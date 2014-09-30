package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * gói tin mở lì xì
	 * @author HiepNM2
	 */
	public class SendOpenLixi extends BasePacket 
	{
		public var ItemType:String;
		public var ItemId:int;
		public function SendOpenLixi(itemType:String, itemId:int) 
		{
			ID = Constant.CMD_OPEN_LIXI;
			URL = "StoreService.openLixi";
			ItemType = itemType;
			ItemId = itemId;
		}
		
	}

}