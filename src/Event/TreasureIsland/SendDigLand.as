package Event.TreasureIsland 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class SendDigLand extends BasePacket 
	{
		public var H:int;
		public var C:int;
		public function SendDigLand(row:int, col:int) 
		{
			ID = Constant.CMD_SEND_DIG_LAND;
			URL = "EventService.is_Dig";
			H = row;
			C = col;
			IsQueue = false;
		}
		
	}

}