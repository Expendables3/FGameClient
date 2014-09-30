package Effect 
{
	import flash.display.DisplayObject;
	import GUI.component.Image;
	import Logic.Layer;
	import Logic.LayerMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ImgEffectFly extends ImageEffect 
	{
		public var fromX:int;
		public var fromY:int;
		public var toX:int;
		public var toY:int;
		public var speed:Number;
		public var fadeSpeed:Number;
		public var friction:Number;
		public var distance:Number;
		public var angle:Number;
		public var image:DisplayObject;		
		public var Parent:Object;
		public var func:Function;
		public var reUse:Boolean;
		
		public function ImgEffectFly(image:DisplayObject, Parent:DisplayObject, f:Function = null) 
		{			
			this.image = image;
			this.func = f;
			if (!Parent)			
			{
				this.Parent = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER + 1);				
				this.Parent.addChild(image);
			}
			else
			{
				this.Parent = Parent;
				this.Parent.addChild(image);
			}
		}
		
		/**
		 * 
		 * @param	fromX  		Tọa độ x của điểm nguồn
		 * @param	fromY		Tọa độ y của điểm nguồn
		 * @param	toX			Tọa độ x của điểm đích
		 * @param	toY			Tọa độ y của điểm đích
		 * @param	speed		Tốc độ bay
		 * @param	FadeSpeed	Tốc độ fade ( <0 thì mờ dần, >0 thì đậm dần)
		 * @param	Friction	Ma sát, khi đến điểm đích thì di chuyển chậm dần
		 */
		public function SetInfo(fromX:int, fromY:int, toX:int, toY:int, speed:Number, FadeSpeed:Number = -0.05, Friction:Number = 0, reUse:Boolean = false):void
		{			
			image.x = fromX;
			image.y = fromY;
			this.fromX = fromX;
			this.fromY = fromY;
			this.toX = toX;
			this.toY = toY;
			this.speed = speed;
			fadeSpeed = FadeSpeed;
			friction = Friction;
			this.reUse = reUse;
			
			distance = Math.sqrt((toX - fromX) * (toX - fromX) + (toY - fromY) * (toY - fromY));
			angle = Math.acos((toX - fromX) / distance);
		}
		
		public override function OnUpdateEffect():void
		{		
			if (IsFinish)
			{
				return;
			}
			
			if (distance != 0)
			{			
				if (distance <= Math.sqrt((image.x - fromX) * (image.x - fromX) + (image.y - fromY) * (image.y - fromY)))
				{
					image.alpha += fadeSpeed;
					speed *= friction;
					image.x = image.x + speed * Math.cos(angle);
					image.y = image.y - speed * Math.sin(angle);
				}
				else
				{
					image.x = image.x + speed * Math.cos(angle);
					image.y = image.y - speed * Math.sin(angle);	
				}
			}
			else
			{
				image.alpha += fadeSpeed;
			}
			
			//trace(Math.sqrt((Image.x - fromX) * (Image.x - fromX) + (Image.y - fromY) * (Image.y - fromY)));
			if (fadeSpeed < 0 && image.alpha <= 0)
			{
				finishEffect();
			}
			if (fadeSpeed > 0 && image.alpha >= 1)
			{
				finishEffect();
			}
		}
		
		public function finishEffect():void
		{
			//imageSet.img.visible = false;
			if (!reUse && image && image.parent == Parent)
			{
				Parent.removeChild(image);
				image = null;
			}
			IsFinish = true;				
			if (func != null)
			{
				func();
			}
			//trace("xongggg", distance);
		}
	}

}