package GUI.Password 
{
	import com.adobe.crypto.MD5;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Effect.EffectMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.TextBox;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIChangePassword extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const TXT_BOX_OLD_PASSWORD:String = "txtBoxOldPassword";
		static public const TXT_BOX_NEW_PASSWORD:String = "txtBoxNewPassword";
		static public const TXT_BOX_CONFIRM:String = "txtBoxConfirm";
		static public const BTN_OK:String = "btnOk";
		static public const BTN_CANCEL:String = "btnCancel";
		static public const BTN_NUMBER:String = "btnNumber";
		static public const BTN_BACKSPACE:String = "btnBackspace";
		static public const BTN_ENTER:String = "btnEnter";
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var waiting:MovieClip = new DataLoading();
		private var ctnInputNumber:Container;
		private var activeBox:String;
		private var txtBoxOldPassword:TextBox;
		private var txtBoxNewPassword:TextBox;
		private var txtBoxConfirm:TextBox;
		
		public function GUIChangePassword(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(150, 100);
				img.addChild(waiting);
				waiting.x = img.width / 2;
				waiting.y = img.height / 2 - 10;
				waiting.visible = false;
				AddButton(BTN_CLOSE, "BtnThoat", 418, 21);
				AddButton(BTN_OK, "GuiPassword_BtnConfirm", 111, 300 - 73);
				AddButton(BTN_CANCEL, "GuiPassword_BtnCancel", 140 + 111,300 - 73);
				
				txtBoxOldPassword = AddTextBox(TXT_BOX_OLD_PASSWORD, "", 50 + 134, 30 + 65, 180, 18, this);
				txtBoxOldPassword.textField.selectable = true;
				txtBoxOldPassword.textField.type = TextFieldType.INPUT;
				txtBoxOldPassword.textField.displayAsPassword = true;
				txtBoxOldPassword.textField.maxChars = 6;
				//txtBoxOldPassword.textField.border = true;
				txtBoxNewPassword = AddTextBox(TXT_BOX_NEW_PASSWORD, "", 50 + 134, 70 + 71, 180, 18, this);
				txtBoxNewPassword.textField.selectable = true;
				txtBoxNewPassword.textField.type = TextFieldType.INPUT;
				txtBoxNewPassword.textField.displayAsPassword = true;
				txtBoxNewPassword.textField.maxChars = 6;
				//txtBoxNewPassword.textField.border = true;
				txtBoxConfirm = AddTextBox(TXT_BOX_CONFIRM, "", 50 + 134, 110 + 75, 180, 18, this);
				txtBoxConfirm.textField.selectable = true;
				txtBoxConfirm.textField.type = TextFieldType.INPUT;
				txtBoxConfirm.textField.displayAsPassword = true;
				txtBoxConfirm.textField.maxChars = 6;
				//txtBoxConfirm.textField.border = true;
				var txtFormat:TextFormat = new TextFormat("arial", 20, 0xffffff, true);
				txtBoxOldPassword.SetDefaultFormat(txtFormat);
				txtBoxNewPassword.SetDefaultFormat(txtFormat);
				txtBoxConfirm.SetDefaultFormat(txtFormat);
				
				//Khung nhap so
				ctnInputNumber = AddContainer("", "GuiPassword_BgInputNumber", 450, 43);
				var arrNumber:Array = new Array();
				var count:int = 0;
				while (count < 10)
				{
					var random:int = int(Math.random() * 10);
					var check:Boolean = false;
					for (var i:int = 0; i < arrNumber.length; i++)
					{
						if (random == arrNumber[i])
						{
							check = true;
							break;
						}
					}
					if (!check)
					{
						arrNumber.push(random);
						count++;
					}
				}
				for ( var j:int = 0; j < arrNumber.length; j++)
				{
					ctnInputNumber.AddButton(BTN_NUMBER + "_" + arrNumber[j].toString(), "GuiPassword_BtnNumber" + arrNumber[j].toString(), (j % 3) * 55 + 27, Math.floor(j / 3) * 50 +34, this);
				}
				ctnInputNumber.AddButton(BTN_BACKSPACE, "GuiPassword_BtnBackSpace", (10 % 3) * 55 + 27, Math.floor(10 / 3) * 50 + 34, this);
				ctnInputNumber.AddButton(BTN_ENTER, "GuiPassword_BtnOk", (11 % 3) * 55 + 27, Math.floor(11 / 3) * 50 + 34, this);
				
				//var mask:Sprite = new Sprite();
				//mask.graphics.beginFill(0xff0000);
				//mask.graphics.drawRect(450, 43, ctnInputNumber.img.width + 10, ctnInputNumber.img.height + 10);
				//mask.graphics.endFill();
				//img.addChild(mask);
				//ctnInputNumber.img.mask = mask;
				ctnInputNumber.img.visible = false;
			}
			LoadRes("GuiChangePassword_Theme");
		}
		
		override public function OnHideGUI():void 
		{
			GuiMgr.getInstance().guiPassword.showGUI();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_OK:
					if (txtBoxNewPassword.textField.text != txtBoxConfirm.textField.text || txtBoxNewPassword.textField.length < 6 || txtBoxConfirm.textField.length < 6 
					|| txtBoxOldPassword.textField.text == txtBoxNewPassword.textField.text)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Mật khẩu mới phải có 6 chữ số không trùng mật mã cũ và giống mã xác nhận!");
					}
					else
					{
						var timeStamp:int = GameLogic.getInstance().CurServerTime;
						var md5OldPassword:String = MD5.hash(MD5.hash(txtBoxOldPassword.textField.text) + timeStamp);
						var sendChangePassword:SendChangePassword = new SendChangePassword(md5OldPassword, MD5.hash(txtBoxNewPassword.textField.text));
						sendChangePassword.timeStamp = timeStamp;
						Exchange.GetInstance().Send(sendChangePassword);
						waiting.visible = true;
					}
					break;
				case BTN_CANCEL:
				case BTN_CLOSE:	
					Hide();
					break;
				case TXT_BOX_OLD_PASSWORD:
				case TXT_BOX_NEW_PASSWORD:
				case TXT_BOX_CONFIRM:
					//TweenMax.to(ctnInputNumber.img, 0.3, { bezierThrough:[ { x:450, y:43 } ], ease:Expo.easeIn } );
					ctnInputNumber.img.visible = true;
					activeBox = buttonID;
					break;
				case BTN_ENTER:
					//TweenMax.to(ctnInputNumber.img, 0.3, { bezierThrough:[ { x:0, y:43 } ], ease:Expo.easeIn } );
					ctnInputNumber.img.visible = false;
					break;
				case BTN_BACKSPACE:
					var box:TextBox = GetTextBox(activeBox);
					if (box != null)
					{
						backspaceToTextField(box.textField);
					}
					break;
				default:
					if (buttonID.search(BTN_NUMBER) >= 0)
					{
						var number:int = buttonID.split("_")[1];
						//trace(number);
						var i:int;
						var txtBox:TextBox = GetTextBox(activeBox);
						
						if (txtBox != null)
						{
							addNumberToTextField(txtBox.textField, number);
						}
					}
			}
		}
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			var txtBox:TextBox = GetTextBox(txtID);
			filterTextField(txtBox.textField);
		}
		
		/**
		 * Loai cac ki tu khong phai la so
		 * @param	txtField
		 */
		private function filterTextField(txtField:TextField):void
		{
			for (var i:int = 0; i < txtField.length; i++)
			{
				if (txtField.text.charCodeAt(i) < 48 || txtField.text.charCodeAt(i) > 57)
				{
					var caretIndex:int = txtField.selectionBeginIndex;
					txtField.text = txtField.text.substr(0, caretIndex - 1) + txtField.text.substr(caretIndex, txtField.length - caretIndex);
					txtField.setSelection(caretIndex - 1, caretIndex - 1);
					var txtFormat:TextFormat = new TextFormat("arial", 15, 0xff0000, true);
					txtFormat.align = "center";
					EffectMgr.getInstance().textFly("Mật mã phải là số!", new Point(394, 260), txtFormat);
				}
			}
		}
		
		/**
		 * Thêm số vào txtField
		 * @param	txtField
		 * @param	number
		 */
		private function addNumberToTextField(txtField:TextField, number:int):void
		{
			var first:String;
			var second:String;
			var caretIndex:int = txtField.selectionBeginIndex;
			//trace("caret", caretIndex);
			//Xóa phần bôi đen
			if (txtField.selectionBeginIndex != txtField.selectionEndIndex)
			{
				//trace("begin", txtField.selectionBeginIndex, "end", txtField.selectionEndIndex, "txt", txtField.text);
				txtField.text = txtField.text.substr(0, txtField.selectionBeginIndex) + 
					txtField.text.substr(txtField.selectionEndIndex, txtField.length - txtField.selectionEndIndex);
				//trace("xoa boi den", txtField.text);
			}
			//Giới hạn số chữ số
			if (txtField.length >= 6)
			{
				return;
			}
			//trace("begin", txtBoxPassword.textField.selectionBeginIndex, "end", txtBoxPassword.textField.selectionEndIndex);
			first = txtField.text.substr(0, caretIndex);
			second = txtField.text.substr(caretIndex, txtField.length - caretIndex);
			//trace("caret", caretIndex, "first", first, "second", second);
			txtField.text = first + number + second;
			txtField.stage.focus = txtField;
			txtField.setSelection(caretIndex + 1, caretIndex + 1);
			//trace("pass", txtField.text);
		}
		
		/**
		 * Xóa kí tự sau con trỏ của txtField
		 * @param	txtField
		 */
		private function backspaceToTextField(txtField:TextField):void
		{
			var caretIndex:int = txtField.selectionBeginIndex;
			//Xóa phần bôi đen
			if (txtField.selectionEndIndex != txtField.selectionBeginIndex)
			{
				//trace("begin", txtField.selectionBeginIndex, "end", txtField.selectionEndIndex);
				txtField.text = txtField.text.substr(0, txtField.selectionBeginIndex) + 
					txtField.text.substr(txtField.selectionEndIndex, txtField.length - txtField.selectionEndIndex);
			}
			else
			{
				txtField.text = txtField.text.substr(0, caretIndex - 1) + txtField.text.substr(caretIndex, txtField.length - caretIndex);
			}
			txtField.setSelection(caretIndex - 1, caretIndex - 1);
			txtField.stage.focus = txtField;
			//trace("pass", txtField.text);
		}
		
	}

}