package Logic.LogicGift 
{
	import Data.ConfigJSON;
	import Data.Localization;
	/**
	 * quà đặc biệt
	 * @author HiepNM2
	 */
	public class GiftSpecial extends AbstractGift
	{
		static public const EQUIPMENT:int = 0;
		static public const JEWELRY:int = 1;
		static public const SEAL:int = 2;
		static public const CHEST:int = 3;
		static public const NONE:int = 3;
		
		public static const FISH_EQUIP_COLOR_WHITE:int = 1;
		public static const FISH_EQUIP_COLOR_GREEN:int = 2;
		public static const FISH_EQUIP_COLOR_GOLD:int = 3;
		public static const FISH_EQUIP_COLOR_PINK:int = 4;
		public static const FISH_EQUIP_COLOR_VIP:int = 5;
		public static const FISH_EQUIP_COLOR_6:int = 6;
		//public var Id:int;
		private var _element:int = -1;
		private var _rank:int;
		//public var Type:String;
		//public var Rank:int;
		public var Color:int;
		public var Damage:int;
		public var Defence:int;
		public var Critical:int;
		public var Health:int;
		public var Vitality:int;
		public var EnchantLevel:int;
		public var bonus:Array;
		public var StartTime:Number;
		public var Durability:int;
		public var Source:int;
		public var IsUsed:Boolean;
		public var Author:Object;
		public var Num:int;
		//public var Primitive:Object;
		
		public function set Type(value:String):void
		{
			_itemType = value;
		}
		public function set Id(value:int):void
		{
			_itemId = value;
		}
		public function set Rank(value:int):void
		{
			_rank = value;
		}
		public function get Rank():int
		{
			return _rank;
		}
		override public function getImageName():String 
		{
			var imgName:String;
			switch (_itemType)
			{
				case "Ring":
					if (_rank == 1)
					{
						if (Color == 5)
						{
							imgName = "RingDragon_Shop";
						}
						else if (Color == 6)
						{
							imgName = "RingPhoenix_Shop";
						}
						else 
						{
							imgName = _itemType + _rank + "_Shop";
						}
					}
					else 
					{
						imgName = _itemType + _rank + "_Shop";
					}
				break;
				case "EquipmentChest":
				case "AllChest":
				case "JewelChest":
					if (Color == 5 || Color == 6)
					{
						imgName = _itemType + "6_" + _itemType;
					}
					else
					{
						imgName = _itemType + Color + "_" + _itemType;
					}
				break;
				case "Weapon"://Equipment
				case "Helmet":
				case "Armor":
					var iElementRank:int = 100 * _element + _rank;
					imgName = _itemType + iElementRank + "_Shop";
					break;
				default://jewelry
					imgName = _itemType + _rank + "_Shop";
			}
			return imgName;
		}
		
		override public function getTooltipText():String 
		{
			var name:String = Localization.getInstance().getString("Equipment" + _itemType);
			var colorName:String = getColorName();
			var rankName:String = getRankName();
			return name + "\n" + rankName + " " + colorName + " cấp " + _rank;
		}
		
		public function getElementName():String
		{
			return Localization.getInstance().getString("Element" + _element);
		}
		public function getColorName():String
		{
			return Localization.getInstance().getString("EquipmentColor" + Color);
		}
		public function GiftSpecial() 
		{
			ClassName = "GiftSpecial";
		}
		
		override public function setInfo(data:Object):void 
		{
			//Primitive = data;
			for (var itm:String in data)
			{
				try
				{
					this[itm] = data[itm];
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
			_element = data["Element"];
			if (_element == -1)
			{
				Element = 1;
			}
			if (data["Rank"])
			{
				_rank = data["Rank"] % 100;
			}
		}
		
		public function categoryType():int
		{
			switch(_itemType)
			{
				case "Weapon":
				case "Armor":
				case "Helmet":
					return EQUIPMENT;
				case "Ring":
				case "Belt":
				case "Bracelet":
				case "Necklace":
					return JEWELRY;
				case "Seal":
					return SEAL;
				case "AllChest":
				case "EquipmentChest":
				case "JewelChest":
					return CHEST;
				default:
					return NONE;
			}
		}
		
		public function set Element(value:int):void
		{
			if (value < 1 || value > 5)
			{
				_element = 1;
			}
			else
			{
				_element = value;
			}
		}
		public function get Element():int
		{
			return _element;
		}
		
		public function getBackGroundName():String
		{
			switch(Color)
			{
				case FISH_EQUIP_COLOR_GREEN:
					return "CtnEquipmentSpecial";
				case FISH_EQUIP_COLOR_GOLD:
					return "CtnEquipmentRare";
				case FISH_EQUIP_COLOR_PINK:
					return "CtnEquipmentDivine";
				case FISH_EQUIP_COLOR_VIP:
				case FISH_EQUIP_COLOR_6:
					return "CtnEquipmentOrange";
				default:
					return "CtnEquipment";
			}
		}
		
		override public function getItemName():String 
		{
			return Localization.getInstance().getString(_itemType + (_element * 100 + _rank));
		}
		public function getTypeName():String
		{
			return Localization.getInstance().getString("Equipment" + _itemType);
		}
		public function getMaxDurability():int
		{
			return ConfigJSON.getInstance().GetEquipmentInfo(_itemType, (_element * 100 + _rank) + "$" + Color)["Durability"];
		}
		public function getRankName():String
		{
			return Localization.getInstance().getString("EquipmentRank" + _rank);
		}
		/**
		 * kiểm tra xem đồ có thể bán được không
		 * @return true: có thể bán
		 */
		public function canSell():Boolean
		{
			var config:Array = ConfigJSON.getInstance().GetItemList("Param")["CanSellEquipment"];
			for (var i:int = 0; i < config.length; i++)
			{
				if (config[i] == Source)
				{
					return true;
				}
			}
			return false;
		}
	}

}


















