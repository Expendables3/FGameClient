package Event.EventHalloween.HalloweenLogic 
{
	import Data.ConfigJSON;
	import Event.EventHalloween.HalloweenPackage.SendUnlockNode;
	import flash.geom.Point;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	import NetworkPacket.BasePacket;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class HalloweenMgr 
	{
		
		private static var _instance:HalloweenMgr = null;
		private var _map:Array;					//lưu trữ dữ liệu về map
		private var _oRockStore:Object;			//kho lưu trữ đá + số lượng của chúng
		private var _agent:Array = [];				//quà của 1 nút bất kỳ (có thể là ma).
		private var _pScr:Point;				//tọa độ hiện tại của cá
		private var _lastTimePlay:Number;		//thời điểm cuối cùng chơi
		private var _remainTimePlay:int;		//số lần chơi còn lại
		private var _storeGift:Array = [];			//kho quà chưa nhận của user
		private var _nKey:int;					//số chìa khóa đang có (<3)
		
		
		public var inTask:Boolean = false;		//đang trong thời điểm thực hiện nhiệm vụ (biến tạm)
		private var _task:Object;				//nhiệm vụ đang gặp phải (khi bị ghẹo)
		
		public var LastDatePlay:String;		//ngày cuối mà người chơi getInfo
		private var _lastTimeLock:Number;		//thời điểm thoát khỏi mật bảo.
		private var _isLockHalloween:Boolean;	//mật bảo bị khóa hay không.
		
		private var _nPoint:int;				//số điểm có được khi người chơi nạp thẻ
		private var _hasKey:Boolean;
		
		public var isMoved:Boolean = false;
		public var RemainPlayCount:int;
		
		private var _isGetSaveGift:Boolean = false;//phần thưởng an ủi khi qua ngày
		private var _giftSave:Array = [];
		
		public var dataGhost:Object;
		public function get GiftSave():Array
		{
			return _giftSave;
		}
		public function get IsGetSaveGift():Boolean
		{
			return _isGetSaveGift;
		}
		public function get HasKey():Boolean
		{
			return _hasKey;
		}
		public function set LastTimeLock(value:Number):void
		{
			_lastTimeLock = value;
		}
		public function get LastTimeLock():Number
		{
			return _lastTimeLock;
		}
		public function set IsLockHalloween(value:Boolean):void
		{
			_isLockHalloween = value;
		}
		public function get IsLockHalloween():Boolean
		{
			return _isLockHalloween;
		}
		public function get pScr():Point 
		{
			return _pScr;
		}
		public function set pScr(value:Point):void 
		{
			_pScr = value;
		}
		
		public function get Key():int 
		{
			return _nKey;
		}
		
		public function set Key(value:int):void 
		{
			_nKey = value;
		}
		
		public function get nPoint():int 
		{
			return _nPoint;
		}
		
		public function set nPoint(value:int):void 
		{
			_nPoint = value;
		}
		
		public function getStoreGift():Array
		{
			return _storeGift;
		}
		
		public function getTask():Object
		{
			return _task;
		}
		public function HalloweenMgr() 
		{
			_oRockStore = new Object();
		}
		
		public function getMap():Array 
		{
			return _map;
		}
		
		public static function getInstance():HalloweenMgr
		{
			if (_instance == null)
			{
				_instance = new HalloweenMgr();
			}
			return _instance;
		}
		/**
		 * khởi tạo dữ liệu sau gói getStatus
		 * @param	data : dữ liệu server
		 */
		public function initData(data:Object):void 
		{
			LastDatePlay = data["Hal12"]["LastDatePlay"];
			RemainPlayCount = data["Hal12"]["RemainPlayCount"];
			initStoreGift(data["Hal12"]["HalScene"]["Reward"]);
			
			_pScr = new Point(data["Hal12"]["HalScene"]["BabyChip"]["0"],
								data["Hal12"]["HalScene"]["BabyChip"]["1"]);
			initMap(data["Hal12"]["HalScene"]["Map"]);
			_hasKey = data["Hal12"]["HadKey"];
			if (inTask)
			{
				initTask(data["Hal12"]["HalScene"]["Task"]);
			}
			_isGetSaveGift = data["GotGiftEngage"];
			if (!_isGetSaveGift)
			{
				var obj:Object = data["Gift"];
				var gift:AbstractGift;
				for (var s:String in obj)
				{
					gift = new GiftNormal();
					gift["ItemType"] = s;
					gift["Num"] = obj[s];
					_giftSave.push(gift);
				}
			}
		}
		/**
		 * khởi tạo kho quà chưa nhận
		 * @param	data : dữ liệu server
		 */
		private function initStoreGift(data:Object):void 
		{
			var s:String, i:int;
			var obj:Object;
			var gift:AbstractGift;
			for (s in data)
			{
				if (data[s])
				{
					for (i = 0; i < data[s].length; i++)
					{
						obj = data[s][i];
						if (s == "Equipment")
						{
							gift = new GiftSpecial();
							gift.setInfo(obj);
							_storeGift.push(gift);
						}
						else
						{
							gift = new GiftNormal();
							gift.setInfo(obj);
							addItemStore(gift, _storeGift);
						}
					}
				}
			}
		}
		
		private function addItemStore(agent:AbstractGift, store:Array):void
		{
			var i:int;
			var gift:AbstractGift;
			var isPush:Boolean = true;
			if (Ultility.categoriesGift(agent["ItemType"]) == 0)//agent là quà thường
			{
				for (i = 0; i < store.length; i++)
				{
					gift = store[i];
					if (Ultility.categoriesGift(gift["ItemType"]) == 0)//chỉ duyệt quà thường
					{
						if (gift["ItemType"] == agent["ItemType"])//chung itemtype
						{
							if (gift["ItemId"] != null)//co itemid
							{
								if (gift["ItemId"] == agent["ItemId"])
								{
									if (gift["ItemType"] == "Gem")
									{
										if (gift["Element"] == agent["Element"] && gift["Day"] == agent["Day"])
										{
											gift["Num"] += agent["Num"];
											isPush = false;
											break;
										}
									}
									else if (gift["ItemType"] == "Soldier")
									{
										if (gift["RecipeType"] == agent["RecipeType"] && gift["RecipeId"] == agent["RecipeId"])
										{
											gift["Num"] += agent["Num"];
											isPush = false;
											break;
										}
									}
									else
									{
										gift["Num"] += agent["Num"];
										isPush = false;
										break;
									}
								}
							}
							else//khong co itemid
							{
								gift["Num"] += agent["Num"];
								isPush = false;
								break;
							}
						}
					}
				}
			}
			if (isPush)
			{
				store.push(agent);
			}
		}
		/**
		 * khởi tạo dữ liệu cho map
		 * @param	Map : dữ liệu vào
		 */
		private function initMap(Map:Array):void
		{
			var i:int, j:int;
			var Line:Array;
			var obj:Object;
			var temp:Object;
			var node:ItemHalloweenInfo;
			var _line:Array;
			_map = new Array();
			for (i = 0; i < Map.length; i++)
			{
				Line = Map[i];
				_line = new Array();
				for (j = 0; j < Line.length; j++)
				{
					obj = Line[j];
					if (obj[0] == 0)
					{
						obj[1] = 0;
						obj[2] = 0;
					}
					
					node = new ItemHalloweenInfo();
					temp = ConfigJSON.getInstance().getItemInfo("Hal2012_MapItemId")[obj[1]];
					node.setInfo(temp);
					node.Thick = obj[0];
					if (!isMoved && node.Thick == ItemHalloweenInfo.ROAD && (i != _pScr.x || j != _pScr.y))
					{
						isMoved = true;
					}
					node.isTrick = obj[2] == 1 ? true : false; //có bị ghẹo ở ô đó hay không
					_line.push(node);
					
				}
				_map.push(_line);
			}
			scanMap();
		}
		
		private function scanMap():void
		{
			var i:int, j:int;
			var line:Array;
			var node:ItemHalloweenInfo;
			for (i = 0; i < _map.length; i++)
			{
				line = _map[i];
				for (j = 0; j < line.length; j++)
				{
					node = line[j];
					if (node.Thick == ItemHalloweenInfo.ROAD)
					{
						change4LandToBound(i, j);
					}
				}
			}
		}
		
		public function initItemHalloween(data:Object):void
		{
			/*khởi tạo số chìa khóa*/
			//if (data["Key"] != null)
			//{
				//_nKey = data["Key"]["1"];
			//}
			/*khởi tạo số đá*/
			for (var i:int = 1; i <= 12; i++)
			{
				_oRockStore[i.toString()] = 0;
			}
			if (data == null)
			{
				return;
			}
			if (data["HalItem"] != null)
			{
				for (var s:String in data["HalItem"])
				{
					_oRockStore[s] = data["HalItem"][s];
				}
				/*khởi tạo số chìa khóa*/
				if (data["HalItem"]["13"] != null)
				{
					_nKey = data["HalItem"]["13"];
				}
				else {
					_nKey = 0;
				}
				
			}
			if (data["Medal"] != null)
			{
				GameLogic.getInstance().numMedalHalloween = data["Medal"][1];
			}
		}
		
		private function initTask(data:Object):void 
		{
			var id:int = data["GhostRequire"];
			dataGhost = ConfigJSON.getInstance().getItemInfo("Hal2012_GhostGift")[id.toString()];
		}
		
		public function updateRockStore(id:int, dNum:int):void
		{
			_oRockStore[id.toString()] += dNum;
		}
		
		public function processBuyPack(data:Object):void
		{
			if (data["Pack"] != null)
			{
				var obj:Object;
				for (var i:int = 0; i < data["Pack"].length; i++)
				{
					obj = data["Pack"][i];
					updateRockStore(obj["ItemId"], obj["Num"]);
				}
			}
		}
		public function getRockNum(id:int):int
		{
			if (id >= 1 && id <= 12)
			{
				return _oRockStore[id.toString()];
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * Mở 1 node
		 * @param	x : vị trí x của node
		 * @param	y : vị trí y của node
		 * @param	isIce : có phải là băng không
		 */
		public function breakRock(x:int, y:int, isIce:Boolean = false):void
		{
			//chuyển trạng thái cho node về ROAD
			var node:ItemHalloweenInfo = _map[x][y];
			node.Thick--;
			node.isBound = isIce;
			if (!isIce)
			{
				//chuyển trạng thái 4 ô xung quanh
				change4LandToBound(x, y);
			}
		}

		private function change4LandToBound(x:int, y:int):void
		{
			changeLandToBound(x, y - 1);
			changeLandToBound(x - 1, y);
			changeLandToBound(x, y + 1);
			changeLandToBound(x + 1, y);
		}
		/**
		 * chuyển 1 node thành biên
		 * @param	x : vị trí x
		 * @param	y : vị trí y
		 */
		private function changeLandToBound(x:int, y:int):void
		{
			if (x < ItemHalloweenInfo.MAX_X &&
				x >= 0 &&
				y < ItemHalloweenInfo.MAX_Y &&
				y >= 0)
			{
				var node:ItemHalloweenInfo = _map[x][y];
				if (!node.isBound && node.Thick != ItemHalloweenInfo.ROAD)
				{
					node.isBound = true;
				}
			}
		}
		/**
		 * khởi tạo cho _agent
		 * @param	data
		 */
		public function initAgent(oldData:SendUnlockNode, data:Object):void 
		{
			var node:ItemHalloweenInfo = _map[oldData.X][oldData.Y];
			var i:int;
			var temp:AbstractGift;
			var pathGift:String;
			if (node.Thick == ItemHalloweenInfo.FREEZE)
			{
				return;
			}
			if (node.isTrick)
			{
				//trace("có ma");
				initTask(data);
			}
			else
			{
				_agent.splice(0, _agent.length);
				if (node.ItemType == "End")
				{
					pathGift = "Reward";
					GuiMgr.getInstance().guiGiftHalloween.autoId = data["AutoId"];
				}
				else
				{
					pathGift = "Gift";
					if (!isMoved)
					{
						isMoved = true;
					}
				}
				
				if (data[pathGift]["Normal"] != null)
				{
					for (i = 0; i < data[pathGift]["Normal"].length; i++)
					{
						temp = new GiftNormal();
						temp.setInfo(data[pathGift]["Normal"][i]);
						if (temp["ItemType"] == "HalItem" && temp["ItemId"] == 13)//là cái chìa khóa => không add vào
						{
							_hasKey = true;
							//_nKey++;
						}
						addItemStore(temp, _agent);
					}
				}
				if (data[pathGift]["Equipment"] != null)
				{
					for (i = 0; i < data[pathGift]["Equipment"].length; i++)
					{
						temp = new GiftSpecial();
						temp.setInfo(data[pathGift]["Equipment"][i]);
						_agent.push(temp);
					}
				}
			}
		}
		
		public function getAgent():Array
		{
			return _agent;
		}
		
		public function freeStoreGift():void
		{
			if (_storeGift == null)
			{
				return;
			}
			var gift:AbstractGift;
			for (var i:int = 0; i < _storeGift.length; i++)
			{
				_storeGift[i] = null;
			}
			_storeGift.splice(0, _storeGift.length);
		}
		/**
		 * tìm đường từ _x, _y đến xDes, yDes
		 * @param	xDes
		 * @param	yDes
		 * @return trả về mảng các phần tử Point chứa chỉ số x,y của các node
		 */
		public function findLine(xDes:int, yDes:int, hasNodeDes:Boolean):Array 
		{
			var a:int = _pScr.x > xDes ? -1 : 1;
			var b:int = _pScr.y > yDes ? -1 : 1;
			var i:int, j:int;
			var node:ItemHalloweenInfo;
			var nodeDes:ItemHalloweenInfo;
			var p:Point;
			var Queue:Array = [];
			
			for (i = 0; i < 10; i++)
			{
				for (j = 0; j < 10; j++)
				{
					node = _map[i][j];
					if (node.Thick == ItemHalloweenInfo.ROAD)
					{
						node.GColor = ItemHalloweenInfo.WHITE;
						node.Before = null;
					}
				}
			}
			node = _map[_pScr.x][_pScr.y];
			node.GColor = ItemHalloweenInfo.GRAY;
			p = new Point(_pScr.x, _pScr.y);
			Queue.push(p);
			while (Queue.length > 0)
			{
				p = Queue.shift();
				node = _map[p.x][p.y];	//lấy node ra để duyệt
				/*check đỉnh kề thứ nhất*/
				if ((nodeDes = checkDes(p.x + 1, p.y, xDes, yDes, p, Queue)) != null)
				{
					break;
				}
				/*check đỉnh kề thứ 2*/
				if ((nodeDes = checkDes(p.x, p.y + 1, xDes, yDes, p, Queue)) != null)
				{
					break;
				}
				/*check đỉnh kề thứ 3*/
				if ((nodeDes = checkDes(p.x - 1, p.y, xDes, yDes, p, Queue)) != null)
				{
					break;
				}
				/*check đỉnh kề thứ 4*/
				if ((nodeDes = checkDes(p.x, p.y - 1, xDes, yDes, p, Queue)) != null)
				{
					break;
				}
				
				node.GColor = ItemHalloweenInfo.BLACK;//duyệt xong node này
			}
			if (nodeDes == null)
			{
				return [];
			}
			else
			{
				var line:Array = getLine(nodeDes);
				if (hasNodeDes)
				{
					line.push(new Point(xDes, yDes));
				}
				return line;
			}
		}
		
		/**
		 * Kiểm tra xem cái vị trí hiện tại có phải đích, và thực hiện việc thăm node x,y
		 * @param	x : vị trí node đang thăm
		 * @param	y : vị trí node đang thăm
		 * @param	xDes : vị trí node đích
		 * @param	yDes : vị trí node đích
		 * @param	node [out]: node đi trước của node đang thăm.
		 * @param	nodeDes [out]: node đích
		 * @param	Queue [out]: hàng đợi 
		 * @return : tìm được đích hay chưa??
		 */
		private function checkDes(x:int, y:int, xDes:int, yDes:int,
									pBefore:Point, 
									/*nodeDes:ItemHalloweenInfo,*/
									Queue:Array):ItemHalloweenInfo
		{
			if (x > 9 || y > 9 || x < 0 || y < 0)
			{
				return null;
			}
			var temp:ItemHalloweenInfo = _map[x][y];
			//var node:ItemHalloweenInfo = _map[pBefore.x][pBefore.y];
			if (xDes == x && yDes == y)
			{
				temp.Before = pBefore;
				return temp;
				//nodeDes = temp;
				//return true;
			}
			else
			{
				if (temp.GColor == ItemHalloweenInfo.WHITE && temp.Thick == ItemHalloweenInfo.ROAD)
				{
					temp.GColor = ItemHalloweenInfo.GRAY;
					temp.Before = pBefore;
					Queue.push(new Point(x, y));
				}
				return null;
			}
		}
		/**
		 * lấy đường đi khi biết điểm đích (điểm đầu có Before = null)
		 * @param	nodeDes : điểm đích
		 * @return : 1 list các Point thể hiện đường đi
		 */
		private function getLine(nodeDes:ItemHalloweenInfo):Array
		{
			var node:ItemHalloweenInfo = nodeDes;
			var p:Point;
			var line:Array = [];
			while (node.Before != null)
			{
				p = node.Before;
				line.unshift(p);
				node = _map[p.x][p.y];
			}
			return line;
		}
		/**
		 * kiểm tra 1 gói tin có phải task đang nhận hay không
		 * @param	cmd : gói tin kiểm tra
		 * @return : true => là task hiện tại , false => ko phải
		 */
		public function isTask(cmd:BasePacket):Boolean
		{
			return false;
		}
		
		/**
		 * kiểm tra xem mật bảo có bị khóa không
		 * @return : true nếu bị khóa, false nếu ngược lại
		 */
		public function checkLockHalloween():Boolean
		{
			var curTimeDate:Number = GameLogic.getInstance().CurServerTime * 1000;
			var date:Date = new Date(curTimeDate);
			var idate:int = int(date.getDate());
			var sDate:String = idate < 10 ? "0" + idate : idate.toString();
			var imounth:int = int(date.getMonth()) + 1;
			var sMounth:String = imounth < 10?"0" + imounth:imounth.toString();
			var sYear:String = date.getFullYear().toString();
			var sss:String = sYear + sMounth + sDate;
			if (sss != LastDatePlay)
			{
				LastDatePlay = sss;
				_isLockHalloween = false;
				_lastTimeLock = 0;
				return false;
			}
			if (!_isLockHalloween)//nếu đang không lock return luôn
			{
				return false;
			}
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var passTime:Number = curTime - _lastTimeLock;
			var cfgTime:int = 1800;
			var remainTime:Number = cfgTime - passTime;
			_isLockHalloween = (remainTime >= -2);
			return _isLockHalloween;
		}
		
		public function initGiftAutoFinish(data:Object):void 
		{
			var temp:AbstractGift;
			var i:int;
			_agent.splice(0, _agent.length);
			if (data["Reward"]["Normal"] != null)
			{
				for (i = 0; i < data["Reward"]["Normal"].length; i++)
				{
					temp = new GiftNormal();
					temp.setInfo(data["Reward"]["Normal"][i]);
					addItemStore(temp, _agent);
				}
			}
			if (data["Reward"]["Equipment"] != null)
			{
				for (i = 0; i < data["Reward"]["Equipment"].length; i++)
				{
					temp = new GiftSpecial();
					temp.setInfo(data["Reward"]["Equipment"][i]);
					_agent.push(temp);
				}
			}
		}
		
		public function breakLockHalloween():void
		{
			_isLockHalloween = false;
			_lastTimeLock = -1;
		}
		
		public function lockHalloween():void
		{
			_isLockHalloween = true;
			_lastTimeLock = GameLogic.getInstance().CurServerTime;
		}
	}

}




















