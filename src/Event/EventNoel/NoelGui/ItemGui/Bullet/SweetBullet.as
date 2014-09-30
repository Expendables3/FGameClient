package Event.EventNoel.NoelGui.ItemGui.Bullet 
{
	import Event.EventNoel.NoelLogic.ItemInfo.BulletInfo;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class SweetBullet extends Bullet 
	{
		
		public function SweetBullet(parent:Object, bulletInfo:BulletInfo, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, bulletInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "SweetBullet";
			_accelleration = 0.5;
			_startSpeed = 20;
		}
		
	}

}