package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendExchangeGreenSock extends BasePacket 
	{
		public var GiftId:int;
		public var Element:int;
		
		public function SendExchangeGreenSock(giftId:int, element:int) 
		{
			ID = Constant.CMD_SEND_EXHANGE_GREEN_SOCK;
			URL = "EventService.exchangeGreenSock";
			GiftId = giftId;// 1 - 6;
			Element = element;// 1 - 5;
			IsQueue = false;
		}
		
	}

}