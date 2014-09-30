package GUI.FishWorld.ForestWorld 
{
	import com.greensock.easing.Quint;
	import com.greensock.TweenMax;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.Network.AttackBossForest;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIInfoForestWorld extends BaseGUI 
	{
		public const BTN_CLOSE:String = "BtnClose";
		
		public const CTN_RESULT:String = "CtnResult";
		public const CTN_UP_IMG:String = "CtnUpImg";
		public const CTN_DOWN_IMG:String = "CtnDownImg";
		public const CTN_RIGHT_IMG:String = "CtnRightImg";
		public const CTN_CENTER_IMG:String = "CtnCenterImg";
		
		public const IMG_PEICE_CENTER:String = "LoadingForestWorld_ImgForestWorld0";
		public const IMG_PEICE_UP_RED:String = "LoadingForestWorld_ImgForestWorld1";
		public const IMG_PEICE_DOWN_PEICE:String = "LoadingForestWorld_ImgForestWorld3";
		public const IMG_PEICE_RIGHT_GREEN:String = "LoadingForestWorld_ImgForestWorld2";
		
		public var ctnUpImg:Container;
		public var ctnDownImg:Container;
		public var ctnRightImg:Container;
		public var ctnCenterImg:Container;
		
		public var ctnResultImg:Container;
		public var objResult:Object = new Object();
		
		public var isFlying:Boolean = false;
		public var isEff:Boolean = false;
		
		private var arrIsRotation:Array = [];
		private var arrButtonIDProcess:Array = [];
		public var arrSpProcess:Array = [];
		private var arrDeltaRotation:Array = [];
		
		//private var isRotation:Boolean = false;
		//private var buttonIDProcess:String = "";
		//private var spProcess:Sprite = null;
		//private var deltaRotation:Number = 0;
		
		public function GUIInfoForestWorld(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "InfoForestWorld";
		}
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("LoadingForestWorld_ImgGUIStatusForestWorld");
			SetPos(120, 80);
			arrSpProcess.splice(0, arrSpProcess.length);
			arrDeltaRotation.splice(0, arrDeltaRotation.length);
			arrIsRotation.splice(0, arrIsRotation.length);
			arrButtonIDProcess.splice(0, arrButtonIDProcess.length);
			OpenRoomOut();
		}
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			AddButton(BTN_CLOSE, "BtnThoat", 510, 20);
			isFlying = false;
			isEff = false;
			objResult = new Object();
			ctnResultImg = AddContainer(CTN_RESULT, "LoadingForestWorld_ImgForestWorld", 198, 127);
			
			ctnResultImg.AddImage(IMG_PEICE_CENTER, "LoadingForestWorld_ImgForestWorld0", 48, 54, true, ALIGN_LEFT_TOP);	
			objResult[IMG_PEICE_CENTER] = false;
			Ultility.SetEnableSprite(ctnResultImg.GetImage(IMG_PEICE_CENTER).img, false);
			ctnResultImg.AddImage(IMG_PEICE_UP_RED, "LoadingForestWorld_ImgForestWorld1", 18, 36, true, ALIGN_LEFT_TOP);	
			objResult[IMG_PEICE_UP_RED] = false;
			Ultility.SetEnableSprite(ctnResultImg.GetImage(IMG_PEICE_UP_RED).img, false);
			//ctnResultImg.AddImage(IMG_PEICE_RIGHT_GREEN, "LoadingForestWorld_ImgForestWorld2", 48, 19, true, ALIGN_LEFT_TOP);	
			ctnResultImg.AddImage(IMG_PEICE_RIGHT_GREEN, "LoadingForestWorld_ImgForestWorld2", 60,63, true, ALIGN_LEFT_TOP);
			objResult[IMG_PEICE_RIGHT_GREEN] = false;
			Ultility.SetEnableSprite(ctnResultImg.GetImage(IMG_PEICE_RIGHT_GREEN).img, false);
			ctnResultImg.AddImage(IMG_PEICE_DOWN_PEICE, "LoadingForestWorld_ImgForestWorld3", 48, 19, true, ALIGN_LEFT_TOP);
			objResult[IMG_PEICE_DOWN_PEICE] = false;
			Ultility.SetEnableSprite(ctnResultImg.GetImage(IMG_PEICE_DOWN_PEICE).img, false);
			
			ctnCenterImg = AddContainer(IMG_PEICE_CENTER, "LoadingForestWorld_ImgForestWorld0", 98, 390, true, this);	
			ctnUpImg = AddContainer(IMG_PEICE_UP_RED, "LoadingForestWorld_ImgForestWorld1", 183, 367, true, this);	
			ctnRightImg = AddContainer(IMG_PEICE_RIGHT_GREEN, "LoadingForestWorld_ImgForestWorld2", 384, 376, true, this);
			ctnDownImg = AddContainer(IMG_PEICE_DOWN_PEICE, "LoadingForestWorld_ImgForestWorld3", 275, 391, true, this);
			
			ctnUpImg.SetVisible(false);
			ctnRightImg.SetVisible(false);
			ctnDownImg.SetVisible(false);
			
			if(GuiMgr.getInstance().GuiMainForest.arrMonsterUpRedData == null || GuiMgr.getInstance().GuiMainForest.arrMonsterUpRedData.length <= 0)
			{
				//Ultility.SetEnableSprite(ctnUpImg.img, true, 0.15);
				ctnUpImg.SetVisible(true);
			}
			if(GuiMgr.getInstance().GuiMainForest.MonsterRightGreenData == null)
			{
				//Ultility.SetEnableSprite(ctnRightImg.img, true, 0.15);
				ctnRightImg.SetVisible(true);
			}
			
			if(GuiMgr.getInstance().GuiMainForest.arrMonsterDownYellowData == null || GuiMgr.getInstance().GuiMainForest.arrMonsterDownYellowData.length <= 0)
			{
				//Ultility.SetEnableSprite(ctnDownImg.img, true, 0.15);
				ctnDownImg.SetVisible(true);
			}
			
			var tf1:TextField;
			var tf2:TextField;
			var txtFormat:TextFormat = new TextFormat();
			
			txtFormat.italic = true;
			txtFormat.size = 14;
			var strWarning:String;
			if (ctnRightImg.img.visible && ctnUpImg.img.visible && ctnDownImg.img.visible)
			{
				strWarning = Localization.getInstance().getString("TooltipFishWorld4");
			}
			else
			{
				strWarning = Localization.getInstance().getString("TooltipFishWorld3");
			}
			AddLabel(strWarning, 220, 470, 0xCC0000, 1, 0xFFFF00).setTextFormat(txtFormat);
			
			txtFormat = new TextFormat();
			txtFormat.size = 18;
			txtFormat.bold = true;
			//tf1 = AddLabel(Localization.getInstance().getString("Tooltip" + (42 + Math.round(Math.random() * 9))), 90, 90, 0xffffff, 1, 0x26709C);
			//tf1.setTextFormat(txtFormat);
			//tf1.wordWrap = true;
			//tf1.width = 60;
			//tf2 = AddLabel(Localization.getInstance().getString("Tooltip" + (42 + Math.round(Math.random() * 9))), 415, 90, 0xffffff, 1, 0x26709C);
			//tf2.setTextFormat(txtFormat);
			//tf2.wordWrap = true;
			//tf2.width = 60;
			
			DoEffChoosePiece1(IMG_PEICE_CENTER);
		}
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonMove(event, buttonID);
			switch (buttonID) 
			{
				case IMG_PEICE_CENTER:
				case IMG_PEICE_DOWN_PEICE:
				case IMG_PEICE_RIGHT_GREEN:
				case IMG_PEICE_UP_RED:
					GetContainer(buttonID).SetHighLight();
				break;
			}
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonMove(event, buttonID);
			switch (buttonID) 
			{
				case IMG_PEICE_CENTER:
				case IMG_PEICE_DOWN_PEICE:
				case IMG_PEICE_RIGHT_GREEN:
				case IMG_PEICE_UP_RED:
					GetContainer(buttonID).SetHighLight(-1);
				break;
			}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			//if (isFlying) 
			//{
				//return;
			//}
			switch (buttonID) 
			{
				case BTN_CLOSE:
					if (isEff)	return;
					Hide();
					break;
				case IMG_PEICE_CENTER:
				case IMG_PEICE_DOWN_PEICE:
				case IMG_PEICE_RIGHT_GREEN:
				case IMG_PEICE_UP_RED:
					DoEffChoosePiece1(buttonID);
					break;
			}
		}
		public function DoEffChoosePiece1(buttonID:String):void 
		{
			arrIsRotation.push(true);
			isFlying = true;
			isEff = true;
			//GuiMgr.getInstance().GuiMainForest.InitBackground(Constant.ID_FISH_WORLD_BACKGROUND_4_ROUND_4);
			var spProcess:Sprite = Ultility.CloneImage(GetContainer(buttonID).img);
			arrSpProcess.push(spProcess);
			arrDeltaRotation.push(spProcess.rotation / 5);
			img.addChild(spProcess);
			GetContainer(buttonID).img.visible = false;
			arrButtonIDProcess.push(buttonID);
		}
		public function DoEffChoosePiece2(index:int):void 
		{
			if (!IsVisible)	return;
			var spProcess:Sprite = arrSpProcess[index];
			var buttonIDProcess:String = arrButtonIDProcess[index];
			var ps:Point, pm:Point, pe:Point;
			ps = new Point(spProcess.x, spProcess.y);
			pe = img.globalToLocal(ctnResultImg.img.localToGlobal(ctnResultImg.GetImage(buttonIDProcess).CurPos));
			pm = new Point();
			pm.y = (pe.y + ps.y) / 2;
			pm.x = (pe.x + ps.x) / 2 + ( -50 + Math.random() * 100);
			isFlying = true;
			TweenMax.to(spProcess, 1, { bezierThrough:[ { x:(pm.x ), y:(pm.y) } , { x:(pe.x ), y:(pe.y) } ], ease:Quint.easeOut, 
					onComplete:onCompletePieceEff, onCompleteParams:[index] } );	
		}
		private function onCompletePieceEff(index:int):void 
		{
			if (!IsVisible)	return;
			var spProcess:Sprite = arrSpProcess[index];
			var buttonIDProcess:String = arrButtonIDProcess[index];
			if(spProcess)
			{
				spProcess.parent.removeChild(spProcess);
				spProcess = null;
				arrSpProcess[index] = null;
				Ultility.SetEnableSprite(ctnResultImg.GetImage(buttonIDProcess).img);
				PlayEffectPiece(index);
			}
			else
			{
				arrButtonIDProcess[index] = "";
				arrSpProcess.splice[index] = null;
				arrDeltaRotation[index] = 0;
				arrIsRotation.splice[index] = false;
				
				if (CheckFinishEff())
				{
					isEff = false;
				}
			}
			// Play eff khi bay len den noi
		}
		private function CheckFinishEff():Boolean
		{
			for (var i:int = 0; i < arrSpProcess.length; i++) 
			{
				var item:String = arrButtonIDProcess[i];
				if (item != "")
					return false;
			}
			return true;
		}
		private function PlayEffectPiece(index:int):void 
		{
			//if (buttonIDProcess.search("LoadingForestWorld_ImgForestWorld0") >= 0)
			//{
				//objResult[buttonIDProcess] = true;
				//buttonIDProcess = "";
				//isFlying = false;
				//return;
			//}
			if (!IsVisible)	return;
			var buttonIDProcess:String = arrButtonIDProcess[index];
			
			var idSeaRound:int = buttonIDProcess.split("LoadingForestWorld_ImgForestWorld")[1];
			var pos:Point = img.globalToLocal(ctnResultImg.img.localToGlobal(ctnResultImg.GetImage(buttonIDProcess).CurPos));
			switch (idSeaRound) 
			{
				case 0:
					pos.x = pos.x +  144;
					pos.y = pos.y +  99;
				break;
				case 1:
					pos.x = pos.x +  143;
					pos.y = pos.y +  114;
				break;
				case 3:
					pos.x = pos.x +  158;
					pos.y = pos.y +  99;
				break;
				case 2:
					pos.x = pos.x +  160;
					pos.y = pos.y +  119;
				break;
			}
			var arr:Array = [buttonIDProcess];
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "LoadingForestWorld_EffHighLight" + 
				idSeaRound, null, pos.x, pos.y, false, false, null, function():void { CheckRotation(index) } );
		}
		private function CheckRotation(index:int):void 
		{
			if (!IsVisible)
			{
				arrIsRotation.splice(index, 1);
				arrButtonIDProcess.splice(index, 1);
				arrDeltaRotation.splice(index, 1);
				arrSpProcess.splice(index, 1);
				
				return;
			}
			var buttonIDProcess:String = arrButtonIDProcess[index];
			
			objResult[buttonIDProcess] = true;
			arrButtonIDProcess[index] = "";
			
			for (var i:String in objResult) 
			{
				if (objResult[i] == false)
				{
					isFlying = false;
					if(CheckFinishEff())
					{
						isEff = false;
					}
					return;
				}
			}
			
			arrIsRotation.splice(index, 1);
			arrButtonIDProcess.splice(index, 1);
			arrDeltaRotation.splice(index, 1);
			arrSpProcess.splice(index, 1);
			
			if(ctnResultImg.img)
			{
				var pos:Point = ctnResultImg.GetPosition();
				ctnResultImg.img.visible = false;
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "LoadingForestWorld_EffOpenGate", null, 
					pos.x + 184, pos.y + 162, false, false, null, DoGoRound4Forest);
			}
			else 
			{
				if(CheckFinishEff())
				{
					isEff = false;
				}
			}
		}
		private function DoGoRound4Forest():void 
		{
			
			if(CheckFinishEff())
			{
				isEff = false;
			}
			
			GuiMgr.getInstance().GuiMainForest.InitBackground(Constant.ID_FISH_WORLD_BACKGROUND_4_ROUND_4);
			FishWorldController.SetRound(Constant.SEA_ROUND_4);
			
			var obj:Object = new Object();
			obj["IdMonster"] = GuiMgr.getInstance().GuiMainForest.MonsterGiftData.Id;
			obj["SeaId"] = FishWorldController.GetSeaId();
			Exchange.GetInstance().Send(new AttackBossForest(obj));
			
			if(IsVisible)	Hide();
			if( GuiMgr.getInstance().GuiMainForest.IsVisible)	GuiMgr.getInstance().GuiMainForest.Hide()
			var arrMonster:Array = GuiMgr.getInstance().GuiMainForest.arrMonsterGift;
			arrMonster.splice(0, arrMonster.length);
			GuiMgr.getInstance().GuiMainForest.TypeSwim = Constant.SEA_ROUND_4;
			GuiMgr.getInstance().GuiBackMainForest.init(Constant.SEA_ROUND_4);
			// Tính các tọa độ cá nhà bạn bơi ra
			var pos:Point = new Point(Constant.MAX_WIDTH / 2 - 100, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD / 2 + 35);
			
			var item:Object = GuiMgr.getInstance().GuiMainForest.MonsterGiftData;
			var imgName:String = "ForestWorldBossGetGift";
			var fis:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), imgName);	
			fis.standbyPos = pos;
			fis.Id = item.Id;
			// Khởi tạo Equip
			var objEquip:Object = item.Equipment as Object;
			var Equipment:Object = GameLogic.getInstance().user.InitEquipmentForFishSoldierInWorld(objEquip);
			// Khởi tạo Quartz
			var objQuartz:Object = item.Quartz as Object;
			var Quartz:Object = GameLogic.getInstance().user.InitQuartzForFishSoldierInWorld(objQuartz);
			// Khởi tạo các tham số cho con con boss
			fis = InitParamForFishSoldierInWorld(fis, item, Equipment, new Point(fis.standbyPos.x + 150, fis.standbyPos.y));
			arrMonster.push(fis);
			fis.OnLoadResCompleteFunction = function ():void 
			{
				(this as FishSoldier).SetEmotion(FishSoldier.WAR);
				(this as FishSoldier).SetMovingState(Fish.FS_IDLE);
			}
			GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_TO_GET_GIFT);
			(GuiMgr.getInstance().GuiMainForest.arrMonsterGift[0] as FishSoldier).SetEmotion(Fish.IDLE);
			// Hiển thị thanh progress bar
			
			// Các con cá lính nhà mình bơi ra
			var arr_:Array = GameLogic.getInstance().user.FishSoldierActorMine;
			for (var iForFishWorld:int = 0; iForFishWorld < arr_.length; iForFishWorld++) 
			{
				var itemFishMine:FishSoldier = arr_[iForFishWorld];
				itemFishMine.SwimTo(itemFishMine.standbyPos.x, itemFishMine.standbyPos.y, 10);
			}
			itemFishMine.isChoose = true;
			GameLogic.getInstance().user.CurSoldier[0] = itemFishMine;
			isFlying = false;
			
			if (GuiMgr.getInstance().GuiMainFishWorld.IsVisible) 
			{
				GuiMgr.getInstance().GuiMainFishWorld.ClearStoreComponent();
				GuiMgr.getInstance().GuiMainFishWorld.InitStore(GuiMgr.getInstance().GuiMainFishWorld.CurrentStore, 0);
			}
		}
		
		public function UpdateAllFishCanGetGift():void 
		{
			var arr_:Array = GameLogic.getInstance().user.FishSoldierActorMine;
			var obj:Object = GuiMgr.getInstance().GuiBackMainForest.objSceneAll;
			trace("arr_.length = ",arr_.length);
			for (var j:int = 0; j < arr_.length; j++) 
			{
				var fs:FishSoldier = arr_[j];
				var isHaveGift:Boolean = false;
				for (var i:String in obj) 
				{
					var i_int:int = int(i);
					if (fs.Id == i_int)
					{
						isHaveGift = true;
						break;
					}
				}
				if (!isHaveGift)
				{
					fs.Destructor();
					arr_.splice(j, 1);
				}
			}
			trace("arr_.length = ",arr_.length);
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
		
		public function Update():void 
		{
			for (var i:int = 0; i < arrIsRotation.length; i++) 
			{
				if(arrIsRotation[i])
				{
					var spProcess:Sprite = arrSpProcess[i];
					if (spProcess != null && Math.abs(spProcess.rotation) > 0.1)
					{
						spProcess.rotation = spProcess.rotation - arrDeltaRotation[i];
					}
					else if(Math.abs(spProcess.rotation) < 0.1)
					{
						arrIsRotation[i] = false;
						arrDeltaRotation[i] = 0;
						DoEffChoosePiece2(i);
					}	
				}
			}
		}
	}

}