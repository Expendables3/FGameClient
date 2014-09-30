package NetworkPacket.PacketSend.BlackMarket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetListItem extends BasePacket 
	{
		public var PageType:String;
		public var PageId:int;
		
		public function SendGetListItem(pageType:String, pageId:int) 
		{
			ID = Constant.CMD_GET_LIST_ITEM;
			URL = "MarketService.getListItem";
			PageType = pageType;
			PageId = pageId;
			IsQueue = false;
		}
		
	}

}