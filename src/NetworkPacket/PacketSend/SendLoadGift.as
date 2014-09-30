package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author thint
	 */
	public class SendLoadGift extends BasePacket
	{
		public function SendLoadGift() 
		{
			ID = Constant.CMD_LOAD_GIFT;
			URL = "MessageService.loadGiftBox";
			IsQueue = false;
		}
	}

}