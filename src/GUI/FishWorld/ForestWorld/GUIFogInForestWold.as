package GUI.FishWorld.ForestWorld 
{
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.GameState;
	import Logic.LayerMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIFogInForestWold extends BaseGUI 
	{
		private var isZoomIn:Boolean = true;
		public function GUIFogInForestWold(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFogInForestWold";
		}
		
		override public function InitGUI():void 
		{
			//super.InitGUI();
			LoadRes("LoadingForestWorld_ImgFrameFriend");
			SetPos(405, 312);
			var fogGui:Sprite = new Sprite();
			fogGui.graphics.beginFill(0x000000, 1);
			//fogGui.graphics.drawCircle(0, 0, 1025);
			fogGui.graphics.drawCircle(0, 0, 600);
			fogGui.graphics.endFill();
			img.addChild(fogGui);
			img.scaleX = img.scaleY = 0.1;
		}
		
		public function Update():void 
		{
			if(isZoomIn)
			{
				if(img.scaleX > 0)
				{
					img.scaleX = img.scaleY = img.scaleX + 0.1;
					if (img.scaleX >= 1)
					{
						isZoomIn = false;
						// Hiện 3 bụi rậm lên, và tạo 3 con quái vật lên
						if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST)
						{
							if (GameLogic.getInstance().gameState == GameState.GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_IN)
							{
								switch (GuiMgr.getInstance().GuiMainForest.TypeSwim) 
								{
									case GuiMgr.getInstance().GuiMainForest.TYPE_SWIM_UP:
										InitMonsterSeaUpRed();
									break;
									case GuiMgr.getInstance().GuiMainForest.TYPE_SWIM_DOWN:
										InitMonsterSeaDownGreen();
									break;
									case GuiMgr.getInstance().GuiMainForest.TYPE_SWIM_RIGHT:
										InitMonsterSeaRightGreen();
									break;
								}
							}
							GuiMgr.getInstance().GuiBackMainForest.init(GuiMgr.getInstance().GuiMainForest.TypeSwim);
						}
					}
				}
			}
			else 
			{
				img.scaleX = img.scaleY = img.scaleX - 0.2;
				if (img.scaleX <= 0)
				{
					isZoomIn = true;
					if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WORLD_FOREST)
					{
						if (GameLogic.getInstance().gameState == GameState.GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_TO_THICKET_NO_REACHDES)
						{
							PreForSeaUpRed();
						}
					}
					Hide();
				}
			}
		}
		
		public function PreForSeaUpRed():void 
		{
			var i:int = 0;
			for (i = 0; i < GameLogic.getInstance().user.FishSoldierActorMine.length; i++) 
			{
				var itemFishMine:FishSoldier = GameLogic.getInstance().user.FishSoldierActorMine[i];
				itemFishMine.SwimTo(itemFishMine.standbyPos.x, itemFishMine.standbyPos.y, 10);
			}
		}
		public function InitMonsterSeaUpRed():void 
		{
			var arrData:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterUpRedData;
			var arrMonster:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterUpRed;
			var arrThicket:Array = GuiMgr.getInstance().GuiMainForest.arrThicketUpRed;
			var arrThicketInPosition:Array = GuiMgr.getInstance().GuiMainForest.arrThicketUpRedInPosition;
			var i:int = 0;
			var imgName:String;
			// Tính các tọa độ cá nhà bạn bơi ra
			var theirSoldierPos:Array = new Array();
			theirSoldierPos.splice(0, theirSoldierPos.length);
			var p1:Point = new Point(Constant.MAX_WIDTH / 2 + 350, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 - 140);
			theirSoldierPos.push(p1);
			var p2:Point = new Point(p1.x, p1.y + 110);
			theirSoldierPos.push(p2);
			var p3:Point = new Point(p1.x, p1.y + 235);
			theirSoldierPos.push(p3);
			var iForFishWorld:int = 0;
			for (i = 0; i < arrData.length; i++) 
			{
				var item:Object = arrData[i];
				imgName = "ForestWorldMonsterRedUp_Idle";
				if (item.IsBoss != null && item.IsBoss == 1)
				{
					imgName = "ForestWorldBossRedUp_Idle";
				}
				var fis:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
					
				fis.OnLoadResCompleteFunction = function ():void 
				{
					var fs:FishSoldier;
					var arrMonsterUpRed:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterUpRed;
					fs = this;
					fs.SetMovingState(Fish.FS_IDLE);
					this.img.visible = false;
					EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, fs.ImgName.split("_")[0] + "_Jump",
						null, fs.standbyPos.x, fs.standbyPos.y, false, false, null, function():void { FinishEffJumpRedUp(fs) } );
				}
				fis.standbyPos = theirSoldierPos[i];
				fis.Id = item.Id;
				// Khởi tạo Equip
				var objEquip:Object = item.Equipment as Object;
				var Equipment:Object = GameLogic.getInstance().user.InitEquipmentForFishSoldierInWorld(objEquip);
				// Khởi tạo Quartz
				var objQuartz:Object = item.Quartz as Object;
				var Quartz:Object = GameLogic.getInstance().user.InitQuartzForFishSoldierInWorld(objQuartz);
				// Khởi tạo các tham số cho con cá lính
				fis = InitParamForFishSoldierInWorld(fis, item, Equipment, fis.standbyPos);
				fis.flipX( 1);
				fis.DesPos = new Point(0, fis.standbyPos.y);
				//fis.Hide();
				//fis.SetMovingState(Fish.FS_STANDBY);
				arrMonster.push(fis);
			}
			
			for (i = 0; i < arrData.length; i++) 
			{
				imgName = "LoadingForestWorld_ImgThicketEmpty";
				var thicket:Thicket = new Thicket(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
				thicket.standbyPos = new Point(theirSoldierPos[i].x - 110, theirSoldierPos[i].y);
				thicket.position = i;
				thicket.Init(theirSoldierPos[i].x - 110, theirSoldierPos[i].y);
				thicket.OnLoadResCompleteFunction = function ():void 
				{
					//this.SetMovingState(Fish.FS_STANDBY);
					this.SetMovingState(Fish.FS_IDLE);
				}
				arrThicket.push(thicket);
				arrThicketInPosition.push(thicket);
			}
			GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_TO_THICKET_NO_REACHDES);
		}
		
		public function FinishEffJumpRedUp(m:FishSoldier):void 
		{
			switch (GameLogic.getInstance().gameState) 
			{
				case GameState.GAMESTATE_FISHWORLD_FOREST_MONSTER_SWIM_TO_THICKET_NO_REACHDES:
					var arrMonsterUpRed:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterUpRed;
					var indexMonsterInUpRed:int = arrMonsterUpRed.indexOf(m);
					if(indexMonsterInUpRed >= 0)
					{
						m.img.visible = true;
						m.Hide();
						var thicket:Thicket = GuiMgr.getInstance().GuiMainForest.arrThicketUpRed[indexMonsterInUpRed];
						thicket.StateThicket = thicket.STATE_THICKET_FULL;
						thicket.fishSoldier = m;
						thicket.LoadRes("LoadingForestWorld_ImgThicketFull");
						var isShowAllFishWorld:Boolean = true;
						var fsw:FishSoldier;
						var iForFishWorld:int = 0;
						for (iForFishWorld = 0; iForFishWorld < arrMonsterUpRed.length; iForFishWorld++) 
						{
							fsw = arrMonsterUpRed[iForFishWorld] as FishSoldier;
							if (!fsw.IsHide)
							{
								isShowAllFishWorld = false;
								break;
							}
						}
						if (isShowAllFishWorld)
						{
							var arrIndex:Array = [];
							for (iForFishWorld = 0; iForFishWorld < GuiMgr.getInstance().GuiMainForest.arrThicketUpRedInPosition.length; iForFishWorld++) 
							{
								arrIndex.push(iForFishWorld);
							}
							var index31:int = Math.floor(Math.random() * arrIndex.length);
							var thicket31:Thicket = GuiMgr.getInstance().GuiMainForest.arrThicketUpRedInPosition[arrIndex[index31]];
							arrIndex.splice(index31, 1);
							var index41:int = Math.floor(Math.random() * arrIndex.length);
							var thicket41:Thicket = GuiMgr.getInstance().GuiMainForest.arrThicketUpRedInPosition[arrIndex[index41]];
							arrIndex.splice(0, arrIndex.length);
							GuiMgr.getInstance().GuiMainForest.Swap(thicket31, thicket41);
						}
					}
				break;
			}
		}
		
		public function InitMonsterSeaRightGreen(isShowMyFishSoldier:Boolean = true):void 
		{
			var arrMonster:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterRightGreen;

			// Tính các tọa độ cá nhà bạn bơi ra
			var pos:Point = new Point(Constant.MAX_WIDTH / 2 + 80, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 30);
			
			var item:Object = GuiMgr.getInstance().GuiMainForest.MonsterRightGreenData;
			var imgName:String = "ForestWorldBossRound2_" + item.Id + "_Idle";
			var fis:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
			fis.standbyPos = pos;
			fis.Id = item.Id;
			// Khởi tạo Equip
			var objEquip:Object = item.Equipment as Object;
			var Equipment:Object = GameLogic.getInstance().user.InitEquipmentForFishSoldierInWorld(objEquip);
			// Khởi tạo Quartz
			var objQuartz:Object = item.Quartz as Object;
			var Quartz:Object = GameLogic.getInstance().user.InitQuartzForFishSoldierInWorld(objQuartz);
			// Khởi tạo các tham số cho con cá lính
			fis = InitParamForFishSoldierInWorld(fis, item, Equipment, new Point(fis.standbyPos.x + 150, fis.standbyPos.y));
			arrMonster.push(fis);
			fis.Hide();
				
			GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_RIGHT_GREEN_MONSTER_SHOW_NO_REACHDES);
			
			if(isShowMyFishSoldier)
			{
				var arr_:Array = GameLogic.getInstance().user.FishSoldierActorMine;
				for (var iForFishWorld:int = 0; iForFishWorld < arr_.length; iForFishWorld++) 
				{
					var itemFishMine:FishSoldier = arr_[iForFishWorld];
					itemFishMine.SwimTo(itemFishMine.standbyPos.x, itemFishMine.standbyPos.y, 10);
				}
				itemFishMine.isChoose = true;
				GameLogic.getInstance().user.CurSoldier[0] = itemFishMine;
			}
		}
		
		public function InitMonsterSeaDownGreen():void 
		{
			var arrData:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownYellowData;
			var arrMonster:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownGreen;
			var i:int = 0;
			var imgName:String;
			// Tính các tọa độ cá nhà bạn bơi ra
			var theirSoldierPos:Array = new Array();
			theirSoldierPos.splice(0, theirSoldierPos.length);
			var p1:Point = new Point(Constant.MAX_WIDTH / 2 + 150, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 40);
			theirSoldierPos.push(p1);
			var p2:Point = new Point(p1.x, p1.y - 150);
			theirSoldierPos.push(p2);
			var p3:Point = new Point(p1.x, p1.y + 150);
			theirSoldierPos.push(p3);
			var p4:Point = new Point(p1.x + 100, p1.y - 150);
			theirSoldierPos.push(p4);
			var p5:Point = new Point(p1.x + 100, p1.y + 150);
			theirSoldierPos.push(p5);
			var p6:Point = new Point(p1.x + 150, p1.y);
			theirSoldierPos.push(p6);
			
			for (i = 0; i < arrData.length; i++)
			{
				var item:Object = arrData[i];
				//imgName = Fish.ItemType + item.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
				imgName = "ForestWorldSnakeNormal_" + item.Element + "_" + "Idle";
				if (item.IsBoss != null && item.IsBoss == 1)
				{
					imgName = "ForestWorldSnakeBoss_Idle";
				}
				var fis:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
				//if(item.Id == 6)	fis.standbyPos = theirSoldierPos[theirSoldierPos.length - 1];
				fis.Id = item.Id;
				fis.standbyPos = theirSoldierPos[(fis.Id - 1)];
				// Khởi tạo Equip
				var objEquip:Object = item.Equipment as Object;
				var Equipment:Object = GameLogic.getInstance().user.InitEquipmentForFishSoldierInWorld(objEquip);
				// Khởi tạo Quartz
				var objQuartz:Object = item.Quartz as Object;
				var Quartz:Object = GameLogic.getInstance().user.InitQuartzForFishSoldierInWorld(objQuartz);
				// Khởi tạo các tham số cho con cá lính
				fis = InitParamForFishSoldierInWorld(fis, item, Equipment, new Point(fis.standbyPos.x + 150, fis.standbyPos.y));
				fis.SwimTo(fis.standbyPos.x, fis.standbyPos.y, 10);
				arrMonster.push(fis);
				fis.OnLoadResCompleteFunction = function ():void 
				{
					this.SwimTo(this.standbyPos.x, this.standbyPos.y, 4);
				}
			}
			GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_SET_QUEUE_FS_NO_REACHDES);
		}
		
		public function ReInitMonsterSeaDownYellow():void 
		{
			var arrData:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownYellowData;
			var arrMonster:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterDownGreen;
			var i:int = 0;
			var imgName:String;
			// Tính các tọa độ cá nhà bạn bơi ra
			var theirSoldierPos:Array = new Array();
			theirSoldierPos.splice(0, theirSoldierPos.length);
			var p1:Point = new Point(Constant.MAX_WIDTH / 2 + 150, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 40);
			theirSoldierPos.push(p1);
			var p2:Point = new Point(p1.x, p1.y - 150);
			theirSoldierPos.push(p2);
			var p3:Point = new Point(p1.x, p1.y + 150);
			theirSoldierPos.push(p3);
			var p4:Point = new Point(p1.x + 100, p1.y - 150);
			theirSoldierPos.push(p4);
			var p5:Point = new Point(p1.x + 100, p1.y + 150);
			theirSoldierPos.push(p5);
			var p6:Point = new Point(p1.x + 150, p1.y);
			theirSoldierPos.push(p6);
			
			for (i = 0; i < arrData.length; i++)
			{
				var item:Object = arrData[i];
				//imgName = Fish.ItemType + item.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
				imgName = "ForestWorldSnakeNormal_" + item.Element + "_" + "Idle";
				if (item.IsBoss != null && item.IsBoss == 1)
				{
					imgName = "ForestWorldSnakeBoss_Idle";
				}
				var fis:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
				//if(item.Id == 6)	fis.standbyPos = theirSoldierPos[theirSoldierPos.length - 1];
				fis.Id = item.Id;
				fis.standbyPos = theirSoldierPos[(fis.Id - 1)];
				// Khởi tạo Equip
				var objEquip:Object = item.Equipment as Object;
				var Equipment:Object = GameLogic.getInstance().user.InitEquipmentForFishSoldierInWorld(objEquip);
				// Khởi tạo Quartz
				var objQuartz:Object = item.Quartz as Object;
				var Quartz:Object = GameLogic.getInstance().user.InitQuartzForFishSoldierInWorld(objQuartz);
				// Khởi tạo các tham số cho con cá lính
				fis = InitParamForFishSoldierInWorld(fis, item, Equipment, new Point(fis.standbyPos.x, fis.standbyPos.y));
				//fis.SwimTo(fis.standbyPos.x, fis.standbyPos.y, 10);
				fis.DesPos.x = fis.standbyPos.x - 5;
				fis.flipX(1);
				fis.SetMovingState(Fish.FS_STANDBY);
				arrMonster.push(fis);
				fis.SetEmotion(Fish.IDLE);
			}
		}
		
		/**
		 * Khởi tạo con cá trong bể
		 * @param	fis
		 * @param	item
		 * @return
		 */
		public function InitParamForFishSoldierInWorld(fis:FishSoldier, item:Object, Equipment:Object, Pos:Point):FishSoldier
		{
			fis.SoldierType = FishSoldier.SOLDIER_TYPE_MIX;
			fis.FishType = Fish.FISHTYPE_SOLDIER;
			fis.Rank = item.Rank;
			fis.FishTypeId = item.FishTypeId;
			fis.Damage = item.Damage;
			fis.Defence = item.Defence;
			fis.Element = item.Element;
			fis.Vitality = item.Vitality;
			fis.Critical = item.Critical;
			fis.Health = item.Health;
			if (item.IsBoss != null)	fis.isSubBoss = false;
			else fis.isSubBoss = true;
			fis.RecipeType = item.RecipeType;
			fis.Id = item.Id;
			fis.Sex = -1;
			fis.isActor = FishSoldier.ACTOR_NONE;
			fis.Status = FishSoldier.STATUS_HEALTHY;
			fis.SetSoldierInfo();
			fis.Init(Pos.x, Pos.y);		
			
			fis.LakeId = 1;
			fis.SetEquipmentInfo(Equipment);
			fis.UpdateCombatSkill();
			fis.SetAgeState(Fish.OLD);
			fis.isChoose = true;
			return fis;
		}
	}

}