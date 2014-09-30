package GUI.EventNationalCelebration 
{
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUITooltipGiftXMas extends BaseGUI 
	{
		
		public function GUITooltipGiftXMas(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("Tooltip_Gift_XMas");
			AddLabel("Bạn được chọn 1 trong các hệ sau:", 20, 13, 0xFFff00, 0, 0x603813);
		}
		
		public function showGUI(arrImgName:Array, x:Number, y:Number):void
		{
			Show();
			SetPos(x, y);
			for (var i:int = 0; i < arrImgName.length; i++)
			{
				var image:Image = AddImage("", arrImgName[i], i * 50, 10);
				image.FitRect(60, 60, new Point(35 + i * 90, 45));
			}
		}
	}

}