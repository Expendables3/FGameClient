package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendRequestDailyGift extends BasePacket 
	{
		
		public function SendRequestDailyGift() 
		{
			ID = Constant.CMD_REQ_DAILY_GIFT;
			URL = "MiniGameService.loadGiftEveryDay";
			IsQueue = false;
		}
		
	}

}