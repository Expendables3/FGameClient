package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendBuyDecorate extends BasePacket
	{
		//public var DecoList:Array = [];
		public var DecoList:Object;
		public var LakeId:int;
		public var PriceType:String;
		
		public function SendBuyDecorate(lakeID:int) 
		{
			ID = Constant.CMD_BUY_DECORATE;
			URL = "ItemService.buyDeco";
			LakeId = lakeID;
		}
		
		public function AddNew(ID:int, itemID:int, itemType:String, priceType:String, X:int, Y:int):void
		{
			//var obj:Object = new Object();
			//obj[ConfigJSON.KEY_ID] = ID;
			//obj["ItemId"] = itemID;
			//obj["Type"] = itemType;
			//obj["x"] = X;
			//obj["y"] = Y;
			//obj["z"] = 1;
			//
			//if (priceType == "Money")
			//{
				//obj["PriceType"] = "Money";
			//}
			//else
			//{
				//obj["PriceType"] = "ZMoney";
			//}
			
			DecoList = new Object();
			DecoList[ConfigJSON.KEY_ID] = ID;
			DecoList["ItemId"] = itemID;
			DecoList["Type"] = itemType;
			DecoList["x"] = X;
			DecoList["y"] = Y;
			DecoList["z"] = 1;
			
			if (priceType == "Money")
			{
				DecoList["PriceType"] = "Money";
			}
			else
			{
				DecoList["PriceType"] = "ZMoney";
			}
			
			this.PriceType = DecoList["PriceType"];
			//DecoList.push(obj);
		}
	}

}