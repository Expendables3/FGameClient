package GUI.EventWarChampion 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUITooltipTopUser extends BaseGUI 
	{
		private var imageName:String;
		public function GUITooltipTopUser(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes(imageName);
		}
		
		public function showGUI(imgName:String, x:Number, y:Number):void
		{
			imageName = imgName;
			Show();
			SetPos(x, y);
			//SetPos(x - img.width - 30, y - img.height / 2 - 20);
			//if (img.y < 0)
			//{
				//img.y = 0;
			//}
			//if (img.y + img.height > Constant.STAGE_HEIGHT)
			//{
				//img.y = Constant.STAGE_HEIGHT - img.height ;
			//}
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			Hide();
		}
	}

}