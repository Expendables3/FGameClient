package NetworkPacket.PacketSend.Collection 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendBuyItemCollection extends BasePacket 
	{
		public var ItemId:int;
		public function SendBuyItemCollection(_itemId:int) 
		{
			ItemId = _itemId;
			ID = Constant.CMD_SEND_BUY_ITEM_COLLECTION;
			URL = "CommonService.buyItemCollection";
		}
		
	}

}