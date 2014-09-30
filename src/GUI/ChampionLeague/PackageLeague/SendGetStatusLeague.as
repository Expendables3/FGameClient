package GUI.ChampionLeague.PackageLeague 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendGetStatusLeague extends BasePacket 
	{
		
		public function SendGetStatusLeague() 
		{
			URL = "LeagueService.getStatusLeague";
			ID = Constant.CMD_GET_STATUS_LEAGUE;
			IsQueue = false;
		}
		
	}

}