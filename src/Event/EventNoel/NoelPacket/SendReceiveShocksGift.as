package Event.EventNoel.NoelPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendReceiveShocksGift extends BasePacket 
	{
		public var DayIndex:int;
		public function SendReceiveShocksGift(dayIndex:int) 
		{
			URL = "KeepLoginService.receiveGift";
			ID = Constant.CMD_RECEIVE_SHOCKS_GIFT;
			DayIndex = dayIndex;
			IsQueue = false;
		}
	}

}