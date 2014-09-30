package Event.EventNoel.NoelGui 
{
	import Event.EventNoel.NoelGui.ItemGui.ItemNoel;
	import Event.EventNoel.NoelLogic.ItemInfo.NoelItemInfo;
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import Event.Factory.FactoryLogic.EventSvc;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * Gui Show Những vật phẩm có được khi săn cá
	 * @author HiepNM2
	 */
	public class GuiExchangeNoelCollection extends BaseGUI 
	{
		static public const CMD_CLOSE:String = "cmdClose";
		static public const CMD_RECEIVE:String = "cmdReceive";
		
		private var _listItemCollection:Array;
		public var inHide:Boolean;
		public function GuiExchangeNoelCollection(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiExchangeNoelCollection";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height/2);
				AddButton(CMD_CLOSE, "BtnThoat", 545, 25);
				var info:NoelItemInfo, item:ItemNoel;
				var x:int = 60;
				_listItemCollection = [];
				for (var i:int = 1; i <= 5; i++)
				{
					info = EventSvc.getInstance().getItemInfo("NoelItem", i) as NoelItemInfo;
					item = ItemCollectionEvent.createItemEvent("NoelItem", this.img, "EventNoel_ImgSlot", x, 120) as ItemNoel;
					item.initData(info);
					item.drawGift();
					_listItemCollection.push(item);
					AddButton(CMD_RECEIVE + "_" + i, "GuiExchangeNoelItem_BtnReceive", x - 4, 215);
					x += 100;
				}
				inHide = false;
				Mouse.show();
				GameLogic.getInstance().MouseTransform("");
			}
			LoadRes("GuiExchangeNoelItem_CollectionTheme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			//kiểm tra xem có hết event chưa?
			if (!EventSvc.getInstance().checkInEvent())
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết thời gian diễn ra event", 310, 200, 1);
				Hide();
				return;
			}
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case CMD_CLOSE:
					Hide();
					break;
				case CMD_RECEIVE:
					var id:int = int(data[1]);
					receiveGift(id);
					break;
			}
		}
		
		private function receiveGift(id:int):void 
		{
			GuiMgr.getInstance().guiExchangeNoelItem.IdRow = id;
			GuiMgr.getInstance().guiExchangeNoelItem.Show(Constant.GUI_MIN_LAYER, 5);
		}
		override public function ClearComponent():void 
		{
			if (_listItemCollection != null && _listItemCollection.length > 0)
			{
				for (var i:int = 0; i < _listItemCollection.length; i++)
				{
					var item:ItemNoel = _listItemCollection[i];
					item.Destructor();
				}
				_listItemCollection.splice(0, _listItemCollection.length);
			}
			super.ClearComponent();
		}
		override public function OnHideGUI():void 
		{
			if (GuiMgr.getInstance().guiHuntFish.IsVisible)
			{
				GameLogic.getInstance().MouseTransform("EventNoel_ImgMouseTarget", 1, 0, 0, 0);
				Mouse.hide();
				inHide = true;
			}
		}
		
		public function refreshTextNumAt(idRow:int):void 
		{
			var item:ItemNoel = _listItemCollection[idRow - 1];
			item.refreshTextNum();
		}
	}

}

















