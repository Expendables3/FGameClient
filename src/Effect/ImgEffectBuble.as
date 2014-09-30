package Effect 
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ImgEffectBuble extends ImageEffect 
	{
		private var OldScale:Number = 1;
		private var nPlay:int;
		private var max:Number;
		private var min:Number;
		private var scale:Number;
		private var IsZoom:Boolean;
		
		private var rate:Number = 0.1;	
		
		public function ImgEffectBuble(Image:DisplayObject) 
		{	
			super(Image);
			OldScale = 1;//Image.scaleX;
			scale = OldScale;
			IsZoom = true;			
		}
		
		public function SetInfo(min:Number, max:Number, nPlay:int = 1000, speed:Number = 1, align:String = ""):void
		{
			this.max = max;
			this.min = min;
			this.nPlay = nPlay;
			this.rate *= speed;
			scale = min;
		}
		
		public override function OnUpdateEffect():void
		{		
			nPlay--;
			if (IsZoom)
			{
				scale += rate;
				if (scale >= max)
				{
					scale == max;
					IsZoom = false;
				}
			}
			else
			{
				scale -= rate;
				if (scale <= min)
				{
					scale == min;
					IsZoom = true;
				}
			}
			if (nPlay > 0)
			{
				Bubble();
			}
			else
			{
				img.scaleX = img.scaleY = OldScale;
				FinishEffect();
			}
		}
		
		private function Bubble():void
		{
			img.scaleX = img.scaleY = scale;
		}
	}

}