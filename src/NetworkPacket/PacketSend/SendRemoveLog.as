package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class SendRemoveLog extends BasePacket
	{
		public function SendRemoveLog() 
		{
			ID = Constant.CMD_REMOVE_LOG;
			URL = "HistoryService.del";
		}
		
	}

}