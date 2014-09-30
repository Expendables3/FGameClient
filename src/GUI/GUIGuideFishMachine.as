package GUI 
{
	import com.bit101.components.Label;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIGuideFishMachine extends BaseGUI 
	{
		private const GUI_GUIDE_BTN_CLOSE:String = "btnClose";
		private var Scroll: ScrollPane = new ScrollPane();
		private var Content: Sprite = new Sprite();
		protected var _formatLine:TextFormat;
		protected var _formatTitle:TextFormat;
		private const BUFF_LINE:int = 10;
		private const BUFF_PARAGRAPH:int = 15;
		private const startX:int = 0;
		private const STARTY:int = 5;
		
		private var LineArr:Array = new Array();
		private var TitleArr:Array = new Array();
		public function GUIGuideFishMachine(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGuideFishMachine";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				_formatTitle = new TextFormat();
				_formatTitle.size = 18;
				_formatTitle.bold = true;
				_formatTitle.color = 0xA14F00;
				
				_formatLine = new TextFormat();
				_formatLine.size = 14;
				_formatLine.color = 0x000000;
				
				SetPos(Constant.STAGE_WIDTH / 2 - this.img.width / 2, Constant.STAGE_HEIGHT / 2 - this.img.height / 2);
				AddImage("", "GuiGuideFM_ImgHuongDan", 185, 35);
				AddButton(GUI_GUIDE_BTN_CLOSE, "BtnThoat", 540, 20);
				//add cac anh huong dan
				InitScroll();
				AddContent();
			}			
			LoadRes("GuiGuideFM_Theme");
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case GUI_GUIDE_BTN_CLOSE:
					Hide();
					break;
			}
		}
		
		private function AddContent():void
		{
			var container: Container = new Container(Content, "GuiGuideFM_KhungFriend", 0, 0);
			var i:int = 0;
			var str:String;
			var tf:TextField;
			var tfPre:TextField;
			//add Tieu de 1
			var tfTieude1:TextField = container.AddLabel("Cách sử dụng", 0, STARTY, 0, 0);
			TitleArr.push(tfTieude1);
			tfPre = tfTieude1;
			//add những dòng trước ảnh 1
			for (i = 1; i <= 3; i++)
			{
				str = Localization.getInstance().getString("GuideBeforeImg1FM" + i);
				tf = container.AddLabel(str, startX, tfPre.y + tfPre.height + 20,0,0);
				LineArr.push(tf);
				tfPre = tf;
			}
			//add ảnh 1
			var tfBuoc1:TextField = container.AddLabel("Bước 1: Chọn cá", 50, tfPre.y+tfPre.height+BUFF_PARAGRAPH*2, 0, 0);
			var tfBuoc2:TextField = container.AddLabel("Bước 2: Click Đổi", 300, tfPre.y+tfPre.height+BUFF_PARAGRAPH*2, 0, 0);
			var img1:Image = container.AddImage("", "GuiGuideFM_ImgGuide1", 10, tfPre.y+tfPre.height+BUFF_PARAGRAPH*4, true, ALIGN_LEFT_TOP);
			//add những dòng trước ảnh 2 sau anh 1
			str = Localization.getInstance().getString("GuideBeforeImg2FM1");
			tf = container.AddLabel(str, startX, img1.img.y + img1.img.height + BUFF_PARAGRAPH,0,0);
			LineArr.push(tf);
			tfPre = tf;
			//add ảnh 2
			var img2:Image = container.AddImage("", "GuiGuideFM_ImgGuide2", 10, tfPre.y + tfPre.height+BUFF_PARAGRAPH*2, true, ALIGN_LEFT_TOP);
			//add những dòng sau ảnh 2
			str = Localization.getInstance().getString("GuideAfterImg2FM1");
			tf = container.AddLabel(str, startX, img2.img.y + img2.img.height + BUFF_PARAGRAPH, 0, 0);
			LineArr.push(tf);
			tfPre = tf;
			//add Tieu de 2
			var tfTieude2:TextField = container.AddLabel("Công thức", 0, tfPre.y + tfPre.height + BUFF_PARAGRAPH*2, 0, 0);
			TitleArr.push(tfTieude2);
			tfPre = tfTieude2;
			//add nhung dong trong tieu de 2
			for (i = 1; i <= 3; i++)
			{
				str = Localization.getInstance().getString("GuideCongthucFM" + i);
				tf = container.AddLabel(str, startX, tfPre.y + tfPre.height + BUFF_LINE,0,0);
				LineArr.push(tf);
				tfPre = tf;
			}

			//set Format
			SetFormat();
			
			Scroll.source = Content;
		}
		/**
		 * Khởi tạo Scroll Bar
		 */
		private function InitScroll(): void
		{
			var bg: Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff, 0);
			bg.graphics.drawRect(0, 0, 490, 320);
			bg.graphics.endFill();
			Scroll.setStyle("upSkin", bg);
			
			var up:Sprite = ResMgr.getInstance().GetRes("GuiGuideFM_ImgUpArrowNone") as Sprite;
			var over: Sprite = ResMgr.getInstance().GetRes("GuiGuideFM_ImgUpArrowOver") as Sprite;
			Scroll.setStyle("upArrowUpSkin", up);
			Scroll.setStyle("upArrowDownSkin", up);
			//var color:ColorTransform = new ColorTransform(1.8, 1.8, 1.8);
			//over.transform.colorTransform = color;
			Scroll.setStyle("upArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiGuideFM_ImgDownArrowNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiGuideFM_ImgDownArrowOver") as Sprite;
			Scroll.setStyle("downArrowUpSkin", up);
			Scroll.setStyle("downArrowDownSkin", up);
			//over.transform.colorTransform = color;
			Scroll.setStyle("downArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiGuideFM_ImgTrackBarNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiGuideFM_ImgTrackBarOver") as Sprite;
			Scroll.setStyle("thumbUpSkin", up);
			Scroll.setStyle("thumbDownSkin", up);
			Scroll.setStyle("thumbOverSkin", over);
			Scroll.setStyle("thumbIcon", "");

			up = ResMgr.getInstance().GetRes("GuiGuideFM_BtnKhungKeo") as Sprite;
			Scroll.setStyle("trackUpSkin", up);
			Scroll.setStyle("trackDownSkin", up);
			Scroll.setStyle("trackOverSkin", up);
			
			Scroll.setSize(490, 320);
			Scroll.verticalScrollBar.setScrollPosition(0);
			
			img.addChild(Scroll);
			Scroll.x = 45;
			Scroll.y = 78;//100;
		}
		private function SetFormat():void
		{
			var i:int;
			for (i = 0; i < LineArr.length; i++)
			{
				(LineArr[i] as TextField).setTextFormat(_formatLine);
				(LineArr[i] as TextField).wordWrap = true;
				(LineArr[i] as TextField).width = 470;
				
			}
			for (i = 0; i < TitleArr.length; i++)
			{
				(TitleArr[i] as TextField).setTextFormat(_formatTitle);
			}
		}
	}

}




























