package Event.EventIceCream.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendBuyItemByDiamond extends BasePacket 
	{	
		public var Item:Object;
		public function SendBuyItemByDiamond(obj:Object) 
		{
			URL = "EventService.buyItemWithDiamond";
			ID = Constant.CMD_ICE_CREAM_BUY_ITEM_BY_DIAMOND;
			Item = obj;
		}
		
	}

}