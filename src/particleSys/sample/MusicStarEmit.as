package particleSys.sample 
{
	import Data.ResMgr;
	import flash.geom.Point;
	import particleSys.Emitter;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class MusicStarEmit extends Emitter
	{
		
		public function MusicStarEmit(Parent:Object) 
		{
			super(Parent);
			posTolerance = new Point(10, 10);
			vel = new Point( 0, 0.7);
			//velTolerance = new Point(0.3, 0.3);
			friction = 0.05;
			fade = -0.1;	
			lifeTime = 1000;
			timeBaseNum = 100;
			spawnCount = 1;									
			imgList.push(ResMgr.getInstance().GetRes("sao"));
		}
		
	}

}