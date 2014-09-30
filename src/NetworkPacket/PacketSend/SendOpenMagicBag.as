package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendOpenMagicBag extends BasePacket 
	{
		public var ItemType:int;
		public function SendOpenMagicBag(itemType:int) 
		{
			ID = Constant.CMD_OPEN_MAGIC_BAG;
			URL = "CommonService.openMagicBag";
			ItemType = itemType;
			//IsQueue = false;
		}
		
	}

}