package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendGetDailyBonus extends BasePacket
	{
		public var Day:int;
		public function SendGetDailyBonus(day:int) 
		{
			Day = day;
			ID = Constant.CMD_GET_DAILY_BONUS;
			URL = "MiniGameService.getGiftDay";
			IsQueue = false;
		}
		
	}

}