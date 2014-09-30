package NetworkPacket.PacketSend.EventWarChampion 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class SendGetRewardWarChampion extends BasePacket 
	{
		public var rewardType:int;
		public var idWeek:int;
		public var Element:int;
		
		public function SendGetRewardWarChampion(_rewardType:int, _idWeek:int, _element:int) 
		{
			URL = "EventService.getRewardEventInGame";
			ID = Constant.CMD_SEN_GET_REWARD_EVENT_WAR_CHAMPION;
			rewardType = _rewardType;				// Loại phần thưởng là tuần, tháng ngày
			idWeek = _idWeek;						// tuần thứ ????
			Element = _element;						// Hệ của giải thưởng
		}
		
	}

}