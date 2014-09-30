package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendFirstTimeLogin extends BasePacket 
	{
		
		public function SendFirstTimeLogin() 
		{
			ID = Constant.CMD_FIRST_TIME_LOGIN;
			URL = "CommonService.firstTimeLogin";
			IsQueue = false;
		}
		
	}

}