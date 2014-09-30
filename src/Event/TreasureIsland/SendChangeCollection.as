package Event.TreasureIsland 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class SendChangeCollection extends BasePacket 
	{
		public var Id:int;
		public function SendChangeCollection(id:int) 
		{
			ID = Constant.CMD_SEND_CHANGE_COLLECT;
			URL = "EventService.is_ChangeCollection";
			Id = id;
			IsQueue = false;
		}
		
	}

}