package particleSys.myFish
{
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.geom.Point;
	import particleSys.Emitter;
	
	/**
	 * ...Chuyên dùng để bắn chưởng
	 * @author 
	 */
	public class CometEmit extends Emitter 
	{
		public var sp:Sprite = new Sprite();
		
		public function CometEmit(Parent:Object) 
		{
			super(Parent);
			velTolerance = new Point(3, 3);
			//friction = 0.05;
			fade = -0.07;	
			scaleOrg = new Point(1.7, 1.7);
			timeBaseNum = 0;
			spawnCount = 7;									
			//imgList.push(ResMgr.getInstance().GetRes("Particle0"));
			//imgList.push(ResMgr.getInstance().GetRes("Particle1"));
			//imgList.push(ResMgr.getInstance().GetRes("sao"));
		}		
		
		public override function updateEmitter():void
		{
			super.updateEmitter();
			setPos(sp.x, sp.y);
		}
		
		public override function destroy():void
		{
			super.destroy();
			sp = null;
		}
		
		
	}
}