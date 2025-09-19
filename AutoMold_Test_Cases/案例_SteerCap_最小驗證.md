# 測試案例：Steer Cap 最小驗證

## 情境
- CapKey 的 SteerRequiredUpperMoldQuantity = 2  
- 候選 = 4 筆

## 期望結果
- 最多輸出 2 筆 `IsNewUpperMold=1`  
- 第 3、4 筆丟棄或在 Pre-Export Audit 被刪除  
- ValidationReport.json 顯示修正動作或 ok: true
