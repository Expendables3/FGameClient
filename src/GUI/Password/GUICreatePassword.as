package GUI.Password 
{
	import com.adobe.crypto.MD5;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
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
	public class GUICreatePassword extends BaseGUI 
	{
		private var boxPassword:TextBox;
		private var boxConfirm:TextBox;
		private var ctnInputNumber:Container;
		private var activeBox:String;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_OK:String = "btnOk";
		static public const BTN_CANCEL:String = "btnCancel";
		static public const BTN_NUMBER:String = "btnNumber";
		static public const BOX_PASSWORD:String = "boxPassword";
		static public const BOX_CONFIRM:String = "boxConfirm";
		static public const BTN_BACKSPACE:String = "btnBackspace";
		static public const BTN_ENTER:String = "btnEnter";
		
		public function GUICreatePassword(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(100, 100);
				AddButton(BTN_CLOSE, "BtnThoat", 418, 21);
				boxPassword = AddTextBox(BOX_PASSWORD, "", 50 + 137, 20 + 79, 180, 16, this);
				boxPassword.textField.selectable =true;
				boxPassword.textField.maxChars = 6;
				boxPassword.textField.displayAsPassword = true;
				boxPassword.textField.type = TextFieldType.INPUT;
				//boxPassword.textField.border = true;
				var txtFormat:TextFormat = new TextFormat("arial", 20, 0xffffff, true);
				boxPassword.SetTextFormat(txtFormat);
				boxPassword.SetDefaultFormat(txtFormat);
				boxConfirm = AddTextBox(BOX_CONFIRM, "", 50 + 137, 50 + 94, 180, 16, this);
				boxConfirm.textField.selectable = true;
				boxConfirm.textField.maxChars = 6;
				boxConfirm.textField.displayAsPassword = true;
				boxConfirm.textField.type = TextFieldType.INPUT;
				boxConfirm.SetTextFormat(txtFormat);
				boxConfirm.SetDefaultFormat(txtFormat);
				//boxConfirm.textField.border = true;
				AddButton(BTN_OK, "GuiPassword_BtnConfirm", 100, 50 + 140);
				AddButton(BTN_CANCEL, "GuiPassword_BtnCancel", 230, 50 + 140);
				
				ctnInputNumber = AddContainer("", "GuiPassword_BgInputNumber", 450, 0);
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
					//ctnInputNumber.AddLabel(arrNumber[j].toString(), (j % 3) * 30 + 20, Math.floor(j / 3) * 30 +120);
				}
				ctnInputNumber.AddButton(BTN_BACKSPACE, "GuiPassword_BtnBackSpace", (10 % 3) * 55 + 27, Math.floor(10 / 3) * 50 + 34, this);
				ctnInputNumber.AddButton(BTN_ENTER, "GuiPassword_BtnOk", (11 % 3) * 55 + 27, Math.floor(11 / 3) * 50 + 34, this);
				
				//var mask:Sprite = new Sprite();
				//mask.graphics.beginFill(0xff0000);
				//mask.graphics.drawRect(450, 0, ctnInputNumber.img.width + 10, ctnInputNumber.img.height + 10);
				//mask.graphics.endFill();
				//img.addChild(mask);
				//ctnInputNumber.img.mask = mask;
				ctnInputNumber.img.visible = false;
				
			}
			
			LoadRes("GuiCreatePassword_Theme");
		}
		
		override public function OnHideGUI():void 
		{
			super.OnHideGUI();
			GuiMgr.getInstance().guiPassword.showGUI();
		}
		
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var txtBox:TextBox;
			switch(buttonID)
			{
				case BTN_ENTER:
					//TweenMax.to(ctnInputNumber.img, 0.3, { bezierThrough:[ { x:0, y:0 } ], ease:Expo.easeIn } );
					ctnInputNumber.img.visible = false;
					break;
				case BOX_PASSWORD:
				case BOX_CONFIRM:
					activeBox = buttonID;
					ctnInputNumber.img.visible = true;
					//TweenMax.to(ctnInputNumber.img, 0.3, { bezierThrough:[ { x:450, y:0 } ], ease:Expo.easeIn } );
					ctnInputNumber.img.visible = true;
					break;
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_OK:
					if (boxConfirm.textField.length < 6 || boxPassword.textField.length < 6 || boxPassword.textField.text != boxConfirm.textField.text)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Mật khẩu phải có 6 chữ số và giống mã xác nhận!");
					}
					else
					{
						//trace("Thanh cong", passwordValue);
						GameLogic.getInstance().user.passwordState = Constant.PW_STATE_IS_LOCK;
						var md5Password:String = MD5.hash(boxPassword.textField.text);
						Exchange.GetInstance().Send(new SendCreatePassword(md5Password));
						//GameLogic.getInstance().user.password = passwordValue;
						Hide();
						GuiMgr.getInstance().guiPassword.showGUI();
					}
					break;
				case BTN_CANCEL:
					Hide();
					break;
				case BTN_BACKSPACE:
					txtBox = GetTextBox(activeBox);
					if (txtBox != null)
					{
						backspaceToTextField(txtBox.textField);
					}
					break;
				case BTN_ENTER:
					txtBox = GetTextBox(activeBox);
					if (txtBox != null)
					{
						backspaceToTextField(txtBox.textField);
					}
					break;
				default:
					if (buttonID.search(BTN_NUMBER) >= 0)
					{
						var number:int = buttonID.split("_")[1];
						//trace(number);
						txtBox = GetTextBox(activeBox);
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
					EffectMgr.getInstance().textFly("Mật mã phải là số!", new Point(370, 220), txtFormat);
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