package Event.EventIceCream 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIHelpIceCream extends BaseGUI 
	{
		
		public function GUIHelpIceCream(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIHelpIceCream";
		}
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("EventIceCream_ImgBgGuiHelp");
			SetPos(30, 20);
			AddButton("BtnClose", "BtnThoat", 705, 20, this);
			AddButton("BtnDetail", "EventIceCream_BtnHint", 300, 513, this);
			EndingRoomOut();
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case "BtnClose":
					Hide();
				break;
				case "BtnDetail":
					GuiMgr.getInstance().GuiMainEventIceCream.CreateHelp();
					Hide();
				break;
			}
		}
	}

}