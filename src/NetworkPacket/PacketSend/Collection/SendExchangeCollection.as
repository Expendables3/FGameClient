package NetworkPacket.PacketSend.Collection 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendExchangeCollection extends BasePacket 
	{
		public var ItemType:String;
		public var ItemId:int;
		
		public function SendExchangeCollection(_itemType:String, _itemId:int) 
		{
			ID = Constant.CMD_SEND_EXCHANGE_COLLECTION;
			URL = "CommonService.exchangeItemCollection";
			
			ItemType = _itemType;
			ItemId = _itemId;
		}
		
	}

}