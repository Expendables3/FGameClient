package GUI.unused
{
	/**
	 * ...
	 * @author Hien
	 */
	public class GUILetterReply extends BaseGUI
	{
		
		public function GUILetterReply(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUILetterReply";
		}
		public override function InitGUI(): void
		{
		//	LoadRes("ContainerLetter");
		//	AddImage("", "IconLetter", 220, 0);
		}
	}

}