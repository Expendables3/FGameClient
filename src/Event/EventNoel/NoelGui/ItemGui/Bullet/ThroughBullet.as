package Event.EventNoel.NoelGui.ItemGui.Bullet 
{
	import Event.EventNoel.NoelLogic.ItemInfo.BulletInfo;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ThroughBullet extends Bullet 
	{
		private var numThrough:int;
		public function ThroughBullet(parent:Object, bulletInfo:BulletInfo, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, bulletInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "ThroughBullet";
			_accelleration = 0.8;
			_startSpeed = 20;
			numThrough = 5;
		}
		override public function IsRemoveAfterCollision():Boolean 
		{
			return --numThrough == 0;
		}
	}

}