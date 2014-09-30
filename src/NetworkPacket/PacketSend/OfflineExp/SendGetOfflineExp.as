package NetworkPacket.PacketSend.OfflineExp 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetOfflineExp extends BasePacket 
	{
		public var isMoney:Boolean;
		public function SendGetOfflineExp(_isMoney:Boolean) 
		{
			ID = Constant.CMD_GET_OFFLINE_EXP;
			URL = "CommonService.getOfflineExp";
			isMoney = _isMoney;
		}
		
	}

}