package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendClickMermaid extends BasePacket 
	{
		
		public function SendClickMermaid() 
		{
			ID = Constant.CMD_SEND_CLICK_MERMAID;
			URL = "EventService.click";
			IsQueue = false;
		}		
	}

}