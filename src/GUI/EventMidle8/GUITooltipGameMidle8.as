package GUI.EventMidle8 
{
	import GUI.component.GUIToolTip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUITooltipGameMidle8 extends GUIToolTip 
	{
		public var imgNameIcon:String;
		
		public function GUITooltipGameMidle8(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			this.ClassName = "GUITooltipGameMidle8";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			//LoadRes("TooltipGuiGameMidle81");
			LoadRes(imgNameBg);
			AddImage("", imgNameIcon, 103 - deltaX, 62 - deltaY);
		}
		
		public function SetInfo(type:int):void 
		{
			switch (type) 
			{
				case GUIGameEventMidle8.GIFT_EXP:
					imgNameIcon = "Exp";
				break;
				case GUIGameEventMidle8.GIFT_MATERIAL:
					imgNameIcon = "MaterialGameMid";
				break;
				case GUIGameEventMidle8.GIFT_ENERGY_ITEM:
					imgNameIcon = "EnergyItemGameMid8";
				break;
				case GUIGameEventMidle8.GIFT_BABYFISH:
					imgNameIcon = "FishGameMid";
				break;
				case GUIGameEventMidle8.GIFT_FATE:
					imgNameIcon = "ObstructGameMid";
				break;
				case GUIGameEventMidle8.GIFT_TREASURE:
					imgNameIcon = "TreasureGameMid";
				break;
			}
		}
	}

}