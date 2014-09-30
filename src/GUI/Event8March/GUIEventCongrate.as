package GUI.Event8March 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.GiftSpecial;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIEventCongrate extends BaseGUI 
	{
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_FEED:String = "idBtnFeed";
		private const ID_BTN_RECEIVE:String = "idBtnReceive";
		private var _parent:GUIChangeFlower;
		private var _data:Object;			//dữ liệu về quà nhận được
		public function GUIEventCongrate(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIEventCongrate";
		}
		override public function InitGUI():void 
		{
			LoadRes("Event_8_3_GUICongrat");
			SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height/2);
			AddButton(ID_BTN_CLOSE, "BtnThoat", 368, 27);
			//AddButton(ID_BTN_FEED, "BtnFeed", 140, 260);
		}
		public function initLogic(value:Object):void
		{
			_data = value;
		}
		public function showGui(data:Object):void
		{
			_data = data;
			var giftS:GiftSpecial = new GiftSpecial();
			giftS.setInfo(data);
			
			Show(Constant.GUI_MIN_LAYER, 5);
			var iGiftS:ItemSpecialGift = new ItemSpecialGift(this.img, "KhungFriend", 0, 0);
			iGiftS.initData(giftS, "", 0, 0, false);
			iGiftS.drawGift();
			var pos:Point = new Point(155, 135);
			iGiftS.FitRect(81, 78, pos);
			//var nameIm:String = data["Type"] + data["Rank"] + "_Shop";
			//var nameEff:String = "Event_8_3_Eff_GuiCongrate_" + data["Color"];
			//add cai anh va effect
			//var pos:Point = new Point(164, 140);
			//var eff:Image = AddImage("", nameEff, 0, 0);
			//eff.FitRect(66, 66, pos);
			//var ima:Image = AddImage("", nameIm, 0, 0);
			//ima.FitRect(60, 60, pos);
			
			//add cai nut
			if (data["Color"] == 4)
			{//hiện nút feed
				AddButton(ID_BTN_FEED, "BtnFeed", 140, 260);
			}
			else
			{//hiện nút nhận
				AddButton(ID_BTN_RECEIVE, "BtnNhanThuong", 130, 260);
			}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_FEED:
				{
					feed();
					break;
				};
				case ID_BTN_RECEIVE:
				case ID_BTN_CLOSE:
					Hide();
				break;
			}
		}
		private function feed():void
		{
			switch(_data["Type"])
			{
				case "Helmet":
				case "Armor":
				case "Weapon":
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_EVENT_8_3_EQUIPMENT);
					break;
				case "Ring":
				case "Necklace":
				case "Bracelet":
				case "Belt":
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_EVENT_8_3_JEWELRY);
					break;
			}
			Hide();
		}
	}

}

























