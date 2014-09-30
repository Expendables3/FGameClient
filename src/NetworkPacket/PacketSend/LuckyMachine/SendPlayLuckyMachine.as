package NetworkPacket.PacketSend.LuckyMachine 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM
	 */
	public class SendPlayLuckyMachine extends BasePacket 
	{
		public var Type:String;
		public var TicketType:int;
		public function SendPlayLuckyMachine(_type:String,_ticketType:int) 
		{
			//super();
			ID = Constant.CMD_SEND_PLAY_LUCKY_MACHINE;
			URL = "MiniGameService.playLuckyMachine";
			
			Type = _type;
			TicketType = _ticketType;
		}
		
	}

}