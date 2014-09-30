package GUI 
{
	import adobe.utils.ProductManager;
	import com.greensock.easing.Sine;
	import com.greensock.TweenLite;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.ImgEffectBlink;
	import Effect.ImgEffectBuble;
	import Effect.ImgEffectFly;
	import Event.EventMgr;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.ProgressEvent;
	import flash.events.TextEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GameControl.GameController;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.EventBirthDay.EventLogic.BirthDayItemMgr;
	import GUI.EventBirthDay.EventLogic.MagicLampMgr;
	import GUI.FishWar.GUIChooseEquipment;
	import GUI.FishWorld.BossMgr;
	import GUI.FishWorld.Network.SendLoadOcean;
	import GUI.Mail.SystemMail.Controller.MailMgr;
	import GUI.Minigame.MinigameMgr;
	import Logic.Fish;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.QuestInfo;
	import Logic.QuestMgr;
	import Logic.Treasure;
	import Logic.Ultility;
	import Logic.User;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Lake;
	import Data.ResMgr;
	import flash.events.MouseEvent;
	import NetworkPacket.PacketSend.OfflineExp.SendSyncOfflineExp;
	import NetworkPacket.PacketSend.SendEventService;
	import NetworkPacket.PacketSend.SendGetDailyQuest;
	import NetworkPacket.PacketSend.SendGetDailyQuestNew;
	import NetworkPacket.PacketSend.SendGetLog;
	import NetworkPacket.PacketSend.SendLoadGift;
	import NetworkPacket.PacketSend.SendLoadMail;
	import flash.display.MovieClip;
	import NetworkPacket.PacketSend.SendGetSeriesQuest;
	import NetworkPacket.PacketSend.SendRefreshFriend;
	import NetworkPacket.PacketSend.SendUpdateG;
	/**
	 * ...
	 * @author MinhT
	 */
	public class GUITopInfo extends BaseGUI
	{
		static public const ID_BTN_CHOOSE_SOLDIER:String = "idBtnChooseSoldier";
		public static const BTN_SERIQUEST:String = "BtnSeriQuest";
		public static const BTN_HELP_SERIQUEST:String = "BtnHelpSeriQuest";
		public var btnExQuestArr:Array = [];
		public var btnQuestArr:Array = [];
		public var btnExQuestHelp:ButtonEx;
		//private var countShowHelpQuest:int = 0;
		
		private const GUI_TOP_EXP:String = "imgEXP";
		private const GUI_TOP_EXP_PRG:String = "PrgEXP";
		private const GUI_TOP_MONEY:String = "imgMoney";
		private const GUI_TOP_ZMONEY:String = "imgZMoney";
		private const GUI_TOP_ENERGY:String = "imgEnergy";
		private const GUI_TOP_CLEAN:String = "imgClean";
		private const GUI_TOP_FOOD:String = "ImgFood";
		private const GUI_TOP_AVATAR:String = "imgAvatar";
		
		// button
		private const GUI_TOP_BTN_LETTER:String = "btnLetter";
		private const GUI_TOP_BTN_MESSAGE:String = "btnMessage";
		private const GUI_TOP_BTN_DAILYQUEST:String = "btnlucky";
		private const GUI_TOP_BTN_LOG:String = "btnLog";		
		private const GUI_TOP_BTN_GIFT: String = "gift";
		private const GUI_TOP_BTN_ANNOUNCE: String = "announce";
		private const GUI_TOP_BTN_EVENT: String = "btnEvent";
		private const GUI_TOP_BTN_CHANGE_MEDAL: String = "btnChangeMedal";
		private const GUI_TOP_BTN_QUEST_PT:String = "btnQuestPT";
		
		private const GUI_TOP_BTN_DAILYBONUS:String = "btnDailyBonus";
		
		private const GUI_TOP_BTN_DAILYQUEST_NEW:String = "btnDailyQuestNew";
		private const GUI_TOP_BTN_SNAPSHOT:String = "btnSnapshot";
		private const GUI_TOP_BTN_SYSTEM_MAIL:String = "btnSystemMail";
		private const GUI_TOP_BTN_INPUT_CODE:String = "btnInputCode";
		
		private const AVATAR_WIDTH:int = 42;
		private const AVATAR_HEIGHT:int = 58;
		
		public static const NAME_CURRENT_IN_EVENT:String = EventMgr.NAME_EVENT;
		
		public static const GUI_TOP_BTN_ICON_MOIBAN:String = "btnIconMoiBan";
		public static const GUI_TOP_BTN_NHANQUA_INVITEFRIEND:String = "GUI_TOP_BTN_NHANQUA_INVITEFRIEND";
		static public const GUI_TOP_BTN_GIFT_XMAS:String = "guiTopBtnGiftXmas";
		private const GUI_TOP_BTN_GET_GIFT_EVENT:String = "btnGetGiftEvent";
		private const BTN_OFFLINE_EXP:String = "btnOfflineExp";
		private const BTN_COLLECTION:String = "btnCollection";
		private const BTN_FISHWARSUM:String = "btnFishWarSum";
		private const CTN_FISHWARSUM:String = "ctnFishWarSum";
		private const GUI_TOP_BTN_STATISTIC:String = "BtnStatistic";
		private const BTN_PEARL_REFINE:String = "btnPearlRefine";
		private const BTN_EQUIPMENT:String = "btnEquipment";
		private const BTN_ENCHANT:String = "btnEnchant";
		private const BTN_CREATE:String = "btnCreate";
		private const BTN_BLACK_MARKET:String = "BtnBlackMarket";
		public const BTN_COME_BACK_MAP:String = "btnComeBackMap";
		static public const BTN_GET_COIN:String = "btnGetCoin";
		static public const BTN_QUICK_PAY:String = "btnQuickPay";
		private const ID_ICON_HAPPYMONDAY:String = "idIconHappyMonday";
		// 1st event
		private const GUI_TOP_BTN_MAGICLAMP:String = "guiTopBtnMagiclamp";
		private const IMG_PRG_WISHINGPOINT:String = "imgPrgWishingpoint";
		private const PRG_WISHINGPOINT:String = "prgWishingpoint";
		private const GUI_TOP_BTN_DIGRITWHEEL:String = "btnDigritWheel";
		// training tower
		private const BTN_TOWER:String = "btnTower";
		// liên đấu
		private const BTN_LEAGUE:String = "btnLeague";
		
		private var user:User;
		public var ctnFriend:Container;
		public var imgBackground:Image;
		public var txtLevel:TextField;
		public var txtMoney:TextField;
		public var txtZMoney:TextField;
		public var txtEnergy:TextField;
		public var txtCooldown:TextField;
		public var txtFoodPercent:TextField;
		public var txtExp:TextField;
		public var effExp:Sprite = new Sprite();
		public var avatar:Image;
		public var imgEXP:Image;
		public var prgEXP:ProgressBar;
		public var prgEnergy:ProgressBar;
		public var prgClean:ProgressBar;
		public var prgFood:ProgressBar;
		public var userName:TextField;		
		public var btnLetter: ButtonEx;
		public var btnDailyQuest: ButtonEx;
		public var btnLog: ButtonEx;
		public var btnGift: ButtonEx;
		public var btnLeftMessage: Button;		
		public var btnAnnounce: ButtonEx;		
		//public var btnMapOcean: Button;		
		public var imgFood:Image;
		public var imgFishWorld:Image;
		public var imgEnergy:Image;
		public var imgGold:ProgressBar;
		public var imgZXu:ProgressBar;
		public var imgAvatar:Image;
		public var imgAvatarWorld:Image;
		public var imgPrgEnergyWorld:Image;
		public var imgSnapshot:Image;
		public var btnDailyQuestNew: ButtonEx;
		public var btnQuestPowerTinh: ButtonEx;
		public var btnSnapshot:Button;
		public var btnDailyBonus: Button;
		public var btnSystemMail:ButtonEx;
		public var btnInputCode:Button;
		// happy Monday Icon
		public var imgDailyQuestMonday:ButtonEx;
		public var imgAvatarMonday:ButtonEx;
		public var imgSnapshotMonday:ButtonEx;
		public var btnDigitWheel:Button;
		public var btnMoiban:Button;
		public var ctnBuffExp:Container;
		public var ctnBuffMoney:Container;
		public var ctnBuffTime:Container;
		public var ctnMoneyAttacked:Container;
		public var txtBuffExp:TextField;
		public var txtBuffMoney:TextField;
		public var txtBuffTime:TextField;				
		/*public var ctnMoneySkill:Container;		
		public var ctnLevelSkill:Container;		
		public var ctnSpecialFishSkill:Container;		
		public var ctnRareFishSkill:Container;		*/
		public var txtMoneySkill:TextField;		
		public var txtLevelSkill:TextField;		
		public var txtSpecialFishSkill:TextField;		
		public var txtRareFishSkill:TextField;		
		
		/*1st event*/
		public var btnEvent:Button;
		public var btnChangeMedal:Button;
		
		public var imgLevelWishingPoint:Image;
		public var imgPrgWishingPoint:Image;
		public var prgWishingPoint:ProgressBar;
		public var btnMagicLamp:ButtonEx;
		public var txtWishingPoint:TextField;
		public var btnGetGiftAfterEvent:Button;
		// Nút đếm đã đc bao nhiêu trận chiến
		//public var imgCombatCount:Image;
		//public var txtCombatCount:TextField;
		
		// Lưu các thông số để optimize
		public var name:String = "";
		public var avatarUrl:String;
		public var iLevel:int = -1;
		public var iExp:int = 0;
		public var iMoney:Number = 0;
		public var iZMoney:int = -1;
		public var iEnergy:int = -1;
		public var iPercentFood:int = 0;
		public var iDirtyAmout:int = -1;
		public var iWishingPoint:int = 0;
		public var iLevelWishingPoint:int = -1;
		private var format:TextFormat = new TextFormat();
		//public var buttonGetGiftEvent:Button;
		
		
		// Event 2/9
		public var txtEventIndependent:TextField;
		public var imgBgTitle:Image;
		private var countRun:int = 0;
		private var lastRunTime:Number = 0;
		private var isRunNotify:Boolean = true;
		private var buttonGiftXmas:Button;
		
		// Buttons ngư chiến
		public var btnFishWarSum:Button;
		public var btnPearlRefine:Button;
		public var btnCollection:Button;
		//public var btnStatistics:Button;
		public var btnEquipment:Button;
		public var btnEnchant:Button;
		public var btnCreate:Button;
		public var FishWarCtn:Container;	// chứa các button trên
		private var MaskClip:MovieClip;		// Để che cái GUI ngư chiến show ra
		private var showPos:Point;
		private var hidePos:Point;
		private var isMoving:Boolean = false;
		private var isInHidePos:Boolean = true;
		public var isShowCtnFishWar:Boolean = false;
		private var btnGetCoin:Button;
		public var txtUseTime:TextField;
		
		// Button Chợ đen
		public var btnBlackMarket:Button;
		//private var buttonOfflineExp:Button;
		
		public var strTextRun:String = "";
		public var arrItemName:Array = [];
		public var arrUserName:Array = [];
		public var arrTextRun:Array = [];
		public var arrCountRun:Array = [];
		public const numTextRun:int = 1;
		static public const BTN_MERIDIAN:String = "btnMeridian";
		static public const BTN_BUY_DIAMOND:String = "btnBuyDiamond";
		static public const BTN_PASSWORD:String = "btnPassword";
		public var idTextRun:int = -1;
		
		private var imgNew:Image;
		//private var imgNewBlackMarket:Image;
		private var btnMeridian:ButtonEx;
		public var labelDiamond:TextField;
		public var btnLock:Button;
		public var btnUnlock:Button;
		
		// button Training tower
		public var btnTower:ButtonEx;
		
		// tournament
		private var today:Date;
		
		// button Liên đấu
		public var btnLeague:Button;
		public var tfRank:TextField;
		
		public function GUITopInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUITopInfo";			
		}
		
		public override function InitGUI(): void
		{
			LoadRes("");
			iPercentFood = 100;
			iDirtyAmout = -1;
			iPercentFood = -1;
			isShowCtnFishWar = false;
			var str:String;
			var strItemName:String;
			for (var i:int = 0; i < numTextRun; i++) 
			{
				str = Localization.getInstance().getString("MessageInGame" + i);
				strItemName = Localization.getInstance().getString("MessageInGameItemname" + i);
				arrTextRun.push(str);
				arrItemName.push(strItemName);
				arrCountRun.push(GetNumCountTextRun(i));
			}
			
			// tournament
			str = Localization.getInstance().getString("MessageInGame" + "Tournament");
			arrTextRun.push(str);
			arrCountRun.push(GetNumCountTextRun(1000));
			
			today = new Date();
		}
		
		public function GetNumCountTextRun(id:int):int
		{
			switch (id) 
			{
				case 0:
					return 450;
				break;
				case 1:
					return 700;
				break;
				case 2:
					return 700;
				break;
			}
			return 400;
		}
		
		public override function Show(ilayer:int = Constant.GUI_MIN_LAYER, ShowModal:int = 0):void
		{			
			super.Show(ilayer, ShowModal);
			var ToolTip:TooltipFormat;
			user = GameLogic.getInstance().user;
			
			//Canh mai tet
			//if(EventMgr.CheckEvent("InGameFishWar") != EventMgr.CURRENT_NOT_EVENT)
			//{
				//var tet_Flower:Image = AddImage("", "Tet_Flower", 640, 150);
				//tet_Flower.img.mouseEnabled = false;
				//tet_Flower.img.mouseChildren = false;
			//}
			
			// Add background
			imgBackground = AddImage("", "GuiTopBar", 0, 0, true, Image.ALIGN_LEFT_TOP);
			
			// Add avatar
			imgAvatar = AddImage("", "ImgAvatarMe", 1, 0, true, ALIGN_LEFT_TOP);
			imgAvatarWorld = AddImage("", "ImgAvatarMeWorld", 1, 0, true, ALIGN_LEFT_TOP);
			avatar = AddImage(GUI_TOP_AVATAR, "ImgFrameFriend", imgAvatar.img.x + 42, 38, true, ALIGN_LEFT_TOP);			
			avatar.SetSize(51, 51);
			userName = AddLabel("", imgAvatar.img.x + 18, imgAvatar.img.y + 100, 0, 1);
			format.size = 12;
			format.bold = true;
			format.align = "center";
			//format.color = 0x0D789C;
			userName.wordWrap = true;
			userName.width = 130;
			userName.defaultTextFormat = format;
			userName.setTextFormat(format);
			avatarUrl = "me";
			
			// Add Exp
			prgEXP = AddProgress(GUI_TOP_EXP_PRG, "PrgEXP", imgAvatar.img.x + 44, imgAvatar.img.y + 11, this, true);
			prgEXP.setStatus(0);
			txtExp = AddLabel("0", 0, 0, 0xFFFFFF, 1, 0x26709C);
			format.size = 14;
			format.bold = true;
			format.align = "center";
			format.color = 0xFFFFFF;
			txtExp.defaultTextFormat = format;
			txtExp.setTextFormat(format);
			txtExp.x = -txtExp.width / 2;
			txtExp.y = -txtExp.height / 2;
			effExp.addChild(txtExp);
			effExp.x = prgEXP.x + 41;
			effExp.y = 18;
			effExp.mouseChildren = false;
			effExp.mouseEnabled = false;
			this.img.addChild(effExp);
			imgEXP = AddImage(GUI_TOP_EXP, "ImgEXP", imgAvatar.img.x + 4, imgAvatar.img.y + 4, true, ALIGN_LEFT_TOP);
			format.size = 14;
			format.color = 0xFFFF00;
			format.bold = true;	
			format.align = "center";
			txtLevel = AddLabel("0", imgEXP.img.x - 33, imgEXP.img.y + 4, 0, 1, 0x26709C);
			txtLevel.wordWrap = true;
			txtLevel.defaultTextFormat = format;
			txtLevel.setTextFormat(format);
			
			// Add 2 loai money			
			//imgGold = AddImage(GUI_TOP_MONEY, "ImgGold", 153, 2, true, ALIGN_LEFT_TOP);
			imgGold = AddProgress("idPrgMoney", "ImgGold", 153, 2, this, false);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Tiền vàng";
			format.color = 0x000000;
			format.bold = false;
			format.size = 12;
			ToolTip.autoSize = "center";
			ToolTip.setTextFormat(format);
			imgGold.setTooltip(ToolTip);
			
			format.size = 14;
			format.color = 0xFFFFFF;
			format.bold = true;
			format.align = "center";
			//txtMoney = AddLabel("0", imgGold.img.x + 23, imgGold.img.y + 4, 0xFFFFFF, 1, 0x26709C);
			txtMoney = AddLabel("0", imgGold.x + 23, imgGold.y + 6, 0xFFFFFF, 1, 0x26709C);
			txtMoney.wordWrap = true;
			txtMoney.defaultTextFormat = format;
			txtMoney.setTextFormat(format);
			
			//imgZXu = AddImage(GUI_TOP_ZMONEY, "ImgZXu", 277, 2, true, ALIGN_LEFT_TOP);
			imgZXu = AddProgress("", "ImgZXu", 277, 2, this, false);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Tiền G";
			format.color = 0x000000;
			format.bold = false;
			format.size = 12;
			ToolTip.autoSize = "center";
			ToolTip.setTextFormat(format);
			imgZXu.setTooltip(ToolTip);
			
			txtZMoney = AddLabel("0", imgZXu.x + 23, imgZXu.y + 6, 0xFFFFFF, 1, 0x26709C);
			format.size = 14;
			format.color = 0xFFFFFF;
			format.bold = true;
			format.align = "center";
			txtZMoney.wordWrap = true;
			txtZMoney.defaultTextFormat = format;
			txtZMoney.setTextFormat(format);
			
			//Password
			btnLock = AddButton(BTN_PASSWORD, "Btn_Lock", 722, 10);
			btnLock.SetVisible(false);
			btnUnlock = AddButton(BTN_PASSWORD, "Btn_Unlock", 722, 10);
			btnUnlock.SetVisible(false);
			
			//Button nạp xu nhanh
			AddButton(BTN_QUICK_PAY, "Btn_Quick_Pay", 363, 2);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Nạp tiền nhanh";
			GetButton(BTN_QUICK_PAY).setTooltip(ToolTip);
			
			//Kim cuong
			var bgDiamond:Container = AddContainer("idCtnDiamond", "NumDiamondBg", 406, 0);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Kim Cương";
			bgDiamond.setTooltip(ToolTip);
			AddButton(BTN_BUY_DIAMOND, "BtnBuyDiamond", 500 - 99 + 125, 0);
			var txtFormat:TextFormat = new TextFormat("arial", 14, 0xffffff, true);
			labelDiamond = AddLabel("0", 500 - 65, 5, 0xffffff, 1);
			labelDiamond.defaultTextFormat = txtFormat;
			
			// Add energy
			format.size = 14;
			format.color = 0xFFFFFF;
			format.bold = true;
			format.align = "center";
			//imgEnergy = AddImage("", "imgEnergy", imgBackground.img.width - 253, 2, true, ALIGN_LEFT_TOP);
			//imgEnergy = AddImage("", "imgEnergy", 440, -3, true, ALIGN_LEFT_TOP);
			imgEnergy = AddImage("", "imgEnergy", 365, -3, true, ALIGN_LEFT_TOP);
			imgEnergy.img.visible = false;
			//prgEnergy = AddProgress("", "PrgEnergy", imgEnergy.img.x + 31, 10, this, true);
			prgEnergy = AddProgress("", "PrgEnergy", 20, 125, this, true);
			prgEnergy.setStatus(0);
			
			ToolTip = new TooltipFormat();
			var str:String;
			var curEnergy:int = user.GetEnergy(true);
			var maxEnergy:String = Ultility.StandardNumber(ConfigJSON.getInstance().getMaxEnergy(user.GetLevel(true)));
			var strReplace:String = curEnergy.toString() + "/" + maxEnergy;
			str = Localization.getInstance().getString("Tooltip21");
			str = str.replace("@energy", strReplace);
			ToolTip.text = str;
			
			format.align = "center";
			format.color = 0x000000;
			format.bold = false;
			format.size = 12;
			ToolTip.autoSize = "center";
			ToolTip.setTextFormat(format);
			format.bold = true;
			format.color = 0xFF0000;
			ToolTip.setTextFormat(format, 0, 10);
			prgEnergy.setTooltip(ToolTip);
			//ToolTip.width = ToolTip.textWidth + 10;
			
			format.color = 0xFFFFFF;
			//txtEnergy = AddLabel("0/0", imgEnergy.img.x + 21, 5, 0, 1, 0x26709C);
			txtEnergy = AddLabel("0/0", 20, 122, 0, 1, 0x26709C);
			txtEnergy.wordWrap = true;
			txtEnergy.defaultTextFormat = format;	
			txtEnergy.setTextFormat(format);
			// Add Cooldown
			txtCooldown = AddLabel(" ", imgBackground.img.width - 245, 144, 0, 0);
			format.size = 12;
			format.color = 0x000000;
			format.bold = true;
			txtCooldown.defaultTextFormat = format;
			
			// Add prgClean, prgFood
			//AddImage("", "imgClean", 640, 4, true, ALIGN_LEFT_TOP);
			//prgClean = AddProgress(GUI_TOP_CLEAN, "prgClean", 674, 9, this, true);
			//prgClean.setStatus(0);
			//imgFood = AddImage("", "imgFood", imgBackground.img.width - 123, 2, true, ALIGN_LEFT_TOP);
			imgFood = AddImage("", "ImgFood", 422, 2, true, ALIGN_LEFT_TOP);
			prgFood = AddProgress(GUI_TOP_FOOD, "PrgFood", imgFood.img.x + 30, 10, this, true);
			prgFood.setStatus(0);
			ToolTip = new TooltipFormat();
			prgFood.setTooltip(ToolTip);
			
			format.size = 14;
			format.color = 0xFFFFFF;
			format.bold = true;
			txtFoodPercent = AddLabel("0%", imgFood.img.x + 23, 7, 0, 1, 0x26709C);
			txtFoodPercent.wordWrap = true;
			txtFoodPercent.defaultTextFormat = format;	
			txtFoodPercent.setTextFormat(format);				
			
			// Avatar bạn bè
			//cntFriend = AddContainer("", "ImgAvatar", imgBackground.img.width - 100, 38, true, this);
			ctnFriend = AddContainer("", "ImgAvatarFriend", 675, 35, true, this);
			
			// 1 đống button
			btnDailyBonus = AddButton(GUI_TOP_BTN_DAILYBONUS, "BtnDailyBonus", 10, imgAvatar.img.y+imgAvatar.img.height + 15, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip51");
			btnDailyBonus.setTooltip(ToolTip);
			
			//button cho cái máy quay số
			//btnDigitWheel = AddButton(GUI_TOP_BTN_DIGRITWHEEL, "BtnDigitWheel", 10, imgAvatar.img.y + imgAvatar.img.height + 65, this);
			//ToolTip = new TooltipFormat();
			//ToolTip.text = Localization.getInstance().getString("ToolTipLuckyMachine1");
			//btnDigitWheel.setTooltip(ToolTip);
			
			btnLeftMessage = AddButton(GUI_TOP_BTN_MESSAGE, "BtnNote", 0, 44, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip17");
			btnLeftMessage.setTooltip(tooltip);
			btnLetter = AddButtonEx(GUI_TOP_BTN_LETTER, "BtnExMail", 0, 55, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip18");
			btnLetter.setTooltip(ToolTip);
			btnGift = AddButtonEx(GUI_TOP_BTN_GIFT, "BtnExGift", 0, 58, this); 
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip16");
			btnGift.setTooltip(ToolTip);
			//btnDailyQuest = AddButtonEx(GUI_TOP_BTN_DAILYQUEST, "ButtonMessage1", 0, 58, this);
			//ToolTip = new TooltipFormat();
			//ToolTip.text = Localization.getInstance().getString("Tooltip19");;
			//btnDailyQuest.setTooltip(ToolTip);
			btnLog = AddButtonEx(GUI_TOP_BTN_LOG, "BtnExLog", 0, 58, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip20");
			btnLog.setTooltip(ToolTip);
			btnAnnounce = AddButtonEx(GUI_TOP_BTN_ANNOUNCE, "BtnExAnnounce", 0, 58, this)
			btnAnnounce.SetBlink(false);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip27");
			btnAnnounce.setTooltip(ToolTip);
			
			//new DailyQuest system
			//btnDailyQuestNew = AddButtonEx(GUI_TOP_BTN_DAILYQUEST_NEW, "BtnExQuest", 0, 58, this);
			btnDailyQuestNew = AddButtonEx(GUI_TOP_BTN_DAILYQUEST_NEW, "BtnExQuest", 0, 58, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip19");
			btnDailyQuestNew.setTooltip(ToolTip);
			
			btnSnapshot = AddButton(GUI_TOP_BTN_SNAPSHOT, "BtnChupAnh", 0, 58, this);
			imgSnapshot = AddImage(GUI_TOP_BTN_SNAPSHOT, "iconEXP", 375, 71);
			imgSnapshot.img.visible = false;
			//imgSnapshot.FitRect(20, 20, new Point(145, 68));
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip62");
			btnSnapshot.setTooltip(ToolTip);
			
			//button thư hệ thống
			btnSystemMail = AddButtonEx(GUI_TOP_BTN_SYSTEM_MAIL, "BtnSystemMail", 0, 58, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip76");
			btnSystemMail.setTooltip(ToolTip);
			btnSystemMail.SetBlink(false);
			//button Nap code
			btnInputCode = AddButton(GUI_TOP_BTN_INPUT_CODE, "BtnInputCode", 0, 58, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip77");
			btnInputCode.setTooltip(ToolTip);
			//Button nhặt tiền
			btnGetCoin = AddButton(BTN_GET_COIN, "Btn_Get_Coin", 758, 120 + 48, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Nam châm hút tiền";
			btnGetCoin.setTooltip(ToolTip);
			var useTimes:int = 0;
			if(GameLogic.getInstance().user.moneyMagnet != null)
			{
				useTimes = GameLogic.getInstance().user.moneyMagnet.useTimes;
			}
			txtUseTime = AddLabel("x" + useTimes.toString(), 658, 186, 0x000000, 2, 0xffffff);
			format = new TextFormat("arial", 16, 0x000000, true);
			txtUseTime.defaultTextFormat = format;
			
			// Button Chợ đen
			btnBlackMarket = AddButton(BTN_BLACK_MARKET, "BtnBlackMarket", 756.65, 170 + 48, this);
			//imgNewBlackMarket = AddImage("", "IcNewShop", 756.65, 240);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Chợ Đen";
			btnBlackMarket.setTooltip(ToolTip);
			
			//Button Ngu Mach			btnMeridian = AddButton(BTN_MERIDIAN, "BtnBlackMarket", 756.65, 220 + 48, this);			// Button Training Tower
			btnTower = AddButtonEx(BTN_TOWER, "BtnExTraining", 772, 300, this);
			btnTower.SetBlink(false);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Chợ Trắng";
			btnTower.setTooltip(ToolTip);
			//Button Ngu Mach
			btnMeridian = AddButtonEx(BTN_MERIDIAN, "BtnExMeridian", 772, 345, this);
			btnMeridian.SetBlink(false);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Ngư Mạch";
			btnMeridian.setTooltip(ToolTip);
			
			// button Liên đấu
			/*
			btnLeague = AddButton(BTN_LEAGUE, "BtnLeague", 775, 360, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Liên đấu";
			btnLeague.setTooltip(ToolTip);
			btnLeague.SetEnable(false);
			btnLeague.SetVisible(false);
			tfRank = AddLabel("", 780, 414, 0xffff00, 1, 0x000000);
			tfRank.visible = false;
			tfRank.mouseEnabled = false;
			tfRank.wordWrap = true;
			tfRank.width = 45;
			tfRank.height = 40;
			
			var fm:TextFormat = new TextFormat("Arial", 14);
			fm.align = TextFieldAutoSize.CENTER;
			tfRank.defaultTextFormat = fm;*/
			// Button Quest PowerTinh
			btnQuestPowerTinh = AddButtonEx(GUI_TOP_BTN_QUEST_PT, "BtnExQuestPowerTinh", 0, 58, this);
			btnQuestPowerTinh.SetScaleXY(0.8);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip78");
			btnQuestPowerTinh.setTooltip(ToolTip);
			btnQuestPowerTinh.SetBlink(false);
			
			// Button ngư chiến ----------------------------------
			FishWarCtn = AddContainer(CTN_FISHWARSUM, "ImgFishWarSumBg", 300, 300, true, this);
			
			btnEquipment = FishWarCtn.AddButton(BTN_EQUIPMENT, "BtnFishWarEquip", 17, 5, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Kho trang bị";
			btnEquipment.setTooltip(ToolTip);
			
			btnEnchant = FishWarCtn.AddButton(BTN_ENCHANT, "BtnFishWarEnchant", 42, 2, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Cường hóa trang bị";
			btnEnchant.setTooltip(ToolTip);
			
			//if (!Ultility.CheckNewFeatureIcon(3))
			//{
				//btnEnchant.SetDisable();
			//}
			
			btnPearlRefine = FishWarCtn.AddButton(BTN_PEARL_REFINE, "BtnFishWarPearl", 81, 5, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Tu luyện đan";
			btnPearlRefine.setTooltip(ToolTip);
			
			btnCollection = FishWarCtn.AddButton(BTN_COLLECTION, "BtnFishWarCol", 115, 7, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Thu thập đổi thưởng";
			btnCollection.setTooltip(ToolTip);
			
			btnCreate = FishWarCtn.AddButton(BTN_CREATE, "BtnFishWarCreate", 143, 3, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Chế tạo trang bị";
			btnCreate.setTooltip(ToolTip);
			//var newIc:Image = FishWarCtn.AddImage("", "IcNew", 143, 20, true, ALIGN_LEFT_TOP);
			//newIc.SetScaleXY(0.7);
			
			MaskClip = new MovieClip();
			MaskClip.graphics.beginFill(0xFF0000,1);
			MaskClip.graphics.drawRect(0, 50, 210, 50);
			MaskClip.graphics.endFill();
			this.img.addChild(MaskClip);
			FishWarCtn.img.mask = MaskClip;
			
			btnFishWarSum = AddButton(BTN_FISHWARSUM, "BtnFishWarSum", 0, 58, this);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip69");
			//ToolTip.text = "品怎么";
			btnFishWarSum.setTooltip(ToolTip);
			
			FishWarCtn.img.x = btnFishWarSum.img.x + btnFishWarSum.img.width - FishWarCtn.img.width - 10;
			FishWarCtn.img.y = btnFishWarSum.img.y + 2;
			
			//btnStatistics = FishWarCtn.AddButton(GUI_TOP_BTN_STATISTIC, "BtnFishWarStat", 84, 7, this);
			//ToolTip = new TooltipFormat();
			//ToolTip.text = Localization.getInstance().getString("Tooltip67");
			//btnStatistics.setTooltip(ToolTip);
			
			//btnStatistics = AddButton(GUI_TOP_BTN_STATISTIC, "BtnStatistics", 0, 58, this);
			//ToolTip = new TooltipFormat();
			//ToolTip.text = Localization.getInstance().getString("Tooltip67");
			//btnStatistics.setTooltip(ToolTip);
			//-----------------------------------------------------
			
			// button event
			btnEvent = AddButton(GUI_TOP_BTN_EVENT, "BtnTreasureIslandEvent", 10, 215, this);
			//btnEvent = AddButton(GUI_TOP_BTN_EVENT, "BtnFishWarCreate", 10, 215, this);
			//btnEvent = AddButton(GUI_TOP_BTN_EVENT, "BtnEvent8March", 10, 415, this);
			//btnGetGiftAfterEvent = AddButton(GUI_TOP_BTN_GET_GIFT_EVENT, "BtnExchangeHerbMedal", 10, 425, this);
			btnGetGiftAfterEvent = AddButton(GUI_TOP_BTN_GET_GIFT_EVENT, "BtnTreasureIslandChangeMedal", 10, 425, this);
			btnEvent.SetVisible(false);
			btnGetGiftAfterEvent.SetVisible(false);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Đảo giấu vàng";
			//btnEvent.SetBlink(false);
			btnEvent.setTooltip(ToolTip);
			ToolTip = new TooltipFormat();
			ToolTip.text = "Nhận quà";
			btnGetGiftAfterEvent.setTooltip(ToolTip);
			
			//btnChangeMedal = AddButton(GUI_TOP_BTN_CHANGE_MEDAL, "BtnChangeMedal", 10, 260, this);
			//ToolTip = new TooltipFormat();
			//ToolTip.text = "Đổi huy chương phú quý";
			//btnChangeMedal.setTooltip(ToolTip);
			
			//--------------
			btnLeftMessage.SetVisible(false);
			btnLetter.SetVisible(false);
			btnGift.SetVisible(false);
			//btnDailyQuest.SetVisible(false); 
			btnLog.SetVisible(false);
			btnDailyQuestNew.SetVisible(false);		
			btnSnapshot.SetVisible(false);
			imgSnapshot.img.visible = false;
			btnSystemMail.SetVisible(false);
			btnInputCode.SetVisible(false);
			//btnMagicLamp.SetVisible(false);
			//imgPrgWishingPoint.img.visible = false;
			//prgWishingPoint.setVisible(false);
			//txtWishingPoint.visible = false;
			//imgLevelWishingPoint.img.visible = false;
			
			// DailyQuest iphone task :))
			for (var i:int = 1; i < 4; i++)
			{
				var imageTemp:Image = AddImage(String(3-i), "ImgQuestLeft" + i, 217, 55);
				imageTemp.SetScaleXY(0.5);
				imageTemp.img.visible = false;
			}			
			//HiepNM2 Bỏ buff của hồ
			//AddBuffLakeInfo();
			//AddSkillInfo();
			// Event 2-9
			imgBgTitle = AddImage("ImgBgTitle", "ImgBgTitle", Constant.STAGE_WIDTH / 2 + 100, 40);
			//txtEventIndependent = AddLabel("Đang được nhân đôi kinh nghiệm đấy, các tình iu ^x^", Constant.STAGE_WIDTH, imgFood.img.y + 28, 0x00ffff, 0);
			//txtEventIndependent = AddLabel("Đang được nhân đôi kinh nghiệm đấy, các tình iu ^x^", 658, imgFood.img.y + 28, 0x00ffff, 0);
			txtEventIndependent = AddLabel("", 658, imgFood.img.y + 28, 0x00ffff, 0);
			format = new TextFormat();
			format.italic = true;
			format.bold = true;
			format.size = 14;
			txtEventIndependent.setTextFormat(format);
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000000);
			sp.graphics.drawRect(Constant.STAGE_WIDTH / 2 - 50, 0, 300, 60);
			img.addChild(sp);
			txtEventIndependent.mask = sp;
			
			imgBgTitle.img.visible = false;
			txtEventIndependent.visible = false;
			
			addHappyMondyIcon();// thứ 2 vui vẻ
			GameLogic.getInstance().BackToIdleGameState();
		}	
		
		public function AddMoneyAttackedInfo():void
		{
			ctnMoneyAttacked = AddContainer("", "CtnMoneyAttackedInfo", ctnFriend.img.x, ctnFriend.img.y + 50);
			ctnMoneyAttacked.AddLabel(GameLogic.getInstance().user.MoneyLeft + "/" + GameLogic.getInstance().user.MoneyTotal, 5, 1);
		}
		
		public function AddBuffLakeInfo():void
		{
			var ToolTip:TooltipFormat;
			//Thông tin buff kinh nghiệm
			//ctnBuffExp = AddContainer("", "CtnBuffInfo", 708, 120);
			ctnBuffExp = AddContainer("", "CtnBuffExpInfo", 605, 8);
			//Icon kinh nghiệm
			ctnBuffExp.AddImage("", "ImgEXP", 17+2, 15 + 4).FitRect(22, 22);
			// Add icon mũi tên
			ctnBuffExp.AddImage("", "IcTangEXP", 27+2, 11);
			//Phần trăm kinh nghiệm được buff
			txtBuffExp = ctnBuffExp.AddLabel("0%", 0, 3, 0xffffff, 1, 0x26709C);	
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip44");
			ctnBuffExp.setTooltip(ToolTip);
			
			//Thông tin buff tiền
			//ctnBuffMoney = AddContainer("", "CtnBuffInfo", 708, 166);			
			ctnBuffMoney = AddContainer("", "CtnBuffGoldInfo", 708, 8);			
			//Icon kinh nghiệm
			ctnBuffMoney.AddImage("", "IcGold", 13+2, 11+6).FitRect(18, 18);;
			// Add icon mũi tên
			ctnBuffMoney.AddImage("", "IcTangMoney", 27+2, 11);
			//Phần trăm kinh nghiệm được buff
			txtBuffMoney = ctnBuffMoney.AddLabel("0%", 0, 3,  0xffffff, 1, 0x26709C);	
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip45");
			ctnBuffMoney.setTooltip(ToolTip);
			
			//Thông tin buff thời gian
			//ctnBuffTime = AddContainer("", "ctnBuffClockInfo", 741, 143);			
			ctnBuffTime = AddContainer("", "CtnBuffClockInfo", 669, 8);
			//Icon kinh nghiệm
			ctnBuffTime.AddImage("", "IcClock", 10+2, 10+4);
			// Add icon mũi tên
			ctnBuffTime.AddImage("", "IcGiamTime", 27+2, 11);
			//Phần trăm kinh nghiệm được buff
			txtBuffTime = ctnBuffTime.AddLabel("0%", 0, 3, 0xffffff, 1, 0x26709C);	
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip46");
			ctnBuffTime.setTooltip(ToolTip);
		}
		
		public function updateBuffLakeInfo():void
		{
			var curLake:Lake = GameLogic.getInstance().user.CurLake;
			var rate:int = Math.min(curLake.Option["Exp"], Constant.MAX_BUFF_EXP);
			txtBuffExp.text =  rate + "%";
			
			rate = Math.min(curLake.Option["Money"], Constant.MAX_BUFF_MONEY);
			txtBuffMoney.text = rate + "%";
			
			rate = Math.min(curLake.Option["Time"], Constant.MAX_BUFF_TIME);
			txtBuffTime.text = rate + "%";
		}
		
		/*public function AddSkillInfo():void
		{
			var x:int = 775;
			var ToolTip:TooltipFormat;
			ctnMoneySkill =  AddContainer("", "ImgMoneySkillInfo", x - 10, 180);
			txtMoneySkill = ctnMoneySkill.AddLabel("0", 25, 21, 0xffffff, 0, 0x26709C);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip47");
			ctnMoneySkill.setTooltip(ToolTip);
			
			ctnLevelSkill = AddContainer("", "ImgLevelSkillInfo", x - 10, 222);			
			txtLevelSkill = ctnLevelSkill.AddLabel("0", 25, 21, 0xffffff, 0, 0x26709C);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip48");
			ctnLevelSkill.setTooltip(ToolTip);
			
			ctnSpecialFishSkill = AddContainer("", "ImgSpecialFishSkillInfo", x - 10, 264);			
			txtSpecialFishSkill = ctnSpecialFishSkill.AddLabel("0", 25, 21, 0xffffff, 0, 0x26709C);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip49");
			ctnSpecialFishSkill.setTooltip(ToolTip);
			
			ctnRareFishSkill = AddContainer("", "ImgRareFishSkillInfo", x - 10, 308);			
			txtRareFishSkill = ctnRareFishSkill.AddLabel("0", 25, 21, 0xffffff, 0, 0x26709C);
			ToolTip = new TooltipFormat();
			ToolTip.text = Localization.getInstance().getString("Tooltip50");
			ctnRareFishSkill.setTooltip(ToolTip);
			
		}*/
		
		
		/*public function updateSkillInfo():void
		{
			return;
			var userSkill:Object = GameLogic.getInstance().user.Skill;
			txtMoneySkill.text = userSkill.MoneySkill.Level;
			txtLevelSkill.text = userSkill.LevelSkill.Level;
			txtSpecialFishSkill.text = userSkill.SpecialSkill.Level;
			txtRareFishSkill.text = userSkill.RareSkill.Level;
			
			var userLevel:int = GameLogic.getInstance().user.Level;
			var skillInfo:Object = ConfigJSON.getInstance().GetSkillInfo("MoneySkill", 1);
			if (userLevel < skillInfo.LevelRequire)
			{
				ctnMoneySkill.SetVisible(false);
			}
			else
			{
				ctnMoneySkill.SetVisible(true);
			}
			
			skillInfo = ConfigJSON.getInstance().GetSkillInfo("LevelSkill", 1);
			if (userLevel < skillInfo.LevelRequire)
			{
				ctnLevelSkill.SetVisible(false);
			}
			else
			{
				ctnLevelSkill.SetVisible(true);
			}
			
			skillInfo = ConfigJSON.getInstance().GetSkillInfo("SpecialSkill", 1);
			if (userLevel < skillInfo.LevelRequire)
			{
				ctnSpecialFishSkill.SetVisible(false);
			}
			else
			{
				ctnSpecialFishSkill.SetVisible(true);
			}
			
			skillInfo = ConfigJSON.getInstance().GetSkillInfo("RareSkill", 1);
			if (userLevel < skillInfo.LevelRequire)
			{
				ctnRareFishSkill.SetVisible(false);
			}
			else
			{
				ctnRareFishSkill.SetVisible(true);
			}
		}*/
		
		
		public function InitButtonSeriesQuest():void
		{
			/*var seriquest:Array = QuestMgr.getInstance().SeriesQuest;
			var y:int = 170;
			var button:ButtonEx;
			var btnName:Array = ["ButtonQuest", "ButtonQuest", "ButtonQuest",
									"ButtonQuest", "ButtonQuest", "ButtonQuest", 
									, "ButtonQuest", , "ButtonQuest", , "ButtonQuest"];
			btnExQuestArr = [];
			for (var i:int = 0; i < seriquest.length; i++)
			{
				var quest:QuestInfo = seriquest[i] as QuestInfo;
				RemoveButtonEx(BTN_SERIQUEST + "_"  + quest.IdSeriesQuest);
				button = AddButtonEx(BTN_SERIQUEST + "_" + quest.IdSeriesQuest, btnName[i], 15, y, this);
				var ToolTip:TooltipFormat = new TooltipFormat();
				ToolTip.text = "Nhiệm vụ: " + Localization.getInstance().getString("TooltipSQ" + quest.IdSeriesQuest);
				var tmpFormat:TextFormat = new TextFormat();
				tmpFormat.bold = true;
				tmpFormat.color = 0xFF0000;
				ToolTip.setTextFormat(tmpFormat, 9, ToolTip.text.length);
				button.setTooltip(ToolTip);
				y += 40;
				button.SetVisible(true);
				button.SetBlink(false);
				if (quest.Id == 1)
				{
					button.SetBlink(true);		
				}
				btnExQuestArr.push(button);
			}*/
			if (GameLogic.getInstance().user.IsViewer()) return;
			if (!Ultility.IsInMyFish())	return;
			
			addBtnExSeriQuest();
			UpdateAllPos();
			//updateStatusBtnEvent("PearFlower");
			//updateStatusBtnEvent("Event_8_3_Flower");
		}		
		
		public function addBtnExSeriQuest():void
		{
			//btnType = 0 là button bình thường
			//btnTyp = 1 là button mở rộng		
			var btnInfo:Array = [ 	{btnType:"1", btnName:"BtnQuest"},
									{btnType:"1", btnName:"BtnQuest" },
									{btnType:"0", btnName:"BtnQuestGiamTien" },
									{btnType:"0", btnName:"BtnQuestVuotCap" },
									{btnType:"0", btnName:"BtnQuestCaDacBiet" },									
									{btnType:"0", btnName:"BtnQuestCaQuy" },
									{btnType:"0", btnName:"BtnQuestCaLinh" },
									{btnType:"0", btnName:"BtnQuestAddMaterial" }			// quest ngư thạch
								];
			var seriquest:Array = QuestMgr.getInstance().SeriesQuest;
			var y:int = 235;
				
			var CheckEvent:int = EventMgr.CheckEvent("Khong_Co");
 			if (CheckEvent == EventMgr.CURRENT_IN_EVENT || MinigameMgr.getInstance().checkMinigame())
				y = 285 + 50;
			var dy:int = 0;
			btnExQuestArr = [];
			btnQuestArr = [];
			var btnEx:ButtonEx, btn:Button;
			var posBtnHelp:Point = new Point();
			var sizeBtnHelp:Point = new Point();
			for (var i:int = 0; i < seriquest.length && i < QuestMgr.MAX_VISIBLE_QUEST; i++)
			{				
				var quest:QuestInfo = seriquest[i] as QuestInfo;
				var ToolTip:TooltipFormat = new TooltipFormat();
				ToolTip.text = "Nhiệm vụ: " + Localization.getInstance().getString("TooltipSQ" + quest.IdSeriesQuest);
				var tmpFormat:TextFormat = new TextFormat();
				tmpFormat.bold = true;
				tmpFormat.color = 0xFF0000;
				ToolTip.setTextFormat(tmpFormat, 9, ToolTip.text.length);
				if (btnInfo[quest.IdSeriesQuest - 1].btnType == 1)
				{
					RemoveButtonEx(BTN_SERIQUEST + "_"  + quest.IdSeriesQuest);
					btnEx = AddButtonEx(BTN_SERIQUEST + "_" + quest.IdSeriesQuest, btnInfo[quest.IdSeriesQuest - 1].btnName, 22, y, this);			
					btnEx.setTooltip(ToolTip);
					btnEx.SetVisible(true);
					btnEx.SetBlink(false);
					dy = btnEx.img.height + 10;
					if (quest.Id == 1)
					{
						btnEx.SetBlink(true);
					}
					btnExQuestArr.push(btnEx);
					if (i == 0)
					{
						posBtnHelp.x = 55;
						posBtnHelp.y = y;
						sizeBtnHelp.x = btnEx.img.width;
						sizeBtnHelp.y = btnEx.img.height;
					}
				}
				else
				{
					RemoveButton(BTN_SERIQUEST + "_"  + quest.IdSeriesQuest);
					btn = AddButton(BTN_SERIQUEST + "_" + quest.IdSeriesQuest, btnInfo[quest.IdSeriesQuest - 1].btnName, 10, y - 20, this);
					btn.setTooltip(ToolTip);					
					btn.SetVisible(true);
					btnQuestArr.push(btn);
					dy = btn.img.height + 5;
					if (i == 0)
					{
						posBtnHelp.x = 75;
						posBtnHelp.y = y + 25;
						sizeBtnHelp.x = btn.img.width;
						sizeBtnHelp.y = btn.img.height;
					}
				}
				y += dy;
			}
			if (seriquest.length > 0)
			{
				//countShowHelpQuest = 0;
				if(!btnExQuestHelp)
				{
					if(btnEvent == null)
					{
						btnExQuestHelp = AddButtonEx(BTN_HELP_SERIQUEST, "BtnExHelpQuest", posBtnHelp.x, posBtnHelp.y - sizeBtnHelp.y + 15, this);
					}
					else 
					{
						btnExQuestHelp = AddButtonEx(BTN_HELP_SERIQUEST, "BtnExHelpQuest", posBtnHelp.x, posBtnHelp.y - sizeBtnHelp.y + btnEvent.img.height + 10 + 15, this);
					}
				}
				else 
				{
					if(btnEvent == null)
					{
						btnExQuestHelp.SetPosY(posBtnHelp.y - sizeBtnHelp.y + 15);
					}
					else
					{
						btnExQuestHelp.SetPosY(posBtnHelp.y - sizeBtnHelp.y + btnEvent.img.height + 10 + 15);
					}
				}
			}
			else
			{
				if (btnExQuestHelp && btnExQuestHelp.img)
				{
					btnExQuestHelp.SetVisible(false);
				}
				
				var btnnn:Button = GetButton("BtnSeriQuest_7");
				if (btnnn && btnnn.img)
				{
					btnnn.SetVisible(false);
				}
			}
		}
		
		// Kiểm tra button Event
		public function updateStatusBtnEvent(name:String):void
		{
			var CheckEvent:int = EventMgr.CheckEvent(name);
			if (CheckEvent == EventMgr.CURRENT_IN_EVENT)
			{
				if(!user.IsViewer())
				{
					btnEvent.SetVisible(true);
					//btnChangeMedal.SetVisible(true);
					//btnMagicLamp.SetVisible(true);
					//imgPrgWishingPoint.img.visible = true;
					//prgWishingPoint.setVisible(true);
					//txtWishingPoint.visible = true;
					//imgLevelWishingPoint.img.visible = true;
					btnGetGiftAfterEvent.SetVisible(true);
				}
				//imgCombatCount.img.visible = true;
				//txtCombatCount.visible = true;
			}
			else
			{
				btnEvent.SetVisible(false);
				//btnChangeMedal.SetVisible(false);
				//if (btnEvent) btnEvent.SetVisible(false);
				//if (btnMagicLamp) btnMagicLamp.SetVisible(false);
				//if (imgPrgWishingPoint)	imgPrgWishingPoint.img.visible = false;
				//if (prgWishingPoint) prgWishingPoint.setVisible(false);
				//if (txtWishingPoint) txtWishingPoint.visible = false;
				//if (imgLevelWishingPoint) imgLevelWishingPoint.img.visible = false;
			}
			//btnEvent.SetVisible(false);	//fake
		}
		
		public function UpdateFriend():void
		{
			/*var date:Date = new Date();
			date.dateUTC = 28;
			date.monthUTC = 4;
			date.fullYearUTC = 2012;
			date.hoursUTC = 0;
			
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var curDate:Date = new Date(curTime * 1000);
			trace(curDate.monthUTC, curDate.hoursUTC);
			if (date > curDate)
			{
				btnBlackMarket.SetEnable(false);
				var tooltipFormat:TooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Chợ đen\nSắp ra mắt";
				btnCreate.setTooltip(tooltipFormat);
			}
			else
			{
				btnBlackMarket.SetEnable(true);
			}*/
			
			user = GameLogic.getInstance().user;		
			if (user && user.IsViewer())
			{
				btnBlackMarket.SetVisible(false);
				//imgNewBlackMarket.img.visible = false;
				//btnTower.SetVisible(false);
				
				ctnFriend.ClearComponent();
				ctnFriend.img.visible = true;
				ctnFriend.AddImage("", "ImgAvatarFriend", 0, 0, true, ALIGN_LEFT_TOP);
				if (user.AvatarPic == null || !user.AvatarPic)
				{
					user.AvatarPic = Main.staticURL + "/avatar.png";
				}
			
				if (user.Name == null)
				{
					user.Name = "Unknown";
				}
				
				ctnFriend.AddImage("", user.AvatarPic, 37, 43, false, ALIGN_LEFT_TOP).SetSize(51, 51);
				//AddMoneyAttackedInfo();
				
				
				var prgExp:ProgressBar = ctnFriend.AddProgress("", "PrgEXP", 42, 13, this, true);
				var levelUp:int = ConfigJSON.getInstance().getUserLevelExp(user.GetLevel(false) + 1);
				var curExp:int = user.GetExp(false);
				prgExp.setStatus(curExp / levelUp);				
				format.size = 14;
				format.bold = true;
				format.align = "center";
				format.color = 0xFFFFFF;
				ctnFriend.AddLabel(Ultility.StandardNumber(curExp), 33, 10, 0xFFFFFF, 1, 0x26709C).setTextFormat(format);
				
				var imgExp:Image = ctnFriend.AddImage("", "ImgEXP", 4, 4, true, ALIGN_LEFT_TOP);
				format.size = 14;
				format.color = 0xFFFF00;
				format.bold = true;				
				format.align = "center";
				var lbLevel:TextField = ctnFriend.AddLabel(Ultility.StandardNumber(user.GetLevel(false)), -29, 12, 0, 1, 0x26709C);
				lbLevel.wordWrap = true;
				lbLevel.setTextFormat(format);
				
				format.size = 11;
				format.color = 0xFFFFFF;
				format.bold = true;
				var IconGold:Image = ctnFriend.AddImage("", "IcGold", 29, 100, true, ALIGN_LEFT_TOP);
				IconGold.SetScaleX(0.6);
				IconGold.SetScaleY(0.6);
				var lbGold:TextField = ctnFriend.AddLabel(Ultility.StandardNumber(user.GetMoney(false)), 47, 98, 0, 0, 0x26709C);
				lbGold.setTextFormat(format);
				
				var lbNick:TextField = ctnFriend.AddLabel("", 13, 115);
				var nick:String = user.Name;
				if (nick.length > 15)
				{
					nick = nick.substr(0, 15) + "..";
				}
				lbNick.text = nick
				lbNick.defaultTextFormat = format;				
				
				// Remove button seriesquest
				var button:ButtonEx;
				for (var i:int = 0; i < btnExQuestArr.length; i++)
				{
					button = btnExQuestArr[i];
					button.SetVisible(false);
					RemoveButtonEx(button.ButtonID);
				}
				btnExQuestArr = [];
				
				var btn:Button;
				for (i = 0; i < btnQuestArr.length; i++)
				{
					btn = btnQuestArr[i];
					btn.SetVisible(false);
					RemoveButton(btn.ButtonID);
				}
				btnQuestArr = [];
				var btnTemp:Button;
				var btnTemp1:Button;
				var btnTemp2:Button;
				btnTemp = GetButton(GUI_TOP_BTN_ICON_MOIBAN);
				if(GetButton(GUI_TOP_BTN_ICON_MOIBAN)!=null)
					GetButton(GUI_TOP_BTN_ICON_MOIBAN).SetVisible(false);//hiepnm2
				btnTemp1 = GetButton("GUI_TOP_BTN_NHANQUA_INVITEFRIEND_1");
				btnTemp2 = GetButton("GUI_TOP_BTN_NHANQUA_INVITEFRIEND_2");
				
				if(btnTemp1)
					RemoveButton("GUI_TOP_BTN_NHANQUA_INVITEFRIEND_1");			//hiepnm2
				if (btnTemp2)
					RemoveButton("GUI_TOP_BTN_NHANQUA_INVITEFRIEND_2");			//hiepnm2
				if(GetImage("idimg_helper_invitefriend")!=null)
					RemoveImage(GetImage("idimg_helper_invitefriend"));
					
				//btnEvent.SetPos(10, 225);
			}
			else
			{//ve nha minh
				btnBlackMarket.SetVisible(true);
				//imgNewBlackMarket.img.visible = true;
				//btnTower.SetVisible(true);
				if (ctnFriend)
				{
					ctnFriend.ClearComponent();
					ctnFriend.img.visible = false;
				}
				
				//nick name của mình
				var name:String = user.GetMyInfo().Name;
				if (!name) name = "Unknown";
				if (name && name.length > 8)
				{
					name = name.substr(0, 8) + "..";
				}
				userName.text = name;
				
				//avatar
				avatarUrl = user.GetMyInfo().AvatarPic;
				if (!avatarUrl) avatarUrl = Main.staticURL + "/avatar.png";
				RemoveImage(avatar);
				avatar = null;
				avatar = AddImage(GUI_TOP_AVATAR, avatarUrl, imgAvatar.img.x + 41, 43, false, Image.ALIGN_LEFT_TOP);
				avatar.SetSize(51, 51);

				UpdateGUI();
				//Remove button GUI_TOP_BTN_ICON_MOIBAN
				btnTemp1 = GetButton("GUI_TOP_BTN_NHANQUA_INVITEFRIEND_1");
				btnTemp2 = GetButton("GUI_TOP_BTN_NHANQUA_INVITEFRIEND_2");
				
				if(btnTemp1)
					RemoveButton("GUI_TOP_BTN_NHANQUA_INVITEFRIEND_1");			//hiepnm2
				if (btnTemp2)
					RemoveButton("GUI_TOP_BTN_NHANQUA_INVITEFRIEND_2");			//hiepnm2
				RemoveImage(GetImage("idimg_helper_invitefriend"));
				
				if (isShowCtnFishWar)
				{
					ShowGui();
					isShowCtnFishWar = true;
				}
			}			
			UpdateAllPos();
		}
		
		public function UpdateInfo():void
		{
			if(GameLogic.getInstance().gameState != GameState.GAMESTATE_INIT)
			{
				// update avatar
				//if (avatarUrl != GameLogic.getInstance().user.GetMyInfo().AvatarPic && avatarUrl != Main.staticURL + "/avatar.png")
				//{
					//avatarUrl = GameLogic.getInstance().user.GetMyInfo().AvatarPic;
					//if (!avatarUrl) avatarUrl = Main.staticURL + "/avatar.png";
					//RemoveImage(avatar);
					//avatar = null;
					//avatar = AddImage(GUI_TOP_AVATAR, avatarUrl, imgAvatar.img.x + 41, 43, false, Image.ALIGN_LEFT_TOP);
					//avatar.SetSize(51, 51);
				//}				
				
				// update level, prgLevel
				if ((iLevel != user.GetLevel(true) || iExp != user.GetExp(true)))
				{
					iLevel = user.GetLevel(true);
					if (iExp == 0)
					{
						iExp = user.GetExp(true);
					}
					else
					{
						if(user.GetExp(true) > iExp)
						{
							iExp += Math.round((user.GetExp(true) - iExp) / 2);
						}
						else 
						{
							iExp -= Math.round((iExp - user.GetExp(true))/2);
						}
						var effBubble:ImgEffectBuble = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_BUBLE, effExp) as ImgEffectBuble;
						effBubble.SetInfo(1, 1.6, 4, 3);
					}
					txtExp.text = Ultility.StandardNumber(iExp);					
					var levelUp:int = ConfigJSON.getInstance().getUserLevelExp(iLevel);
					txtLevel.text = Ultility.StandardNumber(iLevel);
					prgEXP.setStatus(iExp / levelUp);
					var st:String;
					var tFormat:TextFormat = new TextFormat();
					tFormat.bold = true;					
					tFormat.color = 0xFF0000;
					var tt:TooltipFormat = new TooltipFormat();			
					if (iLevel >= ConfigJSON.maxUserLevel)
					{
						st = Localization.getInstance().getString("Tooltip13");
						st = st.replace("@xp", 0);
						tt.text = st;
						tt.setTextFormat(tFormat, 9, 9 + 1);
					}
					else if (levelUp > 0)
					{						
						st = Localization.getInstance().getString("Tooltip13");
						st = st.replace("@xp", Ultility.StandardNumber(levelUp - iExp).toString());
						tt.text = st;
						tt.setTextFormat(tFormat, 9, 9 + Ultility.StandardNumber(levelUp - iExp).toString().length);
					}
					else
					{
						st = Localization.getInstance().getString("GUILabel31");
						tt.text = st;
						prgEXP.setStatus(1);
					}										
					
					prgEXP.setTooltip(tt);
					
					txtEnergy.text = Ultility.StandardNumber(iEnergy);// + " / " + Ultility.StandardNumber(ConfigJSON.getInstance().getMaxEnergy(user.GetLevel(true)));
					format.size = 14;
					if (user.GetMyInfo().bonusMachine > 0)
					{
						format.color = 0x00FF33;
					}
					else 
					{
						format.color = 0xFFFFFF;
					}
					format.bold = true;
					txtEnergy.setTextFormat(format);
					format.color = 0xFF0000;
					format.size = 16;
					//txtEnergy.setTextFormat(format, txtEnergy.text.indexOf("/"), txtEnergy.text.indexOf("/") + 1);			
					//SuggestEnergyTextColor();
				}
				var CheckEvent:int = EventMgr.CheckEvent("TreasureIsland");
				if (CheckEvent != EventMgr.CURRENT_IN_EVENT || !Ultility.IsInMyFish())
				{
					btnEvent.SetVisible(false);
					//btnChangeMedal.SetVisible(false);
					if (GuiMgr.getInstance().GuiQuestHerb.IsVisible)
					{
						GuiMgr.getInstance().GuiQuestHerb.Hide();
					}
					
					if (GuiMgr.getInstance().GuiAutoMixHerbPotion3.IsVisible)
					{
						GuiMgr.getInstance().GuiAutoMixHerbPotion3.Hide();
					}
				}
				else
				{
					btnEvent.SetVisible(true);
				}
				
				
				if(GameLogic.getInstance().isEventDuplicateExp)
				{			
					var curTimeServer:Number = GameLogic.getInstance().CurServerTime;
					if(isRunNotify)
					{
						if (txtEventIndependent)
						{
							imgBgTitle.img.visible = true;
							txtEventIndependent.visible = true;
							
							txtEventIndependent.x -= 2;
							countRun ++;
							if (countRun > 350)
							{
								isRunNotify = false;
								lastRunTime = GameLogic.getInstance().CurServerTime;
							}
						}
					}
					else 
					{
						if(countRun > 0)
						{
							if (txtEventIndependent)
							{
								imgBgTitle.img.visible = false;
								txtEventIndependent.visible = false;
								txtEventIndependent.x += 2 * countRun;
								countRun = 0;
								isRunNotify = false;
							}
						}
						else if (curTimeServer - lastRunTime > 3)
						{
							isRunNotify = true;
						}
					}
				}
				
				//Event thang 9 sac mau
				//var event:Object;
				//if (GameLogic.getInstance().user.GetMyInfo()["event"] != null) 
				//{
					//event = GameLogic.getInstance().user.GetMyInfo()["event"]["IconChristmas"];
				//}
				//if (GameLogic.getInstance().isEventND() && event != null && event["LuckyUser"] != null && event["LuckyUser"] != "")
				//{
					//curTimeServer = GameLogic.getInstance().CurServerTime;
					//if(isRunNotify)
					//{
						//imgBgTitle.img.visible = true;
						//txtEventIndependent.visible = true;
						//txtEventIndependent.x -= 2;
						//countRun ++;
						//if (countRun > 350)
						//{
							//isRunNotify = false;
							//lastRunTime = GameLogic.getInstance().CurServerTime;
						//}
						//var name:String = event["LuckyUser"];
						//txtEventIndependent.htmlText = "Chúc mừng người chơi <font color = '#ffff00'>" + name + "</font> đã nhận được phần thưởng <font color = '#ffff00'>Ông Cá Noel</font>";
					//}
					//else 
					//{
						//if(countRun > 0)
						//{
							//imgBgTitle.img.visible = false;
							//txtEventIndependent.visible = false;
							//txtEventIndependent.x += 2 * countRun;
							//countRun = 0;
							//isRunNotify = false;
						//}
						//else if (curTimeServer - lastRunTime > 3)
						//{
							//isRunNotify = true;
						//}
					//}
				//}
				
				// Dòng text thông báo
				/**
				 * Các bước thực hiện
				 * Bước 1: Thêm 1 câu thì tăng hằng số numTextRun thêm 1 (và ngược lại)
				 * Bước 2: Thếm 2 string vào localization ở 2 mục MessageInGame + id và MessageInGameItemname + id
				 * Bước 3: Viết thêm vào hàm getUserTextRun nếu trong câu có "@User";
				 * Bước 4: Viết thêm vào hàm GetNumCountTextRun để trả về lượng txtEventIndependent.width / 2;
				 */
				//if (GameLogic.getInstance().LastTimeKillBoss != -1 && GameLogic.getInstance().CurServerTime - GameLogic.getInstance().LastTimeKillBoss < 1800)
				if (GameLogic.getInstance().user.Notification != null && 
						LeagueController.getInstance().mode == LeagueController.IN_HOME)//xet cả liên đấu
				{
					curTimeServer = GameLogic.getInstance().CurServerTime;
					if(isRunNotify)
					{
						//trace("txtEventIndependent.x = " + txtEventIndependent.x)
						if (txtEventIndependent)
						{
							imgBgTitle.img.visible = true;
							txtEventIndependent.visible = true;
							
							txtEventIndependent.x -= 2;
						}
						countRun ++;
						if (idTextRun == -1)
						{
							idTextRun = Math.floor((arrTextRun.length - 1) * Math.random());
						}
						
						if (countRun > arrCountRun[idTextRun])
						{
							isRunNotify = false;
							lastRunTime = GameLogic.getInstance().CurServerTime;
						}
						
						if (strTextRun == "")
						{
							if (checkTournamentRegister())
							{
								strTextRun = arrTextRun[numTextRun];
							}
							else
							{
								strTextRun = arrTextRun[idTextRun];
							}
							if (strTextRun.search("@User") >= 0)
							{
								if (strTextRun.search("Huy Chương Thần Thánh") >= 0)
								{
									if (GameLogic.getInstance().user.Notification != null && GameLogic.getInstance().user.Notification["Seal"] != null)
									{
										if (GameLogic.getInstance().user.Notification["Seal"].name != null)
										{
											strTextRun = strTextRun.replace("@User", GameLogic.getInstance().user.Notification["Seal"].name);
										}
										else
										{
											strTextRun = "";
										}
									}
									else
									{
										strTextRun = "";
									}
								}
								else
								{
									strTextRun = strTextRun.replace("@User", getUserTextRun(idTextRun));
								}
							}
							if (strTextRun.search("@ItemName") >= 0)
							{
								if (strTextRun.search("Huy Chương Thần Thánh") >= 0)
								{
									if (GameLogic.getInstance().user.Notification != null && GameLogic.getInstance().user.Notification["Seal"] != null)
									{
										if (GameLogic.getInstance().user.Notification["Seal"].idSeal != null)
										{
											strTextRun = strTextRun.replace("@ItemName", Localization.getInstance().getString("Seal" + GameLogic.getInstance().user.Notification["Seal"].idSeal) + " Thần");
										}
										else
										{
											strTextRun = "";
										}
									}
									else
									{
										strTextRun = "";
									}
								}
								else
								{
									strTextRun = strTextRun.replace("@ItemName", String(arrItemName[idTextRun]));
								}
							}
						}
						//txtEventIndependent.htmlText = "Chúc mừng người chơi <font color = '#ffff00'>" + GameLogic.getInstance().WinBossUser + "</font> đã chiến thắng <font color = '#ffff00'>Boss Tua Rua</font>";
						if (strTextRun != "")
						{
							if(txtEventIndependent)
								txtEventIndependent.htmlText = strTextRun;
						}
					}
					else 
					{
						if(countRun > 0)
						{
							if (txtEventIndependent)
							{
								imgBgTitle.img.visible = false;
								txtEventIndependent.visible = false;
								txtEventIndependent.x += 2 * arrCountRun[idTextRun];
								//trace("txtEventIndependent.x = " + txtEventIndependent.x)
								countRun = 0;
								isRunNotify = false;
							}
						}
						else if (curTimeServer - lastRunTime > 5)
						{
							isRunNotify = true;
							idTextRun = -1;
							strTextRun = "";
						}
					}
				}
				else if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
				{//xét liên đấu
					imgBgTitle.img.visible = false;
					//txtEventIndependent.visible = false;
					txtEventIndependent = null;
				}
				
				//else 
				//{
					//imgBgTitle.img.visible = false;
					//txtEventIndependent.visible = false;
					//txtEventIndependent.x += 2 * countRun;
					//countRun = 0;
					//isRunNotify = false;
				//}
				
				//else
				//{
					//btnEvent.SetVisible(false);
				//}
				// update money
				if(user.GetMoney(true) != iMoney)
				{
					if (iMoney == 0)
					{
						iMoney = user.GetMoney(true);
					}
					if(user.GetMoney(true) > iMoney)
					{
						iMoney += Math.round((user.GetMoney(true) - iMoney)/2);
					}
					else if(user.GetMoney(true) < iMoney)
					{
						iMoney -= Math.round((iMoney - user.GetMoney(true))/2);
					}
					txtMoney.text = Ultility.StandardNumber(iMoney)
				}
				
				// Update ZMoney
				if (iZMoney != user.GetZMoney(true))
				{
					iZMoney = user.GetZMoney(true);
					txtZMoney.text = Ultility.StandardNumber(iZMoney);
				}
				
				labelDiamond.text = Ultility.StandardNumber(user.getDiamond());
				
				// update energy
				if (iEnergy < ConfigJSON.getInstance().getMaxEnergy(user.GetLevel(true)))		// đồng hồ đếm ngược
				{
					var tmp:Number = GameLogic.getInstance().CurServerTime - user.GetMyInfo().LastEnergyTime;					
					var regentime:int = ConfigJSON.getInstance().getConstantInfo("pa_13");
					var cl:Number = regentime - tmp;
					var min:int = cl / 60;
					var sec:int = cl - min * 60;
					var minSt:String = min.toString();
					var secSt:String = sec.toString();
					if (min < 10)
					{
						minSt = "0" + min.toString();
					}
					if (sec < 10)
					{
						secSt = "0" + sec.toString();
					}
					var cooldown:String = "hồi phục " + minSt + ":" + secSt;
					
					txtCooldown.text = cooldown;
				}
				else
				{
					txtCooldown.text = ""
				}
				if (iEnergy != int(user.GetEnergy(true)))		// Hiển thị energy
				{
					updateEnergy();
				}
				
				// update food				
				var sum:Number = 0.0;
				var i:int;
				var fish:Fish;
				var numFish:int = 0;
				for (i = 0; i < user.FishArr.length; i++)
				{
					fish = user.FishArr[i] as Fish;
					if (!fish.IsEgg)
					{
						sum += fish.Full();
						numFish++;
					}
				}
				
				/*1st event update wishing point*/
				var wp:int = MagicLampMgr.getInstance().WP;
				var levelWP:int = MagicLampMgr.getInstance().LevelWish;
				//var wp:int = BirthDayItemMgr.getInstance().getNum();
				//if (iWishingPoint != wp || iLevelWishingPoint != levelWP)
				//{
					//updateWishingPoint();
				//}
				//ToolTip = new TooltipFormat();
				if (Ultility.IsInMyFish())	
				if (numFish > 0)
				{
					var stt:Number = sum / numFish;
					var per:int = Math.round(stt * 100);
					if(iPercentFood != per)
					{
						iPercentFood = per;
						prgFood.setStatus(stt);						
						if(iPercentFood == 100)
						{
							prgFood.setTooltipText(Localization.getInstance().getString("Tooltip22"));
						}
						else
						{
							prgFood.setTooltipText(Localization.getInstance().getString("Tooltip23"));
						}		
						txtFoodPercent.text = iPercentFood.toString() + "%";
					}
				}
				else
				{
					if(iPercentFood != 0)
					{
						iPercentFood = 0;
						prgFood.setStatus(0);
						prgFood.setTooltipText(Localization.getInstance().getString("Tooltip23"));
						txtFoodPercent.text = "0%";
					}
				}		
				
				/*update nút máy quay số khi thay đổi level*/
				//updateDigitWheel();
			}
		}
		
		private function updateDigitWheel():void 
		{
			var lockBtn:Boolean = !MinigameMgr.getInstance().checkMinigame();
			var isMe:Boolean = !GameLogic.getInstance().user.IsViewer();
			var visible:Boolean = (!lockBtn && Ultility.IsInMyFish() && isMe);
			btnDigitWheel.SetVisible(!visible);
		}
		
		/*1st event update wishing point*/
		private function updateWishingPoint():void 
		{
			var preLevel:int = MagicLampMgr.getInstance().countLevel(iWishingPoint);
			//iWishingPoint = BirthDayItemMgr.getInstance().getNum();
			iWishingPoint = MagicLampMgr.getInstance().WP;
			
			var maxWP:int = MagicLampMgr.getInstance().MaxWP;
			prgWishingPoint.setStatus(iWishingPoint / maxWP);
			//prgWishingPoint.setStatus(0.5);
			var tip:TooltipFormat = new TooltipFormat();
			var str:String = Localization.getInstance().getString("Tooltip80");
			str = str.replace("@num", iWishingPoint);
			str = str.replace("@maxnum", maxWP);
			tip.text = str;
			prgWishingPoint.setTooltip(tip);
			txtWishingPoint.text = iWishingPoint.toString() + " / " + maxWP;
			var levelWP:int = MagicLampMgr.getInstance().LevelWish;
			iLevelWishingPoint = levelWP;
			if (EventMgr.CheckEvent("BirthDay")==EventMgr.CURRENT_IN_EVENT)
			{
				imgLevelWishingPoint.LoadRes("EventBirthday_No" + levelWP);
			}
			var hasGift:Boolean = MagicLampMgr.getInstance().LightBlink;
			if (levelWP > preLevel && hasGift)
			{
				btnMagicLamp.SetBlink(true);
			}
			txtWishingPoint.x = prgWishingPoint.x + 33;
			txtWishingPoint.y = prgWishingPoint.y - 1;
			imgLevelWishingPoint.img.scaleX = imgLevelWishingPoint.img.scaleY = 0.6;
			imgLevelWishingPoint.img.x = imgPrgWishingPoint.img.x + 10;
			imgLevelWishingPoint.img.y = imgPrgWishingPoint.img.y + 6;
			//imgLevelWishingPoint.FitRect(20, 20, new Point(imgPrgWishingPoint.img.x + 4, imgPrgWishingPoint.img.y + 4));
		}
		
		public function updateEnergy():void 
		{
			var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel());
			iEnergy = int(GameLogic.getInstance().user.GetEnergy(true));
			txtEnergy.text = Ultility.StandardNumber(iEnergy);// + " / " + Ultility.StandardNumber(maxEnergy);
			format = new TextFormat();
			format.size = 14;
			if(user.GetMyInfo().bonusMachine > 0)
			{
				format.color = 0x00FF33;
			}
			else 
			{
				format.color = 0xFFFFFF;
			}
			format.bold = true;
			//format.align = "center";
			txtEnergy.setTextFormat(format);
			//txtEnergy.setTextFormat(format, txtEnergy.text.indexOf("/"), txtEnergy.text.indexOf("/") + 1);
			
			SuggestEnergyTooltip(iEnergy,maxEnergy);
			prgEnergy.setStatus(iEnergy / maxEnergy);
		}
		
		public function getUserTextRun(idTextRun:int):String
		{
			switch (idTextRun) 
			{
				case 0:
					return GameLogic.getInstance().WinBossUser;
				break;
			}
			return "";
		}
		
		public function UpdateGUI():void
		{			
			updateBtnLock();
			if (GameLogic.getInstance().user.NewMail)
			{
				btnLetter.SetBlink(true);
			}
			else
			{
				btnLetter.SetBlink(false);
			}
			
			if (MailMgr.getInstance().isShowButtonMail())
			{
				btnSystemMail.SetVisible(true);
				if (MailMgr.getInstance().checkHasNewMail())
				{
					btnSystemMail.SetBlink(true);
				}
				else
				{
					btnSystemMail.SetBlink(false);
				}
			}
			else
			{
				btnSystemMail.SetVisible(false);
			}
			
			if (GameLogic.getInstance().user.NewGift)
			{
				btnGift.SetBlink(true);
			}
			else
			{
				btnGift.SetBlink(false);
			}
		}
		
		/**
		 * Hiển thị số task còn lại của DailyQuest
		 * @param	id
		 */
		public function showDailyQuestTask(id:int):void
		{
			for (var j:int = 0; j < 3; j++)
			{
				GetImage(String(j)).img.visible = false;
			}
			if (id != -1)
			{
				GetImage(String(id)).img.visible = true;
			}
		}
		
		public function RemoveButtonGift(): void
		{
			if (!GameLogic.getInstance().user.NewGift)
			{
				btnGift.SetBlink(false);
			}
		}
		
		public function RemoveButtonMail(): void
		{
			if (!GameLogic.getInstance().user.NewMail)
			{
				btnLetter.SetBlink(false);
			}
		}
		
		public function RemoveButtonSystemMail():void
		{
			if (!MailMgr.getInstance().checkHasNewMail())
			{
				btnSystemMail.SetBlink(false);
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonMove(event, buttonID);
			switch (buttonID) 
			{
				case BTN_HELP_SERIQUEST:
					if (btnExQuestHelp && btnExQuestHelp.img && btnExQuestHelp.img.visible)
					{
						btnExQuestHelp.SetHighLight();
					}
				break;
				
				//case BTN_FISHWARSUM:
				//case CTN_FISHWARSUM:
					//if (isMoving)	
					//break;
					//else if (isInHidePos)
						//ShowGui();
				//break;
				
				default:
					
				break;
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonOut(event, buttonID);
			switch (buttonID) 
			{
				case BTN_HELP_SERIQUEST:
					if (btnExQuestHelp && btnExQuestHelp.img && btnExQuestHelp.img.visible)
					{
						btnExQuestHelp.SetHighLight(-1);
					}
				break;
				
				//case BTN_FISHWARSUM:
				//case CTN_FISHWARSUM:
					//if (!isInHidePos)
						//HideGui();
				//break;
				
				default:
					
				break;
			}
		}
		
		public function ShowGui():void
		{
			isMoving = !isMoving;
			isShowCtnFishWar = !isShowCtnFishWar;
			TweenLite.to(FishWarCtn.img, 1, { x:showPos.x, y:showPos.y , ease:Sine.easeOut  } );
			isInHidePos = !isInHidePos;
		}
		
		public function HideGui():void
		{
			isMoving = !isMoving;
			isShowCtnFishWar = !isShowCtnFishWar;
			TweenLite.to(FishWarCtn.img, 0.6, { x:hidePos.x, y:hidePos.y , ease:Sine.easeOut } );
			isInHidePos = !isInHidePos;
		}
		
		public function ShowNotifyNewQuest(isShow:Boolean = true):void 
		{
			//countShowHelpQuest = 0;
			//btnExQuestHelp.img.alpha = 1;
			btnExQuestHelp.SetVisible(isShow);
			if (isShow)
			{
				if (QuestMgr.getInstance().SeriesQuest.length <= 0 || !Ultility.IsInMyFish())
				{
					btnExQuestHelp.SetVisible(false);
				}
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			var ToolTip:TooltipFormat;
			var tmpFormat:TextFormat;
			var cmdReceiveGift:SendEventService;
			switch (buttonID)
			{
				case BTN_BUY_DIAMOND:
					GuiMgr.getInstance().guiBuyDiamond.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_PASSWORD:
					GuiMgr.getInstance().guiPassword.showGUI();
					break;
				case BTN_MERIDIAN:
					GuiMgr.getInstance().guiMeridian.showGUI();
					break;
				case BTN_CREATE:
					GuiMgr.getInstance().guiChooseFactory.Show(Constant.GUI_MIN_LAYER, 6);
					break;
				case BTN_QUICK_PAY:
					GuiMgr.getInstance().guiAddZMoney.Show(Constant.GUI_MIN_LAYER, 3);
					/*trace("acc name", GameLogic.getInstance().user.GetMyInfo().UserName);
					GetButton(BTN_QUICK_PAY).SetEnable(false);
					GetButton(BTN_QUICK_PAY).SetEnable(false);
					ExternalInterface.addCallback("updateG", function ():void {
						Exchange.GetInstance().Send(new SendUpdateG());
						GetButton(BTN_QUICK_PAY).SetEnable(true);
					});
					ExternalInterface.call("payment", GameLogic.getInstance().user.GetMyInfo().UserName);*/
					break;
				//case BTN_COME_BACK_MAP:
					//ProcessGotoWorld();
					//break;
				case BTN_BLACK_MARKET:
					//var date:Date = new Date();
					//date.dateUTC = 28;
					//date.monthUTC = 3;
					//date.fullYearUTC = 2012;
					//date.hoursUTC = 15;
					//
					//var curTime:Number = GameLogic.getInstance().CurServerTime;
					//var curDate:Date = new Date(curTime * 1000);
					//trace("time", curDate.hoursUTC, curDate.dateUTC, curDate.monthUTC, curDate.fullYearUTC);
					//if (date > curDate)
					{
						GuiMgr.getInstance().guiMarket.Show(Constant.GUI_MIN_LAYER, 6);
					}					
					break;
				case BTN_TOWER:
					GuiMgr.getInstance().GuiTrainingTower.Show(Constant.GUI_MIN_LAYER, 5);
				break;
				/*
				case BTN_LEAGUE:
					btnLeague.SetDisable();
					LeagueMgr.getInstance().gotoLeague();
					//btnLeague.SetDisable();
				break;*/
				case BTN_EQUIPMENT:
					//var arrSolider:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
					//if (arrSolider != null && arrSolider.length > 0)
					//{
						//GuiMgr.getInstance().GuiChooseEquipment.Init(arrSolider[0]);
					//}
					//else
					//{
					if(Ultility.IsInMyFish())
					{
						GuiMgr.getInstance().GuiChooseEquipment.Init(null);
					}
					else 
					{
						GuiMgr.getInstance().GuiStoreEquipment.Init();
					}
					//}
					break;
				case BTN_ENCHANT:
					GuiMgr.getInstance().GuiEnchantEquipment.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case GUI_TOP_BTN_STATISTIC:
					GuiMgr.getInstance().GuiFishWarStatistics.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case GUI_TOP_BTN_LETTER:
					GameLogic.getInstance().user.NewMail = false;
					GameController.getInstance().UseTool("Letter");		
					break;
				case GUI_TOP_BTN_DAILYQUEST_NEW:
					// Hiển thị new dquest
					if (GuiMgr.getInstance().GuiDailyQuestNew.IsVisible == false)
					{
						GuiMgr.getInstance().GuiDailyQuestNew.Init(false);						
					}	
					else
					{
						// Hiển thị lại nội dung GUI
						GuiMgr.getInstance().GuiDailyQuestNew.refreshComponent();
					}
					break;
				case GUI_TOP_BTN_QUEST_PT:
					GuiMgr.getInstance().GuiQuestPowerTinh.Show(Constant.GUI_MIN_LAYER, 3);
					btnQuestPowerTinh.SetBlink(false);
					break;
				case GUI_TOP_BTN_GIFT:
					GameLogic.getInstance().user.NewGift = false;
					GameController.getInstance().UseTool("Gift");
					break;
				case GUI_TOP_BTN_SNAPSHOT:
					ActiveTooltip.getInstance().clearToolTip();
					if (img.stage.displayState == StageDisplayState.FULL_SCREEN)
						SetScreen();
					GuiMgr.getInstance().GuiSnapshot.Init();
					break;
				case GUI_TOP_BTN_MESSAGE:		
					GuiMgr.getInstance().GuiReplyLetter.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case GUI_TOP_BTN_LOG:		
					GuiMgr.getInstance().GuiLog.ShowLog(false);
					break;
				case GUI_TOP_BTN_ANNOUNCE:		
					GuiMgr.getInstance().GuiAnnounce.ShowAnnouce();
					break;	
				case GUI_TOP_BTN_SYSTEM_MAIL:
					GuiMgr.getInstance().GuiSystemMail.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case GUI_TOP_BTN_INPUT_CODE:
					GuiMgr.getInstance().GuiInputCode.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case GUI_TOP_BTN_DAILYBONUS:
					//if (GuiMgr.getInstance().GuiDailyBonus.IsVisible == false)
					//{
						GuiMgr.getInstance().GuiDailyBonus.Init();
					//}
					//else
					//{
						//GuiMgr.getInstance().GuiDailyBonus.refreshComponent();
					//}
					break;
				case GUI_TOP_BTN_DIGRITWHEEL:
					GuiMgr.getInstance().guiDigitWheel.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case GUI_TOP_BTN_EVENT:		
					//GuiMgr.getInstance().guiEventEuro.Show(Constant.GUI_MIN_LAYER, 3);
					//GameLogic.getInstance().user.machineMakeIceCream.MouseClick();
					GuiMgr.getInstance().guiTreasureIsLand.Show(Constant.GUI_MIN_LAYER, 5);
					//GuiMgr.getInstance().GuiGameTrungThu.Show(Constant.GUI_MIN_LAYER, 3);
					break;	
				case GUI_TOP_BTN_GET_GIFT_EVENT:	
					//var CheckGetGiftEvent:int = EventMgr.CheckGetGiftInEvent(NAME_CURRENT_IN_EVENT);
					//if (CheckGetGiftEvent == EventMgr.CURRENT_IN_EVENT)
					//{
						// Nếu là event mùng 8-3
						// GuiMgr.getInstance().GuiChangeFlower.init();
						// Kiểm tra xem một ngày 
						//GuiMgr.getInstance().GuiChangeGiftEvent.Show(Constant.GUI_MIN_LAYER, 1);
					//}
					GuiMgr.getInstance().guiChangeMedalVIP.Show(Constant.GUI_MIN_LAYER, 3);
					break;	
				case BTN_PEARL_REFINE:
						GuiMgr.getInstance().GuiGemRefine.Show(Constant.GUI_MIN_LAYER, 5);
						//GuiMgr.getInstance().GuiPearlRefine.ShowGui();
					break;
				//case GUI_TOP_BTN_GET_GIFT_EVENT:
					///*if(EventMgr.CheckEvent("InGameFishWar") == EventMgr.CURRENT_IN_EVENT || EventMgr.CheckEvent("InGameFishWar") == EventMgr.CURRENT_AFTER_EVENT)
					//{
						//GuiMgr.getInstance().guiGetEventGift.showGUI();
						//GuiMgr.getInstance().guiWarChampion.Show(Constant.GUI_MIN_LAYER, 6);
					//}
					//else
					//{
						//GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian diễn ra event.");	
						//buttonGetGiftEvent.SetVisible(false);
					//}*/
					//break;
				case BTN_OFFLINE_EXP:
					Exchange.GetInstance().Send(new SendSyncOfflineExp());
					GuiMgr.getInstance().guiOfflineExperience.Show(Constant.GUI_MIN_LAYER, 10);
					break;
				case GUI_TOP_BTN_GIFT_XMAS:
					//trace("gui gift xmas");
					//GuiMgr.getInstance().guiGiftXMas.Show(Constant.GUI_MIN_LAYER, 6);
					break;
				case BTN_COLLECTION:
					GuiMgr.getInstance().guiCollection.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_GET_COIN:
					GameLogic.getInstance().user.moneyMagnet.OnMouseClick(null);
					var useTimes:int = GameLogic.getInstance().user.moneyMagnet.useTimes;
					txtUseTime.text = "x" + useTimes.toString();
					break;
				case GUI_TOP_BTN_MAGICLAMP:
					//GuiMgr.getInstance().guiMagicLamp.Show(Constant.GUI_MIN_LAYER, 5);
					//btnMagicLamp.SetBlink(false);
					
				case BTN_FISHWARSUM:
				case CTN_FISHWARSUM:
					if (!isShowCtnFishWar)
					{
						ShowGui();
					}
					else
					{
						HideGui();
					}
				break;
				case ID_BTN_CHOOSE_SOLDIER:
					GuiMgr.getInstance().guiSelectSoldier.Show(Constant.GUI_MIN_LAYER, 3);
				break;
				default:
					var data:Array = buttonID.split("_");
					if (data[0] == BTN_SERIQUEST)
					{
						GameController.getInstance().UseTool("SeriesQuest_" + data[1]);
						ShowNotifyNewQuest(false);
					}
					break;
			}
		}
		
		public override function Fullscreen(IsFull:Boolean, dx:int = 0, dy:int = 0, scaleX:Number = 1, scaleY:Number = 1):void
		{			
			//super.Fullscreen(IsFull, dx, dy);
			if (IsFull)
			{
				LastX = img.x;
				LastY = img.y;
				var BgLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
				img.x = BgLayer.x// + dx;
				img.y = BgLayer.y;
				imgBackground.SetScaleX(scaleX);
			}
			else
			{
				img.x = LastX;
				img.y = LastY;
				imgBackground.SetScaleX(1);
			}			
			UpdateAllPos();
		}
		
		private function SetScreen():void 
		{
			if (Main.imgRoot.stage.displayState != StageDisplayState.FULL_SCREEN)
			{	
				img.stage.scaleMode = StageScaleMode.NO_SCALE;
				img.stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else
			{				
				img.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		public function getInviteBtnPos():int
		{
			if (btnQuestArr.length != 0)
			{
				var finalBtnQuest:Button = btnQuestArr[btnQuestArr.length - 1];
				return finalBtnQuest.img.y + finalBtnQuest.img.height + 5;
			}
			else
			{
				if (btnExQuestArr.length != 0)
				{
					var finalBtnExQuest:ButtonEx = btnExQuestArr[btnExQuestArr.length - 1];
					return finalBtnExQuest.img.y + finalBtnExQuest.img.height + 5;
				}
				else
				{
					return btnDigitWheel.img.y + btnDigitWheel.img.height + 5;
					return btnDailyBonus.img.y + btnDailyBonus.img.height + 5;
				}
			}
		}
		
		public function SuggestEnergyTooltip(iEnergy:int, iMaxEnergy:int):void
		{
			var ToolTip1:TooltipFormat = new TooltipFormat();
			var str:String;
			var szEnergy:String = Ultility.StandardNumber(iEnergy);
			var szMaxEnergy:String = Ultility.StandardNumber(iMaxEnergy);
			
			var strReplace:String = szEnergy + "/" + szMaxEnergy;
			str = Localization.getInstance().getString("Tooltip21");
			str = str.replace("@energy", strReplace);
			ToolTip1.text = str;
			
			var iEnterPos:int = str.search("\n");
			format = new TextFormat();
			format.align = "center";
			format.color = 0x000000;
			format.bold = false;
			format.size = 12;
			ToolTip1.autoSize = "center";
			ToolTip1.setTextFormat(format);
			format.bold = true;
			format.color = 0xFF0000;
			ToolTip1.setTextFormat(format, 0, iEnterPos);
			prgEnergy.setTooltip(ToolTip1);
			prgEnergy.setStatus(iEnergy / iMaxEnergy);
		}
				
		public function ShowFishWorld(type:int):void 
		{
			switch (type) 
			{
				case Constant.OCEAN_NEUTRALITY:
				
				break;
				//case 2:
				//
				//break;
			}
			if (imgFishWorld)
			{
				imgFishWorld.img.parent.removeChild(imgFishWorld.img);
				imgFishWorld = null;
			}
			//imgFishWorld = AddImage("", "ImgLogoOcean" + type, 440, 70);
			imgFishWorld = AddImage("", "ImgLogoOcean" + type, 630, 20);
			doGoToWorld();
		}
		
		/**
		 * Hàm thực hiện cập nhật trạng thái các component của GuiTop
		 * @param	isMyFish : = true nếu ở nhà, = false khi ra các đảo
		 */
		public function UpdateGuiForFishWorld(isMyFish:Boolean = true):void 
		{
			if (ctnFriend)
			{
				ctnFriend.img.visible = isMyFish;
			}
			// Hiepnm2 bỏ buff của hồ
			//if (ctnBuffExp)
			//{
				//ctnBuffExp.img.visible = isMyFish;
			//}
			//if (ctnBuffMoney)
			//{
				//ctnBuffMoney.img.visible = isMyFish;
			//}
			//if (ctnBuffTime)
			//{
				//ctnBuffTime.img.visible = isMyFish;
			//}
			/*if (ctnLevelSkill)
			{
				ctnLevelSkill.img.visible = isMyFish;
			}
			if (ctnMoneySkill)
			{
				ctnMoneySkill.img.visible = isMyFish;
			}
			if (ctnSpecialFishSkill)
			{
				ctnSpecialFishSkill.img.visible = isMyFish;
			}
			if (ctnRareFishSkill)
			{
				ctnRareFishSkill.img.visible = isMyFish;
			}*/
			
			//Các button
			if(btnSnapshot)	btnSnapshot.img.visible = isMyFish;
			if (btnSystemMail)
			{
				btnSystemMail.img.visible = isMyFish;
			}
			if (btnInputCode)
			{
				btnInputCode.img.visible = isMyFish;
			}
			//if (GuiMgr.getInstance().GuiMain.IsVisible && GuiMgr.getInstance().GuiMain.btnMapOcean)	
				//GuiMgr.getInstance().GuiMain.btnMapOcean.img.visible = isMyFish;
			if (GuiMgr.getInstance().GuiMain && GuiMgr.getInstance().GuiMain.IsVisible && GuiMgr.getInstance().GuiMain.btnExMapOcean)	
				GuiMgr.getInstance().GuiMain.btnExMapOcean.img.visible = isMyFish;
			if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible && GuiMgr.getInstance().GuiMainFishWorld.btnMapOcean)	
				GuiMgr.getInstance().GuiMainFishWorld.btnMapOcean.img.visible = !isMyFish;
			if(btnAnnounce)	btnAnnounce.img.visible = isMyFish;
			if(btnDailyBonus)	btnDailyBonus.img.visible = isMyFish;
			if (btnDigitWheel) btnDigitWheel.img.visible = isMyFish;
			if(btnDailyQuestNew)	btnDailyQuestNew.img.visible = isMyFish;
			if (btnEvent)	btnEvent.img.visible = isMyFish;
			//if (btnMagicLamp) btnMagicLamp.img.visible = isMyFish;
			if (imgPrgWishingPoint) imgPrgWishingPoint.img.visible = isMyFish;
			if (prgWishingPoint) prgWishingPoint.img.visible = isMyFish;
			if (txtWishingPoint) txtWishingPoint.visible = isMyFish;
			if (imgLevelWishingPoint) imgLevelWishingPoint.img.visible = isMyFish;
			if (btnGetGiftAfterEvent)	btnGetGiftAfterEvent.img.visible = isMyFish;
			//if (imgCombatCount)	imgCombatCount.img.visible = isMyFish;
			//if (txtCombatCount) txtCombatCount.visible = isMyFish;
			//if (buttonGetGiftEvent && EventMgr.CheckEvent("InGameFishWar") != EventMgr.CURRENT_NOT_EVENT)	buttonGetGiftEvent.img.visible = isMyFish;
			if (buttonGiftXmas) buttonGiftXmas.img.visible = isMyFish;
			//if (btnStatistics)	btnStatistics.SetVisible(isMyFish);
			if (btnQuestPowerTinh)	btnQuestPowerTinh.SetVisible(isMyFish);
			if (btnPearlRefine)	btnPearlRefine.img.visible = isMyFish;
			if (btnBlackMarket)	btnBlackMarket.img.visible = isMyFish;
			if (btnMeridian) btnMeridian.img.visible = isMyFish;
			if (btnTower) btnTower.SetVisible(isMyFish);
			//if (btnLeague) btnLeague.SetVisible(isMyFish);
			//if (tfRank) tfRank.visible = isMyFish;
			//if (imgNewBlackMarket) imgNewBlackMarket.img.visible = isMyFish;
			if (btnExQuestHelp)	btnExQuestHelp.img.visible = isMyFish;
			//if (imgNew) HideIconNew();
			var btn:Button = GetButton("BtnSeriQuest_7");
			if (btn && btn.img)
			{
				btn.SetVisible(isMyFish);
			}
			//if (btnCollection)	btnCollection.img.visible = isMyFish;
			//if (btnEquipment)	btnEquipment.img.visible = isMyFish;
			var iCount:int = 0;
			for (iCount = 0; iCount < btnExQuestArr.length; iCount++) 
			{
				btnExQuestArr[iCount].img.visible = isMyFish;
			}
			for (iCount = 0; iCount < btnQuestArr.length; iCount++) 
			{
				btnQuestArr[iCount].img.visible = isMyFish;
			}
			btnGift.img.visible = isMyFish;
			btnLeftMessage.img.visible = isMyFish;
			btnLetter.img.visible = isMyFish;
			btnLog.img.visible = isMyFish;
			prgFood.img.visible = isMyFish;
			prgFood.imgBg.visible = isMyFish;
			//if (!Ultility.CheckNewFeatureIcon(3))
			//{
				//btnEnchant.SetDisable();
			//}
			//else
			//{
				//btnEnchant.SetEnable();
			//}
			btnEnchant.SetEnable(isMyFish);
			
			//thức ăn
			if(imgFood)	imgFood.img.visible = isMyFish;
			
			//GuiMgr.getInstance().GuiChooseEquipment.GetImage(GUIChooseEquipment.ICON_NEW).img.visible = false;
			
			//if (imgNew)
			//{
				//imgNew.img.visible = false;
			//}
			// Nút quà tặng hàng ngày
			if(GameLogic.getInstance().user.dailyBonus && GameLogic.getInstance().user.dailyBonus.img)
			{
				GameLogic.getInstance().user.dailyBonus.img.visible = isMyFish;
			}
			
			// Avatar
			//if (!isMyFish)
			//{
				//GuiMgr.getInstance().GuiCharacter.Hide();
			//}
			//else 
			//{
				//GuiMgr.getInstance().GuiCharacter.Show();;
			//}
			
			// Ảnh
			imgAvatar.img.visible = isMyFish;
			imgAvatarWorld.img.visible = !isMyFish;
			userName.visible = isMyFish
			avatar.img.visible = isMyFish;
			imgEnergy.img.visible = !isMyFish;
			
			if (isMyFish)
			{
				imgEnergy.img.x = 365;
			}
			else 
			{
				imgEnergy.img.x = 385;
				imgSnapshotMonday.img.x -= 330;
				imgSnapshotMonday.img.y += 45;
			}
			
			btnGetCoin.SetVisible(isMyFish);
			txtUseTime.visible = isMyFish;
			
			//icon thứ 2 vui vẻ
			//if (imgSnapshotMonday) {
				//imgSnapshotMonday.img.visible = isMyFish;
			//}
			
			if (imgDailyQuestMonday) {
				imgDailyQuestMonday.img.visible = isMyFish;
			}
			if (imgAvatarMonday) {
				imgAvatarMonday.img.visible = isMyFish;
			}
		}
		/**
		 * Khi ở thế giới cá trở về myFish
		 */
		public function ShowMyHome():void 
		{
			if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	GuiMgr.getInstance().GuiInfoWarInWorld.Hide();
			if (imgFishWorld && imgFishWorld.img)	imgFishWorld.img.visible = false;
			//GameController.getInstance().PanScreenX( -(Constant.MAX_WIDTH - Constant.STAGE_WIDTH) / 2);
			txtCooldown.x = 20;
			txtCooldown.y = 144;
			txtEnergy.x = 9;
			txtEnergy.y = 122;
			//prgEnergy.img.width = 56;
			//prgEnergy.imgBg.width = 59;
			prgEnergy.scaleX = 1;
			prgEnergy.x = 9;
			prgEnergy.y = 125;
			
			btnFishWarSum.SetPos(102, 78);
			//if (imgNew)
			//{
				//imgNew.SetPos(btnFishWarSum.img.x + 8, btnFishWarSum.img.y + 33);
			//}
			FishWarCtn.SetPos(btnFishWarSum.img.x + btnFishWarSum.img.width - FishWarCtn.img.width - 10, btnFishWarSum.img.y + 2);
			MaskClip.x = btnFishWarSum.img.x + btnFishWarSum.img.width - 10;
			MaskClip.y = btnFishWarSum.img.y - 60;
			showPos = new Point(MaskClip.xn - 34, btnFishWarSum.img.y + 2);
			hidePos = new Point(FishWarCtn.img.x, FishWarCtn.img.y);
			
			UpdateGuiForFishWorld();
			
			if (imgSnapshot && GuiMgr.getInstance().GuiSnapshot.GetTypeBg() != "")	imgSnapshot.img.visible = true;
			if (btnExQuestHelp && QuestMgr.getInstance().SeriesQuest && QuestMgr.getInstance().SeriesQuest.length > 0)	
				btnExQuestHelp.img.visible = true;
		}
		/**
		 * Đi ra thế giới cá
		 */
		private function doGoToWorld():void 
		{
			txtEnergy.x = 410;
			txtEnergy.y = 7;
			txtCooldown.x = 400;
			txtCooldown.y = 29;
			//prgEnergy.img.width = 138;
			//prgEnergy.imgBg.width = 140;
			prgEnergy.scaleX = 1.35;
			prgEnergy.x = 425;
			prgEnergy.y = 10;
			
			btnFishWarSum.SetPos(10, 38);
			FishWarCtn.SetPos(btnFishWarSum.img.x + btnFishWarSum.img.width - FishWarCtn.img.width - 10, btnFishWarSum.img.y + 2);
			MaskClip.x = btnFishWarSum.img.x + btnFishWarSum.img.width - 10;
			MaskClip.y = btnFishWarSum.img.y - 60;
			showPos = new Point(MaskClip.x - 4, btnFishWarSum.img.y + 2);
			hidePos = new Point(FishWarCtn.img.x, FishWarCtn.img.y);
			
			UpdateGuiForFishWorld(false);
			
			if (imgSnapshot)	imgSnapshot.img.visible = false;
			if (btnExQuestHelp && btnExQuestHelp.img)	btnExQuestHelp.img.visible = false;
			
			// Bỏ các số ở DailyQuest
			showDailyQuestTask( -1);
			
			// Phần trăm trên thanh prgFood bị xóa
			txtFoodPercent.text = "";
		}
		
		public function UpdateAllPos():void
		{
			trace(btnLock.img.x, imgBackground.img.width);
			btnLock.img.x = imgBackground.img.width - 72;
			btnUnlock.img.x = imgBackground.img.width - 72;
			imgAvatar.img.y = -2;
			imgAvatarWorld.img.y = -2;
			imgAvatar.img.x = imgBackground.img.x - 5;
			imgAvatarMonday.img.x = imgAvatar.img.x + 10;//happy monday
			imgAvatarMonday.img.y = imgAvatar.img.y + 80;
			imgAvatarWorld.img.x = imgBackground.img.x - 2;
			avatar.img.x = imgAvatar.img.x + 42;
			userName.x = imgAvatar.img.x;
			userName.y = imgAvatar.img.y + imgAvatar.img.height -50;
			prgEXP.x = imgAvatar.img.x + 44;
			prgEXP.y = imgAvatar.img.y + 13;
			effExp.x = prgEXP.x + 41;
			imgEXP.img.x = imgAvatar.img.x + 8;
			imgEXP.img.y = imgAvatar.img.y + 3;
			txtLevel.x = imgEXP.img.x - 32;
			
			imgGold.x = imgEXP.img.x + 125;
			//imgGold.x = imgBackground.img.width / 2 - 275;
			//imgGold.x = imgAvatar.img.x + 153;
			txtMoney.x = imgGold.x + 23;
			imgZXu.x = imgGold.x + 122;
			txtZMoney.x = imgZXu.x + 23;

			//Thong tin buff
			//ctnBuffExp.img.x = imgEnergy.img.x + 116;
			//ctnBuffExp.img.x = imgZXu.x + 190;
			// hiepnm2 bỏ buff của hồ
			//ctnBuffExp.img.x = imgBackground.img.width - 370;
			//ctnBuffMoney.img.x = ctnBuffExp.img.x + 65;
			//ctnBuffTime.img.x = ctnBuffMoney.img.x + 65;
			//ctnBuffExp.img.y = imgFood.img.y + 3;
			//ctnBuffMoney.img.y = imgFood.img.y + 3;
			//ctnBuffTime.img.y = imgFood.img.y + 3;
			
			//Thông tin skill lai
			/*ctnMoneySkill.img.x = imgBackground.img.width - 45;
			ctnLevelSkill.img.x = imgBackground.img.width - 45;
			ctnRareFishSkill.img.x = imgBackground.img.width - 45;
			ctnSpecialFishSkill.img.x = imgBackground.img.width - 45;*/
			
			btnBlackMarket.img.x = imgBackground.img.width - 55;
			btnMeridian.img.x = imgBackground.img.width - 40;
			//imgNewBlackMarket.img.x = imgBackground.img.width - 66;
			btnGetCoin.img.x = imgBackground.img.width - 55;
			
			btnTower.img.x = imgBackground.img.width - 40;
			/*
			btnLeague.img.x = imgBackground.img.width - 50;
			tfRank.x = 763;
			tfRank.y = 410;*/
			//imgFood.img.x = imgBackground.img.width / 2 - (405 - 422);
			//imgFood.img.x = ctnBuffTime.img.x + 75;
			imgFood.img.x = 1647;	//hiepnm2 bỏ thanh thức ăn
			//imgFood.img.x = imgZXu.x + 395;
			prgFood.x = imgFood.img.x + 33;
			txtFoodPercent.x = imgFood.img.x + 23;
			//imgEnergy.img.x = imgFood.img.x + 115;
			//prgEnergy.x = imgEnergy.img.x + 31;
			//txtCooldown.x = imgEnergy.img.x + 25;
			//txtEnergy.x = imgEnergy.img.x + 21;
			//imgEnergy.img.x = 20;
			prgEnergy.x = 31;
			txtCooldown.x = 20;
			txtEnergy.x = 9;
			
			btnLeftMessage.SetVisible(false);
			btnLetter.SetVisible(false);
			btnGift.SetVisible(false);
			
			// Button ngu chien ----------	longpt
			btnFishWarSum.SetVisible(false);
			btnTower.SetVisible(false);
			//btnMeridian.SetVisible(false);
			//btnLeague.SetVisible(false);
			//tfRank.visible = false;
			// Button quest tinh luc
			btnQuestPowerTinh.SetVisible(false);
			
			MaskClip.x = btnFishWarSum.img.x + btnFishWarSum.img.width - 10;
			MaskClip.y = btnFishWarSum.img.y - 60;
			FishWarCtn.img.x = btnFishWarSum.img.x + btnFishWarSum.img.width - FishWarCtn.img.width - 10;
			FishWarCtn.img.y = btnFishWarSum.img.y + 2;
			//showPos = new Point(MaskClip.x - 34, btnFishWarSum.img.y + 2);
			showPos = new Point(MaskClip.x - 4, btnFishWarSum.img.y + 2);
			hidePos = new Point(FishWarCtn.img.x, FishWarCtn.img.y);
			// ---------------------------
			
			//btnGift.SetBlink(false);
			//btnDailyQuest.SetVisible(false);
			//btnEvent.SetVisible(false);
			//btnMagicLamp.SetVisible(false);
			//imgPrgWishingPoint.img.visible = false;
			//prgWishingPoint.setVisible(false);
			//txtWishingPoint.visible = false;
			//imgLevelWishingPoint.img.visible = false;
			
			btnGetGiftAfterEvent.SetVisible(false);
			btnLog.SetVisible(false);
			btnLog.SetBlink(false);
			btnDailyQuestNew.SetVisible(false);
			btnQuestPowerTinh.SetVisible(false);
			btnDailyQuestNew.SetBlink(false);
			btnDailyBonus.SetVisible(false);
			//btnDigitWheel.SetVisible(false);
			btnSnapshot.SetVisible(false);
			imgSnapshot.img.visible = false;
			btnSystemMail.SetVisible(false);
			btnInputCode.SetVisible(false);
			
			//btnEvent.SetVisible(false);
			//imgCombatCount.img.visible = false;
			//txtCombatCount.visible = false;
			btnPearlRefine.SetVisible(false);

			imgSnapshotMonday.SetVisible(false);//happy Monday
			imgDailyQuestMonday.SetVisible(false);
			//imgAvatarMonday.SetVisible(false);
			
			if (user.IsViewer())
			{
				btnLeftMessage.SetVisible(true);
				btnLeftMessage.img.x = imgAvatar.img.x + 128;
				btnAnnounce.img.x = btnLeftMessage.img.x + 51;
				
				//btnStatistics.img.x = btnAnnounce.img.x + 45;
				//btnStatistics.img.y = btnLeftMessage.img.y;
				
				showDailyQuestTask( -1);
				if (btnExQuestHelp)	btnExQuestHelp.SetVisible(false);
				//btnMapOcean.SetVisible(false);
				//btnMapOcean.SetVisible(false);
				//buttonOfflineExp.SetVisible(false);
				//btnEvent.SetVisible(false);
				//btnMagicLamp.SetVisible(false);
				//imgPrgWishingPoint.img.visible = false;
				//prgWishingPoint.setVisible(false);
				//txtWishingPoint.visible = false;
				//imgLevelWishingPoint.img.visible = false;
				btnGetGiftAfterEvent.SetVisible(false);
				btnLock.SetVisible(false);
				btnUnlock.SetVisible(false);
			}
			else
			{	
				updateBtnLock();
				//btnEvent.SetVisible(true);
				//btnMagicLamp.SetVisible(true);
				//imgPrgWishingPoint.img.visible = true;
				//prgWishingPoint.setVisible(true);
				//txtWishingPoint.visible = true;
				//imgLevelWishingPoint.img.visible = true;
				btnGetGiftAfterEvent.SetVisible(true);
				btnSnapshot.SetVisible(true);
				if (MailMgr.getInstance().isShowButtonMail())
				{
					btnSystemMail.SetVisible(true);
				}
				//btnSystemMail.SetVisible(true);
				btnInputCode.SetVisible(true);
				
				var maxSnap:int = ConfigJSON.getInstance().GetItemList("Param")["MaxTimesTakePicture"];
				if (!Ultility.CheckDate(user.GetMyInfo().LastPictureTime))
				{
					user.GetMyInfo().NumTakePictureTime = 0;
				}
				if(user.GetMyInfo().NumTakePictureTime < maxSnap)
				{
					imgSnapshot.img.visible = true;
				}
				btnLetter.SetVisible(true);
				btnGift.SetVisible(true);
				if (GameLogic.getInstance().user.GetLevel() >= 7)
				{
					btnTower.SetVisible(true);
					//btnMeridian.SetVisible(true);
					btnFishWarSum.SetVisible(true);
					btnQuestPowerTinh.SetVisible(true);
					//btnLeague.SetVisible(true);
					//tfRank.visible = true;
				}
				//btnDailyQuest.SetVisible(true);
				btnLog.SetVisible(true);				
				//btnGift.img.x = imgBackground.img.width / 2 - (405 - 115);
				btnGift.img.x = imgAvatar.img.x + imgAvatar.img.width ;
				btnLetter.img.x = btnGift.img.x + 45;
				btnDailyQuestNew.img.x = btnLetter.img.x + 45;
				imgDailyQuestMonday.img.x = btnDailyQuestNew.img.x - 10;
				imgDailyQuestMonday.img.y = btnDailyQuestNew.img.y + 4;
				
				btnLog.img.x = btnDailyQuestNew.img.x + 40;
				btnAnnounce.img.x = btnLog.img.x + 45;			
				
				btnSnapshot.img.x = btnAnnounce.img.x + 40;
				btnSnapshot.img.y = btnAnnounce.img.y - 17;
				imgSnapshotMonday.img.x = btnSnapshot.img.x;
				imgSnapshotMonday.img.y = btnSnapshot.img.y;
				
				//btnStatistics.img.x = btnGift.img.x - 2;
				//btnStatistics.img.y = btnGift.img.y + 23;
				
				btnQuestPowerTinh.img.x = btnGift.img.x - 2;
				btnQuestPowerTinh.img.y = btnGift.img.y + 40;
				
				btnFishWarSum.img.x = btnQuestPowerTinh.img.x + 35;
				btnFishWarSum.img.y = btnQuestPowerTinh.img.y - 23;
				
				btnInputCode.img.x = btnSnapshot.img.x + 58;
				btnInputCode.img.y = btnSnapshot.img.y + 8;
				
				btnSystemMail.img.x = btnInputCode.img.x + 46;
				btnSystemMail.img.y = btnInputCode.img.y + 11;
				
				btnDailyQuestNew.SetVisible(true);
				btnDailyBonus.SetVisible(true);
				btnPearlRefine.SetVisible(true);
				suggestShowIconHappyMonday();
			}
			ctnFriend.img.x = imgBackground.img.width - 170;
			ctnFriend.img.y = 34;
			
			if (ctnMoneyAttacked)
			{
				ctnMoneyAttacked.img.x = ctnFriend.img.x + 10;
				ctnMoneyAttacked.img.y = ctnFriend.img.y + 130;
			}
			
			var count:int = 0;
			var posYBtnEvent:int;
			if (btnEvent != null)	posYBtnEvent = btnEvent.img.y + btnEvent.img.height + 25;
			var i:int = 0;
			for (i = 0; i < btnExQuestArr.length; i++)
			{
				var btnExQuest:ButtonEx = btnExQuestArr[i];
				btnExQuest.img.x = (imgBackground.img.x + 22);
				if (btnEvent != null && btnExQuest.img.visible)
				{
					btnExQuest.img.y = posYBtnEvent;
					posYBtnEvent += (btnExQuest.img.height + 5);
				}
				if (btnExQuest.img.visible)
				{
					count++;
				}
			}
			
			for (i = 0; i < btnQuestArr.length; i++)
			{
				var btnQuest:Button = btnQuestArr[i];
				btnQuest.img.x = (imgBackground.img.x + 10);
				if (btnEvent != null)
				{
					btnQuest.img.y = posYBtnEvent;
					posYBtnEvent += (btnQuest.img.height + 5);
				}
			}
			
			if (btnEvent != null)
			{
				btnEvent.img.x = imgBackground.img.x + 10;
				//btnChangeMedal.img.x = imgBackground.img.x + 10;
				//btnEvent.img.y = 265;
			}
			
			if (btnMoiban)
			{
				if(btnMoiban.img)
					btnMoiban.img.y = getInviteBtnPos();
			}
		}
		
		public function getPosYMaxBtnEvent():int 
		{
			var posY:int = 0;
			var i:int = 0;
			for (i = 0; i < btnExQuestArr.length; i++)
			{
				var btnExQuest:ButtonEx = btnExQuestArr[i];
				if (btnExQuest.img.visible)
				{
					if (posY < btnExQuest.img.y + 10)
					{
						posY = btnExQuest.img.y + btnExQuest.img.height + 10;
					}
				}
			}
			for (i = 0; i < btnQuestArr.length; i++)
			{
				var btnQuest:Button = btnQuestArr[i];
				if (btnQuest.img.visible)
				{
					if (posY < btnQuest.img.y + 10)
					{
						posY = btnQuest.img.y + btnQuest.img.height + 10;
					}
				}
			}
			if (posY < btnEvent.img.y)
			{
				posY = btnEvent.img.y
			}
			return posY;
		}
		
		public function DrawIconNew():void
		{
			FishWarCtn.AddImage("", "IcNew", btnEnchant.img.x + btnEnchant.img.width, btnEnchant.img.y);
			imgNew = AddImage("", "IcNew", btnFishWarSum.img.x + 8, btnFishWarSum.img.y + 33);
			imgNew.img.rotation = -45;
		}
		
		public function HideIconNew():void
		{
			if (imgNew && imgNew.img.visible)
			{
				img.removeChild(imgNew.img);
				imgNew = null;
			}
		}
		public function addHappyMondyIcon():void
		{
			imgSnapshotMonday = AddButtonEx(ID_ICON_HAPPYMONDAY, "IconHappyMonday", 0, 0);
			imgDailyQuestMonday = AddButtonEx(ID_ICON_HAPPYMONDAY, "IconHappyMonday", 0, 0);
			imgAvatarMonday = AddButtonEx(ID_ICON_HAPPYMONDAY, "IconHappyMonday", 0, 0);
			
			imgSnapshotMonday.SetScaleXY(0.5);
			imgDailyQuestMonday.SetScaleXY(0.5);
			imgAvatarMonday.SetScaleXY(0.6);
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
			imgSnapshotMonday.setTooltip(tip);
			imgDailyQuestMonday.setTooltip(tip);
			imgAvatarMonday.setTooltip(tip);
			suggestShowIconHappyMonday();
		}
		
		public function suggestShowIconHappyMonday():void
		{
			if (GameLogic.getInstance().isMonday())
			{
				imgSnapshotMonday.img.visible = true;
				imgDailyQuestMonday.img.visible = true;
				imgAvatarMonday.img.visible = true;
			}
			else
			{
				imgSnapshotMonday.img.visible = false;
				imgDailyQuestMonday.img.visible = false;
				imgAvatarMonday.img.visible = false;
			}
		}
		
		public function updateBtnLock():void
		{
			if (GameLogic.getInstance().user.Level >= 7 &&
				LeagueController.getInstance().mode == LeagueController.IN_HOME)
			{
				switch(GameLogic.getInstance().user.passwordState)
				{
					case Constant.PW_STATE_NO_PASSWORD:
					case Constant.PW_STATE_IS_UNLOCK:
					case Constant.PW_STATE_UNAVAILABLE:
						btnLock.SetVisible(false);
						btnUnlock.SetVisible(true);
						break;
					case Constant.PW_STATE_IS_CRACKING:
					case Constant.PW_STATE_IS_LOCK:
					case Constant.PW_STATE_IS_BLOCKED:
						btnLock.SetVisible(true);
						btnUnlock.SetVisible(false);
						break;
				}
			}
			else
			{
				btnLock.SetVisible(false);
				btnUnlock.SetVisible(false);
			}
		}
		
		public function checkTournamentRegister():Boolean 
		{			
			if ((int)(Main.verTournament) <= 0)
			{
				return false;
			}
			
			var hourActiveArr:Array = new Array(7, 11, 16, 20);
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
	}

}