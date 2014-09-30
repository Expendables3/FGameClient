package Event.EventHalloween.HalloweenGui.ItemGui 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiMessageAuto extends BaseGUI 
	{
		static public const ID_BTN_CLOSE:String = "idBtnClose";
		static public const ID_BTN_ACCEPT:String = "idBtnAccept";
		static public const ID_BTN_CANCEL:String = "idBtnCancel";
		
		public function GuiMessageAuto(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiMessageAuto";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(ID_BTN_CLOSE, "BtnThoat", 350, 15);
				AddButton(ID_BTN_ACCEPT, "GuiMessageAuto_BtnAccept", 80, 220);
				AddButton(ID_BTN_CANCEL, "GuiMessageAuto_BtnCancel", 230, 220);
				var tfTip:TextField = AddLabel("", 25, 70);
				var fm:TextFormat  = new TextFormat("Arial", 12);
				fm.align = TextFormatAlign.CENTER;
				tfTip.defaultTextFormat = fm;
				tfTip.text = "Sử dụng chức năng Tự động sẽ mất những phần thưởng đã nhận. Bạn sẽ nhận phần thưởng mới. Bạn có chắc chắn sử dụng";
				tfTip.wordWrap = true;
				tfTip.width = 332;
			}
			LoadRes("GuiMessageAuto_Theme");
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
				case ID_BTN_CANCEL:
					Hide();
					break;
				case ID_BTN_ACCEPT:
					Hide();
					GuiMgr.getInstance().guiFinishAuto.Show(Constant.GUI_MIN_LAYER, 5);
					break;
			}
		}
	}

}













