package GUI.ItemGift 
{
	import flash.events.MouseEvent;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiTestItem extends GUIGetStatusAbstract 
	{
		static public const CMD_CLOSE:String = "cmdClose";
		private var _listGift:Array;
		private var _listItem:Array;
		public function GuiTestItem(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "";
			_imgThemeName = "GuiInputCodeSuccess_Theme_Multi";
			_urlService = "FakeService.testGetItem";
			_idPacket = Constant.CMD_SEND_TEST_GET_ITEM;
		}
		override protected function onInitGuiBeforeServer():void 
		{
			AddButton(CMD_CLOSE, "BtnThoat", 560, 12);
		}
		override protected function onInitData(data1:Object):void 
		{
			var info:AbstractGift;
			var temp:Object;
			_listGift = [];
			for (var i:String in data1["Gift"])
			{
				temp = data1["Gift"][i];
				info = AbstractGift.createGift(temp["ItemType"]);
				info.setInfo(temp);
				_listGift.push(info);
			}
		}
		override protected function onInitGuiAfterServer():void 
		{
			_listItem = [];
			var info:AbstractGift;
			var item:AbstractItemGift;
			var x:int = 93, y:int = 200;
			for (var i:int = 0; i < _listGift.length; i++)
			{
				info = _listGift[i];
				item = AbstractItemGift.createItemGift(info.ItemType, this.img, "GuiInputCodeSuccess_Slot1", x, y);
				item.initData(info);
				item.drawGift();
				_listItem.push(item);
				x += 100;
				if (i == 3)
				{
					x = 93;
					y += 90;
				}
			}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case CMD_CLOSE:
					Hide();
					break;
			}
		}
		override public function ClearComponent():void 
		{
			if (_listItem != null)
			{
				var i:int;
				var item:AbstractItemGift;
				for (i = 0; i < _listItem.length; i++)
				{
					item = _listItem[i];
					item.Destructor();
				}
				_listItem.splice(0, _listItem.length);
			}
			super.ClearComponent();
		}
	}

}

















