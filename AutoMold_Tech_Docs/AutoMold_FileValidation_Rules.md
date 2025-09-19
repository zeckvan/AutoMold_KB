# 📑 AutoMold File Validation Rules (共用檔)

> 目的：統一規範 **上傳檔案 (CSV/Excel/JSON)** → **欄位驗證** → **型別轉換** → **可執行排模** 的流程。
> 本文件為共用規則，各資料表的個別 Schema 檔請在末節連結本檔並列出「該表的必填欄位與型別摘要」。

---

## 1. 欄位覆蓋檢查（必做）
- 檔案必須完整覆蓋該表 **必填欄位**（見各表 Schema）。
- 若缺失 → 僅輸出「驗證失敗報告」，**禁止**進入排模流程。

## 2. 型別檢查與轉換（必做）
- **整數／長整數**（如 `int`/`bigint`：`FacilityId`, `ResourceId`, `ProductId`, `AufnrSeq`, `GAMNG`, `MoldedQuantity`, `UnmoldedQuantity`, `MoldPcsQty` …）  
  - 應能轉為數字；若不可轉 → 記錄錯誤列，不執行排模。

- **日期／時間**：  
  - `ShiftDate`, `ProduceDate` → 標準格式 `YYYYMMDD`。若為 `YYYY-MM-DD` 可自動轉為 `YYYYMMDD`，並紀錄轉換筆數。  
  - `datetime` 欄位（如 `CreateOn`, `HisCreateOn`, `GSTRP`, `GLTRP`）→ 應能被解析為合法日期時間。

- **文字長度與內容**：  
  - `MoldPcsSeq` 建議正則：`^[0-9A-Za-z_-]{1,20}$`。超長或不符字元規則 → 記錄警告。  
  - `ShiftName` / `ShiftDefinitionShift` → 應符合工廠定義清單（如 Day/Night 或制式代碼）。

## 3. 值域與一致性（建議）
- `FacilityId`、`ResourceId` 應存在於工廠與機台定義清單。  
- `ProductId` 與 `MoldNo` 應與模具主檔能關連。  
- `ProductSize` 需符合型體/模具允許尺寸集合。

## 4. 驗證報告（AI 回覆時必須輸出）
- **缺失欄位**：清單（必填缺少者）  
- **多餘欄位**：清單（可忽略，但建議列出）  
- **型別錯誤筆數**：含前三筆示例（欄位名、原值）  
- **轉換策略與筆數**：例：`ShiftDate "YYYY-MM-DD" → "YYYYMMDD"：23 筆`  
- **是否允許執行排模**：`pass | fail`

## 5. 執行順序（AI 必須遵守）
1) 讀取使用者上傳檔案。  
2) 找到對應的 **表 Schema 檔**（例如 `AutoMold_Database_Schema/AutoMold_Produce.md`）。  
3) 依本共用檔與該表的「必填欄位＋型別摘要」進行驗證與轉換。  
4) **若驗證通過** → 才能執行 Thread 規則與排模；寫入 `AutoMold_Temp` 前必做 Thread-aware 預檢核。  
5) **若驗證失敗** → 只輸出驗證報告，不執行排模。

---

## Steer Cap 稽核
- 分組條件：(FacilityId, ShiftDate, ShiftName, ProductId, ProductSize[, ArticleMoldId])  
- 驗證：`SUM(IsNewUpperMold) ≤ SteerRequiredUpperMoldQuantity`  
- 若違反 → 依排序鍵刪除尾筆：  
  1. ResourceId 升冪  
  2. ProductId 升冪  
  3. MoldPcsSeq 升冪  
  4. MoldPcsQty 降冪  
  5. 原始行序  
- 輸出 `ValidationReport.json`，記錄修正動作。

---

> 註：本共用檔僅定義「通用檢核/轉換」；各表仍須在其 Schema 檔中列出「必填欄位與型別摘要」。

