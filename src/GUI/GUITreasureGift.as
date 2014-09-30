package GUI 
{
	import com.greensock.TweenMax;
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUITreasureGift extends BaseGUI
	{	
		private const GUI_TREASURE_GIFT_BTN_CLOSE:String = "close";
		private const GUI_TREASURE_GIFT_BTN_FEED:String = "feed";
		
		private const GUI_TREASURE_GIFT_CTN_GIFT:String = "CtnGift";
		private const GUI_TREASURE_GIFT_IMG_GIFT:String = "ImgGift";
		
		public var ItemName:String = "";
		public var ImageName:String = "";
		public var IconFeed:String = "";
		
		private var typeFeed:String;
		
		public var btnClose:Button;
		
		public function GUITreasureGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUITreasureGift";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				AddImage("", "GuiTreasureGift_ImgTxtPhanThuong", 200, 95);
				SetPos(220, 100);
				
				btnClose = AddButton(GUI_TREASURE_GIFT_BTN_CLOSE, "BtnThoat", 345, 23, this);
				//btnClose.img.scaleX = 0.8;
				//btnClose.img.scaleY = 0.8;
				
				var Format:TextFormat;
				
				var ButtonPos:Point = new Point(160, 260);
				var FeedButton:Button = AddButton(GUI_TREASURE_GIFT_BTN_FEED, "BtnFeed", ButtonPos.x - 10, ButtonPos.y, this);
				
				//var ShareText:TextField = AddLabel("Chia sẻ", ButtonPos.x -2 , ButtonPos.y - 43);
				//Format = new TextFormat("Arial", 17, 0xFFFFFF);
				//ShareText.setTextFormat(Format);
				//
				//FeedButton.img.scaleX = 1.8;
				//FeedButton.img.scaleY = 1.7;
			}
			LoadRes("GuiTreasureGift_Theme");
		}
		
		public function InitInfomation(type:String, name:String, num:int, iconName:String = "", feedType:String = "", domain:int = 0,imgDomain:String = ""):void 
		{	
			var title:TextField;
			//AddLabel("Chúc mừng bạn đã nhận được:", 160, 45);
			title = AddLabel(name, 150, 105, 0xffff00, 1, 0x000000);
			ItemName = name;
			
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.color = 0xFF3232;
			txtFormat.align = "center";
			txtFormat.bold = true;
			txtFormat.size = 18;
			title.setTextFormat(txtFormat);
			var objectType:String;
			var objectId:int = -1;
			var imageGift:Image;
			if (type.substr(0,4) == "Fish")
			{
				//kiểm tra domain
				//add vào cái glow cá quý
				
				if (domain > 0)
				{
					var img2Domain:Image;
					imageGift = AddImage(GUI_TREASURE_GIFT_IMG_GIFT, type, img.width / 2 + 100, img.height / 2 + 36);// true, ALIGN_CENTER_CENTER);
					imageGift.FitRect(70, 70);
					img2Domain = AddImage("imgDomain", imgDomain,  imageGift.img.x - 20, imageGift.img.y - 30);
					img2Domain.FitRect(30, 30,new Point(183,125));
				}
				else
				{
					imageGift = AddImage(GUI_TREASURE_GIFT_IMG_GIFT, type, /*container.*/img.width / 2 + 100, /*container.*/img.height / 2 + 36);// true, ALIGN_CENTER_CENTER);
				}
				var cl:int = 0xffff00;
				TweenMax.to(imageGift.img, 1, { glowFilter: { color:cl, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
				var sp:Sprite;
				sp = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				imageGift.img.addChild(sp);
				imageGift.FitRect(60, 60, new Point(160, 140));
			}
			else if (type == "Sparta" || type == "Swat" || type == "Spiderman" || type == "Batman")
			{
				imageGift = AddImage(GUI_TREASURE_GIFT_IMG_GIFT, type, /*container.*/img.width / 2 + 65, /*container.*/img.height / 2 + 54)// true, ALIGN_CENTER_CENTER);
				imageGift.FitRect(80, 80);
				switch(type)
				{
					case "Batman":
						feedType = "Batman";
						imageGift.SetPos(254 - 8,208 - 8);
						break;
					case "Sparta":
						feedType = "Sparta";
						imageGift.SetPos(254 - 4, 208);
						break;
					case "Swat":
						feedType = "Swat";
						imageGift.SetPos(254 - 4, 208 - 17);
						break;
					case "Spiderman":
						feedType = "Spiderman";
						imageGift.SetPos(254 - 18, 208 - 13);
						break;
				}
			}
			else if (type == "Material6S")
			{
				imageGift = AddImage(GUI_TREASURE_GIFT_IMG_GIFT, type, img.width / 2 + 27, img.height / 2 + 41);// true, ALIGN_CENTER_CENTER);
				objectType = "Material";
				objectId = 106;
			}
			else if (type == "Material7")
			{
				imageGift = AddImage(GUI_TREASURE_GIFT_IMG_GIFT, type, img.width / 2 + 27, img.height / 2 + 41);// true, ALIGN_CENTER_CENTER);
				objectType = "Material";
				objectId = 7;
			}
			else if(type == "EnergyItem6")
			{
				imageGift = AddImage(GUI_TREASURE_GIFT_IMG_GIFT, type, img.width / 2 + 5, img.height / 2 + 21);// true, ALIGN_CENTER_CENTER);
				objectType = "EnergyItem";
				objectId = 6;
			}
			else
			{
				imageGift = AddImage(GUI_TREASURE_GIFT_IMG_GIFT, type, img.width / 2 + 5, img.height / 2 + 21);// true, ALIGN_CENTER_CENTER);
			}
			
			if (objectId > 0)
			{
				var guiStore:GUIStore = GuiMgr.getInstance().GuiStore;
				if (guiStore.IsVisible == false) //ItemId = "", tức là ko được gì
				{
					guiStore.UpdateStore(objectType, objectId, num);
				}
			}
			//imageGift.SetPos(imageGift.CurPos.x - imageGift.img.width / 2, imageGift.CurPos.y - imageGift.img.height / 2);
			//imageGift.FitRect(width * 3 / 5, height * 3 / 5, new Point(width / 10, height / 10));
			
			var numGift:TextField;
			numGift = AddLabel("x" + num.toString(), 230, 160, 0xffff00, 1, 0x000000);
			var txtFormatNum:TextFormat = new TextFormat();
			txtFormatNum.size = 35;
			txtFormatNum.align = "center";
			numGift.setTextFormat(txtFormatNum);
			
			typeFeed = feedType;
			IconFeed = iconName;
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_TREASURE_GIFT_BTN_CLOSE:
					Hide();
				break;
				case GUI_TREASURE_GIFT_BTN_FEED:
				{
					switch(typeFeed)
					{
						case "RareFish":
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_GET_GIFT_RAREFISH);
							break;
						case "Batman":
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_GET_GIFT_XFISHBATMAN);
							break;
						case "Sparta":
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_GET_GIFT_XFISHSPARTA);
							break;
						case "Swat":
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_GET_GIFT_XFISHSWAT);
							break;
						case "Spiderman":
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_GET_GIFT_XFISHSPIDER);
							break;
						case "Material":
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_GET_GIFT_MATERIAL);
							break;
						case "EnergyItem":
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_GET_GIFT_ENERGYITEM);
							break;
						case "RebornMedicine":
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_GET_GIFT_REBORNMEDICINE);
							break;
					}
					//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_GET_GIFT_EVENTS);
					Hide();
				}
				break;
			}
		}
	}

}