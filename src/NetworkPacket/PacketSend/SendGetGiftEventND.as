package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetGiftEventND extends BasePacket
	{
		public function SendGetGiftEventND() 
		{
			ID = Constant.CMD_SEND_GET_GIFT_EVENT_ND;
			URL = "EventService.exchangeIcon";
			IsEvent = true;
			IsQueue = false;
		}
		
	}

}