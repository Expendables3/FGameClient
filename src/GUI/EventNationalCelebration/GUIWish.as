package GUI.EventNationalCelebration 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.TooltipFormat;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIWish extends BaseGUI 
	{
		private const BTN_EXP:String = "BtnExp";
		private const BTN_ENERGY:String = "BtnEnergy";
		private const BTN_MATERIAL:String = "BtnMaterial";
		private const BTN_FISH:String = "BtnFish";
		
		public function GUIWish(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUI_Wish_ND");
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.text = "Món quà kinh nghiệm";
			AddButton(BTN_EXP, "Btn_Exp", 70, 240).setTooltip(tooltip);
			
			tooltip = new TooltipFormat();			
			tooltip.text = "Món quà ngư thạch";
			AddButton(BTN_MATERIAL, "Btn_Material", 160, 240).setTooltip(tooltip);
			
			tooltip = new TooltipFormat();
			tooltip.text = "Món quà năng lượng";
			AddButton(BTN_ENERGY, "Btn_Energy", 250, 240).setTooltip(tooltip);
			
			tooltip = new TooltipFormat();
			tooltip.htmlText = "Món quà cá\n <font color='#ff0000'>(cá đặc biệt, quí hoặc cá Spiderman, Sparta)</font>";
			AddButton(BTN_FISH, "Btn_Fish", 340, 240).setTooltip(tooltip);
			SetPos(180, 70);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var idWish:int = 0;
			switch(buttonID)
			{
				case BTN_EXP:
					idWish = 1;
					break;
				case BTN_MATERIAL:
					idWish = 2;
					break;
				case BTN_ENERGY:
					idWish = 3;
					break;
				case BTN_FISH:
					idWish = 4;
					break;
			}
			
			GameLogic.getInstance().callDragon(idWish);
			Hide();
			
			GameLogic.getInstance().showEffWish();
		}
		
		public function showGUI():void
		{
			Show(Constant.GUI_MIN_LAYER, 10);
		}
	}

}