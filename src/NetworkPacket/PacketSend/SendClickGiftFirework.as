package NetworkPacket.PacketSend 
{
	import flash.geom.Point;
	import Logic.EventNationalCelebration.FireworkFish;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendClickGiftFirework extends BasePacket 
	{
		public var FishId:int;
		public var FishType:String;
		public var LakeId:int;
		
		public function SendClickGiftFirework(fishId:int, lakeId:int) 
		{
			ID = Constant.CMD_SEND_CLICK_GIFT_FIREWORK;
			URL = "FishService.getSpartaGift";
			FishType = "Santa";
			FishId = fishId;
			LakeId = lakeId;
			IsQueue = false;
		}
	}

}