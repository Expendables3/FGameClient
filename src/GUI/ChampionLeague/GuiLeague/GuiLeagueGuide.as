package GUI.ChampionLeague.GuiLeague 
{
	import Data.ConfigJSON;
	import Data.ResMgr;
	import fl.containers.ScrollPane;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GUI.ChampionLeague.GuiLeague.itemGui.ItemTopGift;
	import GUI.ChampionLeague.LogicLeague.GuideXML;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ScrollBar;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiLeagueGuide extends BaseGUI 
	{
		private const ID_SCROLL_BAR:String = "idScrollBar";
		private const ID_BTN_CLOSE:String = "idBtnClose";
		[Embed(source = '../../../../content/dataloading.swf', symbol = 'DataLoading')]
		private var DataLoading:Class;
		private var WaitData:Sprite = new DataLoading();
		public var IsLoadXMLComp:Boolean = false;
		private var container:Container;
		private var tfTitle:TextField;
		private var tfDialog1:TextField;
		private var tfDialog2:TextField;
		private var tfDialog3:TextField;
		private var imgTableRank:Image;
		private var Scroll: ScrollPane = new ScrollPane();
		private var Content: Sprite = new Sprite();
		private var fmTitle:TextFormat;
		private var fmHeader:TextFormat;
		private var fmNormal:TextFormat;
		private var fmBold:TextFormat;
		private var fmRed:TextFormat;
		private var listTitle:Array = [];
		private var listHeader:Array = [];
		private var listNormal:Array = [];
		private var listItemGift:Array = [];
		
		
		public function GuiLeagueGuide(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiLeagueGuide";
			fmTitle = new TextFormat("Arial", 20);
			fmTitle.color = 0xff0000;
			fmHeader = new TextFormat("Arial", 16);
			fmHeader.bold = true;
			fmNormal = new TextFormat("Arial");
			fmNormal.bold = false;
			fmBold = new TextFormat("Arial");
			fmBold.bold = true;
			fmRed = new TextFormat("Arial" , 14);
			fmRed.bold = true;
			fmRed.color = 0xff0000;
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				onLoadSomeThing();
				AddButton(ID_BTN_CLOSE, "BtnThoat", 645, 17);
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 10;
				WaitData.y = img.height / 2 - 10;
				OpenRoomOut();
			}
			LoadRes("GuiLeagueGuide_Theme");
		}
		
		private function onLoadSomeThing():void 
		{
			var alreadyLoadXML:Boolean = LeagueMgr.getInstance().IsLoadGuideComp;
			if (!alreadyLoadXML)//nếu chưa load file xml
			{
				IsLoadXMLComp = false;
				LeagueMgr.getInstance().loadGuideXML(Main.verLocalization);//load file xml
			}
			else {
				IsLoadXMLComp = true;
			}
			
		}
		
		override public function EndingRoomOut():void 
		{
			if (IsLoadXMLComp)
			{
				initGUI();
			}
		}
		
		public function initGUI():void 
		{
			listNormal.splice(0, listNormal.length);
			listTitle.splice(0, listTitle.length);
			listHeader.splice(0, listHeader.length);
			listItemGift.splice(0, listItemGift.length);
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			initScroll();
			container = new Container(Content, "GuiLeagueGuide_KhungFriend", 60, 0);
			var i:int;
			//var speech:String="";
			//var fm:TextFormat = new TextFormat("Arial", 20);
			//fm.color = 0xff0000;
			var x:int = 15;
			var y:int = 0;
			var numCard:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["GiftToken"];
			/*
			//title
			var strTitle:String = GuideXML.getInstance().getSpeech("Title");
			tfTitle = container.AddLabel(strTitle, 15, 14, 0xff0000, 0);
			tfTitle.setTextFormat(fm);
			listTitle.push(tfTitle);
			y = tfTitle.y + tfTitle.height + 10;
			
			var tfHeader:TextField;
			var strHeader:String = "- " GuideXML.getInstance().getSpeech("Header1");
			tfHeader = container.AddLabel(strHeader, x, y);
			listHeader.push(tfHeader);
			y = tfHeader.y + tfHeader.height + 10;
			var id:String = "Paragraph1";
			//đoạn văn 1
			for (i = 1; i <= 3; i++)
			{
				speech += "o " + GuideXML.getInstance().getSpeech(id + "_" + i) + "\n";
			}
			var numCard:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["GiftToken"];
			speech = speech.replace("@Num", numCard);
			tfDialog1 = container.AddLabel(speech, x, y);
			tfDialog1.autoSize = TextFieldAutoSize.LEFT;
			tfDialog1.wordWrap = true;
			tfDialog1.width = 510;
			fm = new TextFormat("Arial");
			fm.size = 14;
			tfDialog1.setTextFormat(fm);
			y = tfDialog1.y + tfDialog1.height + 10;
			strHeader = 
			y = tfDialog1.y + tfDialog1.height + 290;
			
			imgTableRank = container.AddImage("idImgTableRank", "GuiLeagueGuide_TableRank", x+ 200, y,true,ALIGN_CENTER_CENTER,false,null);
			y = imgTableRank.img.y + imgTableRank.img.height + 20;
			//đoạn văn 2
			speech = "";
			for (i = 5; i <= 11; i++)
			{
				speech += "- " + GuideXML.getInstance().getSpeech(id + "_" + i) + "\n";
			}
			speech = speech.replace("@Num", numCard);
			tfDialog2 = container.AddLabel(speech, x, y);
			tfDialog2.autoSize = TextFieldAutoSize.LEFT;
			tfDialog2.wordWrap = true;
			tfDialog2.width = 510;
			tfDialog2.setTextFormat(fm);
			var fmRed:TextFormat = new TextFormat("Arial", 14);
			fmRed.color = 0xff0000;
			var iBegin:int = speech.search("Lưu ý");
			tfDialog2.setTextFormat(fmRed, iBegin, iBegin + 5);
			y = tfDialog2.y +  tfDialog2.height;
			//đoạn văn 3
			id = "Sentence3";
			speech = "";
			for (i = 1; i <= 8; i++)
			{
				speech += "+ " + GuideXML.getInstance().getSpeech(id + "_" + i) + "\n";
			}
			tfDialog3 = container.AddLabel(speech, x + 40, y);
			tfDialog3.autoSize = TextFieldAutoSize.LEFT;
			tfDialog3.wordWrap = true;
			tfDialog3.width = 510;
			tfDialog3.setTextFormat(fm);
			
			*/
			var strTitle:String;
			var tfTitle:TextField;
			var strHeader:String;
			var tfHeader:TextField;
			var tfPara:TextField;
			var paragraph:String = "";
			var imgTableRank:Image;
			var imgName:String;
			var itemGift:ItemTopGift;
			/*title*/
			strTitle = GuideXML.getInstance().getSpeech("Title");
			tfTitle = container.AddLabel(strTitle, x + 150, y, 0, 0);
			tfTitle.wordWrap = false;
			tfTitle.setTextFormat(fmTitle);
			listTitle.push(tfTitle);
			y = tfTitle.y + tfTitle.height + 10;
			/*header1*/
			strHeader = "* " + GuideXML.getInstance().getSpeech("Header1");
			tfHeader = container.AddLabel(strHeader, x, y, 0, 0);
			tfHeader.wordWrap = false;
			tfHeader.setTextFormat(fmHeader);
			listHeader.push(tfHeader);
			y = tfHeader.y + tfHeader.height + 10;
			/*paragraph1*/
			for (i = 1; i <= 3; i++)
			{
				paragraph += "- " + GuideXML.getInstance().getSpeech("Paragraph1" + "_" + i) + "\n";
			}
			paragraph = paragraph.replace("@Num", numCard);
			tfPara = container.AddLabel(paragraph, x + 20, y, 0, 0);
			tfPara.wordWrap = true;
			tfPara.width = 480;
			listNormal.push(tfPara);
			y = tfPara.y + tfPara.height + 10;
			/*header2*/
			strHeader = "* " + GuideXML.getInstance().getSpeech("Header2");
			tfHeader = container.AddLabel(strHeader, x, y, 0, 0);
			tfHeader.wordWrap = false;
			tfHeader.setTextFormat(fmHeader);
			listHeader.push(tfHeader);
			y = tfHeader.y + tfHeader.height + 10;
			/*paragraph2*/
			paragraph = "- " + GuideXML.getInstance().getSpeech("Paragraph2_1");
			tfPara = container.AddLabel(paragraph, x + 20, y, 0, 0);
			tfPara.wordWrap = true;
			tfPara.width = 480;
			listNormal.push(tfPara);
			y = tfPara.y + tfPara.height + 290;
			/*imgTableRank*/
			imgName = GuideXML.getInstance().getSpeech("Image2_1");
			imgTableRank = container.AddImage("", imgName, x + 180, y);
			y = imgTableRank.img.y + imgTableRank.img.height + 20;
			/*paragraph3*/
			paragraph = "";
			for (i = 2; i <= 8; i++)
			{
				paragraph+="- " + GuideXML.getInstance().getSpeech("Paragraph2" + "_" + i) + "\n";
			}
			paragraph = paragraph.replace("@Num", numCard);
			tfPara = container.AddLabel(paragraph, x + 20, y, 0, 0);
			tfPara.wordWrap = true;
			tfPara.width = 480;
			listNormal.push(tfPara);
			y = tfPara.y + tfPara.height + 10;
			/*header3*/
			strHeader = "* " + GuideXML.getInstance().getSpeech("Header3");
			tfHeader = container.AddLabel(strHeader, x, y, 0, 0);
			tfHeader.wordWrap = false;
			tfHeader.setTextFormat(fmHeader);
			listHeader.push(tfHeader);
			y = tfHeader.y + tfHeader.height + 10;
			/*paragraph4*/
			//paragraph = "";
			//for (i = 1; i <= 2; i++) 
			//{
				//paragraph += "- " + GuideXML.getInstance().getSpeech("Paragraph3_" + i) + "\n";
			//}
			paragraph = "- " + GuideXML.getInstance().getSpeech("Paragraph3_1");
			tfPara = container.AddLabel(paragraph, x + 20, y, 0, 0);
			tfPara.wordWrap = true;
			tfPara.width = 480;
			tfPara.setTextFormat(fmRed);
			listNormal.push(tfPara);
			y = tfPara.y + tfPara.height + 10;
			
			paragraph = "- " + GuideXML.getInstance().getSpeech("Paragraph3_2");
			tfPara = container.AddLabel(paragraph, x + 20, y, 0, 0);
			tfPara.wordWrap = true;
			tfPara.width = 480;
			listNormal.push(tfPara);
			
			
			y = tfPara.y + tfPara.height + 10;
			var top:Array = [1000, 300, 100, 50, 20, 10, 5, 1];
			for (i = 1; i <= 8; i++)
			{
				paragraph = "+ " + GuideXML.getInstance().getSpeech("Paragraph3_1_" + i);
				tfPara = container.AddLabel(paragraph, x + 50, y, 0, 0);
				tfPara.setTextFormat(fmBold);
				tfPara.wordWrap = true;
				tfPara.width = 480;
				listNormal.push(tfPara);
				y = tfPara.y + tfPara.height + 40;
				imgName = GuideXML.getInstance().getSpeech("Image3_" + i);
				itemGift = new ItemTopGift(container.img, "GuiLeague_CtnGift", x + 180, y);
				itemGift.EventHandler = this;
				itemGift.top = top[i - 1];
				itemGift.RockIndex = i + 5;
				y = itemGift.img.y + itemGift.img.height;
				listItemGift.push(itemGift);
			}
			/*paragraph5*/
			/*imgGift1000*/
			/*paragraph6*/
			/*imgGift300*/
			/*paragraph7*/
			/*imgGift100*/
			/*paragraph8*/
			/*imgGift50*/
			/*paragraph9*/
			/*imgGift20*/
			/*paragraph10*/
			/*imgGift10*/
			/*paragraph11*/
			/*imgGift5*/
			/*paragraph12*/
			/*imgGift1*/
			//setFormat();
			Scroll.source = Content;
		}
		
		private function setFormat():void 
		{
			var i:int;
			var tempTf:TextField;
			for (i = 0; i < listNormal.length; i++)
			{
				tempTf = listNormal[i] as TextField;
				tempTf.wordWrap = true;
				tempTf.setTextFormat(fmNormal);
			}
			for (i = 0; i < listTitle.length; i++)
			{
				tempTf = listTitle[i] as TextField;
				tempTf.wordWrap = true;
				tempTf.setTextFormat(fmTitle);
			}
			for (i = 0; i < listHeader.length; i++)
			{
				tempTf = listHeader[i] as TextField;
				tempTf.wordWrap = true;
				tempTf.setTextFormat(fmHeader);
			}
			
			
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID) {
				case ID_BTN_CLOSE:
					Hide();
				break;
			}
		}
		private function initScroll():void
		{
			var bg: Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff, 0);
			bg.graphics.drawRect(0, 0, 0, 0);
			bg.graphics.endFill();
			Scroll.setStyle("upSkin", bg);
			
			var up:Sprite = ResMgr.getInstance().GetRes("GuiLeagueGuide_ImgUpArrowNone") as Sprite;
			var over:Sprite = ResMgr.getInstance().GetRes("GuiLeagueGuide_ImgUpArrowOver") as Sprite;
			Scroll.setStyle("upArrowUpSkin", up);
			Scroll.setStyle("upArrowDownSkin", up);
			Scroll.setStyle("upArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiLeagueGuide_ImgDownArrowNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiLeagueGuide_ImgDownArrowOver") as Sprite;
			Scroll.setStyle("downArrowUpSkin", up);
			Scroll.setStyle("downArrowDownSkin", up);
			Scroll.setStyle("downArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiLeagueGuide_ImgTrackBarNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiLeagueGuide_ImgTrackBarOver") as Sprite;
			Scroll.setStyle("thumbUpSkin", up);
			Scroll.setStyle("thumbDownSkin", up);
			Scroll.setStyle("thumbOverSkin", over);
			Scroll.setStyle("thumbIcon", "");

			up = ResMgr.getInstance().GetRes("GuiLeagueGuide_BtnKhungKeo") as Sprite;
			Scroll.setStyle("trackUpSkin", up);
			Scroll.setStyle("trackDownSkin", up);
			Scroll.setStyle("trackOverSkin", up);
			
			Scroll.setSize(620, 300);
			Scroll.verticalScrollBar.setScrollPosition(0);
			
			img.addChild(Scroll);
			Scroll.x = -5;
			Scroll.y = 100;//100;
			Scroll.horizontalScrollBar.visible = false;
		}
		/**
		 * hủy gui
		 */
		override public function Destructor():void 
		{
			for (var i:int = 0; i < listItemGift.length; i++)
			{
				var itGift:ItemTopGift = listItemGift[i] as ItemTopGift;
				itGift.Destructor();
			}
			listItemGift.splice(0, listItemGift.length);
			super.Destructor();
		}
	}

}










