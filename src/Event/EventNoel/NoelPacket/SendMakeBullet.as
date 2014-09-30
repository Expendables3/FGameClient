package Event.EventNoel.NoelPacket 
{
	import Event.Factory.FactoryPacket.SendExchangeGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendMakeBullet extends SendExchangeGift 
	{
		
		public function SendMakeBullet(idRow:int, itemType:String, num:int) 
		{
			URL = "EventService.makeBullet";
			ID = Constant.CMD_SEND_MAKE_BULLET;
			ItemId = idRow;
			ItemType = itemType;
			Num = num;
			IsQueue = false;
		}
		
	}

}