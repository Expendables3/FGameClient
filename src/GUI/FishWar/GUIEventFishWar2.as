package GUI.FishWar 
{
	import Data.Localization;
	import flash.geom.Point;
	import flash.text.engine.FontPosture;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.ProgressBar;
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.GameLogic;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUIEventFishWar2 extends BaseGUI 
	{
		private static const BTN_CLOSE:String = "BtnClose";
		private static const BTN_BACK:String = "BtnBack";
		
		private static const BTN_GET_GIFT_1:String = "BtnGetGift_1";
		private static const BTN_GET_GIFT_2:String = "BtnGetGift_2";
		private static const BTN_GET_GIFT_3:String = "BtnGetGift_3";
		private static const BTN_GET_GIFT_4:String = "BtnGetGift_4";
		
		private var cfg:Object;
		private var myEventInfo:Object;
		private var isChangeOnly:Boolean;
		
		public function GUIEventFishWar2(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIEventFishWar2";
		}
		
		public override function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				SetPos(65, 50);
				
				RefreshGUI(myEventInfo);
			}
			
			LoadRes("GuiEventFishWar2_Theme");
		}
		
		public function Init(isChangeOnly:Boolean = false):void
		{
			this.isChangeOnly = isChangeOnly;
			cfg = ConfigJSON.getInstance().GetSoldierEventConfig("ChangeStar");
			myEventInfo = GameLogic.getInstance().user.GetMyInfo().EventInfo["SoldierEvent"];
			this.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		public function RefreshGUI(myEventInfo:Object):void
		{
			ClearComponent();
			// Add các nút
			AddButton(BTN_CLOSE, "BtnThoat", 647, 20);
			if (!isChangeOnly)
			{
				AddButton(BTN_BACK, "GuiEventFishWar2_BtnQuayLaiGiaiThuong", 50, 455);
			}
			
			//AddStars();
			//AddTime();
			AddBonus();
			
			var luckyNum:int = myEventInfo["LuckyStar"];
			var txtF:TextField = AddLabel(String(luckyNum), 290, 102);
			var tF:TextFormat = new TextFormat();
			tF.size = 20;
			tF.bold = true;
			txtF.setTextFormat(tF);
		}
		
		public function AddTime():void
		{
			// Ngày nhận quà là ngày ngay sau khi event kết thúc
			var cfg:Object = ConfigJSON.getInstance().getEventInfo(GUIEventFishWar.EVENT_NAME);
			var timeStamp:Number = cfg["ExpireTime"] * 1000 + 24 * 60 * 60 * 1000;
			var giftDate:Date = new Date(timeStamp);
			var txtF:TextField = AddLabel(" Phần thưởng sẽ được trao vào ngày: " + giftDate.date + "/" + (int(giftDate.month) + 1), 370, 483, 0xff0000, 1, 0xffffff);
			var tF:TextFormat = new TextFormat();
			tF.size = 20;
			tF.italic = true;
			txtF.setTextFormat(tF);
		}
		
		public function AddBonus():void
		{
			var x0:int = 85;
			var y0:int = 232;
			var dx:int = 145;
			var dy:int = 0;
			var tt:TooltipFormat;
			
			for (var i:int = 1; i <= 4; i++)
			{
				var bonus:Object = cfg[String(i)]["bonus"];
				var ctn:Container;
				if (i != 4)
				{
					AddLabel(Localization.getInstance().getString(bonus.ItemType), x0 + (i - 1) * dx - 20, y0 + (i - 1) * dy - 30, 0x000000, 1, 0xffffff);
					ctn = AddContainer("", "GuiEventFishWar2_ImgBgGiftNormal", x0 + (i - 1) * dx, y0 + (i - 1) * dy);
				}
				else
				{
					AddLabel("Võ Lâm Ngư", x0 + (i - 1) * dx - 20, y0 + (i - 1) * dy - 30, 0x000000, 1, 0xffffff);
					ctn = AddContainer("", "GuiEventFishWar2_ImgBgGiftSpecial", x0 + (i - 1) * dx, y0 + (i - 1) * dy);
				}
				ctn.SetScaleXY(1.05);
				
				var info:Object;
				tt = new TooltipFormat();
				if (!bonus.FormulaType)
				{
					info = ConfigJSON.getInstance().getItemInfo("MixFormula", -1)[bonus["ItemType"]][bonus["ItemId"]];
					ctn.AddImage("", "GuiEventFishWar2_FormulaDefault" + bonus.ItemType, 0, 0).FitRect(50, 50, new Point( 3, 3));
					tt.text = Localization.getInstance().getString(bonus.ItemType);
				}
				else
				{
					info = ConfigJSON.getInstance().getItemInfo("MixFormula", -1)[bonus["FormulaType"]][bonus["ItemId"]];
					ctn.AddImage("", "GuiEventFishWar2_SpecialGiftEventFishWar", 0, 0).FitRect(50, 50, new Point( 3, 3));
					tt.text = "Võ Lâm Ngư";
				}
				
				ctn.setTooltip(tt);
				
				// Vẽ cái nút nhận quà
				var btn:Button = AddButton("BtnGetGift_" + i, "GuiEventFishWar2_BtnChangeKey", x0 + (i - 1) * dx + 7, y0 + (i - 1) * dy + 130);
				if (!myEventInfo.LuckyStar || cfg[i].StarNum > myEventInfo.LuckyStar)
				{
					btn.SetDisable();
				}
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_GET_GIFT_1:
				case BTN_GET_GIFT_2:
				case BTN_GET_GIFT_3:
				case BTN_GET_GIFT_4:
					GuiMgr.getInstance().guiChooseSolider.giftId = int(buttonID.split("_")[1]);
					GuiMgr.getInstance().guiChooseSolider.Show(Constant.GUI_MIN_LAYER, 5);
					this.Hide();
					break;
				case BTN_CLOSE:
					this.Hide();
					break;
				case BTN_BACK:
					GuiMgr.getInstance().GuiEventFishWar.Init();
					this.Hide();
					break;
			}
		}
	}

}