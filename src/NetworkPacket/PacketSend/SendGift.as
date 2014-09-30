package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author Hien
	 */
	public class SendGift extends BasePacket
	{
		public var ReceiveList: Array = [] ;
		public var GiftId: int;
		public function SendGift(Id: int) 
		{
			ID = Constant.CMD_SEND_GIFT;
			URL = "MessageService.sendGift";
			GiftId =  Id;
			IsQueue = false;
		}
		public function AddReceive(id:int):void
		{
			ReceiveList.push(id);
		}
		
	}

}