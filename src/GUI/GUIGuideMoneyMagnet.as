package GUI 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author Sonbt
	 */
	public class GUIGuideMoneyMagnet extends BaseGUI 
	{
		private const BTN_CLOSE:String = "btnClose";
		
		public function GUIGuideMoneyMagnet(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButtons();
			}
			LoadRes("GuiGuideMagnetMoney_Theme");
		}
		
		public function ShowGui():void 
		{
			Show();
			ShowDisableScreen(0.5);
			SetPos(75, 65);
		}
		
		private function AddButtons():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 647, 18);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
					HideDisableScreen();
				break;
				
			}
		}
		
	}

}