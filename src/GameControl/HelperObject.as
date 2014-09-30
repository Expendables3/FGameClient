package GameControl 
{
	import Data.ResMgr;
	import flash.display.ActionScriptVersion;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Logic.LayerMgr;
	/**
	 * ...
	 * @author ducnh
	 */
	public class HelperObject
	{
		public var MyObject:Object = null;
		private var img:Sprite = null;
		public var HelperName:String;
		
		public function HelperObject() 
		{
			
		}
		
		public function SetMyObject(obj:Object):void
		{
			/*
			if (img != null)
			{
				HideHelper();
				MyObject = obj;
				ShowHelper();
			}
			*/
			MyObject = obj;
		}
		
		private function CreateHelperIcon():Sprite
		{
			var temp:Sprite = ResMgr.getInstance().GetRes("IcHelper") as Sprite;
			temp.mouseEnabled = false;
			temp.mouseChildren = false;
			return temp;
		}
		
		public function InviHelper(isHide:Boolean):void
		{
			if (img)
			{
				img.visible = !isHide;
			}
		}
		
		private function FindPos(obj:Object):Point
		{
			var kq:Point = new Point(obj.x, obj.y);
			var rec:Rectangle = obj.getBounds(obj.parent);
			var dx:int = rec.left - obj.x;
			var dy:int = rec.top - obj.y;
			kq.x = obj.x + dx + rec.width / 2;
			kq.y = obj.y + dy;
			return kq;
		}
		
		public function ShowHelper():void
		{
			if (img != null)
			{
				return;
			}
			
			if ("parent" in MyObject)
			{
				img = CreateHelperIcon();
				try
				{
					MyObject.parent.addChildAt(img, MyObject.parent.getChildIndex(MyObject) + 1);	
				}
				catch (err:Error)
				{
					MyObject.parent.addChild(img);
				}
			}
			
			/*
			if ("addChild" in MyObject)
			{
				img = CreateHelperIcon();
				MyObject.addChild(img);
			}
			else
			{
				if ("parent" in MyObject)
				{
					img = CreateHelperIcon();
					MyObject.parent.addChild(img);		
				}
			}*/
			var pt:Point = FindPos(MyObject);
			img.x = pt.x;
			img.y = pt.y;
			
			ShowDisableScreen(true);
		}
		
		private function ShowDisableScreen(IsShow:Boolean):void
		{
			/*
			if (IsShow)
			{
				var rec:Rectangle = MyObject.getBounds(img.stage);
				var r:int = (rec.width > rec.height)?rec.height:rec.width;
				var x:int = rec.left + rec.width / 2;
				var y:int = rec.top + rec.height / 2;
				LayerMgr.getInstance().GetLayer(Constant.TopLayer).ShowTutorialScreen(x, y, r);
			}
			else
			{
				LayerMgr.getInstance().GetLayer(Constant.TopLayer).HideDisableScreen();
			}
			*/
		}
		
		public function HideHelper():void
		{
			if (img == null) 
			{
				return;
			}
			if ("parent" in MyObject)
			{
				if (MyObject.parent != null)
				{
					MyObject.parent.removeChild(img);
				}
			}
			
			/*
			if ("addChild" in MyObject)
			{
				MyObject.removeChild(img);
			}
			else
			{
				if ("parent" in MyObject)
				{
					MyObject.parent.removeChild(img);
				}
			}
			*/
			img = null;
			ShowDisableScreen(false);
		}
		
		public function CanShowHelper():Boolean
		{
			if (MyObject != null)
			{
				if ("stage" in MyObject)
				{
					if ((MyObject.stage != null) && (MyObject.visible))
					{
						return true;
					}
				}
			}
			
			return false;
		}
		
	}

}