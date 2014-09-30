package particleSys.sample 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import particleSys.Emitter;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class TestEmit extends Emitter 
	{
		public function TestEmit((Parent:Object) 
		{
			super(Parent);
			pos = new Point(stage.stageWidth / 2, stage.stageHeight / 2);
			posTolerance = new Point(5, 5);
			vel = new Point(3, 0);
			forceTotal = new Point(0,-0.2);
			fade = -0.03;
			lifeTime = 1000;
			//lifeTimeTolerance = 50;
			//forceTotal = new Point(0, 0.15);
			//friction = 0.015;
			velTolerance = new Point(1, 1);
			spawnCount = 1;
			timeBaseNum = 0;
			
			for (var i:int = 0; i < 10; i++) 
			{
				var img:Sprite = new Sprite();
				img.graphics.beginFill(Math.random()*16777215)
				img.graphics.drawRect(0, 0, 10, 10);
				img.graphics.endFill();
				imgList.push(img);
			}		
			
			//var img:Sprite = new Fire();
			//imgList.push(img);
		}
		
	}

}