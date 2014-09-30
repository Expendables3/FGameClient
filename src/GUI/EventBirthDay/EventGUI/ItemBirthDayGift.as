package GUI.EventBirthDay.EventGUI 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemBirthDayGift extends Container 
	{
		static public const CMD_CHANGE:String = "cmdChange";
		static public const ID_IMG_GIFT:String = "idImgGift";
		public var IdRow:int;
		
		private var btnChange:Button;
		private var imgGift:ButtonEx;
		public var guiTooltipGift:TooltipBirthDayGift = new TooltipBirthDayGift(null, "");
		
		public function ItemBirthDayGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemBirthDayGift";
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_IMG_GIFT:
					guiTooltipGift.Show();
				break;
			}
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_IMG_GIFT:
					guiTooltipGift.Hide();
				break;
			}
		}
		
		public function DrawItem():void 
		{
			IdObject = "";
			//ảnh
			imgGift = AddButtonEx(ID_IMG_GIFT, "EventBirthday_Gift" + IdRow, 0, 0);
			//nút
			btnChange = AddButton(CMD_CHANGE + "_" + IdRow, "EventBirthday_BtnDoi", 2, 80, EventHandler);
			
			guiTooltipGift.init(ConfigJSON.getInstance().getItemInfo("BirthDayGiftBox", IdRow)["Output"], IdRow);
		}
		
		public function setEnableChange(isEnable:Boolean):void 
		{
			btnChange.SetEnable(isEnable);
		}
		
		override public function Destructor():void 
		{
			if (guiTooltipGift)
			{
				if (guiTooltipGift.img)
				{
					if (guiTooltipGift.img.visible)
					{
						guiTooltipGift.Hide();
					}
				}
				guiTooltipGift.Destructor();
				guiTooltipGift = null;
			}
			super.Destructor();
		}
	}

}


























