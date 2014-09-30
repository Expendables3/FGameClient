package GUI.EventMagicPotions.GUIInfoBossHerb 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import Logic.Ultility;
	
	/**
	 * Gui thong tin boss thao duoc
	 * @author longpt
	 */
	public class GUIInfoBossHerb extends BaseGUI 
	{
		private static const BTN_THOAT:String = "BtnThoat";
		private static const BTN_TUI_HIEU_RUI:String = "BtnTuiHieuRui";
		
		public function GUIInfoBossHerb(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIInfoBossHerb";
		}
		public override function InitGUI() :void
		{
			LoadRes("GuiInfoBossHerb_Theme");
			SetPos(40, 40);
			
			AddButton(BTN_THOAT, "BtnThoat", 704, 20);
			AddButton(BTN_TUI_HIEU_RUI, "GuiInfoBossHerb_BtnUnderstand", 290, 480);
			
			var x0:int;
			var y0:int;
			var dx:int = 66;
			var dy:int = 66;
			var numCol:int = 4;
			
			var txtFormat:TextFormat;
			var cfg:Object;
			
			cfg = ConfigJSON.getInstance().GetItemList("HerbBossReward").Attack.Sure;
			x0 = 70;
			y0 = 320;
			
			var s:String;
			var i:int = 0;
			var ctn:Container;
			var tt:TooltipFormat;
			for (s in cfg)
			{
				ctn = AddContainer("", "GuiInfoBossHerb_Ctn", x0 + (i % 4) * dx, y0 + Math.floor(i / 4) * dy);
				switch (cfg[s].ItemType)
				{
					case "Exp":
						ctn.AddImage("", "IcExp", ctn.img.width / 2 - 5, ctn.img.height / 2 - 13).SetScaleXY(1.4);
						ctn.AddLabel(Ultility.StandardNumber(cfg[s].Num) + "", -20, 40, 0xffffff, 1, 0x000000);
						tt = new TooltipFormat();
						tt.text = "Kinh nghiệm";
						break;
					case "RankPointBottle":
						ctn.AddImage("", cfg[s].ItemType + cfg[s].ItemId, 0, 0).FitRect(45, 45, new Point(8, 5));
						ctn.AddLabel(Ultility.StandardNumber(cfg[s].Num) + "", -20, 40, 0xffffff, 1, 0x000000);
						tt = new TooltipFormat();
						tt.text = "Bình chiến công";
						break;
					case "Herb":
						ctn.AddImage("", cfg[s].ItemType + cfg[s].ItemId, 0, 0).FitRect(45, 45, new Point(8, 5));
						ctn.AddLabel(Ultility.StandardNumber(cfg[s].Num) + "", -20, 40, 0xffffff, 1, 0x000000);
						tt = new TooltipFormat();
						tt.text = Localization.getInstance().getString(cfg[s].ItemType + cfg[s].ItemId);
						break;
				}
				ctn.setTooltip(tt);
				i++;
			}
			
			cfg = ConfigJSON.getInstance().GetItemList("HerbBossReward").Attack.Lucky;
			for (s in cfg)
			{
				if (i >= 8)
				{
					break;
				}
				
				if (cfg[s].ItemType == "Material" && cfg[s].ItemId < 6)
				{
					continue;
				}
				
				ctn = AddContainer("", "GuiInfoBossHerb_Ctn", x0 + (i % 4) * dx, y0 + Math.floor(i / 4) * dy);
				switch (cfg[s].ItemType)
				{
					case "Material":
						ctn.AddImage("", cfg[s].ItemType + cfg[s].ItemId, 0, 0).FitRect(45, 45, new Point(8, 5));
						ctn.AddLabel(Ultility.StandardNumber(cfg[s].Num) + "", -20, 40, 0xffffff, 1, 0x000000);
						tt = new TooltipFormat();
						tt.text = Localization.getInstance().getString(cfg[s].ItemType + cfg[s].ItemId);
						break;
					case "RandomEquipment":
						if (cfg[s].Color == FishEquipment.FISH_EQUIP_COLOR_PINK)
						{
							ctn.LoadRes("CtnEquipmentDivine");
						}
						else if (cfg[s].Color == FishEquipment.FISH_EQUIP_COLOR_GOLD)
						{
							ctn.LoadRes("CtnEquipmentRare");
						}
						
						ctn.AddImage("", "GuiTooltipHerb_DefaultEquip", 11, 7, true, ALIGN_LEFT_TOP);
						ctn.SetScaleXY(0.85);
						tt = new TooltipFormat();
						var str:String = "Trang bị ";
						if (cfg[s].Level == 1)
						{
							str += "Lưỡng cực ";
							txtFormat = new TextFormat();
							txtFormat.size = 13;
							ctn.AddLabel("Lưỡng cực", -14, 53, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
						}
						else if (cfg[s].Level == 2)
						{
							str += "Anh hùng ";
							txtFormat = new TextFormat();
							txtFormat.size = 13;
							ctn.AddLabel("Anh hùng", -14, 53, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
						}
						
						if (cfg[s].Color == FishEquipment.FISH_EQUIP_COLOR_PINK)
						{
							str += "Thần";
						}
						else if (cfg[s].Color == FishEquipment.FISH_EQUIP_COLOR_GOLD)
						{
							str += "Quý";
						}
						str += " ngẫu nhiên";
						tt.text = str;
						break;
				}
				ctn.setTooltip(tt);
				i++;
			}
			
			cfg = ConfigJSON.getInstance().GetItemList("HerbBossReward").Care.Sure;
			x0 = 400;
			y0 = 320;
			i = 0;
			
			for (s in cfg)
			{
				ctn = AddContainer("", "GuiInfoBossHerb_Ctn", x0 + (i % 4) * dx, y0 + Math.floor(i / 4) * dy);
				switch (cfg[s].ItemType)
				{
					case "Exp":
						ctn.AddImage("", "IcExp", ctn.img.width / 2 - 5, ctn.img.height / 2 - 13).SetScaleXY(1.4);
						ctn.AddLabel(Ultility.StandardNumber(cfg[s].Num) + "", -20, 40, 0xffffff, 1, 0x000000);
						tt = new TooltipFormat();
						tt.text = "Kinh nghiệm";
						break;
					case "RankPointBottle":
						ctn.AddImage("", cfg[s].ItemType + cfg[s].ItemId, 0, 0).FitRect(45, 45, new Point(8, 5));
						ctn.AddLabel(Ultility.StandardNumber(cfg[s].Num) + "", -20, 40, 0xffffff, 1, 0x000000);
						tt = new TooltipFormat();
						tt.text = "Bình chiến công";
						break;
					case "Herb":
						ctn.AddImage("", cfg[s].ItemType + cfg[s].ItemId, 0, 0).FitRect(45, 45, new Point(8, 5));
						ctn.AddLabel(Ultility.StandardNumber(cfg[s].Num) + "", -20, 40, 0xffffff, 1, 0x000000);
						tt = new TooltipFormat();
						tt.text = Localization.getInstance().getString(cfg[s].ItemType + cfg[s].ItemId);
						break;
				}
				ctn.setTooltip(tt);
				i++;
			}
			
			while (i < 8)
			{
				ctn = AddContainer("", "GuiInfoBossHerb_Ctn", x0 + (i % 4) * dx, y0 + Math.floor(i / 4) * dy);
				i++;
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_THOAT:
				case BTN_TUI_HIEU_RUI:
					this.Hide();
					break;
			}
		}
	}

}