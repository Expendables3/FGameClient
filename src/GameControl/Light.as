package GameControl 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import Logic.BaseObject;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author ducnh
	 */
	public class Light extends BaseObject
	{	
		public static const MIN_SCALE:Number = 0.01;
		public static const MAX_SCALE:Number = 1.0;
		public static const SCALE_PER_FRAME:Number = 0.008;

		private var TargetScale:Number;
		private var CurScale:Number;
		private var RegPoint:Point = new Point;
		
		public function Light(parent:Object, x:int, y:int, width:int, height:int)
		{
			
			super(parent, "", x, y);
			ClassName = "Light";
			
			DrawLight(x, y, width, height);
			//try{
				parent.addChild(img);
				img.x = x; img.y = y;
			//}catch (err:Error){
				//GameLogic.getInstance().CatchErr(err);
			//}
			var eff:BlurFilter = new BlurFilter(40, 40, 2);
			img.filters = [eff];
			
			CurScale = Ultility.RandomNumber(MIN_SCALE, MAX_SCALE);
			
			var a:int = Ultility.RandomNumber(0, 10);
			if (a > 5)
			{
				ScaleTo(MAX_SCALE);
			}
			else
			{
				ScaleTo(MIN_SCALE);
			}
			
			
		}
		
		private function DrawLight(x:int, y:int, width:int, height:int):void
		{		
			img = new Sprite();
			
			//var tg:Sprite = new Sprite();
			// test thu xem
			img .graphics.beginFill(0x3399cc, 0.8);
			img .graphics.moveTo(4*width / 5, 0);
			img .graphics.lineTo(width, 0);
			img .graphics.lineTo(2*width / 5, height);
			img .graphics.lineTo(0, height);
			img .graphics.lineTo(4*width / 5, 0);
			img .graphics.endFill();

			
			RegPoint = new Point(4.5 * width / 5, 0);		
		}
		
		public function ScaleTo(scale:Number):void
		{
			TargetScale = scale;
		}
		
		public function ChangeLight():void
		{
			if (CurScale == MIN_SCALE)
			{
				ScaleTo(MAX_SCALE);
				SetPos(Ultility.RandomNumber(100, 1000), img.y);
			}
			else
			{
				ScaleTo(MIN_SCALE);
			}
		}
		
		private function DoTransform():void
		{
			//img.getChildAt(0).transform.matrix = new Matrix(CurScale, 0, 0, 1, -CurScale*RegPoint.x, 0);// -RegPoint.x, -RegPoint.y);
			
			//var eff:BlurFilter = new BlurFilter((1-CurScale)*100,(1-CurScale)*100, 2);
			//img.filters = [eff];
			img.alpha = CurScale;
		}
		
		public function UpdateLightSize():void
		{
			// update scale
			var d:Number;
			var tg:Number = CurScale;
			if (tg < TargetScale)
			{
				d = SCALE_PER_FRAME;
				tg += d;
				if (tg > TargetScale)
				{
					CurScale = TargetScale;
					DoTransform();
					ChangeLight();
					return;
				}
			}
			
			if (tg > TargetScale)
			{
				d = -SCALE_PER_FRAME;
				tg += d;
				if (tg < TargetScale)
				{
					CurScale = TargetScale;
					DoTransform();
					ChangeLight();
					return;
				}
			}
			
			CurScale += d;
			DoTransform();
		}
		
	}

}