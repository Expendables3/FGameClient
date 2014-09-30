package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author longpt
	 */
	public class SendGetDailyQuestNew extends BasePacket
	{
		public var IsView:Boolean = false;
		
		public function SendGetDailyQuestNew(View:Boolean = false) 
		{
			ID = Constant.CMD_GET_DAILY_QUEST_NEW;
			URL = "QuestService.getDailyQuest";
			IsView = View;
			IsQueue = false;
		}
		
	}

}