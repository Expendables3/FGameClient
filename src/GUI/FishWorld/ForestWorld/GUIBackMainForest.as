package GUI.FishWorld.ForestWorld 
{
	import adobe.utils.CustomActions;
	import com.adobe.images.BitString;
	import com.greensock.easing.Circ;
	import com.greensock.plugins.ShortRotationPlugin;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.Network.SendAttackWorld;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIBackMainForest extends BaseGUI 
	{
		public const CTN_DEITY_MAIN_FOREST:String = "CtnDeityMainForest";
		public const IMG_DEITY_MAIN_FOREST:String = "ImgDeityMainForest";
		public const IMG_DEITY_MAIN_FOREST_0:String = "ImgDeityMainForest0";
		public const IMG_DEITY_MAIN_FOREST_1:String = "ImgDeityMainForest1";
		public const IMG_DEITY_MAIN_FOREST_2:String = "ImgDeityMainForest2";
		public const IMG_DEITY_MAIN_FOREST_3:String = "ImgDeityMainForest3";
		public const IMG_DEITY_MAIN_FOREST_4:String = "ImgDeityMainForest4";
		public const BTN_BACK_MAIN_FOREST:String = "BtnBackMainForest";
		public const IMG_PRG_DAMAGE_MY_FISH:String = "ImgPrgDamageMyFish";
		public var imgPrgGift:Image;
		public var arrThresholdGift:Array = [];
		public var idRound:int
		public var ctnMainRound2:Container;
		public var objt:Object;
		public var isCanDoBackForestWorld:Boolean = true;
		private var isShowGift:Boolean = false;
		
		public function GUIBackMainForest(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIBackMainForest";
		}
		public function init(_idRound:int):void 
		{
			if(arrThresholdGift.length <= 0)
			{
				var objConf:Object = ConfigJSON.getInstance().GetItemList("ForestGift");
				for (var i:int = 1; i < 6; i++) 
				{
					var item:Object = objConf[i.toString()];
					arrThresholdGift.push(item.DamRequire);
				}
			}
			idRound = _idRound;
			Show();
		}
		override public function InitGUI():void 
		{
			super.InitGUI();
			isCanDoBackForestWorld = true;
			isCanClickDeity = true;
			objt = GuiMgr.getInstance().GuiMapOcean.arrListOcean[3].Monster[FishWorldController.GetRound().toString()];
			this.setImgInfo = function():void
			{
				SetPos(0, 0);
				var btnEx:ButtonEx;
				var tt:TooltipFormat;
				tt = new TooltipFormat();
				//tt.text = "Trở về biển Hắc Lâm";
				tt.text = Localization.getInstance().getString("TooltipFishWorld1");
				switch (idRound) 
				{
					case Constant.SEA_ROUND_2:
						ctnMainRound2 = AddContainer(CTN_DEITY_MAIN_FOREST, "LoadingForestWorld_ImgFrameFriend", 600, 90, true, this);
						ctnMainRound2.AddImage(IMG_DEITY_MAIN_FOREST_0, "LoadingForestWorld_Deity_0", 35, 330, true, ALIGN_LEFT_TOP);
						ctnMainRound2.AddImage(IMG_DEITY_MAIN_FOREST_1, "LoadingForestWorld_Deity_1", 35, 330, true, ALIGN_LEFT_TOP);
						ctnMainRound2.AddImage(IMG_DEITY_MAIN_FOREST_2, "LoadingForestWorld_Deity_2", 35, 238, true, ALIGN_LEFT_TOP);
						ctnMainRound2.AddImage(IMG_DEITY_MAIN_FOREST_3, "LoadingForestWorld_Deity_3", 35, 134, true, ALIGN_LEFT_TOP);
						ctnMainRound2.AddImage(IMG_DEITY_MAIN_FOREST_4, "LoadingForestWorld_Deity_4", 35, 39, true, ALIGN_LEFT_TOP);
						btnEx = AddButtonEx(BTN_BACK_MAIN_FOREST, "LoadingForestWorld_Back", 600, 495, this);
						btnEx.setTooltip(tt);
						UpdatePosRound2(objt);
						ctnMainRound2.SetScaleXY(0.75);
					break;
					case Constant.SEA_ROUND_1:
					case Constant.SEA_ROUND_3:
						btnEx = AddButtonEx(BTN_BACK_MAIN_FOREST, "LoadingForestWorld_Back", 600, 495, this);
						btnEx.setTooltip(tt);
					break;
					case Constant.SEA_ROUND_4:
						imgPrgGift = AddImage("", "LoadingForestWorld_PrgLucChien", 740, 330);
						(imgPrgGift.img as MovieClip).gotoAndStop(1);
					break;
			}
				}
			LoadRes("LoadingForestWorld_ImgFrameFriend");
		}
		public function UpdatePosRound2(objt:Object):void 
		{
			var isUpdateFinish:Boolean = true;
			for (var i:int = 1; i <= GuiMgr.getInstance().GuiMainForest.MAX_MONSTER_GREEN_RIGHT; i++ ) 
			{
				var heightHide:Number;
				var imageHide:Image;
				if (objt[String(i)] == null && i < GuiMgr.getInstance().GuiMainForest.MAX_MONSTER_GREEN_RIGHT)
				{
					imageHide = ctnMainRound2.GetImage(IMG_DEITY_MAIN_FOREST + i);
					if (imageHide != null && imageHide.img != null)
					{
						//heightHide = imageHide.img.height * 0.75;
						heightHide = imageHide.img.height * 0.85;
						if (imageHide.img.visible)
						{
							for (var j:int = i + 1; j <= GuiMgr.getInstance().GuiMainForest.MAX_MONSTER_GREEN_RIGHT; j++) 
							{
								TweenMax.to(ctnMainRound2.GetImage(IMG_DEITY_MAIN_FOREST + j).img, 1 + (j - i) / 10, { bezier:[ { x:ctnMainRound2.GetImage(IMG_DEITY_MAIN_FOREST + j).CurPos.x, 
									y:ctnMainRound2.GetImage(IMG_DEITY_MAIN_FOREST + j).CurPos.y + heightHide } ], ease:Circ.easeIn, onComplete:onFinishTweenMax, 
									onCompleteParams:[j, heightHide, objt]});
							}
							imageHide.img.visible = false;
							isUpdateFinish = false;
							break;
						}
					}
				}
			}
		}
		private function onFinishTweenMax(index:int, heightHide:Number, objt:Object ):void
		{
			var imageHide:Image = ctnMainRound2.GetImage(IMG_DEITY_MAIN_FOREST + index);
			if(imageHide != null)
			{
				imageHide.SetPos(imageHide.CurPos.x, imageHide.CurPos.y + heightHide);
			}
			if(index == GuiMgr.getInstance().GuiMainForest.MAX_MONSTER_GREEN_RIGHT)
			{
				UpdatePosRound2(objt);
			}
		}
		public var isCanClickDeity:Boolean = true;
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{	
			switch (buttonID) 
			{
				case BTN_BACK_MAIN_FOREST:
					if(!isCanDoBackForestWorld)
					{
						return;
					}
					DoBackForestWorld();
					break;
				case CTN_DEITY_MAIN_FOREST:
					var arr:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen;
					var monster:FishSoldier = arr[0];
					if(isCanClickDeity)
					{
						isCanClickDeity = false;
						var mousePos:Point = Ultility.PosLakeToScreen(monster.standbyPos.x, monster.standbyPos.y);
						EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, monster.ImgName.replace("Idle", "Jump"),
								null, mousePos.x + 20, mousePos.y + 125, false, false, null, DoAttackDeity);
					}
					break;
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case CTN_DEITY_MAIN_FOREST:
					ctnMainRound2.SetHighLight();
				break;
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case CTN_DEITY_MAIN_FOREST:
					ctnMainRound2.SetHighLight( -1);
				break;
			}
		}
		
		public function CheckHaveInList(id:int):Boolean
		{
			var rt:Boolean = false;
			var arr:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:FishSoldier = arr[i];
				if (item.Id == id)
				{
					rt = true;
					break;
				}
			}
			return rt;
		}
		
		public function DoAttackDeity():void 
		{
			var arr:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen;
			var monster:FishSoldier = arr[0];
			if (monster == null)	return;
			monster.Show();
			monster.SetPos(monster.standbyPos.x, monster.standbyPos.y);
			monster.SetMovingState(Fish.FS_IDLE);
			monster.DesPos.x = 0;
			if (monster.standbyPos != null)
			{
				monster.DesPos.x = monster.standbyPos.x - 5;
			}
			//monster.img.rotation = 0;
			//monster.flipX( -1);
			var arr_:Array = GameLogic.getInstance().user.FishSoldierActorMine;
			// Cập nhật lại state nếu như nó có bị thay đổi
			if (GameLogic.getInstance().gameState != GameState.GAMESTATE_FISHWORLD_FOREST_RIGHT_GREEN_MONSTER_SHOW_NO_REACHDES)
			{
				GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_RIGHT_GREEN_MONSTER_SHOW_NO_REACHDES);
			}
			for (var iForFishWorld:int = 0; iForFishWorld < GameLogic.getInstance().user.FishSoldierActorMine.length; iForFishWorld++) 
			{
				var itemFishMine:FishSoldier = GameLogic.getInstance().user.FishSoldierActorMine[iForFishWorld];
				itemFishMine.SetPos(itemFishMine.standbyPos.x - 5, itemFishMine.standbyPos.y);
				itemFishMine.SwimTo(itemFishMine.standbyPos.x, itemFishMine.standbyPos.y, 10);
			}
			if (monster.CheckReachDesAll(arr_))
			{
				GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_PRE_CREATE_WAR);
				monster.SetEmotion(FishSoldier.WAR);
			}
		}
		
		public function DoBackForestWorld():void 
		{
			GuiMgr.getInstance().GuiMainForest.InitBackground(Constant.ID_FISH_WORLD_BACKGROUND_4);
			if (GuiMgr.getInstance().GuiChooseSerialAttack.IsVisible)	GuiMgr.getInstance().GuiChooseSerialAttack.Hide();
			if (GuiMgr.getInstance().GuiMainForest.IsVisible)	GuiMgr.getInstance().GuiMainForest.Hide();
			if (GuiMgr.getInstance().GuiBackMainForest.IsVisible)	GuiMgr.getInstance().GuiBackMainForest.Hide();
			if (GuiMgr.getInstance().GuiEffRandomSeaRightGreen.IsVisible)	GuiMgr.getInstance().GuiEffRandomSeaRightGreen.Hide();
			var GuiM:GUIMainForest = GuiMgr.getInstance().GuiMainForest;
			var arr:Array;
			var i:int = 0;
			for (i = 0; i < GuiM.arrMonsterDownGreen.length; i++) 
			{
				(GuiM.arrMonsterDownGreen[i] as FishSoldier).Destructor();
			}
			GuiM.arrMonsterDownGreen.splice(0, GuiM.arrMonsterDownGreen.length);
			
			for (i = 0; i < GuiM.arrThicketUpRed.length; i++) 
			{
				(GuiM.arrThicketUpRed[i] as FishSoldier).Destructor();
			}
			GuiM.arrThicketUpRed.splice(0, GuiM.arrThicketUpRed.length);
			
			for (i = 0; i < GuiM.arrThicketUpRedInPosition.length; i++) 
			{
				(GuiM.arrThicketUpRedInPosition[i] as FishSoldier).Destructor();
			}
			GuiM.arrThicketUpRedInPosition.splice(0, GuiM.arrThicketUpRedInPosition.length);
			
			for (i = 0; i < GuiM.arrMonsterRightGreen.length; i++) 
			{
				(GuiM.arrMonsterRightGreen[i] as FishSoldier).Destructor();
			}
			GuiM.arrMonsterRightGreen.splice(0, GuiM.arrMonsterRightGreen.length);
			
			for (i = 0; i < GuiM.arrMonsterGift.length; i++) 
			{
				(GuiM.arrMonsterGift[i] as FishSoldier).Destructor();
			}
			GuiM.arrMonsterGift.splice(0, GuiM.arrMonsterGift.length);
			
			for (i = 0; i < GuiM.arrMonsterUpRed.length; i++) 
			{
				(GuiM.arrMonsterUpRed[i] as FishSoldier).Destructor();
			}
			GuiM.arrMonsterUpRed.splice(0, GuiM.arrMonsterUpRed.length);
			GuiM.Show(Constant.OBJECT_LAYER);
			GuiMgr.getInstance().GuiMapOcean.GoToOcean(Constant.OCEAN_FOREST);
			GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
		}
		
		//Cac bien su dung cho vong danh boss nhan qua
		public var objSceneAll:Object;
		public var isReceiveDataForBossGift:Boolean = false;
		public var curFishSoldierGetGift:FishSoldier = null;
		
		public function ProcessDataForAttackBoss(Data1:Object):void 
		{
			isShowGift = false;
			objSceneAll = Data1.Scene;
			isReceiveDataForBossGift = true;
			if (GuiMgr.getInstance().GuiFishWarForest.IsVisible)
			{
				GuiMgr.getInstance().GuiFishWarForest.Hide();
			}
		}
		
		public function ProcessGetGift(f:FishSoldier):void 
		{
			var mst:FishSoldier = GuiMgr.getInstance().GuiMainForest.arrMonsterGift[0];
			curFishSoldierGetGift = f;
			curFishSoldierGetGift.SwimTo(mst.standbyPos.x - 100, mst.standbyPos.y, 20);
		}
		
		public function ShowEffGetGift():void 
		{
			if(curFishSoldierGetGift)
			{
				var objGiftForCur:Object = objSceneAll[curFishSoldierGetGift.Id.toString()];
				for (var i:int = 0; i < arrThresholdGift.length; i++) 
				{
					var threshold:int = arrThresholdGift[i];
					if (int(objGiftForCur.Damage) < threshold)
					{
						if (i == 0)
						{
							curPercentGift = Math.round(objGiftForCur.Damage / threshold * (100 / arrThresholdGift.length));
						}
						else
						{
							curPercentGift = Math.round(i * ( 100 / arrThresholdGift.length) + (objGiftForCur.Damage - arrThresholdGift[i - 1]) / 
											threshold * (100 / arrThresholdGift.length));
						}
						curLevelGift = i;
						conLevelGift = i;
						break;
					}
					else
					{
						curPercentGift = (i + 1) * (100 / arrThresholdGift.length);
						curLevelGift = i + 1;
						conLevelGift = i + 1;
					}
				}
				curPercentGift = Math.min(curPercentGift, 100);
				curPercentGift = Math.max(curPercentGift, 1);
				curLevelGift = Math.min(curLevelGift, 5);
				conLevelGift = Math.min(conLevelGift, 5);
				EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffWar" + curFishSoldierGetGift.Element, null,
						//curFishSoldierGetGift.CurPos.x, curFishSoldierGetGift.CurPos.y, false, false, null, dropGift);
						curFishSoldierGetGift.CurPos.x, curFishSoldierGetGift.CurPos.y, false, false, null, PlayEffPrg);
			}
		}
		public function PlayEffPrg():void 
		{
			isPlayEffPrg = true;
			(imgPrgGift.img as MovieClip).gotoAndPlay(1);
		}
		public function finishDropGift():void
		{
			var arr:Array = GameLogic.getInstance().user.FishSoldierActorMine;
			var index:int = arr.indexOf(curFishSoldierGetGift);
			arr.splice(index, 1);
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "LoadingForestWorld_EffShowQuit", null, 
				curFishSoldierGetGift.CurPos.x - 365, curFishSoldierGetGift.CurPos.y - 110);
			curFishSoldierGetGift.Destructor();
			curFishSoldierGetGift = null;
			// Check xem da nhan qua het chua
			if (arr.length > 0)
			{
				GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_GET_GIFT);
				(arr[0] as FishSoldier).isChoose = true;
				GameLogic.getInstance().user.CurSoldier[0] = arr[0];
				(GuiMgr.getInstance().GuiMainForest.arrMonsterGift[0] as FishSoldier).SetEmotion(FishSoldier.WAR);
			}
			else
			{
				countWaitReturnMap = 0;
				isReturnMap = true;
			}
		}
		public function dropGiftInStage(objGiftForCurStage:Object):void 
		{
			for (var jStr:String in objGiftForCurStage)
			{
				var objElementGift:Object;
				for (var kStr:String in objGiftForCurStage[jStr]) 
				{
					objElementGift = objGiftForCurStage[jStr][kStr];
					GameLogic.getInstance().dropGiftFishWorld(objElementGift, 800, 500);
				}
			}
		}
		private function createObjAllGift():Object
		{
			var objAll:Object = new Object();
			var count:int = 0;
			for (var i:String in objSceneAll) 	// duyệt từng con cá
			{
					for (var j:String in objSceneAll[i]["Gift"]) 	// duyệt từng giai doạn của từng con cá
					{
						for (var k:String in objSceneAll[i]["Gift"][j]) 	// Duyệt từng loại Normal hoặc Equip của con cá
						{
							if (k == "Normal") 
							{
								for (var l:String in objSceneAll[i]["Gift"][j][k]) // Duyệt từng object trong cùng
								{
									var item:Object = objSceneAll[i]["Gift"][j][k][l];
									count++;
									if (objAll[i] == null)	
										objAll[i] = new Object();
									switch (item.ItemType) 
									{
										case "Exp":
										case "Money":
											if (!objAll[i]["Normal"])
												objAll[i]["Normal"] = new Object();
											objAll[i]["Normal"][count.toString()] = item;
											break;
										case "Material":
											if (!objAll[i]["Material"])
												objAll[i]["Material"] = new Object();
											objAll[i]["Material"][count.toString()] = item;
											break;
										case "Collection":
											if (!objAll[i]["Collection"])
												objAll[i]["Collection"] = new Object();
											objAll[i]["Collection"][count.toString()] = item;
											break;
										case "ItemList":
											
											break;
										case "Mask":
											if (!objAll[i]["Mask"])
												objAll[i]["Mask"] = new Object();
											objAll[i]["Mask"][count.toString()] = item;
											break;
										case "Gem":
											if (!objAll[i]["GemList"])
												objAll[i]["GemList"] = new Object();
											objAll[i]["GemList"][count.toString()] = item;
											break;
										case "MixFormula":
											if (!objAll[i]["MixFormula"])
												objAll[i]["MixFormula"] = new Object();
											objAll[i]["MixFormula"][count.toString()] = item;
											break;
									}
								}
							}
							else
							{
								if (!objAll[i])	objAll[i] = new Object();
								if (!objAll[i]["ItemList"])
									objAll[i]["ItemList"] = new Object();
								for (var m:int = 0; m < objSceneAll[i]["Gift"][j][k].length; m++) 
								{
									var item1:Object = objSceneAll[i]["Gift"][j][k][m];
									count++;
									objAll[i]["ItemList"][count.toString()] = item1;
								}
							}
						}
					}
					
			}
			return objAll;
		}
		public var isPlayEffPrg:Boolean = false;
		public var isReturnMap:Boolean = false;
		public var countWaitReturnMap:int = 0;
		public var curPercentGift:int = 0;
		public var curLevelGift:int = 0;
		public var conLevelGift:int = 0;
		public var countPrgBack:int = -1;
		public function Update():void 
		{
			// Check de quay ve map
			if (isReturnMap)
			{
				if (countWaitReturnMap < 50)
				{
					countWaitReturnMap++;
				}
				else
				{
					countWaitReturnMap = 0;
					isReturnMap = false;
					if (isShowGift)
					{
						GuiMgr.getInstance().GuiFinalKillBoss.InitGui(createObjAllGift());
						GuiMgr.getInstance().GuiFinalKillBoss.Show(Constant.GUI_MIN_LAYER, 1);
					}
					//DoBackForestWorld();
					//GuiMgr.getInstance().GuiMainFishWorld.ComeBackMap();
				}
			}
			// check de cho thanh luc chien chay len
			if (isPlayEffPrg)
			{
				if (imgPrgGift && imgPrgGift.img)
				{
					if ((imgPrgGift.img as MovieClip).currentFrame % 20 == 0)
					{
						curLevelGift --;
						if(curLevelGift >= 0)
						{
							if (objSceneAll[curFishSoldierGetGift.Id.toString()]["Gift"])
							{
								isShowGift = true;
								dropGiftInStage(objSceneAll[curFishSoldierGetGift.Id.toString()]["Gift"][String(conLevelGift - curLevelGift)]);
							}
						}
					}
					if ((imgPrgGift.img as MovieClip).currentFrame == curPercentGift)
					{
						if(countPrgBack < 0)
						{
							(imgPrgGift.img as MovieClip).stop();
						}
						else if(countPrgBack > 20)
						{
							countPrgBack = -2;
							(imgPrgGift.img as MovieClip).gotoAndStop(1);
							isPlayEffPrg = false;
							curPercentGift = 0;
							curLevelGift = 0;
							finishDropGift();
						}
						countPrgBack ++;
					}
				}
			}
		}
	}

}