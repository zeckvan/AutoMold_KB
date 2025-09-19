本 Thread 遵循《Threads_Common_Execution_Rules.md》之通用條款；下列僅列本 Thread 的差異規則。

# 📑 Thread4_共號規則（GongHao Rules for Thread4）

> **適用範圍**：僅 Thread4。  
> **目的**：在 Thread4 情境下，「同一 `ProductId` + 同一 `MoldPcsSeq`」可視作 **共號** 允許再次分派，但需符合以下限制，避免不當重複。

## 共號允許的前提（全部需成立）
1. `ThreadNo = 4`
2. `FacilityId, ShiftDate, ShiftName, ResourceId` 相同（同班別/機台/廠別範圍內處理共號）
3. `ProductId` 相同 **且** `MoldPcsSeq` 相同（同模穴共號）
4. **必須分派到不同工單序（AufnrSeq）** 或不同工單號（AUFNR）（避免同工單被重複計數）
5. 分派量不得使 `AutoMold_WorkMold.UnmoldedQuantity` 變成負值（需逐筆檢核）

## Pre-Insert 檢核 SQL（Thread4）
```sql
IF @ThreadNo = 4
BEGIN
  -- 允許相同 ProductId + 相同 MoldPcsSeq 的再次分派（共號），但必須配合不同 AufnrSeq
  IF EXISTS (
    SELECT 1
    FROM AutoMold_Temp t
    WHERE t.FacilityId  = @FacilityId
      AND t.ShiftDate   = @ShiftDate
      AND t.ShiftName   = @ShiftName
      AND t.ResourceId  = @ResourceId
      AND t.ProductId   = @ProductId
      AND t.MoldPcsSeq  = @MoldPcsSeq
      AND t.AufnrSeq    = @AufnrSeq   -- 同一工單序不允許重複共號寫入
      AND t.ThreadNo    = 4
  )
  BEGIN
    -- 同一 AufnrSeq 已分派過，改選下一個 AufnrSeq
    GOTO NEXT_ORDERSEQ;
  END

  -- 仍需檢核剩餘未排模數
  IF NOT EXISTS (
    SELECT 1
    FROM AutoMold_WorkMold w
    WHERE w.AufnrSeq = @AufnrSeq
      AND w.UnmoldedQuantity >= @ShiftWorkQty
  )
  BEGIN
    -- 目標工單序無足夠可排產數量
    GOTO NEXT_ORDERSEQ;
  END
END
```


## 差異化規則
- 是否允許共模：
- 特殊候選條件：
- 其他補充：
