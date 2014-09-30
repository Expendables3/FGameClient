package GUI.ChampionLeague.PackageLeague 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendRefreshBoard extends BasePacket 
	{
		public var System:Boolean;
		public function SendRefreshBoard(system:Boolean) 
		{
			ID = Constant.CMD_REFRESH_RANK_BOARD;
			URL = "OccupyService.refreshOccupyingBoard";
			System = system;
			IsQueue = false;
		}
		
	}

}