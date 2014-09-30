package Logic 
{
	import com.greensock.easing.Circ;
	import com.greensock.easing.Quint;
	import com.greensock.TweenMax;
	import Data.Config;
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.GUIFishStatus;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import Logic.EventNationalCelebration.FireworkFish;
	import NetworkPacket.PacketSend.SendAddMaterialIntoFish;
	/**
	 * ...
	 * @author ...
	 */
	public class GameLogic2 
	{
		public static const KIND_FISH_NORMAL:int = 0;
		public static const KIND_FISH_SUPER:int = 1;
		public static const KIND_FISH_FIREWORK:int = 2;
		public static var objDataSequenceGreenDown:Object = null;
		public static function UseMaterial(obj:Object, kindFish:int = 0):void
		{
			if (obj.numMatUse >= 5) 
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Cá đã có đủ 5 ngư thạch rồi!\n Bạn hãy dùng cho những con khác nhé |^_^|", 310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
				return;
			}
			else
			{
				var user:User = GameLogic.getInstance().user;
				var idMat:int = 0;
				obj.numMatUse ++;
				
				var arrSplit:Array = GUIFishStatus.USE_MATERIAL_FOR_FISH.split("_");
				if (arrSplit[1] && int(arrSplit[1]) > 0)
				{
					idMat = int(arrSplit[1]);
				}
				
				var fis:Fish;
				var fisFi:FireworkFish;
				var fisSp:FishSpartan;
				var cmd:SendAddMaterialIntoFish;
				switch (kindFish) 
				{
					case KIND_FISH_NORMAL:
					{
						fis = obj as Fish;
						if (idMat == 6 && !GameLogic2.CheckCanUseMaterial6(fis))
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Cá có level quá cao!\n Bạn không thể dùng được ngư thạch cấp 6 |^_^|", 310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
							return;
						}
						var typeFish:String = "Fish";
						if (fis.FishType == Fish.FISHTYPE_RARE)	typeFish = "RareFish";
						fis.FishType = Fish.FISHTYPE_RARE;
						cmd = new SendAddMaterialIntoFish(fis.Id, user.CurLake.Id, idMat, typeFish, kindFish);
						Exchange.GetInstance().Send(cmd);
					}
					break;
					case KIND_FISH_SUPER:
						fisSp = obj as FishSpartan;
						if (!fisSp.Material)	fisSp.Material = [];
						//fisSp.Material.push(idMat);
						cmd = new SendAddMaterialIntoFish(fisSp.Id, user.CurLake.Id, idMat, fisSp.NameItem, kindFish);
						Exchange.GetInstance().Send(cmd);
					break;
					case KIND_FISH_FIREWORK:
						fisFi = obj as FireworkFish;
						if (!fisFi.Material)	fisFi.Material = [];
						//fisFi.Material.push(idMat);
						cmd = new SendAddMaterialIntoFish(fisFi.Id, user.CurLake.Id, idMat, "FireWork", kindFish);
						Exchange.GetInstance().Send(cmd);
						
					break;
				}
				if(GuiMgr.getInstance().GuiStore.IsVisible)
				{
					GuiMgr.getInstance().GuiStore.UpdateStore("Material", idMat, -1);
				}
				else
				{
					GameLogic.getInstance().user.UpdateStockThing("Material", idMat, -1);
				}
				if (user.GetStoreItemCount("Material", idMat) == 0)
				{
					GameLogic.getInstance().BackToIdleGameState();
					GUIFishStatus.USE_MATERIAL_FOR_FISH = GUIFishStatus.USE_MATERIAL_FOR_FISH_CONST;
				}
				EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffHappy", null, obj.CurPos.x - 35, obj.CurPos.y - 50);
			}
		}
		
		public static function CheckCanUseMaterial6(fish:Fish):Boolean 
		{
			var levelMaxCanUseMat:int = ConfigJSON.getInstance().GetItemList("Param")["MaxLevelUseMaterial"];
			var levelFishRequire:int = ConfigJSON.getInstance().GetItemList("Fish")[fish.FishTypeId.toString()]["LevelRequire"];
			if (levelMaxCanUseMat <= levelFishRequire) 
			{
				return false;
			}
			return true;
		}
		
		public static function UseMaterialForFish(buff:Object, idFish:int, idMat:int):void
		{
			var user:User = GameLogic.getInstance().user;
			var i:int;
			var istr:String;
			/*var f:Function = function():void 
			{
				user.UpdateOptionLakeObject(1, buff, GameLogic.getInstance().user.CurLake.Id);
				user.UpdateHavestTime();
				tmp1.visible = false;
			}*/
			var rateOption:Object = new Object();
			//var guiTop:GUITopInfo = GuiMgr.getInstance().GuiTopInfo;
			//var pos:Point = new Point(guiTop.ctnBuffMoney.CurPos.x - 170, guiTop.ctnBuffMoney.CurPos.y);
			var pos:Point = new Point(638, 8);
			var eff1:ImgEffectFly;
			var posOrig:Point;
			var posMid:Point;
			var check:Number;
			var st:String ;
			var txtFormat :TextFormat;
			var tmp1:Sprite;
			
			for (i = 0; i < user.FishArr.length; i++)
			{
				var fish:Fish = user.FishArr[i];
				fish.SetMovingState(Fish.FS_SWIM);
				fish.SetHighLight( -1);
				
				if (fish.Id == idFish)
				{
					if (!fish.RateOption)	fish.RateOption = new Object();
					if (!fish.Material)	fish.Material = [];
					fish.Material.push(idMat);
					for (istr in buff) 
					{
						if (!fish.RateOption[istr])	fish.RateOption[istr] = 0;
						fish.RateOption[istr] += buff[istr];
						
						user.UpdateOptionLakeObject(1, buff, GameLogic.getInstance().user.CurLake.Id);
						user.UpdateHavestTime();
						/*st = "+" + Ultility.StandardNumber(buff[istr]);

						txtFormat = new TextFormat("Arial", 24, 0xffffff, true);
						//pos = new Point(guiTop.ctnBuffMoney.CurPos.x - 170, guiTop.ctnBuffMoney.CurPos.y);
						pos = new Point(638, 8);
						switch (istr) 
						{
							case "Money":
								txtFormat.color = 0xF8CA12;
							break;
							case "Exp":
								txtFormat.color = 0x47E8FF;
								//pos = new Point(guiTop.ctnBuffExp.CurPos.x - 140, guiTop.ctnBuffExp.CurPos.y);
								pos = new Point(465, 8);
							break;
							case "Time":
								txtFormat.color = 0xCC00CC;
								//pos = new Point(guiTop.ctnBuffTime.CurPos.x - 80, guiTop.ctnBuffTime.CurPos.y);
								pos = new Point(589, 8);
							break;
						}
						//pos = guiTop.img.localToGlobal(pos);
						txtFormat.font = "SansationBold";
						txtFormat.align = "left";
						tmp1 = Ultility.CreateSpriteText(st, txtFormat, 6, 0x293661, true);
						GuiMgr.getInstance().guiFrontScreen.img.addChild(tmp1);
						
						posOrig = Ultility.PosLakeToScreen(fish.CurPos.x, fish.CurPos.y);
						tmp1.x = posOrig.x;
						tmp1.y = posOrig.y;
						
						check = Math.random();
						if (check >= 0.5)
						{
							posMid = new Point(pos.x, posOrig.y); 
						}
						else 
						{
							posMid = new Point(posOrig.x, pos.y + 20); 
						}
						TweenMax.to(	tmp1, 1.5,{bezier:[{x:posMid.x, y:posMid.y},{x:pos.x,y:pos.y+20}],
										ease:Circ.easeOut, onComplete:f});*/
					}
					rateOption = fish.RateOption;
					fish.FishType = Fish.FISHTYPE_RARE;
					fish.RefreshImg();
					break;
				}
			}
			
			for (i = 0; i < user.AllFishArr.length; i++)
			{
				if (user.AllFishArr[i].Id == idFish)
				{
					if (!user.AllFishArr[i].Material)
					{
						user.AllFishArr[i].Material = [];
					}
					user.AllFishArr[i].Material.push(idMat);
					if (user.AllFishArr[i].FishType == Fish.FISHTYPE_NORMAL)	
						user.AllFishArr[i].FishType = Fish.FISHTYPE_RARE;
					user.AllFishArr[i].RateOption = rateOption;
					break;
				}
			}
			
			for (i = 0; i < user.FishArrSpartan.length; i++)
			{
				var fishSp:FishSpartan = user.FishArrSpartan[i];
				fishSp.SetMovingState(Fish.FS_SWIM);
				fishSp.SetHighLight( -1);
				
				if (fishSp.Id == idFish)
				{
					if (!fishSp.RateOption)	fishSp.RateOption = new Object();
					for (istr in buff) 
					{
						if (!fishSp.RateOption[istr])	fishSp.RateOption[istr] = 0;
						fishSp.RateOption[istr] += buff[istr];
						
						user.UpdateOptionLakeObject(1, buff, GameLogic.getInstance().user.CurLake.Id);
						user.UpdateHavestTime();
						/*st = "+" + Ultility.StandardNumber(buff[istr]);

						txtFormat = new TextFormat("Arial", 24, 0xffffff, true);
						switch (istr) 
						{
							case "Money":
								txtFormat.color = 0xF8CA12;
							break;
							case "Exp":
								txtFormat.color = 0x47E8FF;
								//pos = new Point(guiTop.ctnBuffExp.CurPos.x - 140, guiTop.ctnBuffExp.CurPos.y);
								pos = new Point(465, 8);
							break;
							case "Time":
								txtFormat.color = 0xCC00CC;
								//pos = new Point(guiTop.ctnBuffTime.CurPos.x - 80, guiTop.ctnBuffTime.CurPos.y);
								pos = new Point(589, 8);
							break;
						}
						pos = guiTop.img.localToGlobal(pos);
						txtFormat.font = "SansationBold";
						txtFormat.align = "left";
						tmp1 = Ultility.CreateSpriteText(st, txtFormat, 6, 0x293661, true);
						guiTop.img.addChild(tmp1);
						
						posOrig = Ultility.PosLakeToScreen(fishSp.CurPos.x, fishSp.CurPos.y);
						tmp1.x = posOrig.x;
						tmp1.y = posOrig.y;
						
						check = Math.random();
						if (check >= 0.5)
						{
							posMid = new Point(pos.x, posOrig.y); 
						}
						else 
						{
							posMid = new Point(posOrig.x, pos.y + 20); 
						}
						TweenMax.to(	tmp1, 1.5,{bezier:[{x:posMid.x, y:posMid.y},{x:pos.x,y:pos.y+20}],
										ease:Circ.easeOut, onComplete:f} );*/
						
						fishSp.numOption = 0;
						for (var iRateOptionSp:String in fishSp.RateOption) 
						{
							fishSp.numOption++;
						}
						fishSp.RefreshImg();
						if (!fishSp.Material)	fishSp.Material = [];
						fishSp.Material.push(idMat);
						//eff1 = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp1,null, f) as ImgEffectFly;
						//eff1.SetInfo(posOrig.x, posOrig.y, pos.x, pos.y + 20, 20);
					}
					return;
				}
			}
			
			//for (i = 0; i < user.FishArrSpartanDeactive.length; i++)
			//{
				//var fishSpDe:FishSpartan = user.FishArrSpartanDeactive[i];
				//fishSpDe.SetMovingState(Fish.FS_SWIM);
				//fishSpDe.SetHighLight( -1);
				//
				//if (fishSpDe.Id == idFish)
				//{
					//if (!fishSpDe.RateOption)	fishSpDe.RateOption = new Object();
					//for (istr in buff) 
					//{
						//if (!fishSpDe.RateOption[istr])	fishSpDe.RateOption[istr] = 0;
						//fishSpDe.RateOption[istr] += buff[istr];
						//st = "+" + Ultility.StandardNumber(buff[istr]);
//
						//txtFormat = new TextFormat("Arial", 24, 0xffffff, true);
						//switch (istr) 
						//{
							//case "Money":
								//txtFormat.color = 0xF8CA12;
							//break;
							//case "Exp":
								//txtFormat.color = 0x47E8FF;
								//pos = new Point(guiTop.ctnBuffExp.CurPos.x - 140, guiTop.ctnBuffExp.CurPos.y);
							//break;
							//case "Time":
								//txtFormat.color = 0xCC00CC;
								//pos = new Point(guiTop.ctnBuffTime.CurPos.x - 80, guiTop.ctnBuffTime.CurPos.y);
							//break;
						//}
						//pos = guiTop.img.localToGlobal(pos);
						//txtFormat.font = "SansationBold";
						//txtFormat.align = "left";
						//tmp1 = Ultility.CreateSpriteText(st, txtFormat, 6, 0x293661, true);
						//guiTop.img.addChild(tmp1);
						//
						//posOrig = Ultility.PosLakeToScreen(fishSpDe.CurPos.x, fishSpDe.CurPos.y);
						//tmp1.x = posOrig.x;
						//tmp1.y = posOrig.y;
						//
						//check = Math.random();
						//if (check >= 0.5)
						//{
							//posMid = new Point(pos.x, posOrig.y); 
						//}
						//else 
						//{
							//posMid = new Point(posOrig.x, pos.y + 20); 
						//}
						//TweenMax.to(	tmp1, 1.5,{bezier:[{x:posMid.x, y:posMid.y},{x:pos.x,y:pos.y+20}],
										//ease:Circ.easeOut, onComplete:f} );
						//
						//fishSpDe.numOption = 0;
						//for (var iRateOptionSpDe:String in fishSpDe.RateOption) 
						//{
							//fishSpDe.numOption++;
						//}
						//fishSpDe.RefreshImg();
						//eff1 = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp1,null, f) as ImgEffectFly;
						//eff1.SetInfo(posOrig.x, posOrig.y, pos.x, pos.y + 20, 20);
					//}
					//return;
				//}
			//}
			
			for (i = 0; i < user.arrFireworkFish.length; i++)
			{
				var fishFi:FireworkFish = user.arrFireworkFish[i];
				if (fishFi.Id == idFish)
				{
					if (!fishFi.Material)	fishFi.Material = [];
					fishFi.Material.push(idMat);
					for (istr in buff) 
					{
						if (!fishFi.RateOption)	fishFi.RateOption = new Object();
						if (!fishFi.RateOption[istr])	fishFi.RateOption[istr] = 0;
						fishFi.RateOption[istr] += buff[istr];
					}
					break;
				}
			}
		}
		
		public function GameLogic2() 
		{
			
		}
		
	}

}