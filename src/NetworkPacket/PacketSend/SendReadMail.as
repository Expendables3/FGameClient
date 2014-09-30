package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author thint
	 */
	public class SendReadMail extends BasePacket
	{
		public var MessageId : int;
		public function SendReadMail(letterId: int) 
		{
			ID = Constant.CMD_READ_MAIL;
			URL = "MessageService.readMail";
			MessageId = letterId;
		}
		
	}

}