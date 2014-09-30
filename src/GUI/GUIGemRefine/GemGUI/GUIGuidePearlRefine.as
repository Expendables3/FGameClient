package GUI.GUIGemRefine.GemGUI 
{
	import flash.events.MouseEvent;
	import GameControl.HelperMgr;
	import GUI.component.BaseGUI;
	import Logic.QuestMgr;
	
	/**
	 * ...
	 * @author SieuSon
	 */
	public class GUIGuidePearlRefine extends BaseGUI 
	{
		static public const ICON_HELPER:String = "iconHelper";
		private const BTN_CLOSE:String = "btnThoat";
		private const BTN_BACK:String = "back";
		private const BTN_NEXT:String = "next";
		private var index:int = 1;
		public function GUIGuidePearlRefine(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		}
		
		override public function InitGUI():void 
		{
			SetImg();
			
		}
		
		public function ShowGui():void 
		{
			Show();
		}
		
		private function SetImg():void 
		{
			this.setImgInfo = function():void
			{
				AddButtons();
				if (index == 1)
				{
					GetButton(BTN_BACK).SetDisable();
				}
				if (index == 4)
				{
					GetButton(BTN_NEXT).SetDisable();
					
					var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
					if (curTutorial.search("BtnExitPearl") >= 0)
					{
						GetImage(ICON_HELPER).SetPos(10 + 664, 200 - 162);
					}
				}
				
				ShowDisableScreen(0.5);
				SetPos(80,60);
			}
			
			if (index < 0)
			{
				index = 1;
			}
			if (index > 4)
			{
				index = 4;
			}
			
			Clear();
			LoadRes("GuiGuidePearlRefine_Theme"+index);
		}
		
		private function AddButtons():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 647, 18, this);
			AddButton(BTN_NEXT, "GuiGuidePearlRefine_Btn_Next_Guide_TuLuyenNgoc", 353, 453, this);
			AddButton(BTN_BACK, "GuiGuidePearlRefine_Btn_Back_Guide_TuLuyenNgoc", 209,453, this);
			
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("BtnNextGuide") >= 0)
			{
				AddImage(ICON_HELPER, "IcHelper", 420, 467);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
					HideDisableScreen();
					
				break;
				case BTN_NEXT:
					index++;
					SetImg();
				break;
				case BTN_BACK:
					index--;
					SetImg();
				break;
			}
		}
		
		
		
	}

}