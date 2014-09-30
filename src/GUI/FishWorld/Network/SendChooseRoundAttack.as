package GUI.FishWorld.Network 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendChooseRoundAttack extends BasePacket 
	{
		public var SeaId:int = 1;
		public var RoundId:int = 1;
		
		public function SendChooseRoundAttack(_RoundId:int, _SeaId:int) 
		{
			ID = Constant.CMD_CHOOSE_ROUND_ATTACK;
			URL = "FishWorldService.chooseRoundAttack";
			RoundId = _RoundId;
			SeaId = _SeaId;
			IsQueue = false;
		}	
	}

}