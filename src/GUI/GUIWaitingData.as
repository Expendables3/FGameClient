package GUI 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import GUI.component.BaseGUI;
	/**
	 * ...
	 * @author ducnh
	 */
	public class GUIWaitingData extends BaseGUI
	{
		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		
		public function GUIWaitingData(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP)  
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIWaitingData";
		}
		
		public override function InitGUI() :void
		{
			img = WaitData;
			Parent.addChild(img);
			SetPos(400, 300);
		}
	}

}