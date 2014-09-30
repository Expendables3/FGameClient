package NetworkPacket.PacketReceive 
{
	/**
	 * ...
	 * @author 
	 */
	public class GetTreasure extends BaseReceivePacket 
	{
		public var Error:int;
		public var Gift:Array = [];
		
		public function GetTreasure(data:Object) 
		{
			super(data);
			
		}
		
	}

}