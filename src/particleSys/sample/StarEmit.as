package particleSys.sample 
{
	import Data.ResMgr;
	import flash.geom.Point;
	import particleSys.Emitter;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class  StarEmit extends Emitter
	{
		
		public function StarEmit(Parent:Object)
		{
			super(Parent);
			posTolerance = new Point(20, 15);
			vel = new Point( 0, 0);
			velTolerance = new Point(0.5, 0.5);
			friction = 0.05;
			fade = -0.03;	
			timeBaseNum = 0;
			spawnCount = 0.7;									
			imgList.push(ResMgr.getInstance().GetRes("sao"));
		}
		
	}

}