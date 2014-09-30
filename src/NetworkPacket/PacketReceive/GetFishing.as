package NetworkPacket.PacketReceive 
{
	/**
	 * ...
	 * @author Le Ba Dung
	 */
	public class GetFishing extends BaseReceivePacket
	{
		public var ItemType:String = "";
		public var Num:int;
		public var ItemId:int;
		public var Error:int;
		
		public function GetFishing(data:Object) 
		{
			super(data);
		}
		
	}

}