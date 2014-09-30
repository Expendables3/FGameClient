package  
{
	import com.adobe.serialization.json.JSON;
	import Constant;
	import Crypto.com.hurlant.util.Base64;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Effect.EffectMgr;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventHalloween.HalloweenPackage.SendUnlockNode;
	import Event.EventIceCream.MachineMakeCream;
	import Event.EventMgr;
	import Event.EventMidAutumn.EventPackage.SendFireLantern;
	import Event.EventNoel.NoelGui.GUIVIPTrunk;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.TreasureIsland.SendAutoDig;
	import Event.TreasureIsland.SendBuyItemInEvent;
	import Event.TreasureIsland.SendBuyItemWithDiamond;
	import Event.TreasureIsland.SendChangeCollection;
	import Event.TreasureIsland.SendCollectGift;
	import Event.TreasureIsland.SendDigLand;
	import Event.TreasureIsland.SendIsLucky;
	import FakeServ;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.net.Responder;
	import flash.net.SharedObject;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import GameControl.GameController;
	import GUI.BlackMarket.GUIConfirmBuyItem;
	import GUI.BlackMarket.GUIMarket;
	import GUI.BlackMarket.GUISell;
	import GUI.BlackMarket.ItemSell;
	import GUI.ChampionLeague.PackageLeague.SendRefreshBoard;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.ChampionLeague.PackageLeague.SendAttackLeague;
	import GUI.ChampionLeague.PackageLeague.SendChangeSoldier;
	import GUI.component.Container;
	import GUI.CreateEquipment.GUISeparateEquipment;
	import GUI.EventBirthDay.EventGUI.BirthdayCandle;
	import GUI.EventBirthDay.EventLogic.BirthDayItemMgr;
	import GUI.EventBirthDay.EventLogic.MagicLampMgr;
	import GUI.EventBirthDay.EventPackage.SendBurnCandle;
	import GUI.EventBirthDay.EventPackage.SendGetGiftMagicLamp;
	import GUI.EventMagicPotions.BossHerb;
	import GUI.EventMagicPotions.QuestHerbMgr;
	import GUI.EventMidle8.GUIGameEventMidle8;
	import GUI.Expedition.ExpeditionLogic.ExpeditionMgr;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIChooseEquipment;
	import GUI.FishWorld.Boss;
	import GUI.FishWorld.BossMetal;
	import GUI.FishWorld.BossMgr;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.ForestWorld.Thicket;
	import GUI.FishWorld.Network.SendJoinSeaAgain;
	import GUI.FishWorld.SubBossIce;
	import GUI.FishWorld.SubBossMetal;
	import GUI.GUIGemRefine.GemPackage.SendCancelUpgrade;
	import GUI.GUIGemRefine.GemPackage.SendGetGem;
	import GUI.GUIGemRefine.GemPackage.SendQuickUpgrade;
	import GUI.GUIGemRefine.GemPackage.SendRecoverGem;
	import GUI.GUIGemRefine.GemPackage.SendUpgradeGem;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import GUI.Mail.GUINewMail;
	import GUI.SpecialSmithy.SendBreakEquipment;
	import GUI.SpecialSmithy.SendMakeEquipment;
	import GUI.TrainingTower.TrainingLogic.TrainingMgr;
	import GUI.TrungLinhThach.TrungLinhThachMgr;
	import Logic.EventNationalCelebration.FireworkFish;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic2;
	import Logic.GameMode;
	import Logic.FishSpartan;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.LayerMgr;
	import Logic.LogInfo;
	import Logic.myTimer;
	import Logic.MyUserInfo;
	import Logic.NewFeedWall;
	import Logic.QuestInfo;
	import Logic.QuestMgr;
	import Logic.TaskInfo;
	import Logic.Treasure;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.*;
	import NetworkPacket.PacketReceive.GetInitRun;
	import NetworkPacket.PacketSend.BlackMarket.SendGetListSell;
	import NetworkPacket.PacketSend.SendBuyFish;
	import NetworkPacket.PacketSend.SendCollectMoney;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import NetworkPacket.PacketSend.SendOpenTrunk;
	import NetworkPacket.PacketSend.SendUseRankPointBottle;
	import particleSys.myFish.GhostEmit;
	import NetworkPacket.PacketSend.SendCollectMoney;

	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Event.EventMgr;
	import FakeServ;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.sampler.NewObjectSample;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import com.adobe.utils.StringUtil;
	import GUI.component.Button;
	import GameControl.GameController;

	import GUI.component.ButtonEx;
	import GUI.component.TooltipFormat;
	import Logic.Fish;
	import Logic.FishSpartan;
	import Logic.NewFeedWall;
	import Logic.User;
	import Logic.Treasure;
	import NetworkPacket.PacketReceive.GetTreasure;
	import NetworkPacket.PacketSend.SendOpenTrunk;
	//import GUI.GUIMain;
	import GUI.GUITopInfo;
	import Logic.BaseObject;
	import Logic.LayerMgr;
	import Logic.LogInfo;
	import Logic.QuestBonus;
	import Logic.QuestInfo;
	import Logic.QuestMgr;
	import flash.ui.Mouse;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Lake;
	import NetworkPacket.PacketReceive.GetInitRun;
	import NetworkPacket.PacketSend.SendGetDailyQuest;
	import NetworkPacket.PacketSend.SendGetSeriesQuest;
	//import com.adobe.serialization.json.JSON;
	import com.adobe.crypto.MD5;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import NetworkPacket.*;
	import Data.INI;
	import  GUI.GuiMgr;
	import flash.external.ExternalInterface;
	import flash.net.Responder;
	import GUI.component.Button;
		
	/**
	 * Handling Send / Receive Operation
	 * @author Tien Ga
	 * 24.08.2010
	 */
	public class Exchange
	{
		private static const TIMEOUT_ALL_CMD:int = 5000;	// timeout cho cả queue
		private static const TIMEOUT_EACH_CMD:int = 2000;	// timeout cho từng gói tin		
		private static const TIMEWAIT_EACH_CMD:int = 1000;	// timewait cho từng gói tin 
		private static const MAX_QUEUE_LENGTH:int = 20;		// độ dài tối đa của queue
		//public var CommandQueue:Array = [];
		
		private static const KEY_TYPE:String = "TypeAction";
		private static const KEY_DATA:String = "Data";
		private static const KEY_TIME_STAMP:String = "TimeStamp";
		private static const KEY_DATA_CLIENT_SEND:String = "ClientSend";
		private static const KEY_DATA_SERVER_SEND:String = "ServerSend";
		
		public const TIMEOUT:int = 25000;	
		private static var ExchangeInstance:Exchange = new Exchange();
		//private var _timer:Timer;
		private var SendService:RemotingService;
		//private var RecieveService:Responder;
		private var fakeSv:FakeServ = new FakeServ();
		private var queueOfRequest:Array = [];				// queue chứa tất cả các cmd sắp gửi lên 
		private var collectMoneyPacket:SendCollectMoney = null;		// dùng ghép gói tin thu thập tiền, là con trỏ tới gói tin thu tiền
		private var timeoutCmd:Timer = null;				// bộ đếm thời gian cho từng gói tin
		private var timeoutAllCmd:Timer = null;				// bộ đếm thời gian cho cả queue
		private var myTimeoutCmd:myTimer = null;				// bộ đếm thời gian cho từng gói tin
		private var myTimeoutAllCmd:myTimer = null;				// bộ đếm thời gian cho cả queue
		private var isCreateUser:Boolean = false;
		private var isSendingXu:Boolean = false;
		//private var isEncrypted:Boolean = true;
		private var isEncrypted:Boolean = false;
		
		private var logClient:SharedObject = null;
		
		
		private var collectMoneyMagnet:SendCollectMoney = null;
		private var arrPacketSending:Array;
		
		//private var isEncrypted:Boolean = true;
		
		
		
		public static function GetInstance():Exchange
		{
			if(ExchangeInstance == null)
			{
				ExchangeInstance = new Exchange();
			}
				
			return ExchangeInstance;
			
		}
		
		public function Exchange() 
		{
			if(ExchangeInstance != null)
			{
				return;
			}
			//_timer = new Timer(1000);
			//_timer.start();
			var url:String = INI.getInstance().getPostUrl();
			SendService = new RemotingService(url);	
			
			// Timer
			//timeoutAllCmd = new Timer(TIMEOUT_ALL_CMD, 1);
			//timeoutAllCmd.addEventListener(TimerEvent.TIMER, SendAll);
			//timeoutCmd = new Timer(TIMEOUT_EACH_CMD, 1);
			//timeoutCmd.addEventListener(TimerEvent.TIMER, SendAll);
			myTimeoutAllCmd = new myTimer("myTimeoutAllCmd", TIMEOUT_ALL_CMD, SendAll);
			myTimeoutCmd = new myTimer("myTimeoutCmd", TIMEOUT_EACH_CMD, SendAll);
			
			arrPacketSending = [];
		}
		
		public static function RenewInstance():void
		{
			ExchangeInstance = null;
			ExchangeInstance = new Exchange();
		}
		

		/*public function Send(SendObject:BasePacket):void
		{
			PostRequest(SendObject,HandleUserGameMsg);
		}*/
		
		public function Send(SendObject:BasePacket):void
		{
			// kiem tra co phai quest ko
			SendObject.IsExpeditionQuest = ExpeditionMgr.getInstance().IsQuest(SendObject);//có phải quest trong viễn chinh
			SendObject.IsQuest = QuestMgr.getInstance().IsQuest(SendObject);
			SendObject.IsEvent = EventMgr.getInstance().IsEvent(SendObject);
			
			if (Constant.OFF_SERVER)
			{
				//trace("Offline server");
				var data:Object = fakeSv.ProcessPacket(SendObject.GetURL(), SendObject.GetID());
				HandleUserGameMsg(SendObject.GetID(), data, SendObject);
			}
			else
			{		
				switch(SendObject.GetID())
				{
					case Constant.CMD_COLLECT_MONEY:
						var cmd:SendCollectMoney = SendObject as SendCollectMoney;
						if (cmd.isMagnet)
						{
							if (collectMoneyMagnet == null) //Tức là gói tin chưa có trong queue chung nên nó được push vào queue
							{
								PushInQueue(SendObject);
								collectMoneyMagnet = cmd;// = new SendCollectMoney( cmd.LakeId, cmd.FriendId);
							}
							else
							{
								collectMoneyMagnet.AddNew(cmd.FishList[0]);//Dồn id của các con cá vào 1 mảng rùi mới gửi lên
							}	
							
						}
						else
						{
							if (collectMoneyPacket == null) //Tức là gói tin chưa có trong queue chung nên nó được push vào queue
							{
								PushInQueue(SendObject);
								collectMoneyPacket = cmd;
							}
							else
							{
								collectMoneyPacket.AddNew(cmd.FishList[0]);//Dồn id của các con cá vào 1 mảng rùi mới gửi lên
							}	
						}
						break;
					default:
						if (SendObject.GetID() == Constant.CMD_ICE_CREAM_BUY_ITEM)
						{
							trace("Bắt đầu pust gói tin buyitem thứ ", GuiMgr.getInstance().GuiMainEventIceCream.countBuyItem, " vào queue");
						}
						PushInQueue(SendObject);
						break;
				}
				
				
				
				if (!SendObject.IsMustQueue() || SendObject.IsExpeditionQuest ||SendObject.IsQuest || queueOfRequest.length >= MAX_QUEUE_LENGTH)
				{
					SendAll();
				}			
			}
		}
		
		//private function PushInQueueCommand(PushObject:BasePacket):void
		//{
			// Search the queue for an object of this type
			//for (var i:int; i < CommandQueue.length; i++)
			//{
				//trace("check queue");
				//if (CommandQueue[i].GetID() == PushObject.GetID())
				//{
					// Merge the Packets
					//Merge(CommandQueue[i], PushObject);
					//return;
				//}
			//}
			//
			// Not found, activate the send timer & push in the queue
			// Handle function:
			//function TimerHandler():void
			//{
				// Send Object:
				//for (var i:int; i < CommandQueue.length; i++)
				//{
					//if (CommandQueue[i].GetID() == PushObject.GetID())
					//{
						//AmfRequest(CommandQueue[i]);
						//CommandQueue[i].RemoveTimer(TimerHandler);
						//CommandQueue.splice(i, 1);
						//break;
					//}
				//}
			//}
			//
			//PushObject.ActivateTimer(TimerHandler);
			//CommandQueue.push(PushObject);
		//}
		
		private function Merge(SendObject:Object, MergeObject:Object):void
		{
			// Merge IsQuest Attribute:
			SendObject.IsQuest = SendObject.IsQuest || MergeObject.IsQuest;
	
			switch (SendObject.GetID())
			{
				case Constant.CMD_BUY_FISH: 
				{
					SendObject.FishList.push(MergeObject.FishList[0]);
				}
				break;
			}
		}
		
		private function ProcessAll():void 
		{
			if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)
			{
				GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
			}
			GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
		}
		
		public function HandleErrGameMsg(Type:String, Data1:Object, OldData:Object):void
		{
			if (Data1["Error"] != 0)
			{
				ProcessAll();
			}
			switch(Data1["Error"])
			{
				case 140:
					GuiMgr.getInstance().guiMainBossServer.Hide();
					GameController.getInstance().gotoMode(GameController.GAME_MODE_HOME);
					break;
				case 142:
				case 141:
					if (Type == Constant.CMD_SEND_SIGN_IN)
					{
						GameLogic.getInstance().user.remainTimesInput --;
						if (GameLogic.getInstance().user.remainTimesInput <= 0)
						{
							GameLogic.getInstance().user.passwordState = Constant.PW_STATE_IS_BLOCKED;
							GameLogic.getInstance().user.timeStartBlock = GameLogic.getInstance().CurServerTime;
						}
					}
					GuiMgr.getInstance().guiChangePassword.Hide();
					GuiMgr.getInstance().guiPassword.Hide();
					GuiMgr.getInstance().guiPassword.showGUI();
					GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("ErrorMsg141"));
					break;
				//Lỗi không mua được bằng G
				case 128:
					if(Data1["ZMoney"] != null)
					{
						GameLogic.getInstance().user.SetUserZMoney(Data1["ZMoney"]);
					}
					GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("ErrorMsg128"));
					break;
				//Mua hoặc hủy bán vật phẩm đã bán
				case 114:
					if (Type == Constant.CMD_SEND_EXIT_ISLAND || Type == Constant.CMD_SEND_DIG_LAND || Type == Constant.CMD_SEND_AUTO_DIG || Type == Constant.CMD_SEND_IS_LUCKY
					|| Type == Constant.CMD_SEND_COLLECT_GIFT || Type == Constant.CMD_SEND_JOIN_ISLAND || Type == Constant.CMD_SEND_CHANGE_COLLECT)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("ErrorMsg114"));
						GuiMgr.getInstance().guiTreasureIsLand.checkExprireTime();
					}
					break;
				case 115:
				case 116:
				case 129:
				case 130:
				case 131:
				case 132:
				case 133:
					if (Data1["Diamond"] != null)
					{
						GameLogic.getInstance().user.setDiamond(Data1["Diamond"]);
						if (GuiMgr.getInstance().guiMarket.IsVisible)
						{
							GuiMgr.getInstance().guiMarket.numDiamond = Data1["Diamond"];
						}
					}
					if (GuiMgr.getInstance().guiConfirmBuyItem.IsVisible)
					{
						GuiMgr.getInstance().guiConfirmBuyItem.Hide();
						GuiMgr.getInstance().guiMarket.refreshCurPage();
					}
					if (GuiMgr.getInstance().guiSell.IsVisible)
					{
						//Gui goi tin lay cac hang dang ban
						if (!GuiMgr.getInstance().guiSell.isWaitingListSell)
						{
							Exchange.GetInstance().Send(new SendGetListSell());
							GuiMgr.getInstance().guiSell.isWaitingListSell = true;
						}
						if (!GuiMgr.getInstance().guiSell.isWaitingStore)
						{
							var cmd:SendLoadInventory = new SendLoadInventory();
							Exchange.GetInstance().Send(cmd);
							GuiMgr.getInstance().guiSell.isWaitingStore = true;
						}
					}
					var error:int = Data1["Error"];
					if (error == 129 || error == 131 || error == 132 || error == 132)
					{
						error = 115;
					}
					var message:String = Localization.getInstance().getString("ErrorMsg" + error);
					GuiMgr.getInstance().GuiMessageBox.ShowOK(message);
					break;
				case 108:
					if (GuiMgr.getInstance().guiSell.IsVisible)
					{
						GuiMgr.getInstance().guiSell.Show(Constant.GUI_MIN_LAYER, 6);
					}
					GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("ErrorMsg108"));
					break;
				case 2:
					//GuiMgr.getInstance().GuiAvatar.Show(Constant.TopLayer - 1, 5);
					isCreateUser = true;
					break;
				case 24:
					switch (Type)
					{
						case Constant.CMD_GET_ALL_SOLDIER:
							// Nếu là gói tin gửi lên lúc khởi tạo
							if (isCreateUser)
							{
								isCreateUser = false;
							}
							break;
						case Constant.CMD_ATTACK_FRIEND_LAKE:
						case Constant.CMD_ATTACK_OCEAN_SEA:
							// Cá nhà bạn đã bị bán
							GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWarMsg18"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR, false);
							break;
						case Constant.CMD_USE_GEM:
							// Ngư thủ ko tồn tại trong hồ (bị bán hoặc chuyển hồ)
							GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWarMsg27"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR, false);
							break;
					}
					break;
				case 28:	// ACTION_NOT_AVAILABLE
					switch (Type)
					{
						case Constant.CMD_USE_GEM:
							var msg:String = Localization.getInstance().getString("FishWarMsg29");
							msg = msg.replace("@Element@", Localization.getInstance().getString("Element" + OldData.ListGem[0].Element));
							GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(msg, 310, 200, GUIMessageBox.NPC_MERMAID_WAR, false);
							
							break;
					}
					break;
				case 81:
					GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWarMsg18"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					break;
				case 90:	// Ngư thủ nhà mình hết sức khỏe
					GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWarMsg19"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					break;
				case 102:	// Ngư thủ nhà bạn hết sức khỏe
					GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWarMsg20"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR, false);
					break;
				case 103:	// QUANG check : dùng hoa sen
					break;
				case 107:	// QUANG check : Khi dùng đan có lỗi qua ngày
					GuiMgr.getInstance().GuiMapOcean.ComeBackHome();
					break;
				case 104:	// Ngư thủ nhà mình đã hết hạn
					if(Ultility.IsInMyFish())
					{
						GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWarMsg28"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR, false);
					}
					else 
					{
						GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWorld(Localization.getInstance().getString("FishWarMsg28"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					}
					break;
				case 105:	// Ngư thủ nhà bạn hết hạn
					GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWarMsg24"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR, false);
					break;
				case 97:	// Trường hợp cá nhà mình hết hạn đi tgc (chưa check)
					GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg28"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					break;
				case 125:
				case 99:
				case 124:
					GuiMgr.getInstance().GuiInputCode.processReceiveGift(Data1);
				break;
				case 31:
					break;
				case 145:
					GameLogic.getInstance().InitLogicGame(OldData.LakeId, Data1);
					break;
				case 146:
					//lỗi ko nhận quà xong
					if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Hệ thống đang bận trao giải!\nBạn vào lại liên đấu để nhận quà nhé ^^!", 310, 200, 1);
					}
				break;
				case 112:
					if (Type == Constant.CMD_EXCHANGE_ACCUMULATION_POINT || Type == Constant.CMD_GET_SAVE_POINT_STATUS)
					{
						if (GuiMgr.getInstance().guiSavePoint.IsVisible)
						{
							GuiMgr.getInstance().guiSavePoint.Hide();
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian đổi quà từ điểm tích lũy", 310, 200, 1);
						}
					}
				break;
				default:
					// các xử lý khác có thể cần dùng khi có lỗi
					{
						if (GuiMgr.getInstance().GuiFishWarBoss.IsVisible)	GuiMgr.getInstance().GuiFishWarBoss.Hide();
						if (GuiMgr.getInstance().GuiWaitReJoinMap.IsVisible)	GuiMgr.getInstance().GuiWaitReJoinMap.Hide();
						if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	GuiMgr.getInstance().GuiInfoWarInWorld.Hide();
						if (GuiMgr.getInstance().GuiIntroOcean.IsVisible)	GuiMgr.getInstance().GuiIntroOcean.Hide();
						if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)	GuiMgr.getInstance().GuiMainFishWorld.Hide();
						if (GuiMgr.getInstance().GuiMapOcean.IsVisible)	GuiMgr.getInstance().GuiMapOcean.Hide();
						if (GuiMgr.getInstance().GuiRegenerating.IsVisible)	GuiMgr.getInstance().GuiRegenerating.Hide();
						if (GuiMgr.getInstance().GuiUnlockOcean.IsVisible)	GuiMgr.getInstance().GuiUnlockOcean.Hide();
						if (GuiMgr.getInstance().GuiCover.IsVisible)	GuiMgr.getInstance().GuiCover.Hide();
						if (GuiMgr.getInstance().GuiRawMaterials.IsVisible)	GuiMgr.getInstance().GuiRawMaterials.Hide();						
						if (GuiMgr.getInstance().GuiMainEventIceCream.IsVisible)	GuiMgr.getInstance().GuiMainEventIceCream.Hide();
					}
					// Hard code cho truong hop bi loi an trom o nha ban
					var st:String;// = Localization.getInstance().getString("ErrorMsg" + Data1["Error"]);
					if(Data1["Error"] != 91 || (Data1["Error"] == 91 && Type != Constant.CMD_ICE_CREAM_THEFT_ICE_CREAM))
					{	
						if (GameLogic.getInstance().gameState != GameState.GAMESTATE_INIT)
						{
							GameLogic.getInstance().BackToIdleGameState();
							GameLogic.getInstance().SetState(GameState.GAMESTATE_ERROR);
						}
						
						if (Constant.DEV_MODE)
						{
							st = "Gói tin " + Type + "\nLỗi: " + Data1["Error"] + "\n" + 
							Localization.getInstance().getString("ErrorMsg" + Data1["Error"]);						
						}
						else
						{
							st = Localization.getInstance().getString("ErrorMsg" + Data1["Error"]);
						}
						GuiMgr.getInstance().GuiMessageBox.ShowReload(st);
					}
					else 
					{
						st = "Bạn không thể ăn trộm thêm được nữa!";
						GuiMgr.getInstance().GuiMessageBox.ShowOK(st);
					}
					break;
			}						
		}
		
		
		public function HandleUserGameMsg(Type:String, Data1:Object, OldData:Object):void
		{
			isSendingXu = false;
			//trace("Da nhan goi tin: isSendingXu = ", isSendingXu, " type: ",Type);
			
			if (Constant.DEV_MODE)	
			{
				if (Data1 == "SNS Executive Call Error Try Again")	return;
			}
			
			if (((Type == Constant.CMD_ATTACK_BOSS_OCEAN_SEA) || (Type == Constant.CMD_ATTACK_OCEAN_SEA)) && Data1.MyEnergy != null)
			{
				GameLogic.getInstance().user.SetEnergy(Data1.MyEnergy);
				GameLogic.getInstance().user.GetMyInfo().LastEnergyTime = GameLogic.getInstance().CurServerTime;
			}
			
			//trace("receive:", Type);
			if ((Type != Constant.CMD_CURE_FISH) && (Type != Constant.CMD_CARE_FISH) && 
				(Type != Constant.CMD_CLEAN_LAKE) && (Type != Constant.CMD_FEED_FISH) && 
				(Type != Constant.CMD_LOAD_GIFT) && (Type != Constant.CMD_LOAD_MAIL) && 
				(Type != Constant.CMD_STEAL_MONEY) && (Type != Constant.CMD_COLLECT_MONEY) &&
				(Type != Constant.CMD_GET_GIFT_LEAGUE))
			{
				if ("Error" in Data1)
				{
					if (Data1["Error"] != 0)
					{
						HandleErrGameMsg(Type, Data1, OldData);
						return;
					}
				}
				else
				{
					trace("Ko có trường Error trong Data1");
					return;
				}
			}
			//kiểm tra hoàn thành quest viễn chinh
			ExpeditionMgr.getInstance().updateQuest(Type, Data1, OldData as BasePacket);
			// kiem tra hoan thanh quest
			{
				UpdateQuest(Type, Data1, OldData);
			}
			
			if (OldData.IsEvent)
			{
				EventMgr.getInstance().HandleEventMsg(Type, Data1, OldData);
			}
			
			QuestHerbMgr.getInstance().UpdateQuestHerb(Type, Data1, OldData);
			//trace("Xu ly goi tin tra ve==== " + Type);
			// xu ly logic goi tin nhan ve
			switch (Type)
			{
				case Constant.CMD_GET_VIP_BOX:
					GuiMgr.getInstance().guiVIPTrunk.updateData(Data1);
					break;
				case Constant.CMD_OPEN_VIP_TRUNK:
					var vipEquip:FishEquipment = new FishEquipment();
					vipEquip.SetInfo(Data1["Item"]["Equipment"][0]);
					GuiMgr.getInstance().guiNewCongratulation.showEquipment(vipEquip, 0, "Bạn nhận được:", function f():void
					{
						GameLogic.getInstance().user.GenerateNextID();
						if(GuiMgr.getInstance().guiVIPTrunk.IsVisible)
						{
							GuiMgr.getInstance().guiVIPTrunk.GetButton(GUIVIPTrunk.BTN_BUY).SetEnable(true);
							GuiMgr.getInstance().guiVIPTrunk.numKey = GuiMgr.getInstance().guiVIPTrunk.numKey;
						}
					});
					trace(Data1);
					break;
				case Constant.CMD_SEND_MIX_MATERIAL:
					GuiMgr.getInstance().guiMixMaterial.processMixMaterial(Data1);
					break;
				case Constant.CMD_SEND_GET_FINAL_GIFT:
					GuiMgr.getInstance().guiFinalGift.updateGift(Data1);
					break;
				case Constant.CMD_GET_STORE_MID_AUTUMN:
					GuiMgr.getInstance().guiGiftStore.updateGift(Data1);
					break;
				case Constant.CMD_GET_EVENT_INFO:
					GuiMgr.getInstance().guiBackGround.updateEventInfo(Data1);
					break;
				case Constant.CMD_SEND_GET_ROOM_INFO:
					GuiMgr.getInstance().guiListBoss.updateRoomInfo(Data1);
					break;
				case Constant.CMD_GET_HAMMERMAN:
					GameLogic.getInstance().user.initSmithyData(Data1);
					break;
				case Constant.CMD_MAKE_OPTION:
					GuiMgr.getInstance().guiSpecialSmithy.processMakeCustom(Data1);
					break;
				case Constant.CMD_MAKE_EQUIP:
					GuiMgr.getInstance().guiSpecialSmithy.processMakeEquip(Data1, OldData as SendMakeEquipment);
					break;
				case Constant.CMD_BREAK_EQUIP:
					GuiMgr.getInstance().guiSpecialSmithy.processBreakEquip(Data1);
					break;
				case Constant.CMD_SAVE_OPTION:
					GuiMgr.getInstance().guiSpecialSmithy.processSaveEquip(Data1);
					break;
				case Constant.CMD_SEND_JOIN_ROOM:
					GuiMgr.getInstance().guiMainBossServer.updateRoomInfo(Data1);
					break;
				case Constant.CMD_SEND_ATTACK_BOSS_SERVER:
					GuiMgr.getInstance().guiMainBossServer.updateAttackBossResult(Data1);
					break;
				case Constant.CMD_SEND_RANDOM_DICE:
					if(int(OldData["Type"]) == 1)
					{
						GuiMgr.getInstance().guiMainBossServer.showDiceResult(Data1["DiceNum"]);
					}
					else
					{
						GuiMgr.getInstance().guiMainBossServer.showDiceResultVip(Data1["DiceNum"]);
					}
					break;
				case Constant.CMD_SEND_AUTO_SEPARATE_EQUIP:
					var guiChooseEquipment:GUIChooseEquipment = GuiMgr.getInstance().GuiChooseEquipment;
					if (guiChooseEquipment.IsVisible && guiChooseEquipment.guiSeparateEquipment != null && guiChooseEquipment.guiSeparateEquipment.img.visible)
					{
						guiChooseEquipment.guiSeparateEquipment.showAutoResult(Data1["Ingredients"]);
					}
					break;
				case Constant.CMD_BUY_ITEM_IN_EVENT:
				case Constant.CMD_BUY_ITEM_WITH_DIAMOND:
					GuiMgr.getInstance().guiTreasureIsLand.processBuyItem(OldData["Item"]);
					break;
				case Constant.CMD_SEND_JOIN_ISLAND:
					GuiMgr.getInstance().guiTreasureIsLand.isNextDay = false;
					GuiMgr.getInstance().guiTreasureIsLand.isEffRun = false;
					GuiMgr.getInstance().guiTreasureIsLand.timePlay = GameLogic.getInstance().CurServerTime * 1000 - 10 * 1000;
					if (Data1["Map"].hasOwnProperty("Map"))
					{
						GuiMgr.getInstance().guiTreasureIsLand.userData = Data1["Map"];
						GuiMgr.getInstance().guiTreasureIsLand.updateMap(Data1["Map"]["Map"]);
						if (Data1.hasOwnProperty("RemainGift"))
							GuiMgr.getInstance().guiMessageInEvent.ShowMessTimeOut(Localization.getInstance().getString("IslandMess1"), Data1["RemainGift"][0]);
						break;
					}
					GuiMgr.getInstance().guiTreasureIsLand.updateMap(Data1["Map"]);
					if (Data1.hasOwnProperty("RemainGift"))
						GuiMgr.getInstance().guiMessageInEvent.ShowMessTimeOut(Localization.getInstance().getString("IslandMess1"), Data1.hasOwnProperty("RemainGift"));
					break;
				case Constant.CMD_SEND_EXIT_ISLAND:
					GuiMgr.getInstance().guiTreasureIsLand.processExitIsland(Data1);
					break;
				case Constant.CMD_SEND_DIG_LAND:
					GuiMgr.getInstance().guiTreasureIsLand.processDigLand(Data1["GiftId"], OldData as SendDigLand);
					break;
				case Constant.CMD_SEND_COLLECT_GIFT:
					GuiMgr.getInstance().guiTreasureIsLand.processCollectGift(Data1, OldData as SendCollectGift);
					break;
				case Constant.CMD_SEND_IS_LUCKY:
					GuiMgr.getInstance().guiTreasureIsLand.processIsLucky(Data1, OldData as SendIsLucky);
					break;
				case Constant.CMD_SEND_AUTO_DIG:
					GuiMgr.getInstance().guiTreasureIsLand.processAutoDig(Data1["Gift"], OldData as SendAutoDig);
					break;
				case Constant.CMD_SEND_CHANGE_COLLECT:
					GuiMgr.getInstance().guiTreasureIsLand.processChangeCollection(Data1["Gift"], OldData as SendChangeCollection);
					break;
				case Constant.CMD_SEND_CHANGE_MEDAL:
					GuiMgr.getInstance().guiChangeMedalEvent.processChangeMedal(Data1["Gift"]);
					break;
				case Constant.CMD_BUY_PASSWORD_FEATURE:
					GameLogic.getInstance().user.remainTimesInput = ConfigJSON.getInstance().GetItemList("Param")["Password"]["MaxTimesInput"];
					GameLogic.getInstance().user.passwordState = Constant.PW_STATE_NO_PASSWORD;
					GuiMgr.getInstance().guiPassword.Hide();
					GuiMgr.getInstance().guiPassword.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case Constant.CMD_CANCEL_CRACK_PASSWORD:
					GameLogic.getInstance().user.passwordState = Constant.PW_STATE_IS_LOCK;
					GuiMgr.getInstance().guiPassword.Hide();
					GuiMgr.getInstance().guiPassword.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case Constant.CMD_SEND_CRACK_PASSWORD:
					GameLogic.getInstance().user.passwordState = Constant.PW_STATE_IS_CRACKING;
					GameLogic.getInstance().user.timeStartCrackingPassword = GameLogic.getInstance().CurServerTime;
					GuiMgr.getInstance().guiPassword.Hide();
					GuiMgr.getInstance().guiPassword.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case Constant.CMD_SEND_CHANGE_PASSWORD:
					GuiMgr.getInstance().guiChangePassword.Hide();
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Thay đổi mật khẩu thành công!");
					break;
				case Constant.CMD_SEND_SIGN_IN:	
					GameLogic.getInstance().user.remainTimesInput = ConfigJSON.getInstance().GetItemList("Param")["Password"]["MaxTimesInput"];
					GameLogic.getInstance().user.passwordState = Constant.PW_STATE_IS_UNLOCK;
					GuiMgr.getInstance().guiPassword.Hide();
					GuiMgr.getInstance().guiPassword.showGUI();
					break;
				case Constant.CMD_RECIEVE_GIFT_EURO:
					GuiMgr.getInstance().guiEuroRewards.updateGift(Data1["Bonus"]);
					break;
				case Constant.CMD_GET_EURO_INFO:
					GuiMgr.getInstance().guiEventEuro.dataServer = Data1["EventEuro"];
					GuiMgr.getInstance().guiEventEuro.loadDataComplete = true;
					if(GuiMgr.getInstance().guiEventEuro.IsVisible)
					{
						GuiMgr.getInstance().guiEventEuro.updateData(Data1["EventEuro"]);
					}
					break;
				case Constant.CMD_GET_GIFT_TOUR_INFO:
					LogicTournament.getInstance().processGetGiftTourInfo(Data1);
					break;
				case Constant.CMD_GET_GIFT:
					LogicTournament.getInstance().processReceiveGiftTour(Data1);
					break;
				case Constant.CMD_BUY_CONFIRM:
					var guiConfirm:GUIConfirmBuyItem = GuiMgr.getInstance().guiConfirmBuyItem;
					if (guiConfirm.IsVisible)
					{
						var objServer:Object = Data1["Object"];
						
						if (objServer != null && objServer["UId"] == guiConfirm.itemMarket.seller["uId"] && objServer["Type"] == guiConfirm.itemMarket.itemType
						&& objServer["AutoId"] == guiConfirm.itemMarket.autoId && objServer["PriceTag"]["Diamond"] == guiConfirm.itemMarket.cost
						&& Ultility.compareObject(objServer["Object"], guiConfirm.itemMarket.data))
						{
							guiConfirm.setBuy(true);
						}
						else
						{
							guiConfirm.setBuy(false);
						}
					}
					break;
				case Constant.CMD_GET_ITEM_BACK:
					var guiSellMarket:GUISell = GuiMgr.getInstance().guiSell;
					if (guiSellMarket.IsVisible)
					{
						var position:int = OldData["Position"];
						var itemS:ItemSell = guiSellMarket.getItemSellByPosition(position);;
						guiSellMarket.removeGoods(itemS);
					}
					//if (itemS.data["Type"] == "Material")
						//GuiMgr.getInstance().GuiStore.UpdateStore("Material", itemS.data["Id"], itemS.data["Num"]);
					break;
				case Constant.CMD_BUY_ITEM:
					//trace("Constant.CMD_BUY_ITEM== " + OldData["PageType"]);
					if (OldData["PageType"]!= "Material")
					{
						/*if (OldData["PageType"] == "Quartz")
						{
							//trace("PageType ========= Quartz");
							var objQuartz:FishEquipment = new FishEquipment();
							objQuartz.Id = OldData["Id"];
							objQuartz.Type = OldData["Type"];
							objQuartz.Level = OldData["Level"];
							objQuartz.ItemId = OldData["ItemId"];
							
							var dataStore:Object = GameLogic.getInstance().user.loadFunctionQuartz(objQuartz.ItemId, objQuartz.Type, objQuartz.Level);
							
							objQuartz.Damage = dataStore.Damage;
							objQuartz.OptionDamage = dataStore.OptionDamage;
							
							objQuartz.Defence = dataStore.Defence;
							objQuartz.OptionDefence = dataStore.OptionDefence;
							
							objQuartz.Critical = dataStore.Critical;
							objQuartz.OptionCritical = dataStore.OptionCritical;
							
							objQuartz.Vitality = dataStore.Vitality;
							objQuartz.OptionVitality = dataStore.OptionVitality;
							
							GameLogic.getInstance().user.UpdateQuartzToStore(objQuartz, true)
						}*/
						GameLogic.getInstance().user.GenerateNextID();
					}
					else
					{
						GuiMgr.getInstance().GuiStore.UpdateStore("Material", OldData["ItemId"], OldData["Num"]);
					}
					break;
				case Constant.CMD_SELL_ITEM:
					var guiS:GUISell = GuiMgr.getInstance().guiSell;
					if(guiS.IsVisible)
					{
						var itemSell:ItemSell = guiS.getItemSellByPosition(OldData["Position"]);
						itemSell.channel = Data1["IdPage"];
						itemSell.AutoId = Data1["AutoId"];
					}
					//if (OldData["Type"] == "Material")
						//GameLogic.getInstance().user.UpdateStockThing("Material", OldData["ItemId"], -OldData["Num"]);
					break;
				case Constant.CMD_GET_LIST_SELL:
					trace(Data1);
					var guiSell:GUISell = GuiMgr.getInstance().guiSell;
					if (guiSell.IsVisible)
					{
						guiSell.updateListSell(Data1["Market"]["ItemList"]);
					}
					break;
				case Constant.CMD_GET_LIST_ITEM:
					var guiMarket:GUIMarket = GuiMgr.getInstance().guiMarket;
					if (guiMarket.IsVisible)
					{
						guiMarket.updateData(Data1["ItemList"]["Type"], Data1["ItemList"]["Data"]);
					}
					break;
				case Constant.CMD_CREATE_EQUIP:
					if (GuiMgr.getInstance().guiCreateEquipment.IsVisible)
					{
						GuiMgr.getInstance().guiCreateEquipment.showResult(Data1["Equip"]);
					}
					break;
				case Constant.CMD_SEND_SEPARATE_EQUIP:
					var guiChooseEquip:GUIChooseEquipment = GuiMgr.getInstance().GuiChooseEquipment;
					if (guiChooseEquip.IsVisible && guiChooseEquip.guiSeparateEquipment != null && guiChooseEquip.guiSeparateEquipment.img.visible)
					{
						guiChooseEquip.guiSeparateEquipment.showResult(Data1["Ingredients"]);
					}
					break;
				case Constant.CMD_GET_INGRADIENT:
					GameLogic.getInstance().user.ingradient = Data1["Ingredients"];
					GameLogic.getInstance().user.craftingSkills = Data1["CraftingSkills"];
					GameLogic.getInstance().user.restGoldBuyPower = Data1["RestGoldBuyPower"];
					//GameLogic.getInstance().user.restGBuyPower = Data1["RestGBuyPower"];
					var guiSeparate:GUISeparateEquipment = GuiMgr.getInstance().GuiChooseEquipment.guiSeparateEquipment;
					if (guiSeparate != null && guiSeparate.img != null && guiSeparate.img.visible)
					{
						GuiMgr.getInstance().GuiChooseEquipment.guiSeparateEquipment.updateListIngradient(Data1["Ingredients"]);
					}
					if (GuiMgr.getInstance().guiChooseFactory.IsVisible)
					{
						GuiMgr.getInstance().guiChooseFactory.updateSkillCreate(Data1["CraftingSkills"]);
					}
					break;
				case Constant.CMD_UPDATE_G:
					GameLogic.getInstance().user.SetUserZMoney(Data1["ZMoney"]);
					//trace("update G", Data1["ZMoney"]);
					break;
				case Constant.CMD_INIT_RUN:
				{
					GameLogic.getInstance().InitLogicGame(OldData.LakeId, Data1);
				}
				break;

				case Constant.CMD_USE_PETROL:
				{
					var ij:int = 0;
				}
				break;
				case Constant.CMD_CREATE_USER:
				{
					GameLogic.getInstance().InitLogicGame(1, Data1);
					var data:GetInitRun = new GetInitRun(Data1);
					GuiMgr.getInstance().GuiAnnounce.ShowAnnouce(false);
					if (GuiMgr.getInstance().GuiDailyBonus && GuiMgr.getInstance().GuiDailyBonus.IsVisible)
					{
						GuiMgr.getInstance().GuiDailyBonus.Hide();
					}
				}
				break;
				
				case Constant.CMD_BUY_DECORATE:
				case Constant.CMD_MOVE_DECORATE:
				case Constant.CMD_STORE_ITEM:
					break;
				case Constant.CMD_BUY_FISH:
					GameLogic.getInstance().processBuyFish(OldData as SendBuyFish, Data1);
					break;
				
				case Constant.CMD_USE_ITEM:
					var itemList:Object = OldData["ItemList"];
					for (var iSparta:String in itemList)
					{
						// Kiểm tra lại khi ngoài cá sparta, batman, swat còn loại khác nữa
						if (itemList[iSparta] && (itemList[iSparta]["ItemType"] == "Spiderman" || itemList[iSparta]["ItemType"] == "Sparta" || 
							itemList[iSparta]["ItemType"] == "Swat" || itemList[iSparta]["ItemType"] == "Batman" || itemList[iSparta]["ItemType"] == "Superman" ||
							itemList[iSparta]["ItemType"] == "Ironman"))
						{
							var fishArrSpartan:Array = GameLogic.getInstance().user.FishArrSpartan;
							for (var jSparta:int = 0; jSparta < fishArrSpartan.length; jSparta++) 
							{
								var fishSparta:FishSpartan = fishArrSpartan[jSparta];
								if (fishSparta.Id == itemList[iSparta]["Id"])
									fishSparta.StartTime = GameLogic.getInstance().CurServerTime;
							}
						}
					}
				break;
				
				case Constant.CMD_SNAPSHOT:
				{
					GuiMgr.getInstance().GuiSnapshot.updateData(Data1.Token, Data1.App_id, Data1.Username);
				}
				break;
				
				case Constant.CMD_SELL_FISH:
				{		
					
				}
				break;
				
				case Constant.CMD_EXCHANGE_STAR:
					//delete(GameLogic.getInstance().user.GetMyInfo().EventInfo["SoldierEvent"]);
					//var cfg:Object = ConfigJSON.getInstance().GetSoldierEventConfig("ChangeStar");
					//var myEventInfo:Object = GameLogic.getInstance().user.GetMyInfo().EventInfo;
					//myEventInfo = myEventInfo["SoldierEvent"];
					//myEventInfo["LuckyStar"] = myEventInfo["LuckyStar"] - cfg[OldData.GiftId].StarNum;
					break;
				case Constant.CMD_UNLOCK_LAKE:
					GameLogic.getInstance().ProcessUnlockLake();
					break;
				case Constant.CMD_UPGRADE_LAKE:
					GameLogic.getInstance().ProcessUpgradeLake(OldData);
					break;
				case Constant.CMD_REQ_DAILY_GIFT:
					GameLogic.getInstance().ProcessShowDailyGift(Data1);
					break;
				case Constant.CMD_LEVEL_UP:
					GameLogic.getInstance().ProcessLevelUp(Data1);
					if (GuiMgr.getInstance().GuiMain) {
						GuiMgr.getInstance().GuiMain.ShowLakes();
					}
					
					//Treasure Island
					if (Data1.EventList != null && Data1.EventList.TreasureIsland != null)
					{
						GuiMgr.getInstance().guiTreasureIsLand.timePlay = GameLogic.getInstance().CurServerTime * 1000 - 10 * 1000;
						GuiMgr.getInstance().guiTreasureIsLand.userData = Data1.EventList.TreasureIsland;
					}
					
					var cf:Object = ConfigJSON.getInstance().GetItemList("EventIceCream");
					if (Data1.EventList != null && Data1.EventList.IceCream != null)
					{
						if(GuiMgr.getInstance().GuiMainEventIceCream.DataIceCream == null)
						{
							GuiMgr.getInstance().GuiMainEventIceCream.DataIceCream = Data1.EventList.IceCream;
						}
						var mch:MachineMakeCream = GameLogic.getInstance().user.machineMakeIceCream;
						if (GameLogic.getInstance().user.machineMakeIceCream == null)
						{
							GameLogic.getInstance().user.InitMachineIceCream();
						}
						
						if (EventMgr.CheckEvent("IceCream") == EventMgr.CURRENT_IN_EVENT && 
							GameLogic.getInstance().user.GetLevel() == 7) 
						{
							GameLogic.getInstance().user.UpdateStockThing("IceCreamItem", 1, 1);
							GameLogic.getInstance().user.UpdateStockThing("IceCreamItem", 2, 1);
							GameLogic.getInstance().user.UpdateStockThing("IceCreamItem", 4, 10);
						}
					}
					break;
				case Constant.CMD_CLEAN_LAKE:
					GameLogic.getInstance().ProcessCleanLake(OldData, Data1)
					break;
				
				case Constant.CMD_LOAD_INVENTORY:
				{
					GameLogic.getInstance().user.InitStore(Data1);
					if (GuiMgr.getInstance().guiSpecialSmithy.IsVisible)
					{
						GuiMgr.getInstance().guiSpecialSmithy.ClearComponent();
						GuiMgr.getInstance().guiSpecialSmithy.refreshComponent();
					}
					
					if (GuiMgr.getInstance().GuiChooseEquipment.IsVisible)
					{
						GuiMgr.getInstance().GuiChooseEquipment.ClearComponent();
						GuiMgr.getInstance().GuiChooseEquipment.refreshComponent();
					}
					
					if (GuiMgr.getInstance().GuiStoreEquipment.IsVisible)
					{
						GuiMgr.getInstance().GuiStoreEquipment.ClearComponent();
						GuiMgr.getInstance().GuiStoreEquipment.refreshComponent();
					}
					
					if (GuiMgr.getInstance().GuiEnchantEquipment.IsVisible)
					{
						GuiMgr.getInstance().GuiEnchantEquipment.UpdateGUIEnchant();
					}
					
					if (GuiMgr.getInstance().GuiUnlockEquipment.IsVisible)
					{
						GuiMgr.getInstance().GuiUnlockEquipment.UpdateGUIUnlockEquip();
					}
					
					if (GuiMgr.getInstance().guiSell.IsVisible)
					{
						GuiMgr.getInstance().guiSell.updateDataStore();
					}
					
					if (GuiMgr.getInstance().guiMixMaterial.IsVisible)
					{
						GuiMgr.getInstance().guiMixMaterial.updateGUI();
					}
					
					/*lấy kết quả cho gui đan*/
					if (GuiMgr.getInstance().GuiGemRefine.IsVisible)
					{
						GuiMgr.getInstance().GuiGemRefine.receiveAllGem(Data1["StoreList"]);
					}
				}
				break;
				
				case Constant.CMD_LOAD_INVENTORY_SOLDIER:
				{
					GameLogic.getInstance().user.InitStoreSoldier(Data1);
				}
				break;
				
				case Constant.CMD_CLICK_GRAVE:
				{
					GameLogic.getInstance().GraveBonus.push(Data1.Bonus);
				}
				break;
				case Constant.CMD_MATE_FISH:
				{		
					GameLogic.getInstance().ProcessMateFish(Data1);
				}
				break;
				
				case Constant.CMD_SELL_STOCK_THING:
				{
					//trace("ban do trong kho: " + Data1.Error);
				}
				break;
				
				case Constant.CMD_CURE_FISH:
				{
					//trace("chua benh cho ca: " + Data1.Error);
					GameLogic.getInstance().ProcessCureFish(Data1, OldData);							
				}
				break;
				case Constant.CMD_CARE_FISH: 
				{
					//trace("cham soc ca: " + Data1.Error);
					GameLogic.getInstance().ProcessCareFish(Data1, OldData);						
				}
				break;
				
				case Constant.CMD_RECHOOSE_DAILY_BONUS:
				{
					// Load dữ liệu quà mới :x
					GuiMgr.getInstance().GuiDailyBonus.WilLChoseButtonArray = [];
					GuiMgr.getInstance().GuiDailyBonus.WilLChoseButtonArray.push(Data1.Bonus);
					GuiMgr.getInstance().GuiDailyBonus.processRechoose(Data1.Bonus, OldData.Day);
					GuiMgr.getInstance().GuiDailyBonus.isSendReChoose = false;
				}
				break;
				
				case Constant.CMD_FEED_FISH:
				{			
					//trace("cho ca an");
					GameLogic.getInstance().ProcessNotifyFeedFish(Data1, OldData);								
				}
				break;
				
				case Constant.CMD_SEN_GET_REWARD_EVENT_WAR_CHAMPION:
				{			
					
				}
				break;
				
				case Constant.CMD_GET_ALL_SOLDIER:
				{
					var u:User = GameLogic.getInstance().user;
					//var isFriendLake:Boolean = GameLogic.getInstance().user.IsViewer();
					
					if (OldData.UserId && OldData.UserId != u.GetMyInfo().Id)
					{
						u.FishSoldierAllArr.splice(0, u.FishSoldierAllArr.length);
					}
					else
					{
						var myInfo:MyUserInfo = u.GetMyInfo();
						myInfo.MySoldierArr.splice(0, myInfo.MySoldierArr.length);
					}
					
					u.NumSoldier = 0;
					for (var lakeId:String in Data1.SoldierList)
					{
						for (var str:String in Data1.SoldierList[lakeId])
						{
							var fs:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "");
							fs.SetInfo(Data1.SoldierList[lakeId][str]);
							//fs.SetEquipmentInfo(Data1.SoldierList[lakeId][str].Equipment);
							
							//Set thong tin ngu mach
							if (Data1["MeridianList"][fs.Id] != null)
							{
								fs.meridianRank = int(Data1["MeridianList"][fs.Id]["meridianRank"]);
								fs.meridianPosition = int(Data1["MeridianList"][fs.Id]["meridianPosition"]);
								fs.meridianPoint = int(Data1["MeridianList"][fs.Id]["meridianPoint"]);
								
								fs.meridianVitality = int(Data1["MeridianList"][fs.Id]["Vitality"]);
								fs.meridianDamage = int(Data1["MeridianList"][fs.Id]["Damage"]);
								fs.meridianCritical = int(Data1["MeridianList"][fs.Id]["Critical"]);
								fs.meridianDefence = int(Data1["MeridianList"][fs.Id]["Defence"]);
							}
							else
							{
								fs.meridianRank = 1;
								fs.meridianPosition = 0;
								fs.meridianPoint = 0;
							}
							
							if (Data1.EquipmentList[fs.Id] == null)
							{
								Data1.EquipmentList[fs.Id] = new Object();
								Data1.EquipmentList[fs.Id].Equipment = new Object();
								Data1.EquipmentList[fs.Id].Index = new Object();
							}
							else 
							{
								if (Data1.EquipmentList[fs.Id].Equipment == null)
								{
									Data1.EquipmentList[fs.Id].Equipment = new Object();
								}
								if (Data1.EquipmentList[fs.Id].Index == null)
								{
									Data1.EquipmentList[fs.Id].Index = new Object();
								}
							}
							
							fs.SetEquipmentInfo(Data1.EquipmentList[fs.Id].Equipment);
							fs.SetSoldierInfo();
							fs.UpdateCombatSkill();
							fs.LakeId = int(lakeId);
							if (fs.CheckStatus() == 3)
							{
								continue;
							}
							var soldier:FishSoldier;
							if (!OldData.UserId || OldData.UserId == u.GetMyInfo().Id)
							{
								myInfo.MySoldierArr.push(fs);
								if (!GameLogic.getInstance().user.IsViewer())
								{
									for each(soldier in GameLogic.getInstance().user.FishSoldierArr)
									{
										if (soldier.Id == fs.Id)
										{
											soldier.meridianDamage = fs.meridianDamage;
											soldier.meridianVitality = fs.meridianVitality;
											soldier.meridianCritical = fs.meridianCritical;
											soldier.meridianDefence = fs.meridianDefence;
											
											soldier.Vitality = fs.Vitality;
											soldier.Damage= fs.Damage;
											soldier.Critical = fs.Critical;
											soldier.Defence = fs.Defence;
											soldier.SetEquipmentInfo(Data1.EquipmentList[fs.Id].Equipment);
											soldier.RefreshImg();
											break;
										}
									}
								}
							}
							else
							{
								u.FishSoldierAllArr.push(fs);
								if (GameLogic.getInstance().user.IsViewer())
								{
									for each(soldier in GameLogic.getInstance().user.FishSoldierArr)
									{
										if (soldier.Id == fs.Id)
										{
											soldier.meridianDamage = fs.meridianDamage;
											soldier.meridianVitality = fs.meridianVitality;
											soldier.meridianCritical = fs.meridianCritical;
											soldier.meridianDefence = fs.meridianDefence;
											
											soldier.Vitality = fs.Vitality;
											soldier.Damage= fs.Damage;
											soldier.Critical = fs.Critical;
											soldier.Defence = fs.Defence;
											soldier.SetEquipmentInfo(Data1.EquipmentList[fs.Id].Equipment);
											soldier.RefreshImg();
											break;
										}
									}
								}
							}
							
							u.NumSoldier++;
						}
					}
					//if(!u.IsViewer())
						//GuiMgr.getInstance().GuiTopInfo.btnLeague.SetVisible(u.NumSoldier > 0);
					//cập nhật cho cái nút liên đấu
					LeagueMgr.getInstance().hasUpdateButton = true;
				}
				break;
				
				//case Constant.CMD_ATTACK_FRIEND_LAKE:
				//{
					//GameLogic.getInstance().FishWarResult.splice(0, GameLogic.getInstance().FishWarResult.length);
					//GameLogic.getInstance().FishWarResult = Data1.Bonus;
					//GameLogic.getInstance().IsWin = Data1.isWin;
					//GameLogic.getInstance().IsWin = 2;
					//
					//if (GameLogic.getInstance().myAtkFish)
					//{
						//GuiMgr.getInstance().GuiFishWarMovie.Init(GameLogic.getInstance().myAtkFish,  Data1.FishId);
						//GameLogic.getInstance().myAtkFish = null;
					//}
				//}
				//break;
				
				case Constant.CMD_GET_BONUS_SOLDIER:
				{
					
				}
				break;
				break;
				
				case Constant.CMD_LEVEL_UP_SOLDIER:
				{
					
				}
				break;
				
				case Constant.CMD_RECOVER_HEALTH_SOLDIER:
				{
					
				}
				break;
				case Constant.CMD_SEND_USE_RANK_POINT_BOTTLE:
				{
					if (Data1.Error == 0)
					{
						GameLogic.getInstance().increaseRankPoint2(Data1, OldData as SendUseRankPointBottle);
					}
				};
				break;
				case Constant.CMD_REBORN_SOLDIER:
				{
					
				}
				break;
				
				case Constant.CMD_REFRESH_FRIEND:
				{				
					if (LeagueController.getInstance().mode == LeagueController.IN_HOME)//chỉ refresh friend khi ở ngoài liên đấu
					{
						GameLogic.getInstance().ProcessRefreshFriend(Data1);				
					}
				}
				break;
				
				case Constant.CMD_ENCHANT_EQUIPMENT:
				{
					GuiMgr.getInstance().GuiEnchantEquipment.ProcessEnchantEquipAfter(Data1.isSuccess, OldData.isMoney, OldData.UseGodCharm, Data1.EnchantLevel);
				}
				break;
				case Constant.CMD_CHANGE_ENCHANT_LEVEL:
					GuiMgr.getInstance().GuiEnchantEquipment.ProcessEnchantEquipAfter2(Data1, OldData);
				break;
				case Constant.CMD_SEND_LETTER:
				{
					//trace("send letter:" + Data1.Error);
					//ngày nay :D
					if (!GameLogic.getInstance().user.IsViewer())//ở nhà mình
					{
						if(GUINewMail.bReply)
							GuiMgr.getInstance().GuiNewMail.SendFast(GUINewMail.curSuffixId, true);
					}
				
					var txt: String = Localization.getInstance().getString("Message8");
					GuiMgr.getInstance().GuiMessageBox.ShowOK(txt,310,215, GUIMessageBox.NPC_MERMAID_NORMAL);
					GuiMgr.getInstance().GuiSendLetter.Hide();
					GuiMgr.getInstance().GuiReplyLetter.Hide();
					GuiMgr.getInstance().GuiReceiveLetter.Hide();
					
				//	GuiMgr.getInstance().GuiLetter.Hide();
				}
				break;
				
				case Constant.CMD_ACCEPT_DAILY_GIFT:
				{
					GameLogic.getInstance().user.SetUserZMoney(Data1.ZMoney);
				}
				break;
				
				case Constant.CMD_LOAD_MAIL:
				{
					GameLogic.getInstance().ProcessMailBox(Data1);
				}
				break;
				case Constant.CMD_INPUT_CODE:
					GuiMgr.getInstance().GuiInputCode.processReceiveGift(Data1);
				break;
				case Constant.CMD_LOAD_GIFT:
				{
					GameLogic.getInstance().ProcessGiftBox(Data1);
				}
				break;
				
				case Constant.CMD_REMOVE_MESSAGE:
				{
					//trace("remove:" + Data1.Error);
				
					//GuiMgr.getInstance().GuiReceiveLetter.Hide();
					
				}
				break;
				case Constant.CMD_SEND_GIFT:
				{
					//trace("send gift " + Data1.Error);
					//GuiMgr.getInstance().GuiGiftSend.Hide();
					//GuiMgr.getInstance().GuiGift.Hide();
					//GuiMgr.getInstance().GuiReceiveGift.Hide();
					var txt1: String = Localization.getInstance().getString("Message12");
					GuiMgr.getInstance().GuiMessageBox.ShowOK(txt1, 310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
					
					// QuestPowerTinh
					var task:TaskInfo = QuestMgr.getInstance().QuestPowerTinh[QuestMgr.QUEST_PT_GIFT].TaskList[0] as TaskInfo;
					if (!task.Status)
					{
						task.Num += OldData.ReceiveList.length;
					}
					QuestMgr.getInstance().UpdatePointReceive();
				}break;
				case Constant.CMD_ACCEPT_GIFT:
					//Nhận quà trứng thần trả về cua thần hoặc tôm thần
					if (Data1["ItemType"] == "ItemCollection" && (Data1["ItemId"] == 9 || Data1["ItemId"] == 10))
					{
						GuiMgr.getInstance().guiCongratulation.showGUI(Data1["ItemType"], Data1["ItemId"], 1, true, Localization.getInstance().getString(Data1["ItemType"] + Data1["ItemId"]));
					}
					if (Data1["ItemType"] == "Island_Item" && (Data1["ItemId"] == 1 || Data1["ItemId"] == 2))
					{
						GuiMgr.getInstance().guiCongratulation.showGUI(Data1["ItemType"], Data1["ItemId"], 1, true, Localization.getInstance().getString(Data1["ItemType"] + Data1["ItemId"]));
					}
				break;			
				
				case Constant.CMD_PLAY_SLOT_MACHINE:
				{
					//GuiMgr.getInstance().GuiSlotMachine.SetResult(new Array(Data1.Lucky_1 , Data1.Lucky_2, Data1.Lucky_3));					
				}
				break;
				
				case Constant.CMD_GET_TOTAL_FISH:
				{					
					GameLogic.getInstance().user.SetLakeInfo(Data1);					
				}
				break;
				
				case Constant.CMD_GET_BUFF_LAKE:
				{
					GameLogic.getInstance().user.buffTimeAllLake = Data1["ListBUff"];
					//GuiMgr.getInstance().GuiMixFish.buffTimeLake = GameLogic.getInstance().user.buffTimeAllLake;
					//GuiMgr.getInstance().GuiMixFish.isReceivedFish = true;
					GuiMgr.getInstance().guiMateFish.isReceivedFish = true;
					GameLogic.getInstance().updateDeco();
					if(GuiMgr.getInstance().GuiMain)
						GuiMgr.getInstance().GuiMain.addTipBuffLake(Data1["ListBUff"]);
					//GuiMgr.getInstance().GuiTopInfo.btnLeague.SetEnable(true);
					//var rank:int = GameLogic.getInstance().user.Rank;
					//GuiMgr.getInstance().GuiTopInfo.tfRank.text = LeagueController.rankText(rank);
				}
				break;
				
				case Constant.CMD_STEAL_MONEY:
				{
					GameLogic.getInstance().ProcessMoneyPocket(OldData, Data1, Type);
				}
				break;
				
				case Constant.CMD_COLLECT_MONEY:
				{
					// update fish rare
					//for (var iCollectmoney:int = 0; iCollectmoney < GameLogic.getInstance().user.FishArr.length; iCollectmoney++)
					//{
						//var fishCollectMoney:Fish = GameLogic.getInstance().user.FishArr[iCollectmoney];
						//if (OldData["FishId"] == fishCollectMoney.Id && fishCollectMoney.FishType != 0) 
						//{
							//fish1.FeedAmount = Math.max( -fish1.Full(), 0) / Fish.AffectTime;
							//fishCollectMoney.StartTime = GameLogic.getInstance().CurServerTime;
							//fishCollectMoney.NumUpLevel ++;
							//fishCollectMoney.Level ++;
							//fishCollectMoney.LastGetLevelGift = fishCollectMoney.Level - 1;
							//fishCollectMoney.HarvestTime = ConfigJSON.getInstance().getFishHarvest(fishCollectMoney.FishTypeId, fishCollectMoney.FishType, fishCollectMoney);
							//fishCollectMoney.FeedAmount = Math.max( -fishCollectMoney.HungryTime(), 0) / Fish.AffectTime;
							//
							//fishCollectMoney.isCreatePocket = false;
							//fishCollectMoney.isSendLevelUP = false;
						//}
					//}
					GameLogic.getInstance().ProcessMoneyPocket(OldData, Data1, Type);
				}
				break;
				
				case Constant.CMD_CHANGE_FISH:
				{
					//trace("chuyển hồ: " + Data1.Error);
				}
				break;
				
				case Constant.CMD_FEED_ONWALL:
				{
					if (Data1["Error"] == 0)	
					{
						//trace("Feed OK");
					}
				}
				break;
				
				// Minigame Cau ca
				case Constant.CMD_FISHING:
				{
					//trace("fishing" + getTimer());
					// Het nang luong, return luon
					if (Data1.Error == 10)
					{
						return;
					}

					//trace("cau ca: " + Data1.Error);
					GameLogic.getInstance().ProcessFishing(Data1);
					
				}
				break;
				
				case Constant.CMD_GET_DAILY_QUEST:
				{
					//du lieu quest
					QuestMgr.getInstance().InitDailyQuest(Data1.DailyQuest, OldData.IsView);
					break;
				}
				
				case Constant.CMD_SEND_GET_POWER_TINH_QUEST:
				{
					QuestMgr.getInstance().InitQuestPowerTinh(Data1.Quest);
					if (GuiMgr.getInstance().GuiQuestPowerTinh.IsVisible)
					{
						GuiMgr.getInstance().GuiQuestPowerTinh.RefreshComponent();
					}
					break;
				}
				
				case Constant.CMD_GET_DAILY_QUEST_NEW:
				{
					// Dữ liệu về daily quest mới
					QuestMgr.getInstance().InitDailyQuestNew(Data1, OldData.IsView);
					QuestMgr.getInstance().isUnlock = Data1.UnlockQuest2;
					break;
				}
				
				case Constant.CMD_COMPLETE_DAILY_QUEST_NEW:
				{
					// Hiển thị GUI thông báo
					var questIndex:int = QuestMgr.getInstance().curDailyQuest;
					GuiMgr.getInstance().GuiCompleteDailyQuestNew.Init(Data1["Gift"], questIndex + 1, true);
					break;
				}
				
				case Constant.CMD_UNLOCK_DAILYQUEST:
				{
					//hiển thị cho làm quest#2
					//var cost:int = QuestMgr.getInstance().XuInfo["XuUnlock"];
					//QuestMgr.getInstance().isUnlock = true;
					//QuestMgr.getInstance().UnlockQuest2();
					//GameLogic.getInstance().user.UpdateUserZMoney(-cost);
					break;
				}
				
				case Constant.CMD_DONE_DAILY_QUEST_BY_XU:
				{
					// Hoàn thành nhiệm vụ bằng Xu thành công!!!!
					//var string:String = OldData.IdDailyQuest;
					//var arrTemp:Array = string.split("t");
					//var costFast:int = QuestMgr.getInstance().XuInfo[arrTemp[1]];
					//GameLogic.getInstance().user.UpdateUserZMoney( -costFast);
					//QuestMgr.getInstance().DoneTaskWithXu(OldData.IdDailyQuest, OldData.IdTask);
					break;
				}
				
				case Constant.CMD_GET_SERIES_QUEST:
				{
					//du lieu quest
					QuestMgr.getInstance().InitSeriesQuest(Data1.QuestList);
					break;
				}
				
				case Constant.CMD_COMPLETE_DAILY_QUEST:
				{
					//trace("Nhận quà daily quest: " + Data1.Error);
					GameLogic.getInstance().user.RecieveDailyQuestGift(OldData.QuestId);
					break;
				}
				
				case Constant.CMD_COMPLETE_SERIES_QUEST:
				{	
					QuestMgr.getInstance().ClearAllSeriQuest();
					if (Data1["QuestInfo"] != null && Data1["QuestInfo"]["ElementMainQuest"] != null && int(Data1["QuestInfo"]["ElementMainQuest"]) > 0)
					{
						GuiMgr.getInstance().guiMainQuest.soldierElement = int(Data1["QuestInfo"]["ElementMainQuest"]);
					}
					//Khoi tao quest moi
					for (var j:String in Data1.QuestList)
					{
						var quest:QuestInfo = new QuestInfo();
						quest.IdSeriesQuest = Data1.QuestList[j].Id;
						quest.SetInfo(Data1.QuestList[j].Quest);
						quest.LevelRequire = ConfigJSON.getInstance().GetSeriesQuestInfo(quest.IdSeriesQuest, "LevelRequire") as int;
						quest.UpdateStatusQuest();
						if (Data1.QuestList[j].Status == false)
						{
							QuestMgr.getInstance().SeriesQuest.push(quest);
							//if (quest.IdSeriesQuest == OldData.SeriesQuestId)
							//{
								//GuiMgr.getInstance().guiMainQuest.showGUI(quest);
							//}
						}
					}
					//Sắp xếp lại thứ tự
					QuestMgr.getInstance().SeriesQuest.sortOn("LevelRequire", Array.NUMERIC);
					//Khởi tạo lại các nút seriquest
					GuiMgr.getInstance().guiFrontScreen.initBtnSeriesQuest();
					//Hard code show quest dau tien sau khi gioi thieu ngu chien
					if (quest != null && quest.IdSeriesQuest == 1 && quest.Id == 2)
					{
						GuiMgr.getInstance().guiMainQuest.showGUI(quest);
					}
					break;
				}
				
				case Constant.CMD_SET_LOG:
				{
					break;
				}
				
				case Constant.CMD_GET_ALL_LOG:
				{
					GuiMgr.getInstance().GuiLog.setInfo(Data1);
					GuiMgr.getInstance().GuiLog.RefreshComponent();
					break;
				}
				
				case Constant.CMD_REMOVE_LOG:
				{
					//GuiMgr.getInstance().GuiLog.setInfo(Data1);
					//GuiMgr.getInstance().GuiLog.RefreshComponent();
					break;
				}
				
				case Constant.CMD_MATERIAL:
					if(GuiMgr.getInstance().GuiRawMaterials.IsVisible)
						GuiMgr.getInstance().GuiRawMaterials.UpdateMaterialUserOk(Data1, OldData);
				break;
				
				
				case  Constant.CMD_CREATE_GIFT_FOR_FISH:
					GameLogic.getInstance().UpdateListGift(Data1, OldData);
					var arrFish:Array = GameLogic.getInstance().user.FishArr;
					for (var i:int = 0; i < arrFish.length; i++) 
					{
						var fish:Fish = arrFish[i] as Fish;
						if (fish.Id == OldData["FishId"])	
						{
							//if(fish.NumUpLevel > 0)
								fish.SetEmotion(Fish.GIFT);
								//GameLogic.getInstance().CreatePocket(fish);
							//else 
								//GameLogic.getInstance().CreatePocket(fish);
						}
					}
				break;
				
				case Constant.CMD_GET_GIFT_OF_FISH:
					var arrFish1:Array = GameLogic.getInstance().user.FishArr;
					for (var i1:int = 0; i1 < arrFish1.length; i1++) 
					{
						var fish1:Fish = arrFish1[i1] as Fish;
						if (fish1.Id == OldData["FishId"])	
						{
							fish1.FeedAmount = Math.max(-fish1.HungryTime(), 0) / Fish.AffectTime;
							fish1.StartTime = GameLogic.getInstance().CurServerTime;
							fish1.LastGetLevelGift = fish1.Level - 1;
							fish1.isSendLevelUP = false;
						}
					}
					
					for (var i2:int = 0; i2 < GameLogic.getInstance().user.AllFishArr.length; i2++) 
					{
						if (GameLogic.getInstance().user.AllFishArr[i2].Id == OldData["FishId"])	
						{
							GameLogic.getInstance().user.AllFishArr[i2].Level = int(GameLogic.getInstance().user.AllFishArr[i2].Level) + 1;
						}
					}
				break;
				
				case  Constant.CMD_CHOOSE_AVATAR:
					GameLogic.getInstance().user.AvatarType = OldData["AvatarType"];
					/*if(!GameController.getInstance().isSmallBackGround)
					{
						GuiMgr.getInstance().GuiCharacter.Show(Constant.OBJECT_LAYER);
					}*/
				break;	
				
				// FishWorld
				case  Constant.CMD_LOAD_OCEAN_SEA:
					if (GuiMgr.getInstance().GuiMessageBox.IsVisible)
					{
						GuiMgr.getInstance().GuiMessageBox.Hide();
					}
					if (GuiMgr.getInstance().GuiFinalKillBoss.IsVisible)
					{
						GuiMgr.getInstance().GuiFinalKillBoss.Hide();
					}
					FishWorldController.SetSeaId(Constant.TYPE_MYFISH);
					FishWorldController.SetRound(1);
					GuiMgr.getInstance().GuiMapOcean.InitDataForAllSea(Data1.World.SeaList);
					GuiMgr.getInstance().GuiMapOcean.Show(Constant.GUI_MIN_LAYER, 3);
					//GuiMgr.getInstance().GuiMain.isSendLoadOcean = false;
					//GuiMgr.getInstance().GuiMain.Hide();
					GuiMgr.getInstance().GuiSetting.SetPos(Constant.STAGE_WIDTH - 27, 76);
					GuiMgr.getInstance().guiFrontScreen.isSendLoadOcean = false;
				break;	
				case Constant.CMD_UNLOCK_OCEAN_SEA:
					if (GuiMgr.getInstance().GuiUnlockOcean.IsVisible)	GuiMgr.getInstance().GuiUnlockOcean.Hide();
					var objectOcean:Object = new Object();
					objectOcean[String(Data1.Sea.SeaId)] = Data1.Sea;
					GuiMgr.getInstance().GuiMapOcean.InitDataForAllSea(objectOcean, false);
					GuiMgr.getInstance().GuiMapOcean.RefreshComponent();
				break;
				case Constant.CMD_CHOOSE_ROUND_ATTACK:
					if (OldData.RoundId == 1)
					{
						GuiMgr.getInstance().GuiMainForest.objSequenceRedUp = Data1.Sequence;
					}
					else if (OldData.RoundId == 3)
					{
						GuiMgr.getInstance().GuiMainForest.objSequenceGreenDown = Data1.Sequence;
						GuiMgr.getInstance().GuiMainForest.objHideGreenDown = Data1.ArrHide;
						GuiMgr.getInstance().GuiChooseSerialAttack.StartProcessChooseSerial(Data1);
					}
					else  if (OldData.RoundId == 2)
					{
						GuiMgr.getInstance().GuiMainForest.objEffYellowRight = Data1.Sequence;
						
					}
					break;
				case Constant.CMD_JOIN_SEA_AGAIN:
					FishWorldController.SetSeaId(Data1.Sea.SeaId);
					FishWorldController.SetInfoForRound1(Data1);
					var objectJoinOcean:Object = new Object();
					objectJoinOcean[String(Data1.Sea.SeaId)] = Data1.Sea;
					GuiMgr.getInstance().GuiMapOcean.InitDataForAllSea(objectJoinOcean);
					GuiMgr.getInstance().GuiMapOcean.GoToOcean(Data1.Sea.SeaId);
					GuiMgr.getInstance().GuiIntroOcean.ShowGUI();
					if (GuiMgr.getInstance().GuiWaitReJoinMap.IsVisible)	GuiMgr.getInstance().GuiWaitReJoinMap.Hide();
					SendJoinSeaAgain.isSendPacket = false;
				break;
				case Constant.CMD_GET_SERIAL_ATTACK_FOREST_YELLOW:
				{
					GuiMgr.getInstance().GuiChooseSerialAttack.StartProcessChooseSerial(Data1);
					break;
				}
				case Constant.CMD_GET_SIGN_KEY:
					var temp:NewFeedWall = NewFeedWall.GetInstance();
					if (ExternalInterface.available) {
						
						ExternalInterface.call("getDialog_ffs", Constant.PUBLIC_KEY, Data1["signKey"], temp.actId, temp.userIdTo, temp.objectId,
							temp.attachName, temp.attachHref, temp.attachCaption, temp.attachDescription, temp.mediaType, temp.mediaImage, temp.mediaSource,
							temp.actionLinkText, temp.actionLinkHref, temp.tplId, temp.suggestion);
					}
				break;
				
				case Constant.CMD_ICE_CREAM_MAKE_HEAVY_RAIN:
					GuiMgr.getInstance().GuiMainEventIceCream.ShowEffHeavy();
					break;
				case Constant.CMD_ICE_CREAM_THEFT_ICE_CREAM:
					GuiMgr.getInstance().GuiHarvestIceCream.Init(Data1, OldData.SlotId);
					break;
				case Constant.CMD_ICE_CREAM_HARVEST_ICE_CREAM:
					GuiMgr.getInstance().GuiHarvestIceCream.Init(Data1, OldData.SlotId);
					GuiMgr.getInstance().GuiMainEventIceCream.waitDataServerSuccess = -1;
					break;
				
				case Constant.CMD_ICE_CREAM_MAKE_RAIN:
					if (GuiMgr.getInstance().GuiMainEventIceCream.DataIceCream.Rain == null)
					{
						GuiMgr.getInstance().GuiMainEventIceCream.DataIceCream.Rain = new Object();
					}
					GuiMgr.getInstance().GuiMainEventIceCream.DataIceCream.Rain.LifeTime = Data1.ExpiredTime;
					break;
					
				case Constant.CMD_LEVEL_UP_SKILL_MATERIAL:
					//Thiết lập biến 
					GuiMgr.getInstance().GuiRawMaterials.IsUpgardeLevelMat = true;
					GuiMgr.getInstance().GuiRawMaterials.Data = Data1;
				break;
				
				case Constant.CMD_FILL_ENERGY:
					var objGeneral:Object = ConfigJSON.getInstance().GetItemList("Param"); //GetItemInfo("General", user.GetMyInfo().NumFill);
					var obj:Object = objGeneral.FillEnergy;
					var user:User = GameLogic.getInstance().user;
					user.UpdateUserZMoney( -obj[(user.GetMyInfo().NumFill - 1).toString()], true);
					GameLogic.getInstance().user.GetMyInfo().Energy = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel(true));
					if (GuiMgr.getInstance().GuiFillEnergy.IsVisible)
					{
						GuiMgr.getInstance().GuiFillEnergy.Hide()
					}
					/*if (GuiMgr.getInstance().GuiMixFish.IsVisible)
					{
						GuiMgr.getInstance().GuiMixFish.updateFillEnergy();
					}*/
					if (GuiMgr.getInstance().guiMateFish.IsVisible)
					{
						GuiMgr.getInstance().guiMateFish.updateFillEnergy();
					}
					if (GuiMgr.getInstance().GuiFillEnergy.IsVisible)
					{
						GuiMgr.getInstance().GuiFillEnergy.Hide()
					}
					user.GetMyInfo().LastFillEnergy = GameLogic.getInstance().CurServerTime;
				break;
				case Constant.CMD_UPDATE_SPARTA:
					
				break;
				
				case Constant.CMD_ATTACK_BOSS_FOREST:
					//if (Data1.MySoldier)
					//{
						//Ultility.UpdateFishSoldier(Data1.MySoldier, null, GameLogic.getInstance().user.FishSoldierActorMine, true);
						//Ultility.UpdateFishSoldier(Data1.MySoldier, null, GameLogic.getInstance().user.GetMyInfo().MySoldierArr, true);
					//}
					GuiMgr.getInstance().GuiBackMainForest.ProcessDataForAttackBoss(Data1);
					GuiMgr.getInstance().GuiInfoForestWorld.UpdateAllFishCanGetGift();
				break;
				
				case Constant.CMD_SEND_CLICK_MERMAID:					
					GuiMgr.getInstance().GuiTienCa.setInfo(Data1);		
					GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + Data1.Bonus[1].Num, GameLogic.getInstance().isEventDuplicateExp); //Phần tử 1 là tiền
					break;
				
				case Constant.CMD_EXCHANGEFAIRYDROP:
				{
					if (Data1.Error == 0)
					{//Đổi ngọc thành công
						GuiMgr.getInstance().GuiFishMachine.DoCrushFish2(Data1);
					}
					else
					{//sai
						//Message Box
						
					}
					
					break;
				}
				case Constant.CMD_BUY_FAIRY_DROP:
				{
					//if (Data1.Error == 0)
					//{//Mua thành công
						//GuiMgr.getInstance().GuiFishMachine.BuySomeThing2();
					//}
					//else
					//{//sai
						//MessageBox
					//}
					break;
				}
				case Constant.CMD_OPEN_MAGIC_BAG:
				{
					if (Data1.Error == 0)
					{
						//GameLogic.getInstance().ReceiveFromMagicBag(Data1);
						GuiMgr.getInstance().GuiStore.getDataMagicBagFromServer(Data1);
					}
					else
					{//sai
						//MessageBox
					}
					break;
				}
				//case Constant.CMD_OPEN_LIXI:
				//{
					//if (Data1.Error == 0)
					//{
						//GuiMgr.getInstance().GuiForEffect.receiveLixiHost(Data1);
					//}
				//};
				break;
				case Constant.CMD_UPGRADE_GEM:
					//tmpSonbt = (OldData as SendUpgradeGem).SlotId + 1;
					//if (Data1.Error == 0)
					//{
						//GuiMgr.getInstance().GuiPearlRefine.ShowGuiClickRefine(tmpSonbt);
					//}
					//GuiMgr.getInstance().GuiPearlRefine.setIsSendList(tmpSonbt);

				break;
				case  Constant.CMD_GET_GEM:
					//tmpSonbt = (OldData as SendGetGem).GemId + 1;
