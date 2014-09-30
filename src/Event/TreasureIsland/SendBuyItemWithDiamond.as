package Event.TreasureIsland 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class SendBuyItemWithDiamond extends BasePacket 
	{
		public var Item:Object;
		public function SendBuyItemWithDiamond(item:Object) 
		{
			URL = "EventService.buyItemWithDiamond";
			ID = Constant.CMD_BUY_ITEM_WITH_DIAMOND;
			Item = item;
			IsQueue = false;
		}
		
	}

}