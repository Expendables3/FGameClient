package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author thint
	 */
	public class SendGetGiftOfFish extends BasePacket
	{
		public var LakeId:int;
		public var FishId:int;
		
		public function SendGetGiftOfFish(fishid: int, lakeid: int )
		{
			ID = Constant.CMD_GET_GIFT_OF_FISH;
			URL = "FishService.getGiftOfFish";
			LakeId = lakeid;
			FishId = fishid;
			//IsQueue = false;
		}
	}
}