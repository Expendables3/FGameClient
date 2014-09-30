package GUI.TrungLinhThach 
{
	import Data.ConfigJSON;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class TrungLinhThachMgr 
	{
		private var eggObjData:Object = new Object();
		private var ListItemTrung:Array = [];
		private var typeEggs:Array = ['WhiteEgg', 'GreenEgg', 'YellowEgg', 'PurpleEgg'];
		private var timeToBonus:int;
		private var _timeGui:Number;
		static public const NORMALTIME:Number = 1.001;
		static private var _instance:TrungLinhThachMgr;
		private var _fisrtTimeLogin:Boolean = true;
		public var hasUpdate:Boolean = false;
		public var slotObjData:Object = new Object();
		
		
		public function TrungLinhThachMgr() 
		{
			_fisrtTimeLogin = true;
		}
		
		static public function getInstance():TrungLinhThachMgr 
		{
			if (_instance == null) {
				_instance = new TrungLinhThachMgr();
			}
			return _instance;
		}
		
		public function get FisrtTimeLogin():Boolean 
		{
			return _fisrtTimeLogin;
		}
		
		public function set FisrtTimeLogin(value:Boolean):void 
		{
			_fisrtTimeLogin = value;
		}
		
		
		public function getQuartzInfo():void 
		{
			var cmdLinhThach:SendGetSmashEgg = new SendGetSmashEgg();
			cmdLinhThach.FriendId = 0;
			Exchange.GetInstance().Send(cmdLinhThach);
		}
		
		public function initData():void 
		{
			_timeGui = GameLogic.getInstance().CurServerTime;
			updateStatusIcon(false);
		}
		
		
		public function updateListRoom(data:Object):void
		{
			updateStatusIcon(false);
			eggObjData = data["SmashEgg"]["Egg"];
			slotObjData = data["SmashEgg"]["Slot"];
			//trace("updateListRoom== " + eggObjData);
			
			var EggArr:Array = new Array();
			EggArr.push(eggObjData.WhiteEgg);
			EggArr.push(eggObjData.GreenEgg);
			EggArr.push(eggObjData.YellowEgg);
			EggArr.push(eggObjData.PurpleEgg);
			addAllItemTrung(EggArr);
		}
		
		private function addAllItemTrung(data:Array):void 
		{
			ListItemTrung.splice(0, ListItemTrung.length);
			
			var i:int;
			var leng:int = 4;
			for (i = 0; i < data.length; i++)
			{
				//trace("data[i].Time== " + data[i].Time);
				var trung:Object = data[i];
				trung.id = i + 1;
				trung.name = typeEggs[i];
				drawItem(trung)
			}
			
		}
		
		public function drawItem(_trung:Object):void
		{
			var timeConfig:int = ConfigJSON.getInstance().GetItemList("SmashEgg_EggHammer")[_trung.name].Time;
			timeToBonus = (_trung.Time + timeConfig) - GameLogic.getInstance().CurServerTime;
			
			if (timeToBonus < 0)
			{
				updateStatusIcon(true);
			}
			ListItemTrung.push(timeToBonus);
		}
		
		private function updateStatusIcon(isOpen:Boolean):void
		{
			//trace("Co cai den thoi gian updateStatusIcon isOpen== " + isOpen);
			if (GuiMgr.getInstance().guiTrungLinhThach.img)
			{
				//GuiMgr.getInstance().guiTrungLinhThach.updateButtomFront(isOpen);
				//trace("tren updateStatusIcon isOpen== " + isOpen);
			}
			else
			{
				GuiMgr.getInstance().guiFrontScreen.BtnTrungLinhThach.SetBlink(isOpen);
				//trace("duoi updateStatusIcon isOpen== " + isOpen);
			}
		}
		
		public function updateQuartzState():void 
		{
			//trace("-------updateQuartzState");
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var isSetTimeGui:Boolean = false;
			for (var i:int = 0; i < ListItemTrung.length; i++)
			{
				var isUpdated:Boolean = true;
				if (isUpdated)
				{
					var tickcount:Number = curTime - _timeGui;
					if (tickcount >= NORMALTIME)
					{
						//trace("-------updateQuartzState");
						var newTimeItem:int = ListItemTrung[i];
						newTimeItem--;
						if (newTimeItem < 0)
						{
							updateStatusIcon(true);
						}
						else
						{
							ListItemTrung[i] = newTimeItem;
						}
						//trace("newTimeItem== " + newTimeItem);
						isSetTimeGui = true;
					}
				}
			}
			if (isSetTimeGui)
			{
				_timeGui = curTime;
			}
		}
		
		
	}

}