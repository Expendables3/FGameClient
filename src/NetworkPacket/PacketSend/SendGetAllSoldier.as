package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendGetAllSoldier extends BasePacket 
	{
		public var UserId:String;
		
		public function SendGetAllSoldier(uId:String = null) 
		{
			ID = Constant.CMD_GET_ALL_SOLDIER;
			URL = "LakeService.getAllSoldier";
			UserId = uId;
			IsQueue = false;
		}
		
	}

}