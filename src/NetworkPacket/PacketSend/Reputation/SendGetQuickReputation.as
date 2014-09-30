package NetworkPacket.PacketSend.Reputation 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendGetQuickReputation extends BasePacket 
	{
		public var QuestId:int;
		
		public function SendGetQuickReputation(questId:int) 
		{
			super();
			ID = Constant.CMD_SEND_QUICK_REPUTATION;
			URL = "UserService.doneReputationQuest";
			
			QuestId = questId;
		}
		
	}

}