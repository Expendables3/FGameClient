package GUI 
{
	import com.greensock.TweenMax;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Event.EventIceCream.GUIMainEventIceCream;
	import Event.EventMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.navigateToURL;
	import flash.net.SharedObject;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.Minigame.MinigameMgr;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author MinhT
	 */
	public class GUIAnnouncement extends BaseGUI 
	{
		public static const BETA_GIFT:String = "BetaGift";
		public static const BTN_CLOSE:String = "btnClose";
		public static const BTN_ACCEPT:String = "btnAccept";
		public static const BTN_NEWS:String = "btnNews";
		public static const BTN_NEWS_SHOP:String = "btnNewsShop";
		public static const SEPARATE:String = "_";
		
		// Event
		public static const BTN_EVENT:String = "btnEvent";
		public static const BTN_GOTO_DETAIL:String = "btnGotoDetail";
		
		public var iconNews:Image;
		public var iconNewsShop:Image;
		
		public static const BEGINNER:int = 1;
		public static const ADVANCE:int = 15;
		public static const EXPERT:int = 25;
		public static const GIFT_EACH_ROW:int = 3;
		
		public static const GIFT_TYPE_MONEY:String = "Money";
		public static const GIFT_TYPE_ZMONEY:String = "ZMoney";
		public static const GIFT_TYPE_MATERIAL:String = "Material";
		public static const GIFT_TYPE_ENERGY:String = "EnergyItem";
		public static const GIFT_TYPE_FISH:String = "BabyFish";		
		public static const GIFT_TYPE_OTHER:String = "Other";		
		
		public static const BONUS_GOLD_BY_LEVEL:int = 100;
		public static const BONUS_ZXU_BY_LEVEL:int = 1;
		public static var bShowGui:Boolean = false;
		
		//public var LINK_HELP_EVENT:String = "http://blog.zing.vn/jb/dt/fish_gsn/15032534?from=friend";	//LuckyMachine
		//public var LINK_HELP_EVENT:String = "http://blog.zing.vn/jb/dt/fish_gsn/15939582";	//FishHunter
		//public var LINK_HELP_EVENT:String = "http://blog.zing.vn/jb/dt/fish_gsn/9482179";	//StoneMaze
		//public var LINK_HELP_EVENT:String = "http://blog.zing.vn/jb/dt/fish_gsn/16460073";	//TreasureIsland
		public var LINK_HELP_EVENT:String = "http://blog.zing.vn/jb/dt/fish_gsn/16604587";	//Thạch bảo đồ
		public var curContent:String = "GuiAnnounce_Content";
		private const YDATE:int = 505 - 23;
		public function GUIAnnouncement(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIAnnouncement";
		}		
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(35, 30);
				AddImage("", "GuiAnnounce_BackGround", 373, 305);
				AddImage("", curContent, 23, 70, true, ALIGN_LEFT_TOP);	
				AddButton(BTN_CLOSE, "BtnThoat", 706, 20, this);
				var btnDetail:Button = AddButton(BTN_GOTO_DETAIL, "GuiAnnounce_BtnHint", 300, 530, this);
				
				var tfDay:TextField = AddLabel(Localization.getInstance().getString("GuiAnnounce_TipDay"), 360, YDATE, 0xFFFFFF, 1,-1);
				var txtFormat:TextFormat = new TextFormat("arial", 14);
				var event:Object = ConfigJSON.getInstance().GetItemList("Event");
				var curEvent:String = EventMgr.NAME_EVENT;
				var date:Date = new Date(event[curEvent]["BeginTime"]*1000);
				var startDate:String = date.getDate() + "/" + (date.getMonth() + 1);
				date = new Date(event[curEvent]["ExpireTime"]*1000);
				var endDate:String = date.getDate() + "/" + (date.getMonth() + 1);
				
				AddLabel(startDate, 390, YDATE, 0xFF0000, 1, 0xFFFFFF).setTextFormat(txtFormat);
				AddLabel(endDate, 500, YDATE, 0xFF0000, 1, 0xFFFFFF).setTextFormat(txtFormat);
				tfDay.setTextFormat(txtFormat);
				txtFormat = new TextFormat("Arial", 25, 0x000099, true);
				OpenRoomOut();
			}
			LoadRes("GuiAnnounce_Theme");
		}
		private function DrawTienCa():void
		{
			var imgTienCa:Image = AddImage("", "NPC_Mermaid_New", 180, 480,true,ALIGN_LEFT_TOP);
			imgTienCa.SetScaleXY(0.8);
		}
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE:
				{
					Hide();
					break;
				}
				case BTN_ACCEPT:
				{
					Hide();
					break;
				}
				
				case BTN_NEWS:
				{
					GetButton(BTN_NEWS).SetVisible(false);
					GetButton(BTN_NEWS_SHOP).SetVisible(true);
					iconNews.img.visible = true;
					iconNewsShop.img.visible = false;
					break;
				}
				
				case BTN_NEWS_SHOP:
				{
					GetButton(BTN_NEWS).SetVisible(true);
					GetButton(BTN_NEWS_SHOP).SetVisible(false);
					iconNews.img.visible = false;
					iconNewsShop.img.visible = true;
					break;
				}
				
				case BTN_EVENT:
				{
					break;
				}
				
				case BTN_GOTO_DETAIL:
				{
					// Event Thao Duoc
					var url:URLRequest = new URLRequest(LINK_HELP_EVENT);
					navigateToURL(url);
					Hide();
					break;
				}
			}
		}
		
		public function ShowAnnouce(isAccepted:Boolean = true):void
		{		
			bShowGui = true;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (EventMgr.CheckEvent(EventMgr.NAME_EVENT) == EventMgr.CURRENT_IN_EVENT)
			{
				curContent = "GuiAnnounce_Content";
				DrawEvent(isAccepted);
			}
		}
		
		private function DrawEvent(event:Object):void 
		{			
			super.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		private function DrawBetaGift(isAccepted:Boolean = true):void
		{
			super.Show(Constant.GUI_MIN_LAYER, 5);
			var i:int;
			var j:int;			
			
			// tọa độ bắt đầu vẽ
			var x:int = 175;
			var y:int = 156;
			var d:int = 84;		// khoảng cách giữa các ctn
			var posX:int;
			var posY:int;
			
			// Lấy quà từ config ra
			var gift:Object;
			var obj:Object = ConfigJSON.getInstance().GetItemList(BETA_GIFT);
			var arrGift:Array = [];
			var numMoney:int;
			var o:Object = new Object();
			for (var s:String in obj)
			{
				var sType:String = obj[s].ItemType;
				if (obj[s].ItemType == GIFT_TYPE_MONEY)
				{
					o = new Object();
					o.ItemType = GIFT_TYPE_MONEY;
					o.ItemId = "";
					o.Num = obj[s].Num + GameLogic.getInstance().user.BetaLevel * BONUS_GOLD_BY_LEVEL;
					arrGift.push(o);
				}				
				else
				{
					if (!isNaN(parseInt(s)))				
					{
						arrGift.push(obj[s]);
					}
				}
			}
			// add zxu vào cho các pé
			o = new Object();
			o.ItemType = GIFT_TYPE_ZMONEY;
			o.ItemId = "";
			o.Num = Math.min(GameLogic.getInstance().user.BetaLevel, 70);
			arrGift.push(o);
			
			// add cái thuyền cho nó khác biệt =.=
			o = new Object();
			o.ItemType = GIFT_TYPE_OTHER;
			o.ItemId = "1";
			o.Num = 1;
			arrGift.push(o);		
			
			// Hiển thị các món quà
			var beginOdd:int = arrGift.length - arrGift.length % GIFT_EACH_ROW;
			for (i = 1; i <= GIFT_EACH_ROW; i++)
			{
				for (j = GIFT_EACH_ROW*(i-1) + 1; j <= i * GIFT_EACH_ROW; j++)
				{
					if (j <= arrGift.length)
					{
						if (j == beginOdd + 1)
						{
							if(arrGift.length % GIFT_EACH_ROW == 2)
							{
								x += d / 2;
							}
							else if(arrGift.length % GIFT_EACH_ROW == 1)
							{
								x += d;
							}
						}
						gift = arrGift[j-1];
						posX = x + ((j+2) % GIFT_EACH_ROW) * d;
						posY = y + (i - 1) * d;						
						DrawGift(posX, posY, gift, gift.Num);
					}
				}
			}
			
			var btnAccept:Button = AddButton(BTN_ACCEPT, "GuiAnnounce_BtnGreen", 250, 428, this);
			btnAccept.SetEnable(false);
			btnAccept.img.width = 95;
			btnAccept.img.height = 48;
			var fm:TextFormat = new TextFormat();
			fm.size = 20;
			AddLabel("Nhận", 270, 388, 0xffffff, 0, 0x000000).setTextFormat(fm);
			if (!isAccepted)
			{
				GetButton(BTN_ACCEPT).SetEnable(true);
			}
		}
		
		private function DrawGift(x:int, y:int, gift:Object, num:int):void 
		{
			var ctn:Container;
			var lb:TextField;
			var imgName:String = GetImgName(gift.ItemType, gift.ItemId.toString());
			ctn = AddContainer("", "GuiAnnounce_CtnGift", x, y);
			
			switch(gift.ItemType)
			{
				case GIFT_TYPE_MONEY:
				case GIFT_TYPE_ZMONEY:
				{
					ctn.AddImage("", imgName, ctn.img.width / 2 - 5, ctn.img.height / 2 - 10).SetScaleXY(1.5);					
					break;
				}
				case GIFT_TYPE_ENERGY:
				{
					ctn.AddImage("", imgName, ctn.img.width / 2 - 5, ctn.img.height / 2 - 13).SetScaleXY(1.5);
					break;
				}
				case GIFT_TYPE_MATERIAL:
				{
					ctn.AddImage("", imgName, ctn.img.width / 2, ctn.img.height / 2 - 2, true, ALIGN_LEFT_TOP).SetScaleXY(1.2);
					break;
				}
				case GIFT_TYPE_OTHER:
				{
					ctn.AddImage("", imgName, ctn.img.width / 2 - 38, ctn.img.height / 2 - 20, true, ALIGN_LEFT_TOP).SetScaleXY(0.3);
					break;
				}
				case GIFT_TYPE_FISH:
				{
					var aboveContent:Sprite;
					if(gift.FishType != Fish.FISHTYPE_NORMAL)
					{
						aboveContent = ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
						aboveContent.scaleX = aboveContent.scaleY = 0.8
						ctn.AddImageBySprite(aboveContent, ctn.img.width / 2 - 10, ctn.img.height / 2 + 8);
					}
					var setInfo:Function = function():void
					{
						this.SetScaleX(Fish.SCALE_BABY);
						this.SetScaleY(Fish.SCALE_BABY);
						if(gift.FishType == Fish.FISHTYPE_RARE)
						{
							for(var s:String in gift.RateOption)
							{
								var cl:int = Fish.getAuraByOption(s);
								break;
							}
							TweenMax.to(this.img, 1, { glowFilter: { color:cl, alpha:1, blurX:30, blurY:30, strength:1.5 }} );
						}
					}
					var imgFish:Image = ctn.AddImage("", imgName, ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_LEFT_TOP, false, setInfo);					
					break;
				}
			}
			
			lb = ctn.AddLabel(Ultility.StandardNumber(num), -12, 53, 0xffffff, 1, 0x26709C);
			var fm:TextFormat = new TextFormat();
			fm.size = 18;
			lb.setTextFormat(fm);
		}
		
		private function GetImgName(type:String, id:String):String 
		{
			var name:String = "";
			switch(type)
			{
				case GIFT_TYPE_MONEY:
				{
					name = "IcGold";
					break;
				}
				case GIFT_TYPE_ZMONEY:
				{
					name = "IcZingXu";
					break;
				}
				case GIFT_TYPE_MATERIAL:
				{
					name = "Material"+id;
					break;
				}
				case GIFT_TYPE_ENERGY:
				{
					name = "EnergyItem" + id;
					break;
				}
				case GIFT_TYPE_FISH:
				{
					name = Fish.ItemType + id + SEPARATE + Fish.BABY + SEPARATE + Fish.HAPPY;
					break;
				}
				case GIFT_TYPE_OTHER:
				{
					name = "Ship" + id;
					break;
				}				
			}
			return name;
		}
		
		public function CheckCookie():void
		{
			if (GameLogic.getInstance().user.IsViewer()) return;
			var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var today:String = date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString();
			
			var so:SharedObject = SharedObject.getLocal("Annoucement" + GameLogic.getInstance().user.GetMyInfo().Id);
			if (so.data.lastDay != null)
			{
				var lastDay:String = so.data.lastDay;				
				if (lastDay != today)
				{
					so.data.lastDay = today;
					ShowAnnouce();
				}
			}
			else
			{
				so.data.lastDay = today;
				ShowAnnouce();
			}
			Ultility.FlushData(so);
		}
	}

}