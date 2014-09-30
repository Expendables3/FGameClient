package Event.TreasureIsland 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIHelpTreasureIsland extends BaseGUI 
	{
		private const GUI_GUIDE_BTN_CLOSE:String = "btnClose";
		private const GUI_GUIDE_BTN_BACK:String = "btnBack";
		private const GUI_GUIDE_BTN_NEXT:String = "btnNext";
		private const GUI_GUIDE_BTN_KNOWN:String = "btnKnown";
		
		private var btnNext:Button;
		private var btnPrev:Button;
		private var btnDone:Button;
		private var curPage:int = 1;
		private var totalPage:int = 5;
		
		public function GUIHelpTreasureIsland(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIHelpTreasureIsland";
		}
		
		override public function InitGUI():void 
		{
			LoadRes("TreasureIsland_GUIHelp1");
			SetPos(Constant.STAGE_WIDTH / 2 - this.img.width / 2, Constant.STAGE_HEIGHT / 2 - this.img.height / 2);
			
			AddButton(GUI_GUIDE_BTN_CLOSE, "BtnThoat", img.width - 35, 20);
			btnPrev = AddButton(GUI_GUIDE_BTN_BACK, "Help_BtnBack", img.width / 2 - 170, img.height - 50, this);
			btnNext = AddButton(GUI_GUIDE_BTN_NEXT, "Help_BtnNext", img.width / 2 + 50, img.height - 50, this);
			btnDone = AddButton(GUI_GUIDE_BTN_KNOWN, "Help_BtnDone", img.width / 2 + 50, img.height - 50, this);
			
			btnPrev.SetVisible(false);
			btnDone.SetVisible(false);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case GUI_GUIDE_BTN_CLOSE:
				case GUI_GUIDE_BTN_KNOWN:
					Hide();
					curPage = 1;
				break;
				case GUI_GUIDE_BTN_NEXT:
					nextPage();
				break;
				case GUI_GUIDE_BTN_BACK:
					prevPage();
				break;
			}
		}
		
		private function prevPage():void 
		{
			this.Clear();
			
			curPage--;
			LoadRes("TreasureIsland_GUIHelp" + curPage);
			SetPos(Constant.STAGE_WIDTH / 2 - this.img.width / 2, Constant.STAGE_HEIGHT / 2 - this.img.height / 2);
			
			AddButton(GUI_GUIDE_BTN_CLOSE, "BtnThoat", img.width - 35, 20);
			btnPrev = AddButton(GUI_GUIDE_BTN_BACK, "Help_BtnBack", img.width / 2 - 170, img.height - 50, this);
			btnNext = AddButton(GUI_GUIDE_BTN_NEXT, "Help_BtnNext", img.width / 2 + 50, img.height - 50, this);
			btnDone = AddButton(GUI_GUIDE_BTN_KNOWN, "Help_BtnDone", img.width / 2 + 50, img.height - 50, this);
			
			btnPrev.SetVisible(true);
			if (curPage <= 1)
			{
				btnPrev.SetVisible(false);
			}
			btnDone.SetVisible(false);
			btnNext.SetVisible(true);
		}
		
		private function nextPage():void 
		{
			this.Clear();
			curPage++;
			
			LoadRes("TreasureIsland_GUIHelp" + curPage);
			SetPos(Constant.STAGE_WIDTH / 2 - this.img.width / 2, Constant.STAGE_HEIGHT / 2 - this.img.height / 2);
			
			AddButton(GUI_GUIDE_BTN_CLOSE, "BtnThoat", img.width - 35, 20);
			btnPrev = AddButton(GUI_GUIDE_BTN_BACK, "Help_BtnBack", img.width / 2 - 170, img.height - 50, this);
			btnNext = AddButton(GUI_GUIDE_BTN_NEXT, "Help_BtnNext", img.width / 2 + 50, img.height - 50, this);
			btnDone = AddButton(GUI_GUIDE_BTN_KNOWN, "Help_BtnDone", img.width / 2 + 50, img.height - 50, this);
			
			btnDone.SetVisible(false);
			btnNext.SetVisible(true);
			if (curPage >= totalPage)
			{
				btnNext.SetVisible(false);
				btnDone.SetVisible(true);
			}
			btnPrev.SetVisible(true);
		}
	}

}