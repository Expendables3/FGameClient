package GUI.EventWarChampion 
{
	import Data.BitmapMovie;
	import Data.ConfigJSON;
	import Data.Localization;
	import Event.EventMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GUI.AvatarImage;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.EventWarChampion.SendGetRewardWarChampion;
	import NetworkPacket.PacketSend.EventWarChampion.SendLuckyTopUser;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIWarChampion extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_TAB_LUCKY:String = "btnTabLucky";
		static public const BTN_TAB_TOP_WEEK:String = "btnTabTopWeek";
		static public const BTN_TAB_TOP_MONTH:String = "btnTabTopMonth";
		static public const BTN_GET_GIFT:String = "btnGetGift";
		static public const BTN_TOP_GIFT_WEEK:String = "btnTopGiftWeek";
		static public const BTN_TOP_GIFT_MONTH:String = "btnTopGiftMonth";
		static public const MIN_NUM_WIN:int = 500;
		static public const MIN_POSITION:int = 100;
		static public const WEEK_GIFT:String = "weekGift";
		static public const MONTH_GIFT:String = "monthGift";
		static public const BTN_GUIDE:String = "btnGuide";
		private var btnTabLucky:Button;
		private var btnTabTopWeek:Button;
		private var btnTabTopMonth:Button;
		private var tabLuckyUser:Container;
		public var tabTopUserWeek:Container;
		public var tabTopUserMonth:Container;
		public var topWeek:int;
		public var topMonth:int;
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		private var waitingImage:Sprite;
		private var curWeek:int;
		private var idWeek:int;
		
		public function GUIWarChampion(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUI_Event_WarChampion");
			SetPos(25, 25);
			OpenRoomOut();
		}
		
		override public function EndingRoomOut():void 
		{
			waitingImage = new DataLoading();
			waitingImage.x = img.width / 2;
			waitingImage.y = img.height / 2;
			img.addChild(waitingImage);
			
			AddButton(BTN_CLOSE, "BtnThoat", 705, 20);	
			AddButton(BTN_GUIDE, "BtnGuide", 613 + 51, 21);
			AddImage("", "Tab_Lucky_User_Selected", 54,70, true, ALIGN_LEFT_TOP);
			btnTabLucky = AddButton(BTN_TAB_LUCKY, "Btn_Lucky_User", 54, 70);
			
			AddImage("", "Tab_Top_Week_Selected", 272, 70, true, ALIGN_LEFT_TOP);
			btnTabTopWeek = AddButton(BTN_TAB_TOP_WEEK, "Btn_Top_Week", 272, 70);
			
			AddImage("", "Tab_Top_Month_Selected", 272*2 - 54, 70, true, ALIGN_LEFT_TOP);
			btnTabTopMonth = AddButton(BTN_TAB_TOP_MONTH, "Btn_Top_Month", 272*2 - 54, 70);
			
			btnTabLucky.SetFocus(true);
			btnTabTopWeek.SetFocus(false);
			btnTabTopMonth.SetFocus(false);
			
			Exchange.GetInstance().Send(new SendLuckyTopUser(GameLogic.getInstance().user.GetMyInfo().Id));
		}
		
		public function updateInfo(data:Object):void
		{
			img.removeChild(waitingImage);
			
			//Tính tuần hiện tại
			var event:Object = ConfigJSON.getInstance().GetItemList("Event");
			var beginTime:Number; 
			var endTime:Number;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (event["InGameFishWar"] != null)
			{
				beginTime = event["InGameFishWar"].BeginTime;
				endTime = event["InGameFishWar"].ExpireTime;
			}
			
			var timeRunEvent:Number = curTime - beginTime;
			curWeek = Math.ceil(timeRunEvent / (7 * 24 * 3600));
			//trace(" Tuan hien tai", curWeek);
			var realWeek:int = curWeek;
			if (curWeek > 4)
			{
				curWeek = 4;
			}
			
			//Tab user may mắn
			var txtFormat:TextFormat = new TextFormat("arial", 15, 0xffffff, true);
			tabLuckyUser = new Container(img, "Page_Lucky_User", 73, 107);
			var i:int;
			var arrSoldier:Array = GameLogic.getInstance().user.GetFishSoldierArr();
			var checkMe:Boolean = false;
			for (i = 0; i < 3; i++)
			{
				var itemLucky:ItemLuckyUser = new ItemLuckyUser(tabLuckyUser.img);
				if(data["LuckyUser"] != null && data["LuckyUser"] != "" && (data["LuckyUser"] != false) && data["LuckyUser"][i] != null)
				{
					itemLucky.init(data["LuckyUser"][i]);
				}
				else
				{
					itemLucky.init(null);
				}
				itemLucky.SetPos(i * 207 + 146, 30 + 138);
				if (data["LuckyUser"] != null && data["LuckyUser"] != "" && data["LuckyUser"][i] != null && data["LuckyUser"][i]["uId"] == GameLogic.getInstance().user.GetMyInfo().Id && !data["LuckyUser"][i]["GotGift"])
				{
					checkMe = true;
				}
			}
			tabLuckyUser.AddButton(BTN_GET_GIFT, "Btn_Get_Gift", 227, 449, this);
			tabLuckyUser.GetButton(BTN_GET_GIFT).SetEnable(checkMe);
			
			//Phần thưởng
			var config:Object = ConfigJSON.getInstance().getItemInfo("EventInGameFW_Random", -1);
			for (var s:String in config)
			{
				var imgName:String;
				if (config[s]["ItemType"] == "Gem")
				{
					imgName = "Gem_" + config[s]["Element"] + "_" + config[s]["ItemId"];
				}
				else
				{
					imgName = config[s]["ItemType"] + config[s]["ItemId"];
				}
				var imageGift:Image = tabLuckyUser.AddImage("", imgName, 230 + (int(s) -1)*65, 400);
				imageGift.FitRect(60, 60);
				tabLuckyUser.AddLabel("x" + config[s]["Num"], 200 + (int(s) -1) * 65, 415, 0xffffff, 0, 0x000000).setTextFormat(txtFormat);
			}
			
			
			
			//Tab top User week
			tabTopUserWeek = new Container(img, "Page_Top_Week", 41, 105);
			var txtNote:TextField = tabTopUserWeek.AddLabel("Lưu ý: Chờ đến tuần sau để nhận giải của tuần này", 355, 400, 0xff0000, 0, 0xffffff);
			var txtAchievementWeek:TextField = tabTopUserWeek.AddLabel("", 105 + 40, 3, 0x1c688e, 0);
			txtAchievementWeek.autoSize = TextFieldAutoSize.CENTER;
			txtFormat.align = "left";
			txtAchievementWeek.setTextFormat(txtFormat);
			if (data["Week"] == null || data["Week"][curWeek] == null || data["Week"][curWeek]["Position"] == 0)
			{
				txtAchievementWeek.htmlText = "<font color = '#1c688e'>Thành tích tuần này của bạn xếp hạng quá thứ: </font><font color='#ff0000'>500</font>";
			}
			else
			{
				txtAchievementWeek.htmlText = "<font color = '#1c688e'>Thành tích tuần này của bạn nằm trong top: </font><font color='#ff0000'>" +data["Week"][curWeek]["Position"] + "</font>";
			}
			var txtNumWar:TextField = tabTopUserWeek.AddLabel("", 105 + 23 - 80, 26, 0x1c6883, 0);
			txtNumWar.setTextFormat(txtFormat);
			
			if(data["Week"] != null && data["Week"][curWeek] != null && data["Week"][curWeek]["Win"] != null)
			{
				txtNumWar.htmlText = "<font color = '#1c688e'>Số trận thắng của bạn trong tuần này là: </font><font color='#ff0000'>" + data["Week"][curWeek]["Win"] + "</font>";
			}
			else
			{
				txtNumWar.htmlText = "<font color = '#1c688e'>Số trận thắng của bạn trong tuần này là: </font><font color='#ff0000'>" +0 + "</font>";
			}
			
			var txtWeek:TextField = tabTopUserWeek.AddLabel("", 459, 0, 0xffff00);
			txtWeek.autoSize = TextFieldAutoSize.CENTER;
			txtWeek.setTextFormat(txtFormat);
			var weekTime:String;
			var date:Date = new Date((beginTime + (curWeek - 1)*7*24*3600)*1000);
			weekTime = date.getDate() + "/ " + (date.getMonth() + 1) + "/ " + date.getFullYear();
			date = new Date((beginTime + curWeek * 7 * 24*3600)*1000);
			weekTime += " - " + date.getDate() + "/ " + (date.getMonth() + 1) + "/ " + date.getFullYear();
			txtWeek.htmlText = "<font color = '#ff0000' size='28'>Tuần " + curWeek + "    </font><font color = '#0000ff' size = '13'>" + weekTime + "</font>";
			
			//var avatar:Image;
			var avatar:AvatarImage;
			var avatarLink:String;
			var name:String;
			for (i = 0; i < 3; i++)
			{
				if (data["Week"] != null && data["Week"][curWeek] != null && data["Week"][curWeek]["Top"][i] != null)
				{
					avatarLink = data["Week"][curWeek]["Top"][i]["AvatarLink"];
					if (avatarLink == null || avatarLink == "")
					{
						avatarLink = Main.staticURL + "/avatar.png";
					}
					name = data["Week"][curWeek]["Top"][i]["Name"];
				}
				else
				{
					avatarLink = Main.staticURL + "/avatar.png";
					name = "Chưa có";
				}
				
				//avatar = tabTopUserWeek.AddImage("", avatarLink, 485, 179 + i * 96, false);
				//avatar.FitRect(60, 60, new Point(485-90, 179 + i * 96-90));
				avatar = new AvatarImage(tabTopUserWeek.img);
				avatar.initAvatar(avatarLink, loadAvatarComplete);
				function loadAvatarComplete():void
				{
					this.FitRect(60, 60, new Point(485 - 90, 179 + i * 96 - 90));
				}
				//avatar.SetPos(485 - 90, 179 + i * 96 - 90);
				
				tabTopUserWeek.AddLabel(Ultility.StandardString(name, 10), 486 - 90, i * 96 + 269 - 116, 0x1c688e, 0);
			}
			
			for (i = 3; i < 10; i++)
			{
				if (data["Week"] != null && data["Week"][curWeek] != null && data["Week"][curWeek]["Top"][i])
				{
					name = data["Week"][curWeek]["Top"][i]["Name"];
				}
				else
				{
					name = "Chưa có";
				}
				
				tabTopUserWeek.AddLabel(Ultility.StandardString(name, 10), 150 + 360, (i-3) * 34 + 104, 0x1c688e, 0);
			}
			
			var eventProfile:Object = GameLogic.getInstance().user.GetMyInfo().outGameFW;			
			//Phần thưởng tuần
			var tooltip:TooltipFormat;
			for (i = 0; i < 5; i++)
			{
				var giftWeek:Container = tabTopUserWeek.AddContainer(WEEK_GIFT + "_" + (i+1), "LiXi_" + (i + 1), 308 - 45, 133 - 45 + i * 70, true, this);
				if (i == 3)
				{
					giftWeek.img.y += 5;
				}
				if (i == 4)
				{
					giftWeek.img.y += 15;
				}
				giftWeek.GoToAndStop(0);
				giftWeek.FitRect(52, 52);
				//tooltip = new TooltipFormat();
				//tooltip.text = Localization.getInstance().getString("RewardWeek" + (i + 1));
				//giftWeek.setTooltip(tooltip);
			}
			var btnTopGiftWeek:Button = tabTopUserWeek.AddButton(BTN_TOP_GIFT_WEEK, "Btn_Get_Gift", 227 + 216, 442, this);
			
			//Check có đc quà tuần ko
			checkMe = false;
			if (data["Week"] != null)
			{
				for (s in data["Week"])
				{
					for (i = 0; i < 10; i++)
					{
						if (data["Week"][s]["Top"][i] != null && data["Week"][s]["Top"][i]["uId"] == GameLogic.getInstance().user.GetMyInfo().Id)
						{
							checkMe = true;
							idWeek = int(s);
							topWeek = i +1;
							//break;
						}
					}
					//if (checkMe)
					//{
						//break;
					//}
				}
			}
			
			//trace("tuan co thuong", idWeek);
			//Kiem tra giai ghi danh			
			var coGiaiGhiDanh:Boolean = false;
			var idWeekGhiDanh:int = -1;
			//if (!checkMe)
			{
				if (data["Week"] != null)
				{
					for (s in data["Week"])
					{
						if (data["Week"][s]["Win"] != null && data["Week"][s]["Win"] >= MIN_NUM_WIN 
								&& (eventProfile == null || eventProfile["Reward"] == null || eventProfile["Reward"][s] == null ||eventProfile["Reward"][s] == false))// && Number(data["Week"][s]["Win"]) / data["Week"][s]["Total"] > 0.5)
						{
							coGiaiGhiDanh = true;
							//topWeek = 100;
							idWeekGhiDanh = int(s);
							break;
						}
					}
				}
			}
			//Kiểm tra thời gian hết tuần chưa
			if ((curTime - beginTime - 6*3600) < idWeek*7*24*3600)
			{
				checkMe = false;				
			}
			if ((curTime - beginTime - 6*3600) < idWeekGhiDanh*7*24*3600)
			{
				coGiaiGhiDanh = false;
			}
			
			//Kiểm tra đã nhận quà tuần chưa			
			if (eventProfile != null && eventProfile["Reward"] != null)
			{
				for (s in  eventProfile["Reward"])
				{
					if (eventProfile["Reward"][s])
					{
						if (int(s) == idWeek)
						{
							checkMe = false;
						}
						if(int(s) == idWeekGhiDanh)
						{
							coGiaiGhiDanh = false;
						}
					}					
				}
			}
			//if (realWeek > 4)
			//{
				//checkMe = false;
			//}
			if (checkMe)
			{
				txtNote.text = "Bạn đạt giải thưởng top " + topWeek + " tuần " + idWeek;
			}
			else if(coGiaiGhiDanh)
			{				
				txtNote.text = "Bạn đạt giải thưởng top 100 tuần " + idWeekGhiDanh;
				idWeek = idWeekGhiDanh;			
				topWeek = 100;
			}	
			
			btnTopGiftWeek.SetEnable(checkMe || coGiaiGhiDanh);			
			tabTopUserWeek.SetVisible(false);
			
			//Tap top user month
			tabTopUserMonth = new Container(img, "Page_Top_Month", 41, 105);
			
			var txtAchievementMonth:TextField = tabTopUserMonth.AddLabel("", 105 + 22, 3, 0x1c688e, 0);
			txtAchievementMonth.autoSize = TextFieldAutoSize.CENTER;
			txtFormat.align = "left";
			txtAchievementMonth.setTextFormat(txtFormat);
			if (data["Month"] == null && data["Month"] == null || data["Month"]["Position"] == 0)
			{
				txtAchievementMonth.htmlText = "<font color = '#1c688e'>Thành tích bạn xếp hạng quá thứ: </font><font color='#ff0000'>500</font>";
			}
			else
			{
				txtAchievementMonth.htmlText = "<font color = '#1c688e'>Thành tích tháng của bạn nằm trong top: </font><font color='#ff0000'>" +data["Month"]["Position"] + "</font>";
			}
			var txtNumWarMonth:TextField = tabTopUserMonth.AddLabel("", 105 + 23 - 80, 26, 0x1c6883, 0);
			txtNumWarMonth.setTextFormat(txtFormat);
			
			var numWinMonth:int = 0;
			if (data["Week"] != null)
			{
				for (s in data["Week"])
				{
					if (data["Week"][s]["Win"] != null)
					{
						numWinMonth += data["Week"][s]["Win"];
					}
				}
			}
			
			txtNumWarMonth.htmlText = "<font color = '#1c688e'>Số trận thắng của bạn trong tháng này là: </font><font color='#ff0000'>" +numWinMonth + "</font>";
			
			var txtMonth:TextField = tabTopUserMonth.AddLabel("", 459, 0, 0xffff00);
			txtMonth.autoSize = TextFieldAutoSize.CENTER;
			txtMonth.setTextFormat(txtFormat);
			
			date = new Date((beginTime) * 1000);
			var monthTime:String;
			monthTime = date.getDate() + "/ " + (date.getMonth() + 1) + "/ " + date.getFullYear();
			date = new Date((endTime)*1000);
			monthTime += " - " + date.getDate() + "/ " + (date.getMonth() + 1) + "/ " + date.getFullYear();
			
			txtMonth.htmlText = "<font color = '#ff0000' size='28'>Tháng   </font><font color = '#0000ff' size = '13'>" + monthTime + "</font>";
			
			checkMe = false;
			for (i = 0; i < 3; i++)
			{
				if (data["Month"] != null && data["Month"]["Top"][i] != null)
				{
					avatarLink = data["Month"]["Top"][i]["AvatarLink"];
					if (avatarLink == null || avatarLink == "")
					{
						avatarLink = Main.staticURL + "/avatar.png";
					}
					name = data["Month"]["Top"][i]["Name"];
					
					if (data["Month"]["Top"][i]["uId"] == GameLogic.getInstance().user.GetMyInfo().Id)
					{
						checkMe = true;
						topMonth = i + 1;
					}
				}
				else
				{
					avatarLink = Main.staticURL + "/avatar.png";
					name = "Chưa có";
				}
				
				//avatar = tabTopUserMonth.AddImage("", avatarLink, 485, 179 + i * 96, false);
				//avatar.FitRect(60, 60, new Point(485-90, 179 + i * 96-90));
				avatar = new AvatarImage(tabTopUserMonth.img);
				avatar.initAvatar(avatarLink, loadAvatarComplete);
				//avatar.FitRect(60, 60, new Point(0, 0));
				//avatar.SetPos(485 - 90, 179 + i * 96 - 90);
				tabTopUserMonth.AddLabel(Ultility.StandardString(name, 10), 486 - 90, i * 96 + 269 - 116, 0x1c688e, 0);
			}
			
			for (i = 3; i < 10; i++)
			{
				if (data["Month"] != null && data["Month"]["Top"][i] != null)
				{
					name = data["Month"]["Top"][i]["Name"];
					
					if (data["Month"]["Top"][i]["Id"] == GameLogic.getInstance().user.GetMyInfo().Id)
					{
						checkMe = true;
						topMonth = i + 1;
					}
				}
				else
				{
					name = "Chưa có";
				}
				tabTopUserMonth.AddLabel(Ultility.StandardString(name, 10), 150 + 360, (i-3) * 34 + 104, 0x1c688e, 0);
			}
			
			if (!checkMe && data["Month"]["Position"] > 0 && data["Month"]["Position"] <= MIN_POSITION)
			{
				checkMe = true;
				topMonth = data["Month"]["Position"];
			}
			//Phần thưởng thang
			for (i = 0; i < 4; i++)
			{
				var giftMonth:Container = tabTopUserMonth.AddContainer(MONTH_GIFT + "_" + (i+1), "LiXi_" + (i + 1), 308 - 45, 133 - 45 + i * 70, true, this);
				if (i == 3)
				{
					giftMonth.img.y += 5;
				}
				giftMonth.GoToAndStop(0);
				giftMonth.FitRect(52, 52);
				//tooltip = new TooltipFormat();
				//tooltip.text = Localization.getInstance().getString("RewardMonth" + (i + 1));
				//giftMonth.setTooltip(tooltip);
				
			}
			var btnTopGiftMonth:Button = tabTopUserMonth.AddButton(BTN_TOP_GIFT_MONTH, "Btn_Get_Gift", 227 + 216, 442, this);
			//Check nhan thuong thang chu
			if (eventProfile != null && eventProfile["Reward"] != null)
			{
				if (eventProfile["Reward"]["Month"] == true)
				{
					checkMe = false;
				}
			}
			if (EventMgr.CheckEvent("InGameFishWar") != EventMgr.CURRENT_AFTER_EVENT)
			{
				checkMe = false;
			}
			if (!checkMe)
			{
				var tooltipFormat:TooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Phần thưởng tháng sẽ \nđược nhận sau khi hết Event";
				btnTopGiftMonth.setTooltip(tooltipFormat);
			}
			btnTopGiftMonth.SetEnable(checkMe);
			//btnTopGiftMonth.SetEnable(true);
			tabTopUserMonth.SetVisible(false);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_TAB_LUCKY:
					btnTabLucky.SetFocus(true);
					btnTabTopWeek.SetFocus(false);
					btnTabTopMonth.SetFocus(false);
					tabLuckyUser.SetVisible(true);
					tabTopUserWeek.SetVisible(false);
					tabTopUserMonth.SetVisible(false);
					break;
				case BTN_TAB_TOP_WEEK:
					btnTabLucky.SetFocus(false);
					btnTabTopWeek.SetFocus(true);
					btnTabTopMonth.SetFocus(false);
					tabLuckyUser.SetVisible(false);
					tabTopUserWeek.SetVisible(true);
					tabTopUserMonth.SetVisible(false);
					break;
				case BTN_TAB_TOP_MONTH:
					btnTabLucky.SetFocus(false);
					btnTabTopWeek.SetFocus(false);
					btnTabTopMonth.SetFocus(true);
					tabLuckyUser.SetVisible(false);
					tabTopUserMonth.SetVisible(true);
					tabTopUserWeek.SetVisible(false);
					break;
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_TOP_GIFT_WEEK:
					if(topWeek < 100)
					{
						GuiMgr.getInstance().guiChooseElement.showGUI(2, idWeek);
					}
					//Giai ghi danh
					else
					{
						tabTopUserWeek.GetButton(BTN_TOP_GIFT_WEEK).SetEnable(false);
						var outGameFW:Object = GameLogic.getInstance().user.GetMyInfo().outGameFW;
						if (outGameFW == null)
						{
							GameLogic.getInstance().user.GetMyInfo().outGameFW = new Object();
							GameLogic.getInstance().user.GetMyInfo().outGameFW["Reward"] = new Object();
							
						}
						else if(outGameFW["Reward"] == null)
						{
							GameLogic.getInstance().user.GetMyInfo().outGameFW["Reward"] = new Object();
						}
						GameLogic.getInstance().user.GetMyInfo().outGameFW["Reward"][idWeek] = true;
						Exchange.GetInstance().Send(new SendGetRewardWarChampion(2, idWeek, 0));
						GameLogic.getInstance().user.GenerateNextID();
						GuiMgr.getInstance().guiCongratulation.showReward("LiXi_5", 1, "Phần thưởng top 100 tuần");
					}
					break;
				case BTN_TOP_GIFT_MONTH:
					GuiMgr.getInstance().guiChooseElement.showGUI(3, 0);
					break;
				case BTN_GET_GIFT:
					tabLuckyUser.GetButton(BTN_GET_GIFT).SetEnable(false);
					var config:Object = ConfigJSON.getInstance().getItemInfo("EventInGameFW_Random", -1);
					for (var s:String in config)
					{
						if (config[s]["ItemType"] == "Gem")
						{
							GuiMgr.getInstance().GuiStore.UpdateStore(config[s]["ItemType"] + "$" + config[s]["Element"] + "$" + config[s]["ItemId"], config[s]["Day"], config[s]["Num"]);
						}
						else
						{
							GuiMgr.getInstance().GuiStore.UpdateStore(config[s]["ItemType"], config[s]["ItemId"], config[s]["Num"]);
						}
					}
					Exchange.GetInstance().Send(new SendGetRewardWarChampion(1, 0, 0));
					GuiMgr.getInstance().guiCongratulation.showReward("LiXi_5", 1, "Phần thưởng may mắn");
					break;
				case BTN_GUIDE:
					GuiMgr.getInstance().GuiHelp.Show(Constant.GUI_MIN_LAYER, 6);
					break;
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var arr:Array;
			if (buttonID.search(WEEK_GIFT) >= 0)
			{
				arr = buttonID.split("_");
				GuiMgr.getInstance().guiTooltipTopUser.showGUI("TooltipWeek_" + arr[1], event.stageX, event.stageY);
			}
			
			if (buttonID.search(MONTH_GIFT) >= 0)
			{
				arr = buttonID.split("_");
				GuiMgr.getInstance().guiTooltipTopUser.showGUI("TooltipMonth_" + arr[1], event.stageX, event.stageY);
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(WEEK_GIFT) >= 0 || buttonID.search(MONTH_GIFT) >= 0)
			{
				GuiMgr.getInstance().guiTooltipTopUser.Hide();
			}
		}
		
	}

}