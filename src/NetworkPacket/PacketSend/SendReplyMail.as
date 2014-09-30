package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author thint
	 */
	public class SendReplyMail extends BasePacket
	{
		public var MessageId : int;
		public function SendReplyMail(letterId: int) 
		{
			ID = Constant.CMD_READ_MAIL;
			URL = "MessageService.readMail";
			MessageId = letterId;
		}
		
	}

}