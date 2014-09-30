package GUI.BossServer 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetInfoBossServer extends BasePacket 
	{
		
		public function SendGetInfoBossServer() 
		{
			ID = Constant.CMD_SEND_GET_INFO_BOSS_SERVER;
			URL = "ServerBossService.getInfoSeverBoss";
		}
		
	}

}