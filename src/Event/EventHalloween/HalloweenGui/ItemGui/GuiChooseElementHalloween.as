package Event.EventHalloween.HalloweenGui.ItemGui 
{
	import Event.TreasureIsland.SendChangeMedalVip;
	import GUI.GUIChooseElementAbstract;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiChooseElementHalloween extends GUIChooseElementAbstract 
	{
		public var numMedalRequire:int;
		
		public function GuiChooseElementHalloween(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiChooseElementHalloween";
			Type = "Element";
		}
		override public function receiveGift(element:int):void 
		{
			/*trừ kim bài*/
			GuiMgr.getInstance().guiChangeMedalEvent.medalNum -= numMedalRequire;
			GameLogic.getInstance().numMedalHalloween -= numMedalRequire;
			/*gửi gói tin lên server*/
			var pk:SendChangeMedalVip = new SendChangeMedalVip(3, element);
			Exchange.GetInstance().Send(pk);
			Hide();
		}
		override public function OnHideGUI():void 
		{
			numMedalRequire = 0;
		}
		override protected function addNumGift():void 
		{
			isClick = false;
		}
	}

}














