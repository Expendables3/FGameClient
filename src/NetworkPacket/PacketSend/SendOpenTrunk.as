package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class SendOpenTrunk extends BasePacket
	{
		public var PearlId:int;
		public function SendOpenTrunk(trunkId:int) 
		{
			ID = Constant.CMD_OPEN_TRUNK;
			URL = "EventService.openPearl";
			PearlId = trunkId;
			IsQueue = false;
		}
		
	}

}