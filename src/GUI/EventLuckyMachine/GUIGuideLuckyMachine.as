package GUI.EventLuckyMachine 
{
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
	 * @author HiepNM
	 */
	public class GUIGuideLuckyMachine extends BaseGUI 
	{
		private const ID_BTN_CLOSE:String = "btnClose";
		private var Scroll: ScrollPane = new ScrollPane();
		private var Content: Sprite = new Sprite();
		protected var _formatLine:TextFormat;
		protected var _formatTitle:TextFormat;
		private var fmBold:TextFormat;
		
		private const BUFF_LINE:int = 10;
		private const BUFF_PARAGRAPH:int = 15;
		private const startX:int = 0;
		private const STARTY:int = 5;
		
		private var LineArr:Array = new Array();
		private var TitleArr:Array = new Array();
		
		public function GUIGuideLuckyMachine(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGuideLuckyMachine";
		};
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
				_formatLine.bold = false;
				
				fmBold = new TextFormat();
				fmBold.bold = true;
				fmBold.size = 14;
				
				SetPos(Constant.STAGE_WIDTH / 2 - this.img.width / 2, Constant.STAGE_HEIGHT / 2 - this.img.height / 2);
				AddImage("", "GuiGuideLuckyMachine_ImgHuongDan", 185, 35);
				AddButton(ID_BTN_CLOSE, "BtnThoat", 540, 20);
				//add cac anh huong dan
				initScroll();
				addContent();
			}
			
			LoadRes("GuiGuideLuckyMachine_Theme");
		};
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
				{
					Hide();
					Content = new Sprite();
				};
				break;
			};
		};
		private function addContent():void
		{
			var container: Container = new Container(Content, "GuiGuideLuckyMachine_KhungFriend", 0, 0);
			var i:int = 0;
			var str:String;
			var tf:TextField;
			var tfPre:TextField;
			//add Tieu de 1
			var tfTieude1:TextField = container.AddLabel("Quay Sò", 0, STARTY, 0, 0);
			TitleArr.push(tfTieude1);
			tfPre = tfTieude1;
			//add những dòng trước ảnh 1
			str = getString("GuideBeforeImg1LM");
			
			tf = container.AddLabel(str, startX, tfPre.y + tfPre.height + 10, 0, 0);
			tf.width = 470;
			tf.wordWrap = true;
			LineArr.push(tf);
			tfPre = tf;

			//add ảnh 1
			var img1:Image = container.AddImage("", "GuiGuideLuckyMachine_imgGuideLM1", 10, tfPre.y + tfPre.height + BUFF_PARAGRAPH * 2, true, ALIGN_LEFT_TOP);
			//add những dòng trước ảnh 2
			str = getString("GuideBeforeImg2LM");
			tf = container.AddLabel(str, startX, tfPre.y + tfPre.height + 10 + img1.img.height + 50, 0, 0);
			tf.width = 470;
			tf.wordWrap = true;
			LineArr.push(tf);
			tfPre = tf;
			//add ảnh 2
			var img2:Image = container.AddImage("", "GuiGuideLuckyMachine_imgGuideLM2", 10, tfPre.y + tfPre.height + BUFF_PARAGRAPH * 2, true, ALIGN_LEFT_TOP);
			
			//add Tiêu đề 2
			var tfTieude2:TextField = container.AddLabel("Phần thưởng", 0, img2.img.y + img2.img.height + 40, 0, 0);
			TitleArr.push(tfTieude2);
			tfPre = tfTieude2;
			
			str = getString("GuidePhanThuongLM");
			tf = container.AddLabel(str, startX, tfPre.y + tfPre.height + 10, 0, 0);
			tf.width = 470;
			tf.wordWrap = true;
			LineArr.push(tf);
			tfPre = tf;
			
			setFormat();
			Scroll.source = Content;
		};
		private function initScroll():void
		{
			var bg: Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff, 0);
			bg.graphics.drawRect(0, 0, 490, 320);
			bg.graphics.endFill();
			Scroll.setStyle("upSkin", bg);
			
			var up:Sprite = ResMgr.getInstance().GetRes("GuiGuideLuckyMachine_ImgUpArrowNone") as Sprite;
			var over: Sprite = ResMgr.getInstance().GetRes("GuiGuideLuckyMachine_ImgUpArrowOver") as Sprite;
			Scroll.setStyle("upArrowUpSkin", up);
			Scroll.setStyle("upArrowDownSkin", up);
			Scroll.setStyle("upArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiGuideLuckyMachine_ImgDownArrowNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiGuideLuckyMachine_ImgDownArrowOver") as Sprite;
			Scroll.setStyle("downArrowUpSkin", up);
			Scroll.setStyle("downArrowDownSkin", up);
			Scroll.setStyle("downArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiGuideLuckyMachine_ImgTrackBarNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiGuideLuckyMachine_ImgTrackBarOver") as Sprite;
			Scroll.setStyle("thumbUpSkin", up);
			Scroll.setStyle("thumbDownSkin", up);
			Scroll.setStyle("thumbOverSkin", over);
			Scroll.setStyle("thumbIcon", "");

			up = ResMgr.getInstance().GetRes("GuiGuideLuckyMachine_BtnKhungKeo") as Sprite;
			Scroll.setStyle("trackUpSkin", up);
			Scroll.setStyle("trackDownSkin", up);
			Scroll.setStyle("trackOverSkin", up);
			
			Scroll.setSize(490, 320);
			Scroll.verticalScrollBar.setScrollPosition(0);
			
			img.addChild(Scroll);
			Scroll.x = 45;
			Scroll.y = 78;//100;
		};
		
		private function setFormat():void
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
		};
		private function getString(id:String):String
		{
			var st:String = Localization.getInstance().getString(id);
			st.split("\\t").join("\t");
			return st;
		}
	};

};



































