package GUI.Password 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendCrackPassword extends BasePacket 
	{
		
		public function SendCrackPassword() 
		{
			ID = Constant.CMD_SEND_CRACK_PASSWORD;
			URL = "UserService.crackPassword";
		}
		
	}

}