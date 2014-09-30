package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendUpdateExpiredEquipment extends BasePacket 
	{
		public var UserId:String = null;
		public function SendUpdateExpiredEquipment(uId:String) 
		{
			UserId = uId;
			ID = Constant.CMD_UPDATE_EXPIRED_EQUIPMENT;
			URL = "ItemService.updateExpiredEquipment";
		}
	}

}