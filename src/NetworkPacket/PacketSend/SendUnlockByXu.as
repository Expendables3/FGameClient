package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendUnlockByXu extends BasePacket
	{
		
		public function SendUnlockByXu() 
		{
			ID = Constant.CMD_UNLOCK_DAILYQUEST;
			URL = "QuestService.unlockByXu";
			IsQueue = false;
		}
		
	}

}