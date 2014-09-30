package NetworkPacket.PacketSend 
{
	import Logic.NewFeedWall;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SendSignKey extends BasePacket
	{
		public var userIdFrom:int;
		public var userIdTo:int;
		public var actId:int;
		public var tplId:int;
		public var objectId:String;
		public var attachName:String;
		public var attachHref:String;
		public var attachCaption:String;
		public var attachDescription:String;
		public var mediaType:int;
		public var mediaImage:String;
		public var mediaSource:String;
		public var actionLinkText:String;
		public var actionLinkHref:String;
		public function SendSignKey(FeedItem:NewFeedWall) 
		{
			ID = Constant.CMD_GET_SIGN_KEY;
			URL = "FeedService.FeedItem";
			userIdFrom = FeedItem.userIdFrom;
			userIdTo = FeedItem.userIdTo;
			actId = FeedItem.actId;
			tplId = FeedItem.tplId;
			objectId = FeedItem.objectId;
			attachName = FeedItem.attachName;
			attachHref = FeedItem.attachHref;
			attachCaption = FeedItem.attachCaption;
			attachDescription = FeedItem.attachDescription;
			mediaType = FeedItem.mediaType;
			mediaImage = FeedItem.mediaImage;
			mediaSource = FeedItem.mediaSource;
			actionLinkText = FeedItem.actionLinkText;
			actionLinkHref = FeedItem.actionLinkHref;
			IsQueue = false;
		}
		
	}

}