package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendRecoverHealthSoldier extends BasePacket 
	{
		public var FishId:int;
		public var LakeId:int;
		public var ItemId:int;
		public function SendRecoverHealthSoldier(fId:int, lId:int, itemId:int) 
		{
			ID = Constant.CMD_RECOVER_HEALTH_SOLDIER;
			URL = "FishService.recoverHealthSoldier";
			FishId = fId;
			LakeId = lId;
			ItemId = itemId;
			IsQueue = false;
		}
	}

}