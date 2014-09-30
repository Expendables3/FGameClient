package NetworkPacket.PacketReceive.Tournament 
{
	import NetworkPacket.PacketReceive.BaseReceivePacket;
	
	/**
	 * ...
	 * @author MinhT
	 */
	public class ReceiveGetGiftTournamentInfo extends BaseReceivePacket 
	{
		public var Error:int;
		public var userId:int;
		public var cardStar:int;
		public var numChoose:int;
		public var groupId:int;
		public var lastCardId:Array = new Array();
		
		public function ReceiveGetGiftTournamentInfo(data:Object) 
		{
			super(data);
		}
		
	}

}