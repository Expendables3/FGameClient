package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author thint
	 */
	public class SendLoadMail extends BasePacket
	{
		public function SendLoadMail() 
		{
			ID = Constant.CMD_LOAD_MAIL;
			URL = "MessageService.loadMailBox";
			IsQueue = false;
		}
	}

}