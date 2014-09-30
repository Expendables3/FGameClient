package particleSys
{
	import adobe.utils.CustomActions;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author tuannm3
	 */
	public class Particle
	{
		public var pos:Point = new Point();					//Vi trí
		public var vel:Point = new Point();					//Vận tốc
		public var acc:Point = new Point();					//Gia tốc
		public var scale:Point = new Point();				//Tốc độ phóng to(thu nhỏ)
		public var rotattion:Number = 0;					//Tốc độ xoay
		public var fade:Number = 0;							//Độ mờ dần
		public var friction:Number = 0;						//Ma sát
		public var bornTime:Number = getTimer();			//Thời điểm sinh ra
		public var lifeTime:Number = -1						//Thời gian tồn tại		
		public var existArea:Rectangle = null;				//Vùng tồn tại
				
		
		//1 số thuộc tính dự trữ
		public var flag1:Boolean = false;
		public var flag2:Boolean = false;
		public var flag3:Boolean = false;
		public var flag4:Boolean = false;
		public var flag5:Boolean = false;

		public var image:Sprite;
		private var parent:Object;							//Content các hạt paritlce sẽ add trên đây
		public var myEmit:Emitter;							//Emitter sinh ra particle này
		public var emit:Emitter = null;						//Emitter đi theo particle này
		
		public function Particle(Image:Sprite, Parent:Object, MyEmit:Emitter)
		{
			image = new Sprite;
			
			var targetClass:Class = Object(Image).constructor;
			image = new targetClass() as Sprite;
			image.transform = Image.transform;
			image.filters = Image.filters;
			image.cacheAsBitmap = Image.cacheAsBitmap;
			image.opaqueBackground = Image.opaqueBackground;
			if (Image.scale9Grid)
			{
				var rect:Rectangle = Image.scale9Grid;			
				if (Capabilities.version.split(" ")[1] == "9,0,16,0"){
				//Flash 9 bug where returned scale9Grid as twips
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				}			
				image.scale9Grid = rect;
			}
			image.graphics.copyFrom(Image.graphics);
			image.mouseEnabled = false;
			parent = Parent;
			myEmit = MyEmit;
			parent.addChildAt(image, 0);
			//if (myEmit.minChildIndex > 0)
			//{
				//parent.addChildAt(image, myEmit.minChildIndex + 1);
				//
			//}
			//else
			//{
				//parent.addChild(image);
				//myEmit.minChildIndex = Math.max(0, parent.getChildIndex(image));
			//}			
		}
		
		public function updateParticle():void
		{
			vel = vel.add(acc);
			vel.x *= (1 - friction);
			vel.y *= (1 - friction);
			pos = pos.add(vel);			
			image.x = pos.x;
			image.y = pos.y;
			image.alpha += fade;	
			if (image.alpha >= 1) image.alpha = 1;
			image.scaleX += scale.x;
			image.scaleY += scale.y;
			image.rotation = (image.rotation + rotattion) % 360;
			if (image.alpha <= 0  || isOutOfStage() 
				|| image.scaleX <= 0 || image.scaleY <= 0
				|| (lifeTime != -1 && (getTimer() - bornTime > lifeTime)))
			{
				destroy();
			}
			
			if (emit != null)
			{
				emit.pos = pos;
				emit.updateEmitter();
			}
		}
		
		
		/**
		 * Kiểm tra xem hạt nằm trong hay nằm ngoài stage
		 * @return true nếu hạt nằm ngoài stage
		 */
		public function isOutOfStage():Boolean
		{
			if (existArea == null)
			{
				//return (pos.x < 0 || pos.x > image.stage.stageWidth || pos.y < 0 || pos.y > image.stage.stageHeight);
				return false;
			}
			else
			{
				return (pos.x < existArea.x || pos.x > existArea.right || pos.y < existArea.y || pos.y > existArea.bottom);
			}
		}
		
		
		/**
		 * Hàm hủy
		 */
		public function destroy():void
		{
			if (parent.contains(image))
			{
				parent.removeChild(image);
				myEmit.removeParticle(myEmit.particleList.indexOf(this));				
			}
			
			if (emit != null)
			{
				emit.destroy();
				emit = null;
			}
		}
		
	}

}