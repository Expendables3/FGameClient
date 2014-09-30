package Event.EventNoel.NoelGui.Team 
{
	import Event.Factory.FactoryGui.ItemGui.ImgObject;
	import flash.geom.Point;
	
	/**
	 * Vùng chứa con boss và 2 team di chuyển tròn
		* Vùng này có thể di chuyển
	 * @author HiepNM2
	 */
	public class GuiBossTeam extends ImgObject 
	{
		public function GuiBossTeam(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
		}
		override public function update():Boolean 
		{
			if (_reachDes)
			{
				return false;
			}
			var temp:Point = _desPos.subtract(CurPos);
			if (temp.length < _speedVec.length)
			{
				_reachDes = true;
				return false;
			}
			CurPos = CurPos.add(_speedVec);
			img.x = CurPos.x; 
			img.y = CurPos.y;
			return true;
		}
	}

}












