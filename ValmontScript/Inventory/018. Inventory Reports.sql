

alter proc spGetBuyerWiseInventory
as
begin
	Select B.BuyerName,II.ItemName,U.UnitType,SUM(ItemBalance-AdjustedBalance) as 'ItemBalance'
	from tblWarehouseItems WI INNER JOIN tblInventoryItems I ON WI.ItemID=I.ItemID
	INNER JOIN tblInventoryItems II ON I.ParentItemID=II.ItemID
	INNER JOIN tblUnitType U ON I.UnitTypeID = U.UnitTypeID
	INNER JOIN tblBuyer B ON I.BuyerID=B.BuyerID
	group by B.BuyerName,II.ItemName,U.UnitType
end