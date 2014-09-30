package GUI.ChampionLeague.GuiLeague 
{
	import Data.ConfigJSON;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.ChampionLeague.GuiLeague.itemGui.ItemPlayer;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.ChampionLeague.LogicLeague.Player;
	import GUI.ChampionLeague.PackageLeague.SendBuyCard;
	import GUI.ChampionLeague.PackageLeague.SendRefreshBoard;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Image;
	import GUI.component.ImageDigit;
	import GUI.component.TooltipFormat;
	import GUI.GuiGetStatus.SendGetStatus;
	import GUI.GuiMgr;
	import GUI.GUINoneAbstract.GUINoneAbstract;
	import GUI.GUITopInfo;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	import Logic.User;
	
	/**
	 * cái gui chứa danh sách người chơi, xổ xuống và xổ lên
	 * @author HiepNM2
	 */
	public class GUIRank extends GUINoneAbstract 
	{
		private const ID_CTN_NUMCARD:String = "idCtnNumcard";
		private const ID_BTN_GUIDE:String = "idBtnGuide";
		private const ID_BTN_HOME:String = "idBtnHome";
		private const ID_BTN_REFRESH:String = "idBtnRefresh";
		private const ID_BTN_BUYCARD:String = "idBtnBuycard";
		private var tfTimeUpdate:TextField;
		public var tfNumCard:TextField;
		private var tfPrice:TextField;
		private var btnBackHome:Button;
		private var btnGuide:Button;
		private var ctnNumCard:Image;
		private var btnBuyCard:Button;
		private var btnRefresh:Button;
		private var _listItemPlayer:Array=[];
		
		private var yCtn:int;
		private var isClicked:Boolean = false;
		public var inRefresh:Boolean;
		public var remainTimeBeforeCoolDown:int;
		public var remainTimeBeforeWaitRefresh:int;
		public var inAutoRefresh:Boolean;
		
		[Embed(source = '../../../../content/dataloading.swf', symbol = 'DataLoading')]
		private var DataLoading:Class;
		private var WaitData:Sprite = new DataLoading();
		
		
		public function GUIRank(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIRank";
			ShiftFromInitGui = true;
			_xScr = _xDes = 0;
			_yScr = -600;
			_yDes = -40;
			_yGui = 27;
			_xGui = 540;
			_wMask = 270;
			_hMask = 590;
			_themeName = "GuiLeague_GuiRankTheme";
			_bgName = "GuiLeague_GuiRankTheme";
		}
		
		override protected function onInitGui():void 
		{
			ctnBg.AddImage("", "GuiLeague_ImgDayXich", 148, -23);
			btnRefresh = AddButton(ID_BTN_REFRESH, "GuiLeague_BtnRefresh", 92, -18);
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = "Cập nhật bảng xếp hạng";
			btnRefresh.setTooltip(tip);
			btnBackHome = AddButton(ID_BTN_HOME, "GuiLeague_BtnHome", 190, -22);
			tip = new TooltipFormat();
			tip.text = "Trở về nhà";
			btnBackHome.setTooltip(tip);
			btnGuide = AddButton(ID_BTN_GUIDE, "GuiLeague_BtnGuide", 145, -18);
			tip = new TooltipFormat();
			tip.text = "Hướng dẫn";
			btnGuide.setTooltip(tip);
			addTimeUpdate();
			addAllItemPlayer();
			addBuyCardCtn();
			LeagueInterface.getInstance().showSomeButton();
			this.img.mouseEnabled = false;
			var isWaitRefresh:Boolean = LeagueMgr.getInstance().IsWaitRefresh;
			btnRefresh.SetEnable(!isWaitRefresh);
			
			drawRankInGuiMainLeague();
			var rank:int = LeagueMgr.getInstance().MyPlayer.Rank;
			GuiMgr.getInstance().guiFrontScreen.labelSeriesFighting.text = LeagueController.rankText(rank);
		}
		
		override protected function onFinishShowGui():void 
		{
			//Thực hiện hiển thị con cá _mySoldier trong LeagueInterface
			if (!LeagueInterface.getInstance().IsGotoLegueOk)//trường hợp chưa vào xong liên đấu
			{
				if (!LeagueMgr.getInstance().receivedCard && LeagueMgr.getInstance().MyPlayer.SoldierId > 0) 
				{
					LeagueInterface.getInstance().guiDailyGift.Show(Constant.GUI_MIN_LAYER, 5);
				}
				if (LeagueMgr.getInstance().MyPlayer.SoldierId > 0)
				{
					var _mySoldier:FishSoldier = LeagueMgr.getInstance().getChooseSoldier();
					LeagueInterface.getInstance().guiInfoMe.isMe = true;
					LeagueInterface.getInstance().guiInfoMe.damage = _mySoldier.getTotalDamage();
					LeagueInterface.getInstance().guiInfoMe.defence = _mySoldier.getTotalDefence();
					LeagueInterface.getInstance().guiInfoMe.critical = _mySoldier.getTotalCritical();
					LeagueInterface.getInstance().guiInfoMe.vitality = _mySoldier.getTotalVitality();
					LeagueInterface.getInstance().guiInfoMe.Show();
				}
				if (LeagueMgr.getInstance().hasGiftTop)//nếu có quà
				{
					var guiGiftRank:GUIGiftRank = new GUIGiftRank(null, "");
					guiGiftRank.initData(LeagueMgr.getInstance().ListGiftTop);
					guiGiftRank.Show(Constant.GUI_MIN_LAYER, 5);
					guiGiftRank.drawTopInfo();
				}
				if (LeagueMgr.getInstance().MyPlayer.SoldierId > 0)//có ngư thủ
				{
					LeagueInterface.getInstance().showSoldier();
				}
				else
				{
					LeagueInterface.getInstance().IsGotoLegueOk = true;
				}
			}
			LeagueInterface.getInstance().showGuiVersus();
		}
		/**
		 * add vào nhãn thời gian cập nhật bảng xếp hạng
		 */
		private function addTimeUpdate():void 
		{
			tfTimeUpdate = AddLabel("", 50, 16, 0xffffff, 1, 0x000000);
			tfTimeUpdate.visible = false;
			resetTimeUpdate();
		}
		/**
		 * add tất cả các itemplayer vào gui
		 */
		private function addAllItemPlayer():void 
		{
			var PlayerArr:Array = LeagueMgr.getInstance().ListPlayer;
			var x:int = 0;
			yCtn = 68;
			_listItemPlayer.splice(0, _listItemPlayer.length);
			for (var i:int = 0; i < PlayerArr.length; i++) {
				var player:Player = PlayerArr[i] as Player;
				addPlayer(player, x, yCtn);
				yCtn += 68;
			}
		}
		/**
		 * add từng itemPlayer vào GUI
		 * @param	player : Player đó
		 * @param	x : tọa độ x đặt item
		 * @param	y : tọa độ y đặt item
		 */
		private function addPlayer(player:Player, x:int, y:int):void 
		{
			//var itemPlayer:ItemPlayer = new ItemPlayer(this.img, "KhungFriend", x, y);
			var itemPlayer:ItemPlayer = new ItemPlayer(ctnBg.img, "GuiLeague_ItmPlayerSelect", x, y);
			itemPlayer.EventHandler = this;
			itemPlayer.initData(player);
			itemPlayer.drawItem();
			_listItemPlayer.push(itemPlayer);
		}
		/**
		 * vẽ vùng có nút buy G
		 */
		private function addBuyCardCtn():void 
		{
			ctnNumCard = ctnBg.AddImage("", "GuiLeague_ImgBottonTable", 23, yCtn + 14, true, ALIGN_LEFT_TOP);
			var ctnCard:ButtonEx = ctnBg.AddButtonEx(ID_CTN_NUMCARD, "GuiLeague_CtnNumCard", 33, yCtn + 22);
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = "Ngư lệnh";
			ctnCard.setTooltip(tip);
			
			tfNumCard = ctnBg.AddLabel("0", 60, yCtn + 34, 0xffffff, 1, 0x000000);
			tfNumCard.text = Ultility.StandardNumber(LeagueMgr.getInstance().NumCard);
			btnBuyCard = ctnBg.AddButton(ID_BTN_BUYCARD, "GuiLeague_BtnBuy", 168, yCtn + 27);
			btnBuyCard.EventHandler = this;
			var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["BuyToken"]["1"]["ZMoney"];
			tfPrice = ctnBg.AddLabel(price.toString(), 175, yCtn + 33, 0xffffff, 1, 0x000000);
			tfPrice.mouseEnabled = false;
		}
		
		/**
		 * cập nhật gui nếu có cooldown
		 */
		public function updateForCoolDown(remainTime:int):void
		{
			var tickcountCoolDown:int = remainTimeBeforeCoolDown - remainTime;
			if (remainTimeBeforeCoolDown == 0)
			{
				remainTimeBeforeCoolDown = remainTime;
			}
			if (tickcountCoolDown >= 1 || tickcountCoolDown<0)
			{
				for (var i:int = 0; i < _listItemPlayer.length; i++)
				{
					var iPlayer:ItemPlayer = _listItemPlayer[i] as ItemPlayer;
					iPlayer.UpdateItem(remainTime);
				}
				remainTimeBeforeCoolDown = remainTime;
			}
		}
		/**
		 * cập nhật gui nếu đang đợi enable nút refresh
		 */
		public function updateForWaitRefresh(remainTime:int):void 
		{
			var tickcountWaitRefresh:int = remainTimeBeforeWaitRefresh - remainTime;
			if (remainTimeBeforeWaitRefresh == 0) 
			{
				remainTimeBeforeWaitRefresh = remainTime;
			}
			if (tickcountWaitRefresh >= 1)
			{
				var isWaitRefresh:Boolean = LeagueMgr.getInstance().IsWaitRefresh;
				if (isWaitRefresh)
				{
					tfTimeUpdate.text = Ultility.convertToTime(remainTime, false);
				}
				remainTimeBeforeWaitRefresh = remainTime;
			}
		}
		
		public function changeToAttackMode():void 
		{
			for (var i:int = 0; i < _listItemPlayer.length; i++)
			{
				var iPlayer:ItemPlayer = _listItemPlayer[i] as ItemPlayer;
				iPlayer.changeToAttackMode();
			}
		}
		
		public function changeToWaitMode():void 
		{
			for (var i:int = 0; i < _listItemPlayer.length; i++)
			{
				var iPlayer:ItemPlayer = _listItemPlayer[i] as ItemPlayer;
				iPlayer.changeToWaitMode();
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (!LeagueInterface.getInstance().IsGotoLegueOk)
			{
				return;
			}
			var curTime:Number;
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			switch(command)
			{
				case ID_BTN_HOME:
					if (LeagueController.getInstance().isWaitReponseGift)//nếu đang đợi gói nhận quà về
					{
						return;
					}
					if (!inRefresh && !inAutoRefresh)
					{
						if (LeagueInterface.getInstance().IsGotoLegueOk)//nếu đã vào liên đấu thành công thì mới được về nhà
						{
							btnBackHome.enable = false;
							LeagueMgr.getInstance().goBackHome();
						}
					}
				break;
				case ID_BTN_REFRESH:
					if (LeagueInterface.getInstance().IsGotoLegueOk)
					{
						if (btnBackHome.enable)
						{
							curTime = GameLogic.getInstance().CurServerTime;
							if (LeagueMgr.getInstance().isLockForUpdate(curTime))
							{//không cho ấn refresh trong 5 phút từ 9h55 đến 10h00
								GuiMgr.getInstance().GuiMessageBox.ShowOK("Hệ thống đang sắp xếp trao giải...", 310, 200, 1);
								return;
							}
							
							var timeDuration:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["CoolDown"]["RefreshBoard"];
							if (curTime-LeagueController.getInstance().timeRefresh <= timeDuration)
							{
								GuiMgr.getInstance().GuiMessageBox.ShowOK("Hệ thống vừa tự động cập nhật danh sách\n Bạn đợi 5 giây để cập nhật tiếp", 310, 200, 1);
							}
							else
							{
								inRefresh = true;
								btnRefresh.SetDisable();
								refreshPlayer();
							}
						}
					}
				break;
				case ID_BTN_GUIDE:
					if (LeagueController.getInstance().isWaitReponseGift || 
							inRefresh || inAutoRefresh)
					{
						return;
					}
					var guiGuide:GuiLeagueGuide = LeagueInterface.getInstance().guiLeagueGuide;
					guiGuide.Show(Constant.GUI_MIN_LAYER, 5);
				break;
				case ItemPlayer.CMD_FIGHT_CARD:
					if (LeagueMgr.getInstance().IsLimitedFight())
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã hết số lần đánh trong ngày");
						return;
					}
					if (!LeagueInterface.getInstance().IsGotoLegueOk)
					{
						return;
					}
					if (LeagueController.getInstance().isWaitReponseGift)//nếu đang đợi gói nhận quà về
					{
						return;
					}
					curTime = GameLogic.getInstance().CurServerTime;
					var rank:int = int(data[1]);
					var myPlayer:Player = LeagueMgr.getInstance().MyPlayer;
					if (myPlayer.SoldierId <= 0)
					{
						if (myPlayer.Rank != rank)
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn chưa có ngư thủ!\nHãy trang bị ngư thủ để tham gia liên đấu nhé!", 310, 200, 1);
						}
						return;
					}
					if (LeagueMgr.getInstance().isLockForUpdate(curTime))
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Hệ thống đang sắp xếp trao giải...", 310, 200, 1);
						return;
					}
					if (!LeagueController.getInstance().IsBuying)
					{
						var myRank:int = LeagueMgr.getInstance().MyPlayer.Rank;
						var soldier:FishSoldier = LeagueMgr.getInstance().getChooseSoldier();
						var expired:Boolean = false;
						var remainTime:Number = soldier.LifeTime - (GameLogic.getInstance().CurServerTime - soldier.OriginalStartTime) ;
						expired = false;/*remainTime < 0;*/
						if (expired) {
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Ngư thủ của bạn đã già\n vui lòng hồi sinh hoặc đổi ngư thủ", 310, 200, 1);
							break;
						}
						if (myRank > rank)//không cho đánh mình và người có rank thấp hơn mình
						{
							var numCard:int = LeagueMgr.getInstance().NumCard;
							if (numCard > 0)
							{
								if (!LeagueMgr.getInstance().IsCoolDown)
								{
									if (!isClicked)
									{
										isClicked = true;
										if (btnBackHome.enable)
										{
											btnBackHome.enable = false;
											if (!inRefresh && !inAutoRefresh)
											{
												LeagueMgr.getInstance().startFight(rank);
											}
											
										}
									}
								}
								else 
								{
									if(LeagueInterface.getInstance().IsCompleteStartWarScene)
										GuiMgr.getInstance().GuiMessageBox.ShowOK("Đợi hết thời gian để chiến đấu tiếp", 310, 200, 1);
								}
							}
							else 
							{
								if(!isClicked)
									GuiMgr.getInstance().GuiMessageBox.ShowOK("Không có ngư lệnh");
							}
						}
						else {
							if (myRank != rank) {
								GuiMgr.getInstance().GuiMessageBox.ShowOK("Không đánh được đối thủ thấp hơn", 310, 200, 1);
							}
							
						}
					}
				break;
				case ID_BTN_BUYCARD:
					trace("mua ngư lệnh");
					var user:User = GameLogic.getInstance().user;
					var myZMoney:int = user.GetZMoney();
					if (myZMoney > 0)
					{
						var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["BuyToken"]["1"]["ZMoney"];
						if (myZMoney >= price)
						{
							buyCard(user, myZMoney, price);
						}
						else
						{
							GuiMgr.getInstance().GuiNapG.Init();
						}
					}
					else
					{
						GuiMgr.getInstance().GuiNapG.Init();
					}
					//thực hiện + num card
				break;
			}
		}

		/**
		 * 
		 */
		private function buyCard(user:User, myZMoney:int, price:int):void 
		{
			//gửi gói tin mua lên server
			LeagueController.getInstance().IsBuying = true;		//không cho việc đánh nhau xảy ra khi chưa mua xong
			var pk:SendBuyCard = new SendBuyCard();
			Exchange.GetInstance().Send(pk);
			//trừ G của người chơi
			user.UpdateUserZMoney(0 - price);
			//cập nhật số lượng thẻ vào cho user
			LeagueMgr.getInstance().NumCard++;
			user.UpdateStockThing("OccupyToken", 1, 1);
			tfNumCard.text = Ultility.StandardNumber(LeagueMgr.getInstance().NumCard);
			// effect
			var txtFormat:TextFormat = new TextFormat("Arial", 24, 0xffffff, true);
			txtFormat.align = "left";
			txtFormat.font = "SansationBold";
			var st:String = "+ 1";
			var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E, true);
			var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
			eff.SetInfo(610, 420, 610, 365, 4);
			var xdes:int = Constant.STAGE_WIDTH / 2;
			var ydes:int = Constant.STAGE_HEIGHT / 2;
			EffectMgr.setEffBounceDown("Mua thành công", "GuiLeague_ImgCard", xdes, ydes);
		}
		
		/**
		 * thực hiện refresh bảng player
		 */
		public function refreshPlayer():void 
		{
			img.addChild(WaitData);
			WaitData.x = img.width / 2 + 20;
			WaitData.y = img.height / 2 - 30;
			LeagueInterface.getInstance().IsDataRefreshReady = false;
			var pk:SendRefreshBoard = new SendRefreshBoard(false);
			Exchange.GetInstance().Send(pk);
		}
		
		public function refreshOk():void
		{
			refreshComp();
			inRefresh = false;
		}
		public function refreshComp():void
		{
			RemoveAllItemPlayer();
			ctnBg.RemoveImage(ctnNumCard);
			ctnBg.RemoveButtonEx(ID_CTN_NUMCARD);
			ctnBg.RemoveButton(ID_BTN_BUYCARD);
			removeLabel(tfNumCard);
			removeLabel(tfPrice);
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			
			addAllItemPlayer();
			addBuyCardCtn();
			//add rank cho cá ở đây
			drawRankInGuiMainLeague();
		}
		
		public function RefreshEnable(enable:Boolean=true):void 
		{
			btnRefresh.SetEnable(enable);
			tfTimeUpdate.visible = !enable;
			remainTimeBeforeWaitRefresh = 0;
		}
		
		public function resetTimeUpdate():void
		{
			var timeDuration:int = ConfigJSON.getInstance().getItemInfo("Param")["Occupy"]["CoolDown"]["RefreshBoard"];
			tfTimeUpdate.text = Ultility.convertToTime(timeDuration, false);
		}
		
		override protected function onAfterHideGui():void 
		{
			if (LeagueController.getInstance().mode == LeagueController.IN_HOME) {
				LeagueInterface.getInstance().recoverHome();
			}
			else//trong liên đấu
			{
				if (LeagueInterface.getInstance().IsCompleteStartWarScene == false)
				{
					LeagueInterface.getInstance().onCompleteStartWarScene();
				}
			}
			isClicked = false;
		}
		
		/**
		 * xóa bỏ tất cả itemplayer
		 */
		private function RemoveAllItemPlayer():void
		{
			var i:int;
			var length:int = _listItemPlayer.length;
			for (i = 0; i < length; i++)
			{
				var iPlayer:ItemPlayer = _listItemPlayer[i] as ItemPlayer;
				iPlayer.Destructor();
				iPlayer = null;
			}
			_listItemPlayer.splice(0, length);
		}
		private function removeLabel(textField:TextField):void
		{
			var index:int = ctnBg.LabelArr.indexOf(textField);
			if (index >= 0)
			{
				ctnBg.img.removeChild(textField);
				textField = null;
				ctnBg.LabelArr.splice(index, 1);
			}
			else {
				trace("Không có textfield này");
			}
		}
		override public function ClearComponent():void 
		{
			super.ClearComponent();
			RemoveAllItemPlayer();
		}
		override public function Clear():void 
		{
			super.Clear();
			var propertyGui:Object = {"btnBackHome":0, "btnBuyCard":0, "btnGuide":0, "ctnNumCard":0,
			"tfNumCard":0, "tfPrice":0, "tfTimeUpdate":0};
									
			for (var str:String in propertyGui)
			{
				if (this[str] != null)
					this[str] = null;
				else
					break;
			}
		}
		
		public function autoRefreshOk():void 
		{
			refreshComp();
			inAutoRefresh = false;
		}
		private function drawRankInGuiMainLeague():void
		{
			var imgDigit:ImageDigit = LeagueInterface.getInstance().imgRank;
			var guiMainLeague:GUIMainLeague = GuiMgr.getInstance().guiMainLeague;
			if (imgDigit)
			{
				if (imgDigit.img)
				{
					guiMainLeague.RemoveImageDigit("ImageRank");
				}
			}
			
			var rank:int = LeagueMgr.getInstance().MyPlayer.Rank;
			if (rank > 1000) {
				rank = 1000;
			}
			LeagueInterface.getInstance().imgRank = guiMainLeague.AddImageDigit("ImageRank", rank, 115, 555, "GuiLeague", "Champion");
			if (LeagueMgr.getInstance().MyPlayer.Rank > 1000)
			{
				var res:Sprite = ResMgr.getInstance().GetRes("GuiLeague_ChampionGreater") as Sprite;
				LeagueInterface.getInstance().imgRank.img.addChild(res);
				res.x = -12;
				res.y = 4
			}
			LeagueInterface.getInstance().imgRank.SetScaleXY(1.3);
			var tip:TooltipFormat = new TooltipFormat();
			tip.text = "Thứ hạng của ngư thủ";
			LeagueInterface.getInstance().imgRank.setTooltip(tip);
			LeagueInterface.getInstance().imgRank.SetAlign(ALIGN_CENTER_CENTER);
		}
	}

}






















