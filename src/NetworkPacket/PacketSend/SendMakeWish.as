package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendMakeWish extends BasePacket 
	{
		public var GiftId:int;
		
		public function SendMakeWish(_giftId:int) 
		{
			GiftId = _giftId;
			ID = Constant.CMD_SEND_MAKE_WISH;
			URL = "EventService.makeAWish";
			IsQueue = false;
		}
	}

}