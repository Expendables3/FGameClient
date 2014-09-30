package GUI 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.component.TextBox;
	
	/**
	 * GUI cho việc nhập số lượng để mua hay làm gì đó:
		 * Anh + ten cua do can nhap so luong
		 * 1 TextBox: the hien so luong
		 * 2 nut pre + next
		 * nut xac nhan
		 * thuc hien ham xac nhan
	 * @author HiepNM2
	 */
	public class GuiChooseNumAbstract extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnThoat";
		static public const BTN_OK:String = "btnOk";
		static public const BTN_NEXT:String = "btnNext";
		static public const BTN_PRE:String = "btnPre";
		private var textBox:TextBox;
		private var labelName:TextField;
		private var _num:Number;
		protected var maxNum:Number;
		private var completeFunction:Function;
		private var name:String;
		private var objName:String;
		private var Quartz:Boolean = false;
		
		private var _themeName:String = "GuiChooseNumber";
		private var _themeNameQuartz:String = "GuiChooseNumber_ReportBuy";
		private var _guiName:String = "GuiChooseNumber";
		protected var _xNext:int = 204;
		protected var _yNext:int = 203;
		protected var _xPrev:int = 128;
		protected var _xImage:int = 150;
		protected var _yImage:int = 120;
		protected var _wImage:int = 50;
		protected var _hImage:int = 50;
		protected var _xTextBox:int = 151;
		protected var _yTextBox:int = 208;
		protected var _wTextBox:int = 50;
		protected var _hTextBox:int = 41;
		protected var _xName:int = 128;
		protected var _yName:int = 71;
		protected var _xClose:int = 333;
		protected var _yClose:int = 17;
		protected var _xConfirm:int = 124;
		protected var _yConfirm:int = 260;
		
		
		public function GuiChooseNumAbstract(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			//trace("GuiChooseNumAbstract Quartz== " + Quartz);
			if (Quartz)
			{
				ClassName = "GuiTrungLinhThach_ReportBuy"; 
			}
			else
			{
				ClassName = "GuiChooseNumAbstract";
			}
		}
		override public function InitGUI():void 
		{
			//trace("InitGUI() Quartz== " + Quartz);
			if (Quartz)
			{
				setImgInfo = function():void
				{
					SetPos (Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
					
					AddButton(BTN_CLOSE, "BtnThoat", 400, 19, this);
					AddButton(BTN_OK, "BtnAccept", 175, 318, this);
					
					var txtFormat:TextFormat = new TextFormat("arial", 18, 0x003333, true);
					labelName = AddLabel("", 250, 68.5);
					labelName.defaultTextFormat = txtFormat;
					
					txtFormat.color = 0xffffff;
					textBox = AddTextBox("", "maxNum", 160, 287, 150, 41, this);
					txtFormat.align = "center";
					textBox.SetDefaultFormat(txtFormat);
					
					AddButton(BTN_NEXT, _guiName + "_BtnNext", 300, 282, this).SetEnable(false);
					AddButton(BTN_PRE, _guiName + "_BtnPrevious", 128, 282, this);
					
					textBox.SetText(maxNum.toString());
					labelName.text = name;
					
					var image:Image = AddImage("", objName, 200, 145, true, ALIGN_LEFT_TOP);
					image.FitRect(_wImage, _hImage, new Point(200, 145));
					
					onAddOther();
					num = 1;// maxNum;
					
				}
				LoadRes(_themeNameQuartz);
			}
			else
			{
				setImgInfo = function():void
				{
					SetPos (Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
					
					AddButton(BTN_CLOSE, "BtnThoat", _xClose, _yClose, this);
					AddButton(BTN_OK, "BtnAccept", _xConfirm, _yConfirm, this);
					
					var txtFormat:TextFormat = new TextFormat("arial", 18, 0xf00000, true);
					labelName = AddLabel("", _xName, _yName);
					labelName.defaultTextFormat = txtFormat;
					
					txtFormat.color = 0xffffff;
					textBox = AddTextBox("", "maxNum", _xTextBox, _yTextBox, _wTextBox, _hTextBox, this);
					txtFormat.align = "center";
					textBox.SetDefaultFormat(txtFormat);
					
					AddButton(BTN_NEXT, _guiName + "_BtnNext", _xNext, _yNext, this).SetEnable(false);
					AddButton(BTN_PRE, _guiName + "_BtnPrevious", _xPrev, _yNext, this);
					
					textBox.SetText(maxNum.toString());
					labelName.text = name;
					
					var image:Image = AddImage("", objName, _xImage, _yImage, true, ALIGN_LEFT_TOP);
					image.FitRect(_wImage, _hImage, new Point(_xImage, _yImage));
					//image = AddImage("",bgText,
					
					onAddOther();
					num = maxNum;
					onAddNum();
					
				}
				LoadRes(_themeName);
			}
		}
		
		protected virtual function onAddNum():void 
		{
			
		}
		protected virtual function onAddOther():void { }
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_NEXT:
					GetButton(BTN_PRE).SetEnable(true);
					num++;
					break;
				case BTN_PRE:
					GetButton(BTN_NEXT).SetEnable(true);
					num--;
					break;
				case BTN_OK:	
					completeFunction(num);
					Hide();
					break;
				case BTN_CLOSE:
					completeFunction(0);
					Hide();
					break;
			}
		}
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			var value:Number = Number(textBox.GetText());
			if (value <= maxNum && value > 0)
			{
				num = value;
			}
			else
			{
				textBox.SetText(num.toString());
			}
		}
		public function get num():Number 
		{
			return _num;
		}
		
		public function set num(value:Number):void 
		{
			_num = value;
			textBox.SetText(value.toString());
			if (value == 1)
			{
				GetButton(BTN_PRE).SetEnable(false);
			}
			else
			{
				GetButton(BTN_PRE).SetEnable(true);
			}
			if (value == maxNum)
			{
				GetButton(BTN_NEXT).SetEnable(false);
			}
			else
			{
				GetButton(BTN_NEXT).SetEnable(true);
			}
			if (value == 0)
			{
				GetButton(BTN_NEXT).SetEnable(false);
				GetButton(BTN_PRE).SetEnable(false);
			}
			onSetNum();
		}
		
		protected virtual function onSetNum():void { };
		
		protected function set ThemeName(value:String):void 
		{
			_themeName = value;
			var data:Array = value.split("_");
			_guiName = data[0];
		}
		
		public function showGUI(_maxNum:Number, _name:String, imgName:String, _completeFunction:Function, _isQuartz:Boolean = false):void
		{
			objName = imgName;
			name = _name;
			Quartz = _isQuartz;
			maxNum = _maxNum;
			completeFunction = _completeFunction;
			Show(Constant.GUI_MIN_LAYER, 5);
			//trace("showGUI _isQuartz== " + _isQuartz);
		}
	}

}























