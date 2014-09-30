package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendGetBonusSoldier extends BasePacket 
	{
		public var FishId:int;
		public var LakeId:int;
		public function SendGetBonusSoldier(fId:int, lId:int) 
		{
			ID = Constant.CMD_GET_BONUS_SOLDIER;
			URL = "FishService.getBonusSoldier";
			FishId = fId;
			LakeId = lId;
			IsQueue = false;
		}
		
	}

}