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
	public class FireEmit
	{
		public var emit1:Emitter;
		public var emit2:Emitter;	
		public var emit3:Emitter;	
		public var emit4:Emitter;	
		public var emit5:Emitter;
		public var pos:Point = new Point();		
		
		public function FireEmit(Parent:Object, pos:Point) 
		{
			emit1 = new Emitter(Parent);
			emit2 = new Emitter(Parent);
			emit3 = new Emitter(Parent);
			emit4 = new Emitter(Parent);
			emit5 = new Emitter(Parent);
			pos = pos;			
			
			emit5.pos = new Point(pos.x + 25, pos.y);
			emit5.posTolerance = new Point(20, 10);
			emit5.vel = new Point(1, -1);
			emit5.forceTotal = new Point(0,-0.15);
			emit5.fade = -0.04;
			emit5.lifeTime = 1000;
			emit5.rotation = 3;
			emit5.rotationTolerance = 2;
			emit5.velTolerance = new Point(1, 1);
			emit5.spawnCount = 3;
			emit5.timeBaseNum = 0;
			
			emit1.pos = new Point(pos.x - 25, pos.y);
			emit1.posTolerance = new Point(20, 10);
			emit1.vel = new Point(-1, -1);
			emit1.forceTotal = new Point(0,-0.15);
			emit1.fade = -0.04;
			emit1.lifeTime = 1000;
			emit1.rotation = -3;
			emit1.rotationTolerance = 2;
			emit1.velTolerance = new Point(1, 1);
			emit1.spawnCount = 3;
			emit1.timeBaseNum = 0;		
			
			emit3.pos = new Point(pos.x + 15, pos.y);
			emit3.posTolerance = new Point(20, 10);
			emit3.vel = new Point(0.5, -2);
			emit3.forceTotal = new Point(0,-0.1);
			emit3.fade = -0.03;
			emit3.lifeTime = 1500;
			emit3.rotationTolerance = 4;
			emit3.velTolerance = new Point(1, 1);
			emit3.spawnCount = 4;
			emit3.timeBaseNum = 0;		
			
			emit2.pos = new Point(pos.x - 15, pos.y);
			emit2.posTolerance = new Point(20, 10);
			emit2.vel = new Point(-0.5, -2);
			emit2.forceTotal = new Point(0,-0.1);
			emit2.fade = -0.03;
			emit2.lifeTime = 1500;
			emit2.rotationTolerance = 4;
			emit2.velTolerance = new Point(1, 1);
			emit2.spawnCount = 4;
			emit2.timeBaseNum = 0;		
			
			emit4.pos = new Point(pos.x, pos.y + 3)
			emit4.posTolerance = new Point(20, 10);
			emit4.vel = new Point(0, -2);
			emit4.forceTotal = new Point(0,-0.1);
			emit4.fade = -0.025;
			emit4.lifeTime = 1500;
			emit4.rotationTolerance = 4;
			emit4.velTolerance = new Point(1, 1);
			emit4.spawnCount = 5;
			emit4.timeBaseNum = 0;		
		}
		
		public function pushImgList(img:Sprite):void
		{
			emit1.imgList.push(img);
			emit2.imgList.push(img);
			emit3.imgList.push(img);
			emit4.imgList.push(img);
			emit5.imgList.push(img);
		}
		
		public function updateEmit():void
		{
			emit1.updateEmitter();
			emit2.updateEmitter();
			emit3.updateEmitter();
			emit4.updateEmitter();
			emit5.updateEmitter();
		}
		
	}

}