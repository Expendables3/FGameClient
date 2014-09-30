package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author hiepnm2
	 */
	public class SendEventService extends BasePacket 
	{
		public var UserId:int;
		public var Times:int;
		public function SendEventService() 
		{
			ID = Constant.CMD_RECEIVE_GIFT_ON_FRIEND;
			URL = "EventService.receiveGift";
		}
	}

}