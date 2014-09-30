package GUI 
{
	import Data.Localization;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventLuckyMachine.EventLuckyMachineMgr;
	import Event.Factory.FactoryLogic.EventSvc;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.TooltipFormat;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GuiGiftFromEvent extends BaseGUI 
	{
		private static const BTN_CLOSE:String = "BtnClose";
		private static const BTN_RECEIVE:String = "BtnReceive";
		
		private var giftList:Array;
		
		public function GuiGiftFromEvent(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);			
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);	
				addContent();
				OpenRoomOut();
			}
			
			LoadRes("GuiBuyContinue_Theme");
		}
		
		private function addContent():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 690, 41);
			AddButton(BTN_RECEIVE, "BtnNhanThuong", 300, 380);
			var i:int;
			var j:int;
			var ctn:Container;
			var obj:Object;
			var tip:TooltipFormat;
			var fm:TextFormat = new TextFormat();
			fm.bold = true;
			fm.size = 14;
			fm.color = 0xffffff;
			var x:int = 95;
			var y:int = 140;
			var tfNum:TextField;
			var num:int;
			
			for (i = 0; i < giftList.length - 1; i++)
			{
				for (j = i + 1; j < giftList.length; j++)
				{
					if (giftList[j]["ItemType"] == giftList[i]["ItemType"] && giftList[j]["ItemId"] == giftList[i]["ItemId"])
					{
						num = int(giftList[i]["Num"]) + int(giftList[j]["Num"]);
						giftList[i]["Num"] = num;
						giftList.splice(j, 1);
						j--;
					}
				}
			}
			
			for (i = 0; i < giftList.length; i++)
			{
				obj = giftList[i];
				ctn = AddContainer(obj["ItemType"] + obj["ItemId"], "GuiBuyContinue_ImgSlot", x, y, true, this);
				ctn.AddImage("", "EventHalloween_HalItem" + obj["ItemId"], 44, 40);	//Thạch bảo đồ
				//ctn.AddImage("", "EventLuckyMachine_Ticket1", 44, 40);	//EventLuckyMachine
				//ctn.AddImage("", "IslandItem15", 64, 70);	//TreasureIsland
				//ctn.AddImage("", "EventNoel_" + obj["ItemType"] + obj["ItemId"], 42, 45);		//FishHunter
				//ctn.AddImage("", "GUIGameEventMidle8_" + obj["ItemType"] + obj["ItemId"], 42, 45);		//StoneMaze
				fm.color = 0xffffff;
				ctn.AddLabel("x" + Ultility.StandardNumber(obj["Num"]), -10, 65, 0xffffff, 1, 0x000000);
				
				tip = new TooltipFormat();
				tip.text = Localization.getInstance().getString("EventHalloween_Tip" + obj["ItemType"] + obj["ItemId"]);	//Thạch bảo đồ
				//tip.text = Localization.getInstance().getString("GUIGameEventMidle8_" + obj["ItemType"] + obj["ItemId"]);	//StoneMaze
				//tip.text = Localization.getInstance().getString("EventNoel_" + obj["ItemType"] + obj["ItemId"]);	//FishHunter
				//tip.text = "Xẻng đào vàng";	//TreasureIsland
				//tip.text = "Vỏ sò may mắn";	//EventLuckyMachine
				fm.color = 0xff00ff;
				tip.setTextFormat(fm);
				ctn.setTooltip(tip);
				
				x += 93;
				if (i == 5)
				{
					x = 95;
					y += 107;
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:			
				case BTN_RECEIVE:
					receiveGift();
					Hide();
					break;
			}
		}
		
		private function receiveGift():void 
		{
			var obj:Object;
			for (var i:int = 0; i < giftList.length; i++)
			{
				obj = giftList[i];
				//GuiMgr.getInstance().guiFrontEvent.updateNumItemEvent(obj["ItemType"], obj["Num"], obj["ItemId"]);
				HalloweenMgr.getInstance().updateRockStore(obj["ItemId"], obj["Num"]);
				//EventSvc.getInstance().updateItem(obj["ItemType"], obj["ItemId"], obj["Num"]);	//FishHunter...
				//GuiMgr.getInstance().GuiStore.UpdateStore(obj["ItemType"], obj["ItemId"], obj["Num"]);	//TreasureIsland + StoneMaze
				//EventLuckyMachineMgr.getInstance().updateTicket(obj["Num"]);	//Slot Machine
				giftList[i] = null;
			}
			giftList.splice(0, giftList.length);
			giftList = null;
		}
		
		public function showGui(itemList:Array):void
		{
			var i:int;
			giftList = new Array();
			for (i = 0; i < itemList.length; i++)
			{
				giftList.push(itemList[i]);				
			}
			Show(Constant.GUI_MIN_LAYER, 1);
		}
	}

}