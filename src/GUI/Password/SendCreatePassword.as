package GUI.Password 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendCreatePassword extends BasePacket 
	{
		public var Md5Password:String;
		
		public function SendCreatePassword(_md5Password:String) 
		{
			Md5Password = _md5Password;
			ID = Constant.CMD_SEND_CREATE_PASSWORD;
			URL = "UserService.createPassword";
		}
		
	}

}