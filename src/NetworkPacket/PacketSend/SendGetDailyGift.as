package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendGetDailyGift extends BasePacket 
	{
		
		public function SendGetDailyGift() 
		{
			ID = Constant.CMD_ACCEPT_DAILY_GIFT;
			URL = "MiniGameService.getGiftDay";
			IsQueue = false;
		}
		
	}

}