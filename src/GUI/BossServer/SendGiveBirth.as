package GUI.BossServer 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGiveBirth extends BasePacket 
	{
		public var PriceType:String;
		
		public function SendGiveBirth(_priceType:String) 
		{
			URL = "ServerBossService.speedUpTime";
			IsQueue = false;
			PriceType = _priceType;
		}
		
	}

}