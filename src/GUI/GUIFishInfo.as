package GUI 
{	
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.FishWar.FishEquipment;
	import Logic.EventNationalCelebration.FireworkFish;
	
	import flash.events.*;
	import GUI.component.BaseGUI;
	import Logic.*;
	import Data.*;
	import flash.display.Sprite;
	import NetworkPacket.PacketSend.SendGetTotalFish;
	import Sound.SoundMgr;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author MinhT
	 */
	public class GUIFishInfo extends BaseGUI
	{
		private const GUI_FISHINFO_EXIT:String = "ButtonExit";
		private const GUI_FISHINFO_MOVE:String = "ButtonMove";
		private const GUI_FISHINFO_SELL:String = "ButtonSell";		
		private const GUI_FISHINFO_BASE_CARE:String = "imgChamSoc";
		private const GUI_FISHINFO_BASE_GROWTH:String = "imgTangTruong";
		private const GUI_FISHINFO_BASE_FOOD:String = "imgThucAn";
		private const GUI_FISHINFO_BASE_AGE:String = "imgHealth";
		private const GUI_FISHINFO_BASE_HEALTH:String = "imgHealth";
		
		private var GUI_FISHINFO_CARE:String = "prgChamSoc";
		private var GUI_FISHINFO_GROWTH:String = "prgTangTruong";
		private var GUI_FISHINFO_FOOD:String = "PrgThucAn";
		private var GUI_FISHINFO_SEX:String = "imgSex";
		public var FishId:int;
		
		//public var prgCare:ProgressBar;
		public var prgGrowth:ProgressBar;
		public var prgRank:ProgressBar;
		public var prgFood:ProgressBar;
		public var prgAge:ProgressBar;
		public var prgHealth:ProgressBar;
		public var imgSex:Image;
		
		//public var IsBaseInfo:Boolean;
		//public var IsEgg:Boolean;
		
		public var btnMove:Button;
		
		public function GUIFishInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_CENTER_BOTTOM) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFishInfo";
			//IsBaseInfo = false;
			//IsEgg = false;
		}
		
		public override function InitGUI(): void
		{
			LoadRes("ImgBgGUIFishInfo");								
			this.SetAlign(ALIGN_CENTER_TOP);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case GUI_FISHINFO_MOVE:
					Hide();
					var fish:Fish = GameLogic.getInstance().user.GetFishArr()[this.FishId] as Fish;
					//GuiMgr.getInstance().GuiChangeLake.fish = fish;
					//GuiMgr.getInstance().GuiChangeLake.Show(Constant.GUI_MIN_LAYER);	
					//GuiMgr.getInstance().GuiChangeLake.Show();
					break;
				case GUI_FISHINFO_SELL:
					SellFish(FishId);
					break;
				case GUI_FISHINFO_EXIT:
					HideDrop();
					break;	
				default:
					break;
			}
		}

		public function HideDrop():void
		{
			if (!this.IsVisible)
			{
				return;
			}
			// Release fish
			var fish:Fish = GameLogic.getInstance().user.GetFishArr()[this.FishId] as Fish;
			
			if (fish != null)
			{
				if (!fish.IsEgg)
				{
					fish.State = Fish.FS_SWIM
				}
				fish.SetHighLight( -1);
			}
			
			// Hide GUI
			this.Hide();
		}
		
		public function SellFish(id:int):void
		{
			var fish:Fish = GameLogic.getInstance().user.GetFishArr()[id] as Fish;	
			if (fish == GameLogic.getInstance().user.FishKing) 
			{
				GameLogic.getInstance().Sell(GameLogic.getInstance().user.FishKing);
				GameLogic.getInstance().user.FishKing = null;
			}
			GameLogic.getInstance().Sell(fish);
			fish = null;
			this.img.mouseEnabled = false;
			this.img.mouseChildren = false;
			// An gui
			this.Hide();
		}
		
		//public function ShowOption(option: String, rate: int): String
		//{
			//switch (option)
			//{
				//case ("Money"):
					//return "Tăng tiền thu hoạch: " + rate + "%";
				//break;
				//case ("Exp"):
					//return "Tăng EXP thu hoach: " + rate + "%";
				//break;
				//case ("MixFish"):
					//return "Tăng khả năng lai " + rate + "% ra cá quý";
				//break;
				//case ("Time"):
					//return "Giảm thời gian thu hoạch: " + rate + "%";
				//break;
			//}
			//return null;
		//}
		
		/**
		 * Thông tin đối tượng bị đánh
		 * (Rớt ra đồ j)
		 * @param	fish
		 */
		public function ShowTargetInfo(fish:Fish):void
		{
			if (!GameLogic.getInstance().user.CurSoldier[0])
			{
				Hide();
				return;
			}
			
			Clear();
			LoadRes("ImgBgGuiBenefit");
			
			// Add ten, type
			var layer:Layer;
			layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var PosX:int = fish.img.x;
			var PosY:int = fish.img.y;
			var txtF:TextField;
			var tF:TextFormat;
			
			// Highlight cá
			fish.SetHighLight();	
			
			switch (fish.FishType)
			{
				case Fish.FISHTYPE_NORMAL:
					//txtF = AddLabel("Rớt: " + CalculateValue(fish) + " vàng", 10, 10);
					//break;
				case Fish.FISHTYPE_RARE:
				case Fish.FISHTYPE_SPECIAL:
					txtF = AddLabel("Rớt: " + CalculateValue(fish) + " vàng", 20, 10, 0xFFF100, 1, 0x603813);
					tF = new TextFormat();
					tF.size = 14;
					txtF.setTextFormat(tF);
					break;
				case Fish.FISHTYPE_SOLDIER:
					if(Ultility.IsInMyFish())
					{
						var str:String = Localization.getInstance().getString("Element" + (fish as FishSoldier).Element);
						txtF = AddLabel("Rớt: " + str + " tán\n       " + str + " đan", 20, 10, 0xFFF100, 1, 0x603813);
					}
					else 
					{
						txtF = AddLabel("Rớt: " + Localization.getInstance().getString("Element" + (fish as FishSoldier).Element) + " tán\n" + 
							"hoặc " + Localization.getInstance().getString("Element" + (fish as FishSoldier).Element) + " đan", 20, 10, 0xFFF100, 1, 0x603813);
					}
					tF = new TextFormat();
					tF.size = 14;
					txtF.setTextFormat(tF);
					break;
					break;
			}
			
			//Xét lại tọa độ cho GUI
			var stageWidth:int = LayerMgr.getInstance().GetLayer(Constant.TopLayer).stage.stageWidth;
			var stageHeight:int = LayerMgr.getInstance().GetLayer(Constant.TopLayer).stage.stageHeight;					
			
			SetPos(PosX, PosY);	
			var posScreen:Point = Ultility.PosLakeToScreen(PosX, PosY);
			
			if (posScreen.y <= stageHeight / 3)
			{
				if (posScreen.x < stageWidth / 3)
				{
					SetAlign(ALIGN_LEFT_TOP);
					SetPos(PosX + 20, PosY);
				}
				else if (posScreen.x > 2 * stageWidth / 3)
				{
					SetAlign(ALIGN_RIGHT_TOP);
					SetPos(PosX - 20, PosY);
				}
				else
				{
					SetAlign(ALIGN_CENTER_TOP);
					SetPos(PosX, PosY + 20);
				}
			}
			else if (posScreen.y > 2 * stageHeight / 3 - 100)
			{
				if (posScreen.x < stageWidth / 3)
				{
					SetAlign(ALIGN_LEFT_BOTTOM);
					SetPos(PosX + 20, PosY);
				}
				else if (posScreen.x > 2 * stageWidth / 3)
				{
					SetAlign(ALIGN_RIGHT_BOTTOM);
					SetPos(PosX - 20, PosY);
				}
				else
				{
					SetAlign(ALIGN_CENTER_BOTTOM);
					SetPos(PosX, PosY - 20);
				}
			}
			else
			{
				if (posScreen.x < stageWidth / 2)
				{
					SetAlign(ALIGN_LEFT_CENTER);
					SetPos(PosX + 30, PosY);	
				}
				else
				{
					SetAlign(ALIGN_RIGHT_CENTER);
					SetPos(PosX - 30, PosY);
				}
			}
		}
		
		/**
		 * Tính toán giá trị có thể lấy của con cá
		 * @param	fish
		 * @return
		 */
		public function CalculateValue(fish:Fish):int
		{
			// Cá nhỏ thì chưa khai thác được
			if (fish.Growth() < 1)
			{
				return 0;
			}
			
			var curFish:FishSoldier = GameLogic.getInstance().user.CurSoldier[0];
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("Fish", fish.FishTypeId);
			var trustPrice:int = cfg.TrustPrice;
			var thisTotal:int = trustPrice * 60 / 100;
			var thisLeft:int = thisTotal - fish.MoneyAttacked;
			if (thisLeft < 0)	thisLeft = 0;
			var wannaGet:int = Math.ceil(Number(curFish.Damage / 100) * curFish.Rate * trustPrice);
			
			return Math.min(wannaGet, thisLeft);
		}
		
		/**
		 * Thông tin cá lính
		 * @param	fish
		 */
		public function ShowInfoSoldier(fish:FishSoldier):void
		{
			Clear();
			LoadRes("ImgBgGuiFishSoldierInfo");
			fish.UpdateCombatSkill();
			fish.UpdateBonusEquipment();
			
			// Add các items đã sử dụng lên GUI
			var i:int = 0;
			var j:int;
			var s:String;
			var x0:int = 95;
			var y0:int = 195;
			var dx:int = 30;
			var dy:int = 0;
			
			//  Add hình các items đã sử dụng vào con cá này
			//for (i = 0; fish.BuffItem && i < fish.BuffItem.length; i++)
			//{
				//AddImage("", fish.BuffItem[i].ItemType + fish.BuffItem[i].ItemId, 0, 0).FitRect(32, 32, new Point(x0 + i * dx, y0 + i * dy));
			//}
			
			// Add trạng thái bảo vệ
			if (fish.CheckProtected())
			{
				AddImage("", "Protector1", 0, 0).FitRect(32, 32, new Point(x0 + i * dx, y0 + i * dy));
				i++;
			}
			
			// Add cả các ngọc đã buff vào con cá này
			if (LeagueController.getInstance().mode != LeagueController.IN_LEAGUE)//loại trừ trường hợp trong liên đấu
			{
				for (s in fish.GemList)
				{
					if (i <= 5)
					{
						var max:int = 0;
						for (j = 0; j < fish.GemList[s].length; j++)
						{
							if (max < fish.GemList[s][j]["GemId"])
							{
								max = fish.GemList[s][j]["GemId"];
							}
						}
						if (max == 0)	continue;
						var ss:String = "Gem_" + s + "_" + max;
						AddImage("", "Gem_" + s + "_" + max, 0, 0).FitRect(32, 32, new Point(x0 + i * dx, y0 + i * dy)); 
						i++;
					}
					else
					{
						break;
					}
				}
			}
			
			
			AddEquipment(fish);
			
			// Add ten, type
			var layer:Layer;
			layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var PosX:int = fish.img.x;
			var PosY:int = fish.img.y;
			
			var food:Number = 0;
			var age:Number = 0;
			var hp:Number = 0;
			
			if (fish.TimeLeft > 0)
			{
				age = fish.TimeLeft / fish.LifeTime;
			}
			
			hp = fish.Health / fish.MaxHealth;
			if (hp > 1)
			{
				hp = 1;
			}
			
			// Tinh toan moc tang truong
			var CurrentTime:int = GameLogic.getInstance().CurServerTime;
			var EatenSpeed:int = 1;
			
			// Highlight cá
			fish.SetHighLight();			
			
			// Tên cá
			var nameF:String = fish.nameSoldier;// Localization.getInstance().getString(Fish.ItemType + fish.FishTypeId);
			var name:TextField;
			var format:TextFormat = new TextFormat();
			format.color = 0x000000;
			
			var curTime:Number = GameLogic.getInstance().CurServerTime; 

			var lb:TextField;
			var fm:TextFormat = new TextFormat;
			fm.font = "Arial";
			fm.size = 11;

			prgRank = AddProgress(GUI_FISHINFO_BASE_GROWTH, "PrgTangTruong", 169, 159, null, true);
			prgHealth = AddProgress(GUI_FISHINFO_BASE_HEALTH, "PrgHealth", 168, 184, null, true);

			var curPoint:int = Math.max(fish.RankPoint, 0);
			prgRank.setStatus(curPoint / fish.MaxRankPoint);
			prgHealth.setStatus(hp);
			prgRank.scaleX = 0.7;
			prgRank.scaleY = 0.8;
			prgHealth.scaleX = 0.7;
			prgHealth.scaleY = 0.8;
			
			// Text
			format.size = 16;
			format.bold = true;
			name = AddLabel(nameF, 135, 28);
			name.setTextFormat(format);
			format.size = 12;
			fm.size = 10;
			fm.bold = false;
			
			// Số sao từ công thức lai
			var numStar:int = GetNumStar(fish.RecipeType.ItemType);			
			var x00:int = 185 - (14 + 3) * numStar / 2;
			var dxx:int = 17;
			for (i = 0; i < numStar; i++)
			{
				AddImage("", "RedStar", x00 + dxx * i, 48, true, ALIGN_LEFT_TOP).SetScaleXY(0.3);
			}
			
			// Cấp cá
			lb = AddLabel(Localization.getInstance().getString("FishSoldierRank" + fish.Rank), 154, 141, 0x000000, 1);
			lb.setTextFormat(fm);
			
			// Sức khỏe của cá
			lb = AddLabel("" + fish.Health, 252, 177, 0x000000, 0);
			
			// Hồi phục 
			var RgTime:int = GameLogic.getInstance().CurServerTime - fish.LastHealthTime;
			var cd:int = fish.HealthRegenCooldown - RgTime;
			var minu:int = Math.floor(cd / 60);			
			cd -= minu * 60;
			
			if (fish.Health < fish.MaxHealth)
			{
				if (cd > 9)
				{
					lb = AddLabel("Hồi phục: 0" + minu + ":" + cd, 154, 167, 0x000000, 1);
				}
				else
				{
					lb = AddLabel("Hồi phục: 0" + minu + ":0" + cd, 154, 167, 0x000000, 1);
				}
				lb.setTextFormat(fm);
			}
			
			// % cấp độ -----------------------------------------------------------------
			var percent:int = Math.floor(fish.RankPoint / fish.MaxRankPoint * 100);
			if (percent > 100) 	percent = 100;
			if (percent < 0)	percent = 0;
			lb = AddLabel(percent + "%", 252, 150, 0x000000, 0);
			AddImage("", "IcRank", 252, 150).FitRect(20, 20, new Point(150, 152));
			AddLabel(fish.Rank + "", 88, 152, 0x064954);
			
/*			var dayLeft:Number;
			var hourLeft:Number;
			var minLeft:Number;
			var secLeft:Number;
			// Thời gian sống ------------------------------------------------------------
			if (fish.TimeLeft > 0)
			{
				dayLeft = Math.floor(fish.TimeLeft / 86400);
				hourLeft = Math.floor((fish.TimeLeft - dayLeft * 86400) / 3600);
				if (dayLeft > 0)
				{
					var strr:String = "Còn " + dayLeft + " ngày";
					if (hourLeft > 0)
					{
						strr += " " + hourLeft + " giờ";
					}
					
					lb = AddLabel(strr, 180, 125, 0x000000, 0);
				}
				else
				{
					minLeft = Math.floor((fish.TimeLeft - hourLeft * 3600)/ 60);
					secLeft = fish.TimeLeft - minLeft * 60 - hourLeft * 3600;
					
					if (hourLeft > 0)
					{
						lb = AddLabel("Còn " + hourLeft + " giờ " + minLeft + " phút ", 180, 125, 0x000000, 0);
					}
					else if (minLeft > 0)
					{
						lb = AddLabel("Còn " + minLeft + " phút " + secLeft + " giây", 180, 125, 0x000000, 0);
					}
					else
					{
						lb = AddLabel("Còn " + secLeft + " giây", 180, 125, 0x000000, 0);
					}
				}
			}
			else
			{
				if(Ultility.IsInMyFish() || fish.isActor == FishSoldier.ACTOR_MINE)
				{
					if (fish.Status == FishSoldier.STATUS_REVIVE)
					{
						lb = AddLabel("Chờ hồi sinh", 180, 127, 0x000000, 0);
					}
					else
					{
						lb = AddLabel("Đã hi sinh", 180, 125, 0x000000, 0);
					}
				}
				else 
				{
					lb = AddLabel("?????", 180, 125, 0x000000, 0);
				}
			}*/
			
			// Hiện công ------------------------------------
			
			var str:String;
			var txtF:TextFormat;
			str = String(fish.getTotalDamage());
			lb = AddLabel(str, 180, 63, 0x000000, 0);
			
			// Hiện thủ ----------------------------
			
			str = String(fish.getTotalDefence());
			lb = AddLabel(str, 180, 79, 0x000000, 0);
			
			// Hiện chí mạng--------------------------------------------
			
			str = String(fish.getTotalCritical());
			lb = AddLabel(str, 180, 95, 0x000000, 0);
			
			// Máu -------------------------------------------------------
			
			str = String(fish.getTotalVitality());
			lb = AddLabel(str, 180, 111, 0x000000, 0);	
			
			// Add cái ảnh thuộc tính
			AddImage("", "ImgLvRequire", 267, 45);
			AddImage("Ele", "Element" + fish.Element, 275, 50).FitRect(25, 25, new Point(255, 33));
			if (fish.Element == 3)
			{
				GetImage("Ele").SetPos(267, 45);
			}
			
			//Xét lại tọa độ cho GUI
			var stageWidth:int = LayerMgr.getInstance().GetLayer(Constant.TopLayer).stage.stageWidth;
			var stageHeight:int = LayerMgr.getInstance().GetLayer(Constant.TopLayer).stage.stageHeight;					
			
			SetPos(PosX, PosY);	
			var posScreen:Point = Ultility.PosLakeToScreen(PosX, PosY);
			
			if (posScreen.y <= stageHeight / 3)
			{
				if (posScreen.x < stageWidth / 3)
				{
					SetAlign(ALIGN_LEFT_TOP);
					SetPos(PosX + 20, PosY);
				}
				else if (posScreen.x > 2 * stageWidth / 3)
				{
					SetAlign(ALIGN_RIGHT_TOP);
					SetPos(PosX - 20, PosY);
				}
				else
				{
					SetAlign(ALIGN_CENTER_TOP);
					SetPos(PosX, PosY + 20);
				}
			}
			else if (posScreen.y > 2 * stageHeight / 3 - 100)
			{
				if (posScreen.x < stageWidth / 3)
				{
					SetAlign(ALIGN_LEFT_BOTTOM);
					SetPos(PosX + 20, PosY);
				}
				else if (posScreen.x > 2 * stageWidth / 3)
				{
					SetAlign(ALIGN_RIGHT_BOTTOM);
					SetPos(PosX - 20, PosY);
				}
				else
				{
					SetAlign(ALIGN_CENTER_BOTTOM);
					SetPos(PosX, PosY - 20);
				}
			}
			else
			{
				if (posScreen.x < stageWidth / 2)
				{
					SetAlign(ALIGN_LEFT_CENTER);
					SetPos(PosX + 30, PosY);	
				}
				else
				{
					SetAlign(ALIGN_RIGHT_CENTER);
					SetPos(PosX - 30, PosY);
				}
			}
		}
		
		public function AddEquipment(fish:FishSoldier):void
		{
			var x0:int = 14;
			var y0:int = 20;
			var dx:int = 0;
			var dy:int = 73;
			var equip:Array = ["Helmet", "Armor", "Weapon"];
			
			var i:int;
			for (i = 0; i < equip.length; i++)
			{
				var ctn:Container = AddContainer("Equip_" + equip[i], "CtnEquipment1", x0 + i * dx, y0 + i * dy);
				
				if (fish.SoldierType == FishSoldier.SOLDIER_TYPE_MIX && fish.EquipmentList && fish.EquipmentList[equip[i]] && fish.EquipmentList[equip[i]][0])
				{
					// Thay nền
					if (fish.EquipmentList[equip[i]][0].Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
					{
						ctn.AddImage("", FishEquipment.GetBackgroundName(fish.EquipmentList[equip[i]][0].Color), 0, 0, true, ALIGN_LEFT_TOP).SetScaleXY(0.95);
					}
					
					var imagg:Image = ctn.AddImage("", fish.EquipmentList[equip[i]][0].imageName + "_Shop", 0, 0);
					imagg.FitRect(50, 50, new Point(10, 10));
					FishSoldier.EquipmentEffect(imagg.img, fish.EquipmentList[equip[i]][0].Color);
					if (fish.EquipmentList[equip[i]][0].EnchantLevel > 0)
					{
						var txt:TextField = ctn.AddLabel("+" + fish.EquipmentList[equip[i]][0].EnchantLevel, 2, 2, 0xFFF100, 1, 0x603813);
						var tF:TextFormat = new TextFormat();
						tF.size = 18;
						tF.bold = true;
						txt.setTextFormat(tF);
						
						FishSoldier.EquipmentEffect(imagg.img, fish.EquipmentList[equip[i]][0].Color);
					}
				}
				else
				{
					ctn.AddImage("", "Img" + equip[i] + "Default", 0, 0).FitRect(50, 50, new Point(10, 10));
				}
			}
		}
		
		public function ShowInfo(fish:Fish):void
		{
			var delta_Y:int = 0;
			if (fish.FishType != Fish.FISHTYPE_SPECIAL && fish.FishType != Fish.FISHTYPE_SOLDIER)
			{
				delta_Y = 43;
				Clear();
				LoadRes("ImgBgGUIFishInfoNew");
			}			
			
			// Add ten, type
			var layer:Layer;
			layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var PosX:int = fish.img.x;
			var PosY:int = fish.img.y;
			
			var growth:Number = 0;
			var food:Number = 0;
			
			// Tinh toan moc tang truong
			var CurrentTime:int = GameLogic.getInstance().CurServerTime;
			var EatenSpeed:int = 1;
			
			// Highlight cá
			fish.SetHighLight();			
			
			// Tên cá
			var nameF:String = Localization.getInstance().getString(Fish.ItemType + fish.FishTypeId);
			var name:TextField;
			var format:TextFormat = new TextFormat();
			format.color = 0x000000;
			
			// Thanh tăng trưởng: thời gian hiện tại của cá * 100 / thời gian phát triển của cá
			growth = Math.abs(fish.Growth() - fish.NumUpLevel);
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var HarvestTime:int = fish.HarvestTime;
			
			// Thời gian cần phát triển nữa để cá lên level
			var kq:int = (1 - growth) * HarvestTime;
			if (kq < 0 && growth < 1)
			{
				kq = HarvestTime;
			}
			var lb:TextField;
			var fm:TextFormat = new TextFormat;
			fm.font = "Arial";
			fm.size = 11;
			var h:int = kq / 3600;
			//var m:int = Math.ceil(kq / 60) - h * 60;
			var m:int = kq / 60 - h * 60;
			var s1:int = kq - h * 3600 - m * 60;
			if (s1 == 60)
			{
				m++;
				s1 = 0;
			}
			if (m == 60)
			{
				h++;
				m = 0;
			}
			var stt:String = "Còn " + h + " giờ " + m + " phút " + s1;
			
			// Thoi gian no con` lai
			{
				food = fish.Full();
				var maxFood:int = INI.getInstance().getGeneralInfo("Fish", "MaxFood");
				var AffectTime:int = INI.getInstance().getGeneralInfo("Food", "AffectTime");
				var timeFull:int = food * maxFood * AffectTime;
				var hFull:int = timeFull / 3600;
				var mFull:int = Math.ceil((timeFull - hFull * 3600) / 60);
				if (mFull == 60)
				{
					hFull++;
					mFull = 0;
				}
				var stFull:String = "Còn " + hFull + " giờ " + mFull + " phút";
				prgGrowth = AddProgress(GUI_FISHINFO_BASE_GROWTH, "PrgTangTruong", 120, 87, null, true);
				prgFood = AddProgress(GUI_FISHINFO_BASE_FOOD, "PrgThucAn", 120, 113, null, true);
				prgGrowth.setStatus(growth);
				prgFood.setStatus(food);
				prgGrowth.scaleX = prgGrowth.scaleY = 0.8
				prgFood.scaleX = prgFood.scaleY = 0.8			
				
				// Text
				format.size = 12;
				format.bold = true;
				name = AddLabel(nameF, 70, 14);
				name.setTextFormat(format);
				fm.size = 10;
				fm.bold = false;
				if (kq <= 0)
				{	
					lb = AddLabel("Cá đã trưởng thành", 114, 70);
					lb.setTextFormat(fm);
				}
				else
				{
					lb = AddLabel(stt, 116, 70);						
					lb.setTextFormat(fm);						
				}
				lb = AddLabel(stFull, 115, 97);		// text thời gian no còn lại
				lb.setTextFormat(fm);
				
				lb = AddLabel("Đói", 40, 105);
				fm = new TextFormat();
				fm.font = "Arial";
				fm.size = 12;
				fm.color = 0x044954;
				fm.bold = true;
				fm.align = "left";
				lb.setTextFormat(fm);
			}
			
			// Giới tính và domain của con cá
			{
				if (fish.Sex == 1) 
				{
					imgSex = AddImage(GUI_FISHINFO_SEX, "IcMale", 210, 10, true, Image.ALIGN_LEFT_TOP);
				}
				else if (fish.Sex == 0)
				{
					imgSex = AddImage(GUI_FISHINFO_SEX, "IcFemale", 210, 10, true, Image.ALIGN_LEFT_TOP);
				}
				else
				{
					imgSex = AddImage(GUI_FISHINFO_SEX, "IcComplete", 210, 10, true, Image.ALIGN_LEFT_TOP);
				}
				
				var domain:int = -1;
				var strDomain:String;
				var imgDomain:Image;
				if (fish.FishTypeId >= Constant.FISH_TYPE_START_DOMAIN) 
				{
					domain = (fish.FishTypeId - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
					if (domain > 0)
					{
						strDomain = Fish.DOMAIN + domain;
						imgDomain = AddImage("DomainFish", strDomain, 0, 0);
						//imgDomain.SetPos(190, 40);
						imgDomain.FitRect(30, 30, new Point(170, 12));
					}
				}
			}
			AddImage("", "ImgEXP", 36, 145);
			AddImage("", "IcGold", 136, 145);
			fm.size = 12;
			fm.bold = true;
			
			var user:User = GameLogic.getInstance().user;
			//Add money
			var price:String;
			var price_int: int = Math.round(fish.GetValue());
			
			price = Ultility.StandardNumber(price_int);
			if (fish.GetPeriod() < Fish.GROWTH_UP && fish.NumUpLevel < 1)
			{
				price = "0";
			}
			if (GameLogic.getInstance().user.CurLake.Option["Money"] > 0)
			{
				price += " (+ " + Math.min(GameLogic.getInstance().user.CurLake.Option["Money"],Constant.MAX_BUFF_MONEY) + "%)";
			}
			//if (fish.MoneyAttacked > 0)
			//{
				//price += " (-" + fish.MoneyAttacked + ")";
			//}
			var lbll:TextField = AddLabel(price, 150, 136, 0, 0)
			lbll.setTextFormat(fm);
			
			var tfmoney:TextFormat = new TextFormat();
			tfmoney.color = 0xffcc00;
			//if (fish.MoneyAttacked > 0)
			//{
				//var a:Array = lbll.text.split("-");
				//var index:int = lbll.text.length - a[1].length - 2;
				//lbll.setTextFormat(tfmoney, index, lbll.text.length);
			//}
			
			//Add exp
			{
				var exp: String;
				var exp_int: int;
				if (growth + fish.NumUpLevel < 1)
				{
					exp_int = 0;
				}
				else
				{
					exp_int = fish.getExp();
				}
				exp = Ultility.StandardNumber(exp_int);
				if (GameLogic.getInstance().user.CurLake.Option["Exp"] > 0)
				{
					exp += " (+ " + Math.min(GameLogic.getInstance().user.CurLake.Option["Exp"],Constant.MAX_BUFF_EXP) + "%)";
				}
				AddLabel(exp, 52, 136, 0, 0).setTextFormat(fm);			
				
				SetAlign(ALIGN_CENTER_BOTTOM);
				SetPos(PosX, PosY - 20);
			}
			var option:String = "";
			var optionLabel: TextField;
			var obj: Object;
			var s: String;	
			
			var distance:int;
			var startCon:int = 15;
			var startArrow:int = 60;
			var startIcon:int = 25;
			var startText:int = -70;
			var delta:int;
			var startY:int = 170;
			var con:Container;
			var clTran:ColorTransform = new ColorTransform();
			var imgTang:Image;
			var numOption:int = 0;
			var numtotalOption:int = 0;
			format = new TextFormat();
			// Thông tin tăng option
			obj = fish.RateOption;
						
			if (fish.FishType == Fish.FISHTYPE_SPECIAL)
			{
				for (s in obj)
				{
					numtotalOption++;
				}
				
				for (s in obj)
				{
					if (obj[s] > 0) 
					{
						option = obj[s] + "%";
						distance = 216 / numtotalOption - 15 * (3 - numtotalOption);
						delta = (3 - numtotalOption) * 36;
						format = new TextFormat();
						format.size = 14;
						format.bold = true;
						format.align = "center";
						
						if (s == "MixFish")
						{
							con = AddContainer("Con_EXP", "ImgBgOption",delta + startCon + numOption * distance, startY);
							// Add icon mũi tên
							imgTang = con.AddImage("", "IcTangMixRare",startArrow, 12);
							// add icon xp
							var imgMixFish:Image;
							imgMixFish = con.AddImage("", "IcMixRare", startIcon, 19);
							imgMixFish.FitRect(25, 25);
							// Add text
							optionLabel = con.AddLabel(option, startText, 2, 0xDA1304, 1, -1);
						}
						else 	if (s == "MixSpecial")
						{
							con = AddContainer("Con_EXP", "ImgBgOption",delta + startCon + numOption * distance, startY);
							// Add icon mũi tên
							imgTang = con.AddImage("", "IcTangEXP",startArrow, 12);
							// add icon xp
							var imgMixSpecial:Image;
							imgMixSpecial = con.AddImage("", "IcMixSpecial", startIcon, 19);
							imgMixSpecial.FitRect(25, 25);
							// Add text
							format.color = 0x00B7ED;
							optionLabel = con.AddLabel(option, startText, 2, 0xFFFFFF, 1, 0x26709C);
						}
						optionLabel.multiline = true;
						optionLabel.wordWrap = true;
						optionLabel.width = 230;
						optionLabel.setTextFormat(format);
					}
					numOption++;
				}
			}
			else 
			{
				distance = 75;
				if (!obj)  obj = new Object();
				if (!obj.Exp)	obj.Exp = 0;
				if (!obj.Time)	obj.Time = 0;
				if (!obj.Money)	obj.Money = 0;
				for (numOption = 0; numOption < 3; numOption++)
				{
					con = AddContainer("Con_EXP" + numOption, "ImgBgOption", startCon + numOption * distance, startY);
					var outLineOption:int = 0x26709C;
					var isEnable:Boolean = true;
					switch (numOption) 
					{
						//case "Exp":
						case 1:
							format.color = 0x00B7ED;
							imgTang = con.AddImage("", "IcBuffExp", 21, 12);
							option = obj.Exp + "%";
							if (obj.Exp <= 0)	isEnable = false;
						break;
						
						//case "Money":
						case 0:
							format.color = 0xE3B601;
							imgTang = con.AddImage("", "IcBuffMoney", 21, 12);
							option = obj.Money + "%";
							if (obj.Money <= 0)	isEnable = false;
						break;
						
						//case "Time":
						case 2:
							format.color = 0xE73B00;
							outLineOption = - 1;
							imgTang = con.AddImage("", "IcBuffTime", 21, 12);
							option = obj.Time + "%";
							if (obj.Time <= 0)	isEnable = false;
						break;
					}
					optionLabel = con.AddLabel(option, 40, 3, 0xFFFFFF, 0, outLineOption);
					optionLabel.multiline = true;
					optionLabel.wordWrap = true;
					optionLabel.width = 230;
					optionLabel.setTextFormat(format);
					if (!isEnable)	Ultility.SetEnableSprite(con.img, false, 0.3);
				}
			}
			
			var SourceFish: TextField = AddLabel(Localization.getInstance().getString("IntroFish" + fish.FishTypeId.toString()), 20, 205 + delta_Y);
			SourceFish.multiline = true;
			SourceFish.wordWrap = true;
			SourceFish.width = 220;
			
			format.color = "0x000000";
			lb = AddLabel(Ultility.StandardNumber(fish.Level), 50, 37);
			lb.setTextFormat(format);
			
			//Xét lại tọa độ cho GUI
			var stageWidth:int = LayerMgr.getInstance().GetLayer(Constant.TopLayer).stage.stageWidth;
			var stageHeight:int = LayerMgr.getInstance().GetLayer(Constant.TopLayer).stage.stageHeight;					
			
			SetPos(PosX, PosY);	
			var posScreen:Point = Ultility.PosLakeToScreen(PosX, PosY);
			
			// Các slot ngư thạch
			if(fish.FishType != Fish.FISHTYPE_SPECIAL)
			{
				var delta_X_Slot_Material:int = 45;
				var start_X_Slot_Material:int = 12;
				var start_Y_Slot_Material:int = 202;
				
				for (var i:int = 0; i < 5; i++) 
				{
					if (fish.Material.length > i)
					{
						var imgNguThach:Image = AddImage("MaterialSlot" + i, Ultility.GetNameMatFromType(fish.Material[i]), 0, 0);
						imgNguThach.FitRect(40, 40, new Point(start_X_Slot_Material + delta_X_Slot_Material * i, start_Y_Slot_Material));
						
					}
					else 
					{
						var txtNguThach:TextField = AddLabel("Ngư thạch", start_X_Slot_Material + delta_X_Slot_Material * i + 3, start_Y_Slot_Material + 4);
						txtNguThach.wordWrap = true;
						txtNguThach.width = 40;
						txtNguThach.multiline = true;
						var txtFormat:TextFormat = new TextFormat(null, null, 0x014D83, true, null, null, null, null, "center");
						txtNguThach.setTextFormat(txtFormat);
					}
					
				}
			}
			
			if (posScreen.y <= stageHeight / 3)
			{
				if (posScreen.x < stageWidth / 3)
				{
					SetAlign(ALIGN_LEFT_TOP);
					SetPos(PosX + 20 + 20, PosY);
				}
				else if (posScreen.x > 2 * stageWidth / 3)
				{
					SetAlign(ALIGN_RIGHT_TOP);
					SetPos(PosX - 20 + 150, PosY);
				}
				else
				{
					SetAlign(ALIGN_CENTER_TOP);
					SetPos(PosX, PosY + 20);
				}
			}
			else if (posScreen.y > 2 * stageHeight / 3 - 100)
			{
				if (posScreen.x < stageWidth / 3)
				{
					SetAlign(ALIGN_LEFT_BOTTOM);
					SetPos(PosX + 20 + 20, PosY);
				}
				else if (posScreen.x > 2 * stageWidth / 3)
				{
					SetAlign(ALIGN_RIGHT_BOTTOM);
					SetPos(PosX - 20 + 150, PosY);
				}
				else
				{
					SetAlign(ALIGN_CENTER_BOTTOM);
					SetPos(PosX, PosY - 20);
				}
			}
			else
			{
				if (posScreen.x < stageWidth / 2)
				{
					SetAlign(ALIGN_LEFT_CENTER);
					SetPos(PosX + 30 + 20, PosY);	
				}
				else
				{
					SetAlign(ALIGN_RIGHT_CENTER);
					SetPos(PosX - 30 + 150, PosY);
				}
			}
		}	
		public function ShowInfoSpartan(fish:FishSpartan):void
		{
			var delta_Y:int = 0;
			delta_Y = 43;
			Clear();
			LoadRes("ImgBgGUIFishInfoNew");
			// Add ten, type
			var layer:Layer;
			layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var PosX:int = fish.img.x;
			var PosY:int = fish.img.y;
			
			var growth:Number = 1;
			var food:Number = 4;
			// Tinh toan moc tang truong
			var CurrentTime:int = GameLogic.getInstance().CurServerTime;
			var EatenSpeed:int = 1;
						
			// Tên cá
			var nameF:String = GuiMgr.getInstance().GuiStore.GetNameFishSpecial(fish.NameItem);
			var name:TextField;
			var format:TextFormat = new TextFormat();
			format.color = 0x000000;
			
			// Thời gian cần phát triển nữa để cá lên level
			var kq:int = 0;
			var lb:TextField;
			var fm:TextFormat = new TextFormat;
			fm.font = "Arial";
			fm.size = 11;
			var stt:String = "Cá đã trưởng thành";
			
			// Số lần có thể hồi sinh
			var stFull:String = "Số lần có thể hồi sinh";
			
			prgGrowth = AddProgress(GUI_FISHINFO_BASE_GROWTH, "PrgTangTruong", 120, 87, null, true);
			prgFood = AddProgress(GUI_FISHINFO_BASE_FOOD, "PrgHoiSinhSparta", 120, 113, null, true);
			prgGrowth.setStatus(1);
			prgFood.setStatus(1 - fish.numReborn / fish.maxNumReborm);
			prgGrowth.scaleX = prgGrowth.scaleY = 0.8
			prgFood.scaleX = prgFood.scaleY = 0.8
			
			// Text
			format.size = 12;
			format.bold = true;
			name = AddLabel(nameF, 70, 11);
			name.setTextFormat(format);
			fm.size = 10;
			fm.bold = false;
			if (kq <= 0)
			{	
				lb = AddLabel("Cá đã trưởng thành", 114, 70);
				lb.setTextFormat(fm);
			}
			lb = AddLabel(stFull, 115, 97);
			lb.setTextFormat(fm);
			
			// label Hồi Sinh
			lb = AddLabel("Hồi Sinh", 30, 107);
			fm = new TextFormat();
			fm.font = "Arial";
			fm.size = 13;
			fm.color = 0x044954;
			fm.bold = true;
			fm.align = "left";
			lb.setTextFormat(fm);
			
			lb = AddLabel((fish.maxNumReborm - fish.numReborn).toString(), 175, 107)
			fm = new TextFormat();
			fm.size = 12;
			fm.color = 0x044954;
			fm.bold = true;
			fm.align = "left";
			lb.setTextFormat(fm);
			
			AddImage("", "ImgEXP", 36, 145);
			AddImage("", "IcGold", 136, 145);
			fm.size = 12;
			fm.bold = true;
			
			//Add money
			var price:String = fish.GetValue().toString();
			AddLabel(price, 150, 136, 0, 0).setTextFormat(fm);
			
			//Add exp
			var exp: String = fish.getExp().toString();
			AddLabel(exp, 52, 136, 0, 0).setTextFormat(fm);
			SetAlign(ALIGN_CENTER_BOTTOM);
			SetPos(PosX, PosY - 20);
			
			var option:String = "";
			var optionLabel: TextField;
			var obj: Object = fish.RateOption;
			var distance:int = 75;
			var startCon:int = 15;
			var startArrow:int = 60;
			var startIcon:int = 25;
			var startText:int = -70;
			var delta:int;
			var startY:int = 170;
			var con:Container;
			var clTran:ColorTransform = new ColorTransform();
			var numOption:int = 0;
			var numtotalOption:int = 0;
			format = new TextFormat();
			var imgTang:Image;
			
			if (!obj)  obj = new Object();
			if (!obj.Exp)	obj.Exp = 0;
			if (!obj.Time)	obj.Time = 0;
			if (!obj.Money)	obj.Money = 0;
			for (numOption = 0; numOption < 3; numOption++)
			{
				con = AddContainer("Con_EXP" + numOption, "ImgBgOption", startCon + numOption * distance, startY);
				var outLineOption:int = 0x26709C;
				var isEnable:Boolean = true;
				switch (numOption) 
				{
					//case "Exp":
					case 1:
						format.color = 0x00B7ED;
						imgTang = con.AddImage("", "IcBuffExp", 21, 12);
						option = obj.Exp + "%";
						if (obj.Exp <= 0)	isEnable = false;
					break;
					
					//case "Money":
					case 0:
						format.color = 0xE3B601;
						imgTang = con.AddImage("", "IcBuffMoney", 21, 12);
						option = obj.Money + "%";
						if (obj.Money <= 0)	isEnable = false;
					break;
					
					//case "Time":
					case 2:
						format.color = 0xE73B00;
						outLineOption = - 1;
						imgTang = con.AddImage("", "IcBuffTime", 21, 12);
						option = obj.Time + "%";
						if (obj.Time <= 0)	isEnable = false;
					break;
				}
				optionLabel = con.AddLabel(option, 40, 3, 0xFFFFFF, 0, outLineOption);
				optionLabel.multiline = true;
				optionLabel.wordWrap = true;
				optionLabel.width = 230;
				optionLabel.setTextFormat(format);
				if (!isEnable)	Ultility.SetEnableSprite(con.img, false, 0.3);
			}
				
			//var SourceFish: TextField = AddLabel("", 20, 205 + (numOption / 2) * 8 + delta_Y);
			var SourceFish: TextField = AddLabel("", 20, 205 + delta_Y);
			switch (fish.NameItem) 
			{
				case "Swat":
					SourceFish.text = "Pằng chíu .... ~.~";
				break;
				
				case "Sparta":
					SourceFish.text = "Siu nhân chém gió";
				break;
				
				case "Batman":
					SourceFish.text = "Ngủ ngày cày đêm";
				break;
				
				case "Spiderman":
					SourceFish.text = "Nhả tơ dệt vải";
				break;
				
				case "Superman":
					SourceFish.text = "Đẹp trai có gì là sai?";
				break;
			}
			
			SourceFish.multiline = true;
			SourceFish.wordWrap = true;
			SourceFish.width = 220;
			
			// Thông tin level
			format.color = "0x000000";
			lb = AddLabel("???", 30, 37);
			lb.setTextFormat(format);
			
				// Thông tin thời gian tồn tại của cá
			var timeSpartaLife:int = GameLogic.getInstance().CurServerTime - fish.StartTime;
			var timeSparta:int = fish.ExpiredTime * 3600 * 24 - timeSpartaLife;
			var daySparta:int = timeSparta / (3600 * 24);			
			var strTimeSparta:String = "Còn ";
			if (daySparta > 0)
			{
				strTimeSparta += (daySparta + 1) + " ngày hóa thạch";
			}
			else 
			{
				var hourSparta:int = int((timeSparta - daySparta * 3600 * 24) / 3600);
				var minSparta:int = int((timeSparta - int(timeSparta / 3600) * 3600) / 60);
				var secSparta:int = (timeSparta - int(timeSparta / 60) * 60);
				if(timeSparta > 0)
					strTimeSparta += hourSparta + ":" + minSparta + ":" + secSparta + " sẽ hóa thạch";
				else 
				{
					strTimeSparta = "Cá đã hóa thạch";
				}
			}
			format.color = "0x990000";
			format.italic = true;
			format.size = 11;
			lb = AddLabel(strTimeSparta, 120, 37);
			lb.setTextFormat(format);
			
			var delta_X_Slot_Material:int = 45;
			var start_X_Slot_Material:int = 12;
			var start_Y_Slot_Material:int = 202;
			
			for (var i:int = 0; i < 5; i++) 
			{
				if (fish.Material.length > i)
				{
					var imgNguThach:Image = AddImage("MaterialSlot" + i, Ultility.GetNameMatFromType(fish.Material[i]), 0, 0);
					imgNguThach.FitRect(40, 40, new Point(start_X_Slot_Material + delta_X_Slot_Material * i, start_Y_Slot_Material));
					
				}
				else 
				{
					var txtNguThach:TextField = AddLabel("Ngư thạch", start_X_Slot_Material + delta_X_Slot_Material * i + 3, start_Y_Slot_Material + 4);
					txtNguThach.wordWrap = true;
					txtNguThach.width = 40;
					txtNguThach.multiline = true;
					var txtFormat:TextFormat = new TextFormat(null, null, 0x014D83, true, null, null, null, null, "center");
					txtNguThach.setTextFormat(txtFormat);
				}
				
			}
			
			//Xét lại tọa độ cho GUI
			var stageWidth:int = LayerMgr.getInstance().GetLayer(Constant.TopLayer).stage.stageWidth;
			var stageHeight:int = LayerMgr.getInstance().GetLayer(Constant.TopLayer).stage.stageHeight;					
			
			SetPos(PosX, PosY);	
			var posScreen:Point = Ultility.PosLakeToScreen(PosX, PosY);
			
			if (posScreen.y <= stageHeight / 3)
			{
				if (posScreen.x < stageWidth / 3)
				{
					SetAlign(ALIGN_LEFT_TOP);
					SetPos(PosX + 20 + 20, PosY);
				}
				else if (posScreen.x > 2 * stageWidth / 3)
				{
					SetAlign(ALIGN_RIGHT_TOP);
					SetPos(PosX - 20 + 150, PosY);
				}
				else
				{
					SetAlign(ALIGN_CENTER_TOP);
					SetPos(PosX, PosY + 20);
				}
			}
			else if (posScreen.y > 2 * stageHeight / 3 - 100)
			{
				if (posScreen.x < stageWidth / 3)
				{
					SetAlign(ALIGN_LEFT_BOTTOM);
					SetPos(PosX + 20 + 20, PosY);
				}
				else if (posScreen.x > 2 * stageWidth / 3)
				{
					SetAlign(ALIGN_RIGHT_BOTTOM);
					SetPos(PosX - 20 + 150, PosY);
				}
				else
				{
					SetAlign(ALIGN_CENTER_BOTTOM);
					SetPos(PosX, PosY - 20);
				}
			}
			else
			{
				if (posScreen.x < stageWidth / 2)
				{
					SetAlign(ALIGN_LEFT_CENTER);
					SetPos(PosX + 30 + 20, PosY);	
				}
				else
				{
					SetAlign(ALIGN_RIGHT_CENTER);
					SetPos(PosX - 30 + 150, PosY);
				}
			}
		}		
		
		public function ShowSellInfo(fish:Fish):void
		{
			prgGrowth = AddProgress(GUI_FISHINFO_GROWTH, "PrgTangTruong", 60, 73, null, true);
		}
		
		public function GetNumStar(ItemType:String):int
		{
			switch (ItemType)
			{
				case "Draft":
					return 1;
				case "Paper":
					return 2;
				case "GoatSkin":
					return 3;
				case "Blessing":
					return 4;
			}
			return 0;
		}
		
		public function showInfoFireworkFish(fish:FireworkFish):void
		{
			// Add ten, type
			var layer:Layer;
			layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var PosX:int = fish.img.x;
			var PosY:int = fish.img.y;
			
			var food:Number = 0;
			// Highlight cá
			fish.SetHighLight();			
			
			// Tên cá
			
			var nameF:String = "Cá Sparta";
			if (fish.ImgName == "Firework")
			{
				nameF = "Cá pháo hoa";
			}
			else if(fish.ImgName == "Santa")
			{
				nameF = "Ông Cá Noel";
			}
			var name:TextField;
			var format:TextFormat = new TextFormat();
			format.color = 0x000000;
			
			// Thoi gian no con` lai
			prgGrowth = AddProgress(GUI_FISHINFO_BASE_GROWTH, "PrgTangTruong", 120, 87, null, true);
			prgFood = AddProgress(GUI_FISHINFO_BASE_FOOD, "PrgThucAn", 120, 113, null, true);
			prgGrowth.setStatus(100);
			prgFood.setStatus(100);
			prgGrowth.scaleX = prgGrowth.scaleY = 0.8
			prgFood.scaleX = prgFood.scaleY = 0.8			
			
			// Text
			format.size = 12;
			format.bold = true;
			name = AddLabel(nameF, 70, 11);
			name.setTextFormat(format);
			var lb:TextField = AddLabel("Cá đã trưởng thành", 114, 70);
			var fm:TextFormat = new TextFormat();
			fm.size = 10;
			fm.bold = false;
			lb.setTextFormat(fm);
			lb = AddLabel("Cá không bao giờ đói", 116, 95);						
			lb.setTextFormat(fm);
			lb = AddLabel("Đói", 40, 105);
			
			fm.font = "Arial";
			fm.size = 12;
			fm.color = 0x044954;
			fm.bold = true;
			fm.align = "left";
			lb.setTextFormat(fm);
			
			// Giới tính và domain của con cá
			imgSex = AddImage(GUI_FISHINFO_SEX, "IcMale", 210, 10, true, Image.ALIGN_LEFT_TOP);
				
			var domain:int = -1;
			var strDomain:String;
			var imgDomain:Image;
			if (fish.FishTypeId >= Constant.FISH_TYPE_START_DOMAIN) 
			{
				domain = (fish.FishTypeId - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
				if (domain > 0)
				{
					strDomain = Fish.DOMAIN + domain;
					imgDomain = AddImage("DomainFish", strDomain, 0, 0);
					//imgDomain.SetPos(190, 40);
					imgDomain.FitRect(30, 30, new Point(170, 12));
				}
			}
			AddImage("", "ImgEXP", 36, 145);
			AddImage("", "IcGold", 136, 145);
			fm.size = 12;
			fm.bold = true;
			
			var user:User = GameLogic.getInstance().user;
			//Add money
			var price:String;
			price = fish.GetValue().toString();
			AddLabel(price, 150, 136, 0, 0).setTextFormat(fm);
			
			//Add exp
			
			var exp: String;
			exp = fish.getExp().toString();
			AddLabel(exp, 52, 136, 0, 0).setTextFormat(fm);			
			
			SetAlign(ALIGN_CENTER_BOTTOM);
			SetPos(PosX, PosY - 20);
		
			var option:String = "";
			var optionLabel: TextField;
			var obj: Object;
			var s: String;
			
			format = new TextFormat();
			// Thông tin tăng option
			obj = fish.RateOption;
			var numOption:int = 0;
			var numtotalOption:int = 0;
			for (s in obj)
			{
				numtotalOption++;
			}
			for (s in obj)
			{
				if (obj[s] > 0) 
				{
					option = obj[s] + "%";
						
					var distance:int = 216 / numtotalOption - 15 * (3 - numtotalOption);
					var startCon:int = 15;
					var startArrow:int = 60;
					var startIcon:int = 25;
					var startText:int = -70;
					var delta:int = (3 - numtotalOption) * 36;
					var startY:int = 170;
					var con:Container;
					var clTran:ColorTransform = new ColorTransform();
					
					
					var imgTang:Image;
					format = new TextFormat();
					format.size = 14;
					format.bold = true;
					format.align = "center";
					
					con = AddContainer("Con_EXP", "ImgBgOption", delta + startCon + numOption * distance, startY);
					imgTang = con.AddImage("", "IcBuff" + s, 21, 12);
					var outLineOption:int = 0x26709C;
					switch (s) 
					{
						case "Exp":
							format.color = 0x00B7ED;
						break;
						
						case "Money":
							format.color = 0xE3B601;
						break;
						
						case "Time":
							format.color = 0xE73B00;
							outLineOption = - 1;
						break;
					}
					optionLabel = con.AddLabel(option, -65, 3, 0xFFFFFF, 0, outLineOption);
					
					
					optionLabel.multiline = true;
					optionLabel.wordWrap = true;
					optionLabel.width = 230;
					
					optionLabel.setTextFormat(format);
				}
				numOption++;
				
			}
			
			var txtNote:String;
			if (fish.ImgName == "Firework")
			{
				txtNote = "5 tiếng tặng ngẫu nhiên ngọc.";
			}
			else if(fish.ImgName == "Santa")
			{
				txtNote = "5 tiếng tặng ngẫu nhiên tất noel.";
			}
			var SourceFish: TextField = AddLabel(txtNote, 20, 205);
			SourceFish.multiline = true;
			SourceFish.wordWrap = true;
			SourceFish.width = 220;
				
			format.color = "0x000000";
			lb = AddLabel("???", 30, 32);
			lb.setTextFormat(format);
			
			// Thông tin thời gian tồn tại của cá
			var timeSpartaLife:int = GameLogic.getInstance().CurServerTime - fish.bornTime;
			var timeSparta:int = fish.deadTime - timeSpartaLife;
			var daySparta:int = timeSparta / (3600 * 24);			
			var strTimeSparta:String = "Còn ";
			if (daySparta > 0)
			{
				strTimeSparta += (daySparta + 1) + " ngày hết hạn";
			}
			else 
			{
				var hourSparta:int = int((timeSparta - daySparta * 3600 * 24) / 3600);
				var minSparta:int = int((timeSparta - int(timeSparta / 3600) * 3600) / 60);
				var secSparta:int = (timeSparta - int(timeSparta / 60) * 60);
				if(timeSparta > 0)
					strTimeSparta += hourSparta + ":" + minSparta + ":" + secSparta + " sẽ hết hạn";
				else 
				{
					strTimeSparta = "Cá đã hết hạn";
				}
			}
			format.color = "0x990000";
			format.italic = true;
			format.size = 11;
			lb = AddLabel(strTimeSparta, 120, 37);
			lb.setTextFormat(format);
			
			
			
			
			//Xét lại tọa độ cho GUI
			var stageWidth:int = LayerMgr.getInstance().GetLayer(Constant.TopLayer).stage.stageWidth;
			var stageHeight:int = LayerMgr.getInstance().GetLayer(Constant.TopLayer).stage.stageHeight;					
			
			SetPos(PosX, PosY);	
			var posScreen:Point = Ultility.PosLakeToScreen(PosX, PosY);
			
			if (posScreen.y <= stageHeight / 3)
			{
				if (posScreen.x < stageWidth / 3)
				{
					SetAlign(ALIGN_LEFT_TOP);
					SetPos(PosX + 20, PosY);
				}
				else if (posScreen.x > 2 * stageWidth / 3)
				{
					SetAlign(ALIGN_RIGHT_TOP);
					SetPos(PosX - 20, PosY);
				}
				else
				{
					SetAlign(ALIGN_CENTER_TOP);
					SetPos(PosX, PosY + 20);
				}
			}
			else if (posScreen.y > 2 * stageHeight / 3 - 100)
			{
				if (posScreen.x < stageWidth / 3)
				{
					SetAlign(ALIGN_LEFT_BOTTOM);
					SetPos(PosX + 20, PosY);
				}
				else if (posScreen.x > 2 * stageWidth / 3)
				{
					SetAlign(ALIGN_RIGHT_BOTTOM);
					SetPos(PosX - 20, PosY);
				}
				else
				{
					SetAlign(ALIGN_CENTER_BOTTOM);
					SetPos(PosX, PosY - 20);
				}
			}
			else
			{
				if (posScreen.x < stageWidth / 2)
				{
					SetAlign(ALIGN_LEFT_CENTER);
					SetPos(PosX +50, PosY);	
				}
				else
				{
					SetAlign(ALIGN_RIGHT_CENTER);
					SetPos(PosX + 50, PosY);
				}
			}
		}
	}
}