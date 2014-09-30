package GUI.Password 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendChangePassword extends BasePacket 
	{
		public var Md5OldPassword:String;
		public var Md5NewPassword:String;
		
		public function SendChangePassword(_md5OldPassword:String, _md5NewPassword:String) 
		{
			Md5NewPassword = _md5NewPassword;
			Md5OldPassword = _md5OldPassword;
			ID = Constant.CMD_SEND_CHANGE_PASSWORD;
			URL = "UserService.changePassword";
		}
		
	}

}