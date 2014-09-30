package GUI.FishWorld.ForestWorld 
{
	import adobe.utils.CustomActions;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import Crypto.MonkeyTab;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import GUI.component.BaseGUI;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.Network.SendChooseRoundAttack;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameState;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIMainForest extends BaseGUI 
	{
		public const BTN_MAIN:String = "BtnMain";
		public const BTN_UP_GO_TO_PIECE_RED:String = "BtnGoToPieceRed";
		public const BTN_DOWN_GO_TO_PIECE_GREEN:String = "BtnGoToPieceYellow";
		public const BTN_RIGHT_GO_TO_PIECE_YELLOW:String = "BtnGoToPieceGreen";
		public const TYPE_SWIM_UP:int = 1;
		public const TYPE_SWIM_RIGHT:int = 2;
		public const TYPE_SWIM_DOWN:int = 3;
		public const TYPE_SWIM_GET_GIFT:int = 4;
		public var RoundId:int = 0;
		public var TypeSwim:int = -1;
		// Các mảng chứa dữ liệu các con quái trong thế giới
		public var arrMonsterUpRedData:Array = [];
		public var arrMonsterDownYellowData:Array = [];
		public var MonsterRightGreenData:Object;
		public var MonsterGiftData:Object;
		
		
		public var arrThicketUpRed:Array = [];
		public var arrThicketUpRedInPosition:Array = [];
		public var arrMonsterUpRed:Array = [];
		public var arrMonsterDownGreen:Array = [];
		public var arrMonsterRightGreen:Array = [];
		public var arrMonsterGift:Array = [];
		
		
		//public var MonsterRightGreen:FishSoldier;
		//public var MonsterRightGreenData:Object;
		
		public function GUIMainForest(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIMainForest";
		}
		
		override public function InitGUI():void 
		{
			var so:SharedObject = SharedObject.getLocal("GUIMainForest_" + GameLogic.getInstance().user.GetMyInfo().Id);
			//super.InitGUI();
			this.setImgInfo = function():void
			{
				SetPos(278, 141);
				SyncWithServer();
				AddButton(BTN_UP_GO_TO_PIECE_RED, "LoadingForestWorld_BtnForestWorldUp", 470, 243);
				GetButton(BTN_UP_GO_TO_PIECE_RED).setTooltipText(Localization.getInstance().getString("TooltipFishWorld5"));
				AddButton(BTN_RIGHT_GO_TO_PIECE_YELLOW, "LoadingForestWorld_BtnForestWorldDown", 186, 84);
				GetButton(BTN_RIGHT_GO_TO_PIECE_YELLOW).setTooltipText(Localization.getInstance().getString("TooltipFishWorld6"));
				AddButton(BTN_DOWN_GO_TO_PIECE_GREEN, "LoadingForestWorld_BtnForestWorldRight", 225, 297);
				GetButton(BTN_DOWN_GO_TO_PIECE_GREEN).setTooltipText(Localization.getInstance().getString("TooltipFishWorld7"));
				//if (arrMonsterRightGreenData.length <= 0)	
				
				if (so.data.isGoneForest == null || so.data.isGoneForest == false)
				{
					GetButton(BTN_UP_GO_TO_PIECE_RED).SetVisible(false);
					GetButton(BTN_RIGHT_GO_TO_PIECE_YELLOW).SetVisible(false);
					GetButton(BTN_DOWN_GO_TO_PIECE_GREEN).SetVisible(false);
					so.data.isGoneForest = true
				}
				
				if (arrMonsterUpRedData.length <= 0)	
					GetButton(BTN_UP_GO_TO_PIECE_RED).SetVisible(false);
				if (arrMonsterDownYellowData.length <= 0)	
					GetButton(BTN_DOWN_GO_TO_PIECE_GREEN).SetVisible(false);
				if (MonsterRightGreenData == null)	
					GetButton(BTN_RIGHT_GO_TO_PIECE_YELLOW).SetVisible(false);
					
				AddButton(BTN_MAIN, "LoadingForestWorld_BtnForestWorldMain", 585, 29);
				GetButton(BTN_MAIN).setTooltipText(Localization.getInstance().getString("TooltipFishWorld8"));
			}
			
			isClickGotoSea = false;
			LoadRes("LoadingForestWorld_ImgFrameFriend");
		}
		
		public var isClickGotoSea:Boolean = false;
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			if (isClickGotoSea)	return;
			isClickGotoSea = true;
			if (GameLogic.getInstance().user.FishSoldierActorMine.length <= 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWorld(Localization.getInstance().getString("FishWarMsg33"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			var gameState:int = GameLogic.getInstance().gameState;
			switch (buttonID) 
			{
				case BTN_MAIN:
					doShowInfoForestWorld();
				break;
				case BTN_UP_GO_TO_PIECE_RED:
					Exchange.GetInstance().Send(new SendChooseRoundAttack(1, 4));
					RoundId = 1;
					doGoUpTheRedForestWorld();
				break;
				case BTN_DOWN_GO_TO_PIECE_GREEN:
					Exchange.GetInstance().Send(new SendChooseRoundAttack(3, 4));
					RoundId = 3;
					doGoDownTheYellowForestWorld();
				break;
				case BTN_RIGHT_GO_TO_PIECE_YELLOW:
					Exchange.GetInstance().Send(new SendChooseRoundAttack(2, 4));
					RoundId = 2;
					doGoRightTheGreenForestWorld();
				break;
			}
		}
		
		public function InitBackground(ItemId:int):void 
		{
			var object:Object = new Object();
			object.ExpiredTime = int.MAX_VALUE;
			object.Id = int.MAX_VALUE;
			object.ItemId = ItemId;
			object.X = 0;
			object.Y = 0;
			object.Z = 0;
			GameLogic.getInstance().user.initBackGround(object);
		}
		public function doGoUpTheRedForestWorld():void 
		{
			FishWorldController.SetRound(Constant.SEA_ROUND_1);
			TypeSwim = TYPE_SWIM_UP;
			var arrFishSoldier:Array = [];
			GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_1);
			arrFishSoldier = GameLogic.getInstance().user.FishSoldierActorMine;
			var fs:FishSoldier;
			for (var i:int = 0; i < arrFishSoldier.length; i++)
			{
				fs = arrFishSoldier[i] as FishSoldier;
				fs.SwimTo(fs.standbyPos.x + 230, fs.standbyPos.y, 10);
				fs.isChoose = false;
			}
			fs.isChoose = true;
			GameLogic.getInstance().user.CurSoldier[0] = fs;
			//GameLogic.getInstance().user.FishSoldierMine = fs;
		}
		public function doGoDownTheYellowForestWorld():void 
		{
			FishWorldController.SetRound(Constant.SEA_ROUND_3);
			TypeSwim = TYPE_SWIM_DOWN;
			var arrFishSoldier:Array = [];
			GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_1);
			arrFishSoldier = GameLogic.getInstance().user.FishSoldierActorMine;
			var fs:FishSoldier;
			for (var i:int = 0; i < arrFishSoldier.length; i++) 
			{
				fs = arrFishSoldier[i] as FishSoldier;
				fs.SwimTo(fs.standbyPos.x + 230, fs.standbyPos.y, 10);
				fs.isChoose = false;
			}
			fs.isChoose = true;
			GameLogic.getInstance().user.CurSoldier[0] = fs;
			GameLogic.getInstance().user.FishSoldierMine = fs;
		}
		public function doGoRightTheGreenForestWorld():void 
		{
			FishWorldController.SetRound(Constant.SEA_ROUND_2);
			TypeSwim = TYPE_SWIM_RIGHT;
			var arrFishSoldier:Array = [];
			GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_SWIM_1);
			arrFishSoldier = GameLogic.getInstance().user.FishSoldierActorMine;
			var fs:FishSoldier;
			for (var i:int = 0; i < arrFishSoldier.length; i++) 
			{
				fs = arrFishSoldier[i] as FishSoldier;
				fs.SwimTo(fs.standbyPos.x + 230, fs.standbyPos.y, 10);
				fs.isChoose = false;
			}
			fs.isChoose = true;
			GameLogic.getInstance().user.CurSoldier[0] = fs;
			GameLogic.getInstance().user.FishSoldierMine = fs;
		}
		public function processChooseFishWar():void
		{
			if (GameLogic.getInstance().user.FishSoldierActorMine.length == 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowGuideFishWar(Localization.getInstance().getString("FishWarMsg13"));
				return;
			}
			
			var mySoldier:FishSoldier = GameLogic.getInstance().user.CurSoldier[0];
			var theirSoldier:FishSoldier = GameLogic.getInstance().user.CurSoldier[1];
			
			if (!mySoldier)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg25"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			
			// Nếu ko đủ tiền thì cũng ko cho đánh					
			var theirFList:Array = GameLogic.getInstance().user.GetFishArr();
			var energyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillMonster");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillMonster"];
			
			if (energyCost > GameLogic.getInstance().user.GetEnergy())
			{
				GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 1);
				return;
			}
			
			if (mySoldier.Health < Constant.MIN_HEALTH_SOLDIER)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg9"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				GameLogic.getInstance().user.CurSoldier[0] = null;
				return;
			}
			
			if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)	
			{
				GuiMgr.getInstance().GuiInfoWarInWorld.ShowDisableScreen(0.01);
			}
			
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.Hide();
			}
			
			GuiMgr.getInstance().GuiFishWarForest.Init(mySoldier, theirSoldier);
			
			SetEmotionIdleAll();
		}
		
		public function SetEmotionIdleAll(isIdle:Boolean = true):void 
		{
			var i:int = 0;
			var mon:FishSoldier;
			var arrMonster:Array = [];
			var curRound:int = FishWorldController.GetRound();
			switch (curRound) 
			{
				case Constant.SEA_ROUND_1:
					arrMonster = arrThicketUpRed;
				break;
				case Constant.SEA_ROUND_2:
					arrMonster = arrMonsterRightGreen;
				break;
				case Constant.SEA_ROUND_3:
					arrMonster = arrMonsterDownGreen;
				break;
				case Constant.SEA_ROUND_4:
					arrMonster = arrMonsterGift;
				break;
			}
			for (i = 0; i < arrMonster.length; i++) 
			{
				mon = arrMonster[i];
				if(isIdle)
				{
					mon.SetEmotion(Fish.IDLE);
				}
				else
				{
					if (curRound == Constant.SEA_ROUND_3)
					{
						if (i == arrMonster.length - 1)
						{
							if (arrMonster.length == 1)
							{
								mon.SetEmotion(FishSoldier.WAR);
							}
							else
							{
								mon.SetEmotion(Fish.IDLE);
							}
						}
						else
						{
							mon.SetEmotion(FishSoldier.WAR);
						}
					}
					else 
					{
						mon.SetEmotion(FishSoldier.WAR);
					}
				}
			}
		}
		
		public function doShowInfoForestWorld():void 
		{
			isClickGotoSea = false;
			GetButton(BTN_UP_GO_TO_PIECE_RED).SetVisible(true);
			GetButton(BTN_RIGHT_GO_TO_PIECE_YELLOW).SetVisible(true);
			GetButton(BTN_DOWN_GO_TO_PIECE_GREEN).SetVisible(true);
			
			if (arrMonsterUpRedData.length <= 0)	
				GetButton(BTN_UP_GO_TO_PIECE_RED).SetVisible(false);
			if (arrMonsterDownYellowData.length <= 0)	
				GetButton(BTN_DOWN_GO_TO_PIECE_GREEN).SetVisible(false);
			if (MonsterRightGreenData == null)	
				GetButton(BTN_RIGHT_GO_TO_PIECE_YELLOW).SetVisible(false);
			
			GuiMgr.getInstance().GuiInfoForestWorld.Show(Constant.GUI_MIN_LAYER, 4);
		}
		public var countSwap:int = 0;
		/**
		 * Hàm thực hiện chuyển chỗ 2 bụi cây cho nhau
		 * @param	thicket1
		 * @param	thicket2
		 */
		public var objSequenceRedUp:Object;
		public var objSequenceGreenDown:Object;
		public var objEffYellowRight:Object;
		public var objHideGreenDown:Object;
		public function Swap(thicket1:Thicket, thicket2:Thicket):void 
		{
			countSwap++;
			if (thicket1 == null || thicket2 == null)	return;
			var stanbyPos1:Point = thicket1.standbyPos;
			var stanbyPos2:Point = thicket2.standbyPos;
			var midPos1:Point = new Point();
			midPos1.y = (stanbyPos1.y + stanbyPos2.y) / 2;
			midPos1.x = stanbyPos1.x + (stanbyPos1.y - stanbyPos2.y) / 2;
			var midPos2:Point = new Point();
			midPos2.y = (stanbyPos1.y + stanbyPos2.y) / 2;
			midPos2.x = stanbyPos2.x + (stanbyPos2.y - stanbyPos1.y) / 2;
			TweenMax.to(thicket1.img, 0.5, { bezier:[ { x:midPos1.x, y:midPos1.y }, { x:stanbyPos2.x, y:stanbyPos2.y } ], ease:Sine.easeIn } );
			TweenMax.to(thicket2.img, 0.5, { bezier:[ { x:midPos2.x, y:midPos2.y }, { x:stanbyPos1.x, y:stanbyPos1.y } ], ease:Sine.easeIn, 
						onComplete:onCompleteSwap, onCompleteParams:[thicket1, thicket2] } );
		}
		public function onCompleteSwap(thicket1:Thicket, thicket2:Thicket):void 
		{
			var stanbyPos2:Point = thicket1.standbyPos;
			var stanbyPos1:Point = thicket2.standbyPos;
			thicket1.SetPos(stanbyPos1.x, stanbyPos1.y);
			thicket2.SetPos(stanbyPos2.x, stanbyPos2.y);
			thicket1.standbyPos = stanbyPos1;
			thicket2.standbyPos = stanbyPos2;
			thicket1.fishSoldier.SetPos(stanbyPos1.x, stanbyPos1.y);
			thicket2.fishSoldier.SetPos(stanbyPos2.x, stanbyPos2.y);
			thicket1.fishSoldier.standbyPos = stanbyPos1;
			thicket2.fishSoldier.standbyPos = stanbyPos2;
			var index1:int = arrThicketUpRedInPosition.indexOf(thicket1);
			var index2:int = arrThicketUpRedInPosition.indexOf(thicket2);
			var arrNew:Array = [];
			for (var i:int = 0; i < arrThicketUpRedInPosition.length; i++) 
			{
				if (i == index1)
				{
					arrNew.push(arrThicketUpRedInPosition[index2]);
				}
				else if (i == index2)
				{
					arrNew.push(arrThicketUpRedInPosition[index1]);
				}
				else
				{
					arrNew.push(arrThicketUpRedInPosition[i]);
				}
			}
			arrThicketUpRedInPosition.splice(0, arrThicketUpRedInPosition.length);
			arrThicketUpRedInPosition = arrNew;
			var thicket3:Thicket;
			var thicket4:Thicket;
			var arrIndex:Array = [];
			for (var j:int = 0; j < arrThicketUpRedInPosition.length; j++) 
			{
				arrIndex.push(j);
			}
			var index3:int = Math.floor(Math.random() * arrIndex.length);
			thicket3 = arrThicketUpRedInPosition[arrIndex[index3]];
			arrIndex.splice(index3, 1);
			var index4:int = Math.floor(Math.random() * arrIndex.length);
			thicket4 = arrThicketUpRedInPosition[arrIndex[index4]];
			arrIndex.splice(0, arrIndex.length);
			if (countSwap < 12)
			{
				Swap(thicket3, thicket4);
			}
			else if(checkFinishSwap())
			{
				var k:int = 0;
				for (k = 0; k < GuiMgr.getInstance().GuiMainForest.arrThicketUpRed.length; k++) 
				{
					var thicket1:Thicket = arrThicketUpRedInPosition[k];
					thicket1.SetEmotion(FishSoldier.WAR);
					countSwap = 0;
				}
				GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WAIT_USER_CREATE_WAR);
				SetEmotionIdleAll(false);
				for (k = 0; k < GameLogic.getInstance().user.FishSoldierActorMine.length; k++) 
				{
					(GameLogic.getInstance().user.FishSoldierActorMine[k] as FishSoldier).SetMovingState(Fish.FS_STANDBY);
				}
			}
			else
			{
				Swap(thicket3, thicket4);
			} 
		}
		
		public function checkFinishSwap():Boolean
		{
			for (var i:int = 0; i < arrThicketUpRed.length; i++) 
			{
				var item:Thicket = arrThicketUpRed[i];
				var index:int = (arrThicketUpRedInPosition.indexOf(item) + 1);
				if (index != int(objSequenceRedUp[String(i + 1)]))
				{
					return false;
				}
			}
			return true;
		}
		
		public const MAX_MONSTER_RED_UP:int = 3;
		public const MAX_MONSTER_YELLOW_DOWN:int = 6;
		public const MAX_MONSTER_GREEN_RIGHT:int = 4;
		public function SyncWithServer():void 
		{
			var obj1:Object = GuiMgr.getInstance().GuiMapOcean.arrListOcean[3];
			var objMonster:Object = obj1.Monster;
			if (objMonster is Array && objMonster.length == 0 || objMonster == null)	return;
			var objMonsterRedUp:Object = objMonster["1"];
			countSwap++;
			// 3 con cá ở vùng biển đỏ
			var i:int = 0;
			arrMonsterUpRedData.splice(0, arrMonsterUpRedData.length);
			for (i = 1; i <= MAX_MONSTER_RED_UP; i++) 
			{
				if (!CheckHaveItem(objMonster[TYPE_SWIM_UP.toString()]))
				{
					break;
				}
				if(objMonster[TYPE_SWIM_UP.toString()]!= null && objMonster[TYPE_SWIM_UP.toString()][i.toString()] != null)
					arrMonsterUpRedData.push(objMonster[TYPE_SWIM_UP.toString()][i.toString()]);
			}
			
			arrMonsterDownYellowData.splice(0, arrMonsterDownYellowData.length);
			for (i = 1; i <= MAX_MONSTER_YELLOW_DOWN; i++) 
			{
				if (!CheckHaveItem(objMonster[TYPE_SWIM_DOWN.toString()]))
				{
					break;
				}
				if(objMonster[TYPE_SWIM_DOWN.toString()][i.toString()] != null)
				{
					arrMonsterDownYellowData.push(objMonster[TYPE_SWIM_DOWN.toString()][i.toString()]);
				}
			}
			
			MonsterRightGreenData = obj1.currentMonster;
			
			MonsterGiftData = objMonster[Constant.SEA_ROUND_4.toString()]["1"];
			
			GuiMgr.getInstance().GuiMainFishWorld.Show(Constant.GUI_MIN_LAYER, 0);
			//if(GuiMgr.getInstance().GuiMainFishWorld.IsVisible)
			//{
				//GuiMgr.getInstance().GuiMainFishWorld.ClearStoreComponent();
				//GuiMgr.getInstance().GuiMainFishWorld.InitStore(GuiMgr.getInstance().GuiMainFishWorld.CurrentStore, 
							//GuiMgr.getInstance().GuiMainFishWorld.CurrentPage);
			//}
		}
		
		private function CheckHaveItem(obj:Object):Boolean
		{
			for (var si:String in obj) 
			{
				if (obj[si] != null)	return	true;
			}
			return false;
		}
		
		public function GenMonster(id:int, position:int):Object
		{
			var objReturn:Object = new Object();
			objReturn.Critical = Math.round(Math.random() * 2000 + 500);
			objReturn.Damage = Math.round(Math.random() * 2000 + 2000);
			objReturn.Defence = Math.round(Math.random() * 2000 + 2000);
			objReturn.Vitality = Math.round(Math.random() * 4000 + 4000);
			objReturn.Element = Math.floor(Math.random() * 4 + 1);
			objReturn.Equipment = new Array();
			objReturn.FishTypeId = (objReturn.Element + 1) * 10 + 300;
			objReturn.Health = Math.round(Math.random() * 100 + 20);
			objReturn.Id = id;
			objReturn.IsBoss = null;
			objReturn.Rank = 1 + Math.floor(Math.random() * 3);
			objReturn.RecipeType = new Object();
			objReturn.RecipeType.ItemId = 3;
			objReturn.RecipeType.ItemType = "GoatSkin";
			objReturn.Position = position;
			return objReturn;
		}
	}

}