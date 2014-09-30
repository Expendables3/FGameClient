package  mercury
{
	import flash.events.Event;
	/**
	 * ...
	 * @author Hungnm3
	 */
	public class MercuryEvent extends Event
	{		
		public static const CONNECTION:String = "Connection";
		public static const CONNECTION_LOST:String = "ConnectionLost";
		public static const EXTENSION_RESPONSE:String = "ExtensionResponse";	
		public static const LOGIN:String = "Login";
		public var params:Object
		public var source:Object;
		public function MercuryEvent(type:String,params:Object) 
		{
			super(type);
			this.params = params
		}
		
	}

}