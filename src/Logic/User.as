package Logic 
{
	import adobe.utils.CustomActions;
	import com.bit101.components.NumericStepper;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Data.QuestINI;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectBlink;
	import Effect.ImgEffectBuble;
	import Effect.ImgEffectFly;
	import Effect.Rippler;
	import Event.EventIceCream.MachineMakeCream;
	import Event.EventMgr;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.text.TextFormat;
	import flash.utils.Proxy;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.component.Button;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.component.ButtonEx;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import GUI.Event8March.CoralTree;
	import GUI.Event8March.GiftBoxAfter;
	import GUI.EventBirthDay.EventGUI.BirthdayCandle;
	import GUI.EventMagicPotions.BossHerb;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWorld.Boss;
	import GUI.FishWorld.BossIce;
	import GUI.FishWorld.BossMetal;
	import GUI.FishWorld.BossMgr;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.SubBossIce;
	import GUI.FishWorld.SubBossMetal;
	import GUI.GUIFriends;
	import GUI.GUIFrontScreen.GUIFrontScreen;
	import GUI.GUIFrontScreen.GUIUserInfo;
	import GUI.GUIGemRefine.unused.PearlMgr;
	import GUI.GuiMgr;
	import GUI.FishWar.GUIStoreSoldier;
	import GUI.GUISecretFishInfo;
	import GUI.GUITopInfo;
	import Logic.EventNationalCelebration.FireworkFish;
	import NetworkPacket.PacketReceive.GetLoadInventory;
	import NetworkPacket.PacketSend.SendFirstTimeLogin;
	import NetworkPacket.PacketSend.SendGetBuffLake;
	import NetworkPacket.PacketSend.SendMoveDecorate;
	import NetworkPacket.PacketSend.SendRefreshFriend;
	import NetworkPacket.PacketSend.SendUpdateExpiredSoldier;
	import NetworkPacket.PacketSend.SendUpdateSparta;
	/**
	 * ...
	 * @author ducnh
	 */
	
	//tuan: 11357326;
	//minh :2165568;
	//duc : 487855;
	//hien : 7096152;
	//anh  : 358245
	//thai anh  : 487853 ;
	//long: 20800579
   
	public class User
	{	
		// thong tin lay tu database ve
		private var AutoId:int;
		public var AvatarPic:String;
		public var AvatarType:int;
		private var Energy:Number;
		private var Exp:int;
		private var FoodCount:int;
		public var Id:int;
		public var LakeNumb:int;
		public var LastEnergyTime:Number;
		public var LastGiftTime:int;
		public var LastLuckyTime:int;
		private var Money:Number = 0;
		public var Name:String;
		public var ZMoney:int;
		public var Ticket:int;
		//public var MixLakeCount:int;
		//public var lastEnergyTime:Number;
		public var Level:int;
		public var NewMail:Boolean;
		public var NewGift:Boolean;
		public var NumReceiver:int;
		public var LastGetGiftDay:Number;
		public var LastPictureTime:Number;
		public var NewDailyQuest:Boolean;
		//public var LevelMixLake:int;
		public var MaxFishLevelUnlock:int;
		public var BetaLevel:int;
		public var BoatType:int;
		public var EnergyBoxTime:int;
		public var Skill:Object;
		public var energyMachine:EnergyMachine;
		public var coralTree:CoralTree;
		public var giftBoxAfter:GiftBoxAfter;			
		public var birthdayCandle1:BirthdayCandle;
		public var birthdayCandle2:BirthdayCandle;
		public var birthdayCandle3:BirthdayCandle;
		public var hasMachine:Boolean = false;
		
				
		//Kiem tra xem da gui level up chua, neu gui roi thi ko duoc gui nua
		public var allowLevelUp: Boolean = true;
		
		// thông tin của nhà mình
		private var MyInfo:MyUserInfo = new MyUserInfo();
		
		// object array
		public var AllFishArr:Array = [];
		public var arrMaterial:Array = [];
		public var FishArr:Array = [];
		// Mảng cá super. 
		// FishArrSpartan : Cá còn có thể buff cho hồ
		// FishArrSpartanDeactive : Cá không thể buff cho hồ
		public var FishArrSpartan:Array = [];
		public var FishArrSpartanDeactive:Array = [];
		// Mảng cá lính
		public var FishSoldierArr:Array = [];			// Cá trong hồ hiện tại
		public var FishSoldierAllArr:Array = [];		// Cá trong toàn bộ nhà user (xài khi chọi)
		public var FishSoldierActorMine:Array = [];			// Cá lính diễn xuất trong hồ (đồng minh)
		public var FishSoldierActorTheirs:Array = [];	// Cá lính diễn xuất trong hồ (không phải đồng minh của mình)
		public var FishSoldierExpired:Array = [];		// Mảng mộ chí
		
		public var bossHerb:BossHerb = null;			// Boss Thảo Mộc
		public var FishSoldierMine:FishSoldier;
		public var FishSoldierTheir:FishSoldier;
		public var CurSoldier:Array = [];
		public var DecoArr:Array = [];
		public var FoodArr:Array = [];
		public var StockThingsArr:GetLoadInventory = new GetLoadInventory("");
		public var DirtyArr:Array = [];
		public var PocketArr:Array = [];
		public var UnlockFish:Object = new Object;
		public var fallingObjArr:Array = [];	
		public var backGround:Decorate = null;
		private var BattleStat:Object;
		
		public var FishWorldHappyArr:Array = [];
		public var arrSadFish:Array = [];
		
		// FishWar
		public var MoneyTotal:int;		// Tổng tiền có thể cướp
		public var MoneyLeft:int;		// Tiền còn lại có thể cướp
		public var MoneyRequire:int;	// Tiền yêu cầu để dc đánh nhau
		public var ElementList:Object = new Object();
		// Rương gỗ, bạc, vàng
		private const GUI_LAKE_BTN_WOOD:String = "20";		
		private const GUI_LAKE_BTN_SILVER:String = "21";		
		private const GUI_LAKE_BTN_GOLD:String = "22";
		
		//Cá đầu đàn
		public var FishKing: Fish = null;
		
		// lake
		public var LakeArr:Array = [];
		public var CurLake:Lake = null;
		
		//mang danh sach ban be
		public var FriendArr: Array = [];
		//Thu
		public var LetterArr:Array = [];
		//Qua
		public var GiftArr: Array = [];
		public var isClickGift: Boolean = false;
		// phan loaid tab trong kho
		private var StoreTabs:Object = ["Other", "OceanTree", "OceanAnimal"];
		public var buffTimeAllLake:Object;
		
		// chai năng lượng
		public var dailyBonus:DailyBonus;
		
		
		//Event treasure2
		// Button rương
		public var TreasureArr:Array = [];
		public var TreasureWood:Treasure = null;
		public var TreasureSilver:Treasure = null;
		public var TreasureGold:Treasure = null;
		// May lam kem
		public var machineMakeIceCream:MachineMakeCream = null;
		// Hòm kho báu
		//public var treasureBox:TreasureBox

		public var bonusMachine:int;
		public var bonusEnergy:int;
		public var FairyDrop:Number;
		// Biến check số lượng loại kinh nghiệm cần xử lý để đồng bộ với server
		public var numWaitProcessExp:int = 0;
		
		// tu luyen ngoc
		public var pearlMgr:PearlMgr = null;
		
		//Event 2-9
		public var arrFireworkFish:Array = [];
		
		public var item:Array = [];
		
		// Túi tân thủ
		public var tuiTanThu:TuiTanThu=null;
		
		public var isFisrtLogin:int = 0;
		
		public var moneyMagnet:MoneyMagnet = null;
		public var ingradient:Object;
		public var craftingSkills:Object;
		public var restGoldBuyPower:int;
		//public var restGBuyPower:int;
		
		public var bossMetal:BossMetal = null;
		public var arrSubBossMetal:Array = [];
		
		public var NumSoldier:int = 0;		// Số ngư thủ của User
		public var bossIce:BossIce = null;
		public var arrBossDataIce:Array = [];
		public var arrSubBossIce:Array = [];
		
		public var Notification:Object;
		
		//Password
		public var passwordState:String = Constant.PW_STATE_UNAVAILABLE;
		public var timeStartCrackingPassword:Number = 0;
		public var remainTimesInput:int = 5;
		public var timeStartBlock:Number = 0;
		//liên đấu
		public var Rank:int;
		
		//BossServer
		public var soldierList:Object;
		public var equipmentList:Object;
		public var meridianList:Object;
		
		// Reputaion
		public var ReputationLevel:int;
		public var ReputationPoint:int;
		public var ReputationQuest:Object = new Object();
		
		public function User()
		{
			InitStoreTab();
		}
		
		
		private function InitStoreTab():void
		{
			StoreTabs = new Object();
			var TabFish:Array = ["Fish", "FishGift"];
			var TabDecorate:Array = ["Other", "OceanAnimal", "OceanTree", "PearFlower", "BackGround"];
			var TabSpecial:Array = ["OpenKeyItem", "HerbPotion", "EnergyItem", "Material", "MixLake", "License", "Medicine", "Key", "Icon", "Viagra", "Petrol", "Draft", "Blessing", "Paper", 
									"GoatSkin", "MagicBag", "RebornMedicine", "IconChristmas", "Sock", /*"ItemCollection",*/ "Visa", "Fish", "FishGift",/* "Ticket",*/ "GiftTicket", 
									"RankPointBottle", "GodCharm", "Herb", /*"HerbMedal",*/ "Event_8_3_Flower", "BirthDayItem", "OccupyToken"];
			var TabMaterial:Array = [];
			var TabBabyFish:Array = ["BabyFish", "Soldier"];
			var TabSoldier:Array = [];
			var TabSuppport:Array = ["RecoverHealthSoldier", "Ginseng", "Samurai", "Resistance", "StoreRank", "BuffRank", "BuffMoney", "BuffExp", "Dice"];
			var TabGem:Array = ["Gem1", "Gem2", "Gem3", "Gem4", "Gem5"];
			var TabSteel:Array = ["Gem1"];
			var TabWood:Array = ["Gem2"];
			var TabEarth:Array = ["Gem3"];
			var TabWater:Array = ["Gem4"];
			var TabFire:Array = ["Gem5"];
			
			StoreTabs["Fish"] = TabFish;
			StoreTabs["Decorate"] = TabDecorate;
			StoreTabs["Special"] = TabSpecial;
			StoreTabs["Material"] = TabMaterial;
			StoreTabs["BabyFish"] = TabBabyFish;
			StoreTabs["Soldier"] = TabSoldier;
			StoreTabs["Support"] = TabSuppport;
			StoreTabs["Gem"] = TabGem;
			StoreTabs["Element_1"] = TabSteel;
			StoreTabs["Element_2"] = TabWood;
			StoreTabs["Element_3"] = TabEarth;
			StoreTabs["Element_4"] = TabWater;
			StoreTabs["Element_5"] = TabFire;
			StoreTabs["Helmet"] = ["Helmet"];
			StoreTabs["Armor"] = ["Armor"];
			StoreTabs["Weapon"] = ["Weapon"];
			StoreTabs["Bracelet"] = ["Bracelet"];
			StoreTabs["Ring"] = ["Ring"];
			StoreTabs["Necklace"] = ["Necklace"];
			StoreTabs["Belt"] = ["Belt"];
			StoreTabs["Mask"] = ["Mask"];
			StoreTabs["Seal"] = ["Seal"];
			StoreTabs["QWhite"] = ["QWhite"];
			StoreTabs["QGreen"] = ["QGreen"];
			StoreTabs["QYellow"] = ["QYellow"];
			StoreTabs["QPurple"] = ["QPurple"];
			StoreTabs["QVIP"] = ["QVIP"];
		}
		
		public function AddStoreTab(tab:String, type:String):void
		{
			if (tab in StoreTabs)
			{
				StoreTabs[tab].push(type);
			}
		}
		
		public function IsViewer():Boolean
		{
			if (MyInfo.Id == -1)
			{
				return false;
			}
			else if (Id != MyInfo.Id)
			{
				return true;
			}
			
			return false;
		}
		
		public function GenerateNextID(isMine:Boolean = true):int
		{
			AutoId ++;
			//trace("GenerateNextID autoId", AutoId);
			if (isMine)
			{
				MyInfo.AutoId++;
				return MyInfo.AutoId -1;
			}
			return AutoId-1;
		}
		
		public function SetInfo(data:Object):void
		{
			for (var itm:String in data)
			{
				try
				{
					this[itm] = data[itm];
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + itm + " trong class " + this);
				}
			}
			
			if (MyInfo.Id < 0)
			{
				MyInfo.Id = Id;
				
				// Hard code phục vụ event
				//GuiMgr.getInstance().GuiAnnounce.ShowAnnouce();
				
				// send packet loginFirstTime
				var cmdNew:SendFirstTimeLogin = new SendFirstTimeLogin();
				Exchange.GetInstance().Send(cmdNew);
			
			}
			
			if (!IsViewer())
			{			
				MyInfo.SetInfo(data);
				MyInfo.VarMoney = 0;
				//HiepNM2 lấy về SavedSetting chứa thời điểm feed mời bạn khi có id của người chơi
				GUIFriends.AchiveSavedSetting();
			}
			
			// LongPT thiết lập thông số BattleStat
			if (BattleStat.length == 0)
			{
				BattleStat = new Object();
				BattleStat.FirstTimeAttack = 0;
				BattleStat.Win = 0;
				BattleStat.Lose = 0;
				BattleStat.AverageWinRate = 0;
			}
			else if (!BattleStat.Win)
			{
				BattleStat.Win = 0;
			}
			else if (!BattleStat.Lose)
			{
				BattleStat.Lose = 0;
			}
			if (!BattleStat.AverageWinRate)
			{
				BattleStat.AverageWinRate = 0;
			}
		}
		
		public function setInfoForDailyEnergy(data:Object):void
		{
			MyInfo.LastTimeDailyEnergy = data.ActionInfo.LastTimeDailyEnergy;
			MyInfo.MaxGetGift = ConfigJSON.getInstance().GetItemList("Param")["DailyEnergy"]["MaxTimesDailyEnergy"];
			if(Ultility.CheckDate(MyInfo.LastTimeDailyEnergy))
			{
				MyInfo.DailyEnergy = data.ActionInfo.DailyEnergy;
				MyInfo.NumGetGift = getNumElementInObject(MyInfo.DailyEnergy)
			}
			else 
			{
				MyInfo.DailyEnergy = new Object();
				MyInfo.NumGetGift = 0;
			}
		}
		
		public function getNumElementInObject(obj:Object):int
		{
			var count:int = 0;
			for (var i:String in obj)
			{
				count ++;
			}
			return count;
		}
		
		public function setUserProfile(data:Object):void
		{
			//Lấy các thuộc tính trong data
			var ActionInfo:Object = data.ActionInfo;
			var ActiveMessage:Object = data.ActiveMessage;
			var FeedInfo:Object = data.FeedInfo;
			if(ActionInfo["Discount"] != null && ActionInfo["Discount"]["Event_83_Discount"] != null)
			{
				MyInfo.NumBuyDiscount = ActionInfo["Discount"]["Event_83_Discount"];
			}
			else
			{
				MyInfo.NumBuyDiscount = new Object();
			}
			MyInfo.outGameFW = ActionInfo["OutGameFW"];
			MyInfo.TotalTimeOffline = data.TotalTimeOffline;
			//Lưu lại các thuộc tính vào user
			MyInfo.MatLevel = data.MatLevel;
			MyInfo.MatPoint = data.MatPoint;
			MyInfo.NumFill = data.NumFill;
			MyInfo.LastFillEnergy = data.LastFillEnergy;
			MyInfo.Attack = data.Attack;
			
			MyInfo.LastPictureTime = data.LastPictureTime;
			MyInfo.NumTakePictureTime = data.NumTakePicture;
			setInfoForDailyEnergy(data);
			
			LastPictureTime = data.LastPictureTime;
			MyInfo.NewDailyQuest = data.NewDailyQuest;
			NewGift = data.NewGift;
			NewMail = data.NewMail;			
			MyInfo.Avatar = data.Avatar;
			UnlockFish = ActionInfo.UnlockFishList;
			MaxFishLevelUnlock = data.MaxFishLevelUnlock;
			BetaLevel = data.BetaLevel;
			MyInfo.SlotUnlock = data.SlotUnlock;
			MyInfo.event = data.Event;
			MyInfo.MaxEnergyUse = data.MaxEnergyUse;
			MyInfo.BuySuperFishTime = data.ActionInfo.BuySuperFishTime;
			//Khởi tạo danh sách người gửi quà và người nhận quà
			MyInfo.SenderGiftList.splice(0, MyInfo.SenderGiftList.length);
			MyInfo.ReceiverGiftList.splice(0, MyInfo.ReceiverGiftList.length);
			var s:String;	
			MyInfo.ReceiverGiftList = [];
			for (s in ActionInfo.Receivers)
			{
				MyInfo.ReceiverGiftList.push(s);				
			}
			MyInfo.NumReceiver = Constant.MAX_NUM_RECEIVER - MyInfo.ReceiverGiftList.length;
			MyInfo.SenderGiftList = [];
			for (s in ActionInfo.Senders)
			{
				MyInfo.SenderGiftList.push(s);				
			}
			
			for (s in FeedInfo)
			{
				MyInfo.FeedInfo[s] = FeedInfo[s];				
			}
			
			//Check xem có quà tặng hệ thống hay không?
			if (ActionInfo.DayGift.length != 0)
			{
				var giftArr:Array = [];
				for (var i:String in ActionInfo.DayGift) 
				{
					var obj:Object = new Object();
					if (ActionInfo.DayGift[i]["Level"])
					{
						obj["Level"] = ActionInfo.DayGift[i]["Level"];
						obj["Gift"] = [];
						
						// Duyệt 6 quà trong ngày
						for (var k:int = 1; k <= 6; k++)
						{
							if (ActionInfo.DayGift[i][String(k)])
							{
								// Đẩy gift vào mảng quà đã nhận
								obj["Gift"].push(ActionInfo.DayGift[i][String(k)]);
							}
						}
					}

					giftArr.push(obj);
				}
				
				// Tìm ngày đầu tiên chưa nhận quà			
				var day:int = 1;
				for (var j:int = 0; j < giftArr.length; j++)
				{
					if (!giftArr[j]["Gift"] && (day <giftArr.length))
					{
						day++;
					}
					else
					{
						break;
					}
				}
				
				GuiMgr.getInstance().GuiDailyBonus.curDay = new Point(day, giftArr.length);
				GuiMgr.getInstance().GuiDailyBonus.GiftList = giftArr;
				
				//	Event Click
				//GameLogic.getInstance().initEventClick();
				
				// Nếu là lần đầu tiên đăng nhập trong ngày thì tự động show GUI lên
				var so:Object = SharedObject.getLocal("DaySetting");
				
				var myInfo:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
				var uId:String = String(myInfo.Id);
				if (!so.data[uId])
				{
					so.data[uId] = new Object();
				}
				var timeStamp:Number = GameLogic.getInstance().CurServerTime;
				var today:Date = new Date(timeStamp * 1000);
				//var today:Date = new Date();
				if ((!so.data[uId]["Date"] || today.date != so.data[uId]["Date"]) && (!IsViewer()))
				{
					GuiMgr.getInstance().GuiDailyBonus.Init();
					so.data[uId]["Date"] = today.date;
				}
			}

			MyInfo.EnergyBox = []
			for (s in ActionInfo.EnergyBox)
			{
				MyInfo.EnergyBox.push(parseInt(s));				
			}
		}
		
		// nhung code lien quan den LAKE nam day
		public function InitLake():void
		{
			var arr:Array = ConfigJSON.getInstance().getLakeList();
			
			for (var i:int = 0; i < arr.length; i++)
			{
				var lake:Lake;
				if (i < LakeNumb)
				{
					lake = new Lake(arr[i][ConfigJSON.KEY_ID], arr[i]["NumLevel"], true);
				}
				else
				{
					lake = new Lake(arr[i][ConfigJSON.KEY_ID], arr[i]["NumLevel"], false);
				}
				LakeArr.push(lake);
			}
		}
		
		public function GetLake(lakeID:int):Lake
		{
			var i:int;
			for (i = 0; i < LakeArr.length; i++)
			{
				var lake:Lake = LakeArr[i] as Lake;
				if (lake.Id == lakeID)
				{
					return lake;
				}
			}
			return null;
		}
		
		public function CanUserUnlockLake(lakeID:int):Boolean
		{
			if (IsViewer()) return false;
			
			if (lakeID > LakeNumb + 1)
			{
				return false;
			}
			
			var lake:Lake = GetLake(lakeID);
			if (lake != null)
			{
				if (lake.LakeLevels[0]["LevelRequire"] > GetLevel())
				{
					return false;
				}
				
				if (lake.LakeLevels[0]["Money"] > Money)
				{
					return false;
				}
				
				return true;
				
			}
			
			return false;
		}
		
		public function CanUserUpgradeLake(lakeID:int):Boolean
		{
			if (IsViewer()) return false;
			
			if (lakeID > LakeNumb + 1)
			{
				return false;
			}
			
			var lake:Lake = GetLake(lakeID);
			if (lake != null)
			{
				if (lake.Level >= lake.MaxLevel)
				{
					return false;
				}
				if (lake.LakeLevels[lake.Level]["LevelRequire"] > GetLevel())
				{
					return false;
				}
				
				/*
				if (lake.LakeLevels[lake.Level]["gold"] > Money)
				{
					return false;
				}*/
				
				return true;
				
			}
			
			return false;
		}
		// nhung code lien quan den LAKE nam day
		
		public function Reset(isInitRun:Boolean = true):void
		{
			var i:int;
			for (i = 0; i < FishArr.length; i++)
			{
				var fish:Fish = FishArr[i] as Fish;
				fish.Destructor();
			}
			FishArr.splice(0, FishArr.length);
			
			for (i = 0; i < FishArrSpartan.length; i++)
			{
				var fishSparta:FishSpartan = FishArrSpartan[i] as FishSpartan;
				fishSparta.Destructor();
			}
			FishArrSpartan.splice(0, FishArrSpartan.length);

			//if (bossHerb)
			//{
				//bossHerb.Destructor();
				//bossHerb = null;
			//}
			
			var fs:FishSoldier;
			for (i = 0; i < FishSoldierActorMine.length; i++)
			{
				fs = FishSoldierActorMine[i] as FishSoldier;
				fs.Destructor();
			}
			FishSoldierActorMine.splice(0, FishSoldierActorMine.length);
			
			for (i = 0; i < FishSoldierActorTheirs.length; i++)
			{
				fs = FishSoldierActorTheirs[i] as FishSoldier;
				fs.Destructor();
			}
			FishSoldierActorTheirs.splice(0, FishSoldierActorTheirs.length);
			
			for (i = 0; i < CurSoldier.length; i++)
			{
				if(CurSoldier[i])	CurSoldier[i].Destructor();
			}
			CurSoldier.splice(0, CurSoldier.length);
			
			for (i = 0; i < FishSoldierAllArr.length; i++)
			{
				fs = FishSoldierAllArr[i] as FishSoldier;
				fs.Destructor();
			}
			FishSoldierAllArr.splice(0, FishSoldierAllArr.length);
			
			for (i = 0; i < FishSoldierExpired.length; i++)
			{
				fs = FishSoldierExpired[i] as FishSoldier;
				fs.Destructor();
			}
			FishSoldierExpired.splice(0, FishSoldierExpired.length);
			
			
			for (i = 0; i < FishArrSpartanDeactive.length; i++)
			{
				var fishSpartanDeactive:FishSpartan = FishArrSpartanDeactive[i] as FishSpartan;
				fishSpartanDeactive.Destructor();
			}
			FishArrSpartanDeactive.splice(0, FishArrSpartanDeactive.length);
			
			//Xóa cá pháo hoa
			for (i = 0; i < arrFireworkFish.length; i++)
			{
				FireworkFish(arrFireworkFish[i]).Destructor();
			}
			arrFireworkFish.splice(0, arrFireworkFish.length);
			
			for (i = 0; i < DecoArr.length; i++)
			{
				var deco:Decorate = DecoArr[i] as Decorate;
				deco.Destructor();
			}
			DecoArr.splice(0, DecoArr.length);
			
			// xoa thuc an
			for (i = 0; i < FoodArr.length; i++)
			{
				var food:Food = FoodArr[i] as Food;
				food.Destructor();
			}
			FoodArr.splice(0, FoodArr.length);
			
			// xoa mang du lieu ho`
			LakeArr.splice(0, LakeArr.length);
			
			// xoa vet ban
			for (i = 0; i < DirtyArr.length; i++)
			{
				var dirty:Dirty = DirtyArr[i] as Dirty;
				dirty.Destructor();
			}
			DirtyArr.splice(0, DirtyArr.length);
			
			//Xoa nguyen lieu
			for (i = 0; i < fallingObjArr.length; i++)
			{
				var mat:FallingObject = fallingObjArr[i] as FallingObject;
				mat.Destructor();
			}
			fallingObjArr.splice(0, fallingObjArr.length);
			
			// xoa mang fish da mo khoa
			UnlockFish = null;			
			//UnlockFishArr.splice(0, UnlockFishArr.length);
			
			//Xoa ngoc ca event thang 9 sac mau
			var arrDragon:Array = GameLogic.getInstance().arrDragonBall;
			for (i = 0; i < arrDragon.length; i++)
			{
				var ball:FallingObject = arrDragon[i] as FallingObject;
				ball.Destructor();
			}
			arrDragon.splice(0, arrDragon.length);
			// Quangvh
			numWaitProcessExp = 0;
			
			//Cho lên levelup
			allowLevelUp = true;
		}
		
		public function getFishInfo(id:int):Object
		{
			for (var i:int = 0; i < AllFishArr.length; i++)
			{
				var o:Object = AllFishArr[i];
				if (o.Id == id)
				{
					return o;
				}
			}
			return null;
		}
		
		public function getFishSoldierInfo(id:int):Object
		{
			for (var i:int = 0; i < FishSoldierArr.length; i++)
			{
				var o:Object = FishSoldierArr[i];
				if (o.Id == id)
				{
					return o;
				}
			}
			return null;
		}
		
		public function GetFishArr():Array
		{
			return FishArr;
		}
		
		public function GetFishSoldierArr():Array
		{
			return FishSoldierArr;
		}
		
		public function GetDecoArr():Array
		{
			return DecoArr;
		}
		
		public function GetFoodArr():Array
		{
			return FoodArr;
		}
		
		public function GetLakeArray():Array
		{
			return LakeArr;
		}
		
		public function GetDirtyArray():Array
		{
			return DirtyArr;
		}
		
		public function GetFriendArr(): Array
		{
			return FriendArr;
		}	
		
		public function GetFriend(Uid:int):Friend
		{
			for (var i:int = 0; i < FriendArr.length; i++) 
			{
				var friend:Friend = FriendArr[i] as Friend;
				if (friend.ID == Uid)
				{
					return friend;
				}
			}
			
			return null;
		}	
		
		public function GetMyInfo(): MyUserInfo
		{
			return MyInfo;
		}
		
		public function InitFishWorld(data:Array, isCreateBattle:Boolean = false):void 
		{
			switch (GameController.getInstance().typeFishWorld) 
			{
				case Constant.OCEAN_NEUTRALITY:
					InitFishOceanNeutrality(data, isCreateBattle);
				break;
				case Constant.OCEAN_METAL:
					InitFishOceanMetal(data, isCreateBattle);
				break;
				case Constant.OCEAN_ICE:
					InitFishOceanIce(data, isCreateBattle);
				break;
				case Constant.OCEAN_FOREST:
					InitFishOceanForest(data, isCreateBattle);
				break;
			}
		}
		
		private function InitFishOceanForest(dataSolider:Array, isCreateBattle:Boolean = false):void 
		{
			var i:int;
			var posX:int;
			var posY:int;
			var fishArr:Array;
			var mySoldierPos:Array = [];
			var fs:FishSoldier;
			
			// Tính các tọa độ cá nhà mình bơi ra
			mySoldierPos.splice(0, mySoldierPos.length);
			var p7:Point = new Point(Constant.MAX_WIDTH / 2 - 280, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 30);
			mySoldierPos.push(p7);
			var p8:Point = new Point(p7.x, p7.y - 100);
			mySoldierPos.push(p8);
			var p9:Point = new Point(p7.x, p7.y + 100);
			mySoldierPos.push(p9);
			var p10:Point = new Point(p7.x - 80, p7.y);
			mySoldierPos.push(p10);
			var p11:Point = new Point(p7.x - 80, p7.y + 100);
			mySoldierPos.push(p11);
			var p12:Point = new Point(p7.x - 80, p7.y - 100);
			mySoldierPos.push(p12);
			
			GameLogic.getInstance().SetMode(GameMode.GAMEMODE_WORLD_FOREST);
			GuiMgr.getInstance().GuiMainForest.Show(Constant.OBJECT_LAYER);
			
			// Cá lính nhà ta sang xâm chiếm
			var actorList:Array = GameLogic.getInstance().user.FishSoldierActorMine;
			actorList.splice(0, actorList.length);
			//fishArr = FishSoldier.SortFishSoldier(GameLogic.getInstance().user.GetMyInfo().MySoldierArr, true);	// Mảng các con cá trong của nhà mình và còn sức khỏe
			fishArr = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;	// Mảng các con cá trong của nhà mình và còn sức khỏe
			for (i = 0; i < fishArr.length; i ++)
			{
				if (fishArr[i].Status == FishSoldier.STATUS_HEALTHY && !fishArr[i].IsDie)
				{
					fs = fishArr[i] as FishSoldier;
					var name:String = Fish.ItemType + fishArr[i].FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					var f:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), name);
					GameController.getInstance().SetInfo(f, fs, FishSoldier.ACTOR_MINE);
					posX = 70;
					posY = GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / (fishArr.length + 1) * (i + 1);
					
					f.Init(posX, posY);
					f.standbyPos = mySoldierPos[i];
					f.SwimTo(f.standbyPos.x, f.standbyPos.y, 20);
					
					
					if (f.Status == FishSoldier.STATUS_REVIVE)
					{
						f.SetEmotion(FishSoldier.REVIVE);
					}
					else if (f.Health < 2 * f.AttackPoint)
					{
						f.SetEmotion(FishSoldier.WEAK);
					}
					
					f.OnLoadResCompleteFunction = function():void
					{
						this.SwimTo(this.standbyPos.x, this.standbyPos.y, 20);
					}
					
					if (GameLogic.getInstance().user.CurSoldier[0] == null && f.Health >= 2 * f.AttackPoint)
					{
						f.isChoose = true;
						GameLogic.getInstance().user.CurSoldier[0] = f;
					}
					actorList.push(f);
				}
			}
			
		}
		
		private function InitFishOceanIce(dataSolider:Array, isCreateBattle:Boolean = false):void 
		{
			FishSoldierArr.splice(0, FishSoldierArr.length);
			var objAllSea:Object = ConfigJSON.getInstance().GetItemList("SeaMonster");
			// Các con cá thường
			var data:Array = new Array();
			var i:int = 0;
			var j:int = 0;
			
			// Tính các tọa độ cá nhà bạn bơi ra
			var theirSoldierPos:Array = new Array();
			theirSoldierPos.splice(0, theirSoldierPos.length);
			var p1:Point = new Point(Constant.MAX_WIDTH / 2 + 100, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 30);
			theirSoldierPos.push(p1);
			var p2:Point = new Point(p1.x + 80, p1.y - 70);
			theirSoldierPos.push(p2);
			var p3:Point = new Point(p1.x + 80, p1.y + 70);
			theirSoldierPos.push(p3);
			var p4:Point = new Point(p1.x + 160, p1.y);
			theirSoldierPos.push(p4);
			var p5:Point = new Point(p1.x + 160, p1.y + 100);
			theirSoldierPos.push(p5);
			var p6:Point = new Point(p1.x + 160, p1.y - 100);
			theirSoldierPos.push(p6);
			
			if (Ultility.IsKillBoss())	
			{
				InitBossInWorldIce(dataSolider);
			}
			else
			{
				var imgName:String;
				// KHởi tạo các con cá lính ở thế giới cá
				for (i = 0; i < dataSolider.length; i++)
				{
					var item:Object = dataSolider[i];
					imgName = Fish.ItemType + item.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					var fis:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
					fis.standbyPos = theirSoldierPos[i];
					fis.Id = item.Id;
					// Khởi tạo Equip
					var objEquip:Object = item.Equipment as Object;
					var Equipment:Object = InitEquipmentForFishSoldierInWorld(objEquip);
					// Khởi tạo Quartz
					var objQuartz:Object = item.Quartz as Object;
					var Quartz:Object = InitQuartzForFishSoldierInWorld(objQuartz);
					// Khởi tạo các tham số cho con cá lính
					InitParamForFishSoldierInWorld(fis, item, Equipment, fis.standbyPos);
					fis.OnLoadResCompleteFunction = function ():void 
					{
						this.SwimTo(this.standbyPos.x, this.standbyPos.y, 20);
						this.SetMovingState(Fish.FS_STANDBY);
					}
				}
				FishWorldController.CheckShowEffEnvironment();
			}
		}
		
		private function InitFishOceanMetal(dataSolider:Array, isCreateBattle:Boolean = false):void 
		{
			FishSoldierArr.splice(0, FishSoldierArr.length);
			var objAllSea:Object = ConfigJSON.getInstance().GetItemList("SeaMonster");
			// Các con cá thường
			var data:Array = new Array();
			var i:int = 0;
			var j:int = 0;
			
			// Tính các tọa độ cá nhà bạn bơi ra
			var theirSoldierPos:Array = new Array();
			theirSoldierPos.splice(0, theirSoldierPos.length);
			var p1:Point = new Point(Constant.MAX_WIDTH / 2 + 100, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 30);
			theirSoldierPos.push(p1);
			var p2:Point = new Point(p1.x + 80, p1.y - 70);
			theirSoldierPos.push(p2);
			var p3:Point = new Point(p1.x + 80, p1.y + 70);
			theirSoldierPos.push(p3);
			var p4:Point = new Point(p1.x + 160, p1.y);
			theirSoldierPos.push(p4);
			var p5:Point = new Point(p1.x + 160, p1.y + 100);
			theirSoldierPos.push(p5);
			var p6:Point = new Point(p1.x + 160, p1.y - 100);
			theirSoldierPos.push(p6);
			
			if (Ultility.IsKillBoss())	
			{
				InitBossInWorldMetal(dataSolider);
			}
			else
			{
				var imgName:String;
				// KHởi tạo các con cá lính ở thế giới cá
				for (i = 0; i < dataSolider.length; i++)
				{
					var item:Object = dataSolider[i];
					imgName = Fish.ItemType + item.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					var fis:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
					fis.standbyPos = theirSoldierPos[i];
					fis.Id = item.Id;
					// Khởi tạo Equip
					var objEquip:Object = item.Equipment as Object;
					var Equipment:Object = InitEquipmentForFishSoldierInWorld(objEquip);
					// Khởi tạo Quartz
					var objQuartz:Object = item.Quartz as Object;
					var Quartz:Object = InitQuartzForFishSoldierInWorld(objQuartz);
					// Khởi tạo các tham số cho con cá lính
					InitParamForFishSoldierInWorld(fis, item, Equipment, fis.standbyPos);
					fis.OnLoadResCompleteFunction = function ():void 
					{
						this.SwimTo(this.standbyPos.x, this.standbyPos.y, 20);
						this.SetMovingState(Fish.FS_STANDBY);
					}
				}
			}
		}
		
		private function InitBossInWorldIce(dataSolider:Object):void 
		{
			var i:int = 0;
			var objAllSea:Object = ConfigJSON.getInstance().GetItemList("SeaMonster");
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var isHaveBoss:Boolean = false;
			var isHaveSubBoss:Boolean = false;
			arrBossDataIce = (dataSolider as Array);
			var dataBoss:Object = arrBossDataIce[0];
			var arrTactic:Array = BossIce.GetTactic(0);
			if(dataBoss.IsBoss != null)
			{
				var boss_Ice:BossIce = new BossIce(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "Boss2_Idle_1");
				boss_Ice.IsBoss = dataBoss.IsBoss;
				var configBoss:Object = objAllSea[FishWorldController.GetSeaId().toString()][FishWorldController.GetRound()];
				boss_Ice.IdBoss = dataBoss.Id;
				boss_Ice.CurHp = dataBoss.Vitality;
				boss_Ice.isSetCurHP = true;
				boss_Ice.MaxHp = configBoss[boss_Ice.IdBoss.toString()].Vitality;
				boss_Ice.Attack = dataBoss.Damage;
				boss_Ice.Defend = dataBoss.Defence;
				boss_Ice.Init(arrTactic[BossMetal.ID_TACTIC_BOSS][0].x, arrTactic[BossMetal.ID_TACTIC_BOSS][0].y);
				boss_Ice.SetStanbyPos(arrTactic[BossMetal.ID_TACTIC_BOSS][0]);
				bossIce = boss_Ice;
				isHaveBoss = true;
				
				GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthIce = GuiMgr.getInstance().GuiMainFishWorld.AddProgress(
					GuiMgr.getInstance().GuiMainFishWorld.PRG_HEALTH_BOSS, 
					"PrgHpBossIce", 620, -440, GuiMgr.getInstance().GuiMainFishWorld, true);
				GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthIce.SetPosBackGround( -41, -30)
				GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthIce.setStatus(1);
			}
			else
			{
				isHaveSubBoss = true;
				var subBossIce:SubBossIce = new SubBossIce(layer, "SubBoss2_Attack");
				subBossIce.Id = dataBoss.Id;
				subBossIce.SoldierType = FishSoldier.SOLDIER_TYPE_MIX;
				subBossIce.FishType = Fish.FISHTYPE_SOLDIER;
				subBossIce.Rank = dataBoss.Rank;
				subBossIce.FishTypeId = dataBoss.FishTypeId;
				subBossIce.Damage = dataBoss.Damage;
				subBossIce.Defence = dataBoss.Defence;
				subBossIce.Element = dataBoss.Element;
				subBossIce.Vitality = dataBoss.Vitality;
				subBossIce.Critical = dataBoss.Critical;
				subBossIce.Health = dataBoss.Health;
				subBossIce.RecipeType = dataBoss.RecipeType;
				subBossIce.Sex = -1;
				subBossIce.isActor = FishSoldier.ACTOR_NONE;
				subBossIce.Status = FishSoldier.STATUS_HEALTHY;
				subBossIce.SetSoldierInfo();
				subBossIce.isSubBoss = true;
				var Pos:Point = arrTactic[BossIce.ID_TACTIC_BOSS][i+1];
				if(isHaveBoss)	Pos = arrTactic[BossIce.ID_TACTIC_BOSS][1];
				subBossIce.Init(Pos.x, Pos.y);	
				subBossIce.standbyPos = Pos;
				
				// Khởi tạo Equip
				var objEquip:Object = dataBoss.Equipment as Object;
				var Equipment:Object = InitEquipmentForFishSoldierInWorld(objEquip);
				// Khởi tạo Quartz
				var objQuartz:Object = item.Quartz as Object;
				var Quartz:Object = InitQuartzForFishSoldierInWorld(objQuartz);
				subBossIce.LakeId = 1;
				subBossIce.SetEquipmentInfo(Equipment);
				subBossIce.UpdateCombatSkill();
				subBossIce.SetAgeState(Fish.OLD);
				subBossIce.SetEmotion(FishSoldier.WAR);
				subBossIce.SetMovingState(Fish.FS_STANDBY);
				arrSubBossIce.push(subBossIce);
			}
			arrBossDataIce.splice(0, 1);
		}
		
		private function InitBossInWorldMetal(dataSolider:Object):void 
		{
			var i:int = 0;
			var objAllSea:Object = ConfigJSON.getInstance().GetItemList("SeaMonster");
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var isHaveBoss:Boolean = false;
			for (i = 0; i < dataSolider.length; i++)
			{
				var dataBoss:Object = dataSolider[i];
				var arrTactic:Array = BossMetal.GetTactic(0);
				if(dataBoss.IsBoss != null)
				{
					var boss_Metal:BossMetal = new BossMetal(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "Boss1_Shield");
					boss_Metal.IsBoss = dataBoss.IsBoss;
					var configBoss:Object = objAllSea[FishWorldController.GetSeaId().toString()][FishWorldController.GetRound()];
					boss_Metal.IdBoss = dataBoss.Id;
					boss_Metal.CurHp = dataBoss.Vitality;
					boss_Metal.isSetCurHP = true;
					boss_Metal.MaxHp = configBoss[boss_Metal.IdBoss.toString()].Vitality;
					boss_Metal.Attack = dataBoss.Damage;
					boss_Metal.Defend = dataBoss.Defence;
					boss_Metal.Init(arrTactic[BossMetal.ID_TACTIC_BOSS][0].x, arrTactic[BossMetal.ID_TACTIC_BOSS][0].y);
					boss_Metal.SetStanbyPos(arrTactic[BossMetal.ID_TACTIC_BOSS][0]);
					isHaveBoss = true;
					bossMetal = boss_Metal;
					
					GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthMetal = GuiMgr.getInstance().GuiMainFishWorld.AddProgress(
						GuiMgr.getInstance().GuiMainFishWorld.PRG_HEALTH_BOSS, 
						//"PrgHpBoss" + FishWorldController.GetSeaId(), 620, -440, GuiMgr.getInstance().GuiMainFishWorld, true);
						"PrgHpBossMetal", 620, -440, GuiMgr.getInstance().GuiMainFishWorld, true);
					GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthMetal.SetPosBackGround( -41, -30)
					GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthMetal.setStatus(1);
					
					GuiMgr.getInstance().GuiMainFishWorld.prgBossArmorMetal = GuiMgr.getInstance().GuiMainFishWorld.AddProgress(
						GuiMgr.getInstance().GuiMainFishWorld.PRG_ARMOR_BOSS, 
						//"PrgHpBoss" + FishWorldController.GetSeaId(), 620, -440, GuiMgr.getInstance().GuiMainFishWorld, true);
						"PrgShieldBossMetal", 620, -390, GuiMgr.getInstance().GuiMainFishWorld, true);
					GuiMgr.getInstance().GuiMainFishWorld.prgBossArmorMetal.SetPosBackGround( -45, -22)
					GuiMgr.getInstance().GuiMainFishWorld.prgBossArmorMetal.setStatus(1);
				}
				else
				{
					var subBossMetal:SubBossMetal = new SubBossMetal(layer, "Bolt_Normal");
					subBossMetal.Id = dataBoss.Id;
					subBossMetal.SoldierType = FishSoldier.SOLDIER_TYPE_MIX;
					subBossMetal.FishType = Fish.FISHTYPE_SOLDIER;
					subBossMetal.Rank = dataBoss.Rank;
					subBossMetal.FishTypeId = dataBoss.FishTypeId;
					subBossMetal.Damage = dataBoss.Damage;
					subBossMetal.Defence = dataBoss.Defence;
					subBossMetal.Element = dataBoss.Element;
					subBossMetal.Vitality = dataBoss.Vitality;
					subBossMetal.Critical = dataBoss.Critical;
					subBossMetal.Health = dataBoss.Health;
					subBossMetal.RecipeType = dataBoss.RecipeType;
					subBossMetal.Sex = -1;
					subBossMetal.isActor = FishSoldier.ACTOR_NONE;
					subBossMetal.Status = FishSoldier.STATUS_HEALTHY;
					subBossMetal.SetSoldierInfo();
					subBossMetal.isSubBoss = true;
					var Pos:Point = arrTactic[BossMetal.ID_TACTIC_BOSS][i+1];
					if(isHaveBoss)	Pos = arrTactic[BossMetal.ID_TACTIC_BOSS][i];
					subBossMetal.Init(Pos.x, Pos.y);	
					subBossMetal.standbyPos = Pos;
					
					// Khởi tạo Equip
					var objEquip:Object = dataBoss.Equipment as Object;
					var Equipment:Object = InitEquipmentForFishSoldierInWorld(objEquip);
					// Khởi tạo Quartz
					var objQuartz:Object = item.Quartz as Object;
					var Quartz:Object = InitQuartzForFishSoldierInWorld(objQuartz);
					subBossMetal.LakeId = 1;
					subBossMetal.SetEquipmentInfo(Equipment);
					subBossMetal.UpdateCombatSkill();
					subBossMetal.SetAgeState(Fish.OLD);
					subBossMetal.SetEmotion(FishSoldier.WAR);
					subBossMetal.SetMovingState(Fish.FS_STANDBY);
					arrSubBossMetal.push(subBossMetal);
					//subBossMetal.isChoose = true;
				}
				//BossMgr.getInstance().BossArr.push(boss);
				//var prgBoss:ProgressBar = GuiMgr.getInstance().GuiMainFishWorld.AddProgress(GuiMgr.getInstance().GuiMainFishWorld.PRG_HEALTH_BOSS, "PrgHpBoss",
						//620, -440, GuiMgr.getInstance().GuiMainFishWorld, true);
				
			}
		}
		
		private function InitFishOceanNeutrality(dataSolider:Array, isCreateBattle:Boolean = false):void 
		{
			FishSoldierArr.splice(0, FishSoldierArr.length);
			var objAllSea:Object = ConfigJSON.getInstance().GetItemList("SeaMonster");
			// Các con cá thường
			var data:Array = new Array();
			var i:int = 0;
			var j:int = 0;
			
			// Tính các tọa độ cá nhà bạn bơi ra
			var theirSoldierPos:Array = new Array();
			theirSoldierPos.splice(0, theirSoldierPos.length);
			var p1:Point = new Point(Constant.MAX_WIDTH / 2 + 100, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 30);
			theirSoldierPos.push(p1);
			var p2:Point = new Point(p1.x + 80, p1.y - 70);
			theirSoldierPos.push(p2);
			var p3:Point = new Point(p1.x + 80, p1.y + 70);
			theirSoldierPos.push(p3);
			var p4:Point = new Point(p1.x + 160, p1.y);
			theirSoldierPos.push(p4);
			var p5:Point = new Point(p1.x + 160, p1.y + 100);
			theirSoldierPos.push(p5);
			var p6:Point = new Point(p1.x + 160, p1.y - 100);
			theirSoldierPos.push(p6);
			
			if (Ultility.IsKillBoss())	
			{
				InitBossInWorld(dataSolider);
			}
			else
			{
				var imgName:String;
				// KHởi tạo các con cá lính ở thế giới cá
				for (i = 0; i < dataSolider.length; i++)
				{
					var item:Object = dataSolider[i];
					imgName = Fish.ItemType + item.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					var fis:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
					fis.standbyPos = theirSoldierPos[i];
					fis.Id = item.Id;
					// Khởi tạo Equip
					var objEquip:Object = item.Equipment as Object;
					var Equipment:Object = InitEquipmentForFishSoldierInWorld(objEquip);
					// Khởi tạo Quartz
					var objQuartz:Object = item.Quartz as Object;
					var Quartz:Object = InitQuartzForFishSoldierInWorld(objQuartz);
					// Khởi tạo các tham số cho con cá lính
					InitParamForFishSoldierInWorld(fis, item, Equipment, fis.standbyPos);
					fis.OnLoadResCompleteFunction = function ():void 
					{
						this.SwimTo(this.standbyPos.x, this.standbyPos.y, 20);
						this.SetMovingState(Fish.FS_STANDBY);
					}
				}
				// Khởi tạo 5 con cá thường bới tung tăng
				//if(!isCreateBattle)
				//{
					//for (i = 0; i < 5; i ++)
					//{
						//data[i] = new Object();
						//data[i]["fishTypeId"] = 1 + Math.floor(Math.random() * 20);
						//data[i]["id"] = i + 1;
					//}
					//var Pos:Point;
					//for (i = 0; i < data.length; i++ ) 
					//{				
						//var fishTypeId:int = data[i]["fishTypeId"];
						//var id:int = data[i]["id"];
						//imgName = Fish.ItemType + fishTypeId + "_" + Fish.OLD + "_" + Fish.HAPPY;
						//
						//var fish:Fish = new Fish(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);
						//fish.Id = id;
						//fish.FishTypeId = fishTypeId;
						//
						//Pos = new Point();
						//Pos.x = Ultility.RandomNumber(300, 1000);
						//Pos.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 200, GameController.getInstance().GetLakeBottom() - 50);
						//fish.Init(Pos.x, Pos.y);
						//fish.SetAgeState(Fish.OLD);
						//FishArr.push(fish);
					//}
				//}
			}
		}
		
		private function InitBossInWorld(dataSolider:Object):void 
		{
			var i:int = 0;
			var objAllSea:Object = ConfigJSON.getInstance().GetItemList("SeaMonster");
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var boss:Boss = new Boss(layer, "Boss0_Idle");
			for (i = 0; i < dataSolider.length; i++)
			{
				var dataBoss:Object = dataSolider[i];
				var configBoss:Object = objAllSea[FishWorldController.GetSeaId().toString()][FishWorldController.GetRound()];
				boss.IdBoss = dataBoss.Id;
				boss.CurHp = dataBoss.Vitality;
				boss.isSetCurHP = true;
				boss.MaxHp = configBoss[boss.IdBoss.toString()].Vitality;
				boss.Attack = dataBoss.Damage;
				boss.Defend = dataBoss.Defence;
				boss.SubBossArr = [];
				boss.SubSoliderArr = [];
				boss.Init(Constant.STAGE_WIDTH / 2 + 100, GameController.getInstance().GetLakeTop() + 300);
				BossMgr.getInstance().BossArr.push(boss);
				//var prgBoss:ProgressBar = GuiMgr.getInstance().GuiMainFishWorld.AddProgress(GuiMgr.getInstance().GuiMainFishWorld.PRG_HEALTH_BOSS, "PrgHpBoss",
						//620, -440, GuiMgr.getInstance().GuiMainFishWorld, true);
				var prgBoss:ProgressBar = GuiMgr.getInstance().GuiMainFishWorld.AddProgressBoss(boss);
				GuiMgr.getInstance().GuiMainFishWorld.arrPrgBossHealth.push(prgBoss);
			}
		}
		
		/**
		 * Khởi tạo con cá trong bể
		 * @param	fis
		 * @param	item
		 * @return
		 */
		public function InitParamForFishSoldierInWorld(fis:FishSoldier, item:Object, Equipment:Object, Pos:Point):FishSoldier
		{
			//var Pos:Point = new Point();
			//Pos.x = Ultility.RandomNumber(300, 1000);
			//Pos.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 200, GameController.getInstance().GetLakeBottom() - 50);
			
			fis.SoldierType = FishSoldier.SOLDIER_TYPE_MIX;
			fis.FishType = Fish.FISHTYPE_SOLDIER;
			fis.Rank = item.Rank;
			fis.FishTypeId = item.FishTypeId;
			fis.Damage = item.Damage;
			fis.Defence = item.Defence;
			fis.Element = item.Element;
			fis.Vitality = item.Vitality;
			fis.Critical = item.Critical;
			fis.Health = item.Health;
			fis.RecipeType = item.RecipeType;
			fis.Id = item.Id;
			fis.Sex = -1;
			fis.isActor = FishSoldier.ACTOR_NONE;
			fis.Status = FishSoldier.STATUS_HEALTHY;
			fis.SetSoldierInfo();
			fis.Init(Pos.x, Pos.y);		
			
			fis.LakeId = 1;
			fis.SetEquipmentInfo(Equipment);
			fis.UpdateCombatSkill();
			fis.SetAgeState(Fish.OLD);
			fis.SetEmotion(FishSoldier.WAR);
			fis.SetMovingState(Fish.FS_STANDBY);
			fis.isChoose = true;
			FishSoldierArr.push(fis);
			//trace("InitParamForFishSoldierInWorld fis== " + fis);
			return fis;
		}
		
		/**
		 * KHởi tạo các dữ liệu cần với Equip
		 * @param	objEquip
		 * @return
		 */
		public function InitEquipmentForFishSoldierInWorld(objEquip:Object):Object 
		{
			var idStart:int = Math.floor(1000000 + 1000000 * Math.random());
			var Equipment:Object = new Object();
			var countCheckNull:int = 0;
			for (var istr:String in objEquip) 
			{
				trace("InitParamForFishSoldierInWorld istr== " + istr);
				var type:String = objEquip[istr].ItemType;
				var rank:int = objEquip[istr].Rank;
				var color:int = objEquip[istr].Color;
				
				//var equip:FishEquipment = new FishEquipment();
				var equip:Object = new Object();
				equip.Id = idStart;
				equip.Element = item.Element;
				equip.Type = type;
				equip.Rank = rank;
				equip.Color = color;
				equip.EnchantLevel = 0;
				Equipment[type] = new Object();
				var obj:Object = ConfigJSON.getInstance().GetItemList("Wars_" + type);
				obj = obj[rank.toString()];
				obj = obj[color.toString()];
				
				if(obj && obj.Critical && obj.Critical.Max) 	equip.Critical = obj.Critical.Max;
				if(obj && obj.Damage && obj.Damage.Max) 	equip.Damage = obj.Damage.Max;
				if(obj && obj.Durability) 	equip.Durability = obj.Durability * 0.5 * (1 + Math.random());
				//equip.FishOwn
				equip.StartTime = GameLogic.getInstance().CurServerTime;
				if(obj && obj.Vitality) 	equip.Vitality = obj.Vitality;
				Equipment[type][idStart.toString()] = equip;
				idStart ++;
				countCheckNull ++;
			}
			if(countCheckNull == 0) 
			{
				Equipment.Helmet = null;
				Equipment.Weapon = null;
				Equipment.Armor = null;
			}
			trace("InitParamForFishSoldierInWorld Equipment== " + Equipment);
			return Equipment;
		}
		
		
		/**
		 * Khởi tạo các dữ liệu cần với Quartz
		 * @param	objQuartz
		 * @return
		 */
		public function InitQuartzForFishSoldierInWorld(objQuartz:Object):Object 
		{
			var idStart:int = Math.floor(1000000 + 1000000 * Math.random());
			var Quartz:Object = new Object();
			var countCheckNull:int = 0;
			for (var istr:String in objQuartz) 
			{
				trace("InitQuartzForFishSoldierInWorld istr== " + istr);
				/*var type:String = objEquip[istr].ItemType;
				var rank:int = objEquip[istr].Rank;
				var color:int = objEquip[istr].Color;
				
				var equip:Object = new Object();
				equip.Id = idStart;
				equip.Element = item.Element;
				equip.Type = type;
				equip.Rank = rank;
				equip.Color = color;
				equip.EnchantLevel = 0;
				Equipment[type] = new Object();
				var obj:Object = ConfigJSON.getInstance().GetItemList("Wars_" + type);
				obj = obj[rank.toString()];
				obj = obj[color.toString()];
				
				if(obj && obj.Critical && obj.Critical.Max) 	equip.Critical = obj.Critical.Max;
				if(obj && obj.Damage && obj.Damage.Max) 	equip.Damage = obj.Damage.Max;
				if(obj && obj.Durability) 	equip.Durability = obj.Durability * 0.5 * (1 + Math.random());
				//equip.FishOwn
				equip.StartTime = GameLogic.getInstance().CurServerTime;
				if(obj && obj.Vitality) 	equip.Vitality = obj.Vitality;
				Equipment[type][idStart.toString()] = equip;*/
				idStart ++;
				countCheckNull ++;
			}
			if(countCheckNull == 0) 
			{
				/*Equipment.Helmet = null;
				Equipment.Weapon = null;
				Equipment.Armor = null;*/
			}
			trace("InitQuartzForFishSoldierInWorld Quartz== " + Quartz);
			return Quartz;
		}
		
		private function InitFishOceanHappy(data:Array):void 
		{
			if (FishWorldHappyArr && FishWorldHappyArr.length > 0)
			{
				for each (var fishHappy:FishOceanHappy in FishWorldHappyArr) 
				{
					fishHappy.Show();
				}
				return;
			}
			var fishTypeId:int;
			var levelMyUser:int = GetMyInfo().Level;
			//var arrFishCanHave:Array = ConfigJSON.getInstance().getItemList("Fish");
			var objFishCanHave:Object = ConfigJSON.getInstance().GetItemList("Fish");
			var arrFishTypeId:Array = new Array();
			for (var j:String in objFishCanHave) 
			{
				if (Math.min(levelMyUser, 68) >= objFishCanHave[j]["LevelRequire"] && objFishCanHave[j]["Id"] < Constant.FISH_TYPE_START_SOLDIER)
				{
					fishTypeId = objFishCanHave[j]["Id"];
					arrFishTypeId.push(fishTypeId);
				}
			}
			var isCouple:Boolean = false;
			var index:int;
			var Pos:Point;
			for (var i:int = 0; i < data.length; i++ ) 
			{
				var item:Object = data[i];
				var imgName:String;
				var fis:FishOceanHappy = new FishOceanHappy();;
				var sourceId:int;
				var deltaX:Number;
				var deltaY:Number;
				
				if (!isCouple)
				{
					isCouple = true;
					Pos = new Point();
					fishTypeId = arrFishTypeId[index];
					if (fishTypeId > Constant.FISH_TYPE_START_DOMAIN  && fishTypeId < Constant.FISH_TYPE_START_SOLDIER) 
					{
						sourceId = fishTypeId - (fishTypeId - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
						imgName = Fish.ItemType + sourceId + "_" + Fish.OLD + "_" + Fish.IDLE;
					}
					else
					{
						imgName = Fish.ItemType + fishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					}
					deltaX = 50 + Math.random() * 20;
					deltaY = Math.sqrt(6000 - deltaX * deltaX);
					Pos.x = Ultility.RandomNumber(300, 1000);
					Pos.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 200, GameController.getInstance().GetLakeBottom() - 50);
					Pos.x = Pos.x + deltaX;
					Pos.y = Pos.y + deltaY;
					fis = new FishOceanHappy(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);
					fis.deltaX = deltaX;
					fis.deltaY = deltaY;
					fis.kind = FishOceanHappy.AUXILIARY;
				}
				else 
				{
					index = Math.floor(Math.random() * arrFishTypeId.length);
					isCouple = false;
					arrFishTypeId.slice(index, index + 1);
					Pos.x = Pos.x - deltaX;
					Pos.y = Pos.y - deltaY;
					//imgName = Fish.ItemType + fishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					if (fishTypeId > Constant.FISH_TYPE_START_DOMAIN  && fishTypeId < Constant.FISH_TYPE_START_SOLDIER) 
					{
						sourceId = fishTypeId - (fishTypeId - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
						imgName = Fish.ItemType + sourceId + "_" + Fish.OLD + "_" + Fish.IDLE;
					}
					else
					{
						imgName = Fish.ItemType + fishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					}
					fis = new FishOceanHappy(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);
					fis.auxiliaryFish = FishWorldHappyArr[FishWorldHappyArr.length - 1] as FishOceanHappy;
					fis.auxiliaryFish.mainFish = fis;
					fis.kind = FishOceanHappy.MAIN;
				}
				
				fis.LastPlayMiniGame = data[i].LastPlayMiniGame;	
				fis.Id = data[i]["Id"];
				fis.FishTypeId = fishTypeId;
				//fis.idTrue = item["idTrue"];
				
				fis.Init(Pos.x, Pos.y);
				fis.LakeId = 1;
				fis.SetAgeState(Fish.OLD);
				// set state hiện tại của cá
				fis.SetEmotion(Fish.IDLE);
				FishWorldHappyArr.push(fis)
			}
		}
		
		/**
		 * Khởi tạo mảng mộ cá
		 * @param	data
		 * @param	lakeId
		 */
		public function InitGrave(data:Object, lakeId:int):void
		{
			//FishSoldierExpired.splice(0, FishSoldierExpired.length);
			
			for (var j:String in data)
			{	
				var imgName:String = "FishGrave";
				var fis:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
				var Pos:Point = new Point();
				Pos.x = Ultility.RandomNumber(300, 1000);
				Pos.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 200, GameController.getInstance().GetLakeBottom() - 50);
				fis.SetInfo(data[j]);
				fis.SetSoldierInfo();
				fis.Init(Pos.x, Pos.y);
				fis.SetEmotion(FishSoldier.DEAD);
				fis.LakeId = lakeId;
				fis.SetEquipmentInfo(data[j].Equipment);

				var x:int = Ultility.RandomNumber((Constant.MAX_WIDTH - Constant.STAGE_WIDTH) / 2, (Constant.MAX_WIDTH + Constant.STAGE_WIDTH) / 2);
				var y:int = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 130, GameController.getInstance().GetLakeBottom() - 70);
					
				fis.fallPos.x = x;
				fis.fallPos.y = y;
				
				FishSoldierExpired.push(fis);
			}
		}
		
		/**
		 * Khởi tạo cá lính
		 * @param	data
		 * @param	lakeId
		 */
		public function InitFishSoldier(data:Object, lakeId:int):void
		{
			FishSoldierExpired.splice(0, FishSoldierExpired.length);
			FishSoldierArr.splice(0, FishSoldierArr.length);
			
			for (var j:String in data)
			{	
				if (data[j].FishType == Fish.FISHTYPE_SOLDIER)
				{
					var imgName:String = Fish.ItemType + data[j].FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					var fis:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
					var Pos:Point = new Point();
					Pos.x = Ultility.RandomNumber(300, 1000);
					Pos.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 200, GameController.getInstance().GetLakeBottom() - 50);
					fis.SetInfo(data[j]);
					fis.SetSoldierInfo();
					//fis.Init(Pos.x, Pos.y);					
					
					fis.LakeId = lakeId;
					fis.SetEquipmentInfo(data[j].Equipment);
					//fis.UpdateBonusEquipment();
					fis.UpdateCombatSkill();
					fis.SetAgeState(Fish.OLD);
					
					//if (fis.EquipmentList && fis.EquipmentList.Mask && fis.EquipmentList.Mask[0] && fis.EquipmentList.Mask[0].TransformName != "")
					//{
						//fis.RefreshImg();
					//}
					
					fis.Init(Pos.x, Pos.y);	
					
					switch (fis.CheckStatus())
					{
						case FishSoldier.STATUS_INSTORE:
							// Chưa ra khỏi shop
							break;
						case FishSoldier.STATUS_HEALTHY:
							// Khỏe mạnh
							// Set state hiện tại của cá lính trưởng thành
							//if (fis.IsHealthy() >= fis.AttackPoint)
							if (fis.IsHealthy())
							{
								// Nếu cá có quà do def thành công -> Hiển thị emo quà
								//if (fis.Bonus.length > 0)
								if (fis.Diary != null && fis.Diary.length > 0 && !GameLogic.getInstance().user.IsViewer())
								{
									fis.SetEmotion(FishSoldier.REWARD);
								}
							}
							else
							{
								fis.SetEmotion(FishSoldier.WEAK);
							}
							break;
						case FishSoldier.STATUS_REVIVE:
							// Lâm sàng
							fis.SetEmotion(FishSoldier.REVIVE);
							break;
						case FishSoldier.STATUS_DEAD:
							// Chết
							//Loadres thành mồ
							//var up:SendUpdateExpiredSoldier = new SendUpdateExpiredSoldier(fis.Id, fis.LakeId, Id.toString());
							//Exchange.GetInstance().Send(up);
							fis.SetEmotion(FishSoldier.DEAD);
							FishSoldierExpired.push(fis);
							break;
					}
					
					var x:int = Ultility.RandomNumber((Constant.MAX_WIDTH - Constant.STAGE_WIDTH) / 2, (Constant.MAX_WIDTH + Constant.STAGE_WIDTH) / 2);
					var y:int = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 130, GameController.getInstance().GetLakeBottom() - 70);
						
					fis.fallPos.x = x;
					fis.fallPos.y = y;
					
					//Trường hợp câu chat của cá đặc biệt
					fis.chatbox.ContentImg = "imgThinkContent2";
					
					//Lải nhải
					if (MyInfo.Id != this.Id)
					{
						GameLogic.getInstance().FishChatting(Constant.CHAT_VISITOR, 3000, 2);
					}
					
					if (fis.Status != FishSoldier.STATUS_DEAD)
					{
						FishSoldierArr.push(fis);
					}
				}
			}
		}
		
		/**
		 * Khởi tạo boss thảo dược
		 * @param	data
		 * @param	lakeId
		 */
		public function InitBossHerb():void
		{
			if (bossHerb)	return;
			
			
			var MaskClip:MovieClip = new MovieClip();
			MaskClip.graphics.beginFill(0xFF0000,1);
			MaskClip.graphics.drawRect(500, GameController.getInstance().GetLakeBottom() - 350, 350, 400);
			MaskClip.graphics.endFill();
			LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).addChild(MaskClip);
			//GetContainer("GuiBG").img.mask = MaskClip;
			
			var imagg:Image = new Image(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "Black_Hole", 500, GameController.getInstance().GetLakeBottom() - 150);
			imagg.SetScaleY(2);
			
			bossHerb = new BossHerb(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "Boss1");	
			var Pos:Point = new Point();
			//Pos.x = Ultility.RandomNumber(300, 1000);
			//Pos.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 200, GameController.getInstance().GetLakeBottom() - 50);
			Pos.x = 430;
			Pos.y = GameController.getInstance().GetLakeBottom() - 150;
			
			var bCfg:Object = ConfigJSON.getInstance().GetItemList("HerbBoss");
			bossHerb.SetInfo(bCfg);
			bossHerb.Init(Pos.x, Pos.y);
			
			bossHerb.img.mask = MaskClip;
			bossHerb.Mask = MaskClip;
			bossHerb.Hole = imagg;
			
			bossHerb.SwimTo(bossHerb.img.x + 200, bossHerb.img.y, 10);
		}
		
		public function InitFish(data:Object, lakeId:int):void
		{
			PocketArr.splice(0, PocketArr.length);
			for (var j:String in data)
			{	
				//try
				//{
					//data[j].FishTypeId = "8";
				if (data[j].FishType != Fish.FISHTYPE_SOLDIER)
				{
					var imgName:String = Fish.ItemType + data[j].FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					var fis:Fish = new Fish(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
					var Pos:Point = new Point();
					Pos.x = Ultility.RandomNumber(300, 1000);
					Pos.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 200, GameController.getInstance().GetLakeBottom() - 50);
					fis.SetInfo(data[j]);	
					fis.Material = data[j]["Material"];
					if (fis.Material == null)	fis.numMatUse = 0;
					else 	fis.numMatUse = fis.Material.length;
					fis.Init(Pos.x, Pos.y);
					fis.LakeId = lakeId;
					fis.LastBirthTime = data[j].LastBirthTime;
					var growth:Number = fis.Growth();
					if (growth < 0 || fis.IsEgg)
					{
						fis.SetAgeState(Fish.EGG);
						fis.SetMovingState(Fish.FS_IDLE);
						fis.SetPos(Pos.x, Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 15, GameController.getInstance().GetLakeBottom() - 10));
						fis.SetDeep(0.1);
						var result:int = fis.StartTime - GameLogic.getInstance().CurServerTime;
						if (result <= 0)
						{
							fis.SetEmotion(Fish.HAMMER);
						}
					}
					else if (growth < 0.5)
					{
						fis.SetAgeState(Fish.BABY);
					}
					else
					{
						fis.SetAgeState(Fish.OLD);
					}
					// set state hiện tại của cá
					if (fis.DomainFish() <= 0)
					{
						fis.SetEmotion(Fish.IDLE);
					}
					else
					{
						fis.SetEmotion(Fish.DOMAIN + fis.DomainFish());
					}
					
					//if (fis.MoneyAttacked > 0)
					//{
						//fis.SetEmotion(Fish.ATTACKED);
					//}
					
					fis.initBalloon();
					
					//Trường hợp câu chat của cá đặc biệt
					if (fis.FishType == Fish.FISHTYPE_SPECIAL)
					{
						fis.chatbox.ContentImg = "imgThinkContent2";
					}
					
					if (fis.LevelUpGift != null && fis.LevelUpGift.length != 0 && fis.Growth() >= fis.NumUpLevel + 1)
					{
						fis.SetEmotion(Fish.GIFT);
					}
					fis.ViagraUsed = data[j].ViagraUsed;
					FishArr.push(fis);			
				//}
				//catch (e:Error)
				//{
					//trace(e.getStackTrace());
				//}			 	
				
				//Khởi tạo cá đầu đàn
				//if (j == 0 && fis != null) 
				//{
					//FishKing = fis;
					//FishKing.IsFishKing = true;
				//}			
				}
			}
			
			//Lải nhải
			if (MyInfo.Id != this.Id)
			{
				GameLogic.getInstance().FishChatting(Constant.CHAT_VISITOR, 3000, 2);
			}
			
			//Khởi tạo cá bơi tập trung lại
			//var des:Point = new Point();
			//var x:Number = Ultility.PosScreenToLake(0, 0).x;
			//des.x = Ultility.RandomNumber(x, x + FishKing.img.stage.stageWidth);
			//do
			//{
				//des.y = FishKing.CurPos.y + Ultility.RandomNumber( -150, 150);
			//}
			//while (	des.y < FishKing.SwimingArea.top	|| des.y > FishKing.SwimingArea.bottom);
			//
			//var speed:Number;
			//
			//for (j = 0; j < FishArr.length; j++ )
			//{
				//fis = FishArr[j] as Fish;
				//fis.SetMovingState(Fish.FS_HERD);
				//speed = Ultility.RandomNumber(5, 8);
				//fis.SwimTo(des.x, des.y, speed);
			//}
			//GameLogic.getInstance().CenterHerd = des;
			
		}
		public function InitFishSpartan(data:Object, lakeId:int, name:String):void
		{
			if (data)
			{
				var imgName:String;
				var fis:FishSpartan;
				for (var j:String in data)
				{	
					var objFish:Object = data[j];
					var objOption:Object = objFish["Option"];
					var numOption:int = 0;
					for (var iobjOptoin:String in objOption) 
					{
						numOption++;
					}
					
					if (data[j]["ExpiredDay"] * 3600 * 24 >= GameLogic.getInstance().CurServerTime - data[j]["StartTime"]) 
					{
						imgName = name;
						fis = new FishSpartan(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
						
						// cap nhật các thuộc tính cho cá
						fis.LakeId = lakeId;
						fis.RateOption = data[j]["Option"];
						fis.Id = data[j]["Id"];
						fis.Material = data[j]["Material"];
						if (fis.Material == null)	fis.numMatUse = 0;
						else 	fis.numMatUse = fis.Material.length;
						fis.ExpiredTime = data[j]["ExpiredDay"];
						fis.StartTime = data[j]["StartTime"];
						fis.numOption = numOption;
						fis.NameItem = name;
						//fis.StartTime = data[j]["StartTime"] -  fis.ExpiredTime * 3600 * 24 + 30;
					
						var Pos:Point = new Point();
						Pos.x = Ultility.RandomNumber(300, 1000);
						Pos.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 200, GameController.getInstance().GetLakeBottom() - 50);
						
						fis.isExpired = true;
						fis.bCollisionBottom = false;
						FishArrSpartan.push(fis);
						fis.Init(Pos.x, Pos.y);
					}
					else
					{
						if(int(ConfigJSON.getInstance().GetItemList("Param")["MaxReborn"]) > int(data[j]["RebornTime"]))
						{
							imgName = name + "1";
						}
						else 
						{
							imgName = "Supper2";
						}
						fis = new FishSpartan(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
						fis.ExpiredTime = data[j]["ExpiredDay"];
						//fis.SetInfo(data[j]);					
						fis.LakeId = lakeId;
						fis.RateOption = data[j]["Option"];
						fis.Material = data[j]["Material"];
						fis.Id = data[j]["Id"];
						fis.ItemType = name;
						fis.numOption = numOption;
						fis.StartTime = data[j]["StartTime"];
						fis.NameItem = name;
						
						if (data[j]["isExpried"])//nếu biến này vẫn hiển thị chưa hết hạn
						{
							// Gửi gói tin
							var updateSparta:SendUpdateSparta = new SendUpdateSparta(Id);
							Exchange.GetInstance().Send(updateSparta);
							fis.isExpired = false;	
							fis.bCollisionBottom = true;
							//UpdateOptionLakeSparta( -1, fis);
							UpdateOptionLakeObject( -1, fis.RateOption, CurLake.Id);
						}
						/*đặt vị trí cho con cá*/
						var x:int;
						var y:int;
						var z:Number = 1;
						/*xét vị trí cá Spartan hóa thạch*/
						if ((data[j]["Position"] is Array) ||
						data[j]["Position"] == null || data[j]["Position"].X == null || data[j]["Position"].Y == null || data[j]["Position"].Z == null
						|| (data[j]["Position"].X == 0 && data[j]["Position"].Y == 0 && data[j]["Position"].Z == 0))
						{//chưa có vị trí trên server
							x = Ultility.RandomNumber((Constant.MAX_WIDTH - Constant.STAGE_WIDTH) / 2, (Constant.MAX_WIDTH + Constant.STAGE_WIDTH) / 2);
							y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 90, GameController.getInstance().GetLakeBottom() - 30);
							//Gửi gói tin cập nhật vị trí
							var pk:SendMoveDecorate = new SendMoveDecorate(lakeId);
							pk.AddNew(fis.Id, fis.ItemType, x, y, 1);
							Exchange.GetInstance().Send(pk);
						}
						else
						{
							x = data[j]["Position"].X;
							y = data[j]["Position"].Y;
							z = data[j]["Position"].Z;
						}
						
						
						fis.fallPos.x = x;
						fis.fallPos.y = y;
						fis.Init(x, y);
						fis.Dragable = false;
						fis.SaveInfo();
						fis.UpdateDeep();
						FishArrSpartanDeactive.push(fis);
					}
					fis.numReborn = data[j]["RebornTime"];
					
				}
			
				//Lải nhải
				if (MyInfo.Id != this.Id)
				{
					GameLogic.getInstance().FishChatting(Constant.CHAT_VISITOR, 3000, 2);
				}
			}
		}	
		
		public function InitPearlRefine(data:Object):void 
		{
			if (pearlMgr)
			{
				pearlMgr = null;
			}
			pearlMgr = new PearlMgr();
			pearlMgr.InitLoad(data);
		}
		
		/**
		 * Hàm tính tổng tiền có thể cướp, số tiền có thể cướp còn lại, và số tiền yêu cầu để có thể oánh nhau
		 */
		public function UpdateLakeBenefit():void
		{
			MoneyTotal = 0;
			MoneyLeft = 0;
			MoneyRequire = 0;
			
			var i:int;
			for (i = 0; i < FishArr.length; i++)
			{
				var cfg:Object = ConfigJSON.getInstance().getItemInfo("Fish", FishArr[i].FishTypeId);
				var trustPrice:int = cfg.TrustPrice;
				var thisTotal:int = trustPrice * 60 / 100;
				var thisLeft:int = thisTotal - FishArr[i].MoneyAttacked;

				MoneyTotal += thisTotal;
				MoneyLeft += thisLeft;
			}
			
			
		}
		
		//Update nguyen lieu lai
		public function UpdateMixedMaterial():void
		{
			for (var i:int; i < fallingObjArr.length; i++ )
			{
				var mat:FallingObject = fallingObjArr[i] as FallingObject;
				mat.UpdateMixMaterial();
			}
		}
		
	
		public function UpdateDirtyArray(UpdateLakeBright:Boolean = false):void
		{
			var i:int;
			var TopY:int = GameController.getInstance().GetLakeTop();
			var BottomY:int = GameController.getInstance().GetLakeBottom() - 100;
			
			//var x:Array = [400, 700, 300, 1000, 550, 100, 200, 300, 400, 500];
			//var y:Array = [400, 500, 600, 600, 570, 450, 550, 490, 580, 420];
			var dirty:Dirty;
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER);
			var nDirty:int = CurLake.GetDirtyAmount();
			var HasChanged:Boolean = false;
			
			for (i = DirtyArr.length; i < nDirty; i++)
			{
				var x:int = Ultility.RandomNumber(230, 800);
				var y:int = Ultility.RandomNumber(TopY, BottomY);
				dirty =  new Dirty(layer, "Dirty", x, y);
				DirtyArr.push(dirty);
				HasChanged = true;
			}
			
			if (HasChanged || UpdateLakeBright)
			{
				//GameController.getInstance().SetLakeBright(0.5 + 0.5*(1-nDirty/Lake.MAX_DIRTY));
			}
		}
		
		public function InitMixLake():void
		{
			//var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			//var imgName:String;
			//
			//MixLakeArr.splice(0, MixLakeArr.length);
			//imgName = MixLake.ItemType + 3;				
			//var mixLake:MixLake = new MixLake(layer, imgName, 0, 0, true, Image.ALIGN_LEFT_TOP);
			//mixLake.UpdatePos(0);
			//MixLakeArr.push(mixLake);
		}
		
		public function InitDailyBonus():void
		{
			//dailyBonus = null;
			//var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);			
			//if (DailyBonus.CheckUser() == DailyBonus.SUCCESS || DailyBonus.CheckUser() == DailyBonus.NOT_ACTIVED)
			//{
				//dailyBonus = new DailyBonus(layer, DailyBonus.NAME_ACTIVED, 890, GameController.getInstance().GetLakeTop() - 20);
			//}
			//else
			//{
				//dailyBonus = new DailyBonus(layer, DailyBonus.NAME_DEACTIVED, 890, GameController.getInstance().GetLakeTop() - 20);
			//}
		}
		
		//public function InitTreasureBox():void
		//{
			//var beginTime:Number = ConfigJSON.getInstance().GetItemList("Event").BeginTime;
			//var remainTime:Number = beginTime - GameLogic.getInstance().CurServerTime;
			//if (remainTime <= 0)
			//{
				//return;
			//}
			//var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			//treasureBox = null;
			//treasureBox = new TreasureBox(layer, TreasureBox.NAME, 980, GameController.getInstance().GetLakeTop());
		//}
		
		public function InitDailyGift(HasDailyGift:Boolean):void
		{
			if (HasDailyGift)
			{
				//GuiMgr.getInstance().GuiGetDailyGift.Show();
			}
		}
		
		//public function InitUnlockFishList(data:Array):void
		//{
			//var i:int;
			//var tg:int;
			//for (i = 0; i < data.length; i++)
			//{
				//tg = data[i] as int;
				//UnlockFishArr.push(tg);
			//}
		//}
		
		/**
		 * Kiểm tra xem cá đã được unlock chưa
		 * Nếu chưa unlock thì trả về 0
		 * Nếu unlock rồi thì trả về kiểu unlock
		 * @param	TypeId	Loại cá
		 * @return
		 */
		public function CheckFishUnlocked(TypeId:int):int
		{
			var result:int = (UnlockFish[TypeId] != null?UnlockFish[TypeId]:0);
			return result;			
		}
		
		/**
		 * Thêm 1 loại cá được unlock vào mảng cá đã được unlock
		 * @param	TypeId
		 * @param	unlockType
		 */
		public function AddFishUnlock(TypeId:int, unlockType:int):void
		{
			UnlockFish[TypeId] = unlockType;	
			var levelRequire:int = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, TypeId)["LevelRequire"];
			MaxFishLevelUnlock = Math.max(levelRequire, MaxFishLevelUnlock);
		}
		
		/**
		 * Lấy levelRequire lớn nhất của các con cá đã được unlock
		 * @return levelRequire lớn nhất của các con cá đã được unlock
		 */
		public function getMaxUnlockedFishLevel():int
		{
			//var level:int = 0;
			//var levelRequire:int = 0;
			//for (var i:String in UnlockFish) 
			//{
				//levelRequire = ConfigJSON.getInstance().GetItemInfo(Fish.ItemType, parseInt(i))["LevelRequire"];
				//level = levelRequire > level ? levelRequire:level;
			//}
			//return level;
			return MaxFishLevelUnlock;
		}
		
		public function SetEmoAllFish(emo:String):void
		{
			var fish:Fish;
			for (var i:int = 0; i < FishArr.length; i++)
			{
				fish = FishArr[i] as Fish;
				fish.SetEmotion(emo);
			}
			
			// Add emo cho cả cá lính
			//var fishSol:FishSoldier;
			//for (var j:int = 0; j < FishSoldierArr.length; j++)
			//{
				//fishSol = FishSoldierArr[j] as FishSoldier;
				//fishSol.SetEmotion(emo);
			//}
		}		
		
		
		/**
		 * Đếm số lượng background đã có
		 */
		public function getNumBgr(itemId:int):int
		{
			var BgrArr:Array = StockThingsArr["BackGround"];
			var num:int = 0;
			
			//Đếm ở trong kho
			for (var i:int = 0; i < BgrArr.length; i++) 
			{
				if (BgrArr[i]["ItemId"] == itemId)
				{
					num++;
				}
			}
			
			//Nếu ở ngoài hồ đang dùng rồi cũng count
			if (backGround.ItemId == itemId)
			{
				num++;
			}
			
			return num;
		}
		
		/**
		 * Lấy backgroud mặc định trong kho
		 */
		public function getDefaultBgrFromStore():Object
		{
			var BgrArr:Array = StockThingsArr["BackGround"];
			for (var i:int = 0; i < BgrArr.length; i++) 
			{
				if (BgrArr[i]["ItemId"] == Constant.ID_DEFAULT_BACKGROUND)
					return BgrArr[i];
			}
			
			//var obj:Object= new Object();
			//obj.ExpiredTime = GameLogic.getInstance().CurServerTime + 365 * 24 * 3600;
			//obj.ItemId = Constant.ID_DEFAULT_BACKGROUND;
			//obj.ItemType = "BackGround";
			//return obj;
			return null;
		}
		
		/**
		 * Khởi tạo background
		 * @param	data	thông tin về background, bao gồm các trường: ItemId, ItemType, Id, ExpiredTime...
		 * @param	isSwapBgr	= true khi thay đổi background, = false nếu muốn load background mới
		 */
		public function initBackGround(data:Object, isSwapBgr:Boolean = false):void
		{
			backGround = new Decorate(null, "", 0, 0, "BackGround", Constant.ID_DEFAULT_BACKGROUND);
			if (data)
			{
				//Hard code: doi bg mac dinh trong cac evetn
				//if (data["ItemId"] == Constant.ID_DEFAULT_BACKGROUND_FROM_SERVER)
				//{
					//data["ItemId"] = Constant.ID_DEFAULT_BACKGROUND;
				//}
				
				backGround.SetInfo(data);
				backGround.expiredTime = data["ExpiredTime"];
					
				GameController.getInstance().isSmallBackGround = Config.getInstance().isSmallBackGround(backGround.ItemId);
			}
			else
			{
				backGround.expiredTime = GameLogic.getInstance().CurServerTime + 365 * 24 * 3600;
			}
			
			if (isSwapBgr)
			{
				GameController.getInstance().changeBackGround(backGround.ItemId);
			}
			else
			{
				//Load background, cái này phải load sau khởi tạo đồ trang trí vì background được coi như là 1 đồ trang trí
				ResMgr.getInstance().loadBackGround();
			}
			
			//Set normal screen khi dùng backgroun nhỏ trong chế độ fullscreen
			if (GameController.getInstance().isSmallBackGround && Main.imgRoot.stage.displayState == StageDisplayState.FULL_SCREEN)
			{
				Main.imgRoot.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		
		public function InitDecoArray(data:Array):void
		{
			// init decorate data
			var hasBackground:Boolean = false;
			item = data;
			var i:int;
			var decoTemp:Decorate = new Decorate(null, "", 0, 0, "", 0);
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			for (i = 0; i < data.length; i++)
			{
				if (data[i] == "") continue;
				if (data[i]["ItemType"] == "BackGround")
				{
					initBackGround(data[i]);
					hasBackground = true;
					continue;
				}
				
				var imgName:String;
				decoTemp.SetInfo(data[i]);
				imgName = decoTemp.ItemType + decoTemp.ItemId;
				
				var deco:Decorate;
				deco = new Decorate(layer, imgName, decoTemp.X, decoTemp.Y, decoTemp.ItemType, decoTemp.ItemId);
				deco.Id = decoTemp.Id;
				deco.expiredTime = data[i]["ExpiredTime"];
				deco.SetScale(decoTemp.Z);
				
				var x:int = decoTemp.X;
				var y:int = decoTemp.Y;
				var r:Rectangle = GameController.getInstance().GetDecorateArea();
								
				if (r.top >  decoTemp.Y)
				{
					y = r.top;
					deco.SetDeep(1);
				}
				else if(r.bottom < decoTemp.Y) 
				{
					y = r.bottom;
					deco.SetDeep(0);
				}
				else
				{
					y = decoTemp.Y;
					deco.SetDeep(1-(decoTemp.Y - r.top) / (r.height));
				}
				deco.SetPos(x, y);
				AddNewDecorate(deco);
				deco.SaveInfo();
				//deco.removeAllEvent();
			}
			
			if (!hasBackground)
			{
				var defBgr:Object = getDefaultBgrFromStore();
				initBackGround(defBgr);
			}
		}
			
		public function AddNewDecorate(obj:Decorate):void
		{
			var i:int, j:int;
			var deco:Decorate;
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var decoArr:Array = GetDecoArr();
			var vt:int = -1;
			
			obj.UpdateDeep();
			vt = decoArr.indexOf(obj);
			if (vt >= 0)
			{
				decoArr.splice(vt, 1);
			}
			decoArr.push(obj);
			
			if (decoArr.length <= 1)
			{
				return;
			}

			// sap xep vi tri
			var v1:int; 
			var v2:int;
			for (i = decoArr.length-2; i >= 0; i--)
			{
				deco = decoArr[i] as Decorate;
				deco.ChangeLayer(Constant.OBJECT_LAYER);
				decoArr[i + 1] = deco;
				if (deco.Deep <= obj.Deep)
				{
					v1 = layer.getChildIndex(deco.img);
					v2 = layer.getChildIndex(obj.img);
					if (v1 < v2)
					{
						layer.setChildIndex(obj.img, layer.getChildIndex(deco.img));
					}
					decoArr[i+1] = obj;
					
					return;
				}
			}

			decoArr[0] = obj;
		}
		
		
		public function InitStockThingsArray(data:Object):void
		{
			StockThingsArr = new GetLoadInventory(data);
			GuiMgr.getInstance().GuiSubInvetory.InitInventory(GuiMgr.getInstance().GuiSubInvetory.CurrentShop, GuiMgr.getInstance().GuiSubInvetory.CurrentPage);			
		}
		
		public function initTuiTanThu(isFirst:Boolean=true,data:Object=null):void 
		{
			if (tuiTanThu)
			{
				tuiTanThu.Clear();
				tuiTanThu = null;
			}
			var layer:Layer;
			if (!IsViewer())
			{
				var obj:Object = ConfigJSON.getInstance().GetItemList("NewUserGiftBag");
				
				var i:int = 0;
				var a:int;
				var b:int;
				for (var s:String in obj) 
				{
					if (i == 0)
					{
						a = parseInt(s);		
					}
					i++;
				}
				b = a + i-1;
				
				if (Level >= a && Level <= b && Ultility.IsInMyFish())
				{
					layer = LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER);		
					//layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);		
					tuiTanThu = new TuiTanThu(layer, "", 0, 0);
					tuiTanThu.init(isFirst, data);
				}
			}			
		}
		
		public function InitStore(data:Object):void
		{			
			StockThingsArr = new GetLoadInventory(data);
			
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				// gia lap
				GuiMgr.getInstance().GuiStore.RefreshComponent();	
			}
			arrMaterial = [];
			for (var id:int = 0; id < Constant.NUM_TYPE_MATERIAL; id++)
			{
				var r:int = id % 2;
				var q:int = id / 2 + 1;
				var type:int = q + 100 * r;
				arrMaterial[id] = GetStoreItemCount("Material", type);
			}
			GuiMgr.getInstance().guiMateFish.isReceivedStore = true;
			
			if ("StoreList"in data)
			{
				InitPearlRefine(data.StoreList);	
			}
		}
		
		public function InitStoreSoldier(data:Object):void
		{
			StockThingsArr = new GetLoadInventory(data);
			
			if (GuiMgr.getInstance().GuiStoreSoldier.IsVisible)
			{
				GuiMgr.getInstance().GuiStoreSoldier.RefreshComponent();
			}
		}
		
		public function UpdateStockThing(Type:String, Id:int, num:int = 1):void
		{
			var a:Array;
			if (Type.search("Gem") == -1)
			{
				a = StockThingsArr[Type];
			}
			else
			{
				var arr:Array = Type.split("$");
				a = StockThingsArr[arr[0] + arr[1]];
			}
			
			//add đồ trang trí
			if ((Type == "Other" || Type == "OceanAnimal" || Type == "OceanTree" || Type == "PearFlower" || Type == "BackGround") && num > 0)
			{
				addDeco(Type, Id);
				return;
			}
			
			
			var tg:StockThings;
			var i:int;
			var HasAdd:Boolean = false;
			
			for (i = 0; i < a.length; i++)
			{
				tg = new StockThings();
				tg.SetInfo(a[i]);
				if (tg.ItemType == Type && tg.Id == Id)
				{
					HasAdd = true;
					tg.Num += num;
					a[i]["Num"] = tg.Num;
					if (tg.Num <= 0)
					{
						a.splice(i, 1);
					}
					break;
				}
			}
			
			if ((!HasAdd) && (num > 0))
			{
				var obj:Object = new Object();
				obj["ItemType"] = Type;
				obj[ConfigJSON.KEY_ID] = Id;
				obj["Num"] = num;
				a.push(obj);
			}
		}
		
		/**
		 * Cập nhật thêm trang bị cá lính vào trong kho
		 * @param	equip
		 */
		public function UpdateEquipmentToStore(equip:FishEquipment, isStore:Boolean = true):void
		{
			var a:Array = StockThingsArr[equip.Type];
			var eq:FishEquipment = equip;
			if (isStore)
			{
				a.push(eq);
			}
			else
			{
				a.splice(a.indexOf(eq), 1);
			}
			//trace("isStore== " + isStore + " |a.indexOf(eq)== " + a.indexOf(eq));
		}
		
		public function TotalQuartzStore():int
		{
			var dataEquip:Array = new Array();
			var dataQWhite:Array = new Array();
			var dataQGreen:Array = new Array();
			var dataQYellow:Array = new Array();
			var dataQPurple:Array = new Array();
			var dataQVIP:Array = new Array();
			
			dataQWhite = GetStore('QWhite');
			dataQGreen = GetStore('QGreen');
			dataQYellow = GetStore('QYellow');
			dataQPurple = GetStore('QPurple');
			dataQVIP = GetStore('QVIP');
			dataEquip = dataEquip.concat(dataQWhite, dataQGreen, dataQYellow, dataQPurple, dataQVIP);
			
			return dataEquip.length;
		}
		
		
		/**
		 * Cập nhật thêm Linh Thach cá lính vào trong kho
		 * @param	equip
		 */
		public function UpdateQuartzToStore(equip:FishEquipment, isStore:Boolean = true):void
		{
			var a:Array = StockThingsArr[equip.Type];
			var eq:FishEquipment = equip;
			if (isStore)
			{
				//trace("ghi vao UpdateQuartzToStore()");
				a.push(eq);
			}
			else
			{
				for (var i:int = 0; i < a.length; i++)
				{
					//trace("a[i].Type== " + a[i].Type + " |a[i].Id== " + a[i].Id);
					var arrId:int = a[i].Id;
					var equipId:int = equip.Id;
					if (arrId == equipId)
					{
						//trace("add vao trong arrId== " + arrId + " |equipId== " + equipId);
						a.splice(i, 1);
					}
				}
			}
			//trace("Type== " + equip.Type + " |a.length== " + a.length);
		}
		
		public function getItemStore(type:String, id:int):Object
		{
			var obj:Object = new Object();
			var a:Array = StockThingsArr[type];
			for (var i:int = 0; i < a.length; i++)
			{
				if (a[i].Id == id)
				{
					obj = a[i];
				}
			}
			
			return obj;
		}
		
		/**
		 * Change thông tin của Huy Hiệu trong kho
		 * @param	equip
		 */
		public function ChangeQuartzToStore(type:String, id:int, level:int, point:int):void
		{
			var a:Array = StockThingsArr[type];
			
			for (var i:int = 0; i < a.length; i++)
			{
				if (a[i].Type == type && a[i].Id == id)
				{
					/*trace("Truoc=========== a[i].Level==  " + a[i].Level + " |level== " + level);
					trace("Truoc=========== a[i].Point==  " + a[i].Point + " |point== " + point);
					trace("=========== a[i].Type==  " + a[i].Type + " |type== " + type);
					trace("=========== a[i].Id==  " + a[i].Id + " |id== " + id);*/
					a[i].Level = level;
					a[i].Point = point;
					/*trace("Cap nhap duoc roi=========== a[i].Level==  " + a[i].Level + " |level== " + level);
					trace("Cap nhap duoc roi=========== a[i].Point==  " + a[i].Point + " |point== " + point);*/
				}
			}
		}
		
		/**
		 * Lấy thông tin Công - Thủ - Máu - Chí Mạng của Huy Hiệu
		 * @param	equip
		 */
		public function loadFunctionQuartz(QItemId:int, QType:String, QLevel:int):Object
		{
			/*if (QItemId > 4)
			{
				QItemId = 1;
			}*/
			var obj:Object = new Object();
			//Công
			var Damage:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[QType][QItemId]["Damage"];
			var numDamage:int = 0;
			if (Damage > 0)
			{
				numDamage = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[QType][QItemId]["OptionDamage"];
			}
			obj.Damage = Damage;
			obj.OptionDamage = numDamage;
			
			//Thủ
			var Defence:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[QType][QItemId]["Defence"];
			var numDefence:int = 0;
			if (Defence > 0)
			{
				numDefence = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[QType][QItemId]["OptionDefence"];
			}
			obj.Defence = Defence;
			obj.OptionDefence = numDefence;
			
			//Chí Mạng
			var Critical:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[QType][QItemId]["Critical"];
			var numCritical:int = 0;
			//trace("Critical== " + Critical);
			if (Critical > 0)
			{
				numCritical = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[QType][QItemId]["OptionCritical"];
			}
			//trace("Critical== " + Critical + " |numCritical== " + numCritical);
			obj.Critical = Critical;
			obj.OptionCritical = numCritical;
			
			//Máu
			var Vitality:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[QType][QItemId]["Vitality"];
			var numVitality:int = 0;
			if (Vitality > 0)
			{
				numVitality = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[QType][QItemId]["OptionVitality"];
			}
			obj.Vitality = Vitality;
			obj.OptionVitality = numVitality;
			
			//Nếu Huy Hiệu level lớn hơn 1 sẽ đọc thêm thông tin trong SmashEgg_QuartzLevel
			if (QLevel > 1)
			{
				//trace("tren obj.Damage== " + obj.Damage);
				if (obj.Damage > 0)
				{
					obj.Damage += (ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")[QType][QLevel]["Damage"])*(QLevel - 1);
				}
				
				if (obj.Defence > 0)
				{
					obj.Defence += (ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")[QType][QLevel]["Defence"])*(QLevel - 1);
				}
				
				if (obj.Critical > 0)
				{
					obj.Critical += (ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")[QType][QLevel]["Critical"])*(QLevel - 1);
				}
				
				if (obj.Vitality > 0)
				{
					obj.Vitality += (ConfigJSON.getInstance().GetItemList("SmashEgg_QuartzLevel")[QType][QLevel]["Vitality"])*(QLevel - 1);
				}
				//trace("duoi obj.Damage== " + obj.Damage);
				//trace("QLevel== " + QLevel + " |he so nhan con = " + (QLevel-1));
			}
			
			return obj;
		}
		
		//Add đồ trang trí có hạn
		public function addDeco(itemType:String, itemId:int):void
		{
			var obj:Object = new Object();
			obj["Num"] = 1;
			obj["Id"] = GenerateNextID();
			obj["ItemType"] = itemType;
			obj["ItemId"] = itemId;
			var config:Object = ConfigJSON.getInstance().getItemInfo(itemType, itemId);
			obj["ExpiredTime"] = GameLogic.getInstance().CurServerTime + config["TimeUse"];
			StockThingsArr[itemType].push(obj);
		}
		
		public function GetStoreItemCount(Type:String, Id:int):int
		{
			var a:Array;
			if (Type.search("Gem") == -1)
			{
				a = StockThingsArr[Type];
			}
			else
			{
				var aa:Array = Type.split("$");
				a = StockThingsArr[aa[0] + aa[1]];
			}
			
			var tg:StockThings;
			var i:int;
			for (i = 0; i < a.length; i++)
			{
				tg = new StockThings();
				tg.SetInfo(a[i]);
				if (tg.ItemType == Type && tg.Id == Id)
				{
					return tg.Num;
				}
			}
			
			return 0;
		}
		
		public function GetStore(Type:String):Array
		{
			var tab:Array = StoreTabs[Type];
			var a:Array = [];
			var b:Array = [];
			
			var i:int;
			for (i = 0; i < tab.length; i++)
			{
				//Event ngoc trai
				if (!Treasure.CheckEvent() && (tab[i] == "Icon" || tab[i] == "Key")) continue;
				//Event 2-9
				if (!GameLogic.getInstance().isEventND())
				{
					if (tab[i] == "IconChristmas" || (arrFireworkFish.length == 0 && tab[i] == "Sock"))
					{
						continue;
					}
				}
				//event 8/3
				if (EventMgr.CheckEvent("Event_8_3_Flower")!=EventMgr.CURRENT_IN_EVENT)
				{
					if (tab[i] == "Event_8_3_Flower")
					{
						continue;
					}
				}
				
				if (EventMgr.CheckEvent("MagicPotion") != EventMgr.CURRENT_IN_EVENT)
				{
					if (tab[i] == "Herb" || tab[i] == "HerbPotion")
					{
						continue;
					}
				}
				
				if (EventMgr.CheckEvent("BirthDay") != EventMgr.CURRENT_IN_EVENT)
				{
					if (tab[i] == "BirthDayItem")
					{
						continue;
					}
				}
				if (tab[i] == "OccupyToken")//không cho vẽ ra ngư lệnh trong kho
				{
					continue;
				}
				
				if (EventMgr.CheckEvent("TreasureIsland") != EventMgr.CURRENT_IN_EVENT)
				{
					if (tab[i] == "Island_Item")
					{
						continue;
					}
				}
				
				b = StockThingsArr[tab[i]];
				a = a.concat(b);
			}
			
			// Loại các Gem đã bị "phế" và tán không hiển thị trong store nữa
			if (Type.search("Element") != -1)
			{
				for (i = a.length - 1; i >= 0; i--)
				{
					var c:Array = a[i].ItemType.split("$");
					if (a[i].Id <= 0 || c[2] == 0)
					{
						a.splice(i, 1);
					}
				}
				
			}
			
			return a;
		}
		
		public function UpdateEnergyOntime():void
		{
			var tmp:Number = GameLogic.getInstance().CurServerTime - GetMyInfo().LastEnergyTime;
			var regentime:int = ConfigJSON.getInstance().getConstantInfo("pa_13");
			var cl:int = tmp / regentime;
			var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GetLevel());
			//if (bonusMachine > 0)
			//{
				//maxEnergy = ConfigJSON.getInstance().getMaxEnergy(GetLevel()) + bonusMachine;
			//}
			//else
			//{
				//maxEnergy = ConfigJSON.getInstance().getMaxEnergy(GetLevel());
			//}
			if (MyInfo.bonusMachine <= 0)
			{
				if (cl >= 1)
				{
					UpdateEnergy(cl,false);
					if(GetEnergy() >= maxEnergy)
					{
						SetEnergy(maxEnergy);
					}
					GetMyInfo().LastEnergyTime += (cl * regentime);
				}
				if(GetEnergy() >= maxEnergy)
				{
					GetMyInfo().LastEnergyTime = GameLogic.getInstance().CurServerTime;
					SetEnergy(maxEnergy);
				}
			}
		}
		
		public function UpdateEnergy(dEnergy:Number, hasEffect:Boolean = true):void
		{
			var temp:int;
			//if (!IsViewer())
			//{
				MyInfo.UpdateLogicEnergy(dEnergy);
			//}
			//else
			//{
				//UpdateLogicEnergy(dEnergy);
			//}
			
			//Effect
			if (dEnergy != 0 && hasEffect)
			{
				var child:Sprite = new Sprite();
				var kq:String;
				var color:int = 0xff0000;
				if (dEnergy > 0)
				{
					kq = "+" + dEnergy;
					color = 0x00ff00;
				}
				else
				{
					kq = dEnergy.toString();
				}
				var guiUserInfo:GUIUserInfo= GuiMgr.getInstance().guiUserInfo;
				var pos:Point = new Point(guiUserInfo.txtEnergy.x, guiUserInfo.txtEnergy.y);
				pos = guiUserInfo.img.localToGlobal(pos);
				var txtFormat:TextFormat = new TextFormat("SansationBold", 18, color, true);
				//var txtFormat:TextFormat = new TextFormat("Arial", 18, color, true);
				txtFormat.align = "left";
				txtFormat.font = "SansationBold";
				//txtFormat.font = "Arial";
				child.addChild(Ultility.CreateSpriteText(kq, txtFormat, 6, 0));					
				var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child) as ImgEffectFly;
				eff.SetInfo(pos.x + 20, pos.y + 50, pos.x + 20, pos.y + 5, 3);			
			}
			
			// Kiem tra neu co quest su dung nang luong - longpt
			if ((QuestMgr.getInstance().SpecialTask["useEnergy"] != null) && (dEnergy < 0))
			{
				var stask:TaskInfo = QuestMgr.getInstance().SpecialTask["useEnergy"];
				stask.Num += Math.abs(dEnergy);
				if (stask.Num >= stask.MaxNum)
				{
					stask.Num = stask.MaxNum;
					stask.Status = true;
				}
				
				// Neu hoan thanh quest -> Rung button
				if (QuestMgr.getInstance().isQuestDone() && (!GameLogic.getInstance().user.IsViewer()) && (!QuestMgr.getInstance().isBlink))
				{
					//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(true);
					GuiMgr.getInstance().guiFrontScreen.btnDailyQuest.SetBlink(true);
					QuestMgr.getInstance().isBlink = true;
				}
			}
			
			var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GetLevel());
			//GuiMgr.getInstance().guiFrontScreen.updateEnergy(GetEnergy(), maxEnergy);
			GuiMgr.getInstance().guiUserInfo.energy = GetEnergy();
		}
		/**
		 * 
		 * @param	dFood
		 */
		public function UpdateFoodCount(dFood:int):void
		{
			MyInfo.FoodCount += dFood;
			if (!IsViewer())
			{
				FoodCount += dFood;
			}
		}
		
		public function GetFoodCount(IsMine:Boolean = true):int
		{
			if (IsMine)
			{
				return MyInfo.FoodCount;
			}
			
			return FoodCount;
		}
		
		public function GetLevel(IsMine:Boolean = true):int
		{
			if (IsMine)
			{
				return MyInfo.Level;
			}
			
			return Level;
		}
		
		public function GetExp(IsMine:Boolean = true):int
		{
			if (IsMine)
			{
				return MyInfo.Exp;
			}
			
			return Exp;
		}
		
		public function GetMoney(IsMine:Boolean = true):Number
		{
			if (IsMine)
			{
				return MyInfo.Money;
			}
			
			return Money;
		}
		
		public function GetZMoney(IsMine:Boolean = true):int
		{
			if (IsMine)
			{
				return MyInfo.ZMoney;
			}
			
			return ZMoney;
		}
		
		public function UpdateUserZMoney(dMoney:int, hasEffect:Boolean = true, pX:int = 0):void
		{
			MyInfo.ZMoney += dMoney;
			if (!IsViewer())
			{
				ZMoney += dMoney;
			}
			
			// Effect
			if (dMoney != 0 && hasEffect)
			{
				var txtFormat:TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
				txtFormat.align = "left";
				txtFormat.font = "SansationBold";
				var st:String;
				if (dMoney > 0)
				{
					st = "+" + Ultility.StandardNumber(dMoney);
					txtFormat.color = 0x00FF00;  //Cộng tiền thì màu xanh
				}
				else
				{
					st = Ultility.StandardNumber(dMoney);
					txtFormat.color = 0x00FF00;  //Trừ tiền thì màu đỏ
				}
		
				var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E/*, true*/);
				
				var guiUserInfo:GUIUserInfo = GuiMgr.getInstance().guiUserInfo;
				var pos:Point = new Point(guiUserInfo.txtZMoney.x, guiUserInfo.txtZMoney.y);
				pos = guiUserInfo.img.localToGlobal(pos);
				var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
				if (pX == 0)	eff.SetInfo(pos.x + guiUserInfo.txtZMoney.width, pos.y + 30, pos.x - 25, pos.y + 30, 7);
				else	eff.SetInfo(pX + guiUserInfo.txtZMoney.width, pos.y + 15, pX - 25, pos.y + 15, 7);
				//Update thông tin tiền trên guishop
				if (GuiMgr.getInstance().GuiShop.IsVisible)
				{
					GuiMgr.getInstance().GuiShop.txtXu.text = Ultility.StandardNumber(GetZMoney());
				}
				
				/*if (GuiMgr.getInstance().guiBuyHammerSaleOff.IsVisible)
				{
					GuiMgr.getInstance().guiBuyHammerSaleOff.txtZMoneyUser.text = Ultility.StandardNumber(GetZMoney());
				}*/
			}
			if (GuiMgr.getInstance().guiUserInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserInfo.zMoney = GetZMoney();
			}
			if (GuiMgr.getInstance().guiUserEventInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserEventInfo.zMoney = GetZMoney();
			}
			if (GuiMgr.getInstance().guiUserTrungLinhThachInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserTrungLinhThachInfo.zMoney = GetZMoney();
			}
		}
		
		public function SetUserZMoney(num:int):void
		{
			MyInfo.ZMoney = num;
			if (!IsViewer())
			{
				ZMoney = num;
			}
			//Update thông tin tiền trên guishop
			if (GuiMgr.getInstance().GuiShop.IsVisible)
			{
				GuiMgr.getInstance().GuiShop.txtXu.text = Ultility.StandardNumber(GetZMoney());					
			}
			
			if (GuiMgr.getInstance().guiUserInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserInfo.zMoney = GetZMoney();
			}
			if (GuiMgr.getInstance().guiUserEventInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserEventInfo.zMoney = GetZMoney();
			}
			if (GuiMgr.getInstance().guiUserTrungLinhThachInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserTrungLinhThachInfo.zMoney = GetZMoney();
			}
		}
		
		public function GetEnergy(IsMine:Boolean = true):Number
		{
			var maxEnergy:int;
			if (MyInfo.bonusEnergy > 0)
			{
				maxEnergy = ConfigJSON.getInstance().getMaxEnergy(GetLevel()) + MyInfo.bonusEnergy;
			}
			else
			{
				maxEnergy = ConfigJSON.getInstance().getMaxEnergy(GetLevel());
			}
			if (IsMine)
			{
				if (MyInfo.Energy > maxEnergy)
				{
					return MyInfo.Energy;
				}
				else
					return MyInfo.Energy + MyInfo.bonusMachine;
			}
			return Energy + MyInfo.bonusMachine;
		}
		
		public function SetEnergy(energy:Number, IsMine:Boolean = true):void
		{
			var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GetLevel());
			if(IsMine)
			{
				if (energy > MyInfo.Energy)
				{
					if (energy > MyInfo.Energy + MyInfo.bonusEnergy)
					{
						MyInfo.bonusMachine = energy - MyInfo.Energy + MyInfo.bonusEnergy;
					}
					else 
					{
						MyInfo.bonusEnergy = 0;
						MyInfo.bonusMachine = energy - MyInfo.Energy;
					}
				}
				else 
				{
					MyInfo.bonusEnergy = 0;
					MyInfo.bonusMachine = 0;
					MyInfo.Energy = energy;
				}
				
				//if (GuiMgr.getInstance().guiFrontScreen.IsVisible)
				//{
					//GuiMgr.getInstance().guiFrontScreen.updateEnergy(GetEnergy(), maxEnergy);
				//}
				if (GuiMgr.getInstance().guiUserInfo.IsVisible)
				{
					GuiMgr.getInstance().guiUserInfo.energy = GetEnergy();
				}
			}
			if (!IsViewer())
			{
				Energy = MyInfo.Energy;
				bonusMachine = MyInfo.bonusMachine;
				bonusEnergy = MyInfo.bonusEnergy;
			}
		}
		
		public function SetUserMoney(money:int):void
		{
			MyInfo.Money = money;
			if (!IsViewer())
			{
				Money = money;
			}
			
			if (GuiMgr.getInstance().guiUserInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserInfo.money = GetMoney();
			}

		}
		
		public function setDiamond(num:int):void
		{
			MyInfo.Diamond = num;
			if (GuiMgr.getInstance().guiUserInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserInfo.diamond = getDiamond();
			}
			if (GuiMgr.getInstance().guiUserEventInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserEventInfo.diamond = getDiamond();
			}
			if (GuiMgr.getInstance().guiUserTrungLinhThachInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserTrungLinhThachInfo.diamond = getDiamond();
			}
		}
		
		public function updateDiamond(num:int, pX:int = 0):void
		{
			MyInfo.Diamond += num;
			
			// Effect
			if (num != 0)
			{
				var txtFormat:TextFormat = new TextFormat("Arial", 16, 0xffffff, true);
				txtFormat.align = "left";
				txtFormat.font = "SansationBold";
				var st:String;
				if (num > 0)
				{
					st = "+" + Ultility.StandardNumber(num);
					txtFormat.color = 0xff00ff; 
				}
				else
				{
					st = Ultility.StandardNumber(num);
					txtFormat.color = 0xff00ff;// 0xff0000;
				}
		
				var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E/*, true*/);
				
				var guiUserInfo:GUIUserInfo = GuiMgr.getInstance().guiUserInfo;
				var pos:Point = new Point(guiUserInfo.txtDiamond.x, guiUserInfo.txtDiamond.y);
				pos = guiUserInfo.img.localToGlobal(pos);
				var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
				if (pX == 0)	eff.SetInfo(pos.x + guiUserInfo.txtDiamond.width, pos.y + 30, pos.x - 25, pos.y + 30, 7);
				else eff.SetInfo(pX + guiUserInfo.txtDiamond.width, pos.y + 15, pX - 25, pos.y + 15, 7);
			}
			
			if (GuiMgr.getInstance().guiUserInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserInfo.diamond = getDiamond();
			}
			if (GuiMgr.getInstance().guiUserEventInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserEventInfo.diamond = getDiamond();
			}
			if (GuiMgr.getInstance().guiUserTrungLinhThachInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserTrungLinhThachInfo.diamond = getDiamond();
			}
		}
		
		public function getDiamond():int
		{
			return MyInfo.Diamond;
		}
		
		//public function SetUserLevelMixLake(lvl:int):void
		//{
			//MyInfo.LevelMixLake = lvl;
			//if (!IsViewer())
			//{
				//LevelMixLake = lvl;
			//}
		//}
		
		//public function GetUserLevelMixLake(IsMine:Boolean = true):int
		//{
			//if (IsMine)
			//{
				//return MyInfo.LevelMixLake;
			//}
			//
			//return LevelMixLake;
		//}
		
		public function UpdateUserLicense(num:int):void
		{
			StockThingsArr.License[0].Num += num;
			if (StockThingsArr.License[0].Num == 0)
			{
				StockThingsArr.License.pop();
			}
		}
		
		public function UpdateUserMoney(dMoney:Number, hasEffect:Boolean = true):void
		{
			//MyInfo.Money += dMoney;
			//var eff:ImgEffectBuble = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_BUBLE, GuiMgr.getInstance().GuiTopInfo.txtMoney) as ImgEffectBuble;
			//eff.SetInfo(1, 1.6, 4, 3);
			MyInfo.Money += dMoney;
			if (!IsViewer())
			{
				Money += dMoney;				
			}
			
			// Effect
			if (dMoney != 0 && hasEffect)
			{
				var txtFormat:TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
				txtFormat.align = "left";
				txtFormat.font = "SansationBold";
				var st:String;
				if (dMoney > 0)
				{
					st = "+" + Ultility.StandardNumber(dMoney);
					txtFormat.color = 0xFFFF00;  //Cộng tiền thì màu xanh
				}
				else
				{
					st = Ultility.StandardNumber(dMoney);
					txtFormat.color = 0xFFFF00;  //Trừ tiền thì màu đỏ
				}
		
				var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E/*, true*/);
				
				var guiUserInfo:GUIUserInfo = GuiMgr.getInstance().guiUserInfo;
				var pos:Point = new Point(guiUserInfo.txtMoney.x, guiUserInfo.txtMoney.y);
				pos = guiUserInfo.img.localToGlobal(pos);
				var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
				eff.SetInfo(pos.x + guiUserInfo.txtMoney.width, pos.y + 30, pos.x - 25, pos.y + 30, 7);
				
				//Update thông tin tiền trên guishop
				if (GuiMgr.getInstance().GuiShop.IsVisible)
				{
					GuiMgr.getInstance().GuiShop.txtGold.text = Ultility.StandardNumber(GetMoney());
				}
				
				if (GuiMgr.getInstance().guiUserInfo.IsVisible)
				{
					GuiMgr.getInstance().guiUserInfo.money = GetMoney();
				}
				if (GuiMgr.getInstance().guiUserEventInfo.IsVisible)
				{
					GuiMgr.getInstance().guiUserEventInfo.money = GetMoney();
				}
				if (GuiMgr.getInstance().guiUserTrungLinhThachInfo.IsVisible)
				{
					GuiMgr.getInstance().guiUserTrungLinhThachInfo.money = GetMoney();
				}
			}
			
			// Kiem tra hanh dong neu co quest kiem tien
			if (QuestMgr.getInstance().SpecialTask["earnMoney"] != null)
			{
				var stask:TaskInfo = QuestMgr.getInstance().SpecialTask["earnMoney"];
				stask.Num += dMoney;
				if (stask.Num >= stask.MaxNum)
				{
					stask.Num = stask.MaxNum;
					stask.Status = true;
				}
				
				// Neu hoan thanh quest -> Rung button
				if (QuestMgr.getInstance().isQuestDone() && (!GameLogic.getInstance().user.IsViewer()) && (!QuestMgr.getInstance().isBlink))
				{
					//GuiMgr.getInstance().GuiTopInfo.btnDailyQuestNew.SetBlink(true);
					GuiMgr.getInstance().guiFrontScreen.btnDailyQuest.SetBlink(true);
					QuestMgr.getInstance().isBlink = true;
				}

			}
		}
		
		
		/**
		 * Gọi trong trường hợp kinh nghiệm được cộng sau khi nhận gói tin 1 khoảng thời gian nào đó
		 */
		public function ExpWillBeAddLater():void
		{
			if (numWaitProcessExp < 0)
				numWaitProcessExp = 0;
			numWaitProcessExp++;
		}
		
		/**
		 * Gọi khi kinh nghiệm đã được cộng sau khi delay 1 khoảng thời gian bằng lời gọi hàm ExpWillBeAddLater();
		 */
		public function ExpWasAdded():void
		{
			numWaitProcessExp --;
			if (numWaitProcessExp < 0)
				numWaitProcessExp = 0;
		}
		
		/**
		 * Hàm thực hiện set kinh nghiệm cho user
		 * Hiện tại 
		 * @param	exp						:	Kinh nghiệm set cho user
		 * @param	isInEventDuplicateExp	:	Có nhân đôi kinh nghiệm được thêm không
		 * @param	isAddExpAfterServer		:	= true khi set exp sau khi nhận gói tin từ server 1 khoảng thời gian nào đó
		 * 										= false khi set exp ngay khi nhận gói tin từ server, hoặc set trước khi gửi gói tin lên server
		 */
		public function SetUserExp(exp:int, isInEventDuplicateExp:Boolean = false, isAddExpAfterServer:Boolean = false):void
		{	
			var xp:int = exp - MyInfo.Exp;			
			if (isInEventDuplicateExp)	
			{
				if (GameLogic.getInstance().checkEventDuplicateExp())
				{
					exp = exp + xp;
					xp = 2 * xp;
				}
			}
			MyInfo.Exp = exp;			
			if (!IsViewer())
			{		
				Exp = exp;
			}
			
			if(isAddExpAfterServer)
			{
				ExpWasAdded();
			}
			
			if (GameLogic.getInstance().CheckLevelUp(MyInfo.Exp, MyInfo.Level) 
				&& allowLevelUp 
				&& numWaitProcessExp <= 0 
				&& Ultility.IsInMyFish()
				&& LeagueController.getInstance().mode == LeagueController.IN_HOME
				&& GameController.getInstance().gameMode != GameController.GAME_MODE_BOSS_SERVER)
			{		
				allowLevelUp = false;
				GameLogic.getInstance().DoLevelUp();
				SetUserLevel(MyInfo.Level + 1);
			}
			
			// Effect
			if (xp > 0)
			{
				var st:String = "+" + Ultility.StandardNumber(xp);
				var txtFormat :TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
				txtFormat.color = 0x00FFFF;
				txtFormat.font = "SansationBold";
				txtFormat.align = "left"
				var tmp1:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x293661/*, true*/);
				
				var guiUserInfo:GUIUserInfo = GuiMgr.getInstance().guiUserInfo;
				var pos:Point = new Point(guiUserInfo.txtExp.x , guiUserInfo.txtExp.y);
				pos = guiUserInfo.img.localToGlobal(pos);
				var eff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp1) as ImgEffectFly;
				eff1.SetInfo(pos.x  + guiUserInfo.txtExp.width, pos.y + 30, pos.x - 10, pos.y + 30, 7);
			}
			
			if (GuiMgr.getInstance().guiUserInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserInfo.exp = GetExp();
			}
			if (GuiMgr.getInstance().guiUserEventInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserEventInfo.exp = GetExp();
			}
			if (GuiMgr.getInstance().guiUserTrungLinhThachInfo.IsVisible)
			{
				GuiMgr.getInstance().guiUserTrungLinhThachInfo.exp = GetExp();
			}
		}		
		
		public function PlusEnergy(energy: Number): void
		{
			var st:String = "+" + Ultility.StandardNumber(energy);
			var txtFormat :TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
			txtFormat.color = 0xF6A921;
			txtFormat.font = "SansationBold";
			txtFormat.align = "left"
			var tmp1:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x293661, true);
			
			UpdateEnergy(energy);
			
			var guiUserInfo:GUIUserInfo = GuiMgr.getInstance().guiUserInfo;
			var pos:Point = new Point(guiUserInfo.txtEnergy.x , guiUserInfo.txtEnergy.y);
			pos = guiUserInfo.img.localToGlobal(pos);
			var eff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp1) as ImgEffectFly;
			eff1.SetInfo(pos.x, pos.y + 30, pos.x - 10, pos.y + 30, 7);
		}
		
		public function SetUserLevel(level:int):void
		{
			MyInfo.Level = level;
			ShowFishMachineButton();
			ShowMapOceanButton();
			
			if (!IsViewer())
			{
				Level = level;
				if (GuiMgr.getInstance().guiUserInfo.IsVisible)
				{
					GuiMgr.getInstance().guiUserInfo.level = level;
				}
			}
		}
		
		public function SetLakeInfo(data:Object):void
		{
			var i:int;
			var m:int;
			var j:String;
			var n:String;
			var arrLake:Array = data.InforLake;
			var count:int;
			var ElementList:Object = GameLogic.getInstance().user.ElementList;
			for (var s1:String in ElementList)
			{
				delete(ElementList[s1]);
			}
			
			AllFishArr = [];
			for (i = 0; i < arrLake.length; i++)
			{
				var lake:Lake = GetLake(arrLake[i].Id)				
				lake.Level = arrLake[i].Level;
				//lake.ElementList = [];
				if (lake.Option == null)
				{
					lake.Option = new Object();
				}
				lake.Option[Fish.OPTION_MIX_RARE] = 0;
				lake.Option[Fish.OPTION_MONEY] = 0;
				lake.Option[Fish.OPTION_EXP] = 0;
				lake.Option[Fish.OPTION_TIME] = 0;
				//Đoạn này chỉ là kiểm tra lại trong trường hợp server trả về level hồ lớn hơn max level
				//Nếu lớn hơn max level không lấy được dữ liệu trong file config và dẫn tới lỗi truy cập ngoài mảng
				if (lake.Level > lake.MaxLevel)
					lake.Level = lake.MaxLevel;
				else if (lake.Level < 1)
					lake.Level = 1;
				lake.CurCapacity = lake.LakeLevels[lake.Level - 1]["TotalFish"];
				
				count = 0;
				for (j in arrLake[i].FishList)
				{
					if (arrLake[i].FishList[j].FishType == Fish.FISHTYPE_SOLDIER)	continue;
					count++;
					arrLake[i].FishList[j]["LakeId"] = arrLake[i].Id;
					AllFishArr.push(arrLake[i].FishList[j]);					
					for (var s: String in arrLake[i].FishList[j].RateOption)
					{
						var rate:int = arrLake[i].FishList[j].RateOption[s];
						lake.Option[s] += rate;
					}
				}
				// Cập nhật lại buff cho các đồ trang trí
				for (var ii:int = 0; ii < DecoArr.length; ii++) 
				{
					var deco:Decorate = DecoArr[ii] as Decorate;
					if ((deco.img != null) && (deco.img.visible))
					{
						for (var jstr:String in deco.Option) 
						{
							lake.Option[jstr] += deco.Option[jstr];
						}
					}
				}
				// Cập nhật lại option với các con cá sparta
				for (m = 0; m < FishArrSpartan.length; m++)
					for (n in FishArrSpartan[m].RateOption)
					{
						var rateSparta:int = FishArrSpartan[m].RateOption[n];
						lake.Option[n] += rateSparta;
					}
					
				lake.NumFish = count;
				
				//Cap nhat voi firework fish
				for each(var fireworkFish:FireworkFish in arrFireworkFish)
				{
					if (fireworkFish.Emotion != FireworkFish.DEAD)
					{
						for (n in fireworkFish.RateOption)
						{
							var rateFirework:int = fireworkFish.RateOption[n];
							lake.Option[n] += rateFirework;
						}
					}
				}
				
				// Kiểm tra số hệ cá lính có trong hồ
				count = 0;
				for (j in arrLake[i].FishList)
				{
					if (arrLake[i].FishList[j]["FishType"] != Fish.FISHTYPE_SOLDIER)	continue;
					count++;
					if (!ElementList[arrLake[i].FishList[j]["Element"]])
					{
						ElementList[arrLake[i].FishList[j]["Element"]] = 1;
					}
					else
					{
						ElementList[arrLake[i].FishList[j]["Element"]] += 1;
					}
				}
				lake.NumSoldier = count;
			}
			Exchange.GetInstance().Send(new SendGetBuffLake());
			
			//if(GuiMgr.getInstance().GuiMixFish.IsVisible)
			//{
				//GuiMgr.getInstance().GuiMixFish.InitFishList(AllFishArr);
			//}
			//if(GuiMgr.getInstance().GuiMateFish.IsVisible)
			//{
				//GuiMgr.getInstance().GuiMateFish.ReceivedTotalFish = true;
				//GuiMgr.getInstance().GuiMateFish.InitFishlist(AllFishArr);
			//}
		}
		
		public function RecieveDailyQuestGift(idQuest:int):void
		{
			var quest:QuestInfo = QuestMgr.getInstance().GetDailyQuest(idQuest);
			var task:TaskInfo = quest.TaskList[0] as TaskInfo;
			//var questBonus:QuestBonus = QuestINI.getInstance().GetBonusDailyQuest(idQuest, task.Level, task.BonusId);
			var questBonus:QuestBonus = ConfigJSON.getInstance().GetBonusDailyQuest(idQuest, task.Level, task.BonusId);
			switch (questBonus.ItemType)
			{
				case "Money":
					UpdateUserMoney(questBonus.Num);
					break;
				
				case "Exp":			
					SetUserExp(MyInfo.Exp + questBonus.Num, GameLogic.getInstance().isEventDuplicateExp);					
					break;			
					
				case "Food":
					UpdateFoodCount(5 * questBonus.Num);
					break;
				case "Material":
					GuiMgr.getInstance().GuiStore.UpdateStore(questBonus.ItemType, questBonus.ItemId, questBonus.Num);
					break;
			}
			
			QuestMgr.getInstance().RemoveDailyQuest(idQuest);
			//GuiMgr.getInstance().GuiDailyQuest.RefreshComponent();
			//GuiMgr.getInstance().GuiDailyQuest.Init(0);
		}
		
		/**
		 * Hàm add quà tặng cho người chơi hoàn thành nhiệm vụ
		 * @author 	longpt
		 * @param	idQuest
		 */
		public function ReceiveDailyQuestGiftNew(BonusList:Object):void
		{
			var bonusSure:Object = BonusList["Sure"];
			for (var i:String in bonusSure)
			{
				switch (bonusSure[i].ItemType)
				{
					case "Money":
						UpdateUserMoney(bonusSure[i].Num);
						break;
					case "Exp":
						SetUserExp(MyInfo.Exp + bonusSure[i].Num, GameLogic.getInstance().isEventDuplicateExp);
						break;
				}
			}
			if (BonusList["Lucky"] != null)
			{
				var bonusLucky:Array = BonusList["Lucky"];
				for (var j:int = 0; j < bonusLucky.length; j++)
				{
					switch (bonusLucky[j].ItemType)
					{
						case "Money":
							UpdateUserMoney(bonusLucky[j].Num);
							break;
						case "Exp":
							SetUserExp(MyInfo.Exp + bonusLucky[j].Num, GameLogic.getInstance().isEventDuplicateExp);
							break;
						case "Material":
							GuiMgr.getInstance().GuiStore.UpdateStore(bonusLucky[j].ItemType, bonusLucky[j].ItemId, bonusLucky[j].Num);
							break;
						case "Ring":
							GenerateNextID();
							break;
						case "Sparta":
						case "Superman":
							GenerateNextID();
							GameLogic.getInstance().user.StockThingsArr.numSparta ++;
							if (GuiMgr.getInstance().GuiStore.IsVisible) 
							{
								GuiMgr.getInstance().GuiStore.Hide();
							}
							GuiMgr.getInstance().GuiStore.UpdateStore("BabyFish", bonusLucky[j].ItemId, 1);							
							break;
					}
				}
			}
		}
		
		// Update về mặt hiển thị
		public function UpdateInfo():void
		{			
			// Update money
			//var tmp:Number;
			//if (MyInfo.VarMoney > 0)
			//{				
				//tmp = MyInfo.VarMoney / 4;
				//MyInfo.Money += Math.ceil(tmp);
				//MyInfo.VarMoney = MyInfo.VarMoney - MyInfo.VarMoney / 4;
			//}
			//else if (MyInfo.VarMoney < 0)
			//{
				//tmp = MyInfo.VarMoney / 4;
				//MyInfo.Money += Math.floor(tmp);
				//MyInfo.VarMoney = MyInfo.VarMoney - MyInfo.VarMoney / 4;
			//}
		}
		
		// lay nhung cai ho co the unlock ra
		public function GetUnlockLakeList():Array
		{
			var _a:Array = [];
			var i:int;
			var lake:Lake;
			for (i = 0; i < LakeArr.length; i++)
			{
				lake = LakeArr[i] as Lake;
				if (lake.Level <= 0)
				{
					var _o:Object = new Object();
					_o[ConfigJSON.KEY_ID] = lake.Id;
					_o["LevelRequire"] = lake.LakeLevels[0]["LevelRequire"];
					_o["Money"] = lake.LakeLevels[0]["Money"];
					_o["ZMoney"] = lake.LakeLevels[0]["ZMoney"];
					_o["Exp"] = lake.LakeLevels[0]["Exp"];
					_o["TotalFish"] = lake.LakeLevels[0]["TotalFish"];
					_o["type"] = "LakeUnlock";
					_o[ConfigJSON.KEY_NAME] = "Mua hồ";
					_a.push(_o);
					return _a;
				}
			}
			return _a;
		}
		
		// lay nhung cai ho co the unlock ra
		public function GetUpgradeLakeList():Array
		{
			var i:int;
			var _a:Array = [];
			var lake:Lake;
			
			for (i = 0; i < LakeArr.length; i++)
			{
				lake = LakeArr[i] as Lake;
				if ((lake.Level > 0) && (lake.Level < lake.MaxLevel))
				{
					var _o:Object = new Object();
					_o[ConfigJSON.KEY_ID] = lake.Id;
					_o["LevelRequire"] = lake.LakeLevels[lake.Level]["LevelRequire"];
					_o["Money"] = lake.LakeLevels[lake.Level]["Money"];
					_o["ZMoney"] = lake.LakeLevels[lake.Level]["ZMoney"];
					_o["Exp"] = lake.LakeLevels[lake.Level]["Exp"];
					_o["TotalFish"] = lake.LakeLevels[lake.Level]["TotalFish"];
					_o[ConfigJSON.KEY_NAME] = "Mở rộng hồ";
					_o["type"] = "LakeUpgrade";					
					_a.push(_o);
				}
			}

			return _a;
		}
		
		// update tutoriorial cho vet ban
		public function UpdateDirtyHelper():void
		{
			var i:int;
			for (i = 0; i < DirtyArr.length; i++)
			{
				var dirty:Dirty = DirtyArr[i] as Dirty;
				dirty.HelperName = "Dirty";
				HelperMgr.getInstance().SetHelperData(dirty.HelperName, dirty.img);
				break;
			}
		}
		
		
		public function UpdatePearlRefine():void 
		{
			if(!IsViewer())
			{
				if (pearlMgr)
				{
					pearlMgr.Update();
				}
			}
			
		}
		
		// update tutorial cho vet ban
		public function UpdateFishHelper(action:String):void
		{
			var i:int;
			var fish:Fish;
			var fs:FishSoldier;
			switch (action)
			{
				case "Monster1":
					if (!Ultility.IsInMyFish() && !GuiMgr.getInstance().GuiIntroOcean.IsVisible && FishSoldierArr != null && FishSoldierArr.length > 0)
					{
						fs = FishSoldierArr[0];
						fs.HelperName = action;
						HelperMgr.getInstance().SetHelperData(fs.HelperName, fs.img);
					}
					break;
				case "soldier1":
					if (FishSoldierArr != null && FishSoldierArr.length > 0)
					{
						fs = FishSoldierArr[0];
						fs.SetMovingState(Fish.FS_IDLE);
						fs.HelperName = action;
						HelperMgr.getInstance().SetHelperData(fs.HelperName, fs.img);
					}
					break;
				case "cure":
					if (GameLogic.getInstance().gameState == GameState.GAMESTATE_CURE_FISH)
					{						
						for (i = 0; i < FishArr.length; i++)
						{
							fish = FishArr[i] as Fish;
							if (fish.Emotion == Fish.ILL)
							{
								fish.HelperName = action;
								HelperMgr.getInstance().SetHelperData(fish.HelperName, fish.img);
								fish.SetMovingState(Fish.FS_IDLE);
								break;
							}
						}
					}
					else
					{
						HelperMgr.getInstance().ClearHelper(action);
						for (i = 0; i < FishArr.length; i++)
						{
							fish = FishArr[i] as Fish;
							if (fish.HelperName != "")
							{
								fish.HelperName = "";
								fish.SetMovingState(Fish.FS_SWIM);
							}
						}
					}
					break;
				case "addMaterialIntoFish":
				{
					if (GameLogic.getInstance().gameState == GameState.GAMESTATE_ADD_MATERIAL_FOR_FISH)
					{
						for (i = 0; i < FishArr.length; i++)
						{
							fish = FishArr[i] as Fish;
							fish.HelperName = action;
							HelperMgr.getInstance().SetHelperData(fish.HelperName, fish.img);
							fish.SetMovingState(Fish.FS_IDLE);
							break;
						}
					}
					else
					{
						HelperMgr.getInstance().ClearHelper(action);
					}
				}
				break;
				case "feed":
					if (GameLogic.getInstance().gameState == GameState.GAMESTATE_FEED_FISH)
					{
						//var img:Sprite = GuiMgr.getInstance().GuiCharacter.img;
						var img:Sprite = GameController.getInstance().blackHole.img;
						HelperMgr.getInstance().SetHelperData(action, img);
					}
					else
					{
						HelperMgr.getInstance().ClearHelper(action);
					}
					break;
				case "sell":
					if (GameLogic.getInstance().gameState == GameState.GAMESTATE_SELL_FISH)
					{	
						var hasGrowth:Boolean = false;
						for (i = 0; i < FishArr.length; i++)
						{
							fish = FishArr[i] as Fish;
							if (fish.Growth() >= 1)
							{
								hasGrowth = true;								
								fish.HelperName = action;
								HelperMgr.getInstance().SetHelperData(fish.HelperName, fish.img);
								fish.SetMovingState(Fish.FS_IDLE);
								break;
							}
							
						}
						
						if (!hasGrowth)
						{
							fish = FishArr[0] as Fish;
							if (fish != null)
							{
								fish.HelperName = action;
								HelperMgr.getInstance().SetHelperData(fish.HelperName, fish.img);
								fish.SetMovingState(Fish.FS_IDLE);
							}
						}
					}
					else
					{
						HelperMgr.getInstance().ClearHelper(action);						
					}
					break;
				case "recoverHealthSoldier":
					if (GameLogic.getInstance().user.IsViewer())
					{
						HelperMgr.getInstance().FindHelper("InventoryTool").InviHelper(true);
						break;
					}
					var fsArr:Array;
					if (!GameLogic.getInstance().user.IsViewer() && Ultility.IsInMyFish())
					{
						fsArr = GameLogic.getInstance().user.FishSoldierArr;
					}
					else
					{
						fsArr = GameLogic.getInstance().user.FishSoldierActorMine;
					}
					if (GameLogic.getInstance().gameState == GameState.GAMESTATE_RECOVER_HEALTH_SOLDIER)
					{
						var isChosen:Boolean = false;
						for (i = 0; i < fsArr.length; i++)
						{
							if (fsArr[i].Health < fsArr[i].MaxHealth)
							{
								isChosen = true;
								fsArr[i].HelperName = action;
								HelperMgr.getInstance().SetHelperData(fsArr[i].HelperName, fsArr[i].img);
								fsArr[i].SetMovingState(Fish.FS_IDLE);
								break;
							}
						}
						
						if (!isChosen)
						{
							fs = fsArr[0] as FishSoldier;
							if (fs)
							{
								fs.HelperName = action;
								HelperMgr.getInstance().SetHelperData(fs.HelperName, fs.img);
								fs.SetMovingState(Fish.FS_IDLE);
							}
						}
					}
					else
					{
						for (i = 0; i < fsArr.length; i++)
						{
							if (fsArr[i].HelperName == action)
							{
								fsArr[i].SetMovingState(Fish.FS_SWIM);
							}
						}
						HelperMgr.getInstance().ClearHelper(action);
					}
					break;
				case "visitFriend":
					if (GameLogic.getInstance().user.IsViewer())
					{
						GuiMgr.getInstance().GuiFriends.icHelper.img.visible = false;
					}
					else
					{
						GuiMgr.getInstance().GuiFriends.icHelper.img.visible = true;
					}
					break;
			}
			
		}
		
		
		public function PlayFish(x:int, y:int):void
		{
			if (GuiMgr.getInstance().GuiFishInfo.IsVisible) return;
			var fish:Fish;
			
			//var clickPos:Point = Ultility.PosScreenToLake(x, y);
			var clickPos:Point = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).globalToLocal(new Point(x, y));
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffWave", null, clickPos.x, clickPos.y);	
			//EffectMgr.rippler.drawRipple(100, 0, 10, 1);
			for (var i:int = 0; i <  FishArr.length; i++ )
			{
				fish = FishArr[i] as Fish;
				if (fish != null && fish.IsHide == false && !fish.IsEgg)
				{
					if (Point.distance(fish.CurPos, clickPos) < 120)
					{
						var pos:Point = new Point;// = fish.CurPos.subtract(clickPos);
						if (fish.CurPos.x < clickPos.x)
						{
							pos.x = fish.CurPos.x - Ultility.RandomNumber(200, 400);
						}
						else
						{
							pos.x = fish.CurPos.x + Ultility.RandomNumber(200, 400);
						}
						pos.y = fish.CurPos.y + Ultility.RandomNumber( -100, 100);
						//pos = fish.CurPos.add(pos);					
						var speed:Number = Ultility.RandomNumber(5, 8);
						fish.SwimTo(pos.x, pos.y, speed);
						GameLogic.getInstance().FishChatting(Constant.CHAT_PLAY_FISH, 5000, 2, fish);
					}
				}
			}
		}
		
		/**
		 * Cập nhật havest time cá trong hồ
		 */
		public function UpdateHavestTime(): void
		{
			var i: int, j: int;
			var fish: Fish;
			for (i = 0;  i < FishArr.length; i++ )
			{
				fish = FishArr[i] as Fish;
				fish.HarvestTime = ConfigJSON.getInstance().getFishHarvest(fish.FishTypeId, fish.FishType, fish);
				fish.HarvestTime = fish.HarvestTime * (1-Math.min(CurLake.Option["Time"],Constant.MAX_BUFF_TIME) / 100);
				//fish.AgeTime = ConfigJSON.getInstance().getFishHarvest(fish.FishTypeId, fish.FishType, fish, true);
				//fish.AgeTime = fish.HarvestTime * (1 - Math.min(CurLake.Option["Time"], 50) / 100);
				//if (fish.NumUpLevel && fish.NumUpLevel > 0 && fish.FishType != Fish.FISHTYPE_NORMAL)
				//{
					//fish.HarvestTime = fish.AgeTime;
				//}
			}
			
			for (i = 0;  i < FishSoldierArr.length; i++ )
			{
				fish = FishSoldierArr[i] as FishSoldier;
				fish.HarvestTime = ConfigJSON.getInstance().getFishHarvest(fish.FishTypeId, fish.FishType, fish);
				fish.HarvestTime = fish.HarvestTime * (1-Math.min(CurLake.Option["Time"],50) / 100);
				//fish.AgeTime = ConfigJSON.getInstance().getFishHarvest(fish.FishTypeId, fish.FishType, fish, true);
				//fish.AgeTime = fish.HarvestTime * (1 - Math.min(CurLake.Option["Time"], 50) / 100);
				//if (fish.NumUpLevel && fish.NumUpLevel > 0 && fish.FishType != Fish.FISHTYPE_NORMAL)
				//{
					//fish.HarvestTime = fish.AgeTime;
				//}
			}
		}
		
		/**
		 * Hàm update lại option của curlake với object vào là các buff, reset -> update (chỉ áp dụng khi liên quan đến deco có buff do tốn performance)
		 * @param	type: = -1 nếu cá bị ra khỏi hồ
		 * @param	obj: là object chứa các tham số buff
		 */
		public function UpdateOptionCurLake(): void
		{
			CurLake.Option = new Object();
			CurLake.Option.Time = 0;
			CurLake.Option.Exp = 0;
			CurLake.Option.Money = 0;
			CurLake.Option.MixFish = 0;
			var i:int = 0;
			for (i = 0; i < FishArr.length; i++) 
			{
				UpdateOptionLakeObject(1, (FishArr[i] as Fish).RateOption, CurLake.Id);
			}
			for (i = 0; i < FishArrSpartan.length; i++) 
			{
				UpdateOptionLakeObject(1, (FishArrSpartan[i] as FishSpartan).RateOption, CurLake.Id);
			}
			for (i = 0; i < DecoArr.length; i++) 
			{
				var deco:Decorate = DecoArr[i] as Decorate;
				if ((deco.img != null) && (deco.img.visible))
				{
					for (var j:String in deco.Option) 
					{
						CurLake.Option[j] += deco.Option[j];
					}
				}
			}
			if (buffTimeAllLake)
			{
				if (!buffTimeAllLake[CurLake.Id.toString()])
				{
					buffTimeAllLake[CurLake.Id.toString()] = new Object();
				}
				buffTimeAllLake[CurLake.Id.toString()] = CurLake.Option;
			}
			//Update lại hiển thị thông tin buff của hồ
			//GuiMgr.getInstance().GuiTopInfo.updateBuffLakeInfo();//HiepNM2 bỏ buff của hồ
			GuiMgr.getInstance().GuiMain.addTipBuffLake(buffTimeAllLake);
			UpdateHavestTime();
		}
		
		/**
		 * Hàm update lại option của curlake khi thêm cá, bán cá, chuyển cá....
		 * @param	type: = -1 nếu cá bị ra khỏi hồ
		 * @param	fish: = 1 nếu cá được thêm vào hồ
		 */
		//public function UpdateOptionLake(type: int, fish: Fish): void
		//{
			//if (fish.FishType == Fish.FISHTYPE_NORMAL) return;
			//for (var s: String in fish.RateOption)
			//{
				//if (s != "MixFish")
				//{
					//if (CurLake.Option == null)	CurLake.Option = new Object();
					//if (CurLake.Option[s] == null)	CurLake.Option[s] = 0;
					//CurLake.Option[s] += type * fish.RateOption[s];
				//}
			//}
			//Update lại hiển thị thông tin buff của hồ
			//GuiMgr.getInstance().GuiTopInfo.updateBuffLakeInfo();
			//UpdateHavestTime();
		//}
		
		/**
		 * Hàm update lại option của allLake khi thêm cá, bán cá, chuyển cá...., phục vụ cho việc lai cá
		 * @param	type: = -1 nếu cá bị ra khỏi hồ
		 * @param	fish: = 1 nếu cá được thêm vào hồ
		 */
		//public function UpdateOptionAllLake(obj:Object, lakeFrom:int, lakeTo:int = 0): void
		//{
			//for (var s: String in obj)
			//{
				//if (s != "MixFish")
				//{
					//if(lakeFrom != 0)
					//{
						//buffTimeAllLake[lakeFrom.toString()][s] -= obj[s];
					//}
					//if(lakeTo != -1)
					//{
						//if (!buffTimeAllLake[lakeTo.toString()])
						//{
							//var obj:Object = new Object();
							//buffTimeAllLake[lakeTo.toString()] = obj;
							//if(!buffTimeAllLake[lakeTo.toString()][s])
							//{
								//obj[s] = 0;
							//}
						//}
						//buffTimeAllLake[lakeTo.toString()][s] += obj[s];
					//}
				//}
			//}
			//Update lại hiển thị thông tin buff của hồ
			//GuiMgr.getInstance().GuiTopInfo.updateBuffLakeInfo();
			//UpdateHavestTime();
		//}
		/**
		 * Hàm update lại option của allLake khi thêm cá, bán cá, chuyển cá...., phục vụ cho việc lai cá
		 * @param	type: = -1 nếu cá bị ra khỏi hồ
		 * @param	fish: = 1 nếu cá được thêm vào hồ
		 */
		//public function UpdateOptionAllLakeSparta(fish:FishSpartan, lakeFrom:int = 0, lakeTo:int = 0): void
		//{
			//for (var s: String in fish.RateOption)
			//{
				//if (fish.RateOption[s])
				//{
					//if(lakeFrom != 0)
					//{
						//buffTimeAllLake[lakeFrom.toString()][s] -= fish.RateOption[s];
					//}
					//if(lakeTo != 0)
					//{
						//if (!buffTimeAllLake[lakeTo.toString()])
						//{
							//var obj:Object = new Object();
							//buffTimeAllLake[lakeTo.toString()] = obj;
							//if(!buffTimeAllLake[lakeTo.toString()][s])
							//{
								//obj[s] = 0;
							//}
						//}
						//buffTimeAllLake[lakeTo.toString()][s] += fish.RateOption[s];
					//}
				//}
			//}
			//Update lại hiển thị thông tin buff của hồ
			//GuiMgr.getInstance().GuiTopInfo.updateBuffLakeInfo();
			//UpdateHavestTime();
		//}
		/**
		 * Hàm update lại option của curlake khi thêm cá, bán cá, chuyển cá....
		 * @param	type	: = -1 nếu cá bị ra khỏi hồ, = 1 nếu cá được thêm vào hồ
		 * @param	fish	: 
		 */
		//public function UpdateOptionLakeSparta(type: int, fish: FishSpartan): void
		//{
			//for (var s: String in fish.RateOption)
			//{
				//if(fish.RateOption[s])
				//{
					//if (!CurLake.Option[s])
					//{
						//CurLake.Option[s] = 0;
					//}
					//CurLake.Option[s] += type * fish.RateOption[s];
				//}
			//}
			//Update lại hiển thị thông tin buff của hồ
			//GuiMgr.getInstance().GuiTopInfo.updateBuffLakeInfo();
			//UpdateHavestTime();
		//}
		/**
		 * Hàm update lại option của curlake từ 1 opject
		 * @param	type	: = -1 lakeFrom giảm (hoặc lakeTo tăng), type: = 1 nếu lakeFrom tăng (hoặc lakeTo giảm)
		 * @param	obj		: obj chứa các buff
		 * @param	lakeIdFrom	:	Hồ ban đầu cần tác động, Nếu thả cá thì = -1
		 * @param	lakeIdTo	:	hồ đích đến của đối tượng cần tác động, nếu bán cá thì = -1
		 */
		public function UpdateOptionLakeObject(type: int, obj:Object, lakeIdFrom:int = -1, lakeIdTo:int = -1): void
		{
			var lakeFrom:Lake;
			var lakeTo:Lake;
			var i:int = 0;
			for (i = 0; i < LakeArr.length; i++) 
			{
				if (lakeIdFrom != -1 && lakeIdFrom == (LakeArr[i] as Lake).Id)
				{
					lakeFrom = LakeArr[i];
				}
				if (lakeIdTo != -1 && lakeIdTo == (LakeArr[i] as Lake).Id)
				{
					lakeTo = LakeArr[i];
				}
			}
			
			for (var s: String in obj)
			{
				// khởi tạo trường chưa tồn tại trong object lake
				//if (lakeTo && lakeTo.Option && lakeTo.Option[s])
				{
					if(lakeTo)
					{
						if (!lakeTo.Option)	lakeTo.Option = new Object();
						if(lakeIdTo != -1 && !lakeTo.Option[s])
						{
							lakeTo.Option[s] = 0;
						}
					}
					if(lakeFrom)
					{
						if (!lakeFrom.Option)	lakeFrom.Option = new Object();
						if (lakeIdFrom != -1 && !lakeFrom.Option[s])
						{
							lakeFrom.Option[s] = 0;
						}
					}
					if (!CurLake.Option)	CurLake.Option = new Object();
					if (lakeIdFrom == CurLake.Id && !CurLake.Option[s])
					{
						CurLake.Option[s] = 0;
					}
				}
				// cập nhật buff cho các đối tượng cần
				if (lakeIdFrom == CurLake.Id)
				{
					CurLake.Option[s] += type * obj[s];
				}
				else if(lakeIdFrom != -1)
				{
					lakeFrom.Option[s] += type * obj[s];
				}
				
				if (lakeIdTo == CurLake.Id)
				{
					CurLake.Option[s] -= type * obj[s];
				}
				else if(lakeIdTo != -1)
				{
					lakeTo.Option[s] -= type * obj[s];
				}
				
				if(lakeIdFrom != -1)
				{
					if (!buffTimeAllLake) buffTimeAllLake = new Object();
					if (!buffTimeAllLake[lakeIdFrom.toString()])	buffTimeAllLake[lakeIdFrom.toString()] = new Object();
					if (!buffTimeAllLake[lakeIdFrom.toString()][s])	buffTimeAllLake[lakeIdFrom.toString()][s] = 0;
					buffTimeAllLake[lakeIdFrom.toString()][s] += type * obj[s];
				}
				
				if(lakeIdTo != -1)
				{
					if (!buffTimeAllLake[lakeIdTo.toString()])		buffTimeAllLake[lakeIdTo.toString()] = new Object();
					if (!buffTimeAllLake[lakeIdTo.toString()][s])	buffTimeAllLake[lakeIdTo.toString()][s] = 0;
					buffTimeAllLake[lakeIdTo.toString()][s] -= type * obj[s];
				}
			}
			//Update lại hiển thị thông tin buff của hồ
			//GuiMgr.getInstance().GuiTopInfo.updateBuffLakeInfo();	//HIepNm2 Bỏ buff của hồ
			GuiMgr.getInstance().GuiMain.addTipBuffLake(buffTimeAllLake);
			UpdateHavestTime();
		}
		/**
		 * khởi tạo máy energy machine nếu có
		 */
		public function initEnergyMachine(data:Object):void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			
			if (IsViewer())//đang ở nhà bạn
			{
				if (MyInfo.energyMachine) //trường hợp nhà mình vào nhà bạn
				{//xóa cái máy của nhà mình
					MyInfo.energyMachine.Destructor();
					MyInfo.energyMachine = null;
				}
				if (energyMachine)			//nếu có máy rồi (trường hợp nhà bạn vào nhà bạn)
				{//xóa cái máy ở nhà bạn trước đó
					energyMachine.Destructor();
					energyMachine = null;
				}
				energyMachine = new EnergyMachine(layer, "MayBuff", EnergyMachine._x, EnergyMachine._y);
				energyMachine.SetInfo(data);
			}
			else	//đang ở nhà mình
			{
				if (energyMachine)	//trường hợp từ nhà bạn về nhà mình
				{//xóa cái máy ở nhà bạn
					energyMachine.Destructor();
					energyMachine = null;
				}
				MyInfo.InitEnergyMachine(data);
			}
		}
		
		public function initCoralTree(data:Object):void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			if (IsViewer())//đang ở nhà bạn
			{
				if (MyInfo.coralTree)//trường hợp nhà mình vào nhà bạn
				{
					MyInfo.coralTree.Destructor();
					MyInfo.coralTree = null;
				}
				if (coralTree)//trường hợp nháy 2 lần vào nick nhà 1 người bạn
				{//xóa cái cây của nhà bạn trước đó
					coralTree.Destructor();
					coralTree = null;
				}
				coralTree = new CoralTree(layer, "", 100, 100);
				coralTree.SetInfo(data);
			}
			else
			{
				if (coralTree)//từ nhà bạn về nhà mình
				{
					coralTree.Destructor();
					coralTree = null;
				}
				MyInfo.initCoralTree(data);
			}
		}
		
		public function initShocksNoel(data:Object):void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			if (IsViewer())//đang ở nhà bạn
			{
				if (MyInfo.shocksNoel)//trường hợp nhà mình vào nhà bạn
				{
					MyInfo.shocksNoel.Destructor();
					MyInfo.shocksNoel = null;
				}
			}
			else
			{
				MyInfo.initShocksNoel(data);
			}
		}
		public function initBirthdayCandle(data:Object, id:int):void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var myBirthdayCandle:BirthdayCandle = MyInfo["birthdayCandle" + id];
			var birthdayCandle:BirthdayCandle = this["birthdayCandle" + id];
			if (IsViewer())//đang ở nhà bạn
			{
				if (myBirthdayCandle)//trường hợp nhà mình đi vào nhà bạn
				{
					myBirthdayCandle.Destructor();
					myBirthdayCandle = null;
				}
				if (birthdayCandle)//trường hợp click 2 lần vào nick 1 người bạn
				{
					birthdayCandle.Destructor();
					birthdayCandle = null;
				}
				birthdayCandle = new BirthdayCandle(layer, "", 0, 0);
				birthdayCandle.initData(data, id);
			}
			else
			{
				if (birthdayCandle)//từ nhà bạn về nhà mình
				{
					birthdayCandle.Destructor();
					birthdayCandle = null;
				}
				MyInfo.initBirthdayCandle(data, id);
			}
		}
		
		public function initGiftBoxAfterEvent(data:Object):void
		{
			//var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			if (IsViewer())//đang ở nhà bạn
			{
				//if (MyInfo.giftBoxAfter)//trường hợp nhà mình vào nhà bạn
				//{
					//MyInfo.giftBoxAfter.Destructor();
					//MyInfo.giftBoxAfter = null;
				//}
				//if (giftBoxAfter)//trường hợp nháy 2 lần vào nick nhà 1 người bạn
				//{//xóa cái cây của nhà bạn trước đó
					//giftBoxAfter.Destructor();
					//giftBoxAfter = null;
				//}
				//giftBoxAfter = new GiftBoxAfter(layer, "Event8March_GiftBoxAfter", 100, 100);
				//giftBoxAfter.SetInfo(data);
			}
			else
			{
				//if (giftBoxAfter)//từ nhà bạn về nhà mình
				//{
					//giftBoxAfter.Destructor();
					//giftBoxAfter = null;
				//}
				MyInfo.initGiftBoxAfterEvent(data);
			}
		}
		/**
		 * Thực hiện cập nhật giá trị cho MyInfo.bonusMachine và this.bonusMachine
		 */
		public function updateBonusMachine(isMine:Boolean=true):void
		{
			var curEnergy:int = GetEnergy();
			var curLevel:int = GetLevel();
			var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(curLevel);
			var buffEnergy:int = ConfigJSON.getInstance().getEnergyMachineLimit(1);
			if (isMine)
			{
				if (curEnergy < maxEnergy)
				{
					MyInfo.bonusMachine = 0;
					MyInfo.Energy = curEnergy;
				}
				else
				{
					MyInfo.bonusMachine = curEnergy - maxEnergy;
					MyInfo.Energy = maxEnergy;
				}
			}
			else
			{
				if (curEnergy < maxEnergy)
				{
					bonusMachine = 0;
				}
				else
				{
					bonusMachine = curEnergy - maxEnergy;
				}
			}
		}
		/**
		 * 
		 */
		public function UpdateLogicEnergy(dEnergy:Number):void
		{
			var temp:int;
			if (bonusMachine > 0)
			{
				temp = bonusMachine + dEnergy;
				if (temp < 0)
				{
					bonusMachine = 0;
					Energy += temp;
				}
				else
				{
					bonusMachine = temp;
				}
			}
			else
			{
				Energy += dEnergy;
			}
		}
		/**
		 * Kiểm tra level để hiện nút vào thế giới cá
		 */
		public function ShowMapOceanButton():void
		{
			if (GuiMgr.getInstance().GuiMain)
			{
				var btnExMapOcean:ButtonEx;
				btnExMapOcean = GuiMgr.getInstance().guiFrontScreen.btnFishWorld;
				
				if (GetLevel(true) >= 7)
				{
					btnExMapOcean.SetEnable(true);
				}
				var tooltip:TooltipFormat = new TooltipFormat();
				tooltip.text = "Bản đồ thế giới cá";
				if (GetLevel(true) < 7)
				{
					tooltip.text += "\nMở ra khi đạt level 7";
				}
				btnExMapOcean.setTooltip(tooltip);
			}
			
			
			
			
		}
		/**
		 * Kiểm tra level để hiện nút hút cá
		 */
		public function ShowFishMachineButton():void
		{
			if (GetLevel(true) >= 20)
			{
				if (GuiMgr.getInstance().GuiMain)
				{
					var btnFishMac:ButtonEx = GuiMgr.getInstance().GuiMain.btnFishMachine;
					btnFishMac.SetEnable(true);
					var tooltip:TooltipFormat = new TooltipFormat();
					tooltip.text = "Máy đổi ngọc\nĐổi cá đặc biệt lấy ngọc để mua đồ";
					btnFishMac.setTooltip(tooltip);
				}
				
			}
		}
		public function GetFairyDrop(isMine:Boolean = true):Number
		{
			if (isMine)
			{
				return MyInfo.FairyDrop;
			}
			else
			{
				return FairyDrop;
			}
		}
		public function SetFairyDrop(fairyDrop:Number, isMine:Boolean = true):void
		{
			if (isMine)
			{
				MyInfo.FairyDrop = fairyDrop;
			}
			else
			{
				FairyDrop = fairyDrop;
			}
		}
		public function UpdateFairyDrop(dFairy:int, isMine:Boolean = true):void
		{
			if (isMine)
			{
				MyInfo.FairyDrop += dFairy;
			}
			else
			{
				FairyDrop += dFairy;
			}
		}
		public function GetFish(id:int):Fish
		{
			for (var i:int = 0; i < FishArr.length; i++)
			{
				if (FishArr[i].Id == id)
				{
					return FishArr[i];
				}
			}
			return null;
		}
		public function GetFishIndex(id:int):int
		{
			for (var i:int = 0; i < FishArr.length; i++)
			{
				if (FishArr[i].Id == id)
				{
					return i;
				}
			}
			return -1;
		}
		public function getFishSpartanIndex(id:int):int
		{
			for (var i:int = 0; i < FishArrSpartan.length; i++)
			{
				if (FishArrSpartan[i].Id == id)
				{
					return i;
				}
			}
			return -1;
		}
		public function getFishSpartanDeactiveIndex(id:int):int
		{
			for (var i:int = 0; i < FishArrSpartanDeactive.length; i++)
			{
				if (FishArrSpartanDeactive[i].Id == id)
				{
					return i;
				}
			}
			return -1;
		}
		
		// Khởi tạo kho báu
		public function InitMachineIceCream():void 
		{//tạm thời commit lại để không cho vẽ ra cây kem (HIEPNM2)
			//if (EventMgr.CheckEvent("IceCream") != EventMgr.CURRENT_IN_EVENT)
			//{
				return;
			//}
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			machineMakeIceCream = new MachineMakeCream(layer,"EventIceCream_MachineIceCream");
			machineMakeIceCream.Init();
		}
		// Khởi tạo kho báu
		public function InitTreasure():void 
		{
			var event:Object = ConfigJSON.getInstance().GetItemList("Event");
			var beginTime:int = event["IconExchange2"].BeginTime;
			var endTime:int = event["IconExchange2"].ExpireTime;
			var curTime:int = GameLogic.getInstance().CurServerTime;
			if (curTime < beginTime || curTime >= endTime)
			{
				return;
			}
			
			TreasureArr = [];
			if (TreasureWood)
			{
				TreasureWood.ClearImage();
				TreasureWood = null;
			}
			if (TreasureSilver)
			{
				TreasureSilver.ClearImage();
				TreasureSilver = null;
			}
			if (TreasureGold)
			{
				TreasureGold.ClearImage();
				TreasureGold = null;
			}
			
			if (!IsViewer())
			{
				var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
				TreasureWood = new Treasure(layer, "MayBuff");
				TreasureSilver = new Treasure(layer, "MayBuff");
				TreasureGold = new Treasure(layer, "MayBuff");
				
				TreasureWood.init(1, 590, 530);
				TreasureSilver.init(2, 720, 530);
				TreasureGold.init(3, 850, 530);
				
				TreasureArr.push(TreasureWood);
				TreasureArr.push(TreasureSilver);
				TreasureArr.push(TreasureGold);				
			}
		}
		
		//Event 2-9 init cá pháo hoa
		public function initFireworkFish(data:Object, lakeId:int):void
		{
			for (var s:String in data)
			{
				var imgName:String = "Santa";
				var fis:FireworkFish = new FireworkFish(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
				fis.isExpried = !data[s]["isExpried"];
				/*fis.RateOption = new Object();
				fis.RateOption[Fish.OPTION_MONEY] = data[s]["Option"]["Money"];
				fis.RateOption[Fish.OPTION_EXP] = data[s]["Option"]["Exp"];
				fis.RateOption[Fish.OPTION_TIME] = data[s]["Option"]["Time"];*/
				//fis.deadTime = data[s]["ExpiredDay"]*24*3600;
				fis.bornTime = data[s]["StartTime"];
				fis.receiveGiftTime = data[s]["LastTimeGetGift"];
				
				//fis.FishTypeId = 20;
				fis.Id = int(s);
				var Pos:Point = new Point();
				Pos.x = Ultility.RandomNumber(300, 1000);
				Pos.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 200, GameController.getInstance().GetLakeBottom() - 20);
				
				fis.Init(Pos.x, Pos.y);
				//fis.SetPos(Pos.x, Pos.y);
				fis.LakeId = lakeId;
				
				arrFireworkFish.push(fis);	
				//UpdateOptionLake(Fish.FISHTYPE_RARE, fis);
			}
		}
		
		public function createFireworkFish(id:int, lakeId:int):void
		{
			var imgName:String = "Sparta";// Fish.ItemType + "20" + "_" + Fish.OLD + "_" + Fish.IDLE;
			var fis:FireworkFish = new FireworkFish(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
			fis.FishTypeId = 20;
			fis.Id = id;
			var Pos:Point = new Point();
			Pos.x = Ultility.RandomNumber(300, 1000);
			Pos.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 200, GameController.getInstance().GetLakeBottom() - 20);
			
			fis.Init(Pos.x, Pos.y);
			fis.LakeId = lakeId;
			fis.SetAgeState(Fish.OLD);
			
			fis.SetEmotion(Fish.IDLE);
			fis.SetEmotion(Fish.GIFT);
			fis.FishType = Fish.FISHTYPE_RARE;
			fis.initBalloon();
			
			arrFireworkFish.push(fis);
		}
		
		public function UpdateTuiTanThu():void 
		{
			if (tuiTanThu)
			{
				tuiTanThu.Update();
			}
			
		}
		
		public function InitMoneyMagnet(data:Object):void 
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER);
			var o:Object;
			if (moneyMagnet==null)
			{
				 o= data["User"].SpecialItem.Magnet;
				if (o)
				{
					moneyMagnet = new MoneyMagnet(layer, "IconNamCham1", 0, 0);
					moneyMagnet.InitData(o);
				}
			}
			else
			{
				var times:int = moneyMagnet.useTimes;
				var time:int = moneyMagnet.lastTime;
				moneyMagnet.ReachDes = true;
				moneyMagnet.ClearImage();
				moneyMagnet = null;
				moneyMagnet = new MoneyMagnet(layer, "IconNamCham1", 0, 0);
				moneyMagnet.useTimes = times;
				moneyMagnet.lastTime = time;
				moneyMagnet.SetImg();
				if (IsViewer())
				{
					moneyMagnet.SetPos(moneyMagnet.POS_X - 30,moneyMagnet.POS_Y);
				}
				else
				{
									 
					o= data["User"].SpecialItem.Magnet;
					moneyMagnet.InitData(o);

				}
				
				/*if (moneyMagnet.Parent)
				{
					layer.addChild(moneyMagnet.img);
				}*/
			}
		}
		
		public function UpdateMoneyMagnet():void 
		{
			if (moneyMagnet)
			{
				moneyMagnet.Update();
			}
		}

		public function GetBattleStat():Object
		{
			return BattleStat;
		}
		
		public function CheckSetTicket(dTicket:int):Boolean
		{
			if (!IsViewer())//đang ở nhà mình
			{
				//trace("tinh xeng");
				//trace("MyInfo.Ticket = " + MyInfo.Ticket);
				//trace("dTicket = " + dTicket);
				if (MyInfo.Ticket + dTicket < 0)
				{
					return false;
				}
				MyInfo.Ticket += dTicket;
				return true;
			}
			//trace("return false")
			return false;
		}
		
		public function ProcessBuffHerbPotion(lucky:Object, herbId:int, fishId:int, lakeId:int, numUse:int):void
		{
			var fishArr:Array;
			var i:int;
			
			if (IsViewer())
			{
				// Nha ban
				
			}
			else
			{
				// Nha minh
				if (CurLake.Id == lakeId)
				{
					fishArr = FishSoldierArr;
					for (i = 0; i < fishArr.length; i++)
					{
						if (fishArr[i].Id == fishId)
						{
							fishArr[i].DropGiftHerb(lucky, herbId, numUse);
							break;
						}
					}
				}
			}
		}
		
		public function getCandle(isMe:Boolean, id:int):BirthdayCandle 
		{
			if (isMe) {
				return GetMyInfo()["birthdayCandle" + id];
			}
			else {
				return this["birthdayCandle" + id];
			}
		}
		
		public function updateIngradient(itemType:String, num:int, itemId:int = 0):void
		{
			if (ingradient == null)
			{
				return;
			}
			
			if (itemType != "SoulRock")
			{
				if(ingradient[itemType] != null)
				{
					ingradient[itemType] += num;
				}
				else
				{
					ingradient[itemType] = num;
				}
			}
			else
			{
				if (ingradient[itemType] == null)
				{
					ingradient[itemType] = new Object();
				}
				if (ingradient[itemType][itemId] == null)
				{
					ingradient[itemType][itemId] = num;
				}
				else
				{
					ingradient[itemType][itemId]  += num;
				}
			}
		}
		public function getPowerTinh():int
		{
			if (ingradient == null)
			{
				return 0;
			}
			if (ingradient["PowerTinh"] == null)
			{
				return 0;
			}
			return ingradient["PowerTinh"];
		}
		
		public var smithyData:Object;
		public function initSmithyData(data:Object):void
		{
			smithyData = data;
			ingradient = data["HammerMan"];
		}
		
		public function getReputationLevel(isMine:Boolean = true):int
		{
			if (isMine)
			{
				return MyInfo.ReputationLevel;
			}
			return ReputationLevel;
		}
		
		public function getReputationPoint(isMine:Boolean = true):int
		{
			if (isMine)
			{
				return MyInfo.ReputationPoint;
			}
			return ReputationPoint;
		}
		
		public function updateReputationLevel(fameLevel:int):void
		{
			MyInfo.ReputationLevel = fameLevel;
			if (!IsViewer())
			{
				ReputationLevel = fameLevel;
			}
		}
		
		public function updateReputationPoint(famePoint:int):void
		{
			MyInfo.ReputationPoint = famePoint;
			if (!IsViewer())
			{
				ReputationPoint = famePoint;
			}
		}
		
		public function resetReputationQuest():void
		{
			if (MyInfo.ReputationLevel <= 0)
			{
				return;
			}
			var fameConf:Object = ConfigJSON.getInstance().getItemInfo("ReputationInfo", getReputationLevel());
			var questConf:Object = new Object();
			for (var st:String in fameConf)
			{
				if (int(st) > 0)
				{
					questConf[st] = new Object();
					questConf[st]["Action"] = fameConf[st]["Action"];
					questConf[st]["Id"] = int(st);
					questConf[st]["isGetGift"] = 0;
					questConf[st]["notDone"] = true;
					questConf[st]["Num"] = 0;
				}
			}
			MyInfo.ReputationQuest = questConf;
			
			if (!IsViewer())
			{
				ReputationQuest = questConf;
			}
		}
		
		public function updateReputationQuest(questId:int, num:int = -1, isGetGift:Boolean = false):void
		{
			if (MyInfo.ReputationQuest == null)
			{
				return;
			}
			if (MyInfo.ReputationQuest[questId] == null)
			{
				return;
			}
			if(num >= 0)
			{
				MyInfo.ReputationQuest[questId]["Num"] = num;
			}
			if (isGetGift)
			{
				MyInfo.ReputationQuest[questId]["isGetGift"] = 1;
			}
		}
	}
	

}
