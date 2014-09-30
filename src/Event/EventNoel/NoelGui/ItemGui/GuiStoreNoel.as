package Event.EventNoel.NoelGui.ItemGui
{
	import Event.EventNoel.NoelGui.ItemGui.Bullet.BulletScenario;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Mouse;
	import GUI.component.Button;
	import GUI.component.ListBox;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiStoreNoel extends GUIGetStatusAbstract
	{
		static public const CMD_CLOSE:String = "cmdClose";
		static public const CMD_NEXT:String = "cmdNext";
		static public const CMD_PREV:String = "cmdPrev";
		private var _listGift:ListBox;
		private var _listInfo:Array;
		private var btnNext:Button;
		private var btnPrev:Button;
		public var inHide:Boolean;
		public function GuiStoreNoel(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP)
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			_imgThemeName = "GuiStoreNoel_Theme";
			_urlService = "EventService.fireGun";
			_idPacket = Constant.CMD_SEND_FIRE_GUN;
		}
		
		public function set dataPacket(value:Object):void
		{
			_dataPacket = value;
		}
		
		override protected function onInitGuiBeforeServer():void
		{
			AddButton(CMD_CLOSE, "BtnThoat", 560, 8);
			_listGift = AddListBox(ListBox.LIST_X, 2, 4, 20, 10, false);
			_listGift.setPos(105, 175);
			//var tfTip:TextField = AddLabel("Bạn sẽ nhận được", 10, 10, 0x096791, 0, -1);
			AddImage("", "GuiStoreNoel_Tip", 127, 85, true, ALIGN_LEFT_TOP);
			//AddImage("", "GuiStoreNoel_ImgPeach", 30, 40, true, ALIGN_LEFT_TOP);
			btnNext = AddButton(CMD_NEXT, "GuiStoreNoel_BtnNext", 518, 245);
			btnPrev = AddButton(CMD_PREV, "GuiStoreNoel_BtnPrev", 38, 245);
			btnNext.SetVisible(false);
			btnPrev.SetVisible(false);
			Mouse.show();
			GameLogic.getInstance().MouseTransform("");
		}
		
		override protected function onInitData(data1:Object):void
		{
			if (_listInfo == null)
			{
				_listInfo = [];
			}
			else
			{
				_listInfo.splice(0, _listInfo.length);
			}
			var gift:AbstractGift;
			var i:String;
			var obj:Object;
			for (i in data1["Equipment"])
			{
				obj = data1["Equipment"][i];
				gift = AbstractGift.createGift(obj["Type"]);
				gift.setInfo(obj);
				_listInfo.push(gift);
			}
			for (i in data1["Normal"])
			{
				obj = data1["Normal"][i];
				gift = AbstractGift.createGift(obj["ItemType"]);
				gift.setInfo(obj);
				_listInfo.push(gift);
			}
			//BulletScenario.getInstance().flushAllFireInfo();
			AddImage("", "GuiStoreNoel_TipRound" + _dataPacket["BoardId"], 437, 86, true, ALIGN_LEFT_TOP);
			delete(_dataPacket["FireInfo"]);
			delete(_dataPacket["Key"]);
			delete(_dataPacket["BoardId"]);
		}
		
		override protected function onInitGuiAfterServer():void
		{
			for (var i:int = 0; i < _listInfo.length; i++)
			{
				var gift:AbstractGift = _listInfo[i];
				var itemGift:AbstractItemGift = AbstractItemGift.createItemGift(gift.ItemType, this.img, "GuiStoreNoel_ImgSlot");
				itemGift.initData(gift);
				itemGift.drawGift();
				_listGift.addItem("", itemGift, this);
			}
			updateStateBtnNextBack();
			Mouse.show();
			GameLogic.getInstance().MouseTransform("");
			inHide = false;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case CMD_CLOSE: 
					Hide();
					break;
				case CMD_NEXT: 
					_listGift.showNextPage();
					updateStateBtnNextBack();
					break;
				case CMD_PREV: 
					_listGift.showPrePage();
					updateStateBtnNextBack();
					break;
			}
		}
		
		private function updateStateBtnNextBack():void
		{
			var curPage:int = _listGift.curPage + 1;
			var totalPage:int = _listGift.getNumPage();
			if (totalPage <= 1)
			{
				btnNext.SetVisible(false);
				btnPrev.SetVisible(false);
			}
			else if (curPage == 1)
			{
				btnNext.SetVisible(true);
				btnPrev.SetVisible(true);
				btnNext.SetEnable(true);
				btnPrev.SetEnable(false);
			}
			else if (curPage == totalPage)
			{
				btnNext.SetVisible(true);
				btnPrev.SetVisible(true);
				btnNext.SetEnable(false);
				btnPrev.SetEnable(true);
			}
			else
			{
				btnNext.SetVisible(true);
				btnPrev.SetVisible(true);
				btnNext.SetEnable(true);
				btnPrev.SetEnable(true);
			}
		}
		
		override public function OnHideGUI():void
		{
			//if (GuiMgr.getInstance().guiHuntFish.IsVisible)
			//{
				GameLogic.getInstance().MouseTransform("EventNoel_ImgMouseTarget", 1, 0, 0, 0);
				Mouse.hide();
				inHide = true;
			//}
		}
		public function get DataReady():Boolean
		{
			return IsDataReady;
		}
	
	}

}