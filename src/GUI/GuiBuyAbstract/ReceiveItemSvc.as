package GUI.GuiBuyAbstract 
{
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.BasePacket;
	/**
	 * Service nhận item
	 * @author HiepNM2
	 */
	public class ReceiveItemSvc 
	{
		private const TIME_TO_DELAY:int = 2;
		private static var _instance:ReceiveItemSvc = null;
		private var _listItemReceive:Object;
		public var UrlReceiveAPI:String;
		public var IdReceiveAPI:String;
		private var timeReceive:Number;
		private var isUpdateForReceive:Boolean = false;
		private var _numItem:int;							//số lượng item tối đa có thể đổi
		private var _itemName:String;
		private var _data:Object = null;
		public function ReceiveItemSvc() { }
		public static function getInstance():ReceiveItemSvc
		{
			if (_instance == null)
			{
				_instance = new ReceiveItemSvc();
			}
			return _instance;
		}
		public function receiveItem(type:String, idRow:int, idCol:int):Boolean
		{
			if (_numItem == 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Không đủ vật phẩm", 310, 200, 1);
				return false;
			}
			mergeReceivePacket(type, idRow, idCol, 1);
			_numItem--;
			return true;
		}
		
		private function mergeReceivePacket(itemType:String, idRow:int, idCol:int, num:int = 1):void 
		{
			if (_listItemReceive == null)
			{
				_listItemReceive = new Object();
			}
			if (_listItemReceive[itemType] == null)
			{
				_listItemReceive[itemType] = new Object();
			}
			if (_listItemReceive[itemType][idRow] == null)
			{
				_listItemReceive[itemType][idRow] = new Object();
			}
			if (_listItemReceive[itemType][idRow][idCol] == null)
			{
				_listItemReceive[itemType][idRow][idCol] = 0;
			}
			_listItemReceive[itemType][idRow][idCol] += num;
			
			isUpdateForReceive = true;
			timeReceive = GameLogic.getInstance().CurServerTime;
		}
		
		public function sendReceiveAction():void
		{
			if (_listItemReceive == null)
			{
				return;
			}
			isUpdateForReceive = false;
			var type:String, idRow:String,idCol:String, num:int, pk:BasePacket;
			for (type in _listItemReceive)
			{
				for (idRow in _listItemReceive[type])
				{
					for (idCol in _listItemReceive[type][idRow])
					{
						num = _listItemReceive[type][idRow][idCol];
						pk = SendExchangeAbstract.createPacket(_itemName, 
																UrlReceiveAPI, IdReceiveAPI, 
																type, int(idRow), int(idCol), num, _data);
						Exchange.GetInstance().Send(pk);
						delete(_listItemReceive[type][idRow][idCol]);
					}
					delete(_listItemReceive[type][idRow]);
				}
				delete(_listItemReceive[type]);
			}
			_listItemReceive = null;
		}
		
		public function updateTime(curTime:Number):void 
		{
			if (isUpdateForReceive)
			{
				if (curTime - timeReceive > TIME_TO_DELAY)
				{
					sendReceiveAction();
				}
			}
		}
		
		public function set ItemName(value:String):void 
		{
			_itemName = value;
		}
		
		public function set NumItem(value:int):void 
		{
			_numItem = value;
		}
	}

}





























