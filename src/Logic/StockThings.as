package Logic 
{
	/**
	 * ...
	 * @author tuan
	 */
	public class StockThings extends BaseObject
	{
		public var ItemType:String;
		public var Id:int;
		public var Num:int;
		
		
		public function StockThings(parent:Object = null, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		}		
	}

}