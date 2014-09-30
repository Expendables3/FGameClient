package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendFeedFish extends BasePacket
	{
		public var UserId:int;
		public var LakeId:int;
		public var TotalAmount:int;
		public var FishList:Array = [];
		
		public function SendFeedFish(LakeId:int, UserId:int, TotalAmount:int)
		{
			ID = Constant.CMD_FEED_FISH;
			URL = "FishService.feed";
			this.LakeId = LakeId;
			this.UserId = UserId;			
			this.TotalAmount = TotalAmount;
		}
		
		public function AddNew(FishId:int, Amount:Number):void
		{
			var obj:Object = new Object();
			obj[ConfigJSON.KEY_ID] = FishId;
			obj["EatAmount"] = Amount;			
			FishList.push(obj);
		}
		
	}

}