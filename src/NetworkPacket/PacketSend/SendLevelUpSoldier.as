package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendLevelUpSoldier extends BasePacket 
	{
		public var FishId:int;
		public var LakeId:int;
		public function SendLevelUpSoldier(fId:int, lId:int) 
		{
			ID = Constant.CMD_LEVEL_UP_SOLDIER;
			URL = "FishService.levelUpSoldier";
			FishId = fId;
			LakeId = lId;
			//IsQueue = false;
		}
		
	}

}