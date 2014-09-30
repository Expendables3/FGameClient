package GUI.EventBirthDay.EventGUI 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.Event8March.GUIEventCongrate;
	import GUI.EventBirthDay.EventLogic.BirthdayItem;
	import GUI.EventBirthDay.EventLogic.BirthDayItemMgr;
	import GUI.EventBirthDay.EventPackage.SendBuyBirthDayItem;
	import GUI.EventBirthDay.EventPackage.SendOpenBirtDayBox;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.User;
	import NetworkPacket.PacketSend.SendLoadInventory;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIChangeBirthdayGift extends BaseGUI 
	{
		// const
		static public const ID_BTN_CLOSE:String = "idBtnClose";
		static public const ID_BTN_GUIDE:String = "idBtnGuide";
		static public const CMD_REMIND:String = "cmdRemind";
		static public const CMD_BUY:String = "cmdBuy";
		static public const CMD_CHANGE:String = "cmdChange";
		// logic
		private var BirthDayItemArr:Array = [];
		public var BirthDayGiftArr:Array = [];
		// gui
		private var _guiGuide:GUIGuideBirthday;
		private var guiCongrate:GUICongrateEventBirthday = new GUICongrateEventBirthday(null, "");
		public function GUIChangeBirthdayGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIChangeBirthdayGift";
		}
		override public function InitGUI():void 
		{
			LoadRes("GUIChangeFlower");
			if(_guiGuide==null)
				_guiGuide = new GUIGuideBirthday(null, "");
			SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
			addBgr();
			addAllItemBirthDay();
			var obj:Object = BirthDayItemMgr.getInstance().ObjBirthDay;
			addAllGift();
			setBtnChange();
		}
		
		private function addAllGift():void 
		{
			var x:int = 595, y:int = 115;
			for (var i:int = 1; i <= 3; i++)
			{
				addGift(i, x, y);
				y += 150;
			}
		}
		
		private function addGift(idRow:int, x:int, y:int):void 
		{
			var itemGift:ItemBirthDayGift = new ItemBirthDayGift(this.img, "KhungFriend", x, y);
			itemGift.IdRow = idRow;
			itemGift.EventHandler = this;
			itemGift.DrawItem();
			BirthDayGiftArr.push(itemGift);
		}
		
		private function addAllItemBirthDay():void 
		{
			var obj:Object = BirthDayItemMgr.getInstance().ObjBirthDay;
			var i:int, j:int;
			for (i = 1; i <= 3; i++)
			{
				for (j = 1; j <= 4; j++)
				{
					var id:int = j + 9;
					addItemBirthDay(i, j, BirthDayItemMgr.getInstance().ObjBirthDay[id] as BirthdayItem);
				}
				addItemBirthDay(i, 5, BirthDayItemMgr.getInstance().ObjBirthDay[i] as BirthdayItem);
			}
		}
		
		private function addItemBirthDay(row:int, col:int, birthDayItem:BirthdayItem):void 
		{
			var itemBirthDay:ItemBirthDay = new ItemBirthDay(this.img, "KhungFriend");
			itemBirthDay.initData(row, col, birthDayItem);
			itemBirthDay.EventHandler = this;
			itemBirthDay.drawItem();
			BirthDayItemArr.push(itemBirthDay);
		}
		
		
		
		private function addBgr():void 
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 707, 19);
			AddButton(ID_BTN_GUIDE, "EventBirthday_BtnGuide", 663, 19);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var id:int = (int)(data[1]);
			
			switch(command)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_GUIDE:
					_guiGuide.Show(Constant.GUI_MIN_LAYER, 6);
				break;
				case CMD_REMIND:
					remindFriend();
				break;
				case CMD_BUY:
					buyItem(id, int(data[2]));
				break;
				case CMD_CHANGE:
					changeGift(id);
				break;
			}
		}
		
		private function changeGift(id:int):void 
		{
			//send dữ liệu lên server
			var pk:SendOpenBirtDayBox = new SendOpenBirtDayBox(id);
			Exchange.GetInstance().Send(pk);
			
			//trừ số lượng các item
			BirthDayItemMgr.getInstance().changeGift(id);
			setBtnChange();
			//hiển thị quà
		}
		
		private function buyItem(id:int, zmoney:int):void 
		{
			var _user:User = GameLogic.getInstance().user;
			var myMoney:int = _user.GetMyInfo().ZMoney;
			
			if (myMoney >= zmoney)
			{
				var objTemp:Object = new Object();
				objTemp["ItemType"] = "BirthDayItem";
				objTemp["Event"] = "BirthDay";
				objTemp["ItemId"] = id;
				objTemp["Num"] = 1;

				var pk:SendBuyBirthDayItem = new SendBuyBirthDayItem(objTemp);
				Exchange.GetInstance().Send(pk);
				_user.UpdateUserZMoney(0 - zmoney);
				//_user.UpdateStockThing("BirthDayItem", id, 1);
				//effect mua thành công
				EffectMgr.setEffBounceDown("Mua thành công", "BirthDayItem" + id, 330, 280);
				BirthDayItemMgr.getInstance().setNum(id, 1, true);
				setBtnChange();
			}
			else
			{
				GuiMgr.getInstance().GuiNapG.Init();
			}
		}
		
		private function setBtnChange():void 
		{
			var i:int, isEnable:Boolean;
			for (i = 1; i <= 3; i++)
			{
				var temp:Object = ConfigJSON.getInstance().getItemInfo("BirthDayGiftBox", i);
				isEnable = true;
				var itemGift:ItemBirthDayGift = BirthDayGiftArr[i - 1] as ItemBirthDayGift;
				for (var j:int = 1; j <= 5; j++)
				{
					var objBirthDay:Object = BirthDayItemMgr.getInstance().ObjBirthDay;
					var id:int = (j + 9 > 13)?i:(j + 9);
					var birthdayItem:BirthdayItem = objBirthDay[id] as BirthdayItem;
					var maxNum:int = temp["Input"][j]["Num"];
					isEnable = isEnable && (birthdayItem.Num >= maxNum);
				}
				itemGift.setEnableChange(isEnable);
			}
		}
		
		private function remindFriend():void 
		{
			var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var today:String = date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString();
			var so:SharedObject = SharedObject.getLocal("PressRemind" + GameLogic.getInstance().user.GetMyInfo().Id);
			var data:Object;
			if (so.data.uId != null)//đã feed nhờ bạn ít nhất 1 lần => chắc chắn có lastday
			{
				data = so.data.uId;
				if (data.lastDay != today)//chưa bấm feed hôm nay
				{
					trace("hiện guifeed ---- chưa feed hôm nay");
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_REMIND_FRIEND);
				}
			}
			else//chưa feed nhờ bạn lần nào trong đời
			{
				trace("hiện guifeed ---- chưa feed lần nào trong đời");
				GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_REMIND_FRIEND);
			}
		}
		
		
		
		public function getItemBirthDay(row:int, col:int):ItemBirthDay 
		{
			var index:int = (row - 1) * 5 + (col - 1);
			return (BirthDayItemArr[index] as ItemBirthDay);
		}
		
		public function changeRemindToBuy():void 
		{
			for (var i:int = 0; i < BirthDayItemArr.length; i++)
			{
				var itemBirthday:ItemBirthDay = BirthDayItemArr[i] as ItemBirthDay;
				if (itemBirthday.ItemId == 13)
				{
					itemBirthday.changeRemindToBuy();
				}
			}
		}
		
		private function removeAllItemBirthDay():void 
		{
			for (var i:int = 0; i < BirthDayItemArr.length; i++)
			{
				var itemBirthDay:ItemBirthDay = BirthDayItemArr[i] as ItemBirthDay;
				itemBirthDay.Destructor();
			}
			BirthDayItemArr.splice(0, BirthDayItemArr.length);
		}
		
		private function removeAllBirthDayGift():void 
		{
			for (var i:int = 0; i < BirthDayGiftArr.length; i++)
			{
				var giftBirthDay:ItemBirthDayGift = BirthDayGiftArr[i] as ItemBirthDayGift;
				giftBirthDay.Destructor();
			}
			BirthDayGiftArr.splice(0, BirthDayGiftArr.length);
		}
		
		override public function Hide():void 
		{
			removeAllBirthDayGift();
			removeAllItemBirthDay();
			if (_guiGuide)
			{
				if (_guiGuide.img)
				{
					if (_guiGuide.img.visible)
					{
						_guiGuide.Hide();
					}
					_guiGuide.Destructor();
				}
				_guiGuide = null;
			}
			super.Hide();
		}
		
		public function receiveGift(data:Object):void 
		{
			var imName:String;
			//trace ("feed lên tường -------------- id = " );
			var gift:AbstractGift;
			var i:String;
			if (data["Special"] is Array && data["Normal"] is Object)
			{//nhận quà thường
				gift = new GiftNormal();
				for (i in data["Normal"])
				{
					gift.setInfo(data["Normal"][i]);
				}
				imName = gift.getImageName();
				EffectMgr.setEffBounceDown("Nhận thành công", imName, 330, 280);
				if ((gift as GiftNormal).ItemType == "PowerTinh")
				{
					if (GameLogic.getInstance().user.ingradient != null)
					{
						GameLogic.getInstance().user.ingradient["PowerTinh"] += (gift as GiftNormal).Num;
					}
				}
				else 
				{
					if ((gift as GiftNormal).ItemType != "Gem")
					{
						var giftN:GiftNormal = gift as GiftNormal;
						if (GuiMgr.getInstance().GuiStore)
						{
							if (GuiMgr.getInstance().GuiStore.img)
							{
								if (GuiMgr.getInstance().GuiStore.img.visible)
								{
									GuiMgr.getInstance().GuiStore.UpdateStore(giftN.ItemType, giftN.ItemId, giftN.Num);
								}
							}
						}
					}
				}
			}
			else if (data["Normal"] is Array && data["Special"] is Object)
			{//nhận quà khủng
				gift = new GiftSpecial();
				for (i in data["Special"])
				{
					gift.setInfo(data["Special"][i]);
				}
				guiCongrate.initData(gift);
				guiCongrate.Show(Constant.GUI_MIN_LAYER, 5);
				GameLogic.getInstance().user.GenerateNextID();
				return;
			}
			
			//trace("nhận dữ liệu từ server trả về");
		}
		
	}

}






















