package Event.EventHalloween.HalloweenPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendExchangeAccumulationPoint extends BasePacket 
	{
		public var Id:int;
		public var Element:int;
		public function SendExchangeAccumulationPoint(idGift:int,element:int = 0) 
		{
			URL = "AccumulationPointService.exchangeAccumulationPoint";
			ID = Constant.CMD_EXCHANGE_ACCUMULATION_POINT;
			Id = idGift;
			Element = element;
			IsQueue = false;
		}
	}

}