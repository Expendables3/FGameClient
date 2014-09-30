package Event.EventTeacher 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendGiftTarget extends BasePacket 
	{
		public var MileStone:Array;
		public function SendGiftTarget(listPoint:Array) 
		{
			URL = "EventService.colp_exchangePointGift";
			ID = Constant.CMD_EXCHANGE_POINT_GIFT;
			MileStone = listPoint;
			IsQueue = false;
		}
		
	}

}