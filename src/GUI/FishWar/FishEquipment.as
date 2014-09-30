package GUI.FishWar 
{
	import com.greensock.loading.core.DisplayObjectLoader;
	import com.greensock.loading.data.VideoLoaderVars;
	import Data.BitmapMovie;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import GUI.component.SpriteExt;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendUpdateExpiredEquipment;
	/**
	 * Trang bị của cá lính (mũ, áo, vũ khí)
	 * @author longpt
	 */
	public class FishEquipment extends SpriteExt//extends BaseObject 
	{
		public static const FISH_EQUIP_HELMET:String = "Helmet";
		public static const FISH_EQUIP_BODY:String = "Armor";
		public static const FISH_EQUIP_WEAPON:String = "Weapon";
		public static const FISH_EQUIP_RING:String = "Ring";
		public static const FISH_EQUIP_BRACELET:String = "Bracelet";
		public static const FISH_EQUIP_NECKLACE:String = "Necklace";
		public static const FISH_EQUIP_BELT:String = "Belt";
		
		public static const FISH_EQUIP_COLOR_WHITE:int = 1;
		public static const FISH_EQUIP_COLOR_GREEN:int = 2;
		public static const FISH_EQUIP_COLOR_GOLD:int = 3;
		public static const FISH_EQUIP_COLOR_PINK:int = 4;
		public static const FISH_EQUIP_COLOR_VIP:int = 5;
		public static const FISH_EQUIP_COLOR_6:int = 6;
		
		public static const EquipColorName:Array = ["", "White", "Blue", "Gold", "Pink"];
		public static const EquipElementName:Array = ["", "Steel", "Wood", "Earth", "Water", "Fire"];
		public static const EquipmentTypeList:Array = ["Helmet", "Armor", "Weapon", "Belt", "Necklace", "Ring", "Bracelet", "Mask", "Seal", "QWhite", "QGreen", "QYellow", "QPurple", "QVIP"];
		
		public var Element:int;			// 1 -> 5
		public var Type:String;			// Helmet, armor, weapon
		public var Id:int;				// Id
		public var Rank:int;			// Cấp của trang bị
		public var StartTime:Number;
		public var OptionDamage:int;
		public var Damage:int;
		public var OptionDefence:int;
		public var Defence:int;
		public var TimeLeft:int;
		public var Color:int;
		public var Health:int;
		public var OptionCritical:int;
		public var Critical:int;
		public var OptionVitality:int;
		public var Vitality:int;
		public var EnchantLevel:int;
		public var Durability:Number;
		public var bonus:Array;
		public var Source:int;
		public var IsUsed:Boolean;
		public var InUse:Boolean;
		public var Author:Object;
		public var seller:Object;
		public var Level:int;
		public var NumChangeOption:int;
		public var ItemId:int;
		public var Point:int;
		public var isExpired:Boolean;
		
		public var imageName:String;
		
		public var FishOwn:FishSoldier;
		
		// Các thuộc tính để đổi hình dạng cá
		public var parent:Sprite;
		public var index:int;
		public var oldChild:DisplayObject;
		
		public function FishEquipment()
		{
			
		}
		
		public function SetInfo(data:Object):void
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
			//Sửa trường bonus sai của server
			for each( var obj:Object in bonus)
			{
				for (var s:String in obj)
				{
					obj[s] = int(obj[s]);
				}
			}
			
			SetImageName();
		}
		
		private function SetImageName():void
		{
			this.imageName = GetEquipmentName(this.Type, this.Rank, this.Color);
			//this.imageName = this.Type + this.Rank;
		}
		
		public function SetFishOwn(fs:FishSoldier):void
		{
			FishOwn = fs;
		}
		
		/**
		 * Cập nhật độ bền của trang bị
		 * @param	num
		 */
		public function UpdateDurability(num:Number):void
		{
			Durability += num;
			if (Durability <= 0)
			{
				Durability = 0;
				
				// Gửi gói tin update đồ đạc
				var uId:String;
				//if (FishOwn && FishOwn.isActor == FishSoldier.ACTOR_MINE)
				{
					uId = GameLogic.getInstance().user.GetMyInfo().Id + "";
				}
				//else
				//{
					//uId = GameLogic.getInstance().user.Id + "";
				//}
				
				if (InUse == true)
				{
					var cmd:SendUpdateExpiredEquipment = new SendUpdateExpiredEquipment(uId);
					Exchange.GetInstance().Send(cmd);
					InUse = false;
				}
				
				/*// Dỡ đồ ra khỏi người con cá
				if (FishOwn)
				{
					var fs:FishSoldier = FishOwn;
					for (var i:int = 0; i < FishOwn.EquipmentList[Type].length; i++)
					{
						if (FishOwn.EquipmentList[Type][i].Id == Id)
						{
							FishOwn = null;
							GameLogic.getInstance().user.UpdateEquipmentToStore(this);
							fs.EquipmentList[Type].splice(i, 1);
							break;
						}
					}
					
					fs.UpdateBonusEquipment();
					fs.RefreshImg();
				}*/
			}
		}
		
		public static function GetEquipmentName(type:String, rank:int, color:int):String
		{
			switch (type)
			{
				case "Ring":
					if (rank == 1)
					{
						if (color == FISH_EQUIP_COLOR_VIP)
						{
							return "RingDragon";
						}
						else if (color == FISH_EQUIP_COLOR_6)
						{
							return "RingPhoenix";
						}
					}
				default:
					return type + rank;
			}
		}
		
		public static function GetBackgroundName(color:int):String
		{
			switch (color)
			{
				case FISH_EQUIP_COLOR_GREEN:
					return "CtnEquipmentSpecial";
				case FISH_EQUIP_COLOR_GOLD:
					return "CtnEquipmentRare";
				case FISH_EQUIP_COLOR_PINK:
					return "CtnEquipmentDivine";
				case FISH_EQUIP_COLOR_VIP:
				case FISH_EQUIP_COLOR_6:
					//return "CtnEquipmentVip";
					return "CtnEquipmentOrange";
				default:
					return "CtnEquipment";
			}
		}
		
		public static function GetEquipmentLocalizeName(type:String, rank:int, color:int):String
		{
			var name:String = "";
			switch (type)
			{
				case "Ring":
					if (rank == 1)
					{
						if (color == FISH_EQUIP_COLOR_VIP)
						{
							name = Localization.getInstance().getString("RingDragon");
							return name;
						}
						else if (color == FISH_EQUIP_COLOR_6)
						{
							name = Localization.getInstance().getString("RingPhoenix");
							return name;
							//return "DSDSDS";
						}
					}
				default:
					name = Localization.getInstance().getString(type + rank);
					return name;
			}
		}
		/**
		 * cập nhật lại EnchantLevel cho đồ
		 * @param	dLevel : + hay - đi
		 */
		public function updateEnchantLevel(dLevel:int):void
		{
			if (dLevel == 0)
			{
				return;
			}
			
			/*cập nhật chỉ số công thủ và các dòng*/
			var temp:int = dLevel;
			var ag:int;
			var levelHere:int;
			if (dLevel < 0)
			{
				ag = -1;
				levelHere = EnchantLevel + 1;
			}
			else
			{
				ag = 1;
				levelHere = EnchantLevel;
			}
			var kind:String = "EnchantEquipment_" + Ultility.GetConfigListNameSuffix(Type);
			var cfg:Object = ConfigJSON.getInstance().getItemInfo(kind, Rank % 100)[Color==6?5:Color];
			var infoHere:Object;
			var i:int;
			var j:int;
			while (dLevel != 0)
			{
				dLevel -= ag;
				levelHere += ag;
				infoHere = cfg[levelHere];
				for (i = 0; i < Constant.SoldierProperties.length; i++)
				{
					if (this[Constant.SoldierProperties[i]]>0)
					{
						this[Constant.SoldierProperties[i]] += ag * infoHere[Constant.SoldierProperties[i]];
					}
					for (j = 0; j < bonus.length; j++)//duyệt từng dòng một
					{
						if (bonus[j][Constant.SoldierProperties[i]])
						{
							bonus[j][Constant.SoldierProperties[i]] += ag * infoHere[Constant.SoldierProperties[i]];
						}
					}
				}
			}
			
			/*cập nhật EnchantLevel*/
			EnchantLevel += temp;
		}
		
	}

}