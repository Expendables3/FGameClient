package GUI.EventMagicPotions.GUIQuestHerb 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.EventMagicPotions.NetworkPacket.ExchangeHerbItem;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * khu vực chế biến thuốc thang
	 * @author longpt
	 */
	public class MixAreaContainer extends Container 
	{
		private static const BTN_MIX_HERB:String = "BtnMixHerb_1";
		private static const BTN_AUTO_MIX:String = "BtnAutoMix";
		private static const CTN_HERB:String = "CtnHerb";
		
		private var HerbId:int;			// Id loại thuốc
		private var curNum:int = 0;			// Số lượng hiện có
		private var componentNumList:Object;
		private var requireNumList:Object;
		
		
		public function MixAreaContainer(parent:Object, id:int, x:int = 0, y:int = 0, imgName:String = "", isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			this.IdObject = "CtnHerbPotion" + id;
			super(parent, "ImgFrameFriend", x, y, isLinkAge, imgAlign);
			HerbId = id;
			curNum = GameLogic.getInstance().user.GetStoreItemCount("HerbPotion", HerbId);
			RefreshContent();
		}
		
		public function RefreshContent():void
		{
			ClearComponent();
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 16;
			
			AddLabel(Localization.getInstance().getString("HerbPotion" + HerbId), 0, 0, 0xffffff, 1 , 0x000000).setTextFormat(txtFormat);
			
			AddImage("", "GuiQuestHerb_Flare", 10, 23, true, ALIGN_LEFT_TOP);
			var ctn:Container = AddContainer(CTN_HERB, "GuiQuestHerb_MixItemContainer", 10, 23, true, this);
			if (HerbId != 3)
			{
				ctn.AddImage("", "HerbPotion" + HerbId, ctn.img.width / 2 + 2, ctn.img.height / 2 + 2);
			}
			else
			{
				ctn.AddImage("", "HerbPotion3_Mass", ctn.img.width / 2 + 2, ctn.img.height / 2 + 2);
			}
			var x0:int = -20;
			var y0:int = 110;
			var dx:int = 50;
			var dy:int = 0;
			var dposx:int = 25;
			
			componentNumList = new Object();
			requireNumList = new Object();
			
			var txF: TextField = AddLabel("Hôm nay còn @num@ lần chế tạo", 0, 195, 0xffffff, 1, 0x000000);
				
			var eventInfo:Object = GameLogic.getInstance().user.GetMyInfo().EventInfo;
			if (!eventInfo["UseHerbPotion"])
			{
				eventInfo["UseHerbPotion"] = new Object();
			}
			
			if (!eventInfo["UseHerbPotion"][HerbId])
			{
				eventInfo["UseHerbPotion"][HerbId] = 0;
			}
			
			if (!eventInfo["LastTimeUse"])
			{
				eventInfo["LastTimeUse"] = 0;
			}
			
			var curDate:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);	// UTC
			var curZoneHour:int = curDate.getUTCHours() + Constant.TIME_ZONE_SERVER;
			var curZoneMin:int = curDate.getUTCMinutes();
			var curZoneSec:int = curDate.getUTCSeconds();
			if (curZoneHour >= 24)
			{
				curZoneHour -= 24;
			}
			var curZoneZero:Number = GameLogic.getInstance().CurServerTime - curZoneHour * 60 * 60 - curZoneMin * 60 - curZoneSec;		// timestamp ma o VN la bat dau ngay hien tai (0h)
			if (eventInfo.LastTimeUse < curZoneZero)
			{
				// Sang ngay moi
				eventInfo["UseHerbPotion"][HerbId] = 0;
			}
			
			var numLeft:int;
			
			if (HerbId != 3)
			{
				numLeft = ConfigJSON.getInstance().GetItemList("HerbPotion")[HerbId].MaxUse - eventInfo.UseHerbPotion[HerbId];
				if (numLeft < 0)
				{
					numLeft = 0;
				}
				
				for (var i:int = 1; i <= 3; i++)
				{
					AddImage("", "Herb" + i, 0, 0, true, ALIGN_LEFT_TOP).FitRect(40, 40, new Point(x0 + dx * (i - 1), y0 + dy * (i - 1)));
					componentNumList[i] = GameLogic.getInstance().user.GetStoreItemCount("Herb", i);
					requireNumList[i] = ConfigJSON.getInstance().GetItemList("HerbPotion")[HerbId]["Exchange"][i]["Num"];
					var color:Object;
					if (componentNumList[i] >= requireNumList[i])
					{
						color = 0x00ff00;
					}
					else
					{
						color = 0xff0000;
					}
					var txtF:TextField = AddLabel(componentNumList[i] + "/" + requireNumList[i], x0 + dx * (i - 1) - 30, y0 + dy * (i - 1) + 30, 0xff0000, 1, 0x000000);
					txtF.autoSize = "center";
					var tF:TextFormat = new TextFormat();
					tF.color = color;
					tF.size = 15;
					txtF.setTextFormat(tF);
				}
				
				var btn:Button = AddButton(BTN_MIX_HERB, "GuiQuestHerb_BtnMixHerb", 15, 170);
				
				for (var s:String in componentNumList)
				{
					if (componentNumList[s] < requireNumList[s])
					{
						btn.SetDisable();
						break;
					}
				}
				if (numLeft <= 0)
				{
					btn.SetDisable();
				}
			}
			else
			{
				numLeft = ConfigJSON.getInstance().GetItemList("MagicPotion_AutoCost")["1"].Limit - eventInfo.UseHerbPotion[HerbId];
				if (numLeft < 0)
				{
					numLeft = 0;
				}
				
				AddLabel("Không yêu cầu nguyên liệu!", -40, 120, 0xffffff, 0, 0x000000).setTextFormat(new TextFormat(null, 15));
				btn = AddButton(BTN_AUTO_MIX, "GuiQuestHerb_BtnAutoMix", -13, 170);
				
				if (numLeft <= 0)
				{
					btn.SetDisable();
				}
			}
			
			
			txF.text = txF.text.replace("@num@", numLeft);
			
			txtFormat = new TextFormat();
			txtFormat.color = 0x00ff00;
			if (numLeft <= 0)
			{
				txtFormat.color = 0xff0000;
			}
			txtFormat.size = 15;
			txF.setTextFormat(txtFormat, txF.text.search("n ") + 2, txF.text.search(" l"));
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_MIX_HERB:
					GetButton(BTN_MIX_HERB).SetDisable();
					processMix();
					break;
				case BTN_AUTO_MIX:
					//GetButton(BTN_AUTO_MIX).SetDisable();
					processAutoMix();
					break;
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			if (buttonID == CTN_HERB && HerbId != 3)
			{
				if (!GuiMgr.getInstance().GuiTooltipHerb.IsVisible)
				{
					GuiMgr.getInstance().GuiTooltipHerb.Init(HerbId);
				}
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (buttonID == CTN_HERB && HerbId != 3)
			{
				if (GuiMgr.getInstance().GuiTooltipHerb.IsVisible)
				{
					GuiMgr.getInstance().GuiTooltipHerb.Hide();
				}
			}
		}
		
		/**
		 * Bắt đầu chế thuốc
		 */
		private function processMix():void
		{
			var s:String;
			
			// Cmd
			var cmd:ExchangeHerbItem = new ExchangeHerbItem(HerbId);
			Exchange.GetInstance().Send(cmd);
			
			GameLogic.getInstance().user.GetMyInfo().EventInfo.UseHerbPotion[HerbId] += 1;
			GameLogic.getInstance().user.GetMyInfo().EventInfo.LastTimeUse = GameLogic.getInstance().CurServerTime;
			
			// Add kho
			GuiMgr.getInstance().GuiStore.UpdateStore("HerbPotion", HerbId, 1);
			if (HerbId == GUIQuestHerb.HERB_POTION_GOD)
			{
				GuiMgr.getInstance().GuiStore.UpdateStore("HerbMedal", 1, 1);
			}
			for (s in componentNumList)
			{
				GuiMgr.getInstance().GuiStore.UpdateStore("Herb", int(s), -requireNumList[s]);
			}
			
			// Effect
			EffectMgr.setEffBounceDown("Nhận thành công", "HerbPotion" + HerbId, 330, 280);
			
			GuiMgr.getInstance().GuiQuestHerb.RefreshComponent();
		}
		
		private function processAutoMix():void
		{
			//GuiMgr.getInstance().GuiQuestHerb.Hide();
			GuiMgr.getInstance().GuiAutoMixHerbPotion3.Show(Constant.GUI_MIN_LAYER, 3);
		}
	}

}