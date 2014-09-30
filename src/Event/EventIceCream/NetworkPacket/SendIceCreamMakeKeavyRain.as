package Event.EventIceCream.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendIceCreamMakeKeavyRain extends BasePacket 
	{
		
		public function SendIceCreamMakeKeavyRain() 
		{
			URL = "EventService.iceCream_HeavyRain";
			ID = Constant.CMD_ICE_CREAM_MAKE_HEAVY_RAIN;
			IsQueue = false;
		}
		
	}

}