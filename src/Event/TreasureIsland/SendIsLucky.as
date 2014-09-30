package Event.TreasureIsland 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class SendIsLucky extends BasePacket 
	{
		public var H:int;
		public var C:int;
		public function SendIsLucky(row:int, col:int) 
		{
			ID = Constant.CMD_SEND_IS_LUCKY;
			URL = "EventService.is_GoodAndBad";
			H = row;
			C = col;
			IsQueue = false;
		}
		
	}

}