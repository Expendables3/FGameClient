package Event.TreasureIsland 
{
	import GUI.component.Container;
	import GUI.component.Image;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class LandItem extends Container 
	{
		public var imgBg:Image;
		public var imgRandom:Image;
		public function LandItem(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			imgBg = AddImage("BG", "LandIdle", 0, 0);
		}
		
		public function setInfo(type:int):void 
		{
			switch(type)
			{
				case -1:
					imgBg.img.visible = false;
					break;
				case 0:
					break;
				default:
					imgRandom.LoadRes("LandItem_" + type);
					break;
			}
		}
		
	}

}