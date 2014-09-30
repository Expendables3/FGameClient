package NetworkPacket.PacketSend 
{
	import Logic.StockThings;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendSellStockThing extends BasePacket
	{
		public var ItemList:Array = [];
			
		public function SendSellStockThing() 
		{
			ID = Constant.CMD_SELL_STOCK_THING;
			URL = "StoreService.sellItem";
		}
		
		public function AddNew(stockThing:StockThings):void
		{
			var obj:Object = new Object();
			obj["ItemId"] = stockThing.Id
			obj["ItemType"] = stockThing.ItemType;
			obj["Num"] = stockThing.Num;
			ItemList.push(obj);
		}
		
	}

}