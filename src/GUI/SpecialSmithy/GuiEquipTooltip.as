package GUI.SpecialSmithy 
{
	import Data.Localization;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.LayerMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GuiEquipTooltip extends BaseGUI 
	{
		
		public function GuiEquipTooltip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiEquipTooltip";
		}
		
		public override function InitGUI():void
		{
			LoadRes("ImgFrameFriend");
		}
		
		public function InitAll(x:Number, y:Number, obj:Object):void 
		{
			if(!this.IsVisible)		Show();
			ClearComponent();
			var ctn:Container = AddContainer("", "ImgFrameFriend", 0, 0);
			ctn.AddImage("BG", "GuiEquipmentInfo", 0, 0, true, ALIGN_LEFT_TOP);
			ShowInfoAbstract(obj, ctn);
			var delta:int = 10;
			
			// Vị trí container
			var posX:int = x;
			var posY:int = y;
			// Kích thước GUI
			var sizeX:int = img.width;
			var sizeY:int = img.height;
			
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
			
			if (posX <= posCenterX) 
			{
				if (posY <= posCenterY) 
				{
					posGui.x = x + 40;
					posGui.y = y - img.height/2;
				}
				else 
				{
					posGui.x = x + 10;
					posGui.y = y - img.height;
				}
			}
			else 
			{
				if (posY <= posCenterY)  
				{
					posGui.x = x - sizeX - 40;
					posGui.y = y - img.height/2;;
				}
				else 
				{
					posGui.x = x - sizeX - 10;
					posGui.y = y - img.height;;
				}
			}
			SetPos(posGui.x, posGui.y);
		}
		
		public static const BASIC_STAT:Array = ["Damage", "Defence", "Critical", "Vitality"];
		public function ShowInfoAbstract(obj:Object, ctn:Container):void
		{
			var a:Array = obj.subtype.split("$");		// 0: Type, 1:Color
			
			var tF:TextFormat;
			var txtF:TextField;	
			
			var i:int;
			var s:String;
			
			var color:Object = GetColorByEquipColor(int(a[1]));
			
			// Nếu là đồ đặc biệt, quý thì cho cái nền khác			
			if (int(a[1]) != FishEquipment.FISH_EQUIP_COLOR_WHITE)
				imag = AddImage("", FishEquipment.GetBackgroundName(int(a[1])), 12, 15, true, ALIGN_LEFT_TOP);
			else
				imag = AddImage("", "CtnEquipmentInfo", 12, 15, true, ALIGN_LEFT_TOP);

			// Ảnh đồ
			var name:String = obj["type"] + a[0] + "_Shop";
			var imag:Image = AddImage("", name, 0, 0);
			imag.FitRect(55, 55, new Point(19, 23));
			FishSoldier.EquipmentEffect(imag.img, int(a[1]));
			
			// Tên, loại đồ (thường, quý...)
			txtF = AddLabel(Localization.getInstance().getString(obj.type + a[0]) + " - " + Localization.getInstance().getString("EquipmentColor" + a[1]) + " - Cấp " + int(int(a[0]) % 100), 85, 15, 0x000000, 0, 0x000000);
			txtF.wordWrap = true;
			txtF.width = 170;
			tF = new TextFormat();
			tF.size = 17;
			tF.color = color;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Loại trang bị (vũ khí, áo...)
			txtF = AddLabel("[" + Localization.getInstance().getString("Equipment" + obj.type) + "]", 85, 62, 0x000000, 0);
			tF = new TextFormat();
			tF.size = 15;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Add cái container thông tin cơ bản
			AddImage("", "CtnInfoEquipmentBase", 15, 110, true, ALIGN_LEFT_TOP);
			
			var x0:int = 140;
			var y0:int = 110;
			var dx:int = 0;
			var dy:int = 26;
			var index:int = 0;
			for (i = 0; i < BASIC_STAT.length; i++)
			{
				if (obj[BASIC_STAT[i]] > 0 || obj[BASIC_STAT[i]] is Object)
				{
					txtF = AddLabel(Localization.getInstance().getString(BASIC_STAT[i]) + ":", x0 - 90, y0 + dy * index + 4, 0xFFF100, 0);
					tF = new TextFormat();
					tF.size = 12;
					tF.color = 0xffffff;
					tF.bold = true;
					txtF.setTextFormat(tF);
					
					if (getQualifiedClassName(obj[BASIC_STAT[i]]) == "Object")
						txtF = AddLabel(obj[BASIC_STAT[i]].Min + " - " + obj[BASIC_STAT[i]].Max, x0 + dx * index, y0 + dy * index, 0xFFF100, 0);
					else
						txtF = AddLabel(obj[BASIC_STAT[i]], x0 + dx * index, y0 + dy * index, 0xFFF100, 0);
					
					tF = new TextFormat();
					tF.size = 18;
					tF.color = color;
					tF.bold = true;
					txtF.setTextFormat(tF);
					
					index++;
				}
			}
			
			// Độ bền
			txtF = AddLabel("Độ bền:", x0 - 90, y0 + dy * index + 4, 0xFFF100, 0);
			tF = new TextFormat();
			tF.size = 12;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			txtF = AddLabel(obj.Durability + " / " + obj.Durability, x0 + dx * index, y0 + dy * index, 0xFFF100, 0);
			tF = new TextFormat();
			tF.size = 18;
			tF.color = color;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Add cái chữ "Dùng cho"
			txtF = AddLabel("Dùng cho:", 52, 200, 0xffffff, 0);
			tF = new TextFormat();
			tF.size = 12;
			tF.color = 0xffffff;
			tF.bold = true;
			txtF.setTextFormat(tF);
			
			// Add tên hệ (Kim mộc...)
			if (obj.Element != FishSoldier.ELEMENT_NONE)
				txtF = AddLabel("Hệ " + Localization.getInstance().getString("Element" + obj.Element), 120, 195, 0x000000, 0);
			else
				txtF = AddLabel("Tất cả", 120, 195, 0x000000, 0);
			
			tF = new TextFormat();
			tF.size = 18;
			tF.color = GetColorByElement(parseInt(obj.Element));
			tF.bold = true;
			txtF.setTextFormat(tF);
		}
		
		private function GetColorByEquipColor(color:int):Object
		{
			switch (color)
			{
				case FishEquipment.FISH_EQUIP_COLOR_WHITE:
					return 0xFFFFFF;
				case FishEquipment.FISH_EQUIP_COLOR_GREEN:
					return 0x00FF00;
				case FishEquipment.FISH_EQUIP_COLOR_GOLD:
					return 0xFFFF00;
				case FishEquipment.FISH_EQUIP_COLOR_PINK:
					return 0xff00cc;
				case FishEquipment.FISH_EQUIP_COLOR_VIP:
				case FishEquipment.FISH_EQUIP_COLOR_6:
					return 0xff9900;
			}
			return 0xFFFFFF;
		}
		
		private function GetColorByElement(element:int):Object
		{
			switch (element)
			{
				case FishSoldier.ELEMENT_METAL:
					return 0xFFFF00;
				case FishSoldier.ELEMENT_WOOD:
					return 0x82FF00;
				case FishSoldier.ELEMENT_EARTH:
					return 0xAA5614;
				case FishSoldier.ELEMENT_WATER:
					return 0x00FFE9;
				case FishSoldier.ELEMENT_FIRE:
					return 0xFF0000;
			}
			return 0xFFFFFF;
		}
	}

}