package GUI.BlackMarket 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIIntroBetaMarket extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_EXIT:String = "btnExit";
		
		public function GUIIntroBetaMarket(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				AddButton(BTN_CLOSE, "BtnThoat", 300 + 407, 21);
				AddButton(BTN_EXIT, "BtnDong", 320, 496);
				SetPos(23, 21)
			}
			LoadRes("GuiIntroBetaMarket");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			Hide();
		}
	}

}