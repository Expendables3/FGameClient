package Event.EventTeacher 
{
	import Data.ConfigJSON;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	/**
	 * Lớp quản lý dữ liệu cho Event 20-11
	 * @author HiepNM2
	 */
	public class EventTeacherMgr 
	{
		private static var _instance:EventTeacherMgr = null;
		private var _allGift:Array;
		private var _combo:ItemCollectionInfo;//combo
		private var _comboGift:Array;
		private var _oRequireCombo:Object;
		private var _listRemainCount:Array = [0, 0, 0, 0, 0];
		private var _point:int;
		private var _maxPoint:int;
		private var _gotGift:Array;
		
		public function EventTeacherMgr() 
		{
			var data:Object = ConfigJSON.getInstance().getItemInfo("ColP_ExchangeGift");
			initAllGift(data["ColPGGift"]);
			initRequireCombo(data["Combo"]["1"]["Require"]);
			initComboGift(data["Combo"]["1"]["Gift"]);
			initMaxPoint();
			//initListMaxCount(data[""][""]);
		}
		public function initPoint(data:Object):void
		{
			if (data == null) return;
			_point = data["Point"];
			_gotGift = data["Got"];
		}
		
		public function increasePoint(num:int):Boolean
		{
			var dPoint:int = 1;//đợi config
			_point += dPoint * num;
			var temp:Object = ConfigJSON.getInstance().getItemInfo("ColP_ExchangeGift")["PointGift"];
			for (var i:String in temp)
			{
				if (int(i) == _point)
				{
					return true;//có quà
				}
			}
			return false;
		}
		private function initMaxPoint():void
		{
			var temp:Object = ConfigJSON.getInstance().getItemInfo("ColP_ExchangeGift")["PointGift"];
			var max:int = -1;
			for (var i:String in temp)
			{
				if (int(i) > max)
				{
					max = int(i);
				}
			}
			_maxPoint = max;
		}
		public function getPoint():int //lay diem
		{ 
			return _point; 
		}
		public function getMaxPoint():int
		{
			return _maxPoint;
		}
		public function initRemainCount(data:Object):void
		{
			for (var id:String in data["ColPGGift"])
			{
				_listRemainCount[int(id) - 1] = data["ColPGGift"][id];
			}
			_listRemainCount[4] = data["Combo"]["1"];
		}
		
		public static function getInstance():EventTeacherMgr
		{
			if (_instance == null)
			{
				_instance = new EventTeacherMgr();
			}
			return _instance;
		}
		
		private function initRequireCombo(data:Object):void 
		{
			_oRequireCombo = new Object();
			for (var idItem:String in data)
			{
				_oRequireCombo[idItem] = data[idItem]["Num"];
			}
		}
		public function getNumRequireCombo(id:int):int
		{
			return _oRequireCombo[id];
		}
		private function initComboGift(data:Object):void
		{
			var count:int = 0;
			for (var s:String in data)
			{
				count++;
			}
			var temp:Object;
			var info:AbstractGift;
			_comboGift = [];
			for (var i:int = 1; i <= count; i++)
			{
				temp = data[i];
				info = AbstractGift.createGift(temp["ItemType"]);
				info.setInfo(temp);
				_comboGift.push(info);
			}
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
		public function initCombo():void
		{
			_combo = ItemCollectionInfo.createItemInfo("Combo");
			_combo.ItemType = "Combo";
			_combo.ItemId = 1;
			_combo.Num = getComboNum();
		}
		public function getTabGift(idTab:int):Array
		{
			return _allGift[idTab - 1];
		}
		public function getGift(idTab:int, idGift:int):AbstractGift
		{
			return _allGift[idTab - 1][idGift - 1];
		}
		
		public function getCombo():ItemCollectionInfo
		{
			return _combo;
		}
		
		private function getComboNum():int
		{
			var oItem:Object = EventSvc.getInstance().getListItem("ColPGGift");
			var info:ItemCollectionInfo;
			var min:int = int.MAX_VALUE;
			var num:int;
			for (var id:String in oItem)
			{
				info = oItem[id];
				num = int(info["Num"] / _oRequireCombo[id]);
				if (num < min)
				{
					min = num;
				}
			}
			return min;
		}
		public function updateCombo():void
		{
			_combo.Num = getComboNum();
		}
		
		public function getComboGift():Array 
		{
			return _comboGift;
		}
		
		public function getRemainCount(idTab:int):int
		{
			return _listRemainCount[idTab - 1];
		}
		
		public function updateRemainCount(idTab:int, dNum:int = 1):void 
		{
			_listRemainCount[idTab - 1] += dNum;
		}
		
		public function resetRemainCount():void
		{
			EventSvc.getInstance().logTime = GameLogic.getInstance().CurServerTime;
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("ColP_ExchangeGift");
			for (var i:int = 0; i < 4; i++)
			{
				_listRemainCount[i] = cfg["ColPGGift"][i + 1]["Max"]["Num"];
			}
			_listRemainCount[4] = cfg["Combo"]["1"]["Max"]["Num"];
		}
		/**
		 * kiểm tra xem có quà giữa khoảng prePoint và point hay không
		 * @param	prePoint : điểm trước đó
		 * @param	point : điểm hiện tại
		 * @param	listPointGift : mảng quà lấy ra
		 * @return có quà hay không
		 */
		public function checkGift(prePoint:int, point:int, listPointGift:Array):Boolean 
		{
			var hasGift:Boolean = false;
			var temp:Object = ConfigJSON.getInstance().getItemInfo("ColP_ExchangeGift")["PointGift"];
			for (var i:int = prePoint + 1; i <= point; i++)
			{
				for (var moc:String in temp)
				{
					if (i == int(moc))
					{
						hasGift = true;
						listPointGift.push(i);
					}
				}
			}
			return hasGift;
		}
	}

}























