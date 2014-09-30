package GUI.EventBirthDay.EventGUI 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.EventBirthDay.EventLogic.BirthdayItem;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemBirthDay extends Container 
	{
		static public const CMD_BUY:String = "cmdBuy";
		static public const CMD_REMIND:String = "cmdRemind";
		static public const BUFFX:int = 95;
		static public const BUFFY:int = 150;
		// logic
		private var _idCol:int;
		private var _idRow:int;
		private var _birthDayItem:BirthdayItem;//reference to a object in _objBirthDay of BirthDayItemMgr class
		// gui
		private var _image:ButtonEx;
		private var _tfNum:TextField;
		private var btnBuy:Button;
		private var btnRemind:Button;
		private var _formatRed:TextFormat;
		private var _formatGreen:TextFormat;
		
		public function ItemBirthDay(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemBirthDay";
			_formatGreen = new TextFormat("arial", 14);
			_formatGreen.color = 0xFFFFFF;
			_formatRed = new TextFormat("arial", 14);
			_formatRed.color = 0xFF0000;
		}
		
		public function initData(idRow:int, idCol:int, birthdayItem:BirthdayItem):void
		{
			_idRow = idRow;
			_idCol = idCol;
			_birthDayItem = birthdayItem;
		}
		
		public function get MaxNum():int 
		{
			var config:Object = ConfigJSON.getInstance().getItemInfo("BirthDayGiftBox", _idRow)["Input"];
			return config[_idCol]["Num"];
		}
		public function get ItemId():int
		{
			return _birthDayItem.ItemId;
		}
		public function drawItem():void 
		{
			IdObject = "";
			SetPos(105 + (_idCol - 1) * BUFFX, 130 + (_idRow - 1) * BUFFY);
			// ảnh
			var slot:Image = AddImage("", "EventBirthday_ImgSlot", 0, 30);
			_image = AddButtonEx("", _birthDayItem.ImageName, 0, 0);
			_image.SetAlign(Image.ALIGN_CENTER_CENTER);
			var priceTable:Image = AddImage("", "Num_Bg", 15, 57);
			priceTable.SetScaleX(_birthDayItem.getScalePriceTable());
			if (_birthDayItem.getScalePriceTable() == 1)
			{
				priceTable.img.x -= 13;
			}
			if (_birthDayItem.getScalePriceTable() == 0.8)
			{
				priceTable.img.x -= 8;
			}
			
			priceTable.SetScaleY(0.65);
			//lable
			var str:String = _birthDayItem.Num + " / " + MaxNum;
			_tfNum = AddLabel(str, -50, 42, 0xffffff, 1, 0x000000);
			if (_birthDayItem.Num < MaxNum)
			{
				_tfNum.setTextFormat(_formatRed);
			}
			else
			{
				_tfNum.setTextFormat(_formatGreen);
			}
			// nút
			if (_birthDayItem.ItemId != 13)
			{
				btnBuy = AddButton(CMD_BUY + "_" + _birthDayItem.ItemId + "_" + _birthDayItem.ZMoney,
									"EventBirthday_BtnBuy", -35, 74, EventHandler);
				if (_birthDayItem.UnlockType == 6)
				{
					btnBuy.SetVisible(false);
				}
				else
				{
					AddLabel(_birthDayItem.ZMoney.toString(), -39, 76, 0xFFFFFF, 1, 0x000000);
				}
			}
			else
			{
				addRemindFriend( -35, 74, _birthDayItem.ZMoney, _birthDayItem.ItemId);
			}
			addTooltip();
		}
		
		private function addRemindFriend(x:int, y:int, zMoney:int, itemId:int):void 
		{
			var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var today:String = date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString();
			var so:SharedObject = SharedObject.getLocal("PressRemind" + GameLogic.getInstance().user.GetMyInfo().Id);
			var data:Object;
			if (so.data.uId != null)//đã feed nhờ bạn ít nhất 1 lần
			{
				data = so.data.uId;
				if (data.lastday != today)//chưa feed nhờ bạn hôm nay
				{
					trace("thêm nút nhờ bạn ---- chưa feed hôm nay");
					btnRemind = AddButton(CMD_REMIND, "EventBirthday_NhoBan", x, y,EventHandler);
				}
				else//đã feed nhờ bạn hôm nay
				{
					trace("thêm nút mua ---- đã feed hôm nay");
					btnBuy = AddButton(CMD_BUY+"_" + itemId + "_" + zMoney, "EventBirthday_BtnBuy", x, y,EventHandler);
					AddLabel(zMoney.toString(), x - 5, y, 0xFFFFFF, 1, 0x000000);
				}
			}
			else//chưa feed nhờ bạn lần nào trong đời
			{
				btnRemind = AddButton(CMD_REMIND, "EventBirthday_NhoBan", x, y,EventHandler);
				trace("thêm nút nhờ bạn ---- chưa feed lần nào trong đời");
			}
		}
		
		public function changeRemindToBuy():void 
		{
			btnRemind.SetVisible(false);
			btnBuy = AddButton(CMD_BUY + "_" + ItemId + "_" + _birthDayItem.ZMoney,
								"EventBirthday_BtnBuy", -35, 74, EventHandler);
			AddLabel(_birthDayItem.ZMoney.toString(), -39, 76, 0xFFFFFF, 1, 0x000000);
		}
		
		public function updateNum():void
		{
			/*vẽ lại cái lable*/
			_tfNum.text = _birthDayItem.Num + " / " + MaxNum;
			if (_birthDayItem.Num < MaxNum)
			{
				_tfNum.setTextFormat(_formatRed);
			}
			else
			{
				_tfNum.setTextFormat(_formatGreen);
			}
			//if (_birthDayItem.Num < MaxNum)
			//{
				//_tfNum.setTextFormat(_formatRed);
			//}
			//else
			//{
				//_tfNum.setTextFormat(_formatGreen);
			//}
		}
		public function addTooltip():void
		{
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = Localization.getInstance().getString(_birthDayItem.ItemType + _birthDayItem.ItemId);
			_image.setTooltip(tip);
		}
	}
}

































