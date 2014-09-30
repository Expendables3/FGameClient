package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendBuyOther extends BasePacket
	{
		public var OtherList:Array = [];
		public var PriceType:String;
		
		public function SendBuyOther() 
		{
			ID = Constant.CMD_BUY_OTHER;
			URL = "ItemService.buyOther";
		}
		
		public function AddNew(type:String, id:int, num:int, priceType:String):void
		{
			var obj:Object = new Object();
			obj["Type"] = type;
			obj[ConfigJSON.KEY_ID] = id;
			obj["Num"] = num;
			if (priceType == "Money")
			{
				obj["PriceType"] = "Money";
			}
			else
			{
				obj["PriceType"] = "ZMoney";
			}
			this.PriceType = obj["PriceType"];
			OtherList.push(obj);
			
			if (type == "Samurai" || type == "Resistance" || type == "RecoverHealthSoldier" || type == "Ginseng")
			{
				IsQueue = false;
			}
		}
		
	}

}