package GUI.Mail 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.display.Sprite;
	import Data.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import GUI.component.Tooltip;
	import Logic.*;
	import flash.filters.ColorMatrixFilter;
	import com.adobe.utils.StringUtil;
	import NetworkPacket.PacketSend.SendLetter;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Hien
	 */
	public class GUISendLetter  extends BaseGUI
	{
		private const GUI_LETTER_BTN_CLOSE:String = "ButtonClose";	
		private const GUI_LETTER_BTN_SEND:String = "ButtonSend";	
		private const GUI_LETTER_TXT_SEARCH:String = "Buttontimkiem";	
		private const GUI_LETTER_BTN_NEXT:String = "ButtonTiepTheo";
		private const GUI_LETTER_BTN_BACK:String = "Buttontimkiem";
		private const GUI_LETTER_RECEIVER:String = "Receiver";
		private const GUI_LETTER_TXT_WIRTER:String = "Writer";	
		private const MAX_FRIEND_SHOW: int  = 2;
		private var txtSearch: TextBox;
		private var txtWriter: TextBox;
		public var CurrentPage: int = 0;
		public var MaxPage: int = 1;
		public var FriendSearch: Array = [];
		public var FriendLetterArr: Array = [];
		private var ReceiverID: int;		
		private var btnSend: Button;
		private var btnBack: Button;
		private var btnNext: Button;
		public var nRow: int = 3;
		public var image: Image;
		public function GUISendLetter(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUISendLetter";
			
		}
		
		public override function InitGUI(): void
		{		
			this.setImgInfo = function():void
			{
				//add background
				//LoadRes("ImgFrameFriend");		---------------
				AddImage("", "GuiLetter_LblVietThu", 190, 18, true, ALIGN_LEFT_TOP);

				
				//add tim kiem
				AddImage("", "GuiLetter_ImgTimKiem", 148, 125).SetScaleX(0.55);
				AddImage("", "GuiLetter_DongVietThu", 285, 250);
				var txtformat:TextFormat = new TextFormat();
				txtformat.color = 0x0047AB;
				txtformat.size = 14;				
				AddLabel("Nhập tên bạn bè", 48, 90).setTextFormat(txtformat);
				
				//add button
				var btn: Button = AddButton(GUI_LETTER_BTN_CLOSE, "BtnThoat", 412, 19, this);
				
				btnNext = AddButton(GUI_LETTER_BTN_NEXT, "GuiLetter_BtnNext", 400, 110, this);	
				btnNext.img.scaleX = 0.8;
				btnNext.img.scaleY = 0.8;
				btnBack = AddButton(GUI_LETTER_BTN_BACK, "GuiLetter_BtnBack", 170, 110, this);
				btnBack.img.scaleX = 0.6;
				btnBack.img.scaleY = 0.6;
				
				
				btnSend = AddButton(GUI_LETTER_BTN_SEND, "GuiLetter_BtnSendMail", 172, 304, this);
				
				//text search
				txtSearch = AddTextBox(GUI_LETTER_TXT_SEARCH, "", 52, 115, 120, 22);
				txtSearch.textField.addEventListener("change", search);
				var formatter_search:TextFormat = new TextFormat( );		
				formatter_search.size = 15;
				txtSearch.textField.defaultTextFormat = formatter_search;
				txtSearch.MyParent = this;
							
				//text writer
				txtWriter = AddTextBox(GUI_LETTER_TXT_WIRTER, "",160, 188, 250, 130, this);
				txtWriter.textField.multiline = true;			
				txtWriter.MyParent = this;
				txtWriter.textField.maxChars = 250;
				var formatter:TextFormat = new TextFormat( );		
				formatter.leading = 11;		
				formatter.size = 17;
					
				txtWriter.textField.defaultTextFormat = formatter;
				txtWriter.textField.wordWrap = true;						
				txtWriter.textField.textColor = 0x0000FF;
				txtWriter.textField.border = false;
				this.img.stage.focus = txtWriter.textField;
				
				//hien thi danh sach ban be
				FriendLetterArr.splice(0, FriendLetterArr.length);		
				FriendSearch.splice(0, FriendSearch.length);
				for (var i: int = 0; i < GameLogic.getInstance().user.FriendArr.length; i++)
				{
					if (GameLogic.getInstance().user.FriendArr[i].ID != GameLogic.getInstance().user.GetMyInfo().Id)
					{
						FriendLetterArr.push(GameLogic.getInstance().user.FriendArr[i]);
					}				
				}
				AddFriendArr(0);
				ReceiverID = 0;
				SetStateButton();			
				SetPos(190, 90);
				OpenRoomOut();
			}
			
			LoadRes("GuiLetter_Theme");
		}
		
		public function SetDisable(btn: Button):void
		{
			var elements:Array =
			[0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0, 0, 0, 1, 0];

			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
			btn.img.filters = [colorFilter];
		}
		
		//add mot nguoi ban vao
		public function AddFriend(FriendID: int,stt: int,x: int, y: int,imgName: String,NickName: String): void
		{								
			var container:Container = AddContainer(FriendID + "_" + stt, "GuiLetter_ImgAvatar", x - 10, y, true, this);			
			//Add anh avatar	
			var imgF: Image;
			var i: int = 0;
			var index: int;
			
			imgF = container.AddImage("", imgName, 0, 22, false, ALIGN_LEFT_TOP);
			imgF.SetSize(50, 50);	
			
			var txtFormat: TextFormat = new TextFormat("Arial", 14, 0x783696);
			var name: String = NickName;			
			if (name.length > 10)
			{
				name = name.substring(0,10);
				name = name.concat("...");
			}			
			var txt: TextField = container.AddLabel(name, -25, 70);									
			container.TooltipText = NickName;
			
		}				
		
		public function AddReceiver(FriendID: String): void
		{
			VisibleContainer(GUI_LETTER_RECEIVER);
			var data: Array = FriendID.split("_");
			if (data.length < 2)
				return;
			var FriendId: int = data[0];
			var stt: int = data[1];
			//trace(stt);
			var i: int;			
			for (i = 0; i < FriendLetterArr.length; i++ )
			{
				if (FriendLetterArr[i].ID == FriendId)
				{	
					var container: Container = AddContainer(GUI_LETTER_RECEIVER, "GuiLetter_ImgFrameFriend", 70, 130);
					var name: String = FriendLetterArr[i].NickName;			
					if (name.length > 25)
					{
						name = name.substring(0,25);
						name = name.concat("...");
					}			
					var txt: TextField = container.AddLabel(name, -25, 70);
					txt.autoSize = TextFieldAutoSize.CENTER;					
					var img: Image;
					img = container.AddImage("", FriendLetterArr[i].imgName, 0, 22, false, ALIGN_LEFT_TOP);
					img.SetSize(50,50);
					ReceiverID = parseInt(FriendID);
					break;
				}
			}		
		}
		
						
		public function InitFriendButton(): void
		{
			if (MaxPage >1)
			{
				btnNext.img.visible = true;
				btnBack.img.visible = true;
				btnBack.SetEnable(true);
				btnNext.SetEnable(true);
				if (CurrentPage == 0)
				{
					btnBack.SetDisable();
					btnNext.SetEnable(true);
				}
				if (CurrentPage == MaxPage - 1)
				{
					btnNext.SetDisable();
					btnBack.SetEnable(true);
					
				}
			}
			else
			{
				btnNext.img.visible = false;
				btnBack.img.visible = false;
			}
		}
			
		public function SetStateButton(): void
		{
			var text: String = StringUtil.trim(txtWriter.GetText());			
			if (text == "")
			{
				btnSend.TooltipText = "Bạn chưa nhập nội dung thư";
				btnSend.SetEnable(false);
			}
			if (text != "" && ReceiverID <= 0)
			{
				btnSend.TooltipText = "Bạn chưa chọn người nhận";
				btnSend.SetEnable(false);
			}			
			if (text != "" && ReceiverID > 0)
			{
				btnSend.TooltipText = null;
				//btnSend.img.enabled = true;
				btnSend.SetEnable(true);				
			}
		
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch(buttonID)
			{
				case GUI_LETTER_BTN_CLOSE :
					Tooltip.getInstance().ClearTooltip();
					Hide();				
				break;
				
				case GUI_LETTER_BTN_NEXT:
					if (CurrentPage < MaxPage - 1)
					{
						AddFriendArr(CurrentPage + 1);
					}
				break;
				
				case GUI_LETTER_BTN_BACK:
					if (CurrentPage > 0)
					{
						AddFriendArr(CurrentPage - 1);
					}
				break;
				
				case GUI_LETTER_BTN_SEND:		
					if (btnSend.enable)
					{
						var sendLetter: SendLetter = new SendLetter(ReceiverID,txtWriter.GetText());
						Exchange.GetInstance().Send(sendLetter);
						btnSend.SetEnable(false);
						btnSend.TooltipText = null;
						Tooltip.getInstance().ClearTooltip();
					}
					btnSend.TooltipText = null;
				break;
				
				case GUI_LETTER_TXT_WIRTER:
				break;
				
				default:					
					AddReceiver(buttonID);
					SetStateButton();
				break;
			}
		}
		
		public function search(e: Event): void
		{			
			var searchText:String = txtSearch.textField.text.toLowerCase();
			searchText = StringUtil.trim(searchText);
			var find: String = searchText;	
			//trace("td", find);
			var i: int;
			var j: int;
			var n: int = 0;
			var myId: int = GameLogic.getInstance().user.GetMyInfo().Id;
			FriendSearch.splice(0, FriendSearch.length);		
			for (i = 0; i < FriendLetterArr.length; i++ )
			{	
				for (j = 0; j < nRow; j++ )
				{
					RemoveContainer(FriendLetterArr[i].ID + "_" +j);
				}
			}
			if (searchText != "")
			{			
				for (i = 0; i < FriendLetterArr.length; i++ )
				{						
					var k: String;
					var m: int;
					k = FriendLetterArr[i].NickName;
					k = k.toLowerCase();
					m = k.indexOf(find);						
					if (m != -1 && FriendLetterArr[i].ID != myId)
					{								
						FriendSearch[n] = FriendLetterArr[i].ID;						
						n ++;	
						AddFriendArr(0);							
					}	
					if (m == -1)
					{
						btnNext.SetEnable(false);
						btnBack.SetEnable(false);
					}
				}											
			}
			else
			{
				AddFriendArr(0);
			}
		}
		
		public override function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void
		{
			switch(txtID)
			{
				case GUI_LETTER_TXT_SEARCH:
				{								
					//search(txtSearch.textField.text);
				}break;
				case GUI_LETTER_TXT_WIRTER:
				{										
					SetStateButton();
				}break;
				
			}
		}
				
		public function AddFriendArr(page: int): void
		{			
			var length: int;
			if (FriendSearch.length == 0)			
				length = FriendLetterArr.length;
			else
				length = FriendSearch.length;
			
			
			var nCol:int = 1;
			var nPageSlot:int = nRow * nCol;
			MaxPage = Math.ceil(length / nPageSlot);			
			CurrentPage = page;
			for (var j: int = 0; j < FriendLetterArr.length; j++)
			{
				for (var k: int = 0; k < nRow; k++)
				{
					RemoveContainer(FriendLetterArr[j].ID + "_" + k);
				}
			}
			if (CurrentPage >= MaxPage) 
			{
				CurrentPage = MaxPage - 1;
			}
			if (CurrentPage < 0)
			{
				CurrentPage = 0;
			}		
			var vt:int = CurrentPage * nPageSlot;
			var imgName: String;
			var nickName: String;
			var nItem:int = nPageSlot;
			if (vt + nItem >= length)
			{
				nItem = length - vt;
			}
			var r: int;
			var c: int;
			var x: int;
			var y: int;
			for (var i:int = vt; i < vt + nItem; i++)
			{
				if ((i -   vt) > nRow * nCol+1 )
				{
					return;
				}
				
				r = (i - vt)/ nRow;
				c = (i - vt) % nRow;
				x = 205 + c * (54 + 20);
				y = 70 + r * (82 + 30);		
				if (FriendSearch.length == 0)
				{										
					AddFriend(FriendLetterArr[i].ID, i - vt, x, y, FriendLetterArr[i].imgName, FriendLetterArr[i].NickName);										
				}
				else
				{
					for (j = 0; j < FriendLetterArr.length; j++ )
					{						
						if (FriendSearch[i] == FriendLetterArr[j].ID)
						{
							imgName = FriendLetterArr[j].imgName;
							nickName = FriendLetterArr[j].NickName;
							AddFriend(FriendSearch[i], i - vt, x, y, imgName, nickName);				
							break;
						}
						
					}
				}
					
			}
			InitFriendButton();
		}
	}

}