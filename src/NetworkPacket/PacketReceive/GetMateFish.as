package NetworkPacket.PacketReceive 
{
	/**
	 * ...
	 * @author ...
	 */
	public class GetMateFish extends BaseReceivePacket
	{
		public var Error:int;
		public var Id:int;
		public var Sex:int;
		public var TypeId:int;
		public var TypeFish:int;
		public var RateOption:Object = new Object();
		public var Color:int;
		public var Level:int;
		public var Option:String;
		
		public function GetMateFish(data:Object) 
		{
			super(data);			
		}
		
	}

}