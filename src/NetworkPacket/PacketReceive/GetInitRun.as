package NetworkPacket.PacketReceive 
{
	import Logic.Fish;
	import Logic.Lake;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class GetInitRun extends BaseReceivePacket
	{
		public var Error:int;
		public var timeRemain:int;
		public var FishList:Array = new Array();
		public var Item:Array = new Array();
		public var FriendList:Array = new Array();
		public var Lake1:Object = new Object();
		public var User:Object = new Object();
		public var SystemTime:int;
		public var MixLakeList:Object = new Object();			
		public var QuestList:Array = new Array();	
		public var DailyQuest:Array = new Array();
		public var UnlockFishList:Array = new Array();
		public var UserProfile:Object = new Object();
		public var Store:Object = new Object();
		public var SpecialItem:Object = new Object();
		public var EventList:Object = new Object();
		public var PowerTinhQuest:Object = new Object();
		public var Notification:Object = new Object();
		public var HammerMan:Object = new Object();
		public function GetInitRun(data:Object) 
		{
			super(data);
			//trace("UserId", User.Id);
		}
		
	}

}