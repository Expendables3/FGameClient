package Event.NewYear 
{
	import Effect.EffectMgr;
	import Effect.ImgEffectBlink;
	import Effect.ImgEffectScaleDown;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import Logic.BaseObject;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	/**
	 * ...
	 * @author ducnh
	 */
	public class BamBoo extends BaseObject
	{
		private var GocTre:DisplayObject;
		private var NgonTre:DisplayObject;
		private var NDotTre:int = 0;
		
		public function BamBoo(parent:Object, x:int, y:int, nDotTre:int)
		{
			super(parent, "Event1_BamBoo", x, y);
			GoToAndStop(nDotTre);
			NDotTre = nDotTre;
		}
		
		public function GrowUp():void
		{
			NDotTre ++;
			GoToAndStop(NDotTre);
		}
		
		public override function OnMouseClick(event:MouseEvent):void
		{
			var ObjName:String = getQualifiedClassName(event.target);
			switch (ObjName)
			{
				case "NgonTre":
					EffectMgr.getInstance().AddImageEffect(EffectMgr.EFF_SCALE_DOWN, img);
					break;
				case "GocTre":
					var eff:ImgEffectScaleDown = EffectMgr.getInstance().AddImageEffect(EffectMgr.EFF_SCALE_DOWN, img) as ImgEffectScaleDown;
					eff.CallBack = GrowUp;
					break;
			}
		}

		
	}

}