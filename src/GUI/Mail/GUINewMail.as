package GUI.Mail 
{
	import com.adobe.utils.StringUtil;
	import Data.Localization;
	import Data.ResMgr;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ScrollBar;
	import GUI.component.TextBox;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendLetter;
	import NetworkPacket.PacketSend.SendLoadMail;
	import NetworkPacket.PacketSend.SendRemoveMessage;
	import NetworkPacket.PacketSend.SendReplyMail;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author HiepNM
	 */
	public class GUINewMail extends BaseGUI 
	{
		//const
		/*hằng số id của nút*/
		private const GUI_NEW_MAIL_BTN_CLOSE:String = "idBtnClose";
		private const GUI_NEW_MAIL_BTN_DELETEALL:String = "idBtnDeleteAll";
		private const GUI_NEW_MAIL_BTN_SEND_DEFAULT:String = "idBtnSendMailDefault";
		private const GUI_NEW_MAIL_BTN_DEL_FAST:String = "idBtnDelFast_";
		private const GUI_NEW_MAIL_BTN_REPLY_FAST:String = "idBtnReplyFast_";
		private const READ_AND_REPLY:String = "rar";
		private const DEL_FAST:String = "del";
		private const REPLY_FAST:String = "reply";
		private const SEND_FAST:String = "SendFast";
		private const TXT_SEND_FAST_ID:String = "TextSendFast";
		private const IMG_SEND_FAST_ID:String = "ImgTextSendFast";
		
		/*hằng logic*/
		private const MAX_FOR_FAST_MAIL:int = 15;
		private const HEIGHT_LETTER:int = 66;				//chiều cao của thư
		private const HEIGHT_TEXT_REPLY:int = 25;			//chiều cao của text box trả lời nhanh
		private const WIDTH_TEXT_REPLY:int = 250;			//chiều rộng của text box trả lời nhanh
		
		//var
		private var m_scroll:ScrollPane = new ScrollPane();
		private var m_iCurPage:int;			//trang hien tai
		private var Content: Sprite = new Sprite();				//cái này để ràng buộc với scroll bar: chứa ít nhất 3 phần tử letter và nhiều nhất là 4 letter
		private var txtField:  TextField;
		
		private var MailContainerArr:Array = new Array();
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		private var WaitData:Sprite = new DataLoading();
		
		private var prevSuffixId:String = "-1_-1_-1";
		public static var curSuffixId:String = "-1_-1_-1";
		
		public static var bReply:Boolean = false;
		
		public function GUINewMail(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		/**
		 * hàm được gọi lúc gui chưa hiện lên
		 */
		override public function InitGUI():void 
		{
			//super.InitGUI();
			
			this.setImgInfo = function():void
			{
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				GameLogic.getInstance().BackToIdleGameState();
				SetPos(Constant.STAGE_WIDTH / 2 - this.img.width / 2, Constant.STAGE_HEIGHT / 2 - this.img.height / 2);//căn ra chính giữa màn hình
				//khởi tạo sơ khai về gui
				AddBgr();
				//add hình ảnh load
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 10;
				WaitData.y = img.height / 2 - 10;
				OpenRoomOut();
			}
			
			LoadRes("GuiNewMail_Theme");
		}
		
		public function AddBgr():void
		{
			var width:int = this.img.width;
			var height:int = this.img.height;
			//tiêu đề cửa sổ
			AddImage("", "GuiNewMail_LblHomThu", width / 2, 32);
			//các nút bấm:
			AddButton(GUI_NEW_MAIL_BTN_CLOSE, "BtnThoat", 448 - 37, 19);
			AddButton(GUI_NEW_MAIL_BTN_DELETEALL,"GuiNewMail_BtnDeleteAll", width / 2 - 150, height - 50);
			AddButton(GUI_NEW_MAIL_BTN_SEND_DEFAULT, "GuiNewMail_BtnGuiThu", width / 2 + 50, height - 50);
		}
		
		public override function EndingRoomOut():void
		{	
			//RefreshComponent();
			var sendCmdLetter: SendLoadMail = new SendLoadMail();
			Exchange.GetInstance().Send(sendCmdLetter);
			prevSuffixId = "-1_-1_-1";
		}
		
		public function RefreshComponent():void
		{
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			ClearComponent();
			AddBgr();
			if (GameLogic.getInstance().user.LetterArr.length == 0)
			{
				AddEmptyMsg();
			}
			else
			{	
				GetButton(GUI_NEW_MAIL_BTN_DELETEALL).SetEnable();
				InitScroll();
				AddLetterArr();
			}
			prevSuffixId = "-1_-1_-1";
		}
		
		public function AddTimeToLetter(ctnLetter:Container, nTimeSend:Number):void
		{
			var format:TextFormat;
			var strTime:String = "Gửi:     ";
			var s:String = Ultility.GetRemainTime(nTimeSend) + " trước";
			/*
			var time: Date = new Date(nTimeSend * 1000);	//thoi gian gui thu
			
			var currentTime: Date = new Date(GameLogic.getInstance().CurServerTime * 1000);//thoi gian hien thoi
			//ngay chenh lech
			var h2: Number = time.getHours() * 3600 + time.getMinutes() * 60 + time.getSeconds();
			var h1: Number = currentTime.getHours() * 3600 + currentTime.getMinutes() * 60 + currentTime.getSeconds();			
			var day: int = (GameLogic.getInstance().CurServerTime - h1) - ( nTimeSend - h2);
			//ngay con lai
			var remainTime:int = Math.ceil(day / 24 / 3600) ;	
			var month: int = time.getMonth() + 1;
			var s: String;
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
			*/
			strTime += s;
			var txtTime:TextField = ctnLetter.AddLabel(strTime, 40 + 20, 3 + 5, 0x000000, 0);
			
			format = new TextFormat();
			format.size = 14;
			format.italic = true;
			format.font = "Myriad Pro";
			format.color = 0x073F42;
			txtTime.setTextFormat(format, 0, 8);
			format = new TextFormat();
			format.size = 14;
			format.italic = true;
			format.bold = true;
			format.font = "Arial";
			format.color = 0xA1541E;
			txtTime.setTextFormat(format, 9, strTime.length);
		}
		
		public function AddLetter(index:int, iLetterId:int, iFromId:int, strView:String, nTimeSend:Number, isReply:Boolean, iPosY:int):void
		{
			var suffixId:String = index.toString() + "_" + iLetterId.toString() + "_" + iFromId.toString();
			var format:TextFormat;
			var ctnId:String = READ_AND_REPLY+"_" + suffixId;			//id cho cái container chứa thư
			var btnDelId:String = DEL_FAST+"_"  + suffixId;				//id cho nút xóa nhanh
			var btnReplyId:String = REPLY_FAST+"_" + suffixId;			//id cho nút trả lời nhanh
			var btnSendFastId:String = SEND_FAST+"_" + suffixId;		//id cho nút gửi nhanh
			var txtSendFastId:String = TXT_SEND_FAST_ID+"_" + suffixId;	//id cho text box gửi nhanh
			var imgSendFastId:String = IMG_SEND_FAST_ID+"_" + suffixId;	//id cho ảnh của text box gửi nhanh
			//tạo 1 cái container để nhét tất cả vào
			var container:Container = new Container(Content, "GuiNewMail_KhungFriend", 0, iPosY);
			container.IdObject = "ctn" + "_" + suffixId;
			
			//Add vào cái khung
			var x:int = 140;
			var ctnLetter:Container = container.AddContainer(ctnId, "GuiNewMail_ImgFastMail", x, 0,true,this);
			//các biến tọa độ
			var xContent:int = x - 100;
			var xDelBtn:int = ctnLetter.img.x + ctnLetter.img.width - 25;
			var xRepBtn:int = xDelBtn - 35;
			var yBtn:int = 3;
			//add nút
			
			container.AddButton(btnDelId, "GuiNewMail_BtnDelMailFast", xDelBtn, yBtn, this);
			var btnReplyFast:Button = container.AddButton(btnReplyId, "GuiNewMail_BtnReplyFast", xRepBtn, yBtn, this);
			var tooltipFast:TooltipFormat = new TooltipFormat();
			tooltipFast.text = "Trả lời nhanh";
			btnReplyFast.setTooltip(tooltipFast);
			
			//add thời gian gửi
			AddTimeToLetter(ctnLetter, nTimeSend);


			//add nội dung thư
			var yContent:int = 30;
			var txtContent:TextField = ctnLetter.AddLabel(strView, xContent - 10, yContent + 5, 0x000000, 0);
			format = new TextFormat();
			format.size = 14;
			format.italic = true;
			format.bold = true;
			format.font = "Arial";
			format.color = 0x0B7875;
			format.align = "left";
			txtContent.setTextFormat(format, 0, strView.length);
			
			//add cái text box trả lời và nút gửi
			var yTextSend:int = ctnLetter.img.y + ctnLetter.img.height + 6;
			var imgTextSend:Image = container.AddImage(imgSendFastId, "GuiNewMail_TxtSendFast", xContent + 240, yTextSend + 07);
			var txtSend:TextBox = container.AddTextBox(txtSendFastId, "", x + 20, yTextSend - 3, 190, 25, this);
			imgTextSend.img.visible = false;
			txtSend.textField.visible = false;
			var xSend:int = x + imgTextSend.img.width - 20;
			var btnSend:Button = container.AddButton(btnSendFastId, "GuiNewMail_BtnSendMailFast", xSend - 8, yTextSend - 2, this);
			btnSend.img.visible = false;
			btnSend.SetDisable();
			
			//add cái ảnh avatar
			var sAvatar:String = GameLogic.getInstance().user.GetFriend(iFromId).imgName;
			var imgF:Image = container.AddImage("idAvatar", sAvatar, x - 60, 25, false, ALIGN_LEFT_TOP);
			imgF.SetSize(50, 50);
			//add cái tên
			var sName:String = GameLogic.getInstance().user.GetFriend(iFromId).NickName;
			if (sName.length >= 10)
			{
				sName = sName.substr(0, 7);
				sName += "...";
			}
			container.AddLabel(sName, x - 80, 05);
			
			//add ảnh nếu mail đã được trả nhời
			if (isReply)
			{
				//ẩn 3 đối tượng phía dưới
				imgTextSend.img.visible = false;
				txtSend.textField.visible = false;
				btnSend.SetVisible(false);
				//disable nút trả lời
				btnReplyFast.SetDisable();
				//thêm ảnh dấu tích
				container.AddImage("", "GuiNewMail_IcComplete", btnReplyFast.img.x + 35, HEIGHT_LETTER - 15);
			}
			container.EventHandler = this;
			this.ContainerArr.push(container);
			
			//container.IdObject = index.toString();
			MailContainerArr.push(container);
			//container.AddImage(
		}
		
		public function AddLetterArr():void
		{
			var iLength:int = GameLogic.getInstance().user.LetterArr.length;
			var arrLetter:Array = GameLogic.getInstance().user.LetterArr;
			var sView:String;
			var iFromId:int;
			var nTimeSend:Number;
			var letterId:int;
			var isReply:Boolean;			
			//các biến chỉnh tọa độ
			var y:int = 10;				//tung độ của các thư sẽ được thay đổi mỗi khi add thêm thư vào
			var dy:int = 28;			// khoảng cách giữa các thư với nhau
			
			var i:int = 0;

			for (i = 0; i < iLength; i++)//duyệt tất cả các thư của user
			{
				sView = arrLetter[i].Content as String;
				if (sView.length > MAX_FOR_FAST_MAIL - 3)
					sView = sView.slice(0, MAX_FOR_FAST_MAIL) + "...";
				var iEnter:int = sView.indexOf("\r");//xet trong xau co dau enter khong
				if (iEnter >= 0) 
				{
					sView = sView.slice(0, iEnter);
					sView += "...";
				}
				letterId = arrLetter[i].Id;
				iFromId = arrLetter[i].FromId;
				nTimeSend = arrLetter[i].FromTime;
				isReply = arrLetter[i].IsRead;
				AddLetter(i,letterId, iFromId, sView, nTimeSend, isReply, y);
				y += (HEIGHT_LETTER + dy);
			}
			m_scroll.source = Content;
		}
		/**
		 * khởi tạo scroll khi có nhiều hơn 3 thư trong thùng
		 */
		private function InitScroll():void
		{//tạm thời để đó, chưa chỉnh vội
			m_scroll.visible = true;
			var bg: Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff, 0);
			bg.graphics.drawRect(0, 0, 200, 200);
			bg.graphics.endFill();
			m_scroll.setStyle("upSkin", bg);
			
			var up:Sprite = ResMgr.getInstance().GetRes("GuiNewMail_ImgUpArrowNone") as Sprite;
			var over: Sprite = ResMgr.getInstance().GetRes("GuiNewMail_ImgUpArrowOver") as Sprite;
			m_scroll.setStyle("upArrowUpSkin", up);
			m_scroll.setStyle("upArrowDownSkin", up);
			//var color:ColorTransform = new ColorTransform(1.8, 1.8, 1.8);
			//over.transform.colorTransform = color;
			m_scroll.setStyle("upArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiNewMail_ImgDownArrowNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiNewMail_ImgDownArrowOver") as Sprite;
			m_scroll.setStyle("downArrowUpSkin", up);
			m_scroll.setStyle("downArrowDownSkin", up);
			//over.transform.colorTransform = color;
			m_scroll.setStyle("downArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiNewMail_ImgTrackBarNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiNewMail_ImgTrackBarOver") as Sprite;
			m_scroll.setStyle("thumbUpSkin", up);
			m_scroll.setStyle("thumbDownSkin", up);
			m_scroll.setStyle("thumbOverSkin", over);
			m_scroll.setStyle("thumbIcon", "");

			up = ResMgr.getInstance().GetRes("GuiNewMail_BtnKhungKeo") as Sprite;
			m_scroll.setStyle("trackUpSkin", up);
			m_scroll.setStyle("trackDownSkin", up);
			m_scroll.setStyle("trackOverSkin", up);
			
			m_scroll.setSize(450, (HEIGHT_LETTER+28) * 3 + 6);
			m_scroll.verticalScrollBar.setScrollPosition(0);
			m_scroll.horizontalScrollBar.visible = false;
			
			img.addChild(m_scroll);
			m_scroll.x = -35;
			m_scroll.y = 68;//100;
			m_scroll.horizontalScrollBar.visible = false;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case GUI_NEW_MAIL_BTN_CLOSE:
					Hide();
					break;
				case GUI_NEW_MAIL_BTN_DELETEALL://xóa tất cả thư
					DeleteAll();
					break;
				case GUI_NEW_MAIL_BTN_SEND_DEFAULT://gửi như bình thường
					SendDefault();
					break;
				default:
					//thực hiện việc khác: xóa nhanh, trả lời nhanh, gửi nhanh
					ProcessInMail(buttonID);
					break;
			}
		}
		/**
		 * thực hiện xử lý 1 thư
		 * @param	command: mã lệnh = lệnh(làm việc gì) + địa chỉ thư (thư chịu tác động)
		 */
		public function ProcessInMail(command:String):void
		{
			var data:Array = command.split("_");
			var work:String = data[0];				//nhận DEL_FAST, REPLY_FAST và SEND_FAST
			var index:int = (int)(data[1]);
			var iwhere:int = (int) (data[2]);		//vi tri thu
			var iWho:int = (int)(data[3]);			//id nguoi gui thu
			var suffixId:String = index.toString() + "_" + iwhere.toString() + "_" + iWho.toString();
			switch(work)
			{
				case DEL_FAST://xóa nhanh thư này
					DeleteFast(suffixId);
					break;
				case REPLY_FAST://trả lời nhanh thư này
					ReplyFast(suffixId);
					break;
				case SEND_FAST://gửi nhanh thư này
					SendFast(suffixId, false);
					break;
				case READ_AND_REPLY://đọc toàn bộ thư và trả lời
					ReadAndRep(suffixId);
					break;
			}
		}
		/**
		 * thực hiện xóa nhanh bức thư hiện tại: thực hiện GUI + Logic
		 * @param	suffixId: gồm index + letterId + FromId
		 */
		public function DeleteFast(suffixId:String):void
		{
			var letterid:int = GetLetterId(suffixId);
			var index:int = GetIndex(suffixId);
			//trace("------------delete fast : LetterID =  " +suffixId+"---senderID");
			var cmd:SendRemoveMessage = new SendRemoveMessage(0, letterid);	//config gói tin
			Exchange.GetInstance().Send(cmd);
			GameLogic.getInstance().user.LetterArr.splice(index, 1);
			var nTemp:Number = m_scroll.verticalScrollPosition;
			RefreshComponent();
			m_scroll.verticalScrollPosition = nTemp - HEIGHT_LETTER - 28;
			
			//DeSelect();
		}
		
		/**
		 * thực hiện hiển thị box trả lời nhanh thư: chỉ thực hiện GUI
		 * @param	suffixId: gồm index + letterId + FromId
		 */
		public function ReplyFast(suffixId:String):void
		{
			//trace("------------reply fast to " + suffixId + "--------------");
			
			var index:int = GetIndex(suffixId);
			var PrevIndex:int = GetIndex(prevSuffixId);
			
			if (PrevIndex != index)
			{
				var CtnId:String = "ctn_" + suffixId;
				var CurCtn:Container = GetContainer(CtnId);
				var imgTextSendCurId:String = IMG_SEND_FAST_ID + "_" + suffixId;
				CurCtn.GetImage(imgTextSendCurId).img.visible = true;
				var txtSendFastCurId:String = TXT_SEND_FAST_ID + "_" + suffixId;
				CurCtn.GetTextBox(txtSendFastCurId).textField.visible = true;
				var btnSendFastCurId:String = SEND_FAST + "_" + suffixId;
				CurCtn.GetButton(btnSendFastCurId).SetVisible(true);
				
				if (PrevIndex != -1)
				{
					var prevCtnId:String = "ctn" + "_" + prevSuffixId;
					var PrevCtn:Container = GetContainer(prevCtnId);
					
					var imgTextSendPrevId:String = IMG_SEND_FAST_ID + "_" + prevSuffixId;
					PrevCtn.GetImage(imgTextSendPrevId).img.visible = false;
					
					var txtSendFastPrevId:String = TXT_SEND_FAST_ID + "_" + prevSuffixId;
					PrevCtn.GetTextBox(txtSendFastPrevId).textField.visible = false;
					
					var btnSendFastPrevId:String = SEND_FAST + "_" + prevSuffixId;
					PrevCtn.GetButton(btnSendFastPrevId).SetVisible(false);
				}
				
				prevSuffixId = suffixId;
			}
			else
			{
				DeSelect();
			}
		}
		
		/**
		 * thực hiện gửi thư nhanh: cả GUI lẫn Logic
		 * @param	suffixId: gồm index + letterId + FromId
		 * @param	bReply: Biến điều khiển luồng, xem là gọi hàm trong thời điểm nào (nếu đã gửi lên => bReply=true, nếu gọi hàm lúc chưa send bReply=false)
		 */
		public function SendFast(suffixId:String, bRep:Boolean):void
		{
			var iReceiverId:Number = GetFromId(suffixId);
			
			if (!bRep)
			{
				//trace("------------send fast to " + suffixId + "--------------");
				//lấy nội dung của text box
				var idCtn:String = "ctn" + "_" + suffixId;
				var ctn:Container = GetContainer(idCtn);
				var idTextBox:String = TXT_SEND_FAST_ID + "_" + suffixId;
				var txtSend:TextBox = ctn.GetTextBox(idTextBox);
				var strContent:String = txtSend.GetText();
				//send lên server
				var sendLetter:SendLetter = new SendLetter(iReceiverId, strContent);
				Exchange.GetInstance().Send(sendLetter);
				
				SaveCurrentMail(suffixId,!bRep);	//luu lai trang thai cua mail
				DeSelect();
			}
			else
			{//đã trả lời mail thì send lên là đã trả lời
				
				//chỉnh item trên gui về dạng đã trả lời
				ProcessItemReplied(suffixId);
				bReply = !bRep;
			}
		}
		
		/**
		 * Hiển thị toàn bộ thư của người gửi, và trả lời lại thư đó: GUI + Logic
		 * @param	suffixId gồm index + letterId + FromId
		 */
		public function ReadAndRep(suffixId:String):void
		{
			//trace("------------read and reply-------------\n"+ suffixId+"*****");
			SaveCurrentMail(suffixId, false);
			GuiMgr.getInstance().GuiReceiveLetter.Show(Constant.GUI_MIN_LAYER, 3);
			DeSelect();
		}
		
		/**
		 * Thực hiện xóa hết thư trong hòm: GUI+Logic
		 */
		public function DeleteAll():void
		{
			//trace("------------delete all-------------");
			//GuiMgr.getInstance().GuiMessageBox.ShowDeleteAllMail(Localization.getInstance().getString("Message31"));
			GuiMgr.getInstance().GuiMessageBox.ShowDeleteAllMail("Bạn có chắc muốn xóa toàn bộ thư không?");
		}
		
		/**
		 * Thực hiện việc gửi thư như bình thường
		 */
		public function SendDefault():void
		{
			//trace("------------send default-------------");
			GuiMgr.getInstance().GuiSendLetter.Show(Constant.GUI_MIN_LAYER, 3);	
		}

		/**
		 * hàm thực hiện bỏ chọn box trả lời nhanh
		 */
		public function DeSelect():void
		{
			var PrevIndex:int = GetIndex(prevSuffixId);
			if (PrevIndex != -1)
			{
				var ctnSelectingId:String = "ctn" + "_" + prevSuffixId;
				var ctnSelecting:Container = GetContainer(ctnSelectingId);
				
				var imgCurSendFastId:String = IMG_SEND_FAST_ID + "_" + prevSuffixId;
				ctnSelecting.GetImage(imgCurSendFastId).img.visible = false;
				
				var txtCurSendFastId:String = TXT_SEND_FAST_ID + "_" + prevSuffixId;
				ctnSelecting.GetTextBox(txtCurSendFastId).textField.visible = false;
				ctnSelecting.GetTextBox(txtCurSendFastId).textField.text = "";
				
				var btnCurSendFastId:String = SEND_FAST + "_" + prevSuffixId;
				ctnSelecting.GetButton(btnCurSendFastId).SetVisible(false);
				ctnSelecting.GetButton(btnCurSendFastId).SetDisable();
				
				prevSuffixId = "-1_-1_-1";
			}
		}
		
		/**
		 * hàm xử lý trên item sau khi trả lời thư xong
		 */
		public function ProcessItemReplied(suffixId:String):void
		{
			var iLeterId:int = GetLetterId(suffixId);
			
			//send len server
			var sendReply:SendReplyMail = new SendReplyMail(iLeterId);
			Exchange.GetInstance().Send(sendReply);
			
			var curCtnId:String = "ctn_" + suffixId;
			var curCtn:Container = GetContainer(curCtnId);
			//add dau tick COmplete vao trong container
			var curBtnReplyId:String = REPLY_FAST + "_" + suffixId;
			var curBtnReply:Button = curCtn.GetButton(curBtnReplyId);
			curBtnReply.SetDisable();
			curCtn.AddImage("", "GuiNewMail_IcComplete", curBtnReply.img.x + 35, HEIGHT_LETTER - 15);
		}
		
		public function ProcessItemReplied2(suffixId:String):void
		{
			var iLeterId:int = GetLetterId(suffixId);
			
			var letter:Object = GetLetter(iLeterId);
			if (!letter.IsRead)
			{//chưa đọc thì thực hiện chỉnh sửa GUI trên letter.
				ProcessItemReplied(suffixId);
			}
			//đọc rồi thì thôi :D
		}
		
		/**
		 * lưu lại vị trí của thư vào biến toàn cục
		 * @param  suffixId gồm index + letterId + FromId
		 */
		public static function SaveCurrentMail(suffixId:String,bRep:Boolean = false):void
		{
			curSuffixId = suffixId;
			bReply = bRep;
		}
		
		public override function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void
		{
			//super.OnTextboxKeyUp(event, txtID);
			var data:Array = txtID.split("_");
			var task:String = data[0];
			var prefixId:String = data[1] + "_" + data[2] + "_" + data[3];
			var btnSendId:String = SEND_FAST + "_" + prefixId;
			switch(task)
			{
				case TXT_SEND_FAST_ID:
					AddToolTipButton(prefixId);
					break;
			}
		}
		
		public function AddToolTipButton(prefixId:String):void
		{
			var ctn:Container = GetContainer("ctn_" + prefixId);
			var txtWriter:TextBox = ctn.GetTextBox(TXT_SEND_FAST_ID + "_" + prefixId);
			var btnSend:Button = ctn.GetButton(SEND_FAST + "_" + prefixId);
			var txt: String = StringUtil.trim(txtWriter.GetText());
			if (txt != "")
			{
				btnSend.img.enabled = true;
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
		
		/**
		 * lấy  thư
		 * @param	idLetter: id của thư cần lấy
		 * @return thư
		 */
		public function GetLetter(idLetter:int):Object
		{
			var obj:Object = new Object();
			var arr:Array = GameLogic.getInstance().user.LetterArr;
			var length:int = arr.length;
			var i:int;
			for (i = 0; i < length; i++)
			{
				if (arr[i].Id == idLetter)
				{
					obj.Content = arr[i].Content;
					obj.FromId = arr[i].FromId;
					obj.Id = arr[i].Id;
					obj.FromTime = arr[i].FromTime;
					obj.IsRead = arr[i].IsRead;
					obj.IsReaded = arr[i].IsReaded;
					return obj;
				}
			}
			return null;
		}
		
		/**
		 * add dòng label khi mà không có thư
		 */
		private function AddEmptyMsg():void
		{
			GetButton(GUI_NEW_MAIL_BTN_DELETEALL).SetDisable();
			m_scroll.visible = false;
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
		
		/**
		 * xử lý xóa hết thư
		 */
		public function ProcessDeleteAll():void
		{
			//trace("-----------delete all rui! YEAH!!!");

			var i:int;
			var curId:String;
			var arr:Array = new Array();
			arr = GameLogic.getInstance().user.LetterArr;
			var length:int = arr.length;
			for (i = 0; i < length; i++)
			{
				//send len server
				var cmd:SendRemoveMessage=new SendRemoveMessage(0, arr[i].Id);
				Exchange.GetInstance().Send(cmd);
				//xoa tren GUI
				curId = "ctn_" + i.toString() + "_" + (arr[i].Id as int).toString() + "_" + (arr[i].FromId as int).toString();
				Content.removeChild(GetContainer(curId).img);
			}
			Content = null;
			AddEmptyMsg();
			//xoa trong user.LetterArr
			arr.splice(0, length);
		}
		
		/**
		 * lấy ra Id của thư hiện tại đang xử lý (lấy từ curSuffixId)
		 * @return letterId
		 */
		public function GetCurLetterId():int
		{
			return GetLetterId(curSuffixId);
		}
		/**
		 * lọc ra index từ suffixId
		 * @param	suffixId: gồm index + letterId + FromId
		 * @return index
		 */
		private function GetIndex(suffixId:String):int
		{
			var data:Array = suffixId.split("_");
			return (int)(data[0]);
		}
		/**
		 * lọc ra letterId từ suffixId
		 * @param	suffixId gồm index + letterId + FromId
		 * @return LetterId
		 */
		private function GetLetterId(suffixId:String):int
		{
			var data:Array = suffixId.split("_");
			return (int)(data[1]);
		}
		/**
		 * lọc ra FromId từ suffixId
		 * @param	suffixId gồm index + letterId + FromId
		 * @return FromId
		 */
		private function GetFromId(suffixId:String):Number
		{
			var data:Array = suffixId.split("_");
			return (Number)(data[2]);
		}
		
	}
}
