package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendResetDailyQuest extends BasePacket
	{
		
		public function SendResetDailyQuest() 
		{
			ID = Constant.CMD_RESET_DAILYQUEST;
			URL = "QuestService.payToResetDailyQuest";
			IsQueue = false;
		}
		
	}

}