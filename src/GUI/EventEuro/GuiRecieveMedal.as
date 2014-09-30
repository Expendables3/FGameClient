package GUI.EventEuro 
{
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GuiRecieveMedal extends BaseGUI 
	{
		private var okFunction:Function;
		private var numMedal:int;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_RECIEVE:String = "btnRecieve";
		
		public function GuiRecieveMedal(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(175, 80);
				AddButton(BTN_CLOSE, "BtnThoat", 479, 42);
				AddButton(BTN_RECIEVE, "GuiRecieveMedal_BtnRecieveMedal", 100, 296);
				var txtFormat:TextFormat = new TextFormat("arial", 18, 0xffffff, true);
				AddLabel("x"+Ultility.StandardNumber(numMedal), 104, 256, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
				AddLabel("x"+Ultility.StandardNumber(numMedal), 327, 256, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
			}
			LoadRes("GuiRecieveMedal_Theme");
		}
		
		public function showGUI(_numMedal:int, _okFunction:Function):void
		{
			numMedal = _numMedal;
			okFunction = _okFunction;
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (okFunction != null)
			{
				okFunction();
			}
			Hide();
		}
		
	}

}