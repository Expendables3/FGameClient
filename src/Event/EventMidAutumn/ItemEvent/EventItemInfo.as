package Event.EventMidAutumn.ItemEvent 
{
	import Data.Localization;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * Thông tin về item trong Event
	 * @author HiepNM2
	 */
	public class EventItemInfo extends AbstractGift 
	{
		private var _num:int;			//số lượng hiện có
		private var _buffStep:int;		//số +/- bước di chuyển
		private var _buffHealth:int;	//số +/- sức khỏe
		private var _numTimeUse:int;	//số lần + vào khi sử dụng
		private var _lastTimeUse:int;	//lần cuối cùng sử dụng giấy
		private var _timeReUse:int;		//đối với cuộn giấy
		private var _zmoney:int = 0;			//đối với can xăng, tên lửa, bộ sưu tập...
		private var _gold:int = 0;			//đối với can xăng, tên lửa, bộ sưu tập...
		private var _diamond:int = 0;			//đối với can xăng, tên lửa, bộ sưu tập...
		private var _typeMoney:String;
		
		public function EventItemInfo() 
		{
			ClassName = "EventItem";
		}
		override public function getImageName():String 
		{
			return "GuiHalloween_" + _itemType + _itemId;
			//return "GUIGameEventMidle8_" + _itemType + _itemId;
			//return "EventLuckyMachine_" + _itemType + _itemId;
			//return "IslandItem15";
		}

		override public function getTooltipText():String 
		{
			//var str:String = "Vỏ Sò May Mắn\nDùng trong Máy Quay Sò";
			var str:String = Localization.getInstance().getString(_itemType + _itemId);
			return str;
		}
		public function set Num(value:int):void 
		{
			_num = value;
		}
		public function get Num():int
		{
			return _num;
		}
		public function set MoveStep(value:int):void 
		{
			_buffStep = value;
		}
		
		public function set LastTimeUse(value:int):void 
		{
			_lastTimeUse = value;
		}
		public function get LastTimeUse():int 
		{
			return _lastTimeUse;
		}
		
		public function set CoolDown(value:int):void 
		{
			_timeReUse = value;
		}
		
		public function get TimeReUse():int 
		{
			return _timeReUse;
		}
		
		public function get ZMoney():int 
		{
			return _zmoney;
		}
		
		public function set ZMoney(value:int):void 
		{
			if (value > 0)
			{
				_typeMoney = "ZMoney";
			}
			_zmoney = value;
		}
		
		public function get Gold():int 
		{
			return _gold;
		}
		
		public function set Gold(value:int):void 
		{
			if (value > 0)
			{
				_typeMoney = "Gold";
			}
			_gold = value;
		}
		
		public function get Diamond():int 
		{
			return _diamond;
		}
		
		public function set Diamond(value:int):void 
		{
			if (value > 0)
			{
				_typeMoney = "Diamond";
			}
			_diamond = value;
		}
		public function get TypeMoney():String
		{
			return _typeMoney;
		}
		
		public function get BuffStep():int
		{
			return _buffStep;
		}
		
		override public function setInfo(data:Object):void 
		{
			for (var itm:String in data)
			{
				this[itm] = data[itm];
			}
		}
		
	}
}










































