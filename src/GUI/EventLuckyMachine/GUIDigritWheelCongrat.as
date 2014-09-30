package GUI.EventLuckyMachine 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.FishEquipmentMask;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	
	/**
	 * GUI nhận quà khủng từ máy quay số
	 * @author HiepNM2
	 */
	public class GUIDigritWheelCongrat extends BaseGUI 
	{
		private static const ID_BTN_CLOSE:String = "idBtnClose";
		private static const ID_BTN_SHARE:String = "idBtnShare";
		private var _giftType:String;
		private var _giftId:int;
		private var _rank:int;
		private var _color:int;
		private var equipment:FishEquipment;
		private var _container:Container;
		private static const ID_CTN:String = "idContainerGift";
		
		public function GUIDigritWheelCongrat(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIDigritWheelCongrat";
		};
		/*getter and setter*/
		public function set GiftType(giftType:String):void
		{
			_giftType = giftType;
		};
		public function get GiftType():String
		{
			return _giftType;
		};
		public function set GiftId(giftId:int):void
		{
			_giftId = giftId;
		};
		public function get GiftId():int
		{
			return _giftId;
		};
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(210, 130);
				AddButton(ID_BTN_CLOSE, "BtnThoat", 340, 55);
				AddButton(ID_BTN_SHARE, "BtnFeed", 140, 260);
			}
			
			LoadRes("GuiDigitWheelCongrat_Theme");
		};
		public function showGui(equip:Object, itemType:String, rank:int, color:int):void
		{
			Show(Constant.GUI_MIN_LAYER, 4);
			if (itemType != "Mask")
			{
				equipment = new FishEquipment();
			}
			else
			{
				equipment = new FishEquipmentMask();
			}
			equipment.SetInfo(equip);// as FishEquipment;
			GiftType = itemType;
			GiftId = rank;
			_rank = rank;
			_color = color;
			_container = AddContainer(ID_CTN, "GuiDigitWheelCongrat_CtnEquipmentRare", 100 + 97 - 30 - 6, 100 + 77 - 40, true, this);
			
			//AddImage("", "GuiDigitWheelCongrat_CtnEquipmentRare", 100 + 97, 100 + 77);
			var imName:String = getImgeName(itemType, rank);
			var im:Image = _container.AddImage("idimg", imName, 0, 0, true, ALIGN_LEFT_TOP);
			im.FitRect(55, 55, new Point(10, 10));
			FishSoldier.EquipmentEffect(im.img, _color);
			
			var name:String = getNameEquip(itemType, rank);
			var fm:TextFormat = new TextFormat();
			fm.size = 18;
			fm.color = 0x096791;//0x096791
			var tf:TextField = AddLabel(name, 100 + 52, 100 + 122);
			tf.setTextFormat(fm);
			
			//var tip:TooltipFormat = new TooltipFormat();
			//tip.text = "Mặt nạ\nTăng tất cả các chỉ số cho ngư thủ: " +
			//ConfigJSON.getInstance().GetEquipmentInfo(itemType, itemId + "$" + color)["Critical"]["Min"];
			//im.setTooltip(tip);
		};
		private function getNameEquip(itemType:String, rank:int):String
		{
			var rs:String;
			var str:String;
			switch(itemType)
			{
				case"Weapon":
				case"Helmet":
				case"Armor":
				case"Belt":
				case"Bracelet":
				case"Necklace":
				case"Ring":
					rs = Localization.getInstance().getString(itemType + rank) + " " + getStringColor();
				break;
				case"Mask":
				{
					rs = "Mặt nạ ";
					str = Localization.getInstance().getString(itemType + rank);
					rs += str;
				}
				break;
			}
			return rs;
		}
		private function getImgeName(itemType:String, rank:int):String
		{
			return itemType + rank + "_Shop";
			//return itemType + itemId + "_Shop";
			//var sId:String = (itemId > 0)?itemId.toString():"";
			//return (itemType + sId + "_Shop");
		};
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			GuiMgr.getInstance().guiDigitWheel.resetMachine();
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
				{
					Hide();
				};
				break;
				case ID_BTN_SHARE:
				{
					feed();
					Hide();
				};
				break;
			};
			
		};
		private function feed():void
		{
			if (_giftType == ItemSlot.TYPE_MASK)
			{
				switch(_giftId)
				{
					case 2:
						GuiMgr.getInstance().GuiFeedWall.ShowFeed("LuckyMachineMaskCaShen");
					break;
					case 3:
						GuiMgr.getInstance().GuiFeedWall.ShowFeed("LuckyMachineMaskChienBinh");
					break;
					case 4:
						GuiMgr.getInstance().GuiFeedWall.ShowFeed("LuckyMachineMaskTuaRua");
					break;
				}
			}
			else
			{
				GuiMgr.getInstance().GuiFeedWall.ShowFeed("LuckyMachineLuongCucQuy");
			}
		};
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			if (buttonID != ID_CTN)	return;
			
			GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equipment, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}
		private function getStringColor():String
		{
			switch(_color)
			{
				case 3:
					return "quí";
				case 4:
					return "thần";
			}
			return "";
		}
	};
};


































