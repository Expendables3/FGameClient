package GUI.TrungLinhThach 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class SendReceiveBonus extends BasePacket 
	{
		public var EggType:String = '';
		
		public function SendReceiveBonus() 
		{
			ID = Constant.CMD_RECEIVE_BONUS;
			URL = "SmashEggService.receiveBonus";
			IsQueue = false;
		}
		
	}

}