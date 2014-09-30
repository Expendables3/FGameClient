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
	public class TailEmit extends Emitter 
	{
		
		public function TailEmit(Parent:Object, objImg:Sprite) 
		{
			super(Parent);
			pos = new Point(objImg.x, objImg.y);
			vel = new Point( 0, 0);
			fade = -0.05;		
			spawnCount = 1;
			spawnTime = 1000;
			scale = new Point( -0.07, -0.07);
			timeBaseNum = 0;
			imgList.push(objImg);
		}
		
	}

}