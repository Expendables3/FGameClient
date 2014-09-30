package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendCompleteSeriesQuest extends BasePacket
	{
		public var SeriesQuestId:int;
		public var QuestId:int;
		public var TaskId:int;
		public var Param:Object;
		
		//Nếu là hoàn thành toàn bộ series quest thì chỉ truyền tham số seriesQuestId
		//Nếu là hoàn thành 1 quest trong series quest thì truyền vào 2 tham số là: seriesQuestId, questId
		//Nếu là hoàn thành 1 task trong 1 quest của series quest thì truyền vào cả 3 tham số
		public function SendCompleteSeriesQuest(seriesQuestId:int, questId:int = 0, taskId:int = 0, param:Object = null) 
		{		
			ID = Constant.CMD_COMPLETE_SERIES_QUEST;
			URL = "QuestService.completeQuest";
			SeriesQuestId = seriesQuestId;
			QuestId = questId;
			TaskId = taskId;
			Param = param;
			IsQueue = false;
			
			//if (questId != 0)
			//{
				//QuestId = questId;
			//}
			//
			//if (taskId != 0)
			//{
				//TaskId = taskId;
			//}
		}		
	}

}