package GUI.FishWorld 
{
	import adobe.utils.CustomActions;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.FishWorld.Network.JoinSeaAgain;
	import GUI.FishWorld.Network.SendJoinSeaAgain;
	import GUI.GUIFriends;
	import GUI.GUIMain;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import GUI.GUISetting;
	import Logic.Decorate;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.GameState;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendGetAllSoldier;
	import NetworkPacket.PacketSend.SendInitRun;
	import NetworkPacket.PacketSend.SendRefreshFriend;
	import com.greensock.plugins.*;
	import com.greensock.easing.*;
	import com.greensock.*;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIMapOcean extends BaseGUI 
	{
		public const GUI_MAP_CTN_OCEAN:String = "ctnOcean_";
		public const GUI_MAP_IMG_OCEAN:String = "ImgIconOcean_";
		public const GUI_MAP_IMG_KEY_IN_MAP:String = "KeyFishWorld_";
		
		public const GUI_MAP_BTN_HOME:String = "btnHome";
		public const GUI_MAP_BTN_NEXT:String = "btnNext";
		public const GUI_MAP_BTN_PRE:String = "btnPre";
		
		public const GUI_MAP_BTN_MAP:String = "BtnMap_";
		public const GUI_MAP_CTN_MAP:String = "CtnMap_";
		
		public const GUI_MAP_CTN_MAP_1:String = "CtnMap_1";
		public const GUI_MAP_CTN_MAP_2:String = "CtnMap_2";
		public const GUI_MAP_CTN_MAP_3:String = "CtnMap_3";
		public const GUI_MAP_CTN_MAP_4:String = "CtnMap_4";
		public const GUI_MAP_CTN_MAP_5:String = "CtnMap_5";
		
		public const GUI_MAP_BTN_MAP_1:String = "BtnMap_1";
		public const GUI_MAP_BTN_MAP_2:String = "BtnMap_2";
		public const GUI_MAP_BTN_MAP_3:String = "BtnMap_3";
		public const GUI_MAP_BTN_MAP_4:String = "BtnMap_4";
		public const GUI_MAP_BTN_MAP_5:String = "BtnMap_5";
		
		public static const NUM_WORLD_IN_PAGE:int = 5;
		
		public var btnHome:Button;
		public var btnNext:Button;
		public var btnPre:Button;
		
		public var IMG_WIDTH:Number;
		
		public var eff:SwfEffect;
		public var objAllSea:Object;
		public var dataLoadSea:Object;
		public var config:Object;
		public var arrCtnMap:Array;
		public var curPage:int;
		public var prgCtnMap:ProgressBar;
		public var ArrGuiToolTip:Array = [];
		
		public var isComingOcean:Boolean = false;
		
		// fake du lieu
		public var arrListOcean:Array;
		public var arrPosCtn:Array;
		
		// Dữ liệu trong cập nhật khi chọn 1 map nào đó
		public var round:int = -1;
		
		public function GUIMapOcean(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIMapOcean";
		}
		
		// Phai gui goi tin len server de nhan danh sach cac bien da duoc unlock
		// Danh sach bien co the lay tu config
		
		// danh sach bien duoc unlock server co the tra ve khi initrun game
		override public function InitGUI():void 
		{
			//super.InitGUI();
			this.setImgInfo = function():void
			{
				SetPos(0, 0);
				// Fake du lieu
				//InitData(new Object());
				
				OpenRoomOut();
			}			
			LoadRes("GuiMapOcean_Theme");
			isComingOcean = false;
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			RefreshComponent();
			
			//prgCtnMap = AddProgress("", "prgAreaSea", 400, 300, null, false, true);
			//prgCtnMap.setStatus(0.10);
		}
		
		override public function OnHideGUI():void 
		{
			super.OnHideGUI();
			if (eff)
			{
				img.removeChild(eff.img);
				eff.FinishEffect();
				eff = null;
			}
		}
		
		//public var bounds:Rectangle = new Rectangle(0, 0, 810, 624);
		public var bounds:Rectangle = new Rectangle(0, 0, 810, 400);
		public var t1:uint, t2:uint, x1:Number, x2:Number, xOverlap:Number, xOffset:Number, xVelocity:Number, xAcceleration:Number;
		public var isSlideImg:Boolean = false;
		public var isComeBack:Boolean = false;
		public var timeStamp:Number;
		public function mouseDownHandler(event:MouseEvent):void {
			try 
			{
				if (!GuiMgr.getInstance().GuiMapOcean.IsVisible)	return;
				isSlideImg = false;
				isComeBack = false;
				TweenLite.killTweensOf(img);
				x1 = x2 = img.x;
				xOffset = GameInput.getInstance().MousePos.x - img.x;
				xOverlap = Math.max(0, IMG_WIDTH - bounds.width);
				t1 = t2 = getTimer();
				
				img.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				img.stage.addEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
				img.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}	
			catch (err:Error)
			{
				
			}
		}
		//public function mouseOutHandler(event:MouseEvent):void {
			//try 
			//{
				//img.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				//img.stage.removeEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
				//img.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
			//}
			//catch (err:Error)
			//{
				//
			//}
		//}
		public function mouseMoveHandler(event:MouseEvent):void {
			try 
			{
				var x:Number = GameInput.getInstance().MousePos.x - xOffset;
				//if mc's position exceeds the bounds, make it drag only half as far with each mouse movement (like iPhone/iPad behavior)
				if (x > bounds.left) {
					img.x = (x + bounds.left) * 0.5;
				} else if (x < bounds.left - xOverlap) {
					img.x = (x + bounds.left - xOverlap) * 0.5;
				} else {
					img.x = x;
				}
				var t:uint = getTimer();
				//if the frame rate is too high, we won't be able to track the velocity as well, so only update the values 20 times per second
				if (t - t2 > 50) 
				{
					x2 = x1;
					t2 = t1;
					x1 = img.x;
					t1 = t;
				}
				event.updateAfterEvent();
			}
			catch (err:Error)
			{
				
			}
		}
		public function mouseUpHandler(event:MouseEvent):void {
			try 
			{
				if (img == null || img.stage == null)	return;
				img.stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				img.stage.removeEventListener(MouseEvent.MOUSE_OUT, mouseUpHandler);
				img.stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
				var time:Number = (getTimer() - t2);	// So ms
				xVelocity = (img.x - x2) / time;		// so pixel / ms
				timeStamp = GameLogic.getInstance().CurServerTime;
				xAcceleration = 0.0025;
				var s:Number;
				var deltaTime:Number = Math.min(1000, Math.abs(xVelocity / xAcceleration));
				if (xVelocity > 0.2)
				{
					s = Math.max(xVelocity * deltaTime - xAcceleration * deltaTime * deltaTime / 2, 0);
					if ( - img.x + 75 < s)
					{
						s = -img.x + 75;
						xAcceleration = (xVelocity * deltaTime - s) * 2 / (deltaTime * deltaTime);
					}
					isSlideImg = true;
				}
				else if(xVelocity < -0.2)
				{
					s = Math.max(- xVelocity * deltaTime - xAcceleration * deltaTime * deltaTime / 2, 0);
					if ( Math.abs((bounds.right - IMG_WIDTH) - img.x - 75) < s)
					{
						s = Math.abs((bounds.right - IMG_WIDTH) - img.x - 75);
						xAcceleration = (- xVelocity * deltaTime - s) * 2 / (deltaTime * deltaTime);
					}
					isSlideImg = true;
				}
				else if(img.x > 0)
				{
					xVelocity = -0.75;
					xAcceleration = 0.00375 / (img.x / 75);
					isSlideImg = true;
					isComeBack = true;
				}
				else if(bounds.right - img.x > IMG_WIDTH)
				{
					xVelocity = 0.75;
					xAcceleration = 0.00375 / ((bounds.right - img.x - IMG_WIDTH) / 75);
					isSlideImg = true;
					isComeBack = true;
				}
			}
			catch (err:Error)
			{
				
			}	
		}
		public function Update():void 
			{
				if(isSlideImg)
				{
					var deltaXSlide:Number;
					var deltaTime:Number = (GameLogic.getInstance().CurServerTime - timeStamp) * 1000;
					if(deltaTime > 0)
					{
						if (xVelocity > 0)
						{
							if(!isComeBack)
							{
								deltaXSlide = xVelocity * deltaTime - xAcceleration * deltaTime * deltaTime / 2;
								img.x = img.x + deltaXSlide;
								xVelocity = xVelocity - xAcceleration * deltaTime;
								timeStamp = timeStamp + deltaTime / 1000;
								if (img.x >= 75)
								{
									isComeBack = true;
									xVelocity = -0.75;
									xAcceleration = 0.00375;
								}
								else if(xVelocity <= 0)
								{
									isSlideImg = false;
								}
							}
							else 
							{
								deltaXSlide = xVelocity * deltaTime - xAcceleration * deltaTime * deltaTime / 2;
								img.x = img.x + deltaXSlide;
								xVelocity = xVelocity - xAcceleration * deltaTime;
								timeStamp = timeStamp + deltaTime / 1000;
								if (img.x >= - IMG_WIDTH + bounds.right || xVelocity <= 0)
								{
									isSlideImg = false;
									img.x = - IMG_WIDTH + bounds.right;
									isComeBack = false;
								}
							}
						}
						else
						{
							if(!isComeBack)
							{
								deltaXSlide = xVelocity * deltaTime - xAcceleration * deltaTime * deltaTime / 2;
								img.x = img.x + deltaXSlide;
								xVelocity = xVelocity + xAcceleration * deltaTime;
								timeStamp = timeStamp + deltaTime / 1000;
								if (img.x <= - IMG_WIDTH + bounds.right - 75)
								{
									isComeBack = true;
									xVelocity = 0.75;
									xAcceleration = 0.00375;
								}
								else if(xVelocity >= 0)
								{
									isSlideImg = false;
								}
							}
							else 
							{
								deltaXSlide = xVelocity * deltaTime - xAcceleration * deltaTime * deltaTime / 2;
								img.x = img.x + deltaXSlide;
								xVelocity = xVelocity + xAcceleration * deltaTime;
								timeStamp = timeStamp + deltaTime / 1000;
								if (img.x <= 0 || xVelocity >= 0)
								{
									isComeBack = false;
									img.x = 0;
									isSlideImg = false;
								}
							}
						}
						if (btnNext && btnNext.img)
						{
							btnNext.SetPos(- img.x + 750, btnNext.GetPos().y);
						}
						if(btnPre && btnPre.img) 	btnPre.SetPos(- img.x + 25, btnPre.GetPos().y);
					}
				}
			}
		public function RefreshComponent():void 
		{
			ClearComponent();
			img.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			
			btnPre = AddButton(GUI_MAP_BTN_NEXT, "GuiMapOcean_BtnPrev", 25, 287, this);
			btnPre.SetVisible(false);
			btnNext = AddButton(GUI_MAP_BTN_PRE, "GuiMapOcean_BtnNext", 750, 287, this);
			btnNext.SetVisible(false);
			btnHome = AddButton(GUI_MAP_BTN_HOME, "GuiMapOcean_BtnHomeInMap", 96, 83, this);
			btnHome.setTooltip(new TooltipFormat());
			btnHome.setTooltipText("Trở về nhà");
			
			GuiMgr.getInstance().GuiMainFishWorld.arrPrgBossHealth = [];
			GuiMgr.getInstance().GuiMainFishWorld.prgBossArmorMetal = null;
			GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthMetal = null;
			GuiMgr.getInstance().GuiMainFishWorld.prgBossHealthIce = null;
			
			var i:int = 0;
			for (i = 0; i < BossMgr.getInstance().BossArr.length; i++) 
			{
				var bossRemove:Boss = BossMgr.getInstance().BossArr[i];
				bossRemove.Destructor();
			}
			BossMgr.getInstance().BossArr.splice(0, BossMgr.getInstance().BossArr.length);
			
			// vẽ các nút  vào thế giới cá dựa vào config (biển chưa được unlock) hoặc data server trả về (các biển đã được unlock)
			
			var ctn:Container;
			for (i = NUM_WORLD_IN_PAGE * curPage; i < Math.min(arrListOcean.length, NUM_WORLD_IN_PAGE * (curPage + 1)); i++) 
			{
				var item:Object = arrListOcean[i];
				ctn = AddContainer(GUI_MAP_CTN_MAP + (i + 1), "GuiMapOcean_ImgFrameFriend", 0, 0, true, this);
				var pos:Point = new Point();
				pos = arrPosCtn[i];
				ctn.SetPos(pos.x, pos.y);
				ctn.AddButton(GUI_MAP_BTN_MAP + (i + 1), "GuiMapOcean_BtnMap_" + (i + 1), 0, 0, this);
				ctn.AddImage("imgLock", "GuiMapOcean_ImgShopItemLock", 60, 0, true, ALIGN_LEFT_TOP);	
				ctn.GetImage("imgLock").img.visible = false;
				
				if (item.StateLock == 0)
				{
					ctn.GetImage("imgLock").img.visible = true;
				}
				else if (item.StateLock == 1)
				{
					ctn.GetImage("imgLock").img.visible = false;
				}
				
				var globalParent:Point = ctn.img.localToGlobal(new Point(0, 0));
				var GuiToolTip:GuiMapOceanToolTip = new GuiMapOceanToolTip(null, "");
				GuiToolTip.Init(item);
				GuiToolTip.InitPos(ctn, "GuiMapOcean_ImgBgGUIMap", globalParent.x, globalParent.y, 0, -0, 0, 0, true, false);
				ctn.setGUITooltip(GuiToolTip);
				
				arrCtnMap.push(ctn);
			}
			
			IMG_WIDTH = img.width;
			
			if(!eff)
			{
				eff = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiMapOcean_EffMapOcean", null, 405, 312, false, true);
				img.addChild(eff.img);
			}
			
			var isLoadWorld:Boolean = true;
			for (i = 0; i < ResMgr.getInstance().LoadingList.length; i++)
			{
				if (ResMgr.getInstance().LoadingList[i]["name"] == "LoadingWorld")
				{
					isLoadWorld = false;
					break;
				}
			}
			
			if (!isLoadWorld)
			{
				GuiMgr.getInstance().GuiWaitingContent.Init("LoadingWorld");
			}
			
			btnPre = AddButton(GUI_MAP_BTN_NEXT, "GuiMapOcean_BtnPrev", 25, 287, this);
			//btnPre.SetVisible(false);
			btnNext = AddButton(GUI_MAP_BTN_PRE, "GuiMapOcean_BtnNext", 750, 287, this);
			//btnNext.SetVisible(false);
			//Show tutorial
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("FirstOcean") >= 0)
			{
				GetContainer(GUI_MAP_CTN_MAP_1).AddImage("", "IcHelper", 167, 24);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case GUI_MAP_BTN_HOME:
					ComeBackHome();
				break;
				case GUI_MAP_BTN_PRE:
					if (isSlideImg)	return;
					xVelocity = -1.5;
					xAcceleration = 0.004;
					isSlideImg = true;
					break;
				case GUI_MAP_BTN_NEXT:
					if (isSlideImg)	return;
					xVelocity = 1.5;
					xAcceleration = 0.004;
					isSlideImg = true;
					break;
				case GUI_MAP_CTN_MAP_1:
				case GUI_MAP_CTN_MAP_2:
				case GUI_MAP_CTN_MAP_3:
				case GUI_MAP_CTN_MAP_4:
					if (isComingOcean)	return;
					isComingOcean = true;
					var index:int = Constant.TYPE_MYFISH;
					if (buttonID.split("_").length >= 2)	index = buttonID.split("_")[1];
					if(index > 0)
					{
						var strShow:String;
						var ctn:Container = arrCtnMap[index - 1] as Container;
						var objSea:Object = arrListOcean[index - 1];
						
						if (arrListOcean[objSea.Id - 1].Monster is Array)
						{
							Ultility.ResetStateIsDie();
						}
						if (Ultility.GetFishSoldierCanGoToWorld().length <= 0) 
						{
							if (GameLogic.getInstance().user.GetMyInfo().MySoldierArr.length <= 0)
							{
								strShow = Localization.getInstance().getString("Tooltip74");
							}
							else 
							{
								strShow = Localization.getInstance().getString("Tooltip73");
							}
							GuiMgr.getInstance().GuiMessageBox.ShowOK(strShow, 310, 200, GUIMessageBox.NPC_MERMAID_WAR);	
							return;
						}
						
						if (ctn && ctn.GetImage("imgLock") && ctn.GetImage("imgLock").img && ctn.GetImage("imgLock").img.visible)
						{
							GuiMgr.getInstance().GuiUnlockOcean.setInfoOcean(dataLoadSea, objSea, buttonID);
							GuiMgr.getInstance().GuiUnlockOcean.Show(Constant.GUI_MIN_LAYER, 3);
						}
						else 
						{
							if (arrListOcean[objSea.Id - 1].Monster is Array)
							{
								// Kiểm tra xem có đủ thời gian để vào lại chưa
								// Nếu chưa thì show gui chờ (xử lý trong hàm CheckCanReJoinOcean)
								// Nếu đủ rồi thì cho vào
								if (CheckCanReJoinOcean(objSea.Id, objSea.JoinNum, objSea.LastJoinTime, buttonID))
								{
									FishWorldController.SetSeaId(index);
									GoToOcean(index);
								}
								else 
								{
									isComingOcean = false;
								}
							}
							else 
							{
								FishWorldController.SetSeaId(index);
								FishWorldController.SetInfoForRound2(arrListOcean[objSea.Id - 1]);
								GoToOcean(index);
								GuiMgr.getInstance().GuiIntroOcean.ShowGUI();
							}
							if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible)
							{
								GuiMgr.getInstance().GuiMainFishWorld.ClearStoreComponent();
								GuiMgr.getInstance().GuiMainFishWorld.InitStore(GuiMgr.getInstance().GuiMainFishWorld.CurrentStore, 0);
							}
						}
					}
				break;
			}
		}
		
		private function CheckCanReJoinOcean(seaId:int, joinNum:int, lastJoinTime:Number, buttonId:String = ""):Boolean
		{
			var curServerTime:Number = GameLogic.getInstance().CurServerTime;
			var deltaTime:Number = curServerTime - lastJoinTime;
			//var obj:Object = ConfigJSON.getInstance().GetItemList("Param");
			var obj:Object = ConfigJSON.getInstance().GetItemList("Sea")[seaId.toString()];
			var objJoinSeaTime:Array = obj.JoinSeaTime;
			var objJoinSeaZingxu:Array = obj.JoinSeaZingxu;
			var maxTimeJoinSeaAday:Object = (ConfigJSON.getInstance().GetItemList("Sea")[seaId.toString()].JoinSeaTime as Array).length;
			var numSec:int = objJoinSeaTime[joinNum];
			var numZXu:int = objJoinSeaZingxu[joinNum];
			if(joinNum < maxTimeJoinSeaAday)
			{
				if (deltaTime >= numSec)
				{
					if(!SendJoinSeaAgain.isSendPacket)
					{
						SendJoinSeaAgain.isSendPacket = true;
						var cmd:SendJoinSeaAgain = new SendJoinSeaAgain(seaId, "");
						Exchange.GetInstance().Send(cmd);
						return true;
					}
					else 
					{
						return false;
					}
				}
				else 
				{
					GuiMgr.getInstance().GuiWaitReJoinMap.Init(seaId, joinNum, lastJoinTime, numZXu);
					return false;
				}
			}
			else 
			{
				var posStart:Point = GameInput.getInstance().MousePos;
				Ultility.ShowEffText("Bạn đã vào đủ số lần được phép\nHẹn gặp bạn vào ngày hôm sau!", GetContainer(buttonId).img, posStart,
					new Point(posStart.x, posStart.y - 100));
				isComingOcean = false;
				return false;
			}
		}
		
		public function ComeBackHome():void 
		{
			var i:int = 0;
			if(GameController.getInstance().typeFishWorld != Constant.TYPE_MYFISH)
			{
				//Ultility.PanScreenView();
				if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST)
				{
					GuiMgr.getInstance().GuiBackMainForest.DoBackForestWorld();
				}
				if(GuiMgr.getInstance().GuiInfoForestWorld.IsVisible)	GuiMgr.getInstance().GuiInfoForestWorld.Hide();
				if(GuiMgr.getInstance().GuiFogInForestWold.IsVisible)	GuiMgr.getInstance().GuiFogInForestWold.Hide();
				if(GuiMgr.getInstance().GuiEffRandomSeaRightGreen.IsVisible)	GuiMgr.getInstance().GuiEffRandomSeaRightGreen.Hide();
				if(GuiMgr.getInstance().GuiBackMainForest.IsVisible)	GuiMgr.getInstance().GuiBackMainForest.Hide();
				if(GuiMgr.getInstance().GuiChooseSerialAttack.IsVisible)	GuiMgr.getInstance().GuiChooseSerialAttack.Hide();
				if(GuiMgr.getInstance().GuiMainFishWorld.IsVisible)	GuiMgr.getInstance().GuiMainFishWorld.Hide();
				if(GuiMgr.getInstance().GuiGameOceanHappy.IsVisible)	GuiMgr.getInstance().GuiGameOceanHappy.Hide();
				GuiMgr.getInstance().GuiMainFishWorld = new GUIMainFishWorld(null, "");
				
				GameController.getInstance().typeFishWorld = Constant.TYPE_MYFISH;
				GameLogic.getInstance().SetMode(GameMode.GAMEMODE_NORMAL);
				GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_NORMAL);
				FishWorldController.SetSeaId(0);
				FishWorldController.SetRound(0);
				
				GameLogic.getInstance().user.backGround = new Decorate(null, "", 0, 0, "BackGround", Constant.ID_DEFAULT_BACKGROUND);
				GameController.getInstance().SetBackground(GameLogic.getInstance().user.backGround.Id, true, true, true);
				GuiMgr.getInstance().GuiMain = new GUIMain(null, "");
				GuiMgr.getInstance().GuiMain.Show();
				
				for (i = 0; i < GameLogic.getInstance().user.FishArr.length; i++) 
				{
					var fs:Fish = GameLogic.getInstance().user.FishArr[i];
					fs.Destructor();
				}
				GameLogic.getInstance().user.FishArr.slice(0, GameLogic.getInstance().user.FishArr.length);
				
				for (i = 0; i < GameLogic.getInstance().user.FishSoldierArr.length; i++) 
				{
					var fsSoldiser:Fish = GameLogic.getInstance().user.FishSoldierArr[i];
					fsSoldiser.Destructor();
				}
				GameLogic.getInstance().user.FishSoldierArr.slice(0, GameLogic.getInstance().user.FishSoldierArr.length);
				
				for (i = 0; i < BossMgr.getInstance().BossArr.length; i++) 
				{
					var boss:Boss = BossMgr.getInstance().BossArr[i];
					boss.Destructor();
				}
				BossMgr.getInstance().BossArr.slice(0, BossMgr.getInstance().BossArr.length);
				
				for (i = 0; i < GameLogic.getInstance().user.arrSubBossMetal.length; i++) 
				{
					var subBossMetal:SubBossMetal = GameLogic.getInstance().user.arrSubBossMetal[i];
					subBossMetal.Destructor();
				}
				GameLogic.getInstance().user.arrSubBossMetal.slice(0, GameLogic.getInstance().user.arrSubBossMetal.length);
				
				if(GameLogic.getInstance().user.bossMetal)	GameLogic.getInstance().user.bossMetal.Destructor();
				GameLogic.getInstance().user.bossMetal = null;
				
				if(GameLogic.getInstance().user.bossIce)	GameLogic.getInstance().user.bossIce.Destructor();
				GameLogic.getInstance().user.bossIce = null;
				
				for (i = 0; i < GameLogic.getInstance().user.arrSubBossIce.length; i++) 
				{
					var subBossIce:SubBossIce = GameLogic.getInstance().user.arrSubBossIce[i];
					subBossIce.Destructor();
				}
				GameLogic.getInstance().user.arrSubBossIce.slice(0, GameLogic.getInstance().user.arrSubBossIce.length);
				
				var test:SendInitRun = new SendInitRun();
				Exchange.GetInstance().Send(test);
				
				//var sol:SendGetAllSoldier = new SendGetAllSoldier(GameLogic.getInstance().user.Id.toString());
				var sol:SendGetAllSoldier = new SendGetAllSoldier();
				Exchange.GetInstance().Send(sol);
				
				// show waiting screen
				GuiMgr.getInstance().GuiWaitingData.Show(Constant.TopLayer-1, 1);
				
				// add GuiTopInfo
				//GuiMgr.getInstance().GuiTopInfo.ShowMyHome();
				
				// add Setting gui
				//GuiMgr.getInstance().GuiSetting = new GUISetting(null, "");
				//GuiMgr.getInstance().GuiSetting.Show();
				
				// Add gui friends
				// MinhT
				GuiMgr.getInstance().GuiFriends = new GUIFriends(null, "");
				GuiMgr.getInstance().GuiFriends.Show();		
			
				
				if (GuiMgr.IsFullScreen)
				{	
					SetScreen();
					GuiMgr.IsFullScreen = false;
					GuiMgr.getInstance().DoFullScreen(GuiMgr.IsFullScreen);
				}
				
				
				var friendlist: SendRefreshFriend = new SendRefreshFriend(false);
				Exchange.GetInstance().Send(friendlist);	
			}
			GuiMgr.getInstance().GuiSetting.SetPos(Constant.STAGE_WIDTH - 27 - 52, 76);
			Hide();
			
			if (GuiMgr.getInstance().GuiMainForest.IsVisible)	GuiMgr.getInstance().GuiMainForest.Hide();
		}
		private function SetScreen():void 
		{
			if (Main.imgRoot.stage.displayState != StageDisplayState.FULL_SCREEN)
			{	
				img.stage.scaleMode = StageScaleMode.NO_SCALE;
				img.stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else
			{				
				img.stage.displayState = StageDisplayState.NORMAL;
			}
		}
		public function GoToOcean(index:int):void 
		{
			var ctn:Container = arrCtnMap[index - 1] as Container;
			if (ctn && ctn.guiTooltip && ctn.guiTooltip.IsVisible)	ctn.guiTooltip.Hide();
			var roundId:int = GetRoundFromListMonster(arrListOcean[index - 1].Monster);
			// do mỗi biển chỉ có 4 vòng thôi
			if (roundId > 4)
			{
				return;
			}
			
			var arrFishSoldierInMyFish:Array = GameLogic.getInstance().user.GetFishSoldierArr();
			var arrFishInMyFish:Array = GameLogic.getInstance().user.GetFishArr();
			var i:int = 0;
			for (i = 0; i < arrFishInMyFish.length; i++) 
			{
				(arrFishInMyFish[i] as Fish).Destructor();
			}
			arrFishInMyFish.splice(0, arrFishInMyFish.length);
			for (i = 0; i < arrFishSoldierInMyFish.length; i++) 
			{
				(arrFishSoldierInMyFish[i] as FishSoldier).Destructor();
			}
			arrFishSoldierInMyFish.splice(0, arrFishSoldierInMyFish.length);
			
			// nếu còn túi tân thủ thì ẩn đi
			if (GameLogic.getInstance().user.tuiTanThu)	GameLogic.getInstance().user.tuiTanThu.Clear();
			GameLogic.getInstance().isAttacking = false;
			if (GameController.getInstance().typeFishWorld == index)
			{
				Hide();
				GameLogic.getInstance().SetMode(GameMode.GAMEMODE_NORMAL);
				GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
				GuiMgr.getInstance().GuiInfoWarInWorld.Hide();
				GameLogic.getInstance().Reset();
				initFish(FishWorldController.GetSeaId());
				return;
			}
			GameController.getInstance().typeFishWorld = index;
			GameLogic.getInstance().Reset(false);
			
			//var layerBg:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
			//GameController.getInstance().PanScreenX( -layerBg.x);
			//GameController.getInstance().PanScreenY( -layerBg.y - (Constant.TOP_LAKE - Constant.TOP_LAKE_FISH_WORLD));
			var object:Object = new Object();
			object.ExpiredTime = int.MAX_VALUE;
			object.Id = int.MAX_VALUE;
			switch (index) 
			{
				case Constant.OCEAN_NEUTRALITY:
					object.ItemId = Constant.ID_FISH_WORLD_BACKGROUND_1;
				break;
				case Constant.OCEAN_METAL:
					object.ItemId = Constant.ID_FISH_WORLD_BACKGROUND_2;
				break;
				case Constant.OCEAN_ICE:
					object.ItemId = Constant.ID_FISH_WORLD_BACKGROUND_3;
				break;
				case Constant.OCEAN_FOREST:
					object.ItemId = Constant.ID_FISH_WORLD_BACKGROUND_4;
				break;
			}
			object.X = 0;
			object.Y = 0;
			object.Z = 0;
			GameLogic.getInstance().user.initBackGround(object);
			
			GuiMgr.getInstance().GuiMain.Hide();
			GuiMgr.getInstance().GuiFriends.Hide();
			if (GuiMgr.getInstance().GuiAnnounce.IsVisible)	GuiMgr.getInstance().GuiAnnounce.Hide();
			//GuiMgr.getInstance().GuiTopInfo.ShowFishWorld(index);
			GuiMgr.getInstance().guiFrontScreen.Hide();
			
			// Fake du lieu ca server tra ve
			initFish(index);
			if(FishWorldController.GetSeaId() != Constant.OCEAN_FOREST)
			{
				GuiMgr.getInstance().GuiMainFishWorld.Show(Constant.GUI_MIN_LAYER, 0);
			}
			
			if (GuiMgr.IsFullScreen)
			{	
				SetScreen();
				GuiMgr.IsFullScreen = false;
				GuiMgr.getInstance().DoFullScreen(GuiMgr.IsFullScreen);
			}
			
			Hide();
		}
		
		public function initFish(SeaId:int, isCreateBattle:Boolean = false):void 
		{
			var obj:Array;
			if(SeaId < 5 && SeaId > 0)
			{
				obj = initDataListFish(arrListOcean[SeaId - 1].Monster, SeaId);
			}
			else 
			{
				obj = [];
			}
			
			if (obj && obj.length > 0 || SeaId >= 4)
			{
				GameLogic.getInstance().user.InitFishWorld(obj, isCreateBattle);
			}
		}
		
		public function UpdateFishSoldier(fish:FishSoldier):void 
		{
			var obj:Object = arrListOcean[FishWorldController.GetSeaId() - 1].Monster[FishWorldController.GetRound().toString()];
			for (var i:String in obj) 
			{
				if (obj[i] != null && fish.Id == obj[i].Id)
				{
					delete(obj[i]);
					//obj[i] = null;
					break;
				}
			}
			//var objTemp:Object;
			//for (var j:String in obj) 
			//{
				//if (obj[j] != null)
				//{
					//if(objTemp == null)		objTemp = new Object();
					//objTemp[j] = new Object();
					//objTemp[j] = obj[j];
				//}
			//}
			//arrListOcean[FishWorldController.GetSeaId() - 1].Monster[FishWorldController.GetRound().toString()] = objTemp;
		}
		
		private function initDataListFish(monster:Object = null, SeaId:int = 1):Array
		{
			var data:Array = new Array();
			//var round:int = Math.min(1 + Math.floor(4 * Math.random()), 3);
			var round:int = GetRoundFromListMonster(monster);
			FishWorldController.SetRound(round);
			for (var i:String in monster[round.toString()]) 
			{
				var item:Object = monster[round.toString()][i];
				data.push(item);
			}
			return data;
		}
		
		public function createNewDataForASea(Sea:Object, IdSea:String):void 
		{
			var arr:Array = [];
			var arrItemUnlock:Array = [];
			var strIdSea:String = "SeaId";
			for (var j:int = 0; j < arrListOcean.length; j++) 
			{
				var item:Object = arrListOcean[j];
				if (IdSea == item.Id)
				{
					item = objAllSea[String(Sea[strIdSea])];
					// Các vật phẩm có thể nhận được
					for (var jStr:String in item.Item) 
					{
						var str:String = item.Item[jStr].ItemType;
						if (item.Item[jStr].ItemType == "Visa")
						{
							str = str + item.Item[jStr].ItemId;
						}
						else
						{
							str = str + item.Item[jStr].Rank;
							str = str + "_Shop";
						}
						arr.push(str);
						
					}
					item.ListItem = arr;
					
					item["StateLock"] = 1;
					item.Monster = Sea.Monster;
					
					item.JoinNum = Sea.JoinNum;
					item.LastJoinTime = Sea.LastJoinTime;
					arrItemUnlock = [];
					for (var i:int = 0; i < arr.length; i++) 
					{
						var strNameUnlock:String = arr[i];
						if (Sea.ItemList)
						{
							if (CheckItemHave(strNameUnlock, Sea.ItemList))
							{
								arrItemUnlock.push(1);
							}
							else 
							{
								arrItemUnlock.push(0);
							}
						}
						else 
						{
							arrItemUnlock.push(0);
						}
					}
					item.ListUnlock = arrItemUnlock;
				}
			}
		}
		
		public function initDataForASea(Sea:Object, isUnlock:Boolean = true):void 
		{
			var obj:Object = new Object();
			var arr:Array = [];
			var arrItemUnlock:Array = [];
			var pos:Point = new Point();
			var strIdSea:String = "Id";
			if (isUnlock)	strIdSea = "SeaId";
			if(Sea[strIdSea] <= 4)
			{
				obj = objAllSea[String(Sea[strIdSea])];
				obj.JoinNum = Sea.JoinNum;
				obj.LastJoinTime = Sea.LastJoinTime;
				
				// các trường phục vụ cho thế giới mộc - vòng đánh 4 con Boss
				if(Sea.arrRandomBuff != null)		obj.arrRandomBuff = Sea.arrRandomBuff;
				if(Sea.currentMonster != null)		obj.currentMonster = Sea.currentMonster;
				if(Sea.sequenceYellowDown != null)	obj.sequenceYellowDown = Sea.sequenceYellowDown;
				if(Sea.sequenceRedUp != null)		obj.sequenceRedUp = Sea.sequenceRedUp;
				
				// Các vật phẩm có thể nhận được
				for (var jStr:String in obj.Item) 
				{
					var str:String = obj.Item[jStr].ItemType;
					if (obj.Item[jStr].ItemType == "Visa")
					{
						str = str + obj.Item[jStr].ItemId;
					}
					else
					{
						str = str + obj.Item[jStr].Rank;
						str = str + "_Shop";
					}
					arr.push(str);
					
				}
				obj.ListItem = arr;
				
				if (!isUnlock)
				{
					obj["StateLock"] = 0;	// = 0 là chưa được unlock, = 1 là đã được unlock
					obj.Monters = null;
				}
				else
				{
					obj["StateLock"] = 1;
					obj.Monster = Sea.Monster;
				}
				
				obj.JoinNum = Sea.JoinNum;
				obj.LastJoinTime = Sea.LastJoinTime;
				
				for (var i:int = 0; i < arr.length; i++) 
				{
					var item:String = arr[i];
					if (isUnlock && Sea.ItemList)
					{
						if (CheckItemHave(item, Sea.ItemList))
						{
							arrItemUnlock.push(1);
						}
						else 
						{
							arrItemUnlock.push(0);
						}
					}
					else 
					{
						arrItemUnlock.push(0);
					}
				}
				obj.ListUnlock = arrItemUnlock;
				switch (int(Sea[strIdSea])) 
				{
					case Constant.OCEAN_NEUTRALITY:
						pos = new Point(46, 320);
					break;
					case Constant.OCEAN_METAL:
						pos = new Point(380, 55);
					break;
					case Constant.OCEAN_ICE:
						pos = new Point(338, 340);
						if(Sea && Sea.Wave)	obj.Wave = Sea.Wave;
					break;
					case Constant.OCEAN_FOREST:
						pos = new Point(846, 148);
					break;
				}
				
				arrListOcean.push(obj);
				arrPosCtn.push(pos);
			
			}
		}
		
		/**
		 * 
		 * @param	data		: 	Dữ liệu nhận từ server
		 * @param	isLoadOcean
		 */
		public function InitDataForAllSea(data:Object, isLoadOcean:Boolean = true):void 
		{
			var iStr:String;
			arrCtnMap = [];
			if(isLoadOcean)
			{
				arrListOcean = new Array();
				arrPosCtn = new Array();
				curPage = 0;
				dataLoadSea = data;
				objAllSea = ConfigJSON.getInstance().getItemInfo("Sea");
				for (iStr in objAllSea) 
				{
					if(data[iStr] == null)
					{
						initDataForASea(objAllSea[iStr], false)
					}
					else 
					{
						initDataForASea(data[iStr], true)
					}
				}
			}
			else
			{
				objAllSea = ConfigJSON.getInstance().getItemInfo("Sea");
				for (iStr in data) 
				{
					createNewDataForASea(data[iStr], iStr);
				}
			}
		}
		
		public function GetRoundFromListMonster(monster:Object):int 
		{
			for (var i:int = 1; i < 5; i++) 
			{
				if (monster == null || monster is Array)	return 5;
				var obj:Object = monster[i.toString()];
				for (var j:String in obj) 
				{
					if (obj[j] != null)
					{
						return i;
					}
				}
			}
			return 5;
		}
		
		/**
		 * Kiểm tra xem vật phẩm name đã được nhặt chưa, danh sách các vật phẩm nhặt được là obj
		 * @param	name	:	tên vật phẩm cần kiểm tra
		 * @param	obj		:	Danh sách các vật phẩm đã nhặt được
		 * @return
		 */
		private function CheckItemHave(name:String, arr:Array):Boolean
		{
			if (arr == null || arr.length == 0)	return false;
			for (var i:int = 0; i < arr.length; i++)
			{
				var item:Object = arr[i];
				var str:String = item.ItemType;
				if (str == "Visa")
				{
					str = str + item.ItemId;
				}
				else 
				{
					str = str + item.Rank + "_Shop";
				}
				if (name == str)	return true;
			}
			return false;
		}
	}
}