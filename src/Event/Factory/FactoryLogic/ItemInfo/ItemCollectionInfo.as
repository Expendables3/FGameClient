package Event.Factory.FactoryLogic.ItemInfo 
{
	import Event.EventNoel.NoelLogic.ItemInfo.BulletInfo;
	import Event.EventNoel.NoelLogic.ItemInfo.CandyInfo;
	import Event.EventNoel.NoelLogic.ItemInfo.NoelItemInfo;
	import Event.EventTeacher.ItemTeacherInfo;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemCollectionInfo extends AbstractGift 
	{
		static public const EventName:String = "EventNoel";
		
		protected var _num:int;
		public function ItemCollectionInfo() 
		{
			
		}
		/**
		 * hàm tạo ra các thông tin của item cho từng event
		 * @param	type
		 * @return
		 */
		static public function createItemInfo(type:String):ItemCollectionInfo
		{
			switch(type)
			{
				case "Candy":
					return new CandyInfo(type);
				case "Bullet":
				case "RainIce":
				case "Bomb":
				case "BulletGold":
					return new BulletInfo(type);
				case "NoelItem":
					return new NoelItemInfo(type);
				case "Combo":
					return new ItemTeacherInfo(type);
				case "ColPItem":
				case"ColPGGift":
					return new ItemTeacherInfo(type);
			}
			return new ItemCollectionInfo();
		}
		/**
		 * hàm lấy tên ảnh mặc định
		 * @return
		 */
		override public function getImageName():String 
		{
			return EventName + "_" + _itemType + _itemId;
		}
		/**
		 * hàm lấy tooltip mặc định
		 * @return
		 */
		override public function getTooltipText():String 
		{
			return EventName + "_" + _itemType + _itemId;
		}
		
		public function get Num():int 
		{
			return _num;
		}
		public function set Num(value:int):void 
		{
			_num = value;
		}
		override public function setInfo(data:Object):void 
		{
			for (var itm:String in data)
			{
				try
				{
					this[itm] = data[itm];
				}
				catch (err:Error)
				{
					trace("không có thuộc tính " + itm + " trong lớp " + ClassName);
				}
				
			}
		}
	}

}
















