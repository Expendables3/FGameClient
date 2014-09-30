package GUI.Mail.SystemMail.View 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import GUI.AvatarImage;
	import GUI.component.Container;
	import GUI.component.TextBox;
	import GUI.Mail.SystemMail.Model.MailInfo;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * biểu diễn 1 item thư
	 * @author HiepNM2
	 */
	public class ItemMail extends Container 
	{
		// const
		private const CMD_READ:String = "cmdRead";
		private const TB_CONTENT:String = "tbContent";
		private const CMD_DEL_FAST:String = "cmdDelFast";
		private const MAX_WORDS:int = 18;
		
		// logic
		private var _mail:MailInfo;
		// gui
		private var _formatTime:TextFormat;
		private var avatar:AvatarImage;
		private var _formatContent:TextFormat;
		private var tbContent:TextBox;
		public function ItemMail(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemMail";
			_formatTime = new TextFormat();
			_formatTime.color = 0x000000;
			_formatTime.size = 16;
			_formatTime.font = "Arial";//Myriad Pro
			_formatContent = new TextFormat();
			_formatContent.size = 16;
			_formatContent.color = 0x0B7875;
			_formatContent.font = "Arial";
			_formatContent.bold = true;
			_formatContent.italic = true;
		}
		public function initData(mail:MailInfo):void
		{
			_mail = mail;
		}
		public function drawItemMail(eventHandler:GUISystemMail = null):void
		{
			IdObject = "";
			EventHandler = eventHandler;
			var tf:TextField = AddLabel("Hệ thống", -21, 0, 0x096791);
			var fm:TextFormat = new TextFormat();
			fm.bold = true;
			fm.font = "Arial";
			tf.setTextFormat(fm);
			var avatarLink:String = Main.staticURL + "/avatar.png";
			avatar = new AvatarImage(this.img);
			avatar.initAvatar(avatarLink, onLoadAvatarComp);
			function onLoadAvatarComp():void
			{
				avatar.FitRect(60, 60, new Point(0, 20));
			}
			addContent(50, 0);
			AddButton(CMD_DEL_FAST + "_" + _mail.AutoId, "GuiNewMail_BtnDelMailFast", 300, 3, this.EventHandler);
			
		}
		
		private function addContent(x:int = 50, y:int = 0):void
		{
			var ctnContent:Container = AddContainer(CMD_READ + "_" + _mail.AutoId, "GuiNewMail_ImgSystemMail", x, y, true, this.EventHandler);
			
			//nhãn thời gian
			addTime(ctnContent);
			//var curTime:Number = GameLogic.getInstance().CurServerTime;
			//var remainTime:Number = curTime - _mail.FromTime;
			//var strTime:String = standardTime(remainTime);
			//var txtTime:String = "Gửi " + strTime + " trước";
			//var tf:TextField = ctnContent.AddLabel(txtTime, 46, 5);
			//tf.setTextFormat(_formatTime);
			
			//nội dung thư trong 1 cái textbox, text box này không nhận sự kiện keyboard
			var strContent:String = _mail.Content;
			strContent = standardize(strContent);
			tbContent = AddTextBox(CMD_READ + "_" + _mail.AutoId, strContent, 80, 30, 200, 30, EventHandler);
			
			//tbContent.RemoveAllEvent();
			//tb.SetBoder(true);
			tbContent.textField.type = TextFieldType.DYNAMIC;
			tbContent.SetTextFormat(_formatContent);
			tbContent.textField.width = tbContent.textField.textWidth + 10;
			tbContent.textField.height = tbContent.textField.textHeight + 5;
			//tbContent.textField.addEventListener(MouseEvent.CLICK, (EventHandler as GUISystemMail).OnButtonClick);
		}
		
		private function standardize(str:String):String
		{
			var result:String = str;
			var leng:int = str.length;
			if (leng > MAX_WORDS)
			{
				result = str.substr(0, MAX_WORDS);
				result += "...";
			}
			return result;
		}
		private function addTime(container:Container):void
		{
			
			var _fmBlack:TextFormat = new TextFormat();
			_fmBlack = new TextFormat();
			_fmBlack.size = 14;
			_fmBlack.color = 0x000000;
			_fmBlack.bold = true;
			
			var _fmRed:TextFormat = new TextFormat();
			_fmRed = new TextFormat();
			_fmRed.size = 14;
			_fmRed.color = 0xff0000;
			_fmRed.bold = true;
			_fmRed.italic = true;
			
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
			
			var tfTime:TextField = container.AddLabel(str, 46, 5);
			tfTime.setTextFormat(_fmBlack, 0, strHead.length);
			tfTime.setTextFormat(_fmRed, strHead.length, str.length);
		}
		private function standardTime(time:Number):String
		{
			if (time < 86400)
			{
				return Ultility.convertToTime(time);
			}
			else
			{
				var day:int = (int)(time / 86400);
				return day + " ngày";
			}
		}
		
	}

}















