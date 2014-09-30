package NetworkPacket.PacketSend 
{
	import flash.display.LineScaleMode;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendCompleteDailyQuest extends BasePacket
	{		
		public var QuestId:int;
		
		public function SendCompleteDailyQuest(questId:int) 
		{
			ID = Constant.CMD_COMPLETE_DAILY_QUEST;
			URL = "QuestService.completeDailyQuest";
			QuestId = questId;
			IsQueue = false;
		}
		
	}

}