package GUI.EventMagicPotions.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Nhan phan thuong hoan thanh quest
	 * @author longpt
	 */
	public class DoneHerbQuest extends BasePacket 
	{
		public var IdHerb:int;
		public function DoneHerbQuest(id:int) 
		{
			ID = Constant.CMD_SEND_DONE_HERB_QUEST;
			URL = "EventService.gotGiftHerbQuest";
			IsQueue = false;
			
			IdHerb = id;
		}
		
	}

}