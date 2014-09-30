package Event.EventTeacher 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiGuideTeacher extends BaseGUI 
	{
		static public const CMD_CLOSE:String = "cmdClose";
		
		public function GuiGuideTeacher(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGuideTeacher";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(CMD_CLOSE, "BtnThoat", 702, 18);
			}
			LoadRes("GuiGuideTeacher_Theme");
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case CMD_CLOSE:
					Hide();
					break;
			}
		}
	}

}