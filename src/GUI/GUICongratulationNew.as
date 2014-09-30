package GUI 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUICongratulationNew extends BaseGUI 
	{
		static public const BTN_OK:String = "btnOk";
		static public const BTN_CLOSE:String = "btnClose";
		private var message:String;
		private var btnName:String;
		private var imagename:String;
		private var textField:TextField;
		private var labelNum:TextField;
		private var num:int;
		private var okFunction:Function;
		private var image:Image;
		
		public function GUICongratulationNew(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(220, 100);
				AddButton(BTN_CLOSE, "BtnThoat", 500 - 155, 44);
				AddButton(BTN_OK, btnName, 145, 245);
				
				image = AddImage("", imagename, 165, 150);
				image.FitRect(60, 60, new Point(165, 145));
				
				textField = AddLabel("", 16, 87, 0x0c6298);
				textField.width = 260;
				textField.wordWrap = true;
				var txtFormat:TextFormat = new TextFormat("Arial", 18, 0x0c6298, true);
				txtFormat.align = "center";
				textField.defaultTextFormat = txtFormat;
				labelNum = AddLabel("", 165, 140, 0, 0, 0x26709c);
				txtFormat.size = 15;
				txtFormat.color = 0xffffff;
				labelNum.defaultTextFormat = txtFormat;
				
				textField.text = message;
				if(num != 0)
				{
					labelNum.text = "x" + Ultility.StandardNumber(num);
				}
			}
			LoadRes("GuiCongratulation_Theme");
		}
		
		public function showGUI(_imageName:String, _num:int = 0, _message:String = "", _okFunction:Function = null, _btnName:String = "BtnNhanThuong"):void
		{
			imagename = _imageName;
			btnName = _btnName;
			num = _num;
			message = _message;
			okFunction = _okFunction;
			
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID == BTN_OK && okFunction != null)
			{
				okFunction();
			}
			Hide();
		}
	}

}