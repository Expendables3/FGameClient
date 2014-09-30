package Effect 
{
	import Data.ResMgr;
	//import Event.EventNoel.NoelGui.ItemGui.EffectEvent.EffBomb;
	import Event.EventNoel.NoelGui.ItemGui.EffectEvent.EffGunFire;
	import Event.EventNoel.NoelGui.ItemGui.EffectEvent.EffIce;
	import Event.EventTeacher.EffOpenBox;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getQualifiedClassName;
	import Logic.BaseObject;
	import Logic.Layer;
	/**
	 * ...
	 * @author ducnh
	 */
	public class SwfEffect
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
		
		public function SwfEffect(parent:Object, swfName:String, ChildList:Array = null, x:Number = 0, y:Number = 0, ReUse:Boolean = false, IsLoop:Boolean = false, ObjUse:BaseObject = null, f:Function = null):void 
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
			
			var node:Sprite;
			var child:DisplayObject;
			var i:int;
			
			for (i = 0; ChildList != null && i < ChildList.length; i++)
			{
				node = img.getChildByName("Child" + i) as Sprite;
				for (var j:int = 0; node && j < node.numChildren; j++) 
				{
					node.removeChildAt(j);
					j--;
				}
				if(getQualifiedClassName(ChildList[i]) == "String")
				{
					child = ResMgr.getInstance().GetRes(ChildList[i] as String) as DisplayObject;
				}
				else
				{
					child = ChildList[i] as DisplayObject;					
					//OldChildParent = null;
					//if (child != null && child.parent != null && ReUse)
					//{
						//OldChildParent = child.parent;
						//OldImg = child;
						//OldPos = new Point(child.x, child.y);
					//}
					child.x = 0;
					child.y = 0;
				}
				if (child == null) 
				{
					continue;
				}
				//for (var j:int = 0; node && j < node.numChildren; j++) 
				//{
					//node.removeChildAt(j);
					//j--;
				//}
				node.addChild(child);				
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
		
		static public function createSwf(layer:Layer, swfName:String, childList:Array, x:Number, y:Number, reUse:Boolean, isLoop:Boolean, objUse:BaseObject, f:Function):SwfEffect
		{
			switch(swfName)
			{
				case "GuiExchangeCandy_EffOpenBox":
					return new EffOpenBox(layer, swfName, childList, x, y, reUse, isLoop, objUse, f);
				case "GuiHuntFish_EffGunFire":
					return new EffGunFire(layer, swfName, childList, x, y, reUse, isLoop, objUse, f);
				/*case "GuiHuntFish_EffBomb":
				case "GuiHuntFish_EffBullet3":
					return new EffBomb(layer, swfName, childList, x, y, reUse, isLoop, objUse, f);*/
				case "GuiHuntFish_EffRainIce":
					return new EffIce(layer, swfName, childList, x, y, reUse, isLoop, objUse, f);
				
				default:
					return new SwfEffect(layer, swfName, childList, x, y, reUse, isLoop, objUse, f);
			}
		}
		
	}

}