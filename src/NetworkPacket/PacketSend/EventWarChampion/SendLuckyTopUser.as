package NetworkPacket.PacketSend.EventWarChampion 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendLuckyTopUser extends BasePacket 
	{
		public var UserId:Number;
		
		public function SendLuckyTopUser(userId:Number) 
		{
			URL = "EventService.getTopEventInGame";
			ID = Constant.CMD_SEN_GET_TOP_EVENT_WAR_CHAMPION;
			UserId = userId;
			IsQueue = false;
		}
		
	}

}