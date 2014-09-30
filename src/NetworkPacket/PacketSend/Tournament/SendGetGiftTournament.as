package NetworkPacket.PacketSend.Tournament 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author MinhT
	 */
	public class SendGetGiftTournament extends BasePacket 
	{
		public var cardId:int;
		public function SendGetGiftTournament(cardId:int)
		{
			super();
			ID = Constant.CMD_GET_GIFT;
			URL = "FishTournamentService.getGiftTour";
			
			this.cardId = cardId;
			this.IsQueue = false;
		}
		
	}

}