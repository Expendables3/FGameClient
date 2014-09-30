package Event.EventMidAutumn.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendRebornLantern extends BasePacket 
	{
		public var PriceType:String;
		public function SendRebornLantern(priceType:String) 
		{
			URL = "EventService.moon_rebornLantern";
			ID = Constant.CMD_REBORN_LANTERN;
			PriceType = priceType;
			IsQueue = false;
		}
		
	}

}