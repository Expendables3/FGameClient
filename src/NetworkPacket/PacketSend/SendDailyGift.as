package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendDailyGift extends BasePacket
	{
		
		public function SendDailyGift() 
		{
			ID = Constant.CMD_GET_DAILY_GIFT;
			URL = "MiniGameService.giftEveryDay";
			IsQueue = false;
		}
		
	}

}