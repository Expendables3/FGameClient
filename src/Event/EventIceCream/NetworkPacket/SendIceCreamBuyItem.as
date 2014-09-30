package Event.EventIceCream.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendIceCreamBuyItem extends BasePacket 
	{
		public var Item:Object;
		public function SendIceCreamBuyItem(item:Object) 
		{
			URL = "EventService.buyItemInEvent";
			ID = Constant.CMD_ICE_CREAM_BUY_ITEM;
			Item = item;
		}
	}

}