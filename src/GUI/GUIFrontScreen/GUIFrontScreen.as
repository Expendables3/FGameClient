package GUI.GUIFrontScreen 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventMgr;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.AvatarImage;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import GUI.FirstPay.GiftPayBag;
	import GUI.FishWorld.BossMgr;
	import GUI.FishWorld.Network.SendLoadOcean;
	import GUI.GuiMgr;
	import GUI.Mail.SystemMail.Controller.MailMgr;
	import GUI.SpecialSmithy.SendGetHammerMan;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.QuestInfo;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import Logic.User;
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIFrontScreen extends BaseGUI
	{
		static public const BTN_BLACK_MARKET:String = "btnBlackMarket";
		static public const BTN_STORE_EQUIP:String = "btnStoreEquip";
		static public const BTN_TRAINING_TOWER:String = "btnTrainingTower";
		static public const BTN_MERIDIAN:String = "btnMeridian";
		static public const BTN_COLLECTION:String = "btnCollection";
		static public const BTN_GEM:String = "btnGem";
		static public const BTN_ENCHANT_EQUIP:String = "btnEnchantEquip";
		static public const BTN_CREATE_EQUIP:String = "btnCreateEquip";
		static public const BTN_SMITHY:String = "btnSmithy";
		static public const BTN_FRIEND_GIFT:String = "btnFriendGift";
		static public const BTN_MAIL:String = "btnMail";
		static public const BTN_DIARY:String = "btnDiary";
		static public const BTN_ANNOUCEMENT:String = "btnAnnoucement";
		static public const BTN_CAMERA:String = "btnCamera";
		static public const BTN_FISH_WORLD:String = "btnFishWorld";
		static public const BTN_TOURNAMENT:String = "btnTournament";
		static public const BTN_SERRIES_FIGHTING:String = "btnSerriesFighting";
		static public const BTN_DAILY_GIFT:String = "btnDailyGift";
		static public const BTN_DAILY_QUEST:String = "btnDailyQuest";
		static public const BTN_SPIRIT_QUEST:String = "btnSpiritQuest";
		static public const BTN_MAIN_QUEST:String = "btnSeriquest";
		static public const BTN_INPUT_CODE:String = "btnInputCode";
		static public const BTN_PASSWORD:String = "btnPassword";
		static public const BTN_GET_COIN:String = "btnGetCoin";
		static public const BTN_FRIEND_MAIL:String = "btnFriendMail";
		static public const BTN_EVENT:String = "btnEvent";
		static public const BTN_EVENT_PLAY:String = "btnEventPlay";
		static public const GUI_TOP_BTN_GET_GIFT_EVENT:String = "guiTopBtnGetGiftEvent";
		static public const LEFT_CORNER_BG:String = "leftCornerBg";
		static public const HORIZONTAL_BG:String = "horizontalBg";
		static public const RIGHT_CORNER_BG:String = "rightCornerBg";
		static public const VERTICAL_BG:String = "verticalBg";
		static public const BOTTOM_CORNER_BG:String = "bottomCornerBg";
		static public const TOP_CORNER_BG:String = "topCornerBg";
		static public const IC_NEW:String = "icNew";
		static public const BTN_BOSS_SERVER:String = "btnBossServer";
		static public const BTN_SYSTEM_MAIL:String = "btnSystemMail";
		static public const BTN_EXPEDITION_QUEST:String = "btnExpeditionQuest";
		static public const BTN_REPUTATION:String = "btnReputation";
		static public const ID_BTN_NAP_THE:String = "idBtnNapThe";
		//ThanhNT2 Add
		static public const BTN_TRUNG_LINH_THACH:String = "BtnTrungLinhThach";
		static public const BTN_TRUNK_VIP:String = "btnTrunkVip";
		static public const BTN_UPGRADE_EQUIP:String = "btnUpgradeEquip";
		//static public const BTN_LINK_OHFISH:String = "btnLinkOhFish";
		
		//static public const NAME_BTN_EVENT:String = "BtnEventNoel";	//Bắn cá
		//static public const NAME_BTN_EVENT:String = "BtnEventFlowerMidle8"; //Mê cung
		//static public const NAME_BTN_EVENT:String = "BtnTreasureIslandEvent"; //Đào vàng
		static public const NAME_BTN_EVENT:String = "EventHalloween_BtnIconEvent"; //Thạch bảo đồ
		//static public const NAME_BTN_AFTER_EVENT:String = "BtnTreasureIslandChangeMedal"; //"BtnGetGiftAfterEventFlowerMidle8"; "EventHalloween_BtnChangeMedal";
		
		static public const TOOLTIP_EVENT:String = "Thạch bảo đồ";
		//static public const TOOLTIP_EVENT:String = "Đảo giấu vàng";
		//static public const TOOLTIP_EVENT:String = "Mê cung đá";
		
		public var isSendLoadOcean:Boolean = false;
		public var btnDailyQuest:ButtonEx;
		public var btnExpeditionQuest:ButtonEx;
		public var btnTrainingTower:ButtonEx;
		public var btnMail:ButtonEx;
		public var btnSpiritPowerQuest:ButtonEx;
		public var btnSeriesFighting:ButtonEx;
		public var btnFriendGift:ButtonEx;
		private var ctnTop:Container;
		private var btnLock:Button;
		private var btnUnlock:Button;
		public var txtEnergy:TextField;
		public var btnGetCoin:Button;
		public var txtUseTime:TextField;
		public var imgSnapshot:Image;
		public var btnFishWorld:ButtonEx;
		public var btnEvent:Button;
		public var btnEventPlay:Button;
		public var btnGiftEvent:Button;
		public var btnTournament:ButtonEx;
		public var btnReputation:ButtonEx;
		private var btnGem:ButtonEx;
		private var prgEnergy:ProgressBar;
		private var ctnAvatar:Container;
		private var ctnFriend:Container;
		private var ctnTitle:Container;
		private var txtTitle:TextField;
		private var isShowTitle:Boolean = true;
		private var mask:Sprite;
		private var ctnTopRight:Container;
		private var ctnBottomRight:Container;
		private var ctnLeft:Container;
		private var avatar:AvatarImage;
		private var friendAvatar:Image;
		private var labelUserName:TextField;
		private var labelFriendExp:TextField;
		private var labelFriendLevel:TextField;
		private var labelFriendMoney:TextField;
		private var labelFriendName:TextField;
		private var prgExp:ProgressBar;
		private var ctnFriendBtn:Container;
		private var imgNumDailyQuest:Image;
		private var startTimeEvent:Number = 0;
		private var endTimeEvent:Number = 0;
		private var btnNameEvent:String;
		private var tipMessageEvent:String;
		public var labelSeriesFighting:TextField;
		private var startLevelEvent:int;
		private var ctnHappyMonday:Container;
		private var arrowTournament:Image;
		private var imgQuestNotification:Image;
		private var btnCollection:ButtonEx;
		private var btnEnchant:ButtonEx;
		private var btnCreate:ButtonEx;
		private var btnSmithy:ButtonEx;
		private var btnMainQuest:ButtonEx;
		private var arrBtnTop:Array;
		private var arrBtnTopRight:Array;
		private var arrBtnBottomRight:Array;
		private var arrBtnLeft:Array;
		private var arrBtnFriend:Array;
		private var labelTimeBossServer:TextField;
		private var giftPay:GiftPayBag;
		private var btnSystemMail:ButtonEx;
		private var helperBossServer:Image;
		private var btnNapThe:ButtonEx;
		//ThanhNT2 Add
		private var ctnBook:Container;
		private var arrBtnBook:Array;
		public var BtnTrungLinhThach:ButtonEx; 
		
		public function GUIFrontScreen(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("");
			SetPos(0, 0);
			
			//Avatar user
			ctnAvatar = AddContainer("", "MyAvatar_Bg", 16, 25);
			avatar = new AvatarImage(ctnAvatar.img, "", 22, 13, false, ALIGN_LEFT_TOP);
			labelUserName = ctnAvatar.AddLabel("", - 18, 80, 0xffffff, 1, 0x000000);
			var txtFormat:TextFormat = new TextFormat("arial", 13, 0xffffff, true);
			txtFormat.align = "center";
			labelUserName.wordWrap = true;
			labelUserName.width = 130;
			labelUserName.defaultTextFormat = txtFormat;
			labelUserName.setTextFormat(txtFormat);
			
			//Ctn Friend
			ctnFriend = AddContainer("", "ImgAvatarFriend", 639, 25, true, this);
			ctnFriend.AddImage("", "ImgAvatarFriend", 0, 0, true, ALIGN_LEFT_TOP);
			friendAvatar = ctnFriend.AddImage("", "", 37, 43, false, ALIGN_LEFT_TOP);
			prgExp = ctnFriend.AddProgress("", "PrgEXP", 42, 13, this, true);			
			txtFormat.size = 14;
			txtFormat.color = 0xFFFFFF;
			labelFriendExp = ctnFriend.AddLabel("", 33, 10, 0xFFFFFF, 1, 0x26709C);
			labelFriendExp.defaultTextFormat = txtFormat;
			var imgExp:Image = ctnFriend.AddImage("", "ImgEXP", 4, 4, true, ALIGN_LEFT_TOP);
			txtFormat.color = 0xFFFF00;
			labelFriendLevel = ctnFriend.AddLabel("", -29, 12, 0, 1, 0x26709C);
			labelFriendLevel.wordWrap = true;
			labelFriendLevel.defaultTextFormat = txtFormat;
			txtFormat.size = 11;
			txtFormat.color = 0xFFFFFF;
			var IconGold:Image = ctnFriend.AddImage("", "IcGold", 29, 100, true, ALIGN_LEFT_TOP);
			IconGold.SetScaleX(0.6);
			IconGold.SetScaleY(0.6);
			labelFriendMoney = ctnFriend.AddLabel("", 47, 98, 0, 0, 0x26709C);
			labelFriendMoney.defaultTextFormat = txtFormat;
			labelFriendName = ctnFriend.AddLabel("", 13, 115, 0xffffff, 1, 0x000000);
			labelFriendName.defaultTextFormat = txtFormat;	
			ctnFriend.SetVisible(false);
			ctnFriendBtn = AddContainer("", "", 120, 40);
			ctnFriendBtn.LoadRes("");
			ctnFriendBtn.AddImage(LEFT_CORNER_BG, "LeftCornerBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnFriendBtn.AddImage(HORIZONTAL_BG, "HorizontalBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnFriendBtn.AddImage(RIGHT_CORNER_BG, "RightCornerBg", 48, 0, true, ALIGN_LEFT_TOP);
			arrBtnFriend = new Array();
			addBtnEx(ctnFriendBtn, arrBtnFriend, true, "BtnMeridian", BTN_MERIDIAN, "Ngư mạch");
			addBtnEx(ctnFriendBtn, arrBtnFriend, true, "BtnWriteLetter", BTN_FRIEND_MAIL, "Ngư mạch");
			ctnFriendBtn.SetVisible(false);
			
			//Cac btn rieng
			AddButtonEx(BTN_INPUT_CODE, "BtnCode", 750 + 11, 10).setTooltipText("Nạp Code");
			btnLock = AddButton(BTN_PASSWORD, "Btn_Lock", 700 - 25, 10);
			btnLock.SetVisible(false);
			btnUnlock = AddButton(BTN_PASSWORD, "Btn_Unlock", 700 - 25, 10);
			btnUnlock.SetVisible(false);
			btnGetCoin = AddButton(BTN_GET_COIN, "Btn_Get_Coin", 708, 120 + 48, this);
			btnGetCoin.setTooltipText("Nam châm hút tiền");
			txtUseTime = AddLabel("x0", 608, 186, 0x000000, 2, 0xffffff);
			btnSystemMail = AddButtonEx(BTN_SYSTEM_MAIL, "BtnSystemMail", 640, 27, this);
			btnSystemMail.SetVisible(false);
			labelTimeBossServer = AddLabel("", 692-158 + 35, 30+62, 0xffffff, 1, 0x000000);
			AddButtonEx(BTN_BOSS_SERVER, "BtnBossServer", 692-171 + 15 + 35 + 33, 72+14 - 40).setTooltipText("Bảo Vệ Thủy Cung");
			helperBossServer = AddImage("", "IcHelper", 692 - 171 + 15 + 43 + 56, 72 + 49);
			helperBossServer.img.rotation = -180;
			helperBossServer.img.visible = false;
			
			//Btn Top
			ctnTop = AddContainer("", "", 160 - 25, 40);
			ctnTop.LoadRes("");
			ctnTop.AddImage(LEFT_CORNER_BG, "LeftCornerBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnTop.AddImage(HORIZONTAL_BG, "HorizontalBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnTop.AddImage(RIGHT_CORNER_BG, "RightCornerBg", 48, 0, true, ALIGN_LEFT_TOP);
			arrBtnTop = new Array();
			addBtnEx(ctnTop, arrBtnTop, true, "BtnStoreEquipment", BTN_STORE_EQUIP, "Kho trang bị", "BtnEquipmentStore");
			btnTrainingTower = addBtnEx(ctnTop, arrBtnTop, true, "BtnTrainingTower", BTN_TRAINING_TOWER, "Tháp tu luyện", "BtnTrainingTower");
			btnTrainingTower.SetBlink(false);
			addBtnEx(ctnTop, arrBtnTop, true, "BtnMeridian", BTN_MERIDIAN, "Ngư mạch", "BtnMeridian");
			btnCollection = addBtnEx(ctnTop, arrBtnTop, true, "BtnCollection", BTN_COLLECTION, "Bộ sưu tập", "BtnCollection");
			btnGem = addBtnEx(ctnTop, arrBtnTop, true, "BtnGem", BTN_GEM, "Tu luyện đan", "BtnRefinePearl");
			btnEnchant = addBtnEx(ctnTop, arrBtnTop, true, "BtnEnchantEquipment", BTN_ENCHANT_EQUIP, "Cường hóa trang bị", "BtnEnchantEquip");
			btnSmithy = addBtnEx(ctnTop, arrBtnTop, true, "BtnSpecialSmithy", BTN_SMITHY, "Thợ rèn thần bí", "BtnSpecialSmithy");
			addBtnEx(ctnTop, arrBtnTop, true, "BtnMarket", BTN_BLACK_MARKET, "Chợ đen");
			BtnTrungLinhThach = addBtnEx(ctnTop, arrBtnTop, true, "BtnTrungLinhThach", BTN_TRUNG_LINH_THACH, "Trứng huy hiệu", "BtnTrungLinhThach", true);
			BtnTrungLinhThach.SetBlink(false);
			
			//ThanhNT2
			/*ctnBook = AddContainer("", "", 750, 440);
			ctnBook.LoadRes("");
			ctnBook.AddImage(LEFT_CORNER_BG, "LeftCornerBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnBook.AddImage(HORIZONTAL_BG, "HorizontalBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnBook.AddImage(RIGHT_CORNER_BG, "RightCornerBg", 48, 0, true, ALIGN_LEFT_TOP);
			arrBtnBook = new Array();
			BtnTrungLinhThach = addBtnEx(ctnBook, arrBtnBook, true, "BtnTrungLinhThach", BTN_TRUNG_LINH_THACH, "Trứng huy hiệu", "BtnTrungLinhThach");*/
			
			//Btn Top right
			ctnTopRight = AddContainer("", "", 620 + 133, 50 + 8);
			ctnTopRight.LoadRes("");
			ctnTopRight.AddImage(TOP_CORNER_BG, "TopCornerBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnTopRight.AddImage(VERTICAL_BG, "VerticalBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnTopRight.AddImage(BOTTOM_CORNER_BG, "BottomCornerBg", 0, 48, true, ALIGN_LEFT_TOP);
			arrBtnTopRight = new Array();
			btnFriendGift = addBtnEx(ctnTopRight, arrBtnTopRight, false, "BtnFriendGift", BTN_FRIEND_GIFT, "Quà tặng bạn bè", "BtnFriendGift", false, 40);
			btnMail = addBtnEx(ctnTopRight, arrBtnTopRight, false, "BtnMail", BTN_MAIL, "Hộp thư", "", false, 40);
			addBtnEx(ctnTopRight, arrBtnTopRight, false, "BtnDiary", BTN_DIARY, "Nhật kí", "", false, 40);
			addBtnEx(ctnTopRight, arrBtnTopRight, false, "BtnAnnouncement", BTN_ANNOUCEMENT, "Thông báo", "", false, 40);
			addBtnEx(ctnTopRight, arrBtnTopRight, false, "BtnCamera", BTN_CAMERA, "Chụp ảnh", "", false, 40);
			imgSnapshot = ctnTopRight.AddImage("", "iconEXP", 16 + 12, 15 + 42 * 4 + 6);
			
			//Btn Bottom right
			ctnBottomRight = AddContainer("", "", 620 + 133, 40 + 48 * 5);
			ctnBottomRight.LoadRes("");
			ctnBottomRight.AddImage(TOP_CORNER_BG, "TopCornerBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnBottomRight.AddImage(VERTICAL_BG, "VerticalBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnBottomRight.AddImage(BOTTOM_CORNER_BG, "BottomCornerBg", 0, 48, true, ALIGN_LEFT_TOP);
			arrBtnBottomRight = new Array();
			btnFishWorld = addBtnEx(ctnBottomRight, arrBtnBottomRight, false, "BtnFishWorld", BTN_FISH_WORLD, "Thế giới cá", "MapOcean");
			btnTournament = addBtnEx(ctnBottomRight, arrBtnBottomRight, false, "BtnTour", BTN_TOURNAMENT, "Lôi đài");
			btnSeriesFighting = addBtnEx(ctnBottomRight, arrBtnBottomRight, false, "BtnSeriesFighting", BTN_SERRIES_FIGHTING, "Liên đấu");
			if (!LeagueController.IsActive())
			{
				btnSeriesFighting.SetDisable2();
				var strTip:String = Localization.getInstance().getString("LeagueIssueTip");
				btnSeriesFighting.setTooltipText(strTip);
			}
			arrowTournament = ctnBottomRight.AddImage("", "IcHelper", 37 - 21, 15 + 48 + 27);
			arrowTournament.img.rotation -= 90;
			arrowTournament.img.visible = false;
			labelSeriesFighting = ctnBottomRight.AddLabel("> 1000", 2 - 34 + 8, 3 + 48 * 2 + 32, 0xffff00, 1, 0x000000);
			
			//Btn Left
			ctnLeft = AddContainer("", "", 10, 160);
			ctnLeft.LoadRes("");
			ctnLeft.AddImage(TOP_CORNER_BG, "TopCornerBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnLeft.AddImage(VERTICAL_BG, "VerticalBg", 0, 0, true, ALIGN_LEFT_TOP);
			ctnLeft.AddImage(BOTTOM_CORNER_BG, "BottomCornerBg", 0, 48, true, ALIGN_LEFT_TOP);
			arrBtnLeft = new Array();
			addBtnEx(ctnLeft, arrBtnLeft, false, "BtnDailyGift", BTN_DAILY_GIFT, "Quà tặng hàng ngày", "");
			btnDailyQuest = addBtnEx(ctnLeft, arrBtnLeft, false, "BtnDailyQuest", BTN_DAILY_QUEST, "Nhiệm vụ hàng ngày");
			btnSpiritPowerQuest = addBtnEx(ctnLeft, arrBtnLeft, false, "BtnSpiritPowerQuest", BTN_SPIRIT_QUEST, "Nhiệm vụ tinh lực");
			imgNumDailyQuest = ctnLeft.AddImage("", "", 15, 70);	
			btnReputation = addBtnEx(ctnLeft, arrBtnLeft, false, "BtnReputation", BTN_REPUTATION, "Uy danh");
			btnReputation.SetBlink(false);
			//Dong thong bao
			ctnTitle = AddContainer("", "ImgBgTitle", 400 - 174 - 27, 40 + 52);
			txtTitle = ctnTitle.AddLabel("", 0, 0, 0xffffff, 1, 0x000000);
			mask = new Sprite();
			mask.graphics.beginFill(0xff0000, 1);
			mask.graphics.drawRect(0, 0, 265, 20);
			mask.x = 40;
			ctnTitle.img.addChild(mask);
			txtTitle.mask = mask;
			ctnTitle.SetVisible(false);
			
			showBtnEx(ctnTop, arrBtnTop, true, 0);
			showBtnEx(ctnBottomRight, arrBtnBottomRight, false, 0);
			labelSeriesFighting.visible = false;
			showBtnEx(ctnLeft, arrBtnLeft, false, 2);
			//ThanhNT2
			//showBtnEx(ctnBook, arrBtnBook, true, 1);
			
			//Btn Event
			var config:Object = ConfigJSON.getInstance().GetItemList("Event");
			if (config[EventMgr.NAME_EVENT] != null)
			{
				addBtnEvent(NAME_BTN_EVENT, config[EventMgr.NAME_EVENT]["BeginTime"], config[EventMgr.NAME_EVENT]["ExpireTime"] - 120, config[EventMgr.NAME_EVENT]["BeginLevel"], TOOLTIP_EVENT);
				//Btn nhan qua event
				//var level:int = GameLogic.getInstance().user.GetLevel();
				//if(level >= config[EventMgr.NAME_EVENT]["BeginLevel"])
				//{
					//btnGiftEvent = AddButton(GUI_TOP_BTN_GET_GIFT_EVENT, NAME_BTN_AFTER_EVENT, 10, 212, this);
					//btnGiftEvent.setTooltipText("Đổi huy chương");
				//}
			}
			
			//nút nạp thẻ lần đầu
			giftPay = new GiftPayBag(this.img, "KhungFriend", 681, 75);
			giftPay.init();
			
			//AddButton(BTN_LINK_OHFISH, "BtnLinkOhFish", Constant.STAGE_WIDTH / 2 + 50, Constant.STAGE_HEIGHT / 2 + 50, this);
			AddButton(BTN_TRUNK_VIP, "BtnVIPTrunk", 160, 98, this).SetVisible(false);	//Có build feature mới lên thì cmt dòng này, có event mới thì bỏ cmt
			//AddButtonEx(BTN_UPGRADE_EQUIP, "BtnUpgradeEquipVIP", 120, 98, this);
		}
		
		/**
		 * add btnEx vào ctn
		 * @param	ctn
		 * @param	arrBtn: mảng chứa các nút trên ctn
		 * @param	horizontal: true nếu mở rông theo chiều ngang, false nếu theo chiều dọc
		 * @param	btnName
		 * @param	btnId
		 * @param	tooltip
		 * @param	helperName
		 * @param	hasIcNew: icon chữ Moi
		 * @return
		 */
		private function addBtnEx(ctn:Container, arrBtn:Array, horizontal:Boolean, btnName:String, btnId:String, tooltip:String, helperName:String = "", hasIcNew:Boolean = false, _height:Number = 48):ButtonEx
		{
			var bg:Image;
			var corner:Image;
			if (horizontal)
			{
				bg = ctn.GetImage(HORIZONTAL_BG);
				corner = ctn.GetImage(RIGHT_CORNER_BG);
			}
			else
			{
				bg = ctn.GetImage(VERTICAL_BG);
				corner = ctn.GetImage(BOTTOM_CORNER_BG);
			}
			var btn:ButtonEx = ctn.AddButtonEx(btnId, btnName, 0, 0, this, helperName);
			btn.SetBlink(false);
			btn.setTooltipText(tooltip);
			if (horizontal)
			{
				btn.FitRect(48, 48, new Point(arrBtn.length * 48, 0));
				bg.img.width = 48 * (arrBtn.length + 1);
				corner.img.x = 48 * (arrBtn.length + 1);
			}
			else
			{
				btn.FitRect(48, _height, new Point(0, arrBtn.length * _height));
				bg.img.height = _height * (arrBtn.length + 1);
				corner.img.y = _height * (arrBtn.length + 1);
			}
			if (hasIcNew)
			{
				if(horizontal)
				{
					ctn.AddImage(IC_NEW + arrBtn.length, "IcMoi", arrBtn.length * 48 + 10, 27, true, ALIGN_LEFT_TOP).img.mouseEnabled = false;
				}
				else
				{
					ctn.AddImage(IC_NEW + arrBtn.length, "IcMoi", 10, arrBtn.length * 48 + 27, true, ALIGN_LEFT_TOP).img.mouseEnabled = false;
				}
			}
			arrBtn.push(btn);
			return btn;
		}
		
		private function removeBtnEx(ctn:Container, btnId:String, arrBtn:Array, horizontal:Boolean):void
		{
			var i:int;
			for (i = 0; i < arrBtn.length; i++)
			{
				if (arrBtn[i] == ctn.GetButtonEx(btnId))
				{
					arrBtn.splice(i, 1);
					break;
				}
			}
			ctn.RemoveButtonEx(btnId);
			if (ctn.GetImage(IC_NEW + i) != null)
			{
				ctn.RemoveImage(ctn.GetImage(IC_NEW + i));
			}
			var bg:Image;
			var corner:Image;
			if (horizontal)
			{
				bg = ctn.GetImage(HORIZONTAL_BG);
				corner = ctn.GetImage(RIGHT_CORNER_BG);
			}
			else
			{
				bg = ctn.GetImage(VERTICAL_BG);
				corner = ctn.GetImage(BOTTOM_CORNER_BG);
			}
			for (i = 0; i < arrBtn.length; i++)
			{
				var btn:ButtonEx = arrBtn[i] as ButtonEx;
				if (horizontal)
				{
					btn.FitRect(48, 48, new Point(i * 48, 0));
					bg.img.width = 48 * (i + 1);
					corner.img.x = 48 * (i + 1);
				}
				else
				{
					btn.FitRect(48, 48, new Point(0, i * 48));
					bg.img.height = 48 * (i + 1);
					corner.img.y = 48 * (i + 1);
				}
			}
		}
		
		private function addBtnExAt(ctn:Container, arrBtn:Array, horizontal:Boolean, btnName:String, btnId:String, tooltip:String, position:int, helperName:String = "", _height:Number = 48):ButtonEx
		{
			var bg:Image;
			var corner:Image;
			if (horizontal)
			{
				bg = ctn.GetImage(HORIZONTAL_BG);
				corner = ctn.GetImage(RIGHT_CORNER_BG);
			}
			else
			{
				bg = ctn.GetImage(VERTICAL_BG);
				corner = ctn.GetImage(BOTTOM_CORNER_BG);
			}
			var btn:ButtonEx = ctn.AddButtonEx(btnId, btnName, 0, 0, this, helperName);
			btn.SetBlink(false);
			btn.setTooltipText(tooltip);
			arrBtn.push(btn);
			var i:int;
			for (i = arrBtn.length -1; i > position; i--)
			{
				arrBtn[i] = arrBtn[i - 1];
			}
			arrBtn[position] = btn;
			
			for (i = 0; i < arrBtn.length; i++)
			{
				var btnex:ButtonEx = arrBtn[i] as ButtonEx;
				if (horizontal)
				{
					btnex.FitRect(48, 48, new Point(i * 48, 0));
					bg.img.width = 48 * (i + 1);
					corner.img.x = 48 * (i + 1);
				}
				else
				{
					btnex.FitRect(48, _height, new Point(0, i * _height));
					bg.img.height = _height * (i + 1);
					corner.img.y = _height * (i + 1);
				}
			}
			return btn;
		}
		
		/**
		 * Hiện số nút trên ctn
		 * @param	ctn
		 * @param	arrBtn: mảng chứa các nút trên ctn
		 * @param	horizontal: true là chiều ngang, false là chiều dọc
		 * @param	num: số lượng các nút hiện lên
		 */
		private function showBtnEx(ctn:Container, arrBtn:Array, horizontal:Boolean, num:int):void
		{
			if (num <= 0)
			{
				ctn.SetVisible(false)
			}else 
			{
				ctn.SetVisible(true);
				if (num > arrBtn.length)
				{
					num = arrBtn.length;
				}
			}
			
			if (horizontal)
			{
				ctn.GetImage(HORIZONTAL_BG).img.width = num * 48;
				ctn.GetImage(RIGHT_CORNER_BG).img.x = num * 48;
			}
			else
			{
				ctn.GetImage(VERTICAL_BG).img.height = num * 48;
				ctn.GetImage(BOTTOM_CORNER_BG).img.y = num * 48;
			}
			for (var i:int = 0; i < arrBtn.length; i++)
			{
				if (i < num)
				{
					ButtonEx(arrBtn[i]).SetVisible(true);
					if (ctnTop.GetImage(IC_NEW + i) != null)
					{
						ctnTop.GetImage(IC_NEW + i).img.visible = true;
					}
				}
				else
				{
					ButtonEx(arrBtn[i]).SetVisible(false);
					if (ctnTop.GetImage(IC_NEW + i) != null)
					{
						ctnTop.GetImage(IC_NEW + i).img.visible = false;
					}
				}
			}
		}
		
		/**
		 * update thông tin khi init run xong hoặc sang nhà bạn hoặc levelup
		 */
		public function updateUserData():void
		{
			if (!IsVisible)
			{
				Show();
			}
			updateTitle();
			
			var user:User = GameLogic.getInstance().user;
			//Thông tin nhà mình
			if (!GameLogic.getInstance().user.IsViewer())
			{
				GetButtonEx(BTN_BOSS_SERVER).SetVisible(true);
				//Update unlock feature
				if (user.GetLevel() < 6)
				{
					showBtnEx(ctnTop, arrBtnTop, true, 0);
					showBtnEx(ctnBottomRight, arrBtnBottomRight, false, 0);
					labelSeriesFighting.visible = false;
					showBtnEx(ctnLeft, arrBtnLeft, false, 2);
				}
				else if (user.GetLevel() < 7)
				{
					showBtnEx(ctnTop, arrBtnTop, true, 1);
					showBtnEx(ctnBottomRight, arrBtnBottomRight, false, 0);
					labelSeriesFighting.visible = false;
					showBtnEx(ctnLeft, arrBtnLeft, false, 2);
				}
				else if (user.GetLevel() < 8)
				{
					showBtnEx(ctnTop, arrBtnTop, true, 1);
					showBtnEx(ctnBottomRight, arrBtnBottomRight, false, 1);
					labelSeriesFighting.visible = false;
					showBtnEx(ctnLeft, arrBtnLeft, false, 2);
				}
				else if (user.GetLevel() < 9)
				{
					showBtnEx(ctnTop, arrBtnTop, true, 2);
					showBtnEx(ctnBottomRight, arrBtnBottomRight, false, 1);
					labelSeriesFighting.visible = false;
					showBtnEx(ctnLeft, arrBtnLeft, false, 2);
				}
				else if (user.GetLevel() < 10)
				{
					showBtnEx(ctnTop, arrBtnTop, true, 3);
					showBtnEx(ctnBottomRight, arrBtnBottomRight, false, 1);
					labelSeriesFighting.visible = false;
					showBtnEx(ctnLeft, arrBtnLeft, false, 2);
				}
				else if (user.GetLevel() < 11)
				{
					showBtnEx(ctnTop, arrBtnTop, true, 4);
					showBtnEx(ctnBottomRight, arrBtnBottomRight, false, 1);
					labelSeriesFighting.visible = false;
					showBtnEx(ctnLeft, arrBtnLeft, false, 2);
				}
				else if (user.GetLevel() < 13)
				{
					showBtnEx(ctnTop, arrBtnTop, true, 5);
					showBtnEx(ctnBottomRight, arrBtnBottomRight, false, 1);
					labelSeriesFighting.visible = false;
					showBtnEx(ctnLeft, arrBtnLeft, false, 2);
				}
				else if (user.GetLevel() < 15)
				{
					showBtnEx(ctnTop, arrBtnTop, true, 8);
					showBtnEx(ctnBottomRight, arrBtnBottomRight, false, 1);
					labelSeriesFighting.visible = false;
					showBtnEx(ctnLeft, arrBtnLeft, false, 2);
				}
				else if (user.GetLevel() < 16)
				{
					showBtnEx(ctnTop, arrBtnTop, true, 8);
					showBtnEx(ctnBottomRight, arrBtnBottomRight, false, 1);
					labelSeriesFighting.visible = false;
					showBtnEx(ctnLeft, arrBtnLeft, false, 2);
				}
				else
				{
					showBtnEx(ctnTop, arrBtnTop, true, arrBtnTop.length);
					showBtnEx(ctnBottomRight, arrBtnBottomRight, false, arrBtnBottomRight.length);
					labelSeriesFighting.visible = true;
					showBtnEx(ctnLeft, arrBtnLeft, false, arrBtnLeft.length);
				}
				
				/*//ThanhNT2 Add
				if (GameLogic.getInstance().user.Level >= 16)
				{
					BtnTrungLinhThach.SetVisible(true);
				}
				else
				{
					BtnTrungLinhThach.SetVisible(false);
				}*/
				/**
				 * tạm thời đóng Viễn Chinh lại
				if (user.GetLevel() >= 7)
				{
					removeBtnEx(ctnLeft, BTN_DAILY_QUEST, arrBtnLeft, false);
					ctnLeft.RemoveImage(imgNumDailyQuest);
					showBtnEx(ctnLeft, arrBtnLeft, false, arrBtnLeft.length);
				}
				 */
				
				ctnFriend.SetVisible(false);
				ctnFriendBtn.SetVisible(false);
				ctnTopRight.SetVisible(true);
				ctnLeft.SetVisible(true);
				labelTimeBossServer.visible = true;
				//Hiện icon chụp đc exp
				if(GuiMgr.getInstance().GuiSnapshot.GetTypeBg() == "")
				{
					imgSnapshot.img.visible = false;
				}
				else 
				{
					imgSnapshot.img.visible = true;
				}
				//Update icon monday
				if (GameLogic.getInstance().isMonday() && ctnHappyMonday == null)
				{
					ctnHappyMonday = AddContainer("", "IconHappyMonday", 25 + 85, 90);
					ctnHappyMonday.SetScaleXY(0.7);
					var strTip:String = "<font size = '20'>Thứ 2 vui vẻ</font>\n<p size = '16' align ='left'>" + Ultility.getHappyMondayTip() + "</p>";
					ctnHappyMonday.setTooltipText(strTip);
				}
				//Update avatar user
				var avatarUrl:String = user.GetMyInfo().AvatarPic;
				if (!avatarUrl) 
				{
					avatarUrl = Main.staticURL + "/avatar.png";
				}
				avatar.LoadRes(avatarUrl, false);
				var userName:String = user.GetMyInfo().Name;
				if (userName == null || userName == "")
				{
					userName = "UnknownName";
				}
				labelUserName.text = Ultility.StandardString(userName, 10);
				if (user.GetMyInfo().AvatarPic == null)
				{
					user.GetMyInfo().AvatarPic = Main.staticURL + "/avatar.png";
				}
				var curEnergy:int = user.GetEnergy(true);
				var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(user.GetLevel(true));
				GuiMgr.getInstance().guiUserInfo.energy = curEnergy;
				
				var useTimes:int = 0;
				if(GameLogic.getInstance().user.moneyMagnet != null)
				{
					useTimes = GameLogic.getInstance().user.moneyMagnet.useTimes;
				}
				txtUseTime.text = "x" + useTimes.toString();
				
				labelSeriesFighting.text = LeagueController.rankText(user.Rank);
				initBtnSeriesQuest();
				GetButtonEx(BTN_INPUT_CODE).SetVisible(true);
				if (GameLogic.getInstance().user.NewGift)
				{
					btnFriendGift.SetBlink(true);
				}
				else
				{
					btnFriendGift.SetBlink(false);
				}
				GuiMgr.getInstance().GuiSetting.SetPos(Constant.STAGE_WIDTH - 27 - 52, 76);
				
				if (imgQuestNotification != null && imgQuestNotification.img != null)
				{
					if (QuestMgr.getInstance().GetCurTutorial() != "")
					{
						imgQuestNotification.img.visible = false;
					}
					else
					{
						imgQuestNotification.img.visible = true;
					}
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
				
				if (btnEvent != null)
				{
					btnEvent.SetVisible(true);
				}
				if (btnEventPlay != null)
				{
					btnEventPlay.SetVisible(true);
				}
				
				if(btnGiftEvent != null)
				{
					btnGiftEvent.SetVisible(true);
				}
				if (giftPay != null)
				{
					giftPay.SetVisible(true);
				}
				if (btnNapThe == null)
				{
					var startTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["AccumulationPoint"]["StartTime"];
					var endTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["AccumulationPoint"]["EndTime"];
					var curTime:Number = GameLogic.getInstance().CurServerTime;
					if (curTime >= startTime && curTime <= endTime)
					{
						/*check việc user đã nạp thẻ lần đầu chưa*/
						var xuAdd:int = user.GetMyInfo().FirstAddXu;
						var cfg:Object = ConfigJSON.getInstance().getItemInfo("FirstAddXuGift");
						var count:int = 0;
						var itm:String;
						var max:int = -1;
						for (itm in cfg)//duyệt tìm lượng xu lớn nhất
						{
							if (int(itm) > max)
							{
								max = int(itm);
							}
							count++;
						}
						if (xuAdd >= max)
						{
							var _oReceived:Object = user.GetMyInfo().FirstAddXuGift;
							var dem:int = 0;
							for (itm in _oReceived)
							{
								dem++;
							}
							if (count == dem)
							{
								btnNapThe = AddButtonEx(ID_BTN_NAP_THE, "BtnNapthe", 695, 84);
								btnNapThe.setTooltipText("Nạp thẻ tích lũy");
								btnNapThe.SetBlink(false);
							}
						}
					}
				}
				if (giftPay == null && btnNapThe == null)
				{
					giftPay = new GiftPayBag(this.img, "KhungFriend", 681, 75);
					giftPay.init();
				}
				if (btnNapThe != null)
				{
					btnNapThe.SetVisible(true);
				}
			}
			//Thông tin bạn
			else
			{
				GetButtonEx(BTN_BOSS_SERVER).SetVisible(false);
				helperBossServer.img.visible = false;
				//btnBossServer.SetVisible(false);
				//imageBossServer.img.visible = false;
				labelTimeBossServer.visible = false;
				
				if (!user.AvatarPic)
				{
					user.AvatarPic = Main.staticURL + "/avatar.png";
				}
				friendAvatar.LoadRes(user.AvatarPic, false);
				friendAvatar.SetSize(51, 51);		
				var levelUp:int = ConfigJSON.getInstance().getUserLevelExp(user.GetLevel(false) + 1);
				var curExp:int = user.GetExp(false);
				prgExp.setStatus(curExp / levelUp);		
				labelFriendExp.text = Ultility.StandardNumber(curExp);
				labelFriendLevel.text = Ultility.StandardNumber(user.GetLevel(false));
				labelFriendMoney.text = Ultility.StandardNumber(user.GetMoney(false));
				var nick:String = user.Name;
				if (nick.length > 15)
				{
					nick = nick.substr(0, 15) + "..";
				}
				labelFriendName.text = nick;
				ctnFriend.SetVisible(true);
				ctnFriendBtn.SetVisible(true);
				ctnTop.SetVisible(false);
				ctnTopRight.SetVisible(false);
				ctnBottomRight.SetVisible(false);
				ctnLeft.SetVisible(false);
				GetButtonEx(BTN_INPUT_CODE).SetVisible(false);
				RemoveButtonEx(BTN_MAIN_QUEST);
				btnMainQuest = null;
				
				GuiMgr.getInstance().GuiSetting.SetPos(Constant.STAGE_WIDTH - 27, 76);
				
				if (imgQuestNotification != null && imgQuestNotification.img != null)
				{
					imgQuestNotification.img.visible = false;
				}
				
				if (btnEvent != null)
				{
					btnEvent.SetVisible(false);
				}
				if (btnEventPlay != null)
				{
					btnEventPlay.SetVisible(false);
				}
				
				if(btnGiftEvent != null)
				{
					btnGiftEvent.SetVisible(false);
				}
				if (giftPay) 	giftPay.SetVisible(false);
				if (btnNapThe != null)
				{
					btnNapThe.SetVisible(false);
				}
			}
			updateBtnLock();
		}
		
		private function updateTitle():void 
		{
			var message:String = "";
			if (LogicTournament.checkTournamentRegister())
			{
				message = Localization.getInstance().getString("MessageInGameTournament");
				showTitle(message);
			}
			else
			{
				var topBossServer:String = GameLogic.getInstance().serverBossTop;
				var lastHit:String = GameLogic.getInstance().serverBossLastHit;
				var bossName:String = Localization.getInstance().getString("BossServer" + GameLogic.getInstance().serverBossId);
				var winBossUser:String = GameLogic.getInstance().WinBossUser;
				
				if(lastHit != null && lastHit != "" && lastHit != "false" && topBossServer != null && topBossServer != "" && topBossServer != "false")
				{
					message = "Người chơi <font color = '#ffff00'>" + topBossServer + "</font>  dẫn đầu ngư dân myFish cùng với đòn chí mạng của <font color = '#ffff00'>" + lastHit 
					+ "</font> đã kết liễu  <font color = '#ffff00'>" + bossName + "</font> và bảo vệ  <font color='#ffff00'>Thủy Cung</font> thành công!";
				}
				else if(winBossUser != null && winBossUser != "" && winBossUser != "false")
				{
					message = "Chúc mừng <font color = '#ffff00'>" + winBossUser + "</font> đã tìm đủ các mảnh ghép và khám phá kho báu trong <font color='#ffff00'>Biển Hắc Lâm</font>";
				}
				else
				{
					var userGetVipMax:String = GameLogic.getInstance().userGetVipMax;
					if (userGetVipMax != null && userGetVipMax != "")
					{
						message = "Chúc mừng <font color = '#ffff00'>" + userGetVipMax + "</font> đã nhận được đồ VIP MAX trong sự kiện Đảo giấu vàng";
					}
					
				}
				//ThanhNT2 bo thong bao che tao do moi
				//message = "myFish sẽ đóng <font color = '#ffff00'>\"chức năng chế tạo trang bị\"</font> từ sau ngày 01/12/2012";
				if (message != "")
				{
					showTitle(message);
				}
				else
				{
					hideTitle();
				}
			}
			
		}
		
		public function initBtnSeriesQuest():void 
		{
			if (!IsVisible)
			{
				return;
			}
			var seriquest:Array = QuestMgr.getInstance().SeriesQuest;	
			RemoveButtonEx(BTN_MAIN_QUEST);
			btnMainQuest = null;
			if (imgQuestNotification != null)
			{
				RemoveImage(imgQuestNotification);
			}
			if(seriquest != null && seriquest.length > 0)
			{				
				var quest:QuestInfo = seriquest[0] as QuestInfo;
				var ToolTip:TooltipFormat = new TooltipFormat();
				ToolTip.text = "Nhiệm vụ: " + Localization.getInstance().getString("TooltipSQ" + quest.IdSeriesQuest);
				var tmpFormat:TextFormat = new TextFormat();
				tmpFormat.bold = true;
				tmpFormat.color = 0xFF0000;
				ToolTip.setTextFormat(tmpFormat, 9, ToolTip.text.length);
				btnMainQuest = AddButtonEx(BTN_MAIN_QUEST, "BtnQuest", 10,  300 - 115 + 98, this);			
				btnMainQuest.setTooltip(ToolTip);
				
				if(imgQuestNotification == null || imgQuestNotification.img == null)
				{
					imgQuestNotification = AddImage("", "BtnExHelpQuest", 10 + 56, 330-115, true, ALIGN_LEFT_TOP);
				}
				if (QuestMgr.getInstance().GetCurTutorial() != "")
				{
					imgQuestNotification.img.visible = false;
					btnMainQuest.SetBlink(false);
				}
				else
				{
					imgQuestNotification.img.visible = true;
					btnMainQuest.SetBlink(true);
				}
			}
		}
		
		public function showTitle(message:String):void
		{
			if (!isShowTitle)
			{
				isShowTitle = true;
				ctnTitle.SetVisible(true);
				txtTitle.htmlText = message;
				txtTitle.x = mask.x + mask.width + 5;
			}
			else
			{
				txtTitle.htmlText = message;
			}
		}
		
		public function hideTitle():void
		{
			isShowTitle = false;
			ctnTitle.SetVisible(false);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				//case BTN_LINK_OHFISH:
					//var link:String = "http://me.zing.vn/apps/ohfish";
					//var url:URLRequest = new URLRequest(link);
					//navigateToURL(url);
					//break;
				case BTN_UPGRADE_EQUIP:
					//GuiMgr.getInstance().guiChooseVIPEquip.Show();
					//GuiMgr.getInstance().guiUpgradeEquip.showGUI();
					break;
				case BTN_TRUNK_VIP:
					GuiMgr.getInstance().guiVIPTrunk.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case GUI_TOP_BTN_GET_GIFT_EVENT:
					//GuiMgr.getInstance().GuiChangeGiftEvent.Show(Constant.GUI_MIN_LAYER, 3);
					GuiMgr.getInstance().guiChangeMedalVIP.Show(Constant.GUI_MIN_LAYER, 3);
					//GuiMgr.getInstance().guiMedal.Show(Constant.GUI_MIN_LAYER, 3);
					//GuiMgr.getInstance().guiChangeMedalEvent.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case BTN_EVENT:
					//GuiMgr.getInstance().guiDigitWheel.Show(Constant.GUI_MIN_LAYER, 5);
					//GuiMgr.getInstance().guiLuckyMachine.Show(Constant.GUI_MIN_LAYER, 5);
					//GuiMgr.getInstance().guiTreasureIsLand.Show(Constant.GUI_MIN_LAYER, 5);
					//GuiMgr.getInstance().guiExchangeCandy.Show(Constant.GUI_MIN_LAYER, 5);
					//GuiMgr.getInstance().GuiGameTrungThu.Show(Constant.GUI_MIN_LAYER, 5);
					var num:int = HalloweenMgr.getInstance().RemainPlayCount;
					if (num <= 0)
					{
						if (Ultility.checkInDay(HalloweenMgr.getInstance().LastTimeLock))
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết số lần tham gia sự kiện trong ngày hôm nay.");
							return;
						}
					}
					if (HalloweenMgr.getInstance().checkLockHalloween())
						GuiMgr.getInstance().guiLockHalloween.Show(Constant.GUI_MIN_LAYER, 5);
					else
						GuiMgr.getInstance().guiHalloween.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case BTN_EVENT_PLAY:
					EventNoelMgr.getInstance().processGotoHunt();
					break;
				case BTN_BOSS_SERVER:
					GuiMgr.getInstance().guiListBoss.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_SYSTEM_MAIL:
					GuiMgr.getInstance().GuiSystemMail.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case BTN_FRIEND_MAIL:
					GuiMgr.getInstance().GuiReplyLetter.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_GET_COIN:
					GameLogic.getInstance().user.moneyMagnet.OnMouseClick(null);
					var useTimes:int = GameLogic.getInstance().user.moneyMagnet.useTimes;
					txtUseTime.text = "x" + useTimes.toString();
					break;
				case BTN_INPUT_CODE:
					GuiMgr.getInstance().GuiInputCode.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case BTN_PASSWORD:
					GuiMgr.getInstance().guiPassword.showGUI();
					break;
				case BTN_BLACK_MARKET:
					GuiMgr.getInstance().guiMarket.Show(Constant.GUI_MIN_LAYER, 6);
					break;
				case BTN_STORE_EQUIP:
					if(Ultility.IsInMyFish())
					{
						GuiMgr.getInstance().GuiChooseEquipment.Init(null);
					}
					else 
					{
						GuiMgr.getInstance().GuiStoreEquipment.Init();
					}
					break;
				case BTN_TRAINING_TOWER:
					GuiMgr.getInstance().GuiTrainingTower.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case BTN_MERIDIAN:
					GuiMgr.getInstance().guiMeridian.showGUI();
					break;
				case BTN_COLLECTION:
					GuiMgr.getInstance().guiCollection.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_GEM:
					GuiMgr.getInstance().GuiGemRefine.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case BTN_ENCHANT_EQUIP:
					GuiMgr.getInstance().guiEnchant.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case BTN_CREATE_EQUIP:
					GuiMgr.getInstance().guiChooseFactory.Show(Constant.GUI_MIN_LAYER, 6);
					break;
				case BTN_SMITHY:
					var cmdLoadData:SendGetHammerMan = new SendGetHammerMan();
					Exchange.GetInstance().Send(cmdLoadData);
					GuiMgr.getInstance().guiSpecialSmithy.showGUI();
					break;
				//ThanhNT2 Add
				case BTN_TRUNG_LINH_THACH:
					if (GameLogic.getInstance().user.Level >= 16)
					{
						GuiMgr.getInstance().guiTrungLinhThach.showGUI();
					}
					else
					{
						var message:String = 'Bạn phải đạt cấp 16 mới được vào Trứng Huy Hiệu!';
						GuiMgr.getInstance().GuiMessageBox.ShowOK(message);
					}
					//trace("<----------- BTN_TRUNG_LINH_THACH ------------>");
					break;
				case BTN_FRIEND_GIFT:
					GameLogic.getInstance().user.NewGift = false;
					GameController.getInstance().UseTool("Gift");
					break;
				case BTN_MAIL:
					GameLogic.getInstance().user.NewMail = false;
					GameController.getInstance().UseTool("Letter");		
					break;
				case BTN_DIARY:
					GuiMgr.getInstance().GuiLog.ShowLog(false);
					break;
				case BTN_ANNOUCEMENT:
					GuiMgr.getInstance().GuiAnnounce.ShowAnnouce();
					break;
				case BTN_CAMERA:
					ActiveTooltip.getInstance().clearToolTip();
					if (img.stage.displayState == StageDisplayState.FULL_SCREEN)
					{
						img.stage.displayState = StageDisplayState.NORMAL;
					}
					GuiMgr.getInstance().GuiSnapshot.Init();
					break;
				case BTN_FISH_WORLD:
					if(GameLogic.getInstance().user.GetLevel(true) >= 7)
					{
						if(!GuiMgr.getInstance().GuiMapOcean.IsVisible && !isSendLoadOcean)
						{
							isSendLoadOcean = true;
							if (GuiMgr.IsFullScreen)
							{
								Ultility.SetScreen();
							}
							
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
					}
					break;
				case BTN_TOURNAMENT:
					btnTournament.SetDisable2();
					LogicTournament.getInstance().openTournament();
					break;
				case BTN_SERRIES_FIGHTING:
					//trace("-------------liên đấu--------------");
					if (GameLogic.getInstance().CurServerTime-LeagueController.getInstance().timeRefresh > LeagueController.TIME_REFRESH)
					{
						//trace("<<<<<<<<< if phia tren >>>>>>>>>>>");
						ctnBottomRight.GetButtonEx(BTN_SERRIES_FIGHTING).SetEnable(false);
						ctnBottomRight.GetButtonEx(BTN_SERRIES_FIGHTING).setTooltipText("Liên đấu");
						LeagueMgr.getInstance().gotoLeague();
						Hide();
					}
					else
					{
						//trace("<<<<<<<<< else >>>>>>>>>>>");
						ctnBottomRight.GetButtonEx(BTN_SERRIES_FIGHTING).setTooltipText("Đợi chút xíu!");
						LeagueController.getInstance().hasUpdateBtnLeague = true;
					}
					break;
				case BTN_DAILY_GIFT:
					GuiMgr.getInstance().GuiDailyBonus.Init();
					break;
				case BTN_DAILY_QUEST:
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
				case BTN_EXPEDITION_QUEST:
					GuiMgr.getInstance().guiExpedition.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case BTN_SPIRIT_QUEST:
					GuiMgr.getInstance().GuiQuestPowerTinh.Show(Constant.GUI_MIN_LAYER, 3);
					ctnLeft.GetButtonEx(BTN_SPIRIT_QUEST).SetBlink(false);
					break;
				case BTN_MAIN_QUEST:
					var seriesQuest:Array = QuestMgr.getInstance().SeriesQuest;
					if (seriesQuest != null && seriesQuest.length > 0)
					{
						var idSeriesQuest:int = QuestInfo(seriesQuest[0]).IdSeriesQuest;
						GameController.getInstance().UseToolSeriQuest(idSeriesQuest);
					}
					btnMainQuest.SetBlink(false);
					break;
				case BTN_REPUTATION:
					GuiMgr.getInstance().guiReputation.showGui();
					break;
				case ID_BTN_NAP_THE:
					if (GuiMgr.getInstance().GuiStore.IsVisible)
					{
						GuiMgr.getInstance().GuiStore.Hide();
					}
					GuiMgr.getInstance().guiSavePoint.Show(Constant.GUI_MIN_LAYER, 5);
					break;
			}
		}
		
		public function updateBtnLock():void
		{
			if (GameLogic.getInstance().user.Level >= 7 &&
				LeagueController.getInstance().mode == LeagueController.IN_HOME && !GameLogic.getInstance().user.IsViewer())
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
		
		override public function UpdateObject():void 
		{
			updateBossServer();
			
			//Update dong thong bao
			if (isShowTitle)
			{
				txtTitle.x -= 2;
				if (txtTitle.x < -txtTitle.width + 30)
				{
					hideTitle();
				}
			}
			
			if (LeagueController.getInstance().hasUpdateBtnLeague)
			{
				if (GameLogic.getInstance().CurServerTime-LeagueController.getInstance().timeRefresh > LeagueController.TIME_REFRESH)
				{
					ctnBottomRight.GetButtonEx(BTN_SERRIES_FIGHTING).setTooltipText("Liên đấu");
					LeagueController.getInstance().hasUpdateBtnLeague = false;
				}
			}
			//update btnEvent
			if (GameLogic.getInstance().CurServerTime < endTimeEvent + 24 * 3600)
			{
				if (GetButton(BTN_TRUNK_VIP) != null)
				{
					GetButton(BTN_TRUNK_VIP).SetVisible(true);
				}
			}
			else
			{
				if (GetButton(BTN_TRUNK_VIP) != null)
				{
					GetButton(BTN_TRUNK_VIP).SetVisible(false);
				}
			}
			//trace(GameLogic.getInstance().CurServerTime, endTimeEvent, startTimeEvent);
			var date:Date = new Date(GameLogic.getInstance().CurServerTime*1000);
			var date1:Date = new Date(endTimeEvent*1000);
			var date2:Date = new Date(startTimeEvent*1000);
			//trace(date.getDate() + "/" + (date.getMonth() + 1));
			if (GameLogic.getInstance().CurServerTime > endTimeEvent || GameLogic.getInstance().CurServerTime < startTimeEvent)
			{
				if(btnEvent != null)
				{
					btnEvent.SetVisible(false);
				}
				if (btnEventPlay != null)
				{
					btnEventPlay.SetVisible(false);
				}
				if(btnGiftEvent != null && GameLogic.getInstance().CurServerTime < startTimeEvent)
				{
					btnGiftEvent.SetVisible(false);
				}
			}
			else if ((btnEvent == null || btnEvent.img == null) && btnNameEvent != null && GameLogic.getInstance().user.GetLevel() >= startLevelEvent)
			{
				btnEvent = AddButton(BTN_EVENT, btnNameEvent, 10, 160, this);
				btnEvent.setTooltipText(tipMessageEvent);
				//btnEventPlay = AddButton(BTN_EVENT_PLAY, "EventNoel_BtnHuntFish", 70, 160, this);
				//var tipBtnEventPlay:String = Localization.getInstance().getString("EventNoel_TipBtnHuntFish");
				//btnEventPlay.setTooltipText(tipBtnEventPlay);
				//btnGiftEvent = AddButton(GUI_TOP_BTN_GET_GIFT_EVENT, NAME_BTN_AFTER_EVENT, 10, 212, this);
				//btnGiftEvent.setTooltipText("Đổi huy chương");
			}
			
			//Update btnTournament
			if ((int)(Main.verTournament) > 0)
			{
				if (GameLogic.getInstance().user.GetLevel() >= 15)
				{
					if (LogicTournament.checkTournamentRegister())
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
			}
			
			// update title			
			if(!isShowTitle)
			{
				updateTitle();
			}
			
			updateLeftCtnPostion();
			
			//cập nhật cho túi quà nạp thẻ lần đầu
			if (giftPay != null)
			{
				var user:User = GameLogic.getInstance().user;
				var myLevel:int = user.GetLevel();
				if (myLevel < 7)
				{
					giftPay.Destructor();
					giftPay = null;
				}
				else
				{
					var count:int = 0;
					var dem:int = 0;
					var _oReceived:Object = user.GetMyInfo().FirstAddXuGift;
					var cfg:Object = ConfigJSON.getInstance().getItemInfo("FirstAddXuGift");
					var countCfg:int;
					var itm:String;
					for (itm in _oReceived)
					{
						count++;
					}
					for (itm in cfg)
					{
						dem++;
					}
					if (count == dem)
					{
						removeGiftPay();
					}
					else
					{
						giftPay.UpdateObject();
					}
				}
			}
		}
		
		private function updateLeftCtnPostion():void 
		{
			//Update vi tri ctnLeft
			if (!GameLogic.getInstance().user.IsViewer())
			{
				if (imgQuestNotification != null && imgQuestNotification.img != null)
				{
					if (QuestMgr.getInstance().GetCurTutorial() != "")
					{
						imgQuestNotification.img.visible = false;
					}
					else if(btnMainQuest != null && btnMainQuest.img != null && btnMainQuest.img.visible)
					{
						imgQuestNotification.img.visible = true;
					}
				}
				
				if (btnEvent != null && btnEvent.img && btnEvent.img.visible)
				{
					btnEvent.img.y = 160;
					if (btnGiftEvent != null && btnGiftEvent.img != null && btnGiftEvent.img.visible)
					{
						btnGiftEvent.img.y = 160 + 55;
						if (btnMainQuest != null && btnMainQuest.img.visible)
						{
							btnMainQuest.SetPosY(160 + 2 * 55);
							
							if (imgQuestNotification != null && imgQuestNotification.img != null)
							{
								imgQuestNotification.img.y = 160 + 2 * 55 + 10;
							}
							ctnLeft.img.y = 170 + 3 * 55;
						}
						else
						{
							ctnLeft.img.y = 170 + 2 * 55;
						}
					}
					else
					if (btnMainQuest != null && btnMainQuest.img.visible)
					{
						btnMainQuest.SetPosY(160 +  55);
						if (imgQuestNotification != null && imgQuestNotification.img != null)
						{
							imgQuestNotification.img.y = 160 + 55 + 10;
						}
						ctnLeft.img.y = 170 + 2 * 55;
					}
					else
					{
						ctnLeft.img.y = 170 + 55;
					}
				}
				else if (btnGiftEvent != null && btnGiftEvent.img != null && btnGiftEvent.img.visible)
				{
					btnGiftEvent.img.y = 160
					if (btnMainQuest != null && btnMainQuest.img.visible)
					{
						btnMainQuest.SetPosY(160 + 55);
						if (imgQuestNotification != null && imgQuestNotification.img != null)
						{
							imgQuestNotification.img.y = 160 +  55 + 10;
						}
						ctnLeft.img.y = 170 + 2 * 55;
					}
					else
					{
						ctnLeft.img.y = 170 + 55;
					}
				}
				else if (btnMainQuest != null && btnMainQuest.img.visible)
				{
					btnMainQuest.SetPosY(160);
					if (imgQuestNotification != null && imgQuestNotification.img != null)
					{
						imgQuestNotification.img.y = 160 + 10;
					}
					ctnLeft.img.y = 170 + 55;
				}
				else
				{
					ctnLeft.img.y = 170;
				}
			}
		}
		
		private function updateBossServer():void
		{
			//Time boss server
			var configJoinTime:Object = ConfigJSON.getInstance().GetItemList("Param")["ServerBoss"]["JoinTime"];
			var arrTimeStone:Array = new Array();
			var minuteFighting:int = 60;
			for (var s:String in configJoinTime)
			{
				var beginTime:String = configJoinTime[s]["BeginTime"];
				var arr:Array = beginTime.split("-");
				arrTimeStone.push(arr[0]);
				
				var endTime:String = configJoinTime[s]["EndTime"];
				var arr2:Array = endTime.split("-");
				minuteFighting = (arr2[0] - arr[0]) * 60 + arr2[1] - arr[1];
			}
				
			var firstPoint:int = Math.min(arrTimeStone[0], arrTimeStone[1]);
			var secondPoint:int = Math.max(arrTimeStone[0], arrTimeStone[1]);
			var date:Date = new Date();
			date.setTime((GameLogic.getInstance().CurServerTime  + 7*3600)* 1000);
			var timeBoss:Number = 0;
			if(date.hoursUTC < firstPoint)
			{
				timeBoss = firstPoint*3600 - date.hoursUTC*3600 - date.minutesUTC*60 - date.secondsUTC;
			}
			if (date.hoursUTC < secondPoint && date.hoursUTC >= firstPoint && (date.minutesUTC > minuteFighting || date.hoursUTC > firstPoint))
			{
				timeBoss = secondPoint * 3600 - date.hoursUTC * 3600 - date.minutesUTC * 60 - date.secondsUTC;
			}
			if (date.hoursUTC >= secondPoint && (date.minutesUTC > minuteFighting || date.hoursUTC > secondPoint))
			{
				timeBoss = (24 + firstPoint) * 3600 - date.hoursUTC * 3600 - date.minutesUTC * 60 - date.secondsUTC;
			}
			//hard code
			if (timeBoss > 0)
			{
				var hour:int = Math.floor(timeBoss / 3600);
				var minute:int = Math.floor((timeBoss - hour * 3600) / 60);
				var second:int = timeBoss - hour * 3600 - minute * 60;
				if (hour < 10)
				{
					labelTimeBossServer.text = "0" + hour;
				}
				else
				{
					labelTimeBossServer.text = hour.toString();
				}
				if (minute < 10)
				{
					labelTimeBossServer.appendText(":0" + minute);
				}
				else
				{
					labelTimeBossServer.appendText(":" + minute);
				}
				if (second < 10)
				
				{
					labelTimeBossServer.appendText(":0" + second);
				}
				else
				{
					labelTimeBossServer.appendText(":"+second);
				}
				
				if (helperBossServer.img.visible)
				{
					helperBossServer.img.visible = false;
					updateTitle();
				}
			}
			else
			{
				if (!GameLogic.getInstance().user.IsViewer())
				{
					labelTimeBossServer.text = "Đang diễn ra";
					if (!helperBossServer.img.visible)
					{
						showTitle("Thủy Cung đang bị Thủy Quái tấn công. Ngư dân myFish hãy cùng nhau đánh Thủy Quái bảo vệ Thủy Cung nào!");
						GetButtonEx(BTN_BOSS_SERVER).SetEnable(true);
						GetButtonEx(BTN_BOSS_SERVER).setTooltipText("Bảo Vệ Thủy Cung");
						helperBossServer.img.visible = true;
					}
				}
			}
			
			if (GameLogic.getInstance().user.GetLevel() >= 7)
			{
				GetButtonEx(BTN_BOSS_SERVER).SetEnable(true);
				GetButtonEx(BTN_BOSS_SERVER).setTooltipText("Bảo Vệ Thủy Cung");
			}
			else
			{
				GetButtonEx(BTN_BOSS_SERVER).SetEnable(false);
				GetButtonEx(BTN_BOSS_SERVER).setTooltipText("Bạn phải lên cấp 7 mới có thể tham gia");
			}
			
		}
		
		override public function Fullscreen(IsFull:Boolean, dx:int = 0, dy:int = 0, scaleX:Number = 1, scaleY:Number = 1):void 
		{
			super.Fullscreen(IsFull, dx, dy, scaleX, scaleY);
			if (IsFull)
			{
				ctnTopRight.img.x = img.stage.fullScreenWidth  - Constant.STAGE_WIDTH + 753;
				ctnBottomRight.img.x = img.stage.fullScreenWidth  - Constant.STAGE_WIDTH + 753;
				btnLock.img.x = 675 + img.stage.fullScreenWidth  - Constant.STAGE_WIDTH;
				btnUnlock.img.x = 675 + img.stage.fullScreenWidth  - Constant.STAGE_WIDTH;
				GetButtonEx(BTN_INPUT_CODE).img.x = 760 + img.stage.fullScreenWidth  - Constant.STAGE_WIDTH;
				btnGetCoin.img.x = 708 + img.stage.fullScreenWidth  - Constant.STAGE_WIDTH;
				txtUseTime.x = 608 + 77 + img.stage.fullScreenWidth  - Constant.STAGE_WIDTH;
				ctnFriend.img.x =  675 - 84 + 48 + img.stage.fullScreenWidth  - Constant.STAGE_WIDTH;
				var BgLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
				img.y = BgLayer.y;
			}
			else
			{
				ctnTopRight.img.x = 753;
				ctnBottomRight.img.x = 753;
				btnLock.img.x = 675;
				btnUnlock.img.x = 675;
				GetButtonEx(BTN_INPUT_CODE).img.x = 760;
				btnGetCoin.img.x = 708;
				txtUseTime.x = 608 + 77;
				ctnFriend.img.x =  675 - 84 + 48;
			}
		}
		
		public function showDailyQuestTask(curDailyQuest:int):void 
		{
			if(curDailyQuest > 0 && curDailyQuest < 4)
			{
				imgNumDailyQuest.LoadRes("ImgQuestLeft" + curDailyQuest);
				imgNumDailyQuest.SetScaleXY(0.6);
			}
			else
			{
				imgNumDailyQuest.LoadRes("");
			}
		}
		
		private function addBtnEvent(_btnNameEvent:String, _startTimeEvent:Number, _endTimeEvent:Number, _startLevel:int, _tipMessageEvent:String):void
		{
			RemoveButton(BTN_EVENT);
			//RemoveButton(BTN_EVENT_PLAY);
			tipMessageEvent = _tipMessageEvent;
			btnNameEvent = _btnNameEvent;
			startTimeEvent = _startTimeEvent;
			endTimeEvent = _endTimeEvent;
			startLevelEvent = _startLevel;
			var cst:Number = GameLogic.getInstance().CurServerTime;
			var lv:int = GameLogic.getInstance().user.GetLevel();
			if (cst >= startTimeEvent && cst <= endTimeEvent && lv >= startLevelEvent)
			{
				btnEvent = AddButton(BTN_EVENT, btnNameEvent, 10, 160, this);
				btnEvent.setTooltipText(tipMessageEvent);
				//btnEventPlay = AddButton(BTN_EVENT_PLAY, "EventNoel_BtnHuntFish", 70, 160, this);
				//btnEventPlay.setTooltipText(tipMessageEvent);
			}
			//Btn nhan qua event
			//if(lv >= startLevelEvent)
			//{
				//btnGiftEvent = AddButton(GUI_TOP_BTN_GET_GIFT_EVENT, NAME_BTN_AFTER_EVENT, 10, 212, this);
				//btnGiftEvent.setTooltipText("Đổi huy chương");
			//}
		}
		
		/**
		 * Vị trí btnEvent trên stage
		 * @return
		 */
		public function getPosBtnEvent():Point
		{
			var p:Point = new Point(0, 0);
			if(btnEvent != null)
			{
				p = btnEvent.GetPos();
				p = ctnTop.img.localToGlobal(p);
			}
			return p;
		}
		
		public function removeGiftPay():void
		{
			giftPay.Destructor();
			giftPay = null;
		}
		
		public function addBtnNapThe():void
		{
			var startTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["AccumulationPoint"]["StartTime"];
			var endTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["AccumulationPoint"]["EndTime"];
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (curTime >= startTime && curTime <= endTime)
			{
				btnNapThe = AddButtonEx(ID_BTN_NAP_THE, "BtnNapthe", 695, 84);
				btnNapThe.setTooltipText("Nạp thẻ tích lũy");
				btnNapThe.SetBlink(false);
			}
		}
	}

}














