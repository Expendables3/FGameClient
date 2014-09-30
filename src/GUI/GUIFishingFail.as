package GUI 
{
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	/**
	 * ...
	 * @author Le Ba Dung
	 */
	public class GUIFishingFail extends BaseGUI
	{
		private const BUTTON_GUI_FISHING_FAIL_CLOSE:String = "ButtonClose";
		private const BUTTON_GUI_FISHING_FAIL_OK:String = "ButtonOk";
		
		public function GUIFishingFail(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFishingFail";
		}
		
		/**
		 * 
		 */
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				//AddImage("", "Paul", 172, 240);
				AddButton(BUTTON_GUI_FISHING_FAIL_CLOSE, "BtnThoat", 340, 53, this);
				//GetButton(BUTTON_GUI_FISHING_FAIL_CLOSE).img.scaleX = GetButton(BUTTON_GUI_FISHING_FAIL_CLOSE).img.scaleY = 0.6;
				var fmt:TextFormat = new TextFormat("Arial");
				fmt.size = 14;
				fmt.bold = true;
				fmt.color = 0x000000;
				//AddLabel("Rất tiếc...", 83, 2).setTextFormat(fmt);
				
				fmt.size = 16;
				fmt.bold = true;
				AddLabel("Ops! Bạn chả câu được gì!", 135, 150).setTextFormat(fmt);
				AddLabel("Hãy thử lại lần sau.", 135, 170).setTextFormat(fmt);

				fmt.size = 16;
				fmt.bold = true;
				fmt.color = 0x00000;
				var bt:Button = AddButton(BUTTON_GUI_FISHING_FAIL_OK, "GuiFishingFail_BtnGreen", 150, 298, this);
				bt.img.width = 80;
				bt.img.height = 35;
				AddLabel("Đóng", 138, 270).setTextFormat(fmt);	
				
				SetPos(210, 150);
			}
			LoadRes("GuiFishingFail_Theme");
		}
		
		/**
		 * Button click
		 * @param	event
		 * @param	buttonID
		 */
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{
				case BUTTON_GUI_FISHING_FAIL_CLOSE:
				case BUTTON_GUI_FISHING_FAIL_OK:
					Hide();				
					//GuiMgr.getInstance().GuiFishing.Show(Constant.GUI_MIN_LAYER + 1);
					//GuiMgr.getInstance().GuiFishing.Show();
				break;
			}
		}		
	}

}