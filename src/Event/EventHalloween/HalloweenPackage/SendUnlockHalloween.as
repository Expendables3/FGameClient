package Event.EventHalloween.HalloweenPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendUnlockHalloween extends BasePacket 
	{
		public var PriceType:String;
		public function SendUnlockHalloween(priceType:String) 
		{
			URL = "EventService.hal_speedupJoin";
			ID = Constant.CMD_UNLOCK_HALLOWEEN;
			PriceType = priceType;
			IsQueue = false;
		}
		
	}

}