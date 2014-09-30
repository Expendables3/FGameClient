package GUI.EventNationalCelebration 
{
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import NetworkPacket.PacketSend.SendBuyIconND;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemObject extends Container 
	{
		private const BTN_BUY_G:String = "BtnBuyG";
		private const BTN_BUY_GOLD:String = "BtnBuyGold";
		private var imageObject:Image;
		private var labelNum:TextField;
		private var labelCost:TextField;
		private var labelCostGold:TextField;
		private var imageCost:Image;
		public var buttonBuy:Button;
		public var buttonBuyGold:Button;
		private var _num:int;
		private var _maxNum:int;
		private var _cost:int;
		private var _costGold:int;
		public var id:int;
		private var timer:Timer;//Dùng ghép gói tin
		private var timerGold:Timer;
		public var numPacket:int;
		public var numGoldPacket:int;
		public var canByGold:Boolean = false;
		
		public function ItemObject(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, "ItemObject_Bg", x, y, isLinkAge, imgAlign);
			imageObject = AddImage("", imgName, 55, 35);
			imageObject.FitRect(75, 75, new Point(20, 0));
			labelNum = AddLabel("", 5, 70, 0xFF0000, 1, 0x603813);
			
			if (imgName == "IconChristmas2")
			{
				//buttonBuy = AddButton(BTN_BUY_G, "Btn_Buy_G", 5, 100);
				buttonBuy = AddButton(BTN_BUY_G, "Btn_G_Small", 32, 103);
				//buttonBuy.img.scaleX = buttonBuy.img.scaleY = 0.7;
				buttonBuy.img.scaleX = buttonBuy.img.scaleY = 0.6;
				//labelCost = AddLabel("1", 3, 102, 0xFFF100, 1, 0x603813);
				labelCost = AddLabel("1", 3, 103, 0x274a03, 1);
			}
			else
			{
				canByGold = true;
				buttonBuyGold = AddButton(BTN_BUY_GOLD, "Btn_Gold_Small", -5, 103);
				buttonBuyGold.img.scaleX = buttonBuyGold.img.scaleY = 0.6;
				labelCostGold = AddLabel("1", -35, 103, 0xFFF100, 1, 0x603813);
				buttonBuy = AddButton(BTN_BUY_G, "Btn_G_Small", 61, 103);
				buttonBuy.img.scaleX = buttonBuy.img.scaleY = 0.6;
				labelCost = AddLabel("1", 35, 103, 0x274a03, 1);
				
				costGold = 2000;
				timerGold = new Timer(2000, 1);
				timerGold.addEventListener(TimerEvent.TIMER_COMPLETE, timerGoldComplete);
			}
			
			
			timer = new Timer(2000, 1);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			

			
			numPacket = 0;
			var tooltip:TooltipFormat = new TooltipFormat();
			switch(imgName)
			{
				case "IconChristmas1":
					tooltip.htmlText = "Hoa Noel\n<font color='#ff0000'>(có được khi cho cá bạn bè ăn, \nchăm sóc cá, lau hồ bạn bè)</font>";
					break;
				case "IconChristmas2":
					tooltip.htmlText = "Kẹo Noel\n<font color='#ff0000'>(có được nhờ bạn bè tặng)</font>";
					break;
				case "IconChristmas3":
					tooltip.htmlText = "Mũ Noel\n<font color='#ff0000'>(có được khi câu cá)</font>";
					break;
			}
			//tooltip.htmlText = Localization.getInstance().getString("Tooltip" + imgName);
			setTooltip(tooltip);
		}
		
		private function timerGoldComplete(e:TimerEvent):void 
		{
			sendPacketGold();
		}
		
		private function timerComplete(e:TimerEvent):void 
		{
			sendPacket();
		}
		
		public function sendPacket():void
		{
			timer.stop();
			if (numPacket != 0)
			{
				var sendBuyIconND:SendBuyIconND = new SendBuyIconND(id, numPacket);
				Exchange.GetInstance().Send(sendBuyIconND);
				trace("num packet", numPacket);
				numPacket = 0;
			}
		}
		
		public function sendPacketGold():void
		{
			timerGold.stop();
			if (numGoldPacket != 0)
			{
				var sendBuyIconND:SendBuyIconND = new SendBuyIconND(id, numGoldPacket, "Money");
				Exchange.GetInstance().Send(sendBuyIconND);
				trace("num gold packet", numGoldPacket);
				numGoldPacket = 0;
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if(!GameLogic.getInstance().isEventND())
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian diễn ra event.");	
				GuiMgr.getInstance().guiGetEventGift.Hide();
				//GuiMgr.getInstance().GuiTopInfo.buttonGetGiftEvent.SetVisible(false);
				return;
			}
			var p:Point = new Point(id * 170-20, 90);
			switch(buttonID)
			{
				case BTN_BUY_G:
					if(GameLogic.getInstance().user.GetZMoney() >= cost)
					{
						num++;
						GameLogic.getInstance().user.UpdateUserZMoney( -cost);
						/*var sendBuyIconND:SendBuyIconND = new SendBuyIconND(id, 1);
						Exchange.GetInstance().Send(sendBuyIconND);*/
						if (timer.running)
						{
							timer.reset();
						}
						
						numPacket ++;
						timer.start();
						
						//Eff mua thanh cong
						EffectMgr.setEffBounceDown("Mua thành công", imageObject.ImgName, p.x, p.y);
					}
					else
					{
						//trace("Bạn không đủ tiền");
						GuiMgr.getInstance().GuiNapG.Init();
					}
					break;
				case BTN_BUY_GOLD:
					if (GameLogic.getInstance().user.GetMoney() >= costGold)
					{
						num++;
						GameLogic.getInstance().user.UpdateUserMoney( -costGold);
						if (timerGold.running)
						{
							timerGold.reset();
						}
						numGoldPacket++;
						timerGold.start();
						
						//Eff mua thanh cong
						EffectMgr.setEffBounceDown("Mua thành công", imageObject.ImgName, p.x, p.y);
					}
					else
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ tiền vàng.");	
					}
					break;
			}
			
		}
		
		public function get num():int 
		{
			return _num;
		}
		
		public function set num(value:int):void 
		{
			_num = value;
			//labelNum.text = value.toString() +"/" + maxNum.toString();
			if(num >= maxNum)
			{
				var guiGift:GUIGetEventGift = GuiMgr.getInstance().guiGetEventGift;
				if(guiGift.timer.delay == guiGift.delayStart)
				{
					if (guiGift.canGetGift())
					{
						guiGift.startEffect();
						guiGift.buttonGetGift.SetEnable(true);
					}
					else
					{
						guiGift.buttonGetGift.SetEnable(false);
						guiGift.timer.stop();
					}
					//guiGift.buttonGetGift.SetEnable(GuiMgr.getInstance().guiGetEventGift.canGetGift());
				}
				//labelNum.setTextFormat(new TextFormat("arial", null, 0xffff00));
				labelNum.htmlText = "<font color = '#ffff00'>"+ value.toString() +"/" + maxNum.toString() + "</font>";
			}
			else
			{
				//labelNum.setTextFormat(new TextFormat("arial", null, 0xff0000));
				labelNum.htmlText = "<font color = '#ff1100'>"+ value.toString() +"</font><font color = '#ffff00'>/" + maxNum.toString() + "</font>";
			}
			
			//Cập nhật dữ liệu ở túi đố
			var data:Object = GameLogic.getInstance().user.StockThingsArr["IconChristmas"];
			for each(var obj:Object in data)
			{
				if (obj["Id"] == id)
				{
					obj["Num"] = value;
				}
			}
		}
		
		public function get maxNum():int 
		{
			return _maxNum;
		}
		
		public function set maxNum(value:int):void 
		{
			_maxNum = value;
			//labelNum.text = num.toString() +"/" + value.toString();
			labelNum.htmlText = "<font color = '#ff1100'>"+ num.toString() +"</font><font color = '#ffff00'>/" + value.toString() + "</font>";		}
		
		public function get cost():int 
		{
			return _cost;
		}
		
		public function set cost(value:int):void 
		{
			_cost = value;
			/*if(!canByGold)
			{
				labelCost.text = "Mua" + value.toString();
			}
			else*/
			{
				labelCost.text = value.toString();
			}
		}
		
		public function get costGold():int 
		{
			return _costGold;
		}
		
		public function set costGold(value:int):void 
		{
			_costGold = value;
			labelCostGold.text = value.toString();
		}
	}

}