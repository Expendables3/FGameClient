package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendLevelUp extends BasePacket
	{
		
		public function SendLevelUp() 
		{
			ID = Constant.CMD_LEVEL_UP;
			URL = "UserService.levelUp";
			IsQueue = false;
		}
		
	}

}