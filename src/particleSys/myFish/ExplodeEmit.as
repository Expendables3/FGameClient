package particleSys.myFish 
{
	import Data.ResMgr;
	import flash.geom.Point;
	import particleSys.Emitter;
	import particleSys.Particle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ExplodeEmit extends Emitter 
	{
		public var thresold_X1:int = 0;
		public var thresold_X2:int = 0;
		public var thresold_Y1:int = 0;
		public var thresold_Y2:int = 0;
		
		public function ExplodeEmit(Parent:Object) 
		{
			super(Parent);
			setPos(350, 200);
			posTolerance = new Point(40, 40)
			vel = new Point(0, -20);
			velTolerance = new Point(10, 10);
			forceTotal = new Point(0, 1);
			//friction = 0.05;
			fade = -0.003;	
			scaleOrg = new Point(1.7, 1.7);
			spawnCount = 250;			
			//lifeTime = 2000;
			spawnTime = 400;
			
			thresold_Y1 = 15;
			thresold_Y2 = 400;
			thresold_X1 = 20;
			thresold_X2 = 795;
			
			imgList.push(ResMgr.getInstance().GetRes("Particle0"));
			imgList.push(ResMgr.getInstance().GetRes("Particle1"));
			imgList.push(ResMgr.getInstance().GetRes("Particle3"));
		}
		
		
		override public function updateEmitter():void 
		{
			super.updateEmitter();
			var particle:Particle;			
			for (var i:int = 0; i < particleList.length; i++) 
			{
				particle = particleList[i] as Particle;				
				if (thresold_Y2 > 0 && !particle.flag1 && particle.pos.y > thresold_Y2)
				{
					particle.vel.y = -0.8*particle.vel.y;
							
				}
				else if (thresold_Y1 > 0 && !particle.flag1 && particle.pos.y < thresold_Y1)
				{
					particle.vel.y = -0.5* particle.vel.y;
							
				}
				
				if (thresold_X1 > 0 && !particle.flag1 && particle.pos.x < thresold_X1)
				{
					particle.vel.x = -particle.vel.x;
							
				}				
				else if (thresold_X2 > 0 && !particle.flag1 && particle.pos.x > thresold_X2)
				{
					particle.vel.x = -particle.vel.x;
							
				}				
			}
		}
	}

}