package Event.EventNoel.NoelGui.ItemGui.Bullet 
{
	import Event.EventNoel.NoelLogic.ItemInfo.BulletInfo;
	
	/**
	 * Đạn Trùm
	 * @author HiepNM2
	 */
	public class CoverBullet extends Bullet 
	{
		
		public function CoverBullet(parent:Object, bulletInfo:BulletInfo, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, bulletInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "CoverBullet";
			_accelleration = 0.6;
			_startSpeed = 20;
		}
		
	}

}