本 Thread 遵循《Threads_Common_Execution_Rules.md》之通用條款；下列僅列本 Thread 的差異規則。


# 🔗 欄位對應表：ScheduleRow → AutoMold_Temp

**目的**  
統一 AI 輸出 (ScheduleRow JSON) 與 DB 暫存表 (`AutoMold_Temp`) 的欄位對應，避免轉換時出錯。

---

## A) 對應表

| AutoMold_Temp 欄位   | ScheduleRow 欄位 | 備註 |
|----------------------|------------------|------|
| ShiftDate           | ShiftDate        | 格式需統一 `YYYY-MM-DD` |
| ShiftName           | ShiftName        | 直接帶入 |
| FacilityId          | FacilityId       | 直接帶入 |
| ResourceId          | ResourceId       | 直接帶入 |
| ProductId           | ProductId        | 直接帶入 |
| ArticleMoldid       | MoldNo           | 對應模具編號 |
| ArticleMoldsize     | ProductSize (可選) | 若 Schema 未定義，填 null |
| MoldPcsSeq          | MoldPcsSeq       | |
| ShiftWorkQty        | ShiftWorkQty     | 整數 ≥0 |
| ThreadName          | AppliedRules/DecisionPath | 從決策摘要產出，例如 `Thread2` |
| MaintainHour        | （由 SQL/政策計算） | Schema 無此欄位 |
| MoldChange          | （由 SQL/政策計算） | Schema 無此欄位 |
| ShiftWork           | （由 SQL/政策計算） | Schema 無此欄位 |
| MoldworkY           | （由 SQL/政策計算） | Schema 無此欄位 |
| MoldworkN           | （由 SQL/政策計算） | Schema 無此欄位 |
| Aufnr               | （工單資訊帶入）   | Schema 無此欄位 |
| AufnrSeq            | （工單資訊帶入）   | Schema 無此欄位 |
| WorkQtyYet          | （工單資訊帶入）   | Schema 無此欄位 |
| ArticleQty          | （工單資訊帶入）   | Schema 無此欄位 |
| MoldSeq             | （系統內部流水號） | Schema 無此欄位 |
| RescourseMoldSeq    | （系統內部流水號） | Schema 無此欄位 |

---

## B) 注意事項
1. **必填對應**：ScheduleRow 中列出的欄位必須能 100% 映射到 AutoMold_Temp 的核心欄位。  
2. **衍生計算**：如 `MaintainHour`, `MoldChange`, `ShiftWork`, `MoldworkY/N` 等欄位，不由 AI 直接輸出，而是由 SQL 或政策公式計算補齊。  
3. **工單相關欄位**：如 `Aufnr`, `AufnrSeq` 等，需依 AutoMold_WorkMold 進一步填充。  
4. **ThreadName**：可由 AppliedRules/DecisionPath 自動摘要，例如：`Thread1.exact-match` → `Thread1`。  

---

## C) 範例轉換流程

1. AI 輸出 ScheduleRow JSON：  
```json
{
  "ShiftDate": "2025-06-02",
  "ShiftName": "Day",
  "FacilityId": 6330,
  "ResourceId": 66331,
  "ProductId": 2412120001,
  "MoldNo": "M123",
  "MoldPcsSeq": "A01",
  "ShiftWorkQty": 80,
  "AppliedRules": ["Thread1.exact-match"],
  "DecisionPath": ["查前班", "對上 MoldNo+Size", "分派成功"],
  "Confidence": 0.95
}
```

2. 轉換後寫入 AutoMold_Temp：  
| ShiftDate | ShiftName | FacilityId | ResourceId | ProductId | ArticleMoldid | MoldPcsSeq | ShiftWorkQty | ThreadName |
|-----------|-----------|------------|------------|-----------|----------------|------------|--------------|------------|
| 2025-06-02 | Day | 6330 | 66331 | 2412120001 | M123 | A01 | 80 | Thread1 |

其餘欄位 (`MaintainHour`, `MoldChange`, …) 由 SQL 計算補齊。


## 差異化規則
- 是否允許共模：
- 特殊候選條件：
- 其他補充：
