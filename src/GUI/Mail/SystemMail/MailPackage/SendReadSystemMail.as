package GUI.Mail.SystemMail.MailPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendReadSystemMail extends BasePacket 
	{
		public var MessageId : int;
		public function SendReadSystemMail(LetterID:int) 
		{
			ID = Constant.CMD_READ_SYSTEM_MESSAGE;
			URL = "MessageService.readSystemMail";
			MessageId = LetterID;
		}
		
	}

}