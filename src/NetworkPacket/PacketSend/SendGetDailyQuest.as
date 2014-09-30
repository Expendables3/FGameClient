package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendGetDailyQuest extends BasePacket
	{		
		public var IsView:Boolean = false;
		
		public function SendGetDailyQuest(View:Boolean = false) 
		{
			ID = Constant.CMD_GET_DAILY_QUEST;
			URL = "QuestService.getDailyQuest";
			IsView = View;
			IsQueue = false;
		}
	}
}