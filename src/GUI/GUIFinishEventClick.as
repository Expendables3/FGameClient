package GUI 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIFinishEventClick extends BaseGUI 
	{
		public static const BTN_CLOSE:String = "btnClose";
	
		public function GUIFinishEventClick(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFinishEventClick";
		}	
		
		public override function InitGUI() :void
		{
			LoadRes("GuiFinishEventClick");
			SetPos(125, 40);
			AddButton(BTN_CLOSE, "BtnThoat", 540, 20, this);
			OpenRoomOut();			
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE:
				{
					Hide();
					GuiMgr.getInstance().GuiTienCa.Hide();
					break;
				}				
			}
		}
		
	}

}