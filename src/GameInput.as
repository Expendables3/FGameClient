package 
{
	import com.greensock.loading.data.XMLLoaderVars;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Event.EventNoel.NoelGui.ItemGui.Bullet.BulletScenario;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import GUI.ChampionLeague.GuiLeague.GUIDailyGift;
	import flash.ui.Mouse;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.component.Container;
	import GUI.EventMagicPotions.BossHerb;
	import GUI.EventMidle8.GUIGameEventMidle8;
	import GUI.*;
	import GUI.ChampionLeague.PackageLeague.SendGetGiftLeague;
	import GUI.component.ActiveTooltip;
	import GUI.component.TooltipFormat;
	import GUI.EventMagicPotions.BossHerb;
	import GUI.FishWorld.Boss;
	import GUI.FishWorld.BossIce;
	import GUI.FishWorld.BossMetal;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.ForestWorld.Thicket;
	import GUI.FishWorld.Network.SendUnlockSea;
	import GUI.FishWorld.SubBossIce;
	import GUI.FishWorld.SubBossMetal;
	import Logic.*;
	import GameControl.*;
	import Logic.EventNationalCelebration.FireworkFish;
	import NetworkPacket.PacketSend.SendAcceptGift;
	import NetworkPacket.PacketSend.SendAttackFriendLake;
	import NetworkPacket.PacketSend.SendClickGrave;
	import NetworkPacket.PacketSend.SendGetLog;
	import NetworkPacket.PacketSend.SendOpenTrunk;
	import NetworkPacket.PacketSend.SendRemoveLog;
	import NetworkPacket.PacketSend.SendSignKey;
	import NetworkPacket.PacketSend.SendUnlockSlotMaterial;
	import NetworkPacket.PacketSend.SendUseItemSoldier;
	import particleSys.Emitter;
	import particleSys.myFish.ExplodeEmit;
	import particleSys.sample.WaterFallEmit;
	import Sound.SoundMgr;
	
	/**
	 * Xử lý các sự kiện input từ bàn phím bao gồm các sự kiện:
	 * <br> - Trên mỗi đối tượng <br>
	 * <br> - Trên stage chính </br>
	 * @author tuan
	 */
	public class  GameInput
	{
		private static var instance:GameInput = new GameInput();
		public var MousePos:Point = new Point(0, 0);
		private var IsMouseDown:Boolean = false;
		public var IsDragScreen:Boolean = false;
		private var LastMouseDownPos:Point = new Point();
		public var matIndex:int = 0;
		//public var isClickFish:Boolean = false;
		public var lastAttackTime:Number = 0;
		
		public var isPressTab:Boolean = false;
		
		public function GameInput():void
		{
			
		}
		
		/**
		 * Lấy một thể hiện chung của lớp GameInput
		 * <br>Thể hiện này mang tính chất gần như 1 biến toàn cục </br>
		 */
		public static function getInstance():GameInput
		{
			if(instance == null)
			{
				instance = new GameInput();
			}
				
			return instance;
		}
		
		/**
		 * Bắt sự kiện ấn bàn phím trên các đối tượng trong game
		 * @param event thông tin về sự kiện
		 * @param obj đối tượng phát sinh sự kiện
		 */
		public function OnKeyDownObject(event:KeyboardEvent, obj:BaseObject):void
		{
			switch(event.keyCode)
			{
				case Keyboard.ESCAPE:
				{
					//GameLogic.getInstance().BackToIdleGameState();
					//if (GameController.getInstance().typeFishWorld != Constant.TYPE_MYFISH)
					//{
						//GuiMgr.getInstance().GuiMainFishWorld.listFishInOcean.updateAllGuiToolTip();
					//}
					//break;
				}				
			}
			
			switch(obj.ClassName)
			{
				case "Fish":
					break;
				case "Tree":
					break;
			}
			//trace(event.keyCode);
		}
		
		/**
		 * Bắt sự kiện nhả bàn phím trên các đối tượng trong game
		 * @param event thông tin về sự kiện
		 * @param obj đối tượng phát sinh sự kiện
		 */
		public function OnKeyUpObject(event:KeyboardEvent, obj:BaseObject):void
		{
			switch(obj.ClassName)
			{
				case "Fish":
					break;
				case "Tree":
					break;
				
			}
		}
		
		/**
		 * Bắt sự kiện chuột di chuển trên các đối tượng trong game
		 * @param event thông tin về sự kiện
		 * @param obj đối tượng phát sinh sự kiện
		 */
		public function onMouseMoveObject(event:MouseEvent, obj:BaseObject):void
		{
			//trace("mousePos: " + event.localX + ", " + event.localY)
			switch(obj.ClassName)
			{
				case "Fish":					
					break;
				case "Tree":
					break;
			}
		}
		
		
		/**
		 * Bắt sự kiện chuột click vào các đối tượng trong game
		 * @param event thông tin về sự kiện
		 * @param obj đối tượng phát sinh sự kiện
		 */
		public function OnMouseClickObject(event:MouseEvent, obj:BaseObject):void
		{	
			//if (GameLogic.getInstance().gameState == GameState.GAMESTATE_OPEN_MAGIC_BAG) return;
			switch(obj.ClassName)
			{
				case "Decorate":
					OnClickDecorate(obj as Decorate);
					break;				
				case "BossHerb":
					(obj as BossHerb).OnClick();
					break;
				case "Fish":
				case "FishSoldier":
				case "SubBossMetal":
				case "SubBossIce":
					OnClickFish(obj as Fish);					
					break;
				case "Thicket":
					OnClickThicket(obj as Thicket);		
					break;
				case "BossIce":
					OnClickBossIce(obj as BossIce);					
					break;
				case "BossMetal":
					OnClickBossMetal(obj as BossMetal);					
					break;
				case "Boss":
					OnClickBoss(obj as Boss);					
					break;
				case "FishSpartan":
					OnClickFishSpartan(obj as FishSpartan);					
					break;
				case "Emotion":
					switch(GameController.getInstance().typeFishWorld)
					{
						case Constant.TYPE_MYFISH:
							OnClickFishEmotion(obj as EmotionImg);
							break;
						case Constant.OCEAN_NEUTRALITY:
						case Constant.OCEAN_METAL:
						case Constant.OCEAN_ICE:
							if (GameLogic.getInstance().isAttacking)	return;
							if (((obj as EmotionImg).MyFish is SubBossIce) && (((obj as EmotionImg).MyFish as SubBossIce)).PreDie)	return;
							if (((obj as EmotionImg).MyFish is SubBossMetal) && (((obj as EmotionImg).MyFish as SubBossMetal)).State == Fish.FS_PRE_DEAD)	return;
							OnClickFishEmotion(obj as EmotionImg);
							break;
						case Constant.OCEAN_FOREST:
							if (GameLogic.getInstance().isAttacking == true)
							{
								return;
							}
							else if(	(obj as EmotionImg).MyFish != null
									&& (obj as EmotionImg).ImgName.search("War") >= 0)
							{
								if ((FishWorldController.GetRound() == Constant.SEA_ROUND_3 && GameLogic.getInstance().countNumEffHoiSinh <= 0) ||
									FishWorldController.GetRound() != Constant.SEA_ROUND_3)
								{
									trace("GameLogic.getInstance().gameState",GameLogic.getInstance().gameState);
									//GameState
									ProcessWarInForestWorld((obj as EmotionImg).MyFish as FishSoldier);
								}
							}
							else if ( (obj as EmotionImg).MyFish != null 
									&& (obj as EmotionImg).MyFish.Emotion == FishSoldier.WEAK
									&& ((obj as EmotionImg).MyFish as FishSoldier).isActor == FishSoldier.ACTOR_MINE
									&& GuiMgr.getInstance().GuiMainFishWorld.CheckCanCatchEventMouseRecoverHelth())
							{
								GuiMgr.getInstance().GuiRecoverHealth.Init((obj as EmotionImg).MyFish as FishSoldier);
							}
						break;
					}
					
					event.stopPropagation();
					break;
				case "Pocket":
					var pocket:Pocket = obj as Pocket;
					pocket.OnMouseClickPocket();
					event.stopPropagation();
					break;	
				//case "FallingObject":
					//var mat:FallingObject = obj as FallingObject;
					//OnClickFallingObject(mat);
					//event.stopPropagation();
					//break;
				//case "Treasure":
					//var treasure:Treasure = obj as Treasure;
					//trace("gamestate = " + GameLogic.getInstance().gameState + "----------");
					//if (GameLogic.getInstance().gameState == GameState.GAMESTATE_TREASURE + treasure.type)
					//{
						//treasure.OpenTreasure(/*treasure.type*/);
					//}
					//break;
			}
		}
		
		public function ProcessWarInForestWorld(fs:FishSoldier):void 
		{
			// Neu khong co con ca nao duoc chon thi tu chon lai con ca manh nhat trong dam ca con lai
			if (GameLogic.getInstance().user.CurSoldier[0] == null)
			{
				var arrFSInForestWorld:Array = GameLogic.getInstance().user.FishSoldierActorMine;
				if(arrFSInForestWorld.length > 0)
				{
					GameLogic.getInstance().user.CurSoldier[0] = FishSoldier.FindBestSoldier(arrFSInForestWorld);
				}
			}
			if (GameLogic.getInstance().user.CurSoldier[0] == null && arrFSInForestWorld.length > 0)
			{
				GameLogic.getInstance().user.CurSoldier[0] = arrFSInForestWorld[0];
			}
			// Chu y la doan nay ca 4 con lao vao danh neu o vong 4
			// ty sua tiep
			if (GameLogic.getInstance().user.CurSoldier[0] != null)
			{
				if(FishWorldController.GetRound() <= Constant.OCEAN_FOREST_ROUND_3)
				{
					GameLogic.getInstance().user.CurSoldier[1] = fs;
					GuiMgr.getInstance().GuiMainForest.processChooseFishWar();
				}
				else if(FishWorldController.GetRound() == Constant.OCEAN_FOREST_ROUND_4)
				{
					GuiMgr.getInstance().GuiBackMainForest.ProcessGetGift(GameLogic.getInstance().user.CurSoldier[0]);
					(GuiMgr.getInstance().GuiMainForest.arrMonsterGift[0] as FishSoldier).SetEmotion(Fish.IDLE);
				}
			}
			else
			{
				GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWorld(Localization.getInstance().getString("FishWarMsg33"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
			}
		}
		
		public function OnMouseOverObject(event:MouseEvent, obj:BaseObject):void
		{
			if (GameController.getInstance().gameMode == GameController.GAME_MODE_BOSS_SERVER)
			{
				return;
			}
			switch(obj.ClassName)
			{
				case "Decorate":				
					break;				
				case "Fish":
				case "FishSoldier":
				case "FireworkFish":
				case "SubBossMetal":
				case "SubBossIce":
				case "Thicket":
					if(Fish.dragingFish == null)
						GameLogic.getInstance().BackToOldMouse();
					OnOverFish(obj as Fish);
					break;
				case "Boss":
					OnOverBoss(obj as Boss);
					break;
				case "BossMetal":
					OnOverBossMetal(obj as BossMetal);
					break;
				case "BossIce":
					OnOverBossIce(obj as BossIce);
					break;
				case "FishSpartan":
					OnOverFishSpartan(obj as FishSpartan);
					break;
				case "Emotion":
					switch (GameController.getInstance().typeFishWorld) 
					{
						case Constant.OCEAN_NEUTRALITY:
						case Constant.OCEAN_METAL:
						case Constant.OCEAN_ICE:
						case Constant.OCEAN_FOREST:
							var emo1:EmotionImg = obj as EmotionImg;
							if(emo1.MyFish != null)
							{
								emo1.MyFish.SetHighLight();
							}
							if (!GuiMgr.getInstance().GuiFishInfo.IsVisible)
							{
								
							}
							break;
						default:
							if (!GuiMgr.getInstance().GuiFishInfo.IsVisible)
							{
								var emo:EmotionImg = obj as EmotionImg;
								if (emo.MyFish.Emotion != Fish.HAPPY && emo.MyFish.Emotion != Fish.LOVE)
								{
									if(!(emo.MyFish is SubBossMetal) && !(emo.MyFish is SubBossIce))
									{
										emo.MyFish.SetMovingState(Fish.FS_IDLE);
									}
									emo.MyFish.SetHighLight();
								}
							}
							break;
					}
					break;
				//case "MixLake":
					//var mixlake:MixLake = obj as MixLake;
					//mixlake.OnMouseOver();
					//break;					
				//case "Pocket":
					//var pocket:Pocket = obj as Pocket;
					//pocket.OnMouseOver();
					//break;		
				case "FallingObject":
					GameLogic.getInstance().MouseTransform("imgHand");;
					var mat:FallingObject = obj as FallingObject;
					if (mat.stayInLake)
					{
						mat.SetHighLight();
						var tooltip:TooltipFormat = new TooltipFormat();
						tooltip.htmlText = "Tất Noel\n<font color='#ff0000'>(sưu tập đủ 10 chiếc để có 1 món quà)</font>";// Localization.getInstance().getString("TooltipFishBall");
						ActiveTooltip.getInstance().showNewToolTip(tooltip, mat.img);
					}
					else
					{
						if(mat.isFinishDeform)
						OnClickFallingObject(mat);
					}
					break;					
				case "Dirty":
					GameController.getInstance().UseTool("CleanLake");
			}
		}
		
		public function OnMouseOutObject(event:MouseEvent, obj:BaseObject):void
		{
			switch(obj.ClassName)
			{
				case "Decorate":
					break;				
				case "Fish":
				case "FishSoldier":
				case "FireworkFish":
				case "SubBossMetal":
				case "SubBossIce":
				case "Thicket":
					OnOutFish(obj as Fish);
					break;
				case "FishSpartan":
					OnOutFishSpartan(obj as FishSpartan);
					break;
				
				case "Boss":
					OnOutBoss(obj as Boss);
					break;
				
				case "BossMetal":
					OnOutBossMetal(obj as BossMetal);
					break;
				
				case "BossIce":
					OnOutBossIce(obj as BossIce);
					break;
				
				case "Emotion":
					switch (GameController.getInstance().typeFishWorld) 
					{
						//case Constant.OCEAN_HAPPY:
							//var emoOeanHappy:EmotionImg = obj as EmotionImg;
							//FishOceanHappy(emoOeanHappy.MyFishOceanHappy).SetMovingState(Fish.FS_SWIM);
							//FishOceanHappy(emoOeanHappy.MyFishOceanHappy).SetHighLight(-1);
							//FishOceanHappy(emoOeanHappy.MyFishOceanHappy.auxiliaryFish).SetMovingState(Fish.FS_SWIM);
							//FishOceanHappy(emoOeanHappy.MyFishOceanHappy.auxiliaryFish).SetHighLight(-1);
							//emoOeanHappy.SetHighLight(-1);
							//break;
						case Constant.OCEAN_NEUTRALITY:
						case Constant.OCEAN_METAL:
						case Constant.OCEAN_ICE:
						case Constant.OCEAN_FOREST:
							var emo1:EmotionImg = obj as EmotionImg;
							if(emo1.MyFish != null)
							{
								emo1.MyFish.SetHighLight( -1);
							}
							if (!GuiMgr.getInstance().GuiFishInfo.IsVisible)
							{
								
							}
							break;
						default:
							var gui:GUIFishInfo = GuiMgr.getInstance().GuiFishInfo;
							var emo:EmotionImg = obj as EmotionImg;
							var fish:Fish = GameLogic.getInstance().user.GetFishArr()[gui.FishId] as Fish;
							if ( (!gui.IsVisible || (fish != null && fish.Id != emo.MyFish.Id)) && emo.MyFish != Fish.dragingFish)
							{	
								if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR || emo.MyFish.State != Fish.FS_WAR)
								{
									emo.MyFish.SetHighLight( -1);
									if (emo.MyFish is FishSoldier)
									{
										var fs:FishSoldier = emo.MyFish as FishSoldier;
										if (fs.isActor != FishSoldier.ACTOR_MINE && fs.isInRightSide == true)
										{
											emo.MyFish.SetMovingState(Fish.FS_STANDBY);
											break;
										}
									}
									emo.MyFish.SetMovingState(Fish.FS_SWIM);
								}
							}
							break;
					}
					break;
				case "Dirty":
					GameLogic.getInstance().BackToOldMouse();
					break;
				//case "MixLake":
					//var mixlake:MixLake = obj as MixLake;
					//mixlake.OnMouseOut();					
					break;
				case "Pocket":
					obj.SetHighLight(-1);
					GameLogic.getInstance().BackToOldMouse();
					break;
				case "FallingObject":
					var mat:FallingObject = obj as FallingObject;
					mat.SetHighLight(-1);
					GameLogic.getInstance().BackToOldMouse();
					if (mat.stayInLake)
					{
						ActiveTooltip.getInstance().clearToolTip()
					}
					break;
			}
		}
		
		public function OnMouseDownObject(event:MouseEvent, obj:BaseObject):void
		{
			switch(obj.ClassName)
			{
				case "Decorate":				
					var deco:Decorate = obj as Decorate;
					if (GameLogic.getInstance().gameState == GameState.GAMESTATE_EDIT_DECORATE)
					{
						if (GuiMgr.getInstance().GuiDecorateInfo.CurObject != null)
						{
							GuiMgr.getInstance().GuiDecorateInfo.CurObject.SetHighLight( -1);
						}
						GameController.getInstance().ActiveObj = obj;
						obj.ChangeLayer(Constant.ACTIVE_LAYER);
						
						obj.ObjectState = BaseObject.OBJ_STATE_EDIT;
						GameController.getInstance().StartMoveDecorate();
						GuiMgr.getInstance().GuiDecorateInfo.CurObject = deco;
						if (deco.ItemType == "OceanAnimal")
						{
							deco.GoToAndStop(2);
						}
						GuiMgr.getInstance().GuiDecorateInfo.ShowDecoInfo(deco);
						deco.SetHighLight();
					}
					break;	
				/* Spartan hóa thạch*/
				case "FishSpartan":
					var fossil:FishSpartan = obj as FishSpartan;
					if (GameLogic.getInstance().gameState == GameState.GAMESTATE_EDIT_DECORATE &&
						!fossil.isExpired)
					{
						GameController.getInstance().ActiveObj = obj;
						obj.ChangeLayer(Constant.ACTIVE_LAYER);
						obj.ObjectState = BaseObject.OBJ_STATE_EDIT;
						GameController.getInstance().StartMoveDecorate();
						fossil.SetHighLight();
					}
					break;
				case "MotionObject":
					OnMouseDownMotionObject(obj as MotionObject);
					break;
			}
		}
		
		public function OnMouseUpObject(event:MouseEvent, obj:BaseObject):void
		{
			switch(obj.ClassName)
			{
				case "Decorate":
					//OnClickDecorate(obj as Decorate);
					break;
			}
		}
		
		/**
		 * Bắt sự kiện click chuột trên các button trong game
		 * @param event thông tin về sự kiện
		 * @param Id của button phát sinh ra sự kiện
		 */
		public function OnButtonClick(event:MouseEvent, btnID:int):void
		{
			
		}
		
		public function GenMap():void 
		{
			var SQUARE_LOCK:int = 0;
			var SQUARE_START:int = 1;
			var SQUARE_END:int = 2;
			var SQUARE_CAN_MOVE:int = 3;
			var SQUARE_CANT_MOVE:int = 4;
			var arrAllMap:Array = [];
			var maxRow:int = 20;
			var maxCol:int = 20;
			var totalSquareCanMove:int = 150;
			var totalSquareTreasure:int = 5;
			var totalSquareAnswer:int = 7;
			var numSquareCanMove:int = 150;
			
			var i:int = 0;
			var j:int = 0;
			// Khoi tao mang chua state cua map
			for (i = 0; i < maxRow; i++) 
			{
				var arrMapRow:Array = [];
				for (j = 0; j < maxCol; j++) 
				{
					arrMapRow.push(SQUARE_CANT_MOVE);
				}
				arrAllMap.push(arrMapRow);
			}
			// khởi tạo ô đầu tiên và ô cuối cùng
			arrAllMap[0][0] = SQUARE_START;
			numSquareCanMove++;
			arrAllMap[(maxRow - 1)][(maxCol - 1)] = SQUARE_END;
			numSquareCanMove++;
			// khoi tao duong di co ban
			if (Math.random() > 0.5)
			{
				// duong di ngang roi doc
				for (j = 1; j < maxCol; j++) 
				{
					arrAllMap[0][j] = SQUARE_CAN_MOVE;
					numSquareCanMove++;
				}
			}
			else
			{
				// duong di ngang roi doc
				for (j = 1; j < maxRow - 1; j++) 
				{
					arrAllMap[j][(maxCol - 1)] = SQUARE_CAN_MOVE;
					numSquareCanMove++;
				}
			}
			// sinh ra cac o chua phan thuong, cac o 
			for (i = 0; i < totalSquareTreasure; i++) 
			{
				do
				{
					var row:int = Math.floor(maxRow * Math.random());
					var col:int = Math.floor(maxCol * Math.random());
				}
				while (arrAllMap[row][col] != SQUARE_CANT_MOVE)
			}
			// sinh ra cac o dan den duong 
		}
		
		/**
		 * Bắt sự kiện ấn bàn phím trên stage chính
		 * @param event thông tin về sự kiện
		 */
		public function OnKeyDown(event:KeyboardEvent):void
		{			
			switch(event.keyCode)
			{
				case Keyboard.TAB:
					//isPressTab = true;
					break;
				case Keyboard.F2:
				{	
					//trace(st);
					//GuiMgr.getInstance().GuiChangeGiftEvent.Show(Constant.GUI_MIN_LAYER, 3);
					//GuiMgr.getInstance().GuiUnlockEquipment.Show();
					break;
				} 
				case Keyboard.F3:
				{	
					//GuiMgr.getInstance().GuiGameTrungThu.Show(Constant.GUI_MIN_LAYER, 3);
					//GuiMgr.getInstance().GuiMainEventIceCream.Show(Constant.GUI_MIN_LAYER, 3);
						break;
				} 
				case Keyboard.F4:
				{	
					//GuiMgr.getInstance().GuiHarvestIceCream.Show();
					break;
				} 

				case Keyboard.F5:
				{	
					//var ctn:Container = GuiMgr.getInstance().GuiGameTrungThu.GetContainer(GUIGameEventMidle8.CTN_SQUARE + "17_18");
					//EffectMgr.getInstance().AddSwfEffect(	Constant.GUI_MIN_LAYER, "EffOpenWindowGameMidle8", null, ctn.CurPos.x - GuiMgr.getInstance().GuiGameTrungThu.widthCtn, ctn.CurPos.y - GuiMgr.getInstance().GuiGameTrungThu.heightCtn,
														//false, false, null);
					//EffectMgr.getInstance().AddSwfEffect(	Constant.GUI_MIN_LAYER, "EffQuitGameMidle8", null, Constant.STAGE_WIDTH / 2 - 100, Constant.STAGE_HEIGHT / 2,
															//false, false, null);// , function():void { ShowGiftFinal(arrNameGift, arrNumGift, dataServer.Gift) } );
					//EffectMgr.getInstance().AddSwfEffect1(Constant.GUI_MIN_LAYER, "EffRandomDice", 2, [5, 6], Constant.STAGE_WIDTH / 2 - 50, 
							//Constant.STAGE_HEIGHT / 2, false, false, null);
					break;
				} 
				
				case Keyboard.F6:
					{
						//GuiMgr.getInstance().GuiSendLetter.Show();
					}
				break;
			}
		}
		 
		
		/**
		 * Bắt sự kiện nhả bàn phím trên stage chính
		 * @param event thông tin về sự kiện
		 */
		//private var fmm:TextFormat = new TextFormat("SansationBold", 44, 0x00ff00, true);
		public function OnKeyUp(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.TAB:
					//var date:Date = new Date(GameLogic.getInstance().CurServerTime*1000);
					//trace(date.getDate() + "/" + (date.getMonth() + 1));
					//GuiMgr.getInstance().guiTreasureIsLand.checkExprireTime();
					break;
				case Keyboard.F1:
				{
					//GuiMgr.getInstance().guiFinishEventAuto.Show(Constant.GUI_MIN_LAYER, 5);
					//GuiMgr.getInstance().guiReputation.showGui();
					//GuiMgr.getInstance().guiFrontEvent.lantern.eatItem("Magnetic", 1);
					//var guiDailyGift:GUIDailyGift = new GUIDailyGift(null, "");
					//guiDailyGift.Show(Constant.GUI_MIN_LAYER, 5);
					//GuiMgr.getInstance().guiSavePoint.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				}
				case Keyboard.F2:
				{
					//GuiMgr.getInstance().guiLockHalloween.Show(Constant.GUI_MIN_LAYER, 5);
					//var herd:HerdFish = new HerdFish();
					//herd.GenerateHerdFish(new Rectangle(0, 0, 30, 30));
					//herd.SetPosHerdFish(250, 200);
					//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GuiMgr.getInstance().GuiFeedWall.FEED_TYPE_LEVEL_UP, "8", "", "lencap.png");
					//SoundMgr.getInstance().playBgMusic(SoundMgr.MUSIC_WAR);
					//GuiMgr.getInstance().GuiMapOcean.Show(Constant.GUI_MIN_LAYER, 3);
					//GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWarMsg18"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR, false);
					//GuiMgr.getInstance().GuiEnchantEquipment.Show(Constant.GUI_MIN_LAYER, 5);
					//GuiMgr.getInstance().GuiQuestPowerTinh.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				}
				
				case Keyboard.F3:
				{
					//GuiMgr.getInstance().GuiFeedWall.ShowFeedNew(GUIFeedWall.FEED_TYPE_MATERIAL_5);
					//var temp:NewFeedWall = NewFeedWall.GetInstance();
					//temp.OpenFeedItem(1546211,2103912, 1,3, "", "Vì sao lên cấp??? ở dưới thấp có được hok????",
						//"", "myFish", "@quangvh  vừa đạt cấp độ 39 trong" + 
						//" <a href=\"http://me.zing.vn/apps/fish?_src=m\"> myFish </a>.Bấm \"Thích\" để chia " + 
						//"sẻ điều này nha bạn.", 1, "http://fish-static.apps.zing.vn/imgcache/iconfeed/lencap.png",
						//"http://me.zing.vn/apps/fish?_src=m", "", "", 1);
					//Exchange.GetInstance().Send(new SendSignKey(temp));
					
					//var objBase:Object = ConfigJSON.getInstance().getItemInfo("AutoMap", 2);
					//var objTotal:Object = ConfigJSON.getInstance().getItemInfo("AutoMap", 1);
					//GuiMgr.getInstance().GuiAutomaticGame.Show(Constant.OBJECT_LAYER, 1);
					break;
				}
				
				case Keyboard.F4:
					//GuiMgr.getInstance().GuiSeriesQuest.ShowFinishSeriQuest(8);
					// Tạo Rung màn hình
					//GameController.getInstance().shakeScreen(10, 2, 20);
				break;
				
				case Keyboard.F5:
				{
					//GuiMgr.getInstance().GuiMessageBox.ShowInputUid();
					break;
				}
			}
		}
		
		
		/**
		 * Bắt sự kiện chuột di chuyển trên stage chính
		 * @param event thông tin về sự kiện
		 */
		public function OnMouseMove(event:MouseEvent):void
		{
			if (GameController.getInstance().gameMode == GameController.GAME_MODE_BOSS_SERVER)
			{
				return;
			}
			
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			if (GameController.getInstance().ActiveObj == null)
			{
				if (IsMouseDown)
				{
					var dx:int;
					var dy:int;
					if (!IsDragScreen)
					{
						dx = Math.abs(event.stageX - LastMouseDownPos.x);
						dy = Math.abs(event.stageY - LastMouseDownPos.y);
						if (dx >= 5 || dy >= 5)
						{
							IsDragScreen = true;
						}
					}
					else
					{
						if (Main.imgRoot.stage.displayState != StageDisplayState.FULL_SCREEN 
							&& GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR 
							&& GameLogic.getInstance().gameMode != GameMode.GAMEMODE_BOSS
							&&!GameController.getInstance().isSmallBackGround)
						{
							dx = (event.stageX - MousePos.x) / 1.5;
							dy = (event.stageY - MousePos.y) / 1.5;
							GameController.getInstance().PanScreenX(dx);
							GameController.getInstance().PanScreenY(dy);
						}
					}
					
				}
			}
			
			if (GameController.getInstance().ActiveObj != null)
			{
				var pt:Point;
				pt = Ultility.PosScreenToLake(event.stageX, event.stageY);
				if (GameController.getInstance().ActiveObj.ClassName == "Decorate" ||
					(GameController.getInstance().ActiveObj.ClassName == "FishSpartan" && !(GameController.getInstance().ActiveObj as FishSpartan).isExpired))
				{
					GameController.getInstance().UpdateDecoPos(GameController.getInstance().ActiveObj as Decorate, pt.x, pt.y, event.stageX, event.stageY);
				}
				else
				{
					GameController.getInstance().UpdateActiveObjPos(pt.x, pt.y);
				}
			}			
			
			// upadte mouse pos
			MousePos.x = event.stageX;
			MousePos.y = event.stageY;
			if (GuiMgr.getInstance().guiHuntFish.IsVisible)
			{
				GuiMgr.getInstance().guiBtnControl.rotateGun(event.stageX, event.stageY);
			}
			/*
			if (GameController.getInstance().ActiveObj != null)
			{	
				if (event.target == layer.fog)
				{
					GameLogic.getInstance().MouseVisible(false);
				}
				else
				{
					GameLogic.getInstance().MouseVisible(true);
				}
			}
			else
			{
				GameLogic.getInstance().MouseVisible(true);
			}
			*/			
			
			
			//Update vị trí cá khi kéo thả
			if (Fish.dragingFish != null)
			{
				pt = Ultility.PosScreenToLake(event.stageX, event.stageY);
				Fish.dragingFish.dragTo(pt.x, pt.y);			
			}	
			if (FishSpartan.dragingFish != null)
			{
				pt = Ultility.PosScreenToLake(event.stageX, event.stageY);
				FishSpartan.dragingFish.dragTo(pt.x, pt.y);			
			}	
		}
		
			
		/**
		 * Bắt sự kiện click chuột trên stage chính
		 * @param event thông tin về sự kiện
		 */
		public function OnMouseClick(event:MouseEvent):void
		{
			if (GameController.getInstance().gameMode == GameController.GAME_MODE_BOSS_SERVER)
			{
				return;
			}
			//trace("event.target",event.target, "event.curTarget", event.currentTarget);
			ClickOnGame(event);
			// kiem tra mouse click tren 1 object
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			if (layer != null)
			{	
				if (layer.fog == event.target)
				{					
					GameController.getInstance().ClickOnActiveObj(event.localX, event.localY);
					//ClickOnGame(event);
				}
				
			}
			
			//if (GameLogic.getInstance().gameState == GameState.GAMESTATE_IDLE)
			//{
				//var gui:GUIFishInfo = GuiMgr.getInstance().GuiFishInfo;
				//if (gui.IsVisible && !gui.IsBaseInfo && event.target.parent != gui.img)
				//{
					//gui.HideDrop();
				//}
			//}
			

			// kiem tra lau vet ban
			var dirty:Dirty = null;
			var obj:Object = event.target;
			var i:int;
			var dirtyArr:Array = GameLogic.getInstance().user.GetDirtyArray();
			var vt:int = -1;
			for (i = 0; i < dirtyArr.length; i++)
			{
				dirty = dirtyArr[i] as Dirty;
				
				if (obj == dirty.img)
				{
					vt = i;
					break;
				}
			}				
			
			if (vt >= 0)
			{
				GameLogic.getInstance().DoCleanLake(dirty);
			}
			if (GuiMgr.getInstance().guiHuntFish.IsInitAllOk)
			{
				GuiMgr.getInstance().guiBtnControl.fire(new Point(event.stageX, event.stageY));
			}
		}
		
			
		/**
		 * Bắt sự kiện ấn chuột trên stage chính
		 * @param event thông tin về sự kiện
		 */
		public function OnMouseDown(event:MouseEvent):void
		{
			if (GameLogic.getInstance().gameState == GameState.GAMESTATE_INIT)
			{
				return;
			}

			
			if (GameController.getInstance().gameMode == GameController.GAME_MODE_BOSS_SERVER)
			{
				return;
			}
			
			//if (event.target.parent == LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER))
			var i:int = LayerMgr.getInstance().GetLayerIndex(event.target.parent);
			//trace(event.target, event.target.parent, i);
			if (Ultility.IsInMyFish())
			{
				if ((i < Constant.GUI_MIN_LAYER) && (i >= 0) || (GameLogic.getInstance().gameState == GameState.GAMESTATE_PREVIEW_BACKGROUND))
				{
					IsMouseDown = true;
					LastMouseDownPos.x = event.stageX;
					LastMouseDownPos.y = event.stageY;
				}			
			}
			
			if (GameLogic.getInstance().gameState == GameState.GAMESTATE_EDIT_DECORATE)
			{
				//trace("di chuyen do trang tri");
				if (GuiMgr.getInstance().GuiDecorateInfo.img != event.target.parent)
				{
					//trace("caaaaa")
					if (GuiMgr.getInstance().GuiDecorateInfo.CurObject != null)
					{
						//trace("tat highlight");
						if (GuiMgr.getInstance().GuiDecorateInfo.CurObject.ClassName == "FishSpartan")
						{
							//trace("tat highlight fishspartan");
							(GuiMgr.getInstance().GuiDecorateInfo.CurObject as FishSpartan).SetHighLight( -1);
						}
						else if (GuiMgr.getInstance().GuiDecorateInfo.CurObject.ClassName == "Decorate")
						{
							//trace("tat highlight decorate");
							(GuiMgr.getInstance().GuiDecorateInfo.CurObject as Decorate).SetHighLight( -1);
						}
						
						GuiMgr.getInstance().GuiDecorateInfo.CurObject = null;
					}
					//trace(GuiMgr.getInstance().GuiDecorateInfo.img,);
					GuiMgr.getInstance().GuiDecorateInfo.Hide();
				}
			}
			
			// kiem tra do'ng man hinh decorate info lai
			//if (GameLogic.getInstance().gameState == GameState.GAMESTATE_INFO_DECORATE)
			//{
				//if ((event.target.parent != GuiMgr.getInstance().GuiDecorateInfo.img))
				//{
					//GuiMgr.getInstance().GuiDecorateInfo.Hide();
					//LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).HideDisableScreen();
					//GuiMgr.getInstance().GuiDecorateInfo.CurObject.SetHighLight(-1);
				//}
			//}
		}
		
		private function CheckActiveObjectMouse(event:MouseEvent):void
		{
			if (GameController.getInstance().ActiveObj != null)
			{
				if (GameLogic.getInstance().gameState == GameState.GAMESTATE_EDIT_DECORATE)
				{
					var deco:Decorate;
					deco = GameController.getInstance().ActiveObj as Decorate;
					if ((deco != null) && (deco.ObjectState == BaseObject.OBJ_STATE_EDIT))
					{
						if ((GuiMgr.getInstance().GuiStore.IsPointInGUI(event.stageX, event.stageY)) && (!GuiMgr.getInstance().GuiStore.IsLoading))
						{
							if (deco.ClassName == "FishSpartan")//thả tay mà nó ở trong gui
							{
								deco.UnMovePos();
								var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
								GameController.getInstance().ActiveObj = null;
								if (layer != null)
								{
									layer.HideDisableScreen();
								}
								GuiMgr.getInstance().GuiDecorateInfo.CurObject = deco as FishSpartan;
								//var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
								//GameController.getInstance().ActiveObj = null;
								//if (layer != null)
								//{
									//layer.HideDisableScreen();
								//}
							}
							else
								GameLogic.getInstance().StoreDecorate(deco);
						}
						else
						{
							GameLogic.getInstance().MoveDecorate(deco);
							
						}
					}
					if ((deco != null) && (deco.ObjectState == BaseObject.OBJ_STATE_USE))
					{
						GameLogic.getInstance().UseDecorate(deco);
					}
				}
			}
		}
		
		/**
		 * Bắt sự kiện nhả chuột trên stage chính
		 * @param event thông tin về sự kiện
		 */
		public function OnMouseUp(event:MouseEvent):void
		{
			if (GameController.getInstance().gameMode == GameController.GAME_MODE_BOSS_SERVER)
			{
				return;
			}
			
			IsDragScreen = false;
			IsMouseDown = false;
			CheckActiveObjectMouse(event);
			if (Fish.dragingFish != null)
			{
				Fish.dragingFish.finisDrag();				
			}
			if (FishSpartan.dragingFish != null)
			{
				FishSpartan.dragingFish.finisDrag();				
			}
		}
		
		public function OnOverBoss(boss:Boss):void
		{
			//if(!boss.isWaitFishSoldierSwim)
			{
				boss.SetHighLight();
				GameLogic.getInstance().MouseTransform("ImgSword");
			}
		}
		
		public function OnOverBossMetal(boss:BossMetal):void
		{
			boss.SetHighLight();
			GameLogic.getInstance().MouseTransform("ImgSword");
		}
		
		public function OnOverBossIce(boss:BossIce):void
		{
			boss.SetHighLight();
			GameLogic.getInstance().MouseTransform("ImgSword");
		}
		
		public function OnOutBoss(boss:Boss):void
		{
			{
				boss.SetHighLight( -1);
				GameLogic.getInstance().BackToOldMouse();
				//boss.SetMovingState(boss.STATE_GO_RUN);
			}
		}
		
		public function OnOutBossMetal(boss:BossMetal):void
		{
			boss.SetHighLight( -1);
			GameLogic.getInstance().BackToOldMouse();
		}
		
		public function OnOutBossIce(boss:BossIce):void
		{
			boss.SetHighLight( -1);
			GameLogic.getInstance().BackToOldMouse();
		}
		
		public function OnClickBoss(boss:Boss):void
		{
			if(GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			{
				if(!boss.isAttacking)
				{
					//if((fs.Health >= fs.AttackPoint) && (boss.State = Boss.BOSS_STATE_IDLE) && (boss.CurHp > 0))
					if(CheckCanAttackBoss())
					{
						if(!boss.isAttacking && !boss.isBossLoose)
						{
							//boss.PreStartAttack(Ultility.GetFishSoldierCanWar());
							//GuiMgr.getInstance().GuiFishWarBoss.Init(Ultility.GetFishSoldierCanWarFromLogic()[0]);
							
							if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	
							{
								GuiMgr.getInstance().GuiInfoWarInWorld.ShowDisableScreen(0.01);
							}
							GuiMgr.getInstance().GuiFishWarBoss.Init(Ultility.GetFishSoldierCanWar()[0]);
						}
					}
					else 
					{
						var str:String = Localization.getInstance().getString("FishWorldMsg1");
						var posStart:Point = boss.img.localToGlobal(new Point(0, 0));
						var posEnd:Point = new Point(posStart.x, posStart.y - 100);
						Ultility.ShowEffText(str, boss.img, posStart, posEnd);
						//GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWorldMsg1"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					}
				}
			}
		}
		
		public function OnClickBossMetal(boss:BossMetal):void
		{
			if(GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			{
				if(!boss.isAttacking)
				{
					var str:String;
					var posStart:Point;
					var posEnd:Point;
					if(GameLogic.getInstance().user.arrSubBossMetal.length == 0)
					{
						if(CheckCanAttackBoss())
						{
							if(!boss.isAttacking && !boss.isBossLoose)
							{
								//boss.PreStartAttack(Ultility.GetFishSoldierCanWar());
								//GuiMgr.getInstance().GuiFishWarBoss.Init(Ultility.GetFishSoldierCanWarFromLogic()[0]);
								
								if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	
								{
									GuiMgr.getInstance().GuiInfoWarInWorld.ShowDisableScreen(0.01);
								}
								GuiMgr.getInstance().GuiFishWarBoss.Init(Ultility.GetFishSoldierCanWar()[0]);
							}
						}
						else 
						{
							str = Localization.getInstance().getString("FishWorldMsg1");
							posStart = boss.img.localToGlobal(new Point(0, 0));
							posEnd = new Point(posStart.x, posStart.y - 100);
							Ultility.ShowEffText(str, boss.img, posStart, posEnd);
							//GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWorldMsg1"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
						}
					}
					else
					{
						str = "Boss Hoàng Kim đang được bảo vệ";
						posStart = boss.img.localToGlobal(new Point(0, 0));
						posEnd = new Point(posStart.x, posStart.y - 100);
						Ultility.ShowEffText(str, boss.img, posStart, posEnd);
					}
				}
			}
		}
		
		public function OnClickBossIce(boss:BossIce):void
		{
			if(GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
			{
				if(!boss.isAttacking)
				{
					var str:String;
					var posStart:Point;
					var posEnd:Point;
					if(GameLogic.getInstance().user.arrSubBossMetal.length == 0)
					{
						if(CheckCanAttackBoss())
						{
							if(!boss.isAttacking && !boss.isBossLoose)
							{
								if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	
								{
									GuiMgr.getInstance().GuiInfoWarInWorld.ShowDisableScreen(0.01);
								}
								GuiMgr.getInstance().GuiFishWarBoss.Init(Ultility.GetFishSoldierCanWar()[0]);
							}
						}
						else 
						{
							str = Localization.getInstance().getString("FishWorldMsg1");
							posStart = boss.img.localToGlobal(new Point(0, 0));
							posEnd = new Point(posStart.x, posStart.y - 100);
							Ultility.ShowEffText(str, boss.img, posStart, posEnd);
						}
					}
					else
					{
						str = "Boss Hoàng Kim đang được bảo vệ";
						posStart = boss.img.localToGlobal(new Point(0, 0));
						posEnd = new Point(posStart.x, posStart.y - 100);
						Ultility.ShowEffText(str, boss.img, posStart, posEnd);
					}
				}
			}
		}
		
		private function CheckCanAttackBoss():Boolean
		{
			var arr:Array = Ultility.GetFishSoldierCanWar();
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:FishSoldier = arr[i];
				if (item.Health >= 2 * item.AttackPoint) 
				{
					return true;
				}
			}
			return false;
		}
		
		public function OnClickThicket(tk:Thicket):void
		{
			if (tk.Emotion == FishSoldier.WAR && GameLogic.getInstance().isAttacking == false)
			{
				ProcessWarInForestWorld(tk as FishSoldier);
			}
		}
		
		public function OnClickFish(fish:Fish):void
		{
			var fs:FishSoldier;
			var guiFishInfo:GUIFishInfo = GuiMgr.getInstance().GuiFishInfo;
			var posX:int;
			var posY:int;
			if (fish.State == Fish.FS_FALL)
			{
				return;
			}
			var i:int = 0;
			if (!Ultility.IsInMyFish() && GameLogic.getInstance().isAttacking)	return;
			if (!Ultility.IsInMyFish() && GameLogic.getInstance().isAttacking || LeagueController.getInstance().mode==LeagueController.IN_LEAGUE)	return;
			
			if(!Ultility.IsInMyFish())
			{
				var arrFs:Array = GameLogic.getInstance().user.FishSoldierActorMine;
				var gs:int = GameLogic.getInstance().gameState;
				if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST
					&& (gs != GameState.GAMESTATE_RECOVER_HEALTH_SOLDIER &&
						gs != GameState.GAMESTATE_REVIVE_SOLDIER &&
						gs != GameState.GAMESTATE_OTHER_BUFF_SOLDIER &&
						gs != GameState.GAMESTATE_USE_HERB_POTION))
				{
					if ((fish as FishSoldier).isActor == FishSoldier.ACTOR_MINE)
					{
						if(GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld)
						{
							if ((fish as FishSoldier).isChoose == true)
							{
								GameLogic.getInstance().user.CurSoldier[0] = fish;
								for (i = 0; i < arrFs.length; i++) 
								{
									(arrFs[i] as FishSoldier).isChoose = false;
								}
								(fish as FishSoldier).isChoose = true;
								return;
							}
							else
							{
								for (i = 0; i < arrFs.length; i++) 
								{
									(arrFs[i] as FishSoldier).isChoose = false;
								}
								(fish as FishSoldier).isChoose = true;
								GameLogic.getInstance().user.CurSoldier[0] = fish;
							}
						}
						else
						{
							return;
						}
					}
					else 
					{
						switch (FishWorldController.GetRound()) 
						{
							case Constant.SEA_ROUND_1:
								if (fish.Emotion == FishSoldier.WAR && GameLogic.getInstance().isAttacking == false)
								{
									ProcessWarInForestWorld(fish as FishSoldier);
								}
								return;
							break;
							case Constant.SEA_ROUND_2:
								if (fish.Emotion == FishSoldier.WAR && GameLogic.getInstance().isAttacking == false)
								{
									ProcessWarInForestWorld(fish as FishSoldier);
								}
								return;
							break;
							case Constant.SEA_ROUND_3:
								trace("GameLogic.getInstance().gameState",GameLogic.getInstance().gameState);
									
								if(GameLogic.getInstance().countNumEffHoiSinh <= 0)
								{
									if (fish.Emotion == FishSoldier.WAR && GameLogic.getInstance().isAttacking == false)
									{
										ProcessWarInForestWorld(fish as FishSoldier);
									}
								}
								return;
							break;
							case Constant.SEA_ROUND_4:
								if (fish.Emotion == FishSoldier.WAR && GameLogic.getInstance().isAttacking == false)
								{
									ProcessWarInForestWorld(fish as FishSoldier);
								}
								return;
							break;
						}
					}
				}
			}
			
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR
				&& GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)
			{
				// Nếu là mồ click nhận tiền
				if ((fish.FishType == Fish.FISHTYPE_SOLDIER) && (fish.Emotion == FishSoldier.DEAD) && !GameLogic.getInstance().user.IsViewer())
				{
					if ((fish as FishSoldier).SoldierType == FishSoldier.SOLDIER_TYPE_HIRE)
					{
						GameLogic.getInstance().ClickGrave(fish as FishSoldier);
					}
					else
					{
						GuiMgr.getInstance().GuiOptionGrave.SetGrave(fish as FishSoldier);
						GuiMgr.getInstance().GuiOptionGrave.Show(Constant.GUI_MIN_LAYER, 3);
						//GuiMgr.getInstance().GuiOptionGrave.SetPos(fish.CurPos.x, fish.CurPos.y + 20);
						fish.SetHighLight( -1);
					}
					return;
				}
				
				switch(GameLogic.getInstance().gameState)
				{
					case GameState.GAMESTATE_CURE_FISH:
						GameLogic.getInstance().CureFish(fish);
						break;
					case GameState.GAMESTATE_CARE_FISH:
						GameLogic.getInstance().CareFish(fish);
						break;
					case GameState.GAMESTATE_SELL_FISH:
						//if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_BOSS)
						{
							// Designated Flow : player should sell their grown fish
							// Ask if they really want to sell their 
							if (!fish.IsEgg)
							{
								//Đang khóa hoặc xin phá khóa, hoac bi block
								var passwordState:String = GameLogic.getInstance().user.passwordState;
								if (passwordState == Constant.PW_STATE_IS_LOCK || passwordState == Constant.PW_STATE_IS_CRACKING|| passwordState == Constant.PW_STATE_IS_BLOCKED)
								{
									GuiMgr.getInstance().guiPassword.showGUI();
								}
								else
								if (fish.FishType == Fish.FISHTYPE_SPECIAL)
								{
									GuiMgr.getInstance().GuiMessageBox.ShowConfirmSellFish(fish,Localization.getInstance().getString("GUILabel35"));
								}
								else if (fish.FishType == Fish.FISHTYPE_RARE)
								{
									GuiMgr.getInstance().GuiMessageBox.ShowConfirmSellFish(fish, Localization.getInstance().getString("GUILabel36"));
								}
								else if (fish.GetPeriod() < Fish.GROWTH_UP && fish.NumUpLevel < 1)
								{
									GuiMgr.getInstance().GuiMessageBox.ShowConfirmSellFish(fish, Localization.getInstance().getString("GUILabel28"));
								}
								else if (fish.FishType == Fish.FISHTYPE_SOLDIER)
								{
									GuiMgr.getInstance().GuiMessageBox.ShowConfirmSellFish(fish, Localization.getInstance().getString("GUILabel37"));
								}
								else
								{
									GameLogic.getInstance().SellFish(fish);
									GameLogic.getInstance().cursor.gotoAndPlay(0);
								}
							}
						}
						break;
					case GameState.GAMESTATE_IDLE:
						// hien thi GUI info
						if (!fish.IsEgg)
						{
							if (guiFishInfo.IsVisible)// && !guiFishInfo.IsBaseInfo)
							{
								guiFishInfo.HideDrop();
							}
						}
						// Nếu là cá lính xịn ở nhà mình thì cho đổi đồ
						if (fish.FishType == Fish.FISHTYPE_SOLDIER && Ultility.IsInMyFish())
						{
							if ((fish as FishSoldier).SoldierType == FishSoldier.SOLDIER_TYPE_MIX)
							{
								if (GameLogic.getInstance().user.IsViewer())
								{
									if ((fish as FishSoldier).Status != FishSoldier.STATUS_DEAD)
									{
										GuiMgr.getInstance().guiSoliderInfo.Init(fish as FishSoldier);
										fish.SetMovingState(Fish.FS_SWIM);
									}
									fish.OnMouseOutFish();
								}
								else
								{
									GuiMgr.getInstance().GuiChooseEquipment.Init(fish as FishSoldier);
								}
							}
						}
						break;
					case GameState.GAMESTATE_RESET_MATE_FISH:
						if (fish.GuiFishStatus.Check(fish) == GUIFishStatus.PASS)
						{
							GameLogic.getInstance().UseViagra(fish);
						}
					break;
					case GameState.GAMESTATE_ADD_MATERIAL_FOR_FISH:
						if (fish.GuiFishStatus.CheckCanUseMaterial(fish))
						{
							//Đang khóa hoặc xin phá khóa
							var pwState:String = GameLogic.getInstance().user.passwordState;
							if (pwState == Constant.PW_STATE_IS_LOCK || pwState == Constant.PW_STATE_IS_CRACKING)
							{
								GuiMgr.getInstance().guiPassword.showGUI();
							}
							else
							{
								GameLogic.getInstance().UseMaterialForFish(fish);
							}
						}
						break;
					case GameState.GAMESTATE_RECOVER_HEALTH_SOLDIER:
						if (fish.FishType == Fish.FISHTYPE_SOLDIER)
						{
							fs = fish as FishSoldier;
							GameLogic.getInstance().RecoverHealth(fs);
						}
						break;
					case GameState.GAMESTATE_REVIVE_SOLDIER:
						if (fish.FishType == Fish.FISHTYPE_SOLDIER)
						{
							fs = fish as FishSoldier;
							GameLogic.getInstance().ReviveSoldier(fs);
						}
						break;
					case GameState.GAMESTATE_INCREASE_RANK_POINT:
					{
						if (fish.FishType == Fish.FISHTYPE_SOLDIER)
						{
							fs = fish as FishSoldier;
							var itemId:int = GuiMgr.getInstance().GuiStore.curRankPointBottleId;
							var numItem:int = GameLogic.getInstance().user.GetStoreItemCount("RankPointBottle", itemId);
							var name:String = Localization.getInstance().getString("RankPointBottle" + itemId);
							//if (fs.Rank > 20 && itemId < 4)
							//{
								//GuiMgr.getInstance().GuiMessageBox.ShowOK("Bình chiến công này chỉ dùng cho ngư thủ cấp 20 trở xuống.");
								//break;
							//}
							GuiMgr.getInstance().guiChooseNumber.showGUI(numItem, name, "RankPointBottle" + itemId, function f(numBottle:int):void
							{
								if (numBottle > 0)
								{
									GameLogic.getInstance().increaseRankPoint(fs, numBottle);
								}
							});
						}
					};
					break;
					case GameState.GAMESTATE_OTHER_BUFF_SOLDIER:
						if (fish.FishType == Fish.FISHTYPE_SOLDIER)
						{
							fs = fish as FishSoldier;
							if (GameLogic.getInstance().cursorImg.search("Gem") == -1)
							{
								fs.processBuffItem();
							}
							else
							{
								fs.processBuffGem();
							}
						}
						break;
					case GameState.GAMESTATE_USE_HERB_POTION:
						if (fish.FishType == Fish.FISHTYPE_SOLDIER)
						{
							(fish as FishSoldier).processBuffHerbPotion();
						}
						break;
				}
			}
			else	if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)	// GAMEMODE_WAR
			{
				if (fish.FishType == Fish.FISHTYPE_SOLDIER)
				{
					var fs1:FishSoldier = fish as FishSoldier;
					
					// Không đang sử dụng item
					if (GameLogic.getInstance().cursorImg == "")
					{
						if(Ultility.IsInMyFish())
						{	
							// Chọn cá và chiến cá
							if (fs1.isActor == FishSoldier.ACTOR_MINE)
							{
								if (fs1.Status == FishSoldier.STATUS_HEALTHY && fs1.Health >= 2 * fs1.AttackPoint)
								{
									for (var ii:int = 0; ii < GameLogic.getInstance().user.FishSoldierActorMine.length; ii++)
									{
										if (GameLogic.getInstance().user.FishSoldierActorMine[ii].isChoose)
										{
											GameLogic.getInstance().user.FishSoldierActorMine[ii].isChoose = false;
											break;
										}
									}
									fs1.isChoose = true;
									GameLogic.getInstance().user.CurSoldier[0] = fs1;
								}
							}
							else	// Chọn cá đánh nhau
							{
								if (fs1.Health >= fs1.AttackPoint)
								{
									//GuiMgr.getInstance().GuiFishWar.Init(GameLogic.getInstance().user.CurSoldier);
									GameLogic.getInstance().user.CurSoldier[1] = fs1;
									fs1.processChooseFishWar();
								}
								else
								{
									fs1.Chatting("Weak", 3000, 1);
								}
							}
						}
						else // TGC
						{
							if (fs1.isActor == FishSoldier.ACTOR_MINE)
							{
								if(fs1.Health >= 2 * fs1.AttackPoint)
								{									
									for (var iFishWorld:int = 0; iFishWorld < GameLogic.getInstance().user.FishSoldierActorMine.length; iFishWorld++)
									{
										if (GameLogic.getInstance().user.FishSoldierActorMine[iFishWorld].isChoose)
										{
											GameLogic.getInstance().user.FishSoldierActorMine[iFishWorld].isChoose = false;
											(GameLogic.getInstance().user.FishSoldierActorMine[iFishWorld] as FishSoldier).SetHighLight( -1);
										}
									}
									fs1.isChoose = true;
									GameLogic.getInstance().user.CurSoldier[0] = fs1;
								}
								else
								{
									GuiMgr.getInstance().GuiRecoverHealth.Init(fs1);
									//GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWorldMsg1"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
								}
							}
							else 
							{
								GameLogic.getInstance().user.CurSoldier[1] = fs1;
								fs1.processChooseFishWar();
							}
						}
					}
					// Sử dụng item cho cá lính
					else
					{
						if (GameLogic.getInstance().cursorImg.search("Gem") != -1)
						{
							fs1.processBuffGem();
						}
						else if (GameLogic.getInstance().cursorImg.search("RecoverHealthSoldier") != -1)
						{
							GameLogic.getInstance().RecoverHealth(fs1);
						}
						else if (GameLogic.getInstance().cursorImg.search("Ginseng") != -1)
						{
							GameLogic.getInstance().ReviveSoldier(fs1);
						}
						else if (GameLogic.getInstance().cursorImg.search("HerbPotion") != -1)
						{
							fs1.processBuffHerbPotion();
						}
						else
						{
							if (fs1.isActor == FishSoldier.ACTOR_MINE)
							{
								fs1.processBuffItem();
							}
							else
							{
								if (Ultility.IsInMyFish())
								{
									GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg2"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
								}
								else
								{
									GameLogic.getInstance().MouseTransform("");
									var child:Sprite = new Sprite();
									var str:String = Localization.getInstance().getString("Message38");
									var posStart:Point = fs1.img.localToGlobal(new Point(0, 0));
									var posEnd:Point = new Point(posStart.x, posStart.y - 100);
									Ultility.ShowEffText(str, fs1.img, posStart, posEnd);
								}
							}
						}
					}
				}
				else
				{
					// Cá thường -> đánh
					fish.processChooseFishWar();
				}
			}
			else // GameMode = Forest_world
			{
				var fs2:FishSoldier = fish as FishSoldier;
				if (fish.FishType == Fish.FISHTYPE_SOLDIER && (fish as FishSoldier).isActor == FishSoldier.ACTOR_MINE)
				{
					if(GameLogic.getInstance().cursorImg != "")
					{
						if (GameLogic.getInstance().cursorImg.search("Gem") != -1)
						{
							fs2.processBuffGem();
						}
						else if (GameLogic.getInstance().cursorImg.search("RecoverHealthSoldier") != -1)
						{
							GameLogic.getInstance().RecoverHealth(fs2);
						}
						else if (GameLogic.getInstance().cursorImg.search("Ginseng") != -1)
						{
							GameLogic.getInstance().ReviveSoldier(fs2);
						}
						else if (GameLogic.getInstance().cursorImg.search("HerbPotion") != -1)
						{
							fs2.processBuffHerbPotion();
						}
						else
						{
							fs2.processBuffItem();
						}
					}
					if (fs2.isChoose == false)
					{
						for (var iFs2:int = 0; iFs2 < GameLogic.getInstance().user.FishSoldierActorMine.length; iFs2++) 
						{
							var itemFs2:FishSoldier = GameLogic.getInstance().user.FishSoldierActorMine[iFs2];
							itemFs2.isChoose = false;
						}
						fs2.isChoose = true;
						GameLogic.getInstance().user.CurSoldier[0] = fs2;
					}
				}
				else
				{
					
				}
			}
		}
		
		public function OnClickFishSpartan(fish:FishSpartan):void
		{
			var guiFishInfo:GUIFishInfo = GuiMgr.getInstance().GuiFishInfo;
			var posX:int;
			var posY:int;
			if (fish.State == Fish.FS_FALL)
			{
				return;
			}
			
			switch(GameLogic.getInstance().gameState)
			{
				case GameState.GAMESTATE_SELL_FISH:
					{
						// Designated Flow : player should sell their grown fish
						// Ask if they really want to sell their 
						var strNameFish:String = GuiMgr.getInstance().GuiStore.GetNameFishSpecial(fish.NameItem);
						GuiMgr.getInstance().GuiMessageBox.ShowConfirmSellFishSpartan(fish, strNameFish + "\n Bạn thật sự muốn bán?");
						
					}
					break;
				case GameState.GAMESTATE_IDLE:
					// hien thi GUI info
					if (guiFishInfo.IsVisible)// && !guiFishInfo.IsBaseInfo)
					{
						guiFishInfo.HideDrop();
					}
					break;
					//guiFishInfo.IsEgg = false;
					//guiFishInfo.IsBaseInfo = false;
				case GameState.GAMESTATE_ADD_MATERIAL_FOR_FISH:
					if(fish.numReborn <= fish.maxNumReborm || (fish.numReborn == fish.maxNumReborm && fish.isExpired == true))
					{
						if(fish.isExpired == true)
						{
							GameLogic.getInstance().UseMaterialForFish(fish, GameLogic2.KIND_FISH_SUPER);
						}
						else 
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Cá đã hết hạn, \nKhông thể dùng thêm ngư thạch! ^_^", 310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
						}
					}
					else 
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Cá không hồi sinh được nữa, \nKhông thể dùng thêm ngư thạch! ^_^", 310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
					}
					break;
				case GameState.GAMESTATE_REBORN_XFISH:
					if (!fish.isExpired && fish.numReborn < fish.maxNumReborm)			//nếu con cá đó là cá hóa thạch
					{
						var iCurIdRebornMedicine:int = GuiMgr.getInstance().GuiStore.curId;
						GameLogic.getInstance().RebornSpartan(fish, iCurIdRebornMedicine);
					}
					break;
					
				default:
					break;
			}
			
		}
		
		public function OnOverFish(fish:Fish):void
		{
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_NORMAL)
			{
				switch(GameLogic.getInstance().gameState)
				{
					case GameState.GAMESTATE_IDLE:
						ViewFishInfo(fish, true);
						GameLogic.getInstance().MouseTransform("imgHand");
						break;
					case GameState.GAMESTATE_CURE_FISH:
						if (!fish.IsEgg && fish.Emotion == Fish.ILL)
						{
							fish.SetMovingState(Fish.FS_IDLE);
						}
					case GameState.GAMESTATE_CARE_FISH:				
						if (!fish.IsEgg && fish.CanCare())
						{
							fish.SetMovingState(Fish.FS_IDLE);
						}
						break;
					case GameState.GAMESTATE_SELL_FISH:					
						if(!fish.IsEgg)
						{
							fish.SetMovingState(Fish.FS_IDLE);
							fish.SetHighLight();
						}
						break;
					case GameState.GAMESTATE_RESET_MATE_FISH:
						if(!fish.IsEgg/**/&&fish.GuiFishStatus.Check(fish)==GUIFishStatus.PASS)
						{
							fish.SetMovingState(Fish.FS_IDLE);
							fish.SetHighLight();
						}
						break;
					case GameState.GAMESTATE_INCREASE_RANK_POINT:
					case GameState.GAMESTATE_RECOVER_HEALTH_SOLDIER:
					case GameState.GAMESTATE_REVIVE_SOLDIER:
					case GameState.GAMESTATE_OTHER_BUFF_SOLDIER:
					case GameState.GAMESTATE_USE_HERB_POTION:
						if (fish.FishType == Fish.FISHTYPE_SOLDIER)
						{
							fish.SetMovingState(Fish.FS_IDLE);
							fish.SetHighLight();
						}
						break;
					case GameState.GAMESTATE_ADD_MATERIAL_FOR_FISH:
						if(!fish.IsEgg && fish.GuiFishStatus.CheckCanUseMaterial(fish))
						{
							fish.SetMovingState(Fish.FS_IDLE);
							fish.SetHighLight();
						}
					break;
				}
			}
			else	if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)
			{
				if (fish is SubBossIce && (fish as SubBossIce).PreDie)
				{
					trace("Đánh subboss biển băng");
				}
				else
				{
					if (!Ultility.IsInMyFish() || LeagueController.getInstance().mode==LeagueController.IN_LEAGUE)
					{//trong thế giới cá hoặc trong liên đấu
						ViewFishInfo(fish, true);
					}
					if (fish.State != Fish.FS_WAR)
					{
						if (fish.State != Fish.FS_PRE_DEAD && Ultility.IsInMyFish() && LeagueController.getInstance().mode==LeagueController.IN_HOME)
						{
							fish.SetMovingState(Fish.FS_IDLE);
						}
						if (LeagueController.getInstance().mode == LeagueController.IN_HOME)
							fish.SetHighLight(0x00ff00);
						switch (fish.FishType)
						{
							case Fish.FISHTYPE_SOLDIER:
								if ((fish as FishSoldier).isActor == FishSoldier.ACTOR_MINE)
								{
									//GuiMgr.getInstance().GuiFishInfo.ShowInfoSoldier(fish as FishSoldier);
									ViewFishInfo(fish, true);
									break;
								}
								if ((fish as FishSoldier).Status == FishSoldier.STATUS_DEAD)
								{
									break;
								}
							default:
								// Show info
								ViewFishInfo(fish, true);
								break;
						}
					}
				}
			}
			else
			{
				fish.SetHighLight();
			}
		}
		
		public function OnOverFishSpartan(fish:FishSpartan):void
		{
			switch(GameLogic.getInstance().gameState)
			{
				case GameState.GAMESTATE_IDLE:
					ViewFishInfoSpartan(fish, true);
					break;
				case GameState.GAMESTATE_SELL_FISH:					
					fish.SetMovingState(Fish.FS_IDLE);
					fish.SetHighLight();
					break;
				case GameState.GAMESTATE_ADD_MATERIAL_FOR_FISH:
					fish.SetMovingState(Fish.FS_IDLE);
					fish.SetHighLight();
					break;
				case GameState.GAMESTATE_REBORN_XFISH:
					if (!fish.isExpired)	//di qua con cá hóa thạch
					{
						fish.SetHighLight();
					}
					break;
					
			}		
		}
		
		public function OnOutFish(fish:Fish):void
		{
			var state:int = GameLogic.getInstance().gameState;
			if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR && GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)
			{
				switch(state)
				{
					case GameState.GAMESTATE_IDLE:
						ViewFishInfo(fish, false);
						GameLogic.getInstance().BackToOldMouse();
						break;
					case GameState.GAMESTATE_CURE_FISH:
						if (!fish.IsEgg && fish.Emotion == Fish.ILL)
						{
							fish.SetMovingState(Fish.FS_SWIM);
						}
						break;
					case GameState.GAMESTATE_CARE_FISH:
						if (fish.CanCare() && !fish.IsEgg)
						{
							fish.SetMovingState(Fish.FS_SWIM);
						}
						break;
					case GameState.GAMESTATE_SELL_FISH:
						if(!fish.IsEgg)
						{
							fish.SetMovingState(Fish.FS_SWIM);
							fish.SetHighLight( -1);
						}
						break;
					case GameState.GAMESTATE_RESET_MATE_FISH:
						if(!fish.IsEgg)
						{
							fish.SetMovingState(Fish.FS_SWIM);
							fish.SetHighLight( -1);
						}
						break;
					case GameState.GAMESTATE_ADD_MATERIAL_FOR_FISH:
						if(!fish.IsEgg)
						{
							fish.SetMovingState(Fish.FS_SWIM);
							fish.SetHighLight( -1);
						}
						break;
					case GameState.GAMESTATE_INCREASE_RANK_POINT:
					case GameState.GAMESTATE_RECOVER_HEALTH_SOLDIER:
					case GameState.GAMESTATE_REVIVE_SOLDIER:
					case GameState.GAMESTATE_OTHER_BUFF_SOLDIER:
					case GameState.GAMESTATE_USE_HERB_POTION:
						if (fish.FishType == Fish.FISHTYPE_SOLDIER)
						{
							fish.SetMovingState(Fish.FS_SWIM);
							fish.SetHighLight( -1);
						}
						break;
				}
			}
			else	if(GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WORLD_FOREST)// GAMEMODE_WAR
			{
				if (fish is SubBossIce && (fish as SubBossIce).PreDie)
				{
					trace("Đánh subboss biển băng");
				}
				else
				{
					if (fish.State != Fish.FS_WAR)
					{			
						fish.OnMouseOutFish();
					}
					if (!Ultility.IsInMyFish() || LeagueController.getInstance().mode==LeagueController.IN_LEAGUE)
					{//trong thế giới cá và trong liên đấu
						ViewFishInfo(fish, false);
					}
				}
			}	
			else
			{
				fish.SetHighLight( -1);
				switch(GameLogic.getInstance().gameState)
				{
					case GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR:
					case GameState.GAMESTATE_FISHWORLD_FOREST_PRE_CREATE_WAR:
					case GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_TO_GET_GIFT:
					{
						if (GuiMgr.getInstance().GuiFishInfo.IsVisible)
						{
							GuiMgr.getInstance().GuiFishInfo.Hide();
						}
						if ((FishWorldController.GetRound() == Constant.OCEAN_FOREST_ROUND_1 || 
							FishWorldController.GetRound() == Constant.OCEAN_FOREST_ROUND_2) &&
							(fish as FishSoldier).isActor != FishSoldier.ACTOR_MINE)
						{
							fish.SetMovingState(Fish.FS_IDLE);
						}
						else
						{
							fish.SetMovingState(Fish.FS_STANDBY);
						}
						break;
					}
				}
			}
		}
		
		public function OnOutFishSpartan(fish:FishSpartan):void
		{
			var state:int = GameLogic.getInstance().gameState;
			switch(state)
			{
				case GameState.GAMESTATE_IDLE:
					ViewFishInfoSpartan(fish, false);
					break;
				case GameState.GAMESTATE_SELL_FISH:
					{
						fish.SetMovingState(Fish.FS_SWIM);
						fish.SetHighLight( -1);
					}
					break;
				case GameState.GAMESTATE_ADD_MATERIAL_FOR_FISH:
					fish.SetMovingState(Fish.FS_SWIM);
					fish.SetHighLight( -1);
					break;
				case GameState.GAMESTATE_REBORN_XFISH:
					if (!fish.isExpired)//di ra ngoài con cá hóa thạch
					{
						fish.SetHighLight( -1);
					}
			}		
		}
		
		//public function ViewFishInfo(fish:Fish, IsIdle:Boolean):void
		//{
			// Mouse Over
			//if ((fish.State != Fish.FS_SWIM && fish.State != Fish.FS_IDLE) || fish.IsDraging)
			//{
				//return;
			//}
			//
			//var guiInfo:GUIFishInfo = GuiMgr.getInstance().GuiFishInfo;			
			//
			//if (IsIdle)
			//{				
				//if (guiInfo.IsVisible)
				//{
					//if (guiInfo.FishId != fish.Id)
					//if (!guiInfo.IsBaseInfo)
					//{
						//return;// guiInfo.HideDrop();
					//}
				//}
				//
				//fish.SetMovingState(Fish.FS_IDLE);
				//guiInfo.IsEgg = fish.IsEgg;
				//guiInfo.IsBaseInfo = true;
				//guiInfo.Show(Constant.GUI_MIN_LAYER, 0);	
				//guiInfo.Show(Constant.OBJECT_LAYER, 0);	
				//
				// Tinh toan cac thong so
				//if (fish.FishType != Fish.FISHTYPE_SOLDIER)
				//{
					//if(fish.ClassName != "FireworkFish")
					//{
						//guiInfo.ShowInfo(fish);
					//}
					//else
					//{
						//guiInfo.showInfoFireworkFish(fish as FireworkFish);
					//}
				//}
				//else
				//{
					//guiInfo.ShowInfoSoldier(fish as FishSoldier);
				//}
				//
				//
			//}
			// Mouse out
			//else
			//{
				//if (guiInfo.IsVisible)
				//{
					//if(guiInfo.IsBaseInfo)
					//{
						//guiInfo.Hide();
						//if (!fish.IsEgg && !fish.IsDraging)
						//{
							//fish.State = Fish.FS_SWIM;
						//}
						//
						//fish.SetHighLight( -1);
					//}
				//}				
			//}
		//}
		
		public function ViewFishInfo(fish:Fish, IsIdle:Boolean):void
		{
			// Mouse Over
			if ((fish.State != Fish.FS_SWIM && fish.State != Fish.FS_IDLE && fish.State != Fish.FS_STANDBY) || fish.IsDraging)
			{
				return;
			}
			
			var guiInfo:GUIFishInfo = GuiMgr.getInstance().GuiFishInfo;			
			
			if (IsIdle)
			{	
				if (Ultility.IsInMyFish() && LeagueController.getInstance().mode == LeagueController.IN_HOME)
				{//ở nhà, thì set về IDLE
					fish.SetMovingState(Fish.FS_IDLE);
				}

				// Tinh toan cac thong so
				if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
				{
					guiInfo.Show(Constant.OBJECT_LAYER, 0);	
					
					if(fish.ClassName != "FireworkFish")
					{
						guiInfo.ShowInfo(fish);
					}
					else
					{
						guiInfo.showInfoFireworkFish(fish as FireworkFish);
					}
					//if (fish.FishType != Fish.FISHTYPE_SOLDIER)
					//{
						//guiInfo.ShowInfo(fish);
					//}
					//else
					//{
					if (fish.FishType == Fish.FISHTYPE_SOLDIER)
					{
						guiInfo.ShowInfoSoldier(fish as FishSoldier);
					}
					//}
					return;
				}
				else
				{
					if (GameLogic.getInstance().user.CurSoldier[0] || !Ultility.IsInMyFish() || LeagueController.getInstance().mode==LeagueController.IN_LEAGUE)//xét cả ở liên đấu
					{
						if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
						{
							if ((fish as FishSoldier).isActor == FishSoldier.ACTOR_MINE)
							{
								guiInfo.Show(Constant.OBJECT_LAYER);
							}
						}
						else 
						{
							guiInfo.Show(Constant.OBJECT_LAYER);
						}
						
					}
					
					//if (!Ultility.IsInMyFish())
					//{
						if(fish is FishSoldier && (fish as FishSoldier).isActor == FishSoldier.ACTOR_MINE)
						{
							guiInfo.ShowInfoSoldier(fish as FishSoldier);
						}
						else 
						{
							if (LeagueController.getInstance().mode == LeagueController.IN_HOME)
							{
								guiInfo.ShowTargetInfo(fish);
							}
						}
					//}
					//else
					//{
						//guiInfo.ShowTargetInfo(fish);
					//}
				}
				
				//guiInfo.ShowTargetInfo(fish);
				
			}
			// Mouse out
			else
			{
				if (guiInfo.IsVisible)
				{
					var standbyPos:Point = new Point();
					if (fish is FishSoldier && !Ultility.IsInMyFish() && fish.State != Fish.FS_STANDBY)
					{
						standbyPos = (fish as FishSoldier).standbyPos;
						fish.SetMovingState(Fish.FS_SWIM);
						fish.SwimTo(standbyPos.x, standbyPos.y, 20, true);
					}
					guiInfo.Hide();
					if (!fish.IsEgg && !fish.IsDraging && fish.State != Fish.FS_STANDBY)
					{
						fish.SetMovingState(Fish.FS_SWIM);
					}
					else if (fish.State == Fish.FS_STANDBY && !Ultility.IsInMyFish() && fish.CurPos.subtract(standbyPos).length > 50) 
					{
						fish.SetMovingState(Fish.FS_SWIM);
					}
					
					if ((fish is FishSoldier) && (fish as FishSoldier).EquipmentList && (fish as FishSoldier).EquipmentList.Mask && (fish as FishSoldier).EquipmentList.Mask[0] && (fish as FishSoldier).EquipmentList.Mask[0].Color > 1)
					{
						FishSoldier.EquipmentEffect(fish.img, (fish as FishSoldier).EquipmentList.Mask[0].Color);
					}
					else
					{
						fish.SetHighLight( -1);
					}
				}				
			}
		}
		
		public function ViewFishInfoSpartan(fish:FishSpartan, IsIdle:Boolean):void
		{	
			// Mouse Over
			if ((fish.State != Fish.FS_SWIM && fish.State != Fish.FS_IDLE) || fish.IsDraging)
			{
				return;
			}
			
			var guiInfo:GUIFishInfo = GuiMgr.getInstance().GuiFishInfo;			
			
			if (IsIdle)
			{				
				if (guiInfo.IsVisible)
				{
					//if (guiInfo.FishId != fish.Id)
					//if (!guiInfo.IsBaseInfo)
					{
						return;// guiInfo.HideDrop();
					}
				}
				
				{
					fish.SetMovingState(Fish.FS_IDLE);
				}
				//guiInfo.IsBaseInfo = true;
				//guiInfo.Show(Constant.GUI_MIN_LAYER, 0);	
				guiInfo.Show(Constant.OBJECT_LAYER, 0);	
				
				// Tinh toan cac thong so
				guiInfo.ShowInfoSpartan(fish);
			}
			// Mouse out
			else
			{
				if (guiInfo.IsVisible)
				{
					//if(guiInfo.IsBaseInfo)
					{
						guiInfo.Hide();
						if (!fish.IsDraging)
						{
							fish.State = Fish.FS_SWIM;
						}
						fish.SetHighLight( -1);
					}
				}				
			}
		}
		
		public function OnClickDecorate(deco:Decorate):void
		{
			//trace("deco pos:", deco.img.x, deco.img.y);
			if (GameLogic.getInstance().user.IsViewer()) return;
			if (GameLogic.getInstance().gameState != GameState.GAMESTATE_EDIT_DECORATE)
				return;
			if (!deco.img.visible) return;
			
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			GuiMgr.getInstance().GuiDecorateInfo.CurObject = deco;
			
			GuiMgr.getInstance().GuiDecorateInfo.ShowDecoInfo(deco);
			deco.SetHighLight();
		}
		
		public function ClickOnGame(event:MouseEvent):void
		{	
			//if (MousePos == null) return;
			//if (MousePos.y < GuiMgr.getInstance().GuiMain.img.y - 15)
			{
				//if (GameLogic.getInstance().gameState == GameState.GAMESTATE_OPEN_MAGIC_BAG) return;
				switch (GameLogic.getInstance().gameState)
				{
					case GameState.GAMESTATE_FEED_FISH:
						if (event.target.parent == LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) || event.target.parent == LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER))
						{
							var pos:Point;
							/*if(!GameController.getInstance().isSmallBackGround)
							{
								pos = GuiMgr.getInstance().GuiCharacter.GetPosAvatar();
							}
							else*/
							{
								pos = Ultility.PosScreenToLake(event.stageX, event.stageY);
							}
							// Play sound
							var sound:Sound = SoundMgr.getInstance().getSound("ChoCaAn") as Sound;
							if (sound != null)
							{
								sound.play();
							}
							GameController.getInstance().DropFood(pos.x + 45, pos.y);
							
							if (GameLogic.getInstance().user.Id != GameLogic.getInstance().user.GetMyInfo().Id)
							{
								GameLogic.getInstance().FishChatting(Constant.CHAT_FRIENDLY_FEED, 3000, 2);
							}
						}
						break;
						
					case GameState.GAMESTATE_IDLE:
						//if (GameController.getInstance().BgSky && event.target != GameController.getInstance().BgSky.img
							//&& (event.target.parent == LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER)))
						if (GameController.getInstance().BgLake && event.target == GameController.getInstance().BgLake.img)// && event.target.parent == LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER))
						{
							GameLogic.getInstance().user.PlayFish(MousePos.x, MousePos.y);
						}
						break;
					case GameState.GAMESTATE_REBORN_XFISH://trạng thái dùng thuốc hồi sinh
					case GameState.GAMESTATE_RESET_MATE_FISH:	//trạng thái dùng viagra
					{
						if (event.target.parent == LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) || event.target.parent == LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER))
						{
							//chuyen con chuot ve trang thai binh thuong
							GameLogic.getInstance().BackToIdleGameState();
							GameController.getInstance().UseTool("Default");
							//khong hien info cua ca trong ho
							GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
							GuiMgr.getInstance().GuiMain.ShowLakes();
						}
						break;
					}
					case GameState.GAMESTATE_INCREASE_RANK_POINT:
					case GameState.GAMESTATE_RECOVER_HEALTH_SOLDIER:
					case GameState.GAMESTATE_REVIVE_SOLDIER:
					case GameState.GAMESTATE_OTHER_BUFF_SOLDIER:
					case GameState.GAMESTATE_USE_HERB_POTION:
					{
						if (event.target.parent == LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) || event.target.parent == LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER))
						{
							GameLogic.getInstance().BackToIdleGameState();
							GameController.getInstance().UseTool("Default");
							GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
							if(GuiMgr.getInstance().GuiMain.IsVisible)	GuiMgr.getInstance().GuiMain.ShowLakes();
						}
						break;
					}
				}				
					
				//trace(event.target, event.currentTarget, event.target.parent);
				//if (event.target == GameController.getInstance().BgLake.img && GameLogic.getInstance().gameState == GameState.GAMESTATE_IDLE)
				//if (GameLogic.getInstance().gameState == GameState.GAMESTATE_IDLE && event.target != GameController.getInstance().BgSky.img
					//&& (event.target.parent == LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER) || event.target.parent == LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER)))
				//{
					//GameLogic.getInstance().user.PlayFish(MousePos.x, MousePos.y);
				//}
				
			}			
		}
	
		public function OnClickFishEmotion(emo:EmotionImg):void
		{
			GameLogic.getInstance().MouseTransform("");
			if (!Ultility.IsInMyFish())	
			{
				GameLogic.getInstance().user.CurSoldier[1] = emo.MyFish;
			}
			emo.MyFish.onClickEmotion();
		}
		
		public function OnClickFallingObject(mat:FallingObject):void
		{		
			/*var guiStore:GUIStore = GuiMgr.getInstance().GuiStore;
			if (guiStore.IsVisible)
			{
				guiStore.UpdateStore(mat.ItemType, mat.ItemId);
			}
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffNhapNhay", null, mat.CurPos.x - 25, mat.CurPos.y + 25);		
			var matArr:Array = GameLogic.getInstance().user.fallingObjArr;
			var i:int = matArr.indexOf(mat);
			mat.Destructor();
			matArr.splice(i, 1);
			GameLogic.getInstance().BackToOldMouse();*/
			mat.startFly();
		}
		
		public function OnMouseDownMotionObject(mat:MotionObject):void 
		{
			//var index:int = EffectMgr.getInstance().motionArr.indexOf(mat);
			//GameLogic.getInstance().user.arrWaitProcessExp.splice(index, 1);
		}
	}

}