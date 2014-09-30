package GUI.EventBirthDay.EventLogic 
{
	import flash.geom.Point;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class BirthdayCandleInfo 
	{
		public var ClassName:String;
		//config
		public var ItemType:String;				//loại nến
		public var BlowLimit:int;				//số lần thổi tối đa
		public var BlowZMoney:int;				//tiền 1 lần thổi
		public var Bonus:Object;				//quà nhận được khi thắp nến
		public var FireTime:int;				//thời gian từ lúc thắp -> lúc tắt
		public var Name:String;					//tên nến
		public var ItemId:int = -1;				// id của nến
		
		//server
		private var _burnLastTime:Number;			//thời điểm cuối cùng đốt nến 
		public var BurnNum:int;					//số lần đốt nến
		private var _blowed:Boolean;
		//public var Blowed:Boolean = false;		//đã thực hiện thổi nến?
		public var BlowNum:int;
		
		
		public function get Position():Point
		{
			var pos:Point = new Point();
			switch(ItemId)
			{
				case 1:
					pos.x = 540;
					pos.y = 500;
				break;
				case 2:
					pos.x = 715;
					pos.y = 485;
				break;
				case 3:
					pos.x = 880;
					pos.y = 460;
				break;
				default:
					pos.x = pos.y = 0;
			}
			return pos;
		}
		public function get PosFire():Point
		{
			var pos:Point = new Point();
			switch(ItemId)
			{
				case 1:
					pos.x = 25;
					pos.y = -45;
				break;
				case 2:
					pos.x = 29;
					pos.y = -12;
				break;
				case 3:
					pos.x = 47;
					pos.y = 18;
				break;
				default:
					pos.x = pos.y = 0;
			}
			return pos;
		}
		public function get PosFireOff():Point
		{
			var pos:Point = new Point();
			switch(ItemId)
			{
				case 1:
					pos.x = 24;
					pos.y = -11;
				break;
				case 2:
					pos.x = 28;
					pos.y = -10;
				break;
				case 3:
					pos.x = 37;
					pos.y = 2;
				break;
				default:
					pos.x = pos.y = 0;
			}
			return pos;
		}
		public function get Blowed():Boolean 
		{
			return _blowed;
		}
		
		public function set Blowed(value:Boolean):void 
		{
			_blowed = value;
		}
		
		public function get BurnLastTime():Number 
		{
			return _burnLastTime;
		}
		
		public function set BurnLastTime(value:Number):void 
		{
			_burnLastTime = value;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var passedTime:int = curTime - value;
			if (FireTime > 0) {
				_blowed = (passedTime >= FireTime);
			}
		}

		public function BirthdayCandleInfo() 
		{
			ClassName = "BirthdayCandleInfo";
			ItemType = "BirthDayCandle";
		}
		
		public function setInfo(data:Object):void
		{
			for (var tmp:String in data)
			{
				try
				{
					this[tmp] = data[tmp];
				}
				catch (err:Error)
				{
					//trace("Thiếu thuộc tính: " + tmp + " trong class " + this + " tìm tiếp trong config");
				}
			}
		}
		
		public function setConfig(data:Object, id:int):void
		{
			setInfo(data);
			ItemId = id;
		}
		
		public function clone():BirthdayCandleInfo
		{
			var objClone:BirthdayCandleInfo = new BirthdayCandleInfo();
			for (var tmp:String in this)
			{
				try {
					objClone[tmp] = this[tmp];
				}
				catch (err:Error)
				{
					trace("không clone được thuộc tính: " + tmp);
				}
			}
			return objClone;
		}
		
		public function canBurn(curTime:Number):Boolean
		{
			var passedTime:int = curTime - BurnLastTime;
			if (passedTime >= FireTime || BurnLastTime <= 0)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		public function getRemainTime(curTime:Number):String
		{
			var passedTime:int = curTime - BurnLastTime;
			var time:int = FireTime - passedTime;			//thời gian còn lại
			if (time <= 0) 
				return "00:00:00";
			var h:int = time / 3600;
			var dH:int = time % 3600;
			var m:int = dH / 60;
			var dM:int = dH % 60;
			var s:int = dM;
			var sh:String = (h < 10)?"0" + h:h.toString();
			var sm:String = (m < 10)?"0" + m:m.toString();
			var ss:String = (s < 10)?"0" + s:s.toString();
			return sh + ":" + sm + ":" + ss;
		}
		
		public function countRemain(curTime:Number):int
		{
			var passedTime:int = curTime - BurnLastTime;
			return FireTime - passedTime;
		}
		
		public function initBlowed():void 
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var passedTime:int = curTime - BurnLastTime;
			_blowed = (passedTime >= FireTime);
		}
		
		public function get IntevalTime():int
		{
			return ItemId * 17;
		}
	}

}
































