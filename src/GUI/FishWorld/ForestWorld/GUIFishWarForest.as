package GUI.FishWorld.ForestWorld 
{
	import adobe.utils.CustomActions;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.GUIFishWar;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.Network.AttackBossForest;
	import GUI.FishWorld.Network.SendAttackWorld;
	import GUI.FishWorld.SubBossIce;
	import GUI.FishWorld.SubBossMetal;
	import GUI.GUIMessageBox;
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
	public class GUIFishWarForest extends GUIFishWar 
	{
		public function GUIFishWarForest(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFishWarForest";
		}
		public var theirFishTrue:FishSoldier;
		public var myFishFinishEff:Boolean = false;
		public var theirFishFinishEff:Boolean = false;
		
		public static const ATTACK_NORMAL:int = 0;
		public static const ATTACK_CRITICAL:int = 1;
		public static const ATTACK_MISS:int = 2;
		
		override public function ProcessWar():void 
		{
			var mF:FishSoldier = GameLogic.getInstance().user.CurSoldier[0];
			var tF:FishSoldier = GameLogic.getInstance().user.CurSoldier[1];
			switch (FishWorldController.GetRound()) 
			{
				case Constant.SEA_ROUND_1:
					(tF as Thicket).fishSoldier.Show();
					if ((tF as Thicket).fishSoldier.isSubBoss)	
					{
						(tF as Thicket).fishSoldier.LoadRes("ForestWorldMonsterRedUp_Idle");
					}
					else {
						(tF as Thicket).fishSoldier.LoadRes("ForestWorldBossRedUp_Idle");
					}
					(tF as Thicket).fishSoldier.standbyPos = new Point((tF as Thicket).fishSoldier.standbyPos.x - 100, 
																		(tF as Thicket).fishSoldier.standbyPos.y);
					(tF as Thicket).fishSoldier.SetPos((tF as Thicket).fishSoldier.standbyPos.x, 
														(tF as Thicket).fishSoldier.standbyPos.y);
					(tF as Thicket).fishSoldier.isReadyToFight = true;
				break;
				case Constant.SEA_ROUND_2:
					
				break;
				case Constant.SEA_ROUND_3:
					
				break;
				case Constant.SEA_ROUND_4:
					
				break;
			}
			// Gửi gói tin oánh nhau lên
			var obj:Object = new Object();
			obj["IdSoldier"] = mF.Id;
			obj["SeaId"] = FishWorldController.GetSeaId();
			obj["RoundId"] = FishWorldController.GetRound();
			obj["LakeId"] = mF.LakeId;
			switch (FishWorldController.GetRound()) 
			{
				case Constant.SEA_ROUND_1:
					obj["IdMonster"] = (tF as Thicket).fishSoldier.Id;
				break;
				case Constant.SEA_ROUND_2:
				case Constant.SEA_ROUND_3:
					obj["IdMonster"] = tF.Id;
				break;
			}
			
			var energyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillMonster");
			// Effect trừ năng lượng
			GameLogic.getInstance().user.UpdateEnergy( -energyCost);
			var fightWorld:SendAttackWorld = new SendAttackWorld(obj);
			fightWorld.SetItemList(SupportList);
			switch (FishWorldController.GetRound()) 
			{
				case Constant.SEA_ROUND_2:
					var objEff:Object = GuiMgr.getInstance().GuiMainForest.objEffYellowRight;
					if(objEff)	// Nếu đang đánh các vị thần 1-2-3
					{
						GuiMgr.getInstance().GuiEffRandomSeaRightGreen.initGUI(objEff.Monster, objEff.Boss, fightWorld);
					}
					else	// Nếu đánh vị thần thứ 4
					{
						Exchange.GetInstance().Send(fightWorld);
					}	
				break;
				case Constant.SEA_ROUND_1:
				case Constant.SEA_ROUND_3:
					Exchange.GetInstance().Send(fightWorld);
				break;
			}
			
			// Lưu lại thời gian click gửi gói tin để chặn ko cho gửi nữa
			GameInput.getInstance().lastAttackTime = GameLogic.getInstance().CurServerTime;
			// Cập nhật kho đối với các item buff exp rank gold
			for (var i:int = 0; i < SupportList.length; i++)
			{
				if (SupportList[i].Type == "BuffRank" || SupportList[i].Type == "BuffExp" || SupportList[i].Type == "BuffMoney")
				{
					if (SupportList[i].Used > 0)
					{
						GuiMgr.getInstance().GuiStore.UpdateStore(SupportList[i].Type, SupportList[i].Id, -SupportList[i].Used);
					}
				}
			}
			this.Hide();
		}
		
		/**
		 * Hàm thực hiện đánh nhau khi có kịch bản trả về
		 */
		public function StartWarUpRed():void 
		{
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffWar" + myFish.Element, 
						null, myFish.CurPos.x, myFish.CurPos.y, false, false, null, function():void { FinishEffMySolider() } );
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffWar" + theirFishTrue.Element, 
						null, theirFishTrue.CurPos.x, theirFishTrue.CurPos.y, false, false, null, function():void { FinishEffTheirSolider() } ).img.rotation = 180;;
		}
		
		public function FinishEffTheirSolider():void 
		{
			var objSence:Object = GameLogic.getInstance().arrSenceForest[0];
			var status:int = objSence.Status.Defence;
			var vitality:int = objSence.Vitality.Attack[myFish.Id.toString()];
			ShowEffResult(myFish, myFish.Vitality - vitality, status);
			var isWin:Boolean = true;
			if (myFish.Vitality <= 0)	isWin = false;
			theirFishFinishEff = true;
			if (myFishFinishEff && theirFishFinishEff)
			{
				myFishFinishEff = false;
				theirFishFinishEff = false;
				GameLogic.getInstance().arrSenceForest.splice(0, 1);
				if (GameLogic.getInstance().arrSenceForest.length > 1)
				{
					StartWarUpRed();
				}
				else 
				{
					GameLogic.getInstance().isAttacking = false;
					FinishAttackUpRed(isWin);
				}
			}
		}
		public function FinishAttackUpRed(isWin:Boolean):void 
		{
			if (!isWin)
			{
				GuiMgr.getInstance().GuiRegenerating.initGUI([myFish]);
				myFish.SwimTo(myFish.standbyPos.x, myFish.standbyPos.y, 10);
				theirFishTrue.SwimTo(theirFish.standbyPos.x, theirFish.standbyPos.y, 10);
			}
			else
			{
				
			}
			//GuiMgr.getInstance().GuiMainForest.Swap();
		}
		public function FinishEffMySolider():void 
		{
			var objSence:Object = GameLogic.getInstance().arrSenceForest[0];
			var status:int = objSence.Status.Attack[myFish.Id.toString()];
			var vitality:int = objSence.Vitality.Defence["Left"];
			ShowEffResult(theirFishTrue, theirFishTrue.Vitality - vitality, status);
			var isWin:Boolean = false;
			if (theirFishTrue.Vitality <= 0)	isWin = true;
			myFishFinishEff = true;
			if (myFishFinishEff && theirFishFinishEff)
			{
				myFishFinishEff = false;
				theirFishFinishEff = false;
				GameLogic.getInstance().arrSenceForest.splice(0, 1);
				if (GameLogic.getInstance().arrSenceForest.length > 1)
				{
					StartWarUpRed();
				}
				else 
				{
					GameLogic.getInstance().isAttacking = false;
					FinishAttackUpRed(isWin);
				}
			}
		}
		public function ShowEffResult(fs:FishSoldier, deltaVitality:int, status:int):void 
		{
			var s:Sprite;
			var txtFormat:TextFormat;
			var deltaPos:Point = new Point(15 - Math.random() * 30, 0 - 35 - Math.random() * 30);
			if (status == ATTACK_CRITICAL)
			{
				s = ResMgr.getInstance().GetRes("EffTxtChiMang") as Sprite;
				s.scaleX = s.scaleY = 0.6;
				EffectMgr.getInstance().flyBack(s, fs.img, new Point(0, 0), new Point( 150, 0), new Point( 50, 0), 0.4, 0.3);
				
				txtFormat = new TextFormat("Arial", 36, 0xff0000, true);
				txtFormat.align = "center";
				EffectMgr.getInstance().textBack("-" + deltaVitality, fs.img,
					new Point(deltaPos.x, deltaPos.y), new Point( deltaPos.x, deltaPos.y - 100), new Point( deltaPos.x, deltaPos.y - 50), 1, 0.5, txtFormat);
			}
			else if (status == ATTACK_NORMAL)
			{
				txtFormat = new TextFormat("Arial", 24, 0xff0000, true);
				txtFormat.align = "center";
				EffectMgr.getInstance().textBack("-" + deltaVitality, fs.img,
					new Point(deltaPos.x, deltaPos.y), new Point( deltaPos.x, deltaPos.y - 100), new Point( deltaPos.x, deltaPos.y - 50), 1, 0.5, txtFormat);
			}
			else 
			{
				s = ResMgr.getInstance().GetRes("EffTxtTruot") as Sprite;
				s.scaleX = s.scaleY = 0.6;
				EffectMgr.getInstance().flyBack(s, fs.img, new Point(0, 0), new Point( 150, 0), new Point( 50, 0), 0.4, 0.3);
			}
			fs.Vitality -= deltaVitality;
		}
		override public function ShowFish(fish:FishSoldier, isMyFish:Boolean):void 
		{
			//super.ShowFish(fish, isMyFish);
			var str:String;
			var a:Array;
			var Pos:Point;
			var tf:TextField;
			var image:Image;
			var ctn:Container;
			var ft:TextFormat;
			var tt:TooltipFormat;
			var counter:int;
			switch (GuiMgr.getInstance().GuiMainForest.TypeSwim) 
			{
				case GuiMgr.getInstance().GuiMainForest.TYPE_SWIM_UP:
					counter = checkCounter(myFish, theirFish);
				break;
			}
			if (isMyFish)
			{
				// Add cái element ở đây
				ctn = AddContainer("", "GuiFishWar_CtnElement", 340, 110);
				ctn.AddImage("", "Element" + fish.Element, 15, 15, true, ALIGN_LEFT_TOP).SetScaleXY(1.3);
				tt = new TooltipFormat();
				tt.text = "Hệ " + Localization.getInstance().getString("Element" + fish.Element);
				ctn.setTooltip(tt);
				
				// Nếu khắc hệ (hoặc bị khắc hệ thì add thêm thông số dc cộng (trừ)
				var dameEnviroment:int = FishWorldController.GetValueOfEnviroment(myFish);
				if ((counter != 0 && !isResistance) || dameEnviroment != 0)
				{
					if (myAllDmg - (myFish.Damage + myFish.DamagePlus + myFish.bonusEquipment.Damage) + dameEnviroment > 0)
					{
						myElementNote = AddLabel("Tăng Công: " + Math.abs(myAllDmg - (myFish.Damage + myFish.DamagePlus + myFish.bonusEquipment.Damage) + dameEnviroment), 326, 170, 0xffffff, 1, 0x000000);
					}
					else
					{
						myElementNote = AddLabel("Giảm Công: " + Math.abs(myAllDmg - (myFish.Damage + myFish.DamagePlus + myFish.bonusEquipment.Damage) + dameEnviroment), 326, 170, 0xffffff, 1, 0x000000);
					}
				}
				else
				{
					myElementNote = AddLabel("", 326, 170, 0xffffff, 1, 0x000000);
				}
				myDmg = AddLabel((myAllDmg + dameEnviroment).toString(), 305, 203, 0xFFFFFF, 2, 0x603813);
				myDef = AddLabel(String(fish.getTotalDefence()), 305, 238, 0xFFFFFF, 2, 0x603813);
				myCrit = AddLabel(String(fish.getTotalCritical()), 305, 273, 0xFFFFFF, 2, 0x603813);
				myVit = AddLabel(String(fish.getTotalVitality()), 305, 308, 0xFFFFFF, 2, 0x603813);
				
				Pos = new Point(420, 270);
				
				if (fish.EquipmentList && fish.EquipmentList.Mask && fish.EquipmentList.Mask[0])
				{
					image = AddImage("", fish.EquipmentList.Mask[0].TransformName, Pos.x, Pos.y, true, ALIGN_CENTER_TOP);
				}
				else
				{
					image = AddImage("", Fish.ItemType + fish.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, Pos.x, Pos.y, true, ALIGN_CENTER_TOP);
					UpdateEquipment(image.img, fish);
				}
				//UpdateEquipment(image.img, fish);
				
				if (fish.DamagePlus + dameEnviroment > 0)
				{
					ft = new TextFormat();
					ft.color = 0x00ff00;
					myDmg.setTextFormat(ft);
				}
				else if (fish.DamagePlus + dameEnviroment < 0)
				{
					ft = new TextFormat();
					ft.color = 0xff0000;
					myDmg.setTextFormat(ft);
				}
				
				if (fish.CriticalPlus > 0)
				{
					ft = new TextFormat();
					ft.color = 0x00ff00;
					myCrit.setTextFormat(ft);
				}
				else if (fish.CriticalPlus < 0)
				{
					ft = new TextFormat();
					ft.color = 0xff0000;
					myCrit.setTextFormat(ft);
				}
				
				if (fish.VitalityPlus > 0)
				{
					ft = new TextFormat();
					ft.color = 0x00ff00;
					myVit.setTextFormat(ft);
				}
				else if (fish.VitalityPlus < 0)
				{
					ft = new TextFormat();
					ft.color = 0xff0000;
					myVit.setTextFormat(ft);
				}
				
				if (fish.DefencePlus > 0)
				{
					ft = new TextFormat();
					ft.color = 0x00ff00;
					myDef.setTextFormat(ft);
				}
				else if (fish.DefencePlus < 0)
				{
					ft = new TextFormat();
					ft.color = 0xff0000;
					myDef.setTextFormat(ft);
				}
			}
			else
			{
				// Add cái element ở đây
				var ElementFish:int;
				var imgNameFishInWorld:String;
				var typeSwim:int = GuiMgr.getInstance().GuiMainForest.TypeSwim;
				switch (typeSwim) 
				{
					case Constant.SEA_ROUND_1:
						ElementFish = (fish as Thicket).fishSoldier.Element;
						imgNameFishInWorld = "LoadingForestWorld_ImgThicketFull";
					break;
					case Constant.SEA_ROUND_3:
						ElementFish = fish.Element;
						imgNameFishInWorld = "ForestWorldSnakeNormal_" + ElementFish + "_" + "Idle";
						break;
					case Constant.SEA_ROUND_2:
						ElementFish = fish.Element;
						imgNameFishInWorld = "ForestWorldBossRound2_" + fish.Id + "_Idle";
						break;
				}
				ctn = AddContainer("", "GuiFishWar_CtnElement", 560, 110);
				//ctn.AddLabel("?", 22, 11, 0xFFFFFF, 0, 0x603813).setTextFormat(new TextFormat(null, 36));
				var dameEnviroment1:int = FishWorldController.GetValueOfEnviroment(theirFish);
				ctn.AddImage("", "Element" + ElementFish, 15, 15, true, ALIGN_LEFT_TOP).SetScaleXY(1.3);
				tt = new TooltipFormat();
				tt.text = "Hệ " + Localization.getInstance().getString("Element" + ElementFish);
				ctn.setTooltip(tt);
				
				if(FishWorldController.GetRound() == Constant.SEA_ROUND_1)
				{
					theirDmg = AddLabel("???", 565, 203, 0xFFFFFF, 0, 0x603813);
					theirDef = AddLabel("???", 565, 238, 0xFFFFFF, 0, 0x603813);
					theirCrit = AddLabel("???", 565, 273, 0xFFFFFF, 0, 0x603813);
					theirVit = AddLabel("???", 565, 308, 0xFFFFFF, 0, 0x603813);
				}
				else
				{
					theirDmg = AddLabel((theirAllDmg + dameEnviroment1) + "", 565, 203, 0xFFFFFF, 0, 0x603813);
					theirDef = AddLabel(String(fish.getTotalDefence()), 565, 238, 0xFFFFFF, 0, 0x603813);
					theirCrit = AddLabel(String(fish.getTotalCritical()), 565, 273, 0xFFFFFF, 0, 0x603813);
					theirVit = AddLabel(String(fish.getTotalVitality()), 565, 308, 0xFFFFFF, 0, 0x603813);
				}
				
				Pos = new Point(630, 270);
				image = AddImage("", imgNameFishInWorld, Pos.x, Pos.y, true, ALIGN_CENTER_TOP);
				image.img.rotationY = 180;
			}
			
			if (!isMyFish)
			{
				image.img.scaleX = -1;
				image.FitRect(120, 120, new Point(610, 230));
			}
			else
			{
				image.FitRect(120, 120, new Point(240, 230));
			}
		}
		
		override public function ShowGiftCanClaim():void 
		{
			super.ShowGiftCanClaim();
			return;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			//super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BUTTON_CLOSE:
				case BUTTON_CANCEL:
					if (isEffecting)	return;
					if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)
					{
						GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
					}
					this.Hide();
					GuiMgr.getInstance().GuiMainForest.SetEmotionIdleAll(false);
					break;
				case BUTTON_WAR:
					if (isEffecting)	return;
					
					// Nếu hết máu hoặc hết hạn thì thông báo và đóng GUI
					if (myFish.Status == FishSoldier.STATUS_REVIVE)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg28"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
						if (!Ultility.IsInMyFish())
						{
							GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
						}
						Hide();
						return;
					}
					
					if (theirFish.Status == FishSoldier.STATUS_REVIVE)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg24"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
						Hide();
						return;
					}
					
					if(GameLogic.getInstance().user.CurSoldier[0] && GameLogic.getInstance().user.CurSoldier[1])
					{
						var energyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillMonster");
						if (energyCost > GameLogic.getInstance().user.GetEnergy())
						{
							GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 1);
						}
						else
						{
							GuiMgr.getInstance().GuiBackMainForest.isCanDoBackForestWorld = false;
							//xử lý kịch bản
							Hide();
							// Giai quyet cho cac truong hop cac vong khac nhau
							switch (FishWorldController.GetRound()) 
							{
								case Constant.SEA_ROUND_1:
									EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, (theirFish as Thicket).fishSoldier.ImgName.split("_")[0] + "_Jump",
										null, (theirFish as Thicket).fishSoldier.standbyPos.x, (theirFish as Thicket).fishSoldier.standbyPos.y, false, false, null, ProcessWar);	
								break;
								case Constant.SEA_ROUND_2:
								case Constant.SEA_ROUND_3:
									ProcessWar();
								break;
								case Constant.SEA_ROUND_4:
									
								break;
							}
							//ProcessWar();
							GameLogic.getInstance().SetState(GameState.GAMESTATE_FISHWORLD_FOREST_WARRING);
						}
						break;
					}
					
					if (!GameLogic.getInstance().user.CurSoldier[0] && GameLogic.getInstance().user.GetFishArr().length > 0)
					{
						// Thông báo cá hết tuổi thọ
						Hide();
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg24"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					}
					else 
					{
						if (FishWorldController.GetRound() != Constant.OCEAN_FOREST_ROUND_4 || 
							(FishWorldController.GetRound() == Constant.OCEAN_FOREST_ROUND_4 && 
							GuiMgr.getInstance().GuiBackMainForest.isReceiveDataForBossGift))
						{
							Hide();
						}
					}
					break;
				default:
					var a:Array = buttonID.split("_");
					if (a[0] == "BtnG")
					{
						for (var i:int = 0; i < SupportList.length; i++)
						{
        					if ((SupportList[i]["Type"] == a[1]) && (SupportList[i]["Id"] == a[2]))
							{
								break;
							}
						}
						
						if (SupportList[i]["Count"] == 0)
						{
							if (SupportList[i]["ZMoney"] > GameLogic.getInstance().user.GetZMoney())
							{
								GuiMgr.getInstance().GuiNapG.Init();
							}
							else
							{
								ProcessBuyItem(buttonID);
							}
						}
						else
						{
							ProcessUseItem(buttonID);
						}
					}
					break;
			}
		}
	}

}