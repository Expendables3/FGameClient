package GUI.GUIGemRefine.GemGUI 
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.TextBox;
	import GUI.GUIGemRefine.GemLogic.Gem;
	import GUI.GUIGemRefine.GemLogic.GemMgr;
	import GUI.GUIGemRefine.GemPackage.SendDeleteGem;
	import GUI.GuiMgr;
	import Logic.Ultility;
	import Data.ConfigJSON;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIDelGem extends BaseGUI 
	{
		// const
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_DELETE:String = "idBtnDelete";
		private const ID_BTN_NEXT:String = "idBtnNext";
		private const ID_BTN_PREV:String = "idBtnPrev";
		private const ID_TEXTBOX_NUMGEM:String = "idTextBoxNumGem";
		// logic
		private var szData:String;
		private var numDelGem:int;
		public function set Data(str:String):void
		{
			szData = str;
		}

		// gui
		private var ctnGem:CtnGem;
		private var tbNumDelGem:TextBox;
		private var btnNext:Button;
		private var btnPrev:Button;
		private var _format:TextFormat;
		
		
		public function GUIDelGem(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIConfirmDelGem";
			_format = new TextFormat();
			_format.color = 0x000000;
			_format.size = 16;
			_format.font = "Arial";
			_format.bold = true;
		}
		
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				addBgr();
				addNumGemDel();
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
			}
			LoadRes("GuiDeletePearl_Theme");
		}
		
		private function addBgr():void
		{
			/*add button*/
			AddButton(ID_BTN_CLOSE, "BtnThoat", 419, 17, this);
			AddButton(ID_BTN_DELETE, "GuiDeletePearl_Btn_HuyNew_TuLuyenNgoc", 186, 210);
			AddImage("", "GuiDeletePearl_IMG_Cell_Tach_TuLuyenNgoc", 230, 180);
			btnNext = AddButton(ID_BTN_NEXT, "GuiDeletePearl_Btn_Pre_TuLuyenNgoc", 255, 165);
			btnNext.SetDisable();
			btnPrev = AddButton(ID_BTN_PREV, "GuiDeletePearl_Btn_Next_TuLuyenNgoc", 185, 165);
			
			/*vẽ viên đan*/
			var data:Array = szData.split("_");
			var element:int = (int)(data[0]);
			var level:int = (int)(data[1]);
			var num:int = (int)(data[2]);
			var dayLife:int = (int)(data[3]);
			var gem:Gem = new Gem(element, level, dayLife, num);
			ctnGem = new CtnGem(this.img, "GuiPearlRefine_Img_Cell_TuLuyenNgoc", 209, 90);
			ctnGem.initData(gem, ConfigJSON.getInstance().getItemInfo("Gem")[gem.Level]);
			ctnGem.drawGem();
			ctnGem.EventHandler = this;
			ctnGem.ClearLabel();
			if (num <= 1)
			{
				btnPrev.SetDisable();
			}
			/*ve cac label*/
			var tfGemName:TextField = AddLabel(Ultility.GetNamePearl(ctnGem.gem.Element, ctnGem.gem.Level), 
												164, 67);
			tfGemName.scaleX = tfGemName.scaleY = 1.4;
			var tfChooseNum:TextField = AddLabel("Chọn số lượng muốn hủy :", 170, 135, 0xff0000);
			tfChooseNum.scaleX = tfChooseNum.scaleY = 1.4;
		}
		
		private function addNumGemDel():void
		{
			numDelGem = ctnGem.gem.Num;
			var strNum:String = Ultility.StandardNumber(numDelGem);
			tbNumDelGem = AddTextBox(ID_TEXTBOX_NUMGEM, strNum, 220, 168, 30, 40, this);
			
			tbNumDelGem.SetTextFormat(_format);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_DELETE:
					delGem(ctnGem.gem);
				break;
				case ID_BTN_NEXT:
					nextNum();
				break;
				case ID_BTN_PREV:
					prevNum();
				break;
			}
		}
		private function nextNum():void
		{
			if (++numDelGem >= ctnGem.gem.Num)
			{
				btnNext.SetDisable();
			}
			btnPrev.SetEnable();
			var strNum:String = Ultility.StandardNumber(numDelGem);
			tbNumDelGem.SetText(strNum);
			tbNumDelGem.SetTextFormat(_format);
			
		}
		private function prevNum():void
		{
			if (--numDelGem <= 1)
			{
				numDelGem = 1;
				btnPrev.SetDisable();
			}
			btnNext.SetEnable();
			var strNum:String = Ultility.StandardNumber(numDelGem);
			tbNumDelGem.SetText(strNum);
			tbNumDelGem.SetTextFormat(_format);
		}
		private function delGem(gem:Gem):void
		{
			var lstGem:Array = [];
			var obj:Object = new Object();
			obj["Element"] = gem.Element;
			obj["GemId"] = gem.Level;
			obj["Day"] = gem.DayLife;
			obj["Num"] = numDelGem;
			lstGem.push(obj);
			var pk:SendDeleteGem = new SendDeleteGem(lstGem);
			Exchange.GetInstance().Send(pk);
			/*xử lý xóa ngay ko cần biết success hay không*/
			var gem:Gem = new Gem(obj["Element"], obj["GemId"], obj["Day"], obj["Num"]);
			GemMgr.getInstance().delGem(gem);
			GuiMgr.getInstance().GuiGemRefine.refreshGemBox();
			Hide();
		}
		
		override public function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void 
		{
			var numTextBox:int = (int)(tbNumDelGem.GetText());
			if (event.keyCode == Keyboard.NUMPAD_0)
			{
				var str:String = tbNumDelGem.GetText();
				if (str.substr(0,1) == "0")
				{
					tbNumDelGem.SetText(str.substring(1, str.length));
				}
			}
			else if (event.keyCode == 8)
			{
				if (numTextBox == 0)
				{
					numTextBox = 1;
					tbNumDelGem.SetText("1");
				}
				numDelGem = numTextBox;
				changeButtonState(numTextBox);
				return;
			}
			switch(txtID)
			{
				case ID_TEXTBOX_NUMGEM:
					if (numTextBox == 0 ||  numTextBox > ctnGem.gem.Num)
					{//set về trạng thái đầu tiên
						resetLable();
					}
					else
					{
						numDelGem = numTextBox;
						changeButtonState(numTextBox);
					}
					tbNumDelGem.SetTextFormat(_format);
				break;
			}
		}
		private function changeButtonState(numTextBox:int):void
		{
			if (numTextBox >= ctnGem.gem.Num)
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
			if (ctnGem.gem.Num == 1)
			{
				btnPrev.SetDisable();
			}
		}
		private function resetLable():void
		{
			var maxNum:int = ctnGem.gem.Num;
			numDelGem = maxNum;
			var strNum:String = Ultility.StandardNumber(maxNum);
			tbNumDelGem.SetText(strNum);
			btnNext.SetDisable();
			if (maxNum != 1)
			{
				btnPrev.SetEnable();
			}
			
		}
	}
}





































