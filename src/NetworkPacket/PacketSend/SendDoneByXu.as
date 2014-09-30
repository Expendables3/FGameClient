package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendDoneByXu extends BasePacket
	{
		public var IdDailyQuest: String; 
		public var IdTask:int; 

		public function SendDoneByXu(qId:int, tId:int) 
		{
			ID = Constant.CMD_DONE_DAILY_QUEST_BY_XU;
			URL = "QuestService.doneByXu";
			IdDailyQuest = "Quest" + String(qId +1);
			IdTask = tId;
		}
		
	}

}