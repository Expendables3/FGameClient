package GUI.Mail 
{
	import flash.display.MovieClip;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import GUI.component.Tooltip;
	import GUI.GuiMgr;
	
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;
	import NetworkPacket.PacketSend.SendLetter;
	import NetworkPacket.PacketSend.SendAcceptGift;
	import com.adobe.utils.StringUtil;
	import flash.text.TextField;
	import Data.Localization;
	/**
	 * ...
	 * @author Hien
	 * reply lai thu hoac de lai loi nhan
	 */
	public class GUIReplyLetter  extends BaseGUI
	{
		private var txtWriter: TextBox;
		private const GUI_LETTER_TXT_WIRTER:String = "Writer";	
		private const GUI_LETTER_BTN_SEND: String = "Send";
		private const GUI_RECEIVELETTER_BTN_CLOSE:String = "ButtonClose";	
		private var FromId: int;
		private var btnSend: Button;
		public function GUIReplyLetter(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIReplyLetter";
		}
		public override function InitGUI() :void
		{				
			this.setImgInfo = function():void
			{
				AddImage("", "GuiReplyLetter_LblVietThu", 110, 18, true, ALIGN_LEFT_TOP);				
				AddImage("", "GuiReplyLetter_DongVietThu", 153, 207, true, ALIGN_LEFT_CENTER);
				
				var btn: Button = AddButton(GUI_RECEIVELETTER_BTN_CLOSE, "BtnThoat", 412, 19, this);
				btnSend = AddButton(GUI_LETTER_BTN_SEND, "GuiReplyLetter_BtnSendMail", 172, 304, this);
				
				GuiMgr.getInstance().GuiSendLetter.SetDisable(btnSend);	
							
				//add dong viet thu
				txtWriter = AddTextBox(GUI_LETTER_TXT_WIRTER, "", 150, 145, 260, 120);	
				txtWriter.textField.multiline = true;			
				txtWriter.MyParent = this;
				var formatter:TextFormat = new TextFormat( );		
				formatter.leading = 11;						
				formatter.size = 17;
				txtWriter.textField.maxChars = 250;
				txtWriter.textField.defaultTextFormat = formatter;
				txtWriter.textField.wordWrap = true;						
				txtWriter.textField.textColor = 0x0000FF;			
				this.img.stage.focus = txtWriter.textField;
							
				//add anh nguoi gui
				if (!GameLogic.getInstance().user.IsViewer())
				{
					var arr:Array = GameLogic.getInstance().user.LetterArr;

					var LetterId: int = GuiMgr.getInstance().GuiNewMail.GetCurLetterId();				
					var i: int = 0;			
					//for (i = 0; i < arr.length; i++)
					//{
						//if (arr[i].Id == LetterId)
						{
							FromId = arr[LetterId].FromId;
							//break;
						}
					//}			
				}
				else
				{				
					FromId = GameLogic.getInstance().user.Id;
				}
				var avatar: String ;
				var name: String;				
				for (i = 0; i < GameLogic.getInstance().user.FriendArr.length; i++)
				{
					if (GameLogic.getInstance().user.FriendArr[i].ID == FromId)
					{
						avatar = GameLogic.getInstance().user.FriendArr[i].imgName;
						name = GameLogic.getInstance().user.FriendArr[i].NickName;						
						var img1: Image;
						//img1  = AddImage("", avatar, 230, 65, false, ALIGN_LEFT_TOP);
						img1  = AddImage("", avatar, 67, 78, false, ALIGN_LEFT_TOP);
						img1.SetSize(50,50);
						AddLabel(name, 42, 131);
						break;
					}
				}
				
				AddTooltipButton();
				
				SetPos(190, 90);
				OpenRoomOut();
			}
			LoadRes("GuiReplyLetter_Theme");
		}
		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch(buttonID)
			{
				case GUI_LETTER_BTN_SEND:
				{	
					if (btnSend.img.enabled)
					{
						//gui thu
						var sendLetter: SendLetter = new SendLetter(FromId,txtWriter.GetText());
						Exchange.GetInstance().Send(sendLetter);
						
						btnSend.TooltipText = null;						
						btnSend.SetDisable();
						Tooltip.getInstance().ClearTooltip();
					}
				}
				break;
				case GUI_RECEIVELETTER_BTN_CLOSE:
				{
					Tooltip.getInstance().ClearTooltip();
					Hide();					
				}
				break;
			}
		}

		
		public override function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void
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
				btnSend.img.enabled = true;
				btnSend.SetEnable(true);
				btnSend.TooltipText = null; 
			}
			else
			{
				btnSend.TooltipText = "Bạn chưa nhập nội dung thư";
				GuiMgr.getInstance().GuiSendLetter.SetDisable(btnSend);	
				btnSend.img.enabled = false;
			}
		}
		
	}

}