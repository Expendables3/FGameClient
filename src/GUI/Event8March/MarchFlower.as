package GUI.Event8March 
{
	import flash.events.MouseEvent;
	import Logic.BaseObject;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class MarchFlower extends BaseObject 
	{
		private var _level:int;
		
		private static const _x:int;			//tọa độ đối với guimain
		private static const _y:int;
		public function MarchFlower(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "MarchFlower";
		}
		/**
		 * move chuột qua "cây hoa": thực hiện hiển thị tooltip
		 * @param	event
		 */
		override public function OnMouseOver(event:MouseEvent):void 
		{
			
		}
		/**
		 * di chuột ra khỏi "cây hoa" ẩn tooltip đi
		 * @param	event
		 */
		override public function OnMouseOut(event:MouseEvent):void 
		{
			
		}
		/**
		 * click vào "cây hoa" thực hiện check để click
		 * @param	event
		 */
		override public function OnMouseClick(event:MouseEvent):void 
		{
			
		}
	}

}