package GUI.EventMagicPotions.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Danh lai herbboss them 1 lan nua
	 * @author longpt
	 */
	public class SendRebornHerbBoss extends BasePacket 
	{
		
		public function SendRebornHerbBoss() 
		{
			ID = Constant.CMD_SEND_REBORN_HERB_BOSS;
			URL = "EventService.rebornHerbBoss";
			
			IsQueue = false;
		}
		
	}

}