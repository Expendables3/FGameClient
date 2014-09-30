package GUI.ChampionLeague.PackageLeague 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Nhận quà
	 * @author HiepNM2
	 */
	public class SendGetGiftLeague extends BasePacket 
	{
		
		public function SendGetGiftLeague() 
		{
			URL = "OccupyService.getGiftOccupied";
			ID = Constant.CMD_GET_GIFT_LEAGUE;
			IsQueue = false;
		}
		
	}

}