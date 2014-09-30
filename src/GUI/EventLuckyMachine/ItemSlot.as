package GUI.EventLuckyMachine 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.GuiMgr;
	
	/**
	 * slot chứa quà
	 * @author HiepNM
	 */
	public class ItemSlot extends Container 
	{
		/*Attributes*/
		public var flagTransform:Boolean = false;
		private var _itemId:int = 0;			
		//private var _level:int = 0;						
		private var _levelGift:int = 0;			//level của quà, thay đổi sau mỗi lần quay => dùng để xác định tên ảnh	
		private var _levelSlot:int = 0;			//level của ô đó, luôn cố định, = 1 or 2 or 3
		private var _itemType:String = "";		
		private var _index:int = 0;				
		/*đối với cái máy quay số*/
		private var _itemIdDW:int = 0;
		private var _itemTypeDW:String = "";
		
		public static const TYPE_ENERGYITEM:String = "EnergyItem";
		public static const TYPE_EXP:String = "ExpLM";
		public static const TYPE_MASK:String = "Mask";
		public static const TYPE_WEAPON:String = "Weapon";
		public static const TYPE_ARMOR:String = "Armor";
		public static const TYPE_HELMET:String = "Helmet";
		public static const TYPE_BELT:String = "Belt";
		public static const TYPE_BRACELET:String = "Bracelet";
		public static const TYPE_NECKLACE:String = "Necklace";
		public static const TYPE_RING:String = "Ring";
		public static const TYPE_MATERIAL:String = "Material";
		public static const TYPE_RANKPOINTBOTTLE:String = "RankPointBottle";
		public static const TYPE_FAIL:String = "Truot";
		
		public static const TYPE_ENERGYITEM_DW:String = "EnergyItemDW";
		public static const TYPE_EXP_DW:String = "ExpDW";
		public static const TYPE_MASK_DW:String = "MaskDW";
		public static const TYPE_WEAPON_DW:String = "TreasureWeapon";
		public static const TYPE_ARMOR_DW:String = "TreasureArmor";
		public static const TYPE_HELMET_DW:String = "TreasureHelmet";
		static public const TYPE_NECKLACE_DW:String = "TreasureNecklace";
		static public const TYPE_RING_DW:String = "TreasureRing";
		static public const TYPE_BRACELET_DW:String = "TreasureBracelet";
		static public const TYPE_BELT_DW:String = "TreasureBelt";
		static public const TYPE_WEAPON_VIP_DW:String = "IcVipWeapon";
		public static const TYPE_MATERIAL_DW:String = "MaterialDW";
		public static const TYPE_RANKPOINTBOTTLE_DW:String = "RankPointBottleDW";
		public static const TYPE_FAIL_DW:String = "TruotDW";
		
		private const typeX:int = 26;
		private const typeY:int = 26;
		public var isSelected:Boolean = false;
		public static const ID_IMG_SELECTED:String = "idimgSelected";
		private var Fog:Sprite;
		
		/*Methods*/
		public function ItemSlot(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		};
		/*getter and setter methods*/
		public function get Index():int
		{
			return _index;
		};
		public function set Index(i:int):void
		{
			if(i>=0)
				_index = i;
		};
		public function get ItemType():String
		{
			var str:String;
			//str = (_itemType == "MoneyLM")?"Money":_itemType;
			str = (_itemType == "ExpLM")?"Exp":_itemType;
			return str;
		};
		public function set ItemType(itemType:String):void
		{
			if (itemType.length > 0)
			{
				//itemType = (itemType=="Money")?ItemSlot.TYPE_MONEY:itemType;
				itemType = (itemType == "Exp")?ItemSlot.TYPE_EXP:itemType;
				_itemType = itemType;
			}
		};
		public function get ItemId():int
		{
			return _itemId;
		};
		public function set ItemId(itemId:int):void
		{
			if (itemId > 0)
				_itemId = itemId;
		};
		
		public function get ItemTypeDW():String
		{
			return _itemTypeDW;
		};
		public function set ItemTypeDW(itemTypeDW:String):void
		{
			if(itemTypeDW.length>0)
				_itemTypeDW = itemTypeDW;
		};
		public function get ItemIdDW():int
		{
			return _itemIdDW;
		};
		public function set ItemIdDW(itemIdDW:int):void
		{
			if (itemIdDW > 0)
				_itemIdDW = itemIdDW;
		};
		public function get LevelGift():int
		{
			return _levelGift;
		};
		public function set LevelGift(levelGift:int):void
		{
			_levelGift = levelGift;
		};
		public function get LevelSlot():int
		{
			return _levelSlot;
		};
		public function set LevelSlot(levelSlot:int):void
		{
			_levelSlot = levelSlot;
		}
		/*
		 * vẽ ảnh vào slot dựa vào:
		 * 		type + id
		 * 		số lượng nhận được
		 */ 
		public function LoadImageDW(floor:int):void
		{
			this.ClearComponent();
			var imageItem:Image;
			var tf:TextField;
			var num:int;			//số lượng quà nhận được, sẽ được vẽ ra ngay dưới ảnh quà
			var imName:String;		//tên ảnh
			var stNum:String;		//số lượng quà sau khi chuẩn hóa về xâu
			var str:String = getString(floor);
			var data:Array = str.split("_");
			var x:int = typeX;
			var y:int = typeY;
			
			num = data[1];
			imName = data[0];
			
			stNum = DigritWheelData.StandardNumber(num);
			imageItem = AddImage("idimg", imName, x, y);
			imageItem.FitRect(42, 42, new Point(7, 0));
			if (num > 0)								//có quà	(không phải ô trượt)
			{
				tf = AddLabel(stNum, -22, 35, 0xffffff, 1, 0x000000);
			}
			if (this.ItemTypeDW == TYPE_WEAPON_VIP_DW) {
				AddLabel("Vip", -8, 25, 0xffffff, 1, 0x000000);
			}
		};
		/*
		 * @type:	loại quà
		 * @typeDW:	loại quà trong máy quay
		 * @level:	cấp của quà
		 * return imageName + "_" + numGift
		 */ 
		private function getString(floor:int):String
		{
			var rs:String;
			if (ItemType == TYPE_FAIL)
			{
				rs = TYPE_FAIL_DW + "_-1";
			}
			else if (ItemType == TYPE_MASK || ItemType == TYPE_WEAPON || ItemType == TYPE_ARMOR || ItemType == TYPE_HELMET
						|| ItemType == TYPE_BELT||ItemType == TYPE_BRACELET||ItemType == TYPE_NECKLACE||ItemType == TYPE_RING)
			{
				rs = _itemTypeDW + "_1";
			}
			else
			{
				var objVar:Object = { ItemId:0, Num:0, TicketNum:0 };
				ConfigJSON.getInstance().GetGiftContent(floor, ItemType, LevelGift, objVar);
				var id:String = (objVar["ItemId"] == 0 || objVar["ItemId"] == null)?"":objVar["ItemId"];
				rs = _itemType + id + "_" + objVar["Num"];
			};
			return rs;
		}
		
		/*
		 * thêm vào effect chạy quanh cái ô đó
		 */ 
		public function addEffSelGift():void
		{
			isSelected = true;
			SetHighLight(0xFF0000);
		};
		public function showFogSlot():void
		{
			Fog = new Sprite();
			Fog.graphics.beginFill(0x000000, 0.6);
			Fog.graphics.drawRect(0, 0, 54, 54);
			Fog.graphics.endFill();
			img.addChild(Fog);
		};
		public function hideFogSlot():void
		{
			if(Fog!=null)
				img.removeChild(Fog);
		};
		/*
		 * Sau khi biến hình xong
		 */ 
		
		private function PlusSmart(no1:int, no2:int, max:int):int
		{
			var rs:int;
			rs = no1 + no2;
			rs = (rs < max)?rs:max;
			return rs;
		};
		public function calLevelGiftForFakeSlot(levelChung:int):int
		{
			var levelGiftResult:int;
			if (LevelGift <= levelChung)
			{
				levelGiftResult = PlusSmart(levelChung, 1, 6);
			}
			else
			{
				levelGiftResult = LevelGift;
			}
			return levelGiftResult;
		}
		public function transform():void
		{
			var x:int = this.img.x;
			var y:int = this.img.y;
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffAnNgoc", null, x, y);
		}
		//public function onCompTransform():void
		//{
			//var levelChung:int = GuiMgr.getInstance().guiDigritWheel.CurGiftLevel;
			//var type:String = GuiMgr.getInstance().guiDigritWheel.CurGiftType;
			//if (_levelSlot == 0)//với ô fake
			//{
				//_levelGift = calLevelGiftForFakeSlot(levelChung);
			//}
			//else	//với ô thực
			//{
				//_levelGift = PlusSmart(levelChung, _levelSlot, 6);
			//}
			//LoadImageDW();
		//}
	};
};
























