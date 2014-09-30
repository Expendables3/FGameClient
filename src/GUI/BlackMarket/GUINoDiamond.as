package GUI.BlackMarket 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUINoDiamond extends BaseGUI 
	{
		static public const BTN_BUY:String = "btnBuy";
		static public const BTN_CANCEL:String = "btnCancel";
		static public const BTN_CLOSE:String = "btnClose";
		
		public function GUINoDiamond(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		public override function InitGUI(): void
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(BTN_BUY, "GuiNoDiamond_BtnBuyDiamond", 110, 190);
				AddButton(BTN_CANCEL, "GuiNoDiamond_BtnCancel", 235, 188);
				AddButton(BTN_CLOSE, "BtnThoat", 413, 18);
			}
			LoadRes("GuiNoDiamond");
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case BTN_BUY:
					GuiMgr.getInstance().guiBuyDiamond.Show(Constant.GUI_MIN_LAYER, 6);
					Hide();
					break;
				case BTN_CANCEL:
				case BTN_CLOSE:
					this.Hide();
					break;
			}
		}
	}

}