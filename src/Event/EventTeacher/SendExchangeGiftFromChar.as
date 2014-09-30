package Event.EventTeacher 
{
	import Event.Factory.FactoryPacket.SendExchangeGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendExchangeGiftFromChar extends SendExchangeGift 
	{
		public var Ans:int;
		public var IsNormalGift:Boolean = false;
		public function SendExchangeGiftFromChar(idTab:int, itemType:String, num:int) 
		{
			URL = "EventService.colp_chooseGift";
			ID = Constant.CMD_RECEIVE_CHARACTER_GIFT;
			ItemId = idTab;
			ItemType = itemType;
			Num = num;
			IsQueue = false;
		}
		
	}

}