package Event.EventIceCream.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendIceCreamCreateIceCream extends BasePacket 
	{
		public var SlotId:int;
		public var ItemId:int;
		public function SendIceCreamCreateIceCream(slotId:int, itemId:int) 
		{
			ID = Constant.CMD_ICE_CREAM_CREATE_ICE_CREAM;
			URL = "EventService.iceCream_InsertPattern";
			SlotId = slotId;
			ItemId = itemId;
		}
	}

}