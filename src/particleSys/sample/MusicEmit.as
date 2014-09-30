package particleSys.sample
{
	import Data.ResMgr;
	import flash.display.Stage;
	import flash.geom.Point;	
	import particleSys.Emitter;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class MusicEmit extends Emitter
	{
		
		public function MusicEmit(Parent:Object, Music1:String = "music1", Music2:String = "music2", Music3:String = "music3") 
		{
			super(Parent);
			posTolerance = new Point(10, 10);
			vel = new Point( 0, 0);
			velTolerance = new Point(1, 1);
			forceTotal = new Point(0, -0.2);
			friction = 0.05;
			fade = -0.020;	
			lifeTime = 1700;
			timeBaseNum = 400;
			spawnCount = 2;			
			spawnTime = 1000;
			nextTime = Math.random()*3000 + 4000;
			scaleOrg = new Point(0.6, 0.6);
			scale = new Point( 0.015, 0.015);
			imgList.push(ResMgr.getInstance().GetRes(Music1));
			imgList.push(ResMgr.getInstance().GetRes(Music2));
			imgList.push(ResMgr.getInstance().GetRes(Music3));
		}		
				
	}

}