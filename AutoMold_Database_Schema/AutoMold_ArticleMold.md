# 📑 AutoMold_ArticleMold — 型體模具 Size 欠數表

## 定義說明
「型體模具 Size 欠數」指某型體（Style）在特定 Size 上的模具需求量，與目前可用模具數量（MoldInventory）之間的差額。  
換句話說，就是「該工單或型體在某個 Size 上，還缺少多少副模具才能滿足生產需求」。

---

## 欄位定義
| 欄位分類     | 欄位名稱             | 欄位英文名 / 資料欄位         | 型別           | 欄位定義說明                           | 欄位邏輯說明                         |
| ------------ | -------------------- | ----------------------------- | -------------- | -------------------------------------- | ------------------------------------ |
| **基本識別** | 工廠代號             | FacilityId                    | bigint         | 工廠識別碼                              |                                      |
|              | 工單生產日           | ProduceDate                   | nvarchar(8)    | 預設工單排產日期                        |                                      |
|              | 生產班別             | ShiftDefinitionShift          | nvarchar(256)  | 預設工單排產班別                        |                                      |
|              | 排模序               | SortMold                      | int            | 系統預設排模順序                        |                                      |
|              | 工單序集合           | SortOrderList                 | nvarchar(256)  | 同一排模序的工單集合                    |                                      |
| **訂單資訊** | 型體代碼             | ZZSTYLCODE                    | nvarchar(50)   | 工單型體代碼                            |                                      |
|              | 性別                 | ZZGENDER                      | nvarchar(10)   | 工單定義性別                            |                                      |
|              | 工單部位             | ZZPARTNO                      | nvarchar(20)   | 工單對應部位                            |                                      |
|              | 型體顏色             | ZZATCOLR                      | nvarchar(50)   | 工單型體顏色                            |                                      |
|              | 部位顏色代碼         | ZZCOLORCODE                   | nvarchar(50)   | 工單部位顏色代碼                        |                                      |
|              | 模具 Size            | ProductSize                   | nvarchar(20)   | 使用模具的 Size                         |                                      |
| **模具資訊** | 底模代號             | MoldNo                        | nvarchar(100)  | 工單對應模具代號                        |                                      |
|              | 模具庫存數           | MoldInventory                 | int            | 符合條件的模具總數                      |                                      |
| **生產推論** | 型體模具 Size 欠數   | SumBodySizeNeed               | int            | 需求模具數 − 模具庫存數                 | 欠數 = 工單需求上模數 − 模具庫存數   |
|              | 需求上模塊數（班）   | SumRequiredUpperMoldQuantity  | int            | 工單所需掛模數                          | 系統依需求推算                        |
|              | 建議上模塊數         | SteerRequiredUpperMoldQuantity| int            | 系統建議可掛模數                        | 若需求 > 庫存 → =庫存；否則 =需求     |
|              | 實際排班上模數       | ActualRequiredUpperMoldQuantity| int           | 實際掛模數                              | 實際執行值                            |

---

## 🔍 Sample 預覽（僅格式/分佈參考，非正式來源）
取自 `AutoMold_Sample_Data/AutoMold_ArticleMold.sample.csv` 前 5 筆資料：

| FacilityId        | ProduceDate | ShiftDefinitionShift | SortMold | SortOrderList | ZZSTYLCODE | ZZGENDER | ZZPARTNO | ZZATCOLR                         | ZZCOLORCODE       | ProductSize | MoldNo | MoldInventory | SumBodySizeNeed | SumRequiredUpperMoldQuantity | SteerRequiredUpperMoldQuantity | ActualRequiredUpperMoldQuantity |
|-------------------|-------------|----------------------|----------|---------------|------------|----------|----------|---------------------------------|------------------|-------------|--------|---------------|-----------------|------------------------------|--------------------------------|--------------------------------|
| 2210030000000000001 | 20250602    | 6330_VNbc_3rdShift   | 1        | 1             | N          | M        | H0001    | 50%WARM VANILLA S25             | 50%AFDM          | UK_8        | 18336  | 4             | 0               | 0                            | 0                              | 0                              |
| 2210030000000000001 | 20250602    | 6330_VNbc_3rdShift   | 2        | 2             | N          | M        | H0001    | CARBON S18/25%CARBON S18        | AAGG/25%AAGG     | UK_10       | 64986  | 4             | 0               | 0                            | 0                              | 0                              |
| 2210030000000000001 | 20250602    | 6330_VNbc_3rdShift   | 3        | 3             | N          | W        | H0001    | LUCID LEMON F23/75%LUCID LEMON F23 | AEWQ/75%AEWQ  | UK_8-       | 64986  | 2             | 0               | 1                            | 1                              | 1                              |
| 2210030000000000001 | 20250602    | 6330_VNbc_3rdShift   | 4        | 4             | N          | W        | H0001    | 80%GUM 2                        | 80%18F0          | UK_3-       | 05344  | 1             | 0               | 0                            | 0                              | 0                              |
| 2210030000000000001 | 20250602    | 6330_VNbc_3rdShift   | 5        | 5             | N          | M        | H0001    | FTWR WHITE                      | 01F7             | UK_6        | 64699  | 2             | 0               | 0                            | 0                              | 0                              |

> 更多樣本（如需要）：`AutoMold_Sample_Data/AutoMold_ArticleMold.sample.csv`
---

## 🧪 推薦查詢（Open WebUI 工具：AutoMold_DB）
**用途：查詢某班別需要排模的型體**
```sql
SELECT MoldNo, ProductSize, SumBodySizeNeed, ActualRequiredUpperMoldQuantity
FROM AutoMold_ArticleMold
WHERE FacilityId = @FacilityId
  AND ProduceDate = @ProduceDate
  AND ShiftDefinitionShift = @ShiftDefinitionShift
  AND SumBodySizeNeed > 0
ORDER BY SortMold ASC;
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
- `ProduceDate` : nvarchar(8)
- `ShiftDefinitionShift` : nvarchar(256)
- `ProductSize` : nvarchar(20)
- `MoldNo` : nvarchar(100)

### AI 回覆要求
- 先輸出「欄位覆蓋檢查＋型別轉換報告」，再執行後續 Thread 規則與排模。
- 驗證失敗時僅輸出報告，不可進入排模流程。