//
					//if (Data1.Error == 0)
					//{
						//GuiMgr.getInstance().GuiPearlRefine.ShowGuiClickReceive(tmpSonbt );
					//}
					//GuiMgr.getInstance().GuiPearlRefine.setIsSendList(tmpSonbt );
				break;
				case Constant.CMD_QUICK_UPGRADE:
					//tmpSonbt = (OldData as SendQuickUpgrade).GemId + 1;
//
					//if (Data1.Error == 0)
					//{
						//GuiMgr.getInstance().GuiPearlRefine.ShowGuiClickBuyG(tmpSonbt);
					//}
					//GuiMgr.getInstance().GuiPearlRefine.setIsSendList(tmpSonbt);
					//hiepnm2
					
					if (Data1.Error == 0)
					{
						GuiMgr.getInstance().GuiGemRefine.processQuickRefine(OldData);
					}

				break;
				case  Constant.CMD_CANCEL_UPGRADE:
					//hiepnm2
					
					var idSlot:int = (OldData as SendCancelUpgrade).GemId;
					if (Data1.Error == 0)
					{
						GuiMgr.getInstance().GuiGemRefine.processCanCelUpgrading(idSlot);
					}
					
					//tmpSonbt = (OldData as SendCancelUpgrade).GemId;
					//if (Data1.Error == 0)
					//{
						//GuiMgr.getInstance().GuiPearlRefine.DeleteRefinePearl(tmpSonbt);
					//}
					//GuiMgr.getInstance().GuiPearlRefine.setIsSendList(tmpSonbt + 1);
				break;
				case Constant.CMD_DELETE_GEM:
					//hiepnm2
					
					//if (Data1.Error == 0)
					//{
						//GuiMgr.getInstance().GuiGemRefine.processDelGem(OldData);
					//}
				break;
				case Constant.CMD_RECOVER_GEM:
					if (Data1.Error == 0)
					{
						GuiMgr.getInstance().GuiGemRefine.processRecoverGem(OldData);
					}
				break;
				// Event Treasure
				case Constant.CMD_OPEN_TRUNK:
				{
					//var result:GetTreasure = new GetTreasure(Data1);
					var cmd:SendOpenTrunk = OldData as SendOpenTrunk;
					var treasure:Treasure = GameLogic.getInstance().user.TreasureArr[cmd.PearlId - 1];
					if (treasure != null)
					{
						treasure.SaveData(Data1);
					}
					
					//GameLogic.getInstance().MouseTransform();
					//var treasure:Treasure = GameLogic.getInstance().user.TreasureArr[OldData["TrunkId"] - 1];
					//treasure.CloseTreasure();
				}
				break;	
				//Event 2-9
				case Constant.CMD_SEND_GET_GIFT_EVENT_ND:				
					//trace("exchange gift", Data1["GiftId"]);
					//if (GuiMgr.getInstance().guiGetEventGift.getNumGift() > 1)
					{
						GuiMgr.getInstance().guiGetEventGift.serverRespond = true;
						GuiMgr.getInstance().guiGetEventGift.setIdGift(Data1["GiftId"]);
					}
					break;
				case Constant.CMD_SEND_BUY_ICON_ND:
					break;
				case Constant.CMD_SEND_CLICK_GIFT_FIREWORK:
					var arrFirework:Array = GameLogic.getInstance().user.arrFireworkFish;
					var firework:FireworkFish;
					for (i = 0; i < arrFirework.length; i++)
					{
						if (arrFirework[i]["Id"] == OldData["FishId"])
						{
							firework = arrFirework[i] as FireworkFish;
						}
					}
					firework.progressBar.visible = false;
					for each (var object:Object in Data1["Gift"])
					{
						switch(object["ItemType"])
						{
							case "Exp":
								EffectMgr.getInstance().fallFlyXP(firework.CurPos.x, firework.CurPos.y, object["Num"], true);
								break;
							case "Money":
								EffectMgr.getInstance().fallFlyMoney(firework.CurPos.x, firework.CurPos.y, object["Num"]);
								break;
							case "Sock":
								GameLogic.getInstance().DropActionGift(object, firework.CurPos.x, firework.CurPos.y, true);
								if (GameLogic.getInstance().user.StockThingsArr["Sock"][0]["Num"] >= Constant.NUM_SOCK_EXCHANGE)
								{
									GuiMgr.getInstance().guiWish.showGUI();
								}
								break;
							case "SockExchange":
								GameLogic.getInstance().user.UpdateStockThing(object["ItemType"], object["ItemId"], object["Num"]);
								break;
						}
					}
					break;
				case Constant.CMD_SEND_MAKE_WISH:
					//trace(Data1["Gift"]);
					var itemType:String = Data1["Gift"]["ItemType"];
					if (itemType == "Exp")
					{
						GameLogic.getInstance().user.ExpWillBeAddLater();
					}
					var itemId:int = Data1["Gift"]["ItemId"];
					var num:int = Data1["Gift"]["Num"];
					/*switch(itemType)
					{
						case "Exp":
							GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + num);
							trace("make wish", num);
							break;
						case "Money":
							GameLogic.getInstance().user.UpdateUserMoney(num);
							break;
						default:
							//GuiMgr.getInstance().GuiStore.UpdateStore(itemType, itemId, num);
							break;
					}*/
					if (itemType == "BabyFish")
					{
						num = Data1["Gift"]["FishType"];
					}
					//Kinh nghiem va vang cong o day
					if(GameLogic.getInstance().endEff)
					{
						GuiMgr.getInstance().guiCongratulation.showGUI(itemType, itemId, num, true);
					}
					else
					{
						GameLogic.getInstance().itemType = itemType;
						GameLogic.getInstance().itemId = itemId;
						GameLogic.getInstance().itemNum = num;
						GameLogic.getInstance().wishRespond = true;
					}
					break;
					
				case   Constant.CMD_GET_NEW_USER_GIFT_BAG:
					GameLogic.getInstance().user.ExpWillBeAddLater();
					GameLogic.getInstance().user.tuiTanThu.GetGift(Data1);
				break;
				case Constant.CMD_FIRST_TIME_LOGIN:
					if (GameLogic.getInstance().user.tuiTanThu)
					{
						GameLogic.getInstance().user.tuiTanThu.updateLastTimeOpenBag(Data1);
					}
				break;
				case Constant.CMD_SYNC_OFFLINE_EXP:
					if (GuiMgr.getInstance().guiOfflineExperience.IsVisible)
					{
						GameLogic.getInstance().totalTimeOffline = Data1["OfflineExp"]["TotalTimeOffline"];
						GuiMgr.getInstance().guiOfflineExperience.updateAccumulateTime(GameLogic.getInstance().totalTimeOffline);
					}
					break;
				case Constant.CMD_SEND_EXCHANGE_COLLECTION:
					if (Data1["Equipment"] != null)
					{
						GuiMgr.getInstance().guiCollection.serverRespond = true;
						GameLogic.getInstance().equipment = Data1["Equipment"];
						if (GuiMgr.getInstance().guiCollection.finishEff)
						{
							//trace("show gift");
							GameLogic.getInstance().showGiftCollection();
						}
					}
					break;
					
				case  Constant.CMD_ADD_MATERIAL_FISH:
					GameLogic.getInstance().ProcessAddMaterialFish(Data1, OldData);
				break;
				case Constant.CMD_UPGRADE_SKILL:
					GuiMgr.getInstance().guiMateFish.upgradeSkill(OldData["Skill"]);
					break;
				
				// Các API Event Hoa Mùa thu
				case Constant.CMD_SEND_BUY_ARROW:
					//GuiMgr.getInstance().GuiGameTrungThu.GetButton(GUIGameEventMidle8.BTN_CLOSE).SetEnable();
					if (OldData.ArrowId == GuiMgr.getInstance().GuiGameTrungThu.ARROW_KEY)
					{
						GuiMgr.getInstance().GuiMessageFinishGame.Hide();
						var ctnEnd:Container = GuiMgr.getInstance().GuiGameTrungThu.GetContainer(GUIGameEventMidle8.CTN_SQUARE + 
							(GuiMgr.getInstance().GuiGameTrungThu.NUM_ROW - 1) + "_" + (GuiMgr.getInstance().GuiGameTrungThu.NUM_COL - 1));
						GuiMgr.getInstance().GuiGameTrungThu.isEff = true;
						EffectMgr.getInstance().AddSwfEffect(	Constant.GUI_MIN_LAYER, "EffOpenWindowGameMidle8", null, ctnEnd.CurPos.x - 
							GuiMgr.getInstance().GuiGameTrungThu.widthCtn, ctnEnd.CurPos.y - GuiMgr.getInstance().GuiGameTrungThu.heightCtn,
													false, false, null,  function():void { GuiMgr.getInstance().GuiGameTrungThu.ShowLock(int(GuiMgr.getInstance().GuiGameTrungThu.CreateTime)) } );
					}
				break;
				case Constant.CMD_RANDOM_DICE:
				{
					//GuiMgr.getInstance().GuiGameTrungThu.GetButton(GUIGameEventMidle8.BTN_CLOSE).SetEnable();
					if(OldData.timeStamp == int(GuiMgr.getInstance().GuiGameTrungThu.CreateTime))
					{
						if (GuiMgr.getInstance().GuiGameTrungThu.IsVisible)
						{
							if(OldData.isTwoDice)
							{
								GuiMgr.getInstance().GuiGameTrungThu.updateData(OldData.m, OldData.n, Data1.Num, Data1.Num2);
								GuiMgr.getInstance().GuiGameTrungThu.doRunNextSquare(OldData.m, OldData.n, OldData.isTwoDice, OldData.ArrowId , Data1.Num , Data1.Num2);
							}
							else
							{
								GuiMgr.getInstance().GuiGameTrungThu.updateData(OldData.m, OldData.n, Data1.Num);
								GuiMgr.getInstance().GuiGameTrungThu.doRunNextSquare(OldData.m, OldData.n, OldData.isTwoDice, OldData.ArrowId , Data1.Num);
							}
						}
					}
					GuiMgr.getInstance().GuiGameTrungThu.isStartSendRandomDice = false;
					break;
				}
				case Constant.CMD_GET_EVENT_ON_ROAD:
					if(OldData.timeStamp == int(GuiMgr.getInstance().GuiGameTrungThu.CreateTime))
					{
						if(GuiMgr.getInstance().GuiGameTrungThu.IsVisible)
						{
							GuiMgr.getInstance().GuiGameTrungThu.ProcessDataServerGift(Data1, OldData.timeStamp);
						}
					}
				break;
				case Constant.CMD_NEXT_MAP:
				{
					if (OldData.isFirstLogin == true)
					{
						GameLogic.getInstance().user.UpdateStockThing("Arrow", 1, 2);
						GameLogic.getInstance().user.UpdateStockThing("Arrow", 2, 2);
						GameLogic.getInstance().user.UpdateStockThing("Arrow", 3, 2);
						GameLogic.getInstance().user.UpdateStockThing("Arrow", 4, 2);
						for (i = 0; i < GameLogic.getInstance().user.StockThingsArr.Arrow.length; i++)
						{
							var objArrowTemp:Object = GameLogic.getInstance().user.StockThingsArr.Arrow[i];
							GuiMgr.getInstance().GuiGameTrungThu.arrArrow[int(objArrowTemp.Id) - 1] = objArrowTemp.Num;
						}
					}
					
					if (Data1 && Data1.Exp && Data1.Exp > 0)
					{
						GuiMgr.getInstance().GuiGameTrungThu.InitInfo(Data1, true);
					}
					else if (GuiMgr.getInstance().GuiGameTrungThu.IsVisible || GuiMgr.getInstance().GuiRePlayGame.IsVisible)
					{
						GuiMgr.getInstance().GuiGameTrungThu.InitInfo(Data1);
					}
					GuiMgr.getInstance().GuiGameTrungThu.isNextDay = false;
					GuiMgr.getInstance().GuiGameTrungThu.timePlay = GameLogic.getInstance().CurServerTime * 1000 - 
					GuiMgr.getInstance().GuiGameTrungThu.NUM_TIME_DELAY * 1000;
					GuiMgr.getInstance().GuiGameTrungThu.JoinNum ++;
				}
				break;
				case Constant.CMD_TELEPORT:
					//GuiMgr.getInstance().GuiGameTrungThu.GetButton(GUIGameEventMidle8.BTN_CLOSE).SetEnable();
				break;
				case Constant.CMD_GO_GO:
					//GuiMgr.getInstance().GuiGameTrungThu.GetButton(GUIGameEventMidle8.BTN_CLOSE).SetEnable();
				break;
				case Constant.CMD_ANSWER_QUESTION:
				{
					if(OldData.timeStamp == int(GuiMgr.getInstance().GuiGameTrungThu.CreateTime))
					{
						if(GuiMgr.getInstance().GuiAnswerQuestion.IsVisible)
						{
							GuiMgr.getInstance().GuiAnswerQuestion.ProcessDataServerGift(Data1, OldData);
						}
					}
				}
				break;
				case Constant.CMD_ATTACK_BOSS_OCEAN_SEA:
					for (var iBoss:int = 0; iBoss < BossMgr.getInstance().BossArr.length; iBoss++) 
					{
						var boss:Boss = BossMgr.getInstance().BossArr[iBoss];
						boss.SetDataServer(Data1);
					}
					switch (FishWorldController.GetSeaId()) 
					{
						case Constant.OCEAN_METAL:
							GameLogic.getInstance().user.bossMetal.SetDataServer(Data1);
						break;
						case Constant.OCEAN_ICE:
							GameLogic.getInstance().user.bossIce.SetDataServer(Data1);
						break;
					}
					break;
				//Lucky Machine
				case Constant.CMD_SEND_PLAY_LUCKY_MACHINE:
				{
					GuiMgr.getInstance().guiLuckyMachine.receiveData(Data1);
					
				};
				break;
				case Constant.CMD_SEN_GET_TOP_EVENT_WAR_CHAMPION:
					//trace(Data1);
					if(GuiMgr.getInstance().guiWarChampion.IsVisible)
					{
						GuiMgr.getInstance().guiWarChampion.updateInfo(Data1);
					}
					break;
				/*Event 8/3*/
				case Constant.CMD_SEND_CARE_FLOWER:
				{
					if (!GameLogic.getInstance().user.IsViewer())
					{
						if (GameLogic.getInstance().user.GetMyInfo().coralTree)
						{
							GameLogic.getInstance().user.GetMyInfo().coralTree.fallBonus(Data1);
						}
					}
				}
				break;
				case Constant.CMD_SEND_SEEK_GROWUP_FLOWER:
				{
					if (!GameLogic.getInstance().user.IsViewer())
					{
						if (GameLogic.getInstance().user.GetMyInfo().coralTree)
						{
							GameLogic.getInstance().user.GetMyInfo().coralTree.guiSeekTime.seekTimeComp();
						}
					}
				}
				break;
				case Constant.CMD_SEND_OPEN_FLOWERBOX:
				{
					GuiMgr.getInstance().GuiChangeFlower.receiveGift(Data1);
				}
				break;
				case Constant.CMD_PLAY_FAST:
					//GuiMgr.getInstance().GuiGameTrungThu.JoinNum ++;
					GuiMgr.getInstance().GuiGameTrungThu.playEffFast(Data1, OldData);
					
				break;
				case Constant.CMD_GET_GIFT_EVENT_SPRING:
					var kEvent:String;
					var lEvent:String;
					var nEvent:int;
					if (OldData.Type == 3)
					{
						var seal:FishEquipment = new FishEquipment();
						seal.Color = FishEquipment.FISH_EQUIP_COLOR_PINK;
						seal.Type = "Seal";
						seal.Rank = 3;
						GameLogic.getInstance().user.UpdateEquipmentToStore(seal);
						GameLogic.getInstance().user.GenerateNextID();
						EffectMgr.setEffBounceDown("Nhận thành công", seal.Type + seal.Rank + "_Shop", 330, 280);
					}
					else 
					{
						for (kEvent in Data1) 
						{
							if (kEvent == "SpecialGift")
							{
								for (lEvent in Data1.SpecialGift) 
								{
									var equip:FishEquipment = new FishEquipment();
									equip.SetInfo(Data1.SpecialGift[lEvent]);
									GameLogic.getInstance().user.UpdateEquipmentToStore(equip);
									GameLogic.getInstance().user.GenerateNextID();
									EffectMgr.setEffBounceDown("Nhận thành công", Data1.SpecialGift[lEvent].Type + Data1.SpecialGift[lEvent].Rank + "_Shop", 330, 280);
								}
							}
							
							if (kEvent == "NormalGift")
							{
								for (nEvent = 0; nEvent < Data1.NormalGift.length; nEvent ++ ) 
								{
									var itemEvent:Object = Data1.NormalGift[nEvent];
									GameLogic.getInstance().user.UpdateStockThing(itemEvent.ItemType, itemEvent.ItemId, itemEvent.Num);
									EffectMgr.setEffBounceDown("Nhận thành công", itemEvent.ItemType + itemEvent.ItemId, 330, 280);
								}
							}
						}
					}
				break;
				
				// Event Magic Potions
				case Constant.CMD_SEND_DONE_HERB_QUEST:
					/*if (GuiMgr.getInstance().GuiQuestHerb.IsVisible)
					{
						QuestHerbMgr.getInstance().InitQuest(Data1.HerbList, Data1.RefreshMoney, false);
						GuiMgr.getInstance().GuiQuestHerb.RefreshComponent();
					}
					else
					{
						QuestHerbMgr.getInstance().InitQuest(Data1.HerbList, Data1.RefreshMoney, true);
					}
					break;*/
				case Constant.CMD_SEND_GET_HERB_LIST:
					if (GuiMgr.getInstance().GuiQuestHerb.IsVisible)
					{
						QuestHerbMgr.getInstance().InitQuest(Data1.HerbList, Data1.RefreshMoney, false);
						GuiMgr.getInstance().GuiQuestHerb.RefreshComponent();
					}
					else
					{
						QuestHerbMgr.getInstance().InitQuest(Data1.HerbList, Data1.RefreshMoney, true);
					}
					break;
				case Constant.CMD_SEND_GET_NEW_HERB_QUEST:
					QuestHerbMgr.getInstance().InitQuest(Data1.HerbList, Data1.RefreshMoney);
					if (GuiMgr.getInstance().GuiQuestHerb.IsVisible)
					{
						GuiMgr.getInstance().GuiQuestHerb.RefreshComponent();
					}
					break;
				case Constant.CMD_SEND_QUICK_DONE_HERB_QUEST:
					break;
				case Constant.CMD_SEND_EXCHANGE_HERB_ITEM:
					if (OldData.IdHerb == 3)
					{
						GuiMgr.getInstance().GuiAutoMixHerbPotion3.Result = Data1;
						//if (GuiMgr.getInstance().GuiAutoMixHerbPotion3.IsVisible)
						//{
							//GuiMgr.getInstance().GuiAutoMixHerbPotion3.Hide();
						//}
						//GuiMgr.getInstance().GuiGetGiftUseHerb.InitAll(Data1.Gift, true);
						if (GuiMgr.getInstance().GuiQuestHerb.IsVisible)
						{
							GuiMgr.getInstance().GuiQuestHerb.RefreshComponent();
						}
					}
					//if (GuiMgr.getInstance().GuiQuestHerb.IsVisible)
					//{
						//GuiMgr.getInstance().GuiQuestHerb.RefreshComponent();
					//}
					break;
				case Constant.CMD_SEND_USE_HERB_POTION:
					GameLogic.getInstance().user.ProcessBuffHerbPotion(Data1.Lucky, OldData.HerbPotionId, OldData.FishId, OldData.LakeId, OldData.Num);
					break;
				case Constant.CMD_SEND_ATTACK_HERB_BOSS:
					if (!GameLogic.getInstance().user.bossHerb)	return;
					if (OldData.isCare)
					{
						GameLogic.getInstance().user.bossHerb.ProcessCareBoss();
					}
					else
					{
						GameLogic.getInstance().user.bossHerb.ProcessAttackBoss(Data1.Scene, Data1.isWin, Data1.Lucky);
					}
					break;
				//event 1st BirthDay
				case Constant.CMD_SEND_BURN_CANDLE:
					if (!GameLogic.getInstance().user.IsViewer())
					{
						var candleId:int = (OldData as SendBurnCandle).CandleId;
						var me:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
						var candle:BirthdayCandle = me["birthdayCandle" + candleId];
						if (candle)
						{
							//trace("rơi ra quà: " + Data1);
							candle.fallbonus(Data1);
						}
					}
				break;
				case Constant.CMD_GET_GIFT_IN_MAGIC_LAMP:
					var oldPacket:SendGetGiftMagicLamp = OldData as SendGetGiftMagicLamp;
					if (oldPacket.FirstDay)
					{
						var wp:int = MagicLampMgr.getInstance().WishingPoint;
						BirthDayItemMgr.getInstance().setNum(14, 0 - wp);
						MagicLampMgr.getInstance().WishingPoint = 0;
						MagicLampMgr.getInstance().initGiftReceive(Data1);
					}
				break;
				case Constant.CMD_SEND_OPEN_BIRTHDAYBOX:
					GuiMgr.getInstance().GuiChangeBirthDayGift.receiveGift(Data1);
				break;
				//training tower
				case Constant.CMD_GET_STATUS_TRAINING:
					if (GuiMgr.getInstance().GuiTrainingTower.img) {
						GuiMgr.getInstance().GuiTrainingTower.processData(Data1);
					}
					else if (TrainingMgr.getInstance().FisrtTimeLogin){
						TrainingMgr.getInstance().updateListRoom(Data1);
						TrainingMgr.getInstance().hasUpdate = true;
					}
					
				break;
				case Constant.CMD_START_TRAININGTOWER:
					if (GuiMgr.getInstance().GuiTrainingTower.img) {
						if (GuiMgr.getInstance().GuiTrainingTower.img.visible) {
							GuiMgr.getInstance().GuiTrainingTower.startSuccess(Data1, OldData);
						}
					}
				break;
				case Constant.CMD_UNLOCK_ROOM:
					if (GuiMgr.getInstance().GuiTrainingTower.img) {
						if (GuiMgr.getInstance().GuiTrainingTower.img.visible) {
							GuiMgr.getInstance().GuiTrainingTower.unlockSuccess();
						}
					}
				break;
				//expedition
				case Constant.CMD_GET_EXPEDITION_STATUS:
					if (GuiMgr.getInstance().guiExpedition.IsVisible)
					{
						GuiMgr.getInstance().guiExpedition.processData(Data1);
					}
					else
					{
						ExpeditionMgr.getInstance().initData(Data1);
					}
					
				break;
				case Constant.SEND_TEST:
					if (GuiMgr.getInstance().GuiTest2.img)
					{
						if (GuiMgr.getInstance().GuiTest2.img.visible)
						{
							GuiMgr.getInstance().GuiTest2.getPacket(Data1);
						}
					}
				break;
				case Constant.CMD_ROLLING_DICE:
					if (GuiMgr.getInstance().guiExpedition.IsVisible)
					{
						GuiMgr.getInstance().guiExpedition.rollingDice(Data1);
					}
				break;
				case Constant.CMD_INCREASE_VALUE:
					if (GuiMgr.getInstance().guiExpedition.IsVisible)
					{
						GuiMgr.getInstance().guiExpedition.increaseValue(Data1);
					}
				break;
				case Constant.CMD_DECREASE_HARD:
					if (GuiMgr.getInstance().guiExpedition.IsVisible)
					{
						GuiMgr.getInstance().guiExpedition.decreaseHard(Data1);
					}
				break;
				case Constant.CMD_COMPLETE_EXPEDITION_QUEST:
					if (GuiMgr.getInstance().guiExpedition.IsVisible)
					{
						GuiMgr.getInstance().guiExpedition.completeQuest(Data1);
					}
				break;
				case Constant.CMD_BUY_CARD_EXPEDITION:
					//if (GuiMgr.getInstance().guiExpedition.IsVisible)
					//{
					if (Data1["Error"] == 0)
					{
						GuiMgr.getInstance().guiExpedition.buyCard(OldData);
					}
					//}
				break;
				//liên đấu
				case Constant.CMD_GET_STATUS_LEAGUE:
					LeagueMgr.getInstance().processGetStatusPacket(Data1);
				break;
				case Constant.CMD_REFRESH_RANK_BOARD:
					if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
					{
						var pk:SendRefreshBoard = OldData as SendRefreshBoard;
						if (pk != null)
						{
							if (!pk.System) 
							{
								LeagueMgr.getInstance().LastRefreshBoard = GameLogic.getInstance().CurServerTime;
							}
						}
						LeagueMgr.getInstance().processRefreshBoardPacket(Data1);
						LeagueController.getInstance().timeRefresh = GameLogic.getInstance().CurServerTime;
					}
				break;
				case Constant.CMD_BUY_CARD:
					LeagueController.getInstance().IsBuying = false;
				break;
				case Constant.CMD_CHANGE_SOLDIER_IN_LEAGUE:
					var idChoose:int = (OldData as SendChangeSoldier).SoldierId;
					if (Data1["Error"] == 0 && idChoose >= 0)
					{
						LeagueMgr.getInstance().changeSoldier(idChoose);
					}
				break;
				case Constant.CMD_GET_TOP_TEN_PLAYER:
					if (Data1["Error"] == 0)
					{
						GuiMgr.getInstance().guiTopPlayer.processData(Data1);
					}
				break;
				case Constant.CMD_GET_GIFT_LEAGUE:
					LeagueMgr.getInstance().processGetGift(Data1);
				break;
				
				case Constant.CMD_GET_PAY_INFO:
					if (Data1["Error"] == 0)
					{
						if (GuiMgr.getInstance().guiPayGift.IsVisible)
						{
							GuiMgr.getInstance().guiPayGift.processData(Data1);
						}
					}
				break;
				case Constant.CMD_RECEIVE_GIFT_PAY:
					if (Data1["Error"] == 0)
					{
						if (GuiMgr.getInstance().guiPayGift.IsVisible)
						{
							//GuiMgr.getInstance().guiPayGift.processGetGift(OldData);
							GuiMgr.getInstance().guiPayGift.initListGiftFromServer(Data1);
						}
					}
				break;
				/*EventMidAutumn*/
				case Constant.CMD_EXCHANGE_COLLECTION_GIFT:
					if (Data1["Error"] == 0)
					{
						if (GuiMgr.getInstance().guiEventCollection.IsVisible)
						{
							GuiMgr.getInstance().guiEventCollection.processGetGift(Data1, OldData);
						}
					}
				break;
				case Constant.CMD_FIRE_LANTERN:
					if (Data1["Error"] == 0)
					{
						GameLogic.getInstance().user.GetMyInfo().AutoId = Data1["AutoId"];
						//if ((OldData as SendFireLantern).ItemType == "PaperBurn")//đốt = giấy
						//{
							//var curTime:Number = GameLogic.getInstance().CurServerTime;
							//GuiMgr.getInstance().guiFrontEvent.setPaperTimeUse(curTime);
						//}
					}
				break;
				case Constant.CMD_REBORN_LANTERN:
					if (Data1["Error"] == 0)
					{
						GuiMgr.getInstance().guiRebornLantern.processReborn();
					}
				break;
				/*Event Halloween*/
				case Constant.CMD_GET_STATUS_EVENT_HALLOWEEN:
					if (Data1["Error"] == 0 &&
						GuiMgr.getInstance().guiHalloween.IsVisible)
					{
						GuiMgr.getInstance().guiHalloween.processData(Data1);
					}
					break;
				case Constant.CMD_UNLOCK_ROCK:
					if (GuiMgr.getInstance().guiHalloween.IsVisible)
					{
						GuiMgr.getInstance().guiHalloween.processUnlock(OldData as SendUnlockNode, Data1);
					}
					break;
				case Constant.CMD_FAIL_TRICK_TASK:
					if (GuiMgr.getInstance().guiHalloween.IsVisible)
					{
						if (GuiMgr.getInstance().guiTrickTask.IsVisible)
						{
							GuiMgr.getInstance().guiTrickTask.Hide();
						}
						GuiMgr.getInstance().guiHalloween.processFailTask(data);
					}
					break;
				case Constant.CMD_UNLOCK_HALLOWEEN:
					if (GuiMgr.getInstance().guiLockHalloween.IsVisible)
					{
						GuiMgr.getInstance().guiLockHalloween.Hide();
					}
					if (!GuiMgr.getInstance().guiHalloween.IsVisible)
					{
						GuiMgr.getInstance().guiHalloween.Show(Constant.GUI_MIN_LAYER, 5);
					}
					break;
				case Constant.CMD_FINISH_AUTO_HALLOWEEN:
					if (Data1["Error"] == 0)
					{
						HalloweenMgr.getInstance().initGiftAutoFinish(Data1);
						GuiMgr.getInstance().guiGiftHalloween.Show(Constant.GUI_MIN_LAYER, 5);
					}
					break;
				case Constant.CMD_SEND_FAST_COMPELTE:
					EventSvc.getInstance().initGiftServer2(Data1,"RetBonus");
					//EventNoelMgr.getInstance().initGiftServer(Data1);
					GuiMgr.getInstance().guiReceiveGiftTet.Show(Constant.GUI_MIN_LAYER, 5);
					GuiMgr.getInstance().guiFinishEventAuto.Hide();
					GuiMgr.getInstance().guiHuntFish.Hide();
					break;
				case Constant.CMD_BUY_PACK_HALLOWEEN:
					if (Data1["Error"] == 0)
					{
						if (OldData["ItemType"] == "BuyPack")
						{
							GuiMgr.getInstance().guiBuyContinue.processData(Data1);
							GuiMgr.getInstance().guiHalloween.inBuyPack = false;
							HalloweenMgr.getInstance().processBuyPack(Data1);
							if (GuiMgr.getInstance().guiHalloween.IsVisible)
							{
								GuiMgr.getInstance().guiHalloween.refreshAllTextNumRock();
							}
						}
					}
					break;
				case Constant.CMD_GET_SAVE_POINT_STATUS:
					if (Data1["Error"] == 0)
					{
						if (GuiMgr.getInstance().guiSavePoint.IsVisible)
						{
							GuiMgr.getInstance().guiSavePoint.processData(Data1);
						}
					}
					break;
				case Constant.CMD_CHOOSE_TRICK_OR_TREAT:
					if (Data1["Error"] == 0 && 
						GuiMgr.getInstance().guiHalloween.IsVisible)
					{
						if (GuiMgr.getInstance().guiTrickTreat.IsVisible)
						{
							GuiMgr.getInstance().guiTrickTreat.Hide();
						}
						GuiMgr.getInstance().guiHalloween.processTrickorTreat(OldData, Data1);
						//GuiMgr.getInstance().guiSavePoint.processData(Data1);
					}
					break;
				case Constant.CMD_EXCHANGE_ACCUMULATION_POINT:
					if (Data1["Error"] == 0)
					{
						if (GuiMgr.getInstance().guiSavePoint.IsVisible)
						{
							GuiMgr.getInstance().guiSavePoint.processGetGift(OldData, Data1);
						}
					}
					break;
				case Constant.CMD_EXCHANGE_EVENT_CHAR:
					if (Data1["Error"] == 0)
					{
						if (GuiMgr.getInstance().guiTeacherEvent.IsVisible)
						{
							GuiMgr.getInstance().guiTeacherEvent.processReceiveGift(Data1["Gifts"]["Normal"],OldData);
						}
					}
					break;
				case Constant.CMD_RECEIVE_COMBO_GIFT:
				case Constant.CMD_RECEIVE_CHARACTER_GIFT:
					if (Data1["Error"] == 0)
					{
						if (GuiMgr.getInstance().guiTeacherEvent.IsVisible)
						{
							GuiMgr.getInstance().guiTeacherEvent.processGetEquipmentGift(Data1, OldData);
						}
					}
					break;
				case Constant.CMD_EXCHANGE_POINT_GIFT:
					if (GuiMgr.getInstance().guiTeacherEvent.IsVisible)
					{
						GuiMgr.getInstance().guiTeacherEvent.processExchangePoint(Data1, OldData);
					}
					break;
				case Constant.CMD_SEND_TEST_GET_ITEM:
					if (Data1["Error"] == 0)
					{
						if (GuiMgr.getInstance().guiTestItem.IsVisible)
						{
							GuiMgr.getInstance().guiTestItem.processData(Data1);
						}
					}
					break;
				case Constant.CMD_GET_SMASH_EGG:
					//trace("case Constant.CMD_GET_SMASH_EGG: " + GuiMgr.getInstance().guiTrungLinhThach.img);
					if (GuiMgr.getInstance().guiTrungLinhThach.img)
					{
						GuiMgr.getInstance().guiTrungLinhThach.addDataRespont(Data1);
					}
					else if (TrungLinhThachMgr.getInstance().FisrtTimeLogin) {
						//trace("OldData.FriendId== " + OldData.FriendId);
						if (OldData.FriendId == 0)
						{
							TrungLinhThachMgr.getInstance().updateListRoom(Data1);
							TrungLinhThachMgr.getInstance().hasUpdate = true;
						}
						else
						{
							if (GuiMgr.getInstance().guiShowQuartzUser.img)
							{
								GuiMgr.getInstance().guiShowQuartzUser.receiveSlotUser(Data1);
							}
						}
					}
					break;
				case Constant.CMD_BUY_HAMMER:
					if (GuiMgr.getInstance().guiHammerInfo.IsVisible)
					{
						GuiMgr.getInstance().guiHammerInfo.buyComplete(OldData, Data1);
					}
					break;
				case Constant.CMD_BUY_DISCOUNT_HAMMER:
					if (GuiMgr.getInstance().guiHammerInfo.IsVisible)
					{
						GuiMgr.getInstance().guiHammerInfo.buyComplete(OldData, OldData);
					}
					break;
				case Constant.CMD_SMASH_EGG:
					//trace("-------CMD_SMASH_EGG---------");
					if (GuiMgr.getInstance().guiTrungLinhThach.IsVisible)
					{
						GuiMgr.getInstance().guiTrungLinhThach.loadDataBonusSmash(OldData, Data1);
					}
					break;
				case Constant.CMD_ADD_QUARTZ_TO_SOLDIER:
					//trace("-------CMD_ADD_QUARTZ_TO_SOLDIER---------");
					if (GuiMgr.getInstance().guiWareRoomLinhThach.IsVisible)
					{
						//GuiMgr.getInstance().guiWareRoomLinhThach.receiveAddQuartz(OldData, Data1);
						GuiMgr.getInstance().guiWareRoomLinhThach.receiveAddQuartz();
					}
					break;
				case Constant.CMD_RECEIVE_BONUS:
					//trace("-------CMD_RECEIVE_BONUS---------");
					if (GuiMgr.getInstance().guiTrungLinhThach.IsVisible)
					{
						GuiMgr.getInstance().guiTrungLinhThach.loadReceiveBonus(OldData, Data1);
					}
					break;
				case Constant.CMD_REMOVE_QUARTZ_SOLDIER:
					//trace("-------CMD_REMOVE_QUARTZ_SOLDIER---------");
					if (GuiMgr.getInstance().guiWareRoomLinhThach.IsVisible)
					{
						//GuiMgr.getInstance().guiWareRoomLinhThach.receiveRemoveQuartz(OldData, Data1);
						GuiMgr.getInstance().guiWareRoomLinhThach.receiveRemoveQuartz();
					}
					break;
				case Constant.CMD_UPGRADE_QUARTZ_SOLDIER:
					if (GuiMgr.getInstance().guiUpdateLinhThach.IsVisible)
					{
						GuiMgr.getInstance().guiUpdateLinhThach.updateLevelQuartz(OldData,Data1);
					}
					break;
				/*EventNoel*/
				case Constant.CMD_SEND_GO_TO_SEA:
					if (GuiMgr.getInstance().guiHuntFish.IsVisible)
					{
						GuiMgr.getInstance().guiHuntFish.processData(Data1);
					}
					break;
				case Constant.CMD_SEND_FIRE_GUN:
					if (GuiMgr.getInstance().guiHuntFish.IsVisible)
					{
						GuiMgr.getInstance().guiHuntFish.processFireGun(Data1);
						if (GuiMgr.getInstance().guiStoreNoel.IsVisible)
						{
							if (!GuiMgr.getInstance().guiStoreNoel.DataReady)
							{
								GuiMgr.getInstance().guiStoreNoel.processData(Data1["RetBonus"]);	
							}
						}
					}
					break;
				case Constant.CMD_SEND_ROUND_UP:
					if (GuiMgr.getInstance().guiHuntFish.IsVisible)
					{
						GuiMgr.getInstance().guiHuntFish.processRoundUp(Data1);
					}
					break;
				case Constant.CMD_RECEIVE_NOEL_FEED://nhận quà từ collection mà có feed lên tường
					//if (GuiMgr.getInstance().guiReceiveGiftCollection.IsVisible)
					if (GuiMgr.getInstance().guiExchangeNoelItem.IsVisible)
					{
						GuiMgr.getInstance().guiExchangeNoelItem.processGetGift(OldData, Data1);
						//GuiMgr.getInstance().guiReceiveGiftCollection.processGetGift(OldData, Data1);
					}
					break;
				case Constant.CMD_SEND_MAKE_BULLET:
					if (GuiMgr.getInstance().guiExchangeCandy.IsVisible)
					{
						GuiMgr.getInstance().guiExchangeCandy.processReceiveGift(Data1["Items"],OldData);
					}
					break;
				case Constant.CMD_GET_KEEP_LOGIN:
					if (GuiMgr.getInstance().guiGiftOnline.IsVisible)
					{
						GuiMgr.getInstance().guiGiftOnline.processData(Data1);
					}
					break;
				case Constant.CMD_REVERT_NOEL_DAY_LOGIN:
					if (GuiMgr.getInstance().guiShocksNoel.IsVisible)
					{
						GuiMgr.getInstance().guiShocksNoel.processRevertDay();
					}
					break;
				case Constant.CMD_RECEIVE_SHOCKS_GIFT:
					if (GuiMgr.getInstance().guiShocksNoel.IsVisible)
					{
						GuiMgr.getInstance().guiShocksNoel.processReceiveGift(Data1, OldData);
					}
					break;
				//event tet
				case Constant.CMD_REVERT_DAY_GIFT:
					if (GuiMgr.getInstance().guiGiftOnline.IsVisible)
					{
						GuiMgr.getInstance().guiGiftOnline.processRevertDay(Data1, OldData);
					}
					break;
				case Constant.CMD_RECEIVE_ONLINE_GIFT:
					if (GuiMgr.getInstance().guiGiftOnline.IsVisible)
					{
						GuiMgr.getInstance().guiGiftOnline.processReceiveGift(Data1, OldData);
					}
					break;
				
			}
			
			// update lai level
			if ("Exp" in Data1 && Type)
			{
				if (Type == Constant.CMD_GET_GIFT_OF_FISH)
				{
					//trace("aaaa");
				}
				if (Type == Constant.CMD_FEED_FISH
						|| Type == Constant.CMD_CURE_FISH
						|| Type == Constant.CMD_CLEAN_LAKE
						|| Type == Constant.CMD_CARE_FISH
						|| Type == Constant.CMD_UNLOCK_SLOT_MATERIAL)
				{					
					GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + Data1["Exp"]);
				}
				else if(Type != Constant.CMD_SNAPSHOT && Type != Constant.CMD_NEXT_MAP)
				{
					//EffectMgr.getInstance().getExpFromQueue() là lượng exp được cộng trên server rồi nhưng chưa được cộng trên client,
					//do còn chờ ngôi sao exp bay lên mới cộng
					//Data1["Exp"] là exp tổng lấy từ server (đã bao gồm lượng exp trong hàng đợi ở client)
					//Vì vậy chỉ cộng 1 lượng còn thiếu chưa được cộng ở client = Data1["Exp"] - EffectMgr.getInstance().getExpFromQueue()
					GameLogic.getInstance().user.SetUserExp(Data1["Exp"] - EffectMgr.getInstance().getExpFromQueue());								
				}
				else 
				{
					switch (Type) 
					{
						case Constant.CMD_SNAPSHOT:
							GuiMgr.getInstance().GuiSnapshot.ExpNeed = Data1.Exp;
						break;
						case Constant.CMD_NEXT_MAP:
						{
							//var arrNameGiftFail:Array = [];
							//var arrNumGiftFail:Array = [];
							//arrNameGiftFail.push("Exp");
							//arrNumGiftFail.push(Data1.Exp);
							//GuiMgr.getInstance().GuiGiftFinalGameMid8.InitGui(arrNameGiftFail, arrNumGiftFail, Data1);
							//EffectMgr.getInstance().fallFlyEXPToNumStar(Data1.Exp, 20);
						}
						break;
					}
					
				}
			}
			
			//kiểm tra xem có giao dịch xu hay ko
			//if (isSendingXu && OldData.hasOwnProperty("PriceType") && OldData["PriceType"] == "ZMoney")
			//{
				//isSendingXu = false;
				//timeoutCmd.delay = 10;
				//timeoutCmd.start();
			//}
			
			// update thông tin uy danh
			GameLogic.getInstance().processReputation(Type, Data1, OldData);
		}
		
		/**
		 * Hàm thực hiện xử lý gói tin đánh nhau
		 * @param	Type		:	Kiểu gói tin
		 * @param	Data1		:	Dữ liệu server trả về
		 * @param	OldData		:	Dữ liệu client gửi lên
		 */
		private function ProcessWarAfterReceive(Type:String, Data1:Object, OldData:Object):void
		{
			var obj:Object = new Object();
			obj["isWin"] = Data1.isWin;
			if (Type == Constant.CMD_ATTACK_FRIEND_LAKE)
			{
				obj["RankFriendSoldier"] = Data1.RankFriendSoldier;
			}
			else
			{
				obj["IdRound"] = Data1.IdRound;
				obj["IdSea"] = Data1.IdSea;
			}
			
			QuestMgr.getInstance().UpdateQuests(OldData as BasePacket, 1, obj);
			
			if(Ultility.IsInMyFish())	// đang đánh nhau ở nhà bạn
			{
				if (Data1.isWin)
				{
					var num:int = 0;
					if (Data1["Bonus"][0]["ItemType"] == "Money")
					{
						num = Data1["Bonus"][0]["Num"];
					}
					GameLogic.getInstance().log.AddAct(LogInfo.ID_ATTACK_WIN, num);
				}
				else
				{
					GameLogic.getInstance().log.AddAct(LogInfo.ID_ATTACK_LOOSE);
				}
			}
			else if(GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)	// Đang đánh ở thế giới cá
			{
				var arrMyFish:Array = GameLogic.getInstance().user.FishSoldierActorMine;
				var arrTheirFish:Array = GameLogic.getInstance().user.FishSoldierArr;
				for (var i:int = 0; i < arrMyFish.length; i++) 
				{
					if (arrMyFish[i].Id == OldData.IdSoldier)
					{
						GameLogic.getInstance().user.CurSoldier[0] = arrMyFish[i];
						break;
					}
				}
				for (var j:int = 0; j < arrTheirFish.length; j++) 
				{
					if (arrTheirFish[j].Id == OldData.IdMonster)
					{
						GameLogic.getInstance().user.CurSoldier[1] = arrTheirFish[j];
						break;
					}
				}
				if(Data1["Bonus"])
				{
					GameLogic.getInstance().bonusFishWorld = Data1["Bonus"]["100"];
				}
			}
			else if(GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST)
			{
				var arrMyFish1:Array = GameLogic.getInstance().user.FishSoldierActorMine;
				for (var i1:int = 0; i1 < arrMyFish1.length; i1++) 
				{
					if (arrMyFish1[i1].Id == OldData.IdSoldier)
					{
						GameLogic.getInstance().user.CurSoldier[0] = arrMyFish1[i1];
						break;
					}
				}
				if(FishWorldController.GetRound() == 1)
				{
					var arrTheirFish1:Array = GuiMgr.getInstance().GuiMainForest.arrThicketUpRed;
					for (var j1:int = 0; j1 < arrTheirFish1.length; j1++) 
					{
						if ((arrTheirFish1[j1] as Thicket).fishSoldier.Id == OldData.IdMonster)
						{
							//(arrTheirFish1[j1] as Thicket).fishSoldier.Show();
							GameLogic.getInstance().user.CurSoldier[1] = (arrTheirFish1[j1] as Thicket).fishSoldier;
							break;
						}
					}
				}
				if(Data1["Bonus"])
					GameLogic.getInstance().bonusFishWorld = Data1["Bonus"]["100"];
				GameLogic.getInstance().datReceiveForest = Data1;
				
				if (FishWorldController.GetSeaId() == Constant.OCEAN_FOREST && 
					FishWorldController.GetRound() == Constant.SEA_ROUND_2 &&
					int(OldData.IdMonster) == 4)
				{
					var monBoss:FishSoldier = GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen[0];
					//var posStart:Point = Ultility.PosLakeToScreen(monBoss.GetPos().x, monBoss.GetPos().y);
					var posStart:Point = new Point(monBoss.GetPos().x - 270, monBoss.GetPos().y - 228);
					var posEnd:Point = new Point(posStart.x, posStart.y - 100);
					var str:String;
					var txtFormat:TextFormat = new TextFormat();
					txtFormat.align = "center";
					txtFormat.bold = true;
					txtFormat.font = "Arial";
					txtFormat.size = 20;
					if(int(Data1.Scene["0"].BossQuit) == 1)
					{
						txtFormat.color = 0x00FF00;
						str = "Ợ ... Chợt nhớ ra có\nchút việc bận. Ta..ta\nphải đi rồi";
						Ultility.ShowEffText(str, monBoss.img, posStart, posEnd, txtFormat, 1, 0x000000);
					}
					else
					{
						txtFormat.color = 0xFF0000;
						str = "Nghiến răng nghiến lợi xông lên!!!";
						Ultility.ShowEffText(str, monBoss.img, posStart, posEnd, txtFormat, 1, 0xffffff);
					}
					//posEnd = new Point(posStart.x, posStart.y - 100);
					
				}
			}
			
			// create war
			if (!Ultility.IsKillBoss() || (Ultility.IsKillBoss() && (GameLogic.getInstance().user.CurSoldier[1] is SubBossMetal))
				|| (Ultility.IsKillBoss() && (GameLogic.getInstance().user.CurSoldier[1] is SubBossIce)))
			{
				if (Data1["Error"] == 0)
				{
					// Cập nhạt dữ liệu về kịch bản
					GameLogic.getInstance().FishWarScene = Data1.Scene;
					GameLogic.getInstance().FishWarPenalty = Data1.Penalty;
					
					var arr:Array = GameLogic.getInstance().user.CurSoldier;
					// Cập nhật thông tin các con cá của mình 
					if (Data1.MySoldier && Data1.MySoldier.length != 0)
					{
						Ultility.UpdateFishSoldier(Data1.MySoldier, Data1.MyEquipment.SoldierList, GameLogic.getInstance().user.FishSoldierActorMine, true);
						Ultility.UpdateFishSoldier(Data1.MySoldier, Data1.MyEquipment.SoldierList, GameLogic.getInstance().user.GetMyInfo().MySoldierArr, true);
					}
					// Cập nhật thông tin các con cá của nhà bạn 
					if (Data1.FriendSoldier && Data1.FriendSoldier.length != 0 && Ultility.IsInMyFish())
					{
						Ultility.UpdateFishSoldier(Data1.FriendSoldier, Data1.FriendEquipment.SoldierList, GameLogic.getInstance().user.FishSoldierActorTheirs.concat(GameLogic.getInstance().user.GetFishSoldierArr()), false);
					}
						
					GameLogic.getInstance().FishWarBonus.splice(0, GameLogic.getInstance().FishWarBonus.length);
					if(Data1.Bonus is Array)
					{
						GameLogic.getInstance().FishWarBonus = Data1.Bonus;
					}
					else 
					{
						for (var iStrBonus:String in Data1.Bonus) 
						{
							if (GameLogic.getInstance().FishWarBonus == null)	GameLogic.getInstance().FishWarBonus = [];
							GameLogic.getInstance().FishWarBonus.push(Data1.Bonus[iStrBonus]);
						}
					}
					GameLogic.getInstance().IsWin = Data1.isWin;
					
					var mySoldier:FishSoldier = GameLogic.getInstance().user.CurSoldier[0];
					var theirSoldier:Fish = GameLogic.getInstance().user.CurSoldier[1];
					var energyCost:int = ConfigJSON.getInstance().getEnergyForAttack(mySoldier.Rank);//ConfigJSON.getInstance().getItemInfo("RankPoint", mySoldier.Rank).AttackEnergy;//Math.floor(mySoldier.Damage / 20);
					if (Type == Constant.CMD_ATTACK_FRIEND_LAKE)
					{
						// Effect trừ năng lượng
						GameLogic.getInstance().user.UpdateEnergy( -energyCost);
					}
					
					// Tắt guiInfo của cá nhà bạn
					if (GuiMgr.getInstance().GuiFishInfo.IsVisible)
					{
						GuiMgr.getInstance().GuiFishInfo.Hide();
					}
					
					// Set lại vùng bay
					if(Ultility.IsInMyFish())
					{
						mySoldier.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() - 170, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 200));
						theirSoldier.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() -170, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 200));
					}
					else
					{
						mySoldier.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + 50));
						if (!Ultility.IsKillBoss() && GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)
						{
							theirSoldier.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.MAX_WIDTH, Constant.HEIGHT_LAKE_FISH_WORLD + 50));
						}
					}
					
					var posX:int;
					var posY:int;
					if(mySoldier && mySoldier.CurPos && theirSoldier && theirSoldier.CurPos)
					{
						posX = int((mySoldier.CurPos.x + theirSoldier.CurPos.x) / 2);
						posY = int((mySoldier.CurPos.y + theirSoldier.CurPos.y) / 2);
						trace(posX, posY);
						trace(Constant.MAX_WIDTH / 2, Constant.MAX_HEIGHT / 2); 
					}
					else
					{
						posX = Constant.MAX_WIDTH / 2;
						posY = Constant.MAX_HEIGHT / 2;
					}
					
					if (theirSoldier is SubBossMetal || theirSoldier is SubBossIce)
					{
						mySoldier.SwimTo(theirSoldier.CurPos.x - 110, theirSoldier.CurPos.y, 7, true);
						
						GameLogic.getInstance().isAttacking = true;
						if(theirSoldier is SubBossMetal)
						{
							(theirSoldier as SubBossMetal).isReadyToFight = true;
						}
						if(theirSoldier is SubBossIce)
						{
							(theirSoldier as SubBossIce).isReadyToFight = true;
						}
					}
					else if(theirSoldier is Thicket)
					{
						mySoldier.SwimTo((theirSoldier as Thicket).fishSoldier.standbyPos.x - 100, 
							(theirSoldier as Thicket).fishSoldier.standbyPos.y, 7, true);
					}
					else if (theirSoldier is FishSoldier)
					{
						if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST ||
							(GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST && 
							(FishWorldController.GetRound() == Constant.OCEAN_FOREST_ROUND_4)))
						{
							mySoldier.SwimTo(posX - 55, posY, 7, true);
							theirSoldier.SwimTo(posX + 55, posY, 7, true);
							(theirSoldier as FishSoldier).OnLoadResCompleteFunction = function():void
							{
								theirSoldier.SwimTo(posX + 55, posY, 7, true);
							}
						}
						else if(FishWorldController.GetRound() == Constant.OCEAN_FOREST_ROUND_1)
						{
							mySoldier.SwimTo((theirSoldier as FishSoldier).standbyPos.x - 100, 
								(theirSoldier as FishSoldier).standbyPos.y, 15, true);
						}
						else if(FishWorldController.GetRound() == Constant.OCEAN_FOREST_ROUND_3)
						{
							mySoldier.SwimTo(posX - 55, posY, 7, true);
							theirSoldier.SwimTo(posX + 55, posY + 60, 7, true);
							(theirSoldier as FishSoldier).OnLoadResCompleteFunction = function():void
							{
								theirSoldier.SwimTo(posX + 55, posY + 60, 7, true);
							}
						}
						else
						{
							var objYellowRandom:Object = GuiMgr.getInstance().GuiMainForest.objEffYellowRight;
							if (objYellowRandom && (objYellowRandom["Monster"] == "Bolt" || objYellowRandom["Boss"] == "Bolt"))
							{
								GameLogic.getInstance().isWinNowByBolt = true;
								mySoldier.SwimTo((mySoldier as FishSoldier).standbyPos.x - 5, (mySoldier as FishSoldier).standbyPos.y, 15, true);
							}
							else
							{
								mySoldier.SwimTo((theirSoldier as FishSoldier).standbyPos.x - 150, (theirSoldier as FishSoldier).standbyPos.y, 15, true);
							}
							(theirSoldier as FishSoldier).isReadyToFight = true;
						}
					}
					else
					{
						mySoldier.SwimTo(posX, posY, 7, true);
						theirSoldier.SwimTo(posX, posY, 7, true);
					}
					
					if (mySoldier.ghostEmit == null)
					{
						mySoldier.ghostEmit = new GhostEmit(mySoldier.img.parent, mySoldier, 1);
					}
					
					if(Ultility.IsInMyFish())
					{
						GuiMgr.getInstance().GuiInfoFishWar.ShowDisableScreen(0.01);
						GameInput.getInstance().lastAttackTime = 0;
						// Cập nhật số trận chiến trong event cá lính
						var myEventInfo:Object = GameLogic.getInstance().user.GetMyInfo().EventInfo;
						if (!myEventInfo)	return;
						var EventSoldierInfo:Object = myEventInfo["SoldierEvent"];
						if (!EventSoldierInfo)	return;
						var WinTotal:int = EventSoldierInfo["WinTotal"];
						WinTotal++;
						
						// Cập nhật thông số statistics
						if (theirSoldier is FishSoldier)
						{
							var myStat:Object = GameLogic.getInstance().user.GetMyInfo().BattleStat;
							GameLogic.getInstance().UpdateStatistics(myStat, Data1.isWin, true);
						}
					}
					else
					{
						GameInput.getInstance().lastAttackTime = 0;
					}
					if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST)
					{
						if(FishWorldController.GetRound() == Constant.SEA_ROUND_1)	// Đang đánh ở thế giới cá
						{
							GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_PRE_ATTACK);
							if(Data1.Sequence)
							{
								GuiMgr.getInstance().GuiMainForest.objSequenceRedUp = Data1.Sequence;
							}
						}
						else if(FishWorldController.GetRound() == Constant.SEA_ROUND_2)	// Đang đánh ở thế giới cá
						{
							GuiMgr.getInstance().GuiMainForest.objEffYellowRight = Data1.Sequence;
						}
					}
				}
			}
		}
		private function UpdateQuest(Type:String, Data1:Object, OldData:Object):void
		{
			switch (Type)
			{
				case Constant.CMD_CURE_FISH:
				case Constant.CMD_CLEAN_LAKE:
				case Constant.CMD_CARE_FISH:
					QuestMgr.getInstance().UpdateQuests(OldData as BasePacket, Data1.Num);
					break;
				case Constant.CMD_MIX_FISH:
					if (Data1.IsSuccess)
					{
						QuestMgr.getInstance().UpdateQuests(OldData as BasePacket);
					}
					break;
				case Constant.CMD_ATTACK_FRIEND_LAKE:
				case Constant.CMD_ATTACK_OCEAN_SEA:
					ProcessWarAfterReceive(Type, Data1, OldData);
					if (FishWorldController.GetSeaId() == Constant.OCEAN_FOREST &&
						FishWorldController.GetRound() == Constant.SEA_ROUND_3)
					{
						if(Data1.Sequence)
						{
							GameLogic2.objDataSequenceGreenDown= Data1;
							//GuiMgr.getInstance().GuiMainForest.objSequenceGreenDown = Data1.Sequence;
							//GuiMgr.getInstance().GuiChooseSerialAttack.StartProcessChooseSerial(Data1);
						}
					}
					break;
				case Constant.CMD_ATTACK_IN_LEAGUE:
					trace("đánh nhau đê, cá ở đây là ");
					if (Data1["Error"] == 0) {
						LeagueMgr.getInstance().curOccupy++;
						var rank:int = (OldData as SendAttackLeague).FightRank;
						var name:String = Data1["UserFought"]["Name"];
						var level:int = Data1["UserFought"]["Level"];
						var avatar:String = Data1["UserFought"]["Avatar"];
						
						LeagueInterface.getInstance().showHisAvatar(name, level, avatar);
						LeagueMgr.getInstance().initFight(OldData as SendAttackLeague, Data1);
					}
					
				break;
				default:
					QuestMgr.getInstance().UpdateQuests(OldData as BasePacket);
					break;
			}
		}
		
		private function AmfRequest(value:Object):void
		{
			if (isEncrypted)
			{
				var st:String = JSON.encode(value);
				st = Base64.encode(st);
				var leftSt:String, rightSt:String; 
				leftSt = st.substr(0, st.length - 2);
				rightSt = st.substr(st.length - 2, st.length + 1);
				st = leftSt.split("").reverse().join("") + rightSt;
			}
			
			var packetTime:Object = new Object();
			packetTime["startTime"] = GameLogic.getInstance().CurServerTime;
			packetTime["cmdId"] = BasePacket(value).GetID();
			arrPacketSending.push(packetTime);
			
			var RecieveService:Responder;
			RecieveService = new Responder(
				function (result:*):void 
				{
					//ClearTimer();
					var index:int = arrPacketSending.indexOf(packetTime);
					//trace("index", index);
					arrPacketSending.splice(index, 1);
					//var duration:Number = GameLogic.getInstance().CurServerTime - packetTime["startTime"];
					//trace("Thoi gian nhận goi tin đúng", packetTime["cmdId"], duration*1000);
					HandleUserGameMsg(value.GetID(), result, value);					
				},
			
				function (result:*):void 
				{
					//ClearTimer();
					var index:int = arrPacketSending.indexOf(packetTime);
					arrPacketSending.splice(index, 1);
					//var duration:Number = GameLogic.getInstance().CurServerTime - packetTime["startTime"];
					//trace("Thoi gian nhận goi tin lỗi", packetTime["cmdId"], duration*1000);
					HandleUserGameMsg(value.GetID(), result, value);
				});
				
			// Set Time Out 
			// TODO: Consider using 1 timer for timeout.
			//var TimeOutTimer:Timer = new Timer(TIMEOUT, 1);
			//TimeOutTimer.start();
			//
			//function OnTimeOut():void
			//{
				//switch (value.GetID())
				//{
					//case Constant.CMD_REFRESH_FRIEND:
					//case Constant.CMD_SEND_LETTER:
					//case Constant.CMD_LOAD_MAIL:
					//case Constant.CMD_LOAD_GIFT:
					//case Constant.CMD_SEND_GIFT:
					//case Constant.CMD_REMOVE_MESSAGE:
					//case Constant.CMD_ACCEPT_GIFT:
					//case Constant.CMD_GET_TOTAL_FISH:
					//case Constant.CMD_FEED_ONWALL:
					//case Constant.CMD_ACCEPT_DAILY_GIFT:
					//case Constant.CMD_GET_SERIES_QUEST:
					//case Constant.CMD_STEAL_MONEY:
					// Ignore all non-critical commands
					//break;
					//
					//default:
						//trace("Gói tin bị mất...", value.GetID());
						//GuiMgr.getInstance().GuiMessageBox.ShowReload(Localization.getInstance().getString("ErrorMsg101"));
						//break;
				//}
				
				
				//GuiMgr.getInstance().GuiWaitingData.Hide();
				//Mouse.show();
				//ClearTimer();
			//}
			
			//function ClearTimer():void
			//{
				//if (TimeOutTimer != null)
				//{
					//TimeOutTimer.stop();
					//TimeOutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, OnTimeOut);
					//SendService.removeEventListener(NetStatusEvent.NET_STATUS, OnTimeOut);
					//TimeOutTimer = null;
				//}
			//}
			
			function sieuQuang(e:NetStatusEvent):void
			{
				trace("Error NetStatusEvent :" + e);
				//ClearTimer();
			}
			
			function sieuTuan(e:SecurityErrorEvent):void
			{
				trace("Error SecurityErrorEvent :" + e);
				//ClearTimer();
			}
			
			// Timeout Event:
			//TimeOutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, OnTimeOut);
			SendService.addEventListener(NetStatusEvent.NET_STATUS, sieuQuang);
			SendService.addEventListener(SecurityErrorEvent.SECURITY_ERROR, sieuTuan);
			
			if (isEncrypted)
			{
				SendService.call(value.GetURL(), RecieveService, st);
			}
			else
			{
				SendService.call(value.GetURL(), RecieveService, value);
			}
			
			// check xem có giao dịch xu hay ko
			if (!isSendingXu && value.hasOwnProperty("PriceType") && value["PriceType"] == "ZMoney")
			{
				isSendingXu = true;
			}
			else
			{
				var minh:String = (value as BasePacket).GetID();
				if (minh == Constant.CMD_BUY_ITEM_WITH_DIAMOND || minh == Constant.CMD_BUY_ITEM_IN_EVENT)
				{
					isSendingXu = true;
				}
			}
			
			WriteDataActionClient(value);
		}
		private function WriteDataActionServer(result:Object, value:Object):void 
		{
			return;
			if (CheckLogAction(value.GetID()))
			{
				var timeStamp:Number = value.timeStamp;
				var key1:String = GenKeyDateToLogClient(timeStamp);
				var key2:String = "ActionInDay";
				var key3:String = value.GetID();
				if (logClient.data[key1] == null)	logClient.data[key1] = new Object();
				if (logClient.data[key1][key2] == null)	logClient.data[key1][key2] = new Array();
				var objElement:Object;
				var arr:Array = logClient.data[key1][key2];
				for (var i:int = arr.length - 1; i >= 0; i--) 
				{
					var item:Object = arr[i];
					if (item[KEY_TIME_STAMP] == timeStamp)
					{
						objElement = item;
						break;
					}
				}
				var objElementData:Object = objElement[KEY_DATA];
				objElementData[KEY_DATA_SERVER_SEND] = result;
				objElement[KEY_DATA] = objElementData;
				logClient.data[key1][key2] = arr;
				Ultility.FlushData(logClient);
			}
		}
		private function WriteDataActionClient(value:Object):void 
		{
			return;
			// Thực hiện ghi log client
			if(CheckLogAction(value.GetID()))
			{
				var timeStamp:Number = GameLogic.getInstance().CurServerTime;
				value.timeStamp = timeStamp;
				var key1:String = GenKeyDateToLogClient(timeStamp);
				var key2:String = "ActionInDay";
				var key3:String = value.GetID();
				var arr:Array = [];
				//if (logClient.data == null)	logClient.data = new Object();
				if (logClient.data[key1] == null)	logClient.data[key1] = new Object();
				if (logClient.data[key1][key2] is Array)	arr = logClient.data[key1][key2];
				var objElement:Object = new Object();
				var objElementData:Object = new Object();
				objElementData[KEY_DATA_CLIENT_SEND] = value;
				objElement[KEY_TYPE] = key3;;
				objElement[KEY_DATA] = objElementData;
				objElement[KEY_TIME_STAMP] = timeStamp;
				arr.push(objElement);
				logClient.data[key1][key2] = arr;
				Ultility.FlushData(logClient);
			}
			
		}
		private function CheckLogAction(typeAction:String):Boolean
		{
			switch (typeAction) 
			{
				case Constant.CMD_ATTACK_FRIEND_LAKE:
				case Constant.CMD_BUY_BACKGROUND:
				case Constant.CMD_BUY_DECORATE:
				case Constant.CMD_BUY_EQUIPMENT:
				case Constant.CMD_BUY_FISH:
				case Constant.CMD_BUY_SPECIAL_FISH:
				case Constant.CMD_BUY_OTHER:
				case Constant.CMD_BUY_PETROL:
				case Constant.CMD_COMPLETE_DAILY_QUEST_NEW:
				case Constant.CMD_RECHOOSE_DAILY_BONUS:
				case Constant.CMD_DELETE_EQUIPMENT:
				case Constant.CMD_DONE_DAILY_QUEST_BY_XU:
				case Constant.CMD_ENCHANT_EQUIPMENT:
				case Constant.CMD_EXTEND_EQUIPMENT:
				case Constant.CMD_UPDATE_EXPIRED_TIME_OF_EQUIPMENT:
				case Constant.CMD_MATE_FISH:
				case Constant.CMD_MATERIAL:
				case Constant.CMD_REBORN_SOLDIER:
				case Constant.CMD_GET_DAILY_BONUS:
				case Constant.CMD_SELL_DECORATE:
				case Constant.CMD_SELL_FISH:
				case Constant.CMD_SELL_SPARTA:
				case Constant.CMD_SELL_STOCK_THING:
				case Constant.CMD_ATTACK_OCEAN_SEA:
				case Constant.CMD_ATTACK_BOSS_OCEAN_SEA:
					return true;
				break;
			}
			return false;
		}
		public function GenKeyDateToLogClient(TimeStamp:Number):String
		{
			var dateSend:Date = new Date(TimeStamp * 1000);
			var keyDate:String = dateSend.dateUTC + "_" + dateSend.monthUTC + "_" + dateSend.fullYearUTC;
			return keyDate;
		}
		public function PushInQueue(packet:BasePacket):void
		{
			if(packet.GetID() == Constant.CMD_ICE_CREAM_BUY_ITEM)
			{
				trace("vào hàm PushInQueue");
			}
			queueOfRequest.push(packet);
			if (queueOfRequest.length == 1)
			{
				myTimeoutAllCmd.Start();
				if(packet.GetID() == Constant.CMD_ICE_CREAM_BUY_ITEM)
				{
					trace("Start hàm myTimeoutAllCmd.Start() của queue");

				}
			}
			myTimeoutCmd.Start();
			if(packet.GetID() == Constant.CMD_ICE_CREAM_BUY_ITEM)
			{
				trace("Start hàm myTimeoutCmd.Start() của gói tin mua item");
			}
		}
		
		private function SendAll(e:TimerEvent = null):void
		{
			if (isSendingXu)
			{	
				//timeoutCmd.delay = TIMEWAIT_EACH_CMD;
				//timeoutCmd.start();
				myTimeoutCmd.ReSetDelay(TIMEWAIT_EACH_CMD);
				myTimeoutCmd.Start();
				return;
			}
			var i:int;
			var length:int = (queueOfRequest.length < MAX_QUEUE_LENGTH ? queueOfRequest.length : MAX_QUEUE_LENGTH);
			var packet:BasePacket;
			var countPacket:int = 0;
			for (i = 0; i < length; i++)
			{
				packet = queueOfRequest[i];
				if (packet.GetID() == Constant.CMD_ICE_CREAM_BUY_ITEM)
				{
					countPacket++;
					trace("Đã gửi gói tin mua item thứ ", countPacket);
				}
				AmfRequest(packet);
				switch(packet.GetID())
				{
					case Constant.CMD_COLLECT_MONEY:
						collectMoneyPacket = null;
						collectMoneyMagnet = null;
						break;
					default:
						break;
				}
			}
			
			// Reset RequestQueue, bộ đếm thời gian
			queueOfRequest.splice(0, length);
			
			// trace tất cả gói tin còn lại trong queue
			for (i = 0; i < queueOfRequest.length; i++)
			{
				packet = queueOfRequest[i];
			}			
			
			if (queueOfRequest.length <= 0)
			{
				//timeoutCmd.reset();
				myTimeoutCmd.Reset();
			}
			else
			{
				//timeoutCmd.delay = TIMEOUT_EACH_CMD;
				//timeoutCmd.start();
				myTimeoutCmd.ReSetDelay(TIMEWAIT_EACH_CMD);
				myTimeoutCmd.Start();
			}
			
			//timeoutAllCmd.reset();
			myTimeoutAllCmd.Reset();
		}
		//private function HttpRequest(url:String,value:Object,handlerFun:Function,timeout:uint = 60000,reload:Boolean = false,dataFormat:String = "text"):void
		//{
			//var completeUrl:String = "";
			//if(/^http.*/.test(url))
			//{
				//completeUrl = url;
			//}
			//else
			//{
				//completeUrl = httpUrl + url;
			//}
			//
			// Send in JSON string
			//var _postData:Object;
			//if(value is String)
			//{
				//_postData = value;
			//}else if(value is URLVariables){
				//_postData = value;
			//}else{
				//var _uv:URLVariables = new URLVariables();
				//for(var _name:String in value)
				//{
					//_uv[_name] = value[_name];
				//}
				//_postData = _uv;
			//}
			//
			//var isHandler:Boolean = false;
			//var aURLRequest:URLRequest = new URLRequest(completeUrl);
			//aURLRequest.method = URLRequestMethod.POST;;
			//aURLRequest.data = _postData;
			//var aURLLoader:URLLoader = new URLLoader();
			//aURLLoader.dataFormat = dataFormat;
			//
			//Clear listener
			//function clearAll():void
			//{
				//aURLLoader.close();
				//_timer.removeEventListener(TimerEvent.TIMER,timerFn);
				//aURLLoader.removeEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
				//aURLLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
				//aURLLoader.removeEventListener(Event.COMPLETE,loadCompHandler);
			//}
