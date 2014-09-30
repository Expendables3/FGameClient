package NetworkPacket.PacketSend 
{
	import Logic.Fish;
	import NetworkPacket.BasePacket;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendBuyFish extends BasePacket
	{
		public var FishList:Array = new Array;
		public var LakeId:int;
		public var PriceType:String;
		
		public function SendBuyFish(lakeID:int) 
		{
			ID = Constant.CMD_BUY_FISH;
			URL = "FishService.buy";			
			LakeId = lakeID;
			IsMerge = false;
		}
		
		public function AddNew(fish:Fish, priceType:String):void
		{
			var obj:Object = new Object();
			obj[ConfigJSON.KEY_ID] = fish.Id;
			obj["FishType"] = fish.FishTypeId;
			obj[ConfigJSON.KEY_NAME] = fish.Name;
			obj["Sex"] = fish.Sex;
			if (priceType == "Money")
			{
				obj["PriceType"] = "Money";
			}
			else
			{
				obj["PriceType"] = "ZMoney";
			}
			this.PriceType = obj["PriceType"];
			FishList.push(obj);
		}
		
	}

}