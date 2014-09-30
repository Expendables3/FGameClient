package GUI.MainQuest 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUICongratFinishQuest extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		
		public function GUICongratFinishQuest(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GuiMainQuest_FinishQuest");
			AddButton(BTN_CLOSE, "BtnDong", 200 - 31, 500 - 153, this);
			SetPos(200, 100);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			Hide();
		}
		
	}

}