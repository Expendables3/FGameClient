package GUI.Mail.SystemMail.View 
{
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import GUI.AvatarImage;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.TextBox;
	import GUI.Mail.SystemMail.Model.MailInfo;
	import Logic.GameLogic;
	
	/**
	 * GUI đọc thư hệ thống
	 * @author HiepNM2
	 */
	public class GUIReadSystemMail extends BaseGUI 
	{
		// const
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_COPY_CODE:String = "idBtnCopyCode";
		private const ID_BTN_END:String = "idBtnEnd";
		private const ID_TEXTBOX_CONTENT:String = "idTextBoxContent";
		private const ID_BTN_SCROLL:String = "idBtnScroll";
		private const ID_BTN_UP:String = "idBtnUp";
		private const ID_BTN_DOWN:String = "idBtnDown";
		private const ID_BTN_SHIFT:String = "idBtnShift";
		
		private const _xContent:int = 265;
		private const _yContent:int = 180;
		private const MINY: int = _yContent - 34;
		private const MAXY: int = _yContent + 39;
		private const MIN_SHOW: int = 4;
		// logic
		private var _mail:MailInfo;
		private var isBtnShiftHold:Boolean;
		private var textSample:String = "như có Bác Hồ trong ngày vui đại thắng\n Lời Bác đây đã thành chiến thắng huy hoàng\n Ba mươi năm đấu tranh giành chọn vẹn non sông";
		// gui
		private var tbContent:TextBox;
		private var btnUp:Button;
		private var btnDown:Button;
		private var btnShift:Button;
		private var avatar:AvatarImage;
		private var _fmRed:TextFormat;
		private var _fmBlack:TextFormat;
		private var _fmBlue:TextFormat;
		
		public function GUIReadSystemMail(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "";
			_fmRed = new TextFormat();
			_fmRed.size = 16;
			_fmRed.color = 0xff0000;
			_fmRed.bold = true;
			_fmRed.italic = true;
			
			_fmBlack = new TextFormat();
			_fmBlack.size = 16;
			_fmBlack.color = 0x000000;
			_fmBlack.bold = true;
			
			_fmBlue = new TextFormat();
			_fmBlue.color = 0x000000;
			_fmBlue.bold = true;
			
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(ID_BTN_CLOSE, "BtnThoat", 411, 19);
				AddButton(ID_BTN_END, "BtnDong", img.width / 2 + 34, img.height - 48);
				AddButton(ID_BTN_COPY_CODE, "GuiReadSystemMail_BtnCopyCode", img.width / 2 - 125, img.height - 52);
				addAvatar();
				
				addItemMail();
				addTime();
			}
			LoadRes("GuiReadSystemMail_Theme");
		}
		public function initData(mail:MailInfo):void
		{
			_mail = mail;
		}
		
		private function addAvatar():void
		{
			var tfName:TextField = AddLabel("Hệ thống", 50, 100, 0x096791);
			var fm:TextFormat = new TextFormat();
			fm.bold = true;
			tfName.setTextFormat(fm);
			var avatarLink:String = Main.staticURL + "/avatar.png";
			avatar = new AvatarImage(this.img);
			avatar.initAvatar(avatarLink, onLoadAvatarComp);
			function onLoadAvatarComp():void
			{
				avatar.FitRect(60, 60, new Point(70, 120));
			}
		}
		
		private function addTime():void
		{
			var strHead:String = "gửi lúc: ";
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:Number = curTime - _mail.FromTime;
			var szTime:String;
			var iTime:int;
			var szUnit:String;
			if (remainTime < 86400)
			{
				if (remainTime < 3600)
				{
					if (remainTime < 60)
					{
						iTime = (int)(remainTime);
						szUnit = "giây";
					}
					else
					{
						iTime = (int)(remainTime / 60);
						szUnit = "phút";
					}
				}
				else
				{
					iTime = (int)(remainTime / 3600);
					szUnit = "tiếng";
				}
			}
			else
			{
				iTime = (int)(remainTime / 86400);
				szUnit = "ngày";
			}
			var str:String = strHead + iTime + " " + szUnit + " trước";
			
			var tfTime:TextField = AddLabel(str, 180, 101);
			tfTime.setTextFormat(_fmBlack, 0, strHead.length);
			tfTime.setTextFormat(_fmRed, strHead.length, str.length);
			
		}
		private function addItemMail():void
		{
			AddImage("", "GuiReadSystemMail_ImgSpeech", _xContent, _yContent);
			var fm:TextFormat = new TextFormat("Arial", 14, 0x096791);
			fm.leading = 10;
			fm.bold = true;
			
			tbContent = AddTextBox(ID_TEXTBOX_CONTENT, _mail.Content, _xContent - 105, _yContent - 50, 220, 124);
			//tbContent.SetBoder(true);
			tbContent.textField.type = TextFieldType.DYNAMIC;
			tbContent.textField.wordWrap = true;
			tbContent.textField.multiline = true;
			
			tbContent.SetTextFormat(fm);
			if (tbContent.textField.numLines > 3)
			{
				var scroll:Button = AddButton(ID_BTN_SCROLL, "GuiReadSystemMail_BtnSpane", _xContent + 120, _yContent - 54);
				scroll.img.scaleY = 1.8;
				btnUp = AddButton(ID_BTN_UP, "GuiReadSystemMail_BtnGoUppMini", _xContent + 120, _yContent - 54);
				btnDown = AddButton(ID_BTN_DOWN, "GuiReadSystemMail_BtnGoBottomMini", _xContent + 120, MAXY + 20);
				btnShift = AddButton(ID_BTN_SHIFT, "GuiReadSystemMail_BtnThanhTruotMini", _xContent + 120, MINY);
				btnShift.img.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				this.img.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				this.img.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_END:
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_UP:
					var y1: int = btnShift.img.y - (MAXY - MINY) / (tbContent.textField.numLines / MIN_SHOW);	
					if (y1 <= MINY)
					{
						btnShift.img.y = MINY;
					}
					else
					{
						btnShift.img.y -= (MAXY - MINY) / (tbContent.textField.numLines / MIN_SHOW);
					}
					tbContent.textField.scrollV -= 4 * tbContent.textField.maxScrollV / (tbContent.textField.numLines );
				break;
				case ID_BTN_DOWN:
					var y2: int = btnShift.img.y + (MAXY - MINY) / (tbContent.textField.numLines / MIN_SHOW);	
					if (y2 >= MAXY)
					{
						btnShift.img.y = MAXY;
					}
					else
					{
						btnShift.img.y += (MAXY - MINY) / (tbContent.textField.numLines / MIN_SHOW);
					}
					tbContent.textField.scrollV += 4 * tbContent.textField.maxScrollV / (tbContent.textField.numLines );
				break;
				case ID_BTN_SCROLL:
					trace("don't click on Pane");
				break;
				case ID_BTN_COPY_CODE:
					copyCode();
				break;
			}
		}
		
		private function onMouseDown(event:MouseEvent):void
		{
			isBtnShiftHold = true;
		}
		
		private function onMouseUp(event:MouseEvent):void
		{
			isBtnShiftHold = false;
		}
		
		private function onMouseMove(event:MouseEvent):void
		{
			if (isBtnShiftHold)
			{
				btnShift.img.y = GameInput.getInstance().MousePos.y - 150;
				if (btnShift.img.y <= MINY) btnShift.img.y = MINY;
				if ( btnShift.img.y >= MAXY) btnShift.img.y = MAXY;						
				tbContent.textField.scrollV =  (btnShift.img.y - MINY) / (MAXY - MINY) * tbContent.textField.maxScrollV;
			}
		}
		private function copyCode():void
		{
			var strContent:String = _mail.Content;
			var iFirst:int = strContent.indexOf("\"", 0);
			var iEnd:int = strContent.indexOf("\"", iFirst + 1);
			if (iFirst < 0 || iEnd < 0)
			{
				trace("ko co code");
				Hide();
				return;
			}
			var code:String = strContent.substr(iFirst + 1, iEnd - iFirst - 1);
			if (code.length > 0)
			{
				trace("code = " + code);
				System.setClipboard(code);
			}
			else
			{
				trace("ko co code");
			}
			GameLogic.getInstance().CodeString = code;
			Hide();
		}
		
	}
}

























