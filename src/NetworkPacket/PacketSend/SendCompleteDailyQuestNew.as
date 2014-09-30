package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendCompleteDailyQuestNew extends BasePacket
	{
		public function SendCompleteDailyQuestNew() 
		{
			ID = Constant.CMD_COMPLETE_DAILY_QUEST_NEW;
			URL = "QuestService.completeDailyQuest";
			IsQueue = false;
		}
		
	}

}