package GUI.TooltipText 
{
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiTooltipTextAbstact extends BaseGUI 
	{
		protected var _tooltip:TooltipTextAbstract;
		protected var _themeName:String;
		protected var _lineName:String;
		
		public function GuiTooltipTextAbstact(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiTooltipTextAbstact";
		}
		
		override public function InitGUI():void 
		{
			LoadRes(_themeName);
			onInitGui();
			drawName();
			drawUsage();
			drawSource();
		}
		
		protected virtual function onInitGui():void 
		{
			
		}

		protected virtual function drawName():void 
		{
		}
		protected virtual function drawUsage():void 
		{
		}
		protected virtual function drawSource():void 
		{
		}
		
		
	}

}
























