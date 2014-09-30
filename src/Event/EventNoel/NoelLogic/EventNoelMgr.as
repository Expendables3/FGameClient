package Event.EventNoel.NoelLogic 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Event.EventNoel.NoelLogic.Round.RoundAbstractInfo;
	import Event.EventNoel.NoelLogic.Round.RoundNoel;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	/**
	 * Lớp quản lý dữ liệu riêng cho EventNoel
	 * @author HiepNM2
	 */
	public class EventNoelMgr 
	{
		private static var _instance:EventNoelMgr = null;
		private var _allGift:Array;	
		private var _logTime:Number = -1;
		private var _lastTimeFinish:Number = -1;
		private var _startTimeGame:Number = -1;
		private var _numPlay:int = -1;
		private var _seed:Number;							//seed sinh key
		private var _tempStore:Array;					//kho tạm để lưu trữ quà từ khi bắt đầu 1 round cho đến khi kết thúc round đó
		
		
		public function set LastTimeFinish(val:Number):void { _lastTimeFinish = val; }
		public function get LastTimeFinish():Number { return _lastTimeFinish; }
		public function set StartTimeGame(val:Number):void { _startTimeGame = val; }
		public function get StartTimeGame():Number { return _startTimeGame; }
		public function get NumPlay():int { return _numPlay; }
		public function set NumPlay(val:int):void { _numPlay = val; }
		public function get LogTime():Number { return _logTime; }
		public function set LogTime(value:Number):void { _logTime = value; }
		public function get Seed():Number { return _seed; }
		public function set Seed(value:Number):void 
		{ 
			_seed = value; 
			decodeSendFire();
		}
		
		public function initTempStore(data:Object):void
		{
			if (_tempStore == null)
			{
				_tempStore = [];
			}
			else
			{
				_tempStore.splice(0, _tempStore.length);
			}
			
			var gift:AbstractGift;
			var i:String;
			var obj:Object;
			for (i in data["Equipment"])
			{
				obj = data["Equipment"][i];
				gift = AbstractGift.createGift(obj["Type"]);
				gift.setInfo(obj);
				_tempStore.push(gift);
			}
			for (i in data["Normal"])
			{
				obj = data["Normal"][i];
				gift = AbstractGift.createGift(obj["ItemType"]);
				gift.setInfo(obj);
				_tempStore.push(gift);
			}
		}
		
		public function pushToTempStore(gift:AbstractGift):void
		{
			_tempStore.push(gift);
		}
		public function clearTempStore():void
		{
			_tempStore.splice(0, _tempStore.length);
			_tempStore = null;
		}
		public function getGiftInStore(index:int):AbstractGift
		{
			return _tempStore[index];
		}
		public function getNumGiftInStore():int
		{
			//trace("length:", _tempStore.length);
			return _tempStore.length;
		}
		public function get InWaitLogGame():Boolean
		{
			return _startTimeGame < 0;
		}
		public function get LogGameOk():Boolean
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			//if (_startTimeGame < 0)
			//{
				var timeWait:Number = ConfigJSON.getInstance().getItemInfo("Noel_BoardConfig")["BoardGame"]["WaitTime"];
				var passTime:Number = curTime - _lastTimeFinish;
				var remainTime:Number = timeWait - passTime;
				return remainTime < 0;//không còn thời gian đợi
			//}
			//return false;
		}
		
		public function get RemainNumPlay():int
		{
			var maxNumPlay:int = ConfigJSON.getInstance().getItemInfo("Noel_BoardConfig")["BoardGame"]["LimitDay"];	
			var res:int = maxNumPlay - _numPlay;
			res = res > 0 ? res : 0;
			return res;
		}
		
		public function getRemainTime():Number
		{
			var timeWait:Number = ConfigJSON.getInstance().getItemInfo("Noel_BoardConfig")["BoardGame"]["WaitTime"];
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var passTime:Number = curTime - _lastTimeFinish;
			var remainTime:Number = timeWait - passTime;
			return remainTime;
		}
		
		public function EventNoelMgr()
		{
			var data:Object = ConfigJSON.getInstance().getItemInfo("ColP_ExchangeGift");
			initAllGift(data["HuntGift"]);
		}
		
		public static function getInstance():EventNoelMgr
		{
			if (_instance == null)
			{
				_instance = new EventNoelMgr();
			}
			return _instance;
		}
		
		private function initAllGift(data:Object):void 
		{
			var count:int = 0;
			var dem:int = 0;
			var listCount:Array = [];
			for (var s:String in data)
			{
				count++;
				dem = 0;
				for (var st:String in data[s])
				{
					dem++;
				}
				listCount.push(dem);
			}
			var len:int;
			var info:AbstractGift;
			var temp:Object;
			_allGift = [];
			var _tabGift:Array;
			for (var i:int = 1; i <= count; i++)
			{
				len = listCount[i - 1];
				_tabGift = new Array();
				for (var j:int = 1; j <= len - 1; j++)
				{
					temp = data[i][j]["1"];
					info = AbstractGift.createGift(temp["ItemType"]);
					info.setInfo(temp);
					_tabGift.push(info);
				}
				_allGift.push(_tabGift);
			}
		}
		
		public function getTabGift(idTab:int):Array
		{
			return _allGift[idTab - 1];
		}
		
		public function getGift(idTab:int, idGift:int):AbstractGift
		{
			return _allGift[idTab - 1][idGift - 1];
		}
		
		public function processGotoHunt():void 
		{
			if (RemainNumPlay == 0)
			{
				if (_startTimeGame < 0)
				{
					showMsgLimitOut();
					return;
				}
			}
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (_startTimeGame < 0)//đang đợi để log game
			{
				var timeWait:Number = ConfigJSON.getInstance().getItemInfo("Noel_BoardConfig")["BoardGame"]["WaitTime"];
				var passTime:Number = curTime - _lastTimeFinish;
				var remainTime:Number = timeWait - passTime;
				if (remainTime < 0)
				{
					GuiMgr.getInstance().guiHuntFish.Show(Constant.GUI_MIN_LAYER, 5);
					EventNoelMgr.getInstance().NumPlay++;
				}
				else
				{
					GuiMgr.getInstance().guiGotoHunt.Show(Constant.GUI_MIN_LAYER, 5);
				}
			}
			else
			{
				if (_startTimeGame > _lastTimeFinish)//resume các bàn 1,2,3,boss
				{
					GuiMgr.getInstance().guiHuntFish.Show(Constant.GUI_MIN_LAYER, 5);
				}
				else
				{
					var timeRoundBonnus:Number = ConfigJSON.getInstance().getItemInfo("Noel_BoardConfig")["5"]["Time"];
					if (curTime - _lastTimeFinish > timeRoundBonnus)
					{
						GuiMgr.getInstance().guiGotoHunt.Show(Constant.GUI_MIN_LAYER, 5);
					}
					else//resume ban bonus
					{
						GuiMgr.getInstance().guiHuntFish.Show(Constant.GUI_MIN_LAYER, 5);
					}
				}
			}
		}
		private function showMsgLimitOut():void
		{
			var maxNumPlay:int = ConfigJSON.getInstance().getItemInfo("Noel_BoardConfig")["BoardGame"]["LimitDay"];
			var tip:String = Localization.getInstance().getString("EventNoel_TipLimitOut");
			tip = tip.replace("@Num@", maxNumPlay);
			GuiMgr.getInstance().GuiMessageBox.ShowOK(tip, 310, 200, 1);
		}
		
		public function encodeSendFire():void
		{
			_seed += 5;
			_seed = Ultility.RandomNumber(_seed, _seed + 5);
			_seed++;
		}
		
		public function initGiftServer(data1:Object):void 
		{
			
		}
		
		private function decodeSendFire():void
		{
			_seed--;
		}
	}

}
















