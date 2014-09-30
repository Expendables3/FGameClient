package Event.TreasureIsland 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class SendExitIsland extends BasePacket 
	{
		
		public function SendExitIsland() 
		{
			ID = Constant.CMD_SEND_EXIT_ISLAND;
			URL = "EventService.is_exitIsland";
			IsQueue = false;
		}
		
	}

}