package GUI.Expedition.ExpeditionLogic 
{
	import Data.ConfigJSON;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import GUI.Expedition.ExpeditionGui.GuiExpedition;
	import GUI.Expedition.ExpeditionGui.GuiReceiveGiftExpedition;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	import NetworkPacket.BasePacket;
	/**
	 * Quản lý toàn bộ Viễn Chinh
	 * @author HiepNM2
	 */
	public class ExpeditionMgr 
	{
		static private var _instance:ExpeditionMgr = null;
		public var IsLoadExpeditionComp:Boolean;
		private var _versionTask:String;
		
		public var inUpdateButton:Boolean = false;//xem có thực hiện rung cái nút viễn chinh ko?
		
		private var _quest:ExQuestInfo;		//quest hiện tại
		private var _gift:Array = [];		//gift hiện tại ["Normal"] và ["Special"]
		private var _value:int;				//giá trị của quà hiện tại
		private var _silkRoad:Array = [];	//con đường viễn chinh
		private var _index:int = 0;			//chỉ số hiện tại trên con đường viễn chinh
		private var _numCard:int = 0;		//số lệnh bài hiện tại
		private var _numRoll:int;			//số lần deo xúc xắc
		
		private var _giftServer:Array = [];		//phần thưởng lấy về từ server
		private var _logServerTime:int;
/********************************************** getter and setter ********************************************/
		public function getSilkRoad():Array
		{
			return _silkRoad;
		}
		public function getQuest():ExQuestInfo
		{
			return _quest;
		}
		public function getGift():Array
		{
			return _gift;
		}
		public function get Index():int 
		{
			return _index;
		}
		public function set Index(value:int):void 
		{
			_index = value;
		}
		public function get NumCard():int 
		{
			return _numCard;
		}
		
		public function set NumCard(value:int):void 
		{
			_numCard = value;
		}
		public function get NumRoll():int 
		{
			return _numRoll;
		}
		public function set NumRoll(value:int):void 
		{
			_numRoll = value;
		}
		public function get GiftServer():Array
		{
			return _giftServer;
		}
		public function get Value():int
		{
			return _value;
		}
/********************************************** create function ********************************************/
		public function ExpeditionMgr() 
		{
			_versionTask = Main.verLocalization;
		}
		
		static public function getInstance():ExpeditionMgr 
		{
			if (_instance == null) {
				_instance = new ExpeditionMgr();
			}
			return _instance;
		}
/*********************************************  function ****************************************************/
/////////////load dữ liệu
		/**
		 * thực hiện load file ExpeditionTask.xml 
		 * 		chi thuc hien 1 lan duy nhat khi vao game va mo gui vien trinh
		 * @param	_xmlVersion : version của file
		 */
		public function loadExpeditionXML(_xmlVersion:String):void
		{
			IsLoadExpeditionComp = false;
			var iniURL:String;			
			var iniURLLoader:URLLoader = new URLLoader();
			if (Constant.OFF_SERVER)
			{
				iniURL = "../src/GUI/Expedition/ExpeditionTask.xml";
			}
			else
			{
				iniURL = Main.staticURL + "/xml/ExpeditionTask" + _xmlVersion + ".xml";
			}
			iniURLLoader.addEventListener(Event.COMPLETE, loadExpeditionComp);
			iniURLLoader.load(new URLRequest(iniURL));
		}
		
		/**
		 * xử lý việc load xong file xml chứa các nhiệm vụ viễn chinh
		 * @param	e : chứa dữ liệu load về
		 */
		private function loadExpeditionComp(e:Event):void 
		{
			ExpeditionXML.getInstance().Data = XML(e.currentTarget.data);
			IsLoadExpeditionComp = true;
			/*xử lý gui*/
			var guiExpedition:GuiExpedition = GuiMgr.getInstance().guiExpedition;
			guiExpedition.IsLoadFileOk = true;
			if (guiExpedition.IsVisible)
			{
				var initGuiOk:Boolean = guiExpedition.LoadDataComp && guiExpedition.FinishRoomOutComp;
				if (initGuiOk) {
					guiExpedition.EndingRoomOut();
				}
			}
		}
//////////liên quan đến quest
		/**
		 * Xét xen gói tin chuẩn bị send lên có phải quest không
		 * @param	cmd : gói tin chuẩn bị send lên
		 * @return : true => là quest, false => không phải quest
		 */
		public function IsQuest(cmd:BasePacket):Boolean 
		{
			var data:Array = cmd.GetURL().split(".");
			var sService:String = data[0];
			var sApi:String = data[1];
			if (_quest == null)
			{
				return false;
			}
			if (sService == "ExpeditionService")
			{
				return false;
			}
			if (checkSpecialAction(_quest.Action, cmd.GetID()))//check các action đặc biệt
			{
				return true;
			}
			if (sApi == _quest.Action)
			{
				var cfg:Object = ConfigJSON.getInstance().getItemInfo("ExpeditionQuest")[_quest.Type][_quest.QuestId];
				var input:Object;
				switch(sApi)
				{
					case "acttackMonster":
					case"acttackBoss":
						input = new Object();
						input["SeaId"] = cfg["Output"]["IdSea"];
						break;
					case "exchangeItemCollection":
						input = cfg["Input"];
						if (cfg["Output"]["Type"])
						{
							input["ItemType"] = cfg["Output"]["Type"];
						}
						break;
					case "cleanLake":
					case "run":
					case "feed":
						input = cfg["Input"];
						var isHome:Boolean = !GameLogic.getInstance().user.IsViewer();
						var self:Boolean = (input["UserId"] == "Self");
						return (isHome && self) || (!isHome && !self);
					default:
						input = cfg["Input"];
				}
				if (checkInput(cmd, input))
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		
		private function checkSpecialAction(action:String, idPackage:String):Boolean 
		{
			switch(action)
			{
				case "useEnergy"://quest sử dụng năng lượng
					switch(idPackage)
					{
						case Constant.CMD_CLEAN_LAKE:
						case Constant.CMD_FEED_FISH:
						case Constant.CMD_CARE_FISH:
						case Constant.CMD_MATE_FISH:
						case Constant.CMD_MIX_FISH:
						case Constant.CMD_FISHING:
						case Constant.CMD_ATTACK_FRIEND_LAKE:
						case Constant.CMD_ATTACK_OCEAN_SEA:
						case Constant.CMD_ATTACK_BOSS_OCEAN_SEA:
							return true;
					}
					break;
				case "collectMaterial"://thu thập ngư thạch
					switch(idPackage)
					{
						case Constant.CMD_CARE_FISH:
						case Constant.CMD_FEED_FISH:
						case Constant.CMD_FISHING:
						case Constant.CMD_CLEAN_LAKE:
						case Constant.CMD_ATTACK_FRIEND_LAKE:
							return true;
					}
					break;
				case "earnMoney"://kiếm tiền
					switch(idPackage)
					{
						case Constant.CMD_COLLECT_MONEY:
						case Constant.CMD_STEAL_MONEY:
						case Constant.CMD_SELL_FISH:
						case Constant.CMD_ACCEPT_DAILY_GIFT:
						case Constant.CMD_COMPLETE_SERIES_QUEST:
						case Constant.CMD_FISHING:
						case Constant.CMD_SELL_DECORATE:
						case Constant.CMD_SELL_SPARTA:
						case Constant.CMD_SELL_STOCK_THING:
						case Constant.CMD_SEND_CLICK_MERMAID:
						case Constant.CMD_LEVEL_UP:
						case Constant.CMD_GET_NEW_USER_GIFT_BAG:
						case Constant.CMD_GET_DAILY_BONUS:
						case Constant.CMD_ATTACK_FRIEND_LAKE:
						case Constant.CMD_ATTACK_BOSS_OCEAN_SEA:
						case Constant.CMD_ATTACK_OCEAN_SEA:
							return true;
					}
					break;
				case "fishingFish"://câu cá
					switch(idPackage)
					{
						case Constant.CMD_FISHING:
							return true;
					}
					break;
			}
			return false;
		}
		
		private function checkInput(cmd:BasePacket, param:Object):Boolean 
		{
			if (param == null)
			{
				return true;
			}
			var hasKey:Boolean = true;
			for (var s:String in param)
			{
				if (cmd[s] != param[s])
				{
					hasKey = false;
					break;
				}
			}
			return hasKey;
		}
		
		/**
		 * cập nhật cho quest hiện tại
		 * @param	type : ID của gói tin vừa gửi lên
		 * @param	data : dữ liệu nhận về
		 * @param	oldPacket : gói tin vừa gửi lên
		 */
		public function updateQuest(type:String, data:Object, oldPacket:BasePacket):void 
		{
			if (data["Error"] != 0)//lỗi
			{
				return;
			}
			if (_quest == null)//chưa set quest
			{
				return;
			}
			if (_quest.QuestId < 0)//chưa có quest
			{
				return;
			}
			var sApi:String = oldPacket.GetURL().split(".")[1];
			if (_quest.Action != sApi)				//action vừa thực hiện không phải quest hiện tại
			{
				return;
			}
			_quest.NumTaskComp++;
			inUpdateButton = _quest.IsComplete();
		}
		
		public function isComplete():Boolean
		{
			return _quest.IsComplete();
		}
////////liên quan đến viễn chinh
		public function initData(data:Object):void 
		{
			var isNextDay:Boolean = data["IsNextDay"];
			_silkRoad = data["SilkRoad"];
			_quest = new ExQuestInfo();
			_gift = [];
			if (isNextDay)
			{
				_index = 0;
			}
			else 
			{
				_quest.setInfo(data["Quest"]);
				_index = data["Index"];
				initGift(data["Gift"]);
			}
			_quest.Type = _silkRoad[_index];
			_numCard = data["NumCard"];
			_numRoll = data["NumRoll"];
			_logServerTime = int(data["CurServerTime"]);
		}
		
		/**
		 * khởi tạo cho quà _value và gift
		 * @param	data : dữ liệu
		 */
		private function initGift(data:Object):void 
		{
			var str:String;
			var i:int;
			var listNormal:Array = [];
			var listSpecial:Array = [];
			var tmpGift:AbstractGift;
			if (data == null)
			{
				return;
			}
			for (str in data)
			{
				_value = int(str);
			}
			for (i = 0; i < data[str]["Sure"].length; i++)
			{
				tmpGift = new GiftNormal();
				tmpGift.setInfo(data[str]["Sure"][i]);
				_gift.push(tmpGift);
			}
			if (data[str]["More"] == null)
			{
				return;
			}
			for (i = 0; i < data[str]["More"].length; i++)
			{
				if (Ultility.categoriesGift(data[str]["More"][i]["ItemType"]))
				{
					tmpGift = new GiftSpecial();
				}
				else
				{
					tmpGift = new GiftNormal();
				}
				tmpGift.setInfo(data[str]["More"][i]);
				_gift.push(tmpGift);
			}
		}
		
		public function initGiftServer(data:Object):void
		{
			var gift:AbstractGift;
			freeGiftServer();
			for (var s:String in data["Gift"])
			{
				for (var type:String in data["Gift"][s])
				{
					for (var i:int = 0; i < data["Gift"][s][type].length; i++)
					{
						var oGift:Object = data["Gift"][s][type][i];
						if (type == "Equipment")
						{
							gift = new GiftSpecial();
						}
						else
						{
							gift = new GiftNormal();
						}
						gift.setInfo(oGift);
						_giftServer.push(gift);
					}
				}
			}
		}
		
		private function initGiftTrunk(data:Object):void
		{
			var gift:AbstractGift;
			freeGiftServer();
			for (var s:String in data["TrunkGift"])
			{
				for (var i:int = 0; i < data["TrunkGift"][s].length; i++)
				{
					var oGift:Object = data["TrunkGift"][s][i];
					if (s == "Equipment")
					{
						gift = new GiftSpecial();
					}
					else
					{
						gift = new GiftNormal();
					}
					gift.setInfo(oGift);
					_giftServer.push(gift);
				}
			}
		}
		
		public function initGiftChance(data:Object):void
		{
			var gift:AbstractGift;
			freeGiftServer();
			for (var s:String in data["Gift"])
			{
				for (var i:int = 0; i < data["Gift"][s].length; i++)
				{
					var oGift:Object = data["Gift"][s][i];
					if (s == "Equipment")
					{
						gift = new GiftSpecial();
					}
					else
					{
						gift = new GiftNormal();
					}
					gift.setInfo(oGift);
					_giftServer.push(gift);
				}
			}
		}
		private function freeGiftServer():void
		{
			if (_giftServer == null)
			{
				return;
			}
			var gift:AbstractGift;
			for (var i:int = 0; i < _giftServer.length; i++)
			{
				_giftServer[i] = null;
			}
			_giftServer.splice(0, _giftServer.length);
		}
		
		
		
		public function rollingDice(data:Object):void
		{
			_index = data["Index"];								//vị trí tiếp theo
			var type:int = _silkRoad[_index];
			if (type == 4)//ô khí vận
			{
				GuiMgr.getInstance().guiExpeditionGift.TypeChance = data["Chance"]["Type"];
				if (data["Chance"]["Type"] == GuiReceiveGiftExpedition.BAD)
				{
					var bad:int = ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["Bad"];
					freeGiftServer();
					_giftServer = [];
					_quest.setInfo(data["Quest"]);						//khởi tạo quest ở ô bị lùi vào
					initGift(data["Gift"]);								//khởi tạo cho quà
				}
				else if (data["Chance"]["Type"] == GuiReceiveGiftExpedition.LUCKY)
				{
					initGiftChance(data["Chance"]);
				}
			}
			else if(type % 10 == 0)//Rương Viễn Chinh
			{
				resetQuest();
				initGiftTrunk(data);
			}
			else//ô quest bình thường
			{
				freeGiftServer();
				if (data["TrunkGift"])
				{
					initGiftTrunk(data);
				}
				_quest.setInfo(data["Quest"]);
				initGift(data["Gift"]);								//khởi tạo cho quà
			}
			_quest.Type = _silkRoad[_index];						//loại quest
		}
		/**
		 * tăng giá trị cho quà 
		 * @param	data : dữ liệu server sau khi ấn tăng giá trị
		 */
		public function increaseValue(data:Object):void
		{
			/*giải phóng cho gift hiện tại*/
			resetGift();
			/*khởi tạo gift*/
			initGift(data["Gift"]);
		}
		/**
		 * giảm độ khó cho quest
		 * @param	data : dữ liệu server sau khi ấn giảm độ khó
		 */
		public function decreaseHard(data:Object):void
		{
			_quest.QuestId = data["Quest"]["QuestId"];
			_quest.HardId = data["Quest"]["HardId"];
			_quest.NumTaskComp = 0;
		}
		
		
		public function Destructor():void 
		{
			_quest = null;
			resetGift();
			_silkRoad.splice(0, _silkRoad.length);
			_silkRoad = null;
			_value = _numCard = _numRoll = _index = -1;
		}
		
		private function resetGift():void
		{
			for (var i:int = 0; i < _gift.length; i++)
			{
				_gift[i] = null;
			}
			_gift.splice(0, _gift.length);
		}
		
		public function resetQuest():void
		{
			_quest.QuestId = -1;
			_quest.HardId = -1;
			_quest.NumTaskComp = 0;
			resetGift();
		}
		public function isFinish():Boolean
		{
			var maxRoad:int = ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["MaxRoad"];
			return _index == ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["MaxRoad"];
		}
		
		public function isMaxValue():Boolean 
		{
			return _value == ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["MaxValue"];
		}
		
		public function isNextDay():Boolean
		{
			var curTime:int = int(GameLogic.getInstance().CurServerTime);
			var zeroHourCurTime:int = Ultility.getHourZeroVietnamese(curTime);//thời điểm 0h của ngày hiện tại
			var zeroHourLogServerTime:int = Ultility.getHourZeroVietnamese(_logServerTime); //thời điểm 0h của ngày getStatus
			return (zeroHourCurTime != zeroHourLogServerTime);
			
		}
	}

}





















