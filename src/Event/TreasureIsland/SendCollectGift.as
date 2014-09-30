package Event.TreasureIsland 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class SendCollectGift extends BasePacket 
	{
		public var H:int;
		public var C:int;
		public var type:int;
		public function SendCollectGift(row:int, col:int, t:int = 0) 
		{
			ID = Constant.CMD_SEND_COLLECT_GIFT;
			URL = "EventService.is_CollectGift";
			H = row;
			C = col;
			IsQueue = false;
			type = t;
		}
		
	}

}