package GUI.EventEuro 
{
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemGiftEuro extends Container 
	{
		public var isEquip:Boolean;
		public var data:Object;
		
		public function ItemGiftEuro(parent:Object, imgName:String = "ItemGiftEuro_Bg", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			if (imgName == "")
			{
				LoadRes("");
				img.graphics.beginFill(0xff000000, 0);
				img.graphics.drawRect(0, 0, 70, 70);
				img.graphics.endFill();
			}
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			if (isEquip)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			if (isEquip)
			{
				var equip:FishEquipment = new FishEquipment();
				equip.SetInfo(data);
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(e.stageX, e.stageY, equip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
			}
		}
		
		public function initItem(_data:Object, _isEquip:Boolean = false):void
		{
			data = _data;
			isEquip = _isEquip;
			if (!isEquip)
			{
				AddImage("", getImageName(data["ItemType"], data["ItemId"]), 0, 0, true, ALIGN_LEFT_TOP).FitRect(70, 70, new Point(0, 0));
				var labelNum:TextField = AddLabel("x" + Ultility.StandardNumber(int(data["Num"])), -15, 50, 0xffffff, 1, 0x000000);
				labelNum.autoSize = "center";
				if (data["ItemType"] == "Medal")
				{
					var tooltip:TooltipFormat = new TooltipFormat();
					//tooltip.text = "Huy chương Euro\nđã được hệ thống tự động cộng";
					tooltip.text = "Kim Bài Trung Thu";
					setTooltip(tooltip);
				}
				if (data["ItemType"] == "EquipmentChest" || data["ItemType"] == "JewelChest" || data["ItemType"] == "AllChest" 
				|| data["ItemType"] == "Weapon")
				{
					AddImage("", "ImgLaMa" + data["Rank"], 17, 59).SetScaleXY(0.7);
				}
				setTooltipText(getNameItem());
			}
			else
			{
				var bgName:String = FishEquipment.GetBackgroundName(int(data["Color"]));
				AddImage("", bgName, 0, 0).FitRect(75, 75, new Point(-0.5, 0));
				var imgEquipName:String = FishEquipment.GetEquipmentName(data["Type"], data["Rank"], data["Color"])  + "_Shop";
				AddImage("", imgEquipName, 0, 0, true, ALIGN_LEFT_TOP).FitRect(70, 70, new Point(0, 0));
				if (data["EnchantLevel"] != null && data["EnchantLevel"] > 0)
				{
					var txt:TextField = AddLabel("+" + data["EnchantLevel"], 2, 0, 0xFFF100, 0, 0x603813);
					txt.setTextFormat(new TextFormat("arial", 18, 0xffff00, true));
				}
			}
			if (img != null)
			{
				img.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
				img.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			}
		}
		
		public function getNameItem():String 
		{
			if (data["ItemType"] == null)
			{
				return "";
			}
			switch(data["ItemType"])
			{
				case "Exp":
					return "Kinh Nghiệm";
				case "Money":
					return "Tiền Vàng";
					//return Localization.getInstance().getString("EventMidAutumn_" + data["ItemType"]);
				case "Collection":
				case "Speeduper":
				case "Protector":
				case "Magnetic":
				case "Health":
				case "AllChest":
				case "Medal":
				case "Disaster":
				case "DropOfWater":
				case "Cyclone":
					return Localization.getInstance().getString("EventMidAutumn_" + data["ItemType"] + data["ItemId"]);
				case "EquipmentChest":
					return "Trang Bị " + getRankName() + " " + getColorName();
				case "JewelChest":
					return "Trang Sức " + getRankName() + " " + getColorName();
				case "SetEquipment":
					return "Bộ Trang Bị " + getRankName() + " " + getColorName();
				case "FullSet":
					return "Bộ " + getRankName() + " " + getColorName();
				case "HalItem":
					return Localization.getInstance().getString("EventHalloween_Tip" + data["ItemType"] + data["ItemId"]);
					break;
				case "ColPItem":
					return Localization.getInstance().getString("EventTeacher_" + data["ItemType"] + data["ItemId"]);
				case "Candy":
					return Localization.getInstance().getString("EventNoel_" + data["ItemType"] + data["ItemId"]);
				case "Ticket":
					return "Vỏ Sò May Mắn";
				case "Island_Item":
					return "Xẻng đào vàng";
				default:
					return Localization.getInstance().getString(data["ItemType"] + data["ItemId"]);
			}
			return "";
		}
		
		private function getRankName():String
		{
			switch(data["Rank"])
			{
				case 1:
					return "Lưỡng Cực";
				case 2:
					return "Anh Hùng";
				case 3:
					return "Vô Song";
			}
			return "";
		}
		
		private function getColorName():String
		{
			switch(data["Color"])
			{
				case 1:
					return "Thường";
				case 2:
					return "Đặc Biệt";
				case 3:
					return "Quý";
				case 4:
					return "Thần";
				case 5:
					return "VIP";
			}
			return "";
		}
		
		private function getImageName(itemType:String, itemId:int):String
		{
			switch(itemType)
			{
				case "Collection":
					return "EventMidAutumn_Collection" + itemId;
				case "Medal":
					//return "Ic_Medal";
					return "GuiBackground_Medal";
				case "Material":
					return Ultility.GetNameMatFromType(itemId);
				case "Exp":
					return "IcExp";
				case "Money":
					return "IcGold";
				case "PowerTinh":
					return itemType;
				case "EquipmentChest":
					//return "TrunkEquipment" + data["Color"];
					return "GuiCollection_Weapon_Trunk_" + data["Color"];
				case "JewelChest":
					return "TrunkJewel" + data["Color"];
				case "Seal":
					return "Seal2_Shop";
				case "SetEquipment":
				case "FullSet":
					return "TrunkEquipment" + data["Color"];
				case "AllChest":
					return "AllChest" + data["Color"] + "_AllChest";
				case "Weapon":
					return "GuiCollection_" + data["ItemType"] + "_Trunk_" + data["Color"];
				case "HalItem":
					return "EventHalloween_" + itemType + itemId;
				case "ColPItem":
					return "EventTeacher_" + itemType + itemId;
				case "Candy":
					return "EventNoel_" + itemType + itemId;
				case "Island_Item":
					return "IslandItem" + itemId;
				case "Ticket":
					return "EventLuckyMachine_" + itemType + itemId;
				case "Arrow":
					return "GUIGameEventMidle8_" + itemType + itemId;
				default:
					return itemType + itemId;
			}
			return "";
		}
	}

}