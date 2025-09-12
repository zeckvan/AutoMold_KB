# 📑 AutoMold 排模排產結果暫存表

## 基本格式
以下範例依據 `AutoMold_Database_Schema/AutoMold_Temp.md` 欄位結構表（摘錄）設計。

---

## 📋 表格輸出
| FacilityId | ShiftDate | ShiftName | ResourceId | MaintainHour | MoldChange | ShiftWork | MoldworkY | MoldworkN | ArticleMoldid | ArticleMoldsize | WorkQty | ShiftWorkQty | ArticleQty | aufnr | AufnrSeq | WorkQtyYet | ProductId | MoldPcsSeq | ThreadName | MoldSeq | RescourseMoldSeq |
|------------|-----------|-----------|------------|--------------|------------|-----------|-----------|-----------|---------------|-----------------|---------|--------------|------------|-------|----------|------------|-----------|------------|------------|---------|------------------|
| 6330       | 20250912  | Day       | 66331      | 0.0          | 0.5        | 8.0       | 2.0       | 6.0       | M123          | UK_9            | 80      | 71           | 9          | 10001 | 1        | 9          | 2412120001 | 1          | Thread1    | 1       | 1                |

---

## 🗂 JSON 輸出
```json
{
  "FacilityId": 6330,
  "ShiftDate": "2025-09-12",
  "ShiftName": "Day",
  "ResourceId": 66331,
  "MaintainHour": 0.0,
  "MoldChange": 0.5,
  "ShiftWork": 8.0,
  "MoldworkY": 2.0,
  "MoldworkN": 6.0,
  "ArticleMoldid": "M123",
  "ArticleMoldsize": "UK_9",
  "WorkQty": 80,
  "ShiftWorkQty": 71,
  "ArticleQty": 9,
  "aufnr": "10001",
  "AufnrSeq": 1,
  "WorkQtyYet": 9,
  "ProductId": 2412120001,
  "MoldPcsSeq": "1",
  "ThreadName": "Thread1",
  "MoldSeq": 1,
  "RescourseMoldSeq": 1
}
```

---

## 📣 注意事項
- 欄位需完整對應 `AutoMold_Database_Schema/AutoMold_Temp.md` 的欄位結構表  
- JSON 輸出必須與表格輸出一致  
- 若某欄位無值 → 需填入 `null` 或 `0`，不可省略
