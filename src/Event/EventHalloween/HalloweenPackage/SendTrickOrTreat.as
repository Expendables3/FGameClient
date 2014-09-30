package Event.EventHalloween.HalloweenPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendTrickOrTreat extends BasePacket 
	{
		public var Ans:int;
		public var PriceType:String;
		public function SendTrickOrTreat(ans:int, pricetype:String) 
		{
			URL = "EventService.hal_chooseKidding";
			ID = Constant.CMD_CHOOSE_TRICK_OR_TREAT;
			Ans = ans;
			PriceType = pricetype;
			IsQueue = false;
		}
		
	}

}