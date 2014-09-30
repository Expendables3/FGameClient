package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendUpdateSparta extends BasePacket
	{
		public var ownerId:int;
		public function SendUpdateSparta(OwnerID:int) 
		{
			ID = Constant.CMD_UPDATE_SPARTA;
			URL = "ItemService.updateExpired";
			ownerId = OwnerID;
		}
		
	}

}