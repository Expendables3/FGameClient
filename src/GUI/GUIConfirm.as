package GUI 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIConfirm extends BaseGUI 
	{
		static public const BTN_OK:String = "btnOk";
		static public const BTN_CANCEL:String = "btnCancel";
		static public const BTN_CLOSE:String = "btnClose";
		private var txtMessage:TextField;
		private var okFunction:Function;
		
		public function GUIConfirm(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("ImgFrameFriend");		
			AddImage("", "ImgBgGUIMessage", 90, 95);			
			AddImage("", "NPC_Paul", 52, 235);
			
			AddButton(BTN_OK, "BtnDongY",65 - 16, 207 - 20);
			var btnCancel:Button = AddButton(BTN_CANCEL, "Btn_BoQua", 195 - 16, 207 - 20);
			btnCancel.img.scaleX = btnCancel.img.scaleY = 1.4;
			AddButton(BTN_CLOSE, "BtnThoat", 280, 75 - 137);
			SetPos(200 + 123, 100 + 126);
		}
		
		public function showGUI(message:String, _okFunction:Function):void
		{
			Show(Constant.GUI_MIN_LAYER, 3);
			txtMessage = AddLabel(message, 120 + 170 - 241, 10, 0x000000, 0, 0xffffff);
			var format:TextFormat = new TextFormat("arial", 16, 0x000000, true);
			format.align = TextFormatAlign.LEFT;
			txtMessage.setTextFormat(format);
			txtMessage.width = 210;
			txtMessage.multiline = true;
			txtMessage.wordWrap = true;
			okFunction = _okFunction;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_OK:
					if (okFunction != null)
					{
						okFunction();
					}
					Hide();
					break;
				case BTN_CANCEL:
				case BTN_CLOSE:
					Hide();
					break;
			}
		}
	}

}