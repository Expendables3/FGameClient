package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendGetGiftEventSoldier extends BasePacket 
	{
		
		public var GiftId:int;
		
		public function SendGetGiftEventSoldier(GId:int) 
		{
			ID = Constant.CMD_SEND_GET_GIFT_EVENT_SOLDIER;
			URL = "EventService.receiveGift";
			GiftId = GId;
			IsQueue = false;
		}
	}

}