package GUI.EventMagicPotions.GUIQuestHerb 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.FishWar.FishEquipment;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * GUI tooltip hiện ra khi di vào container thảo dược
	 * @author longpt
	 */
	public class GUITooltipHerb extends BaseGUI 
	{
		private var HerbId:int;
		private var cfg:Object;
		private var pos:Point;
		
		public function GUITooltipHerb(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUITooltipHerb";
		}
		
		public override function InitGUI() :void
		{
			LoadRes("GuiTooltipHerb_Theme");
			SetPos(pos.x, pos.y);
			RefreshComponent();
			this.img.mouseEnabled = false;
		}
		
		public function Init(id:int):void
		{
			HerbId = id;
			pos = GetPos(HerbId);
			cfg = ConfigJSON.getInstance().GetItemList("HerbPotion")[HerbId];
			Show(Constant.GUI_MIN_LAYER, 0);
		}
		
		private function GetPos(id:int):Point
		{
			var stageWidth:int = Main.imgRoot.stage.stageWidth;
			var tooltipWidth:int = (ResMgr.getInstance().GetRes("GuiTooltipHerb_Theme") as Sprite).width;
			switch(id)
			{
				case 1:
					return new Point(0, 40);
					break;
				case 2:
					return new Point((stageWidth - tooltipWidth) / 2, 40);
					break;
				case 3:
					return new Point(stageWidth - tooltipWidth, 40);
					break;
			}
			return new Point();
		}
		
		private function RefreshComponent():void
		{
			//AddLabel(Localization.getInstance().getString("HerbPotion" + HerbId), 50, 10, 0xffffff, 1, 0x000000);
			
			AddBonusNormal();
			AddBonusLucky();
		}
		
		private function AddBonusNormal():void
		{
			var cfgNormal:Object = cfg.Sure;
			var x0:int = 45;
			var y0:int = 20;
			var dx:int = 0;
			var dy:int = 90;
			var ctn:Container;
			var tF:TextField;
			var txtF:TextFormat = new TextFormat();
			txtF.size = 15;
			txtF.align = "center";
			for (var str:String in cfgNormal)
			{
				ctn = AddContainer("", "GuiTooltipHerb_Ctn", x0 + parseInt(str) * dx, y0 + parseInt(str) * dy);
				switch (cfgNormal[str].ItemType)
				{
					case "Exp":
						ctn.AddImage("", "ImgEXP", ctn.img.width / 2 - 9, ctn.img.height / 2 - 15).SetScaleXY(1.5);
						tF = ctn.AddLabel(Ultility.StandardNumber(cfgNormal[str].Num), -12, 58, 0xffffff, 0, 0x000000);
						tF.autoSize = "center";
						tF.defaultTextFormat = txtF;
						break;
					case "Rank":
						ctn.AddImage("", "Ic" + cfgNormal[str].ItemType, ctn.img.width / 2 - 8, ctn.img.height / 2 - 10).SetScaleXY(1.3);
						tF = ctn.AddLabel(Ultility.StandardNumber(cfgNormal[str].Num), -12, 58, 0xffffff, 0, 0x000000);
						tF.autoSize = "center";
						tF.defaultTextFormat = txtF;
						break;
				}
				
			}
		}
		
		private function AddBonusLucky():void
		{
			var cfgLucky:Object = cfg.Lucky;
			var x0:int = 172;
			var y0:int = 32;
			var dx:int = 91;
			var dy:int = 82;
			var numRow:int = 2;
			var numCol:int = 4;
			var ctn:Container;
			var tF:TextField;
			var txtF:TextFormat = new TextFormat();
			txtF.size = 15;
			txtF.align = "center";
			//for (var i:int = 1; i <= 8; i++)
			for (var i:int = 1; i <= 7; i++)
			{
				switch (cfgLucky[i].ItemType)
				{
					case "Money":
						ctn = AddContainer("", "GuiTooltipHerb_CtnLucky", x0 + ((i - 1) % numCol) * dx, y0 + Math.ceil(i / numCol) * dy);
						ctn.AddImage("", "GiftCoin100", 0, 0).FitRect(70, 70, new Point(0, 0));
						tF = ctn.AddLabel(Ultility.StandardNumber(cfgLucky[i].Num), -12, 58, 0xffffff, 0, 0x000000);
						tF.autoSize = "center";
						tF.defaultTextFormat = txtF;
						break;
					case "Material":
						ctn = AddContainer("", "GuiTooltipHerb_CtnLucky", x0 + ((i - 1) % numCol) * dx, y0 + Math.ceil(i / numCol) * dy);
						ctn.AddImage("", cfgLucky[i].ItemType + cfgLucky[i].ItemId, ctn.img.width - 20, ctn.img.height / 2 + 10).SetScaleXY(1.4);
						tF = ctn.AddLabel(Ultility.StandardNumber(cfgLucky[i].Num), -12, 58, 0xffffff, 0, 0x000000);
						tF.autoSize = "center";
						tF.defaultTextFormat = txtF;
						break;
					case "EnergyItem":
						ctn = AddContainer("", "GuiTooltipHerb_CtnLucky", x0 + ((i - 1) % numCol) * dx, y0 + Math.ceil(i / numCol) * dy);
						ctn.AddImage("", cfgLucky[i].ItemType + cfgLucky[i].ItemId, ctn.img.width / 2 - 7, ctn.img.height / 2 - 13).SetScaleXY(1.4);
						tF = ctn.AddLabel(Ultility.StandardNumber(cfgLucky[i].Num), -12, 58, 0xffffff, 0, 0x000000);
						tF.autoSize = "center";
						tF.defaultTextFormat = txtF;
						break;
					case "RandomEquipment":
						if (cfgLucky[i].Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
						{
							ctn = AddContainer ("", FishEquipment.GetBackgroundName(cfgLucky[i].Color), x0 + ((i - 1) % numCol) * dx, y0 + Math.ceil(i / numCol) * dy);
						}
						else
						{
							ctn = AddContainer("", "GuiTooltipHerb_CtnLucky", x0 + ((i - 1) % numCol) * dx, y0 + Math.ceil(i / numCol) * dy);
						}
						
						ctn.AddImage("", "GuiTooltipHerb_DefaultEquip", 11, 7, true, ALIGN_LEFT_TOP);
						if (cfgLucky[i].Level == 1)
						{
							ctn.AddLabel("Lưỡng cực", -15, 54, 0xffffff, 1, 0x000000);
						}
						else if (cfgLucky[i].Level == 2)
						{
							ctn.AddLabel("Anh hùng", -15, 54, 0xffffff, 1, 0x000000);
						}
						break;
				}
			}
		}
	}

}