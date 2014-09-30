package Event.Tet2013.TetPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Gói tin nhận quà trong nhận quà online
	 * @author HiepNM2
	 */
	public class SendReceiveOnlineGift extends BasePacket 
	{
		public var DayIndex:int;
		public function SendReceiveOnlineGift(dayIndex:int) 
		{
			URL = "KeepLoginService.receiveGift";
			ID = Constant.CMD_RECEIVE_ONLINE_GIFT;
			DayIndex = dayIndex;
			IsQueue = false;
		}
		
	}

}