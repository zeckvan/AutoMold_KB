# 📑 AutoMold_His — 歷史排模資訊表

## 定義說明
歷史排模資訊指系統過去實際執行過的 **模具排程與使用紀錄**，包含模具在各班別、產線、鞋型、尺寸、顏色與訂單需求下的分配與使用情況。  
這些資訊是後續進行 **模具資源優化**、**產能預測**、**模具壽命管理** 以及 **AI 智慧調度** 的重要依據。

---

## 主要內容範疇

1.排模結果紀錄

- 每一班次實際掛模的清單(模具編號、鞋型、尺寸、機台孔數)。

- 模具配置數量。

2.模具使用狀況

- 模具實際產出數量(雙數、報廢數)。

- 模具使用時數與迴轉數(cycle)。

- 模具維護或異常紀錄。

3.產線與訂單對應

- 模具與產線、訂單(PO)、鞋款的對應關係。

- 該模具曾被分配到哪些工單或型體。

4.歷史決策依據

- 當時排模的優先順序(依訂單急迫度、模具數量、產線狀況)。

- 是否存在模具短缺、臨時調度或替代模的情況

---

## 應用價值

- 產能分析:檢視模具實際產能與理論產能的差異。

- 壽命管理:依歷史使用次數、迴轉數,預測模具維護或報廢時點。

- 最佳化排產:提供 AI 或規則引擎作為下一次排模的學習樣本。

- 決策追溯:了解過去的排模邏輯與實際落差,方便改善。

---

## 欄位定義
| 欄位分類      | 欄位名稱       | 欄位英文名 / 資料欄位 | 型別         | 說明           |
| ------------- | -------------- | --------------------- | ------------ | -------------- |
| **基本識別**  | 工廠代號       | FacilityId            | bigint       | 工廠代號        |
|               | 建立時間       | HisCreateOn           | datetime     | 製令單歷程建立時間 |
|               | 機台孔位代號   | ResourceId            | bigint       | 機台孔位識別碼   |
| **模具資訊**  | 底模代號       | MoldNo                | nvarchar(100)| 工單對應模具代號 |
|               | 生產模具代碼   | ProductId             | bigint       | 生產模具識別碼   |
|               | 模穴代碼       | MoldPcsSeq            | nvarchar(20) | 生產模具模穴代碼 |
|               | 模穴數         | MoldPcsQty            | int          | 模穴數（每模幾雙） |
| **訂單資訊**  | 型體代碼       | ZZSTYLCODE            | nvarchar(50) | 工單型體代碼     |
|               | 性別           | ZZGENDER              | nvarchar(10) | 工單性別        |
|               | 部位           | COMPONENT              | nvarchar(20) | 工單部位        |
|               | 型體顏色       | ZZATCOLR              | nvarchar(50) | 工單型體顏色     |
|               | 部位顏色代碼   | ZZCOLORCODE           | nvarchar(50) | 工單部位顏色代碼 |
|               | 模具 Size      | ProductSize           | nvarchar(20) | 模具對應 Size    |

---

## 🔍 Sample 預覽（僅格式/分佈參考，非正式來源）
取自 `AutoMold_His.sample.csv` 前 5 筆資料：

| FacilityId        | HisCreateOn        | ResourceId        | MoldNo | ProductId        | MoldPcsSeq | MoldPcsQty | ZZSTYLCODE | ZZGENDER | COMPONENT | ZZATCOLR             | ZZCOLORCODE | ProductSize |
|-------------------|-------------------|-------------------|--------|-----------------|------------|------------|------------|----------|----------|----------------------|-------------|-------------|
| 2210030000000000001 | 2024-12-11 06:09:01 | 2210030000000000307 | 18336  | 2412120000000004864 | 1          | 1          | N          | M        | H0001    | 50%WARM VANILLA S25 | 50%AFDM     | UK_8        |
| 2210030000000000001 | 2024-12-11 06:09:01 | 2210030000000000323 | 18336  | 2412120000000004968 | 1          | 1          | N          | M        | H0001    | 50%WARM VANILLA S25 | 50%AFDM     | UK_8        |
| 2210030000000000001 | 2024-12-11 06:09:01 | 2210030000000001520 | 18336  | 2412120000000004968 | 1          | 1          | N          | W        | H0001    | 50%WARM VANILLA S25 | 50%AFDM     | UK_8        |
| 2210030000000000001 | 2024-12-11 06:09:01 | 2210030000000000307 | 18336  | 2412120000000004864 | 1          | 1          | N          | M        | H0001    | 50%WARM VANILLA S25 | 50%AFDM     | UK_8        |
| 2210030000000000001 | 2024-12-11 06:09:01 | 2210030000000000307 | 18336  | 2412120000000004864 | 1          | 1          | N          | M        | H0001    | 50%WARM VANILLA S25 | 50%AFDM     | UK_8        |

> 更多樣本（如需要）：`AutoMold_Sample_Data/AutoMold_His.sample.csv`
---

## 🧪 推薦查詢（Open WebUI 工具：AutoMold_DB）
**用途：查詢歷史排模資訊**
```sql
SELECT TOP 10 FacilityId, HisCreateOn, ResourceId, MoldNo, ProductId, ZZSTYLCODE, ProductSize
FROM AutoMold_His
WHERE FacilityId = @FacilityId
ORDER BY HisCreateOn DESC;
```

---

## 📣 資料來源優先序
1) 若使用者提供檔案（CSV/Excel/JSON）或要求使用 **AutoMold_DB** 工具查詢 → 一律以即時資料為準。  
2) 若未提供即時資料 → 才可參考本檔「Sample 預覽」作為欄位與格式理解，**不可**當作真實數據。  
3) 回覆時需註明本次使用的資料來源（DB / 檔案 / Sample）。

---

## 📌 檔案驗證與型別轉換規則（共用）
本表上傳檔案時，必須遵循共用規則文件：
[AutoMold_FileValidation_Rules.md](./AutoMold_FileValidation_Rules.md)

### 本表必填欄位（摘要）
以下欄位為執行本表邏輯的最小必要集合（其他欄位依 Schema 定義）：
- `FacilityId` : bigint
- `ResourceId` : bigint
- `MoldNo` : nvarchar(100)
- `ProductId` : bigint
- `MoldPcsSeq` : nvarchar(20)
- `ProductSize` : nvarchar(20)

### AI 回覆要求
- 先輸出「欄位覆蓋檢查＋型別轉換報告」，再執行後續 Thread 規則與排模。
- 驗證失敗時僅輸出報告，不可進入排模流程。
