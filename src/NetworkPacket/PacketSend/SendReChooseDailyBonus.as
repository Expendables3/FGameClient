package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendReChooseDailyBonus extends BasePacket
	{
		public var Day:int;
		public function SendReChooseDailyBonus(day:int) 
		{
			ID = Constant.CMD_RECHOOSE_DAILY_BONUS;
			Day = day;
			URL = "MiniGameService.chooseAgain";
			IsQueue = false;
		}
		
	}

}