package GUI.EventMidle8 
{
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIGiftGame8Fail extends BaseGUI 
	{
		public var numExp:int = 0;
		private const IMG_GIFT:String = "ImgGift";
		private const BTN_CLOSE:String = "BtnClose";
		public function GUIGiftGame8Fail(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGiftGame8Fail";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("GUIGiftFinalGameMidle8_ImgBgGUIGiftFail");
			SetPos((Constant.STAGE_WIDTH - img.width) / 2, (Constant.STAGE_HEIGHT - img.height) / 2);
			OpenRoomOut();
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			//if (GuiMgr.getInstance().GuiGameTrungThu.IsVisible)	GuiMgr.getInstance().GuiGameTrungThu.Hide();
			AddImage(IMG_GIFT, "Exp", 320, 205);
			GetImage(IMG_GIFT).FitRect(100, 100, new Point(231, 231));
			var format:TextFormat = new TextFormat();
			format.size = 18;
			format.bold = true;
			var tf:TextField = AddLabel("x" + Ultility.StandardNumber(numExp), 230, 310, 0x00CCFF, 1, 0x26709C);
			tf.setTextFormat(format);
			AddButton(BTN_CLOSE, "GUIGameEventMidle8_BtnNhanThuong", img.width / 2 - 70, img.height - 90, this);
			AddButton(BTN_CLOSE, "BtnThoat", img.width - 25, 25, this);
		}
		
		override public function OnHideGUI():void 
		{
			super.OnHideGUI();
			EffectMgr.getInstance().fallFlyEXPToNumStar(numExp, 20);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
				break;
			}
		}
	}

}