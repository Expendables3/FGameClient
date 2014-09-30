package GUI 
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Image;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class AvatarImage extends Image 
	{
		public var oldIndex:int = 1;
		
		public function AvatarImage(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
		}
		
		public function initAvatar(avatarLink:String, loadComplete:Function = null):void
		{
			setImgInfo = loadComplete;
			LoadRes(avatarLink, false);
		}
		
		override public function OnLoadResErr(e:Event):void 
		{
			//super.OnLoadResErr(e);
			LoadRes(Main.staticURL + "/avatar.png", false);
		}
	}

}