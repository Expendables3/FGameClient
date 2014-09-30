package GUI.FishWar 
{
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Effect.SwfEffect;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import Logic.FallingObject;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import Logic.User;
	
	/**
	 * Cho cá diễn trên GUI này
	 * @author longpt
	 */
	public class GUIFishWarMovie extends BaseGUI 
	{
		public var AtkTime:int;
		public var ResultTime:int;
		public var NumCombo:int;
		public var theirFishImg:Image;
		public var myFishImg:Image;
		public var myFish:FishSoldier;
		public var theirFishId:int;
		
		public function GUIFishWarMovie(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFishWarMovie";
		}
		
		public override function InitGUI():void
		{
			LoadRes("GuiFishWar");
			SetPos(30, 30);
		}
		
		public function Init(mFish:FishSoldier, tFishId:int):void
		{
			ClearComponent();
			theirFishId = tFishId;
			this.Show(Constant.GUI_MIN_LAYER, 6);
			this.img.visible = false;
			// Effect oánh nhau
			// Đội bạn
			//Chọn ngẫu nhiên 1 con cá chịu trận
			var theirFishArr:Array = GameLogic.getInstance().user.FishArr;
			for (var i:int = 0; i < theirFishArr.length; i++)
			{
				if (theirFishArr[i].Id == tFishId)
				{
					var theirFish:Fish = theirFishArr[i];
					break;
				}
			}
			//var unLuckyFish:Number = Ultility.RandomNumber(0, theirFishArr.length -1);
			
			mFish = mFish;
			AtkTime = 0;
			ResultTime = 10;
			NumCombo = 5;

			//theirFishImg = new Image(img.stage, Fish.ItemType + theirFishArr[unLuckyFish].FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 250, 320);
			theirFishImg = new Image(img.stage, Fish.ItemType + theirFish.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 250, 320);
			theirFishImg.SetScaleXY(2);
			var imgEff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, theirFishImg.img, null) as ImgEffectFly;
			imgEff1.SetInfo(theirFishImg.img.x, theirFishImg.img.y, 420, 320, 5, -0.5);

			 //Quân ta
			var myFishImg:Image = new Image(img.stage, Fish.ItemType + mFish.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 40, 320);
			myFishImg.SetScaleXY(2);
			var imgEff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, myFishImg.img, null, FightEffect) as ImgEffectFly;
			imgEff.SetInfo(myFishImg.img.x, myFishImg.img.y, 380, 320, 10, -0.5);
		}
		
		public function FightEffect():void
		{
			var e:SwfEffect = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFightingFishSmoke", null, 420, 300, false, false, null, FightResult);
			e.img.scaleX = 2;
			e.img.scaleY = 2;
			AtkMgr();
			AtkMgr();
		}
		
		public function AtkMgr():void
		{
			if (GameLogic.getInstance().IsWin != 2)
			{
				var prob:Number = Ultility.RandomNumber(0, 5);
				switch (prob)
				{
					case 1:
					case 2:
					case 3:
					case 4:
						HitAtk();
						break;
					case 5:
						MissAtk();
						break;
					default:
						 //do nothing
						break;
				}
			}
			else if (GameLogic.getInstance().IsWin == 2)
			{
				AtkTime = 1;
				ResultTime = 0;
				CritAtk();
				CritAtk();
			}
		}
		
		public function HitAtk(next:int = 0):void
		{
			var child:Sprite = new Sprite();
			var pos:Point = new Point(350, Ultility.RandomNumber(250, 380));
			var d:DisplayObject = ResMgr.getInstance().GetRes("EffFishWarTrung") as DisplayObject;
			d.rotation = Ultility.RandomNumber( -45, 45);
			child.addChild(d);
			
			if (ResultTime < 0)
			{
				//var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, null) as ImgEffectFly;
				//eff.SetInfo(pos.x, pos.y, pos.x + Ultility.RandomNumber(-40 , 40), pos.y + Ultility.RandomNumber(-40 , 40), 3);
			}
			else
			{
				var eff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, null, AtkMgr) as ImgEffectFly;
				eff1.SetInfo(pos.x, pos.y, pos.x + Ultility.RandomNumber(-40 , 40), pos.y + Ultility.RandomNumber(-40 , 40), 3);
				ResultTime--;
			}
		}
		
		public function MissAtk():void
		{
			var child:Sprite = new Sprite();
			var pos:Point = new Point(350, Ultility.RandomNumber(250, 380));
			var d:DisplayObject = ResMgr.getInstance().GetRes("EffFishWarTruot") as DisplayObject;
			d.rotation = Ultility.RandomNumber( -45, 45);
			child.addChild(d);
			
			if (ResultTime < 0)
			{
				//var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child) as ImgEffectFly;
				//eff.SetInfo(pos.x, pos.y, pos.x + Ultility.RandomNumber(-40 , 40), pos.y + Ultility.RandomNumber(-40 , 40), 3);
			}
			else
			{
				var eff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, null, AtkMgr) as ImgEffectFly;
				eff1.SetInfo(pos.x, pos.y, pos.x + Ultility.RandomNumber(-40 , 40), pos.y + Ultility.RandomNumber(-40 , 40), 3);
				ResultTime--;
			}
		}
		
		public function CritAtk():void
		{
			var child:Sprite = new Sprite();
			var pos:Point = new Point(350, Ultility.RandomNumber(250, 380));
			var d:DisplayObject;
			
			if (NumCombo > 0)
			{
				d = ResMgr.getInstance().GetRes("EffFishWarTrung") as DisplayObject;
				d.rotation = Ultility.RandomNumber( -45, 45);
				child.addChild(d);
				var eff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, null, AtkMgr) as ImgEffectFly;
				eff1.SetInfo(pos.x, pos.y, pos.x + Ultility.RandomNumber(-40 , 40), pos.y + Ultility.RandomNumber(-40 , 40), 3);
				NumCombo--;
			}
			else if (NumCombo >= -1)
			{
				d = ResMgr.getInstance().GetRes("EffFishWarChiMang") as DisplayObject;
				d.rotation = Ultility.RandomNumber( -45, 45);
				child.addChild(d);
				var efff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, child, null, AtkMgr) as ImgEffectFly;
				efff1.SetInfo(pos.x, pos.y, pos.x + Ultility.RandomNumber(-40 , 40), pos.y + Ultility.RandomNumber(-40 , 40), 3);
				NumCombo--;
			}
		}
		
		public function FightResult():void
		{
			if ((AtkTime != 0) && (GameLogic.getInstance().IsWin != 2))
			{
				FightEffect();
				--AtkTime;
			}
			else if ((GameLogic.getInstance().IsWin == 1) || (GameLogic.getInstance().IsWin == 2))
			{
				UpdateFriendsStatus(GameLogic.getInstance().IsWin + 1);
				ResultTime = 0;
				//var ef:SwfEffect = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFightingFishSmoke", null, 420, 300, false, false, null);
				//ef.img.scaleX = 2;
				//ef.img.scaleY = 2;
				var et:SwfEffect = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFishWarWin", null, 420, 300, false, false, null, DropGift);
				et.img.scaleX = 1.3;
				et.img.scaleY = 1.3;
				GameLogic.getInstance().IsWin = -1;
			}
			else
			{
				UpdateFriendsStatus(GameLogic.getInstance().IsWin + 1);
				ResultTime = 0;
				//var eff:SwfEffect = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFightingFishSmoke", null, 420, 300, false, false, null);
				//eff.img.scaleX = 2;
				//eff.img.scaleY = 2;
				var et1:SwfEffect = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFishWarLose", null, 420, 300, false, false, null, DropGift);
				et1.img.scaleX = 1.3;
				et1.img.scaleY = 1.3;
				GameLogic.getInstance().IsWin = -1;
			}
		}
		
		public function UpdateFriendsStatus(isWin:int):void
		{
			var o:Object = GameLogic.getInstance().user.GetMyInfo().Avatar;
			if (o == null)
			o = new Object();
			o[GameLogic.getInstance().user.Id] = isWin;
		}
		
		/**
		 * Quà cáp rơi ra nếu thắng (thua cũng có thể rơi)
		 */ 
		public function DropGift():void
		{
			var Result:Array = GameLogic.getInstance().FishWarBonus;
			if (Result.length != 0)
			{
				for (var i:int = 0; i < Result.length; i++)
				{
					// Cho quà rơi ra
					var mat:FallingObject;
					var j:int;
					var obj1:Object = Result[i] as Object;
					var objMoneyExp:Object = new Object();
					objMoneyExp["exp"] = 0;
					objMoneyExp["money"] = 0;
					
					switch (obj1["ItemType"])
					{
						case "Rank":
							myFish.UpdateKillMarkPoint(obj1["Num"]);
							break;
						case "Exp":
							objMoneyExp["exp"] = obj1["Num"];
							//EffectMgr.getInstance().fallExpMoney(obj1["Num"], 0 , new Point(770, 470), 5, 50);
							break;
						case "Money":
							objMoneyExp["money"] = obj1["Num"];
							//EffectMgr.getInstance().fallExpMoney(0, obj1["Num"], new Point(770, 470), 5, 50);
							//EffectMgr.getInstance().fallFlyMoney(770, 470, obj1["Num"]);
							//EffectMgr.getInstance().fallFlyXP(770, 470, obj1["Num"], true);
							break;
						case "Draft":
						case "Material":
						case "EnergyItem":
							for (j = 0; j < obj1["Num"]; j++)
							{
								mat = new FallingObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), obj1["ItemType"] + obj1["ItemId"], 770, 470);
								mat.ItemType = obj1["ItemType"];
								mat.ItemId = obj1["ItemId"];
								GameLogic.getInstance().user.fallingObjArr.push(mat);
							}
							
							// Cập nhật vào kho
							if (GuiMgr.getInstance().GuiStore.IsVisible)
							{
								GuiMgr.getInstance().GuiStore.Hide();
								GuiMgr.getInstance().GuiStore.UpdateStore(obj1["ItemType"], obj1["ItemId"], obj1["Num"]);
							}
							else
							{
								GameLogic.getInstance().user.UpdateStockThing(obj1["ItemType"], obj1["ItemId"], obj1["Num"]);
							}
							break;
					}
					
					EffectMgr.getInstance().fallExpMoney(objMoneyExp["exp"], objMoneyExp["money"], new Point(770, 470), 1, 50);
				}
			}
			
			GuiMgr.getInstance().GuiChooseFishWar.UpdateFishesHealth();
			if (GuiMgr.getInstance().GuiFriends.IsVisible)
			{
				GuiMgr.getInstance().GuiFriends.ShowFriend(GuiMgr.getInstance().GuiFriends.page);
			}
			
			ShowEmoAttacked();
			
			// Nếu có quest đánh nhau thì show kết quả
			var questArr:Array = QuestMgr.getInstance().finishedQuest;
			if (questArr.length > 0)
			{
				GameLogic.getInstance().OnQuestDone(questArr[0]);		
				questArr.splice(0, 1);
			}
			
			this.Hide();
		}
		
		/**
		 * Hiển thị emo bị đánh ở các con cá thường trong hồ
		 */
		public function ShowEmoAttacked():void
		{
			var i:int;
			var user:User = GameLogic.getInstance().user;
			for (i = 0; i < user.FishArr.length; i++)
			{
				var fish:Fish = user.FishArr[i] as Fish;
				if ((fish.Emotion != Fish.HUNGRY) && (fish.Emotion != Fish.CANCARE) && (fish.Growth() >= 1) && (fish.Id == theirFishId))
				{
					fish.SetEmotion(Fish.ATTACKED);
				}
			}
		}
	}

}