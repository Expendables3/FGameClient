package GUI.EventMagicPotions.NetworkPacket 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * Đổi ngọc ấn ở event Thảo Dược
	 * @author longpt
	 */
	public class SendExchangeHerbMedal extends BasePacket 
	{
		public var idSeal:int;
		
		public function SendExchangeHerbMedal(id:int) 
		{
			ID = Constant.CMD_SEND_EXCHANGE_HERB_MEDAL;
			URL = "EventService.exchangeHerbMedal";
			
			idSeal = id;
			IsQueue = false;
		}
		
	}

}