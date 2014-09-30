package GUI.GUIGemRefine.unused 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author SieuSon
	 */
	public class GUIHuyDanLuyen extends BaseGUI 
	{
		private const BTN_CLOSE:String = "btnClose";
		private const BTN_SURE:String = "btnSure";
		private const BTN_CONTINUE:String = "btnContinue";
		
		private var indexSlot:int = -1;
		
		public function GUIHuyDanLuyen(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButtons();
				AddLabels();
				
				ShowDisableScreen(0.5);
				SetPos(200, 100);
			}
			
			LoadRes("GuiHuyDanLuyen_Theme");
		}
		
		public function ShowGui(index:int):void 
		{
			indexSlot = index;
			Show();
		}
		
		private function AddButtons():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 420, 17, this);
			AddButton(BTN_SURE, "GuiHuyDanLuyen_Btn_ChacChan_TuLuyenNgoc", 112, 210, this);
			AddButton(BTN_CONTINUE, "GuiHuyDanLuyen_Btn_TiepTucLuyen_TuLuyenNgoc", 255, 210, this);
			
		}
		
		private function AddLabels():void 
		{
			var s:String;
			var f:TextFormat = new TextFormat();
			f.size = 18;
			f.color = 0xCC0000;
			f.align=TextFormatAlign.CENTER;
			var lb1:TextField = AddLabel(" Quá trình luyện đan chưa hoàn tất. ", 173, 85);
			lb1.setTextFormat(f); 
			lb1.autoSize = TextFieldAutoSize.CENTER;
			f.color = 0x274A6D;
			s = "Thời gian đã luyện sẽ không được"+"\n cộng dồn cho lần sau.";
			s += "\n" + "Bạn có chắc chắn hủy?";
			
			var lb2:TextField = AddLabel(s, 173, 110, 0xFF0000);
		
			lb2.autoSize = TextFieldAutoSize.CENTER;
			lb2.setTextFormat(f);

			
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_CLOSE:
				case BTN_CONTINUE:
					Hide();
					HideDisableScreen();
					
				break;
				case BTN_SURE:
					GameLogic.getInstance().user.pearlMgr.SendCancelUpgradePearl(indexSlot);
					Hide();
					HideDisableScreen();

				break;
			}
		}
		
	}

}