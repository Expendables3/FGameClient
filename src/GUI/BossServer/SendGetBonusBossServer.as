package GUI.BossServer 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetBonusBossServer extends BasePacket 
	{
		
		public function SendGetBonusBossServer() 
		{
			IsQueue = false;
			ID = Constant.CMD_SEND_GET_BONUS_BOSS_SERVER;
			URL = "ServerBossService.getAndSaveBonus";
		}
		
	}

}