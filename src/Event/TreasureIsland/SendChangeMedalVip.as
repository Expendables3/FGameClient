package Event.TreasureIsland 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class SendChangeMedalVip extends BasePacket 
	{
		public var Id:int;
		public var Element:int;
		public function SendChangeMedalVip(id:int, element:int = 0) 
		{
			ID = Constant.CMD_SEND_CHANGE_MEDAL;
			URL = "EventService.hal_exchangeMedal";
			IsQueue = false;
			Id = id;
			Element = element;
		}
		
	}

}