package GUI.TrainingTower.TrainingPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendSpeedUpTraining extends BasePacket 
	{
		public var RoomId:int;
		public function SendSpeedUpTraining(roomId:int) 
		{
			URL = "SoldierService.speedUpTraining";
			ID = Constant.CMD_SPEEDUP_TRAINING;
			RoomId = roomId;
		}
		
	}

}