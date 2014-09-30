package NetworkPacket.PacketSend.BlackMarket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendBuyItem extends BasePacket 
	{
		public var PageType:String;
		public var PageId:int;
		public var Position:int;
		public var AutoId:int;
		
		//dung update ngu thach
		public var ItemId:int;
		public var Num:int;
		
		//dung update Trung Huy Hieu
		public var Id:int;
		public var Level:int;
		public var Type:String;
		
		public function SendBuyItem(_pageType:String, _pageId:int, _position:int, _autoId:int) 
		{
			PageType = _pageType;
			PageId = _pageId;
			Position = _position;
			AutoId = _autoId;
			ID = Constant.CMD_BUY_ITEM;
			URL = "MarketService.buyItem";
			IsQueue = false;
		}
		
	}

}