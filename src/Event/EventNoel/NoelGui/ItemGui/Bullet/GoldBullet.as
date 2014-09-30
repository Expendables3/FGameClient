package Event.EventNoel.NoelGui.ItemGui.Bullet 
{
	import Event.EventNoel.NoelLogic.ItemInfo.BulletInfo;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GoldBullet extends Bullet 
	{
		
		public function GoldBullet(parent:Object, bulletInfo:BulletInfo, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, bulletInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "GoldBullet";
			_accelleration = 1;
			_startSpeed = 20;
		}
		
	}

}