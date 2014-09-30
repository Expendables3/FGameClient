package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class SendGetLog extends BasePacket
	{
		public var UserId:int;
		
		public function SendGetLog(userId:int) 
		{
			ID = Constant.CMD_GET_ALL_LOG;
			URL = "HistoryService.getAll";
			UserId = userId;
			IsQueue = false;
		}		
	}

}