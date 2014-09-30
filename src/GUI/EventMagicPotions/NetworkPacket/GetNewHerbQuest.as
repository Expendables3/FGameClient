package GUI.EventMagicPotions.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * tra tien nhan quest moi
	 * @author longpt
	 */
	public class GetNewHerbQuest extends BasePacket 
	{
		public var IdHerb:int;
		public var isMoney:Boolean;
		
		public function GetNewHerbQuest(id:int, money:Boolean) 
		{
			ID = Constant.CMD_SEND_GET_NEW_HERB_QUEST;
			URL = "EventService.getNewHerbQuest";
			IsQueue = false;
			
			IdHerb = id;
			isMoney = money;
		}
		
	}

}