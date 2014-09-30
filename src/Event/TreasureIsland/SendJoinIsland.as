package Event.TreasureIsland 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class SendJoinIsland extends BasePacket 
	{
		public function SendJoinIsland() 
		{
			ID = Constant.CMD_SEND_JOIN_ISLAND;
			URL = "EventService.is_JoinIsland";
			IsQueue = false;
		}
		
	}

}