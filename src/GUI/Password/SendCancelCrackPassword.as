package GUI.Password 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendCancelCrackPassword extends BasePacket 
	{
		
		public function SendCancelCrackPassword() 
		{
			ID = Constant.CMD_CANCEL_CRACK_PASSWORD
			URL = "UserService.cancelCrackPassword";
		}
		
	}

}