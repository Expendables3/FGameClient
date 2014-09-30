package GUI.EventMagicPotions.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Hoàn thành nhanh quest thảo dược
	 * @author longpt
	 */
	public class QuickDoneHerbQuest extends BasePacket 
	{
		public var IdHerb:int;	// id cua quest 1 2 3
		public function QuickDoneHerbQuest(id:int) 
		{
			ID = Constant.CMD_SEND_QUICK_DONE_HERB_QUEST;
			URL = "EventService.quickDoneHerbQuest";
			//IsQueue = false;
			
			IdHerb = id;
		}
		
	}

}