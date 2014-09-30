package GUI.TrainingTower.TrainingPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendGetStatusTraining extends BasePacket 
	{
		public function SendGetStatusTraining() 
		{
			URL = "SoldierService.getStatusTraining";
			ID = Constant.CMD_GET_STATUS_TRAINING;
			IsQueue = false;
		}
	}

}