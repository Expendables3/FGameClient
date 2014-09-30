package Event.EventLuckyMachine 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Effect.SwfEffect;
	import Event.EventMgr;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Factory.FactoryLogic.EventUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.GuiBuyAbstract.BuyItemSvc;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.LuckyMachine.SendBuyTicket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiLuckyMachine extends BaseGUI 
	{
		private const ROLL1:int = 1;
		private const ROLL2:int = 10;
		private const ROLL3:int = 100;
		static public const ID_BTN_CLOSE:String = "idBtnClose";
		static public const ID_BTN_ROLL:String = "idBtnRoll";
		static public const ID_BTN_BUY:String = "idBtnMua";
		static public const ID_BTN_TAB:String = "idBtnTab";
		private var _tab:int;
		private var _indexHighLight:int;
		private var _timeGui:Number;
		private var _active:Boolean = false;
		private var _inEffect:Boolean = false;
		private var _isReceive:Boolean = false;
		private var _timeReceive:Number;
		private var _stopIndex:int;
		
		private var btnRoll:Button;
		private var btnClose:Button;
		private var _listSlotGift:Array = [];
		private var tfCurTicket:TextField;
		private var _positionSlot:Array = [];
		public function GuiLuckyMachine(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiLuckyMachine";
			initPositionSlot();
			BuyItemSvc.getInstance().UrlBuyAPI = "MiniGameService.minigame_buyItem"; 
			BuyItemSvc.getInstance().IdBuyAPI = Constant.CMD_SEND_BUY_TICKET_FOR_LM;
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddImage("idimg", "GuiDigitWheel_ImgLblDW", 187, 30);//title cho máy quay sò
				AddImage("idimgKhung", "GuiDigitWheel_ImgKhungDW", 186, 86, true, ALIGN_LEFT_TOP);
				btnClose = AddButton(ID_BTN_CLOSE, "BtnThoat", 663, 18);
				btnRoll = AddButton(ID_BTN_ROLL, "GuiDigitWheel_BtnQuayLM", 432, 447);
				AddImage("idimg", "GuiDigitWheel_ImgCurTicketTable",118, 390);
				AddImage("idimg", "GuiDigitWheel_ImgTicketperTimeTable", 410, 320);
				AddImage("idimg", "GuiDigitWheel_ImgXeng", 509, 320);
				tfCurTicket = AddLabel(Ultility.StandardNumber(EventLuckyMachineMgr.getInstance().getTicketNum()), 34, 391, 0xFFFF00, 1, 0x000000);
				addTicketBuy();
				addTab();
				addAllSlotGift();
			}
			LoadRes("GuiDigitWheel_Theme");
		}
		private function initPositionSlot():void
		{
			const dx:int = 56;
			const dy:int = 56;
			var x:int = 192;
			var y:int = 91;
			var i:int;
			for (i = 1; i <= 8; i++)
			{
				_positionSlot.push( { "x":x, "y":y } );
				x += dx;
			}
			x -= dx;
			y += dy;
			for (i = 1; i <= 5; i++)
			{
				_positionSlot.push( { "x":x, "y":y } );
				y += dy;
			}
			y -= dy;
			x -= dx;
			for (i = 1; i <= 7; i++)
			{
				_positionSlot.push( { "x":x, "y":y } );
				x -= dx;
			}
			x += dx;
			y -= dy;
			for (i = 1; i <= 4; i++)
			{
				_positionSlot.push( { "x":x, "y":y } );
				y -= dy;
			}
		}
		/*
		 * add bảng giá và mua vé
		 */
		private function addTicketBuy():void
		{
			AddImage("idimg", "GuiDigitWheel_ImgPriceTable1", 116, 201);//add vào cái bảng tĩnh
			//add 3 nút mua
			AddButton(ID_BTN_BUY + "_1", "GuiDigitWheel_BtnBuyTicket", 126, 136);
			AddButton(ID_BTN_BUY + "_2", "GuiDigitWheel_BtnBuyTicket", 126, 206);
			AddButton(ID_BTN_BUY + "_3", "GuiDigitWheel_BtnBuyTicket", 126, 274);
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Ticket");
			//gan vao so luong
			var firstXNum:int = 46;
			var firstXPrice:int = 95;
			var firstYNum:int = 150;
			var firstYPrice:int = 136;
			var i:int;
			var strNum:String;
			var strPrice:String;
			for (i = 1; i <= 3; i++)
			{
				strNum = obj[i.toString()]["Num"];
				strPrice = obj[i.toString()]["ZMoney"];
				AddLabel(strNum, firstXNum, firstYNum - 2, 0xffffff, 1, 0x000000);
				AddLabel(strPrice, firstXPrice , firstYPrice, 0xffffff, 1, 0x000000);
				firstYPrice += 70;
				firstYNum += 70;
			}
		}
		private function addTab():void
		{
			_tab = 1;
			AddImage("", "GuiDigitWheel_ImgTurnPlay" + ROLL1, 253, 175, true, ALIGN_LEFT_TOP);
			AddButton(ID_BTN_TAB + "_" + ROLL1, "GuiDigitWheel_BtnTurnPlay" + ROLL1, 253, 175, this).SetVisible(false);
			AddLabel("1", 335, 195, 0xFFFF00, 1, 0x000000);
			
			AddImage("", "GuiDigitWheel_ImgTurnPlay" + ROLL2, 253, 235, true, ALIGN_LEFT_TOP);
			AddButton(ID_BTN_TAB + "_" + ROLL2, "GuiDigitWheel_BtnTurnPlay" + ROLL2, 253, 235, this); 
			AddLabel("10", 330, 255, 0xFFFF00, 1, 0x000000);
			
			AddImage("", "GuiDigitWheel_ImgTurnPlay" + ROLL3, 253, 295, true, ALIGN_LEFT_TOP);
			AddButton(ID_BTN_TAB + "_" + ROLL3, "GuiDigitWheel_BtnTurnPlay" + ROLL3, 253, 295, this);
			AddLabel("100", 330, 315, 0xFFFF00, 1, 0x000000);
		}
		private function addAllSlotGift():void
		{
			removeListSlotGift();
			var data:Object = ConfigJSON.getInstance().getItemInfo("M_GiftContent");
			var obj:Object;
			var gift:AbstractGift;
			var itGift:AbstractItemGift;
			var x:int, y:int;
			var dx:int = 0, dy:int = 0;
			var wSlot:int = 55, hSlot:int = 55;
			var strTip:String;
			for (var i:int = 1; i <= 24; i++)
			{
				dx = 0;
				dy = 0;
				wSlot = 55;
				hSlot = 55;
				obj = data[i];
				gift = AbstractGift.createGift(obj["ItemType"]);
				gift.setInfo(obj);
				if (Ultility.categoriesGift(gift.ItemType) == 1)
				{
					gift["Element"] = 1;
				}
				itGift = AbstractItemGift.createItemGift(gift.ItemType, this.img, "ImgSlotBlue", _positionSlot[i - 1]["x"], _positionSlot[i - 1]["y"], true);
				itGift.setHasBackGroundColor(false);
				itGift.xNum = -25;
				itGift.yNum = 39;
				itGift.hasTooltipImg = false;
				
				switch(gift.ItemType)
				{
					case "AllChest":
					case "JewelChest":
					case "EquipmentChest":
						wSlot = 40;
						hSlot = 40;
						dx = 10;
						dy = 7;
						break;
				}
				itGift.hasLock = false;
				itGift.setPosBuff(dx, dy);
				itGift.initData(gift, "", wSlot, hSlot, false);
				itGift.drawGift();
				if (Ultility.categoriesGift(gift.ItemType) == 1)
				{
					strTip = Ultility.getTooltipText(gift.ItemType, gift.ItemId, gift["Color"], gift["Rank"]);
					itGift.setTooltipText(strTip);
				}
				_listSlotGift.push(itGift);
			}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			switch(command)
			{
				case ID_BTN_CLOSE:
					Hide();
					break;
				case ID_BTN_ROLL:
					if (!checkEvent())
					{
						return;
					}
					var ticket:Number = EventLuckyMachineMgr.getInstance().getTicketNum();
					if (ticket >= _tab)
					{
						rollMachine();
					}
					else
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ sò", 310, 200, 1);
					}
					break;
				case ID_BTN_BUY:
					if (!checkEvent())
					{
						return;
					}
					var id:int = int(data[1]);
					buyShell(id);
					break;
				case ID_BTN_TAB:
					var tab:int = int(data[1]);
					changeTab(tab);
					break;
					
			}
		}
		private function checkEvent():Boolean
		{
			if (EventMgr.CheckEvent(EventMgr.NAME_EVENT) == EventMgr.CURRENT_IN_EVENT)
			{
				return true;
			}
			else
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết thời gian diễn ra event", 310, 200, 1);
				Hide();
				return false;
			}
		}
		private function buyShell(id:int):void 
		{
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Ticket");
			var num:int = obj[id]["Num"];				//số lượng theo id
			var price:int = obj[id]["ZMoney"];			//giá theo id
			if (BuyItemSvc.getInstance().buyItem("Ticket", id, "ZMoney", price))
			{
				
			//}
			//if (Ultility.payMoney("ZMoney", price))
			//{
				//BuyItemSvc.getInstance().dataBuff = new Object();
				//BuyItemSvc.getInstance().dataBuff["BuyType"] = id;
				//var pk:SendBuyTicket = new SendBuyTicket("Ticket", id, 1);
				//Exchange.GetInstance().Send(pk);
				EffectMgr.setEffBounceDown("Mua thành công", "GuiDigitWheel_ImgEffBuyXeng", 330, 280);
				EventLuckyMachineMgr.getInstance().updateTicket(num);
				tfCurTicket.text = Ultility.StandardNumber(EventLuckyMachineMgr.getInstance().getTicketNum());
				var txtFormat:TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
				txtFormat.align = "left";
				txtFormat.font = "SansationBold";
				var st:String;
				st = "+" + Ultility.StandardNumber(num);
				txtFormat.color = 0xFFFF00;  //Cộng xeng thì màu xanh
				var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E, true);
				var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
				eff.SetInfo(125, 400, 125, 350, 4);
			}
		}
		
		private function rollMachine():void 
		{
			/*trừ sò*/
			EventLuckyMachineMgr.getInstance().updateTicket( -_tab);
			var txtFormat:TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
			txtFormat.align = "left";
			txtFormat.font = "SansationBold";
			var st:String;
			st = "-" + Ultility.StandardNumber(_tab);
			txtFormat.color = 0xff0000;
			var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E, true);
			var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
			eff.SetInfo(125, 400, 125, 350, 4);
			tfCurTicket.text = Ultility.StandardNumber(EventLuckyMachineMgr.getInstance().getTicketNum());
			
			BuyItemSvc.getInstance().sendBuyAction();
			btnClose.SetEnable(false);
			btnRoll.SetEnable(false);
			GetButton(ID_BTN_TAB + "_" + ROLL1).SetEnable(false);
			GetButton(ID_BTN_TAB + "_" + ROLL2).SetEnable(false);
			GetButton(ID_BTN_TAB + "_" + ROLL3).SetEnable(false);
			//Send dữ liệu lên server
			_isReceive = false;
			var pk:SendRollMachine = new SendRollMachine(_tab);
			Exchange.GetInstance().Send(pk);
			switch(_tab)
			{
				case ROLL1:
					_indexHighLight = 0;
					var curItem:AbstractItemGift = _listSlotGift[_indexHighLight];
					curItem.SetHighLight(0xFF0000);
					_active = true;//cho máy chạy
					_timeGui = GameLogic.getInstance().CurServerTime;
					break;
				case ROLL2:
				case ROLL3:
					var effMask:Image = AddImage("effMask", "GuiDigitWheel_EffMask", 343, 231, true, ALIGN_LEFT_TOP);
					var ptr:GuiLuckyMachine = this;
					_inEffect = false;
					var swf:SwfEffect = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiDigitWheel_EffCount" + _tab, null, 370, 287, false, false, null,
									function effCountComp():void
									{
										_inEffect = true;
										if (_isReceive)
										{
											ptr.RemoveImage(effMask);
											receiveGift();
										}
									});
					break;
			}
			
			
		}
		
		public function receiveData(data:Object):void
		{
			_isReceive = true;
			_timeReceive = GameLogic.getInstance().CurServerTime;
			//lấy _stopIndex và phần thưởng
			EventSvc.getInstance().initGiftServer3(data, "GiftList");
			switch(_tab)
			{
				case ROLL1:
					_stopIndex = data["GiftId"] - 1;
					break;
				case ROLL2:
				case ROLL3:
					if (_inEffect)
					{
						RemoveImage(GetImage("effMask"));
						receiveGift();
					}
					break;
			}
		}
		
		private function changeTab(tab:int):void 
		{
			BuyItemSvc.getInstance().sendBuyAction();
			var curBtn:Button = GetButton(ID_BTN_TAB + "_" + tab);
			var preBtn:Button = GetButton(ID_BTN_TAB + "_" + _tab);
			curBtn.SetVisible(false);
			preBtn.SetVisible(true);
			_tab = tab;
		}
		
		public function updateGui():void
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (_active)
			{
				if (curTime - _timeGui > 0.05)
				{
					_timeGui = curTime;
					var preItem:AbstractItemGift = _listSlotGift[_indexHighLight];
					_indexHighLight = (_indexHighLight + 1) % 24;
					var curItem:AbstractItemGift = _listSlotGift[_indexHighLight];
					preItem.SetHighLight( -1);
					curItem.SetHighLight(0xFF0000);
					//thời điểm dừng lại
					if (_isReceive && _indexHighLight == _stopIndex && curTime - _timeReceive > 5)
					{
						_active = false;
						_stopIndex = -1;
						receiveGift();
					}
				}
			}
			BuyItemSvc.getInstance().updateTime(curTime);
		}
		private function receiveGift():void
		{
			btnClose.SetEnable();
			btnRoll.SetEnable();
			GetButton(ID_BTN_TAB + "_" + ROLL1).SetEnable();
			GetButton(ID_BTN_TAB + "_" + ROLL2).SetEnable();
			GetButton(ID_BTN_TAB + "_" + ROLL3).SetEnable();
			var giftServer:Array = EventSvc.getInstance().getGiftServer();
			var num:int = giftServer.length;
			//GuiMgr.getInstance().guiLuckyMachineGift.setNumSlot(num);
			//GuiMgr.getInstance().guiLuckyMachineGift.Show(Constant.GUI_MIN_LAYER, 5);
			var typeFeed:int = checkHaveVipEquip(giftServer);
			GuiMgr.getInstance().guiGiftEventNoel.isFeed = typeFeed > 0;
			switch(typeFeed)
			{
				case 5:
					GuiMgr.getInstance().guiGiftEventNoel.typeFeed = "EventLuckyMachineVip";
					break;
				case 6:
					GuiMgr.getInstance().guiGiftEventNoel.typeFeed = "EventLuckyMachineVipMax";
					break;
			}
			GuiMgr.getInstance().guiGiftEventNoel.setNumSlot(num);
			GuiMgr.getInstance().guiGiftEventNoel.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		private function checkHaveVipEquip(giftServer:Array):int 
		{
			var gift:AbstractGift = giftServer[0];
			if (Ultility.categoriesGift(gift.ItemType) == 0)
			{
				return 0;
			}
			else
			{
				if (gift["Color"] < 5)
				{
					return 0;
				}
				else
				{
					if (gift["Color"] == 6)
					{
						return 6;
					}
					else if (gift["Color"] == 5)
					{
						return 5;
					}
					else
					{
						return 0;
					}
				}
			}
		}
		override public function ClearComponent():void 
		{
			removeListSlotGift();
			super.ClearComponent();
		}
		
		private function removeListSlotGift():void 
		{
			if (_listSlotGift != null)
			{
				for (var i:int = 0; i < _listSlotGift.length; i++)
				{
					var itGift:AbstractItemGift= _listSlotGift[i];
					itGift.Destructor();
				}
				_listSlotGift.splice(0, _listSlotGift.length);
			}
		}
		override public function OnHideGUI():void 
		{
			BuyItemSvc.getInstance().sendBuyAction();
		}
	}

}











