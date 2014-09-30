package NetworkPacket.PacketSend.BlackMarket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Gói tin xác nhận vật phẩm mua
	 * @author dongtq
	 */
	public class SendBuyConfirm extends BasePacket 
	{
		public var PageType:String;
		public var PageId:int;
		public var Position:int;
		public var AutoId:int;
		
		//dung update ngu thach
		public var ItemId:int;
		public var Num:int;
		
		public function SendBuyConfirm(_pageType:String, _pageId:int, _position:int, _autoId:int) 
		{
			PageType = _pageType;
			PageId = _pageId;
			Position = _position;
			AutoId = _autoId;
			IsQueue = false;
			
			ID = Constant.CMD_BUY_CONFIRM;
			URL = "MarketService.getObject";
		}
		
	}

}