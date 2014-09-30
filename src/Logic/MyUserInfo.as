package Logic 
{
	import Data.ConfigJSON;
	import Event.EventNoel.NoelGui.ShocksNoel;
	import GUI.Event8March.CoralTree;
	import GUI.Event8March.GiftBoxAfter;
	import GUI.EventBirthDay.EventGUI.BirthdayCandle;
	import GUI.GuiMgr;
	import NetworkPacket.PacketReceive.GetLoadInventory;
	import NetworkPacket.PacketSend.SendExpiredEnergyMachine;
	/**
	 * ...
	 * @author ducnh
	 */
	public class MyUserInfo
	{
		// thong tin lay tu database ve
		public var UserName:String;
		public var AutoId:int;
		public var AvatarPic:String;
		public var AvatarType:int;
		public var Energy:Number;
		public var Exp:int;
		public var FoodCount:int;
		public var Id:int = -1;
		public var LakeNumb:int;
		public var LastEnergyTime:Number;
		public var LastGiftTime:int;
		public var LastLuckyTime:int;
		public var Diamond:int;
		public var Money:Number = 0;
		public var Name:String;
		public var ZMoney:int;
		public var Ticket:int;
		public var GiftTicket:int;
		public var MixLakeCount:int;
		public var lastEnergyTime:Number;
		public var Level:int;
		public var NewMessage:Boolean;
		public var NewGift:Boolean;
		public var NumReceiver:int;
		public var ReceiverGiftList: Array = [];
		public var SenderGiftList: Array = [];
		public var LastGetGiftDay:Number;
		public var NewDailyQuest:Boolean;
		public var NumOnline:int;
		public var LevelMixLake:int;
		public var SlotUnlock:int;
		public var MaxFishLevelUnlock:int;		
		public var FeedInfo:Array = [];
		public var BoatType:int;
		public var EnergyBox:Array = [];
		public var EnergyBoxTime:int;
		public var EventVersion:int;
		public var event:Object;
		public var MaxEnergyUse:Object;
		public var Skill:Object;
		public var MatLevel:int;
		public var MatPoint:int;
		public var NumFill:int;
		public var LastFillEnergy:int;
		public var hasMachine:Boolean;
		public var energyMachine:EnergyMachine;
		public var coralTree:CoralTree;					//event 8-3
		public var shocksNoel:ShocksNoel;					//tất Noel
		public var giftBoxAfter:GiftBoxAfter;			//after event 8-3
		public var birthdayCandle1:BirthdayCandle;
		public var birthdayCandle2:BirthdayCandle;
		public var birthdayCandle3:BirthdayCandle;
		public var IsExpiredMachine:Boolean;
		public var StartTimeEnergyMachine:Number;
		public var ExpiredTimeEnergyMacnine:Number;
		public var VarMoney:int;
		public var JustExpired:Boolean;
		public var bonusMachine:int;
		public var bonusEnergy:int;
		public var FairyDrop:Number;
		public var MySoldierArr:Array = [];
		public var EventInfo:Object;
		public var Avatar:Object;		// Những người bạn đã đánh (bị đánh)
		public var BuySuperFishTime:Object;
		public var NumTakePictureTime:Number;
		public var LastPictureTime:Number;
		public var BattleStat:Object;
		public var Attack:Object;
		public var LastInitRun:Number;
		
		public var DailyEnergy:Object;
		public var LastTimeDailyEnergy:Number;
		public var NumGetGift:int;
		public var MaxGetGift:int;
		public var TotalTimeOffline:Number;
		
		public var outGameFW:Object;
		
		public var NumBuyDiscount:Object;
		
		public var FirstAddXuGift:Object;//cho cái nạp thẻ lần đầu
		public var FirstAddXu:int;//cho cái nạp thẻ lần đầu
		//public var PowerTinhQuest:Object;
		
		public var ReputationLevel:int;
		public var ReputationPoint:int;
		public var ReputationQuest:Object = new Object();
		
		public function MyUserInfo() 
		{
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
			
			//ReputationLevel = Math.random() * 8 + 1;
		}
		public function InitEnergyMachine(data:Object):void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			if (energyMachine)//nếu có máy rồi (Trường hợp từ nhà mình về nhà mình)
			{//xóa cái máy cũ
				energyMachine.Destructor();
				energyMachine = null;
			}
			energyMachine = new EnergyMachine(layer, "MayBuff", EnergyMachine._x, EnergyMachine._y);
			energyMachine.SetInfo(data);
			//khởi tạo cho biến hasEnergyMachine và biến IsExpiredMachine
			hasMachine = true;
			StartTimeEnergyMachine = energyMachine.StartTime;
			ExpiredTimeEnergyMacnine = energyMachine.ExpiredTime;
			if (energyMachine.IsExpired)
				IsExpiredMachine = true;
			else 
				IsExpiredMachine = false;
		}
		
		public function initCoralTree(data:Object):void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			if (coralTree)//có cây rồi
			{//xóa cây cũ
				coralTree.Destructor();
				coralTree = null;
			}
			coralTree = new CoralTree(layer, "", 100, 100);
			coralTree.SetInfo(data);
		}
		
		public function initShocksNoel(data:Object):void 
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			if (shocksNoel)//có tất rồi
			{//xóa tất cũ
				shocksNoel.Destructor();
				shocksNoel = null;
			}
			shocksNoel = new ShocksNoel(layer, "", 100, 100);
			shocksNoel.SetInfo(data);
		}
		
		public function initBirthdayCandle(data:Object, id:int):void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(1);
			//var myBirthdayCandle:BirthdayCandle = this["birthdayCandle" + id];
			if (this["birthdayCandle" + id])//có nến rồi
			{//xóa nến cũ
				this["birthdayCandle" + id].Destructor();
				this["birthdayCandle" + id] = null;
			}
			this["birthdayCandle" + id] = new BirthdayCandle(layer, "", 0, 0);
			this["birthdayCandle" + id].initData(data, id);
		}
		
		public function initGiftBoxAfterEvent(data:Object):void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			if (giftBoxAfter)//có hộp quà rồi
			{//xóa hộp quà cũ
				giftBoxAfter.Destructor();
				giftBoxAfter = null;
			}
			giftBoxAfter = new GiftBoxAfter(layer, "Event8March_GiftBoxAfter", 100, 100);
			giftBoxAfter.SetInfo(data);
		}
		
		public function UpdateEnergyMachine():void
		{//thực hiện update cho máy nlg của nhà mình khi mình đang ở nhà bạn => không quan tâm đến Interface mà chỉ quan tâm Logic
			var currentTime:Number = GameLogic.getInstance().CurServerTime;
			var timeConlai:Number = StartTimeEnergyMachine + ExpiredTimeEnergyMacnine - currentTime;
			if (timeConlai <= 0 && !IsExpiredMachine)
			{
				
				var id:int = this.Id;
				var cmd:SendExpiredEnergyMachine = new SendExpiredEnergyMachine(id);
				Exchange.GetInstance().Send(cmd);
				IsExpiredMachine = true;
				var iCurEnergy:int = this.Energy + this.bonusMachine;
				var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(Level);
				//GuiMgr.getInstance().GuiTopInfo.SuggestEnergyTooltip(iCurEnergy,maxEnergy);
				//GuiMgr.getInstance().guiFrontScreen.updateEnergy(iCurEnergy, maxEnergy);
				GuiMgr.getInstance().guiUserInfo.energy = iCurEnergy;
				GameLogic.getInstance().user.updateBonusMachine();
			}
		}
		/**
		 * Người chơi mua energy Machine trong shop
		 */
		public function BuyEnergyMachine(id:int):void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			energyMachine = new EnergyMachine(layer, "MayBuff", EnergyMachine._x, EnergyMachine._y);
			hasMachine = true;
			energyMachine.Id = id;
			energyMachine.IsExpired = true;
			energyMachine.StartTime = 0;
			energyMachine.ExpiredTime = 0;
			hasMachine = true;
			StartTimeEnergyMachine = 0;
			ExpiredTimeEnergyMacnine = 0;
			IsExpiredMachine = true;
			energyMachine.SetScaleXY(0.8);
			energyMachine.SetInterface();
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
		/*
		 * 
		 */
		public function initTicket(data:Object):void
		{
			if (data["Store"]["StoreList"]["Items"]["Ticket"] != null)
			{
				Ticket = data["Store"]["StoreList"]["Items"]["Ticket"]["1"];
			}
			else
			{
				Ticket = 0;
			}
			
		};
		public function initGiftTicket(data:Object):void
		{
			if (data["Store"]["StoreList"]["Items"]["GiftTicket"] != null)
				GiftTicket = data["Store"]["StoreList"]["Items"]["GiftTicket"]["1"];
			else
				GiftTicket = 0;
		};
		public function getDataForLM(data:Object):Object
		{
			var rs:Object;
			data = new Object();
			data["Minigame"] = null;
			if (data["Minigame"] == null) {
				rs = new Object();
				rs["Floor"] = 2;
				rs["ItemType"] = "";
				rs["LevelGift"] = 0;
				rs["TicketType"] = "";
				return rs;
			}
			
			if (data["Minigame"] is Array)
			{
				rs = new Object();
				rs["Floor"] = 2;
				rs["ItemType"] = "";
				rs["LevelGift"] = 0;
				rs["TicketType"] = "";
			}
			else
			{
				if (data["Minigame"]["GameList"] == null)
				{
					rs = new Object();
					rs["Floor"] = 2;
					rs["ItemType"] = "";
					rs["LevelGift"] = 0;
					rs["TicketType"] = "";
					return rs;
				}
				if (data["Minigame"]["GameList"] is Array)
				{
					rs = new Object();
					rs["Floor"] = 2;
					rs["ItemType"] = "";
					rs["LevelGift"] = 0;
					rs["TicketType"] = "";
				}
				else
				{
					if (data["Minigame"]["GameList"]["LuckyMachine"] is Array)
					{
						rs = new Object();
						rs["Floor"] = 2;
						rs["ItemType"] = "";
						rs["LevelGift"] = 0;
						rs["TicketType"] = "";
					}
					else
					{
						if (data["Minigame"]["GameList"]["LuckyMachine"]["GiftArr"] is Array)
						{
							rs = new Object();
							rs["ItemType"] = "";
							rs["Floor"] = 2;
							rs["LevelGift"] = 0;
							rs["TicketType"] = "";
						}
						else {
							rs = data["Minigame"]["GameList"]["LuckyMachine"]["GiftArr"];
							rs["Floor"] = data["Minigame"]["GameList"]["LuckyMachine"]["GiftArr"]["TicketType"];
						}
						if (data["Minigame"]["GameList"]["LuckyMachine"]["Limit"] is Array)
						{
							rs["Play_Limit_2"] = 0;
							rs["Play_Limit_10"] = 0;
						}
						else {
							rs["Play_Limit_2"] = data["Minigame"]["GameList"]["LuckyMachine"]["Limit"]["Play_Limit_2"];
							rs["Play_Limit_10"] = data["Minigame"]["GameList"]["LuckyMachine"]["Limit"]["Play_Limit_10"];
						}
					};
					
				};
				
			};
			return rs;
		}
		
		
	}
}
