package NetworkPacket.PacketSend.Tournament 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author MinhT
	 */
	public class SendGetGiftTournamentInfo extends BasePacket 
	{
		
		public function SendGetGiftTournamentInfo() 
		{
			super();
			ID = Constant.CMD_GET_GIFT_TOUR_INFO;
			URL = "FishTournamentService.getGiftTourInfo";
			IsQueue = false;
		}
		
	}

}