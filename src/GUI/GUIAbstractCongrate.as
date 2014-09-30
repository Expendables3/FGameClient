package GUI 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIAbstractCongrate extends BaseGUI 
	{
		protected const ID_BTN_RECEIVE:String = "idBtnReceive";
		protected const ID_BTN_FEED:String = "idBtnFeed";
		protected const ID_BTN_CLOSE:String = "idBtnClose";
		
		protected var btnFeed:Button;
		protected var btnReceive:Button;
		protected var btnClose:Button;
		
		protected var type:String;
		public function GUIAbstractCongrate(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIAbstractCongrate";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				btnClose = AddButton(ID_BTN_CLOSE, "BtnThoat", 374, 21);
				btnFeed = AddButton(ID_BTN_FEED, "BtnFeed", 146, 258);
				btnReceive = AddButton(ID_BTN_RECEIVE, "BtnNhanThuong", 130, 264);
				addTip();
				addGift();
				UpdateBtnState();
			}
			LoadRes("GuiCongratulation_Theme");
		}
		
		/**
		 * add vào quà
		 */
		protected virtual function addGift():void 
		{
			
		}
		
		/**
		 * add vào dòng thông báo phía trên
		 */
		protected virtual function addTip():void 
		{
			
		}
		
		
		private function UpdateBtnState():void 
		{
			if (type == "FEED")
			{
				btnFeed.SetVisible(true);
				btnReceive.SetVisible(false);
			}
			else if (type == "RECEIVE")
			{
				btnFeed.SetVisible(false);
				btnReceive.SetVisible(true);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_FEED:
					feed();
				break;
				case ID_BTN_RECEIVE:
					receive();
				break;
			}
		}
		
		protected virtual function receive():void 
		{
			
		}
		
		protected virtual function feed():void 
		{
			
		}
	}

}