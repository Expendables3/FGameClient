package GUI.ChampionLeague.LogicLeague 
{
	import Data.ConfigJSON;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import Event.EventNoel.NoelGui.ShocksNoel;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.ChampionLeague.GuiLeague.GUIDailyGift;
	import GUI.ChampionLeague.GuiLeague.GUIEffVersus;
	import GUI.ChampionLeague.GuiLeague.GUIGiftFight;
	import GUI.ChampionLeague.GuiLeague.GUIGiftLeague;
	import GUI.ChampionLeague.GuiLeague.GUIGiftRank;
	import GUI.ChampionLeague.GuiLeague.GUILeagueFishInfo;
	import GUI.ChampionLeague.GuiLeague.GuiLeagueGuide;
	import GUI.ChampionLeague.GuiLeague.GUIMainLeague;
	import GUI.ChampionLeague.GuiLeague.GUIRank;
	import GUI.ChampionLeague.GuiLeague.itemGui.ProgressBlood;
	import GUI.ChampionLeague.GuiLeague.TableRankGift;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ImageDigit;
	import GUI.component.ProgressBar;
	import GUI.component.SpriteExt;
	import GUI.Event8March.CoralTree;
	import GUI.GUIFishStatus;
	import GUI.GUIFriends;
	import GUI.GUIMain;
	import GUI.GuiMgr;
	import GUI.GUISetting;
	import GUI.GUITopInfo;
	import Logic.Balloon;
	import Logic.Decorate;
	import Logic.Dirty;
	import Logic.EnergyMachine;
	import Logic.FallingObject;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.FishSpartan;
	import Logic.Food;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.QuestMgr;
	import Logic.TuiTanThu;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.SendGetAllSoldier;
	import NetworkPacket.PacketSend.SendInitRun;
	import NetworkPacket.PacketSend.SendRefreshFriend;
	import particleSys.myFish.GhostEmit;
	import Sound.SoundMgr;
	/**
	 * Quản lý việc xử lý giao diện trong liên đấu
	 * 		Load BackGround Liên đấu và Default, sao cho tối ưu nhất
	 * 		Hiển thị 1 số gui phụ thuộc data server
	 * 		QUản lý các gui khác
	 * 		Giải phóng GUI khi thoát khỏi liên đấu
	 * @author HiepNM2
	 */
	public class LeagueInterface 
	{
		// const
		private const ID_CTN_AVATAR:String = "idCtnAvatar";
		private const ID_CTN_AVATARHIM:String = "idCtnAvatarhim";
		private const STANDPOS:Point = new Point(400, 580);
		private const INITPOS:Point = new Point(-400, 580);
		private const HISINITPOS:Point = new Point(2000, 580);
		private const HISSTANDPOS:Point = new Point(1010, 540);
		private const FIGHTPOS:Point = new Point(600, 435);
		private const HISFIGHTPOS:Point = new Point(750, 435);
		// gui
		public var btnChooseSoldier:Button;
		private var ctnAvatar:Container;
		private var imgAvatar:Image;
		private var _listActiveGui:Array = [];
		private var _guiTopInfo:GUIMainLeague;
		public var guiRank:GUIRank = new GUIRank(null, "");
		private var _guiGiftLeague:GUIGiftLeague = new GUIGiftLeague(null, "");
		public var tableRankGift:TableRankGift = new TableRankGift(null, "");
		private var _guiVitality:ProgressBlood = new ProgressBlood(null, "");
		public var guiDailyGift:GUIDailyGift = new GUIDailyGift(null, "");
		public var guiGiftFight:GUIGiftFight = new GUIGiftFight(null, "");
		private var _guiVersus:GUIEffVersus = new GUIEffVersus(null, "");
		public var guiLeagueGuide:GuiLeagueGuide = new GuiLeagueGuide(null, "");
		private var tfLevel:TextField;
		private var ctnAvatarHim:Container;
		//private var tfRank:TextField;
		public var imgRank:ImageDigit;
		
		private var _mySoldier:FishSoldier;
		private var _hisSoldier:FishSoldier;
		
		// logic
		static private var _instance:LeagueInterface = null;
		public var IsDataReady:Boolean = false;	//cờ này giúp xác định việc đã vào liên đâu (= true=> đã vào)
		public var IsDataStatusReady:Boolean = false;
		public var IsDataRefreshReady:Boolean = false;
		private var IsLoadBackGroundComp:Boolean = false;
		public var IsGotoLegueOk:Boolean = false;
		public var isLoadWarEff:Boolean = false;
		public var timeRefreshBySystem:Number = -1;
		
		[Embed(source = '../../../../content/dataloading.swf', symbol = 'DataLoading')]
		private var DataLoading:Class;
		private var WaitData:Sprite = new DataLoading();
		private var IsFinishReceiveGiftFight:Boolean = false;
		public var IsDataWarReady:Boolean;
		public var IsCompleteStartWarScene:Boolean=true;
		
		public var guiInfoMe:GUILeagueFishInfo = new GUILeagueFishInfo(null, "");
		private var guiInfoHim:GUILeagueFishInfo = new GUILeagueFishInfo(null, "");
		
		
		public function LeagueInterface() 
		{
			_guiTopInfo = GuiMgr.getInstance().guiMainLeague;
			_guiTopInfo.Show();
		}
		
		static public function getInstance():LeagueInterface {
			if (_instance == null) {
				_instance = new LeagueInterface();
			}
			return _instance;
		}
		
		/**ultility method**/
		/**
		 * bắt đầu 1 gui mới
		 */
		public function startGui():void 
		{
			/*khởi tạo các cờ Load dữ liệu*/
			IsDataReady = false;
			IsDataRefreshReady = false;
			IsDataStatusReady = false;
			IsLoadBackGroundComp = false;
			
			loadLeagueBackGround();
			loadWarEff();
			//addCircleLoading();
		}
		
		private function loadWarEff():void 
		{
			if (!isLoadWarEff)
			{
				//GuiMgr.getInstance().GuiWaitingContent.Init("LoadingWar");
				ResMgr.getInstance().LoadFileContent("LoadingWar");
			}
		}
		
		/**
		 * thực hiện việc dọn dẹp vào load layer
		 */
		private function loadLeagueBackGround():void
		{
			/** dọn dẹp layer **/
			if (LeagueController.getInstance().key == LeagueController.INVISIBLE)
			{
				setVisibleAllObject(false);//ẩn hết tất cả các đối tượng trên hồ
			}
			else {
				removeAllObject();
				updateGuiTopForLeague();
				
			}
			
			clearBaseLayer();
			/** load Layer **/
			LeagueController.getInstance().homeBgId = GameLogic.getInstance().user.backGround.ItemId;
			loadLayer(Constant.ID_LEAGUE_BACKGROUND);
		}
		/**
		 * xóa toàn bộ object trên hồ:
		 * 		hệ thống gui, các con cá, các đối tượng event...
		 */
		private function removeAllObject():void 
		{
			GameLogic.getInstance().Reset(false);//xóa logic
			//xóa túi tấn thủ
			if (GameLogic.getInstance().user.tuiTanThu)
			{
				GameLogic.getInstance().user.tuiTanThu.Clear();
			}
			GuiMgr.getInstance().GuiStore.Hide();
			GuiMgr.getInstance().GuiMain.Hide();
			GuiMgr.getInstance().GuiFriends.Hide();
			GuiMgr.getInstance().GuiSetting.Hide();
			if (GuiMgr.getInstance().GuiAnnounce.IsVisible) 
			{
				GuiMgr.getInstance().GuiAnnounce.Hide();
			}
			
		}
		
		/**
		 * ẩn hiện các object ở hồ hiện tại
		 */
		private function setVisibleAllObject(isVisible:Boolean = true):void 
		{
			if (!isVisible)
				HelperMgr.getInstance().HideHelper();
			
			/* ẩn hiện các con cá*/
			var user:User = GameLogic.getInstance().user;
			var i:int;
			//máy năng lượng
			if (user.GetMyInfo().hasMachine)
			{
				var machine:EnergyMachine = user.GetMyInfo().energyMachine;
				machine.img.visible = isVisible;
			}
			
			// cá thường
			var FishArr:Array = user.FishArr;			//reference
			for (i = 0; i < FishArr.length; i++)
			{
				var fish:Fish = FishArr[i] as Fish;
				Ultility.setVisibleActiveObject(fish, isVisible);
			}
			// cá spartan
			var FishArrSpartan:Array = user.FishArrSpartan;
			for (i = 0; i < FishArrSpartan.length; i++)
			{
				var fishSparta:FishSpartan = FishArrSpartan[i] as FishSpartan;
				Ultility.setVisibleActiveObject(fishSparta, isVisible);
			}
			var FishArrSpartanDeactive:Array = user.FishArrSpartanDeactive;
			for (i = 0; i < FishArrSpartanDeactive.length; i++)
			{
				var fishSpartanDeactive:FishSpartan = FishArrSpartanDeactive[i] as FishSpartan;
				Ultility.setVisibleActiveObject(fishSpartanDeactive, isVisible);
			}
			
			//cá lính 
			//var FishSoldierArr:Array = user.FishSoldierArr;
			//for (i = 0; i < FishSoldierArr.length; i++)
			//{
				//var soldier:FishSoldier = FishSoldierArr[i] as FishSoldier;
				//Ultility.setVisibleActiveObject(soldier, isVisible);
			//}
			//thì xóa hay tạo lại, chứ ko ẩn hiện
			if (!isVisible) {
				RemoveAllSoldierInCurLake();
			}
			else {
				InitAllSoldierInCurLake();
			}
			/** ẩn hết đồ trang trí **/
			var DecoArr:Array = user.DecoArr;
			for (i = 0; i < DecoArr.length; i++)
			{
				var deco:Decorate = DecoArr[i] as Decorate;
				Ultility.setVisibleActiveObject(deco, isVisible);
			}
			
			/** ẩn các hạt thức ăn chưa rơi hết :D **/
			var FoodArr:Array = user.FoodArr;
			for (i = 0; i < FoodArr.length; i++)
			{
				var food:Food = FoodArr[i] as Food;
				Ultility.setVisibleActiveObject(food, isVisible);
			}
			
			/** ẩn vết bẩn **/
			var DirtyArr:Array = user.DirtyArr;
			for (i = 0; i < DirtyArr.length; i++)
			{
				var dirty:Dirty = DirtyArr[i] as Dirty;
				Ultility.setVisibleActiveObject(dirty, isVisible);
			}
			
			/** an hết những gì đang fall trong game **/
			var fallingObjArr:Array = user.fallingObjArr;
			for (i = 0; i < fallingObjArr.length; i++)
			{
				var mat:FallingObject = fallingObjArr[i] as FallingObject;
				Ultility.setVisibleActiveObject(mat, isVisible);
			}
			
			/*ẩn các bong bóng tiền*/
			var balloonArr:Array = GameLogic.getInstance().balloonArr;
			for (i = 0; i < balloonArr.length; i++)
			{
				var balloon:Balloon = balloonArr[i] as Balloon;
				Ultility.setVisibleActiveObject(balloon, isVisible);
			}
			/**ẩn túi tuân thủ**/
			var bag:TuiTanThu = user.tuiTanThu;
			
			if (bag)
				Ultility.setVisibleActiveObject(bag, isVisible);
			/*coral tree*/
			var coralTree:CoralTree = user.GetMyInfo().coralTree;
			if (coralTree)
				Ultility.setVisibleActiveObject(coralTree, isVisible);
			var shocks:ShocksNoel = user.GetMyInfo().shocksNoel;
			if (shocks)
				Ultility.setVisibleActiveObject(shocks, isVisible);
			
			/*các effect nào còn tồn tại cũng cho đi hết*/
			EffectMgr.getInstance().reset();
			if (isVisible) {
				//hiện lại các gui chính
				trace("hiện lại các gui chính");
				//bật tiếng nếu thoát khỏi liên đấu
				if (GuiMgr.getInstance().GuiSetting.IsNoMusic == false)//nếu lúc trước nó có tiếng
				{
					SoundMgr.getInstance().playBgMusic();
				}
			}
			else {
				hideGuiMain();
				//tắt tiếng nếu vào liên đấu
				if (GuiMgr.getInstance().GuiSetting.IsNoMusic == false) 
				{
					SoundMgr.getInstance().stopBgMusic();
				}
			}
		}
		/**
		 * Xóa hết mảng cá lính (mảng hiển thị) trong hồ hiện tại
		 */
		private function RemoveAllSoldierInCurLake():void 
		{
			var soldier:FishSoldier;
			var user:User = GameLogic.getInstance().user;
			var i:int;
			//mảng cá lính chết
			var FishSoldierExpired:Array = user.FishSoldierExpired;
			for (i = 0; i < FishSoldierExpired.length; i++)
			{
				soldier = FishSoldierExpired[i] as FishSoldier;
				//if (soldier && soldier.img && soldier.img.parent)	soldier.img.parent.removeChild(soldier.img);
				soldier.Destructor();
			}
			FishSoldierExpired.splice(0, FishSoldierExpired.length);
			//mảng cá lính đang bơi
			var FishSoldierArr:Array = user.FishSoldierArr;
			for (i = 0; i < FishSoldierArr.length; i++)
			{
				soldier = FishSoldierArr[i] as FishSoldier;
				soldier.Destructor();
			}
			FishSoldierArr.splice(0, FishSoldierArr.length);
			
			var FishSoldierActorMine:Array = user.FishSoldierActorMine;
			for (i = 0; i < FishSoldierActorMine.length; i++)
			{
				soldier = FishSoldierActorMine[i] as FishSoldier;
				soldier.Destructor();
			}
			FishSoldierActorMine.splice(0, FishSoldierActorMine.length);
			
			var FishSoldierActorTheirs:Array = user.FishSoldierActorTheirs;
			for (i = 0; i < FishSoldierActorTheirs.length; i++)
			{
				soldier = FishSoldierActorTheirs[i] as FishSoldier;
				soldier.Destructor();
			}
			FishSoldierActorTheirs.splice(0, FishSoldierActorTheirs.length);
		}
		
		public function removeMySolider():void
		{
			var soldier:FishSoldier;
			var user:User = GameLogic.getInstance().user;
			var i:int;
			var FishSoldierActorMine:Array = user.FishSoldierActorMine;
			for (i = 0; i < FishSoldierActorMine.length; i++)
			{
				soldier = FishSoldierActorMine[i] as FishSoldier;
				soldier.Destructor();
			}
			FishSoldierActorMine.splice(0, FishSoldierActorMine.length);
		}
		
		/**
		 * tạo lại mảng cá lính
		 */
		private function InitAllSoldierInCurLake():void 
		{
			var i:int;
			var allSoldier:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			var curLakeId:int = GameLogic.getInstance().user.CurLake.Id;
			var FishSoldierExpired:Array = GameLogic.getInstance().user.FishSoldierExpired;
			var FishSoldierArr:Array = GameLogic.getInstance().user.FishSoldierArr;
			
			for (i = 0; i < allSoldier.length; i++)
			{
				var soldier:FishSoldier = allSoldier[i] as FishSoldier;
				if (soldier.LakeId == curLakeId) {
					var dy:int = Math.floor((Constant.HEIGHT_LAKE - 50) / allSoldier.length);
					var name:String = Fish.ItemType + soldier.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					var fs:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), name);
					GameController.getInstance().SetInfo(fs, soldier, FishSoldier.ACTOR_MINE);
					var posX:int = Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2 - fs.img.width - 50;
					var posY:int = GameController.getInstance().GetLakeTop() + 50 + i * dy;
					fs.Init(posX, posY);
					switch (fs.CheckStatus())
					{
						case FishSoldier.STATUS_INSTORE:
							break;
						case FishSoldier.STATUS_HEALTHY:
							if (fs.IsHealthy())
							{
								if (fs.Diary != null && fs.Diary.length > 0 && !GameLogic.getInstance().user.IsViewer())
								{
									fs.SetEmotion(FishSoldier.REWARD);
								}
							}
							else
							{
								fs.SetEmotion(FishSoldier.WEAK);
							}
							break;
						case FishSoldier.STATUS_REVIVE:
							fs.SetEmotion(FishSoldier.REVIVE);
							break;
						case FishSoldier.STATUS_DEAD:
							fs.SetEmotion(FishSoldier.DEAD);
							FishSoldierExpired.push(fs);
							break;
					}
					FishSoldierArr.push(fs);
				}
			}
		}
		
		private function hideGuiMain():void
		{
			//GuiMgr.getInstance().GuiTopInfo.Hide();
			updateGuiTopForLeague();
			//GuiMgr.getInstance().GuiTopInfo = null;
			GuiMgr.getInstance().GuiStore.Hide();
			GuiMgr.getInstance().GuiMain.Hide();
			GuiMgr.getInstance().GuiMain = null;
			GuiMgr.getInstance().GuiFriends.Hide();
			GuiMgr.getInstance().GuiAnnounce.Hide();
			GuiMgr.getInstance().GuiSetting.Hide();//xử lý gui setting
			
			for (var i:int = 0; i < _listActiveGui.length; i++) {
				var activeGui:BaseGUI = _listActiveGui[i] as BaseGUI;
				if (activeGui) {
					if (activeGui.IsVisible) {
						activeGui.Hide();
					}
				}
			}
		}
		
		/**
		 * xóa ảnh các layer
		 */
		private function clearBaseLayer():void 
		{
			//LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).Empty();
			//LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).Empty();
			//LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER).Empty();
		}
		/**
		 * load layer moi
		 * @param	imgName : tên ảnh của layer
		 */
		private function loadLayer(idBackGound:int = Constant.ID_DEFAULT_BACKGROUND):void 
		{
			var layerBg:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
			//layerBg.y = 0;
			GameController.getInstance().PanScreenX( -layerBg.x);
			GameController.getInstance().PanScreenY( -layerBg.y - (Constant.TOP_LAKE - Constant.TOP_LAKE_FISH_WORLD));
			var object:Object = new Object();
			object.ExpiredTime = int.MAX_VALUE;
			object.Id = int.MAX_VALUE;
			object["ItemId"] = idBackGound;
			//object["ItemId"] = 101;
			
			object.X = 0;
			object.Y = 0;
			object.Z = 0;
			GameLogic.getInstance().user.initBackGround(object);
		}

		private function addCircleLoading():void 
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
			layer.addChild(WaitData);
			WaitData.x = layer.width / 2 - 10;
			WaitData.y = layer.height / 2 - 10;
		}
		
		private function removeCircleLoading():void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
			if (layer.contains(WaitData))
			{
				layer.removeChild(WaitData);
			}
		}
		/**
		 * hiển thị các gui của màn hình bắt đầu
		 */
		private function showStartScene():void
		{
			removeCircleLoading();
			var listGui:Array = new Array();//danh sách gui hiển thị
			listGui.push(guiRank, tableRankGift, _guiGiftLeague);
			//listGui.push( tableRankGift);
			showSomeGui(listGui);//hiển thị
			//show avatar
			if (ctnAvatar == null)
			{
				ctnAvatar = _guiTopInfo.AddContainer(ID_CTN_AVATAR, "GuiLeague_CtnAvatar", 15, 50);
				ctnAvatar.AddLabel(LeagueMgr.getInstance().MyPlayer.Name.substr(0, 7), 12, 11);
				tfLevel = ctnAvatar.AddLabel(GameLogic.getInstance().user.GetMyInfo().Level.toString(), 11, 95);
				var avatar:String = LeagueMgr.getInstance().MyPlayer.Avatar;
				var fComp:Function = function onLoadAvatarComp():void
				{
					this.SetSize(52, 52);
					this.SetPos(36, 36);
				}
				imgAvatar = ctnAvatar.AddImage("", avatar, 36, 36, 
												false, Image.ALIGN_LEFT_TOP, false, fComp);
				imgAvatar.SetSize(52, 52);
			
			}
			//var rank:int = LeagueMgr.getInstance().MyPlayer.Rank;
			//var fm:TextFormat = new TextFormat("Arial", 24, 0xffff00, true);
			//var strRank:String = rank > 1000 ? "> 1,000" : Ultility.StandardNumber(rank);
			//if (tfRank == null)
			//{
				//show Rank
				//tfRank = _guiTopInfo.AddLabel(strRank, 64, 535, 0xffff00, 1, 0x000000);
			//}
			//else {
				//tfRank.text = strRank;
			//}
			//tfRank.setTextFormat(fm);
		}
		public function levelUp():void 
		{
			if (tfLevel)
			{
				tfLevel.text = Ultility.StandardNumber(GameLogic.getInstance().user.GetMyInfo().Level);
			}
			
		}
		/**
		 * load xong background
		 */
		public function onLoadBackGroundComplete():void 
		{
			addCircleLoading();
			IsLoadBackGroundComp = true;
			if (IsDataReady)//dữ liệu đã nhận về
			{
				showStartScene();
			}
		}
		/**
		 * khởi tạo những gui sau khi nhận dữ liệu từ server về
		 */
		public function initGuiAfterData():void 
		{
			if (IsDataReady)//trường hợp chỉ refresh bảng, sau khi đã vào liên đấu
			{
				if (IsFinishReceiveGiftFight) //nếu nhận quà xong rồi
				{
					showStartScene();
					IsFinishReceiveGiftFight = false;
				}
				else
				{
					if (guiRank.inRefresh)
					{
						guiRank.refreshOk();
					}
					else if (guiRank.inAutoRefresh)
					{
						guiRank.autoRefreshOk();
						tableRankGift.refreshOk();
					}
				}
			}
			else //trường hợp vào liên đấu
			{
				IsDataReady = IsDataStatusReady && IsDataRefreshReady;
				if (IsLoadBackGroundComp && IsDataReady)
				{
					showStartScene();
					timeRefreshBySystem = GameLogic.getInstance().CurServerTime;
				}
			}
		}
		
		public function showSomeButton():void 
		{
			//nút chọn ngư thủ
			if (btnChooseSoldier == null)
			{
				btnChooseSoldier = _guiTopInfo.AddButton(GUIMainLeague.ID_BTN_CHOOSE_SOLDIER, "GuiLeague_BtnChooseSoldier", 45, 577);
			}
			else 
			{
				btnChooseSoldier.SetVisible(true);
			}
			btnChooseSoldier.SetEnable(false);
		}
		
		
		private var timer:Timer;
		private var child:Sprite;
		
		/**
		 * tạo ra con cá bơi trong hồ
		 * @param	fishInfo : dữ liệu con cá
		 * @param	Equipment : dữ liệu về đồ của cá
		 */
		public function showHisSoldier(fishIndexEquip:Object, fishInfo:Object, Equipment:Object, fishMeri:Object):void
		{
			var name:String = Fish.ItemType + fishInfo["FishTypeId"] + "_" + Fish.OLD + "_" + Fish.IDLE;
			var parent:Object = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) as Object;
			_hisSoldier = new FishSoldier(parent, name);
			_hisSoldier.SetInfo(fishInfo);
			_hisSoldier.isActor = FishSoldier.ACTOR_THEIRS;
			
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:int = _hisSoldier.LifeTime - (GameLogic.getInstance().CurServerTime - _hisSoldier.OriginalStartTime);
			if (remainTime < 0) //cá Hết hạn
			{
				_hisSoldier.OriginalStartTime = GameLogic.getInstance().CurServerTime;
			}
			var MaxHealth:int = ConfigJSON.getInstance().getItemInfo("RankPoint")[_hisSoldier.Rank]["MaxHealth"];
			_hisSoldier.Health = MaxHealth;
			_hisSoldier.SetEquipmentInfo(Equipment);
			_hisSoldier.UpdateBonusEquipment();
			
			_hisSoldier.isActor = FishSoldier.ACTOR_THEIRS;
			_hisSoldier.isInRightSide = true;
			_hisSoldier.Init(HISINITPOS.x, HISINITPOS.y);
			
			if (fishMeri != null)
			{
				_hisSoldier.meridianDamage = fishMeri["Damage"];
				_hisSoldier.meridianDefence = fishMeri["Defence"];
				_hisSoldier.meridianCritical = fishMeri["Critical"];
				_hisSoldier.meridianVitality = fishMeri["Vitality"];
			}
			
			timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, onShowEffectHim);
			_hisSoldier.flipX( -1, true);
			_hisSoldier.OnLoadResCompleteFunction = function():void
			{
				child = this.img;
				timer.start();
			}
			var listActor:Array = GameLogic.getInstance().user.FishSoldierActorTheirs;
			listActor.push(_hisSoldier);
		}
		
		public function onShowEffectHim(e:TimerEvent):void 
		{
			var childList:Array = [];
			childList.push(child);
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER,
															"GuiLeagueGift_EffAppear",
															childList,
															HISSTANDPOS.x - 14, HISSTANDPOS.y + 19,
															false, false, null,
															effectHimComp);
			function effectHimComp():void//sau khi hoàn thành effect xuất hiện, thi cho xuat hien con ca
			{
				_hisSoldier.Init(HISSTANDPOS.x, HISSTANDPOS.y);
				_hisSoldier.SetMovingState(Fish.FS_STANDBY);
				_hisSoldier.standbyPos = HISSTANDPOS;
				_hisSoldier.GuiFishStatus.ShowStatus(_hisSoldier, GUIFishStatus.WAR_INFO);
				//show gui info him
				guiInfoHim.isMe = false;
				guiInfoHim.damage = _hisSoldier.getTotalDamage();
				guiInfoHim.defence = _hisSoldier.getTotalDefence();
				guiInfoHim.critical = _hisSoldier.getTotalCritical();
				guiInfoHim.vitality = _hisSoldier.getTotalVitality();
				guiInfoHim.Show();
				//Hiện effect bắt đầu
				EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER,
														"GuiLeague_EffBeginText",
														null, 690, 394, 
														false, false, null, 
														onCompleteEffBegin);
				function onCompleteEffBegin():void
				{
					//cho 2 con cá bơi vào vị trí
					_mySoldier.standbyPos = FIGHTPOS;
					_mySoldier.SwimTo(FIGHTPOS.x, FIGHTPOS.y, 15, true);
					if (_mySoldier.ghostEmit == null)
					{
						_mySoldier.ghostEmit = new GhostEmit(_mySoldier.img.parent, _mySoldier, 1);
					}
					_hisSoldier.standbyPos = HISFIGHTPOS;
					_hisSoldier.SwimTo(HISFIGHTPOS.x, HISFIGHTPOS.y, 15, true);
					IsDataWarReady = true;
					if (IsCompleteStartWarScene)
					{
						createMainWarScene();
					}
				}
			}
			timer.stop();
		}
		
		public function showSoldier():void 
		{
			btnChooseSoldier.SetEnable(false);
			var soldier:FishSoldier = LeagueMgr.getInstance().getChooseSoldier();//lấy con cá logic
			var name:String = Fish.ItemType + soldier.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
			var parent:Object = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) as Object;
			_mySoldier = new FishSoldier(parent, name);//khởi tạo con cá interface của mình
			GameController.getInstance().SetInfo(_mySoldier, soldier, FishSoldier.ACTOR_MINE);//gán dữ liệu cho cá interface
			_mySoldier.isInRightSide = true;		//mặc định là cho nó đến đúng vị trí => không phải findDes, không set State == SWIM
			_mySoldier.Health = soldier.MaxHealth;	//vào liên đấu là đầy sức khỏe
			_mySoldier.Init(INITPOS.x, INITPOS.y);//vẽ nó ra tại vị trí INITPOS
			
			timer = new Timer(50);
			timer.addEventListener(TimerEvent.TIMER, onShowEffect);
			
			_mySoldier.OnLoadResCompleteFunction = function():void
			{
				this.SetMovingState(Fish.FS_IDLE);
				child = this.img;
				trace(child);
				timer.start();
			}
			GameLogic.getInstance().user.FishSoldierActorMine.push(_mySoldier);
		}
		
		private function onShowEffect(e:TimerEvent):void 
		{
			var childList:Array = [];
			childList.push(child);
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER,
															"GuiLeagueGift_EffAppear",
															childList,
															STANDPOS.x - 13, STANDPOS.y + 18,
															false, false, null,
															effectComp);
			function effectComp():void//sau khi hoàn thành effect xuất hiện, thi cho xuat hien con ca
			{
				_mySoldier.Init(STANDPOS.x, STANDPOS.y);
				_mySoldier.SetMovingState(Fish.FS_STANDBY);
				_mySoldier.standbyPos = STANDPOS;
				_mySoldier.GuiFishStatus.ShowStatus(_mySoldier, GUIFishStatus.WAR_INFO);
				if(!IsGotoLegueOk)
					IsGotoLegueOk = true;
				btnChooseSoldier.SetEnable(true);
			}
			
			timer.stop();
		}
		
		public function showSomeGui(listGui:Array):void 
		{
			if (listGui) 
			{
				for (var i:int = 0; i < listGui.length; i++)
				{
					var gui:BaseGUI = listGui[i] as BaseGUI;
					gui.Show();
				}
			}
		}
		
		public function backHomeGui():void 
		{
			_guiTopInfo.RemoveContainer(ID_CTN_AVATAR);
			ctnAvatar = null;
			_guiTopInfo.RemoveImageDigit("ImageRank");
			
			if (btnChooseSoldier.img)
			{
				_guiTopInfo.RemoveButton(GUIMainLeague.ID_BTN_CHOOSE_SOLDIER);
				btnChooseSoldier = null;
			}
			
			var listGui:Array = new Array();
			listGui.push(guiRank, tableRankGift, _guiGiftLeague);
			hideSomeGui(listGui);
			if (LeagueMgr.getInstance().MyPlayer.SoldierId > 0)
			{
				removeMySoldier();
			}
			
			_guiVersus.Hide();
			guiInfoMe.Hide();
			IsGotoLegueOk = false;
			
		}
		
		private function removeMySoldier():void 
		{
			_mySoldier.Destructor();
			var FishSoldierActorMine:Array = GameLogic.getInstance().user.FishSoldierActorMine;
			FishSoldierActorMine.splice(0, FishSoldierActorMine.length);
		}
		
		/**
		 * hiển thị toàn bộ GUI khi trở về nhà
		 */
		public function recoverHome():void 
		{
			clearBaseLayer();
			var homeId:int = LeagueController.getInstance().homeBgId;
			loadLayer(homeId);		// load layer mới (default layer)
			if (LeagueController.getInstance().key == LeagueController.INVISIBLE)
			{
				setVisibleAllObject(true);//hien thi lai cac object tren ho
				showGuiMain();			//hien thi lai cac gui chinh
				
			}
			else
			{
				var test:SendInitRun = new SendInitRun();
				Exchange.GetInstance().Send(test);
				var sol:SendGetAllSoldier = new SendGetAllSoldier();
				Exchange.GetInstance().Send(sol);
				GuiMgr.getInstance().GuiMain = new GUIMain(null, "");
				GuiMgr.getInstance().GuiMain.Show();
				GuiMgr.getInstance().GuiWaitingData.Show(Constant.TopLayer - 1, 1);
				// add Setting gui
				GuiMgr.getInstance().GuiSetting = new GUISetting(null, "");
				GuiMgr.getInstance().GuiSetting.Show();
				
				// Add gui friends
				// MinhT
				GuiMgr.getInstance().GuiFriends = new GUIFriends(null, "");
				GuiMgr.getInstance().GuiFriends.Show();		
				
				var friendlist: SendRefreshFriend = new SendRefreshFriend(false);
				Exchange.GetInstance().Send(friendlist);	
			}
		}
		
		private function hideSomeGui(listGui:Array):void 
		{
			for (var i:int = 0; i < listGui.length; i++) 
			{
				var gui:BaseGUI = listGui[i] as BaseGUI;
				if (gui.IsVisible) {
					if (gui.ClassName == "GUIRank") 
					{
						(gui as GUIRank).hideGui();
					}
					else if (gui.ClassName == "TableRankGift")
					{
						(gui as TableRankGift).hideGui();
					}
					else if (gui.ClassName == "GUIGiftLeague")
					{
						(gui as GUIGiftLeague).hideGui2();
					}
					else 
					{
						gui.Hide();
					}
				}
			}
		}
		
		private function recoveBackGound():void 
		{
			setVisibleAllObject(true);
			clearBaseLayer();
			loadLayer();
		}
		
		private function showGuiMain():void
		{
			var i:int;
			
			GuiMgr.getInstance().guiFrontScreen.Show();
			GuiMgr.getInstance().guiFrontScreen.updateUserData();
			GuiMgr.getInstance().GuiMain = new GUIMain(null, "");
			GuiMgr.getInstance().GuiMain.Show();
			GuiMgr.getInstance().GuiMain.ShowLakes();
			GuiMgr.getInstance().GuiMain.UpdateAllPos(false);
			
			GuiMgr.getInstance().GuiFriends = new GUIFriends(null, "");
			GuiMgr.getInstance().GuiFriends.Show();
			LeagueController.getInstance().isRefreshingFriend = true;
			GuiMgr.getInstance().GuiFriends.UpdateFriend();
			
			GuiMgr.getInstance().GuiSetting = new GUISetting(null, "");
			GuiMgr.getInstance().GuiSetting.Show();
			
			GameLogic.getInstance().user.ShowMapOceanButton();
			for (i = 0; i < _listActiveGui.length; i++) {
				var activeGui:BaseGUI = _listActiveGui[i] as BaseGUI;
				if (activeGui) {
					if (activeGui.IsVisible) {
						activeGui.Hide();
					}
				}
			}
		}
		
		/**
		 * thực hiện cập nhật guiTopInfo theo LeagueController.getInstance().mode
		 */
		public function updateGuiTopForLeague():void
		{
			/*//chỉ hiển thị prgExp, prgMoney, imgZXu
			var inHome:Boolean = (LeagueController.getInstance().mode == LeagueController.IN_HOME);
			_guiTopInfo.UpdateGuiForFishWorld(inHome);
			_guiTopInfo.imgEnergy.img.visible = inHome;
			//các cái khác
			_guiTopInfo.prgEnergy.setVisible(inHome);
			_guiTopInfo.btnFishWarSum.SetVisible(inHome);
			_guiTopInfo.txtEnergy.visible = inHome;
			_guiTopInfo.imgDailyQuestMonday.SetVisible(inHome);
			_guiTopInfo.imgAvatarMonday.SetVisible(inHome);
			_guiTopInfo.imgSnapshotMonday.SetVisible(inHome);
			_guiTopInfo.imgSnapshot.img.visible = inHome;
			_guiTopInfo.txtCooldown.visible = inHome;
			_guiTopInfo.GetButton(GUITopInfo.BTN_BUY_DIAMOND).SetVisible(inHome);
			_guiTopInfo.labelDiamond.visible = inHome;
			_guiTopInfo.GetContainer("idCtnDiamond").SetVisible(inHome);
			_guiTopInfo.btnLock.SetVisible(inHome);
			_guiTopInfo.btnUnlock.SetVisible(inHome);
			var curQuestId:int = QuestMgr.getInstance().curDailyQuest;
			curQuestId = inHome?curQuestId: -1;
			_guiTopInfo.showDailyQuestTask(curQuestId);
			
			if (_guiTopInfo.txtEventIndependent != null)
			{
				_guiTopInfo.txtEventIndependent.visible = inHome;
			}
			_guiTopInfo.imgBgTitle.img.visible = inHome;
			
			_guiTopInfo.imgGold.setVisible(inHome);
			_guiTopInfo.txtMoney.visible = inHome;
			
			_guiTopInfo.imgZXu.x = _guiTopInfo.imgGold.x;
			_guiTopInfo.txtZMoney.x = _guiTopInfo.txtMoney.x;
			_guiTopInfo.GetButton(GUITopInfo.BTN_QUICK_PAY).img.x -= 120;
			if (_guiTopInfo.isShowCtnFishWar) {
				_guiTopInfo.HideGui();
			}*/
		}
		
		public function get ChoseSoldier():FishSoldier 
		{
			return _mySoldier;
		}
		
		/**
		 * bắt đầu cảnh đánh nhau:
		 * 		effect load màn hình
		 * 		2 thanh progressbar đầy dần cho feeling
		 */
		public function startWarScene():void 
		{
			IsCompleteStartWarScene = false;
			IsDataWarReady = false;
			tableRankGift.isClickTop = true;
			//hide 2 cai bang
			guiRank.hideGui();
			tableRankGift.hideGui();
			//hide hop qua
			_guiGiftLeague.hideGui2();
			//con ca nha minh boi vao vi tri
			btnChooseSoldier.SetVisible(false);
		}
		
		public function onCompleteStartWarScene():void 
		{
			IsCompleteStartWarScene = true;
			if (IsDataWarReady)
			{
				createMainWarScene();
			}
		}
		
		public function processFightData(hisIndexEquip:Object, hisSoldierInfo:Object, hisSoldierEquipment:Object,fishMeri:Object):void
		{
			GameLogic.getInstance().user.CurSoldier[0] = _mySoldier;
			_guiVersus.runEffect();
			showHisSoldier(hisIndexEquip, hisSoldierInfo, hisSoldierEquipment, fishMeri);
		}
		
		public function showHisAvatar(hisName:String, hisLevel:int, hisAvatar:String = ""):void 
		{
			ctnAvatarHim = _guiTopInfo.AddContainer(ID_CTN_AVATARHIM, "GuiLeague_CtnAvatar", 680, 50);
			var name:String;
			if (hisName == null || hisName == "")
			{
				name = "Unknown";
			}
			else {
				name = hisName;
			}
			ctnAvatarHim.AddLabel(name.substr(0, 7), 12, 11);
			ctnAvatarHim.AddLabel(hisLevel.toString(), 11, 95);
			var avatar:String;
			if (hisAvatar == null || hisAvatar == "") {
				avatar = Main.staticURL + "/avatar.png";
			}
			else {
				avatar = hisAvatar;
			}
			var fComp:Function = function onLoadAvatarComp():void
			{
				this.SetSize(52, 52);
				this.SetPos(36, 36);
			}
			var imgAvatarHim:Image = ctnAvatarHim.AddImage("", avatar, 36, 36, 
											false, Image.ALIGN_LEFT_TOP, false, fComp);
			imgAvatarHim.SetSize(52, 52);
		}
		
		/**
		 * tạo cảnh chính cho trận đánh (sau khi nhận được dữ liệu về)
		 */
		private function createMainWarScene():void 
		{
			var myVitality:int = _mySoldier.getTotalVitality();
			var hisViatality:int = _hisSoldier.getTotalVitality();
			_guiVitality.initData(myVitality, hisViatality);
			_guiVitality.Show();	//hiện thanh máu
			GameLogic.getInstance().user.CurSoldier[1] = _hisSoldier;
		}
		
		/**
		 * cập nhật vào thanh máu
		 * @param	num : số lượng máu cập nhật vào (thường là số < 0)
		 * @param	isMe : cập nhật vào thanh máu của mình hay đối thủ
		 */
		public function updatePrgBlood(num:int, isMe:Boolean):void 
		{
			_guiVitality.updateProgress(isMe, num);
		}
		
		public function updatePrgBlood2(isMe:Boolean, curHP:int, hp:int):void 
		{
			var prg:ProgressBar;
			if (isMe)
			{
				prg = _guiVitality.prgMe;
			}
			else {
				prg = _guiVitality.prgHim;
			}
			GameLogic.getInstance().AddPrgToProcess(prg, curHP / hp);
		}
		public function updateAllGui():void
		{
			if (_guiGiftLeague) {
				if (_guiGiftLeague.img)
				{
					if (_guiGiftLeague.IsVisible)
					{
						_guiGiftLeague.updateGui();
					}
				}
			}
			
		}
		
		public function showCompleteFight():void 
		{
			IsDataRefreshReady = false;
			//2 thanh máu biến mất
			_guiVitality.Hide();
			//hiển thị gui nhận qà
			IsFinishReceiveGiftFight = false;
			guiGiftFight.Show(Constant.GUI_MIN_LAYER, 5);
			//cho con cá nhà bạn bơi ra khỏi màn hình và biến mất
			GameLogic.getInstance().user.CurSoldier[1] = null;
			finishSoldierFight(_hisSoldier);
			
			// cho con cá nhà mình bơi về vị trí chuẩn bị, hiện effect đấm bóp cho cá :D feeling
			GameLogic.getInstance().user.CurSoldier[0] = null;
			finishSoldierFight(_mySoldier);
			
			_guiTopInfo.RemoveContainer(ID_CTN_AVATARHIM);
		}
		
		/**
		 * hành động của cá khi xong 1 trận đấu (trong liên đấu)
		 * @param	soldier : con cá đó
		 */
		private function finishSoldierFight(soldier:FishSoldier):void 
		{
			soldier.SetMovingState(Fish.FS_STANDBY);
			if (soldier.isActor == FishSoldier.ACTOR_MINE)
			{
				_mySoldier.standbyPos = STANDPOS;
				_mySoldier.SwimTo(STANDPOS.x, STANDPOS.y, 13);
				guiInfoMe.Hide();
			}
			else
			{
				_hisSoldier.SwimTo(HISINITPOS.x, HISINITPOS.y, 6);
				LeagueController.getInstance().destructFish = true;
				guiInfoHim.Hide();
			}
		}
		
		
		/**
		 * nhận quà xong (sau khi hoàn thành 1 trận đấu)
		 */
		public function onFinishReceiveGift():void 
		{
			IsFinishReceiveGiftFight = true;
			if (IsDataRefreshReady)
			{
				showStartScene();
				var myRank:int = LeagueMgr.getInstance().MyPlayer.Rank;
				var oldRank:int = GameLogic.getInstance().user.Rank;
				if (oldRank != myRank) 
				{
					GameLogic.getInstance().user.Rank = myRank;
				}
				IsFinishReceiveGiftFight = false;
				setInfoForGuiInfo(true);
				guiInfoMe.Show();
			}
		}
		
		public function deleteHisFish():void 
		{
			_hisSoldier.Destructor();
			var listTheirs:Array = GameLogic.getInstance().user.FishSoldierActorTheirs;
			listTheirs.splice(0, listTheirs.length);
		}
		
		/**
		 * Hiển thị gui có chữ VS
		 */
		public function showGuiVersus():void 
		{
			_guiVersus.Show(Constant.OBJECT_LAYER);
		}
		
		/**
		 * cập nhật quà nhận được sau trận đánh liên quan đến con cá
		 * @param	listGift : danh sách quà cho người chơi, trong đó có quà liên quan đến con cá: RankPoint
		 */
		public function getGiftForMySoldier(listGift:Array):void 
		{
			var i:int;
			var giftN:GiftNormal;
			var logicSoldier:FishSoldier = LeagueMgr.getInstance().getSoldierById(_mySoldier.Id);
			for (i = 0; i < listGift.length; i++)
			{
				giftN = listGift[i] as GiftNormal;
				if (giftN.ItemType == "RankPoint")
				{
					logicSoldier.updateRankPoint(giftN.Num);
					_mySoldier.updateRankPoint(giftN.Num);
					break;
				}
			}
		}
		
		public function initDataForGuiDailyGift(numExpired:int, numCurrent:int):void 
		{
			guiDailyGift.NumExpired = numExpired;
			guiDailyGift.NumCurrent = numCurrent;
		}
		
		private function setInfoForGuiInfo(isMe:Boolean):void
		{
			if (isMe)
			{
				guiInfoMe.damage = _mySoldier.getTotalDamage();
				guiInfoMe.defence = _mySoldier.getTotalDefence();
				guiInfoMe.critical = _mySoldier.getTotalCritical();
				guiInfoMe.vitality = _mySoldier.getTotalVitality();
			}
			else
			{
				guiInfoHim.damage = _hisSoldier.getTotalDamage();
				guiInfoHim.defence = _hisSoldier.getTotalDefence();
				guiInfoHim.critical = _hisSoldier.getTotalCritical();
				guiInfoHim.vitality = _hisSoldier.getTotalVitality();
			}
		}
	}
}

