package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GetDailyEnergy extends BasePacket 
	{
		public var FriendId:int;
		public function GetDailyEnergy(uId:int)
		{
			//super();
			ID = Constant.CMD_GET_DAILY_ENERGY;
			URL = "CommonService.getDailyEnergy";
			IsQueue = false;
			FriendId = uId;
		}
		
	}

}