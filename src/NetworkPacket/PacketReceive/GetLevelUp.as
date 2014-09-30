package NetworkPacket.PacketReceive 
{
	/**
	 * ...
	 * @author ducnh
	 */
	public class GetLevelUp extends BaseReceivePacket
	{
		public var Level:int;
		public var Exp:int;
		public var Error:int;
		public var QuestList:Object = new Object;
		//public var GiftList:Array = new Array();
		
		public function GetLevelUp(data:Object) 
		{
			super(data);
		}
		
	}

}