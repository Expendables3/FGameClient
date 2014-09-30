package GUI.GUIGemRefine.GemGUI 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import GUI.GUIGemRefine.GemLogic.Gem;
	import GUI.GUIGemRefine.GemPackage.SendRecoverGem;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIRecoverGem extends BaseGUI 
	{
		// const
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_NEXT:String = "idBtnNext";
		private const ID_BTN_PREV:String = "idBtnPrev";
		private const ID_BTN_RECOVER:String = "idBtnRecover";
		private const ID_CTN_SLOT:String = "idCtnSlot";
		private const ID_TEXTBOX_NUM:String = "idTextBoxNum";
		// gui
		private var _format:TextFormat;
		private var ctnSlot:Container;
		private var tbNumRecover:TextBox;
		private var btnNext:Button;
		private var btnPrev:Button;
		private var tfPrice:TextField;
		// logic
		private var _gem:Gem;
		private var numRecoverGem:int;
		private var gMoneyRecover:int = 0;
		private var zMoneyRecover:int = 0;
		private var nPrice:Number;
		
		public function initGem(szData:String, staticObj:Object):void
		{
			var data:Array = szData.split("_");
			var element:int = (int)(data[0]);
			var level:int = (int)(data[1]);
			var daylife:int = (int)(data[3]);
			var num:int = (int)(data[2]);
			_gem = new Gem(element, level, daylife, num);
			if (staticObj["ZMoneyRecover"])
			{
				zMoneyRecover = staticObj["ZMoneyRecover"];
			}
			if (staticObj["MoneyRecover"])
			{
				gMoneyRecover = staticObj["MoneyRecover"];
			}
		}
		public function GUIRecoverGem(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIRecoverGem";
			_format = new TextFormat();
			_format.size = 18;
			_format.color = 0x000000;
			_format.bold = true;
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				addBgr();
				addGem();
			}
			LoadRes("GuiRecoverPearl_Theme");
		}
		private function addBgr():void
		{
			/*add buttons*/
			AddButton(ID_BTN_CLOSE, "BtnThoat", 419, 17);
			AddButton(ID_BTN_RECOVER, "GuiRecoverPearl_Btn_KhoiPhucNgay_TuLuyenNgoc", 160, 210);
		}
		
		private function addGem():void
		{
			/*name gem is a label*/
			var name:String = Ultility.GetNamePearl(_gem.Element, _gem.Level);
			var tfName:TextField = AddLabel(name, 50, 140);
			tfName.setTextFormat(_format);
			/*text Box*/
			numRecoverGem = _gem.Num;
			var strNum:String = Ultility.StandardNumber(numRecoverGem);
			ctnSlot = AddContainer(ID_CTN_SLOT, "GuiRecoverPearl_IMG_Cell_Tach_TuLuyenNgoc", 213, 131, true, this);
			tbNumRecover = ctnSlot.AddTextBox(ID_TEXTBOX_NUM, strNum, 10, 7, 50, 41, this);
			tbNumRecover.SetTextFormat(_format);
			/*Next and Previous buttons*/
			btnNext = ctnSlot.AddButton(ID_BTN_NEXT, "GuiRecoverPearl_Btn_Pre_TuLuyenNgoc", 53, 4, this);
			btnPrev = ctnSlot.AddButton(ID_BTN_PREV, "GuiRecoverPearl_Btn_Next_TuLuyenNgoc", -21, 4, this);
			btnNext.SetDisable();
			if (_gem.Num <= 1)
			{
				btnPrev.SetDisable();
			}
			/*price label*/   /*Money or ZMoney image*/
			var szPrice:String;
			var szIconName:String;
			
			if (gMoneyRecover > 0 && zMoneyRecover == 0)
			{
				nPrice = gMoneyRecover;
				szIconName = "IcGold";
			}
			else if (zMoneyRecover > 0 && gMoneyRecover == 0)
			{
				nPrice = zMoneyRecover;
				szIconName = "IcZingXu";
			}
			nPrice *= numRecoverGem;
			szPrice = Ultility.StandardNumber(nPrice);
			tfPrice = AddLabel(szPrice, 315, 133);
			tfPrice.setTextFormat(_format);
			AddImage("", szIconName, 364, 172);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_RECOVER:
					recoverGem();
				break;
				case ID_BTN_NEXT:
					nextNum();
				break;
				case ID_BTN_PREV:
					prevNum();
				break;
			}
		}
		
		override public function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void 
		{
			var numTextBox:int = (int)(tbNumRecover.GetText());
			if (event.keyCode == Keyboard.NUMPAD_0)
			{
				var str:String = tbNumRecover.GetText();
				if (str.substr(0,1) == "0")
				{
					tbNumRecover.SetText(str.substring(1, str.length));
				}
			}
			else if (event.keyCode == 8)
			{
				if (numTextBox == 0)
				{
					numTextBox = 1;
					tbNumRecover.SetText("1");
				}
				numRecoverGem = numTextBox;
				changeButtonState(numTextBox);
				updatePrice();
				return;
			}
			switch(txtID)
			{
				case ID_TEXTBOX_NUM:
					if (numTextBox == 0 ||  numTextBox > _gem.Num)
					{//set về trạng thái đầu tiên
						resetLable();
					}
					else
					{
						numRecoverGem = numTextBox;
						changeButtonState(numTextBox);
					}
					updatePrice();
					tbNumRecover.SetTextFormat(_format);
				break;
			}
		}
		private function resetLable():void
		{
			var maxNum:int = _gem.Num;
			numRecoverGem = maxNum;
			var strNum:String = Ultility.StandardNumber(maxNum);
			tbNumRecover.SetText(strNum);
			btnNext.SetDisable();
			if (maxNum != 1)
			{
				btnPrev.SetEnable();
			}
		}
		private function changeButtonState(numTextBox:int):void
		{
			if (numTextBox >= _gem.Num)
			{
				btnNext.SetDisable();
				btnPrev.SetEnable();
			}
			else if(numTextBox <= 1)
			{
				btnNext.SetEnable();
				btnPrev.SetDisable();
			}
			else
			{
				btnNext.SetEnable();
				btnPrev.SetEnable();
			}
			if (_gem.Num == 1)
			{
				btnPrev.SetDisable();
			}
		}
		
		private function nextNum():void
		{
			if (++numRecoverGem >= _gem.Num)
			{
				btnNext.SetDisable();
			}
			btnPrev.SetEnable();
			var strNum:String = Ultility.StandardNumber(numRecoverGem);
			tbNumRecover.SetText(strNum);
			tbNumRecover.SetTextFormat(_format);
			updatePrice();
		}
		
		private function prevNum():void
		{
			if (--numRecoverGem <= 1)
			{
				numRecoverGem = 1;
				btnPrev.SetDisable();
			}
			btnNext.SetEnable();
			var strNum:String = Ultility.StandardNumber(numRecoverGem);
			tbNumRecover.SetText(strNum);
			tbNumRecover.SetTextFormat(_format);
			updatePrice();
		}
		private function updatePrice():void
		{
			nPrice = numRecoverGem * gMoneyRecover;
			if (!nPrice)
			{
				nPrice = numRecoverGem * zMoneyRecover;
			}
			var szPrice:String = Ultility.StandardNumber(nPrice);
			tfPrice.text = szPrice;
			tfPrice.setTextFormat(_format);
		}
		private function recoverGem():void
		{
			trace("recover gem");
			var nDolar:Number;
			if (gMoneyRecover > 0 && zMoneyRecover == 0)
			{
				nDolar = GameLogic.getInstance().user.GetMoney();
				if (nDolar < nPrice)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không có đủ vàng. ", 310, 215, GUIMessageBox.NPC_MERMAID_NORMAL);
					return;
				}
				else
				{
					GameLogic.getInstance().user.UpdateUserMoney(0 - nPrice);
				}
			}
			else if (zMoneyRecover > 0 && gMoneyRecover == 0)
			{
				nDolar = GameLogic.getInstance().user.GetZMoney();
				if (nDolar < nPrice)
				{
					GuiMgr.getInstance().GuiNapG.Init();
					return;
				}
				else
				{
					GameLogic.getInstance().user.UpdateUserZMoney(0 - nPrice);
				}
			}
			/*thực hiện khôi phục đan*/
			var list:Array = [];
			var obj:Object = new Object();
			obj["Element"] = _gem.Element;
			obj["GemId"] = _gem.Level;
			obj["Day"] = _gem.DayLife;
			obj["Num"] = numRecoverGem;
			list.push(obj);
			var pk:SendRecoverGem= new SendRecoverGem(list);
			Exchange.GetInstance().Send(pk);
			Hide();
		}
		override public function Hide():void 
		{
			gMoneyRecover = 0;
			zMoneyRecover = 0;
			super.Hide();
		}
		
	}

}






























