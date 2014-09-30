package GUI 
{
	import Effect.EffectMgr;
	import Effect.ImgEffectBuble;
	import Effect.ImgEffectFly;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.ActiveTooltip;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWorld.BossMgr;
	import GUI.FishWorld.Network.SendLoadOcean;
	import NetworkPacket.PacketReceive.GetLoadInventory;
	import NetworkPacket.PacketSend.SendChangeSparta;
	import Sound.SoundMgr;
	
	import flash.events.*;
	import GUI.component.BaseGUI;
	import Logic.*;
	import Data.*;
	import GameControl.*;
	import NetworkPacket.PacketSend.SendFishChangeLake;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class GUIMain extends BaseGUI
	{
		//public static const BTN_SERIQUEST:String = "BtnSeriQuest";
		
		//static public const BTN_TOURNAMENT:String = "BtnTournament";
		//public const BTN_COME_BACK_MAP:String = "BtnComeBackMap";
		private const GUI_MAIN_BTN_AVATAR:String = "0";
		private const GUI_MAIN_BTN_INVENTORY:String = "1";
		private const GUI_MAIN_BTN_SHOP:String = "2";
		private const GUI_MAIN_BTN_MOUSE_DEFAULT:String = "3";
		private const GUI_MAIN_BTN_FEED:String = "4";
		private const GUI_MAIN_BTN_HOOK:String = "5";
		private const GUI_MAIN_BTN_FISHING_NET:String = "6";
		private const GUI_MAIN_BTN_CURE_FISH:String = "7";
		private const GUI_MAIN_BTN_HOME:String = "8";
		private const GUI_MAIN_BTN_MOVE_LEFT:String = "9";
		private const GUI_MAIN_BTN_MOVE_RIGHT:String = "10";
		private const GUI_MAIN_BTN_MIX:String = "11";
		private const GUI_MAIN_BTN_RAW:String = "12";
		private const GUI_MAIN_BTN_EXPAND:String = "13";
		private const GUI_MAIN_BTN_UNLOCK_LAKE_2:String = "btnUnlockLake1";
		private const GUI_MAIN_BTN_UNLOCK_LAKE_3:String = "btnUnlockLake2";
		private const GUI_MAIN_BTN_FISHMACHINE:String = "btnFishMachine";
		private const GUI_MAIN_BTN_INVENTORY_SOLDIER:String = "14";
		private const GUI_MAIN_IMG_NEW:String = "icNew";
		
		//button hop qua
		private const GUI_MAIN_BTN_GIFT:String = "11";
		
	
		// mo ho ca'
		private const GUI_MAIN_BTN_OPEN_LAKE:String = "15";
		private const GUI_MAIN_BTN_UPGRADE_LAKE:String = "16";	
		
		private const GUI_MAIN_BTN_EDIT_DECORATE:String = "17";
		private const GUI_MAIN_BTN_SAVE_DECORATE:String = "18";
		private const GUI_MAIN_BTN_HIDE_LAKE:String = "19";		
		
		// Chọi cá
		private const GUI_MAIN_BTN_WAR:String = "20";
		private const GUI_MAIN_BTN_PEACE:String = "21";
		private const GUI_MAIN_BTN_EXTEND_EQUIPMENT:String = "22";
		private const GUI_MAIN_BTN_EXTEND_DECO:String = "23";
		
		//private const NUM_POINT_START:int = 365;		
		private const NUM_POINT_START:int = 500;		
		
		
		public var imgBackground:Image;
		public var imgBgLake:Image;
		public var iconFish:Image;
		public var iconAlert:Image;
		public var lblNumFish:TextField = null;
		private var btnUpgradeLakes:Button = null;
		public var btnShop:ButtonEx = null;
		//public var btnAvatar:Button = null;
		public var btnFishingNet:ButtonEx = null;
		public var btnInventory:ButtonEx = null;	
		//public var btnInventorySoldier:ButtonEx = null;
		public var btnMouseDefault:ButtonEx = null;	
		public var btnFeed:ButtonEx = null;	
		//public var btnEditDeco:ButtonEx = null;	
		public var btnHome:ButtonEx = null;	
		public var btnHook:ButtonEx = null;
		public var btnMix:ButtonEx = null;
		public var btnRaw:ButtonEx = null;
		public var btnExpand:Button = null;
		public var btnUnlockLake2:Button = null;
		public var btnMapOcean: Button;		
		public var btnExMapOcean:ButtonEx;		
		public var btnUnlockLake3:Button = null;
		public var btnFishMachine:ButtonEx = null;
		//public var btnTournament:ButtonEx;
		public var arrowTournament:Image;
		
		// button Chọi cá
		public var btnWar:ButtonEx = null;
		public var btnPeace:ButtonEx = null;
		public var isSwitchable:Boolean = true;
		public var isSendLoadOcean:Boolean = false;
		
		public var btnExtendEquipment:Button;
		//public var btnExtendDeco:Button;
		
		public var btnNextFish:Button;
		public var btnPreviousFish:Button;
		public var ctnFishWar:Container;
		
		public var SelectedLake:Lake;
		public var MovedFishLake: int = -1;
		public var btnLakeArr:Array = [];
		//public var btnLockArr:Array = [];
		
		//private var btnSaveDeco:Button = null;
		//public var btnQuestArr:Array = [];
		
		//happy monday
		private var imgFeedMonday:ButtonEx;
		private var imgHitSoldierMonday:ButtonEx;
		private var imgFishWorldMonday:ButtonEx;
		private var imgFishingMonday:ButtonEx;
		private var imgRawMatMonday:ButtonEx;
		
		public var txtFoodCount:TextField = null;
		public var txtCombatCount:TextField = null;
		private var OldViewerStatus:Boolean = false;
		
		private var expandLake:TextField;
		private var unlockLabel2:TextField;
		private var unlockLabel3:TextField;
		
		private var isHelpExpand:Boolean;
		private var isHelpUnlock:Boolean;
		private var arrow:Image;
		private var arrowUnlock:Image;
		
		private var OldFishNum:int = 0;
		private var OldCurLake:int = 0;
		private var OldFoodNum:int = 0;
		
		private var today:Date;
		public function GUIMain(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIMain";
		}
		
		public override function InitGUI() :void
		{
			LoadRes("");
			var tooltip:TooltipFormat;
			imgBackground = AddImage("", "ImgBgGUIMain", 0, 0, true, ALIGN_LEFT_TOP);
			
			isHelpExpand = false;
			isHelpUnlock = false;
			//AddLabel("ver: 1.0.0.0.25", 110, 10, 0xffffff);				
			//AddLabel("ver: 30.0.0", 35, -50, 0xffffff, 1, 0x26709C);
			//AddImage("BgGUiFriend", "ImgBgFriendAvatar", 405, 73);
			//imgBgLake = AddImage("LakeBg", "ImgBgLake", 105, 13);
			imgBgLake = AddImage("LakeBg", "ImgBgLake", 105, 0);
			var i:int = 0;
			for (i = 1; i <= 3; i++)
			{
				var container:Container = AddContainer("BtnLake_" + i, "ImgAvatar", 8 + i * 45, -11, true, this);
				var btnLake:Button = container.AddButton("ButtonLake", "BtnLake" + i, 0, 0, null);
				//var lbl:TextField = container.AddLabel(i.toString(), -35, 35, 0, 1, 0x26709C);
				//var format:TextFormat = new TextFormat("Arial", 16, 0xffffff, true);
				//format.align = "center";
				//lbl.setTextFormat(format);
				
				var imgArrow:Image = container.AddImage("Arrow_" + i, "ImgArrowLake", 27, -5);
				//var imgArrow:Image = container.AddImage("Arrow_" + i, "ImgShopItemLock", 27, -5);
				imgArrow.img.mouseChildren = false;
				imgArrow.img.mouseEnabled = false;
				imgArrow.img.visible = false;
				
				var lock:Image = container.AddImage("LockLake_" + i, "ImgShopItemLock", 0, 30);
				lock.img.mouseChildren = false;
				lock.img.mouseEnabled = false;
				btnLake.SetEnable(false);
				btnLakeArr.push(container);
				lock.SetSize(20, 20);
			}
			//btnHook.TooltipText = Localization.getInstance().getString("Tooltip9");			
			
			// so luong ca trong be
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 18;
			txtFormat.color = 0xFFFFFF;
			txtFormat.bold = true;
			txtFormat.align = "center";
			var tmpContain:Container = AddContainer("", "CtnAvatar", 44, 28, true, this);
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip24");
			tmpContain.setTooltip(tooltip);
			lblNumFish = tmpContain.AddLabel("0 / 0", 165, -29, 0, 1, 0x26709C);
			lblNumFish.autoSize = "center";		
			lblNumFish.defaultTextFormat = txtFormat;
			lblNumFish.setTextFormat(txtFormat);
			lblNumFish.width = lblNumFish.textWidth;	
			// Hình con cá
			iconFish = tmpContain.AddImage("", "IcFish", 175, -15);			
			
			// Quangvh - Main
			// button tuy theo user la gi
			//btnAvatar = AddButton(GUI_MAIN_BTN_AVATAR, "button_thayavatar", imgBackground.img.width / 2 - (NUM_POINT_START - 760), 2 - 25, this);
			//btnAvatar.img.width = 50;
			//btnAvatar.img.height = 50;
			//tooltip = new TooltipFormat();
			//tooltip.text = Localization.getInstance().getString("Tooltip0");
			//btnAvatar.setTooltip(tooltip);	
			btnInventory = AddButtonEx(GUI_MAIN_BTN_INVENTORY, "BtnInventory", imgBackground.img.width / 2 - (NUM_POINT_START - 432), 2, this, INI.getInstance().getHelper("helper17"));
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip1");
			btnInventory.setTooltip(tooltip);	
			//btnInventorySoldier = AddButtonEx(GUI_MAIN_BTN_INVENTORY_SOLDIER, "BtnInventorySoldier", imgBackground.img.width / 2 - (NUM_POINT_START - 432), 2, this, INI.getInstance().getHelper("helper22"));
			//tooltip = new TooltipFormat();
			//tooltip.text = Localization.getInstance().getString("Tooltip64");
			//btnInventorySoldier.setTooltip(tooltip);
			btnShop = AddButtonEx(GUI_MAIN_BTN_SHOP, "BtnShop", imgBackground.img.width / 2 - (NUM_POINT_START - 388), 2, this, INI.getInstance().getHelper("helper1"));
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip2");
			btnShop.setTooltip(tooltip);
			btnMouseDefault = AddButtonEx(GUI_MAIN_BTN_MOUSE_DEFAULT, "BtnMouseDefault", imgBackground.img.width / 2 - (NUM_POINT_START - 576), 2, this);
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip3");
			btnMouseDefault.setTooltip(tooltip);
			btnFeed = AddButtonEx(GUI_MAIN_BTN_FEED, "BtnFood", imgBackground.img.width / 2 - (NUM_POINT_START - 624), 2, this, "FeedFishTool");
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip4");
			btnFeed.setTooltip(tooltip);
			btnFishingNet = AddButtonEx(GUI_MAIN_BTN_FISHING_NET, "BtnVotCa", imgBackground.img.width / 2 - (NUM_POINT_START - 672), 2, this, "SellFishTool");
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip5");
			btnFishingNet.setTooltip(tooltip);
			//btnEditDeco = AddButtonEx(GUI_MAIN_BTN_EDIT_DECORATE, "BtnEditDeco", imgBackground.img.width / 2 - (NUM_POINT_START - 720), 2, this);
			//tooltip = new TooltipFormat();
			//tooltip.text = Localization.getInstance().getString("Tooltip7");
			//btnEditDeco.setTooltip(tooltip);
			btnHome = AddButtonEx(GUI_MAIN_BTN_HOME, "BtnHome", imgBackground.img.width / 2 - (NUM_POINT_START - 690), -5, this);
			btnHome.SetScaleX(1.6);
			btnHome.SetScaleY(1.6);
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip9");
			btnHome.setTooltip(tooltip);	
			btnHook = AddButtonEx(GUI_MAIN_BTN_HOOK, "BtnHook", 528, 2, this, "Fishing");
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip25");
			btnHook.setTooltip(tooltip);
			
			// Chọi cá
			btnWar = AddButtonEx(GUI_MAIN_BTN_WAR, "BtnWar", 528, 2, this, INI.getInstance().getHelper("helper20") );
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip65");
			btnWar.setTooltip(tooltip);
			btnPeace = AddButtonEx(GUI_MAIN_BTN_PEACE, "BtnPeace", 528, 2, this);
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip66");
			btnPeace.setTooltip(tooltip);
			
			btnExtendEquipment = AddButton(GUI_MAIN_BTN_EXTEND_EQUIPMENT, "BtnExtendEquip", img.width - 50, -22);
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip72");
			btnExtendEquipment.setTooltip(tooltip);
			btnExtendEquipment.SetVisible(false);
			
			//btnExtendDeco = AddButton(GUI_MAIN_BTN_EXTEND_DECO, "BtnExtendDeco", img.width - 50, - 50);
			//tooltip = new TooltipFormat();
			//tooltip.text = Localization.getInstance().getString("Tooltip75");
			//btnExtendDeco.setTooltip(tooltip);
			//btnExtendDeco.SetVisible(false);
			
			// Số lượng trận chiến trong ngày
			txtCombatCount = AddLabel("", imgBackground.img.width / 2 - (NUM_POINT_START - 587), 8, 0, 1, 0x26709C);
			txtCombatCount.wordWrap = true;
			txtFormat.size = 14;
			txtFormat.color = 0xFFFFFF;
			txtFormat.bold = true;
			txtFormat.align = "center";	
			txtCombatCount.defaultTextFormat = txtFormat;
			
			btnMix = AddButtonEx(GUI_MAIN_BTN_MIX, "BtnMixLake", imgBackground.img.width / 2 - (NUM_POINT_START - 528), 2, this, INI.getInstance().getHelper("helper12"));
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip29");
			btnMix.setTooltip(tooltip);		
			
			btnRaw = AddButtonEx(GUI_MAIN_BTN_RAW, "BtnRawMaterialBot", imgBackground.img.width / 2 - (NUM_POINT_START - 482), 2, this, "MaterialTool");
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip42");
			btnRaw.setTooltip(tooltip);	
			//AddImage(GUI_MAIN_IMG_NEW, "IcMoi", 390, 0, true, ALIGN_LEFT_TOP).img.mouseEnabled = false;
			
			btnFishMachine = AddButtonEx(GUI_MAIN_BTN_FISHMACHINE, "BtnFishMachine", imgBackground.img.width / 2 +275, 2, this);
			var myLevel:int = GameLogic.getInstance().user.GetLevel(true);
			if (myLevel < int(ConfigJSON.getInstance().getItemInfo("Param")["MinLevelFairyDrop"]))
			{
				tooltip = new TooltipFormat();
				tooltip.text = "Mở khi đạt cấp độ 20";
				btnFishMachine.setTooltip(tooltip);
				btnFishMachine.SetDisable2();
			}
			//btnMapOcean = AddButton(BTN_COME_BACK_MAP, "BtnMapOcean", btnFishMachine.img.x + 5, -35, this);
			//btnMapOcean.SetEnable(false);
			
			//btnExMapOcean = AddButtonEx(BTN_COME_BACK_MAP, "BtnExMapOcean", imgBackground.img.width / 2 +245, 2, this, "MapOcean");
			//tooltip = new TooltipFormat();
			//tooltip.text += "\nMở ra khi đạt level 7";
			//btnExMapOcean.setTooltip(tooltip);
			//btnExMapOcean.SetDisable2();
			
			// Nút mở rộng hồ
			btnExpand = AddButton(GUI_MAIN_BTN_EXPAND, "BtnExpand", 67, 27, this);
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("Tooltip35");
			btnExpand.setTooltip(tooltip);
			//btnExpand.img.scaleX = btnExpand.img.scaleY = 1.2
			//txtFormat.size = 12;
			//txtFormat.color = 0xFFFFFF;
			//txtFormat.bold = true;
			//txtFormat.align = "center";
			//expandLake = AddLabel("Mở rộng", btnExpand.img.x - 23, btnExpand.img.y - 23, 0, 1, 0x26709C);
			//expandLake.defaultTextFormat = txtFormat;
			//expandLake.setTextFormat(txtFormat);
			btnExpand.SetDisable();
			
			// Nút mở hồ mới
			//btnUnlockLake2 = AddButton(GUI_MAIN_BTN_UNLOCK_LAKE_2, "ButtonGreen", 260, 24, this);
			//tooltip = new TooltipFormat();
			//tooltip.text = Localization.getInstance().getString("Tooltip36");
			//btnUnlockLake2.setTooltip(tooltip);
			//btnUnlockLake2.img.scaleX = btnUnlockLake2.img.scaleY = 1.2;
			//unlockLabel2 = AddLabel(" ", btnUnlockLake2.img.x -23, btnUnlockLake2.img.y - 23, 0, 1, 0x26709C);
			//unlockLabel2.setTextFormat(txtFormat);
			//btnUnlockLake2.SetVisible(false);
			//
			//btnUnlockLake3 = AddButton(GUI_MAIN_BTN_UNLOCK_LAKE_3, "ButtonGreen", 330, 24, this);
			//tooltip = new TooltipFormat();
			//tooltip.text = Localization.getInstance().getString("Tooltip36");
			//btnUnlockLake3.setTooltip(tooltip);
			//btnUnlockLake3.img.scaleX = btnUnlockLake3.img.scaleY = 1.2;
			//unlockLabel3 = AddLabel(" ", btnUnlockLake3.img.x -23, btnUnlockLake3.img.y - 23, 0, 1, 0x26709C);
			//unlockLabel3.setTextFormat(txtFormat);
			//btnUnlockLake3.SetVisible(false);
			
			
			// so luong thuc an
			txtFoodCount = AddLabel(" ", imgBackground.img.width / 2 - (NUM_POINT_START - 587), 8, 0, 1, 0x26709C);
			txtFoodCount.wordWrap = true;
			txtFormat.size = 14;
			txtFormat.color = 0xFFFFFF;
			txtFormat.bold = true;
			txtFormat.align = "center";	
			txtFoodCount.defaultTextFormat = txtFormat;
			
			addHappyMondyIcon();
			//imgFishWorldMonday.img.x = btnExMapOcean.img.x - 15;
			//imgFishWorldMonday.img.y = btnExMapOcean.img.y - 14;
			
			OldViewerStatus = false;
			AddButtonExByViewerStatus(OldViewerStatus);
			SetPos(0, Constant.STAGE_HEIGHT - 130);						
			LastX = img.x;
			LastY = img.y;
			
			//btnAvatar.SetVisible(false);
			
			// MinhT - tournament
			today = new Date();
			//btnTournament = AddButtonEx(BTN_TOURNAMENT, "BtnTournament", btnFishMachine.img.x + 10, -5, this);
			//tooltip = new TooltipFormat();
			//tooltip.text = "Lôi đài";
			//btnTournament.SetVisible(false);			
			//arrowTournament = AddImage("", "IcHelper", btnFishMachine.img.x + 50, -20);
			//btnTournament.setTooltip(tooltip);			
			//btnTournament.SetVisible(false);
			//arrowTournament.img.visible = false;
		}		
		
		public function HideAllToolButton(IsHide:Boolean):void
		{
			btnInventory.SetVisible(!IsHide);
			//btnInventorySoldier.SetVisible(!IsHide);
			btnShop.SetVisible(!IsHide);
			btnMix.SetVisible(!IsHide);
			btnRaw.SetVisible(!IsHide);
			btnMouseDefault.SetVisible(!IsHide);
			btnFeed.SetVisible(!IsHide);
			btnFishingNet.SetVisible(!IsHide);
			//btnEditDeco.SetVisible(!IsHide);
			txtFoodCount.visible = !IsHide;
			//for (var i:int = 0; i < btnLakeArr.length; i++)
			//{
				//var container:Container = btnLakeArr[i] as Container;
				//container.SetVisible(!IsHide);
			//}
			if (IsHide)
			{
				btnExpand.SetVisible(!IsHide);
				//expandLake.text = "";
			}
			//btnUnlockLake2.SetVisible(false);
			//unlockLabel2.text = "";
			//btnUnlockLake3.SetVisible(false);
			//unlockLabel3.text = "";
		}
		
		public function UpdateInfo(PlayEff:Boolean = false):void
		{
			var lakk:Lake = GameLogic.getInstance().user.CurLake;
			if (lakk != null && (OldFishNum != lakk.NumFish || OldCurLake != lakk.CurCapacity))
			{
				OldFishNum = lakk.NumFish;
				OldCurLake = lakk.CurCapacity;
				lblNumFish.text =  lakk.NumFish + " / " + lakk.CurCapacity;
				if (PlayEff)
				{
					var eff:ImgEffectBuble = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_BUBLE, iconFish.img) as ImgEffectBuble;
					eff.SetInfo(1, 1.6, 4, 3);
				}
			}
			
			var food:int = GameLogic.getInstance().user.GetFoodCount();
			if (OldFoodNum != food)
			{
				OldFoodNum = food;
				txtFoodCount.text = Ultility.StandardNumber(food / 5);
			}	
			
			// Check xem còn đồ cần gia hạn không, nếu không thì ẩn cái nút đi
			CheckButtonExtendVisible(GameLogic.getInstance().user.IsViewer());			
			// Check xem còn đồ trang trí cần gia hạn không, nếu không thì ẩn cái nút đi
			//CheckButtonExtendDecoVisible(GameLogic.getInstance().user.IsViewer());
			
			// check thời gian tournament
			/*if ((int)(Main.verTournament) > 0)
			{
				if (GameLogic.getInstance().user.GetLevel() >= 7)
				{
					btnTournament.SetVisible(true);
					if (checkTournamentRegister())
					{
						// hiện effect, mũi tên, abc..v..v.. để user chú ý vào cái GUI				
						if(arrowTournament)
						{
							arrowTournament.img.visible = true;
						}
					}
					else
					{
						if(arrowTournament)
						{
							arrowTournament.img.visible = false;
						}
					}
				}
				else
				{
					btnTournament.SetVisible(false);
					if(arrowTournament)
					{
						arrowTournament.img.visible = false;
					}
				}
			}*/
			
			if (!GameLogic.getInstance().user.IsViewer())	return;
			var lakeAtkInfo:Object = GameLogic.getInstance().user.GetMyInfo().Attack;
			
			var theirId:String = GameLogic.getInstance().user.Id.toString();
			var theirLake:String = GameLogic.getInstance().user.CurLake.Id.toString();
			
			if (!lakeAtkInfo.LastTimeAttack)
			{
				lakeAtkInfo.LastTimeAttack = 0;
				lakeAtkInfo["FriendLake"] = new Object();
				lakeAtkInfo["FriendLake"][theirId] = 0;
			}
			else if (!lakeAtkInfo["FriendLake"][theirId])
			{			
				lakeAtkInfo["FriendLake"][theirId] = 0;
			}
			
			var lastDay:Date = new Date(lakeAtkInfo.LastTimeAttack * 1000);
			var curDay:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			if (curDay.month != lastDay.month || curDay.day != lastDay.day || curDay.fullYear != lastDay.fullYear)
			{
				lakeAtkInfo.LastTimeAttack = GameLogic.getInstance().CurServerTime;
				lakeAtkInfo["FriendLake"] = new Object();
				lakeAtkInfo["FriendLake"][theirId] = 0;
			}
			
			var num:int = GameLogic.getInstance().user.LakeNumb * Constant.MAX_COMBAT_PER_DAY - lakeAtkInfo["FriendLake"][theirId];
			if (num < 0) num = 0;
			txtCombatCount.text = Ultility.StandardNumber(num);			
		}
		
		public function checkTournamentRegister():Boolean 
		{			
			var hourActiveArr:Array = LogicTournament.arrTime;
			var gmt7:int = -420;
			var currentTime:int = GameLogic.getInstance().CurServerTime;			
			today.setTime(currentTime * 1000);
			var hour:int = today.getUTCHours() - gmt7 / 60;
			var minute:int = today.getUTCMinutes();
			if (minute >= 50 && minute <= 59)
			{
				if (hourActiveArr.indexOf(hour) != -1)
				{
					return true;
				}
			}
			return false;
		}
		
		public function EnableButtons(IsEnable:Boolean):void
		{
			//btnInventory.SetEnable(IsEnable);
			//btnInventorySoldier.SetEnable(IsEnable);
			//btnShop.SetEnable(IsEnable);
			//btnFishingNet.SetEnable(IsEnable);
		}
		
		public function RefreshGUI():void
		{
			var isViewer:Boolean = GameLogic.getInstance().user.IsViewer();
			UpdateAllPos(isViewer);
			if (OldViewerStatus != isViewer)
			{
				OldViewerStatus = isViewer;
				//RemoveAllButtonEx();
				AddButtonExByViewerStatus(OldViewerStatus);		
			}
			
			// Kiểm tra có mở rộng hồ được hay không
			var user:User = GameLogic.getInstance().user;
			var lakeAr:Array = user.LakeArr;
			for (var i:int = 0; i < lakeAr.length; i++)
			{
				
			}
			
			CheckSwitchable();
		}
		
		public function AddButtonExByViewerStatus(isViewer:Boolean):void
		{
			//AddButtonEx(GUI_MAIN_BTN_MOVE_LEFT, "BtnBack", 5, -250, this);
			//AddButtonEx(GUI_MAIN_BTN_MOVE_RIGHT, "BtnNext", 775, -250, this);
			//UpdateAllPos(isViewer);
			if (!isViewer)
			{
				//btnAvatar.SetVisible(true);
				//btnAvatar.SetVisible(false);
				btnInventory.SetVisible(true);
				//btnInventorySoldier.SetVisible(true);
				btnShop.SetVisible(true);
				btnMouseDefault.SetVisible(true);
				btnFeed.SetVisible(true);
				btnFishingNet.SetVisible(true);
				//btnCureFish.SetVisible(true);
				//btnEditDeco.SetVisible(true);				
				btnHome.SetVisible(false);
				btnHook.SetVisible(false);
				//imgFishingMonday.SetVisible(false);
				btnWar.SetVisible(false);
				//imgHitSoldierMonday.SetVisible(false);
				btnPeace.SetVisible(false);
				txtCombatCount.visible = false;
				btnMix.SetVisible(true);
				btnRaw.SetVisible(true);
				btnFishMachine.SetVisible(false);
				//btnMapOcean.SetVisible(true);
				//btnExMapOcean.SetVisible(true);
				//InitButtonSeriesQuest();
				//QuestMgr.getInstance().CheckPopUpSeriQuest();
				suggestShowIconHappyMondayMe();
			}
			else
			{
				//btnAvatar.SetVisible(false);
				btnInventory.SetVisible(true);
				btnShop.SetVisible(false);
				btnMouseDefault.SetVisible(true);
				btnFeed.SetVisible(true);
				btnFishingNet.SetVisible(false);
				//btnCureFish.SetVisible(true);
				//btnEditDeco.SetVisible(false);
				btnHome.SetVisible(true);
				btnHook.SetVisible(true);
				btnWar.SetVisible(true);
				txtCombatCount.visible = true;
				btnPeace.SetVisible(false);
				btnMix.SetVisible(false);
				btnRaw.SetVisible(false);
				//imgRawMatMonday.SetVisible(false);
				btnFishMachine.SetVisible(false);
				//btnMapOcean.SetVisible(false);
				//btnExMapOcean.SetVisible(false);
				//imgFishWorldMonday.SetVisible(false);
				suggestShowIconHappyMondayYou();
			}
			
			CheckButtonExtendVisible(isViewer);
		}
		
		//public function CheckButtonExtendDecoVisible(isViewer:Boolean):void
		//{
			//trace("update");
			//if (GameLogic.getInstance().canExtendDeco() && !isViewer && Ultility.IsInMyFish())
			//{
				//btnExtendDeco.SetVisible(true);
				//if (btnExtendEquipment && btnExtendEquipment.img && btnExtendEquipment.img.visible)
				//{
					//btnExtendDeco.SetPos(img.width - 50, -110);
				//}
				//else
				//{
					//btnExtendDeco.SetPos(img.width - 50, -50);
				//}
			//}
			//else
			//{
				//btnExtendDeco.SetVisible(false);
			//}
		//}
		
		public function CheckButtonExtendVisible(isViewer:Boolean):void
		{
			var ShouldExtendFrom:int = 3;
			
			// Kiểm tra xem có đồ nào Durability <= 3 ko
			var data:Array = [];
			data = data.concat(GuiMgr.getInstance().GuiExtendEquipment.getFishEquips());
			
			var stockThing:GetLoadInventory = GameLogic.getInstance().user.StockThingsArr;
			data = data.concat(stockThing["Helmet"]);
			data = data.concat(stockThing["Armor"]);
			data = data.concat(stockThing["Weapon"]);
			data = data.concat(stockThing["Belt"]);
			data = data.concat(stockThing["Bracelet"]);
			data = data.concat(stockThing["Ring"]);
			data = data.concat(stockThing["Necklace"]);
			
			var isShouldExtend:Boolean = false;
			for (var i:int = 0; i < data.length; i ++)
			{
				if (data[i].Durability < ShouldExtendFrom)
				{
					isShouldExtend = true;
					break;
				}
			}
			
			if (isShouldExtend && (!isViewer || GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR))
			{
				btnExtendEquipment.SetVisible(true);
			}
			else
			{
				btnExtendEquipment.SetVisible(false);
			}
			
			//if (isShouldExtend && (!isViewer || GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR))
			//{
				//btnExtendEquipment.SetVisible(true);
				//if (btnExtendDeco && btnExtendDeco.img && btnExtendDeco.img.visible)
				//{
					//btnExtendDeco.SetPos(img.width - 50, -110);
				//}
				//else
				//{
					//btnExtendDeco.SetPos(img.width - 50, -50);
				//}
			//}
			//else
			//{
				//btnExtendEquipment.SetVisible(false);
			//}
		}
		
		//{
		//public function InitButtonSeriesQuest():void
		//{
			//var seriquest:Array = QuestMgr.getInstance().SeriesQuest;
			//var y:int = -350;
			//var button:ButtonEx;
			//var btnName:Array = ["ButtonQuest", "ButtonQuest", "ButtonQuest", "ButtonQuest", "ButtonQuest", "ButtonQuest"];
			//for (var i:int = 0; i < seriquest.length; i++)
			//{
				//var quest:QuestInfo = seriquest[i] as QuestInfo;
				//RemoveButtonEx(BTN_SERIQUEST + "_"  + quest.IdSeriesQuest);
				//button = AddButtonEx(BTN_SERIQUEST + "_" + quest.IdSeriesQuest, btnName[i], 15, y, this);
				//y += 40;
				//button.img.visible = true;
				//button.SetBlink(false);
				//if (quest.Id == 1)
				//{
					//button.SetBlink(true);					
					//if (quest.IdSeriesQuest == 1 && GuiMgr.getInstance().GuiSeriesQuest.IsVisible == false)
					//{
						//GuiMgr.getInstance().GuiSeriesQuest.InitSeriesQuest(quest);
					//}				
				//}
				//btnQuestArr.push(button);
			//}
			//
		//}
		//}
		
		public function BuyExpandLakes():void
		{
			var lkArr:Array = GameLogic.getInstance().user.GetLakeArray();
			var lake:Lake;
			
			var lakeInfoList:Array = ConfigJSON.getInstance().getLakeList();
			
			//for (i = 0; i < lkArr.length; i++)
			//{
				//lake = lkArr[i] as Lake;
			//}
		}
		
		public function ShowLakes():void
		{
			var user:User = GameLogic.getInstance().user;
			var lakeArr:Array = user.GetLakeArray();
			var lake:Lake;			
			var i:int = 0;
			var btnLake:Button;
			var lock:Image;
			var container:Container;
			var lv:int;
			var levelExpand:int;
			var tooltipUnlock2:TooltipFormat = new TooltipFormat();
			var tooltipUnlock3:TooltipFormat = new TooltipFormat();
			var tooltipExpand:TooltipFormat = new TooltipFormat();
			var imgArrowLake:Image;
			if (!GameLogic.getInstance().user.IsViewer())
			{
				for (i = 0; i < lakeArr.length; i++)
				{
					lake = lakeArr[i] as Lake;
					lv = lake.Level;
					if (lv < lake.MaxLevel)
						levelExpand = lake.LakeLevels[lv].LevelRequire;
					else
						levelExpand = 0;
					container = btnLakeArr[lake.Id - 1];
					btnLake = container.GetButton("ButtonLake");
					
					imgArrowLake = container.ImageArr[0];
					if (GameLogic.getInstance().user.CurLake.Id == lake.Id)
					{
						imgArrowLake.img.visible = true;
						container.SetHighLight(0xFFFF00);
					}
					else
					{
						imgArrowLake.img.visible = false;
						container.SetHighLight(-1);
					}
					
					// Nếu chưa mở hồ này
					// Thì disable cái nút mở hồ và disable nút hồ
					// HIện tooltpi "Bạn cần đạt level * để mở được hồ này"
					if (lake.Level <= 0)
					{				
						btnLake.SetEnable(false);
						
						// Kiểm tra có thể mua hồ dc hay ko
						// Nếu có thể thì hiển thị nút mở hồ
						if ((levelExpand <= user.Level))
						{
							switch (i) 
							{
								case 1:
									{
										// hiển thị button unlock và hồ sáng lên
										btnLake.SetEnable();
										if (lake.Level == 0)
										{
											tooltipUnlock2.text = "Hãy click vào hồ\nĐể mở hồ";
											btnLake.setTooltip(tooltipUnlock2);
										}
										
										if (lv == 0 && !isHelpUnlock)
										{
											var posBtnLake:Point = img.globalToLocal(btnLake.img.localToGlobal(new Point(btnLake.GetPos().x, btnLake.GetPos().y)));
											arrowUnlock = AddImage("HelpUnlock", "IcHelper", posBtnLake.x + btnLake.img.width / 2 + 20, posBtnLake.y);
											container.ImageArr[1].img.visible = true;
											isHelpUnlock = true;
										}
									}	
								break;
								case 2:
									tooltipUnlock3.text = "Hồ đang thi công ^x^\nBạn quay lại sau nhé!";
									btnLake.setTooltip(tooltipUnlock3);
								break;
							}
						}
						// Nếu chưa đủ level mua hồ
						else
						{
							// Hiển thị khóa 
							(container.ImageArr[1] as Image).img.visible = true;
							if (i == 1)
							{
								// Ẩn nút unlock đi
								tooltipUnlock2.text = "Bạn cần đạt level " + levelExpand + "\nđể có thể mua được hồ này";
								btnLake.setTooltip(tooltipUnlock2);
							}
							if (i == 2)
							{
								//tooltipUnlock3.text = "Bạn cần đạt level " + levelExpand + "\nđể có thể mua được hồ này";
								tooltipUnlock3.text = "Hồ đang thi công ^x^\nBạn quay lại sau nhé!";
								btnLake.setTooltip(tooltipUnlock3);
							}
						}
					}
					// Nếu đã mở hồ rồi
					else
					{					
						container.setTooltip(null);
						btnLake.SetEnable(true);
						
						// Ẩn khóa
						(container.ImageArr[1] as Image).img.visible = false;	
						// Kiểm tra hồ có mở rộng dc hay ko
						if (lake == user.CurLake)
						{
							if ((levelExpand <= user.Level))
							{
								if(levelExpand != 0)
								{
									btnExpand.SetVisible(true);
									btnExpand.SetEnable();
									//expandLake.text = "Mở rộng";
									tooltipExpand.text = Localization.getInstance().getString("Tooltip35");
									btnExpand.setTooltip(tooltipExpand);
								}
								else 
								{
									btnExpand.SetVisible(false);
									//expandLake.text = "";
								}
								//if (lv == 1 && !isHelpExpand && i == 0)
								//{
									//var PosBtnExpand:Point = btnExpand.GetPos();
									//var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
									//var PosLayer:Point = new Point();
									//PosLayer = img.globalToLocal(btnExpand.img.localToGlobal(new Point(btnExpand.GetPos().x, btnExpand.GetPos().y)));
									//arrow = new Image(this.Parent, "IcHelper", CurPos.x + PosBtnExpand.x + 30, CurPos.y + PosBtnExpand.y - 44);
									//arrow = AddImage("HelpExpand", "IcHelper",btnExpand.GetPos().x + btnExpand.img.width / 2 + 10, btnExpand.GetPos().y);
									//isHelpExpand = true;
								//}
							}
							else
							{
								btnExpand.SetVisible(true);
								btnExpand.SetDisable();
								//expandLake.text = "Mở rộng";
								tooltipExpand.text = "Bạn cần đạt level " + levelExpand + "\nđể có thể mở rộng được hồ này";
								btnExpand.setTooltip(tooltipExpand);
							}
						}
					}
				}	
			}
			else 
			{
				btnExpand.SetVisible(false);
				//expandLake.text = "";
				for (i = 0; i < lakeArr.length; i++)
				{
					lake = lakeArr[i] as Lake;
					lv = lake.Level;
					if (lv < lake.MaxLevel)
						levelExpand = lake.LakeLevels[lv].LevelRequire;
					else
						levelExpand = 0;
					container = btnLakeArr[lake.Id - 1];
					btnLake = container.GetButton("ButtonLake");
					
					imgArrowLake = container.ImageArr[0];
					if (GameLogic.getInstance().user.CurLake.Id == lake.Id)
					{
						imgArrowLake.img.visible = true;
						container.SetHighLight(0xFFFF00);
					}
					else
					{
						imgArrowLake.img.visible = false;
						container.SetHighLight(-1);
					}
					// Nếu chưa mở hồ này
					// Thì disable nút đi và hiện ảnh khóa lên
					if (lake.Level <= 0)
					{								
						btnLake.SetEnable(false);
						(container.ImageArr[1] as Image).img.visible = true;
					}
					// Nếu đã mở hồ rồi
					// Thì cho nút hồ đó enable
					else
					{					
						container.setTooltip(null);
						btnLake.SetEnable(true);
						
						// Ẩn khóa và button Unlock
						(container.ImageArr[1] as Image).img.visible = false;		
					}
					//if (arrow)
					//{
						//isHelpExpand = false;
						//arrow.img.visible = false;
					//}
					if (arrowUnlock)
					{
						isHelpUnlock = false;
						arrowUnlock.img.visible = false;
					}
				}
			}
		}
		
		public function addTipBuffLake(ListBuff:Object):void 
		{
			var container:Container;
			var btnLake:Button;
			var sBufExp:String, sBufMoney:String, sBufTime:String;
			var rate:int = 0; 
			var tip:TooltipFormat;
			for (var i:String in ListBuff)
			{
				container = btnLakeArr[int(i) - 1];
				btnLake = container.GetButton("ButtonLake");
				rate = Math.min(ListBuff[i]["Exp"], Constant.MAX_BUFF_EXP);
				sBufExp =  "Tăng kinh nghiệm : " + rate + "%";
				rate = Math.min(ListBuff[i]["Money"], Constant.MAX_BUFF_MONEY);
				sBufMoney =  "Tăng tiền : " + rate + "%";
				rate = Math.min(ListBuff[i]["Time"], Constant.MAX_BUFF_TIME);
				sBufTime =  "Giảm thời gian cá trưởng thành : " + rate + "%";
				tip = new TooltipFormat();
				tip.text = sBufExp + "\n" + sBufMoney + "\n" + sBufTime;
				btnLake.setTooltip(tip);
			}
		}
		
		//public function ShowUpgradeLake(isShow:Boolean):void
		//{
			///*
			//if (!isShow)
			//{
				//if (btnUpgradeLakes != null)
				//{
					//RemoveButton(btnUpgradeLakes.ButtonID);
					//btnUpgradeLakes = null;
				//}
			//}
			//else
			//{
				//if (btnUpgradeLakes == null)
				//{
					//btnUpgradeLakes = AddButton(GUI_MAIN_BTN_UPGRADE_LAKE, "ButtonUpgradeLake", 5, -50, this);
				//}
			//}
			//*/
		//}

		
		public function ShowButtonLake(isShow:Boolean):void
		{
			//if (isShow)
			//{
				//btnHideLakes.SetEnable(false);
			//}
			//btnLakes.SetEnable(true);
			//btnLakes.img.visible = isShow;
		}
		
		//public function StartFeedFish():void
		//{
			//var p:Point = Ultility.PosScreenToLake(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y);
			//GameLogic.getInstance().gameState = GameState.GAMESTATE_FEED_FISH;			
						//
			//var feedBox:BaseObject = new BaseObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "ImgFoodBox");
			//feedBox.img.scaleX = feedBox.img.scaleY = 0.7;
			//feedBox.img.rotation = 135;
			//GameController.getInstance().SetActiveObject(feedBox);	
			//GameController.getInstance().UpdateActiveObjPos(p.x, p.y);
			//
			// show cover layer
			//var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			//if (layer != null)
			//{
				//layer.ShowDisableScreen(0);
			//}
			//
			//var fishArr:Array = GameLogic.getInstance().user.GetFishArr();
			//for (var i:int = 0; i < fishArr.length; i++ )
			//{
				//var fish:Fish = fishArr[i] as Fish;
				//if (fish.AgeState != Fish.EGG)
				//{
					//fish.GuiFishStatus.ShowStatus(fish, GUIFishStatus.STATUS_FEED);
				//}
			//}		
		//}
		
		//public function StartCureFish():void
		//{
			//GameLogic.getInstance().gameState = GameState.GAMESTATE_CURE_FISH;
			//GameLogic.getInstance().MouseTransform("Medicine", 2);
			//
			//var fishArr:Array = GameLogic.getInstance().user.GetFishArr();
			//for (var i:int = 0; i < fishArr.length; i++ )
			//{
				//var f:Fish = fishArr[i] as Fish;
				//if (f.Emotion == Fish.ILL)
				//{
					//f.SetHighLight();
				//}
			//}
		//}
		
		//public function StartSellFish():void
		//{
			//var p:Point = Ultility.PosScreenToLake(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y);
			//GameLogic.getInstance().gameState = GameState.GAMESTATE_SELL_FISH;
			//GameLogic.getInstance().MouseTransform("VotCa", 1 , 0, 10, 50);
			//
			///*var fishNet:BaseObject = new BaseObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "BtnVotCa");0.0.
			//GameController.getInstance().SetActiveObject(fishNet);	
			//GameController.getInstance().UpdateActiveObjPos(p.x, p.y);*/
			//
			//var fishArr:Array = GameLogic.getInstance().user.GetFishArr();
			//for (var i:int = 0; i < fishArr.length; i++ )
			//{
				//var fish:Fish = fishArr[i] as Fish;
				//if (fish.AgeState != Fish.EGG)
				//{
					//fish.GuiFishStatus.ShowStatus(fish, GUIFishStatus.STATUS_SELL);
				//}
			//}		
		//}
		
		public function StartCareFish():void
		{
			var care:Boolean = false;
			var fishArr:Array = GameLogic.getInstance().user.GetFishArr();
			for (var i:int = 0; i < fishArr.length; i++ )
			{
				var fish:Fish = fishArr[i] as Fish;
				if(fish.CanCare())
				{
					fish.SetHighLight();
					care = true;
				}
			}
			
			if (care)
			{
				GameLogic.getInstance().gameState = GameState.GAMESTATE_CARE_FISH;
			}
		}		
		
		private function UpgradeLake(lakeID:int):void
		{
			var SelectedLake:Lake = GameLogic.getInstance().user.GetLake(lakeID);
			var st:String;
			
			if (GameLogic.getInstance().user.CanUserUpgradeLake(SelectedLake.Id))
			{
				var nMoney:int = GameLogic.getInstance().user.CurLake.GetUpgradeMoney();
				st = Localization.getInstance().getString("Message2");
				st = st.replace("@GiaTien", nMoney);
				st = st.replace("@LoaiTien", Localization.getInstance().getString("Money"));
				if (nMoney <= GameLogic.getInstance().user.GetMoney())
				{
					// unlock ho
					GameLogic.getInstance().SetState(GameState.GAMESTATE_UPGRADE_LAKE);
					GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(st);
				}
				else
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK(st);
				}
			
				
			}
		}
		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			var user:User = GameLogic.getInstance().user;

			if (buttonID != GUI_MAIN_BTN_MOVE_LEFT 
				&& buttonID != GUI_MAIN_BTN_MOVE_RIGHT 
				&& buttonID != GUI_MAIN_BTN_SAVE_DECORATE 
				&& buttonID != GUI_MAIN_BTN_WAR 
				&& buttonID != GUI_MAIN_BTN_PEACE 
				&& buttonID != GUI_MAIN_BTN_INVENTORY_SOLDIER)
				//&& (buttonID != GUI_MAIN_BTN_INVENTORY && user.IsViewer()))
			{
				if (!user.IsViewer() || buttonID != GUI_MAIN_BTN_INVENTORY)
				GameLogic.getInstance().BackToIdleGameState();
			}
			
			//trace(buttonID);
			var x:int = img.x;
			var y:int = img.y;
			
			
			var lakeArr:Array = user.GetLakeArray();
			var lake:Lake;			
			
			switch (buttonID)
			{
				//case BTN_COME_BACK_MAP:
					//if(GameLogic.getInstance().user.GetLevel(true) >= 7)
					//{
						//if(!GuiMgr.getInstance().GuiMapOcean.IsVisible && !isSendLoadOcean)
						//{
							//isSendLoadOcean = true;
							//if (GuiMgr.IsFullScreen)
							//{
								//Ultility.SetScreen();
							//}
							//ProcessGotoWorld();
						//}
					//}
				//break;
				case GUI_MAIN_BTN_AVATAR:
					//HelperMgr.getInstance().ShowHelperByString("InventoryHelper_ShopHelper");
					//GuiMgr.getInstance().GuiAvatar.chooseAvatar = true;
					//GuiMgr.getInstance().GuiAvatar.Show(Constant.TopLayer - 1, 5);
					break;
				case GUI_MAIN_BTN_SHOP:			
					GameController.getInstance().UseTool("Shop");
					break;						
				case GUI_MAIN_BTN_MOUSE_DEFAULT:
					GameController.getInstance().UseTool("Default");						
					//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffHatch", null, 400, 400);
					//GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("ErrorMsg49"));
					//GuiMgr.getInstance().GuiFeedWall.Show(Constant.TopLayer-1, Constant.TopLayer);
					break;				
				case GUI_MAIN_BTN_FEED:
					//StartFeedFish();
					if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
					{
						GameController.getInstance().UseTool("FeedFish");
					}
					break;				
				case GUI_MAIN_BTN_HOME:
					//if (!GameInput.getInstance().isClickFish)
					GameController.getInstance().UseTool("Home");
					break;				
				case GUI_MAIN_BTN_FISHING_NET:
					//StartSellFish();
					GameController.getInstance().UseTool("SellFish");
					break;
					
				case GUI_MAIN_BTN_INVENTORY:
					//GuiMgr.getInstance().GuiStore.Show(Constant.GUI_MIN_LAYER + 2);
					//GuiMgr.getInstance().GuiStore.Show();
					//var pk:SendLoadInventory = new SendLoadInventory();
					//Exchange.GetInstance().Send(pk);
					//if(arrow)
						//arrow.img.visible = false;
					if(arrowUnlock)
						arrowUnlock.img.visible = false;
					isHelpExpand = false;
					isHelpUnlock = false;
					this.img.visible = false;
					this.imgBgLake.img.visible = false;
					GameController.getInstance().UseTool("Inventory_Special_0");
					break;		
					
				case GUI_MAIN_BTN_INVENTORY_SOLDIER:
					if (arrowUnlock)
						arrowUnlock.img.visible = false;
					isHelpExpand = false;
					isHelpUnlock = false;
					this.img.visible = false;
					this.imgBgLake.img.visible = false;
					GameController.getInstance().UseTool("InventorySoldier_Support_0");
					break;
				
				case GUI_MAIN_BTN_OPEN_LAKE:
					//btnLakes.SetEnable(false);					
					//GuiMgr.getInstance().GuiLakes.ShowMoving(Constant.GUI_MIN_LAYER, x + btnLakes.img.x + 20, y + btnLakes.img.y);
					break;
					
				case GUI_MAIN_BTN_HIDE_LAKE:
					//btnHideLakes.SetEnable(false);
					//GuiMgr.getInstance().GuiLakes.MoveHide(x + btnLakes.img.x + 20, y);
					break;
					
				case GUI_MAIN_BTN_UPGRADE_LAKE:
					UpgradeLake(GameLogic.getInstance().user.CurLake.Id);
					break;
					
				case GUI_MAIN_BTN_CURE_FISH:
					//StartCureFish();
					GameController.getInstance().UseTool("CureFish");
					break;
				
				case GUI_MAIN_BTN_HOOK:
					if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
					{
						GameController.getInstance().UseTool("Fishing");
					}
					break;		
				
				case GUI_MAIN_BTN_WAR:
					if (int(txtCombatCount.text) <= 0)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg10"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
						break;
					}
					
					var sortArr:Array = FishSoldier.SortFishSoldier(GameLogic.getInstance().user.GetMyInfo().MySoldierArr, true);

					
					if (isSwitchable)
					{
						if (GameLogic.getInstance().user.GetMyInfo().MySoldierArr.length == 0)
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg13"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
						}
						else
						{
							isSwitchable = false;
							GameController.getInstance().UseTool("War");
						}
					}
					
					break;
					
				case GUI_MAIN_BTN_PEACE:
					if (isSwitchable)
					{	
						isSwitchable = false;
						GameController.getInstance().UseTool("Peace");
					}
					break;
					
				case GUI_MAIN_BTN_EXTEND_EQUIPMENT:
					if (isSwitchable)
					{
						GuiMgr.getInstance().GuiExtendEquipment.Show(Constant.GUI_MIN_LAYER, 5);
					}
					break;
					
				case GUI_MAIN_BTN_EXTEND_DECO:
					GuiMgr.getInstance().guiExtendDeco.showGUI();
					break;
				
				case GUI_MAIN_BTN_EDIT_DECORATE:
					this.img.visible = false;
					this.imgBgLake.img.visible = false;
					GameController.getInstance().UseTool("EditDecorate");
					break;
					
				case GUI_MAIN_BTN_SAVE_DECORATE:
					GameLogic.getInstance().SaveEditDecorate();
					GameController.getInstance().UseTool("Default");
					break;
					
				case GUI_MAIN_BTN_MIX:
					GameLogic.getInstance().BackToIdleGameState();
					//GuiMgr.getInstance().GuiMixFish.Show(Constant.GUI_MIN_LAYER, 6);
					GuiMgr.getInstance().guiMateFish.Show(Constant.GUI_MIN_LAYER, 6);
					break;
				case GUI_MAIN_BTN_RAW:
					GameLogic.getInstance().BackToIdleGameState();
					GuiMgr.getInstance().guiMixMaterial.Show(Constant.GUI_MIN_LAYER, 6);	//Mix Material
					//GuiMgr.getInstance().GuiRawMaterials.Show(Constant.GUI_MIN_LAYER, 6);	//Mix Material
					break;
				case GUI_MAIN_BTN_EXPAND:
					GuiMgr.getInstance().GuiExpandLake.ShowGUIExpand();
					//if(arrow)
						//arrow.img.visible = false;
					break;
				
				case GUI_MAIN_BTN_UNLOCK_LAKE_2:
					GuiMgr.getInstance().GuiUnlockLake.ShowGUIUnlock(2);
					break;
					
				case GUI_MAIN_BTN_UNLOCK_LAKE_3:
					GuiMgr.getInstance().GuiUnlockLake.ShowGUIUnlock(3);
					break;
				case GUI_MAIN_BTN_FISHMACHINE:
					var myLevel:int = GameLogic.getInstance().user.GetLevel(true);
					if(myLevel>=int(ConfigJSON.getInstance().getItemInfo("Param")["MinLevelFairyDrop"]))
						GuiMgr.getInstance().GuiFishMachine.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				//case BTN_TOURNAMENT:	// mở gui Tournamet
				//{
					//GetButtonEx(BTN_TOURNAMENT).SetEnable(false);
					//ActiveTooltip.getInstance().clearToolTip();
					//LogicTournament.getInstance().openTournament();
					//break;
				//}
				default:
					if (buttonID.search("BtnLake_") >= 0)			
					{
						var arrTempLake:Array = buttonID.split("BtnLake_");
						var lakeID:int = arrTempLake[1];
						var levelExpand:int = 0;
						lake = lakeArr[(lakeID - 1)];
						
						if (!user.IsViewer())
						{
							if (lake.Level <= 0 && (lakeID - 1) == 1)
							{
								if (lake.Level < lake.MaxLevel)
									levelExpand = lake.LakeLevels[lake.Level].LevelRequire;
								if (levelExpand <= user.Level)
								{
									GuiMgr.getInstance().GuiUnlockLake.ShowGUIUnlock(lakeID);
									if(arrowUnlock)
										arrowUnlock.img.visible = false;
									ShowLakes();
								}
							}
						}
						SelectLake(buttonID);
					}
					break;
			}
		}
		
		private function ProcessGotoWorld():void 
		{
			if (!Ultility.IsInMyFish())
			{
				if(!Ultility.IsKillBoss())
				{
					if (GameLogic.getInstance().isAttacking)		return;
				}
				else 
				{
					if (BossMgr.getInstance().BossArr && BossMgr.getInstance().BossArr[0].isAttacking)		return;
				}
			}
			
			// Load content của TGC
			ResMgr.getInstance().LoadFileContent("LoadingWorld");
			
			var cmd:SendLoadOcean = new SendLoadOcean();
			Exchange.GetInstance().Send(cmd);
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_MAIN_BTN_MOVE_LEFT:
				GameLogic.getInstance().PanInterval = 6;
				break;
				
				case GUI_MAIN_BTN_MOVE_RIGHT:
				GameLogic.getInstance().PanInterval = -6;
				break;
			}
		}		
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_MAIN_BTN_MOVE_LEFT:
				case GUI_MAIN_BTN_MOVE_RIGHT:
				GameLogic.getInstance().PanInterval = 0;
				break;
			}
		}
		
		private function SelectLake(ID:String):void
		{
			var data:Array = ID.split("_");
			var st:String;
			
			SelectedLake = GameLogic.getInstance().user.GetLake(data[1]);
			
			if (SelectedLake.Level <= 0)
			{
				//st = Localization.getInstance().getString("Message1");
				//st = st.replace("@GiaTien", SelectedLake.GetUnlockMoney());
				//st = st.replace("@LoaiTien", Localization.getInstance().getString("Money"));
				//unlock ho
				//if (GameLogic.getInstance().user.GetMoney() >= SelectedLake.GetUnlockMoney())
				//{
					//GameLogic.getInstance().SetState(GameState.GAMESTATE_UNLOCK_LAKE);
					//
					//GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(st);
				//}
				//else
				//{
					//GuiMgr.getInstance().GuiMessageBox.ShowOK(st);
				//}
			}
			else
			{
				if (GameLogic.getInstance().user.CurLake.Id != SelectedLake.Id)
				{
					//GameLogic.getInstance().DoGoToLake(SelectedLake.Id, GameLogic.getInstance().user.Id);
					var st1:String = "GoToLake_" + SelectedLake.Id + "_" + GameLogic.getInstance().user.Id;
					GameController.getInstance().UseTool(st1);
				}
			}
		}
		
		/**
		 * Chuyển cá về hồ khác
		 * @param	idLake
		 * @param	fish
		 * @return trả về có chuyển được không
		 */
		public function ChangeLake(idLake: int, fish: Fish):Boolean
		{
			var lake:Lake = GameLogic.getInstance().user.GetLake(idLake);			
			MovedFishLake = -1;
			if (GameLogic.getInstance().user.CurLake.Id == idLake)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Cá của bạn đang ở hồ này rồi", 290, 200);
				fish.SetMovingState(Fish.FS_SWIM);
				fish.SetHighLight( -1);
				return false;
			}
			
			if (lake.Level <= 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message19"), 290, 200);
				fish.SetMovingState(Fish.FS_SWIM);
				fish.SetHighLight( -1);
				return false;
			}
			
			if (fish.ClassName == "FireworkFish")
			{
				var sendChange:SendChangeSparta = new SendChangeSparta(fish.Id, GameLogic.getInstance().user.CurLake.Id, idLake, "Firework");
				GameLogic.getInstance().user.UpdateOptionLakeObject( -1, fish.RateOption, GameLogic.getInstance().user.CurLake.Id, idLake);
				//GameLogic.getInstance().user.UpdateOptionLake( -1, fish);
				//GameLogic.getInstance().user.UpdateOptionAllLake(fish, GameLogic.getInstance().user.CurLake.Id, idLake);
				Exchange.GetInstance().Send(sendChange);
				
				// Effect
				var array:Array = [];
				//var nameF:String = Fish.ItemType + fish.FishTypeId + "_Old_Idle";
				array.push(fish.img);
				EffectMgr.getInstance().AddSwfEffect(Constant.ACTIVE_LAYER, "EffChuyenHo", array, fish.CurPos.x + 20, fish.CurPos.y + 30, false,false, null, function():void { EffChangeLake(idLake) } );				
				
				
				//GameLogic.getInstance().user.UpdateOptionLake( -1, fish);
				//GameLogic.getInstance().user.UpdateOptionLakeObject( -1, fish.RateOption, GameLogic.getInstance().user.CurLake.Id, idLake);
				//xoa con ca khoi mang ca
				var spliceIndex:int = GameLogic.getInstance().user.arrFireworkFish.indexOf(fish);	
				GameLogic.getInstance().user.arrFireworkFish.splice(spliceIndex, 1);
				fish.Clear();
				
				GuiMgr.getInstance().GuiMain.UpdateInfo(true);
				
				//Cập nhật time cho cá
				//GameLogic.getInstance().user.UpdateHavestTime();
				GameLogic.getInstance().ClearPocket();
				
				fish.SetMovingState(Fish.FS_SWIM);
				fish.SetHighLight( -1);
				return true;
			}
			
			if (lake.NumFish >= lake.CurCapacity && lake.CurCapacity != 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("ErrorMsg16"),  290, 200);
				fish.SetMovingState(Fish.FS_SWIM);
				fish.SetHighLight( -1);
				return false;
			}
			
			lake.NumFish += 1;
			GameLogic.getInstance().user.CurLake.NumFish -= 1;
			
			var cmd:SendFishChangeLake = new SendFishChangeLake(fish.Id, GameLogic.getInstance().user.CurLake.Id, idLake);
			//GameLogic.getInstance().user.UpdateOptionAllLake(fish, GameLogic.getInstance().user.CurLake.Id, idLake);
			Exchange.GetInstance().Send(cmd);
			
			// sửa thông tin trong mảng AllFishArr của user
			var obj:Object = GameLogic.getInstance().user.getFishInfo(fish.Id);
			obj.LakeId = idLake;
			
			// Effect
			var arr:Array = [];
			//var nameF:String = Fish.ItemType + fish.FishTypeId + "_Old_Idle";
			arr.push(fish.img);
			EffectMgr.getInstance().AddSwfEffect(Constant.ACTIVE_LAYER, "EffChuyenHo", arr, fish.CurPos.x + 20, fish.CurPos.y + 30, false,false, null, function():void { EffChangeLake(idLake) } );			
			
			// Xóa túi tiền của con cá
			for (var i:int = 0; i < GameLogic.getInstance().user.PocketArr.length; i++)
			{
				var pocket:Pocket = GameLogic.getInstance().user.PocketArr[i];
				if (pocket.fish.Id == fish.Id)
				{
					GameLogic.getInstance().user.PocketArr.splice(i, 1);
					pocket.ClearImage();
					break;
				}
			}
			
			//Thu hoạch bong bóng trước
			var balloonArr:Array = GameLogic.getInstance().balloonArr;
			for ( i = 0; i < balloonArr.length; i++)
			{
				var balloon:Balloon = balloonArr[i];
				if (balloon.myFish.Id == fish.Id)
				{
					balloon.collect(false, false);
					i--;
				}
			}
			
			//GameLogic.getInstance().user.UpdateOptionLake( -1, fish);
			GameLogic.getInstance().user.UpdateOptionLakeObject( -1, fish.RateOption, GameLogic.getInstance().user.CurLake.Id, idLake);
			//xoa con ca khoi mang ca
			var fishArr:Array = GameLogic.getInstance().user.GetFishArr();
			var index:int = fishArr.indexOf(fish);	
			fishArr.splice(index, 1);
			fish.Clear();
			
			GuiMgr.getInstance().GuiMain.UpdateInfo(true);
			
			//Cập nhật time cho cá
			GameLogic.getInstance().user.UpdateHavestTime();
			GameLogic.getInstance().ClearPocket();
			
			fish.SetMovingState(Fish.FS_SWIM);
			fish.SetHighLight( -1);
			return true;
		}
		
		/**
		 * Chuyển cá về hồ khác
		 * @param	idLake
		 * @param	fish
		 * @return trả về có chuyển được không
		 */
		public function ChangeLakeSoldier(idLake:int, fish: FishSoldier):Boolean
		{
			var lake:Lake = GameLogic.getInstance().user.GetLake(idLake);			
			MovedFishLake = -1;
			if (GameLogic.getInstance().user.CurLake.Id == idLake)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Cá của bạn đang ở hồ này rồi", 290, 200);
				fish.SetMovingState(Fish.FS_SWIM);
				fish.SetHighLight( -1);
				return false;
			}
			
			if (lake.Level <= 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message19"), 290, 200);
				fish.SetMovingState(Fish.FS_SWIM);
				fish.SetHighLight( -1);
				return false;
			}
			
			if (lake.NumSoldier >= lake.CurCapacitySoldier)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("ErrorMsg16"),  290, 200);
				fish.SetMovingState(Fish.FS_SWIM);
				fish.SetHighLight( -1);
				return false;
			}
			
			lake.NumSoldier += 1;
			GameLogic.getInstance().user.CurLake.NumSoldier -= 1;
			
			var cmd:SendFishChangeLake = new SendFishChangeLake(fish.Id, GameLogic.getInstance().user.CurLake.Id, idLake);
			//GameLogic.getInstance().user.UpdateOptionAllLake(fish, GameLogic.getInstance().user.CurLake.Id, idLake);
			Exchange.GetInstance().Send(cmd);
			
			// Effect
			var arr:Array = [];
			arr.push(fish.img);
			EffectMgr.getInstance().AddSwfEffect(Constant.ACTIVE_LAYER, "EffChuyenHo", arr, fish.CurPos.x + 20, fish.CurPos.y + 30, false,false, null, function():void { EffChangeLake(idLake) } );			

			//xoa con ca khoi mang ca
			var fishSArr:Array = GameLogic.getInstance().user.GetFishSoldierArr();
			var index1:int = fishSArr.indexOf(fish as FishSoldier);
			fishSArr.splice(index1, 1);
			
			// Cập nhật thông tin của cá lính ở hồ khác
			var fishList:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			for (var i:int = 0; i < fishList.length; i++)
			{
				if (fishList[i].Id == fish.Id)
				{
					fishList[i].LakeId = idLake;
					break;
				}
			}
			fish.Clear();
			
			
			
			GuiMgr.getInstance().GuiMain.UpdateInfo(true);
			
			//Cập nhật time cho cá
			//GameLogic.getInstance().user.UpdateHavestTime();
			GameLogic.getInstance().ClearPocket();
			
			fish.SetMovingState(Fish.FS_SWIM);
			fish.SetHighLight( -1);
			return true;
		}
		/**
		 * Chuyển cá về hồ khác
		 * @param	idLake
		 * @param	fish
		 * @return trả về có chuyển được không
		 */
		public function ChangeLakeSparta(idLake: int, fish: FishSpartan):Boolean
		{
			var lake:Lake = GameLogic.getInstance().user.GetLake(idLake);			
			MovedFishLake = -1;
			if (GameLogic.getInstance().user.CurLake.Id == idLake)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Cá của bạn đang ở hồ này rồi", 290, 200);
				fish.SetMovingState(Fish.FS_SWIM);
				fish.SetHighLight( -1);
				return false;
			}
			
			if (lake.Level <= 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message19"), 290, 200);
				fish.SetMovingState(Fish.FS_SWIM);
				fish.SetHighLight( -1);
				return false;
			}
			
			var cmd:SendChangeSparta = new SendChangeSparta(fish.Id, GameLogic.getInstance().user.CurLake.Id, idLake, fish.NameItem);
			//GameLogic.getInstance().user.UpdateOptionAllLakeSparta(fish, GameLogic.getInstance().user.CurLake.Id, idLake);
			Exchange.GetInstance().Send(cmd);
			
			// Effect
			var arr:Array = [];
			//var nameF:String = Fish.ItemType + fish.FishTypeId + "_Old_Idle";
			arr.push(fish.img);
			EffectMgr.getInstance().AddSwfEffect(Constant.ACTIVE_LAYER, "EffChuyenHo", arr, fish.CurPos.x + 20, fish.CurPos.y + 30, false,false, null, function():void { EffChangeLake(idLake) } );				
			
			
			GameLogic.getInstance().user.UpdateOptionLakeObject( -1, fish.RateOption, GameLogic.getInstance().user.CurLake.Id, idLake);
			//xoa con ca khoi mang ca
			var index:int = GameLogic.getInstance().user.FishArrSpartan.indexOf(fish);	
			GameLogic.getInstance().user.FishArrSpartan.splice(index, 1);
			fish.Clear();
			
			GuiMgr.getInstance().GuiMain.UpdateInfo(true);
			
			//Cập nhật time cho cá
			//GameLogic.getInstance().user.UpdateHavestTime();
			GameLogic.getInstance().ClearPocket();
			
			fish.SetMovingState(Fish.FS_SWIM);
			fish.SetHighLight( -1);
			return true;
		}
		
		private function EffChangeLake(idLake:int):void 
		{
			var container:Container = btnLakeArr[idLake - 1];
			container.img.scaleX = 1;
			container.img.scaleY = 1;
		}
		
		public function AlertFull(alert:Boolean):void
		{
			if (alert)
			{
				RemoveImage(iconAlert);
				iconAlert = AddImage("", "IcHelper", 95, 30, true, Image.ALIGN_CENTER_BOTTOM);
			}
			else
			{
				RemoveImage(iconAlert);
			}
		}
		
		public override function Fullscreen(IsFull:Boolean, dx:int = 0, dy:int = 0, scaleX:Number = 1, scaleY:Number = 1):void
		{	
			//trace(imgBackground.img.width);		//810
			//trace(btnLakes.img.x);				//715
			//trace(btnHideLakes.img.x);			//715			
			
			//super.Fullscreen(IsFull, dx, dy);
			if (IsFull)
			{	
				var BgLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
				img.y = BgLayer.y + BgLayer.height - imgBackground.img.height;
			}
			else
			{			
				img.x = LastX;
				img.y = LastY;
			}
			UpdateAllPos(GameLogic.getInstance().user.IsViewer());
		}
		
		public function updateBtnUnlock(isViewer:Boolean):void 
		{
			btnExpand.SetVisible(!isViewer);
			//btnUnlockLake2.SetVisible(!isViewer);
			//btnUnlockLake3.SetVisible(!isViewer);
			//expandLake.text = "";
			//unlockLabel2.text = "";
			//unlockLabel3.text = "";
			if (!isViewer)
			{
				//expandLake.text = "Mở rộng";
				//unlockLabel2.text = "Mua hồ";
				//unlockLabel3.text = "Mua hồ";
			}
		}
		
		public function UpdateAllPos(isViewer:Boolean = false):void
		{
			if (!IsVisible)
			{
				return;
			}
			
			CheckButtonExtendVisible(isViewer);
			
			if (isViewer)
			{
				btnInventory.SetVisible(true);
				txtFoodCount.visible = true;
				//GetImage(GUI_MAIN_IMG_NEW).img.visible = false;
				suggestShowIconHappyMondayYou();
				if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
				{
					btnFeed.SetVisible(true);
					btnHook.SetVisible(true);
					btnMouseDefault.SetVisible(true);
					
					btnHome.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 684);
					btnWar.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 624);
					//imgHitSoldierMonday.img.x = btnWar.img.x - 15;
					//imgHitSoldierMonday.img.y = btnWar.img.y - 14;
					
					txtCombatCount.x = btnWar.img.x - 38;
					btnPeace.img.x = btnWar.img.x;
					btnMouseDefault.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 578);
					btnFeed.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 533);
					//imgFeedMonday.img.x = btnFeed.img.x - 15;
					//imgFeedMonday.img.y = btnFeed.img.y - 14;
					txtFoodCount.x = btnFeed.img.x - 37;
					btnHook.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 488);
					btnHook.SetEnable(true);
					//imgFishingMonday.img.x = btnHook.img.x - 15;
					//imgFishingMonday.img.y = btnHook.img.y - 14;
					
					btnInventory.img.x = btnHook.img.x - 40;
				}
				else
				{
					btnHome.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 684);
					btnWar.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 624);
					//imgHitSoldierMonday.img.x = btnWar.img.x - 15;
					//imgHitSoldierMonday.img.y = btnWar.img.y - 14;
					//imgHitSoldierMonday.SetVisible(false);
					txtCombatCount.x = btnWar.img.x - 38;
					btnPeace.img.x = btnWar.img.x;
					btnInventory.img.x = btnPeace.img.x - 45;
					
					btnFeed.SetVisible(false);
					//imgFeedMonday.SetVisible(false);
					btnHook.SetVisible(false);
					//imgFishingMonday.SetVisible(false);
					btnMouseDefault.SetVisible(false);
					txtFoodCount.visible = false;
					
				}
			}
			else
			{
				//GetImage(GUI_MAIN_IMG_NEW).img.visible = true;
				btnShop.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 388);
				btnInventory.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 432);
				//btnInventorySoldier.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 482);
				btnRaw.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 482);
				//imgRawMatMonday.img.x = btnRaw.img.x - 15;
				//imgRawMatMonday.img.y = btnRaw.img.y - 14;
				
				btnMix.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 528);
				btnMouseDefault.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 576);
				btnFeed.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 624);
				//imgFeedMonday.img.x = btnFeed.img.x - 15;
				//imgFeedMonday.img.y = btnFeed.img.y - 14;
				btnFishingNet.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 672);
				//btnCureFish.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 705);
				//btnEditDeco.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 762);
				//btnAvatar.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 760)
				btnFishMachine.img.x = imgBackground.img.width / 2 - (NUM_POINT_START - 726);
				txtFoodCount.x = imgBackground.img.width / 2 - (NUM_POINT_START - 590);
				
				btnWar.SetVisible(false);
				//imgHitSoldierMonday.SetVisible(false);
				txtCombatCount.visible = false;
				txtFoodCount.visible = true;
				suggestShowIconHappyMondayMe();
			}
		}
		
		public function CheckSwitchable():void
		{
			btnWar.SetDisable();
			btnPeace.SetDisable();			
			
			if (!GameLogic.getInstance().user.IsViewer())	return;
			if (GameLogic.getInstance().fw)	return;
			
			var mine:Array = GameLogic.getInstance().user.FishSoldierActorMine;
			var theirs:Array = GameLogic.getInstance().user.FishSoldierActorTheirs;
			var theirsReal:Array = GameLogic.getInstance().user.FishSoldierArr;
			
			var i:int;
			var fs:FishSoldier;
			
			isSwitchable = true;
			
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			{
				for (i = 0; i < mine.length; i++)
				{
					fs = mine[i] as FishSoldier;
					if (!fs.isInRightSide)
					{
						isSwitchable = false;
						return;
					}
				}
				
				for (i = 0; i < theirs.length; i++)
				{
					fs = theirs[i] as FishSoldier;
					if (!fs.isInRightSide)
					{
						isSwitchable = false;
						return;
					}
				}
				
				for (i = 0; i < theirsReal.length; i++)
				{
					fs = theirsReal[i] as FishSoldier;
					if (!fs.isInRightSide)
					{
						isSwitchable = false;
						return;
					}
				}
			}
			else
			{
				for (i = 0; i < mine.length; i++)
				{
					fs = mine[i] as FishSoldier;
					if (fs.isInRightSide)
					{
						isSwitchable = false;
						return;
					}
				}
				
				for (i = 0; i < theirs.length; i++)
				{
					fs = theirs[i] as FishSoldier;
					if (fs.isInRightSide)
					{
						isSwitchable = false;
						return;
					}
				}
			}
			
			if (isSwitchable)
			{
				if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
				{
					//btnPeace.SetVisible(true);
					btnPeace.SetEnable(true);
					txtCombatCount.visible = true;
				}
				else
				{
					//btnWar.SetVisible(true);
					btnWar.SetEnable(true);
					txtCombatCount.visible = true;
				}
			}
		}
		
		public function addHappyMondyIcon():void
		{
			return;
			imgFeedMonday = AddButtonEx("", "IconHappyMonday", 0, 0);
			imgFishingMonday = AddButtonEx("", "IconHappyMonday", 0, 0);
			imgHitSoldierMonday = AddButtonEx("", "IconHappyMonday", 0, 0);
			//imgFishWorldMonday = AddButtonEx("", "IconHappyMonday", 0, 0);
			imgRawMatMonday = AddButtonEx("", "IconHappyMonday", 0, 0);
			
			imgFeedMonday.SetScaleXY(0.6);
			imgFishingMonday.SetScaleXY(0.6);
			imgHitSoldierMonday.SetScaleXY(0.6);
			//imgFishWorldMonday.SetScaleXY(0.6);
			imgRawMatMonday.SetScaleXY(0.6);
			
			var strTitle:String = "Thứ 2 vui vẻ";
			var strTip:String = strTitle + "\n" + Ultility.getHappyMondayTip();
			var tip:TooltipFormat = new TooltipFormat();
			var fmTitle:TextFormat = new TextFormat();
			fmTitle.align = "center";
			fmTitle.bold = true;
			fmTitle.size = 18;
			var fmContent:TextFormat = new TextFormat();
			fmContent.align = "left";
			fmContent.size = 14;
			tip.text = strTip;
			tip.setTextFormat(fmTitle, 0, strTitle.length);
			tip.setTextFormat(fmContent, strTitle.length, strTip.length);
			
			imgFeedMonday.setTooltip(tip);
			imgFishingMonday.setTooltip(tip);
			imgHitSoldierMonday.setTooltip(tip);
			//imgFishWorldMonday.setTooltip(tip);
			imgRawMatMonday.setTooltip(tip);
			
			suggestShowIconHappyMondayMe();
		}
		public function suggestShowIconHappyMondayMe():void
		{
			return;
			if (GameLogic.getInstance().isMonday())
			{
				imgFeedMonday.img.visible = true;
				//imgHitSoldierMonday.img.visible = true;
				//imgFishWorldMonday.img.visible = true;
				imgFishingMonday.img.visible = true;
				imgRawMatMonday.img.visible = true;
			}
			else
			{
				imgFeedMonday.img.visible = false;
				//imgHitSoldierMonday.img.visible = false;
				//imgFishWorldMonday.img.visible = false;
				imgFishingMonday.img.visible = false;
				imgRawMatMonday.img.visible = false;
			}
		}
		public function suggestShowIconHappyMondayYou():void
		{
			return;
			if (GameLogic.getInstance().isMonday())
			{
				imgFeedMonday.img.visible = true;
				imgHitSoldierMonday.img.visible = true;
				//imgFishWorldMonday.img.visible = true;
				imgFishingMonday.img.visible = true;
				//imgRawMatMonday.img.visible = true;
			}
			else
			{
				imgFeedMonday.img.visible = false;
				imgHitSoldierMonday.img.visible = false;
				//imgFishWorldMonday.img.visible = false;
				imgFishingMonday.img.visible = false;
				//imgRawMatMonday.img.visible = false;
			}
		}
	}

}