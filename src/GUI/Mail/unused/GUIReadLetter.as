package GUI.Mail.unused 
{
	import Logic.GameLogic;
	/**
	 * ...
	 * @author Hien
	 */
	public class GUIReadLetter extends BaseGUI
	{
		
		public function GUIReadLetter(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIReadLetter";
		}
		public override function InitGUI() :void
		{
			//LoadRes("ContainerLetter");
			//AddImage("", "IconLetter", 220, 0);
			AddButton(GUI_LETTER_BTN_CLOSE, "BtnThoat", 440, 10, this);
			var id: int = GuiMgr.getInstance().GuiLetter.LetterOpen;
			var content: String = GameLogic.getInstance().user.LetterArr[id].content;
			AddLabel()
		}
		
	}

}