package GUI.Event8March 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIFlowerGuide extends BaseGUI 
	{
		private const ID_BTN_CLOSE:String = "idbtnClose";
		public function GUIFlowerGuide(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIFlowerGuide";
		}
		override public function InitGUI():void 
		{
			LoadRes("Event83_GUIGide");
			AddButton(ID_BTN_CLOSE, "BtnThoat", 707, 20);
			SetPos(40, 22);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
			}
		}
	}

}