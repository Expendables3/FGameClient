package Effect 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ducnh
	 */
	public class ImageEffect
	{
		public var IsFinish:Boolean = false;
		public var img:DisplayObject;
		public var CallBack:Function = null;

		
		public function ImageEffect(Image:DisplayObject = null)
		{
			img = Image as DisplayObject;			
		}
		
		public function UpdateEffect():void
		{
			OnUpdateEffect();
		}
		
		public virtual function OnUpdateEffect():void
		{
		}
		
		public function FinishEffect():void
		{
			img = null;
			IsFinish = true;
		}
	
		
	}

}