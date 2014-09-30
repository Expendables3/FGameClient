package GUI.FishWar 
{
	import adobe.utils.ProductManager;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import GUI.GUIShop;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameMode;
	import NetworkPacket.PacketSend.SendBuyOther;
	import NetworkPacket.PacketSend.SendRebornSoldier;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUIReviveFishSoldier extends BaseGUI 
	{
		public static const BUTTON_CLOSE:String = "ButtonClose";
		public static const BUTTON_USE_1:String = "ButtonUse_1";
		public static const BUTTON_USE_2:String = "ButtonUse_2";
		public static const BUTTON_USE_3:String = "ButtonUse_3";
		public static const BUTTON_USE_4:String = "ButtonUse_4";
		public static const BUTTON_USE_5:String = "ButtonUse_5";
		public static const BUTTON_USE_6:String = "ButtonUse_6";
		
		public static const BUTTON_BUY_1:String = "ButtonBuy_1";
		public static const BUTTON_BUY_2:String = "ButtonBuy_2";
		public static const BUTTON_BUY_3:String = "ButtonBuy_3";
		public static const BUTTON_BUY_4:String = "ButtonBuy_4";
		public static const BUTTON_BUY_5:String = "ButtonBuy_5";
		public static const BUTTON_BUY_6:String = "ButtonBuy_6";
		
		public var GinsengList:Object;
		
		public var fs:FishSoldier;
		public var isGrave:Boolean;
		
		public function GUIReviveFishSoldier(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIReviveFishSoldier";
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
				refreshComponent(fs.Rank);
			}			
			LoadRes("GuiRevive_Theme");
		}
		
		public function Init(f:FishSoldier, isGrave:Boolean = false):void
		{
			GinsengList = ConfigJSON.getInstance().GetItemList("Ginseng");
			this.isGrave = isGrave;
			fs = f;
			this.Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		private function refreshComponent(rank:int):void
		{
			ClearComponent();
			AddImage("", "GuiRevive_Title", 230, 34).SetScaleXY(1.3);
			
			
			// AddButtonClose
			
			var i:int = 0;
			var x0:int = -50;
			var y0:int = 165;
			var dx:int = 120;
			var num:int = 0;
			for (var str:String in GinsengList)
			{
				var isUsable:Boolean = false;
				for (var ii:int = 0; ii < GinsengList[str]["Rank"].length; ii++)
				{
					if (GinsengList[str]["Rank"][ii] == rank)
					{
						isUsable = true;
						break;
					}
				}
				
				if (isUsable)
				{
					i++;
					var gsStore:Array = GameLogic.getInstance().user.StockThingsArr.Ginseng;
					var isHave:Boolean = false;
					num = 0;
					for (var j:int = 0; j < gsStore.length; j++)
					{
						if (gsStore[j]["Id"] == str)
						{
							isHave = true;
							num = gsStore[j]["Num"];
							break;
						}
					}
					
					var time:int = GinsengList[str]["Expired"] / 86400;
					var ctn:Container;
					var btn:Button;
					var txtF:TextField;
					var tF:TextFormat;
					
					if (!isHave)
					{
						ctn = AddContainer("Info_" + str, "GuiRevive_ImgBgGiftNormal", x0 + dx * i, y0 - 30, true, this);
						ctn.img.scaleX = ctn.img.scaleY = 1.5;
						
						btn = AddButton("ButtonBuy_" + str, "GuiRevive_BtnGreen", x0 + dx * i + 5, y0 + 90);
						btn.img.scaleX = 0.75;
						btn.img.scaleY = 0.8;
						AddImage("", "IcZingXu", x0 + dx * i + 75, y0 + 70).SetScaleXY(1.5);
						var MoneyNeed:int = GinsengList[str]["ZMoney"];
						txtF = AddLabel(MoneyNeed + "", x0 + dx * i - 7, y0 + 62);
					
						tF = new TextFormat();
						tF.size = 20;
						tF.color = 0xffffff;
						txtF.setTextFormat(tF);
						
						if (GinsengList[str].UnlockType == GUIShop.UNLOCK_TYPE_UNUSED)
						{
							btn.SetDisable();
						}
					}
					else
					{
						ctn = AddContainer("Info_" + str, "GuiRevive_ImgBgGiftNormal", x0 + dx * i, y0 - 30, true, this);
						ctn.img.scaleX = ctn.img.scaleY = 1.5;
						
						btn = AddButton("ButtonUse_" + str, "GuiRevive_BtnGreen", x0 + dx * i + 5, y0 + 90);
						btn.img.scaleX = 0.75;
						btn.img.scaleY = 0.8;
						txtF = AddLabel("Dùng", x0 + dx * i - 5, y0 + 60);
					
						tF = new TextFormat();
						tF.size = 20;
						tF.color = 0xffffff;
						txtF.setTextFormat(tF);
					}
					
					ctn.AddImage("", "Ginseng" + str, ctn.img.width / 2 - 15, ctn.img.height / 2 - 15, true, ALIGN_CENTER_CENTER);
					var tt:TooltipFormat = new TooltipFormat();
					tt.text = Localization.getInstance().getString("Ginseng" + str);
					tt.text = tt.text.replace("@Value@", int(GinsengList[str].Expired / (3600 * 24) + ""));

					var arr:Array = Localization.getInstance().getString("Ginseng" + str).split("\n");
					var l:int = (arr[0] as String).length;
					var txtFo:TextFormat = new TextFormat();
					txtFo.size = 14;
					txtFo.color = 0xff00ff;
					txtFo.bold = true;
					tt.setTextFormat(txtFo, 0, l);
					
					if (GinsengList[str].UnlockType == GUIShop.UNLOCK_TYPE_UNUSED)
					{
						//var extraStr:String = "SẮP RA MẮT";
						//var tFExtra:TextFormat = new TextFormat();
						//tFExtra.size = 20;
						//tFExtra.color = 0xff0000;
						//tFExtra.bold = true;
						//l = tt.text.length;
						//tt.text += "\n" + extraStr;
						//tt.setTextFormat(tFExtra, l, tt.length);
						var ttt:TooltipFormat = new TooltipFormat();
						ttt.text = "Sắp ra mắt";
						btn.setTooltip(ttt);
					}
					ctn.setTooltip(tt);
					
					txtF = ctn.AddLabel(num + "", 0, 35, 0x000000, 1, 0xffffff);
					txtFo = new TextFormat();
					txtFo.size = 16;
					txtFo.color = 0xff00ff;
					txtFo.bold = true;
					txtF.setTextFormat(txtFo);
				}
			}
			var b:Button = AddButton(BUTTON_CLOSE, "BtnThoat", 433, 22);
			b.img.scaleX = 1.3;
			b.img.scaleY = 1.3;
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BUTTON_CLOSE:
					this.Hide();
					break;
				case BUTTON_BUY_1:
				case BUTTON_BUY_2:
				case BUTTON_BUY_3:
				case BUTTON_BUY_4:
				case BUTTON_BUY_5:
				case BUTTON_BUY_6:
					var a1:Array = buttonID.split("_");
					
					var MoneyHave:int = GameLogic.getInstance().user.GetZMoney();
					var MoneyNeed:int = GinsengList[a1[1]]["ZMoney"];
					
					if (MoneyHave < MoneyNeed)
					{
						GuiMgr.getInstance().GuiNapG.Init();
						break;
					}
					else
					{
						var test:SendBuyOther = new SendBuyOther();
						test.AddNew("Ginseng", a1[1], 1, "ZMoney");
						Exchange.GetInstance().Send(test);
						GameLogic.getInstance().user.UpdateUserZMoney( - MoneyNeed);
						
						
						GuiMgr.getInstance().GuiStore.UpdateStore("Ginseng", a1[1]);
					}
					//refreshComponent(fs.Rank);
					//break;
				case BUTTON_USE_1:
				case BUTTON_USE_2:
				case BUTTON_USE_3:
				case BUTTON_USE_4:
				case BUTTON_USE_5:
				case BUTTON_USE_6:
					var a:Array = buttonID.split("_");
					// Gửi gói tin
					var cmd:SendRebornSoldier = new SendRebornSoldier(fs.Id, fs.LakeId, a[1], isGrave);
					Exchange.GetInstance().Send(cmd);
					
					// Cập nhật kho
					GuiMgr.getInstance().GuiStore.UpdateStore("Ginseng", a[1], -1);
					
					if (isGrave)
					{
						GameLogic.getInstance().user.FishSoldierExpired.splice(GameLogic.getInstance().user.FishSoldierExpired.indexOf(fs), 1);
						GameLogic.getInstance().user.GetMyInfo().MySoldierArr.push(fs);
						GameLogic.getInstance().user.FishSoldierArr.push(fs);
					}
					
					// Cá khỏe lại
					fs.OriginalStartTime = GameLogic.getInstance().CurServerTime;
					fs.LifeTime = GinsengList[a[1]]["Expired"];
					if (LeagueController.getInstance().mode == LeagueController.IN_HOME)
					{
						if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
						{
							fs.SetEmotion(Fish.HAPPY);
						}
						else
						{
							fs.SetEmotion(Fish.IDLE);
						}
					}
					else 
					{
						fs.SetMovingState(Fish.FS_STANDBY);
						fs.SetEmotion(Fish.IDLE);
						
					}
					// Cập nhật trong cả mảng mySoldierArr
					var fArr:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
					var i:int;
					for (i = 0; i < fArr.length; i++)
					{
						if (fArr[i].Id == fs.Id)
						{
							fArr[i].LifeTime = fs.LifeTime;
							fArr[i].OriginalStartTime = fs.OriginalStartTime;
							fArr[i].CheckStatus(false);
							break;
						}
					}
					fs.CheckStatus(false);
					if(LeagueController.getInstance().mode==LeagueController.IN_HOME)
						fs.UpdateFishInCombat(true);
					if (isGrave)
					{
						fs.SetMovingState(Fish.FS_SWIM);
					}
					this.Hide();
					break;
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{	
			var a:Array = buttonID.split("_");
			if (a[0] == "Info")
			{
				GetContainer(buttonID).SetHighLight();
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			var a:Array = buttonID.split("_");
			if (a[0] == "Info")
			{
				GetContainer(buttonID).SetHighLight( -1);
			}
		}
	}

}