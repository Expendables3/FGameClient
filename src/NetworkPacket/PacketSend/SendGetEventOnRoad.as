package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendGetEventOnRoad extends BasePacket 
	{
		//public var timeStamp:int;
		public function SendGetEventOnRoad(time_Stamp:int = 0) 
		{
			ID = Constant.CMD_GET_EVENT_ON_ROAD;
			URL = "MoonService.eventOnRoad";
			IsQueue = false;
			timeStamp = time_Stamp;
		}
		
	}
}