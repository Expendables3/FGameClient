package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author 
	 */
	public class GetDailyFriendBonus extends BasePacket 
	{
		public var FriendId:int;
		
		public function GetDailyFriendBonus(uId:int) 
		{
			ID = Constant.CMD_GET_DAILY_FRIEND_BONUS;
			URL = "CommonService.bonusEnergyBox";
			//IsQueue = false;
			FriendId = uId;
		}		
	}

}