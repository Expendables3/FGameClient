package GUI.EventEuro 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Event.EventMgr;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.engine.EastAsianJustifier;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.AvatarImage;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ScrollBar;
	import GUI.component.TooltipFormat;
	import GUI.EventEuro.Packet.SendBuyBall;
	import GUI.EventEuro.Packet.SendGetEuroInfo;
	import GUI.EventEuro.Packet.SendRecieveGiftEuro;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIEventEuro extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var waitingMovie:MovieClip = new DataLoading();
		private var imgFixture:Image;
		private var btnFixture:Button;
		private var imgPrediction:Image;
		private var btnPrediction:Button;
		private var imgTop:Image;
		private var btnTop:Button;
		private var listFixture:ListBox;
		private var scrollBar:ScrollBar;
		private var listPrediction:ListBox;
		private var dataFixture:Object;
		private var dataPrediction:Object;
		private var ctnTop:Container;
		private var labelNormalBall:TextField;
		private var labelVipBall:TextField;
		private var _numNormalBall:int;
		private var _numVipBall:int;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_TAB_FIXTURE:String = "btnTabFixture";
		static public const BTN_TAB_PREDICTION:String = "btnTabPrediction";
		static public const BTN_TAB_TOP:String = "btnTabTop";
		static public const CTN_TOP_GIFT:String = "ctnTopGift";
		static public const BTN_GET_TOP_GIFT:String = "btnGetTopGift";
		static public const BTN_BUY_NORMAL_BALL:String = "btnBuyNormalBall";
		static public const BTN_BUY_VIP_BALL:String = "btnBuyVipBall";
		private var loadContentComplete:Boolean = false;
		public var loadDataComplete:Boolean = false;
		public var dataTop:Object;
		private var ctnFixture:Container;
		private var ctnPrediction:Container;
		private var _numMedal:int;
		private var labelMedal:TextField;
		private var lastPosition:int;
		private var labelLastPost:TextField;
		private var arrFixture:Array;
		private var arrPrediction:Array;
		private var euroAchieved:int = 0;
		private var gotAchieved:Boolean = true;
		private var _countGift:int;
		private var labelCountGift:TextField;
		private var imageCountGift:Image;
		private var champion:String;
		public var dataServer:Object;
		public var numBuyGoldOrd:int;
		public var numBuyZMoneyOrd:int;
		public var numBuyZMoneyVip:int;
		public var numBuyDiamondVip:int;
		
		public function GUIEventEuro(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(50, 10);
				OpenRoomOut();
			}
			LoadRes("GuiEventEuro_Theme");
			loadContentComplete = false;
			loadDataComplete = false;
			var sendGetEuroInfo:SendGetEuroInfo = new SendGetEuroInfo();
			Exchange.GetInstance().Send(sendGetEuroInfo);
		}
		
		override public function EndingRoomOut():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 300 + 400, 17);
			img.addChild(waitingMovie);
			waitingMovie.x = img.width / 2;
			waitingMovie.y = img.height / 2;
			waitingMovie.visible = true;
			
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("TooltipORDBall");
			var ctnBall:Container = AddContainer("", "Ic_ORDBall", 0, 0);
			ctnBall.FitRect(30, 30, new Point(152, 91));
			ctnBall.setTooltip(tooltip);
			tooltip = new TooltipFormat();
			tooltip.text = Localization.getInstance().getString("TooltipVIPBall");
			ctnBall = AddContainer("", "Ic_VIPBall", 0, 0);
			ctnBall.setTooltip(tooltip);
			ctnBall.FitRect(30, 30, new Point(455, 91));
			AddButton(BTN_BUY_NORMAL_BALL, "GuiEventEuro_BtnBuyBall", 65, 95);
			AddButton(BTN_BUY_VIP_BALL, "GuiEventEuro_BtnBuyBall", 617, 95);
			
			imgFixture = AddImage("", "GuiEventEuro_SelectedFixture", 57, 143, true, ALIGN_LEFT_TOP);
			btnFixture = AddButton(BTN_TAB_FIXTURE, "GuiEventEuro_BtnTabFixture", imgFixture.img.x, imgFixture.img.y, this);
			imgPrediction = AddImage("", "GuiEventEuro_SelectedPredict", imgFixture.img.x + imgFixture.img.width + 6, 143, true, ALIGN_LEFT_TOP);
			btnPrediction = AddButton(BTN_TAB_PREDICTION, "GuiEventEuro_BtnTabPredict", imgPrediction.img.x, imgPrediction.img.y, this);
			imgTop = AddImage("", "GuiEventEuro_SelectedTop", imgPrediction.img.x + imgPrediction.img.width + 3, 143, true, ALIGN_LEFT_TOP);
			btnTop = AddButton(BTN_TAB_TOP, "GuiEventEuro_BtnTabTop", imgTop.img.x, imgTop.img.y, this);
			AddImage("", "Ic_Medal", imgTop.img.x + imgTop.img.width + 10, imgTop.img.y + imgTop.img.height + 13).SetScaleXY(0.3);
			var txtFormat:TextFormat = new TextFormat("arial", 20, 0xffffff, true);
			labelNormalBall = AddLabel("", 184, 90, 0xffffff, 1, 0x000000);
			labelNormalBall.defaultTextFormat = txtFormat;
			labelVipBall = AddLabel("", 200 + 295, 90, 0xffffff, 1, 0x000000);
			txtFormat.color = 0xffff00;
			labelVipBall.defaultTextFormat = txtFormat;
			imageCountGift = AddImage("", "ImgBgWarCount", btnPrediction.img.x + 182, btnPrediction.img.y + 15);
			imageCountGift.SetScaleXY(0.5);
			imageCountGift.img.visible = false;
			labelCountGift = AddLabel("", btnPrediction.img.x + 81, btnPrediction.img.y-3, 0xffffff, 2, 0x000000);
			
			//Thông tin lịch thi đấu
			ctnFixture = AddContainer("", "GuiEventEuro_PageFixtureBg", 31, 184);
			listFixture = ctnFixture.AddListBox(ListBox.LIST_Y, 2, 1, 20, 25);
			listFixture.setPos(20, 7);
			//Thông tin các trận đã dự đoán
			ctnPrediction = AddContainer("", "GuiEventEuro_PageFixtureBg", 31, 184);
			ctnPrediction.SetVisible(false);
			listPrediction = ctnPrediction.AddListBox(ListBox.LIST_Y, 2, 1, 20, 25);
			listPrediction.setPos(20, 7);
			scrollBar = AddScroll("", "GuiEventEuro_ScrollBar", 670 + 20, 90 + 101);
			scrollBar.setScrollImage(listFixture.img, 0, 320);
			scrollBar.img.scaleX = scrollBar.img.scaleY = 0.95;
			scrollBar.visible = false;
			dataFixture = new Array();
			dataPrediction = new Array();
			//Thông tin top user
			ctnTop = AddContainer("", "GuiEventEuro_PageTopBg", 28, 175);
			ctnTop.SetVisible(false);
			
			loadContentComplete = true;
			if (loadDataComplete)
			{
				updateData(dataServer);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var config:Object;
			var cost:int;
			switch(buttonID)
			{
				case BTN_BUY_NORMAL_BALL:
					GuiMgr.getInstance().guiBuyBalls.showGUI("ORD", function f(num:int, priceType:String):void
					{
						if (num > 0)
						{
							config = ConfigJSON.getInstance().GetItemList("Param");
							config = config["EventEuro"]["BuyBall"]["ORD"][priceType];
							cost = Number(config) * num;
							if(priceType == "ZMoney")
							{
								if (cost <= GameLogic.getInstance().user.GetZMoney())
								{
									numBuyZMoneyOrd -= num;
									Exchange.GetInstance().Send(new SendBuyBall("ORD", num, priceType));
									numNormalBall += num;
									
									GameLogic.getInstance().user.UpdateUserZMoney( -cost);
									EffectMgr.setEffBounceDown("+" + num + " bóng thường", "Ic_ORDBall", 367, 200);
								}
								else
								{
									GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
								}
							}
							else
							if (priceType == "Money")
							{
								if (cost <= GameLogic.getInstance().user.GetMoney())
								{
									numBuyGoldOrd -= num;
									Exchange.GetInstance().Send(new SendBuyBall("ORD", num, priceType));
									numNormalBall += num;
									
									GameLogic.getInstance().user.UpdateUserMoney( -cost);
									EffectMgr.setEffBounceDown("+" + num + " bóng thường", "Ic_ORDBall", 367, 200);
								}
								else
								{
									GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ tiền vàng");
								}
							}
						}
					});
					break;
				case BTN_BUY_VIP_BALL:
					GuiMgr.getInstance().guiBuyBalls.showGUI("VIP", function f(num:int, priceType:String):void
					{
						if (num > 0)
						{
							config = ConfigJSON.getInstance().GetItemList("Param");
							config = config["EventEuro"]["BuyBall"]["VIP"][priceType];
							cost = Number(config) * num;
							if(priceType == "ZMoney")
							{
								numBuyZMoneyVip -= num;
								if (cost <= GameLogic.getInstance().user.GetZMoney())
								{
									Exchange.GetInstance().Send(new SendBuyBall("VIP", num, priceType));
									numVipBall += num;
									
									GameLogic.getInstance().user.UpdateUserZMoney( -cost);
									EffectMgr.setEffBounceDown("+" + num + " bóng vàng", "Ic_VIPBall", 367, 200);
								}
								else
								{
									GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
								}
							}
							else
							if (priceType == "Diamond")
							{
								numBuyDiamondVip -= num;
								if (cost <= GameLogic.getInstance().user.getDiamond())
								{
									Exchange.GetInstance().Send(new SendBuyBall("VIP", num, priceType));
									numVipBall += num;
									
									GameLogic.getInstance().user.updateDiamond( -cost);
									EffectMgr.setEffBounceDown("+" + num + " bóng vàng", "Ic_VIPBall", 367, 200);
								}
								else
								{
									GuiMgr.getInstance().guiNoDiamond.Show(Constant.GUI_MIN_LAYER, 3);
								}
							}
						}
					});
					break;
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_TAB_FIXTURE:
				case BTN_TAB_PREDICTION:
				case BTN_TAB_TOP:
					showTab(buttonID);
					break;
				default:
					if (buttonID.search(BTN_GET_TOP_GIFT) >= 0)
					{
						GuiMgr.getInstance().guiChooseElementEuro.showGUI(function f(element:int):void
						{
							Exchange.GetInstance().Send(new SendRecieveGiftEuro("Top", 0, element));
							ctnTop.GetButton(buttonID).SetEnable(false);
							var giftName:String = ctnTop.GetContainer(CTN_TOP_GIFT + "_" + euroAchieved).ImgName;
							var feedType:String = "EventEuro" + euroAchieved;
							if (euroAchieved == 5)
							{
								feedType = "";
							}
							GuiMgr.getInstance().guiEuroRewards.showGUI(giftName, null, feedType);
						});
					}
					break;
					
			}
		}
		
		public function updateData(data:Object):void
		{
			waitingMovie.visible = false;
			numNormalBall = data["Balls"]["ORD"];
			numVipBall = data["Balls"]["VIP"];
			dataFixture = data["Fixtures"]["NextMatches"];
			dataPrediction = data["Fixtures"]["BettedMatchesInfo"];
			dataTop = data["Top10"];
			numMedal = data["Medal"];
			lastPosition = data["LastPosInTop"];
			euroAchieved = data["EuroAchieved"];
			gotAchieved = data["GotAchieved"];
			champion = data["Champion"];
			numBuyGoldOrd = data["RetainMoneyBuyOrdBall"];
			numBuyZMoneyOrd = data["RetainZMoneyBuyOrdBall"];
			numBuyZMoneyVip = data["RetainZMoneyBuyVipBall"];
			numBuyDiamondVip = data["RetainDiamondBuyVipBall"];
			
			
			//Sap xep tran theo thoi gian
			arrFixture = new Array();
			var s:String;
			var obj:Object;
			var i:int;
			for (s in dataFixture)
			{
				obj = dataFixture[s];
				obj["MatchId"] = int(s);
				arrFixture.push(obj);
				//trace(obj["MatchTimeBegin"]);
			}
			arrFixture.sortOn(["MatchTimeBegin"], Array.CASEINSENSITIVE | Array.NUMERIC);
			
			arrPrediction = new Array();
			for (s in dataPrediction)
			{
				obj = dataPrediction[s];
				obj["MatchId"] = int(s);
				arrPrediction.push(obj);
			}
			arrPrediction.sortOn(["MatchTimeBegin"], Array.CASEINSENSITIVE | Array.NUMERIC);
			
			if(loadContentComplete)
			{
				refreshGUI();
				showTab(BTN_TAB_FIXTURE);
			}
		}
		
		public function refreshGUI():void
		{
			var i:int;
			var itemFixture:ItemFixture;
			
			listFixture.removeAllItem();
			if (champion == null || champion == "")
			{
				//for (i in dataFixture)
				for ( i = 0; i < arrFixture.length; i++)
				{
					//Khởi tạo trận đấu
					itemFixture = new ItemFixture(listFixture.img);
					itemFixture.initFixture(int(arrFixture[i]["MatchId"]), arrFixture[i]);
					if(arrFixture[i]["Goal"] != null && arrFixture[i]["Goal"].length > 0)
					{
						itemFixture.setResult(arrFixture[i]["Goal"][0], arrFixture[i]["Goal"][1], arrFixture[i]["Penalty"]);
					}
					//Set thông tin nếu đã đặt cược
					//for (var j:String in dataPrediction)
					for (var j:int = 0; j < arrPrediction.length; j++)
					{
						if (arrFixture[i]["MatchId"] == arrPrediction[j]["MatchId"])
						{
							//Thông tin cược
							itemFixture.setPrediction(arrPrediction[j]["BetInfo"]["Bet"], arrPrediction[j]["BetInfo"]["BallNum"], arrPrediction[j]["BetInfo"]["BetType"]);
							//Nếu chưa nhận quà
							if(arrFixture[i]["Goal"] != null && arrFixture[i]["Goal"].length > 0)
							{
								if (!arrPrediction[j]["BetInfo"]["GotGift"])
								{
									//Quà thua
									if (arrPrediction[j]["BetInfo"]["Result"] == 2)
									{
										itemFixture.setGift(false);
									}
									else
									//Quà thắng
									if (arrPrediction[j]["BetInfo"]["Result"] == 1)
									{
										itemFixture.setGift(true);
									}
								}
								//Nhận quà rồi
								else
								{
									itemFixture.enable = false;
								}
							}
							break;
						}
					}
					listFixture.addItem(i.toString(), itemFixture);
				}
			}
			else
			{
				ctnFixture.ClearComponent();
				listFixture = ctnFixture.AddListBox(ListBox.LIST_Y, 2, 1, 20, 25);
				listFixture.setPos(20, 7);
				ctnFixture.AddImage("", "GuiEventEuro_IcLogo", 100, 100);
				txtFormat = new TextFormat("arial", 28, 0xffffff, true);
				ctnFixture.AddLabel(Localization.getInstance().getString(champion), 296, 231, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
				ctnFixture.AddImage("", "Flag_" + champion, 321, 301).SetScaleXY(1.5);
				ctnFixture.AddImage("", "GuiEventEuro_UserBg", 571, 108);
				if (dataTop != null && dataTop[1] != null)
				{
					var topUser:Object = dataTop[1];
					txtFormat.size = 14;
					if (topUser["Name"] == null)
					{
						topUser["Name"] = "UnknownName";
					}
					ctnFixture.AddLabel(Ultility.StandardString(topUser["Name"], 20), 526, 145, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
					if(topUser["AvatarPic"] == null || topUser["AvatarPic"] == "")
					{
						topUser["AvatarPic"] = Main.staticURL + "/avatar.png";
					}
					var avatarImage:AvatarImage = new AvatarImage(ctnFixture.img, topUser["AvatarPic"], 571 - 23, 108 - 34);
					ctnFixture.AddImage("", "Effect_Champion", 600 - 6, 400 + 45).img.mouseEnabled = false;
				}
			}
			
			
			countGift = 0;
			listPrediction.removeAllItem();
			//for (i in dataPrediction)
			for (i = 0; i < arrPrediction.length; i++)
			{
				itemFixture = new ItemFixture(listPrediction.img);
				itemFixture.initFixture(int(arrPrediction[i]["MatchId"]), arrPrediction[i]);
				itemFixture.setPrediction(arrPrediction[i]["BetInfo"]["Bet"], arrPrediction[i]["BetInfo"]["BallNum"], arrPrediction[i]["BetInfo"]["BetType"]);
				if(arrPrediction[i]["Goal"] != null && arrPrediction[i]["Goal"].length > 0)
				{
					itemFixture.setResult(arrPrediction[i]["Goal"][0], arrPrediction[i]["Goal"][1], arrPrediction[i]["Penalty"]);
				}
				if (!arrPrediction[i]["BetInfo"]["GotGift"])
				{
					if (arrPrediction[i]["BetInfo"]["Result"] == 2)
					{
						itemFixture.setGift(false);
						countGift ++;
					}
					else
					if (arrPrediction[i]["BetInfo"]["Result"] == 1)
					{
						itemFixture.setGift(true);
						countGift ++;
					}
				}
				else
				{
					itemFixture.enable = false;
				}
				listPrediction.addItem(i.toString(), itemFixture);
			}
			
			
			ctnTop.ClearComponent();
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.text = "Huy chương Euro\nđược thưởng thêm dựa trên mức cược của bạn.\nDùng để đua TOP dự đoán";
			var ctnMedal:Container = ctnTop.AddContainer("", "Ic_Medal", 343 - 28, 24);
			ctnMedal.setTooltip(tooltip);
			ctnMedal.SetScaleXY(0.3);
			var txtFormat:TextFormat = new TextFormat("arial", 19, 0xffffff, true);
			labelMedal = ctnTop.AddLabel(Ultility.StandardNumber(numMedal), 90 + 137, 28, 0xffffff, 1, 0x000000);
			//labelMedal.defaultTextFormat = txtFormat;
			//labelMedal.setTextFormat(txtFormat);
			var position:String = Ultility.StandardNumber(lastPosition);
			if (lastPosition >= 101)
			{
				position = "Ngoài TOP 100";
			}
			labelLastPost = ctnTop.AddLabel(position, 457, 28, 0xffffff, 1, 0x000000);
			labelLastPost.defaultTextFormat = txtFormat;
			for(var s:String in dataTop)
			{
				var y:Number =100;
				var scale:Number = 0.6;
				if (int(s) == 1)
				{
					txtFormat.size = 20;
					scale = 1;
				}
				else if (int(s) == 2)
				{
					txtFormat.size = 18;
					y = 106;
					scale = 0.8;
				}
				else
				{
					y = 107;
					txtFormat.size = 15;
				}
				ctnTop.AddImage("", "Number_" + s, 45, y + int(s) * 28, true, ALIGN_LEFT_TOP).SetScaleXY(scale);
				if (dataTop[s]["Name"] == null)
				{
					dataTop[s]["Name"] = "UnknownName";
				}
				var labelName:TextField = ctnTop.AddLabel(Ultility.StandardString(dataTop[s]["Name"]), 82, y + int(s) * 28, 0xffff00, 0, 0x000000);
				txtFormat.color = 0xfffffff;
				labelName.setTextFormat(txtFormat);
				txtFormat.color = 0xffff00;
				var labelUserMedal:TextField = ctnTop.AddLabel(Ultility.StandardNumber(dataTop[s]["Medal"]),  177, y + int(s) * 28, 0xffffff, 2, 0x000000);
				labelUserMedal.setTextFormat(txtFormat);
			}
			for (var k:int = 1; k <= 5; k++)
			{
				ctnTop.AddContainer(CTN_TOP_GIFT + "_" + k, "GuiEventEuro_TopGift" + k, 533, 41 + 61*k, true, this).FitRect(70, 70, new Point(515, 33 + 61*k));
			}
			
			for (var h:int = 1; h <= 5; h++)
			{
				var btn:Button = ctnTop.AddButton(BTN_GET_TOP_GIFT + "_" + h, "BtnNhanThuong", 578, 59 + h*62, this);
				btn.img.scaleX = btn.img.scaleY = 0.5;
				if (h == euroAchieved && euroAchieved < 6 && euroAchieved > 0 && !gotAchieved)
				{
					btn.SetEnable(true);
				}
				else
				{
					btn.SetEnable(false);
				}
			}
		}
		
		public function showTab(tabName:String):void
		{
			var i:String;
			var itemFixture:ItemFixture;
			switch(tabName)
			{
				case BTN_TAB_FIXTURE:
					btnFixture.SetFocus(true);
					btnPrediction.SetFocus(false);
					btnTop.SetFocus(false);
					
					if (listFixture != null && listFixture.img != null)
					{
						scrollBar.setScrollImage(listFixture.img, 0, 320);
						if (listFixture.itemList.length < 3)
						{
							scrollBar.img.visible = false;
						}
						else
						{
							scrollBar.img.visible = true;
						}
					}
					ctnFixture.SetVisible(true);
					ctnPrediction.SetVisible(false);
					ctnTop.SetVisible(false);
					break;
				case BTN_TAB_PREDICTION:
					btnFixture.SetFocus(false);
					btnPrediction.SetFocus(true);
					btnTop.SetFocus(false);
					
					if (listPrediction != null && listPrediction.img != null)
					{
						scrollBar.setScrollImage(listPrediction.img, 0, 320);
						if (listPrediction.itemList.length < 3)
						{
							scrollBar.img.visible = false;
						}
						else
						{
							scrollBar.img.visible = true;
						}
					}
					ctnFixture.SetVisible(false);
					ctnPrediction.SetVisible(true);
					ctnTop.SetVisible(false);
					break;
				case BTN_TAB_TOP:
					btnFixture.SetFocus(false);
					btnPrediction.SetFocus(false);
					btnTop.SetFocus(true);
					scrollBar.img.visible = false;
					
					ctnFixture.SetVisible(false);
					ctnPrediction.SetVisible(false);
					ctnTop.SetVisible(true);
					break;
			}
		}
		
		public function addPredictionData(matchId:int, data:Object):void
		{
			if (dataPrediction == null)
			{
				dataPrediction = new Object();
			}
			dataPrediction[matchId] = data;
			var obj:Object = data;
			obj["MatchId"] = matchId;
			arrPrediction.push(obj);
			refreshGUI();
		}
		
		public function setGotGift(data:Object):void
		{
			for each(var prediction:Object in arrPrediction)
			{
				if (data["MatchId"] == prediction["MatchId"])
				{
					prediction["BetInfo"]["GotGift"] = true;
					return;
				}
			}
		}
		
		public function get numNormalBall():int 
		{
			return _numNormalBall;
		}
		
		public function set numNormalBall(value:int):void 
		{
			_numNormalBall = value;
			if(labelNormalBall != null)
			{
				labelNormalBall.text = Ultility.StandardNumber(value);
			}
		}
		
		public function get numVipBall():int 
		{
			return _numVipBall;
		}
		
		public function set numVipBall(value:int):void 
		{
			_numVipBall = value;
			if(labelVipBall != null)
			{
				labelVipBall.text = Ultility.StandardNumber(value);
			}
		}
		
		public function get numMedal():int 
		{
			return _numMedal;
		}
		
		public function set numMedal(value:int):void 
		{
			_numMedal = value;
			if(labelMedal != null)
			{
				labelMedal.text = Ultility.StandardNumber(value);
			}
		}
		
		public function get countGift():int 
		{
			return _countGift;
		}
		
		public function set countGift(value:int):void 
		{
			_countGift = value;
			if(value > 0)
			{
				labelCountGift.text = value.toString();
				imageCountGift.img.visible = true;
			}
			else
			{
				imageCountGift.img.visible = false;
				labelCountGift.text = "";
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_TOP_GIFT) >= 0)
			{
				var giftLevel:int = buttonID.split("_")[1];
				//var configGift:Object = ConfigJSON.getInstance().GetItemList("EventEuro_TopGifts");
				//configGift = configGift[giftLevel];
				//GuiMgr.getInstance().guiGiftTooltip.showGUI(event.stageX, event.stageY, configGift);
				
				GuiMgr.getInstance().guiTooltipTopUser.showGUI("GuiEventEuro_TooltipGift" + giftLevel, event.stageX, event.stageY);
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_TOP_GIFT) >= 0)
			{
				GuiMgr.getInstance().guiTooltipTopUser.Hide();
				//GuiMgr.getInstance().guiGiftTooltip.Hide();
			}
		}
	}

}