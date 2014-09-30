package GUI.Mail 
{
	import com.adobe.utils.StringUtil;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.GameState;
	import flash.events.MouseEvent;
	import NetworkPacket.PacketSend.SendAcceptGift;
	import NetworkPacket.PacketSend.SendLetter;
	import NetworkPacket.PacketSend.SendRemoveMessage;
	import flash.text.TextFieldType;	
	import Data.Localization;
	/**
	 * ...
	 * @author Hiep
	 * Xem và trả lời thư bạn xem truyền hình :D
	 */
	public class GUIReceiveLetter extends BaseGUI
	{
		private const GUI_LETTER_TXT_WIRTER:String = "Writer";	
		private const GUI_LETTER_BTN_SEND: String = "Send";
		private const GUI_RECEIVELETTER_BTN_CLOSE:String = "ButtonClose";		
		private const GUI_LETTER_BUTTON_POPUP: String = "ButtonPopUp";
		private const GUI_LETTER_BUTTON_POPDOWN: String = "ButtonPopDown";
		private const GUI_LETTER_BUTTON_SCROLLBAR: String = "ScrollBar";
		private const GUI_LETTER_BUTTON_THANHKEO: String = "ThanhKeo";
		
		private var txtWriter: TextBox;
		private  var LetterId: int;
		private var FromId: int;
		public var btnPopUp: Button;
		public var btnPopDown: Button;
		public var btnThanhKeo: Button;
		public var btn: Button;
		private var btnSend: Button;
		public var textContent: TextBox;
		public var MIN_SHOW: int = 4;
		public var MINY: int = 107;
		public var MAXY: int = 125;
		public var IsChoose: Boolean = false;		
		
		public function GUIReceiveLetter(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIReceiveLetter";
		}
		
		public override function InitGUI(): void
		{
			this.setImgInfo = function():void
			{
				AddImage("", "GuiReceiveLetter_ImgLetterScene", 26.65 + 197, 278.55 + 53);
				
				var imgDongVietThu: Image = AddImage("", "GuiReceiveLetter_ImgDongVietThu", 108.4, 197.5 + 53, true, ALIGN_LEFT_CENTER);
				imgDongVietThu.img.alpha = 0.6;
				
				//add button
				var btn: Button = AddButton(GUI_RECEIVELETTER_BTN_CLOSE, "BtnThoat", 409.95, 18.05, this);
				btnSend = AddButton(GUI_LETTER_BTN_SEND, "GuiReceiveLetter_BtnGuiThu", 177.5, 361.95, this);
				btnSend.SetDisable();
				
				//hiện nội dung lá thư
				AddImage("", "GuiReceiveLetter_ImgReadMail", 130.4 + 145, 70.65 + 53);
				var i: int;
				var Content: String;	
				
				LetterId = GuiMgr.getInstance().GuiNewMail.GetCurLetterId();
				var arr:Array = GameLogic.getInstance().user.LetterArr;
				for (i = 0; i < arr.length; i++)
				{
					if (arr[i].Id == LetterId)
					{
						//lay Id cua thang gui thu
						FromId = arr[i].FromId;
						//lay noi dung
						Content = arr[i].Content;
						var txtformat: TextFormat = new TextFormat("Arial",14);
						textContent = AddTextBox("", Content, 135+ 27, 75+ 20, 216, 60);
						textContent.textField.textColor = 0x000000;
						txtformat.leading = 10;
						textContent.textField.type = TextFieldType.DYNAMIC;
						textContent.textField.wordWrap = true;
						textContent.textField.multiline = true;
						
						textContent.textField.setTextFormat(txtformat, 0, Content.length);					
						textContent.textField.selectable = false;
						if (textContent.textField.numLines > 2)
						{	
							var scroll: Button = AddButton(GUI_LETTER_BUTTON_SCROLLBAR, "GuiReceiveLetter_BtnSpane", 383.25+6, 75+12,this);
							scroll.img.scaleY = 1;
							btnPopUp = AddButton(GUI_LETTER_BUTTON_POPUP, "GuiReceiveLetter_BtnGoUppMini", 382.5+6, 77.45+12, this);
							btnPopDown = AddButton(GUI_LETTER_BUTTON_POPDOWN, "GuiReceiveLetter_BtnGoBottomMini", 382.5+6, 130.45+12, this);	
							//btnPopDown.img.rotation = 180;						
							btnThanhKeo = AddButton(GUI_LETTER_BUTTON_THANHKEO, "GuiReceiveLetter_BtnThanhTruotMini", 382.45+6, MINY, this);			
							btnThanhKeo.img.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
							this.img.stage.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
							this.img.stage.addEventListener(MouseEvent.MOUSE_MOVE, OnMouseMove);						
						}
						break;                           
					}
				}	
				
				//Hien avatar va ten nguoi gui thu
				var avatar: String ;
				var name: String;				
				for (i = 0; i < GameLogic.getInstance().user.FriendArr.length; i++)
				{
					if (GameLogic.getInstance().user.FriendArr[i].ID == FromId)
					{
						avatar = GameLogic.getInstance().user.FriendArr[i].imgName;
						name = GameLogic.getInstance().user.FriendArr[i].NickName;											
						if (name.length >= 10)
						{
							name = name.substr(0, 7);
							name += "...";
						}
						var imgAvatar: Image  = AddImage("", avatar, 52, 78, false, ALIGN_LEFT_TOP);
						imgAvatar.SetSize(50,50);
						AddLabel(name, 27, 131);
						break;
					}
				}
				//hiện cái dòng viết thư trả lời
				txtWriter = AddTextBox(GUI_LETTER_TXT_WIRTER, "", 108.4, 194, 260, 120);		
				txtWriter.textField.multiline = true;			
				txtWriter.MyParent = this;
				var formatter:TextFormat = new TextFormat( );		
				
				formatter.leading = 11;						
				formatter.size = 14;
				txtWriter.textField.maxChars = 250;
				txtWriter.textField.defaultTextFormat = formatter;
				txtWriter.textField.wordWrap = true;						
				txtWriter.textField.textColor = 0x0000FF;			
				this.img.stage.focus = txtWriter.textField;
				SetPos(190, 90);
				OpenRoomOut();
			}
			LoadRes("GuiReceiveLetter_Theme");
		}
		
		private function OnMouseMove(e:MouseEvent):void 
		{
			if (IsChoose)
			{
				btnThanhKeo.img.y = GameInput.getInstance().MousePos.y - 150;
				if (btnThanhKeo.img.y <= MINY) btnThanhKeo.img.y = MINY;
				if ( btnThanhKeo.img.y >= MAXY) btnThanhKeo.img.y = MAXY;						
				textContent.textField.scrollV =  (btnThanhKeo.img.y - MINY) / (MAXY - MINY) * textContent.textField.maxScrollV;
			}
		}
		
		private function OnMouseUp(e:MouseEvent):void 
		{
			IsChoose = false;
		}
		
		private function OnMouseDown(e:MouseEvent):void 
		{
			IsChoose = true;
		}		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch(buttonID)
			{
				case GUI_RECEIVELETTER_BTN_CLOSE:								
					Hide();
				break;		
				
				case GUI_LETTER_BUTTON_POPUP:
				var y: int = btnThanhKeo.img.y - (MAXY - MINY) / (textContent.textField.numLines/MIN_SHOW);						
					if (y <= MINY) btnThanhKeo.img.y = MINY;
					else
					{
						btnThanhKeo.img.y -= (MAXY - MINY)/ (textContent.textField.numLines /MIN_SHOW);												
					}
					textContent.textField.scrollV -= 4*textContent.textField.maxScrollV/(textContent.textField.numLines );
				break;
				
				case GUI_LETTER_BUTTON_POPDOWN:
					var y2: int = btnThanhKeo.img.y + (MAXY - MINY) / (textContent.textField.numLines/MIN_SHOW);
					if ( y2 >= MAXY) btnThanhKeo.img.y = MAXY;
					else  
					{
						btnThanhKeo.img.y +=  (MAXY - MINY) / (textContent.textField.numLines/MIN_SHOW );								
					}					
		
					textContent.textField.scrollV += 4*textContent.textField.maxScrollV/(textContent.textField.numLines);
				break;
				case GUI_LETTER_BTN_SEND:
				{
					//gui thu
					var sendLetter: SendLetter = new SendLetter(FromId,txtWriter.GetText());
					Exchange.GetInstance().Send(sendLetter);
					
					btnSend.TooltipText = null;						
					btnSend.SetDisable();
					Tooltip.getInstance().ClearTooltip();
					Hide();
					GuiMgr.getInstance().GuiNewMail.ProcessItemReplied2(GUINewMail.curSuffixId);
					break;
				}
			}
		}
		override public function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void 
		{
			switch(txtID)
			{
				case GUI_LETTER_TXT_WIRTER:
					AddTooltipButton();
				break;
			}
		}
		public function AddTooltipButton(): void
		{
			var txt: String = StringUtil.trim(txtWriter.GetText());
			if (txt != "")
			{
				btnSend.SetEnable(true);
				btnSend.setTooltip(null);
			}
			else
			{
				var tooltip:TooltipFormat = new TooltipFormat();
				tooltip.text = "Bạn chưa nhập nội dung thư";
				btnSend.setTooltip(tooltip);
				btnSend.SetDisable();
			}
		}
	}
}