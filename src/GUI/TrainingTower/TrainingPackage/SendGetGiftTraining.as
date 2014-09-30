package GUI.TrainingTower.TrainingPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendGetGiftTraining extends BasePacket 
	{
		public var RoomId:int;
		public function SendGetGiftTraining(roomId:int) 
		{
			URL = "SoldierService.getGiftTraining";
			ID = Constant.CMD_GET_GIFT_TRAINING;
			RoomId = roomId;
			IsQueue = false;
		}
		
	}

}