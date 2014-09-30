package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendBuyFairyDrop extends BasePacket 
	{
		public var ItemType:String;
		public var ItemId:int;
		public function SendBuyFairyDrop(itemType:String,itemId:int) 
		{
			ID = Constant.CMD_BUY_FAIRY_DROP;
			URL = "CommonService.exchangeMagicBag";
			ItemType = itemType;
			ItemId = itemId;
		}
	}

}