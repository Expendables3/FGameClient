package Effect 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author ducnh
	 */
	public class ImgEffectBlink extends ImageEffect
	{
		private var nDelay:int;
		private var nPlay:int;
		private var OldColorTransform:ColorTransform;
		
		public function ImgEffectBlink(Image:DisplayObject) 
		{
			super(Image);
			OldColorTransform = img.transform.colorTransform;
		}
		
		public function SetInfo(nFramePlay:int, nFramDelay:int):void
		{
			nPlay = nFramePlay;
			nDelay = nFramDelay;
		}
		
		public override function OnUpdateEffect():void
		{
			nPlay--;
			if ((nPlay/nDelay) % 2 == 0)
			{
				Blink(true);
			}
			else
			{
				Blink(false);
			}
			if (nPlay == 0)
			{
				img.transform.colorTransform = OldColorTransform;
				FinishEffect();
			}
		}
		
		private function Blink(dark:Boolean):void
		{
			var c:ColorTransform ;
			if (dark)
			{
				c = new ColorTransform(0.4, 0.4, 0.4, 1);				
			}
			else
			{
				c = new ColorTransform(1, 0.8, 0.3 , 1);
				c.redOffset   = 100;
				c.greenOffset = 100;
				c.blueOffset  = 100;
			}
			img.transform.colorTransform = c;
		}
		
	}

}