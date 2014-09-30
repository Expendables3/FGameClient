package GUI.Mail.SystemMail.View 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import GUI.Mail.SystemMail.Controller.GiftInputCodeMgr;
	import GUI.Mail.SystemMail.MailPackage.SendInputCode;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIInputCode extends BaseGUI 
	{
		static public const ID_BTN_PASTE:String = "idBtnPaste";
		static public const ID_BTN_RECEIVE:String = "idBtnReceive";
		static public const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_TB_CODE:String = "idTextBoxCode";
		
		// gui
		private var _strCode:String;
		private var _tooltip:TooltipFormat;
		private var tbCode:TextBox;
		private var imgFail:Image;
		private var btnReceive:Button;
		private var btnPaste:Button;
		private var btnClose:Button;
		private var guiGift:GUIInputCodeGift = new GUIInputCodeGift(null, "");
		public function GUIInputCode(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIInputCode";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				_strCode = GameLogic.getInstance().CodeString;
				addBgr();
			}
			LoadRes("GuiInputCode_Theme");
		}
		public function addBgr():void
		{
			_tooltip = new TooltipFormat();
			btnClose = AddButton(ID_BTN_CLOSE, "BtnThoat", 416, 21);
			btnReceive = AddButton(ID_BTN_RECEIVE, "GuiInputCode_BtnReceive", 326, 109);
			AddImage("", "GuiInputCode_ImgInputBg", 185, 120);
			imgFail = AddImage("", "GuiInputCode_ImgNoticeFail", 183, 155);
			imgFail.img.visible = false;
			tbCode = AddTextBox(ID_TB_CODE, "", 77, 110, 230, 25, this);
			var fm:TextFormat = new TextFormat();
			fm.size = 14;
			fm.color = 0x000000;
			tbCode.SetTextFormat(fm);
			btnReceive.SetDisable();
			btnPaste = AddButton(ID_BTN_PASTE, "GuiInputCode_BtnPaste", 310, 143);
			if (_strCode.length == 0)
			{
				_tooltip.text = "Chưa copy code";
			}
			else {
				_tooltip.text = "paste code đã copy từ thư hệ thống";
			}
			btnPaste.setTooltip(_tooltip);
		}

		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			switch(txtID)
			{
				case ID_TB_CODE:
					var isEnable:Boolean = tbCode.GetText().length > 0;
					btnReceive.SetEnable(isEnable);
				break;
			}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_RECEIVE:
					inputCode();
				break;
				case ID_BTN_PASTE:
					pasteCode();
				break;
			}
		}
		
		private function pasteCode():void 
		{
			tbCode.SetText(_strCode);
			if (_strCode.length > 0)
			{
				btnReceive.SetEnable();
			}
		}
		
		private function inputCode():void
		{
			var str:String = tbCode.textField.text;
			trace("send lên : " + str);
			if (str == "")
				return;
			var c:String = str.charAt(0);
			if (c == 'E')
			{
				var guiElement:GuiInputCodeElement = new GuiInputCodeElement(null, "");
				guiElement.Code = str;
				guiElement.Show(Constant.GUI_MIN_LAYER, 5);
				return;
			}
			else if (c == 'N')
			{
				var pk:SendInputCode = new SendInputCode(str);
				Exchange.GetInstance().Send(pk);
			}
			btnClose.SetDisable();
			btnReceive.SetDisable();
		}
		
		public function processReceiveGift(data:Object):void
		{
			if (data.Error != 0)
			{
				if (imgFail != null) {
					imgFail.img.visible = true;
					tbCode.SetText("");
					btnClose.SetEnable();
				}
			}
			else
			{
				imgFail.img.visible = false;
				GiftInputCodeMgr.getInstance().initData(data["Gift"]);
				guiGift.Show(Constant.GUI_MIN_LAYER, 5);
				Hide();
			}
			
		}
		override public function Hide():void 
		{
			_tooltip = null;
			super.Hide();
		}
	}

}























