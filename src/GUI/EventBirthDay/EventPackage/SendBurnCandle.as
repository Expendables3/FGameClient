package GUI.EventBirthDay.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendBurnCandle extends BasePacket 
	{
		public var CandleId:int;
		public function SendBurnCandle(candleId:int) 
		{
			URL = "EventService.burnCandle";
			ID = Constant.CMD_SEND_BURN_CANDLE;
			CandleId = candleId;
			IsQueue = false;
		}
		
	}

}