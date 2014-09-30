package GUI.EventMagicPotions.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Tan cong hoac cham soc boss thao duoc
	 * @author longpt
	 */
	public class AttackHerbBoss extends BasePacket 
	{
		public var isCare:Boolean;
		public function AttackHerbBoss(isC:Boolean) 
		{
			ID = Constant.CMD_SEND_ATTACK_HERB_BOSS;
			URL = "EventService.attackHerbBoss";
			IsQueue = false;
			
			isCare = isC;
		}
		
	}

}