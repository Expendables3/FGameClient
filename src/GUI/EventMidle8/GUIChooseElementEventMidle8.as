package GUI.EventMidle8 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIChooseElementEventMidle8 extends BaseGUI 
	{		
		private var okFunction:Function;
		static public const BTN_CLOSE:String = "btnClose";
		static public const ELEMENT:String = "element";
		
		public function GUIChooseElementEventMidle8(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIChooseElementEventMidle8";
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(100, 170);
				AddButton(BTN_CLOSE, "BtnThoat", 618, -22);
				AddButton(ELEMENT + "_1", "GuiChooseElement_BtnChooseSteel", 10, 18);
				AddButton(ELEMENT + "_2", "GuiChooseElement_BtnChooseWood", 130, 18);
				AddButton(ELEMENT + "_3", "GuiChooseElement_BtnChooseEarth", 250, 18);
				AddButton(ELEMENT + "_4", "GuiChooseElement_BtnChooseWater", 370, 18);
				AddButton(ELEMENT + "_5", "GuiChooseElement_BtnChooseFire", 490, 18);
			}
			LoadRes("GuiChooseElement_5_Theme");
		}
		
		public function showGUI(_okFunction:Function):void
		{
			okFunction = _okFunction;
			Show(Constant.GUI_MIN_LAYER, 6);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				default:
					if (buttonID.search(ELEMENT) >= 0)
					{
						var element:int = buttonID.split("_")[1];
						if (okFunction != null)
						{
							okFunction(element);
						}
					}
					Hide();
					break;
			}
		}
		
	}

}