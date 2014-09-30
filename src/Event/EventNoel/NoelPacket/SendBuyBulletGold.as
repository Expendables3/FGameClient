package Event.EventNoel.NoelPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendBuyBulletGold extends BasePacket 
	{
		public var Num:int;
		public function SendBuyBulletGold(num:int) 
		{
			URL = "EventService.buyBulletGold";
			ID = "";
			Num = num;
			IsQueue = false;
		}
		
	}

}