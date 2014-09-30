package GUI.FishWorld.Network 
{
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendLoadOcean extends BasePacket 
	{
		
		public function SendLoadOcean() 
		{
			ID = Constant.CMD_LOAD_OCEAN_SEA;
			URL = "FishWorldService.loadOcean";
			IsQueue = false;
		}
		
	}

}