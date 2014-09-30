package GUI.ChampionLeague.FakeServer 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUILoadEffect extends BaseGUI 
	{
		static public const CMD_CLOSE:String = "cmdClose";
		
		public function GUILoadEffect(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUILoadEffect";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButton(CMD_CLOSE, "BtnThoat", 100, 100);
			}
			LoadRes("GuiLeagueGift_Theme");
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID) {
				case CMD_CLOSE:
					Hide();
				break;
			}
		}
	}

}