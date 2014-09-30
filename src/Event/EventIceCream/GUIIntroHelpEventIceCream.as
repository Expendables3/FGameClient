package Event.EventIceCream 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIIntroHelpEventIceCream extends BaseGUI 
	{
		public function GUIIntroHelpEventIceCream(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIIntroHelpEventIceCream";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			this.setImgInfo = function ():void 
			{
				SetPos(210, 80);
				OpenRoomOut();
			}
			LoadRes("EventIceCream_ImgBgGuiIntroHelp");
		}
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			AddButton("BtnDetail", "EventIceCream_BtnHint", 210, 300, this);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case "BtnDetail":
					GuiMgr.getInstance().GuiMainEventIceCream.Show(Constant.GUI_MIN_LAYER, 3);
					GuiMgr.getInstance().GuiGetGiftDaily.Show(Constant.GUI_MIN_LAYER, 3);
					Hide();
				break;
			}
		}
	}

}