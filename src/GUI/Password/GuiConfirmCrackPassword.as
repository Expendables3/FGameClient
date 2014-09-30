package GUI.Password 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GuiConfirmCrackPassword extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_OK:String = "btnOk";
		private var okFunction:Function;
		private var bgName:String;
		
		public function GuiConfirmCrackPassword(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(200, 150);
				AddButton(BTN_CLOSE, "BtnThoat", img.width - 40, 22);
				AddButton(BTN_OK, "GuiPassword_BtnConfirm", img.width / 2 - 100, img.height - 60);
				AddButton(BTN_CLOSE, "GuiPassword_BtnCancel", img.width / 2 + 40, img.height - 60);
			}
			LoadRes(bgName);
		}
		
		public function showGUI(_bgName:String, _okFunction:Function):void
		{
			bgName = _bgName;
			okFunction = _okFunction;
			Show(Constant.GUI_MIN_LAYER, 3)
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_OK:
					if (okFunction != null)
					{
						okFunction();
					}
					Hide();
					break;
			}
		}
		
	}

}