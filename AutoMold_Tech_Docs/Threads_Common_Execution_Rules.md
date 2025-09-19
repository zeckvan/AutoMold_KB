# Threads_Common_Execution_Rules.md
> AutoMold 通用執行規則（適用 Thread1～Thread5），以 **DRY** 原則集中維護；各 Thread 僅需補充差異。

## 0. 目的與範圍
- 統一 AI 在 Open WebUI/KB 的執行行為，讓結果與「現場排模系統」一致、可重現、可追溯。
- 本文件為 **共用規則**；各 Thread 檔案只保留「條件與差異」，避免重複敘述。

## 1. 資料驗證與型別轉換（必須遵守）
- 依《AutoMold_FileValidation_Rules.md》與各表 Schema 執行：欄位覆蓋、型別檢查、允許轉換、值域檢核。
- **數值型別強制**：`FacilityId, ResourceId, ProductId` 一律以 **整數（bigint）語義**比較/排序；若來源為 CSV/MD 字串，**先轉型後**才能進入排序。禁止字串排序。

## 2. 候選集定義（通用）
- 僅保留「完全吻合」條件的候選：`FacilityId, ShiftDate, ShiftName` 與該 Thread 所要求的型體/品號/尺寸/模具條件（由各 Thread 規則補充）。
- 若提供黑名單/停機清單 → 先排除並保留原因。

## 3. 排序鍵（決定性，通用）
依下列固定鍵排序；**嚴禁**擅自更動：
1) `ResourceId ASC`  
2) `ProductId ASC`  
3) `MoldPcsSeq ASC`  
4) `MoldPcsQty DESC`  
5) 若仍完全相同，使用 **輸入檔案原始行序** 作為最後 tie‑break（InputRowIndex ASC）。

> 若某 Thread 需要額外鍵，於各 Thread 檔「差異化規則」段落加註。

## 4. 分派流程（逐筆重算，通用）
**一次一筆** 的狀態機流程：
1) `RecomputeCandidates()`：依「候選定義 + 排除規則」重算候選集，並依 §3 排序。  
2) 輸出 `CandidateTop5`（見 §6 格式）。  
3) 取 `Rank=1` 為 `Picked`，輸出 `Reason`（排序鍵/排除條件/共模開關等）。  
4) 將 `Picked` 視為**已寫入** `AutoMold_Temp`（記憶體中），更新狀態。  
5) 若需下一筆 → 回到步驟 1 重新計算。

> 禁止：一次性取前 N 名直接輸出。

## 5. 非共模去重（通用）
- 在 **相同** `(ShiftDate, ShiftName, FacilityId)` 範圍下，`ProductId` **不得重複分派**（視為非共模）。
- 僅在 **顯式啟用共模** 且 **MoldPcsSeq 相同** 的情況下，才允許再次分派。  
- 各 Thread 如有特別的共模/再分派規則，請在差異化段落補充。

## 6. 可觀測性（候選前 N 名與 Trace，通用）
每次分派 **之前** 必須輸出：
```json
{
  "CandidateTop5": [
    {"Rank":1,"ResourceId":...,"ProductId":...,"MoldPcsSeq":"...","MoldPcsQty":...},
    {"Rank":2,...},
    ...
  ],
  "Picked": {"Rank":1,"ResourceId":...,"ProductId":...,"MoldPcsSeq":"..."},
  "Reason": [
    "排序鍵：RID↑, PID↑, Seq↑, PcsQty↓, InputRowIndex",
    "非共模去重：ProductId ... 已/未出現在 Temp",
    "黑名單/停機：已/未排除 ...",
    "型別：RID/PID 已轉為整數排序"
  ]
}
```
> 若使用者提供「人工預期下一筆」，需標示該筆在 `CandidateTop5` 的 Rank；若非 Rank=1，必須說明具體原因。

## 7. 黑名單/停機（通用）
- 若提供停機/維修/不可用清單，於候選階段即排除，並在 `Reason` 註明排除依據。  
- 未提供清單時於 `Reason` 註記「無黑名單資料」。

## 8. 輸出（通用）
- 最終輸出 `AutoMold_Temp` 表格與 JSON；JSON 必須通過 `ScheduleRow_JSON_Schema`，並依 `ScheduleRow_to_AutoMold_Temp_Map` 映射。

---

## 9. Threads 差異化規則匯總（只在此表列差異）
| Thread | 是否允許共模 | 特殊條件/差異 | 備註 |
|---|---|---|---|
| Thread1 | 預設 **不允許**；僅在顯式啟用且 **同穴序** 時可允許 | 以 **前班機台** 為候選來源 | 與人工期望完全一致需逐筆重算 |
| Thread2 | 預設 **不允許**（如需允許請明示） | 依規則文件之條件差異（請補） |  |
| Thread3 | 預設 **不允許**（如需允許請明示） | 依規則文件之條件差異（請補） |  |
| Thread4 | 依文件：**視同共號**情境可再分派 | 需確保 `AufnrSeq` 不重複、`UnmoldedQuantity` ≥ 分派量 |  |
| Thread5 | 預設 **不允許**（如需允許請明示） | 依規則文件之條件差異（請補） |  |

> 請在各 Thread 檔案內的「差異化規則」節補上本表的具體差異；共用部分勿重複。

---

## 10. 引用方式（如何在各文件中使用這份共用規則）
- 在 **SystemPrompt.md** 與每個 **ThreadX.md** 文件中加入：  
  - 「**本 Thread 遵循《Threads_Common_Execution_Rules.md》之通用條款**；下列僅列差異。」  
- 如需從 Open WebUI 讓模型「先讀共用再讀差異」，建議在系統提示詞中明示讀取順序：  
  1) Threads_Common_Execution_Rules.md（先）  
  2) ThreadX.md（後，僅差異）

---

## 11. 偽程式（通用狀態機）
```pseudo
state.temp = TempSeed or []
step = 1

while need_next:
  cands = filter(data.Produce, conds for ThreadX)      // 完全吻合 + 黑名單排除 + 非共模去重
  cands = coerce_types(cands, ints=["FacilityId","ResourceId","ProductId"])
  cands = sort(cands, keys=[RID↑,PID↑,Seq↑,PcsQty↓,InputRowIndex↑])
  emit CandidateTop5(cands[0:5])

  picked = cands.first()
  emit Picked(picked), Reason(...)

  state.temp.append(picked)  // 視為已寫入 AutoMold_Temp
  step += 1
```
