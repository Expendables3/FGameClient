package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author thint
	 */
	public class SendAcceptGift extends BasePacket
	{
		public var MessageId : int;
		public function SendAcceptGift(giftId: int) 
		{
			ID = Constant.CMD_ACCEPT_GIFT;
			URL = "MessageService.acceptGift";
			MessageId = giftId;
			IsQueue = false;
		}
		
	}

}