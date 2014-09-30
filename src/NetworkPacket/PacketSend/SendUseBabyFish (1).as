package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author thint
	 */
	public class SendUseBabyFish extends BasePacket
	{
		public var Id:int;
		public var LakeId:int;
		// param thừa để check quest
		public var TypeFish:int;
		
		public function SendUseBabyFish(lakeID:int, fType:int = -1) 
		{
			ID = Constant.CMD_USE_BABY_FISH;
			URL = "StoreService.useBabyFish";
			LakeId = lakeID;
			TypeFish = fType;
		}
	}

}