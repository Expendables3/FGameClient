package GUI.unused 
{
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author 
	 */
	public class GUICongrat extends BaseGUI 
	{
		public static const BTN_CLOSE:String = "btnClose";
		
		public function GUICongrat(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUICongrat";
		}
		
		public override function InitGUI() :void
		{
			//LoadRes("GUI_Congrat");
			SetPos(115, 40);	
			AddButton(BTN_CLOSE, "BtnThoat", 544, 0, this);
		}
		
	}

}