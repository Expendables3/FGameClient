package NetworkPacket.PacketReceive 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class GetRefreshFriend extends BaseReceivePacket
	{
		public var Error:int;
		public var FriendList :Array = [];
		
		public function GetRefreshFriend(data: Object) 
		{
			super(data);	
			//trace(FriendList[0].Id);
		}
		
	}

}