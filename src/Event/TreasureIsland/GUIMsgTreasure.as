package Event.TreasureIsland 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIMsgTreasure extends BaseGUI 
	{
		public const BTN_CLOSE:String = "BtnThoat";
		public const BTN_DONG_Y:String = "BtnDongY";
		public function GUIMsgTreasure(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIMsgTreasure";
		}
		override public function InitGUI():void 
		{
			LoadRes("GUIMsgTreasure");
			SetPos(210, 150);
			OpenRoomOut();
		}
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			AddButton(BTN_CLOSE, "BtnThoat", 420, 15, this);
			var CloseButton:Button = AddButton(BTN_DONG_Y, "Btngreen", 215, 300, this);
			AddLabel("Đồng ý", 226, 277, 0xffffff, 0);	
			CloseButton.img.width = 75;
			CloseButton.img.height = 30;
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
				break;
				case BTN_DONG_Y:
					Hide();
					GuiMgr.getInstance().guiTreasureIsLand.sendAuto(GuiMgr.getInstance().guiAutoDigLand.idChoice);
				break;
			}
		}
	}

}