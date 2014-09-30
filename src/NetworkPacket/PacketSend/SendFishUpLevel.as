package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendFishUpLevel extends BasePacket
	{
		public var FishId:int;
		public var LakeId:int;
		
		public function SendFishUpLevel(lakeID:int, fishId:int) 
		{
			ID = Constant.CMD_CREATE_GIFT_FOR_FISH;
			URL = "FishService.createGiftForFish";
			LakeId = lakeID;
			FishId = fishId;
		}
		
	}

}