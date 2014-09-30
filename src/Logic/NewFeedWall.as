package Logic 
{
	/**
	 * ...
	 * @author ...
	 */
	import adobe.utils.CustomActions;
	import com.adobe.crypto.MD5;
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.DictionaryUtil;
	import com.adobe.utils.NumberFormatter;
	import com.adobe.utils.StringUtil;
	import com.bit101.charts.PieChart;
	import com.bit101.components.ProgressBar;
	import com.greensock.easing.Bounce;
	import com.greensock.plugins.FilterPlugin;
	import com.greensock.TweenLite;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Data.QuestINI;
	import Effect.EffectMgr;
	import Effect.ImageEffect;
	import Effect.ImgEffectBlink;
	import Effect.ImgEffectFly;
	import Effect.Rippler;
	import Effect.SwfEffect;
	import Event.BaseEvent;
	import Event.EventMgr;
	import flash.accessibility.Accessibility;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import GameControl.*;
	import GUI.*;
	import Data.ResMgr;
	import GUI.component.ActiveTooltip;
	import GUI.component.Image;
	import GUI.component.Tooltip;
	
	public class NewFeedWall
	{
		
		private static var instance:NewFeedWall = new NewFeedWall();
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
		public var suggestion:Array;
		
		//public static const LINK_IMAGE:String = "http://fish-static.apps.zing.vn/imgcache/iconfeed/";
		public static const LINK_IMAGE:String = Main.staticURL +"iconfeed/";
		public static const LINK_FISH:String = "<a href=\\\"http://me.zing.vn/apps/fish?_src=m\\\">";
		public static const LINK_FISH_END:String = "</a>";
		
		public static function GetInstance():NewFeedWall 
		{
			if (instance == null)	instance = new NewFeedWall();
			return instance;
		}
		
		public function OpenFeedItem(UserIdFrom:int, UserIdTo:int, ActId:int, TplId:int, ObjectId:String, AttachName:String, AttachHref:String, 
			AttachCaption:String, AttachDescription:String, MediaType:int, MediaImage:String, MediaSource:String, 
			ActionLinkText:String, ActionLinkHref:String, Suggestion:Array):void
		{				
			instance.userIdFrom = UserIdFrom;
			instance.userIdTo = UserIdTo;
			instance.actId = ActId;
			instance.tplId = TplId;
			instance.objectId = ObjectId;
			instance.attachName = AttachName;
			instance.attachHref = AttachHref;
			instance.attachCaption = AttachCaption;
			instance.attachDescription = AttachDescription;
			instance.mediaType = MediaType;
			instance.mediaImage = MediaImage;
			instance.mediaSource = MediaSource;
			instance.actionLinkText = ActionLinkText;
			instance.actionLinkHref = ActionLinkHref;
			instance.suggestion = Suggestion;
			instance.attachName = (AttachName.length> 80) ? AttachName = AttachName.substring(0, 80) : AttachName;
			instance.attachHref = (AttachHref.length > 150) ? AttachHref = AttachName.substring(0, 150) : AttachHref;
			instance.attachCaption = (AttachCaption.length > 30) ? AttachCaption = AttachName.substring(0, 30) : AttachCaption;
			instance.attachDescription = (AttachDescription.length > 200) ? AttachDescription = AttachName.substring(0, 200) : AttachDescription;
			instance.mediaType = MediaType;
			instance.mediaImage = (MediaImage.length > 150)? MediaImage = MediaImage.substring(0, 150) : MediaImage;
			instance.mediaSource = (MediaSource.length > 150) ? MediaSource = MediaSource.substring(0, 150) : MediaSource;
			instance.actionLinkText = (ActionLinkText.length > 20) ? ActionLinkText = ActionLinkText.substring(0, 20) : ActionLinkText;
			instance.actionLinkHref = (ActionLinkHref.length > 150) ? ActionLinkHref = ActionLinkHref.substring(0, 150) : ActionLinkHref;
		}
		
		public function genKey():String 
		{
			var sec_key:String = "6b5fa8df3e3894ff776a7ec6604ac595";
			var str:String;
			
			str = sec_key + ":" + userIdFrom + ":" + userIdTo + ":" + actId + ":" + tplId + ":" + objectId + ":" + attachName + ":" + attachHref + ":" + attachCaption
				+ ":" + attachDescription + ":" + mediaType + ":" + mediaImage + ":" + mediaSource + ":" + actionLinkText + ":" + actionLinkHref;
			//trace(str);	
			return Ultility.MD5Hash(str);
		}
		
		public function NewFeedWall() 
		{
		}
		
	}

}