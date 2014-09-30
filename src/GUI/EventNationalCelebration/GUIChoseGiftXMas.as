package GUI.EventNationalCelebration 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.EventNationalCelebration.ItemGiftXMas;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendExchangeGreenSock;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIChoseGiftXMas extends BaseGUI 
	{
		private var itemGiftXMas:ItemGiftXMas;
		private var selectedElement:int;
		static public const BTN_GET_GIFT:String = "btnGetGift";
		static public const BTN_CLOSE:String = "btnClose";
		public function GUIChoseGiftXMas(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUI_Chose_GiftXMas");
			AddButton(BTN_GET_GIFT, "Btn_Get_Gift", 177 + 24, 148 + 130);// .SetEnable(false);
			AddButton(BTN_CLOSE, "BtnThoat", 512 - 18, 48, this);	
			SetPos(157, 100);
		}
		
		public function showGUI(itemGiftXMas:ItemGiftXMas):void
		{
			Show(Constant.GUI_MIN_LAYER, 6);
			var arrImgName:Array = itemGiftXMas.imageArrTooltip;
			for (var i:int = 0; i < arrImgName.length; i++)
			{
				var ctn:Container = AddContainer(i.toString(), arrImgName[i], i * 50, 10, true, this);
				var rectange:Rectangle = ctn.img.getBounds(ctn.img);
				ctn.img.graphics.beginFill(0xffffff, 0);
				ctn.img.graphics.drawRect(rectange.x, rectange.y, rectange.width, rectange.height);
				ctn.img.graphics.endFill();
				ctn.FitRect(60, 60, new Point(45.5 + i * 95, 155));
				ctn.img.buttonMode = true;
				if (i == 0)
				{
					ctn.SetHighLight(0xff0000);
					selectedElement = i + 1;
				}
			}
			this.itemGiftXMas = itemGiftXMas;
		}
		
		override public function OnButtonClick(eventM:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_GET_GIFT:
					trace(selectedElement);
					Exchange.GetInstance().Send(new SendExchangeGreenSock(itemGiftXMas.giftId, selectedElement));
					
					if (itemGiftXMas.giftId > 2)
					{
						GameLogic.getInstance().user.GenerateNextID();
					}
					itemGiftXMas.numGift--;
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
					if(event["IconChristmas"]["Exchange"][itemGiftXMas.giftId])
					{
						event["IconChristmas"]["Exchange"][itemGiftXMas.giftId]++ 
					}
					else
					{
						event["IconChristmas"]["Exchange"][itemGiftXMas.giftId] = 1;
					}
					GameLogic.getInstance().user.UpdateStockThing("SockExchange", 1, -itemGiftXMas.numSock);
					GuiMgr.getInstance().guiGiftXMas.numSock -= itemGiftXMas.numSock;
					Hide();
					GuiMgr.getInstance().GuiStore.Hide();
					break;
				default:
					for each(var ctn:Container in ContainerArr)
					{
						if (ctn.IdObject == buttonID)
						{
							ctn.SetHighLight(0xff0000);
							selectedElement = int(buttonID) + 1;
							//GetButton(BTN_GET_GIFT).SetEnable(true);
						}
						else
						{
							ctn.SetHighLight( -1);
						}
					}
			}
		}
		
	}

}