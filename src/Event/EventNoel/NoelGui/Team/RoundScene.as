package Event.EventNoel.NoelGui.Team 
{
	import Data.ConfigJSON;
	import Event.EventNoel.NoelGui.ItemGui.Bullet.BulletScenario;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import Event.EventNoel.NoelLogic.Round.RoundNoel;
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import Event.Factory.FactoryGui.ItemGui.FishAbstract;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	/**
	 * quản lý việc ra vào của các team:
			* chọn random các team đi ra  (tại 1 thời điểm có từ 1 - 6 team ra vào)
			* việc đi ra dựa vào các yếu tố (lượng cá trên hồ, thời gian...)
			* xử lý việc hủy content khi team đi hết màn hình
	 * 
	 * @author HiepNM2
	 */
	public class RoundScene 
	{
		private static var _instance:RoundScene = null;
		private var _parent:Sprite;							//cha của toàn bộ đối tượng vẽ vào Round
		private var _guiBossTeam:GuiBossTeam;
		private var _round:RoundNoel;						//dữ liệu toàn bộ round
		private var _activeTeams:Object;					//những team được vẽ ra màn hình
		private var _timeGenTime:Number;					//thời điểm generate ra team
		private var _inUseIce:Boolean = false;
		private var _timeUseIce:Number;
		
		//private var _numFishDieInIce:int;		//số con cá chết trong lúc đóng băng
		public function RoundScene() 
		{
			_parent = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
			_timeUseIce = -1;
		}
		public static function getInstance():RoundScene 
		{
			if (_instance == null) 
			{
				_instance = new RoundScene();
			}
			return _instance;
		}
		/**
		 * khởi tạo dữ liệu cho cả vòng này
		 * @param	data
		 */
		public function initRoundData(data:Object):void 
		{
			//EventNoelMgr.getInstance().initTempStore(data["RetBonus"]);
			EventNoelMgr.getInstance().Seed = data["MaxKey"];
			_round = RoundNoel.createRound(data["BoardId"]);// new RoundNoel();
			_round.IdRound = data["BoardId"];
			_round.setNumFishDie(data["NumFishDie"]);
			_round.StartTime = EventNoelMgr.getInstance().StartTimeGame;// data["BoardGame"]["StartTime"];
			_round.RequestKey = data["RequestKey"];
			_round.initRoundData(data["BoardGame"]["FishList"]);
			
			_activeTeams = new Object();
		}
		/**
		 * tạo ra 1 lứa cá (nhiều nhất là 6 team && MaxNumActice con cá)
		 * đặt team vào điểm khởi đầu
		 */
		public function generateScene():void
		{
			var info:TeamAbstractInfo;
			var team:TeamAbstract;
			var numTeam:int = 0;
			_timeGenTime = GameLogic.getInstance().CurServerTime;
			while (_round.NumFishActive < _round.MaxNumActive)
			{
				info = _round.generateTeamInfo(numTeam);						//generate thông tin của team
				if (info == null) break;
				team = TeamAbstract.createTeam(info);							//tạo ra team
				team.StartPoint = _round.getStartPoint();						//lấy điểm xuất phát
				team.draw(_parent);												//vẽ team
				swapTeamToLowerLayer();											//đẩy team xuống layer dưới
				_activeTeams[team.IdTeam] = team;								//push vào mảng team trong hồ
				if (++numTeam == _round.getMaxTeamGenerate()) break;//giới hạn số team tạo ra
			}
			_round.generateListStartPoint();			//tạo lại mảng StartPoint cho từng team trong round
		}
		
		private function swapTeamToLowerLayer():void 
		{
			if (GuiMgr.getInstance().guiUserEventInfo.img)
			{
				_parent.setChildIndex(GuiMgr.getInstance().guiUserEventInfo.img, _parent.numChildren - 1);
				_parent.setChildIndex(GuiMgr.getInstance().guiBtnControl.img, _parent.numChildren - 1);
				var ptrGui:BaseGUI;
				var parentGui:Sprite;
				if (GuiMgr.getInstance().guiExchangeNoelCollection.IsVisible)
				{
					ptrGui = GuiMgr.getInstance().guiExchangeNoelCollection;
					parentGui =  ptrGui.img.parent as Sprite;
					parentGui.removeChild(ptrGui.img);
					_parent.addChild(ptrGui.img);
					ptrGui.ShowDisableScreen(0.5);
				}
				if (GuiMgr.getInstance().guiStoreNoel.IsVisible)
				{
					ptrGui = GuiMgr.getInstance().guiStoreNoel;
					parentGui =  ptrGui.img.parent as Sprite;
					parentGui.removeChild(ptrGui.img);
					_parent.addChild(ptrGui.img);
					ptrGui.ShowDisableScreen(0.5);
				}
				if (GuiMgr.getInstance().guiExchangeNoelItem.IsVisible)
				{
					ptrGui = GuiMgr.getInstance().guiExchangeNoelItem;
					parentGui =  ptrGui.img.parent as Sprite;
					parentGui.removeChild(ptrGui.img);
					_parent.addChild(ptrGui.img);
					ptrGui.ShowDisableScreen(0.5);
				}
				if (GuiMgr.getInstance().guiGiftEventNoel.IsVisible)
				{
					ptrGui = GuiMgr.getInstance().guiGiftEventNoel;
					parentGui =  ptrGui.img.parent as Sprite;
					parentGui.removeChild(ptrGui.img);
					_parent.addChild(ptrGui.img);
					ptrGui.ShowDisableScreen(0.5);
				}
				if (GuiMgr.getInstance().GuiMessageBox.IsVisible)
				{
					ptrGui = GuiMgr.getInstance().GuiMessageBox;
					parentGui =  ptrGui.img.parent as Sprite;
					parentGui.removeChild(ptrGui.img);
					_parent.addChild(ptrGui.img);
					ptrGui.ShowDisableScreen(0.5);
				}
				if (GuiMgr.getInstance().GuiNapG.IsVisible)
				{
					ptrGui = GuiMgr.getInstance().GuiNapG;
					parentGui =  ptrGui.img.parent as Sprite;
					parentGui.removeChild(ptrGui.img);
					_parent.addChild(ptrGui.img);
					ptrGui.ShowDisableScreen(0.5);
				}
				if (GuiMgr.getInstance().guiAddZMoney.IsVisible)
				{
					ptrGui = GuiMgr.getInstance().guiAddZMoney;
					parentGui =  ptrGui.img.parent as Sprite;
					parentGui.removeChild(ptrGui.img);
					_parent.addChild(ptrGui.img);
					ptrGui.ShowDisableScreen(0.5);
				}
				if (GuiMgr.getInstance().guiBuyDiamond.IsVisible)
				{
					ptrGui = GuiMgr.getInstance().guiBuyDiamond;
					parentGui =  ptrGui.img.parent as Sprite;
					parentGui.removeChild(ptrGui.img);
					_parent.addChild(ptrGui.img);
					ptrGui.ShowDisableScreen(0.5);
				}
				if (GuiMgr.getInstance().guiBuyMultiRock.IsVisible)
				{
					ptrGui = GuiMgr.getInstance().guiBuyMultiRock;
					parentGui =  ptrGui.img.parent as Sprite;
					parentGui.removeChild(ptrGui.img);
					_parent.addChild(ptrGui.img);
					ptrGui.ShowDisableScreen(0.5);
				}
				if (GuiMgr.getInstance().guifinishRound.IsVisible)
				{
					ptrGui = GuiMgr.getInstance().guifinishRound;
					parentGui =  ptrGui.img.parent as Sprite;
					parentGui.removeChild(ptrGui.img);
					_parent.addChild(ptrGui.img);
					ptrGui.ShowDisableScreen(0.5);
				}
				if (GuiMgr.getInstance().guiFinishEventAuto.IsVisible)
				{
					ptrGui = GuiMgr.getInstance().guiFinishEventAuto;
					parentGui =  ptrGui.img.parent as Sprite;
					parentGui.removeChild(ptrGui.img);
					_parent.addChild(ptrGui.img);
					ptrGui.ShowDisableScreen(0.5);
				}
				
			}
		}
		public function getRemainTimeIce(curTime:Number):Number
		{
			var timeIce:Number = ConfigJSON.getInstance().getItemInfo("Noel_Bullet")["RainIce"]["1"]["Time"];
			var passTime:Number = curTime - _timeUseIce;
			return timeIce - passTime;
		}
		/**
		 * hàm luôn chạy theo frame
		 * @param	curTime
		 */
		public function update(curTime:Number):void
		{
			var team:TeamAbstract;
			var isAppearAll:Boolean = true;//biến xét tất cả các team đã xuất hiện hết ra màn hình chưa
			for (var i:String in _activeTeams)
			{
				team = _activeTeams[i];
				team.update();//có roundUp
				if (team.IsAppearAll)
				{
					checkOutOfScreen(team);
				}
				isAppearAll &&= team.IsAppearAll;
			}
			if (curTime - _timeGenTime > _round.getDeltaTimeGen() && isAppearAll)
			{
				generateScene();//sinh tiếp 1 lứa mới
			}
			
			/**
			 * thực hiện tách 1 vài con của 1 đàn(nhiều cá) bất kỳ 
			 * để tạo thành 1 đàn mới (số lượng = 1)
			 */
		}
		
		public function unFreezeAll():void 
		{
			var team:TeamAbstract;
			for (var idTeam:String in _activeTeams)
			{
				team = _activeTeams[idTeam];
				var activeFishs:Array = team.ActiveFish;
				for (var i:int = 0; i < activeFishs.length; i++)
				{
					var fish:FishAbstract = activeFishs[i];
					fish.unFreeze();
				}
			}
		}
		public function useIce():void
		{
			if (_inUseIce)
			{
				var timeIce:Number = ConfigJSON.getInstance().getItemInfo("Noel_Bullet")["RainIce"]["1"]["Time"];
				_timeUseIce += timeIce;
			}
			else
			{
				_inUseIce = true;
				_timeUseIce = GameLogic.getInstance().CurServerTime;
			}
		}
		
		public function resetIce():void
		{
			_inUseIce = false;
			_timeUseIce = -1;
		}
		
		private function checkOutOfScreen(team:TeamAbstract):Boolean 
		{
			if (!team.InScreen)
			{
				removeTeam(team.IdTeam);
				return true;
			}
			return false;
		}
		
		public function removeTeam(idTeam:int):void
		{
			var team:TeamAbstract = _activeTeams[idTeam];
			team.destructor();
			delete(_activeTeams[idTeam]);
		}
		
		/**
		 * xóa sổ tất cả các team trên màn hình, dữ liệu vẫn còn lưu
		 */
		public function removeAllTeam():void
		{
			var team:TeamAbstract;
			for (var idTeam:String in _activeTeams)
			{
				team = _activeTeams[idTeam];
				team.destructor();
				delete(_activeTeams[idTeam]);
			}
		}
		public function forceRemoveTeam(idTeam:int):void
		{
			removeTeam(idTeam);//xóa content
			_round.removeTeam(idTeam);//xóa data
		}
		public function forceRemoveAllTeam():void
		{
			if (_round != null)
			{
				removeAllTeam();		//xóa content của những team hiện trên màn hình
				_round.removeAllTeam();
				_guiBossTeam.Destructor();
			}
		}
		
		public function Destructor():void
		{
			if (_round != null)
			{
				removeAllTeam();
				_round.Destructor();
				_guiBossTeam.Destructor();
			}
		}
		
		public function contructor():void 
		{
			if (_guiBossTeam == null || _guiBossTeam.img == null)
			{
				_guiBossTeam = new GuiBossTeam(_parent, "EventNoel_GuiBossTeamTheme", Constant.STAGE_WIDTH / 2, Constant.STAGE_HEIGHT / 2);
			}
		}
		
		public function get Round():RoundNoel { return _round; }
		public function get ActiveTeams():Object { return _activeTeams; }
		public function get guiBossTeam():GuiBossTeam { return _guiBossTeam; }
		public function set guiBossTeam(val:GuiBossTeam):void { _guiBossTeam = val; }
		public function get InUseIce():Boolean { return _inUseIce; }
		public function set InUseIce(val:Boolean):void { _inUseIce = val; }
	}

}








































