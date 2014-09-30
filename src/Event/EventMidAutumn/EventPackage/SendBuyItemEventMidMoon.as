package Event.EventMidAutumn.EventPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendBuyItemEventMidMoon extends BasePacket 
	{
		public var ItemType:String;
		public var ItemId:int;
		public var Num:int;
		public var PriceType:String;
		
		public function SendBuyItemEventMidMoon(itemType:String, itemId:int, num:int, priceType:String) 
		{
			ID = Constant.CMD_BUY_ITEM_EVENT_MIDAUTUMN;
			URL = "EventService.moon_buyMidMoonItem";
			
			ItemType = itemType;
			ItemId = itemId;
			Num = num;
			PriceType = priceType;
			
			IsQueue = false;
		}
		
	}

}