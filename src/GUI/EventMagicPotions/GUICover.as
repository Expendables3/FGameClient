package GUI.EventMagicPotions 
{
	import GUI.component.BaseGUI;
	
	/**
	 * Chỉ để che khi đánh nhau
	 * @author longpt
	 */
	public class GUICover extends BaseGUI 
	{
		
		public function GUICover(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUICover";
		}
		
		public override function InitGUI() :void
		{
			//this.setImgInfo = function():void
			//{
				//SetPos(225, 140);
			//}
			LoadRes("ImgFrameFriend");
		}
	}

}