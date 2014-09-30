package Logic.LogicGift 
{
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	import GUI.ItemGift.EquipmentMask;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class AbstractGift 
	{
		public var ClassName:String;
		protected var _itemType:String;
		protected var _itemId:int;
		
		public function AbstractGift() 
		{
			ClassName = "AbstractGift";
		}
		public virtual function setInfo(data:Object):void{}
		public virtual function getImageName():String {
			return "";
		}
		public virtual function getItemName():String {
			return "";
		}
		public virtual function getTooltipText():String { return ""; }
		public static function createGift(type:String):AbstractGift
		{
			switch(type)
			{
				case "Weapon":
				case "Armor":
				case "Helmet":
				case "Ring":
				case "Necklace":
				case "Belt":
				case "Bracelet":
				case "Bracelet":
				case "Seal":
				case "JewelChest":
				case "EquipmentChest":
				case "AllChest":
					return new GiftSpecial();
				case "Mask":
					return new EquipmentMask();
				case "NoelItem":
					return ItemCollectionInfo.createItemInfo(type);
				case "QWhite":
				case "QGreen":
				case "QYellow":
				case "QPurple":
				case "QVIP":
					return new GiftQuad();
				default:
					return new GiftNormal();
			}
		}
		
		public function get ItemType():String 
		{
			return _itemType;
		}
		
		public function set ItemType(value:String):void 
		{
			_itemType = value;
		}
		
		public function get ItemId():int 
		{
			return _itemId;
		}
		
		public function set ItemId(value:int):void 
		{
			_itemId = value;
		}
	}

}