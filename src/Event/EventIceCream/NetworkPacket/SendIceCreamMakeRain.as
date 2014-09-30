package Event.EventIceCream.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendIceCreamMakeRain extends BasePacket 
	{
		public function SendIceCreamMakeRain() 
		{
			ID = Constant.CMD_ICE_CREAM_MAKE_RAIN;
			URL = "EventService.iceCream_MakeRain";
			IsQueue = false;
		}
		
	}

}