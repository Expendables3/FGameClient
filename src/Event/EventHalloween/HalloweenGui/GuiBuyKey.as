package Event.EventHalloween.HalloweenGui 
{
	import Data.ConfigJSON;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import GUI.GuiBuyAbstract.GuiBuyAbstract;
	import GUI.GuiMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiBuyKey extends GuiBuyAbstract 
	{
		public function GuiBuyKey(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiBuyKey";
			ThemeName = "GuiBuyKey_Theme";
			_urlBuyAPI = "EventService.hal_buyItem";
			//_urlBuyAPI = "FakeEventService.buyItemEvent";
			_idBuyAPI = "";
			isBuyOnce = true;
		}
		override protected function onInitGui():void 
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 350, 18);
			var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["BuyKey"]["ZMoney"];
			AddButton(CMD_BUY + "_BuyKey_1_" + price + "_ZMoney", _guiName + "_BtnBuyZMoney", 150, 215);
			AddLabel(Ultility.StandardNumber(price), 157, 221, 0xffffff, 1, 0x000000);
		}
		
		override protected function onUpdateAfterClickBuy(type:String, id:int):void 
		{
			HalloweenMgr.getInstance().Key++;
			GuiMgr.getInstance().guiHalloween.refreshNumKey();
		}
	}

}














