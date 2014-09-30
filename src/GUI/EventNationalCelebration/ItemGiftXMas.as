package GUI.EventNationalCelebration 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendExchangeGreenSock;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemGiftXMas extends Container 
	{
		private var buttonGetGift:Button;
		private var labelNumGift:TextField;
		private var labelSock:TextField;
		private var _numGift:int;
		private var _numSock:int;
		static public const BTN_GET_GIFT:String = "btnGetGift";
		static public const CTN_IMAGE:String = "ctnImage";
		public var imageArrTooltip:Array;
		public var giftId:int;
		
		public function ItemGiftXMas(parent:Object, imgName:String = "GiftXMas_Bg", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			buttonGetGift = AddButton(BTN_GET_GIFT, "Btn_Change_Noel", 31, 91 + 73);
			
			buttonGetGift.SetEnable(false);
			
			labelNumGift = AddLabel("num Gift", 30 - 47 + 23, 5 - 19 + 50 - 10, 0xFFFF00, 1, 0x603813);
			labelSock = AddLabel("num Sock", 20 - 35 + 11, 68 + 66, 0xFFFF00, 1, 0x603813);
		}
		
		public function initItem(itemImgName:String, numGift:int, numSock:int, txtTooltip:String, imageTooltip:Array):void
		{
			var image:Container = AddContainer(CTN_IMAGE, itemImgName, 0, 0, true, this);
			image.FitRect(60, 60, new Point(26, 48));
			//var tooltipFormat:TooltipFormat = new TooltipFormat();
			//tooltipFormat.text = txtTooltip;
			//image.setTooltip(tooltipFormat);
			AddLabel(txtTooltip, 20 - 35 + 23, 68 + 45, 0x854F3D, 1);// , 0xff0000);// 0xFFFF00, 1, 0x603813);
			this.numGift = numGift;
			this.numSock = numSock;
			
			imageArrTooltip = imageTooltip;
			
			
			var totalSock:int;
			if(GameLogic.getInstance().user.StockThingsArr["SockExchange"][0] != null)
			{
				totalSock = GameLogic.getInstance().user.StockThingsArr["SockExchange"][0]["Num"];
			}
			if (totalSock < numSock)
			{
				buttonGetGift.SetEnable(false);
			}
			else
			{
				buttonGetGift.SetEnable(true);
			}
		}
		
		public function get numGift():int 
		{
			return _numGift;
		}
		
		public function set numGift(value:int):void 
		{
			_numGift = value;
			if (value <= 0)
			{
				GetButton(BTN_GET_GIFT).SetEnable(false);
			}
			labelNumGift.text = value.toString();
		}
		
		public function get numSock():int 
		{
			return _numSock;
		}
		
		public function set numSock(value:int):void 
		{
			_numSock = value;
			labelSock.text = value.toString();
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_GET_GIFT:
					/*if(imageArrTooltip != null && imageArrTooltip.length > 0)
					{
						GuiMgr.getInstance().guiTooltipGiftXMas.showGUI(imageArrTooltip, 157, 430);// this.img.x - 150, this.img.y + 210);
					}*/
					break;
			}
		}
		
		override public function OnButtonClick(eventM:MouseEvent, buttonID:String):void 
		{
			if (buttonID == BTN_GET_GIFT)
			{
				if (imageArrTooltip == null || imageArrTooltip.length == 0)
				{
					Exchange.GetInstance().Send(new SendExchangeGreenSock(giftId, 0));
					//trace(GameLogic.getInstance().user.GetExp());
					GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + 500, false, false);
					numGift--;
					
					var event:Object = GameLogic.getInstance().user.GetMyInfo().event;
					var exchangedNum:Object;
					if (!event)
					{
						event = new Object();
					}
					if (!event["IconChristmas"])
					{
						event["IconChristmas"] = new Object();
					}
					if(!event["IconChristmas"]["Exchange"])
					{
						event["IconChristmas"]["Exchange"] = new Object();
					}
					if(!event["IconChristmas"]["Exchange"][giftId])
					{
						event["IconChristmas"]["Exchange"][giftId] = 1 
					}
					else
					{
						event["IconChristmas"]["Exchange"][giftId]++;
					}
					//trace("IconChristmas", event["IconChristmas"]["Exchange"][giftId] );
					GameLogic.getInstance().user.UpdateStockThing("SockExchange", 1, -numSock);
					GuiMgr.getInstance().guiGiftXMas.numSock -= numSock;
				} 
				else
				{
					GuiMgr.getInstance().guiChoseGiftXMas.showGUI(this);
				}
			}
		}
	}

}