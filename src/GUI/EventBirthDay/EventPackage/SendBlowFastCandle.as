package GUI.EventBirthDay.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendBlowFastCandle extends BasePacket 
	{
		public var CandleId:int;
		public function SendBlowFastCandle(idCandle:int) 
		{
			URL = "EventService.BlowCandle";
			ID = Constant.CMD_BLOW_CANDLE;
			CandleId = idCandle;
		}
		
	}

}