package GUI.TrainingTower.TrainingLogic 
{
	import Data.ConfigJSON;
	import GUI.GuiMgr;
	import GUI.TrainingTower.TrainingGUI.Tower;
	import GUI.TrainingTower.TrainingPackage.SendGetStatusTraining;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class TrainingMgr 
	{
		private const DELTATIME:int = 1;
		static private var _instance:TrainingMgr;
		private var _listTrainingSoldier:Array = [];	//mảng những ngư thủ đang train
		private var _listIdleSoldier:Array = [];		//mảng những ngư thủ đang free
		private var _listRoom:Array = [];			//mảng các phòng tập: sẽ dùng chung cho GUITrainingTower và Tower
		
		private var _fisrtTimeLogin:Boolean = true;
		public var boxTimeInt:Array = [];
		public var boxIntensityInt:Array=[];
		private var _speedUpNum:int;
		private var timeRemember:Number;
		private var _tower:Tower;
		public var hasUpdate:Boolean = false;
		public function TrainingMgr() 
		{
			_fisrtTimeLogin = true;
		}
		
		static public function getInstance():TrainingMgr 
		{
			if (_instance == null) {
				_instance = new TrainingMgr();
			}
			return _instance;
		}
		
		public function initListSoldier(data:Object):void
		{
			_listIdleSoldier.splice(0, _listIdleSoldier.length);
			_listTrainingSoldier.splice(0, _listTrainingSoldier.length);
			//lấy mảng soldier chung của game
			var myAllSoldier:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			var i:int;
			var j:int;
			var pushToIdle:Boolean;
			var fs:FishSoldier;
			var str:String;
			/*lấy về thời gian còn để luyện*/
			for (i = 0; i < myAllSoldier.length; i++) {
				fs = myAllSoldier[i] as FishSoldier;
				fs.timeToTraining = ConfigJSON.getInstance().getItemInfo("Param")["TrainingGround"]["TrainingTimeLimit"];//172800
				for (str in data["FishTimeList"]) {
					if (fs.Id == int(str)) {
						fs.timeToTraining -= data["FishTimeList"][str];
					}
				}
			}
			//var listRoom:Array = data["Room"] as Array;
			//xét những soldier nào thuộc vào traing thì add vào
			for (i = 0; i < myAllSoldier.length; i++)
			{
				fs = myAllSoldier[i] as FishSoldier;
				pushToIdle = true;
				for (str in data)
				{
					if (data[str] != null && !(data[str] is Array) && str.length < 2)
					{
						if (fs.Id == data[str]["SoldierId"])
						{
							_listTrainingSoldier.push(fs);
							pushToIdle = false;
							break;
						}
					}
				}
				if (pushToIdle)
				{
					_listIdleSoldier.push(fs);
				}
			}
		}
		
		public function getSoldierFromTrainingList(SoldierId:int):FishSoldier
		{
			for (var i:int = 0; i < _listTrainingSoldier.length; i++)
			{
				var fs:FishSoldier = _listTrainingSoldier[i] as FishSoldier;
				if (fs.Id == SoldierId) {
					//return fs.clone();
					return fs;
				}
			}
			return null;
		}
		
		public function getSoldierFromIdleList(SoldierId:int):FishSoldier
		{
			for (var i:int = 0; i < _listIdleSoldier.length; i++)
			{
				var fs:FishSoldier = _listIdleSoldier[i] as FishSoldier;
				if (fs.Id == SoldierId) {
					//return fs.clone();
					return fs;
				}
			}
			return null;
		}
		/**
		 * chuyển cá lính từ mảng vãi Luyện sang mảng Free
		 * @param	SoldierId
		 */
		public function transferTrainingToIdle(SoldierId:int):void
		{
			var fs:FishSoldier = getSoldierFromTrainingList(SoldierId);
			var index:int = _listTrainingSoldier.indexOf(fs);
			_listTrainingSoldier.splice(index, 1);
			_listIdleSoldier.unshift(fs);
		}
		
		/**
		 * chuyển cá lính từ mảng Free sang mảng vãi Luyện
		 * @param	SoldierId : Id của con cá lính cần chuyển
		 */
		public function transferIdleToTraining(SoldierId:int):void
		{
			var fs:FishSoldier = getSoldierFromIdleList(SoldierId);
			var index:int = _listIdleSoldier.indexOf(fs);
			_listIdleSoldier.splice(index, 1);
			_listTrainingSoldier.push(fs);
		}
		
		public function get ListIdleSoldier():Array 
		{
			return _listIdleSoldier;
		}
		
		public function get FisrtTimeLogin():Boolean 
		{
			return _fisrtTimeLogin;
		}
		
		public function set FisrtTimeLogin(value:Boolean):void 
		{
			_fisrtTimeLogin = value;
		}
		
		public function get SpeedUpNum():int 
		{
			return _speedUpNum;
		}
		
		public function set SpeedUpNum(value:int):void 
		{
			if (value < 0) {
				_speedUpNum = 0;
			}
			else {
				_speedUpNum = value;
			}
			
		}
		
		public function get ListRoom():Array 
		{
			return _listRoom;
		}
		
		public function set ListRoom(value:Array):void 
		{
			_listRoom = value;
		}
		
		public function countTime(time:int):Object 
		{
			var objTime:Object = { "hour":0, "minute":0, "second":0 };
			if (time <= 0) 
				return objTime;
			var h:int = time / 3600;
			var dH:int = time % 3600;
			var m:int = dH / 60;
			var dM:int = dH % 60;
			var s:int = dM;
			objTime = { "hour":h, "minute":m, "second":s };
			return objTime;
		}
		
		public function getTowerInfo():void 
		{
			var pk:SendGetStatusTraining = new SendGetStatusTraining();
			Exchange.GetInstance().Send(pk);
		}
		public function initData():void {
			timeRemember = GameLogic.getInstance().CurServerTime;
			_tower = new Tower(null, "");
			
			_tower.initData(GuiMgr.getInstance().guiFrontScreen.btnTrainingTower);
			initBoxTime();
			initListRoom();
		}
		public function initBoxTime():void
		{
			boxTimeInt.splice(0, boxTimeInt.length);
			var config:Object = ConfigJSON.getInstance().getItemInfo("CustomTraining");
			var oTime:Object = config["Time"];
			for (var i:String in oTime)
			{
				var value:int = int(i);
				boxTimeInt.push(value);
			}
			boxTimeInt.sort(Array.NUMERIC);
		}
		
		/*
		 * init danh sách phòng dựa vào config
		 **/
		public function initListRoom():void
		{
			if (_listRoom.length > 0) {
				return;
			}
			//_listRoom.splice(0, _listRoom.length);
			var configRoom:Object = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Room"];
			var i:int;
			/*tạo ra các room với giá trị mở khóa*/
			for (i = 1; i <= 4; i++)
			{
				var room:Room = new Room();
				room.RoomId = i;
				room.ZMoney = configRoom[i.toString()]["ZMoney"];
				room.StartTime = -1;
				_listRoom.push(room);
			}
			/*cho room có id = 1 luôn là Idle*/
			var room1:Room = _listRoom[0] as Room;
			room1.StartTime = 0;
		}
		
		/**
		 * cập nhật thông tin cho các phòng
		 * @param	data
		 */
		public function updateListRoom(data1:Object):void
		{
			_fisrtTimeLogin = false;
			if (data1["Object"] == null) {
				initListSoldier(null);
			}
			else {
				var data:Object = data1["Object"]["Room"];
				initListSoldier(data);
				for (var i:String in data)
				{
					var id:int = int(i);
					if (id <= 0) {
						_speedUpNum = int(data[i]);
					}
					else {
						var room:Room = _listRoom[id - 1] as Room;
						room.StartTime = 0;
						room.setInfo(data[i]);						//lấy TimeType
						if (data[i]["StartTime"])
						{
							room.StartTime = data[i]["StartTime"];		//dựa vào TimeType để tính state
						}
						//khởi tạo TimeType và IntensityType cho các Room có state = Idle
						if (room.State == Room.STATE_IDLE)
						{
							room.IntensityType = 1;
							room.TimeType = boxTimeInt[0];
							/*nếu cache thì code tại đây*/
						}
					}
					
				}
			}
			//trace("see listroom here");
		}
		
		public function getRoomById(roomId:int):Room {
			return _listRoom[roomId - 1] as Room;
		}
		
		public function updateTowerState():void 
		{
			var isShowGuiTraining:Boolean = false;
			if (GuiMgr.getInstance().GuiTrainingTower != null) {
				if (GuiMgr.getInstance().GuiTrainingTower.img != null) {
					if (GuiMgr.getInstance().GuiTrainingTower.img.visible == true) {
						isShowGuiTraining = true;
					}
				}
			}
			//hasUpdate = hasUpdate && !isShowGuiTraining;
			if (hasUpdate && !isShowGuiTraining)//có sự cập nhật Button Tower
			{
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				var tickcount:Number = curTime - timeRemember;
				if (tickcount > DELTATIME) //cập nhật sau 1 khoảng thời gian DELTATIME
				{
					_tower.State = Tower.STATE_TRAIN;
					for (var i:int = 0; i < _listRoom.length; i++) 
					{
						var room:Room = _listRoom[i] as Room;
						room.updateState(curTime);
						if (room.State == Room.STATE_IDLE) {
							_tower.State = Tower.STATE_IDLE;
							hasUpdate = false;
						}
						if (room.State == Room.STATE_FINISH) {
							_tower.State = Tower.STATE_FINISH;
							hasUpdate = false;
							break;
						}
					}
					timeRemember = curTime;
				}
			}
		}
		
		public function getNameSoldier(soldierId:int):String {
			var strName:String="";
			for (var i:int = 0; i < _listTrainingSoldier.length; i++) {
				var soldier:FishSoldier = _listTrainingSoldier[i] as FishSoldier;
				if (soldier.Id == soldierId) {
					if (soldier.nameSoldier == null) {
						strName = getNameDefault(soldier.Element);
					}
					else {
						if (soldier.nameSoldier.length <= 0) {
							strName = getNameDefault(soldier.Element);
						}
						else {
							strName = soldier.nameSoldier;
						}
					}
				}
			}
			
			if (strName.length >= 10) {
				strName = strName.substr(0, 9);
			}
			return strName;
		}
		
		public function getNameDefault(element:int):String
		{
			var sElement:String = "";
			switch(element) {
				case 1:
					sElement = "Kim";
				break;
				case 2:
					sElement = "Mộc";
				break;
				case 3:
					sElement = "Thổ";
				break;
				case 4:
					sElement = "Thủy";
				break;
				case 5:
					sElement = "Hỏa";
				break;
			}
			return "Tiểu " + sElement + " Ngư";
		}
		
		/**
		 * kiểm tra con cá hết hạn hay chưa
		 * @param	fs : con cá lính
		 * @param	curTime : thời gian hiện tại
		 * @return True nếu đã hết hạn tại thời điểm curTime
		 */ 
		public function checkExpireFish(fs:FishSoldier, curTime:Number):Boolean 
		{
			return false;
			var bornTime:Number = fs.OriginalStartTime;			//thời điểm sinh ra
			var liveTime:int = curTime - bornTime;		//thời gian sống cho đến giờ
			var exprieTime:int = 30 * 86400;			//thời gian tồn tại tạm thời hard code đợi config
			
			if (liveTime >= exprieTime) {
				return true;
			}
			else {
				return false;
			}
		}
		public function checkMultiEvent():Boolean
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var beginTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["TrainingGround"]["BeginTime"];
			var endTime:Number = ConfigJSON.getInstance().getItemInfo("Param")["TrainingGround"]["ExpireTime"];
			if (curTime<endTime&&curTime>beginTime)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
	}

}



















