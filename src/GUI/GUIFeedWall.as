 package GUI 
{
	import com.bit101.components.Style;
	import com.greensock.plugins.ShortRotationPlugin;
	import Data.Config;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import Logic.Fish;
	import Logic.GameLogic;
	import Data.Localization;
	import flash.external.ExternalInterface;
	import Logic.GameMode;
	import Logic.GameState;
	import Logic.Lake;
	import Logic.MyUserInfo;
	import Logic.NewFeedWall;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.SendSignKey;
	import Sound.SoundMgr;
	import com.bit101.components.ComboBox;
	import flash.events.KeyboardEvent;
	import com.adobe.utils.StringUtil;
	
	/**
	 * Hướng dẫn
	 * 	// Tổng số loại feed
		// Ai thêm feed mới, thì phải
		// tăng NUM_TYPE_FEED thêm 1;
		// Cập nhật lại localization bao gồm
		//		* Thông báo Feed mặc đinh
		// 		* Các kiểu câu Feed có sẵn 
		//		* Thông báo Nội dung Feed mặc đinh
		// 		* Các icon Dùng để feed lên tường
		//		* Các icon Dùng để hiện trên GUI (nếu là cá thì phải đặt nội dung bên trong là "Fish")
		// 		* id của kiểu feed
		//	Các trường hợp khác của localization (có Feed ở đầu) phải được cập nhật đầy đủ
		// 	Sau đó gọi đến hàm ShowFeed(type, itemName);
		//  Nếu là cá thì phải truyền thêm FishId của nó
		// 	Nếu có nhiều cái dùng chung 1 feedType thì có thể phân biệt nó bằng hậu tố "@ + chỉ số"
		// 	hậu tố này sẽ ko được gửi lên server
	 * @author Quangvh
	 */
	public class GUIFeedWall extends BaseGUI 
	{
		public const TYPE_GAME:String = "myFish";
		public const LINK_GAME:String = "http://me.zing.vn/apps/fish?_src=m";
		//public const LINK_GAME:String = "http://me.zing.vn/apps/fish?Web=1&Banner=1";
		public const MEDIA_TYPE:int = 1;
		public const PRIVICY:int = 1;
		private const NUM_TYPE_FEED:int = 149;	// Tổng số loại FEED hiện có
		private const GUI_FEED_ICON:String 		= "FeedIcon";
		private const GUI_FEED_ICON_BKG:String 	= "FeedIconBackground";
		private const GUI_FEED_STRING:String 	= "txtContent";
		private const GUI_FEED_OK:String 		= "ButtonOk";
		private const GUI_FEED_CANCEL:String 	= "ButtonCancel";
		
		// GUI components:
		private var txtContent:TextBox;
		private var Title:TextField;
		private var Content:TextField;
		private var FeedIcon:Image;
		private var FeedType:String;
		private var FeedIconPos:Point;
		private var ComboFeed:ComboBox;
		public var OkButton:Button; 
		
		// Mảng chứa các tham số *
		private var ArrNumBox:Array;

		// Các tham số dùng để tạo gói tin gửi lên server
		private var IconSend:String = "";
		private var ItemNameSend:String = "";
		private var QuestNameSend:String = "";
		
			// Nơi chứa các kiểu feed
			//Event euro
			public const FEED_TYPE_EURO_CORRECT_PREDICTION:String = "EventEuro4";
			public const FEED_TYPE_EURO_CHAMPION:String = "EventEuro1";
			public const FEED_TYPE_EURO_SECOND_PRIZE:String = "EventEuro2";
			public const FEED_TYPE_EURO_THIRD_PRIZE:String = "EventEuro3";
			// KHởi tạo trò chơi
			public const FEED_TYPE_INIT:String 							= "create";		
			// Lai được giống cá mới trong shop
			public static const FEED_TYPE_NEW_FISH:String 				= "unlockNewFish";		
			// Lên Level
			public const FEED_TYPE_LEVEL_UP:String 						= "levelUp";	
			// Mua bể lai mới
			public const FEED_TYPE_BUY_MIXLAKE:String 					= "buyMixLake";
			// Nâng cấp hồ để rộng hơn
			public static const FEED_TYPE_UPGRADE_TANK:String 			= "upgradeLake";
			// Hoàn thành nhiệm vụ 1
			public const FEED_TYPE_SQ_FINISH1:String 					= "completeQuest_1";
			// Hoàn thành nhiệm vụ 2
			public const FEED_TYPE_SQ_FINISH2:String 					= "completeQuest_2";
			// Câu được cá khi sang nhà bạn
			public static const FEED_TYPE_FISHING:String 				= "fishing";
			// Mua thêm hồ
			public static const FEED_TYPE_UNLOCK_LAKE: String			= "unlockLake";
			// Lai được cá vượt cấp lần đầu
			public static const FEED_TYPE_MIX_OVER_LEVEL:String 		= "mixOverLevel";
			// Lai ra cá đặc biệt
			public static const FEED_TYPE_SPECIAL_FISH:String 			= "specialFish";
			// Lai ra cá quí
			public static const FEED_TYPE_RARE_FISH:String 				= "rareFish";
			// Ép ra nguyên liệu cấp 3 lần đầu
			public static const FEED_TYPE_MATERIAL_3:String 			= "material_3";
			// Ép ra nguyên liệu cấp 4
			public static const FEED_TYPE_MATERIAL_4:String 			= "material_4";
			// Ép ra nguyên liệu cấp 5
			public static const FEED_TYPE_MATERIAL_5:String 			= "material_5";
			// Nhận được quà khủng
			public static const FEED_TYPE_HUGE_GIFT:String				= "getGiftDay";	
			// Unlock Slot Material
			public const FEED_TYPE_UNLOCK_SLOT_MATERIAL:String 			= "unlockSlotMaterial";	
			// Nhận được quà là cá quý
			public static const FEED_TYPE_RARE_FISH_GIFT:String 		=  "rareFishGift"
			// Tham gia sự kiện
			public static const FEED_TYPE_JOIN_EVENTS:String 			=  "activeFreeDomEvent";
			// Nhận quà của sự kiện
			public static const FEED_TYPE_GET_GIFT_EVENTS:String 		=  "getBonusEvent30";
			// Nhờ bạn bè tặng quà event
			public static const FEED_TYPE_REMIND_FRIEND:String 			=  "inviteFriendSendFlower";
			// Hoàn thành DailyQuest 
			private static const DAILY_QUEST_FEED_2:String 				= "feedDailyQuest2";
			private static const DAILY_QUEST_FEED_3:String 				= "feedDailyQuest3";
			
			//Hoàn thành seriquest skill lai cá
			public static const FEED_TYPE_SALE_OFF_SKILL:String 		= "completeSkillQuest@1";
			public static const FEED_TYPE_OVER_LEVEL_SKILL:String 		= "completeSkillQuest@2";
			public static const FEED_TYPE_SPECIAL_SKILL:String 			= "completeSkillQuest@3";

			public static const FEED_TYPE_RARE_SKILL:String 			= "completeSkillQuest@4";			
			public static const FEED_TYPE_QUEST_USE_MATERIAL:String		= "completeUseMaterial";			
			public static const FEED_UPGRADE_SKILL_MATERIAL:String 		= "upgradeMaterialSkill";			
			public static const FEED_TYPE_OPEN_MAGIC_BAG_LUCKY:String = "OpenLucky";
			
			public static const FEED_TYPE_SERIES_QUEST_FISH_WAR:String 	= "SeriesQuest7";
			
			public static const FEED_TYPE_GET_GIFT_RAREFISH:String 			=  "getRareFishEventTreasure";
			public static const FEED_TYPE_GET_GIFT_XFISHSPARTA:String 			=  "getSpartaEventTreasure";
			public static const FEED_TYPE_GET_GIFT_XFISHSWAT:String 			=  "getSwatEventTreasure";
			public static const FEED_TYPE_GET_GIFT_XFISHBATMAN:String 			=  "getBatmanEventTreasure";
			public static const FEED_TYPE_GET_GIFT_XFISHSPIDER:String 			=  "getSpiderEventTreasure";
			public static const FEED_TYPE_GET_GIFT_MATERIAL:String 			=  "getMaterialEventTreasure";
			public static const FEED_TYPE_GET_GIFT_ENERGYITEM:String 		=  "getEnergyItemEventTreasure";
			public static const FEED_TYPE_GET_GIFT_REBORNMEDICINE:String 	=  "getRebornMedicineEventTreasure";

			// Nâng cấp skill lai cá
			public static const FEED_UPGRADE_SKILL_MONEY:String			= "upgradeMixSkill@1";
			public static const FEED_UPGRADE_SKILL_LEVEL:String			= "upgradeMixSkill@2";
			public static const FEED_UPGRADE_SKILL_SPECIAL:String		= "upgradeMixSkill@3";
			public static const FEED_UPGRADE_SKILL_RARE:String			= "upgradeMixSkill@4";
			//invite friend
			public static const FEED_TYPE_INVITE_FRIEND:String 			= "inviteFriend";		
			public static const FEED_TYPE_INVITE_FRIEND_FINISH1:String 			= "finishInviteFriend_1";		
			public static const FEED_TYPE_INVITE_FRIEND_FINISH2:String 			= "finishInviteFriend_2";		
			public static const FEED_TYPE_INVITE_FRIEND_FINISH3:String 			= "finishInviteFriend_3";		
			
			public static const FEED_TYPE_EVENT_CLICK:String 			= "eventClick";		
			
			//Event 2-9
			public static const FEED_TYPE_EVENT_ND_1:String 			= "EventND1";		
			public static const FEED_TYPE_EVENT_ND_2:String 			= "EventND2";		
			public static const FEED_TYPE_EVENT_ND_3:String 			= "EventND3";		
			public static const FEED_TYPE_EVENT_ND_4:String 			= "EventND4";		
			public static const FEED_TYPE_EVENT_ND_5:String 			= "EventND5";		
			
			public static const FEED_TYPE_WISH_ND_1:String 			= "WishND1";		
			public static const FEED_TYPE_WISH_ND_2:String 			= "WishND2";		
			public static const FEED_TYPE_WISH_ND_3:String 			= "WishND3";		
			public static const FEED_TYPE_WISH_ND_4:String 			= "WishND4";	
			
			// Event Hoa mùa thu
			public static const FEED_TYPE_EVENT_PEAR_FLOWER:String 			= "eventGameMidle8";	
			public static const FEED_TYPE_EVENT_HOA_MUA_XUAN:String 			= "eventHoaMuaXuan";	
			
			public static const FEED_TYPE_KILL_BOSS_HOANG_SO:String 			= "WinBossHoangSo";	
			public static const FEED_TYPE_KILL_BOSS_HOANG_KIM:String 			= "KillBossHoangKim";	
			public static const FEED_TYPE_KILL_BOSS_HAN_THUY:String 			= "KillBossHanThuy";	
			public static const FEED_TYPE_OVER_HAC_LAM:String 					= "OverHacLam";	

			// Feed cho event đua top
			public static const FEED_TYPE_WAR_CHAMPION_1:String 			= "WarChampion1";			// Nhận thưởng may mắn trong ngày
			public static const FEED_TYPE_WAR_CHAMPION_2:String 			= "WarChampion2";			// Nhận thưởng giải ghi danh
			public static const FEED_TYPE_WAR_CHAMPION_3:String 			= "WarChampion3";			// Nhận thưởng giải top tuần
			public static const FEED_TYPE_WAR_CHAMPION_4:String 			= "WarChampion4";			// Nhận thưởng giải top tháng
			
			//Feed cho máy quay số
			public static const FEED_TYPE_LUCKY_MACHINE_MASKTUARUA:String = "LuckyMachineMaskTuaRua";	//nhận quà khủng nhất trong lucky machine
			public static const FEED_TYPE_LUCKY_MACHINE_MASKCHIENBINH:String = "LuckyMachineMaskChienBinh";	//nhận quà khủng nhất trong lucky machine
			public static const FEED_TYPE_LUCKY_MACHINE_CASHEN:String = "LuckyMachineMaskCaShen";	//nhận quà khủng nhất trong lucky machine
			public static const FEED_TYPE_LUCKY_MACHINE_EXP:String = "LuckyMachineExp";	//nhận quà khủng nhất trong lucky machine
			public static const FEED_TYPE_LUCKY_MACHINE_MONEY:String = "LuckyMachineMaterial";	//nhận quà khủng nhất trong lucky machine
			public static const FEED_TYPE_LUCKY_MACHINE_ENERGYITEM:String = "LuckyMachineEnergyItem";	//nhận quà khủng nhất trong lucky machine
			public static const FEED_TYPE_LUCKY_MACHINE_RANKPOINTBOTTLE:String = "LuckyMachineRankPointBottle";	//nhận quà khủng nhất trong lucky machine
			public static const FEED_TYPE_LUCKY_MACHINE_VUKHIVIP:String = "LuckyMachineVuKhiVip";	//nhận quà khủng nhất trong lucky machine
			
			//Event 8/3
			public static const FEED_TYPE_EVENT_8_3_JEWELRY:String 			= "Event8MarchJewelry";		
			public static const FEED_TYPE_EVENT_8_3_EQUIPMENT:String 			= "Event8MarchEquipment";		
			public static const FEED_TYPE_EVENT_8_3_LEVELUP:String 			= "Event8MarchLevelUp";	
			
			// tournament
			public static const FEED_TYPE_TOURNAMENT_GET_MASK:String 			= "TournamentMask";	
			public static const FEED_TYPE_TOURNAMENT_GET_GIFT:String 			= "TournamentGift";	
			
			// treasure island
			public static const FEED_TYPE_ISLAND_EXIT:String 			= "IslandExit";	
			public static const FEED_TYPE_ISLAND_GET_MEDAL:String 			= "IslandGetMedal";	
			public static const FEED_TYPE_ISLAND_GET_COLLECTION:String 			= "IslandGetCollection";	
			
			// special smithy
			public static const FEED_TYPE_SPECIAL_SMITHY_GIFT:String 			= "SpecialSmithyGift";		
			
			//Mid autumn
			public static const FEED_TYPE_AUTUMN_MEDAL_1:String = "AutumnMedal1";
			public static const FEED_TYPE_AUTUMN_MEDAL_2:String = "AutumnMedal2";
			public static const FEED_TYPE_AUTUMN_MEDAL_3:String = "AutumnMedal3";
			public static const FEED_TYPE_KISS_MOON:String = "KissMoon";
			
			//Boss server
			public static const FEED_TYPE_TOP_BOSS_SERVER:String = "TopBossServer";
			public static const FEED_TYPE_LASTHIT_BOSS_SERVER:String = "LastHitBossServer";
			
			//Feed kĩ năng chế đồ
			public static const FEED_TYPE_UPGRADE_SKILL_CREATE:String = "UpgradeSkillCreate";
		{	// Cái này bỏ sau
			// Store MixLake Name:
			public var MixLakeName:String;
			// Store Target Lake:
			public var TargetLake:Lake;
			// Store Fish Type for new fish feed:
			public var ColorLevel:int;
		}
		
			// feed Uy danh
			public static const FEED_TYPE_REPUTATION_UP_2:String 			= "ReputationUp2";
			public static const FEED_TYPE_REPUTATION_UP_3:String 			= "ReputationUp3";
			public static const FEED_TYPE_REPUTATION_UP_4:String 			= "ReputationUp4";
			public static const FEED_TYPE_REPUTATION_UP_5:String 			= "ReputationUp5";
			public static const FEED_TYPE_REPUTATION_UP_6:String 			= "ReputationUp6";
			public static const FEED_TYPE_REPUTATION_UP_7:String 			= "ReputationUp7";
			public static const FEED_TYPE_REPUTATION_UP_8:String 			= "ReputationUp8";
			public static const FEED_TYPE_REPUTATION_UP_9:String 			= "ReputationUp9";
			public static const FEED_TYPE_REPUTATION_UP_10:String 			= "ReputationUp10";
			public static const FEED_TYPE_REPUTATION_UP_11:String 			= "ReputationUp11";
			public static const FEED_TYPE_REPUTATION_UP_12:String 			= "ReputationUp12";
			public static const FEED_TYPE_REPUTATION_UP_13:String 			= "ReputationUp13";
			public static const FEED_TYPE_REPUTATION_UP_14:String 			= "ReputationUp14";
			public static const FEED_TYPE_REPUTATION_UP_15:String 			= "ReputationUp15";
			
			public static const FEED_TYPE_HALLOWEEN_VIP4:String 			= "HalloweenVip4";
			public static const FEED_TYPE_HALLOWEEN_FINISHMAP:String 			= "HalloweenFinishMap";
			
			public static const FEED_TYPE_TEACHER_EQUIP4:String 			= "EventTeacherEquip4";
			public static const FEED_TYPE_TEACHER_MATERIAL13:String 			= "EventTeacherMat13";
			
			//EventNoel
			public static const FEED_TYPE_NOEL_MATERIAL13:String 			= "EventNoelMaterial13";
			public static const FEED_TYPE_NOEL_SEAL3:String 			= "EventNoelSeal3";
			public static const FEED_TYPE_NOEL_SEAL4:String 			= "EventNoelSeal4";
			public static const FEED_TYPE_NOEL_SEAL6:String 			= "EventNoelSeal6";
			public static const FEED_TYPE_NOEL_EQUIPMENT4:String 			= "EventNoelEquipment4";
			public static const FEED_TYPE_NOEL_HAMMERPURPLE1:String 			= "EventNoelHammerPurple1";
			
			
			
			//fedd Trung linh thach
			public static const FEED_TYPE_UPDATE_QUARTZ:String 				= "UpdateQuartz";
			//Event Tet
			static public const FEED_TYPE_TET2013_GIFT_POINT:String = "EventTet2013GiftPoint";
			static public const FEED_TYPE_TET2013_COMBO:String = "EventTet2013Combo";
			
			static public const FEED_TYPE_LUCKYMACHINE_VIP:String = "EventLuckyMachineVip";
			static public const FEED_TYPE_LUCKYMACHINE_VIP_MAX:String = "EventLuckyMachineVipMax";
			
			
			
		// Store Fish Type for new fish feed:
		public var FishTypeId:int;
		
		/**
		 * Tao đối tượng
		 * @param	parent
		 * @param	imgName
		 * @param	x
		 * @param	y
		 * @param	isLinkAge
		 * @param	imgAlign
		 */
		public function GUIFeedWall(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			x = 240;
			y = 800;
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFeedWall";
		}
		
		/**
		 * Khởi tạo GUI
		 */
		public override function InitGUI(): void
		{
			var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			
			GameLogic.getInstance().MouseTransform("Windows");
			LoadRes("GUI_Feed");
			var Format:TextFormat;
			Format = new TextFormat("Arial", 17, 0xFFFFFF);
			
			var ButtonPos:Point = new Point();
			ButtonPos.y = 270;
			ButtonPos.x = 160;
			var ButtonGap:int = 100;
			
			Style.fontName = "Arial";
			Style.embedFonts = false;
			Style.fontSize = 14;
			
			// Add combo box chứa các câu feed
			ComboFeed = AddCombobox();
			ComboFeed.width = 313;
			ComboFeed.x = 165;
			ComboFeed.y = 63;
			// Add label hiện trong combo box lúc mới hiện lên
			ComboFeed.defaultLabel = Localization.getInstance().getString("FeedCombo");
			
			// TODO: Quick add event here. Put in Base Class later
			ComboFeed.addEventListener(Event.SELECT, OnComboChange);
			
			
			// Button ok (chia sẻ)
			OkButton = AddButton(GUI_FEED_OK, "BtnGreen", ButtonPos.x +120, ButtonPos.y, this);
			OkButton.img.scaleX = 1.8;
			OkButton.img.scaleY = 1.7;
			AddLabel("Chia sẻ", ButtonPos.x +112, ButtonPos.y-34).setTextFormat(Format);
			OkButton.SetEnable(true);
			
			// Button Cancel (bỏ qua)
			var CancelButton:Button = AddButton(GUI_FEED_CANCEL, "ButtonRed", ButtonPos.x + 120 + ButtonGap, ButtonPos.y, this);
			CancelButton.img.scaleX = 1.8;
			CancelButton.img.scaleY = 1.7;
			AddLabel("Bỏ qua", ButtonPos.x +112 + ButtonGap, ButtonPos.y-34).setTextFormat(Format);
			
			// Button Close
			var ButtonClose:Button = AddButton(GUI_FEED_CANCEL, "BtnThoat", ButtonPos.x + 280 +60, ButtonPos.y -267, this);
			//ButtonClose.img.scaleX = 0.7;
			//ButtonClose.img.scaleY = 0.7;
			
			// add avatar của người chơi
			AddImage("", GameLogic.getInstance().user.GetMyInfo().AvatarPic, 38 +40 - 17, 49 +10 , false, ALIGN_LEFT_TOP).SetSize(55, 55);		 
			
			// Hiện tên user người chơi
			var DisplayName:String = GameLogic.getInstance().user.GetMyInfo().Name;
			if (DisplayName.length > 12)
			{
				DisplayName = DisplayName.substr(0, 12) + "..";
			}
			var UserName:TextField = AddLabel(DisplayName, 38 +40 - 37, 49 +69);
			Format.color = 0x000000;
			Format.size = 12;
			UserName.setTextFormat(Format);
			
			// Textbox Comment - người chơi tự viết câu feed
			txtContent = AddTextBox(GUI_FEED_STRING, "something here", 105 + 27 + 40, 65 + 10 + 24, img.width/2 + 40, img.height/3 -50, this);
			//SetPos(img.stage.stageWidth / 2 - img.width / 2 + 25 - 20, img.stage.stageHeight / 2 - img.height / 2);
			SetPos(141, 162);
			var FeedContent:String = Localization.getInstance().getString("FeedMsg1");
			Format.size = 14;
			
			txtContent.SetDefaultFormat(Format);
			txtContent.SetText(FeedContent);
			txtContent.SetTextColor(0x000000);
			txtContent.textField.wordWrap = true;
			txtContent.textField.maxChars = 120;
			
			// Label - nhãn của mỗi loại feed
			//Title = AddLabel("Feed Wall", 100 + 27 +40, 37+4 - 21);
			Title = AddLabel("Feed Wall", 100 + 27 +40, 37+4 -2);
			
			// Content - cái chua vào thêm của với mỗi câu feed
			Content = AddLabel("Feed Content", 135 + 40, 140 + 30);
			//Content.border = true;
			Content.wordWrap = true;
			Content.width = 310;
			Content.height = 50;
			
			// Feed Icon - Vị trí mà ta sẽ add ảnh tương ứng với từng câu feed
			FeedIconPos = new Point(85 - 10 + 15, 190 - 10 + 30);	
			
			
			// khởi tạo dữ liệu
			ArrNumBox = [];
			InitData();
		}
		
		/**
		 * khi chọn 1 câu feed rồi thì lưu câu feed vào biến và enable nút
		 * thực hiện nhập câu mà user chọn vào textbox
		 * @param	e
		 */ 
		private function OnComboChange(e:Event):void 
		{
			txtContent.SetText(ComboFeed.selectedItem as String);
			OkButton.SetEnable(true);
		}
		
		/**
		 * thiết lập lại fishtype của con cá
		 * @param	type
		 */ 
		public function SetFishType(type:int):void
		{
			FishTypeId = type;
		}
		
		/**
		 * Hàm thực hiện show thông tin lên GUI
		 * @param	Type		: Kiểu feed
		 * @param	ItemName	: Tên của đối tượng Ex: Cá mòi, Cá mặt trời ...
		 * @param	QuestName	: Tên của seriquest: làm quen myFish, kỹ năng lai cá vượt cấp...
		 */
		public function ShowFeedOld(Type:String, ItemName:String = "", QuestName:String = "", imageNamw:String = ""):void
		{			
			var myInfo:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
			if (Type == FEED_TYPE_MATERIAL_3 || Type == FEED_TYPE_MIX_OVER_LEVEL || Type == FEED_TYPE_JOIN_EVENTS)
				if (myInfo.FeedInfo[Type] && myInfo.FeedInfo[Type] > 0)
					return;
			super.Show(Constant.TopLayer - 2, 3);
			if(GameLogic.getInstance().gameState!=GameState.GAMESTATE_INIVTE_FRIEND) //hiepga
				GameLogic.getInstance().BackToIdleGameState();
			var imageName:String;
			super.Show(Constant.GUI_MIN_LAYER, 3);
			var st:String;
			var imgName:String;
			 //Determine the Content of the feed:
			FeedType = Type;
			PrepareShowFeed(Type, ItemName, QuestName);
		} 
		
		/**
		 * Hàm thiết lập các trường cần khi show feed
		 * @param	Type		: Kiểu feed
		 * @param	item_name	: Tên đối tượng thu được Ex: Cá mòi
		 */ 
		private function PrepareShowFeed(Type:String, item_name:String = "", QuestName:String = ""):void
		{
			InitData();
			UpdateData(Type);
			var imgName:String;
			imgName = ArrNumBox[Type]["ImageName"];
			FeedIcon = AddImage(GUI_FEED_ICON, imgName, FeedIconPos.x + ArrNumBox[Type]["FeedIconX"], FeedIconPos.y + ArrNumBox[Type]["FeedIconY"]);
			FeedIcon.FitRect(110, 110, new Point(FeedIconPos.x - 59, FeedIconPos.y - 58));

			var NumElementInCombo:int = ArrNumBox[Type]["NumComboBox"];
			// Label của dạng feed
			Title.text = Localization.getInstance().getString("FeedTitle" + Type);
			
			var version:int = Math.ceil(Math.random() * NumElementInCombo);
			txtContent.SetText(Localization.getInstance().getString("FeedMsg" + Type + "v" + version.toString()));
			ComboFeed.defaultLabel = txtContent.GetText();
			
			// Add các câu trong combobox
			for (var i:int = 1; i <= NumElementInCombo; i++) 
				ComboFeed.addItem(Localization.getInstance().getString("FeedMsg" + Type + "v" + i.toString()));
			ComboFeed.numVisibleItems = NumElementInCombo;
			
			// Add câu chua thêm vào
			var st:String = Localization.getInstance().getString("FeedContent" + Type);
			st = st.replace("@User", GameLogic.getInstance().user.GetMyInfo().Name);
			if (item_name != "")
			{
				st = st.replace("@ItemName", item_name);
				ItemNameSend = item_name;
			}
			if (QuestName != "" && st.indexOf("@Level") != -1)
			{
				st = st.replace("@Level", QuestName);
			}
			Content.text = st;
			
			//Quest name: cần trong trường hợp muốn gửi tên seriquest lên
			QuestNameSend = QuestName;
			
			// Cập nhật lại số lần feed
			var myInfo:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
			if (myInfo.FeedInfo[Type])	myInfo.FeedInfo[Type]++
			else 	myInfo.FeedInfo[Type] = 1;
		}
		
		public function ShowFeed(Type:String, itemName:String = "", QuestName:String = "", imageNamw:String = "", kindOfFeed:int = 3):void 
		{
			//nếu trong event trung thu
			//if (EventMgr.CheckEvent("MidMoon") == EventMgr.CURRENT_IN_EVENT)
			//{
				if (Type == FEED_TYPE_REMIND_FRIEND)
				{
					var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
					var today:String = date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString();
					var so:SharedObject = SharedObject.getLocal("EventMidAutumn_PressRemind" + GameLogic.getInstance().user.GetMyInfo().Id);
					var data:Object;
					if (so.data.uId != null)
					{
						data = so.data.uId;
					}
					else
					{
						data = new Object();
						so.data.uId = data;
					}
					data.RestrictFeed = FEED_TYPE_REMIND_FRIEND;
					data.lastTimeFeed = GameLogic.getInstance().CurServerTime;
					data.lastday = today;
					Ultility.FlushData(so);
					trace("đã feed và ghi vào shareObject và đổi sang nút mua");
					GuiMgr.getInstance().guiFrontEvent.changeRemindToBuy();
					//GuiMgr.getInstance().GuiChangeBirthDayGift.changeRemindToBuy();
				}
			//}
			
			InitData();
			UpdateData(Type);
			SaveFeed(Type);				//nếu là invite friend thì lưu lại thời điểm feed
			var user:User = GameLogic.getInstance().user;
			var userIdFrom:int = user.GetMyInfo().Id;
			var userIdTo:int = 0;
			var actionId:int = 1;
			var tplId:int = kindOfFeed;
			var object_Id:String = "";
			// Câu thể hiện tiêu đề của feed
			var attack_name:String = Localization.getInstance().getString("FeedTitle" + Type);
			// Đường link đến game khi click vào attack_name
			var attack_href:String = LINK_GAME;
			//var attack_href:String = "";
			// Tên mô tả game
			var attack_Caption:String = TYPE_GAME;	// myFish duoi dong tieu de tren tuong khong co linh
			//var attack_Caption:String = NewFeedWall.LINK_FISH + TYPE_GAME + NewFeedWall.LINK_FISH_END;
			// Dòng mô tả chi tiết hành động của user
			var attack_Description:String = Localization.getInstance().getString("FeedContent" + Type);
			attack_Description = attack_Description.replace("@User", GameLogic.getInstance().user.GetMyInfo().Name);
			// Còn đoạn dán link vào chữ myFish và THÍCH sẽ giải quyết sau
			if (itemName != "")
			{
				attack_Description = attack_Description.replace("@ItemName", itemName);
			}
			if (QuestName != "" && attack_Description.indexOf("@Level") != -1)
			{
				attack_Description = attack_Description.replace("@Level", QuestName);
			}
			
			// loại hình ảnh, hiện tại gán là 1 - tức là có dạng 1 ảnh
			var media_type:int = MEDIA_TYPE;
			//var media_Image:String =  NewFeedWall.LINK_IMAGE + ArrNumBox[Type]["ImageName"];
			// link ảnh đưa lên
			var media_Image:String =  NewFeedWall.LINK_IMAGE + Localization.getInstance().getString("FeedIcon" + Type);
			// Link vào game gán vào ảnh
			var media_source:String = LINK_GAME;
			var action_Link_Text:String = TYPE_GAME;
			var action_Link_Href:String = LINK_GAME;
			// Chọn các câu mặc định
			var NumElementInCombo:int = ArrNumBox[Type]["NumComboBox"];
			var Suggestion:Array = new Array();
			for (var i:int = 1; i <= NumElementInCombo; i++) 
				Suggestion.push(Localization.getInstance().getString("FeedMsg" + Type + "v" + i.toString()));
			
			var FeedItem:NewFeedWall = NewFeedWall.GetInstance();
			FeedItem.OpenFeedItem(userIdFrom, userIdTo, actionId, tplId, object_Id, attack_name, attack_href, attack_Caption, attack_Description,
				media_type, media_Image, media_source, action_Link_Text, action_Link_Href, Suggestion);
			Exchange.GetInstance().Send(new SendSignKey(FeedItem));
			
		}
		
		public override function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void
		{
			switch(txtID)
			{
				case GUI_FEED_STRING:
					var txt: String = StringUtil.trim(txtContent.GetText());
					if (txt != "")
					{
						OkButton.SetEnable(true);
					}
					else
					{
						OkButton.SetEnable(false);
					}
				break;
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case GUI_FEED_OK:
					Feed();
					if (GameLogic.getInstance().gameState == GameState.GAMESTATE_INIVTE_FRIEND)
					{
						//thực hiện lưu lại người feed và thời điểm feed.
						GuiMgr.getInstance().GuiFriends.SavedFeed();
					}
					GameLogic.getInstance().BackToIdleGameState();
					break;
				case GUI_FEED_CANCEL:
					if (GameLogic.getInstance().gameState == GameState.GAMESTATE_INIVTE_FRIEND)
					{
						GameLogic.getInstance().gameState = GameState.GAMESTATE_IDLE;
					}
					Hide();		
					break;
				default:
					break;
			}
		}
		/**
		 * Ẩn GUI và một số thứ liên quan
		 */
		private function HideGUI():void 
		{
			Hide()
			GameLogic.getInstance().MouseTransform();
			ComboFeed.removeEventListener(Event.SELECT, OnComboChange);
		}
		/**
		 * Cập nhật các tham số cần để truyền lên server
		 */
		private function UpdateDataUpload():void 
		{
			IconSend = Localization.getInstance().getString("FeedIcon" + FeedType);
			if (FeedType == FEED_TYPE_MIX_OVER_LEVEL || FeedType == FEED_TYPE_NEW_FISH)	IconSend = "Fish" + FishTypeId.toString() + ".png";
			if (FeedType == FEED_TYPE_GET_GIFT_EVENTS)	
			{
				IconSend = GuiMgr.getInstance().GuiTreasureGift.IconFeed 
				if(IconSend != "Ornament")
					IconSend = IconSend + ".png";
				else 
					IconSend = IconSend + ".PNG";
			}
		}
		/**
		 * Hàm xử lý gói tin
		 */
		private function Feed():void
		{
			UpdateDataUpload();
			var feedType:String = FeedType.split("@")[0];//cắt hậu tố "@ + chỉ số" đi
			GameLogic.getInstance().ProcessFeedWall(txtContent.GetText(), feedType, IconSend, ItemNameSend, QuestNameSend);
			HideGUI();
			
			
		}
		/**
		 * Một số tham số đặc biệt mà không khởi tạo được bằng InitData()
		 * @param	Type
		 */
		private function UpdateData(Type:String):void 
		{			
			try
			{
				if(ArrNumBox[Type]["ImageName"] == "Fish")
				{
					ArrNumBox[Type]["ImageName"] = Fish.ItemType + FishTypeId + "_" + Fish.OLD + "_" + Fish.HAPPY;
				}
				if (Type == FEED_TYPE_GET_GIFT_EVENTS)	
				{
					ArrNumBox[Type]["ImageName"] = GuiMgr.getInstance().GuiTreasureGift.IconFeed;
				}
			}
			catch (e:Error)
			{
				trace("bug vkl khi feed. FeedType: ", Type);
			}
		}
		/**
		 * Hàm khởi tạo các tham số cần thiết cho Feed
		 */
		private function InitData():void 
		{
			ArrNumBox = [];
			for (var i:int = 0; i < NUM_TYPE_FEED;) 
			{
				i++;
				var type_feed:String = Localization.getInstance().getString("FeedType" + i.toString());
				ArrNumBox[type_feed] = new Array();
				ArrNumBox[type_feed]["NumComboBox"] = int(Localization.getInstance().getString("FeedNum" + type_feed));
				ArrNumBox[type_feed]["ImageName"] = Localization.getInstance().getString("FeedIconGUI" + type_feed);
			}
		}
		
		public override function OnHideGUI():void
		{
			if (FeedType.split("@")[0] == "completeSkillQuest"
				|| 	FeedType.split("@")[0] == FEED_TYPE_SQ_FINISH2)
			{
				//hiển thị phần thưởng của những seriquest đã hoàn thành nhưng còn trong hàng đợi
				var questArr:Array = QuestMgr.getInstance().finishedQuest;
				if (questArr.length > 0)
				{
					GameLogic.getInstance().OnQuestDone(questArr[0]);		
					questArr.splice(0, 1);
				}
			}
		}
		

		private function SaveFeed(Type:String):void
		{
			if (GameLogic.getInstance().gameState == GameState.GAMESTATE_INIVTE_FRIEND)
			{
				//thực hiện lưu lại người feed và thời điểm feed.
				GuiMgr.getInstance().GuiFriends.SavedFeed();
			}
			if (Type == FEED_TYPE_REMIND_FRIEND)
			{
				var so:SharedObject = SharedObject.getLocal("SavedSetting");
				var data:Object;
				if (so.data.uId != null)
				{
					data = so.data.uId;
				}
				else
				{
					data = new Object();
					so.data.uId = data;
				}
				data.RestrictFeed = FEED_TYPE_REMIND_FRIEND;
				data.lastTimeFeed = GameLogic.getInstance().CurServerTime;
			}
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			{
				return;
			}
			GameLogic.getInstance().BackToIdleGameState();
			
		}
	}
}

