package GUI.FishWorld.Network 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ChooseSerialAttackInYellowForest extends BasePacket 
	{
		public var SeaId:int;
		public function ChooseSerialAttackInYellowForest(_SeaId:int) 
		{
			ID = Constant.CMD_GET_SERIAL_ATTACK_FOREST_YELLOW;
			URL = "FishWorldService.startChooseSerialAttackInForestYellow";
			SeaId = _SeaId;
			IsQueue = false;
		}
		
	}

}