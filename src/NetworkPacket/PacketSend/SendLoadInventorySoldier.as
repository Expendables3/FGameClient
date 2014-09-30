package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author longpt
	 */
	public class SendLoadInventorySoldier extends BasePacket 
	{
		
		public function SendLoadInventorySoldier() 
		{
			ID = Constant.CMD_LOAD_INVENTORY_SOLDIER;
			URL = "StoreService.loadInventory";
			IsQueue = false;
		}
		
	}

}