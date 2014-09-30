package GUI.unused 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.trace.Trace;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendLoadMail;
	import Sound.SoundMgr;	

	import flash.events.KeyboardEvent;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import Data.*;
	import flash.utils.getTimer;
	import NetworkPacket.PacketSend.SendReplyMail;
	
	/**
	 * ...
	 * @author Hien
	 * Hien thi danh sach cac thu gui cho minh
	 */
	
	public class GUILetter extends BaseGUI
	{
		private const GUI_LETTER_BTN_CLOSE:String = "ButtonClose";		
		private const GUI_LETTER_BTN_NEXT:String = "ButtonNext";
		private const GUI_LETTER_BTN_BACK:String = "ButtonBack";
		private const GUI_LETTER_BTN_WRITTER:String = "ButtonWriter";				
		private var btn_Next: Button;
		private var btn_Back: Button;
		private var ReceiverID: int = -1;	
		private var txtField:  TextField;		
		public var LetterOpen: int;
		public var CurrentPage:int = 0;		
		private var MaxPage:int = 1;
		private var image: Array;
		public var isRefresh: Boolean;
		
		
		
		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		private var WaitData:Sprite = new DataLoading();
		
		public function GUILetter(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUILetter";
		}
		
		public function AddBgr():void
		{
			//var imgLetter: Image = AddImage("", "GUI_Bgr", 120, 110);	----------------------------
			//imgLetter.SetSize(470, 370);											-----------------------------
			
			//add icon va text hom thu
			//AddImage("", "IconThu", 90, 35);------------------------------
			//AddImage("", "txtHomThu", 205, 27, true, ALIGN_LEFT_TOP);-------------------
			//var txt_homthu: TextField = AddLabel("", 205, 23);			
			//var formatter1:TextFormat = new TextFormat( );					
			//formatter1.size = 20;				
			//formatter1.font = "Arial";
			//formatter1.color = 0x0047AB;
			//formatter1.bold = true;
			//txt_homthu.defaultTextFormat = formatter1;		
			//txt_homthu.text = Localization.getInstance().getString("GUILabel22");
			
			var btn: Button = AddButton(GUI_LETTER_BTN_CLOSE, "BtnThoat", 412, 19, this);
			AddImage("", "TxtMail", 110, 18, true, ALIGN_LEFT_TOP);
			AddButton(GUI_LETTER_BTN_WRITTER, "BtnWriteMail", 172, 304, this);
			//btn.img.scaleX = 0.8;
			//btn.img.scaleY = 0.8;
			//AddButton(GUI_LETTER_BTN_WRITTER, "ButtonWriter", 210, 350, this);
			//var btnWriter: Button = AddButton(GUI_LETTER_BTN_WRITTER, "BtnGreen", 180, 355, this); -------------
			//btnWriter.img.width = 100;																----------
			//btnWriter.img.height = 38;																			------------
			//btnWriter.SetEnable(false);
			//var tf:TextField = AddLabel("Viết thư", 196, 324, 0x000000, 0);					-----------
			//tf.scaleX = tf.scaleY = 1.3;														-----------
		}
		
		public override function InitGUI() :void
		{		
			var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			isRefresh = false;
			GameLogic.getInstance().BackToIdleGameState();
			//ve background
			//LoadRes("ImgFrameFriend");	---------------------------------------------
			LoadRes("GuiLetter");
			
			AddBgr();
			//load hinh anh load
			img.addChild(WaitData);
			WaitData.x = img.width / 2 - 10;
			WaitData.y = img.height / 2 - 10;
			
			SetPos(190, 90);			
			OpenRoomOut();
			
		}
	
		public override function EndingRoomOut():void
		{	
			//RefreshComponent();
			var sendCmdLetter: SendLoadMail = new SendLoadMail();
			Exchange.GetInstance().Send(sendCmdLetter);
		}
		
		public function RefreshComponent(): void
		{
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			ClearComponent();
			AddBgr();
			if (GameLogic.getInstance().user.LetterArr.length == 0)
			{
				txtField = AddLabel("", 200, 130, 0x000000);				
				var formatter:TextFormat = new TextFormat( );					
				formatter.size = 18;
				txtField.multiline = true;
				formatter.font = "Arial";
				txtField.defaultTextFormat = formatter;		
				var txt: String = Localization.getInstance().getString("GUILabel11");
				var txt1: String = Localization.getInstance().getString("GUILabel10");
				AddLabel(txt, 175, 150, 0x604220).setTextFormat(formatter);				
				AddLabel(txt1,185, 175, 0x604220).setTextFormat(formatter);	
			}
			else
			{					
				AddLetterArr(CurrentPage);
			}	
		}
		public  function AddLetter(LetterID: String, FromId: String,TimeSend:int, x: int, y: int,IsRead: Boolean): void
		{			
			var txtFormat:TextFormat;
			var i: int = 0;
			var NameSender: String = "Unknown";	
			//thoi gian gui thu
			var time: Date = new Date(TimeSend * 1000);	
			//thoi gian hien thoi
			var currentTime: Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			
			var hours: int = time.getHours();			
			var currentHour: int  = currentTime.getHours();
			//ngay chenh lech
			var h2: Number = time.getHours() * 3600 + time.getMinutes() * 60 + time.getSeconds();
			var h1: Number = currentTime.getHours() * 3600 + currentTime.getMinutes() * 60 + currentTime.getSeconds();			
			var day: int = (GameLogic.getInstance().CurServerTime - h1) - ( TimeSend - h2);								
			//ngay con lai
			var remainTime:int = Math.ceil(day / 24 / 3600) ;	
			
			txtFormat = new TextFormat("Arial", 12, 0x478584);											
			NameSender = "Unknown";
			for (i = 0; i < GameLogic.getInstance().user.FriendArr.length; i ++)
			{		
				if (GameLogic.getInstance().user.FriendArr[i].ID == FromId)
				{
					NameSender = GameLogic.getInstance().user.FriendArr[i].NickName;
					break;
				}					
			}
			var s: String;
			var con: Container = AddContainer(LetterID, "CtnTrang", x, y, true, this);	
			if (!IsRead)
			{
				con.AddImage("", "IconThu", 30, 25);				
			}
			else
			{
				con.AddImage("", "Mothu", 32, 33);
			}
			if (NameSender.length > 15)
			{
				NameSender = NameSender.substring(0,15);
				NameSender = NameSender.concat("...");			
			}
			con.AddLabel(NameSender, -13, -17).setTextFormat(txtFormat);
			var month: int = time.getMonth() + 1;
			con.AddLabel(time.getDate() + "-" + month + "-" + time.getFullYear(), -13, 0).setTextFormat(txtFormat);															
			if (remainTime <= 0)
			{
				var h:  int = currentTime.getHours() * 60 + currentTime.getMinutes() - (time.getHours() * 60 + time.getMinutes());								
				var t: int = h / 5;				
				if (t <= 12)
				{
					var r: int = t * 5 +5;
					s = Localization.getInstance().getString("GUILabel33");								
					s = s.replace("@remainTime", r);	
				}
				else
				{					
					r = h / 60;
					s = Localization.getInstance().getString("GUILabel15");				
					s = s.replace("@remainTime",r);	
				}
			}
			else
			{
				if (remainTime >= 6)
					remainTime = 6;
				s = Localization.getInstance().getString("GUILabel16");
				s = s.replace("@remainTime", remainTime);
			}
			con.AddLabel(s, -13, 75).setTextFormat(txtFormat);
				
		}
		
		
		public function InitButton(): void
		{
			if (MaxPage > 1)
			{
				//var btnNext:ButtonEx = AddButtonEx(GUI_LETTER_BTN_NEXT, "ButtonNext", 420, 175, this);
				var btnNext:Button = AddButton(GUI_LETTER_BTN_NEXT, "BtnNext", 406, 170, this);
				btnNext.img.scaleX = 0.9;
				btnNext.img.scaleY = 0.9;
				
				//var btnBack:ButtonEx = AddButtonEx(GUI_LETTER_BTN_BACK, "ButtonBack", -5, 175, this);
				var btnBack:Button = AddButton(GUI_LETTER_BTN_BACK, "BtnBack", 17, 170, this);
				btnBack.img.scaleX = 0.9;
				btnBack.img.scaleY = 0.9;
				if (CurrentPage == 0)
				{
					btnBack.SetDisable();
				}
				if (CurrentPage == MaxPage - 1)
				{
					btnNext.SetDisable();
				}
			}
		}
		
		public function AddLetterArr(page: int): void
		{
			var length: int = GameLogic.getInstance().user.LetterArr.length;
			var arr:Array = GameLogic.getInstance().user.LetterArr;
			var nRow:int = 4;
			var nCol:int = 2;
			var nPageSlot:int = nRow * nCol;			
			//for (var j:int = 0; j < length; j++)
			//{
				//trace(CurrentPage * nPageSlot + j%nPageSlot, arr[CurrentPage * nPageSlot + j%nPageSlot].Id + "_" + (CurrentPage * nPageSlot + j%nPageSlot));
				//RemoveContainer(arr[CurrentPage * nPageSlot + j%nPageSlot].Id + "_" + (CurrentPage * nPageSlot + j%nPageSlot));			
			//}
			RemoveAllContainer();
			MaxPage = Math.ceil(length / nPageSlot);
			CurrentPage = page;
			if (CurrentPage >= MaxPage) 
			{
				CurrentPage = MaxPage - 1;
			}
			if (CurrentPage < 0)
			{
				CurrentPage = 0;
			}		
			var vt:int = CurrentPage * nPageSlot;
			var nItem:int = nPageSlot;
			if (vt + nItem >= length)
			{
				nItem = length - vt;
			}
			var r: int;
			var c: int;
			var x: int;
			var y: int;
			var icon:Sprite = ResMgr.getInstance().GetRes("CtnTrang") as Sprite;
			var w:int = icon.width;
			var h:int = icon.height;
			for (var i:int = vt; i < vt + nItem; i++)
			{
				if ((i -   vt) > nRow * nCol+1 )
				{
					return;
				}
				
				r = (i - vt)/ nRow;
				c = (i - vt) % nRow;
				x = 54 + c * (w + 15);
				y = 90 + r * (h + 40);						
				AddLetter(arr[i].Id + "_"+ i, arr[i].FromId,arr[i].FromTime,x, y,arr[i].IsRead);
			}
			InitButton();
			
		}
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch(buttonID)
			{
				case GUI_LETTER_BTN_CLOSE :
					
					Hide();
				break;
				
				case GUI_LETTER_BTN_NEXT:
					if (CurrentPage < MaxPage - 1)
					{
						AddLetterArr(CurrentPage + 1);
					}					
				break;
				
				case GUI_LETTER_BTN_BACK:
					if (CurrentPage > 0)
					{
						AddLetterArr(CurrentPage - 1);
					}
				break;
				
				case GUI_LETTER_BTN_WRITTER:	
					GuiMgr.getInstance().GuiSendLetter.Show(Constant.GUI_MIN_LAYER, 3);	
				break;
				
				default:					
					ChooseLetter(buttonID);
				break;
			}
		}	
		
		
		public function ChooseLetter(LetterID: String): void
		{						
			var data: Array = LetterID.split("_");           
			if (data.length < 2)
				return;
			var id: int = data[0];
			var stt: int = data[1];	
			
			//trace("stt", stt)
			var arr:Array = GameLogic.getInstance().user.LetterArr;
			for (var i: int = 0; i < arr.length; i++)
			{
				if (arr[i].Id == id)
				{
					if (!arr[i].IsRead)
					{
						var container: Container = GetContainer(LetterID);
						container.RemoveAllImage();								
						var imgMothu: Image = container.AddImage("", "Mothu", 32, 33);				;
						arr[i].IsRead = true;
					}
					break;
				}
			}
			
			LetterOpen = stt;
			//gui thong bao da doc thu
			var sendLetter:SendReplyMail = new SendReplyMail(id);
			Exchange.GetInstance().Send(sendLetter);								
			//GuiMgr.getInstance().GuiReceiveLetter.Show(Constant.GUI_MIN_LAYER + 3, 3);		
			GuiMgr.getInstance().GuiReceiveLetter.Show(Constant.GUI_MIN_LAYER,3);	
		}		
	}

}