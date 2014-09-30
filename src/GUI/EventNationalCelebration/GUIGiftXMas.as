package GUI.EventNationalCelebration 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.ListBox;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIGiftXMas extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const CTN_GIFT:String = "ctnGift";
		private var listGift:ListBox;
		private var labelNumSock:TextField;
		private var _numSock:int;
		
		public function GUIGiftXMas(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUI_GiftXMas");
			AddButton(BTN_CLOSE, "BtnThoat", 655 + 106, 26, this);
			labelNumSock = AddLabel("0", 100 + 234 + 22, 350 - 227, 0xFFff00, 1, 0x603813);
			var txtFormat:TextFormat = new TextFormat("arial", 20);
			labelNumSock.defaultTextFormat = txtFormat;
			labelNumSock.setTextFormat(txtFormat);
			listGift = AddListBox(ListBox.LIST_X, 1, 6, 4, 0);
			listGift.setPos(100 - 66, 400 - 187);
			
			var config:Object = ConfigJSON.getInstance().GetItemList("NoelSockExchange");
			var arrImgName:Array = ["ImgEXP", "Draft_1", "Fish303_Old_Idle", "Weapon101_Normal", "Weapon101_Special", "Weapon101_Rare"];
			var arrTooltip:Array = ["Kinh nghiệm", "Công thức lai", "Cá lính đánh thuê", "Vũ khí thường", "Vũ khí đặc biệt", "Vũ khí quí hiếm"];
			var arrImage:Array = [[],["Draft_1", "Draft_2", "Draft_3", "Draft_4", "Draft_5"], ["Fish303_Old_Idle", "Fish302_Old_Idle", "Fish301_Old_Idle", "Fish300_Old_Idle", "Fish304_Old_Idle"],
								["Weapon101_Normal", "Weapon201_Normal", "Weapon301_Normal", "Weapon401_Normal", "Weapon501_Normal"],
								["Weapon101_Special", "Weapon201_Special", "Weapon301_Special", "Weapon401_Special", "Weapon501_Special"],
								["Weapon101_Rare", "Weapon201_Rare", "Weapon301_Rare", "Weapon401_Rare", "Weapon501_Rare"]];
			var event:Object = GameLogic.getInstance().user.GetMyInfo().event;
			var exchangedNum:Object;
			if(event && event["IconChristmas"] && event["IconChristmas"]["Exchange"])
			{
				exchangedNum = event["IconChristmas"]["Exchange"];
			}
			for (var i:int = 0; i < 6; i++)
			{
				var itemGift:ItemGiftXMas = new ItemGiftXMas(listGift.img);
				var numGift:int = config[i + 1]["MaxItem"];
				if (exchangedNum && exchangedNum[i + 1])
				{
					numGift -= exchangedNum[i + 1];
				}
				itemGift.initItem(arrImgName[i], numGift, config[i+1]["Require"]["Num"], arrTooltip[i], arrImage[i]);
				if (i == 0)
				{
					itemGift.AddLabel("500", 5, 70, 0xFFff00, 1, 0x603813);
				}
				itemGift.giftId = i + 1;
				listGift.addItem(CTN_GIFT + "_" + i.toString(), itemGift, this);
			}
			if(GameLogic.getInstance().user.StockThingsArr["SockExchange"][0] != null)
			{
				numSock = GameLogic.getInstance().user.StockThingsArr["SockExchange"][0]["Num"];
			}
			
			var labelTime:TextField = AddLabel("Thời hạn đổi tất đến hết ngày 10/01/2012", 10 + 320, 500 - 55, 0xff0000, 1, 0xffffff);
			txtFormat = new TextFormat("arial", 18);
			labelTime.setTextFormat(txtFormat);
			SetPos(5, 15);
		}
		
		public function get numSock():int 
		{
			return _numSock;
		}
		
		public function set numSock(value:int):void 
		{
			_numSock = value;
			labelNumSock.text = value.toString();
			
			for each(var itemGift:ItemGiftXMas in listGift.itemList)
			{
				if (value < itemGift.numSock || itemGift.numGift <= 0)
				{
					itemGift.GetButton(ItemGiftXMas.BTN_GET_GIFT).SetEnable(false);
				}
				else
				{
					itemGift.GetButton(ItemGiftXMas.BTN_GET_GIFT).SetEnable(true);
				}
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_GIFT) >= 0)
			{
				var itemGift:ItemGiftXMas = listGift.getItemById(buttonID) as ItemGiftXMas;
				var p:Point = listGift.img.localToGlobal(itemGift.GetPosition());
				if (buttonID == CTN_GIFT + "_" + 1)
				{
					GuiMgr.getInstance().guiTooltipGiftXMas.showGUI(["Draft_1", "Draft_2", "Draft_3", "Draft_4", "Draft_5"], p.x-150, p.y+210);
				}
				else if (buttonID == CTN_GIFT + "_" + 2)
				{
					GuiMgr.getInstance().guiTooltipGiftXMas.showGUI(["Fish303_Old_Idle", "Fish302_Old_Idle", "Fish301_Old_Idle", "Fish300_Old_Idle", "Fish304_Old_Idle"], p.x-200, p.y + 210);
				}
				else if (buttonID == CTN_GIFT + "_" +3)
				{
					GuiMgr.getInstance().guiTooltipGiftXMas.showGUI(["Weapon101_Normal", "Weapon201_Normal", "Weapon301_Normal", "Weapon401_Normal", "Weapon501_Normal"], p.x-200, p.y + 210);
				}else if (buttonID == CTN_GIFT + "_" + 4)
				{
					GuiMgr.getInstance().guiTooltipGiftXMas.showGUI(["Weapon101_Special", "Weapon201_Special", "Weapon301_Special", "Weapon401_Special", "Weapon501_Special"], p.x-250, p.y + 210);
				}else if (buttonID == CTN_GIFT + "_" +5)
				{
					GuiMgr.getInstance().guiTooltipGiftXMas.showGUI(["Weapon101_Rare", "Weapon201_Rare", "Weapon301_Rare", "Weapon401_Rare", "Weapon501_Rare"], p.x-350, p.y + 210);
				}
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			GuiMgr.getInstance().guiTooltipGiftXMas.Hide();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
			}
		}
	}

}