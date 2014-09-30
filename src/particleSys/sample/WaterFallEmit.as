package particleSys.sample
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.geom.Point;
	import particleSys.Emitter;
	import particleSys.Particle;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class WaterFallEmit extends Emitter 
	{
		public var thresold_1:int = 0;
		public var thresold_2:int = 0;
		public var thresold_3:int = 0;
		
		public function WaterFallEmit(Parent:Object) 
		{
			super(Parent);
			pos = new Point(400, 150);
			//posTolerance = new Point(5, 5);			
			vel = new Point(0, -4);
			velTolerance = new Point(1, 2);
			forceTotal = new Point(0, 0.1);
			//fade = -0.0001;		
			spawnCount = 2;
			//spawnTime = 1000;
			//nextTime = 5000;	
			timeBaseNum = 0;
			thresold_1 = 250;
			thresold_2 = 350;
			thresold_3 = 450;					
				
			
			onBeginNextSpawn();
		}
		
		override public function updateEmitter():void 
		{
			super.updateEmitter();
			var particle:Particle;			
			for (var i:int = 0; i < particleList.length; i++) 
			{
				particle = particleList[i] as Particle;				
				if (thresold_1 > 0 && !particle.flag1 && particle.pos.y > thresold_1)
				{
					particle.vel.y = -0.4* particle.vel.y;
					particle.flag1 = true;					
				}
				if (thresold_2 > 0 && !particle.flag2 && particle.pos.y > thresold_2)
				{
					particle.vel.y = -0.4 * particle.vel.y;
					particle.flag2 = true;					
				}
				if (thresold_3 > 0 && !particle.flag3 && particle.pos.y > thresold_3)
				{
					particle.vel.y = -0.4 * particle.vel.y;
					particle.flag3 = true;					
				}
			}
		}
		
		override public function onBeginNextSpawn():void 
		{
			imgList.splice(0, imgList.length);
			for (var i:int = 0; i < 10; i++) 
			{
				var img:Sprite = new Sprite();
				img.graphics.beginFill(Math.random()*16777215)
				img.graphics.drawCircle(0, 0, 5);
				img.graphics.endFill();
				imgList.push(img);
			}		
		}
		
		
	}

}