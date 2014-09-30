package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author Hien
	 */
	public class SendRefreshFriend extends BasePacket
	{
		public var Refresh: Boolean = false;
		public function SendRefreshFriend(isRefresh: Boolean = false) 
		{
			Refresh = isRefresh;
			ID = Constant.CMD_REFRESH_FRIEND;
			URL = "UserService.refreshFriend";
			IsQueue = false;
		}		
	}

}