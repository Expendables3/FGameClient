package GUI.BlackMarket 
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
	 * ...
	 * @author dongtq
	 */
	public class GUIChooseNum extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnThoat";
		static public const BTN_OK:String = "btnOk";
		static public const BTN_NEXT:String = "btnNext";
		static public const BTN_PRE:String = "btnPre";
		private var textBox:TextBox;
		private var labelName:TextField;
		private var _num:int;
		private var maxNum:int;
		private var completeFunction:Function;
		private var name:String;
		private var objName:String;
		
		public function GUIChooseNum(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function():void
			{
				AddButton(BTN_CLOSE, "BtnThoat", 419 - 86, 17, this);
				AddButton(BTN_OK, "BtnAccept", 124, 260, this);
				
				SetPos ( 240, 150);
				
				var txtFormat:TextFormat = new TextFormat("arial", 18, 0xf00000, true);
				labelName = AddLabel("Tên", 128, 71);
				labelName.setTextFormat(txtFormat);
				labelName.defaultTextFormat = txtFormat;
				//txtFormat.color = 0xf00000;
				//AddLabel("Chọn số lượng:", 180, 135).setTextFormat(txtFormat);
				
				txtFormat.color = 0xffffff;
				textBox = AddTextBox("", "maxNum", 151, 208, 50, 41, this);
				txtFormat.align = "center";
				textBox.SetTextFormat(txtFormat);
				textBox.SetDefaultFormat(txtFormat);
				AddButton(BTN_NEXT, "GuiChooseNumber_BtnNext", 204, 203, this).SetEnable(false);
				AddButton(BTN_PRE, "GuiChooseNumber_BtnPrevious", 128, 203, this);
				
				textBox.SetText(maxNum.toString());
				labelName.text = name;
				var image:Image = AddImage("", objName, 200, 80, true, ALIGN_LEFT_TOP);
				image.FitRect(50, 50, new Point(150, 120));
				num = maxNum;
				
			}
			LoadRes("GuiChooseNumber");
		}
		
		public function showGUI(_maxNum:int, _name:String, imgName:String, _completeFunction:Function):void
		{
			objName = imgName;
			name = _name;
			maxNum = _maxNum;
			completeFunction = _completeFunction;
			Show(Constant.GUI_MIN_LAYER, 5);
		}
		
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
			var value:int = int(textBox.GetText());
			if (value <= maxNum && value > 0)
			{
				num = value;
			}
			else
			{
				textBox.SetText(num.toString());
			}
		}
		
		public function get num():int 
		{
			return _num;
		}
		
		public function set num(value:int):void 
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
		}
		
	}

}