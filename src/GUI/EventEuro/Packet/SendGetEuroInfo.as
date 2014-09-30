package GUI.EventEuro.Packet 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetEuroInfo extends BasePacket 
	{
		
		public function SendGetEuroInfo() 
		{
			ID = Constant.CMD_GET_EURO_INFO;
			URL = "EventService.euro_getInfo";
			IsQueue = false;
		}
		
	}

}