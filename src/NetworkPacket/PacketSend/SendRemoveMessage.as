package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author Hien
	 */
	public class SendRemoveMessage extends BasePacket
	{
		public var MessageId : int;
		public var MessageType: int;
		public function SendRemoveMessage(type: int, Letter: int) 
		{
			ID = Constant.CMD_REMOVE_MESSAGE;
			URL = "MessageService.removeMessage";
			MessageType = type;
			MessageId = Letter;
		}
	}
}