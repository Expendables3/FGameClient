package GUI.BossServer 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendAttackBossServer extends BasePacket 
	{
		
		public function SendAttackBossServer() 
		{
			IsQueue = false;
			ID = Constant.CMD_SEND_ATTACK_BOSS_SERVER;
			URL = "ServerBossService.attackBoss";
		}
		
	}

}