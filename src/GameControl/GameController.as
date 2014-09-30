package GameControl
{
	import Data.Config;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.Rippler;
	import Event.EventMgr;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import GUI.*;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.ChampionLeague.LogicLeague.LeagueInterface;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.EventMagicPotions.BossHerb;
	import GUI.GUIFrontScreen.GUIFrontScreen;
	import Logic.*;
	import NetworkPacket.PacketSend.SendBuyFish;
	import NetworkPacket.PacketSend.SendFishing;
	import NetworkPacket.PacketSend.SendGetAllSoldier;
	import NetworkPacket.PacketSend.SendGetSeriesQuest;
	import NetworkPacket.PacketSend.SendInitRun;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import NetworkPacket.PacketSend.SendLoadInventorySoldier;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class GameController
	{
		static public const GAME_MODE_HOME:String = "gameModeHome";
		static public const GAME_MODE_BOSS_SERVER:String = "gameModeBossServer";
		private static var instance:GameController = new GameController;
		
		public var ScreenWidth:int = 810;
		public var ScreenHeight:int = 624;
		
		public var ActiveObj:BaseObject = null;
		
		/**
		 * = -1 là đang ở trong game
		 * = index của đại dương tương ứng
		 */
		public var typeFishWorld:int = -1;
		public var BgLake:Image = null;
		public var BgSky:Image = null;
		//public var BgLake:Sprite = new Sprite();
		//public var BgSky:Sprite = new Sprite();
		public var BgWave:Sprite = null;
		public var NextUseTool:String = "";
		
		//public var imgBackground:Image = null;
		
		// Khoảng bay của cá lính nhà mình
		public var MySoldierRectangle:Rectangle; // = new Rectangle(Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2, GameController.getInstance().GetLakeTop() + 30, Main.imgRoot.stage.width / 2 - 100, Constant.HEIGHT_LAKE - 80);
		// Khoảng bay của cá lính nhà bạn
		public var TheirSoldierRectangle:Rectangle; // = new Rectangle(Constant.MAX_WIDTH / 2, GameController.getInstance().GetLakeTop() + 30, 280, Constant.HEIGHT_LAKE - 80);		
		// Khoảng bay của cá nông dân nhà bạn (ofcourse)
		public var TheirFishRectangle:Rectangle; // = new Rectangle(Constant.MAX_WIDTH / 2 + 200, GameController.getInstance().GetLakeTop() + 30, Main.imgRoot.stage.width / 2 - 200, Constant.HEIGHT_LAKE - 80);			
		// Khoảng bay của cá nông dân nhà mình
		public var MyFishRectangle:Rectangle;
		// Khoảng bay lúc tự do
		public var DefaultRectangle:Rectangle; // = new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80);
		
		public var theirSoldierPos:Array = new Array();
		public var mySoldierPos:Array = new Array();
		
		//For shakeScreen
		private var amp:Number;
		private var shakeNum:int = 0;	
		private var shakeMilestone:Number = 0;
		private var shakeSign:int = -1;
		private var shakeSpeed:Number = 0;
		private var isX:Boolean = false;
		
		//For shakeObject
		private var ampArr:Array = [];
		private var shakeNumArr:Array = [];	
		private var shakeMilestoneArr:Array = [];
		private var shakeSignArr:Array = [];
		private var shakeSpeedArr:Array = [];
		private var isXArr:Array = [];
		private var imgShakeArr:Array = [];
		private var curPosArr:Array = [];
		
		//Chế độ background bé
		private var _isSmallBackGround:Boolean = false;
		private var fog:Sprite;
		public var blackHole:Image;
		public var finishEffFishing:Boolean = false;
		public var isFishing:Boolean = false;
		
		public var gameMode:String;
		
		/**
		 * Lấy một thể hiện chung của lớp GameLogic
		 * <br>Thể hiện này mang tính chất gần như 1 biến toàn cục </br>
		 */
		public static function getInstance():GameController
		{
			if(instance == null)
			{
				instance = new GameController();
			}
				
			return instance;
		}
		
		public function GameController() 
		{
			
		}
		
		
		public function clearBackGround():void
		{
			if (BgLake != null)
			{
				var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
				if (BgLake && BgLake.img)
				{
					if (layer.contains(BgLake.img))
					{
						layer.removeChild(BgLake.img);
					}
				}
				if (BgSky && BgSky.img)
				{
					if (layer.contains(BgSky.img))
					{
						layer.removeChild(BgSky.img);
					}
				}
				if (BgWave)
				{
					if (BgWave && layer.contains(BgWave))
					{
						layer.removeChild(BgWave);
					}
				}
				if(BgLake)	BgLake.Destructor();
				if(BgSky)	BgSky.Destructor();
				BgLake = null;
				BgSky = null;
				BgWave = null;
			}
		}
		
		/**
		 * Swap background hiện tại bằng background mới
		 * @param	itemIdBgr
		 */
		public function changeBackGround(itemIdBgr:int, isMyFish:Boolean = true):void
		{
			/*if (itemIdBgr > 100)
			{
				GameController.getInstance().isSmallBackGround = true;
			}
			else
			{
				GameController.getInstance().isSmallBackGround = false;
			}*/
			GameController.getInstance().isSmallBackGround = Config.getInstance().isSmallBackGround(itemIdBgr);
			if(!GameController.getInstance().isSmallBackGround)
			{
				SetBackground(itemIdBgr);
			}
			else
			{
				setSmallBackground(itemIdBgr);
			}
			
			//Update lại độ bẩn của hồ
			if(isMyFish && GameLogic.getInstance().user.CurLake != null)
			{
				var nDirty:int = GameLogic.getInstance().user.CurLake.GetDirtyAmount();
				GameController.getInstance().SetLakeBright(0.5 + 0.5 * (1 - nDirty / Lake.MAX_DIRTY));
			}
		}
		
		/**
		 * Thiết lập background
		 * @param	imgLake tên content hồ
		 */
		public function SetBackground(itemIdBgr:int, hasSky:Boolean = true, hasLake:Boolean = true, hasWave:Boolean = true):void
		{
			clearBackGround();
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
			
			if (hasLake)
			{
				BgLake = new Image(layer, "BgLake" + itemIdBgr);
				//BgLake.SetPos( -10, 340); 
				//BgLake.SetPos(0, 200); 
				if(GameController.getInstance().typeFishWorld == Constant.TYPE_MYFISH)
				{
					BgLake.SetPos(0, 296); 
				}
				else 
				{
					BgLake.SetPos(0, 146); 
				}
				BgLake.img.mouseChildren = false;
			}
			
			// sky
			if (hasSky)
			{
				BgSky = new Image(layer, "BgSky" + itemIdBgr);
				//BgSky.SetPos(0, 60);
				BgSky.SetPos(0, 5);
				BgSky.img.mouseChildren = false;
			}
			
			
			if (hasWave)
			{
				BgWave = ResMgr.getInstance().GetRes("BgWave" + itemIdBgr) as Sprite;
				if (BgWave)
				{
					layer.addChild(BgWave);
					//BgLake.img.mask = BgWave;
					BgWave.x = 0;
					BgWave.y = BgLake.img.y + 1;
					BgWave.cacheAsBitmap = true;
				}
			}
			
			//Constant.MAX_WIDTH = layer.width;
			//Constant.MAX_HEIGHT = layer.height;
			//PanScreenX( -(Constant.MAX_WIDTH - Constant.STAGE_WIDTH)/2);
			//PanScreenY( -(Constant.MAX_HEIGHT - Constant.STAGE_HEIGHT)/2 - 100);
			// test
			//var i:int;
			//for (i = 0; i < 10; i++)
			//{
				//LightMgr.getInstance().AddLight(LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER), 100 + i*150, 300, 90, 280);
			//}
		}
		
		public function setSmallBackground(itemIdBgr:int):void
		{
			clearBackGround();
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
			
			BgLake = new Image(layer, "BgLake" + itemIdBgr);
			BgLake.SetPos(275, 138); 
			BgLake.img.mouseChildren = false;
			isSmallBackGround = true;
			if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE) 
			{
				LeagueInterface.getInstance().onLoadBackGroundComplete();
			}
			
		}
		
		public function LockViewerUser():void
		{
			var IsViewer:Boolean = GameLogic.getInstance().user.IsViewer();
			GuiMgr.getInstance().GuiMain.EnableButtons(!IsViewer);		
		}
		
		public function SetLakeBright(ratio:Number):void
		{
			return;
			var c:ColorTransform = new ColorTransform(0.4+ 0.6*ratio, 0.7+ 0.3*ratio, 0.5+ 0.5*ratio, 1);
			if (BgLake.img != null)
			{
				BgLake.img.transform.colorTransform = c;
			}
			//BgLake.transform.colorTransform = c;
			if(BgWave)
				BgWave.transform.colorTransform = c;
		}
		
		public function SetActiveObject(obj:BaseObject):void
		{
			ActiveObj = obj;
		}
		
		public function UpdateDecoPos(deco:Decorate, px:int, py:int, mx:int, my:int):void
		{
			
			var height:int = deco.img.height;
			if (deco.ClassName == "FishSpartan")
			{
				deco = deco as FishSpartan;
				height -= 90;
			}
			var x:int = px;
			var y:int = py + height / 2;
			
			var r:Rectangle = GetDecorateArea();
			deco.SetPos(x, y);
			if (!deco.CheckPosition())
			{
				// hien thi ko the di chuyen
				if (!GuiMgr.getInstance().GuiStore.IsPointInGUI(mx, my))
				{
					deco.ShowDisable(true);
					//trace("sua ham");
				}
				else
				{
					if(deco.ClassName=="Decorate")
						deco.ShowDisable(false);
					else if (deco.ClassName == "FishSpartan")//nếu di chuyển vào trong kho với cá Spartan
					{
						deco.ShowDisable(true);
						//deco.UnMovePos();
					}
					trace("ko sua ham");
				}
			}
			else
			{
				//trace("dang updatedeep cho spartan");
				deco.UpdateDeep();
			}
			if(deco.ClassName=="Decorate")
				GuiMgr.getInstance().GuiDecorateInfo.Hide();
		}
		
		public function UpdateActiveObjPos(mx:int, my:int):void
		{
			if (ActiveObj != null)
			{
				var x:int = mx;
				var y:int = my;
				
				var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
				if (layer != null)
				{
					switch(GameLogic.getInstance().gameState)
					{
						case GameState.GAMESTATE_BUY_DECORATE:
						case GameState.GAMESTATE_USE_DECORATE:
						//case GameState.GAMESTATE_MOVE_DECORATE:
						case GameState.GAMESTATE_EDIT_DECORATE:
						{
							var deco:Decorate = ActiveObj as Decorate;
							if (deco == null)
							{
								break;
							}
							var r:Rectangle = GetDecorateArea();
							if (x > Constant.MAX_WIDTH - 20)
							{
								x = Constant.MAX_WIDTH - 20;
							}
							if (x < 20)
							{
								x = 20;
							}
							if (r.top >  my + deco.img.height)
							{
								y = r.top;
								deco.SetDeep(1);
							}
							else if(r.bottom < my + deco.img.height) 
							{
								y = r.bottom;
								deco.SetDeep(0);
							}
							else
							{
								y = my + deco.img.height;
								deco.SetDeep(1-(my + deco.img.height - r.top) / (r.height));
							}
							deco.SetPos(x, y);
							UpdateDecorateChildIndex(deco);
							GuiMgr.getInstance().GuiDecorateInfo.Hide();
						}
						break;
						
						case GameState.GAMESTATE_BUY_FISH:
							ActiveObj.SetPos(x, y);
							break;
						case GameState.GAMESTATE_FEED_FISH:
							ActiveObj.SetPos(x, y);
							break;
						case GameState.GAMESTATE_SELL_FISH:
							ActiveObj.SetPos(x, y);
							break;
						case GameState.GAMESTATE_CURE_FISH:
							//ActiveObj.SetPos(x, y);
							break;
						case GameState.GAMESTATE_INIT:;
						case GameState.GAMESTATE_IDLE:
							ActiveObj.SetPos(x, y);
							break;
						default:
							ActiveObj.SetPos(x, y);
							break;
					}					
				}				
			}
		}
		
		public function ArrangeAllDecorateChildIndex():void			//gồm có cả đồ trang trí
		{
			var i:int, j:int;
			var deco1:Decorate;
			var deco2:Decorate;
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var decoArr:Array = GameLogic.getInstance().user.GetDecoArr();
			//var fossilArr:Array = GameLogic.getInstance().user.FishArrSpartanDeactive;
			var r:Rectangle = GetDecorateArea();
			
			for (i = 0; i < decoArr.length; i++)
			{
				for (j = i + 1; j < decoArr.length; j++)
				{
					deco1 = decoArr[i] as Decorate;
					deco2 = decoArr[j] as Decorate;
					var v1:int = layer.getChildIndex(deco1.img);
					var v2:int = layer.getChildIndex(deco2.img);
					if ((deco1.Deep < deco2.Deep) && (v1 < v2))
					{
						layer.swapChildren(deco1.img, deco2.img);
						decoArr[i] = deco2;
						decoArr[j] = deco1;
					}
				}
			}
			
			for (i = 0; i < decoArr.length; i++)
			{
				var deco:Decorate = decoArr[i] as Decorate;
				deco.UpdateDeep();
			}
		}
		
		
		
		public function UpdateDecorateChildIndex(obj:Decorate):void
		{
			var i:int, j:int;
			var subObj:int, subDeco:int;
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var deco:Decorate;
			var decoArr:Array = GameLogic.getInstance().user.GetDecoArr();
			var fossilArr:Array = GameLogic.getInstance().user.FishArrSpartanDeactive;
			var total:Array = new Array();
			for (i = 0; i < decoArr.length; i++)
				total.push(decoArr[i]);
			for (i = 0; i < fossilArr.length; i++)
				total.push(fossilArr[i]);
			trace("Sap xep lai layer cho deco");
			// thay lai layer cho deco
			if (obj.ClassName == "Decorate")
			{
				obj = obj as Decorate;
				subObj = 0;
			}
			else if (obj.ClassName == "FishSpartan")
			{
				obj = obj as FishSpartan;
				subObj = 60;
			}
			obj.ChangeLayer(Constant.OBJECT_LAYER);
			
			for (i = 0; i < total.length; i++)
			{
				
				if (total[i].ClassName == "Decorate")
				{
					deco = total[i] as Decorate;
					subDeco = 0;
				}
				else if (total[i].ClassName == "FishSpartan")
				{
					deco = total[i] as FishSpartan;
					subDeco = 60;
				}
				if (obj.img.hitTestObject(deco.img))
				{
					var vt2:int = layer.getChildIndex(deco.img);
					var vt1:int = layer.getChildIndex(obj.img);
					var y1:int = obj.CurPos.y + subObj;
					var y2:int = deco.CurPos.y + subDeco;
					if ((y1 < y2) && (vt1 > vt2))
					{
						layer.setChildIndex(obj.img, vt2);
						/*
						trace("fish Spartan hoa thach dung sau" + "\nsubObj: " + subObj + "\nsubDeco: " + subDeco 
								+ "\nvt1: " + vt1
								+ "\nvt2: " + vt2
								+ "\ny1: " + y1
								+ "\ny2: " + y2);*/
					}
					
					if ((y1 > y2) && (vt1 < vt2))
					{
						layer.setChildIndex(obj.img, vt2);
						trace("fish Spartan hoa thach dung truoc");
					}
				}
			}
		}
		
		public function UpdateFishChildIndex(obj:Fish):void
		{
			var i:int, j:int;
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			var deco:Decorate;
			var decoArr:Array = GameLogic.getInstance().user.GetDecoArr();
			var hitArea:Sprite = obj.GetMoveArea();
			var MaxChildIndex:int = -1;
			var MaxDeep:int = 0;
			
			for (i = 0; i < decoArr.length; i++)
			{
				deco = decoArr[i] as Decorate;
				if (deco.img.hitTestObject(hitArea))
				{
					var index:int = layer.getChildIndex(deco.img);
					if (index > MaxChildIndex)
					{
						MaxChildIndex = index;
						MaxDeep = deco.Deep;
					}
				}
			}
			
			if (MaxChildIndex >= 0)
			{
				if(obj.img != null && obj.img.parent != null)
				{
					layer.setChildIndex(obj.img, MaxChildIndex);
				}
				//obj.SetDeep(MaxDeep);
			}
		}
		
		public function GetLakeTop():int
		{
			//return (GetLakeBottom() - Constant.HEIGHT_LAKE);
			//return BgLake.img.y;
			if (Ultility.IsInMyFish()) {
				if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE)
				{
					return Constant.TOP_LAKE_LEAGUE;
				}
				return Constant.TOP_LAKE;
			}
			else 	return Constant.TOP_LAKE_FISH_WORLD;
			//return BgSky.img.height;
			//return BgLake.y;
		}
		
		public function GetLakeBottom():int
		{
			//return BgLake.img.y + Constant.HEIGHT_LAKE;
			//if(!GuiMgr.IsFullScreen)
			if (Ultility.IsInMyFish()) {
				if (LeagueController.getInstance().mode == LeagueController.IN_LEAGUE) {
					return GetLakeTop() + Constant.HEIGHT_LAKE_LEAGUE;
				}
				return GetLakeTop() + Constant.HEIGHT_LAKE;
			}
			else	return GetLakeTop() + Constant.HEIGHT_LAKE_FISH_WORLD;
			//return Ultility.PosScreenToLake(GuiMgr.getInstance().GuiMainFishWorld.CurPos.x, GuiMgr.getInstance().GuiMainFishWorld.CurPos.y).y;
		}
		
		public function GetDecorateArea():Rectangle
		{
			var pt:Point = GuiMgr.getInstance().GuiMain.GetPosition();
			pt.y = GetLakeBottom()+5;
			var AreaHeight:int = 90;
			
			var a:Rectangle = new Rectangle(0, pt.y - AreaHeight, Constant.MAX_WIDTH, AreaHeight);
			// dich chuyen theo kich thuoc man hinh
		
			/*var area:Sprite = new Sprite();
			area.graphics.lineStyle(1);
			area.graphics.moveTo(a.left, a.top);
			area.graphics.lineTo(a.right, a.top);				
			area.graphics.lineTo(a.right, a.bottom);
			area.graphics.lineTo(a.left , a.bottom);
			area.graphics.lineTo(a.left, a.top);
			BackGround.img.stage.addChild(area);*/

			return a;
		}
		
		public function ClickOnActiveObj(x:int, y:int):void
		{
			//can check xem vi tri tha co nam trong be khong
			var rect:Rectangle = new Rectangle(100, 100, 200, 200);
			var fishArr:Array = GameLogic.getInstance().user.GetFishArr(); 
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			
			if (ActiveObj != null)
			{
				switch (GameLogic.getInstance().gameState)
				{
					//case GameState.GAMESTATE_USE_DECORATE:
						//GameLogic.getInstance().UseDecorate(ActiveObj as Decorate);
						//break;
					case GameState.GAMESTATE_BUY_DECORATE:
						var deco:Decorate = ActiveObj as Decorate;
						if (GameLogic.getInstance().BuyDecorate(deco))
						{
							//GuiMgr.getInstance().GuiBuyShop.BuyDecorate(deco.ItemId, deco.ItemType);
							GuiMgr.getInstance().GuiShop.BuyDecorate(deco.ItemId, deco.ItemType);
						}
						break;
					
					case GameState.GAMESTATE_BUY_FISH:
						var fish:Fish = ActiveObj as Fish;
						GameLogic.getInstance().BuyFish(fish);
						break;
					
					case GameState.GAMESTATE_CURE_FISH:
						break;
						
					case GameState.GAMESTATE_FEED_FISH:
						//var pos:Point = GuiMgr.getInstance().GuiCharacter.GetPosAvatar();
						// Play sound
						//var sound:Sound = SoundMgr.getInstance().getSound("ChoCaAn") as Sound;
						//if (sound != null)
						//{
							//sound.play();
						//}
						//DropFood(pos.x + 45, pos.y);
						break;
					
					//case GameState.GAMESTATE_MOVE_DECORATE:
						//GameLogic.getInstance().MoveDecorate(ActiveObj as Decorate);
					//	break;

				}
			}
		}
		
		public function DropFood(x:int, y:int):void
		{
			if (GameLogic.getInstance().user.GetFoodCount() < 5)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOkShop("Bạn đã hết thức ăn", 310, 180);
				GameLogic.getInstance().BackToIdleGameState();
				return;
			}
			//var temp:int = INI.getInstance().getEnergyInfo("feed");
			var temp:int = ConfigJSON.getInstance().getEnergyInfo("feed");
			if (GameLogic.getInstance().user.GetEnergy() < temp)
			{
				//var st:String = Localization.getInstance().getString("Message4");
				//GuiMgr.getInstance().GuiMessageBox.ShowOK(st);
				GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 3);
				//GameLogic.getInstance().BackToIdleGameState();
				return;
			}
			
			//Avatar rắc thức ăn
			//if(!GameController.getInstance().isSmallBackGround)
			//{
				//GuiMgr.getInstance().GuiCharacter.PlayAni(GUICharacter.ANI_FEED);		
			//}
			
			var i:int = 0;
			var FoodArr:Array = GameLogic.getInstance().user.GetFoodArr();
			//var ListFood:Array = GameLogic.getInstance().ListFood;
			var f:Array = [];
			for (i = 0; i < 5; i++ )
			{
				var food:Food = new Food(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "Food");
				food.img.scaleX = food.img.scaleY = 0.7;
				if (y < GetLakeTop() )
				{
					y = Ultility.RandomNumber(GetLakeTop() - 30, GetLakeTop());
				}
				food.SetPos(Ultility.RandomNumber(x - 70, x + 70), y);
				food.nextDes();
				//food.MoveTo(food.CurPos.x, GuiMgr.getInstance().GuiMain.img.y + Ultility.RandomNumber( -60, -5), Ultility.RandomNumber(2, 4));
				FoodArr.push(food);	
				f.push(food);
			}
			GameLogic.getInstance().user.UpdateFoodCount( -5);
			//trừ năng lượng
			//if (GameLogic.getInstance().user.IsViewer())
			{				
				GameLogic.getInstance().user.UpdateEnergy( -temp);
			}
			
			GameLogic.getInstance().ListFood.push(f);
		
			
			GuiMgr.getInstance().GuiMain.UpdateInfo();
		}
		
		
		public function StartMoveDecorate():void
		{
			//var decoArr:Array = GameLogic.getInstance().user.GetDecoArr();
			//decoArr.splice(decoArr.indexOf(ActiveObj), 1);
			
			//GuiMgr.getInstance().GuiDecorateInfo.Hide();
			//GameLogic.getInstance().gameState = GameState.GAMESTATE_MOVE_DECORATE;
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			if (layer != null)
			{
				layer.ShowDisableScreen(0.01);
			}
		}
		
		
		public function PanScreenX(dis:int, maxX:int = 0):void
		{
			if (maxX < Constant.MAX_WIDTH)
			{
				maxX = Constant.MAX_WIDTH;
			}
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
			var x:int = layer.x;
			var tg:int = x + dis;
			var dt:int = dis;
			if (tg > 0)
			{
				dt = 0 - x;
			}
			if (tg < Constant.STAGE_WIDTH - layer.width)
			{
				dt = Constant.STAGE_WIDTH - layer.width - x;
			}
			
			LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).PanX(dt);
			LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).PanX(dt);
			LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).PanX(dt);
			LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER).PanX(dt);
			LayerMgr.getInstance().GetLayer(Constant.ACTIVE_LAYER).PanX(dt);
			if (GuiMgr.getInstance().GuiDecorateInfo.IsVisible)
			{
				GuiMgr.getInstance().GuiDecorateInfo.Hide();
			}
		}
		
		public function PanScreenY(dis:int, maxY:int = 762):void
		{
			if (maxY < Constant.MAX_HEIGHT)
			{
				maxY = Constant.MAX_HEIGHT;
			}
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
			var y:int = layer.y;
			var tg:int = y + dis;
			var dt:int = dis;
			if (tg > 0)
			{
				dt = 0 - y;
			}
			if (tg < Constant.STAGE_HEIGHT - layer.height)
			{
				dt = Constant.STAGE_HEIGHT - layer.height - y;
			}
			LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).PanY(dt);
			LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).PanY(dt);
			LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).PanY(dt);
			LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER).PanY(dt);
			LayerMgr.getInstance().GetLayer(Constant.ACTIVE_LAYER).PanY(dt);
		}
		
		/**
		 * Thiết lập các thông số cho việc rung màn hình
		 * @param	Amp			Biên độ rung
		 * @param	ShakeNum	Số lần rung
		 * @param	ShakeSpeed	Tốc độ rung (pixel/frame)
		 * @param	IsX			= true thì rung theo phương X, = false thì rung theo phương Y
		 */
		public function shakeScreen(Amp:Number, ShakeNum:int, ShakeSpeed:Number, IsX:Boolean = false):void
		{
			amp = Amp;
			shakeNum = ShakeNum;
			shakeMilestone = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).y;
			shakeSign = -1;
			shakeSpeed = ShakeSpeed;
			isX = IsX;
		}
		
		/**
		 * Thiết lập các thông số cho việc rung màn hình
		 * @param	Amp			Biên độ rung
		 * @param	ShakeNum	Số lần rung
		 * @param	ShakeSpeed	Tốc độ rung (pixel/frame)
		 * @param	IsX			= true thì rung theo phương X, = false thì rung theo phương Y
		 */
		public function shakeObj(ImgShakeObj:Sprite, CurPosObj:Point, AmpObj:Number, ShakeNumObj:int, ShakeSpeedObj:Number, IsXObj:Boolean = false):void
		{
			ampArr.push(AmpObj);
			shakeNumArr.push(ShakeNumObj);
			shakeMilestoneArr.push(ImgShakeObj.y);
			imgShakeArr.push(ImgShakeObj);
			shakeSignArr.push(-1);
			shakeSpeedArr.push(ShakeSpeedObj);
			isXArr.push(IsXObj);
			curPosArr.push(CurPosObj);
		}
		
		/**
		 * Cập nhật rung màn hình
		 */
		public function updateShakeScreen():void
		{
			if (shakeNum > 0)
			{
				var y:Number = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).y;
				if (y <= shakeMilestone - amp)
				{
					shakeSign = 1;					
				}
				else if (y >= shakeMilestone + amp)
				{
					shakeSign = -1;
					shakeNum--;
				}			
					
				var dis:int = shakeSign * shakeSpeed;
				if (!isX)
				{
					LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).PanY(dis);
					LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).PanY(dis);
					LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).PanY(dis);
					LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER).PanY(dis);
					LayerMgr.getInstance().GetLayer(Constant.ACTIVE_LAYER).PanY(dis);
				}
				else
				{
					LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).PanX(dis);
					LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).PanX(dis);
					LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER).PanX(dis);
					LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER).PanX(dis);
					LayerMgr.getInstance().GetLayer(Constant.ACTIVE_LAYER).PanX(dis);
				}
			}						
		}
		
		/**
		 * Cập nhật rung màn hình
		 */
		public function updateShakeObject():void
		{
			for (var i:int = 0; i < shakeNumArr.length; i++) 
			{
				var ampObj:Number = ampArr[i];
				var shakeNumObj:int = shakeNumArr[i];	
				var shakeMilestoneObj:Number = shakeMilestoneArr[i];
				var shakeSignObj:int = shakeSignArr[i];
				var shakeSpeedObj:Number = shakeSpeedArr[i];
				var isXObj:Boolean = isXArr[i];
				var imgShakeObj:Sprite = imgShakeArr[i];
				var curPosObj:Point = curPosArr[i];
				if (shakeNumObj > 0)
				{
					var y:Number = imgShakeObj.y;
					if (y <= shakeMilestoneObj - ampObj)
					{
						shakeSignObj = 1;					
					}
					else if (y >= shakeMilestoneObj + ampObj)
					{
						shakeSignObj = -1;
						shakeNumObj--;
						shakeNumArr[i] = shakeNumObj;
						if (shakeNumObj <= 0)
						{
							ampArr.splice(i, 1);
							shakeNumArr.splice(i, 1);
							shakeMilestoneArr.splice(i, 1);
							shakeSignArr.splice(i, 1);
							shakeSpeedArr.splice(i, 1);
							isXArr.splice(i, 1);
							imgShakeArr.splice(i, 1);
							curPosArr.splice(i, 1);
							i--;
						}
					}			
						
					var dis:int = shakeSignObj * shakeSpeedObj;
					var posDesObj:Point = new Point();
					if (!isXObj)
					{
						imgShakeObj.y = curPosObj.y + dis;
					}
					else
					{
						imgShakeObj.x = curPosObj.x + dis;
					}
				}				
			}		
		}
		
		// Use Functions in game
		public function UseTool(cmd:String):void
		{
			var Params:Array = cmd.split("_");
			var Tool:String = Params[0];
			
			if (Tool == "CleanLake")
			{
				UseToolCleanLake();
				return;
			}
			
			NextUseTool = "";
			if (GameLogic.getInstance().gameState == GameState.GAMESTATE_EDIT_DECORATE)
			{
				NextUseTool = cmd;
				if (NextUseTool == "EditDecorate")
				{
					NextUseTool ="";
				}
				GameLogic.getInstance().BackToIdleGameState();
				return;
			}
			
			switch (Tool)
			{
				case "FeedFish":
					UseToolFeedFish();
					break;
				case "SellFish":
					UseToolSellFish();
					break;
				case "CureFish":
					UseToolCureFish();
					break;
				case "Fishing":
					UseToolFishing();
					break;		
				case "War":
					UseToolFishWar(true);
					break;
				case "Peace":
					UseToolFishWar(false);
					break;
				case "RapeBoss":
					UserToolRapeBossAtHome();
					break;
				case "ByeByeBoss":
					UserToolRapeBossAtHome(false);
					break;
				case "EditDecorate":
					UseToolEditDecorate();
					break;
				case "GoToLake":
					GameLogic.getInstance().DoGoToLake(Params[1], Params[2]);
					break;
				case "Home":
					if (GameLogic.getInstance().user.IsViewer())
					{
						GameLogic.getInstance().DoGoToLake(1, GameLogic.getInstance().user.GetMyInfo().Id);			
						GuiMgr.getInstance().GuiFriends.CheckBorder(GameLogic.getInstance().user.GetMyInfo().Id);
					}
					break;
					
				// dung chuc nang khac
				case "Shop":
					if (!GuiMgr.getInstance().GuiShop.IsVisible)
					{				
						GuiMgr.getInstance().GuiShop.Show(Constant.GUI_MIN_LAYER, 6);
					}
					else
					{						
						GuiMgr.getInstance().GuiShop.Hide();
					}
					break;
					
				case "Inventory":
					if (!GuiMgr.getInstance().GuiInvetory.IsVisible)
					{
						GuiMgr.getInstance().GuiStore.Show();
						GuiMgr.getInstance().GuiStore.CurrentStore = Params[1];
						GuiMgr.getInstance().GuiStore.CurrentPage = Params[2];
						var pk1:SendLoadInventory = new SendLoadInventory();
						Exchange.GetInstance().Send(pk1);
					}
					else
					{
						GuiMgr.getInstance().GuiStore.Hide();
					}
					break;
				
				case "InventorySoldier":
					if (GuiMgr.getInstance().GuiFriends.IsVisible)
					{
						GuiMgr.getInstance().GuiFriends.HideFriend();
					}
					GuiMgr.getInstance().GuiStoreSoldier.Show();
					GuiMgr.getInstance().GuiStoreSoldier.CurrentStore = Params[1];
					GuiMgr.getInstance().GuiStoreSoldier.CurrentPage = Params[2];
					var pk:SendLoadInventorySoldier = new SendLoadInventorySoldier();
					Exchange.GetInstance().Send(pk);
					break;
				case "Gift":
					GuiMgr.getInstance().GuiReceiveGift.Show(Constant.GUI_MIN_LAYER, 3);					
					break;
				case "Letter":
					GuiMgr.getInstance().GuiNewMail.Show(Constant.GUI_MIN_LAYER, 3);
					break;
				default:
					break;
			}
		}
		
		public function UseToolSeriQuest(idSeri:int):void
		{
			if (GuiMgr.getInstance().guiMainQuest.IsVisible == false)
			{
				var cmd1:SendGetSeriesQuest = new SendGetSeriesQuest();
				cmd1.IsInitRun = false;
				cmd1.IdSeriQuest = idSeri;
				Exchange.GetInstance().Send(cmd1);
				var quest:QuestInfo = QuestMgr.getInstance().GetSeriesQuest(idSeri);
				GuiMgr.getInstance().guiMainQuest.showGUI(quest);
			}
		}
		
		
		private function UseToolCleanLake():void
		{
			GameLogic.getInstance().MouseTransform("Brush", 1 , 0 , 25, -30);
		}
		
		// Dunglb - Bat dau minigame cau ca
		private function UseToolFishing():void
		{
			//var EnergyNeed:int = INI.getInstance().getEnergyInfo("fishing");
			var EnergyNeed:int = ConfigJSON.getInstance().getEnergyInfo("fishing");
			if (GameLogic.getInstance().user.GetEnergy() >= EnergyNeed)
			{
				//GuiMgr.getInstance().GuiFishing.Show(Constant.GUI_MIN_LAYER + 1);
				//GuiMgr.getInstance().GuiFishing.Show();
				
				/*if (!GameController.getInstance().isSmallBackGround)
				{
					var curAni:String = GuiMgr.getInstance().GuiCharacter.CurAni;
					var avatarType:int = GameLogic.getInstance().user.AvatarType;
					if (avatarType == 0)
					{
						if (curAni != GUICharacter.ANI_PREPARE_FISH && curAni !=  GUICharacter.ANI_FISH
								&& curAni !=  GUICharacter.ANI_FISHING_IDLE && curAni !=  GUICharacter.ANI_END_FISH)
						{
							GuiMgr.getInstance().GuiCharacter.GoAct(GUICharacter.ANI_PREPARE_FISH, 40, GuiMgr.getInstance().GuiCharacter.CurAvaPos.y, 3);
						}
					}
					else 
					{
						if (curAni != GUICharacter.ANI_GIRL_PREPARE_FISH && curAni !=  GUICharacter.ANI_GIRL_FISHING_IDLE
								&& curAni !=  GUICharacter.ANI_GIRL_END_FISH)
						{
							GuiMgr.getInstance().GuiCharacter.GoAct(GUICharacter.ANI_GIRL_PREPARE_FISH, 40, GuiMgr.getInstance().GuiCharacter.CurAvaPos.y, 3);
						}
					}
				}
				else*/
				{
					fog = new Sprite();
					fog.graphics.beginFill(0x000000, 0.3);
					fog.graphics.drawRect(0, 0, Constant.STAGE_WIDTH, Constant.STAGE_HEIGHT);
					fog.graphics.endFill();
					
					LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).addChild(fog);
					blackHole.SetPos(485, 250);
					blackHole.img.visible = true;
					var numChild:int = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).numChildren;
					LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).setChildIndex(blackHole.img, numChild -1);
					isFishing = true;
					EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffFishing", null, blackHole.img.x, blackHole.img.y, false, false, null, completeEffFishing);
					
					var cmd:SendFishing = new SendFishing(GameLogic.getInstance().user.Id, GameLogic.getInstance().user.CurLake.Id);
					Exchange.GetInstance().Send(cmd);
				}
			}
			else
			{
				//GuiMgr.getInstance().GuiFishingCannot.Show(Constant.GUI_MIN_LAYER + 1);
				//GuiMgr.getInstance().GuiFishingCannot.Show();
				GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 3);
				//GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message4"));
			}
		}
		
		public function completeEffFishing():void 
		{
			isFishing = false;
			//tắt đi thì mới bật phần nhận thưởng quest
			var questArr:Array = QuestMgr.getInstance().finishedQuest;
			if (questArr.length > 0)
			{
				GameLogic.getInstance().OnQuestDone(questArr[0]);		
				questArr.splice(0, 1);
			}
			finishEffFishing = true;
			blackHole.img.visible = false;
			LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).removeChild(fog);
			if(GameLogic.getInstance().FishingDataReceive)
			{
				GameLogic.getInstance().ProcessFishing1(GameLogic.getInstance().dataFishing)
			}
		}
		
		private function UseToolEditDecorate():void
		{
			if (!GuiMgr.getInstance().GuiStore.IsVisible)
			{
				// hien inventory ra
				GuiMgr.getInstance().GuiStore.Show();
				GuiMgr.getInstance().GuiStore.CurrentStore = "Decorate";
				var pk:SendLoadInventory = new SendLoadInventory();
				Exchange.GetInstance().Send(pk);
			}
			else
			{
				GuiMgr.getInstance().GuiStore.ClearComponent();
				GuiMgr.getInstance().GuiStore.InitStore("Decorate", 0);
			}
			//GuiMgr.getInstance().GuiStore.btnExtendDeco.SetVisible(true);
			// chyen sang editdeco
			if (GameLogic.getInstance().gameState == GameState.GAMESTATE_EDIT_DECORATE) return;
			
			
			GameLogic.getInstance().SetState(GameState.GAMESTATE_EDIT_DECORATE);
			GameLogic.getInstance().HideFish();
			
			var decoArr:Array = GameLogic.getInstance().user.GetDecoArr();
			var i:int;
			for (i = 0; i < decoArr.length; i++)
			{
				var deco:Decorate = decoArr[i] as Decorate;
				deco.SaveInfo();
			}	
		}
		
		/**
		 * Active war in my home
		 */
		private function UserToolRapeBossAtHome(isActive:Boolean = true):void
		{
			var i:int;
			var posX:int;
			var posY:int;
			var fishArr:Array;
			var fs:FishSoldier;
			
			var decoArr:Array = GameLogic.getInstance().user.GetDecoArr();
			
			if (isActive)
			{
				GameLogic.getInstance().SetMode(GameMode.GAMEMODE_BOSS);
				GameLogic.getInstance().MouseTransform("");
				LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER).visible = false;
				
				// Ẩn bong bóng
				for (i = 0; i < GameLogic.getInstance().balloonArr.length; i++)
				{
					GameLogic.getInstance().balloonArr[i].img.visible = false;
				}
				// Ẩn đồ trang trí
				for (i = 0; i < decoArr.length; i++)
				{
					decoArr[i].img.visible = false;
				}
				// Ẩn spartans deactive
				for (i = 0; i < GameLogic.getInstance().user.FishArrSpartanDeactive.length; i++)
				{
					GameLogic.getInstance().user.FishArrSpartanDeactive[i].img.visible = false;
				}
			}
			else
			{
				GameLogic.getInstance().SetMode(GameMode.GAMEMODE_NORMAL);
				LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER).visible = true;
				
				// Ẩn bong bóng
				for (i = 0; i < GameLogic.getInstance().balloonArr.length; i++)
				{
					GameLogic.getInstance().balloonArr[i].img.visible = true;
				}
				// Ẩn đồ trang trí
				for (i = 0; i < decoArr.length; i++)
				{
					decoArr[i].img.visible = true;
				}
				// Ẩn spartans deactive
				for (i = 0; i < GameLogic.getInstance().user.FishArrSpartanDeactive.length; i++)
				{
					GameLogic.getInstance().user.FishArrSpartanDeactive[i].img.visible = true;
				}
			}
			
			// Tính các tọa độ cá nhà mình bơi ra
			mySoldierPos.splice(0, mySoldierPos.length);
			var p7:Point = new Point(Constant.MAX_WIDTH / 2 -170, GetLakeTop() + 40 + (Constant.HEIGHT_LAKE - 80) / 2);
			mySoldierPos.push(p7);
			var p8:Point = new Point(p7.x, p7.y + 70);
			mySoldierPos.push(p8);
			var p9:Point = new Point(p7.x, p7.y - 70);
			mySoldierPos.push(p9);
			var p10:Point = new Point(p7.x - 80, p7.y);
			mySoldierPos.push(p10);
			var p11:Point = new Point(p8.x - 80, p8.y);
			mySoldierPos.push(p11);
			var p12:Point = new Point(p9.x - 80, p9.y);
			mySoldierPos.push(p12);
			
			// Khoảng bay của cá lính nhà mình
			MySoldierRectangle = new Rectangle(Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2, GameController.getInstance().GetLakeTop(), Main.imgRoot.stage.width / 2 - 100, Constant.HEIGHT_LAKE - 40);
			// Khoảng bay của cá nông dân nhà mình
			MyFishRectangle = new Rectangle(Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2 - 200, GameController.getInstance().GetLakeTop(), 200, Constant.HEIGHT_LAKE - 40);
			if (isActive)
			{
				// Căn chỉnh lại màn hình chơi
				if (Main.imgRoot.stage.displayState == StageDisplayState.FULL_SCREEN)
				{
					Main.imgRoot.stage.displayState = StageDisplayState.NORMAL;
				}
				else
				{
					var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
					PanScreenX( -(layer.width - Constant.STAGE_WIDTH)/2 - layer.x);
					PanScreenY( -(layer.height - Constant.STAGE_HEIGHT)/2 - layer.y - 100);
				}
				
				// Cá thường nhà mình dạt đi
				fishArr = GameLogic.getInstance().user.GetFishArr();
				for (i = 0; i < fishArr.length; i++)
				{
					var fish:Fish = fishArr[i] as Fish;
					fish.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
					posX = Ultility.RandomNumber(MyFishRectangle.left + fish.img.width + 30, MyFishRectangle.right - fish.img.width - 30);
					posY = fish.CurPos.y;
					fish.SwimTo(posX, posY, 10);
				}
				
				// Cá super ẩn luôn
				fishArr = GameLogic.getInstance().user.FishArrSpartan;
				for (i = 0; i < fishArr.length; i++)
				{
					(fishArr[i] as FishSpartan).img.visible = false;
				}
				
				// Cá lính vào vị trí
				fishArr = GameLogic.getInstance().user.GetFishSoldierArr();
				var indexFish:int;	// thứ tự để get vị trí
				for (i = 0; i < fishArr.length; i++)
				{
					fs = fishArr[i] as FishSoldier;
					posX = mySoldierPos[i].x;
					posY = mySoldierPos[i].y;
					
					// Set lại khoảng bơi cho xông xênh không là cá bị va vào khung dội lại
					fs.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() -170, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 500));
					
					fs.SwimTo(posX, posY, 10);
					fs.standbyPos = mySoldierPos[i];
					
					fs.OnLoadResCompleteFunction = function():void
					{
						this.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() -170, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 500));
						this.SwimTo(this.standbyPos.x, this.standbyPos.y, 10);
					}
				}
				indexFish = i;
				
				// Cá lính hồ khác sang tiếp viện
				var actorList:Array = GameLogic.getInstance().user.FishSoldierActorMine;
				actorList.splice(0, actorList.length);
				fishArr = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
				for (i = 0; i < fishArr.length; i++)
				{
					var j:int;
					var isInLake:Boolean = false;
					for (j = 0; j < GameLogic.getInstance().user.FishSoldierArr.length; j++)
					{
						if (GameLogic.getInstance().user.FishSoldierArr[j].Id == fishArr[i].Id)
						{
							isInLake = true;
							break;
						}
					}
					
					if (!isInLake)
					{
						fs = fishArr[i] as FishSoldier;
						if (fishArr[i].Status == FishSoldier.STATUS_DEAD)	continue;
						
						var name1:String = Fish.ItemType + fishArr[i].FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
						var f1:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), name1);
						
						SetInfo(f1, fs, FishSoldier.ACTOR_MINE);
						
						posX = Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2 - f1.img.width + 50;
						posY = GetLakeTop() + Constant.HEIGHT_LAKE / 2;
						
						f1.Init(posX, posY);
						
						// Set lại khoảng bơi cho xông xênh không là cá bị va vào khung dội lại
						f1.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() -170, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 500));
						
						//posX = mySoldierPos[indexFish].x;
						//posY = mySoldierPos[indexFish].y;
						f1.standbyPos = mySoldierPos[indexFish];
						//f1.SwimTo(posX, posY, 20);
						f1.SwimTo(f1.standbyPos.x, f1.standbyPos.y, 20);
						
						f1.OnLoadResCompleteFunction = function():void
						{
							this.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() -170, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 500));
							this.SwimTo(this.standbyPos.x, this.standbyPos.y, 20);
							//trace("OnLoadResComplete cua con ca Id la " + this.Id);
						}
						actorList.push(f1);
						indexFish++;
					}
				}
				
				var boss:BossHerb = GameLogic.getInstance().user.bossHerb;
				if (boss)
				{
					boss.standbyPos = new Point(Constant.MAX_WIDTH / 2 + 170, GetLakeTop() + (Constant.HEIGHT_LAKE - 80) / 2);
					boss.SwimTo(boss.standbyPos.x, boss.standbyPos.y, 10);
				}
			}
			else
			{				
				// Cá super hiện luôn
				fishArr = GameLogic.getInstance().user.FishArrSpartan;
				for (i = 0; i < fishArr.length; i++)
				{
					(fishArr[i] as FishSpartan).img.visible = true;
				}
				
				// Các con cá fake chạy hết
				for (i = 0; i < GameLogic.getInstance().user.FishSoldierActorMine.length; i++)
				{
					fs = GameLogic.getInstance().user.FishSoldierActorMine[i] as FishSoldier;
					fs.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() - 50, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 10));
					fs.SetHighLight(-1);
					fs.SwimTo(0, fs.CurPos.y, 20);
				}
				
				// Cá thường đi lại tung tăng
				for (i = 0; i < GameLogic.getInstance().user.FishSoldierArr.length; i++)
				{
					fs = GameLogic.getInstance().user.FishSoldierArr[i] as FishSoldier;
					fs.SetMovingState(Fish.FS_SWIM);
					fs.GuiFishStatus.Hide();
					fs.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 40));
				}
				
				for (i = 0; i < GameLogic.getInstance().user.FishArr.length; i++)
				{
					var fn:Fish = GameLogic.getInstance().user.FishArr[i] as Fish;
					fn.SetMovingState(Fish.FS_SWIM);
					//fn.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 40));
					if(!isSmallBackGround)
					{
						fn.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
					}
					else
					{
						fn.SetSwimingArea(new Rectangle(275, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE - 80));
					}
				}
				
				// Boss herb biến
				if (GameLogic.getInstance().user.bossHerb)
				{
					var b:BossHerb = GameLogic.getInstance().user.bossHerb;
					b.SetEmotion(BossHerb.EMO_IDLE);
					b.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 40));
					b.SwimTo(Constant.MAX_WIDTH, b.CurPos.y, 10);
				}
				
				// Update last atk boss
				GameLogic.getInstance().user.GetMyInfo().EventInfo.LastTimeAttackBoss = GameLogic.getInstance().CurServerTime;
				
				if (GuiMgr.getInstance().GuiCover.IsVisible)
				{
					GuiMgr.getInstance().GuiCover.Hide();
				}
			}
		}
		
		/**
		 * Active Fish War Longpt
		 * @param	isActive	:	bắt đầu để các con dạt sang 2 bên
		 */
		private function UseToolFishWar(isActive:Boolean = true):void
		{
			var i:int;
			var posX:int;
			var posY:int;
			var fishArr:Array;
			var fs:FishSoldier;
			var decoArr:Array = GameLogic.getInstance().user.GetDecoArr();
			
			if (isActive)
			{
				// Chuyển trạng thái
				GameLogic.getInstance().SetMode(GameMode.GAMEMODE_WAR);
				GuiMgr.getInstance().GuiMain.btnWar.SetVisible(false);
				GuiMgr.getInstance().GuiMain.txtCombatCount.visible = false;
				GuiMgr.getInstance().GuiMain.btnPeace.SetVisible(true);
				GameLogic.getInstance().MouseTransform("");
				
				// Ẩn bớt 1 số content ko cần thiết
				GuiMgr.getInstance().GuiInfoFishWar.Show(Constant.GUI_MIN_LAYER, 0);	//Ranh giới giữa 2 bên
				LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER).visible = false;
				for (i = 0; i < GameLogic.getInstance().balloonArr.length; i++)
				{
					GameLogic.getInstance().balloonArr[i].img.visible = false;
				}
				
				// Ẩn đồ trang trí
				for (i = 0; i < decoArr.length; i++)
				{
					decoArr[i].img.visible = false;
				}
				//ẩn cây hoa trong event
				if (EventMgr.CheckEvent("Event_8_3_Flower") == EventMgr.CURRENT_IN_EVENT)
				{
					if (GameLogic.getInstance().user.coralTree)
					{
						GameLogic.getInstance().user.coralTree.img.visible = false;
					}
				}
				// Ẩn spartans deactive
				for (i = 0; i < GameLogic.getInstance().user.FishArrSpartanDeactive.length; i++)
				{
					GameLogic.getInstance().user.FishArrSpartanDeactive[i].img.visible = false;
				}
				
				if (SoundMgr.getInstance().IsPlayBg)
				{
					SoundMgr.getInstance().playBgMusic(SoundMgr.MUSIC_WAR);
				}
			}
			else
			{
				// Chuyển trạng thái
				GameLogic.getInstance().gameMode = GameMode.GAMEMODE_NORMAL;
				GuiMgr.getInstance().GuiMain.btnWar.SetVisible(true);
				GuiMgr.getInstance().GuiMain.txtCombatCount.visible = true;
				GuiMgr.getInstance().GuiMain.btnPeace.SetVisible(false);
				GuiMgr.getInstance().GuiInfoFishWar.Hide();
				
				// Hiện các content đã ẩn lúc active
				LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER).visible = true;
				for (i = 0; i < GameLogic.getInstance().balloonArr.length; i++)
				{
					GameLogic.getInstance().balloonArr[i].img.visible = true;
				}
				for (i = 0; i < decoArr.length; i++)
				{
					decoArr[i].img.visible = true;
				}
				//hiện cây hoa trong evetn
				if (EventMgr.CheckEvent("Event_8_3_Flower") == EventMgr.CURRENT_IN_EVENT)
				{
					if (GameLogic.getInstance().user.coralTree)
					{
						GameLogic.getInstance().user.coralTree.img.visible = true;
					}
					
				}
				for (i = 0; i < GameLogic.getInstance().user.FishArrSpartanDeactive.length; i++)
				{
					GameLogic.getInstance().user.FishArrSpartanDeactive[i].img.visible = true;
				}
				
				
				if (SoundMgr.getInstance().IsPlayBg && SoundMgr.getInstance().musicMode != SoundMgr.MUSIC_NORMAL)
				{
					SoundMgr.getInstance().playBgMusic();
				}
			}
			GuiMgr.getInstance().GuiMain.RefreshGUI();
			
			// Tính các tọa độ cá nhà bạn bơi ra
			theirSoldierPos.splice(0, theirSoldierPos.length);
			var p1:Point = new Point(Constant.MAX_WIDTH / 2 + 70, GetLakeTop() + 30 + (Constant.HEIGHT_LAKE - 80) / 2);
			theirSoldierPos.push(p1);
			var p2:Point = new Point(p1.x, p1.y + 70);
			theirSoldierPos.push(p2);
			var p3:Point = new Point(p1.x, p1.y - 70);
			//p.y -= 180;
			theirSoldierPos.push(p3);
			var p4:Point = new Point(p1.x + 80, p1.y);
			theirSoldierPos.push(p4);
			var p5:Point = new Point(p2.x + 80, p2.y);
			theirSoldierPos.push(p5);
			var p6:Point = new Point(p3.x + 80, p3.y);
			theirSoldierPos.push(p6);
			
			// Tính các tọa độ cá nhà mình bơi ra
			mySoldierPos.splice(0, mySoldierPos.length);
			var p7:Point = new Point(Constant.MAX_WIDTH / 2 -220, GetLakeTop() + 30 + (Constant.HEIGHT_LAKE - 80) / 2);
			mySoldierPos.push(p7);
			var p8:Point = new Point(p7.x, p7.y + 70);
			mySoldierPos.push(p8);
			var p9:Point = new Point(p7.x, p7.y - 70);
			mySoldierPos.push(p9);
			var p10:Point = new Point(p7.x - 80, p7.y);
			mySoldierPos.push(p10);
			var p11:Point = new Point(p8.x - 80, p8.y);
			mySoldierPos.push(p11);
			var p12:Point = new Point(p9.x - 80, p9.y);
			mySoldierPos.push(p12);
			
			// Khoảng bay của cá lính nhà mình
			MySoldierRectangle = new Rectangle(Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2, GameController.getInstance().GetLakeTop(), Main.imgRoot.stage.width / 2 - 100, Constant.HEIGHT_LAKE - 40);
			// Khoảng bay của cá lính nhà bạn
			TheirSoldierRectangle = new Rectangle(Constant.MAX_WIDTH / 2, GameController.getInstance().GetLakeTop(), 280, Constant.HEIGHT_LAKE - 40);		
			// Khoảng bay của cá nông dân nhà bạn (ofcourse)
			TheirFishRectangle = new Rectangle(Constant.MAX_WIDTH / 2 + 200, GameController.getInstance().GetLakeTop(), Main.imgRoot.stage.width / 2 - 100, Constant.HEIGHT_LAKE - 40);			
			// Khoảng bay lúc tự do
			DefaultRectangle = new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 40);
			
			GameLogic.getInstance().user.CurSoldier.splice(0, GameLogic.getInstance().user.CurSoldier.length);
			// Switch to active mode
			if (isActive)
			{
				// Căn chỉnh lại màn hình chơi
				if (Main.imgRoot.stage.displayState == StageDisplayState.FULL_SCREEN)
				{
					Main.imgRoot.stage.displayState = StageDisplayState.NORMAL;
				}
				else
				{
					var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
					PanScreenX( -(layer.width - Constant.STAGE_WIDTH)/2 - layer.x);
					PanScreenY( -(layer.height - Constant.STAGE_HEIGHT)/2 - layer.y - 100);
				}
				
				// Cá nhà bạn bơi về bên phải
				// Cá thường
				fishArr = GameLogic.getInstance().user.GetFishArr();
				for (i = 0; i < fishArr.length; i++)
				{
					var fish:Fish = fishArr[i] as Fish;
					posX = Ultility.RandomNumber(TheirFishRectangle.left + fish.img.width + 30, TheirFishRectangle.right - fish.img.width - 30);
					posY = fish.CurPos.y;
					fish.SwimTo(posX, posY, 10);
				}
				
				// Cá super thì trốn luôn
				fishArr = GameLogic.getInstance().user.FishArrSpartan;
				for (i = 0; i < fishArr.length; i++)
				{
					var sf:FishSpartan = fishArr[i] as FishSpartan;
					posX = Ultility.RandomNumber(Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2 + sf.img.width + 50, Constant.MAX_WIDTH);
					posY = GetLakeTop() + Constant.HEIGHT_LAKE / 2;
					sf.SwimTo(posX, posY, 10);
				}
				
				// Cá lính cũng dạt
				fishArr = GameLogic.getInstance().user.GetFishSoldierArr();
				var indexFish:int;	// thứ tự để get vị trí
				for (i = 0; i < fishArr.length; i++)
				{
					fs = fishArr[i] as FishSoldier;
					posX = theirSoldierPos[i].x;
					posY = theirSoldierPos[i].y;
					
					// Set lại khoảng bơi cho xông xênh không là cá bị va vào khung dội lại
					fs.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() -170, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 200));
					
					fs.SwimTo(posX, posY, 10);
					fs.standbyPos = theirSoldierPos[i];
				}
				indexFish = i;
				
				// Cá lính nhà ta sang xâm chiếm
				// Xóa mảng cá diễn viên
				var actorList:Array = GameLogic.getInstance().user.FishSoldierActorMine;
				actorList.splice(0, actorList.length);
				fishArr = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
				var bestSoldier:FishSoldier = FishSoldier.FindBestSoldier(fishArr, true);
				var dy:int = Math.floor((Constant.HEIGHT_LAKE - 50) / fishArr.length);
				for (i = 0; i < fishArr.length; i ++)
				{
					if (fishArr[i].IsHealthy() < 1 && !Ultility.IsInMyFish())
					break;
					if (fishArr[i].Status == FishSoldier.STATUS_DEAD)
					continue;
					
					fs = fishArr[i] as FishSoldier;
					var name:String = Fish.ItemType + fishArr[i].FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					var f:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), name);
					SetInfo(f, fs, FishSoldier.ACTOR_MINE);
					posX = Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2 - f.img.width - 50;
					posY = GetLakeTop() + 50 + i * dy;
					f.Init(posX, posY);
					
					//posX = mySoldierPos[i].x;
					//posY = mySoldierPos[i].y;
					
					//f.SwimTo(posX, posY, 20);
					f.standbyPos = mySoldierPos[i];
					f.SwimTo(f.standbyPos.x, f.standbyPos.y);
					var p:Point = f.standbyPos;
					f.OnLoadResCompleteFunction = function():void
					{
						this.SwimTo(this.standbyPos.x, this.standbyPos.y, 20);
						var area:Rectangle = new Rectangle(0, GameController.getInstance().GetLakeTop() -170, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 500);
						this.SetSwimingArea(area);
					}
					
					if (bestSoldier && GameLogic.getInstance().user.CurSoldier[0] == null && f.Id == bestSoldier.Id)
					{
						f.isChoose = true;
						GameLogic.getInstance().user.CurSoldier[0] = f;
					}
					actorList.push(f);
				}
				
				// Add thêm các con cá lính nhà bạn ở hồ khác sang tiếp viện
				actorList = GameLogic.getInstance().user.FishSoldierActorTheirs;
				actorList.splice(0, actorList.length);
				
				fishArr = GameLogic.getInstance().user.FishSoldierAllArr;
				bestSoldier = FishSoldier.FindBestSoldier(fishArr, false);
				//if (fishArr.length || !bestSoldier)	return;
				if (fishArr.length == 0)	return;
				for (i = 0; i < fishArr.length; i++)
				{
					var j:int;
					var isInLake:Boolean = false;
					for (j = 0; j < GameLogic.getInstance().user.FishSoldierArr.length; j++)
					{
						// Chọn con cá khỏe nhất ở hồ bên kia
						if (bestSoldier && GameLogic.getInstance().user.FishSoldierArr[j].Id == bestSoldier.Id)
						{
							GameLogic.getInstance().user.FishSoldierArr[j].isChoose = true;
							GameLogic.getInstance().user.CurSoldier[1] = GameLogic.getInstance().user.FishSoldierArr[j];
						}
						
						if (GameLogic.getInstance().user.FishSoldierArr[j].Id == fishArr[i].Id)
						{
							isInLake = true;
							break;
						}
					}
					
					if (!isInLake)
					{
						fs = fishArr[i] as FishSoldier;
						if (fishArr[i].Status == FishSoldier.STATUS_DEAD)	continue;
						
						var name1:String = Fish.ItemType + fishArr[i].FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
						var f1:FishSoldier = new FishSoldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), name1);
						
						SetInfo(f1, fs, FishSoldier.ACTOR_THEIRS);
						posX = Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2 + f1.img.width + 50;
						posY = GetLakeTop() + Constant.HEIGHT_LAKE / 2;
						f1.Init(posX,posY);
						// Set lại khoảng bơi cho xông xênh không là cá bị va vào khung dội lại
						f1.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() -170, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 500));
						
						//posX = theirSoldierPos[indexFish].x;
						//posY = theirSoldierPos[indexFish].y;
						f1.standbyPos = theirSoldierPos[indexFish];
						//f1.SwimTo(posX, posY, 20);
						f1.SwimTo(f1.standbyPos.x, f1.standbyPos.y, 20);
						
						f1.OnLoadResCompleteFunction = function():void
						{
							this.SwimTo(this.standbyPos.x, this.standbyPos.y, 20);
							this.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() -170, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 500));
						}
						
						if (!GameLogic.getInstance().user.CurSoldier[1] && bestSoldier && f1.Id == bestSoldier.Id)
						{
							f1.isChoose = true;
							GameLogic.getInstance().user.CurSoldier[1] = f1;
						}
						
						actorList.push(f1);
						indexFish++;
					}
				}
			}
			// Switch to deactive mode
			else
			{
				// Các con cá fake chạy hết
				for (i = 0; i < GameLogic.getInstance().user.FishSoldierActorMine.length; i++)
				{
					fs = GameLogic.getInstance().user.FishSoldierActorMine[i] as FishSoldier;
					fs.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() - 50, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 10));
					fs.SetHighLight(-1);
					fs.SwimTo(0, fs.CurPos.y, 20);
				}
				
				for (i = 0; i < GameLogic.getInstance().user.FishSoldierActorTheirs.length; i++)
				{
					fs = GameLogic.getInstance().user.FishSoldierActorTheirs[i] as FishSoldier;
					//fs.SwimTo(Constant.MAX_WIDTH, fs.CurPos.y, 20);
					fs.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() - 50, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE + 10));
					fs.SwimTo(Constant.MAX_WIDTH, GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE / 2, 20);
				}
				
				// Cá thường đi lại tung tăng
				for (i = 0; i < GameLogic.getInstance().user.FishSoldierArr.length; i++)
				{
					fs = GameLogic.getInstance().user.FishSoldierArr[i] as FishSoldier;
					fs.SetMovingState(Fish.FS_SWIM);
					fs.GuiFishStatus.Hide();
					fs.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 40));
				}
				
				for (i = 0; i < GameLogic.getInstance().user.FishArr.length; i++)
				{
					var fn:Fish = GameLogic.getInstance().user.FishArr[i] as Fish;
					
					if (!fn.img || !fn.img.visible)
					{
						f.img.visible = true;
					}
					fn.SetMovingState(Fish.FS_SWIM);
					fn.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop(), Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 40));
				}
			}
		}
		
		private function UseToolCureFish():void
		{
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.Hide();
			}
			GameLogic.getInstance().gameState = GameState.GAMESTATE_CURE_FISH;
			GameLogic.getInstance().MouseTransform("Medicine");
			
			var fishArr:Array = GameLogic.getInstance().user.GetFishArr();
			for (var i:int = 0; i < fishArr.length; i++ )
			{
				var f:Fish = fishArr[i] as Fish;
				if (f.Emotion == Fish.ILL)
				{
					f.SetHighLight();
				}
			}
		}
		
		private function UseToolSellFish():void
		{
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
			{
				return;
			}
			
			var p:Point = Ultility.PosScreenToLake(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y);
			GameLogic.getInstance().gameState = GameState.GAMESTATE_SELL_FISH;
			GameLogic.getInstance().MouseTransform("VotCa", 1 , 0,  10, -10);
			
			/*var fishNet:BaseObject = new BaseObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "ButtonVotCa");0.0.
			GameController.getInstance().SetActiveObject(fishNet);	
			GameController.getInstance().UpdateActiveObjPos(p.x, p.y);*/
			
			GameLogic.getInstance().ShowGuiFishStatus(GUIFishStatus.STATUS_SELL, true);
		}
		
		private function UseToolFeedFish():void
		{		
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_BOSS)
			{
				return;
			}
			
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.Hide();
			}
			var p:Point = Ultility.PosScreenToLake(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y);
			GameLogic.getInstance().gameState = GameState.GAMESTATE_FEED_FISH;			
						
			//var feedBox:BaseObject = new BaseObject(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "ImgFoodBox");
			//feedBox.img.scaleX = feedBox.img.scaleY = 0.7;
			//feedBox.img.rotation = 135;
			//SetActiveObject(feedBox);	
			//UpdateActiveObjPos(p.x, p.y);
			GameLogic.getInstance().MouseTransform("ImgFoodBox", 0.7, 135, 30, -5);
			
			// show cover layer
			//var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			//if (layer != null)
			//{
				//layer.ShowDisableScreen(0);
			//}
			
			GameLogic.getInstance().ShowGuiFishStatus(GUIFishStatus.STATUS_FEED);
		}	
		
		public function SetInfo(f1:FishSoldier, f2:FishSoldier, type:int, isRefreshImg:Boolean = true):void
		{
			f1.Damage = f2.Damage;
			f1.nameSoldier = f2.nameSoldier;
			f1.Element = f2.Element;
			f1.Health = f2.Health;
			f1.MaxHealth = f2.MaxHealth;
			f1.Id = f2.Id;
			f1.LakeId = f2.LakeId;
			f1.FeedAmount = 100;
			f1.FishTypeId = f2.FishTypeId;
			f1.FishType = Fish.FISHTYPE_SOLDIER;
			f1.isActor = type;
			f1.AttackPoint = f2.AttackPoint;
			f1.Rank = f2.Rank;
			f1.Critical = f2.Critical;
			f1.LastHealthTime = f2.LastHealthTime;
			f1.OriginalStartTime = f2.OriginalStartTime;
			f1.HealthRegenCooldown = f2.HealthRegenCooldown;
			f1.BuffItem = f2.BuffItem;
			f1.UserBuff = f2.UserBuff;
			f1.GemList = f2.GemList;
			f1.DamagePlus = f2.DamagePlus;
			f1.Defence = f2.Defence;
			f1.DefencePlus = f2.DefencePlus;
			f1.SoldierType = f2.SoldierType;
			f1.EquipmentList = f2.EquipmentList;
			f1.bonusEquipment = f2.bonusEquipment;
			f1.Vitality = f2.Vitality;
			f1.VitalityPlus = f2.VitalityPlus;
			f1.RankPoint = f2.RankPoint;
			f1.MaxRankPoint = f2.MaxRankPoint;
			f1.AlmostDieTime = f2.AlmostDieTime;
			f1.Rank = f2.Rank;
			f1.LifeTime = f2.LifeTime;
			f1.Bonus = f2.Bonus;
			f1.Rate = f2.Rate;
			f1.Status = f2.Status;
			f1.LastTimeDefendFail = f2.LastTimeDefendFail;
			f1.NumDefendFail = f2.NumDefendFail;
			f1.MaxTimeFail = f2.MaxTimeFail;
			f1.RecipeType = f2.RecipeType;
			f1.nameSoldier = f2.nameSoldier;
			f1.meridianDamage = f2.meridianDamage;
			f1.meridianCritical = f2.meridianCritical;
			f1.meridianDefence = f2.meridianDefence;
			f1.meridianVitality = f2.meridianVitality;
			f1.reputationLevel = f2.reputationLevel;
			f1.bonusReputation = f2.bonusReputation;
			// Trỏ lại FishOwn của Equipments
			for (var typeEquip:String in f1.EquipmentList)
			{
				for (var i:int = 0; i < f1.EquipmentList[typeEquip].length; i++)
				{
					f1.EquipmentList[typeEquip][i].SetFishOwn(f1);
				}
			}
			
			if (isRefreshImg)
			f1.RefreshImg();
		}
		
		public function gotoMode(_gameMode:String):void 
		{
			gameMode = _gameMode;
			switch(gameMode)
			{
				case GAME_MODE_BOSS_SERVER:
					//Xóa tất cả các đối tượng trên các layer
					for (var i:int = 0; i < LayerMgr.getInstance().GetLayerNumber(); i++)
					{
						var layer:Layer = LayerMgr.getInstance().GetLayer(i);
						while (layer.numChildren > 0)
						{
							layer.removeChildAt(0);
						}
					}
					//Hiển thị gui ở mode mới
					GuiMgr.getInstance().guiUserInfo.Show();
					//GuiMgr.getInstance().GuiSetting.Show();
					GuiMgr.getInstance().guiUserInfo.updateUserData();
					GameLogic.getInstance().user.backGround.ItemId = 8;
					ResMgr.getInstance().loadBackGround();
					Main.imgRoot.stage.frameRate = 30;
					break;
				case GAME_MODE_HOME:
					Main.imgRoot.stage.frameRate = 24;
					EffectMgr.getInstance().reset();
					GameLogic.getInstance().gameState == GameState.GAMESTATE_INIT;
					GameLogic.getInstance().user = new User();
					GameLogic.getInstance().gameMode = GameMode.GAMEMODE_NORMAL;
					GameController.getInstance().typeFishWorld = -1;
					//GuiMgr.getInstance().guiUserInfo.Show();
					GuiMgr.getInstance().GuiMain = new GUIMain(null, "");
					GuiMgr.getInstance().GuiMain.Show();
					GuiMgr.getInstance().guiFrontScreen.Show();
					if (GameController.getInstance().blackHole == null)
					{
						var layerObject:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
						GameController.getInstance().blackHole = new Image(layerObject, "Black_Hole", 200, 100);
						layerObject.addChild(GameController.getInstance().blackHole.img);
						GameController.getInstance().blackHole.SetPos(485, 135);
						GameController.getInstance().blackHole.img.visible = false;
					}
					// Lấy thông tin cá lính của User
					var test:SendInitRun = new SendInitRun();
					Exchange.GetInstance().Send(test);
					var getSoldier:SendGetAllSoldier = new SendGetAllSoldier();
					Exchange.GetInstance().Send(getSoldier);
					// show waiting screen
					GuiMgr.getInstance().GuiWaitingData.Show(Constant.TopLayer-1, 1);
					// add Setting gui
					GuiMgr.getInstance().GuiSetting.Show();
					// Add gui friends
					GuiMgr.getInstance().GuiFriends = new GUIFriends(null, "");
					GuiMgr.getInstance().GuiFriends.Show();
					GuiMgr.getInstance().GuiFriends.UpdateFriend();
					break;
			}
		}
		
		public function get isSmallBackGround():Boolean 
		{
			return _isSmallBackGround;
		}
		
		public function set isSmallBackGround(value:Boolean):void 
		{
			_isSmallBackGround = value;
			if (value)
			{
				//Set cac layer ve vi tri mac dinh
				var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
				layer.x = -275;
				layer.y = -139;
				//trace("background", layer.x, layer.y);
				layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
				//trace("objectlayer", layer.x, layer.y);
				layer.x = -275;
				layer.y = -139;
				layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
				//trace("cover layer", layer.x, layer.y);
				layer.x = -275;
				layer.y = -139;
				layer = LayerMgr.getInstance().GetLayer(Constant.DIRTY_LAYER);
				//trace("dirty layer", layer.x, layer.y);
				layer.x = -275;
				layer.y = -139;
				layer = LayerMgr.getInstance().GetLayer(Constant.ACTIVE_LAYER);
				//trace("active layer", layer.x, layer.y);
				layer.x = -275;
				layer.y = -139;
				
				//if (GuiMgr.getInstance().GuiCharacter.IsVisible)
				//{
					//GuiMgr.getInstance().GuiCharacter.Hide();
				//}
				
				//Set lai vi tri cho Deco o man hinh to
				var arrDeco:Array = GameLogic.getInstance().user.DecoArr;
				var failPos:Boolean = false;
				var deco:Decorate;
				for each(deco in arrDeco)
				{
					//trace("deco   x:", deco.img.x);
					//275 va 1085 la 2 vi tri mep ngoai map nho
					if (deco.img.x < 275 || deco.img.x > 1085)
					{
						failPos = true;
					}
				}
				
				if (failPos)
				{
					for each(deco in arrDeco)
					{
						//810 va 1360 la width background nho va to
						deco.SetPos(deco.img.x * 810 / 1360 + 275, deco.img.y);
					}
				}
			}
			else
			{
				//GuiMgr.getInstance().GuiCharacter.Show(Constant.OBJECT_LAYER);
			}	
				
			var arrFish:Array = GameLogic.getInstance().user.FishArr;
			for each(var fish:Fish in arrFish)
			{
				if(!isSmallBackGround)
				{
					fish.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
				}
				else
				{
					fish.SetSwimingArea(new Rectangle(275, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE - 80));
				}
			}
			
			var arrSparta:Array = GameLogic.getInstance().user.FishArrSpartan;
			for each(var sparta:FishSpartan in arrSparta)
			{
				if(!isSmallBackGround)
				{
					sparta.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
				}
				else
				{
					sparta.SetSwimingArea(new Rectangle(275, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE - 80));
				}
			}
			
			var arrSoldier:Array = GameLogic.getInstance().user.FishSoldierArr;
			for each(var soldier:FishSoldier in arrSoldier)
			{
				if(!isSmallBackGround)
				{
					soldier.SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
				}
				else
				{
					soldier.SetSwimingArea(new Rectangle(275, GameController.getInstance().GetLakeTop() + 30, Constant.STAGE_WIDTH, Constant.HEIGHT_LAKE - 80));
				}
			}
		}
	}

}