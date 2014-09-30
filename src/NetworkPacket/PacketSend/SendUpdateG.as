package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendUpdateG extends BasePacket 
	{
		public function SendUpdateG() 
		{
			IsQueue = false;
			ID = Constant.CMD_UPDATE_G;
			URL = "UserService.updateG";
		}
		
	}

}