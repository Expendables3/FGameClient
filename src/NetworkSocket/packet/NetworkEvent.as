package NetworkSocket.packet 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class NetworkEvent extends Event 
	{
		public var cmdID:int;
		public var cmdSend:Object;
		public var cmdReceive:Object;
		
		public function NetworkEvent(type:String) 
		{
			super(type);
		}
		
	}

}