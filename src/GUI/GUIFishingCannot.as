package GUI 
{
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	/**
	 * ...
	 * @author Le Ba Dung
	 */
	public class GUIFishingCannot extends BaseGUI
	{
		private const BUTTON_GUI_FISHING_CANNOT_CLOSE:String = "ButtonClose";
		
		public function GUIFishingCannot(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFishingCannot";
		}
		
		/**
		 * 
		 */
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButton(BUTTON_GUI_FISHING_CANNOT_CLOSE, "BtnThoat", 340, 53, this);
				//AddImage("", "Paul", 172, 240);
				//GetButton(BUTTON_GUI_FISHING_CANNOT_CLOSE).img.scaleX = GetButton(BUTTON_GUI_FISHING_CANNOT_CLOSE).img.scaleY = 0.6;
				var fmt:TextFormat = new TextFormat("Arial");
				fmt.size = 16;
				fmt.bold = true;
				fmt.color = 0x000000;
				//AddLabel("Thông báo", 83, 2).setTextFormat(fmt);
				
				fmt.size = 16;
				fmt.bold = true;
				AddLabel(Localization.getInstance().getString("Message4"), 135, 160).setTextFormat(fmt);
				
				
				fmt.size = 16;
				fmt.bold = true;
				fmt.color = 0x00000;
				var bt:Button = AddButton(BUTTON_GUI_FISHING_CANNOT_CLOSE, "GuiFishingCannot_BtnGreen", 150, 298, this);
				bt.img.width = 80;
				bt.img.height = 35;
				AddLabel("Đóng", 138, 270).setTextFormat(fmt);	
				
				SetPos(210, 150);
			}
			LoadRes("GuiFishingCannot_Theme");
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
				case BUTTON_GUI_FISHING_CANNOT_CLOSE:
					Hide();				
				break;
			}
		}		
	}

}