package NetworkPacket.PacketSend.Reputation 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendGetGiftReputation extends BasePacket 
	{
		public var QuestId:int;
		
		public function SendGetGiftReputation(questId:int)
		{
			super();
			ID = Constant.CMD_SEND_GET_REPUTATION;
			URL = "UserService.getGiftReputation";
			
			QuestId = questId;
		}
		
	}

}