//
			//function ioerrorHandler(e:IOErrorEvent):void{
				//if(!isHandler)
				//{
					//handlerFun('{"errorType":"IOError","errorContent":""}');
					//isHandler = true;
				//}
				//clearAll();
			//};
//
			//function httpStatusHandler(e:HTTPStatusEvent):void
			//{
				//if(e.status != 0 && e.status != 200)
				//{
					//if(!isHandler)
					//{
						//handlerFun('{"errorType":"httpStatus","errorContent":'+ e.status +'}');
						//isHandler = true;
					//}
					//clearAll();
				//}
			//}
			//
			//function loadCompHandler(e:Event):void
			//{
				//if(!isHandler)
				//{
					//handlerFun(e.currentTarget.data);
					//isHandler = true;
				//}
				//clearAll();
			//}
			//
			//Timer processing
			//function timerFn(e:TimerEvent):void {
				//if(reload)
				//{
					//if(getTimer() - timerValue > timeout && requestNum == 0)
					//{
						//aURLLoader.load(aURLRequest);
						//timerValue = getTimer();
						//requestNum = 1;
					//}else if(getTimer() - timerValue > timeout && requestNum == 1){
						//if(!isHandler)
						//{
							//handlerFun('{"errorType":"timeOut","content":""}');
							//isHandler = true;
						//}
						//clearAll();
					//}
				//}else{
					//if(getTimer() - timerValue > timeout){
						//if(!isHandler)
						//{
							//handlerFun('{"errorType":"timeOut","content":""}');
							//isHandler = true;
						//}
						//clearAll();
					//}
				//}
			//};
			//
			//aURLLoader.addEventListener(IOErrorEvent.IO_ERROR,ioerrorHandler);
			//
			//aURLLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
			//
			//aURLLoader.addEventListener(Event.COMPLETE,loadCompHandler);
