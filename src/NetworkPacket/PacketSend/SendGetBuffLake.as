package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendGetBuffLake extends BasePacket 
	{
		
		public function SendGetBuffLake() 
		{
			ID = Constant.CMD_GET_BUFF_LAKE;
			URL = "LakeService.getBuffOfAllLake";
			IsQueue = false;
		}
		
	}

}