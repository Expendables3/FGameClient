package NetworkPacket.PacketReceive.Tournament 
{
	import NetworkPacket.PacketReceive.BaseReceivePacket;
	
	/**
	 * ...
	 * @author MinhT
	 */
	public class ReceiveGiftTournament extends BaseReceivePacket 
	{
		public var Error:int;
		public var cardId:int;
		public var star:int;
		public var groupId:int;
		public var equipment:Object = new Object();
		public var eventItems:Array = new Array();
		
		public function ReceiveGiftTournament(data:Object) 
		{
			super(data);
		}
		
	}

}