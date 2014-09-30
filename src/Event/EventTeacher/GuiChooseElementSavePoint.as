package Event.EventTeacher 
{
	import Data.ConfigJSON;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventHalloween.HalloweenPackage.SendExchangeAccumulationPoint;
	import GUI.GUIChooseElementAbstract;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiChooseElementSavePoint extends GUIChooseElementAbstract 
	{
		public var giftId:int;
		public function GuiChooseElementSavePoint(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiChooseElementSavePoint";
		}
		override public function receiveGift(element:int):void 
		{
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("Accumulation_Point");
			var dPoint:int = cfg[giftId]["Point"];
			HalloweenMgr.getInstance().nPoint -= dPoint;
			GuiMgr.getInstance().guiSavePoint.refreshPoint();
			GuiMgr.getInstance().guiSavePoint.refreshListBtnReceive();
			
			var pk:SendExchangeAccumulationPoint = new SendExchangeAccumulationPoint(giftId, element);
			Exchange.GetInstance().Send(pk);
			Hide();
		}
		override protected function onClose():void 
		{
			GuiMgr.getInstance().guiSavePoint.inExchange = false;
			Hide();
		}
		override protected function addNumGift():void 
		{
			isClick = false;
		}

	}

}























