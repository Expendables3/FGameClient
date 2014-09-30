package NetworkPacket.PacketReceive 
{
	/**
	 * ...
	 * @author ducnh
	 */
	public class GetCleanLake extends BaseReceivePacket
	{
		public var Exp:int;
		public var Num:int;
		public var Error:int;
		public var Bonus:Array = [];
		public var EventBonus:Array = [];
		
		public function GetCleanLake(data:Object) 
		{
			super(data);
		}
		
	}

}