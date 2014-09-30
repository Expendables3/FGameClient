package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author longpt
	 */
	public class SendExchangeStar extends BasePacket 
	{
		public var Element:int;		// 1 - 4
		public var GiftId:int;		// 1 - 5
		
		public function SendExchangeStar() 
		{
			ID = Constant.CMD_EXCHANGE_STAR;
			URL = "EventService.exchangeStar";
			IsQueue = false;
		}
		
	}

}