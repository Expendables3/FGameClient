package Logic 
{
	import adobe.utils.CustomActions;
	import com.adobe.serialization.json.JSON;
	import com.adobe.utils.DictionaryUtil;
	import com.adobe.utils.NumberFormatter;
	import com.adobe.utils.StringUtil;
	import com.bit101.charts.PieChart;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.plugins.FilterPlugin;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Data.QuestINI;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImageEffect;
	import Effect.ImgEffectBlink;
	import Effect.ImgEffectFly;
	import Effect.Rippler;
	import Effect.SwfEffect;
	import Event.BaseEvent;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventLuckyMachine.EventLuckyMachineMgr;
	import Event.EventMgr;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import Event.EventTeacher.EventTeacherMgr;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Factory.FactoryLogic.EventUtils;
	import flash.accessibility.Accessibility;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.sampler.NewObjectSample;
	import flash.system.Security;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	import GameControl.*;
	import GUI.*;
	import Data.ResMgr;
	import GUI.BossServer.Soldier;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.component.ActiveTooltip;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.SpriteExt;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.Event8March.GUIChangeFlower;
	import GUI.Event8March.GUIFlowerGuide;
	import GUI.Event8March.TooltipFlower;
	import GUI.Event8March.TooltipTree;
	import GUI.EventBirthDay.EventGUI.BirthdayCandle;
	import GUI.EventBirthDay.EventGUI.GUIBlowCandle;
	import GUI.EventBirthDay.EventGUI.GUIGuideBirthday;
	import GUI.EventBirthDay.EventGUI.ItemBirthDayGift;
	import GUI.EventBirthDay.EventGUI.TooltipBirthDayGift;
	import GUI.EventBirthDay.EventGUI.TooltipCandle;
	import GUI.EventBirthDay.EventLogic.BirthDayItemMgr;
	import GUI.EventBirthDay.EventLogic.MagicLampMgr;
	import GUI.EventMagicPotions.BossHerb;
	import GUI.EventMagicPotions.NetworkPacket.SendGetHerbList;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.FishWar;
	import GUI.FishWorld.Boss;
	import GUI.FishWorld.BossMgr;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.ForestWorld.Thicket;
	import GUI.FishWorld.GUIMixFormulaInfo;
	import GUI.FishWorld.SubBossIce;
	import GUI.FishWorld.SubBossMetal;
	import GUI.GUIFrontScreen.GUIUserInfo;
	import GUI.GuiGetStatus.SendGetStatus;
	import GUI.Mail.SystemMail.Controller.MailMgr;
	import GUI.MainQuest.GUIIntroduceFeature;
	import GUI.MainQuest.GUIMainQuest;
	import GUI.MainQuest.GUISeriesQuest;
	import GUI.TrainingTower.TrainingLogic.TrainingMgr;
	import GUI.GUIFrontScreen.GUIFrontScreen;
	import GUI.TrungLinhThach.TrungLinhThachMgr;
	import Logic.EventNationalCelebration.FireworkFish;
	import NetworkPacket.PacketReceive.GetBuyMixBox;
	import Math;
	import NetworkPacket.PacketReceive.GetCleanLake;
	import NetworkPacket.PacketReceive.GetFishing;
	import NetworkPacket.PacketReceive.GetInitRun;
	import NetworkPacket.PacketReceive.GetLevelUp;
	import NetworkPacket.PacketReceive.GetMateFish;
	import NetworkPacket.PacketReceive.GetMixFish;
	import NetworkPacket.PacketReceive.GetRefreshFriend;
	import NetworkPacket.PacketReceive.GetUpgradeMixLake;
	import NetworkPacket.PacketSend.ExtendDeco.SendExpiredDeco;
	import NetworkPacket.PacketSend.SendAcceptGift;
	import NetworkPacket.PacketSend.SendBuyBackGround;
	import NetworkPacket.PacketSend.SendBuyDecorate;
	import NetworkPacket.PacketSend.SendBuyEquipment;
	import NetworkPacket.PacketSend.SendBuyFish;
	import NetworkPacket.PacketSend.SendBuyOther;
	import NetworkPacket.PacketSend.SendBuySpecialFish;
	import NetworkPacket.PacketSend.SendCareFish;
	import NetworkPacket.PacketSend.SendCleanLake;
	import NetworkPacket.PacketSend.SendClickGrave;
	import NetworkPacket.PacketSend.SendCollectMoney;
	import NetworkPacket.PacketSend.SendCompleteDailyQuest;
	import NetworkPacket.PacketSend.SendCureFish;
	import NetworkPacket.PacketSend.SendFeedFish;
	import NetworkPacket.PacketSend.SendFeedWall;
	import NetworkPacket.PacketSend.SendGetAllSoldier;
	import NetworkPacket.PacketSend.SendGetBuffLake;
	import NetworkPacket.PacketSend.SendGetDailyQuest;
	import NetworkPacket.PacketSend.SendGetDailyQuestNew;
	import NetworkPacket.PacketSend.SendGetSeriesQuest;
	import NetworkPacket.PacketSend.SendGetTotalFish;
	import NetworkPacket.PacketSend.SendHitEgg;
	import NetworkPacket.PacketSend.SendInitRun;
	import NetworkPacket.PacketSend.SendLevelUp;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import NetworkPacket.PacketSend.SendMakeWish;
	import NetworkPacket.PacketSend.SendMateFish;
	import NetworkPacket.PacketSend.SendMixRequest;
	import NetworkPacket.PacketSend.SendMoveDecorate;
	import NetworkPacket.PacketSend.SendOpenMagicBag;
	import NetworkPacket.PacketSend.SendRebornSoldier;
	import NetworkPacket.PacketSend.SendRebornXFish;
	import NetworkPacket.PacketSend.SendRecoverHealthSoldier;
	import NetworkPacket.PacketSend.SendRefreshFriend;
	import NetworkPacket.PacketSend.SendRequestDailyGift;
	import NetworkPacket.PacketSend.SendRemoveMessage;
	import NetworkPacket.PacketSend.SendSellDecorate;
	import NetworkPacket.PacketSend.SendSellFish;
	import NetworkPacket.PacketSend.SendSellSparta;
	import NetworkPacket.PacketSend.SendSellStockThing;
	import NetworkPacket.PacketSend.SendSetLog;
	import NetworkPacket.PacketSend.SendStealMoney;
	import NetworkPacket.PacketSend.SendStoreItem;
	import NetworkPacket.PacketSend.SendUnlockLake;
	import NetworkPacket.PacketSend.SendUpdateSparta;
	import NetworkPacket.PacketSend.SendUpgradeLake;
	import NetworkPacket.PacketSend.SendUpgradeMixLake;
	import NetworkPacket.PacketSend.SendUseItem;
	import NetworkPacket.PacketSend.SendRemoveMessage;
	import NetworkPacket.PacketSend.SendUseBabyFish;
	import NetworkPacket.PacketSend.SendUseItem;
	import NetworkPacket.PacketSend.SendUsePetrol;
	import NetworkPacket.PacketSend.SendUseRankPointBottle;
	import NetworkPacket.PacketSend.SendUseViagra;
	import particleSys.myFish.CometEmit;
	import particleSys.myFish.ExplodeEmit;
	import particleSys.sample.WaterFallEmit;
	import Sound.SoundMgr;
	
	
	
	
	/**
	 * Lớp xử lý logic chung của game
	 * @author tuan
	 */
	
	import Math;	

	public class GameLogic
	{
		[Embed(source='../../lib/font/Sansation_Bold.ttf', fontName = 'SansationBold', fontWeight = 'bold')]		
		//[Embed(source='../../lib/font/Sansation_Bold.ttf',fontName = 'SansationBold', fontWeight = 'bold', embedAsCFF='false')]	// for FLEX 4
		public var font1:String;
		
		[Embed(source='../../lib/font/Sansation_Regular.ttf', fontName = 'SansationRegular')]
		//[Embed(source='../../lib/font/Sansation_Regular.ttf', fontName = 'SansationRegular', embedAsCFF='false')]			// for FLEX 4
		public var font2:String;
		
		[Embed(source='../../lib/font/HappyKiller.ttf', fontName = 'HappyKiller')]
		//[Embed(source='../../lib/font/HappyKiller.ttf', fontName = 'HappyKiller', embedAsCFF='false')]			// for FLEX 4
		public var font3:String;
		
		[Embed(source='../../lib/font/myFish.ttf', fontName = 'myFish')]
		//[Embed(source='../../lib/font/myFish.ttf', fontName = 'myFish', embedAsCFF='false')]			// for FLEX 4
		public var font4:String;
		
		private static var instance:GameLogic = new GameLogic;
		
		public var gameState:int = GameState.GAMESTATE_INIT;
		public var gameMode:int = GameMode.GAMEMODE_NORMAL;
		public var user:User = new User; 
		public var cursor:MovieClip;
		public var cursorImg:String;
		public var DeltaMousePos:Point = new Point(0,0);
		public var PanInterval:int = 0;
		
		public var ServerTime:Number;
		public var CurServerTime:Number; //Thời gian hiện tại của server(tính theo giây)
		private var CurClientTime:Number;
		private var date:Date = new Date(0);

		private var OldMouseName:String;
		private var OldMouseScale:Number;
		private var OldMouseRotate:Number;
		
		public var balloonArr:Array = [];

		// Effect
		public var swfEffClean:SwfEffect;
		public var swfEffFood:SwfEffect;
		public var swfEffHatchArr:Array = [];
		public var swfEffCureFishArr:Array = [];
		
		// List chứa thức ăn đã được rắc
		public var ListFood:Array = [];
		
		//Thong tin log
		public var log:LogInfo = new LogInfo();
		
		public var CenterHerd: Point;
		public var CountHerd:int = 0;
		public var NumMaxFish:int = 6;
		private var arrFish:Array = [];
		public var FishingDataReceive:Boolean = false;
		public var dataFishing:Object;
		public var finishFishing:Boolean = false;
		
		public var emitStar:Array = [];		
		public var arrPrgProcess:Array = [];		
		public var arrPrgStatusProcess:Array = [];		
		public var arrPrgTypeProcess:Array = [];		
		
		public var isEventDuplicateExp:Boolean = false;
		// Kết quả chọi cá
		public var fw:FishWar = null;
		public var FishWarScene:Array = [];
		public var FishWarBonus:Array = [];
		public var FishWarPenalty:Object = null;
		public var myAtkFish:FishSoldier = null;
		public var IsWin:int = -1;
		public var GraveBonus:Array = [];
		public var PrgGraveList:Array = [];
		public var GraveList:Array = [];
		public var isAttacking:Boolean = false;
		public var EffectInFishList:Array = [];
		public var LastEffectMine:Number = 0;
		public var LastEffectTheirs:Number = 0;
		public var isWinNowByBolt:Boolean = false;
		
		// Item buff đang sử dụng
		public var curItemUsed:String;
		
		// Tên người chơi vừa thắng Boss
		public var WinBossUser:String;
		public var LastTimeKillBoss:Number = -1;
		
		// Progress bar
		public var ProgressList:Array = [];
		
		// Mảng chứa các timer
		public var arrMyTimer:Array = [];
		
		//Event 2-9
		public var arrDragonBall:Array = [];
		public var endEff:Boolean = false;
		public var wishRespond:Boolean = false;
		public var itemType:String;
		public var itemId:int;
		public var itemNum:int;
		//sử dụng rankPointBottle
		public var idFishUseRPB:int = -1;
		public var curFishUseRankPoint:Object;
		//offline nhận kinh nghiệm
		public var totalTimeOffline:Number;
		
		//Dữ liệu quà đổi đc Collection
		public var equipment:Object;
		//vien chinh
		private var isFirstForExpedition:Boolean=false;
		//Thông báo hoàn thành bộ sưu tập
		public var completedCollection:Object =
		{
			Weapon: { Exp1:false, Money1:false, ItemTrunk1:false, ItemTrunk2:false, ItemTrunk3:false },
			Armor: { Exp1:false, Money1:false, ItemTrunk1:false, ItemTrunk2:false, ItemTrunk3:false },
			Helmet: { Exp1:false, Money1:false, ItemTrunk1:false, ItemTrunk2:false, ItemTrunk3:false },
			FishWorld: {Exp1:false, Money1:false, ItemTrunk1:false, ItemTrunk2:false}
		}
		public var dropItemCollection:Boolean = false;
		public var bonusFishWorld:Object;
		public var datReceiveForest:Object;
		
		// Check thời gian boss thảo dược xuất hiện
		public var TimeAppearArr:Array = [];
		
		// Các biến dành cho thế giới Mộc
		// Các biến dành cho biển đỏ của thế giới mộc
		public var arrSenceForest:Array = [];
		//HiepNM2 CodeString
		public var CodeString:String = "";
		
		public var countNumEffHoiSinh:int = 0;
		public var efRound3ForestSea:SwfEffect = null;
		
		public var isFighting:Boolean = false;
		//Mang ca linh BossServer
		public var arrSoldier:Array = [];
		
		public var curRankPoint:int = 0;
		public var isUseRPfinish:Boolean = false;
		public var midMoonData:Object;
		public var numMedalHalloween:int = 0;
		public var serverBossTop:String;
		public var serverBossLastHit:String;
		public var serverBossId:int;
		
		public var userGetVipMax:String;
		//public var energyMachine:EnergyMachine;
		/**
		 * Lấy một thể hiện chung của lớp GameLogic
		 * <br>Thể hiện này mang tính chất gần như 1 biến toàn cục </br>
		 */
		public static function getInstance():GameLogic
		{
			if(instance == null)
			{
				instance = new GameLogic();
			}
				
			return instance;
		}
		
		/**
		 * Phương thức khởi tạo mặc định
		 */
		public function GameLogic() 
		{
			
		}
		
		private var TestCount:int = 0;
		private var OldTool:String = "";
		private function TestTool():void
		{
			var st:String = "";
			if (user.FriendArr.length > 0)
			{
				var tg:int = Ultility.RandomNumber(0, user.FriendArr.length - 1);
				var friend:Friend = user.FriendArr[tg] as Friend;
				st = "GoToLake_1_" + friend.ID;
			}
			//var Tools:Array = ["EditDecorate", "Shop", "Inventory", st];
			var Tools:Array = ["Shop", st];
			TestCount++;
			if (TestCount >= 10)
			{
				switch (OldTool)
				{
					case "Shop":
					case "Inventory":
						GameController.getInstance().UseTool(OldTool);
						GameController.getInstance().UseTool("Default");
						break;
						
					default:
						GameController.getInstance().UseTool("Default");
						break;
				}
				
				var rnd:int = Ultility.RandomNumber(0, Tools.length-1);
				GameController.getInstance().UseTool(Tools[rnd]);
				TestCount = 0;
				OldTool = Tools[rnd];
			}
		}
				
		/**
		 * Phương thức khởi tạo
		 * Các thuộc tính của lớp GameLogic nên được khởi tạo ở đây
		 */
		public function InitLogicGame(LakeID:int, Data1:Object):void
		{
			// clear old data
			Reset();
			
			// bo man hinh wating di
			GuiMgr.getInstance().GuiWaitingData.Hide();
			
			// get new data
			var data:GetInitRun = new GetInitRun(Data1);
			if (data.Error == 145)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowInTournament(data.timeRemain);
				GameLogic.getInstance().HideFish(true);
				return;
			}
			
			//init time
			ServerTime = CurServerTime = data.SystemTime;
			CurClientTime = getTimer();
			
			// neu la lan dau tien dang nhap thi load danh sach ban be
			
			// Khởi tạo nhà luôn là trạng thái hòa bình
			GameController.getInstance().UseTool("Peace");
			
			//đã trả về false khi kết thúc event mời bạn
			if (user.GetMyInfo().Id < 0)
			{
				var friendlist: SendRefreshFriend = new SendRefreshFriend(false);
				Exchange.GetInstance().Send(friendlist);	
			}
			
			// du lieu user
			user.SetInfo(data.User);
			user.GetMyInfo().UserName = Data1["Username"];
			/*data for LuckyMachine*/
			
			if (!user.IsViewer())
			{
				
				//user.GetMyInfo().initTicket(data);
				//user.GetMyInfo().initGiftTicket(data);
				
				var objVar:Object = user.GetMyInfo().getDataForLM(Data1);
				GuiMgr.getInstance().guiDigitWheel.Floor = objVar["Floor"];
				GuiMgr.getInstance().guiDigitWheel.CurGiftType = objVar["ItemType"];
				GuiMgr.getInstance().guiDigitWheel.CurGiftLevel = objVar["LevelGift"];
				GuiMgr.getInstance().guiDigitWheel.CurTicketType = objVar["TicketType"];
				GuiMgr.getInstance().guiDigitWheel.CountPlay2 = objVar["Play_Limit_2"];
				GuiMgr.getInstance().guiDigitWheel.CountPlay10 = objVar["Play_Limit_10"];
			}
			//Xử lý cross-domain				
			ResMgr.getInstance().loadPolicyFile(user.AvatarPic);
			
			user.ShowFishMachineButton();				//kiểm tra xem có show cái button hút cá không?
			user.ShowMapOceanButton();
			//Update thong tin level skill
			//GuiMgr.getInstance().GuiTopInfo.updateSkillInfo();
			//if (GuiMgr.getInstance().GuiTopInfo.btnExQuestHelp && GuiMgr.getInstance().GuiTopInfo.btnExQuestHelp.img)
			//{
				//GuiMgr.getInstance().GuiTopInfo.btnExQuestHelp.img.visible = true;
			//}
			
			if (!user.IsViewer())
			{
				if (Main.uId != 0 && Main.uId != user.GetMyInfo().Id)
				{
					var url:URLRequest = new URLRequest("http://login.me.zing.vn/login/logout");
					navigateToURL(url, "_self");
				}
			}
			
			// init decorate array
			user.InitDecoArray(data.Item);	

			
			//Init kho
			if (!user.IsViewer())
			{
				user.InitStore(data.Store);
			}
			//khởi tạo cây event 8/3
			if (data["EventList"])
			{
				
				// Cập nhật dữ liệu cho event 
				if(EventMgr.CheckEvent("PearFlower") == EventMgr.CURRENT_IN_EVENT)
				{
					if (data["EventList"]["PearFlower"])
					{
						ProgessEventPearFlower(data["EventList"]["PearFlower"]);
					}
				}
				if(EventMgr.CheckEvent("TreasureIsland") == EventMgr.CURRENT_IN_EVENT)
				{
					if (data["EventList"]["TreasureIsland"])
					{
						GuiMgr.getInstance().guiTreasureIsLand.userData = data.EventList.TreasureIsland;
					}
				}
				
				if (data["EventList"]["MidMoon"] != null)
				{
					midMoonData = data["EventList"]["MidMoon"];
				}
				if (!user.IsViewer())
				{
					var eventStore:Object = data["Store"]["StoreList"]["EventItem"]["Hal2012"];
					HalloweenMgr.getInstance().initItemHalloween(eventStore);
					var curEvent:Object = data["EventList"]["Hal2012"];
					if (curEvent)
					{
						HalloweenMgr.getInstance().LastDatePlay = curEvent["LastDatePlay"];
						HalloweenMgr.getInstance().IsLockHalloween = !curEvent["InMap"];
						HalloweenMgr.getInstance().LastTimeLock = curEvent["BeginWait"];
						HalloweenMgr.getInstance().RemainPlayCount = curEvent["RemainPlayCount"];
					}
				}
				//Event bắn cá
				/*if(EventMgr.CheckEvent(EventMgr.NAME_EVENT) == EventMgr.CURRENT_IN_EVENT)//init cho cái cây
				{
					if (!user.IsViewer())
					{
						if (data["EventList"][EventMgr.NAME_EVENT])
						{
							EventNoelMgr.getInstance().StartTimeGame = data["EventList"][EventMgr.NAME_EVENT]["FireFish"]["StartTime"];
							EventNoelMgr.getInstance().LastTimeFinish = data["EventList"][EventMgr.NAME_EVENT]["FireFish"]["FinishTime"];
							EventNoelMgr.getInstance().NumPlay = data["EventList"][EventMgr.NAME_EVENT]["FireFish"]["NumPlay"];
						}
						
						EventSvc.getInstance().logTime = CurServerTime;
						EventSvc.getInstance().initData(data["Store"]["StoreList"]["EventItem"][EventMgr.NAME_EVENT]);
					}
					/*if (data["EventList"][EventMgr.NAME_EVENT])
					{
						user.initCoralTree(data["EventList"][EventMgr.NAME_EVENT]);
					}
				}*/
				if (EventUtils.checkInShocksNoel())
				{
					if (!user.IsViewer())
					{
						user.initShocksNoel(null);
					}
				}
				if (EventMgr.CheckEvent(EventMgr.NAME_EVENT) == EventMgr.CURRENT_IN_EVENT)
				{
					EventLuckyMachineMgr.getInstance().initData(Data1);
				}
			}
			user.InitFish(data.Lake1.FishList, data.Lake1.Id);
			user.InitFishSoldier(data.Lake1.FishList, data.Lake1.Id);
			//user.InitBossHerb();
			user.InitGrave(data.Lake1.Grave, data.Lake1.Id);	
			
			// init mixlake array
			user.InitMixLake();
			
			// init thong tin ho
			user.InitLake();
			user.CurLake = user.GetLake(LakeID);
			user.CurLake.SetInfo(data.Lake1);
			user.CurLake.NumFish = user.GetFishArr().length - user.CurLake.TotalEgg;			
			user.CurLake.NumSoldier = user.GetFishSoldierArr().length;
			
			if (data.SpecialItem)
			{
				user.FishArrSpartan = [];
				user.FishArrSpartanDeactive = [];
				
				//Xóa dữ liệu firework fish cũ
				user.arrFireworkFish = new Array();
				
				for (var iSpecialItem:String in data.SpecialItem) 
				{
					switch (iSpecialItem) 
					{
						//Khởi tạo cá pháo hoa event 2-9
						case "Firework":
							//user.initFireworkFish(data.SpecialItem["Firework"], LakeID);
							break;
						case "Santa":
							user.initFireworkFish(data.SpecialItem["Santa"], LakeID);
							break;
						default:	// Khởi tạo hình ảnh cho con cá sparta va swat
							user.InitFishSpartan(data.SpecialItem[iSpecialItem], data.Lake1.Id, iSpecialItem);
							break;
					}
				}
				//khởi tạo máy energyMachine nếu có
				if (data.User.SpecialItem)
				{
					if (data.User.SpecialItem.EnergyMachine)//trong trường hợp server trả về là có máy giới hạn nlg
					{
						user.initEnergyMachine(data.User.SpecialItem.EnergyMachine);
						if (!user.IsViewer())
						{
							user.GetMyInfo().energyMachine.UpdateEnergyMachine(true);
						}
						else
						{
							user.energyMachine.UpdateEnergyMachine(false);
						}
					}
				}
			}
			
			GuiMgr.getInstance().GuiMain.UpdateInfo();			
			user.UpdateDirtyArray(true);
			
			//GuiMgr.getInstance().GuiTopInfo.UpdateAvatar(user.AvatarPic);
			GuiMgr.getInstance().GuiMain.RefreshGUI();
			
			// Add mouse
			MouseTransform("");
			
			// lock neu la user
			GameController.getInstance().LockViewerUser();
			
			//GuiMgr.getInstance().GuiTopInfo.UpdateGUI();
			var isViewer:Boolean = GameLogic.getInstance().user.IsViewer();
			if (!isViewer)
			{	
				//set nhung thong tin chi co o nha minh				
				user.setUserProfile(data.UserProfile);
				user.Notification = data.Notification;
				//user.Notification = null;
				user.GetMyInfo().LastInitRun = data.SystemTime;
				//user.GetMyInfo().PowerTinhQuest = data.PowerTinhQuest;
				QuestMgr.getInstance().InitQuestPowerTinh(data.PowerTinhQuest);
				
				if (Data1["QuestInfo"] != null && Data1["QuestInfo"]["ElementMainQuest"] != null && int(Data1["QuestInfo"]["ElementMainQuest"]) > 0)
				{
					GuiMgr.getInstance().guiMainQuest.soldierElement = int(Data1["QuestInfo"]["ElementMainQuest"]);
				}
				QuestMgr.getInstance().InitSeriesQuest(Data1.QuestList, true);
				
				//Get daily quest va series quest
				//QuestMgr.getInstance().InitDailyQuest(Data1.DailyQuest, false);
				if (user.GetLevel() < 7)
				{
					var cmdDailyQuestNew:SendGetDailyQuestNew = new SendGetDailyQuestNew();
					Exchange.GetInstance().Send(cmdDailyQuestNew);	
				}
				
				
				var cmd:SendGetTotalFish = new SendGetTotalFish();
				Exchange.GetInstance().Send(cmd);
				
				//if (!isFirstForExpedition)//chỉ gửi 1 lần
				//{
					//var pk:SendGetStatus = new SendGetStatus("ExpeditionService.getStatus", 
														//Constant.CMD_GET_EXPEDITION_STATUS);
					//Exchange.GetInstance().Send(pk);
					//isFirstForExpedition = true;
				//}
				
				
				user.GetMyInfo().EventInfo = Data1["UserProfile"]["Event"];
				
				//event 1st Birth day
				if (EventMgr.CheckEvent(GUITopInfo.NAME_CURRENT_IN_EVENT) == EventMgr.CURRENT_IN_EVENT)
				{
					//BirthDayItemMgr.getInstance().initData1(Data1);
					//MagicLampMgr.getInstance().initData(Data1);
					if(Data1 && Data1.EventList && Data1.EventList.PearFlower)
					{
						ProgessEventPearFlower(Data1.EventList.PearFlower);
					}
				}
			}		
			
			// init bonus daily
			user.InitDailyBonus();
			//user.InitTreasureBox();
			
			// Event
			if(Treasure.CheckEvent())
				user.InitTreasure();
			//Khoi tao lai gui Avatar
			/*if(!GameController.getInstance().isSmallBackGround)
			{
				GuiMgr.getInstance().GuiCharacter.Show(Constant.OBJECT_LAYER);
			}*/
			
			GuiMgr.getInstance().GuiFishing.Hide();
			GuiMgr.getInstance().GuiFishingFail.Hide();
			GuiMgr.getInstance().GuiFishingCannot.Hide();
			GuiMgr.getInstance().GuiFishingSuccess.Hide();
			GuiMgr.getInstance().guiAnoucementCollection.Hide();
			
			GuiMgr.getInstance().GuiMain.ShowLakes();
			GuiMgr.getInstance().GuiMain.isSendLoadOcean = false;
			GuiMgr.getInstance().guiFrontScreen.isSendLoadOcean = false;
			GuiMgr.getInstance().GuiStore.Hide();
			//GuiMgr.getInstance().GuiMixFish.Hide();
			MailMgr.getInstance().initSystemMail1(Data1["SystemMail"]);
			
			//GuiMgr.getInstance().GuiTopInfo.UpdateFriend();
			//GuiMgr.getInstance().GuiTopInfo.updateStatusBtnEvent("Event_8_3_Flower");
			//GuiMgr.getInstance().GuiTopInfo.updateStatusBtnEvent("Khong_Co");
			GuiMgr.getInstance().GuiAnnounce.CheckCookie();
			
			// Effect
			swfEffHatchArr = [];
			swfEffCureFishArr = [];	
			
			//EventMgr.getInstance().InitEvent(EventMgr.EVENT_NEW_YEAR);
			user.UpdateHavestTime();	
			
			//Event duplicateExp
			checkEventDuplicateExp();
			
			EventMgr.getInstance().CheckInitEvent();

			if (user.IsViewer())
			{
				user.UpdateLakeBenefit();
				if(user.GetMyInfo().NumGetGift < user.GetMyInfo().MaxGetGift && !CheckGotGift(user.Id))
				{
					GuiMgr.getInstance().guiDailyEnergyBonus.Show(Constant.GUI_MIN_LAYER, 1);
				}
			}
			
			if (GuiMgr.getInstance().GuiInfoFishWar.IsVisible)
			{
				GuiMgr.getInstance().GuiInfoFishWar.Hide();
			}
			
			// túi tân thủ
			if (!isViewer)
			{
				if ("NewUserGiftBag" in Data1["UserProfile"]["ActionInfo"])
				{
					user.initTuiTanThu(false,Data1["UserProfile"]["ActionInfo"]["NewUserGiftBag"]);
				}
			}
			else 
			{
				if (user.tuiTanThu)
				{
					user.tuiTanThu.Clear();
					user.tuiTanThu.loop = false;
				}
			}
			user.InitMoneyMagnet(Data1);
			
			//Show gui gia han 1 lan trong ngay neu gia han duoc
			var sharedObj:Object = SharedObject.getLocal("ExtendDeco");
			var uId:String = String(user.GetMyInfo().Id);
			if (!sharedObj.data[uId])
			{
				sharedObj.data[uId] = new Object();
			}
			var today:Date = new Date(CurServerTime * 1000);
			if ((!(sharedObj.data[uId]["Date"]) || (today.date != sharedObj.data[uId]["Date"])) && canExtendDeco() && !user.IsViewer())
			{
				GuiMgr.getInstance().guiExtendDeco.showGUI();
				sharedObj.data[uId]["Date"] = today.date;
			}
			
			// Cập nhật thông tin của người đánh Boss
			GameLogic.getInstance().WinBossUser = Data1.WinBossUser;
			GameLogic.getInstance().LastTimeKillBoss = Data1.LastTimeKillBoss;
			
			GameLogic.getInstance().serverBossTop = Data1["SB_TopUser"];
			GameLogic.getInstance().serverBossLastHit = Data1["SB_LastHit"];
			GameLogic.getInstance().serverBossId = Data1["SB_LastHit_Boss"];
			
			userGetVipMax = Data1["UserGetVipMax"];
			var isLoadWar:Boolean = true;
			for (var i:int = 0; i < ResMgr.getInstance().LoadingList.length; i++)
			{
				if (ResMgr.getInstance().LoadingList[i]["name"] == "LoadingWar")
				{
					isLoadWar = false;
					break;
				}
			}
			
			if (!isLoadWar)
			{
				GuiMgr.getInstance().GuiWaitingContent.Init("LoadingWar");
			}
			//training tower
			TrainingMgr.getInstance().initData();
			var firstTimeLogin:Boolean = TrainingMgr.getInstance().FisrtTimeLogin;
			if (firstTimeLogin) {
				TrainingMgr.getInstance().getTowerInfo();
			}
			
			//Trung Huy hieu
			TrungLinhThachMgr.getInstance().initData();
			var loadTimeLogin:Boolean = TrungLinhThachMgr.getInstance().FisrtTimeLogin;
			if (loadTimeLogin) {
				TrungLinhThachMgr.getInstance().getQuartzInfo();
			}
			
			// Nhận quà tournament nếu chưa nhận sau khi kết thúc tour
			if (!isViewer)
			{
				if ("ReceivedGiftTournament" in Data1["UserProfile"]["ActionInfo"])
				{
					if (Data1["UserProfile"]["ActionInfo"]["ReceivedGiftTournament"] == false)
					{						
						LogicTournament.getInstance().getGiftTourInfo();
					}
				}
			}
			LeagueController.getInstance().mode = LeagueController.IN_HOME;
			user.Rank = Data1["OccupyingRank"];
			
			GuiMgr.getInstance().guiFrontScreen.updateUserData();
			GuiMgr.getInstance().guiUserInfo.updateUserData();
			//Quà Boss server
			if (Data1["ServerBoss"] != null && Data1["ServerBoss"]["GiftList"] != null)
			{
				GuiMgr.getInstance().guiGiftBossServer.showGUI(Data1["ServerBoss"]["GiftList"], false, Data1["ServerBoss"]["UserInfo"]["Position"]);
			}
		}	
		
		/**
		 * Hàm kiểm tra xem user đã nhận quà từ nhà người bạn hiện tại chưa
		 * @param	Id	:	Id của người bạn cần kiểm tra
		 * @return
		 */
		private function CheckGotGift(Id:int):Boolean
		{
			var myInfo:MyUserInfo = user.GetMyInfo();
			for (var i:String in myInfo.DailyEnergy)
			{
				if (Id.toString() == i)
					return true;
			}
			return false;
		}
		
		public function ProgessEventPearFlower(event:Object):void 
		{
			if (isEvent("PearFlower") && !GameLogic.getInstance().user.IsViewer())
			{
				//GuiMgr.getInstance().GuiTopInfo.btnEvent.SetVisible(true);
				//GuiMgr.getInstance().GuiTopInfo.UpdateAllPos();
				GuiMgr.getInstance().GuiGameTrungThu.ReInitInfo(event);
			}
		}

		public function canExtendDeco():Boolean
		{
			var data:Array = [];
			data = data.concat(user.GetStore("Decorate"));
			data = data.concat(user.item);
			for each(var obj:Object in data)
			{
				if (obj["ItemType"] == "BackGround" && obj["ExpiredTime"] - Constant.TIME_CAN_EXTEND < CurServerTime  &&  CurServerTime < obj["ExpiredTime"] + Constant.TIME_DISAPPEAR)
				{
					return true;
				}
			}
			return false;
		}
		
		public function showEffWish():void
		{
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFishBall", null, 420, 350, false, false, null, finishEff);
			hide7Ball();
		}
		
		public function finishEff():void 
		{
			if (wishRespond)
			{
				GuiMgr.getInstance().guiCongratulation.showGUI(itemType, itemId, itemNum, true);
			}
			else
			{
				endEff = true;
			}
		}
		
		private function showGUIWish():void
		{
			GuiMgr.getInstance().guiWish.showGUI();
		}
		
		
		//Event duplicateExp
		public function checkEventDuplicateExp():Boolean
		{
			var event:Object = ConfigJSON.getInstance().GetItemList("Event");
			if (event && event["DuplicateExp"] && event["DuplicateExp"]["BeginTime"] <= CurServerTime && event["DuplicateExp"]["ExpireTime"] >= CurServerTime)
			{
				isEventDuplicateExp = true;
			}
			else
			{
				isEventDuplicateExp = false;
			}
			return isEventDuplicateExp;
		}
		
		//Event click
		//Khoi tao event
		public function initEventClick():void
		{
			//Event click
			var event:Object = ConfigJSON.getInstance().getEventInfo("SaveMermaid");
			var num:int = GameLogic.getInstance().user.GetMyInfo().event["SaveMermaid"]["NumCurrent"];
			if (event && event.BeginTime <= CurServerTime)
			{
				var maxNum:int = event["LimitedClick"];
				if(CurServerTime <= event.ExpireTime)
				{
					if (num < maxNum)
					{
						GuiMgr.getInstance().GuiTienCa.Show(Constant.DIRTY_LAYER);
						SharedObject.getLocal("FeedClick").data.feeded = false;
					}
					else
					{
						var so:SharedObject = SharedObject.getLocal("FeedClick");
						if (!so.data.feeded)				
						{
							//GuiMgr.getInstance().GuiFinishEventClick.Show(Constant.GUI_MIN_LAYER, 2);
							so.data.feeded = true;						
						}		
						TienCaClick.isNewTienCa = true;
					}
				}
				else 
				{
					TienCaClick.isNewTienCa = true;
				}
			}
		}		
		
		/**
		 * Kiểm tra xem event nameEvent có đang diễn hay không
		 * @param	nameEvent
		 * @return
		 */
		public function isEvent(nameEvent:String):Boolean
		{
			var event:Object = ConfigJSON.getInstance().GetItemList("Event");
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (event[nameEvent] == null)
			{
				return false;
			}
			else
			{
				if (event[nameEvent]["BeginTime"] > curTime || event[nameEvent]["ExpireTime"] < curTime || user.GetLevel() < event[nameEvent].LevelRequire)
				{
					return false;
				}
			}
			return true;
		}
		public function ProcessShowDailyGift(GetGift:Object):void
		{
			//GuiMgr.getInstance().GuiGetDailyGift.ShowDialog(GetGift);
		}
		
		public function ProcessAddMaterialFish(dataReceive:Object, dataOld:Object):void 
		{
			GameLogic2.UseMaterialForFish(dataReceive.Option, dataOld.Id, dataOld.MaterialId);
		}
		
		public function Reset(isInitRun:Boolean = true):void
		{
			// xoa helper
			HelperMgr.getInstance().HideHelper();
			GameInput.getInstance().lastAttackTime = 0;
			// chuyen trang thai binh thuong
			BackToIdleGameState();
			user.Reset(isInitRun);
			
			//reset bong bong
			for (var i:int = 0; i < balloonArr.length; i++)
			{
				var balloon:Balloon = balloonArr[i] as Balloon;
				balloon.Destructor();
				balloon = null;
				i--;
			}
			balloonArr.splice(0, balloonArr.length);
			
			EffectMgr.getInstance().reset();
			LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).Empty();
			LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).Empty();
			LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER).Empty();
			
			//Đẩy hết log đi
			if (log.HasAct())
			{
				var cmd:SendSetLog = new SendSetLog();
				cmd.SetData(log);
				Exchange.GetInstance().Send(cmd);
				log = new LogInfo();
				//trace("push log", getTimer(), user.Id);
			}			
		}
		
		public function CheckLevelUp(exp:int, level:int):Boolean
		{
			//if (user.IsViewer()) 
			//{                                                                                     
				//return false;
			//}
			
			var ExpNeed:int = ConfigJSON.getInstance().getUserLevelExp(user.GetLevel());
			if (ExpNeed < 0) return false;
			
			// chăn level không quá 50
			if (level >= ConfigJSON.maxUserLevel) return false;
			
			if (user.GetExp() >= ExpNeed)
			{
				//Exp -= ExpNeed;
				//Level++;				
				return true;
			}			
			return false;
		}
		
		
		/**
		 * Phương thức cập nhật logic của game trong mỗi frame
		 */
		public function UpdateLogic():void
		{			
			if (gameState == GameState.GAMESTATE_INIT)
			{
				return;
			}
			
			//Update Energy
			if(!user.IsViewer())//với máy của mình
			{
				if (user.GetMyInfo().hasMachine)//có máy
				{
					if(!user.GetMyInfo().IsExpiredMachine)//chưa hết xăng
						user.GetMyInfo().energyMachine.UpdateEnergyMachine(true);//thực hiện update cho máy của mình (mà mình đang nhìn thấy)
				}
			}
			else		//với máy của bạn
			{
				if (user.energyMachine)//bạn có máy
				{
					if(!user.energyMachine.IsExpired)//chưa hết xăng
						user.energyMachine.UpdateEnergyMachine(false);
				}
				if (user.GetMyInfo().hasMachine)//nếu mình có máy
				{//thực hiện update cho cả máy của nhà mình (mặc dù lúc này mình không nhìn thấy nó)
					if(!user.GetMyInfo().IsExpiredMachine)		//máy đó chưa hết xăng thì mới update
						user.GetMyInfo().UpdateEnergyMachine();
				}
			}
			//khi hết event thì xóa
			updateEvent83();//xoa event HiepNM2
			//updateEventBirthDay();
			//Update time
			updateShocksNoel();
			UpdateTime();
			
			//Check timeout
			Exchange.GetInstance().checkTimeOut();
			
			//Update fish
			UpdateFish();
			
			//Update Masks
			UpdateMask();
			
			//update tui tan thu
			if(Ultility.IsInMyFish())
			{
				user.UpdateTuiTanThu();
			}
			user.UpdateMoneyMagnet();
			
			var i:int = 0;
			var t:int;
			var food:Food;
			//var fishArr:Array = user.GetFishArr();
			var FoodArr:Array = user.GetFoodArr();		
			//Update food
			for (i = 0; i < FoodArr.length; i++ )
			{
				food = FoodArr[i] as Food;
				if (food != null)
				{
					food.UpdateFood();
					if (food.MovingSate == Food.F_IDLE)
					{
						t = FoodArr.indexOf(food);
						food.ClearImage();
						FoodArr.splice(t, 1);
					}
				}
			}
			UpdateFoodList();
			
			//Update các túi tiền, nếu có
			var pocket:Pocket;
			for (i = 0; i < user.PocketArr.length; i++ )
			{
				pocket = user.PocketArr[i];
				pocket.UpdatePos();
			}
			
			// update mouse position
			if (cursor != null)
			{
				cursor.x = GameInput.getInstance().MousePos.x;
				cursor.y = GameInput.getInstance().MousePos.y;				
			}

			
			// update paning state
			if (PanInterval != 0)
			{
				GameController.getInstance().PanScreenX(PanInterval);
			}			
			
			// update dirty object
			var dirtyArr:Array = user.GetDirtyArray();
			if (dirtyArr.length > 0 && dirtyArr.length < user.CurLake.GetDirtyAmount())
			{
				user.UpdateDirtyArray();
			}
			
			//Update nguyên liệu lai
			user.UpdateMixedMaterial();
			
			// update pearlRefine
			user.UpdatePearlRefine();
			
			// Update thanh progressbar
			if (PrgGraveList.length != 0)
			UpdatePrgGraveStatus();
			
			// Update energy cho user
			user.UpdateEnergyOntime();
			if(user.dailyBonus!=null)
			user.dailyBonus.updateStateBonusEnergy();
			
			//if (user.treasureBox != null && user.treasureBox.img != null)
			//{
				//user.treasureBox.UpdateTime();
			//}			
			
			//Update cá bơi theo đàn
			if (CountHerd == 12)
			{
				CountHerd = 0;
				UpdateHerd();
			}
			CountHerd++;
			// Update action cho game sau khi các effect kết thúc
			//AfterEffect();
			
			// update light
			//LightMgr.getInstance().UpdateLight();
			
			// update GUI
			GuiMgr.getInstance().UpdateAllGUI();
			LeagueInterface.getInstance().updateAllGui();
			//update particle
			if(GuiMgr.getInstance().GuiStore.IsVisible)
				if (GuiMgr.getInstance().GuiForEffect)
					GuiMgr.getInstance().GuiForEffect.updateParticle();
			// update effect
			EffectMgr.getInstance().UpdateAllEffect();			
			BossMgr.getInstance().UpdateBoss();
			
			//TestTool();
			//GuiMgr.getInstance().GuiGiftSend.MoveThanhKeo();
			//GuiMgr.getInstance().GuiGiftSend.MoveThanhKeoUp();
			// helper
			/*if (!GuiMgr.getInstance().GuiMixFish.IsVisible)
			{
				HelperMgr.getInstance().ShowHelper(QuestMgr.getInstance().GetCurTutorial());
			}*/
			if (!GuiMgr.getInstance().guiMateFish.IsVisible)
			{
				var st:String = QuestMgr.getInstance().GetCurTutorial();
				//if(st != "")
				//{
					//trace("curtutorial", st);
				//}
				HelperMgr.getInstance().ShowHelper(st);
			}
			//tooltip
			ActiveTooltip.getInstance().update();
			
			//Test();
			var f:Fish;
			var can:int = Ultility.RandomNumber(0, user.GetFishArr().length-1);
			//for (i = 0; i < user.GetFishArr().length; i++)
			//{				
				//if ((i+1) % can == 0)
				//{
				if (gameMode != GameMode.GAMEMODE_WAR)
				{
					// Lảm nhảm
					f = user.GetFishArr()[can];
					if (f != null)
					{						
						switch (f.Emotion)
						{
							case Fish.DOMAIN_1:
							case Fish.DOMAIN_2:
							case Fish.DOMAIN_3:
							case Fish.DOMAIN_4:
							case Fish.DOMAIN_5:
							case Fish.IDLE:
								FishChatting(Constant.CHAT_NORMAL, 5000, 20, f);
								break;
							case Fish.ILL:
								FishChatting(Constant.CHAT_SICK, 5000, 20, f);
								break;
							case Fish.HUNGRY:
								FishChatting(Constant.CHAT_HUNGRY, 5000, 20, f);
								break;
							default:
								break;
						}
					}
				}
				else
				{
					
				}
				//}
			//}
			//GuiMgr.getInstance().GuiWaitFishing.UpdateTimeout();
			
			if (FishingDataReceive)	
			{
				if(finishFishing)
				{
					//GuiMgr.getInstance().GuiWaitFishing.GUIHide();
					ProcessFishing1(dataFishing)
				}
			}
			
			// cho ket thuc eff ghep nguyen lieu
			if (GuiMgr.getInstance().GuiRawMaterials.IsVisible && GuiMgr.getInstance().GuiRawMaterials.IsEffSendFinish 
				&& GuiMgr.getInstance().GuiRawMaterials.IsReceived)
			{
				GuiMgr.getInstance().GuiRawMaterials.IsReceived = false;
				GuiMgr.getInstance().GuiRawMaterials.UpdateMaterialUserOkStart();
			}
			
			//if (GuiMgr.getInstance().GuiRawMaterials.isStartRaw)
			//{
				//GuiMgr.getInstance().GuiRawMaterials.UpdateTimeOut();
			//}
			
			if (GuiMgr.getInstance().GuiRawMaterials.IsVisible && GuiMgr.getInstance().GuiRawMaterials.StateBuyShop == 2 )
			{
				GuiMgr.getInstance().GuiRawMaterials.lisRawMaterial.removeAllItem();
				//GuiMgr.getInstance().GuiRawMaterials.lisRawMaterial.setPos(15, 0);
				GuiMgr.getInstance().GuiRawMaterials.lisRawMaterial.setPos(82, 0);
				GuiMgr.getInstance().GuiRawMaterials.InitArrNumMaterial(user.StockThingsArr.Material);
				var arrNUmMat:Array = GuiMgr.getInstance().GuiRawMaterials.arrNumMaterial;
				var arrNumMatUsed:Array = GuiMgr.getInstance().GuiRawMaterials.arrUsedSlot;
				for (i = 0; i < arrNumMatUsed.length; i++) 
				{
					var r:int = arrNumMatUsed[i] % 100;
					var q:int = arrNumMatUsed[i] / 100;
					var index:int = (r - 1) * 2 + q;
					arrNUmMat[index] --;
				}
				GuiMgr.getInstance().GuiRawMaterials.arrNumMaterial = arrNUmMat;
				GuiMgr.getInstance().GuiRawMaterials.InitMaterialList(arrNUmMat);
			}
			
			
			// Progressbar thay đổi giá trị dần - longpt
			for (i = 0; i < ProgressList.length; i++)
			{
				var ob:Object = ProgressList[i];
				var pb:ProgressBar = ProgressList[i]["pb"] as ProgressBar;
				var nextstatus:Number = ob["begin"] + ob["step"];
				if (nextstatus > ob["end"])
				{
					nextstatus = ob["end"];
				}
				pb.setStatus(nextstatus, ob["scaleX"]);
				ob["begin"] = nextstatus;
				
				if (ob["begin"] == ob["end"])
				{
					ProgressList.splice(i, 1);
				}
			}
			
			//Update nhả bóng
			for (var j:int = 0; j < balloonArr.length; j++)
			{
				var bl:Balloon = balloonArr[j] as Balloon;
				bl.updateBalloon();
			}
			
			
			if (GuiMgr.getInstance().GuiStore.IsVisible && !GuiMgr.getInstance().GuiStore.isProgressFull)
			{
				if(GuiMgr.getInstance().GuiStore.btnID.search("MagicBag") >= 0)
					GuiMgr.getInstance().GuiStore.UpdateForPgrMagicBag(GuiMgr.getInstance().GuiStore.curId);
			}
			
			if (GuiMgr.getInstance().GuiStore.isProgressFull && GuiMgr.getInstance().GuiForEffect.isReceiveData)
			{
				GuiMgr.getInstance().GuiStore.ProcessReceiveGiftMagicBag(GuiMgr.getInstance().GuiStore.curprgProcessing,GuiMgr.getInstance().GuiStore.curimgPrgProcessing);
			}
			
			UpdateFishWorld();
			
			// Check chọi cá trên hồ
			if (user.CurSoldier[0])
			{
				//trace("CheckState_user.CurSoldier[0]");
				if (user.CurSoldier[0].img)
				{
					//trace("CheckState_user.CurSoldier[0].img");
					if (user.CurSoldier[1])
					{
						//trace("CheckState_user.CurSoldier[1]");
						if(user.CurSoldier[1].img)
						{
							//trace("CheckState_user.CurSoldier[1].img");
							if (!user.CurSoldier[0].img.visible && !user.CurSoldier[1].img.visible)
							{
								//trace("Con ca linh thu nhat va thu hai trong mang CurSoldier khong duoc hien");
								if (!fw)
								{
									//trace("Neu chua tao fishWar thi khoi tao no");
									fw = new FishWar(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "EffFightingFishSmoke");
									fw.SetFishes(user.CurSoldier[0], user.CurSoldier[1]);
									fw.CreateBattle();
								}
							}
							//else if (isAttacking && user.CurSoldier[1] is FishSoldier && user.CurSoldier[0].isReadyToFight && user.CurSoldier[1].isReadyToFight)
							else 
							{
								if (isAttacking)
								{
									//trace("CheckState_isAttacking");
									if (user.CurSoldier[0].isReadyToFight)
									{
										if (user.CurSoldier[1].isReadyToFight)
										{
											//trace("CheckState_user.CurSoldier[1].isReadyToFight");
											if (!fw)
											{
												//trace("CheckState_fw_null");
												if(!Ultility.IsKillBoss() || (Ultility.IsKillBoss() && (user.CurSoldier[1] is SubBossMetal))
													|| (Ultility.IsKillBoss() && (user.CurSoldier[1] is SubBossIce)))
												{
													fw = new FishWar(null, "");
													fw.SetFishes(user.CurSoldier[0], user.CurSoldier[1]);
													fw.CreateBattle();
												}
											}
										}
									}
								}
							}
						}
					}
				}
			}
			
			if (isAttacking && fw)
			{
				fw.CombatForReal1();
			}
			
			// Cập nhật effect trên đầu cá
			for (i = 0; i < EffectInFishList.length; i++)
			{
				if (EffectInFishList[i].parent.isActor == FishSoldier.ACTOR_MINE)
				{
					if (CurServerTime > LastEffectMine + 0.6)
					{
						EffectMgr.getInstance().textFly(EffectInFishList[i].str, EffectInFishList[i].pos, EffectInFishList[i].txtFormat, EffectInFishList[i].parent.aboveContent, 0, -40, 3);
						LastEffectMine = CurServerTime;
						EffectInFishList.splice(i, 1);
						i--;
					}
				}
				else
				{
					if (CurServerTime > LastEffectTheirs + 0.6)
					{
						EffectMgr.getInstance().textFly(EffectInFishList[i].str, EffectInFishList[i].pos, EffectInFishList[i].txtFormat, EffectInFishList[i].parent.aboveContent, 0, -40, 3);
						LastEffectTheirs = CurServerTime;
						EffectInFishList.splice(i, 1);
						i--;
					}
				}
			}
			
			// Check chuyển chế độ WAR/PEACE
			if(GuiMgr.getInstance().GuiMain)
			GuiMgr.getInstance().GuiMain.CheckSwitchable();
			
			//Event 2-9 update firework fish
			updateFireworkFish();
			
			//update time deco
			updateDeco();
			
			// cập nhật các thanh prg chạy chạy
			UpdatePrg();
			
			//Update rung màn hình
			GameController.getInstance().updateShakeScreen();
			
			// Cập nhật các timer mình tạo ra
			UpdateMyTimer();
			
			// Cập nhật đan tán qua ngày
			Ultility.CheckNewDay();
			
			//BossHerb.CheckBossHerbRealTime();
			
			//if (user.bossHerb)
			//{
				//user.bossHerb.CheckCombat();
			//}
			TrainingMgr.getInstance().updateTowerState();
			
			TrungLinhThachMgr.getInstance().updateQuartzState();
			
			LeagueMgr.getInstance().updateTime();
			
			endOfDay();
		}
		
		public function UpdateMyTimer():void 
		{
			var curTime:Number = CurServerTime * 1000;
			for (var i:int = 0; i < arrMyTimer.length; i++) 
			{
				var timer:myTimer = arrMyTimer[i];
				if (curTime - timer.startTime > timer.delay && timer.isRun)
				{
					timer.Finish();
				}
			}
		}
		
		private function UpdatePrg():void 
		{
			for (var i:int = 0; i < arrPrgProcess.length; i++) 
			{
				var prg:ProgressBar = arrPrgProcess[i];
				if(prg)
				{
					prg.setStatus(Math.max(prg.GetStatus() - 0.05, 0));
					SetColorPrg(prg, prg.GetStatus(), arrPrgTypeProcess[i]);
					if (prg.GetStatus() <= arrPrgStatusProcess[i])
					{
						prg.setStatus(arrPrgStatusProcess[i]);
						arrPrgProcess.splice(i, 1);
						arrPrgStatusProcess.splice(i, 1);
						arrPrgTypeProcess.splice(i, 1);
					}
				}
			}
		}
		
		public function SetColorPrg(prg:ProgressBar, status:Number, typeProgess:int):void 
		{
			if (!prg || !prg.img)	return;
			var offsetGreen:Number = getOffsetGreen(status, typeProgess);
			var offsetRed:Number = getOffsetRed(status, typeProgess);
			var c:ColorTransform = new ColorTransform(0, 0, 0, 1, offsetRed, offsetGreen, 0, 0);
			switch (typeProgess)
			{
				case Constant.TYPE_PRG_HP:
				{
					prg.img.transform.colorTransform = c;
				}
			}
		}
		
		public function getOffsetRed(status:Number, typeProgess:int):Number 
		{
			var num:Number;
			switch (typeProgess) 
			{
				case Constant.TYPE_PRG_HP:
					if (status > 0.5)
					{
						num = 255 / 0.5 * (1 - status);
					}
					else 
					{
						num = 255;
					}
				break;
			}
			return num;
		}
		public function getOffsetGreen(status:Number, typeProgess:int):Number 
		{
			var num:Number;
			switch (typeProgess) 
			{
				case Constant.TYPE_PRG_HP:
					if (status < 0.5)
					{
						num = 255 / 0.5 * status;
					}
					else 
					{
						num = 255;
					}
				break;
			}
			return num;
		}
		
		public function AddPrgToProcess(prg:ProgressBar, status:Number, typePrg:int = 0):void 
		{
			var index:int = arrPrgProcess.indexOf(prg);
			if(index < 0)
			{
				arrPrgProcess.push(prg);
				arrPrgStatusProcess.push(status);
				arrPrgTypeProcess.push(typePrg);
			}
			else 
			{
				arrPrgStatusProcess[index] = Math.max(status, 0);
				arrPrgTypeProcess[index] = typePrg;
			}
		}
		
		public function updateDeco():void 
		{
			var decoArr:Array = user.GetDecoArr();
			var arrId:Array = [];
			
			//Xử lí deco hết hạn
			for (var i:int  = 0; i < decoArr.length; i++)
			{
				var deco:Decorate =  decoArr[i];
				//trace(deco.expiredTime - CurServerTime, deco.isExpired);
				if (CurServerTime > deco.expiredTime && !deco.isExpired)
				{
					deco.isExpired = true;
					arrId.push(deco.Id);
					if(!user.IsViewer())
					{
						StoreDecorate(deco);
					}
					decoArr.splice(i, 1);
					i--;
					user.UpdateOptionCurLake();
				}
			}
			
			//Check thoi han background
			if (user.backGround)
			{	
				//trace(user.backGround.expiredTime - CurServerTime, user.backGround.isExpired);
				if(CurServerTime > user.backGround.expiredTime && !user.backGround.isExpired)
				{
					user.backGround.isExpired = true;
					arrId.push(user.backGround.Id);
					var defBgr:Object = user.getDefaultBgrFromStore();
						
					if(!user.IsViewer())
					{						
						var dec:Decorate = new Decorate(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "BackGround" + user.backGround.ItemId, 0, 0, "BackGround", user.backGround.ItemId);
						dec.Id = user.backGround.Id;
						dec.expiredTime = user.backGround.expiredTime;
						dec.extendTime = user.backGround.extendTime;
						StoreDecorate(dec);
						//Chưa load kho thì ko updatestore
						if(defBgr != null)
						{
							GuiMgr.getInstance().GuiStore.UpdateStore("BackGround", defBgr["Id"], -1);
							var cmd:SendUseItem = new SendUseItem(GameLogic.getInstance().user.CurLake.Id);
							cmd.AddNew(defBgr["Id"], defBgr["ItemId"], "BackGround", 0, 0, 0);
							Exchange.GetInstance().Send(cmd);
						}					
					}				
					
					user.initBackGround(defBgr);
				}
			}
			
			if (arrId.length > 0)
			{
				var sendExpiredDeco:SendExpiredDeco = new SendExpiredDeco(user.Id, arrId, user.CurLake.Id);
				Exchange.GetInstance().Send(sendExpiredDeco);
			}
			
			//Xử lí deco có thể gia hạn
			for each(var decorate:Decorate in decoArr)
			{
				if (decorate.canExtend() && decorate.img.visible)
				{
					if (GameLogic.getInstance().gameState == GameState.GAMESTATE_EDIT_DECORATE)
					{
						decorate.showButtonExtend();
					}
					else
					{	
						decorate.hideButtonExtend();
					}
				}
			}			
			
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.UpdateObject();
			}
		}
		
		private function updateFireworkFish():void 
		{
			var arrFireworkFish:Array = user.arrFireworkFish;
			if (arrFireworkFish != null)
			{
				for (var i:int = 0; i < arrFireworkFish.length; i++ )
				{
					var fis:FireworkFish = arrFireworkFish[i] as FireworkFish;
					if (fis != null && fis.img != null && fis.img.stage != null)
					{
						fis.UpdateFish();	
					}
				}
			}
		}
		
		public function MouseVisible(IsVisible:Boolean):void
		{
			if (IsVisible)
			{
				if (cursor != null && cursor.parent == null)
				{
					LayerMgr.getInstance().GetLayer(Constant.TopLayer).addChild(cursor);
					//cursor.mouseChildren = false;
					//cursor.mouseEnabled = false;					
				}
			}
			else
			{
				if (cursor != null && cursor.parent != null)
				{
					cursor.parent.removeChild(cursor);
				}
			}
		}
		
		public function BackToOldMouse():void
		{
			MouseTransform(OldMouseName, OldMouseScale, OldMouseRotate, DeltaMousePos.x, DeltaMousePos.y);
			//trace(OldMouseName);
		}
		
		public function MouseTransform(imgName:String = "", scale:Number = 1, rotation:Number = 0, deltaX:int = 10, deltaY:int = -20):void
		{	
			var tool:MovieClip = null;
			if (cursor != null && cursor.parent != null)
			{
				cursor.parent.removeChild(cursor);				
			}
			
			cursorImg = imgName;
			
			// Nếu imgName được truyền vào có dạng Type$Id -> Item FishWar - Longpt
			if (imgName.search("$") != -1)
			{
				var a:Array = imgName.split("$");
				var s:String = "";
				for (var j:int = 0; j < a.length; j++)
				{
					s += a[j];
				}
				imgName = s;
			}
			
			
			
			if (imgName == "Windows")
			{
				Mouse.show();
				return;
			}
			
			if (imgName == "" || imgName == null)
			{
				//cursor = ResMgr.getInstance().GetRes("MouseDefault") as MovieClip;
				cursor = ResMgr.getInstance().GetRes("ctnNone") as MovieClip;
				//cursor.gotoAndStop(1);
				//Mouse.hide();
				Mouse.show();
				//cursor = null;
			}
			else
			{
				while (cursor.numChildren > 0)
				{
					cursor.removeChildAt(0);
				}
				
				tool = ResMgr.getInstance().GetRes(imgName) as MovieClip;
				if(imgName.search("EventIceCream") >= 0)
					tool.gotoAndStop(1);
				//var cur:Sprite = ResMgr.getInstance().GetRes("MouseDefault") as Sprite;
				var cur:Sprite = ResMgr.getInstance().GetRes("ctnNone") as Sprite;
				cursor.addChild(tool);
				if (imgName != "imgHand" && imgName != "ImgSword")
				{
					cursor.addChild(cur);
					Mouse.show();
				}		
				else
				{
					Mouse.hide();
				}
				//Mouse.hide();
			}
			if(cursor != null)
			{			
				LayerMgr.getInstance().GetLayer(Constant.TopLayer).addChild(cursor);
				cursor.mouseChildren = false;
				cursor.mouseEnabled = false;
				cursor.parent.mouseEnabled = false;
				//cursor.x = GameInput.getInstance().MousePos.x;
				//cursor.y = GameInput.getInstance().MousePos.y;
				if (tool != null && imgName != "imgHand" && imgName != "ImgSword")
				{
					tool.scaleX = scale;
					tool.scaleY = scale;
					tool.rotation = rotation;					
					tool.x = deltaX;
					tool.y = deltaY;
				}
			}
			if (imgName != "Brush" && imgName != "ImgSword" && imgName != "imgHand" && imgName.search("MouseKey") == -1)
			{
				if (imgName == "")
				{
					//trace("DSDSDSD");
				}
				//trace(imgName);
				OldMouseName = imgName;
				OldMouseScale = scale;
				OldMouseRotate = rotation;
				DeltaMousePos.x = deltaX;
				DeltaMousePos.y = deltaY;
			}
		}
		
		public function DoLevelUp():void
		{
			var test:SendLevelUp = new SendLevelUp();
			Exchange.GetInstance().Send(test);
			//var cmd:SendGetSeriesQuest = new SendGetSeriesQuest();
			//var guiMainQuest:GUIMainQuest = GuiMgr.getInstance().guiMainQuest;
			//if (guiMainQuest.IsVisible && guiMainQuest.curQuest != null)
			//{
				//cmd.IdSeriQuest = guiMainQuest.curQuest.IdSeriesQuest;
			//}
			//Exchange.GetInstance().Send(cmd);
			}
		
		public function ProcessLevelUp(data:Object):void
		{
			var pCmd:GetLevelUp = new GetLevelUp(data);
			
			user.allowLevelUp = true;
			if (pCmd.Error != 0) return;						
			user.SetUserLevel(pCmd.Level);				
			var energy:int = ConfigJSON.getInstance().getMaxEnergy(user.GetMyInfo().Level);
			user.SetEnergy(energy);
			if (user.IsViewer())
			{
				if (user.coralTree)
				{
					if (user.coralTree.guiTipTree.img)
					{
						if (user.coralTree.guiTipTree.img.visible)
						{
							user.coralTree.guiTipTree.Hide();
						}
					}
				}
			}
			else
			{
				if (user.GetMyInfo().coralTree)
				{
					if (user.GetMyInfo().coralTree.guiTipTree.img)
					{
						if (user.GetMyInfo().coralTree.guiTipTree.img.visible)
						{
							user.GetMyInfo().coralTree.guiTipTree.Hide();
						}
					}
					if (user.GetMyInfo().coralTree.guiSeekTime.img)//nếu guiseektime đang show
					{
						if (user.GetMyInfo().coralTree.guiSeekTime.img.visible &&
							!user.GetMyInfo().coralTree.guiSeekTime.pressSeek)
						{
							user.GetMyInfo().coralTree.guiSeekTime.Hide();
						}
					}
				}
				else
				{
					if (data["Level"] == 7)
					{
						if (data["EventList"])
						{
							if (data["EventList"][EventMgr.NAME_EVENT])
							{
								if (EventMgr.CheckEvent(EventMgr.NAME_EVENT) == EventMgr.CURRENT_IN_EVENT)
								{
									//user.initCoralTree(data["EventList"][EventMgr.NAME_EVENT]);//thêm vào khởi tạo cây khi level up
								}
								if (EventUtils.checkInShocksNoel())
								{
									//user.initShocksNoel(null);//thêm vào để khởi tạo cái tất
								}
							}
						}
					}
				}
			}
			// hien ra gui chuc mung
			GuiMgr.getInstance().GuiLevelUp.ShowNewLevelUp(pCmd.Level);
			
			// Nếu gui nạp năng lượng nhanh đang hiển thị thì ẩn nó đi
			if (GuiMgr.getInstance().GuiAddEnergy.IsVisible)
			{
				GuiMgr.getInstance().GuiAddEnergy.Hide();
			}
			/*if (GuiMgr.getInstance().GuiRawMaterials.IsVisible)
			{
				GuiMgr.getInstance().GuiRawMaterials.Hide();
			}*/
			
			
			
			// init Túi tân thu?
			if(GameController.getInstance().gameMode != GameController.GAME_MODE_BOSS_SERVER)
			{
				user.initTuiTanThu();
			}
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE) 
			{
				if (user.tuiTanThu)
				{
					if (user.tuiTanThu.img)
					{
						user.tuiTanThu.loop = false;
						user.tuiTanThu.Clear();
					}
				}
			}
			LeagueMgr.getInstance().hasUpdateButton = true;
			EventMgr.getInstance().CheckInitEvent();
			
			//GuiMgr.getInstance().GuiTopInfo.updateStatusBtnEvent("Khong_Co");
			//GuiMgr.getInstance().GuiTopInfo.updateBtnLock();
			/*event BirthDay*/
			if (data["EventList"] as Array)
			{
				return;
			}
			else
			{
				if (data["EventList"][EventMgr.NAME_EVENT])
				{
					if (!user.IsViewer())//đang ở nhà mình
					{
						//user.GetMyInfo().initCoralTree(data["EventList"][EventMgr.NAME_EVENT]);//thêm vào để khởi tạo cái cây
					}
				}
				if (user.GetLevel() == 7)//hard code cho event
				{
					//EventSvc.getInstance();
					//EventTeacherMgr.getInstance().initCombo();
				}
			}
			
			//GuiMgr.getInstance().GuiTopInfo.updateEnergy();
			
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
			{
				LeagueInterface.getInstance().updateGuiTopForLeague();
				LeagueInterface.getInstance().levelUp();
				if (GuiMgr.getInstance().GuiLevelUp)
				{
					if (GuiMgr.getInstance().GuiLevelUp.img)
					{
						GuiMgr.getInstance().GuiLevelUp.Hide();
					}
				}
			}
			
			GuiMgr.getInstance().guiFrontScreen.updateUserData();
			
			/*remainplaycount của event halloween*/
			if (data["EventList"] as Array)
			{
				return;
			}
			else
			{
				if (data["EventList"]["Hal2012"])
				{
					HalloweenMgr.getInstance().RemainPlayCount = data["EventList"]["Hal2012"]["RemainPlayCount"];
				}
			}
		}

		/**
		 * Mua trang bị cá lính
		 * @param	ItemType	Armor Helmet Weapon
		 * @param	ItemId		Element$Level$Color
		 * @return
		 */
		public function BuyEquipment(ItemType:String, buyType:String, ishasMessage:Boolean = true):Boolean
		{
			// kiem tra tien
			var obj:Object;
			
			var a:Array = ItemType.split("$");
			obj = ConfigJSON.getInstance().GetEquipmentInfo(a[0], a[1] + "$" + a[2]);
			
			var MoneyHave:Number = 0;
			var BuyType:String = buyType;			
			var nMoney:int = obj[BuyType];
			if (BuyType == "Money")
			{
				MoneyHave = user.GetMoney();
			}
			else
			{
				MoneyHave = user.GetZMoney();
			}
			if (nMoney > MoneyHave)
			{
				return false;
			}
			
			if (BuyType == "Money")
			{
				user.UpdateUserMoney( -nMoney);
			}
			else
			{
				user.UpdateUserZMoney( -nMoney);
			}
			GuiMgr.getInstance().GuiMain.UpdateInfo();
			
			var test:SendBuyEquipment = new SendBuyEquipment(a[0], int(a[1]), int(a[2]), (buyType == "Money"));
			Exchange.GetInstance().Send(test);

			GameLogic.getInstance().user.GenerateNextID();
			
			//Hiện thông báo mua thành công
			if (ishasMessage)
			{
				var strr:String = a[0] + a[1] + "_Shop";
				EffectMgr.setEffBounceDown("Mua thành công", strr, 330, 280);
			}
			return true;
		}
		
		/**
		 * Buy item trong shop
		 * @param	ItemId
		 * @param	ItemType
		 */
		public function BuyItem(ItemId:int, ItemType:String, buyType:String, ishasMessage:Boolean = true):Boolean
		{
			// kiem tra tien
			var obj:Object;
			obj = ConfigJSON.getInstance().getItemInfo(ItemType, ItemId);
			var MoneyHave:Number = 0;
			//var BuyType:String = GuiMgr.getInstance().GuiBuyShop.BuyType;
			var BuyType:String = buyType;			
			var nMoney:int = obj[BuyType];
			if (BuyType == "Money")
			{
				MoneyHave = user.GetMoney();
			}
			else
			{
				MoneyHave = user.GetZMoney();
			}
			if (nMoney > MoneyHave)
			{
				return false;
			}
			
			if (BuyType == "Money")
			{
				user.UpdateUserMoney( -nMoney);
			}
			else
			{
				user.UpdateUserZMoney( -nMoney);
			}
			GuiMgr.getInstance().GuiMain.UpdateInfo();
			
			if (ItemType == "Food")
			{
				user.UpdateFoodCount(int(obj["Num"]));
			}
			
			var test:SendBuyOther = new SendBuyOther();
			if (obj["Count"])
			{
				test.AddNew(ItemType, ItemId, obj["Count"], BuyType);
			}
			else
			{
				test.AddNew(ItemType, ItemId, obj["Num"], BuyType);
			}
			Exchange.GetInstance().Send(test);
			
			if (ItemType != "EnergyMachine")
				user.UpdateStockThing(ItemType, ItemId, 1);
			else
			{
				user.GetMyInfo().BuyEnergyMachine(ItemId);
			}
			
			//Hiện thông báo mua thành công
			if (ishasMessage)
			{
				if(ItemType != "Draft" && ItemType != "GoatSkin" && ItemType != "Paper" && ItemType != "Blessing")
					EffectMgr.setEffBounceDown("Mua thành công", ItemType + ItemId, 330, 280);
				else
				{
					//EffectMgr.setEffBounceDown("Mua thành công", ItemType + "_" + GUIMixFormulaInfo.getElementsName(obj["Elements"]) + "_" + ItemId, 330, 280);
					EffectMgr.setEffBounceDown("Mua thành công", ItemType + "_" + obj["Elements"], 330, 280);
				}
			}
			
			if (GuiMgr.getInstance().GuiExpandLake.IsVisible)
			{
				GuiMgr.getInstance().GuiExpandLake.UpdateLicense();
			}
			
			if (GuiMgr.getInstance().GuiUnlockLake.IsVisible)
			{
				GuiMgr.getInstance().GuiUnlockLake.UpdateLicense();
			}
			
			GuiMgr.getInstance().GuiRawMaterials.StateBuyShop = 2;
			return true;
		}	
		
		
		public function BuySpecialFish(ItemType:String, buyType:String, ishasMessage:Boolean = true):Boolean
		{
			// kiem tra tien
			var obj:Object = ConfigJSON.getInstance().getSuperFishInfo(ItemType);
			var MoneyHave:Number = 0;
			var BuyType:String = buyType;			
			var nMoney:int = obj[BuyType];
			if (BuyType == "Money")
			{
				MoneyHave = user.GetMoney();
			}
			else
			{
				MoneyHave = user.GetZMoney();
			}
			if (nMoney > MoneyHave)
			{
				return false;
			}
			
			if (BuyType == "Money")
			{
				user.UpdateUserMoney( -nMoney);
			}
			else
			{
				user.UpdateUserZMoney( -nMoney);
			}
			
			var cmd:SendBuySpecialFish = new SendBuySpecialFish(ItemType, 1, false);
			Exchange.GetInstance().Send(cmd);
				
			user.GenerateNextID();
			GameLogic.getInstance().user.StockThingsArr.numSparta ++;
			if (GuiMgr.getInstance().GuiStore.IsVisible) 
			{
				GuiMgr.getInstance().GuiStore.Hide();
			}
			
			user.GetMyInfo().BuySuperFishTime[ItemType] -= 1;

			EffectMgr.setEffBounceDown("Cá đã vào kho", ItemType, 330, 280);
		
			return true;
		}	
		
		
		
		public function BuyDecorate(deco:Decorate):Boolean
		{
			if (user.IsViewer())
			{
				BackToIdleGameState();
				return false;
			}
			
			if (!deco.CheckPosition())
			{
				return false;
			}
			
			// kiem tra tien
			//var obj:Object = INI.getInstance().getItemInfo(deco.ItemId.toString(), deco.ItemType);
			var obj:Object = ConfigJSON.getInstance().getItemInfo(deco.ItemType, deco.ItemId);
			
			//var BuyType:String = GuiMgr.getInstance().GuiBuyShop.BuyType;
			var BuyType:String = GuiMgr.getInstance().GuiShop.BuyType;
			var nMoney:int = obj[BuyType];
			var MoneyHave:Number = 0;
			var nExp:int = obj["Exp"];
			
			if (BuyType == "Money")
			{
				MoneyHave = user.GetMoney();
			}
			else
			{
				MoneyHave = user.GetZMoney();
			}
			
			if (nMoney <= MoneyHave)
			{
				//user.UpdateUserMoney( -nMoney);
				//user.UpdateUserExp(nExp);
			}
			else
			{
				BackToIdleGameState();
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message16"));
				return false;
			}
			
			deco.SetHighLight( -1);
			user.AddNewDecorate(deco);
			
			deco.Id = user.GenerateNextID();
			deco.expiredTime = CurServerTime + deco.extendTime;
			//update item deco
			var item:Object = new Object();
			item["Id"] = deco.Id;
			item["ItemType"] = deco.ItemType;
			item["ItemId"] = deco.ItemId;
			item["ExpiredTime"] = deco.expiredTime;
			item["Num"] = 1;
			GameLogic.getInstance().user.item.push(item);
			
			
			var test:SendBuyDecorate = new SendBuyDecorate(user.CurLake.Id);
			test.AddNew(deco.Id, deco.ItemId, deco.ItemType, BuyType, deco.CurPos.x, deco.CurPos.y);
			Exchange.GetInstance().Send(test);
			
			if (BuyType == "Money")
			{
				user.UpdateUserMoney( -nMoney);
			}
			else
			{
				user.UpdateUserZMoney( -nMoney);
			}
			GuiMgr.getInstance().GuiMain.UpdateInfo();
			return true;
		}
		
		
		public function buyBackGround(itemId:int):void
		{
			if (user.IsViewer())
			{
				BackToIdleGameState();
				return;
			}
			
			// kiem tra tien
			//var obj:Object = INI.getInstance().getItemInfo(deco.ItemId.toString(), deco.ItemType);
			var obj:Object = ConfigJSON.getInstance().getItemInfo("BackGround", itemId);
			
			//var BuyType:String = GuiMgr.getInstance().GuiBuyShop.BuyType;
			var BuyType:String = GuiMgr.getInstance().GuiShop.BuyType;
			var nMoney:int = obj[BuyType];
			var MoneyHave:Number;
			var nExp:int = obj["Exp"];
			
			if (BuyType == "Money")
			{
				MoneyHave = user.GetMoney();
			}
			else
			{
				MoneyHave = user.GetZMoney();
			}
			
			if (nMoney <= MoneyHave)
			{
				//user.UpdateUserMoney( -nMoney);
				//user.UpdateUserExp(nExp);
			}
			else
			{
				BackToIdleGameState();
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message16"));
				return;
			}		
			
			var id:int = user.GenerateNextID();
			var test:SendBuyBackGround = new SendBuyBackGround();
			test.AddNew(id, itemId, "BackGround", BuyType);
			Exchange.GetInstance().Send(test);
			
			//Update vào kho
			var dec:Decorate = new Decorate(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "BackGround" + itemId, 0, 0, "BackGround", itemId);
			dec.Id = id;
			dec.expiredTime =  CurServerTime + ConfigJSON.getInstance().getItemInfo("BackGround", itemId)["TimeUse"];
			StoreDecorate(dec);	
			
			//Hiện thông báo mua thành công
			EffectMgr.setEffBounceDown("Mua thành công", "BackGround" + itemId, 330, 280);
			
			if (BuyType == "Money")
			{
				user.UpdateUserMoney( -nMoney);
			}
			else
			{
				user.UpdateUserZMoney( -nMoney);
			}
			GuiMgr.getInstance().GuiMain.UpdateInfo();
		}
		
		
		public function SellStockDecorate(deco:StockThings):void
		{
			if (user.IsViewer())
			{
				BackToIdleGameState();
				return;
			}
			
			// kiem tra tien
			//var obj:Object = INI.getInstance().getItemInfo(deco.Id.toString(), deco.ItemType);
			var obj:Object = ConfigJSON.getInstance().getItemInfo(deco.ItemType, deco.Id);
			var nMoney:int = obj["Money"];
			user.UpdateUserMoney(nMoney/2);
			
			var pk:SendSellStockThing = new SendSellStockThing();
			pk.AddNew(deco);
			Exchange.GetInstance().Send(pk);
			GuiMgr.getInstance().GuiSubInvetory.DecreaseItem(deco, 1);
			GuiMgr.getInstance().GuiSubInvetory.Refresh();
		}
		
		public function SellStockFish(fish:StockThings):void
		{
			if (user.IsViewer())
			{
				BackToIdleGameState();
				return;
			}
			
			// kiem tra tien
			//var obj:Object = INI.getInstance().getItemInfo(fish.Id.toString(), fish.ItemType);
			var obj:Object = ConfigJSON.getInstance().getItemInfo(fish.ItemType, fish.Id);
			//var nMoney:int = obj["gold"]*fish.Num;
			var nMoney:int = obj["Money"]*fish.Num;			
			user.UpdateUserMoney(nMoney);
			
			var pk:SendSellStockThing = new SendSellStockThing();
			pk.AddNew(fish);
			Exchange.GetInstance().Send(pk);
			//GuiMgr.getInstance().GuiSubInvetory.DecreaseItem(fish, 1);
			//GuiMgr.getInstance().GuiSubInvetory.Refresh();
		}
			
		public function UseDecorate(deco:Decorate):void
		{
			if (user.IsViewer())
			{
				BackToIdleGameState();
				return;
			}
			
			if (!deco.CheckPosition())
			{
				//if (deco.Id < 0)
				//{
					//deco.ClearImage();
				//}
				//else
				{
					deco.img.visible = false;
				}
				GameController.getInstance().ActiveObj = null;
				return;
			}
			deco.ChangeLayer(Constant.OBJECT_LAYER);
			GameController.getInstance().UpdateDecorateChildIndex(deco);
			if (deco.IsNewObj)
			{
				deco.SaveInfo(false);
			}
			deco.SetHighLight( -1);
			deco.GoToAndPlay(1);
			user.AddNewDecorate(deco);
			
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			GameController.getInstance().ActiveObj = null;
			if (layer != null)
			{
				layer.HideDisableScreen();
			}
			
			// cap nhat lai kho
			GuiMgr.getInstance().GuiStore.UpdateStore(deco.ItemType, deco.Id, -1);
			
			//Cap nhat item
			var obj:Object = new Object();
			obj["Id"] = deco.Id;
			obj["ItemType"] = deco.ItemType;
			obj["ItemId"] = deco.ItemId;
			obj["ExpiredTime"] = deco.expiredTime;
			obj["Num"] = 1;
			GameLogic.getInstance().user.item.push(obj);
		}		
		
		public function MoveDecorate(deco:Decorate):void
		{
			if (user.IsViewer())
			{
				return;
			}
			// chinh lai vi tri neu can
			if (!deco.CheckPosition())
			{
				deco.UnMovePos();
			}
			deco.DoMovePos(deco.img.x, deco.img.y);
			GameController.getInstance().UpdateDecorateChildIndex(deco);
			if (deco.ItemType == "OceanAnimal")
			{
				deco.GoToAndPlay(2);
			}
			//user.AddNewDecorate(deco);
			
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			GameController.getInstance().ActiveObj = null;
			if (layer != null)
			{
				layer.HideDisableScreen();
			}
			if (deco.ClassName == "Decorate")
			{
				GuiMgr.getInstance().GuiDecorateInfo.CurObject = deco;
				//layer.ShowDisableScreen(0.1);
				GuiMgr.getInstance().GuiDecorateInfo.ShowDecoInfo(deco);
			}
			else if (deco.ClassName == "FishSpartan")
			{
				GuiMgr.getInstance().GuiDecorateInfo.CurObject = deco as FishSpartan;
			}
			
			GuiMgr.getInstance().GuiStore.ShowSaveDeco();
		}
		
		public function StoreDecorate(deco:Decorate):void
		{
			if (user.IsViewer())
			{
				BackToIdleGameState();
				return;
			}
			
			deco.ChangeLayer(Constant.OBJECT_LAYER);
			deco.SetHighLight( -1);
			deco.img.visible = false;
			deco.hideButtonExtend();
			//var decoArr:Array = user.GetDecoArr();
			//var index:int = decoArr.indexOf(deco);
			//deco.ClearImage();
			GameController.getInstance().ActiveObj = null;
			//decoArr.splice(index, 1);
			
			GuiMgr.getInstance().GuiDecorateInfo.Hide();
			LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).HideDisableScreen();
			//SetState(GameState.GAMESTATE_IDLE);
			
			// update lai store
			var obj:Object = new Object();
			obj["Id"] = deco.Id;
			obj["ItemType"] = deco.ItemType;
			obj["ItemId"] = deco.ItemId;
			obj["ExpiredTime"] = deco.expiredTime;
			obj["Num"] = 1;
			obj["Option"] = deco.Option;
			
			var decoList:Array = GameLogic.getInstance().user.StockThingsArr[deco.ItemType];
			var check:Boolean = true;
			for each(var object:Object in decoList)
			{
				if (object["Id"] == obj["Id"])
				{
					check = false;
					break;
				}
			}
			if(check && CurServerTime < obj["ExpiredTime"] + Constant.TIME_DISAPPEAR)
			{
				decoList.push(obj);
			}
			
			//update item deco
			var item:Array = GameLogic.getInstance().user.item;
			for (var i:int = 0; i < item.length; i++)
			{
				if (item[i]["Id"] == deco.Id)
				{
					item.splice(i, 1);
					break;
				}
			}
			
			var guiStore:GUIStore = GuiMgr.getInstance().GuiStore;
			if (guiStore.IsVisible)
			{
				guiStore.ClearComponent();
				//guiStore.updateStateForMagicBag();
				guiStore.InitStore(guiStore.CurrentStore, guiStore.CurrentPage);
				if (guiStore.btnSaveDeco != null)
				{
					guiStore.btnSaveDeco.SetVisible(true);
				}
			}
		}
		
		public function DoCleanLake(dirty:Dirty):void
		{
			if (dirty.IsCleaning) return;
			var energy:int = ConfigJSON.getInstance().getEnergyInfo("cleanlake");
			//if (user.IsViewer())
			{
				if (user.GetEnergy() < energy)
				{
					//var st:String = Localization.getInstance().getString("Message4");
					//GuiMgr.getInstance().GuiMessageBox.ShowOK(st);
					GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 3);
					return;
				}
			}
				
			// Play sound
			var sound:Sound = SoundMgr.getInstance().getSound("Laube") as Sound;
			if (sound != null)
			{
				sound.play();
				//sound.positi
			}
			// send to server
			var test:SendCleanLake = new SendCleanLake(user.CurLake.Id, user.Id);
			test.AddDirty(dirty);
			Exchange.GetInstance().Send(test);			
			
			// effect
			swfEffClean = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffCleanLake", null, GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y)//, false, true);
			
			var exp:int = ConfigJSON.getInstance().getActionExp("cleanlake");		
			//var child1:Sprite = Ultility.EffExpMoneyEnergy("exp", exp);
			var arr:Array = [];
			//arr.push(child1);
			if (user.IsViewer())
			{
				var child2:Sprite = Ultility.EffExpMoneyEnergy("energy", -energy);// * NewCmd.Num);
				arr.push(child2);
			}
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffSellFish", arr, dirty.img.x + 40, dirty.img.y + 20);
			
			//effect kinh nghiệm rơi ra
			//var srcPos:Point = Ultility.PosLakeToScreen(dirty.img.x, dirty.img.y);
			EffectMgr.getInstance().fallFlyXP(dirty.img.x, dirty.img.y, exp);
			
			// xoa hi`nh vet ban khoi be
			var i:int;
			var UserArr:Array = user.GetDirtyArray();
			var vt:int = UserArr.indexOf(dirty);
			if (vt >= 0)
			{
				// clear image
				dirty.ClearImage();
				UserArr.splice(vt, 1);
			}
			
			// update info			
			//if (user.IsViewer())
			{
				user.UpdateEnergy(-energy);
			}
			user.CurLake.CleanAmount += 1;
			var nDirty:int = user.CurLake.GetDirtyAmount();
			GameController.getInstance().SetLakeBright(0.5 + 0.5 * (1 - nDirty / Lake.MAX_DIRTY));
			GuiMgr.getInstance().GuiMain.UpdateInfo(true);
			
			// hien effect mat cuoi neu be sach
			if (nDirty == 0)
			{
				var fishArr:Array = user.GetFishArr();
				var fish:Fish;
				for (i = 0; i < fishArr.length; i++)
				{
					fish = fishArr[i] as Fish;
					fish.SetEmotion(Fish.HAPPY);
				}
				
				//var fishSArr:Array = user.GetFishSoldierArr();
				//var fs:FishSoldier;
				//for (i = 0; i < fishSArr.length; i++)
				//{
					//fs = fishSArr[i] as FishSoldier;
					//fs.SetEmotion(Fish.HAPPY);
				//}
				
				//var posPgr:Point = new Point(GuiMgr.getInstance().GuiTopInfo.prgClean.imgBg.x, GuiMgr.getInstance().GuiTopInfo.prgClean.imgBg.y);				
				//EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER + 1, "EffFullClean", null, posPgr.x, posPgr.y);
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER + 1, "EffNhapNhay", null, 200, 300);
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER + 1, "EffNhapNhay", null, 400, 400);
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER + 1, "EffNhapNhay", null, 667, 200);
			}
			BackToOldMouse();
			
			// Lảm nhảm
			FishChatting(Constant.CHAT_CLEAN_LAKE, 5000, 2);
		}
		
		public function ProcessCleanLake(pOldCmd:Object, pNewCmd:Object):void
		{
			var OldCmd:SendCleanLake =  pOldCmd as SendCleanLake;
			var NewCmd:GetCleanLake = new GetCleanLake(pNewCmd);
			var dirty:Dirty;
			var i:int;
			var pos:Point = OldCmd.GetPos();			
			var energy:int = ConfigJSON.getInstance().getEnergyInfo("cleanlake");
			
			//trace("NewCmd.Exp, num", NewCmd.Exp, NewCmd.Num);
			if (user.IsViewer())
			{			
				//Ghi lại log
				log.AddAct(LogInfo.ID_CLEAN_LAKE);
			}
			
			//Rơi ra bonus
			for (i = 0; i < NewCmd.Bonus.length; i++) 
			{
				//var obj:Object = ConfigJSON.getInstance().GetItemInfo("ActionGift", NewCmd.Bonus[i]);
				//DropActionGift(obj, pos.x, pos.y);					
				DropActionGift(NewCmd.Bonus[i], pos.x, pos.y);					
			}
			
			//Roi ra 1 so thu trong event
			
			if (NewCmd.EventBonus)
			{
				for (var k:int = 0; k < NewCmd.EventBonus.length; k++) 
				{
					if (!Treasure.CheckEvent("PearFlower")) break;
					//var obj:Object = ConfigJSON.getInstance().GetItemInfo("Icon", NewCmd.EventBonus[k]);
					//if (obj)
					{
						//obj["Num"] = 1; //So luong roi ra = 1
						DropActionGift(NewCmd.EventBonus[k], pos.x, pos.y);
					}
				}
			}	
			
			//Rơi đồ trong event 2-9
			dropBonusEventND(OldCmd, NewCmd.EventBonus);
			
			// Bù lại năg lượng
			if (NewCmd.Num < OldCmd.GetDirtyArr().length)// && user.IsViewer())
			{
				user.UpdateEnergy(energy * (OldCmd.GetDirtyArr().length - NewCmd.Num));				
			}
		}			
		
		public function DoUnlockLake(lake:Lake):void
		{
			// cap nhat exp va money
			var nMoney:int = lake.GetUnlockMoney();
			var nExp:int = lake.GetUnlockExp();
			
			//Tăng autoId lên 1 vì server tạo ra 1 background mặc định và tăng autoId lên 1
			user.GenerateNextID();
			
			var test:SendUnlockLake = new SendUnlockLake();
			Exchange.GetInstance().Send(test);
			
			//user.UpdateUserMoney( -nMoney);
			user.UpdateUserLicense( -lake.LakeLevels[lake.Level]["License"]);
			
			// hien man hinh che
			GuiMgr.getInstance().GuiWaitingData.Show(Constant.TopLayer - 1, 6);
		}

		public function ProcessUnlockLake():void
		{
			GuiMgr.getInstance().GuiMessageBox.Hide();
			
			// update thong tin ho
			GuiMgr.getInstance().GuiMain.SelectedLake.SetUnlock();
			GuiMgr.getInstance().GuiMain.RefreshGUI();

			// tro ve trang thai idle
			SetState(GameState.GAMESTATE_IDLE);
			
			// tăng số lượng hồ của user lên 1
			user.LakeNumb++;
			
			// hien lai gui shop
			//if (GuiMgr.getInstance().GuiShop.IsVisible)
			//{
				//GameController.getInstance().UseTool("Shop");
				//GameController.getInstance().UseTool("Shop");
			//}
			//if (GuiMgr.getInstance().GuiShop.IsVisible)
			//{
				//GuiMgr.getInstance().GuiShop.showTab(GuiMgr.getInstance().GuiShop.CurrentShop);
			//}
			GuiMgr.getInstance().GuiWaitingData.Hide();
			GuiMgr.getInstance().GuiMain.ShowLakes();
			
			// chuc mung
			var st:String = Localization.getInstance().getString("Message13");
			GuiMgr.getInstance().GuiMessageBox.ShowFeedUnlockLake(st);
		}
		
		public function DoUpgradeLake():void
		{
			// cap nhat exp va money
			//var lake:Lake = user.GetLake(GuiMgr.getInstance().GuiBuyShop.BuyObjID);
			var lake:Lake = user.GetLake(user.CurLake.Id);
			var nMoney:int = lake.GetUpgradeMoney();
			var nExp:int = lake.GetUpgradeExp();
			
			var test:SendUpgradeLake = new SendUpgradeLake(lake.Id);
			Exchange.GetInstance().Send(test);

			//user.UpdateUserMoney( -nMoney);
			//user.SetUserExp(user.GetExp() + nExp);
			
			user.UpdateUserLicense( -lake.LakeLevels[lake.Level]["License"]);
			
			// hien man hinh che
			GuiMgr.getInstance().GuiWaitingData.Show(Constant.TopLayer-1, 6);
		}
		
		public function ProcessUpgradeLake(OldData:Object):void
		{
			var pCmd:SendUpgradeLake = OldData as SendUpgradeLake;
			var lake:Lake = user.GetLake(pCmd.LakeId);
			
			// update thong tin ho
			lake.SetUpgrade();
			
			// tro ve trang thai idle
			SetState(GameState.GAMESTATE_IDLE);
			//GuiMgr.getInstance().GuiMain.ShowUpgradeLake(user.CanUserUpgradeLake(lake.Id));
			GuiMgr.getInstance().GuiMain.UpdateInfo(true);
			GuiMgr.getInstance().GuiMain.RefreshGUI();
			//GuiMgr.getInstance().GuiMain.ShowLakes();
			
			// hien lai gui shop
			//if (GuiMgr.getInstance().GuiShop.IsVisible)
			//{
				//GameController.getInstance().UseTool("Shop");
				//GameController.getInstance().UseTool("Shop");
			//}
			//if (GuiMgr.getInstance().GuiShop.IsVisible)
			//{
				//GuiMgr.getInstance().GuiShop.showTab(GuiMgr.getInstance().GuiShop.CurrentShop);
			//}
			GuiMgr.getInstance().GuiWaitingData.Hide();
			
			// chuc mung
			var st:String = Localization.getInstance().getString("Message14");
			GuiMgr.getInstance().GuiMessageBox.ShowFeedUpgradeLake(st, lake);
			GuiMgr.getInstance().GuiMain.ShowLakes();
			//GuiMgr.getInstance().GuiExpandLake.EndingRoomOut();
			GuiMgr.getInstance().GuiExpandLake.Hide();
		}
		
		public function DoGoToLake(lakeID:int, uID:int):void
		{
			if (uID != GameLogic.getInstance().user.GetMyInfo().Id && GameLogic.getInstance().user.GetMyInfo().Id != -1)
			{
				ResMgr.getInstance().LoadFileContent("LoadingWar");
			}
			
			// Gửi hết các gói thức ăn đang rắc
			var i:int;
			var j:int;
			var arr:Array;
			while (ListFood.length > 0)
			{
				arr = ListFood[0];				
				FeedFish(arr);
				ListFood.splice(0, 1);				
			}
			
			// Chuyển hồ
			
			
			// Khởi tạo
			var test:SendInitRun = new SendInitRun();
			test.LakeId = lakeID;
			test.UserId = uID.toString();
			Exchange.GetInstance().Send(test);
			
			var sol:SendGetAllSoldier = new SendGetAllSoldier(uID.toString());
			Exchange.GetInstance().Send(sol);
			
			if (uID != user.GetMyInfo().Id)
			{
				var solMine:SendGetAllSoldier = new SendGetAllSoldier();
				Exchange.GetInstance().Send(solMine);
			}
			GuiMgr.getInstance().GuiWaitingData.Show(Constant.TopLayer-1, 6);
			
			//if (GuiMgr.getInstance().GuiLakes.IsVisible)
			//{
				//var x:int = GuiMgr.getInstance().GuiMain.img.x;
				//var y:int = GuiMgr.getInstance().GuiMain.img.y;
				//GuiMgr.getInstance().GuiLakes.MoveHide(x + GuiMgr.getInstance().GuiMain.btnLakes.img.x + 20, y);
			//}
			
		}
		
		public function SetState(state:int):void
		{
			if(state != GameState.GAMESTATE_IDLE && state != GameState.GAMESTATE_INIT)
			{
				BackToIdleGameState();
			}
			gameState = state;
		}
		
		public function SetMode(mode:int):void
		{
			gameMode = mode;
		}
		
		public function BackToIdleGameState():void
		{
			GameLogic.getInstance().MouseTransform("");
			switch (gameState)
			{
				case GameState.GAMESTATE_BUY_DECORATE:
					//GuiMgr.getInstance().GuiBuyDecorate.Hide();
					if (GameController.getInstance().ActiveObj != null)
					{
						GameController.getInstance().ActiveObj.ClearImage();
						GameController.getInstance().ActiveObj = null;
						//GuiMgr.getInstance().GuiBuyShop.FinishBuy();
						GuiMgr.getInstance().GuiShop.FinishBuy();						
					}
					break;
					
				case GameState.GAMESTATE_BUY_FISH:
					if (GameController.getInstance().ActiveObj != null)
					{
						GameController.getInstance().ActiveObj.ClearImage();
						GameController.getInstance().ActiveObj = null;
						//GuiMgr.getInstance().GuiBuyShop.FinishBuy();
						GuiMgr.getInstance().GuiShop.FinishBuy();	
						GuiMgr.getInstance().GuiBuyFish.Close();
					}
					break;
				
				case GameState.GAMESTATE_USE_DECORATE:
				if (GameController.getInstance().ActiveObj != null)
				{
					GameController.getInstance().ActiveObj.ClearImage();
					GameController.getInstance().ActiveObj = null;
					LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).HideDisableScreen();
				}
				break;
			
				case GameState.GAMESTATE_EDIT_DECORATE:
					var deco:Decorate = GameController.getInstance().ActiveObj as Decorate;
					if (deco != null)
					{
						if (deco.ObjectState == BaseObject.OBJ_STATE_EDIT)
						{
							deco.ChangeLayer(Constant.OBJECT_LAYER);
							deco.UnSaveEdit();
							GameController.getInstance().UpdateDecorateChildIndex(deco);
							GameController.getInstance().ActiveObj = null;
						}
					}
					if (GuiMgr.getInstance().GuiStore.CurrentStore == "Decorate")
					{
						GuiMgr.getInstance().GuiStore.Hide();
					}
					if (CanSaveDecorate())
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(Localization.getInstance().getString("Message5"));
						return;
					}
					else
					{
						ShowFish();
						GuiMgr.getInstance().GuiDecorateInfo.Hide();
						LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).HideDisableScreen();
						if (GuiMgr.getInstance().GuiDecorateInfo.CurObject != null)
						{
							GuiMgr.getInstance().GuiDecorateInfo.CurObject.SetHighLight( -1);
						}
						GameController.getInstance().ActiveObj = null;
					}
					
					break;
				
				case GameState.GAMESTATE_MOVE_DECORATE:
					MoveDecorate(GameController.getInstance().ActiveObj as Decorate);
					break;
					
				case GameState.GAMESTATE_FEED_FISH:
					if (GameController.getInstance().ActiveObj != null)
					{
						GameController.getInstance().ActiveObj.ClearImage();
						GameController.getInstance().ActiveObj = null;
					}
					LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).HideDisableScreen();
					LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).HideDisableScreen();
					
					//Ẩn thanh thức ăn đi
					HideGuiFishStatus();
					break;
					
				case GameState.GAMESTATE_CURE_FISH:
					var fishArr:Array = GameLogic.getInstance().user.GetFishArr();
					for (var i:int = 0; i < fishArr.length; i++ )
					{
						var f:Fish = fishArr[i] as Fish;
						if (f.Emotion == Fish.ILL)
						{
							f.SetHighLight(-1);
						}
					}
					break;
				
				case GameState.GAMESTATE_CARE_FISH:
					fishArr = GameLogic.getInstance().user.GetFishArr();
					for (i = 0; i < fishArr.length; i++ )
					{
						var fish:Fish = fishArr[i] as Fish;
						fish.SetHighLight(-1);
					}
					break;
					
				case GameState.GAMESTATE_SELL_FISH:
					if (GameController.getInstance().ActiveObj != null)
					{
						GameController.getInstance().ActiveObj.ClearImage();
						GameController.getInstance().ActiveObj = null;
					}
					fishArr = GameLogic.getInstance().user.GetFishArr();
					//Ẩn thanh tăng trưởng
					HideGuiFishStatus();
					break;
				case GameState.GAMESTATE_RESET_MATE_FISH:
					HideGuiFishStatus();
					break;
				case GameState.GAMESTATE_INCREASE_RANK_POINT:
				case GameState.GAMESTATE_RECOVER_HEALTH_SOLDIER:
				case GameState.GAMESTATE_OTHER_BUFF_SOLDIER:
					HideGuiFishStatus();
					break;
				default:
					GuiMgr.getInstance().GuiFishInfo.HideDrop();
					break;
			}			
			
			SetState(GameState.GAMESTATE_IDLE);
		}
		
		public function GetFishCurLake(id:int):Fish
		{
			var f:Fish;
			var i:int;
			for (i = 0; i < user.FishArr.length; i++)
			{
				f = user.FishArr[i];
				if (f.Id == id)
				{
					return f;
				}
			}
			
			return null;
		}
		
		public function Sell(obj:BaseObject):BaseObject
		{
			switch (obj.ClassName)
			{
				case "Decorate":
					SellDeco(obj as Decorate);
					break;
				case "Fish":
					SellFish(obj as Fish);
					break;
				case "FishSpartan":
					SellFishSpartan(obj as FishSpartan);
					break;
			}
			return obj;
		}
		
		public function ClickGrave(fish:FishSoldier):FishSoldier
		{
			// Gửi gói tin đào mộ
			var cmd:SendClickGrave = new SendClickGrave(fish.LakeId, fish.Id);
			Exchange.GetInstance().Send(cmd);
			
			for (var i:int = 0; i < user.FishSoldierExpired.length; i++)
			{
				if (fish.Id == user.FishSoldierExpired[i].Id)
				{
					GraveList.push(user.FishSoldierExpired[i] as FishSoldier);
					user.FishSoldierExpired.splice(i, 1);
				}
			}
			
			var ctn:Container = new Container(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "ImgFrameFriend", fish.CurPos.x, fish.CurPos.y);
			//var ctn:Container = new Container(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "PrgFood_bg", fish.img.x, fish.img.y);
			var PrgGrave:ProgressBar = ctn.AddProgress("", "PrgFood", 0, 0, null, false);
			PrgGrave.setStatus(0);
			PrgGraveList.push(PrgGrave);
			
			return fish;
		}
		
		public function UpdatePrgGraveStatus():void
		{
			for (var i:int = 0; i < PrgGraveList.length; i++)
			{
				var newStatus:Number = PrgGraveList[i].GetStatus() + 0.015;
				if (newStatus >= 1)
				{
					newStatus = 1;
					PrgGraveList[i].setStatus(newStatus);
					if (GraveBonus.length != 0)
					{
						var obj:Object = new Object();
						obj["exp"] = 0;
						obj["money"] = 0;
						for (var j:int = 0; j < GraveBonus[0].length; j++)
						{
							//var p:Point = PrgGraveList[i].img.localToGlobal(new Point(PrgGraveList[i].img.x, PrgGraveList[i].img.y));
							var p:Point = GraveList[i].CurPos;
							switch (GraveBonus[0][j]["ItemType"])
							{
								case "Money":
									obj["money"] = GraveBonus[0][j]["Num"];
									break;
								case "Exp":	
									obj["exp"] = GraveBonus[0][j]["Num"];
									break;
							}
						}
						
						if (!user.IsViewer())
							EffectMgr.getInstance().fallExpMoney(obj["exp"], obj["money"], new Point(p.x, p.y), 5, 50);
						
						var pi:ProgressBar = PrgGraveList[i];
						pi.img.visible = false;
						//pi.imgBg.visible = false;
						GraveList[i].img.visible = false;
						PrgGraveList.splice(i, 1);
						GraveList.splice(i, 1);
						GraveBonus.splice(0, 1);
					}
				}
				else
				{
					PrgGraveList[i].setStatus(newStatus);
				}
			}
		}
		
		public function SellFish(fish:Fish):Fish
		{			
			// Play sound
			var sound:Sound = SoundMgr.getInstance().getSound("BanCa") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			//132999 + 3560
			//Avatar bán cá
			//GuiMgr.getInstance().GuiCharacter.PlayAni(GUICharacter.ANI_SALE);		
			
			// Thu hoạch túi tiền trước		
			var money1:int = 0;
			for (var i:int = 0; i < user.PocketArr.length; i++)
			{
				var pocket:Pocket = user.PocketArr[i] as Pocket;
				if(pocket.fish.Id == fish.Id)
				{					
					money1 = pocket.GetCurrent();
					var child3:Sprite = Ultility.EffExpMoneyEnergy("money", money1);
					var arr1:Array = [];
					arr1.push(child3);
					EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffSellFish", arr1, pocket.CurPos.x, pocket.CurPos.y);
					user.UpdateUserMoney(money1);
					user.PocketArr.splice(i, 1);
					pocket.ClearImage();
					break;
				}
			}
			
			//Thu hoạch bong bóng trước
			for ( i = 0; i < balloonArr.length; i++)
			{
				var balloon:Balloon = balloonArr[i];
				if (balloon.myFish.Id == fish.Id)
				{
					balloon.collect(false);
					i--;
				}
			}
			
			//Gui goi tin ban ca di
			var cmd:SendSellFish = new SendSellFish(user.CurLake.Id);				
			cmd.AddNew(fish);
			Exchange.GetInstance().Send(cmd);
			
			// xóa thông tin khỏi mảng AllFishArr trong user
			var obj:Object = user.getFishInfo(fish.Id);
			var idx:int = user.AllFishArr.indexOf(obj);
			user.AllFishArr.splice(idx, 1);			
			
			user.CurLake.NumFish--;
			//Cong tien cho user
			var money:int = fish.GetValue();
			//Cong diem kinh nghiem cho user
			var exp:int = 0
			if (fish.Growth() < 1)
			{
				exp = 0;
			}
			else
			{
				//exp = ConfigJSON.getInstance().GetItemInfo(Fish.ItemType, fish.FishTypeId)["Exp"];
				exp = fish.getExp();
			}
			//if (user.CurLake.Option["Exp"] > 0)
				//exp *= Math.min(user.CurLake.Option["Exp"], 50);
			
			// Effect
			//var arr:Array = [];	
			//var st0:String = "+" + money;
			//var txtFormat :TextFormat = new TextFormat("Arial", 18, 0xffffff, true);
			//txtFormat.align = "left"
			//var tmp:Sprite = ResMgr.getInstance().GetRes("IcGold") as Sprite;
			//var child:Sprite = new Sprite();					
			//child.addChild(tmp);					
			//tmp.x = -tmp.width;
			//tmp.y = -12;
			//var tmp0:Sprite = Ultility.CreateSpriteText(st0, txtFormat);					
			//child.addChild(tmp0);					
			//tmp0.x = 0;
			//tmp0.y = 0;					
			//arr.push(child);					
			//
			//var st1:String = "+" + exp;
			//var child1:Sprite = new Sprite();
			//var tmp1:Sprite = ResMgr.getInstance().GetRes("ImgXP") as Sprite;
			//child1.addChild(tmp1);
			//tmp1.x = -tmp1.width;
			//tmp1.y = -16;
			//var tmp11:Sprite = Ultility.CreateSpriteText(st1, txtFormat);
			//child1.addChild(tmp11);					
			//tmp11.x = 0;
			//tmp11.y = 0;					
			//arr.push(child1);			
			
			//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffSellFish", arr, fish.CurPos.x, fish.CurPos.y);
			
			//effect tiền và kinh nghiệm rơi ra
			var p:Point = fish.CurPos;
			EffectMgr.getInstance().fallFlyMoney(p.x, p.y, money);
			EffectMgr.getInstance().fallFlyXP(p.x, p.y, exp);
			
			// Cập nhật lại các biến mà con cá đặc biệt có thể ảnh hưởng
			//user.UpdateOptionLake( -1, fish);
			user.UpdateOptionLakeObject( -1, fish.RateOption, user.CurLake.Id);
			
			//xoa con ca khoi mang ca
			var index:int = user.FishArr.indexOf(fish);
			var fishArr:Array = user.GetFishArr();
			fish.Clear();
			fishArr.splice(index, 1);
			
			//Cap nhat thong tin tren guimain
			GuiMgr.getInstance().GuiMain.UpdateInfo(true);
			// Cập nhật lại các biến mà con cá đặc biệt có thể ảnh hưởng
			//if(fish.RateOption != null && fish.RateOption["Time"] != null)
				//user.CurLake.Option["Time"] -= fish.RateOption["Time"];
			//if(fish.RateOption != null && fish.RateOption["Money"] != null)
				//user.CurLake.Option["Money"] -= fish.RateOption["Money"];
			//if(fish.RateOption != null && fish.RateOption["MixFish"] != null)
				//user.CurLake.Option["MixFish"] -= fish.RateOption["MixFish"];
			//if(fish.RateOption != null && fish.RateOption["Exp"] != null)
				//user.CurLake.Option["Exp"] -= fish.RateOption["Exp"];
			//Cập nhật thông tin havest time
			//user.UpdateHavestTime();
			//for (var iFishSell:int = 0; iFishSell < user.FishArr.length; iFishSell++) 
			//{
				//var fish:Fish = user.FishArr[iFishSell];
				//ClearPocket();
			//}
			ClearPocket();
			return fish;
		}
		
		/**
		 * Bán cá lính
		 * @author longpt
		 * @param	fish
		 * @return
		 */
		public function SellFishSoldier(fish:FishSoldier):FishSoldier
		{
			// Play sound
			var sound:Sound = SoundMgr.getInstance().getSound("BanCa") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			
			// Gửi gói tin
			var cmd:SendSellFish = new SendSellFish(user.CurLake.Id);				
			cmd.AddNew(fish);
			Exchange.GetInstance().Send(cmd);
			
			// Xóa thông tin khỏi mảng FishSoldierArr và MyInfo.FIshSoldierARr
			var j:int;
			for (j = 0; j < user.FishSoldierArr.length; j++)
			{
				if (user.FishSoldierArr[j].Id == fish.Id)
				{
					break;
				}
			}
			fish.Clear();
			user.FishSoldierArr.splice(j, 1);
			user.CurLake.NumSoldier--;
			user.NumSoldier--;
			
			var mi:MyUserInfo = user.GetMyInfo();
			for (j = 0; j < mi.MySoldierArr.length; j++)
			{
				if (mi.MySoldierArr[j].Id == fish.Id)
				{
					break;
				}
			}
			mi.MySoldierArr.splice(j, 1);
			//cập nhật ngay nút liên đấu HiepNM2
			LeagueMgr.getInstance().hasUpdateButton = true;
			//user.CurLake.ElementList[fish.Element] -= 1;
			user.ElementList[fish.Element] -= 1;
			if (user.ElementList[fish.Element] == 0)
			{
				delete(user.ElementList[fish.Element]);
			}
			
			//Cap nhat thong tin tren guimain
			GuiMgr.getInstance().GuiMain.UpdateInfo(true);

			return fish;
		}
		
		public function SellFishSpartan(fish:FishSpartan):FishSpartan
		{			
			// Play sound
			var sound:Sound = SoundMgr.getInstance().getSound("BanCa") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			
			//Cong tien cho user
			var money:int = fish.GetValue();
			//Cong diem kinh nghiem cho user
			var exp:int = fish.getExp();
			
			//effect tiền và kinh nghiệm rơi ra
			var p:Point = fish.CurPos;
			EffectMgr.getInstance().fallFlyMoney(p.x, p.y, money);
			EffectMgr.getInstance().fallFlyXP(p.x, p.y, exp);
			
			// Cập nhật lại các biến mà con cá đặc biệt có thể ảnh hưởng
			if(fish.isExpired)
				user.UpdateOptionLakeObject(-1, fish.RateOption, user.CurLake.Id);// ( -1, fish);
			
			//xoa con ca khoi mang ca
			fish.Clear();
			var index:int;
			if (fish.isExpired)
			{
				index = user.FishArrSpartan.indexOf(fish);
				user.FishArrSpartan.splice(index, 1);
			}
			else
			{
				index = user.FishArrSpartanDeactive.indexOf(fish);
				user.FishArrSpartanDeactive.splice(index, 1);
			}
			
			//Gui goi tin ban ca di
			var cmd:SendSellSparta = new SendSellSparta(user.CurLake.Id, fish.Id, fish.NameItem);
			Exchange.GetInstance().Send(cmd);
			
			//Cap nhat thong tin tren guimain
			GuiMgr.getInstance().GuiMain.UpdateInfo(true);
			//Cập nhật thông tin havest time
			//user.UpdateHavestTime();
			ClearPocket();
			return fish;
		}
		
		public function SellFireworkFish(fish:FireworkFish):void
		{			
			// Play sound
			var sound:Sound = SoundMgr.getInstance().getSound("BanCa") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			
			//Cong tien cho user
			var money:int = fish.GetValue();
			//Cong diem kinh nghiem cho user
			var exp:int = fish.getExp();
			
			//effect tiền và kinh nghiệm rơi ra
			var p:Point = fish.CurPos;
			EffectMgr.getInstance().fallFlyMoney(p.x, p.y, money);
			EffectMgr.getInstance().fallFlyXP(p.x, p.y, exp, true);
			
			//xoa con ca khoi mang ca
			fish.Clear();
			var index:int = user.arrFireworkFish.indexOf(fish);
			//trace(index);
			user.arrFireworkFish.splice(index, 1);
			
			//Gui goi tin ban ca di
			var cmd:SendSellSparta = new SendSellSparta(user.CurLake.Id, fish.Id, "Santa");
			Exchange.GetInstance().Send(cmd);
			
			//Cap nhat thong tin tren guimain
			GuiMgr.getInstance().GuiMain.UpdateInfo(true);
			if(fish.Emotion != FireworkFish.DEAD)
			{
				//user.UpdateOptionLake(-1, fish);
				user.UpdateOptionLakeObject(-1, fish.RateOption, user.CurLake.Id);
			}
			//Cập nhật thông tin havest time
			//user.UpdateHavestTime();
			ClearPocket();
			
			//Kiểm tra ẩn ngọc đi
			if (!isEventND() && user.arrFireworkFish.length == 0)
			{
				for each (var fallingObj:FallingObject in arrDragonBall)
				{
					fallingObj.movingState = FallingObject.DISAPPEAR;
				}
				arrDragonBall.splice(0, arrDragonBall.length);
				if(user.StockThingsArr["Sock"] != null && user.StockThingsArr["Sock"][0] != null)
				{
					user.StockThingsArr["Sock"][0]["Num"] = 0;
				}
			}
		}
		
		public function CureFish(fish:Fish):void
		{	
			if (fish.IsEgg)
			{
				return;
			}
			
			if (fish.Emotion != Fish.ILL)
			{
				var pos:Point = new Point();
				pos = Ultility.PosLakeToScreen(fish.CurPos.x, fish.CurPos.y);
				Tooltip.getInstance().ShowNewToolTip(Localization.getInstance().getString("Message20"), pos.x, pos.y, 0.7);
				Tooltip.getInstance().SetTimeOut(1000);				
				return;
			}
			
			//var obj:Object = INI.getInstance().getItemInfo(fish.FishTypeId.toString(), Fish.ItemType);
			var obj:Object = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, fish.FishTypeId);
			var nMoney:int = Math.round(obj["Money"] / 10);
			if (nMoney  < 1) nMoney = 1;			
			if (nMoney > user.GetMoney()) 
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message16") , 290, 200);
				return;
			}
			
			var temp:int = ConfigJSON.getInstance().getEnergyInfo("cure");
			if (user.GetEnergy() < temp)
			{
				//var st:String = Localization.getInstance().getString("Message4");
				//GuiMgr.getInstance().GuiMessageBox.ShowOK(st);
				GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 3);
				return;
			}

			// Play sound
			var sound:Sound = SoundMgr.getInstance().getSound("ChuaBenhCa") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			
			var maxFood:int = INI.getInstance().getGeneralInfo("Fish", "MaxFood");
			
			//fish.SetEmotion(Fish.IDLE);
			//if ((fish.Level - 50 - 1 % 6) == 0)
			if (fish.DomainFish() <= 0)
			{
				fish.SetEmotion(Fish.IDLE);
			}
			else
			{
				fish.SetEmotion(Fish.DOMAIN + fish.DomainFish());
			}

			fish.SetMovingState(Fish.FS_IDLE);
			//fish.SetHighLight(-1);
			fish.UpdateStartTime();
			fish.EatFood(maxFood);
			
			
			var cmd:SendCureFish = new SendCureFish(user.CurLake.Id, user.Id);
			cmd.AddNew(fish);
			Exchange.GetInstance().Send(cmd);			
			
			//if (user.IsViewer())
			{
				//tru diem nang luong				
				user.UpdateEnergy(-temp);
			}
			
			// effect
			var eff:SwfEffect = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffThuoc", null, fish.CurPos.x - 10, fish.CurPos.y - 15, false, false, fish);
			swfEffCureFishArr.push(eff);
			
			var nEnergy:int = ConfigJSON.getInstance().getEnergyInfo("cure");
			var nExp:int = ConfigJSON.getInstance().getActionExp("cure");
			//var child1:Sprite = Ultility.EffExpMoneyEnergy("exp", nExp);
			var child2:Sprite = Ultility.EffExpMoneyEnergy("money", -nMoney);
			var arr:Array = [];
			//arr.push(child1);
			arr.push(child2);
			if (user.IsViewer())
			{						
				var child3:Sprite = Ultility.EffExpMoneyEnergy("energy", -nEnergy);// , fish.CurPos.x, fish.CurPos.y - 60);							
				arr.push(child3);							
			}
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffSellFish", arr, fish.CurPos.x, fish.CurPos.y);
			//var srcPos:Point = Ultility.PosLakeToScreen(fish.CurPos.x, fish.CurPos.y);
			EffectMgr.getInstance().fallFlyXP(fish.CurPos.x, fish.CurPos.y, nExp);
			
			//tru tien
			user.UpdateUserMoney( -nMoney);
		}
		
		public function ProcessCureFish(newData:Object, oldData:Object):void
		{
			var cmd:SendCureFish =  oldData as SendCureFish;
			var Num:int = newData.Num;
			var fish:Fish;
			var i:int;
			var CmdArr:Array = cmd.GetFishArr();
			var UserArr:Array = user.GetFishArr();
			
			var obj:Object;
			var nMoney:int
			var nEnergy:int = ConfigJSON.getInstance().getEnergyInfo("cure");
			
			var bonus:Object = null;
			if (Num > 0)
			{
				bonus = newData.Bonus;
			}
			//Cá ko tồn tại thì bù lại năng lượng và load lại game
			if (newData["Error"] == 7)
			{
				if (GameLogic.getInstance().gameState != GameState.GAMESTATE_INIT)
				{
					BackToIdleGameState();
					SetState(GameState.GAMESTATE_ERROR);
				}
				var st:String = Localization.getInstance().getString("ErrorMsg" + newData["Error"]);
				if (st != "")
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK(st);
				}
				else
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("error " + newData["Error"]);
				}
				
				//Bù lại năng luọng
				user.UpdateEnergy(CmdArr.length * nEnergy);
				
				//Bù lại tiền
				for (i = 0; i < CmdArr.length; i++)
				{
					fish = CmdArr[i] as Fish;			
					//obj = INI.getInstance().getItemInfo(fish.FishTypeId.toString(), Fish.ItemType);
					obj = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, fish.FishTypeId);
					nMoney = Math.round(obj["Money"] / 10);
					user.UpdateUserMoney(nMoney);
				}
				return;
			}
			
			for (i = 0; i < CmdArr.length; i++)
			{
				fish = CmdArr[i] as Fish;			
				//obj = INI.getInstance().getItemInfo(fish.FishTypeId.toString(), Fish.ItemType);
				obj = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, fish.FishTypeId);
				nMoney = Math.round(obj["Money"] / 10);
				if (nMoney  < 1) nMoney = 1;
				
				var vt:int = UserArr.indexOf(fish);
				if (vt >= 0)
				{			
					if (cmd.UserId != user.Id) continue;
					
					if (Num > 0)
					{
						//Ghi lại log
						log.AddAct(LogInfo.ID_CURE_FISH);
						
						
						//update ca ve mat hien thi
	
						//fish.SetEmotion(Fish.LOVE);
						//fish.SetMovingState(Fish.FS_SWIM);						
					}
					else
					{
						//var pos:Point = new Point();
						//pos = Ultility.PosLakeToScreen(fish.CurPos.x, fish.CurPos.y);
						//Tooltip.getInstance().ShowNewToolTip(Localization.getInstance().getString("Message15"), pos.x, pos.y, 0.7);
						//Tooltip.getInstance().SetTimeOut(1000);
						//fish.UpdateStartTime();						
						//fish.SetHighLight(-1);
						//fish.EatFood(maxFood);
						//fish.SetEmotion(Fish.IDLE);
						//fish.SetMovingState(Fish.FS_SWIM);		
						
						//if (user.IsViewer())
						{
							//bù lại nang luong
							user.UpdateEnergy(nEnergy);
						}
						
						//bù tien
						user.UpdateUserMoney(+nMoney);
					}
					Num--;
					
					
					//Roi ra nguyen lieu
					if (bonus)
					{
						for (var k:int = 0; k < bonus.length; k++) 
						{
							var gift:Object = ConfigJSON.getInstance().getItemInfo("ActionGift", bonus[i]);
							DropActionGift(bonus[i], fish.CurPos.x, fish.CurPos.y);					
						}
					}		
					
					//Roi ra 1 so thu trong event
					if (newData.EventBonus)
					{
						
						for (k = 0; k < newData.EventBonus.length; k++) 
						{
							if (!Treasure.CheckEvent("PearFlower")) break;
							//obj = ConfigJSON.getInstance().GetItemInfo("Icon", newData.EventBonus[k]);
							//if (obj)
							{
								//obj["Num"] = 1; //So luong roi ra = 1
								DropActionGift(newData.EventBonus[k], fish.CurPos.x, fish.CurPos.y);
							}
						}
					}					
				}
			}
			CmdArr.splice(0, CmdArr.length);			
			//GuiMgr.getInstance().GuiTopInfo.UpdateInfo();
			
			// kiem tra quest
		}
		
		public function CareFish(fish:Fish):void
		{
			if (fish.IsEgg)
			{
				return;
			}
			
			if (!user.IsViewer())
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message17"));
				return;
			}	
			
			var	temp:int = ConfigJSON.getInstance().getEnergyInfo("carefriendfish");
			if (user.GetEnergy() < temp)
			{
				//var st:String = Localization.getInstance().getString("Message4");
				//GuiMgr.getInstance().GuiMessageBox.ShowOK(st);
				GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 3);
				return;
			}
			
			if (fish.LastPeriodCare == fish.GetPeriod())
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Cá đã hết lần được chăm sóc");
				return;
			}
			
			//if (fish.Full() > 0.98)
			//{
				//GuiMgr.getInstance().GuiMessageBox.ShowOK("Cá đã no không thể chăm sóc");
				//return;
			//}
			
			if (fish.Growth() >= 1)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Cá đã đã trưởng thành không thể chăm sóc");
				return;
			}			
			
			// Play sound
			var sound:Sound = SoundMgr.getInstance().getSound("ChamSocCa") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			
			fish.LastPeriodCare = fish.GetPeriod();
			//update start time							
			var t1:int = 0.1 * ConfigJSON.getInstance().GetTimeIntervalPeriod(fish.FishTypeId , fish.LastPeriodCare) * (100 - Math.min(user.CurLake.Option["Time"], Constant.MAX_BUFF_TIME))/100;
			var t2:int = ConfigJSON.getInstance().GetTimePeriod(fish.FishTypeId , fish.LastPeriodCare) * (100 - Math.min(user.CurLake.Option["Time"], Constant.MAX_BUFF_TIME))/100 - fish.GetLifeTime();
			var time:int = t1 < t2 ? t1: t2;
			fish.StartTime -= time;
			if (fish.DomainFish() <= 0) 
			{
				fish.SetEmotion(Fish.IDLE);
			}
			else 
			{
				fish.SetEmotion(Fish.DOMAIN + fish.DomainFish());
			}
			fish.SetMovingState(Fish.FS_SWIM);		
			var AffectTime:int = INI.getInstance().getGeneralInfo("Food", "AffectTime");
			var nFood:Number = Number(time / AffectTime); 
			fish.EatFood(nFood);
			fish.SetHighLight( -1);		

			//Gui goi tin di
			var cmd:SendCareFish = new SendCareFish(user.CurLake.Id, user.Id);
			cmd.AddNew(fish);
			Exchange.GetInstance().Send(cmd);			
			
			fish.SetEmotion(Fish.LOVE);					
			fish.SetMovingState(Fish.FS_SWIM);	
			
			// Effect
			var nExp:int = ConfigJSON.getInstance().getActionExp("carefriendfish");
			//var child1:Sprite = Ultility.EffExpMoneyEnergy("exp", nExp);// , fish.CurPos.x, fish.CurPos.y);
			var arr:Array = [];
			//arr.push(child1);
			
			if (user.IsViewer())
			{		
				var nEnergy:int = ConfigJSON.getInstance().getEnergyInfo("carefriendfish");
				var child2:Sprite = Ultility.EffExpMoneyEnergy("energy", -nEnergy);//, fish.CurPos.x, fish.CurPos.y - 40);
				arr.push(child2);
			}
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffSellFish", arr, fish.CurPos.x, fish.CurPos.y);
			//var srcPos:Point = Ultility.PosLakeToScreen(fish.CurPos.x, fish.CurPos.y);
			EffectMgr.getInstance().fallFlyXP(fish.CurPos.x, fish.CurPos.y, nExp);
			
			//Tru nang luong			
			user.UpdateEnergy(-temp);
		}
		
		public function ProcessCareFish(newData:Object, oldData:Object):void
		{
			var cmd:SendCareFish =  oldData as SendCareFish;
			var Num:int = newData.Num;
			var fish:Fish;
			var i:int;
			var CmdArr:Array = cmd.GetFishArr();
			var UserArr:Array = user.GetFishArr();
			
			var obj:Object;
			var nEnergy:int = ConfigJSON.getInstance().getEnergyInfo("carefriendfish");
			var bonus:Object = null;
			if (Num > 0)
			{
				bonus = newData.Bonus;
			}
			//Cá ko tồn tại thì bù lại năng lượng và load lại game
			if (newData["Error"] == 7)
			{
				if (GameLogic.getInstance().gameState != GameState.GAMESTATE_INIT)
				{
					BackToIdleGameState();
					SetState(GameState.GAMESTATE_ERROR);
				}
				var st:String = Localization.getInstance().getString("ErrorMsg" + newData["Error"]);
				if (st != "")
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK(st);
				}
				else
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("error " + newData["Error"]);
				}
				
				//Bù lại năng luọng
				user.UpdateEnergy(CmdArr.length*nEnergy);
				return;
			}
			
			for (i = 0; i < CmdArr.length; i++)
			{
				fish = CmdArr[i] as Fish;
				var vt:int = UserArr.indexOf(fish);
				if (vt >= 0)
				{			
					//Nếu user ko còn ở nhà người bạn có cá được chăm sóc
					//lúc gói tin chăm sóc bắt đầu được gửi đi
					if (cmd.UserId != user.Id) continue;
				

					if (Num > 0)
					{	
						//Ghi lại log
						log.AddAct(LogInfo.ID_CARE_FISH);
						
						//fish.SetEmotion(Fish.LOVE);					
						//fish.SetMovingState(Fish.FS_SWIM);	
						//
						// Effect
						//var nExp:int = newData["Exp"];// INI.getInstance().getActionExp("carefriendfish");
						//var child1:Sprite = Ultility.EffExpMoneyEnergy("exp", nExp);// , fish.CurPos.x, fish.CurPos.y);
						//var arr:Array = [];
						//arr.push(child1);
						//
						//if (user.IsViewer())
						//{						
							//var child2:Sprite = Ultility.EffExpMoneyEnergy("energy", -nEnergy);//, fish.CurPos.x, fish.CurPos.y - 40);
							//arr.push(child2);
						//}
						//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffSellFish", arr, fish.CurPos.x, fish.CurPos.y);
					}
					else
					{
						//if (user.IsViewer())
						{
							//Bù lại năng luọng
							user.UpdateEnergy(nEnergy);
							
							//var pos:Point = new Point();
							//pos = Ultility.PosLakeToScreen(fish.CurPos.x, fish.CurPos.y);
							//Tooltip.getInstance().ShowNewToolTip("Pé đã được người khác chăm sóc rồi", pos.x, pos.y, 0.7);
							//Tooltip.getInstance().SetTimeOut(1000);
							//fish.SetEmotion(Fish.IDLE);
							//fish.SetMovingState(Fish.FS_SWIM);		
						}
					}
					Num--;
					
					//Roi ra nguyen lieu
					if (bonus)
					{
						for (var k:int = 0; k < bonus.length; k++) 
						{
							//var gift:Object = ConfigJSON.getInstance().getItemInfo("ActionGift", bonus[i]);
							DropActionGift(bonus[k], fish.CurPos.x, fish.CurPos.y);					
						}
					}
					
					//Roi ra 1 so thu trong event
					if (newData.EventBonus)
					{
						
						for (k = 0; k < newData.EventBonus.length; k++) 
						{
							if (!Treasure.CheckEvent("PearFlower")) break;
							//obj = ConfigJSON.getInstance().GetItemInfo("Icon", newData.EventBonus[k]);
							//if (obj)
							{
								//obj["Num"] = 1; //So luong roi ra = 1
								DropActionGift(newData.EventBonus[k], fish.CurPos.x, fish.CurPos.y);
							}
						}
					}	
					
					//Rơi đồ trong event 2-9
					dropBonusEventND(oldData, newData.EventBonus);
				}
			}			
			CmdArr.splice(0, CmdArr.length);			
			//GuiMgr.getInstance().GuiTopInfo.UpdateInfo();
		}
		
		// Dunglb - xu ly cau ca
		public function ProcessFishing(fishingData:Object):void
		{
			FishingDataReceive = true;
			dataFishing = fishingData;
			
			// Quest nhặt nguyên liệu (câu được)
			if (fishingData.ItemType == "Material")
			{
				if ((QuestMgr.getInstance().SpecialTask["collectMaterial"] != null) && (GameLogic.getInstance().user.IsViewer()))
				{
					var stask:TaskInfo = QuestMgr.getInstance().SpecialTask["collectMaterial"];
					stask.Num += fishingData.Num;
					if (stask.Num >= stask.MaxNum)
					{
						stask.Num = stask.MaxNum;
						stask.Status = true;
					}
					
					// Neu hoan thanh quest -> Rung button
					if (QuestMgr.getInstance().isQuestDone() && (!GameLogic.getInstance().user.IsViewer()) && (QuestMgr.getInstance().isBlink == false))
					{
						//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(true);
						GuiMgr.getInstance().guiFrontScreen.btnDailyQuest.SetBlink(true);
						QuestMgr.getInstance().isBlink = true;
					}
				}
			}
			
			if (GameController.getInstance().isSmallBackGround && GameController.getInstance().finishEffFishing)
			{
				ProcessFishing1(dataFishing);
			}
		}
		public function ProcessFishing1(fishingData:Object):void
		{
			GameController.getInstance().finishEffFishing = false;
			FishingDataReceive = false;
			
			user.UpdateEnergy(-ConfigJSON.getInstance().getEnergyInfo("fishing"));
			if (fishingData.ItemType == "")
			{
				GuiMgr.getInstance().GuiFishingFail.Show();
				return;
			}
			
			var data:GetFishing = new GetFishing(fishingData);
			if (data.Error != 0)
			{
				return;
			}
			
			//Ghi lại log
			log.AddAct(LogInfo.ID_FISHING);		
		
			
			//gui.Show(Constant.GUI_MIN_LAYER + 1);
			if (data.ItemType != "ItemCollection")
			{
				var gui:GUIFishingSuccess = GuiMgr.getInstance().GuiFishingSuccess;
				gui.SetData(data.ItemType, data.Num, data.ItemId);
				gui.Show(Constant.GUI_MIN_LAYER, 3);
			}
			else
			{
				var p:Point;
				/*if (!GameController.getInstance().isSmallBackGround)
				{
					p = GuiMgr.getInstance().GuiCharacter.GetPosition(); 
				}
				else*/
				{
					p = GameController.getInstance().blackHole.CurPos;
					p = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).localToGlobal(p);
					p = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).globalToLocal(p);
				}
				for (var j:int = 0; j < data.Num; j++)
				{
					var mat:FallingObject = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER),data.ItemType + data.ItemId, p.x, p.y);
					mat.ItemType = data.ItemType;
					mat.ItemId = data.ItemId;
					mat.setWaitingTime(1.5);
					
					mat.getDesToFly = function():Point
					{
						var pos:Point = GuiMgr.getInstance().guiAnoucementCollection.getPosById(data.ItemId);
						return pos;
					}
					GameLogic.getInstance().user.fallingObjArr.push(mat);
				}
				
				//Hiện thông báo hoàn thành bộ sưu tập
				//if(!dropItemCollection)
				{
					//GameLogic.getInstance().dropItemCollection = true;
					GameLogic.getInstance().checkAnoucementCollection(data.ItemId);
				}
				GuiMgr.getInstance().GuiStore.UpdateStore(data.ItemType, data.ItemId, data.Num);
				
				fishingData = null;
			}
		}
		
		public function UseEnergy(id:int):void
		{
			// gui len server
			var test:SendUseItem = new SendUseItem(user.CurLake.Id);
			test.AddNew(0, id, "EnergyItem", 0, 0, 0);
			var energyMax:int = ConfigJSON.getInstance().getMaxEnergy(user.GetLevel());
			var isUseFull:Boolean = false;
			if (id == Constant.ID_FULL_ENERGY)
			{
				isUseFull = true;
				if (user.GetMyInfo().Energy >= energyMax)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đang đầy năng lượng.\nKhông thể sử dụng", 310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
					if (GuiMgr.getInstance().GuiStore.IsVisible)
					{
						GuiMgr.getInstance().GuiStore.Hide();
					}
					return;
				}
			}
			Exchange.GetInstance().Send(test);
			
			//cap nhat lai energy cua user
			//var obj:Object = INI.getInstance().getItemInfo(id.toString(), "EnergyItem")
			var obj:Object = ConfigJSON.getInstance().getItemInfo("EnergyItem", id)
			
			//user.UpdateEnergy(obj["Num"]);
			updateEnergyOver(obj["Num"], isUseFull);
			
			// update kho
			GuiMgr.getInstance().GuiStore.UpdateStore("EnergyItem", id, -1);
		}
		
		public function updateEnergyOver(numEnergy:int, isUseFullEnergy:Boolean = false):void 
		{
			var maxBonusMachine:int = ConfigJSON.getInstance().GetItemList("Param")["MaxBonusMachine"];
			var energyMax:int = ConfigJSON.getInstance().getMaxEnergy(user.GetLevel());
			var txtFormat:TextFormat;
			if (isUseFullEnergy)
			{
				if (user.GetMyInfo().Energy < energyMax)
				{
					numEnergy = energyMax - user.GetMyInfo().Energy;
				}
			}
			user.GetMyInfo().Energy += numEnergy;
			if(user.GetMyInfo().Energy > energyMax)
			{
				user.GetMyInfo().bonusMachine += (user.GetMyInfo().Energy - energyMax);
				if (user.GetMyInfo().bonusMachine >= maxBonusMachine)
				{
					user.GetMyInfo().bonusMachine = maxBonusMachine;
				}
				user.GetMyInfo().Energy = energyMax;
			}
			GuiMgr.getInstance().guiUserInfo.energy = user.GetEnergy();
			// Effect
			var child:Sprite = new Sprite();
			var kq:String;
			var color:int = 0x00ff00;;
			kq = "+" + numEnergy;
			var guiUserInfo:GUIUserInfo = GuiMgr.getInstance().guiUserInfo;
			var pos:Point = new Point(guiUserInfo.txtEnergy.x, guiUserInfo.txtEnergy.y);
			pos = guiUserInfo.img.localToGlobal(pos);
			txtFormat = new TextFormat("SansationBold", 18, color, true);
			txtFormat.align = "left";
			txtFormat.font = "SansationBold";
			child.addChild(Ultility.CreateSpriteText(kq, txtFormat, 6, 0, true));					
			var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child) as ImgEffectFly;
			eff.SetInfo(pos.x + 20, pos.y + 50, pos.x + 20, pos.y + 5, 3);			
			
		}
		
		public function UseFish(Id:int):void
		{
			var sound:Sound;
			var imgName:String;
			var pos:Point;
			var dir:int;
			var obj:Object;
			if(user.CurLake.NumFish >= user.CurLake.CurCapacity)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Hồ cá của bạn đã đầy rồi!");
				return;
			}
			
			// Play sound
			sound = SoundMgr.getInstance().getSound("MuaCa") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			
			obj = user.StockThingsArr.PopBabyFish(Id);//INI.getInstance().getItemInfo(FishTypeId.toString(), Fish.ItemType);

			user.CurLake.NumFish++;
			imgName = Fish.ItemType + obj["FishTypeId"] + "_Baby_Idle";
			/*if (!GameController.getInstance().isSmallBackGround)
			{
				pos = GuiMgr.getInstance().GuiCharacter.GetPosAvatar();
				dir = GuiMgr.getInstance().GuiCharacter.GetDirAvatar();
			}
			else*/
			{
				dir = 1;
				GameController.getInstance().blackHole.SetPos(485, 135);
				pos = GameController.getInstance().blackHole.CurPos;
				pos = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).localToGlobal(pos);
				pos = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).globalToLocal(pos);
			}
			var fish:Fish = new Fish(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);
			fish.SetInfo(obj);
	
			fish.Init(pos.x + dir * 40, pos.y - 10);

			fish.SetDirFall(dir);
			fish.Id = Id;//GameLogic.getInstance().user.GenerateNextID();
			fish.LakeId = user.CurLake.Id;
			fish.Name = GuiMgr.getInstance().GuiBuyFish.GetNameFish();			
			fish.StartTime = CurServerTime;
			fish.OriginalStartTime = CurServerTime;
			fish.PocketStartTime = CurServerTime + 3;//Cộng thêm 3s để tránh lệch thời gian giữa client và server
			fish.SetHighLight();
			fish.UpdateColor();
			var fishArr:Array = user.GetFishArr();
			fishArr.push(fish);
			
			//user.UpdateOptionLake(1, fish);
			//user.UpdateOptionAllLake(fish, 0, user.CurLake.Id);
			user.UpdateOptionLakeObject(1, fish.RateOption, user.CurLake.Id);
			GuiMgr.getInstance().GuiStore.UpdateStore("BabyFish", obj["FishTypeId"], -1);
			
			var test:SendUseBabyFish = new SendUseBabyFish(user.CurLake.Id);
			test.Id = Id;
			Exchange.GetInstance().Send(test);
			// add thông tin vào trong mảng AllFishArr của user
			var fObj:Object = new Object();
			fObj.ColorLevel = fish.ColorLevel;
			fObj.ColorEdit = fish.ColorEdit;
			fObj.FeedAmount = fish.FeedAmount;
			fObj.FishType = fish.FishType;
			fObj.FishTypeId = fish.FishTypeId;
			fObj.Id = fish.Id;
			fObj.LakeId = fish.LakeId;
			fObj.LastBirthTime = fish.LastBirthTime;
			fObj.LastPeriodCare = fish.LastPeriodCare;
			fObj.LastPeriodStim = fish.LastPeriodStim;
			fObj.Level = fish.Level;
			fObj.MoneyPocket = fish.MoneyPocket;
			fObj.OriginalStartTime = fish.OriginalStartTime;
			fObj.Sex = fish.Sex;
			fObj.StartTime = fish.StartTime;
			user.AllFishArr.push(fObj);
			
			//if (fish.FishType == Fish.FISHTYPE_SOLDIER)
			//{
				//var fs:FishSoldier = fish as FishSoldier;
				//fs.SetSoldierInfo();
				//user.FishSoldierArr.push(fish);
			//}
			/*if(!GameController.getInstance().isSmallBackGround)
			{
				GuiMgr.getInstance().GuiCharacter.PlayAni(GUICharacter.ANI_RELEASE_FISH);
			}
			else*/
			{
				GameController.getInstance().blackHole.img.visible = true;
			}
			// Cập nhật lại các biến mà con cá đặc biệt có thể ảnh hưởng
			//if(fish.RateOption != null && fish.RateOption["Time"] != null)
				//user.CurLake.Option["Time"] += fish.RateOption["Time"];
			//if(fish.RateOption != null && fish.RateOption["Money"] != null)
				//user.CurLake.Option["Money"] += fish.RateOption["Money"];
			//if(fish.RateOption != null && fish.RateOption["MixFish"] != null)
				//user.CurLake.Option["MixFish"] += fish.RateOption["MixFish"];
			//if(fish.RateOption != null && fish.RateOption["Exp"] != null)
				//user.CurLake.Option["Exp"] += fish.RateOption["Exp"];
			
			//Cập nhật havest time cá
			//user.UpdateHavestTime();
		}
		
		public function UseFishSoldier(Id:int):void
		{
			var sound:Sound;
			var imgName:String;
			var pos:Point;
			var dir:int;
			var obj:Object;
			
			var numElement:int = 0;
			for (var s:String in user.ElementList)
			{
				numElement += 1;
			}
			obj = user.StockThingsArr.findBabyFishInfo(Id);
			
			if (numElement == 1)
			{
				if (checkCounter(obj["Element"], parseInt(s)))
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không thể cùng lúc nuôi 2 Ngư Thủ khắc hệ với nhau", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					return;
				}
			}
			
			if (numElement >= 2)
			{
				//var canUse:Boolean = true;
				if (!user.ElementList[obj["Element"]])
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn chỉ có thể sở hữu 2 hệ Ngư Thủ!", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					return;
				}
			}
			
			if (user.CurLake.NumSoldier >= user.CurLake.CurCapacitySoldier)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Chỉ được thả tối đa 3 Ngư Thủ!", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			// Play sound
			sound = SoundMgr.getInstance().getSound("MuaCa") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			
			obj = user.StockThingsArr.PopBabyFishSoldier(Id);//INI.getInstance().getItemInfo(FishTypeId.toString(), Fish.ItemType);

			user.CurLake.NumSoldier++;
			user.NumSoldier++;
			imgName = Fish.ItemType + obj["FishTypeId"] + "_Old_Idle";
			
			/*if (!GameController.getInstance().isSmallBackGround)
			{
				pos = GuiMgr.getInstance().GuiCharacter.GetPosAvatar();
				dir = GuiMgr.getInstance().GuiCharacter.GetDirAvatar();
			}
			else*/
			{
				dir = 1;
				pos = GameController.getInstance().blackHole.CurPos;
				pos = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).localToGlobal(pos);
				pos = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).globalToLocal(pos);
			}
			
			var fish:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);
			fish.SetInfo(obj);
			fish.FeedAmount = 100;
			fish.Init(pos.x + dir * 40, pos.y - 10);
			
			fish.SetDirFall(dir);
			fish.Id = Id;
			//fish.Id = user.GenerateNextID();
			fish.LakeId = user.CurLake.Id;
			fish.Name = GuiMgr.getInstance().GuiBuyFish.GetNameFish();			
			fish.StartTime = CurServerTime;
			fish.OriginalStartTime = CurServerTime;
			fish.SetHighLight();
			fish.UpdateColor();
			fish.SetSoldierInfo();
			fish.CheckStatus();
			fish.EquipmentList = new Object();
			fish.bonusEquipment = new Object();
			if (fish.SoldierType == FishSoldier.SOLDIER_TYPE_MIX)
			{
				for (var k:int = 0; k < FishEquipment.EquipmentTypeList.length; k++)
				{
					var type:String = FishEquipment.EquipmentTypeList[k];
					fish.EquipmentList[type] = new Array();
				}
			}
			fish.bonusEquipment.Damage = 0;
			fish.bonusEquipment.Critical = 0;
			fish.bonusEquipment.Vitality = 0;
			fish.bonusEquipment.Defence = 0;
			var fishArr:Array = user.GetFishSoldierArr();
			fishArr.push(fish);
			
			fishArr = user.GetMyInfo().MySoldierArr;
			var newFishSoldier:FishSoldier = new FishSoldier(null, "");
			newFishSoldier.SetInfo(obj);
			newFishSoldier.Id = Id;
			newFishSoldier.LakeId = user.CurLake.Id;
			newFishSoldier.Name = GuiMgr.getInstance().GuiBuyFish.GetNameFish();			
			newFishSoldier.StartTime = CurServerTime;
			newFishSoldier.OriginalStartTime = CurServerTime;
			newFishSoldier.SetSoldierInfo();
			newFishSoldier.CheckStatus();
			newFishSoldier.EquipmentList = new Object();
			newFishSoldier.bonusEquipment = new Object();
			if (newFishSoldier.SoldierType == FishSoldier.SOLDIER_TYPE_MIX)
			{
				for (var k1:int = 0; k1 < FishEquipment.EquipmentTypeList.length; k1++)
				{
					var typek1:String = FishEquipment.EquipmentTypeList[k1];
					newFishSoldier.EquipmentList[typek1] = new Array();
				}
			}
			newFishSoldier.bonusEquipment.Damage = 0;
			newFishSoldier.bonusEquipment.Critical = 0;
			newFishSoldier.bonusEquipment.Vitality = 0;
			newFishSoldier.bonusEquipment.Defence = 0;
			
			
			
			
			//GameController.getInstance().SetInfo(newFishSoldier, fish, FishSoldier.ACTOR_NONE, false);
			
			fishArr.push(newFishSoldier);
			//cập nhật nút liên đấu HiepNM2
			LeagueMgr.getInstance().hasUpdateButton = true;
			
			GuiMgr.getInstance().GuiStore.UpdateStore("Soldier", obj["FishTypeId"], -1);
			
			var test:SendUseBabyFish = new SendUseBabyFish(user.CurLake.Id);
			test.Id = Id;
			test.TypeFish = 3;
			Exchange.GetInstance().Send(test);
			
			//Lưu hệ con cá lính để gửi lên khi hoàn thành quest thả cá
			GuiMgr.getInstance().guiMainQuest.soldierElement = fish.Element;
			
			//user.FishSoldierArr.push(fish);
			/*if(!GameController.getInstance().isSmallBackGround)
			{
				GuiMgr.getInstance().GuiCharacter.PlayAni(GUICharacter.ANI_RELEASE_FISH);
			}*/
			
			//Cập nhật havest time cá
			user.UpdateHavestTime();
			
			if (user.ElementList[fish.Element])
			{
				user.ElementList[fish.Element] += 1;
			}
			else
			{
				user.ElementList[fish.Element] = 1;
			}
		}
		
		/**
		 * Hàm kiểm tra tương khắc giữa 2 thuộc tính e1 và e2
		 * @param	e1
		 * @param	e2
		 * @return
		 */
		public function checkCounter(e1:int, e2:int):Boolean
		{
			// Kiểm tra tương khắc
			var EleMinus:int = e1 - e2;
			var isKhac:Boolean = false;		// Khắc: true, KO khắc: false;
			
			// Trường hợp xảy ra tương khắc
			if (Math.abs(EleMinus) == 1 || Math.abs(EleMinus) == 4)
			{				
				isKhac = true;			
			}
			
			return isKhac;
		}
		
		public function UseFishSpartan(Id:int):void
		{
			var sound:Sound;
			var imgName:String;
			var pos:Point;
			var dir:int;
			var obj:Object;
				// Play sound
				sound = SoundMgr.getInstance().getSound("MuaCa") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				obj = user.StockThingsArr.PopBabyFish(Id);//INI.getInstance().getItemInfo(FishTypeId.toString(), Fish.ItemType);

				imgName = obj["Name"];
				/*if (!GameController.getInstance().isSmallBackGround)
				{
					pos = GuiMgr.getInstance().GuiCharacter.GetPosAvatar();
					dir = GuiMgr.getInstance().GuiCharacter.GetDirAvatar();
				}
				else*/
				{
					dir = 1;
					pos = GameController.getInstance().blackHole.CurPos;
					pos = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).localToGlobal(pos);
					pos = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).globalToLocal(pos);
				}
				var fishSpt:FishSpartan = new FishSpartan(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);
				//fishSpt.SetInfo(obj);
				fishSpt.RateOption = obj["Option"];
				var numOption:int = 0;
				for (var iRateOption:String in fishSpt.RateOption) 
				{
					numOption++;
				}
				fishSpt.numOption = numOption;
				fishSpt.StartTime = CurServerTime;
				fishSpt.ExpiredTime = obj["ExpiredDay"];
				fishSpt.isExpired = true;
				fishSpt.Init(pos.x + dir*40, pos.y - 10);
				fishSpt.SetDirFall(dir);
				fishSpt.Id = obj["Id"];//GameLogic.getInstance().user.GenerateNextID();
				fishSpt.Name = GuiMgr.getInstance().GuiStore.GetNameFishSpecial(imgName);			
				fishSpt.SetHighLight();
				fishSpt.NameItem = obj["Name"];
				fishSpt.numReborn = 0;
				//fishSpt.UpdateColor();
				user.FishArrSpartan.push(fishSpt);
				
				user.UpdateOptionLakeObject(-1, fishSpt.RateOption, -1, user.CurLake.Id);
				//user.UpdateOptionLakeSparta(1, fishSpt);
				//user.UpdateOptionAllLakeSparta(fishSpt, 0, user.CurLake.Id);
				user.StockThingsArr.numSparta -= 1;
				GuiMgr.getInstance().GuiStore.UpdateStore("BabyFish", fishSpt.Id, -1);				
								
				var testSpartan:SendUseItem = new SendUseItem(user.CurLake.Id);
				var objSparta:Object = new Object();
				objSparta["Id"] = fishSpt.Id;
				objSparta["ItemType"] = imgName;
				testSpartan.ItemList.push(objSparta);
				Exchange.GetInstance().Send(testSpartan);
				/*if(!GameController.getInstance().isSmallBackGround)
				{
					GuiMgr.getInstance().GuiCharacter.PlayAni(GUICharacter.ANI_RELEASE_FISH);
				}*/
				
				//Cập nhật havest time cá
				//user.UpdateHavestTime();
		}
		
		
		public function useFireworkFish(Id:int):void
		{
			var sound:Sound;
			var imgName:String;
			var pos:Point;
			var dir:int;
			var obj:Object;
			// Play sound
			sound = SoundMgr.getInstance().getSound("MuaCa") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			
			obj = user.StockThingsArr.PopBabyFish(Id);//INI.getInstance().getItemInfo(FishTypeId.toString(), Fish.ItemType);

			imgName = obj["Name"];
			//pos = GuiMgr.getInstance().GuiCharacter.GetPosAvatar();
			//dir = GuiMgr.getInstance().GuiCharacter.GetDirAvatar();
			pos = Ultility.PosScreenToLake(GameController.getInstance().blackHole.CurPos.x, GameController.getInstance().blackHole.CurPos.y);
			dir = 1;
			var fish:FireworkFish = new FireworkFish(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);
			fish.RateOption = obj["Option"];
			fish.Init(pos.x + dir * 40, pos.y - 10);
			fish.Id = Id;
			fish.LakeId = user.CurLake.Id;
			fish.bornTime = GameLogic.getInstance().CurServerTime;
			fish.receiveGiftTime = GameLogic.getInstance().CurServerTime;
			
			fish.SetMovingState(Fish.FS_FALL);
			fish.SetDirFall(dir);
			
			user.arrFireworkFish.push(fish);
			user.StockThingsArr.numSparta -= 1;
			GuiMgr.getInstance().GuiStore.UpdateStore("BabyFish", fish.Id, -1);				
			
			var useItem:SendUseItem = new SendUseItem(user.CurLake.Id);
			obj = new Object();
			obj["Id"] = fish.Id;
			obj["ItemType"] = "Firework";
			useItem.ItemList.push(obj);
			Exchange.GetInstance().Send(useItem);
			
			//GuiMgr.getInstance().GuiCharacter.PlayAni(GUICharacter.ANI_RELEASE_FISH);
			//user.UpdateOptionLake(1, fish);
			user.UpdateOptionLakeObject(1, fish.RateOption, user.CurLake.Id);
			//Cập nhật havest time cá
			//user.UpdateHavestTime();
		}
		
		public function BuyFish(fish:Fish):void
		{		
			if(user.CurLake.NumFish >= user.CurLake.CurCapacity)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Hồ cá của bạn đã đầy rồi!");
				GuiMgr.getInstance().GuiBuyFish.Close();
				return;
			}
			
			// Play sound
			var sound:Sound = SoundMgr.getInstance().getSound("MuaCa") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			
			var pos:Point;
			//var obj:Object = INI.getInstance().getItemInfo(fish.FishTypeId.toString(), Fish.ItemType);
			var obj:Object = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, fish.FishTypeId);
			var MoneyHave:Number = 0;
			//var BuyType:String = GuiMgr.getInstance().GuiBuyShop.BuyType;
			var BuyType:String = GuiMgr.getInstance().GuiShop.BuyType;
			var nMoney:int = obj[BuyType];
			if (BuyType == "Money")
			{
				MoneyHave = user.GetMoney();
			}
			else
			{
				MoneyHave = user.GetZMoney();
			}
			if (nMoney > MoneyHave)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không còn đủ tiền để mua cá!");
				GuiMgr.getInstance().GuiBuyFish.Close();
				return;
			}
			
			if (BuyType == "Money")
			{
				user.UpdateUserMoney( -nMoney, true);
				
				//Effect
				
				var st:String = "-" + nMoney;
				var txtFormat:TextFormat = new TextFormat("Arial", 18, 0xffffff, true);
				txtFormat.align = "left";
				txtFormat.color = 0xFFFF00;
				txtFormat.font = "SansationBold";
				var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0, true);
				var icon:Sprite = ResMgr.getInstance().GetRes("IcGold") as Sprite;
				icon.x = tmp.width + 5;
				icon.y =  -13;
				tmp.addChild(icon);
				pos = GameInput.getInstance().MousePos;
				var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
				eff.SetInfo(pos.x - tmp.width/2, pos.y - tmp.height/2, pos.x-tmp.width/2, pos.y - 60, 7);
			}
			else
			{
				user.UpdateUserZMoney(-nMoney);
			}
			
			user.CurLake.NumFish++;
			
			var dir:int;
			/*if (!GameController.getInstance().isSmallBackGround)
			{
				dir = GuiMgr.getInstance().GuiCharacter.GetDirAvatar();
				pos = GuiMgr.getInstance().GuiCharacter.GetPosAvatar();
			}
			else*/
			{
				dir = 1;
				GameController.getInstance().blackHole.SetPos(485, 135);
				pos = GameController.getInstance().blackHole.CurPos;
				pos = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).localToGlobal(pos);
				pos = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).globalToLocal(pos);
			}
			fish.Init(pos.x + dir * 40, pos.y - 10);			
			fish.SetDirFall(dir);
			fish.Id = GameLogic.getInstance().user.GenerateNextID();
			fish.Name = GuiMgr.getInstance().GuiBuyFish.GetNameFish();
			fish.Sex = GuiMgr.getInstance().GuiBuyFish.sexFish;
			fish.StartTime = CurServerTime;
			fish.MoneyPocket = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, fish.FishTypeId)["TotalPocket"];
			fish.TotalBalloon = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, fish.FishTypeId)["TotalBalloon"];			
			fish.PocketStartTime = CurServerTime;
			fish.LakeId = user.CurLake.Id;
			fish.OriginalStartTime = CurServerTime;
			fish.SetHighLight();
			var fishArr:Array = user.GetFishArr();
			fishArr.push(fish);
			var cmd:SendBuyFish = new SendBuyFish(user.CurLake.Id);
			if (BuyType == "ZMoneyUnlock")
				cmd.AddNew(fish, "ZMoney");
			else
				cmd.AddNew(fish, BuyType);
			Exchange.GetInstance().Send(cmd);
			// add thông tin vào trong mảng AllFishArr của user
			var fObj:Object = new Object();
			fObj.ColorLevel = fish.ColorLevel;
			fObj.ColorEdit = fish.ColorEdit;
			fObj.FeedAmount = fish.FeedAmount;
			fObj.FishType = fish.FishType;
			fObj.FishTypeId = fish.FishTypeId;
			fObj.Id = fish.Id;
			fObj.LakeId = fish.LakeId;
			fObj.LastBirthTime = fish.LastBirthTime;
			fObj.LastPeriodCare = fish.LastPeriodCare;
			fObj.LastPeriodStim = fish.LastPeriodStim;
			fObj.Level = fish.Level;
			fObj.MoneyPocket = fish.MoneyPocket;
			fObj.OriginalStartTime = fish.OriginalStartTime;
			fObj.Sex = fish.Sex;
			fObj.StartTime = fish.StartTime;
			user.AllFishArr.push(fObj);
			
			GuiMgr.getInstance().GuiMain.UpdateInfo(true);
			//GuiMgr.getInstance().GuiBuyShop.BuyFish(fish.FishTypeId);
			GuiMgr.getInstance().GuiShop.BuyFish(fish.FishTypeId);
			/*if(!GameController.getInstance().isSmallBackGround)
			{
				GuiMgr.getInstance().GuiCharacter.PlayAni(GUICharacter.ANI_RELEASE_FISH);
			}
			else*/
			{
				GameController.getInstance().blackHole.img.visible = true;
			}
			fish.UpdateHavestTime();
		}
		
		public function processBuyFish(oldData:SendBuyFish, newData:Object):void
		{
			var fishArr:Array = user.GetFishArr();
			var fishSend:Array = oldData.FishList;
			for (var i:int = 0; i < fishSend.length; i++) 
			{
				var fish:Fish = user.GetFish(fishSend[i].Id);
				if (fish != null)
				{
					fish.OriginalStartTime = CurServerTime;
					fish.PocketStartTime = CurServerTime;
					fish.StartTime = CurServerTime;				
				}
			}
		}
			
		
		public function MixFish(arr:Array, MixLakeId:int):void
		{
			var cmd:SendMixRequest = new SendMixRequest(user.CurLake.Id, MixLakeId);
			var fish:Fish;
			for (var i:int = 0; i < arr.length; i++)
			{
				fish = arr[i] as Fish;
				cmd.AddNew(fish.Id);
			}
			Exchange.GetInstance().Send(cmd);
			
			//var pk:SendLoadInventory = new SendLoadInventory();
			//Exchange.GetInstance().Send(pk);			
		}
		
		private function SellDeco(deco:Decorate):Decorate
		{			
			// kiem tra tien
			//var obj:Object = INI.getInstance().getItemInfo(deco.ItemId.toString(), deco.ItemType);
			var obj:Object = ConfigJSON.getInstance().getItemInfo(deco.ItemType, deco.ItemId);
			var nMoney:int = obj["Money"];
			user.UpdateUserMoney(nMoney/2);
			
			var decoArr:Array = user.GetDecoArr();
			var index:int = decoArr.indexOf(deco);
			deco.ClearImage();
			decoArr.splice(index, 1);
			
			var test:SendSellDecorate = new SendSellDecorate(user.CurLake.Id);
			test.AddNew(deco.Id);
			Exchange.GetInstance().Send(test);
			
			return deco;
		}
		
		public function OnMessageBox(result:String):void
		{
			var deco:Decorate;
			if (result == GUIMessageBox.MSGBOX_OK)
			{
				switch (gameState)
				{
					case GameState.GAMESTATE_UNLOCK_LAKE:
						SetState(GameState.GAMESTATE_IDLE);
						if (GuiMgr.getInstance().GuiMain.SelectedLake.Level <= 0)
						{
							DoUnlockLake(GuiMgr.getInstance().GuiMain.SelectedLake);
						}
						break;
						
					case GameState.GAMESTATE_UPGRADE_LAKE:
						SetState(GameState.GAMESTATE_IDLE);
						DoUpgradeLake();
						break;
					case GameState.GAMESTATE_BUY_BACKGROUND:
						SetState(GameState.GAMESTATE_IDLE);
						GameLogic.getInstance().buyBackGround(GuiMgr.getInstance().GuiMessageBox.itemIdBgr);
						break;
						
					case GameState.GAMESTATE_ERROR:
						if(Ultility.IsInMyFish())
						{
							GameLogic.getInstance().DoGoToLake(user.CurLake.Id, user.Id);
						}
						else 
						{
							GuiMgr.getInstance().GuiMapOcean.ComeBackHome();
						}
						//DoGoToLake(user.CurLake.Id, user.Id);
						break; 
					case GameState.GAMESTATE_REMOVE_LETTER:
						SetState(GameState.GAMESTATE_IDLE);						
						var letterId: int = GuiMgr.getInstance().GuiNewMail.GetCurLetterId();
						var arr:Array = GameLogic.getInstance().user.LetterArr;
						var sendLetter: SendRemoveMessage = new SendRemoveMessage(0, arr[letterId].Id);
						Exchange.GetInstance().Send(sendLetter);
						arr.splice(letterId, 1);
						GuiMgr.getInstance().GuiReceiveLetter.Hide();
						GuiMgr.getInstance().GuiNewMail.RefreshComponent();			
						break;
						
					case GameState.GAMESTATE_EDIT_DECORATE:
						// xoa active object
						deco = GameController.getInstance().ActiveObj as Decorate;
						if (deco != null)
						{
							if (deco.ObjectState == BaseObject.OBJ_STATE_EDIT)
							{
								deco.ChangeLayer(Constant.OBJECT_LAYER);
								deco.UnSaveEdit();
								GameController.getInstance().UpdateDecorateChildIndex(deco);
								GameController.getInstance().ActiveObj = null;
							}
						}
						if (GuiMgr.getInstance().GuiStore.CurrentStore == "Decorate")
						{
							GuiMgr.getInstance().GuiStore.Hide();
						}
						if (GuiMgr.getInstance().GuiStore.btnSaveDeco && GuiMgr.getInstance().GuiStore.btnSaveDeco.img)
						{
							GuiMgr.getInstance().GuiStore.btnSaveDeco.SetVisible(false);
							GuiMgr.getInstance().GuiStore.btnClose.SetVisible(true);
						}
						ShowFish();
						GuiMgr.getInstance().GuiDecorateInfo.Hide();
						LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).HideDisableScreen();
						if (GuiMgr.getInstance().GuiDecorateInfo.CurObject != null)
						{
							GuiMgr.getInstance().GuiDecorateInfo.CurObject.SetHighLight( -1);
						}
						
						GameController.getInstance().ActiveObj = null;
						DoUseDecoList();
						DoStoreDecoList();
						SaveEditDecorate();
						SetState(GameState.GAMESTATE_IDLE);
						
						GameController.getInstance().UseTool(GameController.getInstance().NextUseTool);
						break;
				}
				if (GuiMgr.getInstance().GuiMapOcean.IsVisible)	
				{
					GuiMgr.getInstance().GuiMapOcean.isComingOcean = false;
				}
			}
			else if (result == GUIMessageBox.MSGBOX_CANCEL)
			{
				switch (gameState)
				{
					case GameState.GAMESTATE_ERROR:
						DoGoToLake(user.CurLake.Id, user.Id);
						break; 
						
					case GameState.GAMESTATE_BUY_BACKGROUND:
						SetState(GameState.GAMESTATE_IDLE);
						break; 
						
					case GameState.GAMESTATE_UNLOCK_LAKE:
						SetState(GameState.GAMESTATE_IDLE);
						break;
						
					case GameState.GAMESTATE_EDIT_DECORATE:
						// xoa active object
						deco = GameController.getInstance().ActiveObj as Decorate;
						if (deco != null)
						{
							if (deco.ObjectState == BaseObject.OBJ_STATE_EDIT)
							{
								deco.ChangeLayer(Constant.OBJECT_LAYER);
								deco.UnSaveEdit();
								GameController.getInstance().UpdateDecorateChildIndex(deco);
								GameController.getInstance().ActiveObj = null;
							}
						}
						if (GuiMgr.getInstance().GuiStore.CurrentStore == "Decorate")
						{
							GuiMgr.getInstance().GuiStore.Hide();
						}
						
						ShowFish();
						GuiMgr.getInstance().GuiDecorateInfo.Hide();
						LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).HideDisableScreen();
						if (GuiMgr.getInstance().GuiDecorateInfo.CurObject != null)
						{
							GuiMgr.getInstance().GuiDecorateInfo.CurObject.SetHighLight( -1);
						}
						
						if (GuiMgr.getInstance().GuiStore.btnSaveDeco && GuiMgr.getInstance().GuiStore.btnSaveDeco.img)
						{
							GuiMgr.getInstance().GuiStore.btnSaveDeco.SetVisible(false);
							GuiMgr.getInstance().GuiStore.btnClose.SetVisible(true);
						}
						
						GameController.getInstance().ActiveObj = null;
						UnSaveEditDecorate();
						SetState(GameState.GAMESTATE_IDLE);
						GameController.getInstance().UseTool(GameController.getInstance().NextUseTool);
						break;
				}
				if (GuiMgr.getInstance().GuiMapOcean.IsVisible)	
				{
					GuiMgr.getInstance().GuiMapOcean.isComingOcean = false;
				}
			}
		}
		
		public function CatchErr(err:Error):void
		{
			//trace("Error: ", err.message);
			//trace("Error: ", err.getStackTrace);
			//trace("Error: ", err.name);
			return;
		}
		
		
		public function UpdateTime():void
		{
			var t:Number = getTimer();
			var s:Number = t - CurClientTime;
			if (s < 1000)
			{
				CurServerTime += (s / 1000);
			}
			CurClientTime = t;			
		}
		
		public function UpdateFoodList():void
		{
			var i:int;
			var j:int;
			var arr:Array;
			var food:Food;
			for (i = 0; i < ListFood.length; i++)
			{
				arr = ListFood[i];
				var count:int = 5;
				for (j = 0; j < arr.length; j++)
				{
					food = arr[j] as Food;
					if (food.FishId != -2)
					{
						count -= 1;
					}
				}
				if (count == 0)
				{
					FeedFish(arr);
					ListFood.splice(i, 1);
				}
			}
		}
		
		public function UpdateListGift(data:Object, oldData:Object):void 
		{
			var arrFish:Array = user.GetFishArr();
			for (var i:int = 0; i < arrFish.length; i++) 
			{
				var fish: Fish = arrFish[i] as Fish;
				if (fish.Id == oldData["FishId"]) 
				{
					fish.LevelUpGift = data["GiftList"];
				}
			}
		}
		
		public function UpdateFishWorld():void 
		{
			switch (GameController.getInstance().typeFishWorld) 
			{
				case -1:
					return;
				break;
				case Constant.OCEAN_NEUTRALITY:
					updateNeutralityFish();
				break;
				//case Constant.OCEAN_HAPPY:
					//UpdateFishHappy();
				//break;
				//case Constant.OCEAN_FIERCE:
					//
				//break;
				default:
					return;
				break;
			}
		}
		
		private function UpdateFishHappy():void 
		{
			var FishWorldHappyArr:Array = user.FishWorldHappyArr;
			for (var i:int = 0; i < FishWorldHappyArr.length; i++) 
			{
				var fis:FishOceanHappy = FishWorldHappyArr[i] as FishOceanHappy;
				if (fis != null && fis.img && fis.img.stage && fis.IsHide == false)
				{
					fis.UpdateFish();	
				}
			}
		}
		
		private function updateNeutralityFish():void
		{
			//var arrSadFish:Array = user.arrSadFish;
			//for (var j:int = 0; j < arrSadFish.length; j++)
			//{
				//var sadFish:FishWorld = arrSadFish[j] as FishWorld;
				//if (sadFish != null && sadFish.img && sadFish.img.stage && sadFish.IsHide == false)
				//{
					//sadFish.UpdateFish();
				//}
			//}
		}
		
		public function UpdateMask():void
		{
			var i:int = 0;
			var MaskArr:Array = user.GetStore("Mask");
			
			// Item trong kho
			for (i = 0; i < MaskArr.length; i++)
			{
				MaskArr[i].UpdateTime();
			}
		}
		
		public function UpdateFish():void
		{
			//Update fish
			var i:int = 0;
			var t:int;
			var food:Food;
			var fishArr:Array = user.GetFishArr();
			var fishSoldierArr:Array = user.GetFishSoldierArr();
			var fishSoldierActorMine:Array = user.FishSoldierActorMine;
			var fishSoldierActorTheirs:Array = user.FishSoldierActorTheirs;
			var FoodArr:Array = user.GetFoodArr();		
			for (i = 0; i < user.FishArrSpartan.length; i++)
			{
				var fallFish:Boolean = false;
				var fisSparta:FishSpartan = user.FishArrSpartan[i];
				if (!fisSparta.IsDraging && fisSparta.ExpiredTime * 24 * 3600 <= CurServerTime - fisSparta.StartTime)
				{//đến lúc hóa thạch :D
					fisSparta.fallPos = fisSparta.FallPos();
					//trace(fisSparta.fallPos , fisSparta.CurPos);
					user.FishArrSpartanDeactive.push(fisSparta);
					fisSparta.Clear();
					if(fisSparta.numReborn < fisSparta.maxNumReborm)
					{
						fisSparta.LoadRes(fisSparta.NameItem + "1");
					}
					else 
					{
						fisSparta.LoadRes("Supper2");
					}
					//user.UpdateOptionLakeSparta( -1, fisSparta);
					user.UpdateOptionLakeObject(-1, fisSparta.RateOption, user.CurLake.Id);
					//user.UpdateHavestTime();
					
					var updateSparta:SendUpdateSparta = new SendUpdateSparta(GameLogic.getInstance().user.Id);
					fisSparta.Dragable = false;
					if (fisSparta.isExpired)
					{
						fisSparta.isExpired = false;
						Exchange.GetInstance().Send(updateSparta);
					}
					fallFish = true;
				}
				
				if (fisSparta != null && fisSparta.IsHide == false)
				{
					if(fallFish == false)
						fisSparta.UpdateFish();
					else 
					{
						var arr:Array = user.FishArrSpartan;
						user.FishArrSpartan.splice(i, 1);
					}
				}
			}
			// Cho các con các vừa hóa thạch rơi xuống đáy
			fallSparta();
			
			// Cá lính rơi
			fallSoldier();
			
			var f:Object;
			var sum:int;
			var numFish:int;
			for (i = 0; i < fishArr.length; i++ )
			{
				var fis:Fish = fishArr[i] as Fish;
				if (fis != null && fis.IsHide == false)
				{
					if (!fis.IsEgg)
					{
						sum += fis.Full();
						numFish++;
					}
					fis.UpdateFish();					
					
					//Check ca va thuc an
					if (fis.Emotion == Fish.ILL || FoodArr.length <= 0)
						continue;
						
					if(fis.myFood == null || FoodArr.indexOf(fis.myFood) < 0)
					{
						var index:int = Math.random() * FoodArr.length; 
						food = FoodArr[index] as Food;							
					}
					else
					{
						food = fis.myFood;
					}
						
					var EatMoreS:Number = fis.EatMore();
					
					if (food != null && EatMoreS > 0)
					{
						if (Point.distance(fis.CurPos, food.CurPos) < 500)
						{
							fis.FollowFood(food);								
						}
						
						if (fis.img.hitTestObject(food.img) && (EatMoreS > 0) && !fis.IsEgg)
						{
							fis.UpdateStartTime();								
							t = FoodArr.indexOf(food);
							if (EatMoreS > 0)
							{
								var otherFull:Number = (sum/numFish) * user.FishArr.length - fis.Full();
								var eated:Number;
								if(EatMoreS > 1)
								{
									eated = 1;										
								}
								else
								{
									eated = EatMoreS;
								}
								fis.EatFood(eated);
								fis.Eated++;
								food.Eated(fis.Id, eated);								
								var vari:int = Math.round(((otherFull + fis.Full()) / user.FishArr.length) * 100)
								if (vari >= 100 && (!swfEffFood || swfEffFood.IsFinish))
								{	
									BackToIdleGameState();
									swfEffFood = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFullFood", null, 450, 10);
									user.SetEmoAllFish(Fish.HAPPY);
								}
								
								// update vào AllFishArr của user, để check độ no khi lai
								if (!user.IsViewer())
								{
									f = user.getFishInfo(fis.Id);
									f.FeedAmount += eated;
								}
							}
							food.ClearImage();
							FoodArr.splice(t, 1);
						}
					}
					else
					{
						if (fis.Eated > 0)
						{
							//var child1:Sprite = Ultility.EffExpMoneyEnergy("exp", f.Eated);
							//var arr:Array = [];
							//arr.push(child1);								
							//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffSellFish", arr, f.CurPos.x, f.CurPos.y);
						}
						fis.Eated = 0;
					}
				}
				
				// cập nhật startTime cho cá trong mảng AllFishArr của user, phục vụ việc lai
				var HungryTime:Number;
				if (!user.IsViewer())
				{
					f = user.getFishInfo(fis.Id);
					if (f != null)
					{
						HungryTime = CurServerTime - f.StartTime - (f.FeedAmount * Fish.AffectTime);
						if (HungryTime > 0)
						{
							f.StartTime += HungryTime;
						}
					}
				}
			}
			
			for (i = 0; i < fishSoldierActorMine.length; i++ )
			{
				var fish1:FishSoldier = fishSoldierActorMine[i] as FishSoldier;
				if (fish1 != null && fish1.IsHide == false)
				{
					fish1.UpdateFish();					
					fish1.CheckHealth();
				}
			}
			
			for (var j:int = 0; j < BossMgr.getInstance().BossArr.length; j++ )
			{
				var boss:Boss = (BossMgr.getInstance().BossArr[j] as Boss);
				for (i = 0; boss.arrFishSolider && i < boss.arrFishSolider.length; i++ )
				{
					var fishBoss:FishSoldier = boss.arrFishSolider[i] as FishSoldier;
					if (fishBoss != null && fishBoss.IsHide == false)
					{
						fishBoss.UpdateFish();					
						fishBoss.CheckHealth();
					}
				}
			}
			
			for (i = 0; i < fishSoldierArr.length; i++ )
			{
				var fish:FishSoldier = fishSoldierArr[i] as FishSoldier;
				if (fish != null && fish.IsHide == false)
				{
					fish.UpdateFish();					
					fish.CheckHealth();
					
					if (fish.Emotion != Fish.HAPPY && gameMode != GameMode.GAMEMODE_WAR && gameMode != GameMode.GAMEMODE_BOSS) 
					{
						if (fish.State == Fish.FS_WAR)
						{
							fish.State = Fish.FS_SWIM;
						}
					}
				}
			}
			
			var fishSoldierArrDownYellow:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownGreen;
			for (i = 0; i < fishSoldierArrDownYellow.length; i++ )
			{
				var fishYellowDown:FishSoldier = fishSoldierArrDownYellow[i] as FishSoldier;
				if (fishYellowDown != null && fishYellowDown.IsHide == false && fishYellowDown.img != null)
				{
					fishYellowDown.UpdateFish();
					fishYellowDown.CheckHealth();
				}
			}
			
			var fishSoldierArrUpRed:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterUpRed;
			for (i = 0; i < fishSoldierArrUpRed.length; i++ )
			{
				var fishRedUp:FishSoldier = fishSoldierArrUpRed[i] as FishSoldier;
				if (fishRedUp != null && fishRedUp.IsHide == false && fishRedUp.img != null)
				{
					fishRedUp.UpdateFish();
					fishRedUp.CheckHealth();
				}
			}
			
			var fishSoldierArrRightGreen:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen;
			for (i = 0; i < fishSoldierArrRightGreen.length; i++ )
			{
				var fishGreenRight:FishSoldier = fishSoldierArrRightGreen[i] as FishSoldier;
				if (fishGreenRight != null && fishGreenRight.IsHide == false && fishGreenRight.img != null)
				{
					fishGreenRight.UpdateFish();
					fishGreenRight.CheckHealth();
				}
			}
			
			var fishSoldierArrGetGift:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterGift;
			for (i = 0; i < fishSoldierArrGetGift.length; i++ )
			{
				var fishGetGift:FishSoldier = fishSoldierArrGetGift[i] as FishSoldier;
				if (fishGetGift != null && fishGetGift.IsHide == false && fishGetGift.img != null)
				{
					fishGetGift.UpdateFish();
					fishGetGift.CheckHealth();
				}
			}
			
			var ThickArrUpRed:Array = GuiMgr.getInstance().GuiMainForest.arrThicketUpRed;
			for (i = 0; i < ThickArrUpRed.length; i++ )
			{
				var thicketRedUp:Thicket = ThickArrUpRed[i] as Thicket;
				if (thicketRedUp != null && thicketRedUp.IsHide == false)
				{
					thicketRedUp.UpdateFish();
					thicketRedUp.CheckHealth();
				}
			}
			
			for (i = 0; i < fishSoldierActorTheirs.length; i++)
			{
				var fish2:FishSoldier = fishSoldierActorTheirs[i] as FishSoldier;
				if (fish2 != null && fish2.IsHide == false)
				{
					fish2.UpdateFish();
					fish2.CheckHealth();
				}
			}
			
			for (i = 0; i < user.arrSubBossMetal.length; i++)
			{
				var subBossMetal:SubBossMetal = user.arrSubBossMetal[i] as SubBossMetal;
				if (subBossMetal != null && subBossMetal.IsHide == false)
				{
					subBossMetal.UpdateFish();
				}
			}
			for (i = 0; i < user.arrSubBossIce.length; i++)
			{
				var subBossIce:SubBossIce = user.arrSubBossIce[i] as SubBossIce;
				if (subBossIce != null && subBossIce.IsHide == false)
				{
					subBossIce.UpdateFish();
				}
			}
			switch (FishWorldController.GetSeaId()) 
			{
				case Constant.OCEAN_METAL:
					if (GameLogic.getInstance().user.bossMetal != null)
					{
						GameLogic.getInstance().user.bossMetal.Update();
					}
				break;
				case Constant.OCEAN_ICE:
					if (GameLogic.getInstance().user.bossIce != null)
					{
						GameLogic.getInstance().user.bossIce.Update();
					}
					if (FishWorldController.waveEmit)
					{
						FishWorldController.waveEmit.updateEmitter();
					}
				break;
			}
			for (i = 0; i < user.FishSoldierAllArr.length; i++)
			{
				user.FishSoldierAllArr[i].CheckHealth();
				user.FishSoldierAllArr[i].CheckStatus();
			}
			
			for (i = 0; i < user.GetMyInfo().MySoldierArr.length; i++)
			{
				user.GetMyInfo().MySoldierArr[i].CheckHealth();
				user.GetMyInfo().MySoldierArr[i].CheckStatus();
			}
			
			//if (user.bossHerb != null)
			//{
				//user.bossHerb.UpdateFish();
				//user.bossHerb.CheckHealth();
				//user.bossHerb.CheckStatus();
			//}
		}
		
		public function fallSparta():void 
		{
			for (var i:int = 0; i < user.FishArrSpartanDeactive.length; i++) 
			{
				var fis:FishSpartan = user.FishArrSpartanDeactive[i];
				if(fis.CurPos.y < fis.fallPos.y && !fis.bCollisionBottom)	//chưa chạm đáy
					fis.SetPos(fis.CurPos.x, fis.CurPos.y + 5);
				else
					fis.bCollisionBottom = true;
			}
		}
		
		public function fallSoldier(): void
		{
			for (var i:int = 0; i < user.FishSoldierExpired.length; i++)
			{
				var fs:FishSoldier = user.FishSoldierExpired[i] as FishSoldier;
				fs.fallSoldier();
			}
		}
		
		public function FeedFish(arr:Array):void
		{
			// Xài tạm trước khi merge được nhiều gói tin
			var food:Food;
			var i:int;
			var cmd:SendFeedFish = new SendFeedFish(user.CurLake.Id, user.Id, 1);
			
			// effect cộng điểm kinh nghiệm
			//if (user.IsViewer())
			{
				var fish:Fish;
				for (i = 0; i < user.GetFishArr().length; i++)
				{
					fish = user.GetFishArr()[i];
					if (fish.Eated > 0)
					{
						//var child1:Sprite = Ultility.EffExpMoneyEnergy("exp", fish.Eated);
						//var arrEff:Array = [];
						//arrEff.push(child1);								
						//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffSellFish", arrEff, fish.CurPos.x, fish.CurPos.y);
						//var srcPos:Point = Ultility.PosLakeToScreen(fish.CurPos.x, fish.CurPos.y);
						EffectMgr.getInstance().fallFlyXP( fish.CurPos.x,  fish.CurPos.y,  fish.Eated);
						fish.Eated = 0;
					}
				}
			}
			//logic
			for (i = 0; i < arr.length; i++)
			{
				food = arr[i] as Food;
				if(food.FishId > 0)
				{
					cmd.AddNew(food.FishId, food.Amount);
				}
			}
			Exchange.GetInstance().Send(cmd);
			//--------------------------------------------			
		}
		
		public function ProcessNotifyFeedFish(data1:Object, OldData:Object):void
		{
			// Nếu ko thành công thì return
			if (data1.Error != 0)
			{
				return;
			}
			
			//Ghi lại log
			log.AddAct(LogInfo.ID_FEED_FISH);			
			
			if (OldData.UserId != user.Id) return;						
			
			//Rơi bonus khi cho ca an
			var FishList:Array = OldData.FishList;
			var fishArr:Array = user.GetFishArr();
			var obj:Object;
			//Duyệt hết mảng bonust rơi ra
			for (var i:int = 0; data1.Bonus != null && i < data1.Bonus.length; i++) 
			{
				obj = ConfigJSON.getInstance().getItemInfo("ActionGift", data1.Bonus[i]);
				
				//Tìm con cá để rơi ra
				var index:int = Math.random() * FishList.length;
				for (var j:int = 0; j < fishArr.length ; j++ )
				{
					var fish:Fish = fishArr[j] as Fish;
					if (fish.Id == FishList[index]["Id"])
					{
						DropActionGift(data1.Bonus[i], fish.CurPos.x, fish.CurPos.y);
						break;
					}						
				}
			}			
			
			//Duyệt hết mảng bonust rơi ra
			if(data1.EventBonus)
			{
				for (i = 0; i < data1.EventBonus.length; i++) 
				{
					if (!Treasure.CheckEvent("PearFlower")) break;
					obj = ConfigJSON.getInstance().getItemInfo(data1.EventBonus[i].ItemType, data1.EventBonus[i].ItemId);
					if (obj)
					{					
						obj["Num"] = data1.EventBonus[i].Num; //So luong roi ra = 1
						obj["ItemId"] = data1.EventBonus[i].ItemId;
						obj["ItemType"] = data1.EventBonus[i].ItemType;
						//Tìm con cá để rơi ra
						index = Math.random() * FishList.length;
						for (j = 0; j < fishArr.length ; j++ )
						{
							fish = fishArr[j] as Fish;
							if (fish.Id == FishList[index]["Id"])
							{						
								DropActionGift(obj, fish.CurPos.x, fish.CurPos.y);
								break;
							}						
						}
					}
				}
			}
			
			dropBonusEventND(OldData, data1.EventBonus);
		}
		
		public function ProcessRefreshFriend(data1: Object): void
		{
			if (data1.Error != 0)
			{				
				return;
			}

			//GuiMgr.getInstance().GuiWaitingData.Hide();
			var i: int;
			var j: int;
			var friend: Friend;
			var ID: int;
			var FriendArr1: Array = [];
			FriendArr1.splice(0, FriendArr1.length);
			user.FriendArr.splice(0, user.FriendArr.length);
			var data:GetRefreshFriend = new GetRefreshFriend(data1);
			
			for (i = 0; i < data.FriendList.length; i++ )
			{
				FriendArr1.push(data.FriendList[i]);
			}
						
			FriendArr1.sortOn(["Level", "Exp"], Array.DESCENDING | Array.NUMERIC);
						
			var domain:String;
			for (i = 0; i < FriendArr1.length; i++ )
			{
				friend = new Friend();
				friend.ID = FriendArr1[i].Id;				
				if (FriendArr1[i].AvatarPic == null || !FriendArr1[i].AvatarPic)
				{
					friend.imgName = Main.staticURL + "/avatar.png";					
				}
				else
				{
					friend.imgName = FriendArr1[i].AvatarPic;
				}				
				friend.Index = i;
				friend.Level = FriendArr1[i].Level;
				friend.Exp = FriendArr1[i].Exp;
				
				if (FriendArr1[i].Name == null)
					friend.NickName = "Unknown";
				else
					friend.NickName = FriendArr1[i].Name;							
				user.FriendArr.push(friend);
				
				//Xử lý cross-domain				
				ResMgr.getInstance().loadPolicyFile(friend.imgName);
			}
			// MinhT
			var friendList:GetRefreshFriend = new GetRefreshFriend(data1);
			var guiFriends:GUIFriends = GuiMgr.getInstance().GuiFriends;				
			guiFriends.AddFriendList(friendList.FriendList);		
			
			//fake server cho liên đấu HiepNM2
			//FakeServerMgr.getInstance().initData(data1, 20, -1);
			//var data1:Object = FakeServerMgr.getInstance().Data1
			//trace("");
			/*
			if (LeagueController.getInstance().isRefreshingFriend == true)
			{
				//GuiMgr.getInstance().GuiTopInfo.btnLeague.SetEnable(true);
				GuiMgr.getInstance().guiFrontScreen.btnSeriesFighting.SetEnable(true);
				LeagueController.getInstance().isRefreshingFriend = false;
				var rank:int = GameLogic.getInstance().user.Rank;
				//GuiMgr.getInstance().GuiTopInfo.tfRank.text = LeagueController.rankText(rank);
			}*/
		}
		
		public function ProcessGiftBox(data1: Object): void
		{			
			user.GiftArr.splice(0, user.GiftArr.length);
			
			var temp: Object;
			var i:int;
			var j:int;
			for (var s:String in data1.ListGift)
			{
				data1.ListGift[s]["Id"] = parseInt(s);
				/*chặn với event birthday*/
				if (EventMgr.CheckEvent(GUITopInfo.NAME_CURRENT_IN_EVENT) != EventMgr.CURRENT_IN_EVENT)
				{
					if (data1.ListGift[s]["GiftId"] == 17)
					{
						continue;
					}
				}
				user.GiftArr.push(data1.ListGift[s]);
			}
			user.GiftArr.sortOn(["FromTime"], Array.DESCENDING | Array.NUMERIC);
			GuiMgr.getInstance().guiFrontScreen.btnFriendGift.SetBlink(false);
			
			if (GuiMgr.getInstance().GuiReceiveGift.IsVisible)
			{
				GuiMgr.getInstance().GuiReceiveGift.RefreshComponent();
			}
		}
		
		public function ProcessMailBox(data1: Object): void
		{
			user.LetterArr.splice(0, user.LetterArr.length);
			 
			//sap xep theo ngay
			
			var temp: Object;
			var i: int;		
			var j: int;
			//for (i = 0; i < data1.ListMail.length; i++ )
			//{
				//for (j = i + 1; j < data1.ListMail.length; j++ )
				//{
					//if (data1.ListMail[i]["FromTime"] < data1.ListMail[j]["FromTime"])
					//{
						//temp = data1.ListMail[i]; 
						//data1.ListMail[i] = data1.ListMail[j];
						//data1.ListMail[j] = temp;
					//}
				//}
			//}
			
			//for (i = 0; i < data1.ListMail.length; i++ )
			for (var s:String in data1.ListMail)
			{		
				//neu la thu
				data1.ListMail[s]["Id"] = parseInt(s);
				if (data1.ListMail[s].IsRead == true)
				{
					data1.ListMail[s]["IsReaded"] = 0;
				}
				else
				{
					data1.ListMail[s]["IsReaded"] = 1;
				}
				if(user.GetFriend(data1.ListMail[s].FromId)!=null)
					user.LetterArr.push(data1.ListMail[s]);														
			}
			user.LetterArr.sortOn(["IsReaded", "FromTime"], Array.DESCENDING | Array.NUMERIC);
			
			//GuiMgr.getInstance().GuiTopInfo.RemoveButtonMail();
			GuiMgr.getInstance().guiFrontScreen.btnMail.SetBlink(false);
			
			//if (GuiMgr.getInstance().GuiLetter.IsVisible)
			//{
				//GuiMgr.getInstance().GuiLetter.RefreshComponent();
			//}	
			if (GuiMgr.getInstance().GuiNewMail.IsVisible)
			{
				GuiMgr.getInstance().GuiNewMail.RefreshComponent();
			}	
		}
		
		public function ProcessMateFish(data:Object):void
		{
			var result:GetMateFish = new GetMateFish(data);
			var TypeShow:int = result.TypeId;
			if (TypeShow < 0) 
			{			
				if (GuiMgr.getInstance().guiMateFish.IsVisible)
				{
					//trace("lai ra cá lính bị xịt");
					GuiMgr.getInstance().guiMateFish.mateFishComplete(null, null);
				}
				return;
			}
			if (TypeShow >= Constant.FISH_TYPE_START_DOMAIN && TypeShow < Constant.FISH_TYPE_START_SOLDIER
				&& (TypeShow - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN != 0)
			{
				TypeShow -= (TypeShow - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
			}
			var imgName:String;
			var fish:Fish;
			if (TypeShow >= Constant.FISH_TYPE_START_SOLDIER)
			{
				imgName = Fish.ItemType + TypeShow + "_Old_Idle";
				fish = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);
			}
			else 
			{
				imgName = Fish.ItemType + TypeShow + "_Baby_Idle";
				fish = new Fish(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);
			}
			fish.Id = result.Id;
			fish.Sex = result.Sex;
			fish.FishTypeId = result.TypeId;
			fish.FishType = result.TypeFish;
			fish.ColorLevel = result.Color;
			fish.Level = result.Level;
			fish.Scale = Fish.SCALE_BABY;
			fish.RateOption = result.RateOption;
			fish.LakeId = user.CurLake.Id;
			fish.img.visible = false;	
			
			fish.UpdateColor();
			/*if (GuiMgr.getInstance().GuiMixFish.IsVisible)
			{
				GuiMgr.getInstance().GuiMixFish.ProcessMateFish(fish);
			}*/		
			if (GuiMgr.getInstance().guiMateFish.IsVisible)
			{
				GuiMgr.getInstance().guiMateFish.mateFishComplete(fish, data["Skill"]);
			}
		}		
		
		public function ProcessMoneyPocket(OldData:Object, NewData:Object, type:String):void
		{
			var pocket:Pocket;
			//var child1:Sprite;
			//var arr:Array = [];
			var money:int;
			//var pockerArr:Array = user.PocketArr;
			
			switch(type)
			{
				case Constant.CMD_STEAL_MONEY:
					var oldSteal:SendStealMoney = OldData as SendStealMoney;
					pocket = oldSteal.GetPocket();
					money = NewData["Money"];						
					user.UpdateUserMoney(money);
					pocket.UpdateCurrent( -money);
					pocket.AddStealer(user.GetMyInfo().Id);					
					GameLogic.getInstance().BackToOldMouse();
					
					//Ghi lai log
					log.AddAct(LogInfo.ID_STEAL_MONEY, money);
					break;
					
				case Constant.CMD_COLLECT_MONEY:
					//var oldCollect:SendCollectMoney = OldData as SendCollectMoney;
					//pocket = oldCollect.GetPocket();
					money = NewData["Money"];					
					GameLogic.getInstance().BackToOldMouse();
					break;
			}
			
			for (var i:int = 0; i < arrFish.length; i++) 
			{
				var fish:Fish = arrFish[i];
				if (fish.Id == OldData["FishId"])	
					fish.MoneyPocket = money;
			}
			
			if (NewData["Error"] != 0)
			{
				money = 0;
			}
		}
		
		/**
		 * Gửi gói tin feed lên server
		 * @param	UserMsg		Câu nói mà user chọn trong combobox hoặc tự viết
		 * @param	TypeFeed	Kiểu feed, cái này define chung giữa client và server, nó gần giống như id
		 * @param	Icon		Tên của icon sẽ hiển thị trên tường
		 * @param	ItemName	Tên của vật phẩm: ngư thạch cấp 1, cá mòi, cây rong biển,...
		 * @param	QuestName	Tên của quest, chỉ truyền vào với trường hợp feed quest: làm quen myFish, Kỹ năng giảm tiền lai cá, ...
		 */
		public function ProcessFeedWall(UserMsg:String, TypeFeed:String, Icon:String = "", ItemName:String = "", QuestName:String = ""):void
		{
			var cmd:SendFeedWall = new SendFeedWall();
			cmd.AddNew(UserMsg, TypeFeed, Icon, ItemName, QuestName);
			Exchange.GetInstance().Send(cmd);
		}
		
		public function OnQuestDone(quest:QuestInfo):void
		{
			//trace("ban vua lam xong quest " + quest.Name);
			if (quest.QuestType == QuestInfo.QUEST_SERIES)
			{
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER + 3, "EffStar", null, 90 + 190, 20 + 300);
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER + 3, "EffStar", null, 90 + 550, 20 + 300);
				//GuiMgr.getInstance().GuiSeriesQuest.InitSeriesQuest(quest);
				GuiMgr.getInstance().guiMainQuest.showGUI(quest);
				
				if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
				{
					GuiMgr.getInstance().guiMainQuest.Hide();
				}
				switch(quest.TaskList[quest.TaskList.length - 1].Action)
				{
					case "buy":
						GuiMgr.getInstance().GuiBuyFish.Close();
						break;
					case "sell":
						for (var i:int = 0; i < user.FishArr.length; i++)
						{
							var fish:Fish = user.FishArr[i] as Fish;
							if (fish.HelperName != "")
							{
								fish.HelperName = "";
								fish.SetMovingState(Fish.FS_SWIM);
							}
						}
						break;
					case "useEquipmentSoldier":
						if (user.FishSoldierArr != null && user.FishSoldierArr.length > 0)
						{
							var fs:FishSoldier = user.FishSoldierArr[0];
							if (fs.HelperName != "")
							{
								fs.HelperName = "";
								fs.SetMovingState(Fish.FS_SWIM);
							}
						}
						break;
					//case "attackFriendLake":
						//for (var j:int = 0; j < user.FishSoldierArr.length; j++)
						//{
							//var fishSoldier:FishSoldier = user.FishSoldierArr[j] as FishSoldier;
							//if (fishSoldier.HelperName != "")
							//{
								//fishSoldier.HelperName == "";
								//fishSoldier.SetMovingState(Fish.FS_SWIM);
							//}
						//}
						//break;
				}
			}
			
			if (quest.QuestType == QuestInfo.QUEST_DAILY_NEW)
			{
				//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(true);
				GuiMgr.getInstance().guiFrontScreen.btnDailyQuest.SetBlink(true);
			}
		}
		
		public function CanSaveDecorate():Boolean
		{
			if (user.IsViewer())	return false;
			var decoArr:Array = user.GetDecoArr();
			var i:int;
			for (i = 0; i < decoArr.length; i++)
			{
				var deco:Decorate = decoArr[i] as Decorate;
				if (deco.HasChanged())
				{
					return true;
				}
				if ((deco.img != null) && (!deco.img.visible))
				{
					return true;
				}
				if (deco.Id < 0)
				{
					return true;
				}
				
				if (!deco.official)
				{
					return true;
				}
			}

			return false;
		}
		
		public function UnSaveEditDecorate():void
		{
			var decoArr:Array = user.GetDecoArr();
			var i:int;
			for (i = 0; i < decoArr.length; i++)
			{
				var deco:Decorate = decoArr[i] as Decorate;
				if (!deco.img.visible)
				{
					if (deco.Id < 0)
					{
						decoArr.splice(i, 1);
						deco.Destructor();
						i = i - 1;
					}
					else
					{
						deco.img.visible = true;
						deco.UnSaveEdit();
						user.UpdateStockThing(deco.ItemType, deco.ItemId, -1);
					}
				}
				else
				{
					deco.UnSaveEdit();
					if (deco.Id < 0 || !deco.official)
					{
						user.UpdateStockThing(deco.ItemType, deco.ItemId, 1);
						decoArr.splice(i, 1);
						deco.Destructor();
						i = i - 1;
					}
				}
			}
		}
		
		private function DoStoreDecoList():void
		{
			var test:SendStoreItem = new SendStoreItem();
			test.LakeId = user.CurLake.Id;
			//var guiTop:GUITopInfo = GuiMgr.getInstance().GuiTopInfo;
			var arrTmp:Array = [];
			var numDecoNewHaBuff:int = 0;
			var countDecoHadEff:int = 0;
			var tmp1:Sprite;
			var decoArr:Array = user.GetDecoArr();
			var i:int;
			var deco:Decorate;
			
			var f:Function = function():void 
			{
				countDecoHadEff++;
				if (countDecoHadEff == numDecoNewHaBuff)
				{
					user.UpdateOptionCurLake();
					for (var j:int = 0; j < arrTmp.length; j++) 
					{
						var item:Sprite = arrTmp[j] as Sprite;
						item.parent.removeChild(item);
						item = null;
					}
					arrTmp.splice(0, arrTmp.length);
				}
			}
			
			for (i = 0; i < decoArr.length; i++)
			{
				deco = decoArr[i] as Decorate;
				if ((deco.img != null) && (!deco.img.visible))
				{
					if (deco.Id >= 0)
					{
						test.AddItem(deco.Id);
					}
					
					// Effect
					/*var buff:Object = deco.Option;
					var st:String;
					var txtFormat:TextFormat;
					var pos:Point;
					var posDes:Point;
					var posMid:Point;
					var check:Number = 0;
					for (var istr:String in buff) 
					{
						if(buff[istr] && buff[istr] > 0)
						{
							st = "-" + Ultility.StandardNumber(buff[istr]);
							txtFormat = new TextFormat("Arial", 24, 0xffffff, true);
							//pos = new Point(guiTop.ctnBuffMoney.CurPos.x - 170, guiTop.ctnBuffMoney.CurPos.y);
							pos = new Point(638, 8);
							switch (istr) 
							{
								case "Money":
									txtFormat.color = 0xF8CA12;
								break;
								case "Exp":
									txtFormat.color = 0x47E8FF;
									//pos = new Point(guiTop.ctnBuffExp.CurPos.x - 140, guiTop.ctnBuffExp.CurPos.y);
									pos = new Point(465, 8);
								break;
								case "Time":
									txtFormat.color = 0xCC00CC;
									//pos = new Point(guiTop.ctnBuffTime.CurPos.x - 80, guiTop.ctnBuffTime.CurPos.y);
									pos = new Point(589, 8);
								break;
							}
							//pos = guiTop.img.localToGlobal(pos);
							txtFormat.font = "SansationBold";
							txtFormat.align = "left";
							//tmp1 = Ultility.CreateSpriteText(st, txtFormat, 6, 0x293661, true);
							//guiTop.img.addChild(tmp1);
							
							posDes = new Point(pos.x -75 + 150 * Math.random(), pos.y + 150);
							tmp1.x = pos.x;
							tmp1.y = pos.y;
							
							check = Math.random();
							if (check >= 0.5)
							{
								posMid = new Point(pos.x, pos.y); 
							}
							else 
							{
								posMid = new Point(posDes.x, pos.y + 20); 
							}
							arrTmp.push(tmp1);
							numDecoNewHaBuff++;
							//TweenMax.to(	tmp1, 1.5,{bezier:[{x:posMid.x, y:posMid.y},{x:pos.x,y:pos.y+20}],
											//ease:Circ.easeOut, onComplete:f});
							TweenMax.to(	tmp1, 1.5,{bezier:[{x:posMid.x, y:posMid.y},{x:posDes.x,y:posDes.y}],
											ease:Circ.easeOut, onComplete:f});
							
						}
					}*/
					
					decoArr.splice(i, 1);
					deco.Destructor();
					i = i - 1;
				}
			}
			
			if (test.ItemList.length > 0)
			{
				Exchange.GetInstance().Send(test);
				user.UpdateOptionCurLake();
			}
		}
		
		private function DoUseDecoList():void
		{
			var test:SendUseItem = new SendUseItem(user.CurLake.Id);
			//var guiTop:GUITopInfo = GuiMgr.getInstance().GuiTopInfo;
			var arrTmp:Array = [];
			var numDecoNewHaBuff:int = 0;
			var countDecoHadEff:int = 0;
			var tmp1:Sprite;
			var decoArr:Array = user.GetDecoArr();
			var i:int;
			var deco:Decorate;
			
			var f:Function = function():void 
			{
				countDecoHadEff++;
				if (countDecoHadEff == numDecoNewHaBuff)
				{
					user.UpdateOptionCurLake();
					for (var j:int = 0; j < arrTmp.length; j++) 
					{
						var item:Sprite = arrTmp[j] as Sprite;
						item.parent.removeChild(item);
						item = null;
					}
					arrTmp.splice(0, arrTmp.length);
				}
			}
			
			for (i = 0; i < decoArr.length; i++)
			{
				deco = decoArr[i] as Decorate;
				if ((deco.img != null) && (deco.img.visible) && !deco.official)
				{
					test.AddNew(deco.Id, deco.ItemId, deco.ItemType, deco.CurPos.x, deco.CurPos.y, deco.Scale);
					deco.SaveInfo();
					// Effect
					/*var buff:Object = deco.Option;
					var st:String;
					var txtFormat:TextFormat;
					var pos:Point;
					var posOrig:Point;
					var posMid:Point;
					var check:Number = 0;
					for (var istr:String in buff) 
					{
						if(buff[istr] && buff[istr] > 0)
						{
							st = "+" + Ultility.StandardNumber(buff[istr]);
							txtFormat = new TextFormat("Arial", 24, 0xffffff, true);
							//pos = new Point(guiTop.ctnBuffMoney.CurPos.x - 170, guiTop.ctnBuffMoney.CurPos.y);
							pos = new Point(638, 8);
							switch (istr) 
							{
								case "Money":
									txtFormat.color = 0xF8CA12;
								break;
								case "Exp":
									txtFormat.color = 0x47E8FF;
									//pos = new Point(guiTop.ctnBuffExp.CurPos.x - 140, guiTop.ctnBuffExp.CurPos.y);
									pos = new Point(465, 8);
								break;
								case "Time":
									txtFormat.color = 0xCC00CC;
									//pos = new Point(guiTop.ctnBuffTime.CurPos.x - 80, guiTop.ctnBuffTime.CurPos.y);
									pos = new Point(589, 8);
								break;
							}
							pos = guiTop.img.localToGlobal(pos);
							txtFormat.font = "SansationBold";
							txtFormat.align = "left";
							tmp1 = Ultility.CreateSpriteText(st, txtFormat, 6, 0x293661, true);
							guiTop.img.addChild(tmp1);
							
							posOrig = Ultility.PosLakeToScreen(deco.CurPos.x, deco.CurPos.y);
							tmp1.x = posOrig.x;
							tmp1.y = posOrig.y;
							
							check = Math.random();
							if (check >= 0.5)
							{
								posMid = new Point(pos.x, posOrig.y); 
							}
							else 
							{
								posMid = new Point(posOrig.x, pos.y + 20); 
							}
							arrTmp.push(tmp1);
							numDecoNewHaBuff++;
							//TweenMax.to(	tmp1, 1.5,{bezier:[{x:posMid.x, y:posMid.y},{x:pos.x,y:pos.y+20}],
											//ease:Circ.easeOut, onComplete:f});
							TweenMax.to(	tmp1, 1.5,{bezier:[{x:posMid.x, y:posMid.y},{x:pos.x,y:pos.y+20}],
											ease:Circ.easeOut, onComplete:f});
							
						}
					}*/
				}
			}
			if (test.ItemList.length > 0)
			{
				Exchange.GetInstance().Send(test);
			}
		}
		
		private function DoEditDecoList():void
		{
			var test:SendMoveDecorate = new SendMoveDecorate(user.CurLake.Id);
			
			var decoArr:Array = user.GetDecoArr();
			var fossilArr:Array = user.FishArrSpartanDeactive;
			var i:int;
			for (i = 0; i < decoArr.length; i++)
			{
				var deco:Decorate = decoArr[i] as Decorate;
				if ((deco.img != null) && (deco.img.visible) && (deco.Id >= 0))
				{
					if (deco.HasChanged())
					{
						test.AddNew(deco.Id, deco.ItemType, deco.CurPos.x, deco.CurPos.y, deco.Scale);
						deco.SaveInfo();
					}
				}
			}
			for (i = 0; i < fossilArr.length; i++)
			{
				var fossil:FishSpartan = fossilArr[i] as FishSpartan;
				if ((fossil.img != null) && (fossil.img.visible) && (fossil.Id >= 0))
				{
					if (fossil.HasChanged())
					{
						test.AddNew(fossil.Id, fossil.ItemType, fossil.CurPos.x, fossil.CurPos.y, 1);
						fossil.SaveInfo();
					}
				}
			}
			if (test.DecoList.length > 0)
			{
				Exchange.GetInstance().Send(test);
			}
		}
		
		public function SaveEditDecorate():void
		{
			DoStoreDecoList();
			DoUseDecoList();
			DoEditDecoList();
			GuiMgr.getInstance().GuiStore.HideSaveDeco();			
			
			/*
			var test:SendMoveDecorate = new SendMoveDecorate(user.CurLake.Id);
			
			var decoArr:Array = user.GetDecoArr();
			var i:int;
			var HasEdit:Boolean = false;
			for (i = 0; i < decoArr.length; i++)
			{
				var deco:Decorate = decoArr[i] as Decorate;
				if (deco.HasChanged())
				{
					test.AddNew(deco.Id, deco.CurPos.x, deco.CurPos.y, deco.Scale);
					deco.SaveInfo();
					HasEdit = true;
				}
			}
			
			if (HasEdit)
			{
				Exchange.GetInstance().Send(test);
			}*/
			//GameController.getInstance().UseTool("Default");
		}
		
		public function HideFish(hideSoldier:Boolean = false):void
		{
			var fishArr:Array = user.GetFishArr();
			var fish:Fish;
			var i:int;
			for (i = 0; i < fishArr.length; i++ )
			{
				fish = fishArr[i] as Fish;
				fish.Hide();				
			}
			
			if (hideSoldier)
			{
				var soldier:FishSoldier;
				for (i = 0; i < user.FishSoldierArr.length; i++)
				{
					soldier = user.FishSoldierArr[i] as FishSoldier;
					soldier.Hide();
				}
			}
		}		
		
		public function ShowFish():void
		{
			var fishArr:Array = user.GetFishArr();
			var fish:Fish;
			var i:int;
			for (i = 0; i < fishArr.length; i++ )
			{
				fish = fishArr[i] as Fish;
				fish.Show();
			}
			
			var soldier:FishSoldier;
			for (i = 0; i < user.FishSoldierArr.length; i++)
			{
				soldier = user.FishSoldierArr[i] as FishSoldier;
				soldier.Show();
			}
		}
		
		public function HideEmotionFish():void
		{
			var fishArr:Array = user.GetFishArr();
			var fish:Fish;
			for (var i:int = 0; i < fishArr.length; i++ )
			{
				fish = fishArr[i] as Fish;
				fish.HideEmotion();				
			}
		}
		
		public function ShowEmotionFish():void
		{
			var fishArr:Array = user.GetFishArr();
			var fish:Fish;
			for (var i:int = 0; i < fishArr.length; i++ )
			{
				fish = fishArr[i] as Fish;
				fish.ShowEmotion();				
			}
		}		
		
		public function ShowGuiFishSoldierStatus(status:String, hideEmo:Boolean = false):void
		{
			var i:int = 0;
			var fishSArr:Array = user.GetFishSoldierArr();
			
			for (i = 0; i < fishSArr.length; i++ )
			{
				var fish1:Fish = fishSArr[i] as Fish;
				if (!fish1.IsEgg)
				{
					fish1.GuiFishStatus.ShowStatus(fish1, status);
					if (hideEmo)
					{
						if(fish1.Emotion.search(Fish.DOMAIN) < 0)
							fish1.HideEmotion();
					}
				}
			}	
		}
		
		public function ShowGuiFishStatus(status:String, hideEmo:Boolean = false):void
		{
			var fishArr:Array = user.GetFishArr();
			var i:int = 0;
			
			// show status cho cá
			for (i = 0; i < fishArr.length; i++ )
			{
				var fish:Fish = fishArr[i] as Fish;
				if (!fish.IsEgg)
				{
					fish.GuiFishStatus.ShowStatus(fish, status);
					if (hideEmo)
					{
						if(fish.Emotion.search(Fish.DOMAIN) < 0)
							fish.HideEmotion();
					}
				}
			}	
			
			// Show status cho cá chiến binh còn tòn tại
			for (i = 0; i < user.FishArrSpartan.length; i++ )
			{
				var fishSparta:FishSpartan = user.FishArrSpartan[i] as FishSpartan;
				fishSparta.GuiFishStatus.ShowStatusSparta(fishSparta, status);
			}	
			
			// Show status cho cá chiến binh đã hóa thạch
			for (i = 0; i < user.FishArrSpartanDeactive.length; i++ )
			{
				var fishSpartaDeacitve:FishSpartan = user.FishArrSpartanDeactive[i] as FishSpartan;
				if(status != GUIFishStatus.STATUS_FEED)
					fishSpartaDeacitve.GuiFishStatus.ShowStatusSparta(fishSpartaDeacitve, status);
			}	
			
			//Cá pháo hoa
			for each(var fireworkFish:FireworkFish in user.arrFireworkFish)
			{
				fireworkFish.GuiFishStatus.ShowFireworkStatus(fireworkFish, status);
			}
		}
		
		public function HideGuiFishStatus():void
		{
			var fishArr:Array = user.GetFishArr();
			var fish:Fish;
			for (var i:int = 0; i < fishArr.length; i++ )
			{				
				fish = fishArr[i] as Fish;
				if (!fish.IsEgg)
				{
					fish.GuiFishStatus.Hide();
					fish.ShowEmotion();
				}
			}	
			
			var fishSArr:Array = user.GetFishSoldierArr();
			var fishSoldier:FishSoldier;
			for (var j:int = 0; j < fishSArr.length; j++ )
			{				
				fish = fishSArr[j] as FishSoldier;
				if (!fish.IsEgg)
				{
					fish.GuiFishStatus.Hide();
					fish.ShowEmotion();
				}
			}	
			
			// ẩn status cho cá chiến binh còn tòn tại
			for (i = 0; i < user.FishArrSpartan.length; i++ )
			{
				var fishSparta:FishSpartan = user.FishArrSpartan[i] as FishSpartan;
				fishSparta.GuiFishStatus.Hide();
			}	
			
			// ẩn status cho cá chiến binh đã hóa thạch
			for (i = 0; i < user.FishArrSpartanDeactive.length; i++ )
			{
				var fishSpartaDeacitve:FishSpartan = user.FishArrSpartanDeactive[i] as FishSpartan;
				fishSpartaDeacitve.GuiFishStatus.Hide();
			}	
			
			//Cá pháo hoa
			for each(var fireworkFish:FireworkFish in user.arrFireworkFish)
			{
				fireworkFish.GuiFishStatus.Hide();
			}
		}	
		
		/**
		 * Rơi ra quà khi action
		 * @param	bonus	đối tượng chưa thông tin quà: loại quà, số lượng
		 * @param	x	vị trí rơi ra theo phương x
		 * @param	y	vị trí rơi ra theo phương y
		 */
		public function DropActionGift(bonus:Object, x:int, y:int, stayInLake:Boolean = false):void
		{
			if (!bonus.ItemType || !bonus.Num) 	return;
			var itemType:String = bonus["ItemType"];
			var itemId:int = bonus["ItemId"];
			var num:int = bonus["Num"];
			var name:String;
			switch(itemType)
			{
				case "Balls":
					name = "Ic_" + bonus["ItemId"] + "Ball";
					break;
				case "Energy":
				case "EnergyItem":
					itemType = "EnergyItem";
					name = itemType + itemId;
					break;
				case "Material":
					if ((QuestMgr.getInstance().SpecialTask["collectMaterial"] != null) && (GameLogic.getInstance().user.IsViewer()))
					{
						var stask:TaskInfo = QuestMgr.getInstance().SpecialTask["collectMaterial"];
						stask.Num += num;
						if (stask.Num >= stask.MaxNum)
						{
							stask.Num = stask.MaxNum;
							stask.Status = true;
						}
						
						// Neu hoan thanh quest -> Rung button
						if (QuestMgr.getInstance().isQuestDone() && (!GameLogic.getInstance().user.IsViewer()) && (QuestMgr.getInstance().isBlink == false))
						{
							//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(true);
							GuiMgr.getInstance().guiFrontScreen.btnDailyQuest.SetBlink(true);
							QuestMgr.getInstance().isBlink = true;
						}
					}
					name = Ultility.GetNameMatFromType(itemId);
					break;
				case "Icon":
				case "Viagra":
				case "IconND":
				case "DragonBall":
					name = itemType + itemId;
					break;
				case "Arrow":
					name = "GUIGameEventMidle8_" + itemType + itemId;
					break;
				case "Ticket":
					name = "EventLuckyMachine_" + itemType + itemId;
			}
			
			var mat:FallingObject;
			var waitTime:Number = 0;
			var fallArr:Array = GameLogic.getInstance().user.fallingObjArr;
			for (var i:int = 0; i < num; i++) 
			{
				if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE) continue;
				mat = new  FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), name, x, y);
				mat.stayInLake = stayInLake;
				waitTime = 5 + fallArr.length*0.3;
				mat.setWaitingTime(waitTime);
				mat.ItemType = itemType;
				mat.ItemId = itemId;
				if (itemType == "Icon")
				{
					mat.setRandomDir(true);
				}
				else if (itemType == "IconND")
				{
					mat.setRandomDir(true);
				}
				else if (itemType == "Arrow") 
				{
					mat.setRandomDir(true);
					mat.getDesToFly = function():Point
					{
						var pos:Point = new Point(0, 0);
						return pos;
					}
				}
				else if (itemType == "Balls")
				{
					mat.setRandomDir(true);
					if (!GameLogic.getInstance().user.IsViewer())
					{
						//mat.getDesToFly = function():Point
						//{
							//var pos:Point = new Point(GuiMgr.getInstance().GuiTopInfo.btnEvent.img.x, GuiMgr.getInstance().GuiTopInfo.btnEvent.img.y);
							//pos = GuiMgr.getInstance().GuiTopInfo.img.localToGlobal(pos);
							//return pos;
						//}
					}
				}
				
				fallArr.push(mat);
				
				if (itemType == "DragonBall")
				{
					arrDragonBall.push(mat);
				}
			}	
			
			var guiStore:GUIStore = GuiMgr.getInstance().GuiStore;
			if (guiStore.IsVisible == false && bonus["ItemId"] != "" && itemType != "Balls") //ItemId = "", tức là ko được gì
			{
				guiStore.UpdateStore(itemType, itemId, num);
			}
		}		
		
		public function dropInLake(obj:Object, x:Number, y:Number):void
		{
			var itemType:String = obj["ItemType"];
			var itemId:int = obj["ItemId"];
			var num:int = obj["Num"];
			var name:String;
			switch(itemType)
			{
				case "DragonBall":
					name = itemType + itemId;
					break;
			}
			var mat:FallingObject;
			var waitTime:Number = 0;
			var fallArr:Array = GameLogic.getInstance().user.fallingObjArr;
			for (var i:int = 0; i < num; i++) 
			{
				mat = new  FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), name, x, y);
				mat.stayInLake = true;
				mat.ItemType = itemType;
				mat.ItemId = itemId;
				fallArr.push(mat);
				arrDragonBall.push(mat);
			}	
		}
		
		public function CreatePocket(fish:Fish):void
		{
			if (fish.IsEgg)
			{
				return;
			}
			//var obj:Object = INI.getInstance().getItemInfo(fish.FishTypeId.toString(), Fish.ItemType);
			var obj:Object = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, fish.FishTypeId);
			var money:int = fish.MoneyPocket;
			
			if (money <= 0)
			{
				return;
			}
			var imgPocket:String = "imgPocket";
			if (fish.ThiefList.length > 0 && !user.IsViewer())
			{
				imgPocket = "imgPocketOpen";
			}
			var pocket:Pocket = new Pocket(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgPocket);
			var TargetPocket:Point = new Point();
			TargetPocket.x = Ultility.RandomNumber(300, 800);
			TargetPocket.y = GameController.getInstance().GetLakeTop() + 270;// Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 50, GameController.getInstance().GetLakeBottom() - 30);
			pocket.SetPos(fish.CurPos.x, fish.CurPos.y);
			pocket.SetData(money, TargetPocket, fish);
			if(pocket.Check() == 0)
			{
				pocket.ClearImage();
				return;
			}
			user.PocketArr.push(pocket);
		}
		public function ClearPocket():void 
		{
			for (var i:int = 0; i < user.PocketArr.length; i++) 
			{
				var pocket:Pocket = user.PocketArr[i];
				if(pocket.fish.Growth() < pocket.fish.NumUpLevel + 1)
				{
					pocket.ClearImage();
					pocket.fish.isCreatePocket = false;
					pocket.fish.isSendLevelUP = false;
					i--;
					
					//pocket.fish.SetEmotion(Fish.IDLE);
					//if ((pocket.fish.Level - 50 - 1 % 6) == 0)
					if (pocket.fish.DomainFish() <= 0)
					{
						pocket.fish.SetEmotion(Fish.IDLE);
					}
					else
					{
						pocket.fish.SetEmotion(Fish.DOMAIN + pocket.fish.DomainFish());
					}
					user.PocketArr.splice((i + 1), 1);
				}
			}
		}
		
		/*public function AfterEffect():void 
		{
			var i:int;
			var fish:Fish;
			
			// Eff trứng nở
			for (i = 0; i < swfEffHatchArr.length; i++)
			{
				var swfEffHatch:SwfEffect = swfEffHatchArr[i];
				if (swfEffHatch != null && swfEffHatch.IsFinish)
				{
					fish = swfEffHatch.ObjUse as Fish;
					if (user.CurLake.NumFish < user.CurLake.CurCapacity)
					{
						fish.SetPos(swfEffHatch.PosX, swfEffHatch.PosY);
						fish.SetMovingState(Fish.FS_SWIM);
						fish.SetAgeState(Fish.BABY);			
						fish.StartTime = CurServerTime;
						fish.IsEgg = false;				
						fish.Show();
						user.CurLake.NumFish++;
					}
					else
					{
						var name:String = Localization.getInstance().getString("Fish" + fish.FishTypeId);
						GuiMgr.getInstance().GuiMessageBox.ShowGoToInventory(name);
						GuiMgr.getInstance().GuiStore.UpdateStore("BabyFish", fish.FishTypeId);
						
						//xoa con ca khoi mang ca
						var index:int = user.FishArr.indexOf(fish);
						var fishArr:Array = user.GetFishArr();			
						fish.Clear();
						fishArr.splice(index, 1);
					}
					//var obj:Object = INI.getInstance().getItemInfo(fish.FishTypeId.toString(), Fish.ItemType);
					var obj:Object = ConfigJSON.getInstance().GetItemInfo(Fish.ItemType, fish.FishTypeId);
					
					// Check feed new fish:
					if (!GameLogic.getInstance().user.CheckFishUnlocked(fish.FishTypeId))
					{
						GuiMgr.getInstance().GuiFeedWall.SetFishType(fish.FishTypeId);
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_NEW_FISH);
					}
					
					if (obj["UnlockType"] == 2)
					{
						user.AddFishUnlock(fish.FishTypeId);
					}					
					
					swfEffHatch = null;
					swfEffHatchArr.splice(i, 1);
				}
			}
			
			// Eff khi cứu cá
			for (i = 0; i < swfEffCureFishArr.length; i++)
			{
				var effCureFish:SwfEffect = swfEffCureFishArr[i] as SwfEffect;
				
				if (effCureFish != null && effCureFish.IsFinish)
				{
					fish = effCureFish.ObjUse as Fish;
					fish.SetEmotion(Fish.LOVE);
					if (GuiMgr.getInstance().GuiFishInfo.IsVisible && user.FishArr[GuiMgr.getInstance().GuiFishInfo.FishId] == fish)
					{
						fish.SetMovingState(Fish.FS_IDLE);
					}
					else
					{
						fish.SetMovingState(Fish.FS_SWIM);
					}
					fish.SetHighLight( -1);
					
					effCureFish = null;
					swfEffCureFishArr.splice(i, 1);
				}
			}
		}*/
		
		/**
		 * @param	event: Sự kiện cá sẽ nói
		 * @param	time: thời gian chatbox tồn tại, đơn vị milisecond, mặc định 5 giây
		 * @param	rate: tỉ lệ xuất hiện câu nói cho mỗi con cá, càng nhỏ càng cao, mặc định 1/20
		 */ 
		public function FishChatting(event:String, time:int = 5000, rate:int = 20, fish:Fish = null):void
		{				
			var i:int;
			var f:Fish;
			
			for (i = 0; i < user.GetFishArr().length; i++)
			{
				f = user.GetFishArr()[i];
				if (f.chatbox.IsShow)
				{
					return;
				}
			}
			if(fish == null)
			{
				var id:int = Ultility.RandomNumber(0, user.GetFishArr().length - 1);
				fish = user.GetFishArr()[id];				
			}
			
			if (fish && !fish.IsEgg && fish.State == Fish.FS_SWIM)
			{ 
				fish.Chatting(event, time, rate);
			}
		}
		
		//Update trạng thái cá đi theo đàn
		public function UpdateHerd(): void
		{
			if (user.FishKing == null) return;
			var i: int, j: int;
			var p1: Point, p2: Point;
			var fish: Fish;
			var fishKing:Fish = user.FishKing;
			p2 = fishKing.CurPos;		// tọa độ con cá đầu đàn
			fishKing.SetHighLight(0x00cc33);	// set hightlight cho con cá đầu đàn
			
			if (user.FishKing.img && !fishKing.IsHide && fishKing.State == Fish.FS_SWIM)	// Nếu có cá đầu đàn
			{
				 //Loai cac con ca trong dan nhung ra ngoai tam anh huong
				for (var i0:int = 0; i0 < arrFish.length; i0++) 
				{
					fish = arrFish[i0] as Fish;
					p1 = fish.CurPos;			// Tọa độ của con cá đó
					if(p1 && p2)
						if (p1.subtract(p2).length >= Fish.RADIUS)
						{
							fish.SetHighLight(-1);
							fish.SetMovingState(Fish.FS_SWIM);
							fish.ReachDes = true;
							arrFish.splice(i0, 1);
							i0--;
						}
				}
				for (i = 0; i < user.FishArr.length; i++ )	// duyệt mảng các con cá
					if (user.FishKing != user.FishArr[i])	//Nếu con cá khác cá đầu đàn
					{
						var inArr:Boolean = false;
						fish = user.FishArr[i] as Fish;
						for (var j1:int = 0; j1 < arrFish.length; j1++)
							if (arrFish[j1] == fish)
							{
								inArr = true;
								break;
							}
						p1 = fish.CurPos;			// Tọa độ của con cá đó
						if (p1.subtract(p2).length < Fish.RADIUS && fish.State != Fish.FS_HERD && arrFish.length < NumMaxFish
							&& fish.State == Fish.FS_SWIM && !inArr)	
						//Neu con ca trong vung anh huong cua ca dau dan
						//Va no phai o sau ca dau dan
						//va dang o ngoai dan
						{
							arrFish.push(fish);
							var distance0:Number = fishKing.img.width + fish.img.width;
							if (distance0 > Fish.RADIUS)	distance0 = Fish.RADIUS - 5;
							fish.SetMovingState(Fish.FS_HERD);
							//fish.ReachDes = true;
						}
					}
				
				var deltaY:Number = 3 * Fish.RADIUS / 4;
				deltaY = deltaY / arrFish.length;
				var YStart:Number 
				YStart = fishKing.DesPos.y + deltaY * ( -int(arrFish.length / 2));
				
				for (var i1:int = 0; i1 < arrFish.length; i1++) 
				{
					var tempFish:Fish = arrFish[i1] as Fish;
					if (tempFish.img && tempFish.CurPos)
					{
						var test:Number;
						var vec:Point = fishKing.DesPos.subtract(fishKing.CurPos);
						var distance:Number
						distance = fishKing.img.width + tempFish.img.width;
						var rand:Number = Ultility.RandomNumber(-5, 10);
						if (fishKing.CurPos.y < tempFish.CurPos.y) 	rand = -rand;
						if (distance > Fish.RADIUS)	distance = Fish.RADIUS;
						// Nhập các con cá ở đằng trước lại
						if (fishKing.SpeedVec.x * (fishKing.CurPos.x - tempFish.CurPos.x) < fishKing.img.width / 2 + 5)
							tempFish.SwimTo( tempFish.CurPos.x + vec.x,YStart + i1 * deltaY, 1);
						else
						{
							if (fishKing.SpeedVec.x * (fishKing.CurPos.x - tempFish.CurPos.x) >= fishKing.img.width / 2 + 5 &&
								fishKing.SpeedVec.x * (fishKing.CurPos.x - tempFish.CurPos.x) <= Math.abs(fishKing.SpeedVec.x) * 5 * distance / 6)
								tempFish.SwimTo( tempFish.CurPos.x + vec.x, YStart + i1 * deltaY, 3 * Math.random());
							else
							{
								tempFish.SwimTo(tempFish.CurPos.x + vec.x, YStart + i1 * deltaY, 2);
							}
						}
						if(tempFish.CurPos.subtract(fishKing.CurPos).length < Fish.RADIUS)
							tempFish.SetHighLight(0xaa11cc);
						else 
							tempFish.SetHighLight( -1);
					}
				}
					
			}
			else 
			{
				if (user.FishKing.img == null) 
				{
					user.FishKing = user.FishArr[0];
				}
			}
			
			
		}
		
		private function desSwimTo(fish1:Fish, fish2:Fish):Point 
		{
			var desReturn:Point = new Point();
			if (fish1.SpeedVec.x * fish2.SpeedVec.x < 0) 
			{
				var s0f1:Number = new Number();
				var s0f2:Number = new Number();
				var s0f12:Number = new Number();
				if (Math.abs(fish1.CurPos.x - fish2.CurPos.x) > s0f1 + s0f2) 
				{
					s0f1 = 0.075 * fish1.realMaxSpeed;
					s0f2 = fish2.realMaxSpeed * fish1.realMaxSpeed / 0.15;
					s0f12 = (Math.abs(fish1.CurPos.x - fish2.CurPos.x) - (s0f1 + s0f2)) * fish2.realMaxSpeed / (fish1.realMaxSpeed + fish2.realMaxSpeed); 
					desReturn.y = fish2.CurPos.y;
					if (fish2.SpeedVec.x > 0) 
						desReturn.x = fish2.CurPos.x + s0f2 + s0f12;
					else 
						desReturn.x = fish2.CurPos.x - (s0f2 + s0f12);
				}
				else 
				{
					s0f12 = fish2.realMaxSpeed / (0.15 * 0.075 + fish2.realMaxSpeed);
					desReturn.y = Ultility.RandomNumber(Math.max(fish2.CurPos.y - Fish.RADIUS, fish1.SwimingArea.bottom), 
							Math.min(fish2.CurPos.y + Fish.RADIUS,fish1.SwimingArea.top));;
					if (fish2.SpeedVec.x > 0) 
						desReturn.x = fish2.CurPos.x + s0f2 + s0f12;
					else 
						desReturn.x = fish2.CurPos.x - (s0f2 + s0f12);
				}
			}
			return desReturn;
		}
		
		public function Test():void
		{
			//if(int(CurServerTime) % 2 == 0)
			//{
				//var cmd:SendFeedFish = new SendFeedFish(GameLogic.getInstance().user.CurLake.Id, GameLogic.getInstance().user.Id, 1);
				//cmd.AddNew(1, 0);
				//Exchange.GetInstance().Send(cmd);
			//}
		}
		//hiepnm2
		/**
		 * thực hiện khi sử dụng xăng cho máy giới hạn năng lượng
		 * @param	type: loại xăng sử dụng=> quyết định thời gian sử dụng máy
		 */
		public function UsePetrol(type:int):void//đang ở nhà mình
		{
				//if (user.GetMyInfo().IsExpiredMachine)//chưa đổ xăng, hoặc hết xăng				
				//{
					//
					//user.GetMyInfo().IsExpiredMachine = false;
					
					
					//thực hiện trừ số lượng bình xăng trong guiStore	và update GUIStore
					
					//thực hiện send lên server để server
			//if (gameState == GameState.GAMESTATE_OPEN_MAGIC_BAG)
			//return;
			var cmd:SendUsePetrol = new SendUsePetrol(type);
			Exchange.GetInstance().Send(cmd);
			//thay đổi thuộc tính cho user.energyMachine 
			
			if (user.GetMyInfo().IsExpiredMachine)
			{
				user.GetMyInfo().energyMachine.IsExpired = false;
				user.GetMyInfo().IsExpiredMachine = false;
				user.GetMyInfo().energyMachine.SetInterface();
				user.GetMyInfo().energyMachine.StartTime = CurServerTime;
				user.GetMyInfo().StartTimeEnergyMachine = CurServerTime;
				user.GetMyInfo().energyMachine.ExpiredTime = ConfigJSON.getInstance().getExpiredTimePetrol(type);
				user.GetMyInfo().ExpiredTimeEnergyMacnine = ConfigJSON.getInstance().getExpiredTimePetrol(type);
			}
			else
			{
				user.GetMyInfo().ExpiredTimeEnergyMacnine += ConfigJSON.getInstance().getExpiredTimePetrol(type);
				user.GetMyInfo().energyMachine.ExpiredTime += ConfigJSON.getInstance().getExpiredTimePetrol(type);
			}
			var iCurEnergy:int = user.GetEnergy();
			var EnergyPetrol:int = ConfigJSON.getInstance().GetItemList("Param")["EnergyMachine"];
			var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(user.GetLevel());
			user.SetEnergy(iCurEnergy, true);
			user.GetMyInfo().bonusMachine -= EnergyPetrol;
			if (user.GetMyInfo().bonusMachine < 0)	user.GetMyInfo().bonusMachine = 0;
			
			//GuiMgr.getInstance().GuiTopInfo.SuggestEnergyTooltip(iCurEnergy, maxEnergy);		//tam thoi de day
			//GuiMgr.getInstance().guiFrontScreen.updateEnergy(iCurEnergy, maxEnergy);
			GuiMgr.getInstance().guiUserInfo.energy = iCurEnergy;

			GuiMgr.getInstance().GuiStore.UpdateStore("Petrol", type, -1);
				//}
		}
		
		/**
		 * Hồi sinh cho cá lính
		 * Longpt
		 * @param	fs
		 */
		public function ReviveSoldier(fs:FishSoldier):void
		{
			if (fs.Status != FishSoldier.STATUS_REVIVE || (GameLogic.getInstance().user.IsViewer() && fs.isActor != FishSoldier.ACTOR_MINE))
			{
				return;
			}
			var GinsengCfg:Object = ConfigJSON.getInstance().GetItemList("Ginseng")[GuiMgr.getInstance().GuiStore.curItemId];
			var isUsable:Boolean = false;
			var min:int = 0;
			var max:int = 0;
			for (var ii:int = 0; ii < GinsengCfg["Rank"].length; ii++)
			{
				if (min == 0 || min > GinsengCfg["Rank"][ii])
				{
					min = GinsengCfg["Rank"][ii];
				}
				
				if (max == 0 || max < GinsengCfg["Rank"][ii])
				{
					max = GinsengCfg["Rank"][ii];
				}
				
				if (GinsengCfg["Rank"][ii] == fs.Rank)
				{
					isUsable = true;
				}
			}
			
			if (!isUsable)
			{
				var posStart:Point = fs.img.localToGlobal(new Point(0, 0));
				var posEnd:Point = new Point(posStart.x, posStart.y - 100);
				var str:String = Localization.getInstance().getString("FishWarMsg31");
				str = str.replace("@ItemName@", Localization.getInstance().getString("Ginseng" + GuiMgr.getInstance().GuiStore.curItemId).split("\n")[0]);
				str = str.replace("@Min@", min + "");
				str = str.replace("@Max@", max + "");
				Ultility.ShowEffText(str, fs.img, posStart, posEnd);
				fs.SetHighLight( -1);
				return;
			}
			var itemId:int = GuiMgr.getInstance().GuiStore.curItemId;
			
			// Gửi gói tin
			var cmd:SendRebornSoldier = new SendRebornSoldier(fs.Id, fs.LakeId, itemId);
			Exchange.GetInstance().Send(cmd);
			
			// Cập nhật kho
			GuiMgr.getInstance().GuiStore.UpdateStore("Ginseng", itemId, -1);
			if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)
			{
				GuiMgr.getInstance().GuiMainFishWorld.UpdateStore();
			}
			if (user.GetStoreItemCount("Ginseng", itemId) == 0)
			{
				if (gameMode == GameMode.GAMEMODE_WAR)
				{
					MouseTransform("");
				}
				else
				{
					BackToIdleGameState();
				}
			}
			
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
			{
				fs.SetEmotion(Fish.HAPPY);
				fs.SetMovingState(Fish.FS_SWIM);
			}
			else 
			{
				fs.SetEmotion(Fish.IDLE);
				fs.SetMovingState(Fish.FS_STANDBY);
			}
			
			// Effect cá khỏe lại
			// Cá khỏe lại
			fs.OriginalStartTime = GameLogic.getInstance().CurServerTime;
			fs.LifeTime = ConfigJSON.getInstance().GetItemList("Ginseng")[itemId]["Expired"];
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
			{
				fs.SetEmotion(Fish.HAPPY);
			}
			else
			{
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
		}
		
		/**
		 * Hồi máu cho cá lính
		 * Longpt
		 * @param	fs
		 */
		public function RecoverHealth(fs:FishSoldier):void
		{
			if (!fs.isInRightSide && gameMode == GameMode.GAMEMODE_WAR)
			{
				return;
			}
			// không buff vào dc cá nhà bạn
			if (GameLogic.getInstance().user.IsViewer() && fs.isActor != FishSoldier.ACTOR_MINE)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg22"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			if (fs.Health >= fs.MaxHealth)
			{
				var child:Sprite = new Sprite();
				var str:String = Localization.getInstance().getString("Message38");
				//var txtFormat:TextFormat = new TextFormat(null, 20, 0xFFFF00);
				//txtFormat.bold = true;
				//txtFormat.align = "center";
				//txtFormat.font = "Arial";
				var posStart:Point = fs.img.localToGlobal(new Point(0, 0));
				var posEnd:Point = new Point(posStart.x, posStart.y - 100);
				Ultility.ShowEffText(str, fs.img, posStart, posEnd);
				//GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg12"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			//var ItemId:int = GuiMgr.getInstance().GuiStoreSoldier.curItemId;
			var ItemId:int = GuiMgr.getInstance().GuiStore.curItemId;
			var cmd:SendRecoverHealthSoldier = new SendRecoverHealthSoldier(fs.Id, fs.LakeId, ItemId);
			Exchange.GetInstance().Send(cmd);
			
			var hp:int = ConfigJSON.getInstance().GetItemList("RecoverHealthSoldier")[String(ItemId)]["Num"];
			var i:int;
			for (i = 0; i < user.FishSoldierArr.length; i++)
			{
				if (user.FishSoldierArr[i].Id == fs.Id)
				{
					user.FishSoldierArr[i].UpdateHealth(hp); 
					user.FishSoldierArr[i].LastHealthTime = CurServerTime;
					break;
				}
			}
			for (i = 0; i < user.GetMyInfo().MySoldierArr.length; i++)
			{
				if (user.GetMyInfo().MySoldierArr[i].Id == fs.Id)
				{
					user.GetMyInfo().MySoldierArr[i].UpdateHealth(hp); 
					user.GetMyInfo().MySoldierArr[i].LastHealthTime = CurServerTime;
					break;
				}
			}
			
			// Nếu buff ở nhà bạn hoặc thế giới Mộc thì cập nhật vào cá diễn viên của mình
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR || GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST)
			{
				for (i = 0; i < user.FishSoldierActorMine.length; i++)
				{
					if (user.FishSoldierActorMine[i].Id == fs.Id)
					{
						user.FishSoldierActorMine[i].UpdateHealth(hp);
						user.FishSoldierActorMine[i].LastHealthTime = CurServerTime;
					}
				}
			}
			
			//GuiMgr.getInstance().GuiStoreSoldier.UpdateStore("RecoverHealthSoldier", ItemId, -1);
			GuiMgr.getInstance().GuiStore.UpdateStore("RecoverHealthSoldier", ItemId, -1);
			if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)	GuiMgr.getInstance().GuiMainFishWorld.UpdateStore();
			if (user.GetStoreItemCount("RecoverHealthSoldier", ItemId) == 0)
			{
				if (gameMode == GameMode.GAMEMODE_WAR)
				{
					MouseTransform("");
				}
				else
				{
					BackToIdleGameState();
				}
			}
			
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR 
				&& GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)
			{
				fs.SetEmotion(Fish.HAPPY);
				fs.SetMovingState(Fish.FS_SWIM);
			}
			else 
			{
				fs.SetEmotion(Fish.IDLE);
				fs.SetMovingState(Fish.FS_STANDBY);
			}
			
			
			if (fs.SpeedVec.x < 0)
			{
				EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffUseGinseng", null, fs.CurPos.x - 30, fs.CurPos.y, true);
			}
			else
			{
				EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffUseGinseng", null, fs.CurPos.x, fs.CurPos.y, true);
			}
			
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_NORMAL)
			{
				fs.GuiFishStatus.ShowStatus(fs, GUIFishStatus.RECOVER_HEALTH);
			}
			else
			{
				if(fs.GuiFishStatus.prgHealth)
				{
					fs.GuiFishStatus.prgHealth.setStatus(fs.Health / fs.MaxHealth);
				}
			}
		}
		/*
		 * 
		 * @fs [in]: cá lính được sử dụng rankPoint
		 */ 
		public function increaseRankPoint(fs:FishSoldier, numBottle:int):void
		{
			fs.MaxRankPoint = ConfigJSON.getInstance().GetFishRankInfo(fs.Rank)["PointRequire"];
			if (fs.RankPoint >= fs.MaxRankPoint)
			{//không dùng được
				var str:String = Localization.getInstance().getString("Message38");
				var posStart:Point = fs.img.localToGlobal(new Point(0, 0));
				var posEnd:Point = new Point(posStart.x, posStart.y - 100);
				Ultility.ShowEffText(str, fs.img, posStart, posEnd);
				return;
			}
			else
			{//send dữ liệu lên server
				curFishUseRankPoint = new Object();//tham chiếu
				curFishUseRankPoint = fs;
				idFishUseRPB = fs.Id;
				var itemId:int = GuiMgr.getInstance().GuiStore.curRankPointBottleId;
				GuiMgr.getInstance().GuiStore.UpdateStore("RankPointBottle", itemId, -numBottle);
				if (user.GetStoreItemCount("RankPointBottle", itemId) <= 0)
				{
					BackToIdleGameState();
					(curFishUseRankPoint as FishSoldier).GuiFishStatus.Hide();
				};
				(curFishUseRankPoint as FishSoldier).ShowEffect((curFishUseRankPoint as FishSoldier).Element,(curFishUseRankPoint as FishSoldier).CurPos);
				(curFishUseRankPoint as FishSoldier).SetEmotion("Happy");
				(curFishUseRankPoint as FishSoldier).SetMovingState(Fish.FS_SWIM);
				//tăng progessBar theo id của RankPointBottle
				var increase:int = ConfigJSON.getInstance().getItemInfo("RankPointBottle", itemId)["Num"];
				if (!isUseRPfinish)//nếu chưa nhận dữ liệu về => fake việc cộng thêm rankpoint
				{
					curRankPoint += increase*numBottle;
				}
				else	//lấy được dữ liệu về, lấy luôn RankPoint của cá
				{
					curRankPoint = (curFishUseRankPoint as FishSoldier).RankPoint;
					isUseRPfinish = false;
				}
				var curStatus:Number = curRankPoint/ (curFishUseRankPoint as FishSoldier).MaxRankPoint;
				//(curFishUseRankPoint as FishSoldier).GuiFishStatus.prgRank.setStatus(curStatus);
				AddPrgToProcess((curFishUseRankPoint as FishSoldier).GuiFishStatus.prgRank, curStatus);
				var pk:SendUseRankPointBottle = new SendUseRankPointBottle(fs.LakeId, fs.Id, itemId, numBottle);
				Exchange.GetInstance().Send(pk);
			};
		};
		/*
		 * tăng điểm chiến công cho cá sau khi nhận dữ liệu từ server trả về
		 * @rankPoint: dữ liệu từ server trả về 
		 */ 
		//public var rankPointBefore:int = 0;
		public function increaseRankPoint2(data1:Object, oldData:SendUseRankPointBottle):void
		{
			isUseRPfinish = true;
			var obj:Object = GameLogic.getInstance().user.getItemStore("RankPointBottle", oldData.ItemId);
			var numUse:int = obj["Num"] - data1["Num"];
			//GuiMgr.getInstance().GuiStore.UpdateStore("RankPointBottle", oldData.ItemId, -numUse);
			//var info:Object = user.getFishSoldierInfo(idFishUseRPB);
			//if (rankPoint <= (curFishUseRankPoint as FishSoldier).rankPointBefore||rankPoint>=(curFishUseRankPoint as FishSoldier).MaxRankPoint)//levelup
			if ((curFishUseRankPoint as FishSoldier).Rank < data1["Rank"])//levelup
			{
				(curFishUseRankPoint as FishSoldier).levelUpTime = CurServerTime;
				// Rung màn hình
				GameController.getInstance().shakeScreen(10, 2, 20, false);
				(curFishUseRankPoint as FishSoldier).SetSoldierInfo(data1["Rank"]);
				(curFishUseRankPoint as FishSoldier).Rank = data1["Rank"];
			}
			(curFishUseRankPoint as FishSoldier).RankPoint = data1["RankPoint"];
			(curFishUseRankPoint as FishSoldier).rankPointBefore = data1["RankPoint"];
			var logicFishArr:Array = user.GetMyInfo().MySoldierArr;
			for (var i:int = 0; i < logicFishArr.length; i++) {
				var logicFish:FishSoldier = logicFishArr[i] as FishSoldier;
				if (logicFish.Id == (curFishUseRankPoint as FishSoldier).Id) {
					var buff:int = data1["RankPoint"] - logicFish.RankPoint;
					logicFish.UpdateKillMarkPoint(buff);
					break;
				}
			}
			AddPrgToProcess((curFishUseRankPoint as FishSoldier).GuiFishStatus.prgRank, data1["RankPoint"]/(curFishUseRankPoint as FishSoldier).MaxRankPoint);
		}
		//Quangvh
		public function UseMaterialForFish(fis:Object, kindFish:int = 0):void
		{
			GameLogic2.UseMaterial(fis, kindFish);
		}
		
		//hiepnm2
		public function UseViagra(fis:Fish, isInGUIMix:Boolean = false):void
		{
			var i:int;
			//send dữ liệu lên server user.getMyInfo().uId và fis.LakeId
			
			var cmd:SendUseViagra = new SendUseViagra(fis.Id, fis.LakeId);
			Exchange.GetInstance().Send(cmd);
			for (i = 0; i < user.AllFishArr.length; i++)
			{
				if (user.AllFishArr[i].Id == fis.Id)
				{
					user.AllFishArr[i].LastTimeViagra = CurServerTime;
					user.AllFishArr[i].ViagraUsed = 1;
					user.AllFishArr[i].LastBirthTime = 0;
					break;
				}
			}
			for (i = 0; i < user.FishArr.length; i++)
			{
				if (user.FishArr[i].Id == fis.Id)
				{
					user.FishArr[i].LastTimeViagra = CurServerTime;
					user.FishArr[i].ViagraUsed = 1;
					user.FishArr[i].LastBirthTime = 0;
					break;
				}
			}
			fis.ViagraUsed = 1;
			fis.LastBirthTime = 0;
			if(GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.UpdateStore("Viagra", 1, -1);
			}
			else
			{
				GameLogic.getInstance().user.UpdateStockThing("Viagra", 1, -1);
			}
			if (user.GetStoreItemCount("Viagra", 1) == 0)
			{
				BackToIdleGameState();
			}
			if(!isInGUIMix)
			{
				fis.SetEmotion("Happy");
				//var srcPos:Point = Ultility.PosLakeToScreen(fis.CurPos.x, fis.CurPos.y);
				EffectMgr.getInstance().fallFlyXP(fis.CurPos.x, fis.CurPos.y, 1, true);
				if (fis.SpeedVec.x < 0)
				{
 					EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffHappy", null, fis.CurPos.x - 35, fis.CurPos.y - 50, true);
				}
				else
				{
					EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffHappy", null, fis.CurPos.x + 35, fis.CurPos.y - 50, true);
				}
				//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffHappy", null, fis.CurPos.x - 100, fis.CurPos.y - 50, true);
				fis.GuiFishStatus.Hide();
			}
		}
		//hiepnm2
		public function InviteFriend():void
		{
			//hiển thị feed mời bạn
			GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_INVITE_FRIEND);
		}
		public function RebornSpartan(fs:FishSpartan ,idMedicine:int):void
		{			
			var scaleX:Number = fs.img.scaleX;
			var scaleY:Number = fs.img.scaleY;
			fs.Clear();
			var index:int = user.getFishSpartanDeactiveIndex(fs.Id);
			user.FishArrSpartanDeactive.splice(index, 1);
			GuiMgr.getInstance().GuiStore.UpdateStore("RebornMedicine", idMedicine, -1);
			//chặn ngay cái số lượng < 1
			if (user.GetStoreItemCount("RebornMedicine", idMedicine) == 0)
			{
				BackToIdleGameState();
			}
			
			//Effect phá băng chui ra :D hehe		
			var sp:SpriteExt = new SpriteExt();
			var arr:Array;
			var swfEf:SwfEffect;
			sp.loadComp = function f():void
			{
				arr = [];
				sp.img.x = 100;
				sp.img.y = 100;
				arr.push(sp.img);
				swfEf = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffBangVo", arr, fs.CurPos.x - 52, fs.CurPos.y - 51, false, false, null, finishBreakIce);									
				trace(swfEf.img.scaleX);
				
				swfEf.img.scaleX = scaleX;
				swfEf.img.scaleY = scaleY;
			}
			sp.loadRes(fs.ImgName.split("1")[0]);			
			
			function finishBreakIce():void
			{
				var timeReborn:Number = Number(ConfigJSON.getInstance().getItemInfo("RebornMedicine", idMedicine)["RebornTime"])/86400;
				fs.isExpired = true;
				fs.bCollisionBottom = false;		//chua cham day
				fs.numReborn++;
				fs.ExpiredTime = timeReborn;
				fs.StartTime = CurServerTime;
				fs.Dragable = true;
				user.FishArrSpartan.push(fs);				
				fs.LoadRes(fs.NameItem);
				UpdateFish();
				fs.RefreshImg();
				//user.UpdateOptionLakeObject(-1, fs.RateOption, -1, user.CurLake.Id);
			}
			//xác định lại buff của hồ
			//user.UpdateOptionLakeSparta(1, fs);
			user.UpdateOptionLakeObject(1, fs.RateOption, user.CurLake.Id);
			//cập nhật lại thời gian trưởng thành của cá trong hồ
			//user.UpdateHavestTime();
			//send dữ liệu lên server
			var cmd:SendRebornXFish = new SendRebornXFish(fs.NameItem, idMedicine, fs.Id, fs.LakeId);
			Exchange.GetInstance().Send(cmd);
		}
		
		
		//public function OpenMagicBag(idMagicBag:int,beginPos:Point):void
		public function OpenMagicBag(idMagicBag:int):void
		{
			//hiển thị effect
			
			//trừ 1 túi với id trên trong gui store
			//GuiMgr.getInstance().GuiStore.UpdateStore("MagicBag", idMagicBag, -1);
			//gửi dữ liệu lên server
			//Cho effect Partical bay ra
			//StartParFromMagicBag(beginPos);
			var cmd:SendOpenMagicBag = new SendOpenMagicBag(idMagicBag);
			Exchange.GetInstance().Send(cmd);
			
		}
		//public function ReceiveFromMagicBag(IdGift:int):void
		//{
			//var curId:int = GuiMgr.getInstance().GuiStore.curId;
			//lấy đồ đó ra
			//var Thing:Object = ConfigJSON.getInstance().GetGiftMagicBag(curId,IdGift);
			//effect Nhận thành công
			//EffectMgr.setEffBounceDown("Nhận thành công", 
										//Thing["ItemType"] + Thing["ItemId"], 
										//Constant.STAGE_WIDTH / 2 - 40, 
										//Constant.STAGE_HEIGHT - 100);
			//Effect mở túi càn khôn :D hehe		
			//var sp:SpriteExt = new SpriteExt();
			//sp.loadComp = function f():void
			//{
				//var arr:Array = [];
				//sp.img.x = 100;
				//sp.img.y = 100;
				//arr.push(sp.img);
				//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffOpenMagicBag", arr,
														//Constant.STAGE_WIDTH/2 + 260, 
														//Constant.STAGE_HEIGHT / 2 + 90, 
														//false, false, null, finishOpenMagicBag);					
			//}
			//sp.loadRes(Thing["ItemType"] + Thing["ItemId"]);
			//if (Thing["ItemType"] == "EnergyItem" || Thing["ItemType"] == "RebornMedicine")
			//{
				//var x:Number = sp.img.x;
				//var y:Number = sp.img.y;
				//var w:Number = sp.img.width;
				//var h:Number = sp.img.height;
				//sp.img.x = x-w/2;
				//sp.img.y = y-h/2;
			//}
			//function finishOpenMagicBag():void
			//{
				//update vào kho
				//user.UpdateStockThing(Thing["ItemType"], Thing["ItemId"], 1);
				//
				//GuiMgr.getInstance().GuiStore.isProcessedMagicBag = true;
				//GuiMgr.getInstance().GuiStore.idGiftMagicBag = 0;
				//gameState = GameState.GAMESTATE_IDLE;
				//
				//if (SuggestFeedOpenMagicBag(curId, IdGift))
				//{
					//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_OPEN_MAGIC_BAG_LUCKY);
				//}
				//GuiMgr.getInstance().GuiStore.addAllEvent();
				//GuiMgr.getInstance().GuiStore.UpdateStore(Thing["ItemType"], Thing["ItemId"], 1);
				//
			//}
		//}
		//private function SuggestFeedOpenMagicBag(idMagicBag:int, idGift:int):Boolean
		//{
			//switch(idGift)
			//{
				//case 3:
					//if (idMagicBag == 1 || idMagicBag == 20 || idMagicBag == 40)
						//return true;
				//case 4:
					//if (idMagicBag == 2 || idMagicBag == 21 || idMagicBag == 41)
						//return true;
				//case 5:
					//if (idMagicBag == 3 || idMagicBag == 22 || idMagicBag == 42)
						//return true;
					//
				//default:
					//return false;
			//}
			//return false;
		//}
		
		//public function StartParFromMagicBag(idGift:int,pos:Point):void
		//{
			//tính vị trí bắt đầu partical nhờ vào vị trí click chuột
			//
			//vị trí kết thúc partical
			//var med:Point;
			//var time:Number = 1;
			//var des:Point = new Point(Constant.STAGE_WIDTH / 2 - 26, Constant.STAGE_HEIGHT / 2 - 47);
			//var emit:CometEmit = new CometEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));		
			//var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;
			//sao.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 204, 102, 0);			
			//emit.imgList.push(sao);
			//emitStar.push(emit);
			//med = getThroughPoint(pos, des);
			//var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.TopLayer);
			//if (emit)
			//{
				//layer.stage.addChild(emit.sp);
				//emit.sp.x = pos.x;
				//emit.sp.y = pos.y;
				//TweenMax.to(emit.sp , time, { bezierThrough:[ { x:med.x, y:med.y }, { x:des.x, y:des.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween } );					
			//}
			//
			//function onCompleteTween():void
			//{
				//if (emit)
				//{
					//emit.stopSpawn();
				//}
				//layer.stage.removeChild(emit.sp);		
				//ReceiveFromMagicBag(idGift);
			//}
		//}
		
		//private function getThroughPoint(psrc:Point, pdes:Point):Point
		//{
			//var p:Point = pdes.subtract(psrc);//Vector từ nguồn đến đích
			//if (p.y == 0)
				//return new Point(p.x/2, 0);
			//var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2);//Trung điểm của nguồn và đích
			//var v:Point = new Point( -p.y, p.x);//Vector vuông góc với vector(nguồn, đích)
	//
			//Random hướng vuông góc
			//var n:int = Math.round(Math.random()) * 2 - 1;
			//v.x = n*v.x;
			//v.y = n*v.y;
			//var l:Number = Math.min(120, v.length / 3);
			//v.normalize(l);//Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			//var result:Point = med.add(v);//Tính ra điểm cần đi xuyên qua
			//return result;			
		//}
		
		//private function updateParticle():void
		//{
			//Update particle
			//for (var i:int; i < emitStar.length; i++)
			//{
				//emitStar[i].updateEmitter();
				//if (!emitStar[i].allowSpawn && emitStar[i].particleList.length < 1)
				//{
					//emitStar[i].destroy();
					//emitStar.splice(i, 1);
					//i--;					
				//}
			//}
		//}
		
		public function isEventND():Boolean
		{
			var event:Object = ConfigJSON.getInstance().GetItemList("Event");
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			//trace(event["IconND"]["BeginTime"] , curTime , event["IconND"]["ExpireTime"] );
			if (event["IconND"] == null)
			{
				return false;
			}
			else
			{
				if (event["IconND"]["BeginTime"] > curTime || event["IconND"]["ExpireTime"] - 60 < curTime)
				{
					return false;
				}
			}
			return true;
		}
		
		private function dropBonusEventND(oldData:Object, newData:Object):void
		{
			if (GameLogic.getInstance().isEventND())
			{
				//var config:Object = ConfigJSON.getInstance().GetItemInfo("IconND");
				var fishArr:Array = user.GetFishArr();
				var pos:Point = new Point (500, 200);
				var FishList:Array;
				var index:int;
				for (var i:int = 0; i < newData.length; i++) 
				{
					switch(oldData.GetID())
					{
						case Constant.CMD_FEED_FISH:
							FishList = oldData.FishList;
							index = Math.random() * FishList.length;
							for (var j:int = 0; j < fishArr.length ; j++ )
							{
								var fish:Fish = fishArr[j] as Fish;
								if (fish.Id == FishList[index]["Id"])
								{						
									pos = new Point(fish.CurPos.x, fish.CurPos.y);
									break;
								}						
							}
							break;
						case Constant.CMD_CARE_FISH:
							FishList = oldData.FishList;
							index = Math.random() * FishList.length;
							for (var h:int = 0; h < fishArr.length ; h++ )
							{
								var fis:Fish = fishArr[h] as Fish;
								if (fis.Id == FishList[index])
								{						
									pos = new Point(fis.CurPos.x, fis.CurPos.y);
									break;
								}						
							}
							break;
						case Constant.CMD_CLEAN_LAKE:
							pos = oldData.GetPos();
							break;
					}
					DropActionGift(newData[i], pos.x, pos.y);
				}
			}
		}
		
		public function callDragon(idWish:int):void
		{
			Exchange.GetInstance().Send(new SendMakeWish(idWish));
		}
		
		public function hide7Ball():void
		{
			if (user.StockThingsArr["DragonBall"][0]["Num"] >= 7)
			{
				for (var i:int = 0; i < 7; i++)
				{
					if (arrDragonBall[i] != null && arrDragonBall[i].img != null)
					{
						FallingObject(arrDragonBall[i]).movingState = FallingObject.DISAPPEAR;
						
					}
				}
				user.StockThingsArr["DragonBall"][0]["Num"] -= 7;
				arrDragonBall.splice(0, 7);
			}
		}
		
		/**
		 * Kiểm tra xem item collecction vừa nhận được có hoàn thành bộ sưu tập nào không
		 * @param	itemId là id của item collection
		 */
		public function checkCompleteCollection(itemId:int):void
		{
			//Đóng chức năng này
			return;
			
			var itemCollection:Object = GameLogic.getInstance().user.StockThingsArr["ItemCollection"];
			var data:Object = new Object();
			for each(var obj:Object in itemCollection)
			{
				data[obj["Id"]] = obj["Num"];
			}
			
			var rewardId:int = 0;
			var rewardType:String;
			var rewardNum:int = 0;
			var rewardTab:String;
			var config:Object = ConfigJSON.getInstance().getItemInfo("ItemCollectionExchange", -1);
			var priority:Object = 
			{
				Money:1, Exp:2, ItemTrunk:3
			};
			
			for (var h:String in config)
			{
				for (var s:String in config[h])
				{
					if (s != "Id" && s != "Name" && s != "type")
					{
						//Kiểm tra các collection chứa itemId
						var test:Boolean = false;
						for each(var o:Object in config[h][s]["NecessaryItem"])
						{
							if (o["ItemId"] == itemId)
							{
								test = true;
								break;
							}
						}
						
						//Kiểm tra bộ sưu tập thõa mãn không
						if (test)
						{
							var check:Boolean = true;
							for (var t:String in config[h][s]["NecessaryItem"])
							{
								//trace("check", config[h][s]["NecessaryItem"][t]["Num"], data[config[h][s]["NecessaryItem"][t]["ItemId"]]);
								if (data[config[h][s]["NecessaryItem"][t]["ItemId"]] == null || config[h][s]["NecessaryItem"][t]["Num"] > data[config[h][s]["NecessaryItem"][t]["ItemId"]])
								{
									check = false;
									break;
								}
							}
							
							//Lưu phần thưởng hoàn thành bộ sưu tập giá trị nhất
							if (check && config[h][s]["ItemId"] >= rewardId && (priority[config[h][s]["ItemType"]] >= priority[rewardType] || priority[rewardType] == null))
							{
								rewardId = config[h][s]["ItemId"];
								rewardNum = config[h][s]["Num"];
								rewardType = config[h][s]["ItemType"];
								rewardTab = h;
							}
						}
					}
				}
			}
			
			//trace(rewardTab, rewardType, rewardId, rewardNum);
			//if(rewardTab)
			//trace(completedCollection[rewardTab][rewardType + rewardId]);
			if (rewardTab != null && !completedCollection[rewardTab][rewardType + rewardId])
			{
				/*GuiMgr.getInstance().guiCollection.setFocusData(rewardTab, rewardType, rewardId, rewardNum);
				GuiMgr.getInstance().guiCollection.Show(Constant.GUI_MIN_LAYER, 10);
				completedCollection[rewardTab][rewardType + rewardId]  = true;*/
				completedCollection[rewardTab][rewardType + rewardId]  = true;
				GuiMgr.getInstance().guiCompleteCollection.showGUI(rewardTab, rewardType, rewardId, rewardNum);
			}
		}
		
		public function checkAnoucementCollection(itemId:int):void
		{
			var config:Object = ConfigJSON.getInstance().getItemInfo("ItemCollectionExchange", -1);
			
			var anoucementTab:String;
			for (var h:String in config)
			{
				for (var s:String in config[h])
				{
					if (s != "Id" && s != "Name" && s != "type")
					{
						//Kiểm tra các collection chứa itemId
						for each(var o:Object in config[h][s]["NecessaryItem"])
						{
							if (o["ItemId"] == itemId)
							{
								anoucementTab = h;
								GuiMgr.getInstance().guiAnoucementCollection.showTab(anoucementTab, itemId);
								return;
							}
						}
					}
				}
			}
		}
		
		//Hiện quà collection khi đổi
		public function showGiftCollection():void 
		{
			if (equipment != null)
			{
				var item:FishEquipment = new FishEquipment();
				item.SetInfo(equipment);
				GameLogic.getInstance().user.UpdateEquipmentToStore(item);
				GameLogic.getInstance().user.GenerateNextID();
				var message:String = Localization.getInstance().getString(item.imageName);
				switch(item.Color)
				{
					case 1:
						message += " thường";
						break;
					case 2:
						message += " đặc biệt";
						break;
					case 3:
						message += " quí hiếm";
						break;
				}
				var level:int = int(item.Rank) % 100;
				message += " cấp " + level;
				//GuiMgr.getInstance().guiCongratulation.showReward(item.imageName + "_Shop", 1, message);
				GuiMgr.getInstance().guiNewCongratulation.showEquipment(item, 1, message);
				
				// Feed
				GuiMgr.getInstance().GuiFeedWall.ShowFeed("FishCollection", GetCollectionTrunkName(item));
			}
			GuiMgr.getInstance().guiCollection.serverRespond = false;
			GuiMgr.getInstance().guiCollection.finishEff = false;
			GuiMgr.getInstance().guiCollection.isGettingGift = false;
		}
		
		public function GetCollectionTrunkName(eq:FishEquipment):String
		{
			var trunkName:String = "";
			switch(eq.Color)
			{
				case 1:
					trunkName = "Thiết Bảo Rương";
					break;
				case 2:
					trunkName = "Ngân Bảo Rương";
					break;
				case 3:
					trunkName = "Hoàng Kim Bảo Rương";
					break;
			}
			switch(eq.Type)
			{
				case "Weapon":
					trunkName += " - Vũ Khí";
					break;
				case "Armor":
					trunkName += " - Áo Giáp";
					break;
				case "Helmet":
					trunkName += " - Mũ Giáp";
					break;
				case "FishWorld":
					trunkName += " - Đồ Trang Sức";
					break;
			}
			return trunkName;
		}
		
		public function dropAllGiftFishWorld():void
		{
			if (bonusFishWorld != null)
			{
				for (var s:String in bonusFishWorld)
				{
					if (bonusFishWorld[s] != null)
					{
						for (var h:String in bonusFishWorld[s])
						{
							dropGiftFishWorld(bonusFishWorld[s][h], 800, 500);
						}
					}
				}
			}
			bonusFishWorld = null;
			if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)
			{
				GuiMgr.getInstance().GuiMainFishWorld.ClearStoreComponent();
				GuiMgr.getInstance().GuiMainFishWorld.InitStore(GuiMgr.getInstance().GuiMainFishWorld.CurrentStore, GuiMgr.getInstance().GuiMainFishWorld.CurrentPage);
			}
		}
		
		/**
		 * cập nhật bảng thành tích của user
		 * @param	objInfo
		 * @param	isMyInfo
		 */
		public function UpdateStatistics(objInfo:Object, isWin:int, isMyInfo:Boolean = true):void
		{
			if (objInfo.FirstTimeAttack == 0)
			{
				objInfo.FirstTimeAttack = GameLogic.getInstance().CurServerTime;
				objInfo.Win = 0;
				objInfo.Lose = 0;
			}
			
			if (!isMyInfo)
			{
				//Tấn công thắng
				if (isWin > 0)
				{
					objInfo.Lose += 1;
				}
				//Tấn công thua
				else
				{
					objInfo.Win += 1;
				}
			}
			else
			{
				//Tấn công thắng
				if (isWin > 0)
				{
					objInfo.Win += 1;
				}
				//Tấn công thua
				else
				{
					objInfo.Lose += 1;
				}
			}
		}
		
		/**
		 * Rơi quà trong thế giới cá
		 */ 
		public function dropGiftFishWorld(obj:Object, x:Number, y:Number):void
		{
			if (obj == null)
			{
				return;
			}
			var mat:FallingObject;
			var j:int;
			var objMoneyExp:Object = new Object();
			objMoneyExp["exp"] = 0;
			objMoneyExp["money"] = 0;
			if (obj["ItemType"])
			{
				switch (obj["ItemType"])
				{
					case "Exp":
						objMoneyExp["exp"] = obj["Num"];
						break;
					case "Money":
						objMoneyExp["money"] = obj["Num"];
						break;
					case "Gem":
						for (j = 0; j < obj["Num"]; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj["ItemType"] + "_" + obj["Element"] + "_" + obj["ItemId"], x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						GuiMgr.getInstance().GuiStore.UpdateStore(obj.ItemType + "$" + obj.Element + "$" + obj.ItemId, obj.Day, obj.Num);
						break;
					case "Draft":
					case "Paper":
					case "GoatSkin":
					case "Blessing":
						for (j = 0; j < obj["Num"]; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj["ItemType"] + "_" + obj["ItemId"], x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						
						// Cập nhật vào kho
						GuiMgr.getInstance().GuiStore.UpdateStore(obj["ItemType"], obj["ItemId"], obj["Num"]);
						break;
					case "EnergyItem":
					case "Material":
					case "EnergyItem":
					case "Visa":
						for (j = 0; j < obj["Num"]; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj["ItemType"] + obj["ItemId"], x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						
						// Cập nhật vào kho
						GuiMgr.getInstance().GuiStore.UpdateStore(obj["ItemType"], obj["ItemId"], obj["Num"]);
						break;
					case "Arrow":
						for (j = 0; j < obj["Num"]; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "GUIGameEventMidle8_" + obj["ItemType"] + obj["ItemId"], x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							mat.setWaitingTime(3);
							if(Ultility.IsInMyFish())
							{
								mat.getDesToFly = function():Point
								{
									var p:Point = GuiMgr.getInstance().guiFrontScreen.getPosBtnEvent();
									return p;
								}
							}
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						GuiMgr.getInstance().GuiStore.UpdateStore(obj["ItemType"], obj["ItemId"], obj["Num"]);
						break;
					case "ItemCollection":
						for (j = 0; j < obj["Num"]; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj["ItemType"] + obj["ItemId"], x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							mat.setWaitingTime(3);
							mat.getDesToFly = function():Point
							{
								var pos:Point = GuiMgr.getInstance().guiAnoucementCollection.getPosById(obj.ItemId);
								return pos;
							}
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						
						//Hiện thông báo hoàn thành bộ sưu tập
						GameLogic.getInstance().checkAnoucementCollection(obj["ItemId"]);
						GuiMgr.getInstance().GuiStore.UpdateStore(obj["ItemType"], obj["ItemId"], obj["Num"]);
						break;
					case "Weapon":
					case "Armor":
					case "Helmelt":
					case "Ring":
					case "Belt":
					case "Bracelet":
					case "Necklace":
					case "Mask":
						for (j = 0; j < obj["Num"]; j++)
						{
							GameLogic.getInstance().user.GenerateNextID();
							
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj["ItemType"] + obj["Rank"] + "_Shop", x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							//Tên đồ
							var txtName:TextField = new TextField();
							txtName.text = Localization.getInstance().getString(obj["ItemType"] + obj["Rank"]);
							var txtFormat:TextFormat = new TextFormat("arial", 15, 0xffffff, true);
							switch(obj["Color"])
							{
								case 1:
									txtFormat.color = 0xffffff;
									break;
								case 2:
									txtFormat.color = 0x00ff00;
									break;
								case 3:
									txtFormat.color = 0xffff00;
									break;
							}
							txtFormat.align = "center";
							
							var outline:GlowFilter = new GlowFilter();
							outline.blurX = outline.blurY = 3.5;
							outline.strength = 8;
							outline.color = 0x000000;
							var arr:Array = [];
							arr.push(outline);
							txtName.antiAliasType = AntiAliasType.ADVANCED;
							txtName.filters = arr;
							
							txtName.setTextFormat(txtFormat);
							txtName.autoSize = "center";
							txtName.x = 0;
							txtName.y = -30;
							mat.img.addChild(txtName);
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						}
						
						break;
					case "Rank":
						var myFish:FishSoldier = user.CurSoldier[0] as FishSoldier;
						myFish.UpdateKillMarkPoint(obj["Num"]);
						var posX:Number = myFish.img.x;
						var posY:Number = myFish.img.y - GameController.getInstance().GetLakeTop();
						if (obj["Num"] > 0)
						{
							var p:Point = new Point(0, -50);
							var txtFormatChienCong:TextFormat = new TextFormat("Arial", 24, 0x06C417, true);
							txtFormatChienCong.align = "center";
							EffectMgr.getInstance().textFly("+" + obj["Num"] + " Chiến công", p, txtFormatChienCong, myFish.aboveContent);
						}
						break;
					case "Event_8_3_Flower":
						for (j = 0; j < obj["Num"]; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj["ItemType"] + obj["ItemId"], x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							mat.getDesToFly = function():Point
							{
								return GuiMgr.getInstance().guiFrontScreen.getPosBtnEvent();
							}
							user.fallingObjArr.push(mat);
						}
					break;
					
					case "IceCreamItem":
						for (j = 0; j < obj["Num"]; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "EventIceCream_Item" + obj["ItemId"], x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							user.fallingObjArr.push(mat);
						}
					break;
					
					case "Island_Item":
						for (j = 0; j < obj["Num"]; j++)
							{
								mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "IslandItem15", x, y);
								mat.ItemType = obj["ItemType"];
								mat.ItemId = obj["ItemId"];
								user.fallingObjArr.push(mat);
							}
						break;
					case "HalItem":
						for (j = 0; j < obj["Num"]; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "EventHalloween_" + obj["ItemType"] + obj["ItemId"], x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							user.fallingObjArr.push(mat);
						}
						HalloweenMgr.getInstance().updateRockStore(obj["ItemId"], obj["Num"]);
						break;
					//case "ColPItem":
					//case "BirthDayItem":
					case "Candy":
					//case "SpaceCraft":
					//case "PaperBurn":
						for (j = 0; j < obj["Num"]; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "EventNoel_" + obj["ItemType"] + obj["ItemId"], x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							user.fallingObjArr.push(mat);
						}
						//GuiMgr.getInstance().guiFrontEvent.updateNumItemEvent(obj["ItemType"], obj["Num"]);
						EventSvc.getInstance().updateItem(obj["ItemType"], obj["ItemId"], obj["Num"]);
					break;
					case "Balls":
						for (j = 0; j < obj["Num"]; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "Ic_" + obj["ItemId"] +"Ball", x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							user.fallingObjArr.push(mat);
						}
						break;
					case "Ticket":
						for (j = 0; j < obj["Num"]; j++)
						{
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "EventLuckyMachine_" + obj["ItemType"] + obj["ItemId"], x, y);
							mat.ItemType = obj["ItemType"];
							mat.ItemId = obj["ItemId"];
							user.fallingObjArr.push(mat);
						}
						EventLuckyMachineMgr.getInstance().updateTicket(obj["Num"]);
						break;
						
				}
			}
			if (obj["Type"])
			{
				switch (obj["Type"])
				{
					case "Weapon":
					case "Armor":
					case "Helmelt":
					case "Ring":
					case "Belt":
					case "Bracelet":
					case "Necklace":
					case "Mask":
							GameLogic.getInstance().user.GenerateNextID();
							
							mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj["Type"] + obj["Rank"] + "_Shop", x, y);
							mat.ItemType = obj["Type"];
							mat.ItemId = obj["Rank"];
							//Tên đồ
							var txtName1:TextField = new TextField();
							txtName1.text = Localization.getInstance().getString(obj["Type"] + obj["Rank"]);
							var txtFormat1:TextFormat = new TextFormat("arial", 15, 0xffffff, true);
							switch(int(obj["Color"]))
							{
								case 1:
									txtFormat1.color = 0xffffff;
									break;
								case 2:
									txtFormat1.color = 0x00ff00;
									break;
								case 3:
									txtFormat1.color = 0xffff00;
									break;
								case 4:
									txtFormat1.color = 0x9900ff;
									break;
							}
							txtFormat1.align = "center";
							
							var outline1:GlowFilter = new GlowFilter();
							outline1.blurX = outline1.blurY = 3.5;
							outline1.strength = 8;
							outline1.color = 0x000000;
							var arr1:Array = [];
							arr1.push(outline1);
							txtName1.antiAliasType = AntiAliasType.ADVANCED;
							txtName1.filters = arr1;
							
							txtName1.setTextFormat(txtFormat1);
							txtName1.autoSize = "center";
							txtName1.x = 0;
							txtName1.y = -30;
							mat.img.addChild(txtName1);
							GameLogic.getInstance().user.fallingObjArr.push(mat);
						break;
				}
			}
			EffectMgr.getInstance().fallExpMoneyToNumStar(objMoneyExp["exp"], objMoneyExp["money"], new Point (x, y), 2, 2);
		}
		
		/**
		 * Check boss thảo dược xuất hiện
		 * @param	isInit
		 * @return
		 */
		public function CheckBossHerbVisibility(isInit:Boolean = false):Boolean
		{
			if (BossHerb.CooldownBoss <= 0)
			{
				BossHerb.CooldownBoss = ConfigJSON.getInstance().GetItemList("Event")["MagicPotion"]["TimeAppear"];
			}
			if (!user.GetMyInfo().EventInfo)
			{
				user.GetMyInfo().EventInfo = new Object();
			}
			
			if (!user.GetMyInfo().EventInfo.LastTimeAttackBoss)
			{
				user.GetMyInfo().EventInfo.LastTimeAttackBoss = 0;
			}
			
			var lastAtk:Number = user.GetMyInfo().EventInfo.LastTimeAttackBoss;
			
			//return true;
			var curTime:Number = CurServerTime;
			
			if ((curTime - lastAtk - BossHerb.CooldownBoss - Constant.TIME_DELAY) > 0)
			{
				return true;
			}
			else
			{
				return false;
			}
			
			var i:int;
			if (isInit)
			{
				var cfg:Array = ConfigJSON.getInstance().GetItemList("Event").MagicPotion.TimeAppear;
				var curDate:Date = new Date(curTime * 1000);	// UTC
				
				var curZoneHour:int = curDate.getUTCHours() + Constant.TIME_ZONE_SERVER;
				var curZoneMin:int = curDate.getUTCMinutes();
				if (curZoneHour >= 24)
				{
					curZoneHour -= 24;
				}
				
				var curZoneZero:Number = curTime - curZoneHour * 60 * 60 - curZoneMin * 60;		// timestamp ma o VN la bat dau ngay hien tai (0h)
				
				TimeAppearArr.splice(0, TimeAppearArr.length);
				for (i = 0; i < cfg.length; i++)
				{
					var timeApp:Number = curZoneZero + cfg[i] * 60 * 60;
					TimeAppearArr.push(timeApp);
				}
			}
			
			for (i = 0; i < TimeAppearArr.length; i++)
			{
				if (curTime > TimeAppearArr[i] && curTime < (TimeAppearArr[i] + BossHerb.TIME_LIVE) && lastAtk < TimeAppearArr[i])
				{
					return true;
				}
			}
			
			return false;
		}
		
		private function updateShocksNoel():void
		{
			if (!EventUtils.checkInShocksNoel())
			{
				if (!user.IsViewer())
				{
					if (user.GetMyInfo().shocksNoel)
					{
						user.GetMyInfo().shocksNoel.Destructor();
						user.GetMyInfo().shocksNoel = null;
					}
				}
				if (GuiMgr.getInstance().guiGiftOnline.img)//pop up tất noel đang hiện
				{
					GuiMgr.getInstance().guiGiftOnline.Hide();
				}
			}
		}
		private function updateEvent83():void
		{
			if (EventMgr.CheckEvent(EventMgr.NAME_EVENT) != EventMgr.CURRENT_IN_EVENT)
			{
				if (user.IsViewer())
				{
					if (user.coralTree)
					{
						if (user.coralTree.guiTipTree.img)
						{
							if (user.coralTree.guiTipTree.img.visible)
							{
								user.coralTree.guiTipTree.Hide();//cho biến mất cái tooltip
							}
						}
						user.coralTree.img.visible = false;
						user.coralTree = null;
					}
				}
				else
				{
					if (user.GetMyInfo().coralTree)
					{
						if (user.GetMyInfo().coralTree.guiTipTree.img)
						{
							if (user.GetMyInfo().coralTree.guiTipTree.img.visible)
							{
								user.GetMyInfo().coralTree.guiTipTree.Hide();//cho biến mất cái tooltip
							}
						}
						if (user.GetMyInfo().coralTree.guiSeekTime.img)
						{
							if (user.GetMyInfo().coralTree.guiSeekTime.img.visible)
							{
								user.GetMyInfo().coralTree.guiSeekTime.Hide();//cho biến mất cái tooltip
							}
						}
						user.GetMyInfo().coralTree.img.visible = false;
						user.GetMyInfo().coralTree = null;
					}
				}
				if (GuiMgr.getInstance().GuiChangeFlower.img)//nếu hết event và cái bảng đang hiện lên
				{
					for (var i:int = 0; i < 3; i++)
					{
						var tooltipFlower:TooltipFlower = GuiMgr.getInstance().GuiChangeFlower.guiTipArr[i] as TooltipFlower;
						if (tooltipFlower)
						{
							if (tooltipFlower.img)
							{
								if (tooltipFlower.img.visible)
								{
									tooltipFlower.Hide();
								}
							}
						}
						
					}
					var guiGuide:GUIFlowerGuide = GuiMgr.getInstance().GuiChangeFlower.guiGuide;
					if (guiGuide)
					{
						if (guiGuide.img)
						{
							
							if (guiGuide.img.visible)
							{
								guiGuide.Hide();
							}
						}
					}
					
					GuiMgr.getInstance().GuiChangeFlower.Hide();
					
				}
			}
			else//trong event thì update cái helper trỏ vào đầu
			{
				if (!user.IsViewer()&&user.GetMyInfo().coralTree)
				{
					var hasHelper:Boolean = user.GetMyInfo().coralTree.hasHelper;
					var isShowGuiSeekTime:Boolean;
					if (user.GetMyInfo().coralTree.guiSeekTime.img)
					{
						isShowGuiSeekTime = user.GetMyInfo().coralTree.guiSeekTime.img.visible;
					}
					else
					{
						isShowGuiSeekTime = false;
					}
					if (user.GetMyInfo().coralTree.canCare())
					{
						//nếu guiseektime xuất hiện thì hide guiseektime
						if (isShowGuiSeekTime)
						{
							user.GetMyInfo().coralTree.guiSeekTime.Hide();
						}
						if (!hasHelper)
							user.GetMyInfo().coralTree.addHelper();
					}
					else
					{
						user.GetMyInfo().coralTree.removeHelper();
					}
				}
			}
		}
		public function isMonday():Boolean
		{
			var date:Date = new Date(CurServerTime * 1000);
			var obj:Object = ConfigJSON.getInstance().getItemInfo("HappyWeekDay");
			var result:Boolean = false;
			for (var i:String in obj) {
				if (date.day == int(i))
				{
					result = true;
					break;
				}
			}
			return result;
		}
		
		public function updateLogicBossServer():void 
		{
			if (gameState == GameState.GAMESTATE_INIT)
			{
				return;
			}
			//Update time
			UpdateTime();
			// update effect
			EffectMgr.getInstance().UpdateAllEffect();
			ActiveTooltip.getInstance().update();
			
			for (var i:int = 0; i < arrSoldier.length; i++ )
			{
				var soldier:Soldier = arrSoldier[i] as Soldier;
				soldier.UpdateObject();
			}
			
			if(GuiMgr.getInstance().guiMainBossServer.IsVisible)
			{
				GuiMgr.getInstance().guiMainBossServer.UpdateObject();
			}
		}
		/**
		 * Hàm thực hiện cập nhật lại tham số cần khi ta lấy dữ liệu từ server về cho vòng 2 của thế giới mộc
		 * Các dữ liệu cần gồm có hiệu ứng khi đánh nhau 
		 * và dữ liệu con quái can sinh ra
		 */
		public function UpdateDataRound2Forest():void 
		{
			if (GuiMgr.getInstance().GuiEffRandomSeaRightGreen.IsVisible)	GuiMgr.getInstance().GuiEffRandomSeaRightGreen.Hide();
			var obj1:Object = GuiMgr.getInstance().GuiMapOcean.arrListOcean[3];
			if(datReceiveForest != null && datReceiveForest.currentBoss)
			{
				obj1.currentMonster = datReceiveForest.currentBoss;
				// Cập nhật dữ liệu vào 
				GuiMgr.getInstance().GuiMainForest.objEffYellowRight = datReceiveForest.Sequence;
				GuiMgr.getInstance().GuiMainForest.MonsterRightGreenData = datReceiveForest.currentBoss;
				// Cập nhật vào hiển thị
				GuiMgr.getInstance().GuiFogInForestWold.InitMonsterSeaRightGreen(false);
				GuiMgr.getInstance().GuiMainForest.SetEmotionIdleAll(false);
				var objt:Object = GuiMgr.getInstance().GuiMapOcean.arrListOcean[3].Monster[FishWorldController.GetRound().toString()];
				GuiMgr.getInstance().GuiBackMainForest.UpdatePosRound2(objt);
			}
			else
			{
				GuiMgr.getInstance().GuiMainForest.MonsterRightGreenData = null;
				GuiMgr.getInstance().GuiGetPiece.Show(Constant.GUI_MIN_LAYER, 1);
			}
		}
		
		public function Round3ComeBackForestSea():void 
		{
			GuiMgr.getInstance().GuiBackMainForest.DoBackForestWorld();
		}
		
		public function Round2ComeBackForestSea():void 
		{
			var obj1:Object = GuiMgr.getInstance().GuiMapOcean.arrListOcean[3];
			GuiMgr.getInstance().GuiMainForest.objEffYellowRight = null;
			GuiMgr.getInstance().GuiMainForest.MonsterRightGreenData = null;
			obj1.currentMonster = null;
			// tro ve map ban do chinh cua the gioi Moc
			GuiMgr.getInstance().GuiBackMainForest.DoBackForestWorld();
		}
		
		public function Round1ComeBackForestSea():void 
		{
			GuiMgr.getInstance().GuiBackMainForest.DoBackForestWorld();
			GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = true;
		}
		
		/**
		 * Hàm check qua ngày hay chưa khi client đang bật
		 * Khi qua ngày, ai thích xử lý gì thì push vào
		 */
		private function endOfDay():void
		{
			if (date.getTime() > 0)
			{
				var curDay:int = date.getUTCDate();
				date.setTime((CurServerTime - date.getTimezoneOffset() * 60) * 1000);
				if (date.getUTCDate() - curDay <= 0)
				{
					return;
				}
				
				// client nhận ra ngày vừa kết thúc, xử lý những thứ cần thiết
				updateReputation();	
			}
			else
			{
				date.setTime((CurServerTime - date.getTimezoneOffset() * 60) * 1000);
			}
		}
		
		private function updateReputation():void 
		{
			if(user.getReputationLevel() > 0)
			{
				if (GuiMgr.getInstance().guiReputation.IsVisible)
				{
					GuiMgr.getInstance().guiReputation.Hide();
				}
				var fameConf:Object = ConfigJSON.getInstance().getItemInfo("ReputationInfo");
				var fameLevel:int = user.getReputationLevel();
				var famePoint:int = user.getReputationPoint();
				famePoint -= fameConf[fameLevel]["SubtractPoint"];
				if (famePoint < 0)
				{
					if (fameConf[fameLevel - 1] != null)
					{
						famePoint = fameConf[fameLevel - 1]["RequirePoint"] + famePoint;
						fameLevel--;
					}
					else
					{
						famePoint = 0;
					}
				}
				
				user.updateReputationLevel(fameLevel);
				user.updateReputationPoint(famePoint);
				GameLogic.getInstance().user.resetReputationQuest();
				var fishSoldier:FishSoldier;					
				var arrSoldier:Array = GameLogic.getInstance().user.GetFishSoldierArr();
				for (var i:int = 0; i < arrSoldier.length; i++)
				{
					fishSoldier = arrSoldier[i];
					fishSoldier.updateReputation();
				}
			}
		}
		
		public function processReputation(cmd:String, data:Object, oldData:Object):void 
		{
			var fameLevel:int = GameLogic.getInstance().user.GetMyInfo().ReputationLevel;
			var fameConf:Object = ConfigJSON.getInstance().getItemInfo("ReputationInfo");
			var questList:Object = GameLogic.getInstance().user.GetMyInfo().ReputationQuest;
			var quest:Object;
			var i:int;
			var st:String;
			
			var isChangeNum:Boolean = false;
			switch(cmd)
			{
				case Constant.CMD_SEND_GET_REPUTATION:	
					GameLogic.getInstance().user.updateReputationLevel(data["Level"]);
					GameLogic.getInstance().user.updateReputationPoint(data["Point"]);
					GameLogic.getInstance().user.GetMyInfo().ReputationQuest = data["Quest"];
					isChangeNum = true;
					break;
				case Constant.CMD_SEND_GIFT:	// tặng quà bạn bè
					for (st in questList)
					{
						quest = questList[st];
						if (quest["Action"] == "sendGift")
						{
							quest["Num"] ++;
							isChangeNum = true;
						}
					}
					break;
				case Constant.CMD_GET_DAILY_BONUS:	// nhận quà tặng hàng ngày
					for (st in questList)
					{
						quest = questList[st];
						if (quest["Action"] == "getGiftDay")
						{
							quest["Num"]++;
							isChangeNum = true;
						}
					}
					break;				
				case Constant.CMD_SEND_SEPARATE_EQUIP:	// tách trang bị
					for (st in questList)
					{
						quest = questList[st];
						if (quest["Action"] == "refineIngredient")
						{
							quest["Num"] ++;
							isChangeNum = true;
						}
					}
					break;
				case Constant.CMD_GET_GEM:			// luyện đan
					for (st in questList)
					{
						quest = questList[st];
						if (quest["Action"] == "getGem")
						{
							if(data["GemId"] == fameConf[fameLevel][st]["OutputParam"][1]["Num"])
							{
								quest["Num"]++;
								isChangeNum = true;
							}
						}
					}
					break;
				case Constant.CMD_ENCHANT_EQUIPMENT:	// cường hóa trang bị
					for (st in questList)
					{
						quest = questList[st];
						if (quest["Action"] == "enchantEquipment")
						{
							if(data["EnchantLevel"] == fameConf[fameLevel][st]["OutputParam"][1]["Num"])
							{
								quest["Num"]++;
								isChangeNum = true;
							}
						}
					}
					break;
				case Constant.CMD_ATTACK_OCEAN_SEA:		// tấn công thế giới cá
					for (st in questList)
					{
						quest = questList[st];
						if (quest["Action"] == "acttackMonster")
						{
							if(data["RoundId"] == fameConf[fameLevel][st]["OutputParam"][2]["Num"])
							{
								quest["Num"]++;
								isChangeNum = true;
							}
						}
					}
					break;
				case Constant.CMD_ATTACK_BOSS_OCEAN_SEA:	// tấn công boss Tua Rua
					for (st in questList)
					{
						quest = questList[st];
						if (quest["Action"] == "acttackBoss")
						{
							if(data["isWin"] > 0)
							{
								quest["Num"]++;
								isChangeNum = true;
							}
						}
					}
					break;
				case Constant.CMD_COMPLETE_DAILY_QUEST_NEW:	// hoàn thành nhiệm vụ hàng ngày
					for (st in questList)
					{
						quest = questList[st];
						if (quest["Action"] == "completeDailyQuest")
						{
							if(data["QuestId"] == fameConf[fameLevel][st]["OutputParam"][1]["Num"])
							{
								quest["Num"]++;
								isChangeNum = true;
							}
						}
					}
					break;
				case Constant.CMD_ATTACK_IN_LEAGUE:			// chiến thắng liên đấu
					for (st in questList)
					{
						quest = questList[st];
						if (quest["Action"] == "occupy")
						{
							if(data["IsWin"] == 1)
							{
								quest["Num"]++;
								isChangeNum = true;
							}
						}
					}
					break;
				case Constant.CMD_GET_GIFT_TRAINING:			// Tu luyện ngư thủ
					for (st in questList)
					{
						quest = questList[st];
						if (quest["Action"] == "getGiftTraining")
						{
							if(data["IntensityType"] == fameConf[fameLevel][st]["OutputParam"][1]["Num"])
							{
								quest["Num"]++;
								isChangeNum = true;
							}
						}
					}
					break;
				case Constant.CMD_RESET_DAILYQUEST:			// nhận daily quest lần 2
					for (st in questList)
					{
						quest = questList[st];
						if (quest["Action"] == "payToResetDailyQuest")
						{
							if(data["Error"] == 0)
							{
								quest["Num"]++;
								isChangeNum = true;
							}
						}
					}
					break;
				case Constant.CMD_ATTACK_FRIEND_LAKE:		// tấn công ngư thủ nhà bạn					
					break;
				case Constant.CMD_FISHING:					// câu cá nhà bạn
					break;
				case Constant.CMD_GET_GIFT_TRAINING:		// Tu luyện ngư thủ
					break;
				case Constant.CMD_INIT_RUN:
				case Constant.CMD_SEND_QUICK_REPUTATION:
					isChangeNum = true;
					break;
			}
			
			if (isChangeNum == true)
			{
				for (st in questList)
				{
					quest = questList[st];
					if(quest["Num"] >= fameConf[fameLevel][st]["Num"] && !quest["isGetGift"])
					{
						GuiMgr.getInstance().guiFrontScreen.btnReputation.SetBlink(true);
						return;
					}
				}
				GuiMgr.getInstance().guiFrontScreen.btnReputation.SetBlink(false);
			}
		}
		
	}
}