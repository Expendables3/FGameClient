package Event.EventHalloween.HalloweenLogic 
{
	import flash.geom.Point;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemHalloweenInfo extends AbstractGift 
	{
		static public const MAX_X:int = 10;
		static public const MAX_Y:int = 10;
		static public const ROAD:int = 0;		//là đường đi
		static public const LAND:int = 1;		//là biên
		static public const FREEZE:int = 2;		//là phần đất bên trong
		static public const WHITE:int = 1;		//nút này chưa thăm
		static public const GRAY:int = 2;		//nút này đã thăm nhưng chưa duyệt xong
		static public const BLACK:int = 3;		//thăm và duyệt xong
		
		private var _thick:int;
		private var _before:Point;			//tọa độ điểm đi trước trong đường đi ngắn nhất
		private var _gcolor:int;			//màu của node trên đồ thị
		public var isBound:Boolean = false;
		public var isTrick:Boolean = false;
		public function ItemHalloweenInfo() 
		{
			ClassName = "ItemHalloweenInfo";
		}
		/*getter*/
		public function get Thick():int 
		{
			return _thick;
		}
		public function get Before():Point
		{
			return _before;
		}
		public function get GColor():int
		{
			return _gcolor;
		}
		
		/*setter*/
		public function set Thick(value:int):void 
		{
			_thick = value;
		}
		public function set Before(value:Point):void
		{
			_before = value;
		}
		public function set GColor(value:int):void
		{
			if (value == BLACK || value == GRAY || value == WHITE)
			{
				_gcolor = value;
			}
			else
			{
				_gcolor = 0;
			}
		}
		override public function getImageName():String 
		{
			if (_itemType == "End" && _itemId == 1)
			{
				if (HalloweenMgr.getInstance().HasKey)
				{
					return "GuiHalloween_ImgUnlockKey";
				}
			}
			return "GuiHalloween_" + _itemType + _itemId;
		}
		override public function setInfo(data:Object):void 
		{
			for (var itm:String in data)
			{
				if (itm != "GroupGiftId")
				{
					this[itm] = data[itm];
				}
			}
		}
	}

}























