package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class SendUpgradeLake extends BasePacket
	{
		public var LakeId:int;
		
		public function SendUpgradeLake(lakeid:int) 
		{
			ID = Constant.CMD_UPGRADE_LAKE;
			URL = "LakeService.upgradeLake";
			LakeId = lakeid;
			IsQueue = false;
		}
		
	}

}