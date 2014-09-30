package Event.EventNoel.NoelGui.ItemGui 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.GuiBuyAbstract.ReceiveItemSvc;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.LogicGift.AbstractGift;
	
	/**
	 * GUI nhận thưởng khi có collection từ việc săn cá
	 * @author HiepNM2
	 */
	public class GuiExchangeNoelItem extends BaseGUI 
	{
		private const FEED:int = 2;
		private const SHOW:int = 1;
		private const CMD_RECEIVE:String = "cmdReceive";
		private const CMD_CLOSE:String = "cmdClose";
		private const listFeed:Object = { 
											"1": { },
											"2": { "3": 1}, 
											"3":{},
											"4": { "3":2 }, 
											"5": { "1":2, "2":2 }
										};
		private const listFeedType:Object = { 
											"4": { "3":"Equipment4" }, 
											"5": { "1":"HammerPurple1", "2":"Material13" }
										};
		
		private var _idRow:int;
		private var inReceiveFeed:Boolean;
		
		public var itemExchange:ItemCollectionEvent;
		public var btnReceive1:Button;
		public var btnReceive2:Button;
		public var btnReceive3:Button;
		public var listGift:Array;
		public function GuiExchangeNoelItem(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiExchangeNoelItem";
			ReceiveItemSvc.getInstance().ItemName = "NoelItem";
			ReceiveItemSvc.getInstance().UrlReceiveAPI = "EventService.noelExchangeGift";
			ReceiveItemSvc.getInstance().IdReceiveAPI = "";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				ReceiveItemSvc.getInstance().NumItem = EventSvc.getInstance().getNumItem("NoelItem", _idRow);
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(CMD_CLOSE, "BtnThoat", 530, 22);
				var tfHaving:TextField = AddLabel("", 145, 90, 0xffffff, 1, 0x000000);
				tfHaving.text = "Đang có:";
				var info:ItemCollectionInfo = EventSvc.getInstance().getItemInfo("NoelItem", _idRow);
				itemExchange = ItemCollectionEvent.createItemEvent(info.ItemType, this.img,
																	"EventNoel_ImgSlot",
																	250, 70);
				itemExchange.initData(info);
				itemExchange.drawGift();
				//dòng tip
				var tfTip:TextField = AddLabel("", 255, 180, 0xffffff, 1, 0x000000);
				var strTip:String = "Sử dụng 1 \"@Name@\" sẽ đổi được một phần thưởng tùy chọn";
				strTip = strTip.replace("@Name@", info.getItemName());
				tfTip.text = strTip;
				//các phần thưởng và nút nhận
				var cfg:Object = ConfigJSON.getInstance().getItemInfo("Noel_Bonus")["NoelGift"][_idRow];
				var temp:Object;
				var giftInfo:AbstractGift, gift:AbstractItemGift;
				var x:int = 60, y:int = 195;
				listGift = [];
				for (var i:int = 1; i <= 3; i++)
				{
					temp = cfg[i]["1"];
					giftInfo = AbstractGift.createGift(temp["ItemType"]);
					giftInfo.setInfo(temp);
					gift = AbstractItemGift.createItemGift(giftInfo.ItemType, this.img, 
															"GuiExchangeNoelItem_ImgSlotGift",
															x, y);
					gift.initData(giftInfo);
					gift.setPosBuff(33, 35);
					gift.drawGift();
					listGift.push(gift);
					var btnReceive:Button = this["btnReceive" + i] = AddButton(CMD_RECEIVE + "_" + i, "GuiExchangeNoelItem_BtnReceive", x + 30, y + 130);
					btnReceive.SetEnable(info.Num > 0);
					x += 150;
				}
			}
			LoadRes("GuiExchangeNoelItem_GiftTheme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case CMD_CLOSE:
					Hide();
					break;
				case CMD_RECEIVE:
					var idCol:int = int(data[1]);
					if (listFeed[_idRow][idCol] > 0)//show gift in gui
					{
						if (inReceiveFeed) return;
						ReceiveItemSvc.getInstance().sendReceiveAction();//send tất cả các gói trước đó đi
						ReceiveItemSvc.getInstance().IdReceiveAPI = Constant.CMD_RECEIVE_NOEL_FEED;
						inReceiveFeed = true;
					}
					if (ReceiveItemSvc.getInstance().receiveItem("NoelItem", _idRow, idCol))//nhận thành công
					{
						EventSvc.getInstance().updateItem("NoelItem", _idRow, -1);
						refreshBtnReceives();
						itemExchange.refreshTextNum();
						if (!inReceiveFeed)
						{
							//effect nhận thành công
							var info:AbstractGift = (listGift[idCol - 1] as AbstractItemGift).getGiftInfo();
							EventSvc.getInstance().processGetGift(info, info["Num"]);
							EffectMgr.setEffBounceDown("Nhận Thành Công", info.getImageName(), 330, 280, null, info["Num"]);
						}
						else
						{
							ReceiveItemSvc.getInstance().sendReceiveAction();//vừa ấn nhận phần thưởng feed => send tất cả các gói nhận lên
						}
						//ReceiveItemSvc.getInstance().sendReceiveAction();//vừa ấn nhận phần thưởng feed => send tất cả các gói nhận lên
					}
					break;
			}
		}
		private function refreshBtnReceives():void
		{
			var btnReceive:Button;
			for (var i:int = 1; i <= 3; i++)
			{
				btnReceive = this["btnReceive" + i];
				var numItem:int = EventSvc.getInstance().getNumItem("NoelItem", _idRow);
				btnReceive.SetEnable(numItem > 0);
			}
		}
		public function processGetGift(oldData:Object, data:Object):void 
		{
			var row:int = oldData["ItemId"];
			var col:int = oldData["Index"];
			EventSvc.getInstance().initGiftServer2(data, "Bonus");
			var num:int = EventSvc.getInstance().getGiftServer().length;
			if (listFeed[row][col] == 2)
			{
				GuiMgr.getInstance().guiGiftEventNoel.isFeed = true;
				GuiMgr.getInstance().guiGiftEventNoel.typeFeed = listFeedType[row][col];
			}
			GuiMgr.getInstance().guiGiftEventNoel.setNumSlot(num);
			GuiMgr.getInstance().guiGiftEventNoel.Show(Constant.GUI_MIN_LAYER, 5);
			ReceiveItemSvc.getInstance().IdReceiveAPI = "";
			inReceiveFeed = false;
		}
		public function set IdRow(value:int):void { _idRow = value; }
		override public function OnHideGUI():void 
		{
			ReceiveItemSvc.getInstance().sendReceiveAction();
			GuiMgr.getInstance().guiExchangeNoelCollection.refreshTextNumAt(_idRow);
		}
		override public function ClearComponent():void 
		{
			if (listGift)
			{
				var gift:AbstractItemGift;
				for (var i:int = 0; i < listGift.length; i++)
				{
					gift = listGift[i];
					gift.Destructor();
				}
				listGift.splice(0, listGift.length);
			}
			super.ClearComponent();
		}
		
		public function updateGui(curTime:Number):void
		{
			ReceiveItemSvc.getInstance().updateTime(curTime);
		}
	}

}













