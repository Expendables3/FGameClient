package GUI.Password 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIDetailLockAction extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		
		public function GUIDetailLockAction(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(200 - 86, 100);
				AddButton(BTN_CLOSE, "BtnThoat", 532, 22);
				AddButton(BTN_CLOSE, "BtnDong", 150 + 95, 370);
			}
			LoadRes("GuiDetailLockAction_Theme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID == BTN_CLOSE)
			{
				Hide();
			}
		}
		
	}

}