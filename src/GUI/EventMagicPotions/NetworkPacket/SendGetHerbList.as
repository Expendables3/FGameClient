package GUI.EventMagicPotions.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Lấy list Herb
	 * @author longpt
	 */
	public class SendGetHerbList extends BasePacket 
	{
		
		public function SendGetHerbList() 
		{
			ID = Constant.CMD_SEND_GET_HERB_LIST;
			URL = "EventService.getHerbList";
			IsQueue = false;
		}
		
	}

}