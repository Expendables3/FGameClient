package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author Hien
	 */
	public class SendLoadMessageBox extends BasePacket
	{
		public var TypeMessage:int;
		
		public function SendLoadMessageBox(type:int) 
		{
			TypeMessage = type;
			ID = Constant.CMD_LOAD_LETTER;
			URL = "MessageService.loadMessageBox";
			IsQueue = false;
		}
		
	}

}