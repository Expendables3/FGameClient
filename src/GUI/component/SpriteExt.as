package GUI.component 
{
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author ...
	 */
	public class SpriteExt 
	{
		public var img:Sprite;
		public var loadComp:Function = null;
		public var imgName:String = "";
		private var imgLinkAge:Boolean = true;
		
		public function SpriteExt() 
		{
			
		}		
		
		public function loadRes(ImgName:String, isLinkAge:Boolean = true):void
		{
			img = null;
			imgName = ImgName;
			if (imgName != "")
			{
				var eventName:String;
				if (isLinkAge)
				{
					eventName = ResMgr.getInstance().FindUrl(imgName);
				}
				else
				{
					eventName = imgName;
				}	
				ResMgr.getInstance().addEventListener(eventName, reLoadRes);
				ResMgr.getInstance().addEventListener("err" + eventName, OnLoadResErr);
				var tg:Sprite = ResMgr.getInstance().GetRes(imgName, isLinkAge) as Sprite;
				if (tg != null)
				{
					img = tg;
					if (loadComp != null)
					{
						loadComp();
					}
				}
			}
			
			if (img == null)
			{
				img = new Sprite();
			}			
		}		
		
		private function reLoadRes(e:Event):void
		{	
			img = null;
			var tg:Sprite = ResMgr.getInstance().GetRes(imgName, imgLinkAge) as Sprite;
			if (tg != null)
			{
				img = tg;
				if (loadComp != null)
				{
					loadComp();
				}
			}
			clearEvent();
		}
		
		private function clearEvent():void
		{
			var eventName:String;
			if (imgLinkAge)
			{
				eventName = ResMgr.getInstance().FindUrl(imgName);
			}
			else
			{
				eventName = imgName;
			}
			ResMgr.getInstance().removeEventListener(eventName, reLoadRes);
			ResMgr.getInstance().removeEventListener("err" + eventName, OnLoadResErr);
		}
		
		private function OnLoadResErr(e:Event):void
		{
			clearEvent();
		}
	}

}