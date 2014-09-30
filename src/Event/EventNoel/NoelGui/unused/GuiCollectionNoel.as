package Event.EventNoel.NoelGui.unused 
{
	import Effect.EffectMgr;
	import Event.EventNoel.NoelGui.ItemGui.ItemHunt;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import Event.EventNoel.NoelPacket.SendExchangeNoelItem;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Factory.FactoryGui.GuiCollectionAbstract;
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	import Event.Factory.FactoryPacket.SendExchangeGift;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	import NetworkPacket.BasePacket;
	
	/**
	 * GUI đổi các NoelItem lấy phần thưởng
	 * @author HiepNM2
	 */
	public class GuiCollectionNoel extends GuiCollectionAbstract 
	{
		private const CMD_TAB:String = "cmdTab";
		private const CMD_RECEIVE:String = "cmdReceive";
		private var curTabId:int;
		private var tfTipTab:TextField;
		private var tfTipReceive:TextField;
		private var btnReceive1:Button;
		private var btnReceive2:Button;
		private var btnReceive3:Button;
		private var _listGift:Array = [];//quà từ các tab quà
		private var _listItem:Array = [];
		private var inReceiveSpecial:Boolean = false;
		public function GuiCollectionNoel(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiCollectionNoel";
			ThemeName = "GuiExchangeNoelGift_Theme";
			
		}
		override protected function onInitGui():void 
		{
			/*vẽ ra tất cả các tab*/
			AddButton(ID_BTN_CLOSE, "BtnThoat", 762, 19);
			var x:int = 50, y:int = 88;
			_listItem = [];
			var item:ItemCollectionEvent, info:ItemCollectionInfo;
			for (var i:int = 1; i <= 6; i++)
			{
				info = EventSvc.getInstance().getItemInfo("HuntItem", i);
				item = ItemCollectionEvent.createItemEvent(info.ItemType, this.img,
														"KhungFriend", 
														x, y);
				item.initData(info);
				item.drawGift();
				(item as ItemHunt).setButtonMode(true);
				item.EventHandler = this;
				item.IdObject = CMD_TAB + "_" + i;
				_listItem.push(item);
				x += 97;
			}
			x = 201;
			for (i = 1; i <= 3; i++)
			{
				this["btnReceive" + i] = AddButton(CMD_RECEIVE + "_" + i,
													"GuiCollectionTeacher_BtnReceive",
													x, 544);
				x += 146;
			}
			tfTipTab = AddLabel("", 330, 410);
			var fm:TextFormat = new TextFormat("Arial", 12, 0x096791, true);
			tfTipTab.defaultTextFormat = fm;
			tfTipReceive = AddLabel("", 650, 450);
			fm = new TextFormat("Arial", 12, 0x096791, true);
			tfTipReceive.defaultTextFormat = fm;
			curTabId = 1;
			changeTab(1);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (Ultility.IsOtherDay(EventSvc.getInstance().logTime, GameLogic.getInstance().CurServerTime))
			{
				//trace("qua ngày");
			}
			super.OnButtonClick(event, buttonID);
			if (inReceiveSpecial) return;
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			var type:String, id:int, num:int;
			var pk:BasePacket, ans:int;
			var gift:AbstractGift;
			switch(cmd)
			{
				case CMD_TAB:
					if (inReceiveGift) return;
					if (curTabId != int(data[1]))
					{
						(_listItem[curTabId - 1] as ItemHunt).setButtonMode(true);
						curTabId = int(data[1]);
						changeTab(curTabId);
					}
					break;
				case CMD_RECEIVE:
					id = curTabId;
					ans = int(data[1]);
					type = "NodeGift";
					num = 1;
					pk = SendExchangeGift.createPacketExchagne(type, id, type, num);
					(pk as SendExchangeNoelItem).Index = ans;
					gift = EventNoelMgr.getInstance().getGift(id, ans);
					if (Ultility.categoriesGift(gift.ItemType) == 0)//nhận quà thường
					{
						//(pk as SendExchangeNoelItem).IsNormalGift = true;
						EffectMgr.setEffBounceDown("Nhận Thành Công", gift.getImageName(), 330, 280, null, num * gift["Num"]);
					}
					else
					{
						inReceiveSpecial = true;
					}
					Exchange.GetInstance().Send(pk);
					EventSvc.getInstance().updateItem("NodeGift", id, -num);
					EventSvc.getInstance().processGetGift(gift, gift["Num"] * num);
					effText((_listItem[id - 1] as ItemCollectionEvent).img, 25, 105, 25, 95, "-", num);
					(_listItem[id - 1] as ItemCollectionEvent).refreshTextNum();
					tfTipReceive.text = getTipReceive(id);
					updateAllButtonReceive(id);
					break;
			}
		}
		private function updateAllButtonReceive(id:int):void 
		{
			var numChar:int = EventSvc.getInstance().getNumItem("HuntItem", id);
			var btnReceive:Button;
			for (var i:int = 1; i <= 3; i++)
			{
				btnReceive = this["btnReceive" + i];
				btnReceive.SetEnable(numChar > 0);
			}
		}
		private function changeTab(idTab:int):void
		{
			removeAllTabGift();
			tfTipTab.text = getTipTab(idTab);
			tfTipReceive.text = getTipReceive(idTab);
			var x:int = 187, y:int = 318;
			var listGift:Array = EventNoelMgr.getInstance().getTabGift(idTab);
			var numChar:int = EventSvc.getInstance().getNumItem("HuntItem", idTab);
			var btnReceive:Button, temp:AbstractGift, itemGift:AbstractItemGift;
			for (var i:int = 0; i < listGift.length; i++)
			{
				temp = listGift[i];
				itemGift = AbstractItemGift.createItemGift(temp.ItemType, this.img,
															"GuiExchangeNoelGift_ImgSlotGift",
															x, y, true);
				itemGift.initData(temp, "", 136, 157);
				itemGift.setPosBuff(0, -11);
				itemGift.xNum = 12;
				itemGift.yNum = 110;
				itemGift.hasTooltipImg = false;
				itemGift.hasTooltipText = true;
				itemGift.drawGift();
				itemGift.addNum(12, 102, 12, 0xffffff);
				_listGift.push(itemGift);
				btnReceive = this["btnReceive" + (i + 1)];
				btnReceive.SetVisible(true);
				btnReceive.SetEnable(numChar > 0);
				img.swapChildren(itemGift.img, btnReceive.img);
				x += 147;
			}
			(_listItem[idTab - 1] as ItemHunt).setButtonMode(false);
		}
		
		
		
		private function getTipTab(idTab:int):String 
		{
			return "";
		}
		
		private function getTipReceive(idTab:int):String	 
		{
			return "";
		}
		
		private function removeAllTabGift():void
		{
			var item:AbstractItemGift;
			for (var i:int = 0; i < _listGift.length; i++)
			{
				item = _listGift[i];
				item.Destructor();
			}
			_listGift.splice(0, _listGift.length);
		}
		
		override public function ClearComponent():void 
		{
			for (var i:int = 0; i < _listItem.length; i++)
			{
				var item:ItemCollectionEvent = _listItem[i];
				item.Destructor();
			}
			_listItem.splice(0, _listItem.length);
			removeAllTabGift();
			super.ClearComponent();
		}
		
		public function proccessGetSpecial(data1:Object, oldData:Object):void 
		{
			EventSvc.getInstance().initGiftServer2(data1, "Bonus");
			var num:int = EventSvc.getInstance().getGiftServer().length;
			GuiMgr.getInstance().guiGiftEventNoel.setNumSlot(num);
			GuiMgr.getInstance().guiGiftEventNoel.Show(Constant.GUI_MIN_LAYER, 5);
			inReceiveSpecial = false;
		}
	}

}






















