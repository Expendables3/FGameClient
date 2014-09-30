package GUI.GUIGemRefine.GemGUI 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.GUIGemRefine.GemLogic.GemMgr;
	import GUI.GUIGemRefine.GemLogic.UpgradingGem;
	import GUI.GUIGemRefine.GemPackage.SendCancelUpgrade;
	import GUI.GuiMgr;
	
	/**
	 * Confirm việc hủy luyện đan
	 * @author HiepNM2
	 */
	public class GUICancelUpgrade extends BaseGUI 
	{
		// const
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_SURE:String = "idBtnSure";
		private const ID_BTN_CONTINUE:String = "idBtnContinue";
		// logic
		private var _idSlot:int;
		public function set IdSlot(id:int):void
		{
			_idSlot = id;
		}
		// gui
		public function GUICancelUpgrade(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIConfirmCancelUpgrade";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				addBgr();
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
			}
			LoadRes("GuiHuyDanLuyen_Theme");
		}
		private function addBgr():void
		{
			/*add button*/
			AddButton(ID_BTN_CLOSE, "BtnThoat", 420, 17);
			AddButton(ID_BTN_SURE, "GuiHuyDanLuyen_Btn_ChacChan_TuLuyenNgoc", 112, 210);
			AddButton(ID_BTN_CONTINUE, "GuiHuyDanLuyen_Btn_TiepTucLuyen_TuLuyenNgoc", 255, 210);
			/*add label*/
			var fm:TextFormat = new TextFormat();
			fm.size = 18;
			fm.color = 0xCC0000;
			fm.align = TextFormatAlign.CENTER;
			
			var lb1:TextField = AddLabel(" Quá trình luyện đan chưa hoàn tất. ", 173, 85);
			lb1.setTextFormat(fm); 
			lb1.autoSize = TextFieldAutoSize.CENTER;
			
			fm.color = 0x274A6D;
			var lb2:TextField = AddLabel("Thời gian đã luyện sẽ không được" + "\n cộng dồn cho lần sau.\nBạn có chắc chắn hủy?", 173, 110, 0xFF0000);
			lb2.autoSize = TextFieldAutoSize.CENTER;
			lb2.setTextFormat(fm);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_SURE:
					cancelUpgrade();
				break;
				case ID_BTN_CONTINUE:
					Hide();
				break;
			}
		}
		private function cancelUpgrade():void
		{
			/*send dữ liệu lên server*/
			var pk:SendCancelUpgrade = new SendCancelUpgrade(_idSlot);
			Exchange.GetInstance().Send(pk);
			var uGem:UpgradingGem = GemMgr.getInstance().getUpgradingGemById(_idSlot);
			GemMgr.getInstance().transferUgradingGem(uGem);
			GuiMgr.getInstance().GuiGemRefine.refreshAllGem();
			Hide();
		}
	}

}