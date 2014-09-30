package GUI.FishWar 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.TooltipFormat;
	import GUI.GUIFishStatus;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameMode;
	import NetworkPacket.PacketSend.SendBuyOther;
	import NetworkPacket.PacketSend.SendRecoverHealthSoldier;
	import Sound.SoundMgr;
	import GUI.component.Button;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUIRecoverHealth extends BaseGUI 
	{
		public static const BUTTON_CLOSE:String = "ButtonClose";
		public static const BUTTON_USE_1:String = "ButtonUse_1";
		public static const BUTTON_USE_2:String = "ButtonUse_2";
		public static const BUTTON_USE_3:String = "ButtonUse_3";
		
		public static const BUTTON_BUY_1:String = "ButtonBuy_1";
		public static const BUTTON_BUY_2:String = "ButtonBuy_2";
		public static const BUTTON_BUY_3:String = "ButtonBuy_3";
		
		public static const CTN_USE_1:String = "CtnUse_1";
		public static const CTN_USE_2:String = "CtnUse_2";
		public static const CTN_USE_3:String = "CtnUse_3";
		
		public var RecoverList:Object;
		
		public var fs:FishSoldier;
			
		public function GUIRecoverHealth(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIRecoverHealth";
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
				SetPos(170, 130);
				refreshComponent();
			}			
			LoadRes("GuiRecoverHealth_Theme");
		}
		
		public function Init(f:FishSoldier):void
		{
			RecoverList = ConfigJSON.getInstance().GetItemList("RecoverHealthSoldier");
			fs = f;
			this.Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		private function refreshComponent():void
		{
			ClearComponent();
			
			// AddButtonClose
			var b:Button = AddButton(BUTTON_CLOSE, "BtnThoat", 433, 22);
			b.img.scaleX = 1.3;
			b.img.scaleY = 1.3;
			
			// AddTitle
			AddImage("", "GuiRecoverHealth_Title", 220, 35).SetScaleXY(1.3);
			
			var i:int = 0;
			var x0:int = -60;
			var y0:int = 120;
			var dx:int = 120;
			
			var ctn:Container; 
			var btn:Button;
			var txtF:TextField;
			var tF:TextFormat;
			var tt:TooltipFormat;
			var arr:Array;
			var l:int;
			var txtFo:TextFormat;
			
			for (var str:String in RecoverList)
			{
				i++;
				var recoverStore:Array = GameLogic.getInstance().user.StockThingsArr.RecoverHealthSoldier;
				var isHave:Boolean = false;
				for (var j:int = 0; j < recoverStore.length; j++)
				{
					if (recoverStore[j]["Id"] == str)
					{
						isHave = true;
						break;
					}
				}
				
				if (!isHave)
				{
					ctn = AddContainer("Other_" + str, "GuiRecoverHealth_ImgBgGiftNormal", x0 + dx * i, y0, true, this);
					ctn.img.scaleX = ctn.img.scaleY = 1.8;
					
					tt = new TooltipFormat();
					tt.text = Localization.getInstance().getString("RecoverHealthSoldier" + str);
					tt.text = tt.text.replace("@Value@", RecoverList[str].Num + "");
					arr = Localization.getInstance().getString("RecoverHealthSoldier" + str).split("\n");
					l = (arr[0] as String).length;
					txtFo = new TextFormat();
					txtFo.size = 14;
					txtFo.color = 0xff00ff;
					txtFo.bold = true;
					tt.setTextFormat(txtFo, 0, l);
					ctn.setTooltip(tt);
					
					btn = AddButton("ButtonBuy_" + str, "GuiRecoverHealth_BtnGreen", x0 + dx * i + 7, y0 + 145);
					btn.img.scaleX = 0.9;
					btn.img.scaleY = 0.9;
					AddImage("", "IcZingXu", x0 + dx * i + 83, y0 + 121).SetScaleXY(1.6);
					
					txtF = AddLabel("Mua " + RecoverList[str]["ZMoney"], x0 + dx * i - 10, y0 + 115);
					tF = new TextFormat();
					tF.size = 20;
					tF.color = 0xffffff;
					txtF.setTextFormat(tF);
					
					ctn.AddImage("", "RecoverHealthSoldier" + str, ctn.img.width/2- 15, ctn.img.height/2 - 20, true, ALIGN_CENTER_CENTER).FitRect(50,50, new Point(5, 5));
					
					txtF = ctn.AddLabel("0", 0, 35, 0x000000, 1, 0xffffff);
					tF = new TextFormat();
					tF.size = 16;
					txtF.setTextFormat(tF);
					
					// Không cho mua bình fill đầy Năng Lượng
					if (parseInt(str) == 3)
					{
						btn.SetDisable();
					}
					
				}
				else
				{
					ctn = AddContainer("CtnUse_" + str, "GuiRecoverHealth_ImgBgGiftNormal", x0 + dx * i, y0, true, this);
					ctn.img.scaleX = ctn.img.scaleY = 1.8;
					
					tt = new TooltipFormat();
					tt.text = Localization.getInstance().getString("RecoverHealthSoldier" + str);
					tt.text = tt.text.replace("@Value@", RecoverList[str].Num + "");
					arr = Localization.getInstance().getString("RecoverHealthSoldier" + str).split("\n");
					l = (arr[0] as String).length;
					txtFo = new TextFormat();
					txtFo.size = 14;
					txtFo.color = 0xff00ff;
					txtFo.bold = true;
					tt.setTextFormat(txtFo, 0, l);
					ctn.setTooltip(tt);
					
					ctn.AddImage("", "RecoverHealthSoldier" + str, ctn.img.width/2- 15, ctn.img.height/2 - 20, true, ALIGN_CENTER_CENTER).FitRect(50,50, new Point(5, 5));
					
					txtF = ctn.AddLabel(String(recoverStore[j].Num), 0, 35, 0x000000, 1, 0xffffff);
					tF = new TextFormat();
					tF.size = 16;
					txtF.setTextFormat(tF);
					
					btn = AddButton("ButtonUse_" + str, "GuiRecoverHealth_BtnGreen", x0 + dx * i + 7, y0 + 145);
					btn.img.scaleX = 0.9;
					btn.img.scaleY = 0.9;
					//AddImage("", "IcZingXu", x0 + dx * i + 80, y0 + 120).SetScaleXY(1.5);
					
					txtF = AddLabel("Dùng", x0 + dx * i + 5, y0 + 115);
					tF = new TextFormat();
					tF.size = 20;
					tF.color = 0xffffff;
					txtF.setTextFormat(tF);
				}
				
				
			}
			
			txtF = AddLabel("Sức khỏe hiện tại: " + fs.Health + "/" + fs.MaxHealth, 190, 80, 0x000000, 1, 0xffffff);
			tF = new TextFormat();
			tF.size = 17;
			tF.bold = true;
			tF.italic = true;
			txtF.setTextFormat(tF);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BUTTON_CLOSE:
					this.Hide();
					break;
				case BUTTON_USE_1:
				case BUTTON_USE_2:
				case BUTTON_USE_3:
				case CTN_USE_1:
				case CTN_USE_2:
				case CTN_USE_3:
					processRecoverHealth(buttonID);
					if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)
					{
						GuiMgr.getInstance().GuiMainFishWorld.ClearStoreComponent();
						GuiMgr.getInstance().GuiMainFishWorld.InitStore(GuiMgr.getInstance().GuiMainFishWorld.CurrentStore, GuiMgr.getInstance().GuiMainFishWorld.CurrentPage);
					}
					this.Hide();
					break;
				case BUTTON_BUY_1:
				case BUTTON_BUY_2:
				case BUTTON_BUY_3:
					var a1:Array = buttonID.split("_");
					
					var MoneyHave:int = GameLogic.getInstance().user.GetZMoney();
					var MoneyNeed:int = RecoverList[a1[1]]["ZMoney"];
					
					if (MoneyHave < MoneyNeed)
					{
						GuiMgr.getInstance().GuiNapG.Init();
						break;
					}
					else
					{
						var test:SendBuyOther = new SendBuyOther();
						test.AddNew("RecoverHealthSoldier", a1[1], 1, "ZMoney");
						Exchange.GetInstance().Send(test);
						GameLogic.getInstance().user.UpdateUserZMoney( - MoneyNeed);
						
						if (GuiMgr.getInstance().GuiStore.IsVisible)
						{
							GuiMgr.getInstance().GuiStore.UpdateStore("RecoverHealthSoldier", a1[1]);
						}
						else
						{
							GameLogic.getInstance().user.UpdateStockThing("RecoverHealthSoldier", a1[1]);
						}
					}
					processRecoverHealth("ButtonUse_" + a1[1]);
					this.Hide();
					break;
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{	
			var a:Array = buttonID.split("_");
			if (a[0] == "Other" || a[0] == "CtnUse")
			{
				GetContainer(buttonID).SetHighLight();
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			var a:Array = buttonID.split("_");
			if (a[0] == "Other" || a[0] == "CtnUse")
			{
				GetContainer(buttonID).SetHighLight( -1);
			}
		}
		
		private function processRecoverHealth(buttonID:String):void
		{
			var a:Array = buttonID.split("_");
			// Gửi gói tin
			var cmd:SendRecoverHealthSoldier = new SendRecoverHealthSoldier(fs.Id, fs.LakeId, a[1]);
			Exchange.GetInstance().Send(cmd);
			
			// Cập nhật kho
			//if (GuiMgr.getInstance().GuiStoreSoldier.IsVisible)
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				//GuiMgr.getInstance().GuiStoreSoldier.UpdateStore("RecoverHealthSoldier", a[1], -1);
				GuiMgr.getInstance().GuiStore.UpdateStore("RecoverHealthSoldier", a[1], -1);
			}
			else
			{
				GameLogic.getInstance().user.UpdateStockThing("RecoverHealthSoldier", a[1], -1);
			}
			
			// Cá khỏe lại
			fs.UpdateHealth(RecoverList[a[1]]["Num"]);

			// Effect cá khỏe lại
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
			{
				fs.SetEmotion(Fish.HAPPY);
			}
			else
			{
				fs.SetEmotion(Fish.IDLE);
			}
			
			// Cập nhật vào mảng MyFishSoldier
			for (var i:int = 0; i < GameLogic.getInstance().user.GetMyInfo().MySoldierArr.length; i++)
			{
				if (GameLogic.getInstance().user.GetMyInfo().MySoldierArr[i].Id == fs.Id)
				{
					GameLogic.getInstance().user.GetMyInfo().MySoldierArr[i].UpdateHealth(RecoverList[a[1]]["Num"]); 
					GameLogic.getInstance().user.GetMyInfo().MySoldierArr[i].LastHealthTime = GameLogic.getInstance().CurServerTime;
					break;
				}
			}
			
			if (fs.GuiFishStatus.IsVisible && fs.GuiFishStatus.prgHealth)
			{
				fs.GuiFishStatus.prgHealth.setStatus(fs.Health/fs.MaxHealth);
			}
		}
	}

}