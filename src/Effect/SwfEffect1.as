package Effect 
{
	import Data.ResMgr;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import Logic.BaseObject;
	/**
	 * ...
	 * @author Quangvh
	 * Dùng khi muốn can thiệp vào 1 frame nào đó
	 */
	public class SwfEffect1 
	{
		public var IsFinish:Boolean = false;
		public var img:MovieClip;
		private var Parent:Object;
		//private var OldChildParent:Object;
		private var OldImg:Object;
		private var OldPos:Point;
		private var IsLoop:Boolean;
		public var PosX:int;
		public var PosY:int;
		public var ObjUse:BaseObject;
		public var f:Function;
		public var frameChildStop:Array;
		public var numMovieChild:int;
		
		public function SwfEffect1(parent:Object, swfName:String, NumMovieChild:int = 0, FrameChildStop: Array = null, x:Number = 0, y:Number = 0, ReUse:Boolean = false, IsLoop:Boolean = false, ObjUse:BaseObject = null, f:Function = null):void 
		{
			Parent = parent;
			this.IsLoop = IsLoop;
			this.ObjUse = ObjUse;
			this.f = f;
			img = ResMgr.getInstance().GetRes(swfName) as MovieClip;
			PosX = x;
			PosY = y;
			img.x = x;
			img.y = y;
			img.mouseChildren = false;
			img.mouseEnabled = false;
			Parent.addChild(img);
			frameChildStop = FrameChildStop;
			numMovieChild = NumMovieChild;
			var i:int = 0;
			for (i = 0; i < numMovieChild; i++)
			{
				var node:MovieClip;
				node = img.getChildByName("Child" + i) as MovieClip;
				if (node != null)
				{
					node.gotoAndPlay(frameChildStop[i]);
					node.stop();
				}
			}
		}
		
		public function UpdateEffect():void
		{
			//trace("img.currentFrame, img.totalFrames", img.currentFrame, img.totalFrames);
			if (!IsLoop && img.totalFrames <= img.currentFrame)
			{
				FinishEffect();
			}
		}
		
		public function FinishEffect():void
		{
			if (Parent != null && img.parent == Parent)
			{
				Parent.removeChild(img);
				//if (OldChildParent != null)
				//{
					//OldChildParent.addChild(OldImg);
					//OldImg.x = OldPos.x
					//OldImg.y = OldPos.y
				//}
			}
			IsFinish = true;
			
			if(f!= null)
			{
				f();
			}
		}
		
	}

}