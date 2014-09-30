package GUI.Password 
{
	import com.adobe.crypto.MD5;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import flash.display.MovieClip;
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
	public class GUIPassword extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var waiting:MovieClip = new DataLoading();
		
		private var isLock:Boolean;
		private var txtBoxPassword:TextBox;
		private var ctnInputNumber:Container;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BOX_PASSWORD:String = "boxPassword";
		static public const BTN_UNLOCK:String = "btnUnlock";
		static public const BTN_CREATE_PASSWORD:String = "btnCreatePassword";
		static public const BTN_CHANGE_PASSWORD:String = "btnChangePassword";
		static public const BTN_CRACK_PASSWORD:String = "btnCrackPassword";
		static public const BTN_DETAIL:String = "btnDetail";
		static public const BTN_NUMBER:String = "btnNumber";
		static public const BTN_BACKSPACE:String = "btnBackspace";
		static public const BTN_ENTER:String = "btnEnter";
		static public const BTN_CANCEL_CRACK_PASSWORD:String = "btnCancelCrackPassword";
		static public const BTN_ZMONEY:String = "btnZmoney";
		static public const BTN_DIAMOND:String = "btnDiamond";
		
		public function GUIPassword(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(123, 101);
				AddButton(BTN_CLOSE, "BtnThoat", 200 + 341, 20);
				if (GameLogic.getInstance().user.passwordState != Constant.PW_STATE_UNAVAILABLE)
				{
					AddImage("", "GuiPassword_BgTxtPassword", 180, 182, true, ALIGN_LEFT_TOP);
					txtBoxPassword = AddTextBox(BOX_PASSWORD, "", 200, 221, 142, 23, this);
					var txtFormat:TextFormat = new TextFormat("arial", 20, 0xffffff, true);
					txtBoxPassword.SetDefaultFormat(txtFormat);
					txtBoxPassword.SetTextFormat(txtFormat);
					txtBoxPassword.textField.selectable = true;
					txtBoxPassword.textField.type = TextFieldType.INPUT;
					txtBoxPassword.textField.displayAsPassword = true;
					txtBoxPassword.textField.maxChars = 6;
					//txtBoxPassword.textField.border = true;
					AddButton(BTN_UNLOCK, "GuiPassword_BtnUnlock", 212, 285);
					AddButton(BTN_CREATE_PASSWORD, "GuiPassword_BtnCreatePassword", 388, 185);
					AddButton(BTN_CHANGE_PASSWORD, "GuiPassword_BtnChangePassword", 388, 235);
					AddButton(BTN_CRACK_PASSWORD, "GuiPassword_BtnCrackPassword", 388, 285);
					
					//GameLogic.getInstance().user.passwordState = Constant.PW_STATE_IS_BLOCKED;
					trace(GameLogic.getInstance().user.passwordState);
					switch(GameLogic.getInstance().user.passwordState)
					{
						case Constant.PW_STATE_IS_BLOCKED:
							var timeRemain:Number = GameLogic.getInstance().CurServerTime - GameLogic.getInstance().user.timeStartBlock;
							var timeConfig:Number = ConfigJSON.getInstance().GetItemList("Param")["Password"]["TimeBlockingPassword"];
							//Neu het thoi gian blocked
							if (timeConfig - timeRemain <= 0)
							{
								GameLogic.getInstance().user.passwordState = Constant.PW_STATE_IS_LOCK;
								GameLogic.getInstance().user.remainTimesInput = ConfigJSON.getInstance().GetItemList("Param")["Password"]["MaxTimesInput"];
								GetButton(BTN_UNLOCK).SetEnable(true);
								GetButton(BTN_CREATE_PASSWORD).SetEnable(false);
								GetButton(BTN_CHANGE_PASSWORD).SetEnable(true);
								GetButton(BTN_CRACK_PASSWORD).SetEnable(true);
								
								AddImage("", "GuiPassword_MessageIsLock", 285, 127);
								AddButton(BTN_DETAIL, "GuiPassword_BtnDetail", 250, 125);
								AddLabel("Còn " + GameLogic.getInstance().user.remainTimesInput + " lần nhập", 224, 262, 0xff0000, 1, 0xffffff);
								
								addInputCtn();
								break;
							}
							txtBoxPassword.textField.type = TextFieldType.DYNAMIC;
							AddImage("", "GuiPassword_MessageIsLock", 285, 127);
							AddButton(BTN_DETAIL, "GuiPassword_BtnDetail", 250, 125);
							AddLabel("Thử lại sau: " + Math.ceil((timeConfig - timeRemain) / 60) + " phút !", 224, 262, 0xff0000, 1, 0xffffff);
							GetButton(BTN_CREATE_PASSWORD).SetEnable(false);
							GetButton(BTN_CHANGE_PASSWORD).SetEnable(false);
							GetButton(BTN_CRACK_PASSWORD).SetEnable(false);
							GetButton(BTN_UNLOCK).SetEnable(false);
							break;
						//Chưa thiết lập mật khẩu
						case Constant.PW_STATE_NO_PASSWORD:
							txtBoxPassword.textField.type = TextFieldType.DYNAMIC;
							GetButton(BTN_CREATE_PASSWORD).SetEnable(true);
							GetButton(BTN_CHANGE_PASSWORD).SetEnable(false);
							GetButton(BTN_CRACK_PASSWORD).SetEnable(false);
							GetButton(BTN_UNLOCK).SetEnable(false);
							
							AddImage("", "GuiPassword_MessageNoPassword", 285, 127);
							break;
						//Tài khoản đang khóa
						case Constant.PW_STATE_IS_LOCK:
							GetButton(BTN_UNLOCK).SetEnable(true);
							GetButton(BTN_CREATE_PASSWORD).SetEnable(false);
							GetButton(BTN_CHANGE_PASSWORD).SetEnable(true);
							GetButton(BTN_CRACK_PASSWORD).SetEnable(true);
							
							AddImage("", "GuiPassword_MessageIsLock", 285, 127);
							AddButton(BTN_DETAIL, "GuiPassword_BtnDetail", 250, 125);
							AddLabel("Còn " + GameLogic.getInstance().user.remainTimesInput + " lần nhập", 224, 262, 0xff0000, 1, 0xffffff);
							
							addInputCtn();
							break;
						//Tài khoản đã mở khóa
						case Constant.PW_STATE_IS_UNLOCK:
							AddImage("", "GuiPassword_MessageIsUnlock", 285, 127);
							txtBoxPassword.textField.type = TextFieldType.DYNAMIC;
							GetButton(BTN_UNLOCK).SetEnable(false);
							GetButton(BTN_CREATE_PASSWORD).SetEnable(false);
							GetButton(BTN_CHANGE_PASSWORD).SetEnable(true);
							GetButton(BTN_CRACK_PASSWORD).SetEnable(true);
							break;
						//Tài khoản đang xin phá khóa
						case Constant.PW_STATE_IS_CRACKING:
							AddImage("", "GuiPassword_MessageDeletePassword", 285, 127);
							var timeStartCrackingPassword:Number = GameLogic.getInstance().user.timeStartCrackingPassword;
							var param:int = ConfigJSON.getInstance().GetItemList("Param")["Password"]["TimeCrackingPassword"];
							var distanceTime:int = GameLogic.getInstance().CurServerTime - timeStartCrackingPassword;
							AddLabel(Math.ceil((param - distanceTime)/(3600*24)).toString(), 155, 122, 0xffffff, 1, 0x000000).setTextFormat(new TextFormat("arial", 15, 0xffffff, true));
							
							txtBoxPassword.textField.type = TextFieldType.INPUT;
							GetButton(BTN_UNLOCK).SetEnable(true);
							GetButton(BTN_CREATE_PASSWORD).SetEnable(false);
							GetButton(BTN_CHANGE_PASSWORD).SetEnable(true);
							GetButton(BTN_CRACK_PASSWORD).SetVisible(false);
							AddButton(BTN_CANCEL_CRACK_PASSWORD, "GuiPassword_BtnCancelCrackPassword", GetButton(BTN_CRACK_PASSWORD).img.x, GetButton(BTN_CRACK_PASSWORD).img.y);
							addInputCtn();
							break;
					}
				}
				else
				{
					AddImage("", "GuiPassword_IntroduceMessage", 308, 190);
					var config:Object = ConfigJSON.getInstance().GetItemList("Param")["Password"]["Cost"];
					AddButton(BTN_ZMONEY, "GuiPassword_BtnZMoney", 150 + 32, 150 + 128 + 12); 
					AddButton(BTN_DIAMOND, "GuiPassword_BtnDiamond", 250 + 52 + 32, 150 + 128 + 12); 
					AddLabel(config["ZMoney"], 214, 290, 0xffffff);
					AddLabel(config["Diamond"], 368, 290, 0xffffff);
					AddButton(BTN_DETAIL, "GuiPassword_BtnDetail", 250, 147);
				}
				
				img.addChild(waiting);
				waiting.x = img.width / 2;
				waiting.y = img.height / 2 - 10;
				waiting.visible = false;
			}
			LoadRes("GuiPassword_Theme");
		}
		
		private function addInputCtn():void 
		{
			ctnInputNumber = AddContainer("", "GuiPassword_BgInputNumber", 370, 65);
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
			//mask.graphics.drawRect(347 + 24, 65, ctnInputNumber.img.width + 10, ctnInputNumber.img.height + 10);
			//mask.graphics.endFill();
			//img.addChild(mask);
			//ctnInputNumber.img.mask = mask;
			ctnInputNumber.img.visible = false;
		}
		
		public function showGUI():void 
		{
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function OnHideGUI():void 
		{
			//GuiMgr.getInstance().GuiTopInfo.updateBtnLock();
			GuiMgr.getInstance().guiFrontScreen.updateBtnLock();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (waiting.visible)
			{
				return;
			}
			var config:Object;
			switch(buttonID)
			{
				case BTN_ZMONEY:
					config = ConfigJSON.getInstance().GetItemList("Param")["Password"]["Cost"];
					if (GameLogic.getInstance().user.GetZMoney() >= config["ZMoney"])
					{
						waiting.visible = true;
						Exchange.GetInstance().Send(new SendBuyPasswordFeature("ZMoney"));
						GameLogic.getInstance().user.UpdateUserZMoney( -config["ZMoney"]);
					}
					else
					{
						GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
					}
					break;
				case BTN_DIAMOND:
					config = ConfigJSON.getInstance().GetItemList("Param")["Password"]["Cost"];
					if (GameLogic.getInstance().user.getDiamond() >= config["Diamond"])
					{
						waiting.visible = true;
						Exchange.GetInstance().Send(new SendBuyPasswordFeature("Diamond"));
						GameLogic.getInstance().user.updateDiamond( -config["Diamond"]);
					}
					else
					{
						GuiMgr.getInstance().guiNoDiamond.Show(Constant.GUI_MIN_LAYER, 3);
					}
					break;
				case BTN_CANCEL_CRACK_PASSWORD:
					GuiMgr.getInstance().guiConfirmCrackPassword.showGUI("GuiCancelCrackPassword_Theme", function f():void
					{
						Exchange.GetInstance().Send(new SendCancelCrackPassword());
						waiting.visible = true;
					});
					break;
				case BTN_DETAIL:
					GuiMgr.getInstance().guiDetailLockAction.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_CRACK_PASSWORD:
					GuiMgr.getInstance().guiConfirmCrackPassword.showGUI("GuiCrackPassword_Theme", function f():void
					{
						Exchange.GetInstance().Send(new SendCrackPassword());
						waiting.visible = true;
					});
					break;
				case BTN_CHANGE_PASSWORD:
					Hide();
					GuiMgr.getInstance().guiChangePassword.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_CLOSE:
					Hide();
					break;
				case BOX_PASSWORD:
					if (GameLogic.getInstance().user.passwordState == Constant.PW_STATE_IS_LOCK
					|| GameLogic.getInstance().user.passwordState == Constant.PW_STATE_IS_CRACKING)
					{
						//TweenMax.to(ctnInputNumber.img, 0.3, { bezierThrough:[ { x:370, y:65 } ], ease:Expo.easeIn } );
						ctnInputNumber.img.visible = true;
					}
					break;
				case BTN_ENTER:
					trace(txtBoxPassword.textField.text);
					//TweenMax.to(ctnInputNumber.img, 0.3, { bezierThrough:[ { x:0, y:65 } ], ease:Expo.easeIn } );
					ctnInputNumber.img.visible = false;
					break;
				case BTN_CREATE_PASSWORD:
					Hide();
					GuiMgr.getInstance().guiCreatePassword.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_UNLOCK:
					var md5Mixture:String = MD5.hash(txtBoxPassword.textField.text);
					var timeStamp:int = GameLogic.getInstance().CurServerTime;
					md5Mixture = MD5.hash(md5Mixture +timeStamp);
					var sendSignIn:SendSignIn = new SendSignIn(md5Mixture);
					sendSignIn.timeStamp = timeStamp;
					Exchange.GetInstance().Send(sendSignIn);
					waiting.visible = true;
					break;
				case BTN_BACKSPACE:
					backspaceToTextField(txtBoxPassword.textField);
					break;
				default:
					if (buttonID.search(BTN_NUMBER) >= 0)
					{
						var number:int = buttonID.split("_")[1];
						addNumberToTextField(txtBoxPassword.textField, number);
					}
			}
		}
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			switch(txtID)
			{
				case BOX_PASSWORD:
					filterTextField(txtBoxPassword.textField);
					break;
			}
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
					EffectMgr.getInstance().textFly("Mật mã phải là số!", new Point(394, 322), txtFormat);
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