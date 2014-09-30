package Event.EventLuckyMachine 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SendRollMachine extends BasePacket 
	{
		public var TicketType:int;
		public function SendRollMachine(ticketType:int) 
		{
			ID = Constant.CMD_SEND_PLAY_LUCKY_MACHINE;
			URL = "MiniGameService.playLuckyMachine";
			
			TicketType = ticketType;
			IsQueue = false;
		}
		
	}

}