# 📑 AutoMold_Temp — 排模排產結果暫存表

## 定義說明
此表為 **自動排模排產邏輯規則** 的運算結果暫存表，主要用途為：
- 儲存當班次（Shift）與指定日期（ShiftDate）的排模結果。
- 紀錄每台機台（ResourceId）在特定班別所掛載的模具與分配產能。
- 作為後續更新 **正式生產排程表** 的依據。

---

📌 主要內容範疇

1.生產班別資訊:ShiftDate、ShiftName、FacilityId

2.機台工時資訊:ResourceId、MaintainHour、MoldChange、ShiftWork

3.模具資訊:ArticleMoldid、ArticleMoldsize、MoldQty、moldpcsqty、AroudQty

4.排產數據資訊:MoldworkY、MoldworkN、WorkQty、ShiftWorkQty、ArticleQty

5.工單資訊:aufnr、AufnrSeq、WorkSize、WorkQtyYet

6.生產執行資訊:ProductId、MoldPcsSeq、ThreadName、MoldSeq、RescourseMoldSeq

---

📌 應用價值

- 快速模擬:可用於演算不同策略下的排模結果,不影響正式表。

- 生產決策依據:協助生管判斷模具使用效率、機台稼動率。

- 後續追蹤:提供比對依據,檢視計劃與實際落差。

---

## 欄位結構表（摘錄）
| 欄位分類      | 欄位名稱        | 欄位英文名 / 資料欄位 | 型別       | 說明 |
| ------------- | --------------- | --------------------- | ---------- | ---- |
| **基本識別**  | 工廠代號        | FacilityId            | bigint     | 工廠識別碼 |
|               | 排班日          | ShiftDate             | nvarchar(8)| 指定排產日期 |
|               | 班別名稱        | ShiftName             | nvarchar(256)| 指定班別 |
|               | 機台孔位代號    | ResourceId            | bigint     | 機台孔位代號 |
| **機台工時**  | 維保時數        | MaintainHour          | decimal(5,2)| 機台維修耗時 |
|               | 換模時數        | MoldChange            | decimal(5,2)| 換模耗時 |
|               | 當班有效戰力    | ShiftWork             | decimal(5,2)| 可用工時 |
|               | 排模戰力        | MoldworkY             | decimal(5,2)| 已分派工時 |
|               | 剩餘戰力        | MoldworkN             | decimal(5,2)| 剩餘可用工時 |
| **模具資訊**  | 模具代號        | ArticleMoldid         | nvarchar(100)| 底模代號 |
|               | 模具 Size       | ArticleMoldsize       | nvarchar(256)| 模具尺寸 |
|               | 型體代碼        | ArticleCode           | nvarchar(50)| 型體代碼 |
|               | 型體顏色        | ArticleColor          | nvarchar(100)| 型體顏色 |
|               | 部位顏色        | ArticlePartColor      | nvarchar(100)| 部位顏色 |
|               | 模具庫存數      | MoldQty               | int        | 符合條件的模具數量 |
|               | 模具雙數        | moldpcsqty            | decimal(5,2)| 每模幾雙 |
|               | 迴轉數          | AroudQty              | int        | 每日迴轉次數 |
| **排產數據**  | 戰力雙數        | WorkQty               | int        | 排產數量 |
|               | 本班生產數      | ShiftWorkQty          | int        | 本班可完成數 |
|               | 欠數            | ArticleQty            | int        | 型體 Size 欠數 |
| **工單資訊**  | 工單號          | aufnr                 | nvarchar(256)| 工單號 |
|               | 工單序          | AufnrSeq              | int        | 工單序號 |
|               | 未排模排產數    | WorkQtyYet            | int        | 尚未完成數量 |
| **生產執行**  | 生產模具代碼    | ProductId             | bigint     | 生產模具識別碼 |
|               | 模穴代碼        | MoldPcsSeq            | nvarchar(20)| 模穴編碼 |
|               | 執行邏輯名稱    | ThreadName            | nvarchar(256)| 所用邏輯 Thread |
|               | 排模序          | MoldSeq               | int        | 排模順序 |
|               | 上模序          | RescourseMoldSeq      | int        | 上模順序 |

---

## 🔍 Sample 預覽（僅格式/分佈參考，非正式來源）
取自 `AutoMold_Temp.sample.csv` 前 5 筆資料：

| FacilityId        | ShiftDate | ShiftName        | ResourceId        | ArticleGender | ArticlePart | MaintainHour | MoldChange | ShiftWork | MoldworkY | MoldworkN | WorkQty | ShiftWorkQty | ArticleQty | aufnr       | WorkQtyYet | ProductId        | MoldPcsSeq | ThreadName | AufnrSeq | MoldSeq | RescourseMoldSeq |
|-------------------|-----------|------------------|-------------------|---------------|-------------|--------------|------------|-----------|-----------|-----------|--------|--------------|------------|-------------|------------|------------------|------------|------------|----------|--------|------------------|
| 2210030000000000001 | 20250602  | 6330_VNbc_1stShift | 2210030000000001040 | M             | H0001       | 0.0          | 0.00       | 8.00      | 8.00      | 8.00      | 200    | 199          | 199        | 100030850083 | 199.0      | 2412120000000004796 | 1          | L1         | 1        | 1      | 1                |
| 2210030000000000001 | 20250602  | 6330_VNbc_1stShift | 2210030000000000306 | M             | H0001       | 0.0          | 0.00       | 8.00      | 8.00      | 8.00      | 200    | 160          | 160        | 100030850083 | 160.0      | 2412120000000004864 | 1          | L1         | 1        | 1      | 2                |
| 2210030000000000001 | 20250602  | 6330_VNbc_1stShift | 2210030000000000323 | M             | H0001       | 0.0          | 0.00       | 8.00      | 8.00      | 8.00      | 200    | 121          | 121        | 100030850083 | 121.0      | 2412120000000004968 | 1          | L1         | 1        | 1      | 3                |
| 2210030000000000001 | 20250602  | 6330_VNbc_1stShift | 2210030000000000310 | M             | H0001       | 0.0          | 0.33       | 7.67      | 7.67      | 7.67      | 200    | 82           | 82         | 100030850083 | 82.0       | 2412120000000005106 | 1          | L2         | 1        | 1      | 4                |
| 2210030000000000001 | 20250602  | 6330_VNbc_1stShift | 2210030000000000318 | W             | H0001       | 0.0          | 0.33       | 7.67      | 7.67      | 7.67      | 200    | 534          | 534        | 100030539383 | 534.0      | 2412120000000004776 | 1          | L2         | 73       | 71     | 5                |

> 更多樣本（如需要）：`AutoMold_Sample_Data/AutoMold_Temp.sample.csv`
---

## 🧪 推薦查詢（Open WebUI 工具：AutoMold_DB）
**用途：查詢某班別的排模結果暫存**
```sql
SELECT FacilityId, ShiftDate, ShiftName, ResourceId, MoldNo, MoldworkY, MoldworkN, ShiftWorkQty
FROM AutoMold_Temp
WHERE ShiftDate = @ShiftDate AND ShiftName = @ShiftName;
```

---

## 📣 資料來源優先序
1) 若使用者提供檔案（CSV/Excel/JSON）或要求使用 **AutoMold_DB** 工具查詢 → 一律以即時資料為準。  
2) 若未提供即時資料 → 才可參考本檔「Sample 預覽」作為欄位與格式理解，**不可**當作真實數據。  
3) 回覆時需註明本次使用的資料來源（DB / 檔案 / Sample）。
