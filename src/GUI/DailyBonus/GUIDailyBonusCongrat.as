package GUI.DailyBonus 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import fl.managers.IFocusManager;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.Ultility;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUIDailyBonusCongrat extends BaseGUI
	{
		private var giftObject:Object;
		private static var BUTTON_CLOSE:String = "ButtonClose";
		private static var BUTTON_SHARE:String = "ButtonShare";
		public function GUIDailyBonusCongrat(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			x = 240;
			y = 800;
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIDailyBonus";
		}
		
		public override function InitGUI(): void
		{
			this.setImgInfo = function():void
			{
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				SetPos(210, 130);
				SetScaleXY(1.2);
				refreshComponent();
			}
			LoadRes("GuiDailyBonusCongrat_Theme");
		}
		
		public function Init(gift:Object):void
		{
			giftObject = gift;
			this.Show(Constant.GUI_MIN_LAYER + 1, 6);
		}
		
		private function refreshComponent():void
		{
			ClearComponent();
			AddButton(BUTTON_CLOSE, "BtnThoat", 340, 55);
			AddButton(BUTTON_SHARE, "BtnFeed", 140, 260);
			
			var image:Image;
			var txtF:TextField;
			//var tt:TooltipFormat = new TooltipFormat();
			switch (giftObject["ItemType"])
			{
				case "Money":
					AddImage("", "GiftCoin100", 228, 195);
					txtF = AddLabel(Ultility.StandardNumber(giftObject["Num"]), 150, 190, 0x000000, 1, 0x26709C);
					//tt.text = "Tiền vàng";
					break;
				case "Material":
					image = AddImage("", "Material" + giftObject["ItemId"], 220 - 10 + 3, 130 + 58);
					image.SetScaleXY(1.2);
					txtF = AddLabel(Ultility.StandardNumber(giftObject["Num"]), 150, 190, 0x000000, 1, 0x26709C);
					//tt.text = Localization.getInstance().getString("Material" + giftObject["ItemId"]);
					break;
				case "EnergyItem":
					image = AddImage("", "EnergyItem" + giftObject["ItemId"], 197 - 8 + 3, 107 + 60);
					image.SetScaleXY(1.2);
					txtF = AddLabel(Ultility.StandardNumber(giftObject["Num"]), 150, 190, 0x000000, 1, 0x26709C);
					//tt.text = Localization.getInstance().getString("EnergyItem" + giftObject["ItemId"]);
					break;
				case "Exp":
					image = AddImage("", "IcExp", 192 - 6 + 2, 102 + 56 + 2);
					image.SetScaleXY(1.6);
					txtF = AddLabel(Ultility.StandardNumber(giftObject["Num"]), 150, 190, 0x000000, 1, 0x26709C);
					//tt.text = "Kinh nghiệm";
					break;
				case "BabyFish":
					if (giftObject["ItemId"] == "")
					{
						 //Lấy ID cá theo level hiện tại
						giftObject["ItemId"] = ConfigJSON.getInstance().GetLevelFish(GuiMgr.getInstance().GuiDailyBonus.GiftList["4"]["Level"]);
					}
					image = AddImage("", "Fish" + giftObject["ItemId"] + "_Old_Idle", 195 - 10 + 7, 123 + 70 - 20, true, ALIGN_LEFT_TOP);
					image.SetScaleXY(0.7);
					//tt.text = Localization.getInstance().getString("Fish" + giftObject["ItemId"]);
					break;
				case "Bracelet":
					image = AddImage("", giftObject["ItemType"] + giftObject["ItemId"] + "_Shop", 175, 160, true, ALIGN_LEFT_TOP);
					break;
				case "RankPointBottle":
					image = AddImage("", giftObject["ItemType"] + giftObject["ItemId"], 170, 125, true, ALIGN_LEFT_TOP);
					txtF = AddLabel(Ultility.StandardNumber(giftObject["Num"]), 150, 190, 0x000000, 1, 0x26709C);
					break;
				case "Diamond":
					image = AddImage("", "Ic" + giftObject["ItemType"] + "Bonous", 160, 140, true, ALIGN_LEFT_TOP);
					txtF = AddLabel(Ultility.StandardNumber(giftObject["Num"]), 150, 190, 0x000000, 1, 0x26709C);
					break;
				case "Swat":
					image = AddImage("", "Swat", 265 - 15, 140 + 50);
					image.SetScaleXY(0.7);
					//tt.text = "Cá đặc nhiệm";
					break;
				case "Ironman":
					image = AddImage("", "Ironman", 265 - 15, 140 + 80);
					image.SetScaleXY(0.7);
					break;
			}
			
			if (txtF)
			{
				var TxtFormat:TextFormat = new TextFormat();
				TxtFormat.color = 0xffffff;
				txtF.setTextFormat(TxtFormat);
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BUTTON_CLOSE:
					this.Hide();
					break;
				case BUTTON_SHARE:
					// Hiện GUI feed
					var day:int = GuiMgr.getInstance().GuiDailyBonus.curDayView;
					GuiMgr.getInstance().GuiFeedWall.ShowFeed("dailyBonus@" + day);
					/*switch (day)
					{
						case 1:
						case 2:
						case 3:
						case 5:
							GuiMgr.getInstance().GuiFeedWall.ShowFeed("dailyBonus@" + day);
							break;
						case 4:
							if (giftObject["ItemType"] == "Ironman")
							{
								GuiMgr.getInstance().GuiFeedWall.ShowFeed("dailyBonus@4");
							}
							break;
					}*/
					Hide();
					break;
			}
		}
	}

}