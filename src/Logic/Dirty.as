package Logic 
{
	/**
	 * ...
	 * @author ducnh
	 */
	public class Dirty extends BaseObject
	{
		public var IsCleaning:Boolean = false;
		
		public function Dirty(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP)
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "Dirty";
		}		
	}

}