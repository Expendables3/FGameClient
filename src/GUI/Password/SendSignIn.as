package GUI.Password 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendSignIn extends BasePacket 
	{
		public var Md5Mixture:String;
		
		public function SendSignIn(_md5Mixture:String) 
		{
			Md5Mixture = _md5Mixture;
			ID = Constant.CMD_SEND_SIGN_IN;
			URL = "UserService.signIn";
		}
		
	}

}