package GUI.Mail.SystemMail.MailPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendInputCode extends BasePacket 
	{
		public var Code:String;
		public var Element:int;
		public function SendInputCode(code:String,element:int = 0) 
		{
			ID = Constant.CMD_INPUT_CODE;
			URL = "UserService.useItemCode";
			Code = code;
			Element = element;
			IsQueue = false;
		}
		
	}

}