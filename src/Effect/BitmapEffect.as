package Effect 
{
	import Data.ResMgr;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author longpt
	 */
	public class BitmapEffect 
	{
		
		public var IsFinish:Boolean = false;
		public var img:Sprite;
		private var Parent:Object;
		private var reUse:Boolean;
		private var OldImg:Object;
		private var OldPos:Point;
		private var IsLoop:Boolean;
		public var PosX:int;
		public var PosY:int;
		public var f:Function;
		
		public var bmpArray:Vector.<BitmapData>;
		public var bmpPos:Vector.<Rectangle>;
		public var curFrame:int;
		public var maxFrame:int;
		
		public function BitmapEffect(parent:Object, swfName:String, x:Number = 0, y:Number = 0, reUse:Boolean = false, IsLoop:Boolean = false, f:Function = null) 
		{
			Parent = parent;
			this.IsLoop = IsLoop;
			this.reUse = reUse;
			this.f = f;
			img = ResMgr.getInstance().GetRes(swfName, true, true) as Sprite;
			bmpArray = ResMgr.getInstance().GetBmpArray(swfName);
			bmpPos = ResMgr.getInstance().GetBmpPos(swfName);
			//////img.addChild(bmpArray[0]);
			
			PosX = x;
			PosY = y;
			img.x = x;
			img.y = y;
			img.mouseChildren = false;
			img.mouseEnabled = false;

			var mv:MovieClip = img as MovieClip;
			img.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			curFrame = 0;
			maxFrame = bmpArray.length;
			mv.gotoAndPlay(0);
			
			Parent.addChild(img);
		}
		
		private function onEnterFrame(event:Event):void
		{
			//trace(curFrame, maxFrame);
			if (img == null)
			{
				return;
			}
			
			if (maxFrame <= 1)
			{
				return;
			}
			
			var mv:MovieClip = img as MovieClip;
			var bm:Bitmap = mv.getChildAt(0) as Bitmap;
			if (bm == null)
			{
				return;
			}
			
			curFrame++;
			if (curFrame >= maxFrame && !IsLoop)
			{
				return;
			}
			
			if (curFrame >= maxFrame)
			{
				curFrame = 0;
			}
			

			bm.bitmapData = bmpArray[curFrame];
			//bm.x = PosX;
			//bm.y = PosY;
			bm.x = bmpPos[curFrame].x;
			bm.y = bmpPos[curFrame].y;
		}
		
		public function UpdateEffect():void
		{
			//trace("img.currentFrame, img.totalFrames", img.currentFrame, img.totalFrames);
			if (!IsLoop && curFrame >= maxFrame)
			{
				img.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				FinishEffect();
			}
		}
		
		public function FinishEffect():void
		{
			if (Parent != null && img.parent == Parent)
			{
				Parent.removeChild(img);
			}
			
			IsFinish = true;
			
			if (f != null)
			{
				f();
			}
		}
	}

}