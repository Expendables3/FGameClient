package GUI.TrainingTower.TrainingPackage 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendUnlockRoom extends BasePacket 
	{
		
		public function SendUnlockRoom() 
		{
			URL = "SoldierService.unlockRoom";
			ID = Constant.CMD_UNLOCK_ROOM;
			IsQueue = false;
		}
		
	}

}