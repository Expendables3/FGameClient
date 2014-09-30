package Event.EventMidAutumn.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetEventInfo extends BasePacket 
	{
		
		public function SendGetEventInfo() 
		{
			ID = Constant.CMD_GET_EVENT_INFO;
			URL = "EventService.moon_getInfo";
			IsQueue = false;
		}
		
	}

}