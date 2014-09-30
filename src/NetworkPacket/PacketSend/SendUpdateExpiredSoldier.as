package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendUpdateExpiredSoldier extends BasePacket 
	{
		public var UserId:String = null;
		public var FishId:int;
		public var LakeId:int;
		
		public function SendUpdateExpiredSoldier(fId:int, lId:int, uId:String = null) 
		{
			ID = Constant.CMD_UPDATE_EXPIRED_SOLDIER;
			URL = "FishService.updateExpiredSolider";
			FishId = fId;
			LakeId = lId;
			if (uId)
			{
				UserId = uId;
			}
			IsQueue = false;
		}
		
	}

}