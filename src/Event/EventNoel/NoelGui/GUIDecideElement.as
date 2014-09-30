package Event.EventNoel.NoelGui 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIDecideElement extends BaseGUI 
	{
		private var completeFunction:Function;
		static public const BTN_ELEMENT:String = "btnElement";
		static public const BTN_CLOSE:String = "btnClose";
		
		public function GUIDecideElement(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void 
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				
				//AddButton(BTN_CLOSE, "BtnThoat", 618, -22);
				AddButton(BTN_ELEMENT + "_1", "GuiChooseElement_BtnChooseSteel", 10, 18);
				AddButton(BTN_ELEMENT + "_2", "GuiChooseElement_BtnChooseWood", 130, 18);
				AddButton(BTN_ELEMENT + "_3", "GuiChooseElement_BtnChooseEarth", 490, 18);
				AddButton(BTN_ELEMENT + "_4", "GuiChooseElement_BtnChooseWater", 250, 18);
				AddButton(BTN_ELEMENT + "_5", "GuiChooseElement_BtnChooseFire", 370, 18);
			}
			
			LoadRes("GuiChooseElement_5_Theme");
		}
		
		public function showGUI(_completeFunction:Function):void
		{
			completeFunction = _completeFunction;
			Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					
					break;
				default:
					if (buttonID.search(BTN_ELEMENT) >= 0)
					{
						if(completeFunction != null)
						{
							var element:int = buttonID.split("_")[1];
							completeFunction(element);
						}
						Hide();
					}
			}
		}
		
		override public function OnHideGUI():void 
		{
			completeFunction = null;
		}
		
	}

}