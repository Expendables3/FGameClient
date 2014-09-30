package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class completeDailyQuestNew extends BasePacket
	{
		public var QuestId:int;
		
		public function completeDailyQuestNew(questId:int) 
		{
			ID = Constant.CMD_COMPLETE_DAILY_QUEST_NEW;
			URL = "QuestService.completeDailyQuestNew";
			QuestId = questId;
		}
		
	}

}