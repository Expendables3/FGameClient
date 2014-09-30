package GUI.TrainingTower.TrainingPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendStopTraining extends BasePacket 
	{
		public var RoomId:int;
		public function SendStopTraining(roomId:int) 
		{
			URL = "SoldierService.stopTraining";
			ID = Constant.CMD_STOP_TRAINING;
			RoomId = roomId;
		}
		
	}

}