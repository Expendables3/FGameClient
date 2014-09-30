package NetworkPacket.PacketReceive.Reputation 
{
	import NetworkPacket.PacketReceive.BaseReceivePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ReceiveGiftReputation extends BaseReceivePacket 
	{
		public var Error:int;
		public var Level:int;
		public var QuestList:Object = new Object();
		
		public function ReceiveGiftReputation(data:Object) 
		{
			super(data);			
		}
		
	}

}