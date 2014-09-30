package Event.EventMidAutumn.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendUseFan extends BasePacket 
	{
		public var PosX:int;
		public var PosY:int;
		public var ToY:int;
		public function SendUseFan(high:int, fromX:int, toX:int) 
		{
			URL = "EventService.moon_fanItem";
			ID = Constant.CMD_EVENT_MIDAUTUMN_USE_FAN;
			IsQueue = false;
			
			PosX = high;
			PosY = fromX;
			ToY = toX;
		}
		
	}

}