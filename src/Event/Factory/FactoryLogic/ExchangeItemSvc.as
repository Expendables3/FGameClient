package Event.Factory.FactoryLogic 
{
	import Event.Factory.FactoryPacket.SendExchangeItem;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ExchangeItemSvc 
	{
		private const TIME_TO_DELAY:int = 2;
		private static var _instance:ExchangeItemSvc = null;
		private var _listItemExchange:Object;
		public var UrlExchangeAPI:String;								//địa chỉ của service
		public var IdExchangeAPI:String;								//id của API
		private var timeExchange:Number;
		private var isUpdateForExchange:Boolean = false;
		private var _dataPacket:Object = null;
		
		public function ExchangeItemSvc() { }
		
		public static function getInstance():ExchangeItemSvc
		{
			if (_instance == null)
			{
				_instance = new ExchangeItemSvc();
			}
			return _instance;
		}
		
		/**
		 * hàm đổi item
		 * @param	... args tập các đối số -> liên quan đến các node của tree
		 * @param	num số lượng item exchange
		 * @param	fCondition hàm kiểm tra điều kiện exchange
		 * @return
		 */
		public function exchangeItem(... args, num:int, fCondition:Function = null):Boolean
		{
			if (fCondition != null)
			{
				if (!fCondition())//check dieu kien
				{
					return false;//khong du dieu kien
				}
			}
			
			GameUtils.batchToTree(_listItemExchange, num, args);
			isUpdateForExchange = true;
			timeExchange = GameLogic.getInstance().CurServerTime;
			return true;
		}
		
		/**
		 * gửi toàn bộ dữ liệu đã batch lại lên server
		 */
		public function sendAllExchangeAction():void
		{
			isUpdateForExchange = false;
			var marks:Array = [];
			var sendPacket:Function = function(params:Array, num:int):void
			{
				params.push(num);
				var pk:SendExchangeItem = SendExchangeItem.createExchangePacket(UrlExchangeAPI, IdExchangeAPI, params, _dataPacket);
				Exchange.getInstance().Send(pk);
			}
			EventUtils.exploreTree(_listItemExchange, marks, sendPacket);
			EventUtils.destructTree(_listItemExchange);
			_listItemExchange = null;
		}
		
		public function updateTime(curTime:Number):void 
		{
			if (isUpdateForExchange)
			{
				if (curTime - timeExchange > TIME_TO_DELAY)
				{
					sendAllExchangeAction();
				}
			}
		}
		
		public function set DataPacket(value:Object):void { _dataPacket = value; }
		
	}

}