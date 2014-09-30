package GUI.ChampionLeague.LogicLeague 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventMidAutumn.ItemEvent.EventItemInfo;
	import Event.Factory.FactoryLogic.EventSvc;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import GUI.ChampionLeague.GuiLeague.GUIGiftRank;
	import GUI.ChampionLeague.GuiLeague.GuiLeagueGuide;
	import GUI.ChampionLeague.GuiLeague.GUIRank;
	import GUI.ChampionLeague.LogicLeague.Player;
	import GUI.ChampionLeague.PackageLeague.SendAttackLeague;
	import GUI.ChampionLeague.PackageLeague.SendRefreshBoard;
	import GUI.GuiGetStatus.SendGetStatus;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	import Logic.User;
	/**
	 * quản lý chung cái liên đấu
	 * @author HiepNM2
	 */
	public class LeagueMgr 
	{
		static public const TIME_COOLDOWN:int = 30;
		static public const TIME_REFRESH:int = 30;
		static private var _instance:LeagueMgr = null;
		
		//private var _chosenSoldierId:int = -1;
		private var _listSoldier:Array = [];//sao cho con cá được chọn luôn nằm ở vị trí 0
		private var _listPlayer:Array = [];	//danh sách người chơi
		public var lastGiftRank:int;
		public var _listTop:Array = [];
		
		private var _league:League;
		private var _levelRequire:int = 7;
		private var _numCard:int;
		private var _lastTimeUpdate:Number;
		private var _lastTimeAttack:Number;
		private var _myPlayer:Player;
		private var _listGiftTop:Array = [];
		public var hasGiftTop:Boolean = false;			//biến xác định xem có quà từ server hay không
		
		public var receivedCard:Boolean;
		
		public var hasUpdateButton:Boolean = false;	//mua cá lính, bán cá lính, lên level thì set = true
		public var IsCoolDown:Boolean = false;
		public var IsWaitRefresh:Boolean = false;
		//thời gian chốt giải
		private var _hour:int = -1;
		private var _minute:int = -1;
		private var _second:int = -1;
		public var IsLoadGuideComp:Boolean;
		public var TimeForGetGift:Number = -1;
		public var LastGiftTime:Number = -1;
		
		//giới hạn số lần đánh
		private var _maxOccupy:int;
		private var _curOccupy:int;
		
		public var ListEventGift:Array;
		public function getConfigHour():int {
			return _hour;
		}
		public function getConfigMinute():int {
			return _minute;
		}
		public function getConfigSecond():int {
			return _second;
		}
		
		static public function getInstance():LeagueMgr {
			if (_instance == null) {
				_instance = new LeagueMgr();
			}
			return _instance;
		}
		
		public function LeagueMgr() 
		{
			initTimeConfig();
			initListTop();
		}
		
		/** getter and setter **/
		public function get ListSoldier():Array 
		{
			return _listSoldier;
		}
		
		public function get MyPlayer():Player
		{
			return _myPlayer;
		}
		
		public function set MyPlayer(value:Player):void 
		{
			_myPlayer = value;
		}
		
		public function get ListPlayer():Array 
		{
			return _listPlayer;
		}
		
		public function get NumCard():int 
		{
			return _numCard;
		}
		
		public function set NumCard(value:int):void 
		{
			_numCard = value;
			
		}
		
		public function get LastTimeUpdate():Number 
		{
			return _lastTimeUpdate;
		}
		
		public function set LastRefreshBoard(value:Number):void 
		{
			_lastTimeUpdate = value;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var passTime:int = curTime - value;
			var timeDown:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["CoolDown"]["RefreshBoard"];
			IsWaitRefresh = passTime < timeDown ? true : false;
			if (LeagueInterface.getInstance().guiRank.IsVisible)
			{
				if (LeagueInterface.getInstance().guiRank.inRefresh)
				{
					LeagueInterface.getInstance().guiRank.RefreshEnable(!IsWaitRefresh);
				}
			}
		}
		
		public function get ListTop():Array 
		{
			return _listTop;
		}
		
		public function get LastTimeAttack():Number 
		{
			return _lastTimeAttack;
		}
		
		public function set LastOccupy(value:Number):void 
		{
			_lastTimeAttack = value;
			//set gia tri cho IsCoolDown
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var passTime:int = curTime - value;
			var timeCoolDown:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["CoolDown"]["Occupy"];
			var timeDown:int = timeCoolDown;
			
			if (passTime >= timeDown)
			{
				IsCoolDown = false;
			}
			else
			{
				IsCoolDown = true;
			}
		}
		
		public function get ListGiftTop():Array 
		{
			return _listGiftTop;
		}
		
		public function get maxOccupy():int 
		{
			return _maxOccupy;
		}
		
		public function set maxOccupy(value:int):void 
		{
			_maxOccupy = value;
		}
		
		public function get curOccupy():int 
		{
			return _curOccupy;
		}
		
		public function set curOccupy(value:int):void 
		{
			_curOccupy = value;
		}
		/******************************* function *****************************/
		/**
		 * đi đến liên đấu
		 */
		public function gotoLeague():void
		{
			/*khởi tạo trước cho _myPlayer và _numCard*/
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var sTime:String = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["TimeEndInDay"];
			var isInDay:Boolean = LeagueController.isInDay(curTime, sTime);
			TimeForGetGift = LeagueController.convertToUnixTime(curTime, sTime, !isInDay);//thời điểm nhận giải
			var user:User = GameLogic.getInstance().user;
			_myPlayer = new Player();
			_myPlayer.Name = user.GetMyInfo().Name;
			_myPlayer.Avatar = user.GetMyInfo().AvatarPic;
			_myPlayer.Id = user.GetMyInfo().Id;
			_numCard = user.GetStoreItemCount("OccupyToken", 1);
			
			_maxOccupy = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["MaxOccupy"];
			var pk1:SendGetStatus = new SendGetStatus("OccupyService.getOccupying", 
														Constant.CMD_GET_STATUS_LEAGUE);
			Exchange.GetInstance().Send(pk1);
			var pk2:SendGetStatus = new SendGetStatus("OccupyService.refreshOccupyingBoard", 
														Constant.CMD_REFRESH_RANK_BOARD);
			Exchange.GetInstance().Send(pk2);
			LeagueController.getInstance().changeState(LeagueController.IN_LEAGUE);
			LeagueInterface.getInstance().startGui();
		}
		/*** Các hàm khởi tạo dữ liệu ***/
		/**
		 * xử lý dữ liệu từ gói SendGetStatus
		 * @param	data
		 */
		public function processGetStatusPacket(data:Object):void
		{
			initDataFromStatusPacket(data);
			LeagueInterface.getInstance().IsDataStatusReady = true;
			LeagueInterface.getInstance().initGuiAfterData();
		}
		/**
		 * khởi tạo numcard, lastTimeUpdate, mảng cá con cá được chọn, và listtop 
		 * @param	data
		 */
		public function initDataFromStatusPacket(data:Object):void
		{
			var obj:Object;
			if (data["Occupying"] is Array)//trường hợp không trả về gì cả vì không có cá
			{
				_myPlayer.SoldierId = -1;
				receivedCard = false;
			}
			else 
			{
				receivedCard = data["Occupying"]["GotGiftToken"];		//xét việc đã nhận thẻ bài chưa
				if (!receivedCard)
				{
					LeagueInterface.getInstance().initDataForGuiDailyGift(data["Occupying"]["TokenExpired"], data["Occupying"]["TokenCurr"]);
				}
				LastRefreshBoard = data["Occupying"]["LastRefreshBoard"];
				LastOccupy = data["Occupying"]["LastOccupy"];
				if (data["Occupying"]["CurrSoldier"])//khởi tạo về con cá
				{
					var chosenSoldierId:int = data["Occupying"]["CurrSoldier"]["Id"];
					initListFish(chosenSoldierId);
				}
				if (data["Occupying"]["LastGift"]!=null) //khởi tạo về quà
				{
					initListGift(data["Occupying"]["LastGift"]);
					LastGiftTime = data["Occupying"]["LastGiftTime"];
					var curRank:int = int(data["Occupying"]["LastGiftRank"]);
					lastGiftRank = curRank;
					hasGiftTop = (curRank >= 1) && (curRank <= 1000);
				}
				_curOccupy = _maxOccupy - data["Occupying"]["RemainOccupyCount"];
			}
		}
		/**
		 * khởi tạo danh sách cá của người chơi, cá đứng đầu có id = chosenSoldierId
		 * @param	chosenSoldierId : id cá được chọn
		 */
		public function initListFish(chosenSoldierId:int):void 
		{
			_listSoldier.splice(0, _listSoldier.length);
			var arrFish:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			if (arrFish == null || arrFish.length == 0) 
			{
				_myPlayer.SoldierId = -1;
				_listSoldier = [];
			}
			else {
				_myPlayer.SoldierId = chosenSoldierId;
				var i:int;
				var fs:FishSoldier;
				for (i = 0; i < arrFish.length; i++) {
					fs = arrFish[i] as FishSoldier;
					_listSoldier.push(fs);
				}
				var index:int = -1;
				for (i = 0; i < _listSoldier.length; i++) {
					fs = _listSoldier[i] as FishSoldier;
					if (fs.Id == chosenSoldierId) {
						index = i;
						break;
					}
				}
				//đảm bảo chooseSoldier luôn nằm đầu danh sách
				if (index < 0) return;//không tìm thấy con cá trong danh sách cá
				fs = _listSoldier[index] as FishSoldier;
				_listSoldier.splice(index, 1);
				_listSoldier.unshift(fs);
			}
		}
		/**
		 * thực hiện lấy quà và nhét vào mảng _listGiftTop
		 */
		public function initListGift(allGift:Object):void 
		{
			var lstNormal:Array = allGift["Normal"];
			var lstSpecial:Array = allGift["Equipment"];
			if (lstNormal == null || lstSpecial == null) {
				return;
			}
			var oGift:Object;
			var _gift:AbstractGift;
			var i:int;
			_listGiftTop.splice(0, _listGiftTop.length);
			
			for (i = 0; i < lstNormal.length; i++)
			{
				oGift = lstNormal[i];
				_gift = new GiftNormal();
				_gift.setInfo(oGift);
				_listGiftTop.push(_gift);
			}
			for (i = 0; i < lstSpecial.length; i++)
			{
				oGift = lstSpecial[i];
				_gift = new GiftSpecial();
				_gift.setInfo(oGift);
				_listGiftTop.push(_gift);
			}
		}
		/**
		 * xử lý dữ liệu từ gói refresh rank board
		 * @param	data
		 */
		public function processRefreshBoardPacket(data:Object):void 
		{
			initDataFromRefreshBoard(data);
			LeagueInterface.getInstance().IsDataRefreshReady = true;
			//trong trường hợp mới bắt đầu game
			LeagueInterface.getInstance().initGuiAfterData();
			//trong trường hợp đánh nhau xong
		}
		/**
		 * khởi tạo danh sách player
		 * @param	data : dữ liệu gồm danh sách player
		 */
		private function initDataFromRefreshBoard(data:Object):void 
		{
			if (data["OccupyingBoard"])
			{
				initPlayer(data["OccupyingBoard"]);
			}
			_myPlayer.Rank = data["CurrRank"];
			GameLogic.getInstance().user.Rank = _myPlayer.Rank;
		}
		/**
		 * khởi tạo dữ liệu cho danh sách player
		 * @param	data : dữ liệu về bảng người chơi
		 */
		private function initPlayer(data:Object):void 
		{
			_listPlayer.splice(0, _listPlayer.length);
			var player:Player;
			for (var rank:String in data)
			{
				player = new Player();
				player.setInfo(data[rank]);
				_listPlayer.push(player);
			}
			_listPlayer.sortOn(["Rank"], Array.NUMERIC);
		}
		
		
		
		public function initListTop():void {
			//var topGift:Object = FakeConfigMgr.getInstance().GiftTop;
			var topGift:Object = ConfigJSON.getInstance().getItemInfo("Occupy_Gifts")["Top"];
			_listTop.splice(0, _listTop.length);
			for (var str:String in topGift) {
				var top:int = int(str);
				_listTop.push(top);
			}
			_listTop.sort(Array.NUMERIC);
			_listTop.push(int.MAX_VALUE);
		}
		/**** Các hàm cập nhật liên tục ****/
		 
		/**
		 * cập nhật cho cái nút league
		 */
		public function updateLeagueState():void
		{
			if (hasUpdateButton)
			{
				var user:User = GameLogic.getInstance().user;
				var level:int = user.GetLevel();
				_league.State = League.STATE_OK;
				if (level < _levelRequire) {
					_league.State = League.STATE_NO_LEVEL;
				}
				else if (user.GetMyInfo().MySoldierArr.length <= 0) {
					_league.State = League.STATE_NO_SOLDIER;
				}
				hasUpdateButton = false;
			}
		}
		
		/*** Các hàm tiện ích ***/
		
		/**
		 * lấy người chơi dựa vào id
		 * @param	uId : id của người chơi
		 * @return người chơi với id truyền vào
		 */
		public function getPlayerById(uId:int):Player {
			for (var i:int = 0; i < _listPlayer.length; i++) {
				var player:Player = _listPlayer[i] as Player;
				if (player.Id == uId) {
					return player;
				}
			}
			return null;
		}
		
		public function getPlayerByRank(rank:int):Player {
			for (var i:int = 0; i < _listPlayer.length; i++) {
				var player:Player = _listPlayer[i] as Player;
				if (player.Rank == rank) {
					return player;
				}
			}
			return null;
		}
		/**
		 * lấy cá lính dựa vào id
		 * @param	soldierId : id của con cá
		 * @return con cá với id truyền vào
		 */
		public function getSoldierById(soldierId:int):FishSoldier {
			for (var i:int = 0; i < _listSoldier.length; i++) {
				var soldier:FishSoldier = _listSoldier[i] as FishSoldier;
				if (soldier.Id == soldierId) {
					return soldier;
				}
			}
			return null;
		}
		public function getChooseSoldier():FishSoldier {
			return (_listSoldier[0] as FishSoldier);
		}
		
		public function getTop(rank:int):int {
			var topHere:int;
			for (var i:int = _listTop.length - 1; i >= 0 ; i--) {
				topHere = _listTop[i];
				if (rank > topHere) {
					break;
				}
			}
			return _listTop[i + 1];
		}
		
		public function getListTopGift(rank:int):Array {
			var topHere:int = getTop(rank);
			var index:int = _listTop.indexOf(topHere);
			if (index < 4) {
				return _listTop.slice(0, 4);
			}
			else {
				if (index == 8)
				{
					return _listTop.slice(4, 8);
				}
				else {
					return _listTop.slice(index - 3, index + 1);
				}
				
			}
		}
		/**
		 * trở về nhà
		 */
		public function goBackHome():void
		{
			LeagueController.getInstance().changeState(LeagueController.IN_HOME);	//rollback state
			LeagueInterface.getInstance().backHomeGui();		//rollback gui
		}
		
		/**
		 * bắt đầu trận đánh
		 * @param	me : tôi
		 * @param	victim : đối thủ
		 */
		public function startFight(victimRank:int):void 
		{
			//gửi dữ liệu đánh victim lên server
			NumCard--;
			GameLogic.getInstance().user.UpdateStockThing("OccupyToken", 1, -1);
			var pk:SendAttackLeague = new SendAttackLeague(victimRank);
			Exchange.GetInstance().Send(pk);
			//thực hiện load cảnh và tạo thanh máu
			LeagueInterface.getInstance().startWarScene();
		}
		
		/**
		 * khởi tạo trận đấu (cá đối thủ, ngữ cảnh, isWin...)
		 * @param	Data1 : dữ liệu từ server trả về
		 */
		public function initFight(oldData:SendAttackLeague, Data1:Object):void
		{
			/*b1: khởi tạo dữ liệu trận đánh*/
			LastOccupy = GameLogic.getInstance().CurServerTime;
			GameLogic.getInstance().FishWarScene = Data1.Scene;
			GameLogic.getInstance().FishWarPenalty = null;
			GameLogic.getInstance().IsWin = Data1["IsWin"];
			/*khởi tạo về gui để bắt đầu chiến*/
			if (Data1["SoldierFought"])
			{
				var hisSoldierInfo:Object ;
				var hisEquipmentInfo:Object;
				var hisIndexEquip:Object;
				var hisMeri:Object;
				hisSoldierInfo = Data1["SoldierFought"]["Soldier"];
				hisSoldierInfo["reputationLevel"] = Data1["UserFought"]["ReputationLevel"];
				hisIndexEquip = Data1["SoldierFought"]["Index"];
				hisMeri = Data1["SoldierFought"]["Meridian"];
				hisEquipmentInfo = Data1["SoldierFought"]["Equipment"];
			}
			if (Data1["Gift"])//khởi tạo quà nhận được sau trận đánh
			{
				var listGift:Array = new Array();
				ListEventGift = new Array();
				var abstractGift:AbstractGift;
				for (var i:String in Data1["Gift"])
				{
					//if (Data1["Gift"][i]["ItemType"] == "Arrow")	//StoneMaze
					//if (Data1["Gift"][i]["ItemType"] == "Candy")	//FishHunter
					//if (Data1["Gift"][i]["ItemType"] == "Island_Item")	//TreasureIsland
					//if (Data1["Gift"][i]["ItemType"] == "Ticket")	//LuckyMachine
					if (Data1["Gift"][i]["ItemType"] == "HalItem")	//Thạch bảo đồ
					{
						abstractGift = new EventItemInfo();
						abstractGift.setInfo(Data1["Gift"][i]);
						ListEventGift.push(abstractGift);
					}
					else
					{
						abstractGift = new GiftNormal();
						abstractGift.setInfo(Data1["Gift"][i]);
						listGift.push(abstractGift);
					}
				}
				LeagueInterface.getInstance().guiGiftFight.isWin = Data1["IsWin"];
				LeagueInterface.getInstance().guiGiftFight.initData(listGift);
				LeagueInterface.getInstance().getGiftForMySoldier(listGift);
			}
			LeagueInterface.getInstance().processFightData(hisIndexEquip, hisSoldierInfo, hisEquipmentInfo, hisMeri);
		}
		/**
		 * thay đổi cá chiến đấu
		 * @param	soldierId : id của cá cần thay
		 */
		public function changeSoldier(soldierId:int):void 
		{
			_myPlayer.SoldierId = soldierId;
			var fs:FishSoldier;
			var index:int = -1;
			for (var i:int = 0; i < _listSoldier.length; i++) {
				fs = _listSoldier[i] as FishSoldier;
				if (fs.Id == soldierId) {
					index = i;
					break;
				}
			}
			//đảm bảo chooseSoldier luôn nằm đầu danh sách
			fs = _listSoldier[index] as FishSoldier;
			_listSoldier.splice(index, 1);
			_listSoldier.unshift(fs);
			
			LeagueInterface.getInstance().removeMySolider();
			LeagueInterface.getInstance().showSoldier();
		}
		
		/**
		 * xong 1 trận đánh
		 */
		public function completeFight():void 
		{
			//gửi gói tin cập nhật bảng liên đấu => suy ra được rank của mình, và cái bảng đối thủ
			var pk:SendGetStatus = new SendGetStatus("OccupyService.refreshOccupyingBoard", 
														Constant.CMD_REFRESH_RANK_BOARD);
			Exchange.GetInstance().Send(pk);
			
			//xử lý việc hiển thị nhận quà
			dropEventGift();
			LeagueInterface.getInstance().showCompleteFight();
		}
		
		/**
		 * cập nhật cho con cá các thông tin sau trận đánh
		 * @param	soldier : con cá cần được cập nhật thông tin 
		 * @param	soldierInfo : thông tin mới của cá
		 * @param	equipmentInfo : thông tin mới của đồ
		 */
		private function updateMySoldier(soldier:FishSoldier, soldierInfo:Object, equipmentInfo:Array):void 
		{
			
		}
		
		private function initTimeConfig():void
		{
			var sTimeConfig:String = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["TimeEndInDay"];
			var data:Array = sTimeConfig.split(":");
			_hour = int(data[0]);
			_minute = int(data[1]);
			_second = int(data[2]);
		}
		
		public function updateTime():void
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var passTime:int;
			var remainTime:int;
			
			if (IsCoolDown)//cập nhật cho cooldown giữa 2 lần đánh liên tiếp
			{
				passTime = int(curTime) - _lastTimeAttack;
				var timeCoolDown:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["CoolDown"]["Occupy"];
				remainTime = timeCoolDown - passTime;
				
				if (remainTime > 0)
				{
					if (LeagueInterface.getInstance().guiRank.IsVisible) 
					{
						LeagueInterface.getInstance().guiRank.updateForCoolDown(remainTime);
					}
				}
				else 
				{
					IsCoolDown = false;
					if (LeagueInterface.getInstance().guiRank.IsVisible)
					{
						LeagueInterface.getInstance().guiRank.changeToAttackMode();
					}
				}
			}
			
			if (IsWaitRefresh)//cập nhật cho việc hiển thị nút refresh
			{
				passTime = int(curTime) - _lastTimeUpdate;
				var timeDown:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["CoolDown"]["RefreshBoard"];
				remainTime = timeDown - passTime;
				
				if (remainTime > 0)
				{
					if (LeagueInterface.getInstance().guiRank.IsVisible) 
					{
						LeagueInterface.getInstance().guiRank.updateForWaitRefresh(remainTime);
					}
				}
				else 
				{
					IsWaitRefresh = false;
					if (LeagueInterface.getInstance().guiRank.IsVisible)
					{
						LeagueInterface.getInstance().guiRank.RefreshEnable();
						LeagueInterface.getInstance().guiRank.resetTimeUpdate();
					}
				}
			}
			
			if (LeagueInterface.getInstance().tableRankGift.IsVisible)
			{
				var timeGui:Number = LeagueInterface.getInstance().tableRankGift.timeGui;
				if (curTime - timeGui > 1.001)
				{
					LeagueInterface.getInstance().tableRankGift.updateTable2(curTime);
				}
			}
			
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
			{
				if (LeagueInterface.getInstance().guiRank.IsVisible &&
					LeagueInterface.getInstance().tableRankGift.IsVisible)
				{
					if (!isLockForUpdate(curTime))//không trong thời gian lock
					{
						var timeAutoRefresh:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["CoolDown"]["AutoRefresh"];
						var timeRefresh:Number = LeagueController.getInstance().timeRefresh;
						if (curTime - timeRefresh > timeAutoRefresh + 0.001)
						{
							if (!LeagueInterface.getInstance().guiRank.inRefresh && !LeagueInterface.getInstance().guiRank.inAutoRefresh)//nếu ko đang trong quá trình gửi gói tin refresh từ guiRank
							{
								LeagueInterface.getInstance().guiRank.inAutoRefresh = true;
								LeagueInterface.getInstance().guiRank.refreshPlayer();
							}
						}
					}
				}
			}
			
		}
		
		/**
		 * Nhận quà từ server sau 10h
		 * @param	data1 : quà nhận về
		 */
		public function processGetGift(data1:Object):void 
		{
			if (data1["Error"] == 0)
			{
				LastGiftTime = data1["LastGiftTime"];
				initListGift(data1["LastGift"]);
				var curRank:int = int(data1["LastGiftRank"]);
				lastGiftRank = curRank;
				hasGiftTop = (curRank >= 1) && (curRank <= 1000);
				
				if (hasGiftTop)
				{
					var guiGiftRank:GUIGiftRank = new GUIGiftRank(null, "");
					guiGiftRank.initData(_listGiftTop);
					guiGiftRank.Show(Constant.GUI_MIN_LAYER, 5);
					guiGiftRank.drawTopInfo();
				}
				else {
					if (curRank == 0) {
						trace("đã nhận quà");
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã nhận quà");
					}
					else {
						trace("thứ hạng > 1000");
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Thứ hạng của bạn đã bị đẩy ra khỏi top 1000");
					}
				}
			}
			else
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Lỗi khi nhận quà \n(quà đã được nhận hoặc thứ hạng đã bị đẩy ra khỏi 1000)");
				LeagueController.getInstance().isWaitReponseGift = false;
			}
			
		}
		/**
		 * xét xem có đang trong khoảng thời gian khóa Liên Đấu
		 * @param	curTime : thời điểm hiện tại
		 * @return
		 */
		public function isLockForUpdate(curTime:Number):Boolean
		{
			var timeForStop:Number = TimeForGetGift - 301;//Thời điểm chốt giải
			var upperTime:Number = TimeForGetGift + 4;
			if (curTime >= timeForStop && curTime <= upperTime)
			{
				return true;
				//return false;
			}
			else
			{
				return false;
				//return true;
			}
		}
		/**
		 * thực hiện load file ExpeditionTask.xml 
		 * 		chi thuc hien 1 lan duy nhat khi vao game va mo gui vien trinh
		 * @param	_xmlVersion : version của file
		 */
		public function loadGuideXML(_xmlVersion:String):void
		{
			IsLoadGuideComp = false;
			var iniURL:String;			
			var iniURLLoader:URLLoader = new URLLoader();
			if (Constant.OFF_SERVER)
			{
				iniURL = "../src/GUI/ChampionLeague/LogicLeague/GuideChampionLeague.xml";
			}
			else
			{
				iniURL = Main.staticURL + "/xml/GuideChampionLeague" + _xmlVersion + ".xml";
			}
			iniURLLoader.addEventListener(Event.COMPLETE, loadGuideComp);
			iniURLLoader.load(new URLRequest(iniURL));
		}
		
		private function loadGuideComp(e:Event):void 
		{
			GuideXML.getInstance().Data = XML(e.target.data);
			IsLoadGuideComp = true;
			var guiGuide:GuiLeagueGuide = LeagueInterface.getInstance().guiLeagueGuide;
			guiGuide.IsLoadXMLComp = true;
			if (guiGuide.IsVisible)
			{
				if (guiGuide.IsFinishRoomOut)
				{
					guiGuide.initGUI();
				}
			}
			
		}
		
		public function IsLimitedFight():Boolean 
		{
			return _curOccupy >= _maxOccupy;
		}
		
		
		/**
		 * rơi quà trong event
		 */
		private function dropEventGift():void 
		{
			var x:int = Constant.STAGE_WIDTH / 2;
			var y:int = Constant.STAGE_HEIGHT / 2;
			var itemInfo:EventItemInfo;
			for (var i:int; i < ListEventGift.length; i++)
			{
				itemInfo = ListEventGift[i] as EventItemInfo;
				//GuiMgr.getInstance().guiFrontEvent.updateNumItemEvent(itemInfo.ItemType, itemInfo.Num, itemInfo.ItemId);
				//HalloweenMgr.getInstance().updateRockStore(itemInfo.ItemId, itemInfo.Num);
				//EventSvc.getInstance().updateItem(itemInfo.ItemType, itemInfo.ItemId, itemInfo.Num);
				EffectMgr.getInstance().fallFlower(itemInfo.Num, itemInfo.ItemId, new Point(x, y));
			}
		}
	}
}













































