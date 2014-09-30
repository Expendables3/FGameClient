package GUI.Mail.SystemMail.MailPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendDelSystemMailFast extends BasePacket 
	{
		public var MessageId : int;
		public function SendDelSystemMailFast(LetterID: int) 
		{
			ID = Constant.CMD_REMOVE_SYSTEM_MESSAGE;
			URL = "MessageService.removeSystemMessage";
			MessageId = LetterID;
		}
		
	}

}