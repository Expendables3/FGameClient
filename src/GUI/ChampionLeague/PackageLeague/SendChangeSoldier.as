package GUI.ChampionLeague.PackageLeague 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendChangeSoldier extends BasePacket 
	{
		public var SoldierId:int;
		public var LakeId:int;
		
		public function SendChangeSoldier(soldierId:int, lakeId:int) 
		{
			URL = "OccupyService.changeSoldier";
			ID = Constant.CMD_CHANGE_SOLDIER_IN_LEAGUE;
			SoldierId = soldierId;
			LakeId = lakeId;
			IsQueue = false;
		}
		
	}

}