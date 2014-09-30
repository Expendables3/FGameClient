package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendUnlockLake extends BasePacket
	{
		
		public function SendUnlockLake() 
		{
			ID = Constant.CMD_UNLOCK_LAKE;
			URL = "LakeService.unlockLake";
			IsQueue = false;
		}
		
	}

}