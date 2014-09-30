package GUI.EventMagicPotions.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class SendAutoDoneHerbQuest extends BasePacket 
	{
		public var IdHerb:int;	// 1, 2, 3
		public var NumAuto:int; // 10, 100
		
		public function SendAutoDoneHerbQuest(id:int, num:int) 
		{
			ID = Constant.CMD_SEND_AUTO_DONE_HERB_QUEST;
			URL = "EventService.autoDoneHerbQuest";
			
			IdHerb = id;
			NumAuto = num;
			
			IsQueue = false;
		}
		
	}

}