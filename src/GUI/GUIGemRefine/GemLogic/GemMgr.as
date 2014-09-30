package GUI.GUIGemRefine.GemLogic 
{
	import Data.ConfigJSON;
	import flash.geom.Point;
	import Logic.GameLogic;
	
	/**
	 * Lớp quản lý logic 2 mảng đan ở khu luyện và khu đan
	 * @author HiepNM2
	 */
	public class GemMgr 
	{
		private var _gemArr:Array=[];				//mảng đan đang trong khu đan
		private var _upgradingGemArr:Array=[];		//mảng đan đang trong khu luyện
		private var _lastUpdateTime:Number;
		private static var _instacne:GemMgr;
		private const MAX_GEM_LEVEL_0:int = 10;
		public function get GemArr():Array
		{
			if (_gemArr.length == 0)
			{
				//trace("khong co gem");
			}
			return _gemArr;
		}
		public function get UpgradingGemArr():Array
		{
			if (_upgradingGemArr.length == 0)
			{
				//trace("khong co gem dang luyen");
			}
			return _upgradingGemArr;
		}
		public function GemMgr() 
		{
			
		}
		public static function getInstance():GemMgr
		{
			if (_instacne == null)
			{
				_instacne = new GemMgr();
			}
			return _instacne;
		}
		/**
		 * nhận dữ liệu sau khi load Kho
		 * @param	data: 	data["Gem"]["ListGem"] : danh sách những đan ở trong Khu đan
		 * 					data["Gem"]["LastUpdateTime"] 
		 * 					data["UpgradingGem"]
		 */
		public function receiveData(data:Object):void
		{
			/*xoa gem*/
			removeAllGem();
			removeAllUpgradingGem();
			_gemArr = [];
			_upgradingGemArr = [];
			/*them gem*/
			addAllGem(data["Gem"]["ListGem"]);
			addAllUpgradingGem(data["UpgradingGem"]);
			_lastUpdateTime = data["Gem"]["LastUpdateTime"];
		}
		
		private function removeAllGem():void
		{
			if (_gemArr)
			{
				_gemArr.splice(0, _gemArr.length);
			}
		}
		
		private function removeAllUpgradingGem():void
		{
			if (_upgradingGemArr)
			{
				_upgradingGemArr.splice(0, _upgradingGemArr.length);
			}
		}
		private function addAllGem(dataGem:Object):void
		{
			var gem:Gem;
			var element:int, level:int, dayLife:int, num:int, timeToRefine:Number;
			var i:String, j:String, k:String;
			for (i in dataGem)
			{
				element = (int) (i);
				for (j in dataGem[i])
				{
					level = (int)(j);
					for (k in dataGem[i][j])
					{
						dayLife = (int)(k);
						num = dataGem[i][j][k];
						gem = new Gem(element, level, dayLife, num);
						_gemArr.push(gem);
					}
				}
			}
		}
		
		private function addAllUpgradingGem(dataUpgradingGem:Object):void
		{
			var upgradingGem:UpgradingGem;
			var slotId:int,element:int, levelDone:int, listGemSource:Array, timeRefine:Number, startTime:Number, dayExpired:Number;
			var i:String;
			for (i in dataUpgradingGem)
			{
				slotId = (int)(i);
				levelDone = dataUpgradingGem[i]["LevelDone"];
				timeRefine = dataUpgradingGem[i]["Time"];
				startTime = dataUpgradingGem[i]["StartTime"];
				listGemSource = initListGemOfUGem(dataUpgradingGem[i]["ListGem"], levelDone-1 );
				element = listGemSource[0]["Element"];
				dayExpired = dataUpgradingGem[i]["Day"];
				upgradingGem = new UpgradingGem(slotId, element, levelDone, listGemSource, timeRefine, startTime, dayExpired);
				if (upgradingGem.StepRefine == 1) 
					upgradingGem.JustRefined = true;
				_upgradingGemArr.push(upgradingGem);
			}
		}
		private function initListGemOfUGem(lstGem:Array, level:int):Array
		{
			var leng:int = lstGem.length;
			var gem:Gem;
			var lstGemOfUGem:Array = [];
			for (var i:int = 0; i < leng; i++)
			{
				gem = new Gem(lstGem[i]["Element"], level, lstGem[i]["Day"], lstGem[i]["Num"]);
				lstGemOfUGem.push(gem);
			}
			return lstGemOfUGem;
		}
		
		public function isRefined(uGem:UpgradingGem):Boolean
		{
			//if (uGem.TimeRefine < 0)
			//{
				//return false;
			//}
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:Number = curTime-uGem.StartTimeRefine;
			if (remainTime >= uGem.TimeRefine)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		/**
		 * chuyển gem từ mảng _gemArr sang mảng _upgradingGemArr
		 * @param	gem			:viên gem cần chuyển
		 */
		public function transferGem(gem:Gem):void
		{
			var index:int;
			var _gem:Gem;
			var gemClone:Gem = new Gem(gem.Element, gem.Level, gem.DayLife, gem.Num);
			var uGem:UpgradingGem;
			var lstGemSource:Array = [];
			var num:int;
			
			index = indexOfGem(gem);
			_gem = _gemArr[index] as Gem;
			var len:int = _upgradingGemArr.length;
			var i:int, j:int;
			if (gem.Level == 0)
			{
				num = _gem.Num;
				for (i = 0; i < len; i++)
				{
					uGem = _upgradingGemArr[i] as UpgradingGem;
					if (uGem.Element == gem.Element && uGem.Level == 0 && uGem.ListGemSource.length < MAX_GEM_LEVEL_0)
					{//tìm thấy slot chứa tán cùng hệ và nó chưa chứa đủ 10 viên
						for (j = 0; j < num; j++)
						{
							if (uGem.ListGemSource.length < MAX_GEM_LEVEL_0 && _gem.Num > 0)
							{
								_gem.Num--;
								uGem.pushToListGem(gem.Element, gem.Level, gem.DayLife, 1);
								if (_gem.Num == 0)
								{
									_gemArr.splice(index, 1);
								}
							}
							else
							{
								break;
							}
						}
						return;//thoat trường hợp trùng hệ và số lượng tán chưa đủ
					}
				}
				if (len >= 3)
				{
					return;
				}
				//trường hợp là tán: bổ sung vào các slot trống
				for (i = 0; i < num; i++)
				{
					if (gem.Num > 0 && lstGemSource.length < MAX_GEM_LEVEL_0)
					{
						lstGemSource.push(new Gem(gem.Element, gem.Level, gem.DayLife, 1));
						gem.Num--;
					}
				}
			}
			else
			{
				if (len >= 3)
					return;
				lstGemSource.push(new Gem(gem.Element, gem.Level, gem.DayLife, 1));
				gem.Num--;
			}
			// còn slot trống
			var timeRefine:int = ConfigJSON.getInstance().getItemInfo("Gem")[gem.Level]["TimeUpgrade"];
			uGem = new UpgradingGem(0, gem.Element, gem.Level + 1, lstGemSource, timeRefine, -1, gem.DayLife);
			uGem.SlotId = findSlot();
			//xóa khỏi mảng _gemArr nếu gem.Num==0
			var ind:int = indexOfGem(gemClone);
			if (gem.Num == 0)
			{
				_gemArr.splice(ind, 1);
			}
			else
			{
				_gemArr[ind] = gem;
			}
			_upgradingGemArr.push(uGem);
		}
		
		/**
		 * chuyển gem từ _upgradingGemArr sang _gemArr
		 * @param	uGem: viên gem cần chuyển
		 */
		public function transferUgradingGem(uGem:UpgradingGem):void
		{
			var i:int,j:int, isPush:Boolean = true;
			var gem:Gem;
			var groupGem:Array = [];
			groupGem.push(uGem.ListGemSource[0] as Gem);
			var num:int = 1;
			for (i = 1; i < uGem.ListGemSource.length; i++)
			{
				gem = uGem.ListGemSource[i] as Gem;
				var gem2:Gem = groupGem[groupGem.length - 1] as Gem;
				if (!(gem.Element == gem2.Element && gem.Level == gem2.Level && gem.DayLife == gem2.DayLife))
				{
					groupGem.push(gem);
					num = 1;
				}
				else
				{
					num++;
					(groupGem[groupGem.length - 1] as Gem).Num = num;
				}
			}
			/*xóa đan ở khu luyện*/
			var index:int = indexOfUpgradingGem(uGem);
			_upgradingGemArr.splice(index, 1);
			/*thêm đan vào khu đan*/
			for (i = 0; i < groupGem.length; i++)
			{
				gem = groupGem[i] as Gem;
				for (j = 0; j < _gemArr.length; j++)
				{
					var tmpGem:Gem = _gemArr[j] as Gem;
					if (gem.Element == tmpGem.Element && gem.Level == tmpGem.Level && gem.DayLife == tmpGem.DayLife)
					{
						tmpGem.Num += gem.Num;
						isPush = isPush && false;
						break;
					}
				}
				if(isPush)
					_gemArr.push(gem);
				
			}
		}
		
		/**
		 * Tìm 1 slot trống và slot đó có giá trị nhỏ nhất trong các slot trống tìm được
		 * @return id của slot (stt của slot)
		 */
		private function findSlot():int
		{
			var arr:Array = [0, 1, 2];
			var leng:int = _upgradingGemArr.length;
			var uGem:UpgradingGem;
			var index:int, i:int;
			for (i = 0; i < leng; i++)
			{
				uGem = _upgradingGemArr[i] as UpgradingGem;
				index = arr.indexOf(uGem.SlotId);
				if (index != -1)
				{
					arr.splice(index, 1);
				}
			}
			var min:int = 9999;
			leng = arr.length;
			for (i = 0; i < leng; i++)
			{
				if (arr[i] < min)
					min = arr[i];
			}
			return min;
		}
		
		/**
		 * tìm chỉ số của gem trong _gemArr
		 * @param	gem: viên gem cần tìm chỉ số
		 * @return chỉ số trong _gemArr
		 */
		private function indexOfGem(gem:Gem):int
		{
			var i:int;
			for (i = 0; i < _gemArr.length; i++)
			{
				if (gem.equal(_gemArr[i] as Gem))
				{
					return i;
				}
			}
			return -1;
		}
		
		public function finishRefine(uGem:UpgradingGem):void
		{
			var index:int = indexOfUpgradingGem(uGem);
			if (index >= 0)
			{
				var uGem:UpgradingGem = _upgradingGemArr[index] as UpgradingGem;
				uGem.JustRefined = true;
				uGem.TimeRefine = -1;
			}
		}
		/**
		 * tìm chỉ số của gem trong _upgradingGemArr
		 * @param	uGem: viên gem cần tìm chỉ số
		 * @return chỉ số trong _upgradingGemArr
		 */
		private function indexOfUpgradingGem(uGem:UpgradingGem):int
		{
			var i:int;
			for (i = 0; i < _upgradingGemArr.length; i++)
			{
				if (uGem.equal(_upgradingGemArr[i] as UpgradingGem))
				{
					return i;
				}
			}
			return -1;
		}
		/**
		 * lên cấp 1 viên đan trong khu luyện - thực hiện khi nhận đan sau khi luyện xong
		 * @param	idSlot: id của slot chứa đan lên cấp
		 */
		public function levelUp(idSlot:int):void
		{
			/* tìm viên đan với slot đã cho */
			var i:int, index:int = -1;
			for (i = 0; i < _upgradingGemArr.length; i++)
			{
				var uGem:UpgradingGem = _upgradingGemArr[i] as UpgradingGem;
				if (uGem.SlotId == idSlot)
				{
					index = i;
					break;
				}
			}
			/* thực hiện lên cấp viên đan đó - không cần, thực hiện lên cấp khi nhận đan*/
			var upgradingGem:UpgradingGem = _upgradingGemArr[index] as UpgradingGem;
			upgradingGem.levelUp();
		}
		/**
		 * Tính thời gian đợi và % thời gian chạy
		 * @param	intervalTime [in]: Khoảng thời gian
		 * @param	startTime [in]: Thời gian bắt đầu
		 * @param	objParam [out]: lấy ra Thời gian đợi và % thời gian đã chạy được
		 */
		public static function countInGem(intervalTime:Number, startTime:Number, objParam:Object):void
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:Number = curTime - startTime;
			objParam["TimeWait"] = intervalTime - remainTime;
			objParam["Percent"] = remainTime / intervalTime;
		}
		/**
		 * lấy ra upgradingGem có slotId = idSlot truyền vào
		 * @param	idSlot: SlotId cần so sánh
		 * @return uGem cần lấy
		 */
		public function getUpgradingGemById(idSlot:int):UpgradingGem
		{
			var lstUGem:Array = _upgradingGemArr;
			var i:int;
			var uGem:UpgradingGem;
			for (i = 0; i < _upgradingGemArr.length; i++)
			{
				uGem = _upgradingGemArr[i] as UpgradingGem;
				if (uGem.SlotId == idSlot)
				{
					break;
				}
			}
			return uGem;
		}
		
		public function delGem(gem:Gem):void
		{
			var i:int;
			if (gem.Num == 0)
				return;
			for (i = 0; i < _gemArr.length; i++)
			{
				var g:Gem = _gemArr[i] as Gem;
				if (g.Element == gem.Element && g.Level == gem.Level && g.DayLife == gem.DayLife)
				{
					if (g.Num == gem.Num)
					{
						_gemArr.splice(i, 1);
						break;
					}
					else if (g.Num > gem.Num)
					{
						g.Num -= gem.Num;
						break;
					}
				}
			}
		}
		
		public function recoverGem(gem:Gem):void
		{
			var i:int;
			if (gem.Num == 0)
				return;
			var NUM_GEM_DAY:int = ConfigJSON.getInstance().getItemInfo("Param")["NumGemDay"];
			for (i = 0; i < _gemArr.length; i++)
			{
				var g:Gem = _gemArr[i] as Gem;
				if (g.Element == gem.Element && g.Level == gem.Level && g.DayLife == gem.DayLife)
				{
					if (g.Num == gem.Num)
					{
						gem.DayLife = NUM_GEM_DAY;
						_gemArr.splice(i, 1);
						break;
					}
					else if (g.Num > gem.Num)
					{
						g.Num -= gem.Num;
						gem.DayLife = NUM_GEM_DAY;
						//_gemArr.push(gem);
						break;
					}
				}
			}
			//đẩy gem vào trong _gemArr
			var isPush:Boolean = true;
			for (i = 0; i < _gemArr.length; i++)
			{
				var gem2:Gem = _gemArr[i] as Gem;
				if (gem2.Element == gem.Element && gem2.Level == gem.Level && gem2.DayLife == gem.DayLife)
				{
					gem2.Num += gem.Num;
					isPush = false;
				}
			}
			if (isPush)
			{
				_gemArr.push(gem);
			}
		}
		public function quickRefine(idSlot:int):void
		{
			var _ugem:UpgradingGem = getUpgradingGemById(idSlot);
			if (_ugem != null)
			{
				trace("Server đã hoàn thành luyện đan nhanh ở slot có id = " + idSlot);
				_ugem.TimeRefine = -1;
			}
			else
			{
				trace("gem đã được chuyển đi");
			}
		}
		public function smartSort():void
		{
			_gemArr.sortOn(["IsExpired", "Element", "Level", "Num"], Array.NUMERIC);
			_gemArr.reverse();
		}
		
		public function hasExpiredGem():Boolean
		{
			var hasExpired:Boolean = false;
			for (var i:int = 0; i < _gemArr.length; i++)
			{
				var gem:Gem = _gemArr[i] as Gem;
				if (gem.IsExpired)
				{
					hasExpired = true;
					break;
				}
			}
			return hasExpired;
		}
	}
}


















