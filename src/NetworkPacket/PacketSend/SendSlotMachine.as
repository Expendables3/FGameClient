package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author TienGa
	 */
	public class SendSlotMachine extends BasePacket
	{
		
		public function SendSlotMachine() 
		{
			ID = Constant.CMD_PLAY_SLOT_MACHINE;
			URL = "MiniGameService.luckyNumber";
			IsQueue = false;
		}
		
	}

}