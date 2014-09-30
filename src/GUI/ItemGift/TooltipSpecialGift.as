package GUI.ItemGift 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.GUIToolTip;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	//import GUI.component.GUIToolTip;
	import GUI.component.Image;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	//public class TooltipSpecialGift extends BaseGUI 
	public class TooltipSpecialGift extends GUIToolTip 
	{
		private var _info:GiftSpecial;				//thông tin chi tiết về đồ
		private var _itemGift:ItemSpecialGift;
		private var _imgBackGround:Image;
		private var _tfName:TextField;
		private var _tfType:TextField;
		
		//public var xGift:int;
		//public var yGift:int;
		public var wGift:int;
		public var hGift:int;
		//public function TooltipSpecialGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		//{
			//super(parent, imgName, x, y, isLinkAge, imgAlign);
			//ClassName = "TooltipSpecialGift";
		//}
		public function TooltipSpecialGift(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "TooltipSpecialGift";
		}
		
		public function initInfo(itemGiftInfo:GiftSpecial):void
		{
			_info = itemGiftInfo;
		}
		
		override public function InitGUI():void 
		{
			LoadRes("KhungFriend");
			showGeneralInfo();
			switch(_info.ItemType)
			{
				case "Seal":
					showSealInfo();
					break;
				case "Mask":
					showMaskInfo();
					break;
				default:
					showEquipmentInfo();
			}
			var xMouse:Number = GameInput.getInstance().MousePos.x;
			var yMouse:Number = GameInput.getInstance().MousePos.y;
			SetPosition(xMouse, yMouse);
		}
		
		private function showGeneralInfo():void
		{
			/*ảnh của cái BackGround*/
			_imgBackGround = AddImage("", "GuiEquipmentInfo", 0, 0, true, ALIGN_LEFT_TOP);
			/*ảnh của nó + bg*/
			_itemGift = new ItemSpecialGift(this.img, "KhungFriend", 12, 15);
			_itemGift.initData(_info, "");
			_itemGift.hasTooltipText = false;
			_itemGift.hasTooltipImg = false;
			_itemGift.drawGift();
			/*tên + màu + cấp*/
			_tfName = AddLabel("", 85, 15, 0x000000, 1, 0x000000);
			var fm:TextFormat = new TextFormat("Arial", 15, getColorByColor());
			_tfName.wordWrap = true;
			_tfName.width = 170;
			_tfName.defaultTextFormat = fm; 
			var sName:String = _info.getItemName() + " - " + _info.getColorName();
			if (_info.ItemType != "Mask")
			{
				sName += " - Cấp " + (_info.Rank % 100);
			}
			_tfName.text = sName;
			/*loại(mũ, áo, vũ khí...)*/
			_tfType = AddLabel("", 85, 60);
			fm = new TextFormat("Arial", 15, 0xFFFFFF, true);
			_tfType.defaultTextFormat = fm;
			_tfType.text = "[" + _info.getTypeName() + "]";
		}
		/**
		 * thông tin cho đồ chung nhất: trang bị + trang sức
		 */
		private function showEquipmentInfo():void
		{
			var fm:TextFormat;
			var i:int;
			var j:int = 0;
			var s:String;
			var color:Object = getColorByColor();
			const  BASIC_STAT:Array = ["Damage", "Defence", "Critical", "Vitality"];
			/*số sao cường hóa*/
			for (i = 0; i < _info.EnchantLevel; i++)
			{
				AddImage("", "LuckyStar", 60 + i * 22, 113).SetScaleXY(0.35);
			}
			/*Show thông tin đặc trưng: Công, Thủ, Máu, Chí Mạng, Độ bền*/
			AddImage("", "CtnInfoEquipmentBase", 15, 110, true, ALIGN_LEFT_TOP);
			
			
			var tfPropertyName:TextField;
			var tfPropertyValue:TextField;
			for (i = 0; i < BASIC_STAT.length; i++)
			{
				if (_info[BASIC_STAT[i]] > 0)
				{
					tfPropertyName = AddLabel("", 50, 114 + 26 * j, 0x000000, 0, 0x000000);
					fm = new TextFormat("Arial", 12, 0xffffff, true);
					tfPropertyName.defaultTextFormat = fm;
					tfPropertyName.text = Localization.getInstance().getString(BASIC_STAT[i]) + ":";
					tfPropertyValue = AddLabel("", 140, 114 + 26 * j, 0x000000, 0, 0x000000);
					fm = new TextFormat("Arial", 18, color, true);
					tfPropertyValue.defaultTextFormat = fm;
					tfPropertyValue.text = Ultility.StandardNumber(_info[BASIC_STAT[i]]);
					j++;
				}
			}
			/*Độ bền*/
			tfPropertyName = AddLabel("", 50, 114 + 26 * j, 0x000000, 0, 0x000000);
			fm = new TextFormat("Arial", 12, 0xffffff, true);
			tfPropertyName.defaultTextFormat = fm;
			tfPropertyName.text = "Độ bền:";
			tfPropertyValue = AddLabel("", 140, 110 + 26 * j, 0x000000, 0, 0x000000);
			fm = new TextFormat("Arial", 18, _info.Durability > 0?color:0xFF0000, true);
			tfPropertyValue.defaultTextFormat = fm;
			tfPropertyValue.text = _info.Durability + "/" + _info.getMaxDurability();
			
			/*Dùng cho: ...*/
			tfPropertyName = AddLabel("Dùng cho:", 52, 200, 0x000000, 0, 0x000000);
			fm = new TextFormat("Arial", 12, 0xffffff, true);
			tfPropertyName.defaultTextFormat = fm;
			tfPropertyName.text = "Dùng cho:";
			tfPropertyValue = AddLabel("", 130, 195, 0x000000, 0, 0x000000);
			fm = new TextFormat("Arial", 12, getColorByElement(_info.Element), true);
			tfPropertyValue.defaultTextFormat = fm;
			tfPropertyValue.text = _info.Element == 0? "Tất cả" : "Hệ " + _info.getElementName();
			/*Đường kẻ*/
			if (j > 0)
			{
				AddImage("", "LineCtnEquipmentInfo", 20, 232, true, ALIGN_LEFT_TOP);
			}
			/*Show các dòng: Tăng:....*/
			j = 0;
			if (_info.bonus && _info.bonus[0])
			{
				for (i = 0; i < _info.bonus.length; i++)
				{
					for (s in _info.bonus[i])
					{
						if (_info.bonus[i][s] <= 0) continue;
						tfPropertyName = AddLabel("", 50, 244 + 26 * j, 0x000000, 0, 0x000000);
						fm = new TextFormat("Arial", 12, color, true);
						tfPropertyName.defaultTextFormat = fm;
						tfPropertyName.text = "Tăng " + Localization.getInstance().getString(s) + ":";
						tfPropertyValue = AddLabel("", 150, 240 + 26 * j, 0x000000, 0, 0x000000);
						fm = new TextFormat("Arial", 18, color, true);
						tfPropertyValue.defaultTextFormat = fm;
						tfPropertyValue.text = Ultility.StandardNumber(_info.bonus[i][s]);
						j++;
					}
				}
			}
			
			/*kéo dài cái bg*/
			_imgBackGround.img.height += (j * 30);
			showExtraInfo();
		}
		/**
		 * thông tin cho cái ấn
		 */
		private function showSealInfo():void
		{
			const BASIC_STAT:Array = ["Damage", "Defence", "Critical", "Vitality"];
			var config:Object = ConfigJSON.getInstance().GetItemList("Wars_Seal");
			config = config[_info.Rank][_info.Color];
			var color:Object = getColorByColor();
			var fm:TextFormat;
			var tfPropertyName:TextField;
			var tfPropertyValue:TextField;
			var tfRequire:TextField;
			var s:String;
			var i:int, j:int = 0;
			for (s in config)
			{
				var ctnObj:Container = AddContainer("", "CtnInfoEquipmentBaseSmall", 15, 110 + j * 60);
				tfRequire = ctnObj.AddLabel("", 5, 0, 0x000000, 0, 0x000000);
				fm = new TextFormat("Arial", 11, color, true); fm.align = TextFormatAlign.CENTER;
				tfRequire.defaultTextFormat = fm;
				if (config[s]["TotalPercent"] == null)
				{
					var iColor:int = _info.Color;
					var sColor:String = _info.Color == 6 ? "Thần" : _info.getColorName();
					tfRequire.text = "Trang bị " + int(config[s]["Require"]["NumEquip"]) + " đồ " + sColor /*+ " cấp " + _info.Rank*/ + " trở lên + " + int(config[s]["Require"]["EnchantLevel"]);
					var index:int = 0;
					for (i = 0; i < BASIC_STAT.length; i++)
					{
						if (config[s][BASIC_STAT[i]] > 0)
						{
							tfPropertyName = ctnObj.AddLabel("", 10, 16 + 18 * index, 0x000000, 0, 0x000000);
							fm = new TextFormat("Arial", 11, 0xffffff, true);
							tfPropertyName.defaultTextFormat = fm;
							tfPropertyName.text = Localization.getInstance().getString(BASIC_STAT[i]);
							
							tfPropertyValue = ctnObj.AddLabel("", 60, 12 + 18 * index, 0x000000, 0, 0x000000);
							fm = new TextFormat("Arial", 14, color, true);
							tfPropertyValue.defaultTextFormat = fm;
							tfPropertyValue.text = "+" + Ultility.StandardNumber(config[s][BASIC_STAT[i]]);
							
							tfPropertyName.x = 10 + Math.floor(index / 2) * 110;
							tfPropertyName.y = 16 + 18 * (index%2);
							tfPropertyValue.x = 62 + Math.floor(index / 2) * 110;
							tfPropertyValue.y = 15 + 18 * (index % 2);
							
							index++;
						}
					}
				}
				else
				{
					tfRequire.text = "Trang bị " + int(config[s]["Require"]["NumEquip"]) + " đồ " + _info.getColorName() + " +" + int(config[s]["Require"]["EnchantLevel"]);
					tfPropertyName = ctnObj.AddLabel("", 10, 16, 0xFFF100, 0, 0x000000);
					fm = new TextFormat("Arial", 11, 0xffffff, true);
					tfPropertyName.defaultTextFormat = fm;
					tfPropertyName.text = "Tất cả chỉ số trang bị đang mặc: ";
					
					tfPropertyValue = ctnObj.AddLabel("", 190, 16, 0x000000, 0, 0x000000);
					fm = new TextFormat("Arial", 16, color, true);
					tfPropertyValue.defaultTextFormat = fm;
					tfPropertyValue.text = "+" + config[s]["TotalPercent"] + "%";
				}
				ctnObj.enable = false;
				j++;
			}
			
			/*kéo dài cái bg*/
			_imgBackGround.img.height += (j - 1) * 60 - 26;
			tfRequire = AddLabel("", 30,  174 + 60 * (j - 1), 0xffffff, 0, 0x000000);
			fm = new TextFormat("Arial", 11, color, true);
			tfRequire.defaultTextFormat = fm;
			tfRequire.htmlText = "<font size='12'>Dùng cho: </font><font size = '18'>       Tất cả</font>";
		}
		/**
		 * thông tin cho cái mặt nạ
		 */
		private function showMaskInfo():void
		{
			var tfPropertyName:TextField;
			var tfPropertyValue:TextField;
			var fm:TextFormat;
			/*Add cái container thông tin cơ bản*/
			AddImage("", "CtnInfoEquipmentBase", 15, 110, true, ALIGN_LEFT_TOP).SetScaleY(0.7);
			// Tăng tất cả các chỉ số
			tfPropertyName = AddLabel("", 40, 114, 0xffffff, 0, 0x000000);
			fm = new TextFormat("Arial", 12, 0xffffff, true);
			tfPropertyName.defaultTextFormat = fm;
			tfPropertyName.text = "Tăng tất cả chỉ số:";
			tfPropertyValue = AddLabel("", 155, 110, 0xFFF100, 0, 0x000000);
			fm = new TextFormat("Arial", 18, (_info as EquipmentMask).TimeUse > 0 ? 0xffffff : 0xff0000, true);
			tfPropertyValue.defaultTextFormat = fm;
			tfPropertyValue.text = Ultility.StandardNumber(_info.Damage);
			//hạn sử dụng
			tfPropertyName = AddLabel("", 40, 140 , 0xFFF100, 0, 0x000000);
			fm = new TextFormat("Arial", 12, 0xffffff, true);
			tfPropertyName.defaultTextFormat = fm;
			tfPropertyName.text = "Hạn sử dụng còn:";
			tfPropertyValue = AddLabel("", 155, 140, 0x000000, 0, 0x000000);
			fm = new TextFormat("Arial", 18, (_info as EquipmentMask).TimeUse > 0 ? 0xffffff : 0xff0000, true);
			tfPropertyValue.defaultTextFormat = fm;
			tfPropertyValue.text = (_info as EquipmentMask).getTimeLeftString();
			
			// Add cái chữ "Dùng cho: hệ"
			tfPropertyName = AddLabel("", 52, 175, 0xffffff, 0, 0x000000);
			fm = new TextFormat("Arial", 12, 0xffffff, true);
			tfPropertyName.defaultTextFormat = fm;
			tfPropertyName.text = "Dùng cho:";
			tfPropertyValue = AddLabel("", 130, 170, 0x000000, 0, 0x000000);
			fm = new TextFormat("Arial", 18, getColorByElement(_info.Element), true);
			tfPropertyValue.defaultTextFormat = fm;
			tfPropertyValue.text = _info.Element == 0? "Tất cả" : "Hệ " + _info.getElementName();
			//đường kẻ
			AddImage("", "LineCtnEquipmentInfo", 20, 200, true, ALIGN_LEFT_TOP);
			
			//tên con cá mặt nạ
			var color:Object = getColorByColor();
			tfPropertyName = AddLabel("", 80, 210, 0xffffff, 1, 0x000000);
			fm = new TextFormat("Arial", 12, color, true);
			tfPropertyName.defaultTextFormat = fm;
			tfPropertyName.text = "Khi sử dụng sẽ biến thành";
			tfPropertyValue = AddLabel("", 80, 225, 0xffffff, 1, 0x000000);
			fm = new TextFormat("Arial", 18, color, true);
			tfPropertyValue.defaultTextFormat = fm;
			tfPropertyValue.text = Localization.getInstance().getString(_info.ItemType + _info.Rank);
			//cái khung
			AddImage("", "CtnInfoEquipmentBase", 15, 250, true, ALIGN_LEFT_TOP).SetScaleY(1.4);
			//con cá
			AddImage("", (_info as EquipmentMask).getFishByMaskId(), 0, 0).FitRect(120, 120, new Point(60, 250));
			_imgBackGround.img.height *= 1.6;
		}
		
		private function showExtraInfo():void 
		{
			/*đường kẻ*/
			var h:int = _imgBackGround.img.height;
			AddImage("", "LineCtnEquipmentInfo", 20, h, true, ALIGN_LEFT_TOP);
			/*có thể giao dịch hay không*/
			var height:int = _imgBackGround.img.height;
			var tfNotice:TextField = AddLabel("", 70, height + 10, 0xffffff, 1, 0x000000);
			var fm:TextFormat = new TextFormat("Arial", 12, 0xffffff, true);
			tfNotice.defaultTextFormat = fm;
			_imgBackGround.img.height += 40;
			if (!_info.canSell() || _info.IsUsed)
			{
				tfNotice.htmlText = " <font color='#ff0000'>Đồ không thể giao dịch</font>";
				AddImage("", "Lock", 47, height + 21);
			}
			else
			{
				tfNotice.htmlText = " <font color='#00ff00'>Đồ có thể giao dịch</font>";
			}
		}
		private function getColorByColor():Object
		{
			switch(_info.Color)
			{
				case GiftSpecial.FISH_EQUIP_COLOR_WHITE:
					return 0xFFFFFF;
				case GiftSpecial.FISH_EQUIP_COLOR_GREEN:
					return 0x00FF00;
				case GiftSpecial.FISH_EQUIP_COLOR_GOLD:
					return 0xFF0000;
				case GiftSpecial.FISH_EQUIP_COLOR_PINK:
					return 0xFF00CC;
				case GiftSpecial.FISH_EQUIP_COLOR_VIP:
				case GiftSpecial.FISH_EQUIP_COLOR_6:
					return 0xFF9900;
			}
			return 0xFFFFFF;
		}
		private function getColorByElement(element:int):Object
		{
			switch (element)
			{
				case 1:
					return 0xFFFF00;
				case 2:
					return 0x82FF00;
				case 3:
					return 0xAA5614;
				case 4:
					return 0x00FFE9;
				case 5:
					return 0xFF0000;
			}
			return 0xFFFFFF;
		}
		
		private function SetPosition(x:int, y:int):void
		{
			var posCenterX:int;
			var posCenterY:int;
			var posGui:Point = new Point();
			
			if (GuiMgr.IsFullScreen)
			{
				posCenterX = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenWidth / 2;
				posCenterY = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenHeight / 2
			}
			else 
			{
				posCenterX = Constant.STAGE_WIDTH / 2;
				posCenterY = Constant.STAGE_HEIGHT / 2;
			}
			
			if (x <= posCenterX) 
			{
				posGui.x = x + 15;
				if (y <= posCenterY) 
				{
					posGui.y = y - img.height/4;
				}
				else 
				{
					posGui.y = y - img.height;
					if (posGui.y < 10)
					{
						posGui.y = 10;
					}
				}
			}
			else 
			{
				posGui.x = x - img.width - 10;
				if (y <= posCenterY)  
				{
					posGui.y = y - img.height/4;
				}
				else 
				{
					posGui.y = y - img.height;
					if (posGui.y < 10)
					{
						posGui.y = 10;
					}
				}
			}
			SetPos(posGui.x, posGui.y);
		}
		override public function ClearComponent():void 
		{
			if(_itemGift)
				_itemGift.Destructor();
			super.ClearComponent();
		}
	}

}













