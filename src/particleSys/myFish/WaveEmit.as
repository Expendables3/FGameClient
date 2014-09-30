package particleSys.myFish 
{
	import Data.ResMgr;
	import flash.geom.Point;
	import particleSys.Emitter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class WaveEmit extends Emitter 
	{
		
		public function WaveEmit(Parent:Object) 
		{
			super(Parent);
			setPos(800, 250);
			posTolerance = new Point(0, 250);
			vel = new Point(-20, -2);
			velTolerance = new Point(15, 2);
			forceTotal = new Point(0, 0);
			fade = -0.05;	
			fadeTolerance = 0.05;
			rotation = 5;
			rotationTolerance = 10;
			spawnCount = 15;			
			spawnTime = 1000;
			nextTime = 2000;
			lifeTime = 1000;
			lifeTimeTolerance = 500;
			
			imgList.push(ResMgr.getInstance().GetRes("WaveEmit5"));
			imgList.push(ResMgr.getInstance().GetRes("WaveEmit4"));
			imgList.push(ResMgr.getInstance().GetRes("WaveEmit3"));
			imgList.push(ResMgr.getInstance().GetRes("WaveEmit2"));
			imgList.push(ResMgr.getInstance().GetRes("WaveEmit1"));
			imgList.push(ResMgr.getInstance().GetRes("WaveEmit0"));
		}
		
	}

}