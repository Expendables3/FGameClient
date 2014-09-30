package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author Hien
	 */
	public class SendLetter extends BasePacket
	{
		public var ReceiverId : int;
		public var Content: String;
		public function SendLetter(Receiver: int, content:  String) 
		{
			ID = Constant.CMD_SEND_LETTER;
			URL = "MessageService.sendMessage";
			ReceiverId =  Receiver;
			Content = content;
			IsQueue = false;
		}		
	}
}