//
			//aURLLoader.load(aURLRequest);
			//
			//var timerValue:int = getTimer();
			//var requestNum:int = 0;
			//_timer.addEventListener(TimerEvent.TIMER,timerFn);
		//}
		
		/*private function PostRequest(value:Object,handlerFun:Function,timeout:int=60000,reload:Boolean=false,dataFormat:String="text"):void
		{
			// Send in JSON string
			var url:String = value.GetURL();
			var JSONRequest:URLVariables = new URLVariables();
			JSONRequest.gaga = JSON.encode(value);
			
			
			HttpRequest(url, JSONRequest, function (data:Object):void{
			
				var _data:Object = decode(data);
				
				if(_data){
					if(_data.hasOwnProperty("errorType") && _data["errorType"] == "session")
					{
						//MData.getInstance().mainData.sessionTimeout = _data["errorContent"];
					}
					handlerFun(value.GetID(), _data);					
				}else{
					trace('Data is empty!')
				}
			},timeout,reload,dataFormat);
		}*/
		
		
		//private function decode(data:*):Object{
				//var _data:Object;
				//try{
					//var loadStr:String = dataToString(data);
					//loadStr = StringUtil.trim(loadStr);
					//if(/^[\{\[].*/.test(loadStr) == false)
					//{
						//loadStr = '{"errorType":"PHPError","errorContent":"'+ loadStr +'"}';
					//}
					//_data = JSON.decode(loadStr);
					//return _data;
				//}catch(e:Error){
					//trace('JSON decoding error:'+e+'\n'+loadStr);
				//}
				//return null;
		//}
		
		//The byteArray to String
		//private function dataToString(data:Object):String
		//{
			//if(data is ByteArray)
			//{
				//var byte:ByteArray = data as ByteArray;
				//byte.position = 0;
				//var s:String = byte.readUTFBytes(byte.length);
				//return s;
			//}
			//return data.toString();
		//}
		
		public function checkTimeOut():void
		{
			if (arrPacketSending != null)
			{
				//trace("length", arrPacketSending.length);
				for (var i:int = 0; i < arrPacketSending.length; i++)
				{
					var duration:Number = GameLogic.getInstance().CurServerTime - arrPacketSending[i]["startTime"];
					if (duration*1000 > TIMEOUT)
					{
						trace("Gói tin bị timeout ", arrPacketSending[i]["cmdId"], duration*1000);
						switch (arrPacketSending[i]["cmdId"])
						{
							case Constant.CMD_REFRESH_FRIEND:
							case Constant.CMD_SEND_LETTER:
							case Constant.CMD_LOAD_MAIL:
							case Constant.CMD_LOAD_GIFT:
							case Constant.CMD_SEND_GIFT:
							case Constant.CMD_REMOVE_MESSAGE:
							case Constant.CMD_ACCEPT_GIFT:
							case Constant.CMD_GET_TOTAL_FISH:
							case Constant.CMD_FEED_ONWALL:
							case Constant.CMD_ACCEPT_DAILY_GIFT:
							case Constant.CMD_GET_SERIES_QUEST:
							case Constant.CMD_STEAL_MONEY:
								break;
							default:
								if (Constant.DEV_MODE)
								{
									GuiMgr.getInstance().GuiMessageBox.ShowReload("Gói tin" + arrPacketSending[i]["cmdId"] + " bị timeout");
								}
								else
								{
									GuiMgr.getInstance().GuiMessageBox.ShowReload(Localization.getInstance().getString("ErrorMsg101"));
								}
								break;
						}
						GuiMgr.getInstance().GuiWaitingData.Hide();
						Mouse.show();
						arrPacketSending = [];
						break;
					}
				}
			}
		}
		
	}

}