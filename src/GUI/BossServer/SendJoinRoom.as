package GUI.BossServer 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendJoinRoom extends BasePacket 
	{
		public var BossId:int;
		
		public function SendJoinRoom(_bossId:int) 
		{
			BossId = _bossId;
			IsQueue = false;
			ID = Constant.CMD_SEND_JOIN_ROOM;
			URL = "ServerBossService.joinRoom";
		}	
	}
}