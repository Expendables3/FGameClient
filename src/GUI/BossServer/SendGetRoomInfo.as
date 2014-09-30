package GUI.BossServer 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetRoomInfo extends BasePacket 
	{
		
		public function SendGetRoomInfo() 
		{
			ID = Constant.CMD_SEND_GET_ROOM_INFO;
			URL = "ServerBossService.getVitalityAllBoss";
			IsQueue = false;
		}
		
	}

}