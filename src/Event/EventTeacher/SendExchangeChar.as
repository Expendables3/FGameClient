package Event.EventTeacher 
{
	import Event.Factory.FactoryPacket.SendExchangeGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendExchangeChar extends SendExchangeGift 
	{
		public function SendExchangeChar(idRow:int, itemType:String, num:int) 
		{
			super();
			ID = Constant.CMD_EXCHANGE_EVENT_CHAR;
			ItemId = idRow;
			ItemType = itemType;
			Num = num;
			IsQueue = false;
		}
		
	}

}