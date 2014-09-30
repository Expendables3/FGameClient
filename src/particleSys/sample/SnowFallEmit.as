package particleSys.sample 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import particleSys.Emitter;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class SnowFallEmit extends Emitter 
	{
		
		public function SnowFallEmit(Parent:Object) 
		{
			super(Parent);
			pos = new Point(stage.stageWidth / 2, - 10);			
			posTolerance = new Point(stage.stageWidth + 200, 20);
			existArea = new Rectangle( -250, -30, stage.stageWidth + 250, stage.stageHeight + 30);
			vel = new Point(2, 3);
			velTolerance = new Point(0.5, 2);
			forceTotal = new Point(0, 0);
			spawnCount = 3;
			timeBaseNum = 0;
			//blur = new Point(2, 2);
			
			var img:Sprite = new Sprite();
			img.graphics.beginFill(0x55af33)
			img.graphics.drawCircle(0, 0, 5);
			img.graphics.endFill();
			imgList.push(img);
		}
		
	}

}