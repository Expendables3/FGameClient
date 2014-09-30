package NetworkPacket.PacketSend 
{
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendFeedWall extends BasePacket 
	{		
		public var TypeFeed:String;
		public var UserMsg:String;
		public var Icon:String;
		public var ItemName:String;
		public var QuestName:String;
		
		public function SendFeedWall() 
		{
			ID = Constant.CMD_FEED_ONWALL;
			//URL = "FeedService.postOnWall";
			URL = "FeedService.postOnWall";
			IsQueue = false;
		}
		
		public function AddNew(UserMsg:String, TypeFeed:String, Icon:String, ItemName:String, QuestName:String):void
		{
			this.TypeFeed = TypeFeed;
			this.UserMsg = UserMsg;
			this.Icon = Icon;
			this.ItemName = ItemName;
			this.QuestName = QuestName;
			//trace(UserMsg);
		}
	}

}