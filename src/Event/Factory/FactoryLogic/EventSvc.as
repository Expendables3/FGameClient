package Event.Factory.FactoryLogic 
{
	import Data.ConfigJSON;
	import Event.EventMgr;
	import Event.EventTeacher.EventTeacherMgr;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class EventSvc 
	{
		private static var _instance:EventSvc;
		private var _oItem:Object;//danh sách item của event
		private var _oRequired:Object;//danh sách số lượng item yêu cầu
		private var _numRow:int;
		public var logTime:Number = -1;
		private const dataItem:Object = { 	
											"Bullet":
												{ "1":0, "2":0, "3":0 },
											"BulletGold":
												{"1":0 },
											"Candy":
												{ "1":0, "2":0, "3":0, "4":0, "5":0 }, 
											"NoelItem":
												{ "1":0, "2":0, "3":0, "4":0, "5":0 }
										};
		private var _giftServer:Array = [];
		public function EventSvc() 
		{
			initAllItem(dataItem);
			initRequire(ConfigJSON.getInstance().getItemInfo("Noel_Make")["Make"]);
		}
		public static function getInstance():EventSvc
		{
			if (_instance == null)
			{
				_instance = new EventSvc();
			}
			return _instance;
		}
		
		/**
		 * khởi tạo toàn bộ item dựa vào config
		 * @param	data
		 */
		private function initAllItem(data:Object):void
		{
			_oItem = new Object();
			var item:ItemCollectionInfo;
			for (var type:String in data)
			{
				_oItem[type] = new Object();
				for (var id:String in data[type])
				{
					item = ItemCollectionInfo.createItemInfo(type);
					item.ItemType = type;
					item.ItemId = int(id);
					item.Num = 0;
					_oItem[type][id] = item;
				}
			}
		}
		/**
		 * khởi tạo _oRequired
		 * @param	data
		 */
		public function initRequire(data:Object):void
		{
			_oRequired = new Object();
			_numRow = 0;
			for (var idRow:String in data)
			{
				_oRequired[idRow] = new Object();
				_numRow++;
				for (var idItem:String in data[idRow]["Require"])
				{
					_oRequired[idRow][idItem] = data[idRow]["Require"][idItem]["Num"];
				}
			}
		}
		/**
		 * khởi tạo dữ liệu cho event: list ItemCollectionIno
		 * @param	data
		 */
		public function initData(data:Object):void
		{
			var item:ItemCollectionInfo;
			for (var type:String in data)
			{
				for (var id:String in data[type])
				{
					item = _oItem[type][id] as ItemCollectionInfo;
					item.Num = int(data[type][id]);
				}
			}
		}
		
		public function updateItem(itemType:String, itemId:int, dNum:int):void
		{
			var item:ItemCollectionInfo = _oItem[itemType][itemId] as ItemCollectionInfo;
			item.Num += dNum;
		}
		
		public function getNumItem(itemType:String, itemId:int):int
		{
			var item:ItemCollectionInfo = _oItem[itemType][itemId] as ItemCollectionInfo;
			return item.Num;
		}
		public function getRequired(idRow:int, id:int):int
		{
			return _oRequired[idRow.toString()][id.toString()];
		}
		
		public function get NumRow():int 
		{
			return _numRow;
		}
		
		public function getListRequire():Object
		{
			return _oRequired;
		}
		
		public function getItemInfo(type:String, id:int):ItemCollectionInfo
		{
			return _oItem[type][id];
		}
		public function getListItem(type:String):Object
		{
			return _oItem[type];
		}
		public function getPrice(itemType:String, itemId:int, priceType:String):int 
		{
			return ConfigJSON.getInstance().getItemInfo("Noel_Candy")[itemType][itemId.toString()][priceType];
		}
		
		/**
		 * đổi quà: trừ đi số lượng của loại đem đi đổi
		 * @param	type : loại đem đi đổi
		 * @param	id : id của loại đem đi đổi
		 */
		public function changeGift(type:String, id:int, num:int = 1):void 
		{
			var idItem:String, iRequire:int;
			for (idItem in _oRequired[id])
			{
				iRequire = _oRequired[id][idItem] * num;
				updateItem(type, int(idItem), -iRequire);
			}
		}
		
		public function processGetGift(gift:AbstractGift, num:Number = 1):void 
		{
			var i:int;
			switch(gift.ItemType) 
			{
				case "Money":
					GameLogic.getInstance().user.UpdateUserMoney(num);
				break;
				case "ZMoney":
					GameLogic.getInstance().user.UpdateUserZMoney(num);
				break;
				case "Exp":
					GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + num, false, true);
				break;
				case "PowerTinh":
				case "Iron":
				case "Jade":
				case "SoulRock":
				case "SixColorTinh":
					GameLogic.getInstance().user.updateIngradient(gift.ItemType, num, gift.ItemId);
				break;
				case "Diamond":
					var curDiamond:int = GameLogic.getInstance().user.getDiamond();
					GameLogic.getInstance().user.setDiamond(curDiamond + num);
				break;
				case "NoelItem":
					updateItem(gift.ItemType, gift.ItemId, num);
				break;
			}
		}
		public function initGiftServer(data:Object):Array
		{
			var gift:AbstractGift;
			freeGiftServer();
			for (var sKind:String in data["Gifts"])
			{
				for (var sIndex:String in data["Gifts"][sKind])
				{
					var oGift:Object = data["Gifts"][sKind][sIndex];
					if (sKind == "Equipment")
					{
						gift = new GiftSpecial();
					}
					else
					{
						gift = new GiftNormal();
					}
					//gift = AbstractGift.createGift(oGift["ItemType"]);
					gift.setInfo(oGift);
					_giftServer.push(gift);
				}
			}
			return _giftServer;
		}
		public function initGiftServer2(data:Object, location:String):void
		{
			var gift:AbstractGift;
			freeGiftServer();
			for (var sKind:String in data[location])
			{
				for (var sIndex:String in data[location][sKind])
				{
					var oGift:Object = data[location][sKind][sIndex];
					if (sKind == "Equipment")
					{
						gift = new GiftSpecial();
					}
					else
					{
						gift = new GiftNormal();
					}
					//gift = AbstractGift.createGift(oGift["ItemType"]);
					gift.setInfo(oGift);
					_giftServer.push(gift);
				}
			}
		}
		public function initGiftServer3(data:Object, location:String):void
		{
			freeGiftServer();
			var gift:AbstractGift;
			var mainData:Object = data[location];
			var tempNormalData:Object = mainData["Normal"];
			var normalData:Object = GiftNormal.mergeGift(tempNormalData);
			var equipData:Object = mainData["Equipment"];
			var s:String;
			var oGift:Object;
			for (s in equipData)
			{
				oGift = equipData[s];
				gift = new GiftSpecial();
				gift.setInfo(oGift);
				_giftServer.push(gift);
			}
			_giftServer.sortOn("Color", Array.DESCENDING);
			//_giftServer.sortOn("Rank");
			for (s in normalData)
			{
				oGift = normalData[s];
				gift = new GiftNormal();
				gift.setInfo(oGift);
				_giftServer.push(gift);
			}
			
			
		}
		public function initGiftSavePoint(data:Object):void
		{
			var gift:AbstractGift;
			freeGiftServer();
			for (var sKind:String in data["Bonus"])
			{
				for (var sIndex:String in data["Bonus"][sKind])
				{
					var oGift:Object = data["Bonus"][sKind][sIndex];
					gift = AbstractGift.createGift(oGift["Type"]);
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
		
		public function getGiftServer():Array 
		{
			return _giftServer;
		}
		
		public function getMinNum(idRow:int):int
		{
			var oRequire:Object = _oRequired[idRow];
			var oItem:Object = _oItem["Candy"];
			var info:ItemCollectionInfo;
			var min:int = int.MAX_VALUE;
			var num:int;
			for (var id:String in oItem)
			{
				info = oItem[id];
				num = int(info["Num"] / oRequire[id]);
				if (num < min)
				{
					min = num;
				}
			}
			return min;
		}
		
		/**
		 * chia data đầu vào làm nhiều data nhỏ hơn với điều kiện tổng số lượng được bảo toàn
		 * @param	data dữ liệu đưa vào để chia
		 * @return data sau khi được chia
		 */
		public function splitData(data:Object):Object 
		{
			//return data;
			var temp:Object;
			var obj:Object;
			var num:int;
			var dem:int = 0;
			var o:Object = new Object();
			
			const c:int = 5;
			var b:int;
			for (var i:String in data)
			{
				temp = data[i];
				if (temp["Num"] > c)
				{
					num = int(temp["Num"] / c) + (temp["Num"] % c);
					dem++;
					obj = new Object();
					obj["ItemType"] = temp["ItemType"];
					obj["ItemId"] = temp["ItemId"];
					obj["Num"] = num;
					o[dem] = obj;
					b = c - 1;
					num = int(temp["Num"] / c);
				}
				else
				{
					num = 1;
					b = temp["Num"];
				}
				for (var j:int = 0; j < b; j++)
				{
					dem++;
					obj = new Object();
					obj["ItemType"] = temp["ItemType"];
					obj["ItemId"] = temp["ItemId"];
					obj["Num"] = num;
					o[dem] = obj;
				}
			}
			return o;
		}
		public function checkInEvent():Boolean
		{
			var config:Object = ConfigJSON.getInstance().GetItemList("Event");
			var beginTime:Number = config[EventMgr.NAME_EVENT]["BeginTime"];
			var endTime:Number = config[EventMgr.NAME_EVENT]["ExpireTime"] - 120;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			return (curTime >= beginTime && curTime <= endTime);
		}
	}

}















