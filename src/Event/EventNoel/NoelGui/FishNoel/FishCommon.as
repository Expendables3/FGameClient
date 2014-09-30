package Event.EventNoel.NoelGui.FishNoel 
{
	import Event.Factory.FactoryGui.ItemGui.FishAbstract;
	import Event.Factory.FactoryLogic.ItemInfo.FishAbstractInfo;
	import flash.geom.Point;
	import Logic.Ultility;
	
	/**
	 * con cá common
	 * @author HiepNM2
	 */
	public class FishCommon extends FishAbstract 
	{
		public function FishCommon(parent:Object, fishInfo:FishAbstractInfo, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, fishInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "FishCommon";
			_realMaxSpeed = 2;// Ultility.RandomNumber(1, 4);
		}
		
		/**
		 *  bơi theo vòng tròn
		 * @param	center tâm vòng tròn
		 * @param	radius bán kính
		 */
		public function swimRound(center:Point, radius:Number):void
		{
			var vtRadius:Point = new Point(CurPos.x - center.x, CurPos.y - center.y);
			var sin:Number = (CurPos.y - center.y) / vtRadius.length;
			var cos:Number = (CurPos.x - center.x) / vtRadius.length;
			var vx:Number = -_speed *sin;
			var vy:Number = _speed * cos;
			CurPos.x += vx;
			CurPos.y += vy;
			img.x = CurPos.x;
			img.y = CurPos.y;
			var alpha:Number = Math.acos(cos) * 180 / Math.PI;
			var asign:int = sin > 0 ? 1 : -1;
			img.rotation = 90 + asign * alpha;
		}
		
		override public function swimRandom():void 
		{
			swim();
		}
		override public function effBleed():void 
		{
			super.effBleed();
		}
	}

}

















