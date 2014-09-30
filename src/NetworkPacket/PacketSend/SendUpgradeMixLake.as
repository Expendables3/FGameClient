package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendUpgradeMixLake extends BasePacket 
	{
		
		public function SendUpgradeMixLake() 
		{
			ID = Constant.CMD_UPGRADE_MIX_LAKE;
			URL = "MixLakeService.upgradeMixLake";
			IsQueue = false;
		}
		
	}

}