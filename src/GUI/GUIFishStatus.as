package GUI 
{
	import adobe.utils.CustomActions;
	import Data.BitmapMovie;
	import Data.Localization;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.FishWorld.FishWorldController;
	import Logic.EventNationalCelebration.FireworkFish;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.FishSpartan;
	import Logic.GameLogic;
	import Data.ConfigJSON;
	import Logic.Ultility;
	/**
	 * ...
	 * @author tuan
	 */
	public class GUIFishStatus extends BaseGUI
	{
		public static const STATUS_SELL:String = "Sell";
		public static const STATUS_FEED:String = "Feed";
		public static const STATUS_MIX:String = "Mix";
		public static const USE_MATERIAL_FOR_FISH_CONST:String = "UseMaterialForFish_";
		public static var USE_MATERIAL_FOR_FISH:String = "UseMaterialForFish_";
		public static const RESET_MATE_FISH:String = "ResetMateFish";
		public static const RECOVER_HEALTH:String = "RecoverHealth";
		public static const INCREASE_RANK_POINT:String = "Increase";
		public static const BUFF_SAMURAI:String = "BuffSamurai";
		public static const BUFF_RESISTANCE:String = "BuffResistance";
		public static const BUFF_STORE_RANK:String = "BuffStoreRank";
		public static const WAR_INFO:String = "WarInfo";
		public static const HP_BAR:String = "HPBar";
		
		// Các kết quả kiểm tra cá trước khi lai
		public static const PASS:int = 0;			// đủ điều kiện để show
		public static const BABY:int = 1;			// đang còn bé
		public static const CHUALAI:int = 2;		// trưởng thành nhưng chưa lai
		public static const DADUNGTHUOC:int = 3;	// đã dùng thuốc
		public static const NOT_EXIST:int = 3;		// cá ko tồn tại
		
		
		private var GUI_FISHINFO_CARE:String = "prgChamSoc";
		private var GUI_FISHINFO_HEALTH:String = "prgHealth";
		public static const GUI_FISHINFO_HP:String = "prgHP";
		
		public var prgFood:ProgressBar;
		public var prgGrowth:ProgressBar;
		public var prgHealth:ProgressBar;
		public var prgRank:ProgressBar;
		public var prgHP:ProgressBar;
		public var Type:String;
		
		public function GUIFishStatus(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_CENTER_BOTTOM) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFishStatus";			
		}
		
		public override function InitGUI(): void
		{
			//LoadRes("ImgFrameFriend");
			img = new Sprite();
			/*img.graphics.beginFill(0xFFFFFF, 1);
			img.graphics.drawRect(0, 0, 10, 10);
			img.graphics.endFill()*/
			Parent.addChild(img);
			this.SetAlign(ALIGN_LEFT_TOP);
			removeAllEvent();
		}
		
		public function ShowStatus(fish:Fish, StatusType:String):void
		{
			Type = StatusType;
			Hide();
			Show(Constant.OBJECT_LAYER);
			switch(StatusType)
			{
				case STATUS_SELL:
					ShowSellInfo(fish, StatusType);
					break;
				case STATUS_FEED:
					ShowFeedInfo(fish);
					break;
				case RESET_MATE_FISH:
					ShowResetMateFishInfo(fish);	//hiepnm2
					break;
				case RECOVER_HEALTH:
					if (fish.FishType == Fish.FISHTYPE_SOLDIER)
					{
						ShowSoldierStatus(fish as FishSoldier);
					}
					else
					{
						
					}
					break;
				case INCREASE_RANK_POINT:
				{
					if (fish.FishType == Fish.FISHTYPE_SOLDIER)
					{
						ShowSoldierStatus2(fish as FishSoldier);
					}
				};
				break;
				case BUFF_SAMURAI:
					break;
				case BUFF_RESISTANCE:
					break;
				case BUFF_STORE_RANK:
					break;
				case WAR_INFO:
					if (fish.FishType == Fish.FISHTYPE_SOLDIER)
					{
						ShowStatusWar(fish as FishSoldier);
					}
					break;
				default:
					if (StatusType.search(USE_MATERIAL_FOR_FISH) >= 0)
					{
						ShowSellInfo(fish, StatusType);
					}
					break;
			}
		}
		
		public function ShowSoldierStatus(fish:FishSoldier):void
		{
			// Thanh HP
			//prgHealth = AddProgress(GUI_FISHINFO_HEALTH, "PrgHealth", 0, 0, null, true);
			//prgHealth.setStatus(fish.Health / fish.MaxHealth);
			//prgHealth.scaleX = 0.36;
			//prgHealth.scaleY = 0.5;
			//prgHealth.x = -prgHealth.width / 2;
			//prgHealth.y = fish.img.height / 2 + 5;
			
			// Thanh sức khỏe
			prgHealth = AddProgress(GUI_FISHINFO_HEALTH, "PrgHealth", 0, 0, null, true);
			prgHealth.img.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 255, 0, 0);
			prgHealth.setStatus(fish.Health / fish.MaxHealth);
			prgHealth.scaleX = 0.5;
			prgHealth.scaleY = 0.5;
			prgHealth.x = -prgHealth.width / 2;
			prgHealth.y = -fish.img.height / 2 - 15;
			//AddLabel("Sức khỏe", prgHealth.x - 60, prgHealth.y - 7, 0x000000, 0, 0xffffff);
			var imgHealth:Image = AddImage("RecoverHealthSoldier1", "RecoverHealthSoldier1", prgHealth.x - 20, prgHealth.y - 7);
			GetImage("RecoverHealthSoldier1").FitRect(20, 20, new Point(prgHealth.x - 20, prgHealth.y - 7));
			
			AddLabel(Localization.getInstance().getString("FishSoldierRank" + fish.Rank), prgHealth.x, prgHealth.y + 7 + fish.img.height + 20, 0x000000, 0, 0xffffff);
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
			{
				imgHealth.img.visible = false;
				prgHealth.setVisible(false);
			}
		}
		
		public function ShowSoldierStatus2(fish:FishSoldier):void
		{
			var icRank:Image;
			prgRank = AddProgress(GUI_FISHINFO_HEALTH, "PrgTangTruong", 0, 0, null, true);
			prgRank.img.transform.colorTransform = new ColorTransform(0, 1, 0, 1, 0, 0, 0, 0);
			prgRank.setStatus(fish.RankPoint / fish.MaxRankPoint);
			prgRank.scaleX = 0.5;
			prgRank.scaleY = 0.5;
			prgRank.x = -prgRank.width / 2;
			prgRank.y = -fish.img.height / 2 - 15;
			icRank = AddImage("idRank", "IcRank", prgRank.x - 20, prgRank.y - 7);
			icRank.FitRect(20, 20, new Point(prgRank.x - 20, prgRank.y - 7));
			AddLabel(Localization.getInstance().getString("FishSoldierRank" + fish.Rank), prgRank.x, prgRank.y + 7 + fish.img.height + 20, 0x000000, 0, 0xffffff);
		}
		public function ShowStatusWar(fish:FishSoldier):void
		{
			if (IsVisible)	Hide();
			Show(Constant.OBJECT_LAYER);
			prgHealth = AddProgress(GUI_FISHINFO_HEALTH, "PrgHealth", 0, 0, null, true);
			prgHealth.img.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 255, 0, 0);
			prgHealth.setStatus(fish.Health / fish.MaxHealth);
			prgHealth.scaleX = 0.5;
			prgHealth.scaleY = 0.5;
			prgHealth.x = -prgHealth.width / 2;
			prgHealth.y = - fish.img.height / 2 - 15;
			//AddLabel("Sức khỏe", prgHealth.x - 60, prgHealth.y - 7, 0x000000, 0, 0xffffff);
			var imgHealth:Image = AddImage("RecoverHealthSoldier1", "RecoverHealthSoldier1", prgHealth.x - 20, prgHealth.y - 7);
			GetImage("RecoverHealthSoldier1").FitRect(20, 20, new Point(prgHealth.x - 20, prgHealth.y - 7));
			AddLabel(Localization.getInstance().getString("FishSoldierRank" + fish.Rank), prgHealth.x, prgHealth.y + 7 + fish.img.height + 20, 0x000000, 0, 0xffffff);
			if (FishWorldController.CheckHaveEnvironment())
			{
				FishWorldController.ShowEffForFishArrInIceWorld(fish);
				GameController.getInstance().shakeScreen(10, 2, 20, false);
			}
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
			{
				imgHealth.img.visible = false;
				prgHealth.setVisible(false);
			}
		}
		
		public function ShowHPBar(fish:FishSoldier, curHP:int, maxHP:int, isShowHpBar:Boolean = true):void
		{
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
			{
				return;
			}
			Hide();
			Show(Constant.OBJECT_LAYER);
			if(isShowHpBar)
			{
				prgHP = AddProgress(GUI_FISHINFO_HP, "PrgHealth", 0, 0, null, true);
				if (curHP < 0) curHP = 0;
				prgHP.setStatus(curHP / maxHP);
				prgHP.scaleX = 0.5;
				prgHP.scaleY = 0.5;
				prgHP.x = -prgHP.width / 2;
				prgHP.y = -fish.img.height / 2 - 40;
				//AddLabel("Máu", prgHP.x - 30, prgHP.y - 7, 0x000000, 0, 0xffffff);
				AddImage("ImgHeart", "IcHeart", prgHP.x - 20, prgHP.y - 7);
				GetImage("ImgHeart").FitRect(20, 20, new Point(prgHP.x - 20, prgHP.y - 7));
				var status:Number = curHP / maxHP;
				GameLogic.getInstance().AddPrgToProcess(prgHP, status, Constant.TYPE_PRG_HP);
			}
			
			// Thanh sức khỏe
			prgHealth = AddProgress(GUI_FISHINFO_HEALTH, "PrgHealth", 0, 0, null, true);
			prgHealth.img.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 255, 0, 0);
			prgHealth.setStatus(fish.Health / fish.MaxHealth);
			prgHealth.scaleX = 0.5;
			prgHealth.scaleY = 0.5;
			prgHealth.x = -prgHealth.width / 2;
			prgHealth.y = -fish.img.height / 2 - 15;
			prgHealth.setVisible(!(LeagueController.getInstance().mode == LeagueController.IN_LEAGUE));
			//AddLabel("Sức khỏe", prgHealth.x - 60, prgHealth.y - 7, 0x000000, 0, 0xffffff);
			var imgHealth:Image = AddImage("RecoverHealthSoldier1", "RecoverHealthSoldier1", prgHealth.x - 20, prgHealth.y - 7);
			GetImage("RecoverHealthSoldier1").FitRect(20, 20, new Point(prgHealth.x - 20, prgHealth.y - 7));
			
			AddLabel(Localization.getInstance().getString("FishSoldierRank" + fish.Rank), prgHealth.x, prgHealth.y + 7 + fish.img.height + 20, 0x000000, 0, 0xffffff);
			if (FishWorldController.CheckHaveEnvironment())
			{
				FishWorldController.ShowEffForFishArrInIceWorld(fish);
				GameController.getInstance().shakeScreen(10, 2, 20, false);
			}
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
			{
				imgHealth.img.visible = false;
				prgHealth.setVisible(false);
			}
		}
		
		//hiepnm2
		public function ShowResetMateFishInfo(fish:Fish):void
		{
			//chi hien thi status cho nhung con ca co the dung thuoc
			switch(Check(fish))
			{
				case PASS:		//nhung con ca da lai:
				{
					//xử lý show ở đây.
					var growth:Number = Math.abs(fish.Growth());
					prgGrowth = AddProgress(GUI_FISHINFO_CARE, "PrgTangTruong", 0, 0, null, true);
					//prgGrowth.SetBackGround("prgEXP_bg", 2, 1);
					//prgGrowth.SetPosBackGround( -3, fish.img.height + 8);
					prgGrowth.setStatus(growth);
					prgGrowth.scaleX = 0.36;
					prgGrowth.scaleY = 0.5;
					prgGrowth.x = -prgGrowth.width/ 2;
					prgGrowth.y = fish.img.height / 2 + 5;
					
					var image:Image = AddImage("", "IcGold", prgGrowth.x + 5, prgGrowth.y + 11, true, ALIGN_LEFT_TOP);
					image.SetScaleX(0.8);
					image.SetScaleY(0.8);
					
					var format:TextFormat = new TextFormat(null, 20, 0x954200, true);			
					format.size = 15;
					format.color = 0xFFFFFF;
					format.bold = true;
					var price: int = fish.GetValue();
					var txt:TextField = AddLabel(price.toString(), prgGrowth.x + 25, prgGrowth.y + 10, 0xffffff, 0);
					txt.setTextFormat(format);
								
					//Add ảnh giới tính cá
					if (fish.Sex == 1)
					{
						image = AddImage("", "IcMale", prgGrowth.x + prgGrowth.width + 2, prgGrowth.y - 7, true, ALIGN_LEFT_TOP);
						image.SetScaleX(0.6);
						image.SetScaleY(0.6);
					}
					else
					{
						image = AddImage("", "IcFemale", prgGrowth.x + prgGrowth.width + 2, prgGrowth.y - 5 , true, ALIGN_LEFT_TOP);
						image.SetScaleX(0.65);
						image.SetScaleY(0.65);
					}
					image =  AddImage("", "ImgEgg", prgGrowth.x - 11 , prgGrowth.y  + 8, true, ALIGN_LEFT_TOP);
					image.SetScaleX(0.6);
					image.SetScaleY(0.6);
					break;
				}
				case CHUALAI:			//nhung con ca truong thanh co the dem lai
					break;
				case BABY:			//cá bé
					break;
				case DADUNGTHUOC:
					break;
			}
			
		}
		
		public function CheckCanUseMaterial(fish:Fish):Boolean 
		{
			if (fish.FishType != Fish.FISHTYPE_NORMAL && fish.FishType != Fish.FISHTYPE_RARE)
			{
				return false;
			}
			else 
			{
				return true;
			}
		}
		
		public function Check(f:Fish):int
		{
			if (!f)
			{
				return NOT_EXIST;
			}
			// Check tuổi
			f.UpdateHavestTime();
			if (f.Growth() < 1)
			{
				return BABY;
			}
			// check time, 1 ngày sinh sản 1 lần
			var lastTime:Date = new Date(f.LastBirthTime * 1000);//lần cuối cùng lai
			var lastViagraTime:Date = new Date(f.LastTimeViagra * 1000);//lan cuoi su dung viagra
			var curTime:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			if (curTime.getFullYear() == lastTime.getFullYear())
			{
				if (curTime.getMonth() == lastTime.getMonth())
				{
					if (curTime.getDate() == lastTime.getDate())
					{
						if (curTime.getFullYear() != lastViagraTime.getFullYear() ||
							curTime.getMonth() != lastViagraTime.getMonth() ||
							curTime.getDate() != lastViagraTime.getDate())
							return PASS;
						else
							return DADUNGTHUOC;
						//if (f.ViagraUsed == 0)
							//return PASS;
						//else
							//return DADUNGTHUOC;
					}
					else
					{
						return CHUALAI;
					}
				}
				else
				{
					return CHUALAI;
				}
			}
			else
			{
				return CHUALAI;
			}
		}
		public function ShowStatusSparta(fish:FishSpartan, StatusType:String):void
		{
			Type = StatusType;
			Hide();
			Show(Constant.OBJECT_LAYER);
			SetPos(fish.CurPos.x, fish.CurPos.y);
			switch(StatusType)
			{
				case STATUS_SELL:
				case USE_MATERIAL_FOR_FISH:
					ShowSellInfoSparta(fish);
					break;
				case STATUS_FEED:
					//ShowFeedInfoSparta(fish);
					break;
			}
		}
		
		public function ShowFireworkStatus(fish:FireworkFish, StatusType:String):void
		{
			Type = StatusType;
			Hide();
			Show(Constant.OBJECT_LAYER);
			SetPos(fish.CurPos.x, fish.CurPos.y);
			switch(StatusType)
			{
				case STATUS_SELL:
				case USE_MATERIAL_FOR_FISH:
					ShowSellInfoFirework(fish);
					break;
				case STATUS_FEED:
					//ShowFeedInfoSparta(fish);
					break;
			}
		}
		
		private function ShowSellInfo(fish:Fish, type:String = STATUS_SELL):void
		{
			var growth:Number = Math.abs(fish.Growth());
			prgGrowth = AddProgress(GUI_FISHINFO_CARE, "PrgTangTruong", 0, 0, null, true);
			//prgGrowth.SetBackGround("prgEXP_bg", 2, 1);
			//prgGrowth.SetPosBackGround( -3, fish.img.height + 8);
			prgGrowth.setStatus(growth);
			prgGrowth.scaleX = 0.36;
			prgGrowth.scaleY = 0.5;
			prgGrowth.x = -prgGrowth.width/ 2;
			prgGrowth.y = fish.img.height / 2 + 5;
			if(type == STATUS_SELL)
			{
				var image:Image = AddImage("", "IcGold", prgGrowth.x + 5, prgGrowth.y + 11, true, ALIGN_LEFT_TOP);
				image.SetScaleX(0.8);
				image.SetScaleY(0.8);
				
				var format:TextFormat = new TextFormat(null, 20, 0x954200, true);			
				format.size = 15;
				format.color = 0xFFFFFF;
				format.bold = true;
				var price: int = fish.GetValue();
				var txt:TextField = AddLabel(price.toString(), prgGrowth.x + 25, prgGrowth.y + 10, 0xffffff, 0);
				txt.setTextFormat(format);
				
				//Add ảnh quả trứng
				var lastTime:Date = new Date(fish.LastBirthTime * 1000);
				var curTime:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
				var can:Boolean;
				
				// check time
				if (curTime.getFullYear() == lastTime.getFullYear())
				{
					if (curTime.getMonth() == lastTime.getMonth())
					{
						if (curTime.getDate() == lastTime.getDate())
						{
							can = false;
						}
						else
						{
							can = true;
						}
					}
					else
					{
						can = true;
					}
				}
				else
				{
					can = true;
				}			
				
				if (!can)
				{
					image =  AddImage("", "ImgEgg", prgGrowth.x - 11 , prgGrowth.y  + 8, true, ALIGN_LEFT_TOP);
					image.SetScaleX(0.6);
					image.SetScaleY(0.6);
				}
			}
						
			if(type == STATUS_SELL || (type.search(USE_MATERIAL_FOR_FISH) >= 0 && (fish.FishType == Fish.FISHTYPE_NORMAL || fish.FishType == Fish.FISHTYPE_RARE)))
			{
				//Add ảnh giới tính cá
				if (fish.FishType != Fish.FISHTYPE_SOLDIER)
				{
					if (fish.Sex == 1)
					{
						image = AddImage("", "IcMale", prgGrowth.x + prgGrowth.width + 2, prgGrowth.y - 7, true, ALIGN_LEFT_TOP);
						image.SetScaleX(0.6);
						image.SetScaleY(0.6);
					}
					else
					{
						image = AddImage("", "IcFemale", prgGrowth.x + prgGrowth.width + 2, prgGrowth.y - 5 , true, ALIGN_LEFT_TOP);
						image.SetScaleX(0.65);
						image.SetScaleY(0.65);
					}
				}
			}
		}
		
		private function ShowFeedInfo(fish:Fish):void
		{
			var food:Number = Math.abs(fish.Full());
			prgFood = AddProgress(GUI_FISHINFO_CARE, "PrgThucAn", 0, 0, null, true);
			//prgFood.SetBackGround("prgEXP_bg", 2, 1);
			//prgFood.SetPosBackGround( -3, fish.img.height + 8);
			prgFood.scaleX = 0.5;
			prgFood.scaleY = 0.5;
			prgFood.setStatus(food);
			prgFood.x = - prgFood.width / 2;
			if (fish.IsHide)
			{
				prgFood.y = 23;
			}
			else
			{
				prgFood.y = fish.img.height / 2 + 5;
			}
		}
		private function ShowSellInfoSparta(fish:FishSpartan):void
		{
			//prgGrowth = AddProgress(GUI_FISHINFO_CARE, "PrgTangTruong", 0, - fish.img.height, null, true);
			//prgGrowth.setStatus(1);
			//prgGrowth.scaleX = 0.36;
			//prgGrowth.scaleY = 0.5;
			var posX:int = -21;
			var posY:int = -65;
			if (!fish.isExpired) 
			{
				posX = posX + fish.sign(fish.SpeedVec.x) * fish.img.width / 2;
				posY = posY + fish.img.height / 2;
			}
			
			
			var image:Image = AddImage("", "IcGold", posX - 20, posY - 15, true, ALIGN_LEFT_TOP);
			image.SetScaleX(0.8);
			image.SetScaleY(0.8);
			
			image = AddImage("", "IcExp", posX - 20, posY + 7, true, ALIGN_LEFT_TOP);
			image.SetScaleX(0.6);
			image.SetScaleY(0.6);
			
			var format:TextFormat = new TextFormat(null, 20, 0x954200, true);			
			format.size = 15;
			format.color = 0xFFFFFF;
			format.bold = true;
			var price: int = fish.GetValue();
			var txt:TextField = AddLabel(price.toString(), posX, posY - 15, 0xffffff, 0);
			txt.setTextFormat(format);
			
			var exp: int = fish.getExp();
			txt = AddLabel(exp.toString(), posX, posY + 7, 0xffffff, 0);
			txt.setTextFormat(format);
		}
		
		private function ShowSellInfoFirework(fish:FireworkFish):void
		{
			var posX:int = 0;// -21;
			var posY:int = 0;// -65;
			if (fish.Emotion != FireworkFish.DEAD)
			{
				posX = -21;
				posY = -65;
			}
			
			var image:Image = AddImage("", "IcGold", posX - 20, posY - 15, true, ALIGN_LEFT_TOP);
			image.SetScaleX(0.8);
			image.SetScaleY(0.8);
			
			image = AddImage("", "IcExp", posX - 20, posY + 7, true, ALIGN_LEFT_TOP);
			image.SetScaleX(0.6);
			image.SetScaleY(0.6);
			
			var format:TextFormat = new TextFormat(null, 20, 0x954200, true);			
			format.size = 15;
			format.color = 0xFFFFFF;
			format.bold = true;
			var price: int = fish.GetValue();
			var txt:TextField = AddLabel(price.toString(), posX, posY - 15, 0xffffff, 0);
			txt.setTextFormat(format);
			
			var exp: int = fish.getExp();
			txt = AddLabel(exp.toString(), posX, posY + 7, 0xffffff, 0);
			txt.setTextFormat(format);
			//this.SetPos(fish.img.x, fish.img.y);
		}
		
		private function ShowFeedInfoSparta(fish:FishSpartan):void
		{
			prgFood = AddProgress(GUI_FISHINFO_CARE, "PrgThucAn", 0, 0, null, true);
			prgFood.scaleX = 0.5;
			prgFood.scaleY = 0.5;
			prgFood.setStatus(1);
			prgFood.x = - prgFood.width / 2;
		}
	}

}