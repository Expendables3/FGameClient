package NetworkPacket.PacketSend.OfflineExp 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendSyncOfflineExp extends BasePacket 
	{
		public function SendSyncOfflineExp() 
		{
			ID = Constant.CMD_SYNC_OFFLINE_EXP;
			URL = "CommonService.syncOfflineExp";
		}
		
	}

}