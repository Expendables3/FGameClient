package Effect 
{
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author ducnh
	 */
	public class ImgEffectScaleDown extends ImageEffect 
	{
		private var Scale:Number = -0.05;
		public function ImgEffectScaleDown(Image:DisplayObject) 
		{
			super(Image);
			Image.scaleX = 1;
			Image.scaleY = 1;
		}
		
		public override function OnUpdateEffect():void
		{
			img.scaleY += Scale;
			img.scaleX -= Scale;
			if (img.scaleY < 0.8)
			{
				Scale = -Scale;
			}
			if (img.scaleY >= 1)
			{
				img.scaleY = 1;
				img.scaleX = 1;
				FinishEffect();
			}
		}
		
	}

}