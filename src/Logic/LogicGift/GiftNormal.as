package Logic.LogicGift 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Logic.Fish;
	import Logic.Ultility;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GiftNormal extends AbstractGift
	{
		/*chung*/
		public var Num:Number;
		/*đối với gem*/
		public var Element:int;
		public var Day:int;
		/*đối với con cá*/
		public var RecipeType:String;
		public var RecipeId:int = -1;
		public function GiftNormal() 
		{
			ClassName = "GiftNormal";
		}
		public function get IsGenerateNextId():Boolean
		{
			var isGenerate:Boolean = false;
			switch(_itemType)
			{
				case"OceanAnimal":
				case"OceanTree":
				case"Other":
				case"Soldier":
					isGenerate = true;
			}
			return isGenerate;
		}
		
		override public function getImageName():String
		{
			var name:String;
			switch(_itemType)
			{
				case "Gem":
					
					if (Element == 0)
					{
						name = _itemType +  _itemId;
					}
					else 
					{
						if (Element == 6)//trong event halloween
						{
							name = "EventTeacher_" + _itemType + Element + _itemId;
						}
						else
						{
							name = _itemType + "_" + Element + "_" + _itemId;
						}
					}
				break;
				case "Material":
					if (_itemId > 100)
					{
						var id:int = _itemId % 100;
						name = _itemType + id + "S";
					}
					else
					{
						name = _itemType + _itemId;
					}
				break;
				case "Money":
					name = "IcGold";
				break;
				case "Exp":
					name = "IcExp";
				break;
				case "ZMoney":
					name = "IcZingXu";
				break;
				case "Draft":
				case "Blessing":
				case "GoatSkin":
				case "Paper":
				case "TrunkOnline":
					name = _itemType + "_" + _itemId;
				break;
				case "RankPoint":
					name = "IcRank";
				break;
				case "Meridian":
					name = "IcMeridian";
				break;
				case "PowerTinh":
				case "Iron":
				case "Jade":
				case "SoulRock":
				case "SixColorTinh":
				case "AccPoint":
					name = _itemType;
				break;
				case "Diamond":
					name = "IcDiamond";
				break;
				case "Soldier":
					name = Fish.ItemType + (RecipeId * 10 + 310) + "_" + Fish.OLD + "_" + Fish.IDLE;
				break;
				case "Medal":
					name = "GuiFinishAuto_Medal";
				break;
				case "Hammer":
					name = "GuiTrungLinhThach_Hammer_" + _itemId;
				break;
				case "NoelItem":
					name = "EventNoel_" + _itemType + _itemId;
				break;
				case "VipTag":
					name = "VipTag1";
				break;
				case "Ticket":
					name = "EventLuckyMachine_Ticket1";
				break;
				default:
					name = _itemType + _itemId;
			}
			return name;
		}
		
		override public function getTooltipText():String 
		{
			var strTip:String = "";
			var value:int;
			var cfg:Object;
			switch(_itemType)
			{
				case "Money":
					strTip = Ultility.StandardNumber(Num) + " Tiền vàng";
				break;
				case "Exp":
					strTip = Ultility.StandardNumber(Num) + " Điểm kinh nghiệm";
				break;
				case "ZMoney":
					strTip = Ultility.StandardNumber(Num) + " G";
				break;
				case "Gem":
					strTip = Ultility.GetNamePearl(Element, _itemId);
				break;
				case "Draft":
				case "Blessing":
				case "GoatSkin":
				case "Paper":
				case "PowerTinh":
				case "Iron":
				case "Jade":
				case "SoulRock":
				case "RankPoint":
				case "Meridian":
				case "SixColorTinh":
				case "Diamond":
				case "AccPoint":
					strTip = Localization.getInstance().getString(_itemType);
				break;
				case "RecoverHealthSoldier":
					strTip = Localization.getInstance().getString(_itemType + _itemId);
					var recoverHealth:Object = ConfigJSON.getInstance().getItemInfo(_itemType, _itemId);
					strTip = strTip.replace("@Value@", recoverHealth["Num"]);
				break;
				case "Soldier":
					strTip = "Cá lính " + RecipeType + " sao";
				break;
				case "Ginseng":
					cfg = ConfigJSON.getInstance().getItemInfo(_itemType, _itemId);
					value = cfg["Expired"] / 86400;
					strTip = Localization.getInstance().getString(_itemType + _itemId);
					strTip = strTip.replace("@Value@", Ultility.StandardNumber(value));
				break;
				case "Samurai":
				case "BuffExp":
				case "BuffMoney":
				case "BuffRank":
					cfg = ConfigJSON.getInstance().getItemInfo("BuffItem");
					var curItem:Object = cfg[_itemType][_itemId];
					value = curItem["Num"];
					strTip = Localization.getInstance().getString(_itemType + _itemId);
					strTip = strTip.replace("@Value@", Ultility.StandardNumber(value));
				break;
				case "Medal":
					strTip = "Thạch Bảo Kim Bài";
				break;
				case "GiftBox":
					//strTip = Localization.getInstance().getString("EventTeacher_" + _itemType + _itemId);
					strTip = Localization.getInstance().getString("EventNoel_" + _itemType + _itemId);
				break;
				case "NoelItem":
					strTip = Localization.getInstance().getString("EventNoel_" + _itemType + _itemId);
				break;
				case "VipTag":
					strTip = Localization.getInstance().getString("VipTag1");
				break;
				case "Ticket":
					strTip = "Vỏ Sò May Mắn\nDùng trong Máy Quay Sò";
				break;
				default:
					strTip = Localization.getInstance().getString(_itemType + _itemId);
			}
			return strTip;
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
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
			if (_itemType == "Soldier")
			{
				if (data["ItemId"] != 0 && data["Rank"] != 0 && 
					data["RecipeType"] == null && data["RecipeId"] == null)
				{
					RecipeType = data["Rank"];
					RecipeId = data["ItemId"];
				}
				if (RecipeId == -1)
				{
					RecipeId = 1;
				}
			}
			
		}
		public function get RankBelongType():int 
		{
			switch(_itemType)
			{
				case "Money": return 1;
				case "Exp": return 2;
				case "Material": return 3;
				case "Draft": 
				case "Blessing":
				case "GoatSkin":
				case "Paper": 
					return 4;
				case "PowerTinh": return 5;
				case "Gem": return 6;
				case"OceanAnimal":
				case"OceanTree":
				case"Other":
				case"Soldier":	
					return 7;
				
				default: return -1;
			}
		}
		/**
		 * Merge quà giống nhau
		 * @param	data
		 */
		static public function mergeGift(data:Object):Object
		{
			var ret:Object = new Object();
			var hasKey:Boolean = false;
			var key:int = 1;
			var test:int = 0;
			for (var s:String in data)
			{
				key = 1;
				hasKey = false;
				var obj:Object = data[s];
				for (var k:String in ret)
				{
					key++;
					var temp:Object = ret[k];
					if (temp["ItemType"] == obj["ItemType"])
					{
						if (obj["ItemId"] == null || obj["ItemId"] == temp["ItemId"])
						{
							hasKey = true;
							temp["Num"] += obj["Num"];
						}
					}
				}
				if (!hasKey)
				{
					ret[key] = new Object();
					ret[key]["ItemType"] = obj["ItemType"];
					ret[key]["Num"] = obj["Num"];
					if (obj["ItemId"] != null)
					{
						ret[key]["ItemId"] = obj["ItemId"];
					}
				}
			}
			trace("count=", test);
			return ret;
		}
	}

}















