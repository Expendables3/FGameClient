package Event.EventHalloween.HalloweenPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendFinishAuto extends BasePacket 
	{
		public var PriceType:String;
		public var TypeAuto:int;
		public function SendFinishAuto(priceType:String, typeAuto:int) 
		{
			URL = "EventService.hal_autoUnlockMap";
			ID = Constant.CMD_FINISH_AUTO_HALLOWEEN;
			PriceType = priceType;
			TypeAuto = typeAuto;
			IsQueue = false;
		}
		
	}

}