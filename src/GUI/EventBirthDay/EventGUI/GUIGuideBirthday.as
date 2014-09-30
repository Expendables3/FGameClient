package GUI.EventBirthDay.EventGUI 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIGuideBirthday extends BaseGUI 
	{
		static public const ID_BTN_CLOSE:String = "idBtnClose";
		
		public function GUIGuideBirthday(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGuideBirthday";
		}
		override public function InitGUI():void 
		{
			LoadRes("EventBirthDay_GUIGuide");
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