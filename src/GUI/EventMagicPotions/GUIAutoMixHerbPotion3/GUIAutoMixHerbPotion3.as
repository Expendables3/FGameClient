package GUI.EventMagicPotions.GUIAutoMixHerbPotion3 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.EventMagicPotions.NetworkPacket.ExchangeHerbItem;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * GUI tự động chế tạo bình thần thánh
	 * @author longpt
	 */
	public class GUIAutoMixHerbPotion3 extends BaseGUI 
	{
		public const BTN_THOAT:String = "BtnThoat";
		public const BTN_1:String = "Btn_1";
		public const BTN_2:String = "Btn_2";
		
		public var cfg:Object;
		public var cfgCost:Object;
		
		public var EffAutoMix:Image;
		
		public var Result:Object;
		
		public function GUIAutoMixHerbPotion3(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIAutoMixHerbPotion3";
		}
		
		public override function InitGUI() :void
		{
			LoadRes("GuiAutoMixHerbPotion3_Theme");
			SetPos(130, 100);
			RefreshContent();
		}
		
		private function RefreshContent():void
		{
			AddButton(BTN_THOAT, "BtnThoat", 522, 14);
			
			cfg = ConfigJSON.getInstance().GetItemList("MagicPotion_Auto");
			cfgCost = ConfigJSON.getInstance().GetItemList("MagicPotion_AutoCost");
			
			var x0:int = 285;
			var y0:int = 110;
			var dx:int = 62;
			var dy:int = 66;
			var numCol:int = 4;
			
			var s1:String;
			var s2:String;
			
			var ctn:Container;
			var gift:Object;
			var i:int = 0;
			var tt:TooltipFormat;
			
			//AddLabel("Chế tạo 5 Thuốc Thần Thánh", 48, 72, 0xffffff, 0, 0x000000).setTextFormat(new TextFormat(null, 14));
			//AddLabel("Chế tạo 50 Thuốc Thần Thánh", 300, 72, 0xffffff, 0 , 0x000000).setTextFormat(new TextFormat(null, 14));
			
			var name:Array = ["Money", "Exp", "RankPointBottle", "EnergyItem", "Material", "RandomEquipment", "HerbMedal"];
			
			for (s1 in cfg["1"])
			{
				for (s2 in cfg["1"][s1])
				{
					gift = cfg["1"][s1][s2];
					ctn = AddContainer("", "GuiAutoMixHerbPotion3_Ctn", x0 + (i % numCol) * dx, y0 + Math.floor(i / 4) * dy);
					
					switch (gift.ItemType)
					{
						case "EnergyItem":
						case "Material":
						case "RankPointBottle":
							ctn.AddImage("", gift.ItemType + gift.ItemId, 0, 0).FitRect(45, 45, new Point(7, 7));
							ctn.AddLabel(gift.Num[0] + " ~ " + gift.Num[gift.Num.length - 1], -20, 46, 0xffffff, 1, 0x000000);
							tt = new TooltipFormat();
							tt.text = Localization.getInstance().getString(gift.ItemType + gift.ItemId);
							ctn.setTooltip(tt);
							break;
						case "HerbMedal":
							ctn.AddImage("", gift.ItemType + gift.ItemId, 0, 0).FitRect(45, 45, new Point(7, 7));
							ctn.AddLabel(gift.Num[0] + " ~ " + gift.Num[gift.Num.length - 1], -20, 46, 0xffffff, 1, 0x000000);
							tt = new TooltipFormat();
							tt.text = Localization.getInstance().getString(gift.ItemType + gift.ItemId) + "\n(Sử dụng để đổi Ngọc Ấn)";
							ctn.setTooltip(tt);
							break;
						case "Money":
							ctn.AddImage("", "GiftCoin100", 0, 0).FitRect(45, 45, new Point(7, 7));
							ctn.AddLabel(ConvertToK(gift.Num[0]) + " ~ " + ConvertToK(gift.Num[gift.Num.length - 1]), -20, 46, 0xffffff, 1, 0x000000);
							tt = new TooltipFormat();
							tt.text = "Tiền vàng";
							ctn.setTooltip(tt);
							break;
						case "Exp":
							ctn.AddImage("", "IcExp", 9, 7, true, ALIGN_LEFT_TOP).SetScaleXY(1.3);
							ctn.AddLabel(Ultility.StandardNumber(gift.Num[0]), -20, 46, 0xffffff, 1, 0x000000);
							tt = new TooltipFormat();
							tt.text = "Kinh nghiệm";
							ctn.setTooltip(tt);
							break;
						case "RandomEquipment":
							var strTooltip:String = "Trang bị ";
							if (gift.Color == FishEquipment.FISH_EQUIP_COLOR_PINK)
							{
								ctn.LoadRes("CtnEquipmentDivine");
							}
							else if (gift.Color == FishEquipment.FISH_EQUIP_COLOR_GREEN)
							{
								ctn.LoadRes("CtnEquipmentSpecial");
							}
							ctn.AddImage("", "GuiTooltipHerb_DefaultEquip", 11, 7, true, ALIGN_LEFT_TOP);
							if (gift.Level == 1)
							{
								ctn.AddLabel("Lưỡng Cực", -15, 54, 0xffffff, 1, 0x000000);
								strTooltip += "Lưỡng Cực Thần ngẫu nhiên";
							}
							else if (gift.Level == 2)
							{
								ctn.AddLabel("Anh Hùng", -15, 54, 0xffffff, 1, 0x000000);
								strTooltip += "Anh Hùng Thần ngẫu nhiên";
							}
							ctn.SetScaleX(0.85);
							ctn.SetScaleY(0.82);
							
							tt = new TooltipFormat();
							tt.text = strTooltip;
							ctn.setTooltip(tt);
							break;
					}
					i++;
				}
			}
			
			var btn:Button = AddButton(BTN_1, "Btngreen", 367, 335);
			btn.img.scaleX = btn.img.scaleY = 0.7;
			AddImage("", "IcZingXu", 437, 318).SetScaleXY(1.3);
			AddLabel("" + cfgCost["1"].ZMoney, 392, 312, 0xffffff, 0, 0x000000).setTextFormat(new TextFormat(null, 14));
			
			x0 = 25;
			y0 = 110;
			i = 0;
			
			for (s1 in cfg["2"])
			{
				for (s2 in cfg["2"][s1])
				{
					gift = cfg["2"][s1][s2];
					ctn = AddContainer("", "GuiAutoMixHerbPotion3_Ctn", x0 + (i % numCol) * dx, y0 + Math.floor(i / 4) * dy);
					
					switch (gift.ItemType)
					{
						case "EnergyItem":
						case "Material":
						case "RankPointBottle":
							ctn.AddImage("", gift.ItemType + gift.ItemId, 0, 0).FitRect(45, 45, new Point(7, 7));
							ctn.AddLabel(gift.Num[0] + " ~ " + gift.Num[gift.Num.length - 1], -20, 46, 0xffffff, 1, 0x000000);
							tt = new TooltipFormat();
							tt.text = Localization.getInstance().getString(gift.ItemType + gift.ItemId);
							ctn.setTooltip(tt);
							break;
						case "HerbMedal":
							ctn.AddImage("", gift.ItemType + gift.ItemId, 0, 0).FitRect(45, 45, new Point(7, 7));
							ctn.AddLabel(gift.Num[0] + " ~ " + gift.Num[gift.Num.length - 1], -20, 46, 0xffffff, 1, 0x000000);
							tt = new TooltipFormat();
							tt.text = Localization.getInstance().getString(gift.ItemType + gift.ItemId) + "\n(Sử dụng để đổi Ngọc Ấn)";
							ctn.setTooltip(tt);
							break;
						case "Money":
							ctn.AddImage("", "GiftCoin100", 0, 0).FitRect(45, 45, new Point(7, 7));
							ctn.AddLabel(ConvertToK(gift.Num[0]) + " ~ " + ConvertToK(gift.Num[gift.Num.length - 1]), -20, 46, 0xffffff, 1, 0x000000);
							tt = new TooltipFormat();
							tt.text = "Tiền vàng";
							ctn.setTooltip(tt);
							break;
						case "Exp":
							ctn.AddImage("", "IcExp", 9, 7, true, ALIGN_LEFT_TOP).SetScaleXY(1.3);
							ctn.AddLabel(Ultility.StandardNumber(gift.Num[0]), -20, 46, 0xffffff, 1, 0x000000);
							tt = new TooltipFormat();
							tt.text = "Kinh nghiệm";
							ctn.setTooltip(tt);
							break;
						case "RandomEquipment":
							var strTooltip1:String = "Trang bị ";
							if (gift.Color == FishEquipment.FISH_EQUIP_COLOR_PINK)
							{
								ctn.LoadRes("CtnEquipmentDivine");
							}
							else if (gift.Color == FishEquipment.FISH_EQUIP_COLOR_GREEN)
							{
								ctn.LoadRes("CtnEquipmentSpecial");
							}
							
							ctn.AddImage("", "GuiTooltipHerb_DefaultEquip", 11, 7, true, ALIGN_LEFT_TOP);
							if (gift.Level == 1)
							{
								ctn.AddLabel("Lưỡng Cực", -15, 54, 0xffffff, 1, 0x000000);
								strTooltip1 += "Lưỡng Cực Đặc biệt ngẫu nhiên";
							}
							else if (gift.Level == 2)
							{
								ctn.AddLabel("Anh Hùng", -15, 54, 0xffffff, 1, 0x000000);
								strTooltip1 += "Anh Hùng Đặc biệt ngẫu nhiên";
							}
							ctn.SetScaleX(0.85);
							ctn.SetScaleY(0.82);
							
							tt = new TooltipFormat();
							tt.text = strTooltip1;
							ctn.setTooltip(tt);
							break;
					}
					i++;
				}
			}
			
			btn = AddButton(BTN_2, "Btngreen", 110, 335);
			btn.img.scaleX = btn.img.scaleY = 0.7;
			AddImage("", "IcZingXu", 180, 318).SetScaleXY(1.3);
			
			AddLabel("" + cfgCost["2"].ZMoney, 130, 312, 0xffffff, 0, 0x000000).setTextFormat(new TextFormat(null, 14));
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_THOAT:
					this.Hide();
					break;
				case BTN_1:
					ProcessAuto(int(buttonID.split("_")[1]));
					break;
				case BTN_2:
					ProcessAuto(int(buttonID.split("_")[1]));
					break;
			}
		}
		
		private function ProcessAuto(id:int):void
		{
			if (GameLogic.getInstance().user.GetZMoney() < cfgCost[id].ZMoney)
			{
				GuiMgr.getInstance().GuiNapG.Init();
				return;
			}
			
			GetButton(BTN_1).SetDisable();
			GetButton(BTN_2).SetDisable();
			GetButton(BTN_THOAT).SetDisable();
			
			GameLogic.getInstance().user.UpdateUserZMoney( -cfgCost[id].ZMoney);
			GameLogic.getInstance().user.GetMyInfo().EventInfo.LastTimeUse = GameLogic.getInstance().CurServerTime;
			
			// Cmd
			var cmd:ExchangeHerbItem = new ExchangeHerbItem(3, id);
			Exchange.GetInstance().Send(cmd);
			
			GameLogic.getInstance().user.GetMyInfo().EventInfo.UseHerbPotion[3] += 1;
			
			//EffAutoMix = AddImage("", "EffAutoMixHerb", 200, 200, true, ALIGN_LEFT_TOP);
			
			AddEffect();
			//this.Hide();
		}
		
		public function ShowResult():void
		{
			if (GuiMgr.getInstance().GuiAutoMixHerbPotion3.Result != null)
			{
				GuiMgr.getInstance().GuiGetGiftUseHerb.InitAll(GuiMgr.getInstance().GuiAutoMixHerbPotion3.Result.Gift, true);
				GuiMgr.getInstance().GuiAutoMixHerbPotion3.Hide();
			}
			else
			{
				GuiMgr.getInstance().GuiAutoMixHerbPotion3.AddEffect();
			}
		}
		
		public function AddEffect():void
		{
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffAutoMixHerb", null, 400, 300, false, false, null, function():void { GuiMgr.getInstance().GuiAutoMixHerbPotion3.ShowResult() } );
		}
		
		public override function OnHideGUI():void
		{
			Result = null;
		}
		
		private function ConvertToK(num:int):String
		{
			var numF:Number = num / 1000;
			var str:String = String(numF);
			
			//var str:String = String(num);
			return str + "K";
		}
	}

}