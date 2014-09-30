package Event.EventHalloween.HalloweenGui 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import GUI.GuiBuyAbstract.GuiBuyAbstract;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * gui mua đá
	 * @author HiepNM2
	 */
	public class GuiBuyRock extends GuiBuyAbstract 
	{
		
		public function GuiBuyRock(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiBuyRock";
			ThemeName = "GuiBuyRock_Theme";
			_urlBuyAPI = "EventService.hal_buyItem";
			//_urlBuyAPI = "FakeEventService.buyItemEvent";
			_idBuyAPI = Constant.CMD_BUY_PACK_HALLOWEEN;
			isBuyOnce = true;
		}
		
		override protected function onInitGui():void 
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 350, 18);
			//AddImage("", "GuiBuyRock_ImgRockBag", 260, 100, true, ALIGN_LEFT_TOP);
			var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["BuyPack"]["ZMoney"];
			AddButton(CMD_BUY + "_BuyPack_1_" + price + "_ZMoney", _guiName + "_BtnBuyZMoney", 150, 225);
			AddLabel(Ultility.StandardNumber(price), 157, 231, 0xffffff, 1, 0x000000);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case ID_BTN_CLOSE:
					Hide();
					break;
				case CMD_BUY:
					var type:String = data[1];
					var id:int = data[2];
					var price:int = int(data[3]);
					var priceType:String = data[4];
					var myMoney:int;
					if (priceType == "ZMoney")
					{
						myMoney = GameLogic.getInstance().user.GetZMoney();
					}
					else if (priceType == "Money")
					{
						myMoney = GameLogic.getInstance().user.GetMoney();
					}
					else if (priceType == "Diamond")
					{
						myMoney = GameLogic.getInstance().user.getDiamond();
					}
					GuiMgr.getInstance().guiBuyMultiRock.priceType = priceType;
					GuiMgr.getInstance().guiBuyMultiRock.costPerPack = price;
					GuiMgr.getInstance().guiBuyMultiRock.showGUI(int(myMoney / price), "Túi đá mật mã", "GuiHalloween_ImgBag", function f(numPack:int):void
					{
						if (numPack > 0)
						{
							if (Ultility.payMoney(priceType, price * numPack))
							{
								GuiMgr.getInstance().guiBuyContinue.numPack = numPack;
								GuiMgr.getInstance().guiBuyContinue.Show(Constant.GUI_MIN_LAYER, 5);
								//inBuyPack = true;
							}
						}
					});
					//if (Ultility.payMoney(priceType, price))
					//{
						//GuiMgr.getInstance().guiBuyContinue.Show(Constant.GUI_MIN_LAYER, 5);
					//}
					Hide();
					break;
			}
		}
		override protected function onUpdateAfterClickBuy(type:String, id:int):void 
		{
			
		}
	}

}

















