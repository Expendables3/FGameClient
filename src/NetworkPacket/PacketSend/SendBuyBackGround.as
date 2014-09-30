package NetworkPacket.PacketSend 
{
	import Data.ConfigJSON;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendBuyBackGround extends BasePacket 
	{
		public var DecoList:Object;
		
		public function SendBuyBackGround() 
		{
			ID = Constant.CMD_BUY_BACKGROUND;
			URL = "ItemService.buyBackGround";
		}
		
		
		public function AddNew(ID:int, itemID:int, itemType:String, priceType:String):void
		{
			DecoList = new Object();
			DecoList[ConfigJSON.KEY_ID] = ID;
			DecoList["ItemId"] = itemID;
			DecoList["ItemType"] = itemType;		
			
			if (priceType == "Money")
			{
				DecoList["PriceType"] = "Money";
			}
			else
			{
				DecoList["PriceType"] = "ZMoney";
			}
		}
	}

}