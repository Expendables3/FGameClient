package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuan
	 */
	public class SendLoadInventory extends BasePacket
	{
		
		public function SendLoadInventory() 
		{
			ID = Constant.CMD_LOAD_INVENTORY;
			URL = "StoreService.loadInventory";
			IsQueue = false;
		}
		
	}

}