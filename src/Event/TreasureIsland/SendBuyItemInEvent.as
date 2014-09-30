package Event.TreasureIsland 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendBuyItemInEvent extends BasePacket 
	{
		public var Item:Object;
		public function SendBuyItemInEvent(item:Object) 
		{
			URL = "EventService.buyItemInEvent";
			ID = Constant.CMD_BUY_ITEM_IN_EVENT;
			Item = item;
			IsQueue = false;
		}
	}

}