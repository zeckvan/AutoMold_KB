
# 🧾 輸出契約：ScheduleRow JSON Schema

**目的**  
統一 AI 的輸出格式，確保結果可驗證、可追溯，並可直接轉換寫入 `AutoMold_Temp`。

---

## A) 必填欄位
- **ShiftDate**：日期 (YYYY-MM-DD)  
- **ShiftName**：班別名稱 (字串)  
- **FacilityId**：工廠代號 (整數)  
- **ResourceId**：機台孔位代號 (整數)  
- **ProductId**：產品/型體代號 (整數)  
- **MoldNo**：模具編號 (字串)  
- **MoldPcsSeq**：模穴代碼 (字串)  
- **ShiftWorkQty**：本班需生產的對數 (整數 ≥0)  
- **AppliedRules**：套用規則清單 (字串陣列)  
- **DecisionPath**：決策路徑 (字串陣列)  
- **Confidence**：信心分數 (0~1)

---

## B) JSON Schema 定義（縮編版）
```json
{
  "title": "ScheduleRow",
  "type": "object",
  "required": [
    "ShiftDate","ShiftName","FacilityId","ResourceId",
    "ProductId","MoldNo","MoldPcsSeq","ShiftWorkQty",
    "AppliedRules","DecisionPath","Confidence"
  ],
  "properties": {
    "ShiftDate": {"type":"string","format":"date"},
    "ShiftName": {"type":"string"},
    "FacilityId": {"type":"integer"},
    "ResourceId": {"type":"integer"},
    "ProductId": {"type":"integer"},
    "MoldNo": {"type":"string"},
    "MoldPcsSeq": {"type":"string"},
    "ShiftWorkQty": {"type":"integer","minimum":0},
    "AppliedRules": {"type":"array","items":{"type":"string"}},
    "DecisionPath": {"type":"array","items":{"type":"string"}},
    "Confidence": {"type":"number","minimum":0,"maximum":1}
  }
}
```

---

## C) 範例
```json
{
  "ShiftDate": "2025-06-02",
  "ShiftName": "6330_VNbc_1stShift",
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

---

## D) 注意事項
1. **AppliedRules** → 對應到 AutoMold_Main.md 的 Thread 條件節點，例如：  
   - `Thread1.exact-match`  
   - `Thread2.closest-size`  
   - `Thread3.history-assign`  
   - `Thread4.capacity-check`  
   - `Thread5.rush-priority`  

2. **DecisionPath** → 應記錄實際的決策過程（逐步清單），方便回溯。  

3. **Confidence** → AI 判斷的信心度（0~1），建議 ≥0.8 才能落地。  

4. 其餘如 `MaintainHour`, `MoldChange`, `MoldworkY/N` 為 **衍生值**，不在 Schema 中，由 SQL / 政策表計算。
