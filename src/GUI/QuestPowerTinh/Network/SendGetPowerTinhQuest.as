package GUI.QuestPowerTinh.Network 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * GetPowerTinhQuestList
	 * @author longpt
	 */
	public class SendGetPowerTinhQuest extends BasePacket
	{
		
		public function SendGetPowerTinhQuest() 
		{
			ID = Constant.CMD_SEND_GET_POWER_TINH_QUEST;
			URL = "MiniGameService.getPowerTinhQuest";
			
			IsQueue = false;
		}
		
	}

}