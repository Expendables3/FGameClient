package Event.TreasureIsland 
{
	import adobe.utils.ProductManager;
	import com.greensock.easing.Back;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import Data.BitmapMovie;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Event.TreasureIsland.SendBuyItemInEvent;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.Button;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendLoadInventory;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class GUITreasureIsland extends BaseGUI 
	{
		private const BTN_BUY_SHOVEL_DIAMOND:String = "BuyShovelDiamond";
		private const BTN_BUY_SHOVEL_COIN:String = "BuyShovelCoin";
		private const BTN_BUY_SILVER_KEY_DIAMOND:String = "BuySilverKeyDiamond";
		private const BTN_BUY_SILVER_KEY_COIN:String = "BuySilverKeyCoin";
		private const BTN_BUY_GOLD_KEY_DIAMOND:String = "BuyGoldKeyDiamond";
		private const BTN_BUY_GOLD_KEY_COIN:String = "BuyGoldKeyCoin";
		private const BTN_TREASURE_CHESTS:String = "BtnTreasureChests";
		private const BTN_TREASURE_OPEN_CLOSE:String = "BtnTreasureOpenClose";
		private const BTN_COLLECTION:String = "BtnCollection";
		private const BTN_AUTO_DIG:String = "BtnAutoDig";
		public const BTN_CLOSE:String = "BtnThoat";
		public const BTN_HELP:String = "BtnHelp";
		private const GIFT_ITEM:String = "GiftItem";
		private const IMG_SHOVEL:String = "ImgShovel";
		private const IMG_GOLD_KEY:String = "ImgGoldKey";
		private const IMG_SILVER_KEY:String = "ImgSilverKey";
		
		private const HARVESTED:int = -2;	//ô đất đã nhận quà rồi
		private const DIGGED:int = -1;	//ô đất đã đào rồi
		private const BLANK:int = 0;	//ô ko có đất
		private const NORMAL:int = 1;	//ô đất thường
		
		private const ROW:int = 8; 
		private const COL:int = 8; 
		
		private var landList:Array = [];
		private var giftOnMapList:Array = [];
		public var treasureList:Array = [];
		private var _numShovel:int;
		private var _numGoldKey:int;
		private var _numSilverKey:int;
		
		private var txtShovelNum:TextField;
		private var txtSilverKeyNum:TextField;
		private var txtGoldKeyNum:TextField;
		private var txtZMoney:TextField;
		private var txtDiamond:TextField;
		private var txtClock:TextField;
		
		private var imgShovel:Container;
		private var imgGoldKey:Container;
		private var imgSilverKey:Container;
		private var buyShovelDiamond:Button;
		private var buyShovelCoin:Button;
		private var buyGoldKeyDiamond:Button;
		private var buyGoldKeyCoin:Button;
		private var buySilverKeyDiamond:Button;
		private var buySilverKeyCoin:Button;
		private var imgLandBg:Image;
		public var imgTreasureOpenClose:Container;
		
		public var txtTimeFinish:TextField;
		public var timePlay:Number = 0;
		public var hour:int = 0;
		public var min:int = 0;
		public var sec:int = 0;
		
		private var configStateLand:Object;
		
		[Embed(source="../../../content/dataloading.swf", symbol="DataLoading")]
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		private var landContainerArr:Array;
		public function GUITreasureIsland(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUITreasureIsland";
		}
		private var cfEvent:Object;
		override public function InitGUI():void
		{
			LoadRes("GUITreasureIsland");			
			SetPos(0, 0);
			addContent();
			updateItem();
			cfEvent = ConfigJSON.getInstance().GetItemList("Event");
			var cf:Object = ConfigJSON.getInstance().GetItemList("Param");
			var today:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var lastDay:Date = new Date(userData.LastJoinTime * 1000);
			var todayStr:String = today.getDate().toString() + today.getMonth().toString() + today.getFullYear().toString();
			var lastDayStr:String = lastDay.getDate().toString() + lastDay.getMonth().toString() + lastDay.getFullYear().toString();
			
			var so:SharedObject = SharedObject.getLocal("TreasureIsland" + GameLogic.getInstance().user.GetMyInfo().Id);
			if (so.data.lastDay != null)
			{
				var lDay:String = so.data.lastDay;				
				if (lDay != todayStr)
				{
					so.data.lastDay = todayStr;
					GuiMgr.getInstance().guiHelpTreasureIsland.Show(Constant.GUI_MIN_LAYER, 3);
				}
			}
			else
			{
				so.data.lastDay = todayStr;
				GuiMgr.getInstance().guiHelpTreasureIsland.Show(Constant.GUI_MIN_LAYER, 3);
			}
			Ultility.FlushData(so);
			
			if (todayStr != lastDayStr)	isNextDay = true;
			if (!isNextDay)
			{
				if ((userData["Map"] as Array || userData["Map"] == null) && (userData["JoinNum"] == cf["TreasureIsland"]["MaxJoinNum"]))
				{
					if (imgLandBg)	imgLandBg.img.visible = false;
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã tham gia event " + cf["TreasureIsland"]["MaxJoinNum"] + " lần trong ngày rồi.");
					if (txtTimeFinish)	 txtTimeFinish.visible = false;
					GetButton(BTN_AUTO_DIG).SetDisable();
					return;
				}
			}
			else
			{
				HideOthersGUI();
				if (cfEvent.hasOwnProperty("TreasureIsland"))
				{
					if (GameLogic.getInstance().CurServerTime > cfEvent["TreasureIsland"]["ExpireTime"] || GameLogic.getInstance().CurServerTime < cfEvent["TreasureIsland"]["BeginTime"])
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian tham gia event.");
						Hide();
					}
					else
					{
						sendJoinIsland = new SendJoinIsland();
						Exchange.GetInstance().Send(sendJoinIsland);
						hour = 23;
					}
				}
				else
				{
					Hide();
				}
				return;
			}
			
			if (isNextDay || userData["Map"] as Array || userData["Map"] == null)
			{
				if (landContainerArr != null)
				{
					for (var i:int = 0; i < landContainerArr.length; i++ )
					{
						var container:Container = landContainerArr[i] as Container;
						if (container)	container.Destructor();
					}
				}
				if (!img.contains(WaitData))
				{	
					img.addChild(WaitData);
					WaitData.x = img.width / 2 - 5;
					WaitData.y = img.height / 2 - 5;
				}
				sendJoinIsland = new SendJoinIsland();
				Exchange.GetInstance().Send(sendJoinIsland);
			}		
			addLand(landList);
			isEffRun = false;
		}
		
		private var format:TextFormat = new TextFormat();
		private var toolTip:TooltipFormat;
		public function addContent():void 
		{
			toolTip = new TooltipFormat();
			AddButton(BTN_CLOSE, "BtnClose", 760, 8, this);
			toolTip.text = "Về trại cá";
			GetButton(BTN_CLOSE).setTooltip(toolTip);
			toolTip = new TooltipFormat();
			AddButton(BTN_HELP, "TreasureIsland_BtnGuide", 725, 12, this);
			toolTip.text = "Tìm hiểu cách chơi";
			GetButton(BTN_HELP).setTooltip(toolTip);
			
			var btnTreasure:Button = AddButton(BTN_TREASURE_CHESTS, "BtnTreasure", 710, 480);
			btnTreasure.img.scaleY = -1;
			AddButton(BTN_COLLECTION, "BtnCollectionTreasure", 515, 520);
			GetButton(BTN_COLLECTION).SetEnable(false);
			AddButton(BTN_AUTO_DIG, "BtnAutoDig", 510, 562);
			imgTreasureOpenClose = AddContainer(BTN_TREASURE_OPEN_CLOSE, "BtnTreasureOpenClose", 665, 500, true, this);
			imgTreasureOpenClose.GoToAndStop(1);
			
			imgShovel = AddContainer(IMG_SHOVEL, "IslandItem15", 65, 570);
			imgSilverKey = AddContainer(IMG_SILVER_KEY, "IslandItem1", 225, 570);
			imgGoldKey = AddContainer(IMG_GOLD_KEY, "IslandItem2", 385, 570);
			
			toolTip = new TooltipFormat();
			toolTip.text = "Kiếm được khi chiến thắng ngư thủ\nnhà bạn bè và thế giới cá.";
			imgShovel.setTooltip(toolTip);
			toolTip = new TooltipFormat();
			toolTip.text = "Ngẫu nhiên nhận được\ntrong chùm chìa khóa bạn bè tặng.";
			imgSilverKey.setTooltip(toolTip);
			imgGoldKey.setTooltip(toolTip);
			
			buyShovelCoin = AddButton(BTN_BUY_SHOVEL_COIN, "Btn_Xu", 110, 540);
			buyShovelDiamond = AddButton(BTN_BUY_SHOVEL_DIAMOND, "Btn_Diamond", 110, 575);
			buySilverKeyCoin = AddButton(BTN_BUY_SILVER_KEY_COIN, "Btn_Xu", 270, 540);
			buySilverKeyDiamond = AddButton(BTN_BUY_SILVER_KEY_DIAMOND, "Btn_Diamond", 270, 575);
			buyGoldKeyCoin = AddButton(BTN_BUY_GOLD_KEY_COIN, "Btn_Xu", 430, 540);
			buyGoldKeyDiamond = AddButton(BTN_BUY_GOLD_KEY_DIAMOND, "Btn_Diamond", 430, 575);
			
			txtShovelNum = AddLabel("0", 60, 580, 0x000000, 0, 0xFFFFFF);
			txtSilverKeyNum = AddLabel("0", 220, 580, 0x000000, 0, 0xFFFFFF);
			txtGoldKeyNum = AddLabel("0", 380, 580, 0x000000, 0, 0xFFFFFF);
			
			var config:Object = ConfigJSON.getInstance().getItemInfo("Island_Item");
			AddLabel(config["15"]["ZMoney"], 80, 540, 0x008000, 1, 0xFFFFB3);
			AddLabel(config["15"]["Diamond"], 80, 575, 0x004080, 1, 0xFFFFB3);
			AddLabel(config["1"]["ZMoney"], 240, 540, 0x008000, 1, 0xFFFFB3);
			AddLabel(config["1"]["Diamond"], 240, 575, 0x004080, 1, 0xFFFFB3);
			AddLabel(config["2"]["ZMoney"], 400, 540, 0x008000, 1, 0xFFFFB3);
			AddLabel(config["2"]["Diamond"], 400, 575, 0x004080, 1, 0xFFFFB3);
			
			if (userData != null && userData["MapId"])
				imgLandBg = AddImage("", "IslandMap" + userData["MapId"], 20, 270, true, ALIGN_LEFT_TOP);
			
			var zMoneyHave:int = GameLogic.getInstance().user.GetZMoney();
			
			txtZMoney = AddLabel(Ultility.StandardNumber(zMoneyHave), 50, 10, 0xFFFFFF, 1, 0x26709C);
			txtDiamond = AddLabel(Ultility.StandardNumber(GameLogic.getInstance().user.getDiamond()), 180, 10, 0xFFFFFF, 1, 0x26709C);
			
			configStateLand = ConfigJSON.getInstance().getItemInfo("Island_StateMap");
			
			timePlay = GameLogic.getInstance().CurServerTime * 1000 - 10 * 1000;
			var date:Date = new Date(timePlay);
			hour = int(date.getUTCHours() + Constant.TIME_ZONE_SERVER);
			if (hour >= 24)	hour -= 24;
			min = int(date.getUTCMinutes());
			sec = int(date.getUTCSeconds());
			if (sec == 0)
			{
				if (min == 0) 
				{
					hour = 24 - hour;
				}
				else 
				{
					hour = 23 - hour;
					min = 60 - min;
				}
			}
			else 
			{
				sec = 60 - sec;
				min = 59 - min;
				hour = 23 - hour;
			} 
			var s1:String = hour.toString();
			var s2:String = min.toString();
			var s3:String = sec.toString();
			if (hour < 10)	s1 = "0" + hour;
			if (min < 10)	s2 = "0" + min;
			if (sec < 10)	s3 = "0" + sec;
			
			txtTimeFinish = AddLabel("Còn " + s1 + ":" + s2 + ":" + s3, 380, 32, 0xffffff, 1, 0x26709C);
			var	txtFormatTime:TextFormat = new TextFormat();
			txtFormatTime.size = 15;
			txtTimeFinish.setTextFormat(txtFormatTime);
			txtTimeFinish.defaultTextFormat = txtFormatTime;
		}
		public var isNextDay:Boolean = false;
		private var sendJoinIsland:SendJoinIsland;
		public function UpdateGUI():void 
		{
			if (txtTimeFinish && !txtTimeFinish.visible)
			{
				if (isNextDay)
				{
					HideOthersGUI();
					if (GameLogic.getInstance().CurServerTime > cfEvent["TreasureIsland"]["ExpireTime"] || GameLogic.getInstance().CurServerTime < cfEvent["TreasureIsland"]["BeginTime"])
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian tham gia event.");
						Hide();
					}
					else
					{
						sendJoinIsland = new SendJoinIsland();
						Exchange.GetInstance().Send(sendJoinIsland);
						hour = 23;
					}
				}
			}
			else
			{
				// Cập nhật time count down
				if(!isNextDay)
				{
					if (GameLogic.getInstance().CurServerTime - (timePlay + 10 * 1000) / 1000 >= 1 && txtTimeFinish && txtTimeFinish.text)
					{
						timePlay += 1000;
						if (sec == 0)
						{
							sec = 59;
							if (min == 0)
							{
								min = 59;
								if (hour == 0)
								{
									isNextDay = true;
									HideOthersGUI();
									if (GameLogic.getInstance().CurServerTime > cfEvent["TreasureIsland"]["ExpireTime"] || GameLogic.getInstance().CurServerTime < cfEvent["TreasureIsland"]["BeginTime"])
									{
										GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian tham gia event.");
										Hide();
									}
									else
									{
										sendJoinIsland = new SendJoinIsland();
										Exchange.GetInstance().Send(sendJoinIsland);
										hour = 23;
									}
								}
								else 
								{
									hour --;
								}
							}
							else 
							{
								min --;
							}
						}
						else 
						{
							sec --;
						}
						var s1:String = hour.toString();
						var s2:String = min.toString();
						var s3:String = sec.toString();
						if (hour < 10)	s1 = "0" + hour;
						if (min < 10)	s2 = "0" + min;
						if (sec < 10)	s3 = "0" + sec;
						txtTimeFinish.text = "Còn " + s1 + ":" + s2 + ":" + s3;
					}
				}
				else if (hour == 0)
				{
					HideOthersGUI();
					if (GameLogic.getInstance().CurServerTime > cfEvent["TreasureIsland"]["ExpireTime"] || GameLogic.getInstance().CurServerTime < cfEvent["TreasureIsland"]["BeginTime"])
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian tham gia event.");
						Hide();
					}
					else
					{
						sendJoinIsland = new SendJoinIsland();
						Exchange.GetInstance().Send(sendJoinIsland);
						hour = 23;
					}
				}
			}
		}
		
		public function HideOthersGUI():void 
		{	
			if (GuiMgr.getInstance().guiMessageInEvent.IsVisible)	GuiMgr.getInstance().guiMessageInEvent.Hide();
			if (GuiMgr.getInstance().guiCollectionTreasure.IsVisible)	GuiMgr.getInstance().guiCollectionTreasure.Hide();
			if (GuiMgr.getInstance().guiTreasureChests.IsVisible)	GuiMgr.getInstance().guiTreasureChests.Hide();
			if (GuiMgr.getInstance().guiAutoDigLand.IsVisible)	GuiMgr.getInstance().guiAutoDigLand.Hide();
		}
		
		private function addLand(landList:Array):void 
		{
			var i:int;
			if (landContainerArr != null)
			{
				for (i = 0; i < landContainerArr.length; i++ )
				{
					var container:Container = landContainerArr[i] as Container;
					if (container != null) container.Destructor();
				}
			}
			landContainerArr = [];
			for (i = 0; i < landList.length; i++)
			{
				addItem(i);
			}
			if (img.contains(WaitData))	img.removeChild(WaitData)
			checkExitIsland();
		}
		
		private function addItem(landId:int):void 
		{
			if (landList[landId] == BLANK)
			{
				landContainerArr.push(null);
				return;
			}
			var container:Container = new Container(img, "LandBg");
			var type:int = (int)(landList[landId]);
			var tip:TooltipFormat;
			if (type < NORMAL)
			{
				container.AddImage("HarvestedLand", "HarvestedLand", 35, 20);
				if (type == DIGGED)
				{
					//show qua`
					if (giftOnMapList[landId] > 0)
					{
						var config:Object = ConfigJSON.getInstance().getItemInfo("Island_GiftMap");
						if (giftOnMapList[landId] < 2 || giftOnMapList[landId] > 4)		//trừ TH quà xui xẻo, may mắn
						{
							var giftType:String = config[giftOnMapList[landId]]["ItemType"];
							var objI:Object = config[giftOnMapList[landId]];
							var item:Image;
							switch (giftType)
							{
								case "Exp":
									container.AddImage(GIFT_ITEM, "IcExp", 50, 0);
									break;
								case "Money":
									container.AddImage(GIFT_ITEM, "IcGold", 50, 0);
									break;
								case "Material":
									container.AddImage(GIFT_ITEM, giftType + objI["ItemId"], 70, 20);
									break;
								case "RankPointBottle":
									item = container.AddImage(GIFT_ITEM, giftType + objI["ItemId"], 55, 5);
									item.SetScaleXY(0.7);
									break;
								case "Island_Item":
									container.AddImage(GIFT_ITEM, "IslandItem" + objI["ItemId"], 70, 30);
									break;
								case "HammerWhite":
									container.AddImage("", "GuiTrungLinhThach_Hammer_1", 50, 0);
									break;
								case "HammerGreen":
									container.AddImage("", "GuiTrungLinhThach_Hammer_2", 50, 0);
									break;
								case "HammerYellow":
									container.AddImage("", "GuiTrungLinhThach_Hammer_3", 50, 0);
									break;
								case "HammerPurple":
									container.AddImage("", "GuiTrungLinhThach_Hammer_4", 50, 0);
									break;
								case "AllChest":
									item = container.AddImage("", objI["ItemType"] + objI["Color"] + "_" + objI["ItemType"], 60, 10);
									item.SetScaleXY(0.7);
									break;
								default:
									container.AddImage(GIFT_ITEM, giftType + objI["ItemId"], 50, 0);
									break;
							}
						}
						tip = new TooltipFormat();
						if (giftOnMapList[landId] != 12)
						{
							if (giftOnMapList[landId] < 5 || giftOnMapList[landId] > 6)
								tip.text = "Click để nhận quà";
							else
								tip.text = "Click để mở rương";
						}
						else
						{
							tip.text = "Click để rời đảo";
						}
						container.setTooltip(tip);
					}
				}
			}
			else
			{
				container.AddImage("BlankLand", "BlankLand", 50, 25);
				if (type != NORMAL)		container.AddImage("Item", "LandItem" + type, 70, 20);
			}
			container.IdObject = String(landId);
			container.EventHandler = this;
			var r:int = landId / COL;
			var c:int = landId % COL;
			container.SetPos(20 + 52 * (r + c), 270 + 26 * (r - c));
			landContainerArr.push(container);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (isNextDay)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã sang ngày mới\nHãy chờ hệ thống xử lý trong giây lát");
				return;
			}
			switch (buttonID) 
			{
				case BTN_BUY_SHOVEL_COIN:
				case BTN_BUY_SHOVEL_DIAMOND:
				case BTN_BUY_GOLD_KEY_COIN:
				case BTN_BUY_GOLD_KEY_DIAMOND:
				case BTN_BUY_SILVER_KEY_COIN:
				case BTN_BUY_SILVER_KEY_DIAMOND:
					buyItemInEvent(buttonID);
					break;
				case BTN_TREASURE_CHESTS:
				case BTN_TREASURE_OPEN_CLOSE:
					if (!GuiMgr.getInstance().guiTreasureChests.IsVisible)
					{
						GuiMgr.getInstance().guiTreasureChests.ShowGUI(treasureList);
						imgTreasureOpenClose.GoToAndStop(3);
					}
					break;
				case BTN_COLLECTION:
					GuiMgr.getInstance().guiCollectionTreasure.ShowGUI(itemList);
					break;
				case BTN_AUTO_DIG:
					GuiMgr.getInstance().guiAutoDigLand.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_HELP:
					GuiMgr.getInstance().guiHelpTreasureIsland.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				default:
					var idx:int = int(buttonID);
					var state:int = (int)(landList[idx]);
					var container:Container = landContainerArr[idx] as Container;
					container.SetHighLight(-1);
					GuiMgr.getInstance().guiLandToolTip.Hide();
					digLand(idx);
					break;
			}
		}
		
		public function checkExprireTime():void 
		{
			if (GameLogic.getInstance().CurServerTime > cfEvent["TreasureIsland"]["ExpireTime"] || GameLogic.getInstance().CurServerTime < cfEvent["TreasureIsland"]["BeginTime"])
			{
				Hide();
				HideOthersGUI();
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID) 
			{
				case BTN_TREASURE_OPEN_CLOSE:
					imgTreasureOpenClose.GoToAndStop(2);
					break;
				default:
					if (landContainerArr)
					{
						var idx:int = int(buttonID);
						var type:int = (int)(landList[idx]);
						GuiMgr.getInstance().guiLandToolTip.showGUI(type);
						var container:Container = landContainerArr[idx] as Container;
						if (container)	container.SetHighLight(0xF9F900);
					}
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID) 
			{
				case BTN_TREASURE_OPEN_CLOSE:
					imgTreasureOpenClose.GoToAndStop(1);
					break;
				default:
					GuiMgr.getInstance().guiLandToolTip.Hide();
					if (landContainerArr)
					{
						var idx:int = int(buttonID);
						var container:Container = landContainerArr[idx] as Container;
						if (container)	container.SetHighLight( -1);
					}
					break;
			}
		}
		
		private function buyItemInEvent(buttonId:String):void 
		{
			var config:Object = ConfigJSON.getInstance().getItemInfo("Island_Item");
			var diamond:int;
			var coin:int;
			var objTemp:Object = new Object();
			objTemp["ItemType"] = "Island_Item";
			objTemp["Event"] = "TreasureIsland";
			switch (buttonId)
			{
				case BTN_BUY_SHOVEL_COIN:
				case BTN_BUY_SHOVEL_DIAMOND:
					objTemp["ItemId"] = 15;
					coin = config[objTemp["ItemId"]]["ZMoney"];
					diamond = config[objTemp["ItemId"]]["Diamond"];
					break;
				case BTN_BUY_GOLD_KEY_COIN:
				case BTN_BUY_GOLD_KEY_DIAMOND:
					objTemp["ItemId"] = 2;
					coin = config[objTemp["ItemId"]]["ZMoney"];
					diamond = config[objTemp["ItemId"]]["Diamond"];
					break;
				case BTN_BUY_SILVER_KEY_COIN:
				case BTN_BUY_SILVER_KEY_DIAMOND:
					objTemp["ItemId"] = 1;
					coin = config[objTemp["ItemId"]]["ZMoney"];
					diamond = config[objTemp["ItemId"]]["Diamond"];
					break;
			}
			var str:String = "IslandItem" + objTemp["ItemId"];
			if (buttonId.search(BTN_BUY_SHOVEL_COIN) >= 0 || buttonId.search(BTN_BUY_GOLD_KEY_COIN) >= 0 || buttonId.search(BTN_BUY_SILVER_KEY_COIN) >= 0)
			{
				var coinHave:int = GameLogic.getInstance().user.GetZMoney();
				if (coinHave >= coin)
				{
					objTemp["PriceType"] = "ZMoney";
					var cmd:SendBuyItemInEvent = new SendBuyItemInEvent(objTemp);
					Exchange.GetInstance().Send(cmd);
					
					GameLogic.getInstance().user.UpdateUserZMoney( -coin, true, txtZMoney.x);
					txtZMoney.text = Ultility.StandardNumber(GameLogic.getInstance().user.GetZMoney());
					
					GuiMgr.getInstance().GuiStore.UpdateStore("Island_Item", objTemp["ItemId"]);
					EffectMgr.setEffBounceDown("Mua thành công", str, 330, 280);
					switch (buttonId)
					{
						case BTN_BUY_SHOVEL_COIN:
						case BTN_BUY_SHOVEL_DIAMOND:
							numShovel++;
							break;
						case BTN_BUY_GOLD_KEY_COIN:
						case BTN_BUY_GOLD_KEY_DIAMOND:
							numGoldKey++;
							break;
						case BTN_BUY_SILVER_KEY_COIN:
						case BTN_BUY_SILVER_KEY_DIAMOND:
							numSilverKey++;
							break;
					}
				}
				else
				{
					GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
				}
			}
			else
			{
				var diamondHave:int = GameLogic.getInstance().user.getDiamond();
				if (diamondHave >= diamond)
				{
					var cmd1:SendBuyItemWithDiamond = new SendBuyItemWithDiamond(objTemp);
					Exchange.GetInstance().Send(cmd1);
					
					GameLogic.getInstance().user.updateDiamond(-diamond, txtDiamond.x);
					txtDiamond.text = Ultility.StandardNumber(GameLogic.getInstance().user.getDiamond());
					
					GuiMgr.getInstance().GuiStore.UpdateStore("Island_Item", objTemp["ItemId"]);
					EffectMgr.setEffBounceDown("Mua thành công", str, 330, 280);
					switch (buttonId)
					{
						case BTN_BUY_SHOVEL_COIN:
						case BTN_BUY_SHOVEL_DIAMOND:
							numShovel++;
							break;
						case BTN_BUY_GOLD_KEY_COIN:
						case BTN_BUY_GOLD_KEY_DIAMOND:
							numGoldKey++;
							break;
						case BTN_BUY_SILVER_KEY_COIN:
						case BTN_BUY_SILVER_KEY_DIAMOND:
							numSilverKey++;
							break;
					}
				}
				else
				{
					GuiMgr.getInstance().guiNoDiamond.Show(Constant.GUI_MIN_LAYER, 3);
				}
			}
		}
		
		public function processBuyItem(data:Object):void
		{
			
		}
		
		private function digLand(idx:int):void 
		{
			var stateLand:int = (int)(landList[idx]);
			var container:Container = landContainerArr[idx] as Container;
			if (container == null) return;
			var r:int = idx / COL + 1;
			var c:int = idx % COL + 1;
			if (isEffRun)	return;
			
			if (stateLand < 1 && stateLand != DIGGED)	return;		//đào đất và nhận thưởng rồi thì ko click đc nữa
			if (stateLand == DIGGED)	//nếu chưa nhận quà thì...
			{
				if (giftOnMapList[idx] >= 5 && giftOnMapList[idx] <= 6)	//nếu là mở rương báu
				{
					if ((giftOnMapList[idx] == 5 && numSilverKey > 0) || (giftOnMapList[idx] == 6 && numGoldKey > 0))	//đủ chìa khóa để mở thì request mở rương
					{
						//set lại trạng thái ô đất là nhận quà rồi
						landList[idx] = HARVESTED.toString();
						container.RemoveAllImage();
						container.AddImage("HarvestedLand", "HarvestedLand", 35, 20);
						container.removeAllEvent();
						container.SetHighLight( -1);
						var sendCollectGift:SendCollectGift;
						if (giftOnMapList[idx] == 5)
						{
							numSilverKey--;
							GuiMgr.getInstance().GuiStore.UpdateStore("Island_Item", 1, -1);
							sendCollectGift = new SendCollectGift(r, c, 1);
						}
						else
						{
							numGoldKey--;
							GuiMgr.getInstance().GuiStore.UpdateStore("Island_Item", 2, -1);
							sendCollectGift = new SendCollectGift(r, c, 2);
						}
						Exchange.GetInstance().Send(sendCollectGift);
					}
					else	
					{
						//ko đủ chìa khóa thì show bảng thông báo mua chìa khóa
						var s:String = Localization.getInstance().getString("IslandMess3");
						if (giftOnMapList[idx] == 5)	GuiMgr.getInstance().guiMessageInEvent.ShowMessBuyItem(s, 1, buyItemInEvent);
						else	GuiMgr.getInstance().guiMessageInEvent.ShowMessBuyItem(s, 2, buyItemInEvent);
					}
				}
				else //if (giftOnMapList[idx] != 12)	//nếu là quà thì request nhận quà (ko phải cửa thoát)
				{
					//set lại trạng thái ô đất là nhận quà rồi
					landList[idx] = HARVESTED.toString();
					container.RemoveAllImage();
					container.AddImage("HarvestedLand", "HarvestedLand", 35, 20);
					container.removeAllEvent();
					
					if (giftOnMapList[idx] >= 41)
					{
						sendCollectGift = new SendCollectGift(r, c, 3);
						Exchange.GetInstance().Send(sendCollectGift);
					}
					else
					{
						sendCollectGift = new SendCollectGift(r, c);
						Exchange.GetInstance().Send(sendCollectGift);
						var config:Object = ConfigJSON.getInstance().getItemInfo("Island_GiftMap");
						var objItem:Object = config[giftOnMapList[idx]];
						
						if (objItem["ItemType"] != "Island_Item")
						{
							var confItem:Object = new Object();
							confItem["ItemId"] = objItem["ItemId"];
							confItem["ItemType"] = objItem["ItemType"];
							confItem["Name"] = objItem["Name"];
							confItem["Num"] = objItem["Num"];
							confItem["Rate"] = objItem["Rate"];
							treasureList.push(confItem);
							groupTreasure();
						}
						else
						{
							isCollection = true;
							itemList[objItem["ItemId"]] += objItem["Num"];
							numGoldKey = itemList[2];
							GuiMgr.getInstance().GuiStore.UpdateStore(objItem["ItemType"], objItem["ItemId"], objItem["Num"]);
						}
					}
					aGift.push(objItem);
					ctn = container;
					openTrunk();
				}
				/*else
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(Localization.getInstance().getString("IslandMess5"), 310, 200, 0, sendRequest);
					function sendRequest():void
					{
						sendCollectGift = new SendCollectGift(r, c);
						Exchange.GetInstance().Send(sendCollectGift);
					}
				}*/
				return;
			}
			var shovelRequire:int = configStateLand[landList[idx]]["ShovelRequire"];
			if (shovelRequire <= numShovel)
			{
				//Show eff đào đất ở đây
				function sendDigLand():void
				{
					if (isNextDay == true) return;
					if (container == null || container.ImageArr == null) return;
					if (stateLand == NORMAL)	//ô đất thường
					{
						stateLand = DIGGED;
						landList[idx] = stateLand.toString();
						numShovel--; 
						GuiMgr.getInstance().GuiStore.UpdateStore("Island_Item", 15, -1);
						container.removeAllEvent();
						container.SetHighLight( -1);
						showEffSubShovel( -1, container);
						enableAll(true);
					}
					else		//ô đất có trạng thái đặc biệt
					{
						numShovel -= shovelRequire;
						GuiMgr.getInstance().GuiStore.UpdateStore("Island_Item", 15, -shovelRequire);
						stateLand = NORMAL;
						landList[idx] = stateLand.toString();
						showEffSubShovel( -shovelRequire, container);
						enableAll(true);
					}
					//show lại trạng thái của ô đất sau khi đào
					container.RemoveAllImage();
					if (stateLand == DIGGED)
						container.AddImage("HarvestedLand", "HarvestedLand", 35, 20);
					if (stateLand >= NORMAL)
					{
						container.AddImage("BlankLand", "BlankLand", 50, 25);
						if (stateLand != 1)
						{
							container.AddImage("Item", "LandItem" + shovelRequire, 70, 20);
						}
					}
					
					var sendDig:SendDigLand = new SendDigLand(r, c);
					Exchange.GetInstance().Send(sendDig);
					enableAll(true);
				}
				showEffDigLand(stateLand, container, sendDigLand);
			}
			else	//show tooltip nếu ko đủ xẻng
			{
				var posStart:Point = GameInput.getInstance().MousePos;
				var posEnd:Point = new Point(posStart.x, posStart.y - 100);
				var txtFormat:TextFormat = new TextFormat("Arial", 14, 0xFF0000, true, null, null, null, null, "center");
				var str:String = "Bạn không đủ xẻng để đào";
				Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat, 1, 0xffffff);
			}
		}
		
		private function showEffSubShovel(shovelRequire:int, ctn:Container):void 
		{
			if (img == null || ctn == null || ctn.img == null)	return;
			enableAll(false);
			var txtFormat:TextFormat = new TextFormat("Arial", 28, 0xFF0000, true, null, null, null, null, "right");
			var tmp:Sprite = Ultility.createSpriteFromText(shovelRequire.toString(), txtFormat);
			tmp.x = -40;
			var imgShovel:Container = new Container(img, "ImgShovel");
			imgShovel.img.addChild(tmp);
			var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, imgShovel.img) as ImgEffectFly;
			eff.SetInfo(ctn.img.x, ctn.img.y,ctn.img.x, ctn.img.y + 60, 5);
		}
		
		public var isEffRun:Boolean = false;
		private function showEffDigLand(stateLand:int, container:Container, func:Function):void 
		{
			if (isNextDay == true) return;
			if (container == null || container.img == null || container.ImageArr == null)	return;
			isEffRun = true;
			enableAll(false);
			var effName:String;
			switch (stateLand)
			{
				case 1:
					effName = "EffDigLand1";
					break;
				case 2:
				case 8:
				case 9:
					effName = "EffDigLand2";
					break;
				case 5:
				case 6:
				case 7:
					effName = "EffDigLand3";
					break;
				case 3:
					container.RemoveAllImage();
					container.AddImage("BlankLand", "BlankLand", 50, 25);
					effName = "EffDigLand4";
					break;
				case 4:
					container.RemoveAllImage();
					container.AddImage("BlankLand", "BlankLand", 50, 25);
					effName = "EffDigLand5";
					break;
			}
			
			if (container && container.img)
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, effName, null, container.img.x + 42, container.img.y - 40, false, false, null, func);
		}
		
		public function processDigLand(giftId:int, sendData:SendDigLand):void
		{			
			if (isNextDay == true) return;
			if (giftId <= 0)
			{
				isEffRun = false;
				return;
			}
			var ind:int = (sendData.H - 1) * COL + sendData.C - 1;
			var r:int = ind / COL + 1;
			var c:int = ind % COL + 1;
			var container:Container = landContainerArr[ind] as Container;
			if (container == null || container.img == null)
			{
				isEffRun = false;
				return;
			}
			container.RemoveAllImage();
			container.AddImage("HarvestedLand", "HarvestedLand", 35, 20);
			var config:Object = ConfigJSON.getInstance().getItemInfo("Island_GiftMap");
			var objItem:Object = config[giftId];
			if (giftId < 2 || giftId > 4)	//trừ TH xui xẻo, may mắn
			{
				var giftType:String = objItem["ItemType"];
				var item:Image;
				switch (giftType)
				{
					case "Exp":
						container.AddImage(GIFT_ITEM, "IcExp", 50, 0);
						break;
					case "Money":
						container.AddImage(GIFT_ITEM, "IcGold", 50, 0);
						break;
					case "Material":
						container.AddImage(GIFT_ITEM, giftType + objItem["ItemId"], 70, 20);
						break;
					case "RankPointBottle":
						item = container.AddImage(GIFT_ITEM, giftType + objItem["ItemId"], 55, 5);
						item.SetScaleXY(0.7);
						break;
					case "Island_Item":
						container.AddImage(GIFT_ITEM, "IslandItem" + objItem["ItemId"], 70, 30);
						break;
					case "HammerWhite":
						container.AddImage("", "GuiTrungLinhThach_Hammer_1", 50, 0);
						break;
					case "HammerGreen":
						container.AddImage("", "GuiTrungLinhThach_Hammer_2", 50, 0);
						break;
					case "HammerYellow":
						container.AddImage("", "GuiTrungLinhThach_Hammer_3", 50, 0);
						break;
					case "HammerPurple":
						container.AddImage("", "GuiTrungLinhThach_Hammer_4", 50, 0);
						break;
					case "AllChest":
						item = container.AddImage("", objItem["ItemType"] + objItem["Color"] + "_" + objItem["ItemType"], 60, 10);
						item.SetScaleXY(0.7);
						break;
					default:
						container.AddImage(GIFT_ITEM, giftType + objItem["ItemId"], 50, 0);
						break;
				}
				var tip:TooltipFormat = new TooltipFormat();
				//if (giftId != 12)
				//{
					if (giftId < 5 || giftId > 6)
					{
						tip.text = "Click để nhận thưởng";
						//set lại trạng thái ô đất là nhận quà rồi
						landList[ind] = HARVESTED.toString();
						var sendCollectGift:SendCollectGift;
						if (giftId >= 41)
						{
							sendCollectGift = new SendCollectGift(r, c, 3);
							Exchange.GetInstance().Send(sendCollectGift);
						}
						else
						{
							sendCollectGift = new SendCollectGift(r, c);
							Exchange.GetInstance().Send(sendCollectGift);
							
							if (objItem["ItemType"] != "Island_Item" || objItem["ItemId"] == 2)
							{
								var confItem:Object = new Object();
								confItem["ItemId"] = objItem["ItemId"];
								confItem["ItemType"] = objItem["ItemType"];
								confItem["Name"] = objItem["Name"];
								confItem["Num"] = objItem["Num"];
								confItem["Rate"] = objItem["Rate"];
								treasureList.push(confItem);
								groupTreasure();
							}
							else
							{
								isCollection = true;
								itemList[objItem["ItemId"]] += objItem["Num"];
								//numGoldKey = itemList[2];
								GuiMgr.getInstance().GuiStore.UpdateStore(objItem["ItemType"], objItem["ItemId"], objItem["Num"]);
							}
						}
						
						var timer:Timer = new Timer(500, 1);
						timer.start();
						timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComp);
						function onTimerComp():void
						{
							if (timer)
							{
								timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComp);
								timer.stop();
								timer = null;
							}
							if (isNextDay == true) return;
							if (container == null || container.ImageArr == null) return;
							container.RemoveAllImage();
							container.AddImage("HarvestedLand", "HarvestedLand", 35, 20);
							container.removeAllEvent();
							container.SetHighLight( -1);
							
							aGift.push(objItem);
							ctn = container;
							openTrunk();
						}
					}
					else
					{
						tip.text = "Click để mở rương";
						EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffHura", null, container.img.x, container.img.y);
					}
				//}
				//else
				//{
					//tip.text = "Click để rời đảo";
				//}
				container.setTooltip(tip);
				giftOnMapList[ind] = giftId;
				container.addAllEvent();
				isEffRun = false;
			}
			else
			{
				landList[ind] = HARVESTED.toString();
				container.RemoveAllImage();
				container.AddImage("HarvestedLand", "HarvestedLand", 35, 20);
				container.removeAllEvent();
				container.SetHighLight( -1);
				isEffRun = true;
				var sendIsLucky:SendIsLucky = new SendIsLucky(r, c);
				Exchange.GetInstance().Send(sendIsLucky);
				if (giftId == 2)
					EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffHura", null, container.img.x, container.img.y);
			}
		}
		
		public function processCollectGift(data1:Object, sendCollectGift:SendCollectGift):void 
		{
			if ((data1["Gift"] as Array) && sendCollectGift.type != 0)
			{
				var ind:int = (sendCollectGift.H - 1) * COL + sendCollectGift.C - 1;
				var container:Container = landContainerArr[ind] as Container;
				if (container && sendCollectGift.type < 3)
				{
					aGift = data1["Gift"];
					ctn = container;
					for (var i:int = 0; i < aGift.length; i++ )
					{
						if (aGift[i].hasOwnProperty("Type"))
						{
							var type:String = aGift[i]["Type"];
							if (type == "Helmet" || type == "Armor" || type == "Weapon" || type == "Belt" || type == "Bracelet" || type == "Necklace" || type == "Ring")
							{
								GameLogic.getInstance().user.GenerateNextID();
							}
						}
					}
					EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffOpenTrunk" + sendCollectGift.type, null, container.img.x + 50, container.img.y + 10, false, false, null, openTrunk);
				}
				else
				{
					GameLogic.getInstance().user.GenerateNextID();
				}
				for (i = 0; i < data1["Gift"].length; i++ )
				{
					treasureList.push(data1["Gift"][i]);
				}
				groupTreasure();
			}
			checkExitIsland();
		}
		
		private function checkExitIsland():void 
		{
			var n:int;
			for (var i:int = 0; i < ROW * COL; i++ )
			{
				if (landList[i] == HARVESTED)	n++;
			}
			if (n >= numLand && numLand > 0)
			{
				Exchange.GetInstance().Send(new SendExitIsland());
			}
		}
		
		public function processExitIsland(data1:Object):void
		{
			if (data1["ExitGift"])
			{
				//Exit Island
				receiveGift();
				resetData();
			}
		}
		
		private var aGift:Array = [];
		private var ctn:Container;
		private var isCollection:Boolean = false;
		private function openTrunk():void
		{
			if (ctn == null || ctn.img == null)	return;
			var txtFormat:TextFormat = new TextFormat("Arial", 30, 0xFFFF0D, true);
			var c:Container = this.AddContainer("", "LandBg", ctn.img.x, ctn.img.y);
			for (var i:int = 0; i < aGift.length; i++ )
			{
				var num:int = 1;
				if (aGift[i].hasOwnProperty("Num"))
				{
					num = aGift[i]["Num"];
				}
				var name:String = getGiftName(aGift[i]);
				//eff num fly	
				var tmp:Sprite = Ultility.createSpriteFromText("+" + Ultility.StandardNumber(num), txtFormat);
				var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
				eff.SetInfo(ctn.img.x + 30, ctn.img.y, ctn.img.x + 50 * (i % 2) , ctn.img.y + 70 - 50 * (i / 2), 4);
				
				//show eff quà bay vào kho tạm thời
				if (this.img == null) return;
				var giftImg:Image = c.AddImage(GIFT_ITEM, name, 30 + 60 * (i % 2), - 40 - 60 * (i / 2));
			}
			var p1:Point = new Point(ctn.img.x, ctn.img.y);
			var p2:Point = new Point(700, 630);
			if (isCollection) p2 = new Point(580, 560);
			var m:Point = getThroughPoint(p1, p2);
			TweenMax.to(c.img, 2, { bezierThrough:[ { x:m.x, y:m.y }, { x:p2.x, y:p2.y } ], alpha:0, ease:Cubic.easeOut });
			aGift = [];
			isCollection = false;
		}
		
		public function getThroughPoint(psrc:Point, pdes:Point):Point
		{
			var p:Point = pdes.subtract(psrc);//Vector từ nguồn đến đích
			if (p.y == 0)	return new Point(p.x/2, 0);
			var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2);//Trung điểm của nguồn và đích
			var v:Point = new Point( -p.y, p.x);//Vector vuông góc với vector(nguồn, đích)
			var n:int = Math.round(Math.random()) * 2 - 1;
			v.x = n*v.x;
			v.y = n*v.y;
			var l:Number = Math.min(150, v.length / 2);
			v.normalize(l);//Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			var result:Point = med.add(v);//Tính ra điểm cần đi xuyên qua
			return result;
		}
		
		private function getGiftName(data:Object):String
		{
			var str:String;
			if (data.hasOwnProperty("ItemType"))
			{
				switch (data["ItemType"])
				{
					case "Exp":
						str = "IcExp";
						break;
					case "Money":
						str = "IcGold";
						break;
					case "Material":
					case "EnergyItem":
					case "RankPointBottle":
						str = data["ItemType"] + data["ItemId"];
						break;
					case "Island_Item":
						str = "IslandItem" + data["ItemId"];
						break;
					case "HammerWhite":
						str = "GuiTrungLinhThach_Hammer_1";
						break;
					case "HammerGreen":
						str = "GuiTrungLinhThach_Hammer_2";
						break;
					case "HammerYellow":
						str = "GuiTrungLinhThach_Hammer_3";
						break;
					case "HammerPurple":
						str = "GuiTrungLinhThach_Hammer_4";
						break;
					case "AllChest":
						str = data["ItemType"] + data["Color"] + "_" + data["ItemType"];
						break;
					default:
						break;
				}
			}
			else
			{
				str = FishEquipment.GetEquipmentName(data.Type, data.Rank, data.Color) + "_Shop";
			}
			return str;
		}
		
		private function receiveGift():void 
		{
			//show bảng nhận quà, lưu quà tạm thời vào túi đồ
			if (treasureList.length <= 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("IslandMess4"));
			}
			else
			{
				GuiMgr.getInstance().guiReceiveTreasure.showTreasure(treasureList);
			}
			GuiMgr.getInstance().guiChangeMedalVIP.medalNum = itemList[14];
		}
		
		private var imgEffAngel:Image;
		private function onFinishTween():void
		{
			if (ctn == null || ctn.img == null)	return;
			this.RemoveImage(imgEffAngel);
			ctn.RemoveAllImage();
			ctn.AddImage("HarvestedLand", "HarvestedLand", 35, 20);
			ctn.removeAllEvent();
			ctn.SetHighLight( -1);
			
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffOpenTrunk2", null/*[name]*/, ctn.img.x + 50, ctn.img.y + 10, false, false, null, openTrunk);
		}
		
		public function processIsLucky(data1:Object, sendIsLucky:SendIsLucky):void 
		{
			//TH thiên thần nhỏ --> thêm quà vào giftOnMapList, kho tạm thời, set status o may mắn = -2
			var ind:int = (sendIsLucky["H"] - 1) * COL + sendIsLucky["C"] - 1;
			var container:Container = landContainerArr[ind] as Container;
			if (container == null)	return;
			if (!(data1["LuckyPosition"] as Array))	//TH may mắn
			{
				imgEffAngel = this.AddImage("Eff", "EffAngel", container.img.x + 70, container.img.y + 30);
				
				var ind1:int = (data1["LuckyPosition"]["H"] - 1) * COL + data1["LuckyPosition"]["C"] - 1;
				var container1:Container = landContainerArr[ind1] as Container;
				
				var lGift:Object;
				if (data1["LuckyGift"] as Array)
					lGift = data1["LuckyGift"][0];
				else
					lGift = data1["LuckyGift"];
				if (lGift == null) return;
				aGift.push(lGift);
				ctn = container1;
				
				var p1:Point = new Point(imgEffAngel.img.x, imgEffAngel.img.y);
				var p2:Point = new Point(container1.img.x + 40, container1.img.y);
				var m:Point = getThroughPoint(p1, p2);
				TweenMax.to(imgEffAngel.img, 1, { bezierThrough:[ { x:m.x, y:m.y }, { x:p2.x, y:p2.y } ], ease:Cubic.easeOut, onComplete:onFinishTween});	
				if (lGift.hasOwnProperty("Type"))
				{
					var type:String = lGift["Type"];
					if (type == "Helmet" || type == "Armor" || type == "Weapon" || type == "Belt" || type == "Bracelet" || type == "Necklace" || type == "Ring")
					{
						GameLogic.getInstance().user.GenerateNextID();
					}
				}
				landList[ind1] = HARVESTED.toString();
				treasureList.push(lGift);
				groupTreasure();
				isEffRun = false;
				checkExitIsland();
			}
			//TH dừa rơi --> xóa quà trong kho tạm thời, show bảng thông báo
			if (data1["Map"] as Array && data1["LuckyPosition"] as Array)
			{
				var lostArr:Array = new Array();
				if (!(data1["LostGift"] as Array))
				{
					for (var s:String in data1["LostGift"])
					{
						lostArr.push(data1["LostGift"][s])
					}
				}
				else
				{
					for (var i:int = 0; i < data1["LostGift"].length; i++ )
					{
						lostArr.push(data1["LostGift"][i])
					}
				}
				for (i = 0; i < lostArr.length; i++ )
				{
					var gLost:Object = lostArr[i];
					if (gLost == null) continue;
					for (var j:int = 0; j < treasureList.length; j++ )
					{
						var gift:Object = treasureList[j];
						if (gLost.hasOwnProperty("ItemType"))
						{
							if (gLost["ItemType"] != gift["ItemType"]) continue;
							
							if (gLost.hasOwnProperty("ItemId"))
							{
								if (gLost["ItemId"] == gift["ItemId"])
								{
									if (gift["Num"] <= gLost["Num"])
									{
										treasureList.splice(j, 1);
										j--;
									}
									else
									{
										gift["Num"] -= gLost["Num"];
									}
									break;
								}
								else
								{
									continue;
								}
							}
							else
							{
								if (gift["Num"] <= gLost["Num"])
								{
									treasureList.splice(j, 1);
									j--;
								}
								else
								{
									gift["Num"] -= gLost["Num"];
								}
								break;
							}
						}
						else
						{
							if (gLost["Id"] == gift["Id"])
							{									
								treasureList.splice(j, 1);
								j--;								
								break;	
							}						
						}
					}
				}
				enableAll(false);
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffCoconut", null, container.img.x + 50, container.img.y + 10, false, false, null, showGUILostGift);
				function showGUILostGift():void
				{
					if (lostArr.length > 0)
						GuiMgr.getInstance().guiMessageInEvent.ShowMessLostGift(Localization.getInstance().getString("IslandMess2"), lostArr);
					else
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("IslandMess6"));
					enableAll(true);
				}
				isEffRun = false;
				checkExitIsland();
			}
			//TH mưa đá --> reset lại map
			if (data1["Map"] as Array)
			{
				isEffRun = false;
				checkExitIsland();
				return;
			}
			var c:Container;
			var index:int;
			for (s in data1["Map"])
			{
				for (var t:String in data1["Map"][s])
				{
					if (data1["Map"][s][t] == 2)
					{
						index = (int(s) - 1) * COL + int(t) - 1;
						c = landContainerArr[index] as Container;
						EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffRain", null, c.img.x + 50, c.img.y + 10);
					}
				}
			}
			updateMap(data1["Map"]);
			isEffRun = false;
			checkExitIsland();
		}
		
		public function sendAuto(idChoice:int):void
		{
			var cmd:SendAutoDig = new SendAutoDig(idChoice);
			Exchange.GetInstance().Send(cmd);
			var config:Object = ConfigJSON.getInstance().getItemInfo("IsLand_AutoDig");
			GameLogic.getInstance().user.UpdateUserZMoney( -config[idChoice]["ZMoney"], true, 50);
			GuiMgr.getInstance().guiAutoDigLand.Hide();		
			enableAll(false);
		}
		
		public function processAutoDig(data1:Object, sendAutoDig:SendAutoDig):void 
		{
			//show gui nhan qua, add qua vao tui do
			var container:Container;
			var stateLand:int;
			var effRun:Boolean = false;
			for (var i:int = 0; i < landContainerArr.length; i++ )
			{
				container = landContainerArr[i];
				stateLand = (int)(landList[i]);
				if (container && (stateLand > 0))
				{
					effRun = true;
					showEffDigLand(stateLand, container, processAuto);
				}
				if (i == landContainerArr.length - 1 && !effRun)
				{
					effRun = true;
					processAuto();
				}
			}
			function processAuto():void
			{
				if (effRun)
				{
					treasureList = [];
					var s:String;
					if (data1["NormalGift"] as Object)
					{
						for (s in data1["NormalGift"])
						{
							treasureList.push(data1["NormalGift"][s]);
						}
					}
					if (data1["SpecialGift"] as Object)
					{
						for (s in data1["SpecialGift"])
						{
							treasureList.push(data1["SpecialGift"][s]);
							GameLogic.getInstance().user.GenerateNextID();
						}
					}
					groupTreasure();
					receiveGift();
					resetData();
				}
				effRun = false;
				isEffRun = false;
				Hide();
			}			
		}
		
		private function resetData():void 
		{
			Hide();
			landList = [];
			userData["Map"] = null;
			giftOnMapList = [];
			treasureList = [];
			isNextDay = false;
		}
		
		public function processChangeCollection(data1:Object, sendChangeCollection:SendChangeCollection):void 
		{
			//show gui nhan qua, add qua vao tui do
			var collectionGift:Array = [];
			var s:String;
			if (data1["NormalGift"] as Object)
			{
				for (s in data1["NormalGift"])
				{
					collectionGift.push(data1["NormalGift"][s]);
				}
			}
			if (data1["SpecialGift"] as Object)
			{
				for (s in data1["SpecialGift"])
				{
					collectionGift.push(data1["SpecialGift"][s]);
				}
			}
			GuiMgr.getInstance().guiReceiveGiftChangeMedal.showGui(collectionGift);
		}
		
		public function get numShovel():int 
		{
			return _numShovel;
		}
		
		public function set numShovel(value:int):void 
		{
			_numShovel = value;
			if (txtShovelNum) 	txtShovelNum.text = numShovel.toString();
			itemList[15] = numShovel;
		}
		
		public function get numGoldKey():int 
		{
			return _numGoldKey;
		}
		
		public function set numGoldKey(value:int):void 
		{
			_numGoldKey = value;
			if (txtGoldKeyNum)	txtGoldKeyNum.text = String(numGoldKey);
			itemList[2] = numGoldKey;
		}
		
		public function get numSilverKey():int 
		{
			return _numSilverKey;
		}
		
		public function set numSilverKey(value:int):void 
		{
			_numSilverKey = value;
			if (txtSilverKeyNum) 	txtSilverKeyNum.text = String(numSilverKey);
			itemList[1] = numSilverKey;
		}
		
		public function get userData():Object 
		{
			return _userData;
		}
		
		public function set userData(value:Object):void 
		{
			_userData = value;
			updateMap(userData["Map"]);
			updateTreasure(userData["Treasure"]);
			updateGiftOnMap(userData["TempGift"]);
			updateItem();
		}
		
		public function updateItem():void 
		{
			var arr:Array = GameLogic.getInstance().user.StockThingsArr.Island_Item;
			itemList = [];
			for (var i:int = 1; i <= 15 ; i++ )
			{
				itemList[i] = 0;
			}
			for (var j:int = 0; j < arr.length; j++ )
			{
				itemList[int(arr[j]["Id"])] = arr[j]["Num"];
			}
			GuiMgr.getInstance().guiChangeMedalVIP.medalNum = itemList[14];
			numSilverKey = itemList[1];
			numGoldKey = itemList[2];
			numShovel = itemList[15];
		}
		
		public function updateTreasure(data:Object):void 
		{
			treasureList = [];
			for (var s:String in data)
			{
				treasureList.push(data[s])
			}
			groupTreasure();
		}
		
		private function groupTreasure():void 
		{
			if (treasureList.length <= 0) return;
			var temp:Array = [];
			temp.push(treasureList[0]);
			var i:int = 1;
			if (treasureList.length == i)	return;
			do
			{
				for (var j:int = 0; j < temp.length; j++ )
				{
					if ((treasureList[i].hasOwnProperty("ItemType") && treasureList[i]["ItemType"] == temp[j]["ItemType"]) || 
					(treasureList[i].hasOwnProperty("Type") && treasureList[i]["Type"] == temp[j]["Type"]))
					{
						if (treasureList[i]["ItemType"] == "Exp" || treasureList[i]["ItemType"] == "Money")
						{
							temp[j]["Num"] += treasureList[i]["Num"];
							i++;
							break;
						}
						if (treasureList[i].hasOwnProperty("ItemId"))
						{
							if (treasureList[i]["ItemId"] == temp[j]["ItemId"])
							{
								temp[j]["Num"] += treasureList[i]["Num"];
								i++;
								break;
							}
							else
							{
								if (j == temp.length - 1)	
								{
									temp.push(treasureList[i]);
									i++;
									break;
								}
							}
						}
						if (treasureList[i].hasOwnProperty("Type"))
						{		
							temp.push(treasureList[i]);
							i++;
							break;
						}
					}
					else
					{
						if (j == temp.length - 1)	
						{
							temp.push(treasureList[i]);
							i++;
							break;
						}
					}
				}
			}
			while (i < treasureList.length)
			treasureList = temp;
		}
		
		public function updateGiftOnMap(data:Object):void 
		{
			giftOnMapList = [];
			for (var s:int = 1; s <= ROW; s++ )
			{
				for (var t:int = 1; t <= COL; t++ )
				{
					if (data as Array || data == null)
					{
						giftOnMapList.push(0);
					}
					else 
					{
						if (data.hasOwnProperty(s.toString()))
						{
							if (data[s.toString()].hasOwnProperty(t.toString()))
								giftOnMapList.push(data[s.toString()][t.toString()]);
							else
								giftOnMapList.push(0);
						}
						else
						{
							giftOnMapList.push(0);
						}
					}
				}
			}
		}
		
		private var _userData:Object;		//user data (Map, TempGift, Treasure, JoinNum, LastJoinTime, MapId) trả về trong init run
		public var itemList:Array;		//list item (shovel, key)
		public var numLand:int;
		public function updateMap(data:Object):void
		{
			if (data == null) return;
			landList = [];
			numLand = 0;
			for (var r:int = 1; r <= ROW; r++ )
			{
				for (var t:int = 1; t <= COL; t++ )
				{
					if (data.hasOwnProperty(r.toString()))
					{
						var u:Object = data[r];
						if (u.hasOwnProperty(t.toString()))	
						{
							landList.push(u[t]);	
							numLand++;
						}
						else	
						{
							landList.push(0);
						}
					}
					else
					{
						landList.push(0);
					}
				}
			}
			if (this.IsVisible) 
			{
				if (imgLandBg && imgLandBg.img)
				{
					imgLandBg.img.visible = true;
					imgLandBg.LoadRes("IslandMap" + userData["MapId"]);
					imgLandBg.SetPos(20, 270);
				}
				else
				{
					imgLandBg = AddImage("", "IslandMap" + userData["MapId"], 20, 270, true, ALIGN_LEFT_TOP);
				}
				addLand(landList);	
			}
		}
		
		private function enableAll(enable:Boolean):void
		{
			if (!this.IsVisible) return;
			var i:int;
			var btn:Button;
			for (i = 0; i < ButtonArr.length; i++)
			{
				btn = ButtonArr[i];
				btn.SetEnable(enable);
			}
			GetButton(BTN_COLLECTION).SetEnable(false);
		}
	}
}