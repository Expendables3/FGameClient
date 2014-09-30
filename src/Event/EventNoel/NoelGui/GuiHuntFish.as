package Event.EventNoel.NoelGui 
{
	import Effect.EffectMgr;
	import Event.EventNoel.NoelGui.ItemGui.Bullet.BulletScenario;
	import Event.EventNoel.NoelGui.Team.RoundScene;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import Event.EventNoel.NoelLogic.Round.RoundNoel;
	import Event.EventNoel.NoelPacket.SendFireGun;
	import Event.EventNoel.NoelPacket.SendGotoSea;
	import Event.Factory.FactoryLogic.EventSvc;
	import flash.ui.Mouse;
	import GUI.component.BaseGUI;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import NetworkPacket.BasePacket;
	
	/**
	 * MainScene của cả bàn chơi.
	 * @author HiepNM2
	 */
	public class GuiHuntFish extends GUIGetStatusAbstract 
	{
		private var _timeShowUserInfo:Number = -1;
		public var inEffectRoundUp:Boolean = false;
		public var inEffectComeInRound:Boolean = false;
		private var inShowGetGift:Boolean = false;
		
		public function GuiHuntFish(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			_imgThemeName = "GuiHuntFish_BackGround";
			_idPacket = Constant.CMD_SEND_GO_TO_SEA;
			_urlService = "EventService.getBoardGame";
			_dataPacket = new Object();
		}
		
		public function setDataPacket(dataPacket:Object):void 
		{
			_dataPacket["IsPlayNow"] = dataPacket["IsPlayNow"];
		}
		
		override protected function onInitGuiBeforeServer():void 
		{
			//Main.imgRoot.stage.frameRate = 20;
			GameLogic.getInstance().user.allowLevelUp = false;
			GuiMgr.getInstance().guiBtnControl.ShowInHunt();
			GameLogic.getInstance().BackToIdleGameState();
			GameLogic.getInstance().MouseTransform("EventNoel_ImgMouseTarget", 1, 0, 0, 0);
			Mouse.hide();
			if (EventNoelMgr.getInstance().InWaitLogGame)//nếu lần đầu vào MiniGame
			{
				EventNoelMgr.getInstance().StartTimeGame = GameLogic.getInstance().CurServerTime;
			}
		}
		
		override protected function onInitData(data1:Object):void 
		{
			RoundScene.getInstance().initRoundData(data1);
			_dataPacket["IsPlayNow"] = false;				//reset lại biến này để lần sau ko vào = G
		}
		
		override protected function onInitGuiAfterServer():void 
		{
			_timeShowUserInfo = GameLogic.getInstance().CurServerTime;
			EventNoelMgr.getInstance().LogTime = GameLogic.getInstance().CurServerTime;//Thời điểm vào game
			RoundScene.getInstance().contructor();
			BulletScenario.getInstance().contructor();
			RoundScene.getInstance().generateScene();
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
			GuiMgr.getInstance().guiUserEventInfo.Show();
			GuiMgr.getInstance().guiBtnControl.initPrgFishDie();
			GuiMgr.getInstance().guiBtnControl.updateRoundBar();
			layer.setChildIndex(GuiMgr.getInstance().guiBtnControl.img, layer.numChildren - 1);
			inEffectComeInRound = true;
			var idRound:int = RoundScene.getInstance().Round.IdRound;
			var x:Number = Constant.STAGE_WIDTH / 2;
			var y:Number = Constant.STAGE_HEIGHT / 2;
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiHuntFish_EffComeInRound" + idRound,
													null, x, y, false, false, null, fComp);
			function fComp():void
			{
				inEffectComeInRound = false;
			}
		}
		
		override protected function onUpdateGui(curTime:Number):void 
		{
			if (_timeShowUserInfo > 0)
			{
				if (curTime - _timeShowUserInfo > 0.5)
				{
					GuiMgr.getInstance().guiUserEventInfo.updateUserData();
					_timeShowUserInfo = -1;
				}
			}
			GuiMgr.getInstance().guiBtnControl.updateTime(curTime);//có timeout
			if (!BulletScenario.getInstance().TimeOutFlag)
			{
				RoundScene.getInstance().update(curTime);//có roundUp
				BulletScenario.getInstance().update(curTime);
			}
		}
		
		override public function ClearComponent():void 
		{
			/*xóa đi tất cả các team*/
			if (IsInitFinish)
			{
				RoundScene.getInstance().Destructor();
				IsInitFinish = false;
			}
			super.ClearComponent();
		}


		override public function OnHideGUI():void 
		{
			BulletScenario.getInstance().Destructor();
			var isSendOK:Boolean = sendFireGun();
			if (isSendOK)
			{
				BulletScenario.getInstance().flushAllFireInfo();
			}
			RoundScene.getInstance().resetIce();
			GuiMgr.getInstance().guiUserEventInfo.Hide();
			GuiMgr.getInstance().guiBtnControl.Hide();
			GameLogic.getInstance().user.allowLevelUp = true;
			GameLogic.getInstance().MouseTransform("");
			BulletScenario.getInstance().TimeOutFlag = false;
			var outTime:Number = GameLogic.getInstance().CurServerTime;//thời điểm ra game
			var logTime:Number = EventNoelMgr.getInstance().LogTime;
			if (Ultility.IsOtherDay(logTime, outTime))//thời điểm vào game và ra game ở 2 ngày khác nhau => reload
			{
				GuiMgr.getInstance().GuiMessageBox.inReload = true;
				GuiMgr.getInstance().GuiMessageBox.ShowReload("Qua ngày\nBạn hãy tải lại game để chơi tiếp nhé", 310, 200, 1);
			}
		}
		
		public function preparingRoundUp():void 
		{
			var pk:BasePacket, fireInfo:Array, idBoard:int;
			IsInitFinish = false;
			BulletScenario.getInstance().Destructor();				//thực hiện remove tất cả đạn để merge vào
			RoundScene.getInstance().forceRemoveAllTeam();
			//gửi gói tin bắn cá
			var isSendOK:Boolean = sendFireGun();
			if (isSendOK)
			{
				BulletScenario.getInstance().flushAllFireInfo();
			}
			
			var isRoundUp:Boolean = RoundScene.getInstance().Round.roundUp();
			if (isRoundUp)//lên level
			{
				IsDataReady = false;
				var x:Number = img.width / 2 - 180;
				var y:Number = img.height / 2 - 50;
				inEffectRoundUp = true;
				var ptr:BaseGUI = this;
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiHuntFish_EffRoundUp",
														null, x, y, false, false, null, fCompEff);
				function fCompEff():void
				{
					inEffectRoundUp = false;
					if (!IsDataReady)//chưa nhận dữ liệu về
					{
						ptr.img.addChild(WaitData);
						WaitData.x = ptr.img.width / 2 - 10;
						WaitData.y = ptr.img.height / 2 - 10;
					}
					else
					{
						if (!inShowGetGift)//nếu mà ko show cái gui nhận thưởng khi qua bàn
						{
							initRound();
						}
					}
				}
			}
			else//đã kết thúc 5 vòng chơi
			{
				//trace("đã hết 5 vòng chơi");
			}
		}
		public function processFireGun(data1:Object):void 
		{
			var isRoundUpServer:Boolean = data1["IsPassBoard"];
			if (isRoundUpServer)
			{
				if (RoundScene.getInstance().Round.IdRound == 5)
				{
					var x:Number = img.width / 2 - 180;
					var y:Number = img.height / 2 - 50;
					inEffectComeInRound = true;
					EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiHuntFish_EffRoundUp",
														null, x, y, false, false, null, fCompEff);
					function fCompEff():void
					{
						inEffectComeInRound = false;
						Hide();
						EventNoelMgr.getInstance().StartTimeGame = -1;
					}
					return;
				}
				var pk:SendGotoSea = new SendGotoSea("EventService.getBoardGame", Constant.CMD_SEND_ROUND_UP, false);
				Exchange.GetInstance().Send(pk);
				if (RoundScene.getInstance().Round.IdRound == RoundNoel.ROUND_BOSS)//nếu là vòng boss
				{
					EventNoelMgr.getInstance().LastTimeFinish = GameLogic.getInstance().CurServerTime;
					//trace("set startTime = -1 here");
					//EventNoelMgr.getInstance().StartTimeGame = -1;
					//EventNoelMgr.getInstance().NumPlay++;
				}
				if (RoundScene.getInstance().Round.IdRound < 5)
				{
					GuiMgr.getInstance().guifinishRound.roundId = RoundScene.getInstance().Round.IdRound;
					EventNoelMgr.getInstance().initTempStore(data1["RetBonus"]);
					GuiMgr.getInstance().guifinishRound.Show(Constant.GUI_MIN_LAYER, 5);
				}
			}
		}
		/**
		 * khởi tạo về round
		 */
		public function initRound():void 
		{
			if (img == null) return;
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			GuiMgr.getInstance().guiBtnControl.initPrgFishDie();
			GuiMgr.getInstance().guiBtnControl.updateRoundBar();
			RoundScene.getInstance().contructor();
			BulletScenario.getInstance().contructor();
			RoundScene.getInstance().generateScene();
			IsInitFinish = true;
			inEffectComeInRound = true;
			var idRound:int = RoundScene.getInstance().Round.IdRound;
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiHuntFish_EffComeInRound" + idRound,
													null, Constant.STAGE_WIDTH / 2, Constant.STAGE_HEIGHT / 2, false, false, null, fComp);
			function fComp():void
			{
				inEffectComeInRound = false;
			}
		}
		
		public function processRoundUp(data:Object):void
		{
			IsDataReady = true;
			RoundScene.getInstance().initRoundData(data);
			if (!inEffectRoundUp && !inShowGetGift)
			{
				initRound();
			}
		}
		
		public function sendFireGun():Boolean
		{
			if (EventNoelMgr.getInstance().InWaitLogGame) return false;
			var fireInfo:Array = BulletScenario.getInstance().FireInfo;
			if (fireInfo != null && fireInfo.length > 0)
			{
				var boardId:int = RoundScene.getInstance().Round.IdRound;
				EventNoelMgr.getInstance().encodeSendFire();
				var key:int = EventNoelMgr.getInstance().Seed;
				var pk:SendFireGun = new SendFireGun("EventService.fireGun",Constant.CMD_SEND_FIRE_GUN,boardId, fireInfo, key);//trong những viên đạn này toàn là những viên dùng G
				Exchange.GetInstance().Send(pk);
				//trace("Send goi tin");
				return true;
			}
			else
			{
				return false;
			}
		}
		public function get IsInitAllOk():Boolean { return IsInitFinish; }
		public function get DataReady():Boolean { return IsDataReady; }
	}

}



















