package GUI.EventMidle8 
{
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIGiftGameMid8 extends BaseGUI 
	{
		public static const BTN_CLOSE:String = "BtnThoat";
		public static const BTN_FEED:String = "BtnFeed";
		public static const IMG_GIFT:String = "ImgGift";
		public var nameGift:String = "";
		public var numGift:int;
		public var isRare:Boolean = false;
		
		public function GUIGiftGameMid8(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIGiftGameMid8";
		}
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("GUIGiftGameMid8_ImgBgGUIGiftReceiveGameMid8");
			SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
			OpenRoomOut();
		}
		
		override public function EndingRoomOut():void 
		{
			var setInfo:Function = function():void
			{
				//Vẽ aura bằng glowFilter
				var cl:int = 0xff0000;
				TweenMax.to(this.img, 1, { glowFilter: { color:cl, alpha:1, blurX:37, blurY:37, strength:1.5 }} );								
			}
			super.EndingRoomOut();
			AddButton(BTN_CLOSE, "BtnThoat", img.width - 25, 45, this);
			AddButton(BTN_FEED, "GUIGameEventMidle8_BtnNhanThuong", img.width / 2, img.height - 90, this);
			if (isRare)	AddImage(IMG_GIFT, nameGift, 320, 205, true, ALIGN_CENTER_CENTER, false, setInfo);
			else 	AddImage(IMG_GIFT, nameGift, 320, 205);
			GetImage(IMG_GIFT).FitRect(60, 60, new Point(323, 212));
			
			var txtFormat:TextFormat = new TextFormat("Arial", 20, 0x601020);
			txtFormat.bold = true;
			txtFormat.color = 0xFFFF00;
			txtFormat.size = 20;
			var lbGift:TextField = AddLabel("x" + numGift, 360, 250, 0xCCCC33, 1, 0x26709C);
			lbGift.setTextFormat(txtFormat);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
				break;
				case BTN_FEED:
					Feed();
				break;
			}
		}
		public function Feed():void 
		{
			Hide();
		}
		override public function OnHideGUI():void 
		{
			super.OnHideGUI();
			if (GuiMgr.getInstance().GuiGameTrungThu.IsVisible)
			{
				GuiMgr.getInstance().GuiGameTrungThu.ShowBtnArrow();
			}
		}
		public function AddGift(Gift:Object):void 
		{
			for (var iStr:String in Gift) 
			{
				var bonus:Object = Gift[iStr];
				if (iStr == "NormalGift") 
				{
					if (bonus.ItemId != null) 
					{
						if (bonus.ItemType == "Material" && int(bonus.ItemId) >= 100)
						{
							nameGift = bonus.ItemType + (int(bonus.ItemId) % 100) + "S";
						}
						else
						{
							nameGift = bonus.ItemType + bonus.ItemId;
						}
					}
					else //Phan thuong la exp, money
					{   
						nameGift = bonus.ItemType;
					}
					numGift = bonus.Num;
					isRare = false;
				}
				else if (iStr == "SpecialGift") // Phan thuong la ca
				{
					GameLogic.getInstance().user.GenerateNextID();
					//if (bonus.Type && (bonus.Type == "Sparta" || bonus.Type == "Swat" || bonus.Type == "Swpiderman" 
						//|| bonus.Type == "Superman" || bonus.Type == "Ironman"|| bonus.Type == "Batman"))
					//{
						//nameGift = bonus.Type;
						//isRare = true;
					//}
					//else 
					//{
						//nameGift = "Fish" + bonus.FishTypeId + "_" + Fish.OLD + "_" + Fish.HAPPY;
						//if (bonus.FishType != Fish.FISHTYPE_NORMAL)	isRare = true;
						//else 	isRare = false;
					//}
					isRare = false;
					nameGift = bonus.Type + bonus.Rank + "_Shop";
					numGift = 1;
				}
			}
			if(Ultility.CheckDate(GuiMgr.getInstance().GuiGameTrungThu.CreateTime, GuiMgr.getInstance().GuiGameTrungThu.NUM_TIME_DELAY))
			{
				GuiMgr.getInstance().GuiGameTrungThu.AddMoreContent(Gift, numGift);
			}
		}
	}

}