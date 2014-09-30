package Event.TreasureIsland 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class SendAutoDig extends BasePacket 
	{
		public var Id:int;
		public function SendAutoDig(id:int) 
		{
			ID = Constant.CMD_SEND_AUTO_DIG;
			URL = "EventService.is_AutoDig";
			Id = id;
			IsQueue = false;
		}
		
	}

}