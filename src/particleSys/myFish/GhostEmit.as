package particleSys.myFish 
{
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.geom.Point;
	import Logic.Fish;
	import particleSys.Emitter;
	
	/**
	 * Tạo bóng mờ khi chuyển động
	 * @author longpt
	 */
	public class GhostEmit extends Emitter 
	{		
		public function GhostEmit(Parent:Object, f:Fish, OrientX:int,isMagnet:Boolean=false) 
		{
			super(Parent);
			fade = -0.04;
			scale = new Point(-0.015, -0.015);
			timeBaseNum = 0;
			spawnCount = 0.3;		
			var sp:Sprite;
			if (!isMagnet)
			{
				sp= ResMgr.getInstance().GetRes(Fish.ItemType + f.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE) as Sprite;
			}
			else
			{
				fade = -0.04;
				scale = new Point(-0.04, -0.04);
				timeBaseNum = 0;
				spawnCount = 1;	
				sp= ResMgr.getInstance().GetRes("IconBallNamCham") as Sprite;
			}
			imgList.push(sp);
		}
		
		public override function updateEmitter():void
		{
			super.updateEmitter();			
		}
		
		public override function destroy():void
		{
			super.destroy();
		}
	}

}