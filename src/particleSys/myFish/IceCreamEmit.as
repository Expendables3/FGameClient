package particleSys.myFish 
{
	import Data.ResMgr;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import particleSys.Emitter;
	
	/**
	 * ...
	 * @author ...
	 */
	public class IceCreamEmit extends Emitter 
	{
		
		public function IceCreamEmit(Parent:Object) 
		{
			super(Parent);
			setPos(405, 175);
			posTolerance = new Point(305, 0);
			vel = new Point(-1, 5);
			velTolerance = new Point(2, 1);
			forceTotal = new Point(0, 0);
			fade = 0.005;	
			fadeTolerance = 0.005;
			rotation = 3;
			rotationTolerance = -6;
			spawnCount = 70;			
			spawnTime = -1;
			nextTime = 0;
			lifeTime = 3000;
			lifeTimeTolerance = 0;
			scaleOrg = new Point(0.2, 0.2);
			existArea = new Rectangle(100, 175, 620, 200);
			
			imgList.push(ResMgr.getInstance().GetRes("IceCream0"));
			imgList.push(ResMgr.getInstance().GetRes("IceCream1"));
			imgList.push(ResMgr.getInstance().GetRes("IceCream2"));
		}
		
		public function changeToHeavy():void 
		{
			spawnCount = 200;
			vel = new Point( -1, 15);
			fade = 0.02;
		}
		
		public function BackToNormal():void 
		{
			spawnCount = 50;
			vel = new Point( -1, 5);
			fade = 0.005;
		}
	}

}