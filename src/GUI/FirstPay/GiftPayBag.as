package GUI.FirstPay 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.MyUserInfo;
	
	/**
	 * Túi quà ở front screen
	 * @author HiepNM2
	 */
	public class GiftPayBag extends Container 
	{
		private const WATER_FACE:int = 168;
		private const ID_GIFT:String = "idGift";
		private var btnGift:ButtonEx;
		//private var specY:Number;
		static public var firstClick:Boolean = false;
		public function GiftPayBag(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "GiftPayBag";
		}
		
		public function init():void
		{
			btnGift = AddButtonEx(ID_GIFT, "BtnPayGift", 0, 0, this);
			btnGift.SetBlink(false);
		}
		/**
		 * cập nhật trạng thái của GiftPayBag
		 */
		override public function UpdateObject():void 
		{
			//if (CurPos.y <= WATER_FACE - 7)
			//{
				//specY = Math.random() * 0.3 + 0.2;
			//}
			//else if (CurPos.y >= WATER_FACE + 7)
			//{
				//specY = -(Math.random() * 0.3 + 0.2);
			//}
			//CurPos.y += specY;
			//SetPos(CurPos.x, CurPos.y);
			if (!firstClick)
			{
				var user:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
				var cfg:Object = ConfigJSON.getInstance().getItemInfo("FirstAddXuGift");
				
				var min:int = int.MAX_VALUE;
				for (var itm:String in cfg)
				{
					if (user.FirstAddXuGift && user.FirstAddXuGift[itm] == null)//có quà chưa nhận
					{
						if (int(itm) < min)
						{
							min = int(itm);
						}
					}
				}
				if (user.FirstAddXu >= min || user.FirstAddXu == 0)//có quà để nhận
				{
					btnGift.SetBlink(true);
				}
				firstClick = true;
			}
			//rung rung khi đến 1 mốc nào đó
			//btnGift.SetBlink(true);
			//nếu nhận hết quà => xóa hết
			//Destructor();
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_GIFT:
					if (GuiMgr.getInstance().GuiStore.IsVisible)
					{
						GuiMgr.getInstance().GuiStore.Hide();
					}
					GuiMgr.getInstance().guiPayGift.Show(Constant.GUI_MIN_LAYER, 5);
					btnGift.SetBlink(false);
					firstClick = true;
				break;
			}
		}
	}

}























