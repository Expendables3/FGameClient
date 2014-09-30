package GUI.EventBirthDay.EventLogic 
{
	import Data.ConfigJSON;
	import GUI.EventBirthDay.EventGUI.GUIReceiveGiftMagicLamp;
	import GUI.EventBirthDay.EventPackage.SendGetGiftMagicLamp;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class MagicLampMgr 
	{
		private var _wishingPoint:int;
		private var _wp:int;
		private var _listMagicLampItem:Array;
		private var _lastTimeReset:Number;				//thời gian reset wishing point lần cuối
		private var _recievedGift:Array;				//những quà đã nhận rồi
		
		private var _allGiftBeforeReset:Array=[];
		public var LightBlink:Boolean = false;
		static private var _instance:MagicLampMgr = null;
		
		static public function getInstance():MagicLampMgr {
			if (_instance == null)
			{
				_instance = new MagicLampMgr();
			}
			return _instance;
		}
		public function MagicLampMgr() 
		{
			_listMagicLampItem = new Array();
			_recievedGift = new Array();
		}
		
		public function initData(data:Object):void
		{
			_listMagicLampItem.splice(0, _listMagicLampItem.length);
			_recievedGift.splice(0, _recievedGift.length);
			_lastTimeReset = 0;
			_wishingPoint = 0;
			_wp = 0;
			/*init config*/
			var itemMagicLamp:MagicLampItemInfo;
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("BirthDayLight");
			for (var i:String in cfg)
			{
				itemMagicLamp = new MagicLampItemInfo();
				itemMagicLamp.Id = int(i);
				itemMagicLamp.setInfo(cfg[i]);
				_listMagicLampItem.push(itemMagicLamp);
			}
			WishingPoint = BirthDayItemMgr.getInstance().getNum();
			
			(_listMagicLampItem[0] as MagicLampItemInfo).MaxWP = (_listMagicLampItem[0] as MagicLampItemInfo).WishingPointNum;
			for (var ii:int = 1; ii < _listMagicLampItem.length; ii++)
			{
				var itm:MagicLampItemInfo = _listMagicLampItem[ii] as MagicLampItemInfo;
				var preItem:MagicLampItemInfo = _listMagicLampItem[ii - 1] as MagicLampItemInfo;
				itm.MaxWP = itm.WishingPointNum - preItem.WishingPointNum;
			}
			/*init from server*/
			if (data["EventList"])
			{
				if (data["EventList"]["BirthDay"])
				{
					if (data["EventList"]["BirthDay"]["Light"])
					{
						var lightData:Object = data["EventList"]["BirthDay"]["Light"];
						_lastTimeReset = lightData["LastTimeReset"];
						if (!Ultility.checkInDay(_lastTimeReset))//là lần đầu tiên trong ngày
						{
							//gửi lên server gói tin getGiftInLight để nhận quà về
							var pk:SendGetGiftMagicLamp = new SendGetGiftMagicLamp(true);
							Exchange.GetInstance().Send(pk);
						}
						_recievedGift = lightData["Gave"];
					}
				}
			}
			
			/*dựa vào _receiveGift để xác định itemMagicLamp nào có _isReceived = true*/
			for (var j:int = 0; j < _recievedGift.length; j++)
			{
				var idRecieve:int = _recievedGift[j];
				for (var k:int = 0; k < _listMagicLampItem.length; k++)
				{
					itemMagicLamp = _listMagicLampItem[k] as MagicLampItemInfo;
					if (itemMagicLamp.Id == idRecieve)
					{
						itemMagicLamp.IsReceived = true;
						break;
					}
				}
			}
			if (_recievedGift.length < LevelWish)
			{
				LightBlink = true;
			}
			else
			{
				LightBlink = false;
			}
			
			if (LevelWish == 0)
			{
				LightBlink = true;
			}
			_listMagicLampItem.sortOn("Id", Array.NUMERIC);
		}
		
		public function getItemByIndex(index:int):MagicLampItemInfo 
		{
			return _listMagicLampItem[index] as MagicLampItemInfo;
		}
		
		public function initGiftReceive(data1:Object):void 
		{
			_allGiftBeforeReset.splice(0, _allGiftBeforeReset.length);
			if (data1)
			{
				if (data1["GiftList"])
				{
					var data:Object = data1["GiftList"];
					initNormalGift(data["Normal"]);
					initSpecialGift(data["Special"]);
					if (_allGiftBeforeReset.length > 0)
					{
						var guiGift:GUIReceiveGiftMagicLamp = new GUIReceiveGiftMagicLamp(null, "");
						guiGift.Show(Constant.GUI_MIN_LAYER, 5);
					}
					
				}
			}
		}
		
		private function initNormalGift(data:Object):void
		{
			var tmp:AbstractGift;
			for (var str:String in data)
			{
				tmp = new GiftNormal();
				tmp.setInfo(data[str]);
				_allGiftBeforeReset.push(tmp);
			}
		}
		
		private function initSpecialGift(data:Object):void
		{
			var tmp:AbstractGift;
			for (var str:String in data)
			{
				tmp = new GiftSpecial();
				tmp.setInfo(data[str]);
				_allGiftBeforeReset.push(tmp);
			}
		}
		
		public function get ListItem():Array 
		{
			return _listMagicLampItem;
		}
		
		public function get NumItem():int 
		{
			return _listMagicLampItem.length;
		}
		
		public function get WishingPoint():int
		{
			return _wishingPoint;
		}
		
		public function set WishingPoint(value:int):void
		{
			_wishingPoint = value;
			var min:int = 99999;
			_wp = value;
			for (var i:int = 0; i < _listMagicLampItem.length; i++)
			{
				var itm:MagicLampItemInfo = _listMagicLampItem[i] as MagicLampItemInfo;
				var delta:int = value - itm.WishingPointNum;
				if (delta >= 0 && delta < min)
				{
					min = delta;
					_wp = delta;
				}
			}
		}
		
		public function get WP():int
		{
			return _wp;
		}
		public function get LevelWish():int
		{
			var level:int = 0;
			for (var i:int = 0; i < _listMagicLampItem.length; i++)
			{
				var itm:MagicLampItemInfo = _listMagicLampItem[i] as MagicLampItemInfo;
				if (_wishingPoint >= itm.WishingPointNum)
				{
					level++;
				}
			}
			return level;
		}
		
		public function countLevel(wp:int):int
		{
			var level:int = 0;
			for (var i:int = 0; i < _listMagicLampItem.length; i++)
			{
				var itm:MagicLampItemInfo = _listMagicLampItem[i] as MagicLampItemInfo;
				if (wp >= itm.WishingPointNum)
				{
						level++;
				}
			}
			return level;
		}
		
		public function get MaxWishingPoint():int
		{
			var index:int = LevelWish >= 7?6:LevelWish;
			return (_listMagicLampItem[index] as MagicLampItemInfo).WishingPointNum;
		}
		
		public function get MaxWP():int
		{
			var index:int = LevelWish >= 7?6:LevelWish;
			if (_listMagicLampItem.length == 0) 
				return ConfigJSON.getInstance().getItemInfo("BirthDayLight",1)["WishingPointNum"];
			else
				return (_listMagicLampItem[index] as MagicLampItemInfo).MaxWP;
		}
		
		public function getMaxWP():int 
		{
			return 0;
		}
		
		public function getLightBlink():Boolean 
		{
			//có quà chưa nhận => true
			return true;
			//hết quà => false
			
		}
		public function get ListAllGift():Array 
		{
			return _allGiftBeforeReset;
		}
		
		public function set ListAllGift(value:Array):void 
		{
			_allGiftBeforeReset = value;
		}
		
	}
	
}





























