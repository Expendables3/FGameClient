package GUI 
{
	import flash.events.MouseEvent;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class GUIPreviewBgr extends BaseGUI 
	{
		public static const BTN_CLOSE:String = "btnClose";
		
		public function GUIPreviewBgr(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIPreviewBgr";
		}
		
		
		public override function InitGUI() :void
		{
			LoadRes("ImgFrameFriend");				
			SetPos(340, 300);
			AddButton(BTN_CLOSE, "GuiShop_BtnCancelPreview", 0, 0, this);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE:
				{
					Hide();
					GameController.getInstance().changeBackGround(GameLogic.getInstance().user.backGround.ItemId);
					GameLogic.getInstance().BackToIdleGameState();	
					GuiMgr.getInstance().GuiShop.Show();
					
					// Hiện lại layer GUI - longpt
					//LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).visible = true;
					GuiMgr.getInstance().GuiMain.img.visible = true;
					GuiMgr.getInstance().GuiFriends.img.visible = true;
				}				
			}
		}
	}

}