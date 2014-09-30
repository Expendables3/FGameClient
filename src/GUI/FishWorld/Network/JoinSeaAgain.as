package GUI.FishWorld.Network 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class JoinSeaAgain extends BasePacket 
	{
		public var SeaId:int;
		public function JoinSeaAgain(seaID:int) 
		{
			ID = Constant.CMD_JOIN_OCEAN_SEA_AGAIN;
			URL = "FishWorldService.joinSeaAgainOld";
			SeaId = seaID;
			IsQueue = false;
		}
		
	}

}