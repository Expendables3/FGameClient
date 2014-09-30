package GUI.GuiBuyAbstract 
{
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.BasePacket;
	/**
	 * Service mua item
		* input cần thiết:	UrlBuyAPI và IdBuyAPI
	 * @author HiepNM2
	 */
	public class BuyItemSvc 
	{
		static public const TIME_TO_DELAY:int = 2;
		static private var _instance:BuyItemSvc = null;
		private var _listItemBuy:Object;
		private var timeBuy:Number;
		private var isUpdateForBuy:Boolean = false;
		public var dataBuff:Object;
		public var UrlBuyAPI:String;
		public var IdBuyAPI:String;
		
		public function BuyItemSvc() {}
		
		static public function getInstance():BuyItemSvc
		{
			if (_instance == null)
			{
				_instance = new BuyItemSvc();
			}
			return _instance;
		}
		public function buyItem(type:String, id:int, priceType:String, price:int):Boolean 
		{
			if (!Ultility.payMoney(priceType, price))
			{
				return false;
			}
			mergeBuyPacket(type, id, 1, priceType);
			return true;
		}
		private function mergeBuyPacket(itemType:String, itemId:int, num:int = 1, priceType:String = "ZMoney"):void
		{
			if (_listItemBuy == null)
			{
				_listItemBuy = new Object();
			}
			if (_listItemBuy[itemType] == null)
			{
				_listItemBuy[itemType] = new Object();
			}
			if (_listItemBuy[itemType][itemId] == null)
			{
				_listItemBuy[itemType][itemId] = new Object();
			}
			if (_listItemBuy[itemType][itemId][priceType] == null)
			{
				_listItemBuy[itemType][itemId][priceType] = 0;
			}
			_listItemBuy[itemType][itemId][priceType] += num;
			
			isUpdateForBuy = true;
			timeBuy = GameLogic.getInstance().CurServerTime;
		}
		
		public function sendBuyAction():void
		{
			if (_listItemBuy == null)
			{
				return;
			}
			isUpdateForBuy = false;
			var type:String, id:String, priceType:String, num:int, pk:BasePacket;
			for (type in _listItemBuy)
			{
				for (id in _listItemBuy[type])
				{
					for (priceType in _listItemBuy[type][id])
					{
						num = _listItemBuy[type][id][priceType];
						pk = SendBuyAbstract.createPacket(UrlBuyAPI, IdBuyAPI, 
													type, int(id), 
													num, priceType,dataBuff);
						Exchange.GetInstance().Send(pk);
					}
					_listItemBuy[type][id] = null;
				}
				_listItemBuy[type] = null;
			}
			_listItemBuy = null;
		}
		
		public function updateTime(curTime:Number):void 
		{
			if (isUpdateForBuy)
			{
				if (curTime - timeBuy > TIME_TO_DELAY)
				{
					sendBuyAction();
				}
			}
		}
	}

}