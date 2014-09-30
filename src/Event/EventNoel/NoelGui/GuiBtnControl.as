package Event.EventNoel.NoelGui 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Event.EventMgr;
	import Event.EventNoel.NoelGui.ItemGui.Bullet.BulletScenario;
	import Event.EventNoel.NoelGui.ItemGui.EffectEvent.EffGunFire;
	import Event.EventNoel.NoelGui.ItemGui.ItemBullet;
	import Event.EventNoel.NoelGui.Team.RoundScene;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import Event.EventNoel.NoelLogic.Round.RoundNoel;
	import Event.EventNoel.NoelPacket.SendBuyBulletGold;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Factory.FactoryLogic.EventUtils;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	
	/**
	 * GUI nằm trên cùng để điều khiển
	 * @author HiepNM2
	 */
	public class GuiBtnControl extends BaseGUI 
	{
		private const CMD_HOME:String = "cmdHome";
		private const CMD_GUIDE:String = "cmdGuide";
		private const CMD_STORE:String = "cmdStore";
		private const CMD_CB_AUTO:String = "cmdCbAuto";
		private const CMD_USE_ZMONEY:String = "cmdUseZMoney";
		private const CMD_USE_BULLET:String = "cmdUseBullet";
		private const CMD_USE_BULLETGOLD:String = "cmdUseBulletGold";
		private const CMD_USE_RAINICE:String = "cmdUseRainIce";
		//private const CMD_USE_BOMB:String = "cmdUseBomb";
		private const ID_PRG_CLOCK:String = "idPrgClock";
		
		private const MAX_ID_BULLET:int = 3;
		private const MIN_ID_BULLET:int = 1;
		
		private const DELTA_TIME_FIRE:Number = 0.5;
		private const DELTA_TIME_SEND_FIREGUN:Number = 2;
		private const READY_FIRE_CONTINUE:Boolean = true;
		private const CMD_BUY_BULLETGOLD:String = "cmdBuyBulletgold";
		private const CMD_AUTO_FIRE:String = "cmdAutoFire";
		
		
		private var isShowHuntFish:Boolean = false;
		private var _timeGui:Number = -1;
		private var inEffFire:Boolean;
		public var inFire:Boolean;
		/*Top*/
		private var imgClock:Image;
		private var prgClock:ProgressBar;
		private var tfTime:TextField;
		private var tfTimeIce:TextField;					//thời gian đợi để đóng băng
		private var imgFishDie:Image;
		private var prgFishDie:ProgressBar;
		private var tfFishDie:TextField;
		private var roundBar:Image;
		private var icRound1:Image, icRound2:Image, icRound3:Image, icRound4:Image, icRound5:Image;
		private var icTick1:Image, icTick2:Image, icTick3:Image, icTick4:Image, icTick5:Image;
		private var imgRoundSelect:Image;
		/*Bot*/
		private var gun:Image;
		public var canFire:Boolean = true;
		private var preTimeFire:Number = 0;
		private var itmBullet1:ItemBullet;				//các nút đạn
		private var itmBullet2:ItemBullet;				
		private var itmBullet3:ItemBullet;
		//private var itmBomb:ItemBullet;					//nút bom
		private var itmFreeze:ItemBullet;				//nút tuyết
		private var itmBulletGold:ItemBullet;			//nút đạn = Gold
		private var _itmBullet:ItemBullet;				//con trỏ
		private var checkboxAuto:Button;				//checkbox xem có auto G ko?
		private var _lastTimeFire:Number;				//thời điểm cuối cùng khai hỏa
		private var _isUpdateToFire:Boolean;				//có cập nhật để gửi gói tin bắn lên ko
		private var _isAuto:Boolean;
		//private var clickToStore:Boolean = false;
		
		public function GuiBtnControl(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiBtnControl";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				var btnHome:Button = AddButton(CMD_HOME, "GuiHuntFish_BtnHome", 750, 0);
				btnHome.setTooltipText("Trở về nhà");
				/*AddButton(CMD_GUIDE, "GuiHuntFish_BtnGuide", 700, 30);*/
				
				if (isShowHuntFish)
				{
					AddButton(CMD_STORE, "GuiHuntFish_BtnCollection", 680, 10).setTooltipText("Kho quà");
					/*draw*/
					drawTopArea();
					drawBotArea();
					/*logic*/
					canFire = true;
					autoChangeBulletFromGold();
					/*addevent*/
					var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
					layer.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
				}
			}
			LoadRes("GuiHuntFish_Theme");
		}
		
		/**
		 * vẽ phần trên của gui
		 */
		private function drawTopArea():void 
		{
			/*vẽ cái đồng hồ đếm thời gian hết bàn chơi*/
			prgClock = AddProgress(ID_PRG_CLOCK, "GuiHuntFish_PrgClock", 50, 36, null, true);
			imgClock = AddImage("", "GuiHuntFish_ImgClock", 26, 30, true, ALIGN_LEFT_TOP);
			tfTime = AddLabel("", 75, 42, 0xffffff, 1, 0x000000);
			var fm:TextFormat = new TextFormat("Arial", 18, 0xffffff, true);
			tfTime.defaultTextFormat = fm;
			tfTime.text = "00:00:00";
			/*vẽ cái khung đếm số lượng cá tiêu diệt*/
			prgFishDie = AddProgress(ID_PRG_CLOCK, "GuiHuntFish_PrgFishDie", 630, 50, null, true);
			prgFishDie.setStatus(0);
			imgFishDie = AddImage("", "GuiHuntFish_ImgFishDie", 606, 44, true, ALIGN_LEFT_TOP);
			tfFishDie = AddLabel("", 655, 54, 0xffffff, 1, 0x000000);
			fm = new TextFormat("Arial", 18, 0xffffff, true);
			tfFishDie.defaultTextFormat = fm;
			/*vẽ round bar "GuiHuntFish_ImgRoundBar" và cập nhật nó*/
			roundBar = AddImage("", "GuiHuntFish_ImgRoundBar", 210, 40, true, ALIGN_LEFT_TOP);
			var x:int = 234, y:int = 70, icTick:Image, icRound:Image;
			for (var i:int = 1; i <= 5; i++)
			{
				icTick = this["icTick" + i] = AddImage("", "GuiHuntFish_ImgTick", x, y, true, ALIGN_LEFT_TOP);
				icRound = this["icRound" + i] = AddImage("", "GuiHuntFish_ImgRoundNo" + i, x, y - 7);
				icTick.img.visible = icRound.img.visible = false;
				x += 81;
			}
			imgRoundSelect = AddImage("", "GuiHuntFish_ImgBarSelected", 231, 60, true, ALIGN_LEFT_TOP);
		}
		
		/**
		 * vẽ phần dưới của gui
		 */
		private function drawBotArea():void 
		{
			var price:int;
			/*giá*/
			AddImage("", "GuiHuntFish_ImgShelf", 68, 553, true, ALIGN_LEFT_TOP);
			/*súng*/
			gun = AddImage("", "GuiHuntFish_ImgGun", 406, 592, true, ALIGN_LEFT_TOP);
			
			AddLabel("1", 316, 573, 0x000000, 0);
			AddLabel("2", 511, 573, 0x000000, 0);
			AddLabel("3", 575, 573, 0x000000, 0);
			AddLabel("4", 639, 573, 0x000000, 0);
			/*đạn*/
			var x:int = 495, y:int = 595, itmBullet:ItemBullet, info:ItemCollectionInfo, hasBulletG:Boolean = false;
			for (var i:int = MIN_ID_BULLET; i <= MAX_ID_BULLET; i++)
			{
				info = EventSvc.getInstance().getItemInfo("Bullet", i);
				itmBullet = this["itmBullet" + i] = new ItemBullet(this.img, "KhungFriend", x, y);
				itmBullet.IdObject = CMD_USE_BULLET + "_" + i;
				itmBullet.EventHandler = this;
				itmBullet.img.buttonMode = true;
				itmBullet.initData(info);
				itmBullet.drawGift();
				hasBulletG ||= (info.Num > 0);
				y = 597;
				x += 63;
			}
			
			itmFreeze = new ItemBullet(this.img, "KhungFriend", 223, 595); itmFreeze.hasNum = false;
			price = ConfigJSON.getInstance().getItemInfo("Noel_Bullet")["RainIce"]["1"]["ZMoney"];
			itmFreeze.IdObject = CMD_USE_ZMONEY + "_RainIce_1_" + price;
			itmFreeze.EventHandler = this;
			itmFreeze.img.buttonMode = true;
			info = ItemCollectionInfo.createItemInfo("RainIce"); info.ItemType = "RainIce"; info.ItemId = 1;
			itmFreeze.initData(info);
			itmFreeze.drawGift();
			AddButton(CMD_USE_ZMONEY + "_RainIce_1_" + price, "GuiHuntFish_BtnZMoney", 202, 586);
			AddLabel(Ultility.StandardNumber(price), 212, 585, 0xffffff, 0, 0x000000).mouseEnabled = false;
			tfTimeIce = AddLabel("", 200, 530, 0xffffff, 0, 0x000000);
			var fm:TextFormat = new TextFormat("Arial", 14, 0xffffff, true);
			tfTimeIce.defaultTextFormat = fm;
			tfTimeIce.visible = false;
			
			
			itmBulletGold = new ItemBullet(this.img, "KhungFriend", 301, 595);/* itmBulletGold.hasNum = true;*/
			itmBulletGold.IdObject = CMD_USE_BULLETGOLD + "_1";
			itmBulletGold.EventHandler = this;
			itmBulletGold.img.buttonMode = true;
			info = EventSvc.getInstance().getItemInfo("BulletGold", 1);
			itmBulletGold.initData(info);
			itmBulletGold.drawGift();
			
			AddButton(CMD_BUY_BULLETGOLD, "GuiHuntFish_BtnGold", 281, 598);
			var tfBuy:TextField = AddLabel("Mua", 285, 597, 0xffffff, 0, 0x000000);
			
			BulletScenario.getInstance().UseGold = true;
			BulletScenario.getInstance().bulletId = 1;
			_itmBullet = itmBulletGold;
			_itmBullet.setSelected(true);
			
			/*phần tự động*/
			_isAuto = false;//cứ mở gui là _isAuto được set lại = false;
			checkboxAuto = AddButton(CMD_CB_AUTO, "EventNoel_CheckBox" + _isAuto, 656, 592);
			var tfTipAuto:TextField = AddLabel("", 674, 591, 0x0c4c68, 0);
			tfTipAuto.text = "Tự động";
			checkboxAuto.setTooltipText(Localization.getInstance().getString("EventNoel_TipCheckBoxAuto" + _isAuto));
			
			AddButton(CMD_AUTO_FIRE, "GuiHuntFish_BtnAutoFire", 657, 531);
		}
		
		public function changeBulletGold():void
		{
			if (inFire||GuiMgr.getInstance().guiHuntFish.inEffectComeInRound) return;
			BulletScenario.getInstance().UseGold = true;
			BulletScenario.getInstance().bulletId = 1;
			_itmBullet.setSelected(false);
			_itmBullet = itmBulletGold;
			_itmBullet.setSelected(true);
		}
		
		public function changeBullet(id:int):void
		{
			var inEffCome:Boolean = GuiMgr.getInstance().guiHuntFish.inEffectComeInRound;
			if (inFire||inEffCome) return;
			BulletScenario.getInstance().UseGold = false;
			BulletScenario.getInstance().bulletId = id;
			_itmBullet.setSelected(false);
			_itmBullet = this["itmBullet" + id];
			_itmBullet.setSelected(true);
		}
		/**
		 * tự động chuyển đạn từ vị trí Bullet thường(không phải đạn dùng vàng)
		 * @param	idBullet id của viên đạn hiện tại
		 * @return true nếu còn đạn, false nếu tất cả các đạn đều hết
		 */
		public function autoChangeBullet(idBullet:int):Boolean
		{
			var i:int, num:int = 0;
			for (i = idBullet + 1; i <= MAX_ID_BULLET; i++)
			{
				num = EventSvc.getInstance().getNumItem("Bullet", i);
				if (num > 0) break;
			}
			if (num == 0)
			{
				for (i = idBullet - 1 ; i >= MIN_ID_BULLET; i--)
				{
					num = EventSvc.getInstance().getNumItem("Bullet", i);
					if (num > 0) break;
				}
				if (num == 0)//tìm đạn dùng vàng
				{
					var gold:Number = GameLogic.getInstance().user.GetMoney();
					var price:int = ConfigJSON.getInstance().getItemInfo("Noel_Bullet")["BulletGold"]["1"]["Money"];
					if (gold >= price)
					{
						BulletScenario.getInstance().UseGold = true;
						BulletScenario.getInstance().bulletId = 1;
						_itmBullet.setSelected(false);
						_itmBullet = itmBulletGold;
					}
					else
					{
						return false;
					}
				}
				else
				{
					BulletScenario.getInstance().UseGold = false;
					BulletScenario.getInstance().bulletId = i;
					_itmBullet.setSelected(false);
					_itmBullet = this["itmBullet" + i];
				}
			}
			else
			{
				BulletScenario.getInstance().UseGold = false;
				BulletScenario.getInstance().bulletId = i;
				_itmBullet.setSelected(false);
				_itmBullet = this["itmBullet" + i];
			}
			
			_itmBullet.setSelected(true);
			return true;
		}
		/**
		 * chuyển đạn từ vị trí dùng vàng
		 * @return true nếu còn đạn, false nếu tất cả các đạn đều hết
		 */
		public function autoChangeBulletFromGold():Boolean
		{
			var i:int, num:int = 0;
			for (i = MIN_ID_BULLET; i <= MAX_ID_BULLET; i++)
			{
				num = EventSvc.getInstance().getNumItem("Bullet", i);
				if (num > 0) break;
			}
			if (num > 0)
			{
				_itmBullet.setSelected(false);
				BulletScenario.getInstance().UseGold = false;
				BulletScenario.getInstance().bulletId = i;
				_itmBullet = this["itmBullet" + i];
				_itmBullet.setSelected(true);
			}
			return num > 0;
			
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var inHuntFish:Boolean = GuiMgr.getInstance().guiHuntFish.IsVisible;
			var inEffCome:Boolean = GuiMgr.getInstance().guiHuntFish.inEffectComeInRound;
			var inEffIce:Boolean = BulletScenario.getInstance().inEffIce;
			if (inHuntFish && !inEffCome && !inEffIce)
			{
				canFire = false;
			}
			var data:Array = buttonID.split("_");
			var cmd:String  = data[0];
			var initAllOk:Boolean = GuiMgr.getInstance().guiHuntFish.IsInitAllOk;
			var id:int;
			var price:Number;
			if (inEffCome || inEffFire || inEffIce) 
				return;
			switch(cmd)
			{
				case CMD_HOME:
					if (inEffFire) return;
					if (GuiMgr.getInstance().guiGotoHunt.IsVisible)
					{
						GuiMgr.getInstance().guiGotoHunt.Hide();
					}
					if (inHuntFish)
					{
						GuiMgr.getInstance().guiHuntFish.Hide();
					}
					break;
				case CMD_BUY_BULLETGOLD:
					GuiMgr.getInstance().guiBuyMultiRock.priceType = "Money";
					price = ConfigJSON.getInstance().getItemInfo("Noel_Bullet")["BulletGold"]["1"]["Money"];
					GuiMgr.getInstance().guiBuyMultiRock.costPerPack = price;
					var myMoney:Number = GameLogic.getInstance().user.GetMoney();
					GuiMgr.getInstance().guiBuyMultiRock.showGUI(int(myMoney / price), "Đạn Thường", "GuiHuntFish_BulletGoldShop", function f(num:int):void
					{
						if (num > 0)
						{
							if (Ultility.payMoney("Money", price * num))
							{
								var pk:SendBuyBulletGold = new SendBuyBulletGold(num);
								Exchange.GetInstance().Send(pk);
								EventSvc.getInstance().updateItem("BulletGold", 1, num);
								itmBulletGold.refreshTextNum();
							}
						}
					});
					break;
				case CMD_STORE:
					//clickToStore = true;
					var dataPacket:Object = new Object();
					dataPacket["BoardId"] = RoundScene.getInstance().Round.IdRound;
					EventNoelMgr.getInstance().encodeSendFire();
					dataPacket["Key"] = EventNoelMgr.getInstance().Seed;
					dataPacket["FireInfo"] = [];
					GuiMgr.getInstance().guiStoreNoel.dataPacket = dataPacket;
					GuiMgr.getInstance().guiStoreNoel.Show(Constant.GUI_MIN_LAYER, 5);
					//GuiMgr.getInstance().guiExchangeNoelCollection.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case CMD_AUTO_FIRE:
					GuiMgr.getInstance().guiFinishEventAuto.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case CMD_CB_AUTO:
					if (initAllOk)
					{
						_isAuto = !_isAuto;
						RemoveButton(CMD_CB_AUTO);
						checkboxAuto = AddButton(CMD_CB_AUTO, "EventNoel_CheckBox" + _isAuto, 656, 592);
						checkboxAuto.setTooltipText(Localization.getInstance().getString("EventNoel_TipCheckBoxAuto" + _isAuto));
					}
					break;
				case CMD_USE_ZMONEY:
					if (initAllOk)
					{
						var type:String = data[1];
						id = int(data[2]);
						price = int(data[3]);
						if (Ultility.payMoney("ZMoney", price))
						{
							useSpecial(type, id);
						}
					}
					break;
				case CMD_USE_BULLET:
					id = int(data[1]);
					changeBullet(id);
					break;
				case CMD_USE_BULLETGOLD:
					changeBulletGold();
					break;
			}
		}
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (!isShowHuntFish)
			{
				return;
			}
			var data:Array = buttonID.split("_");
			var cmd:String  = data[0];
			switch(cmd)
			{
				case CMD_HOME:
				case CMD_BUY_BULLETGOLD:
				case CMD_GUIDE:
				case CMD_STORE:
				case CMD_AUTO_FIRE:
				case CMD_CB_AUTO:
				case CMD_USE_ZMONEY:
				case CMD_USE_BULLET:
				case CMD_USE_BULLETGOLD:
					Mouse.show();
					GameLogic.getInstance().MouseTransform("");
					break;
			}
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (!isShowHuntFish)
			{
				return;
			}
			var data:Array = buttonID.split("_");
			var cmd:String  = data[0];
			switch(cmd)
			{
				case CMD_HOME:
				case CMD_GUIDE:
				case CMD_STORE:
				case CMD_CB_AUTO:
				case CMD_USE_ZMONEY:
				case CMD_USE_BULLET:
				case CMD_USE_BULLETGOLD:
					if (!GuiMgr.getInstance().guiExchangeNoelCollection.IsVisible||!GuiMgr.getInstance().guiStoreNoel.IsVisible)
					{
						GameLogic.getInstance().MouseTransform("EventNoel_ImgMouseTarget", 1, 0, 0, 0);
						Mouse.hide();
					}
					if (GuiMgr.getInstance().guiStoreNoel.IsVisible || GuiMgr.getInstance().guiFinishEventAuto.IsVisible)
					{
						Mouse.show();
						GameLogic.getInstance().MouseTransform("");
					}
					break;
				case CMD_BUY_BULLETGOLD:
					{
						if (!GuiMgr.getInstance().guiBuyMultiRock.IsVisible)
						{
							GameLogic.getInstance().MouseTransform("EventNoel_ImgMouseTarget", 1, 0, 0, 0);
							Mouse.hide();
						}
						break;
					}
			}
		}
		
		/**
		 * sử dụng Bomb1 hay là RainIce1
		 * @param	type
		 * @param	id
		 */
		private function useSpecial(type:String, id:int):void 
		{
			switch(type)
			{
				case "RainIce":
					BulletScenario.getInstance().useRainIce(type, id);
					var timeIce:int = ConfigJSON.getInstance().getItemInfo("Noel_Bullet")["RainIce"]["1"]["Time"];
					var sTime:String = "+" + Ultility.StandardNumber(timeIce) + "s";
					EventUtils.effText(this.img, itmFreeze.img, 0, -20, 0, -60, 0xffff00, sTime);
					break;
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void 
		{
			var id:int;
			switch(e.keyCode)
			{
				case Keyboard.NUMPAD_1:
				case 49://"1"
					changeBulletGold();
					break;
				case Keyboard.NUMPAD_2:
				case Keyboard.NUMPAD_3:
				case Keyboard.NUMPAD_4:
				case 50://"2"
				case 51://"3"
				case 52://"4"
					id = (e.keyCode - Keyboard.NUMPAD_1) < 0 ? (e.keyCode - 49) : (e.keyCode - Keyboard.NUMPAD_1);
					changeBullet(id);
					break;
			}
		}
		/**
		 * xoay súng hướng đến vị trí (x,y)
		 * @param	x vị trí x của điểm đến
		 * @param	y vị trí y của điểm đến
		 */
		public function rotateGun(x:Number, y:Number):Number 
		{
			var alpha:Number = 0;
			if (gun != null && gun.img != null && gun.img.visible && !inEffFire)
			{
				var mousePos:Point = new Point(x, y);
				var vectorDir:Point = mousePos.subtract(gun.CurPos);
				alpha = Math.atan2(vectorDir.y, vectorDir.x) * 180 / Math.PI + 90;
				gun.img.rotation = alpha;
				//gun.img.visible = !inEffFire;
			}
			return alpha;
		}
		
		/**
		 * bắn đạn
		 * @param	desPos vị trí đến
		 */
		public function fire(mouseClickPos:Point):void
		{
			if (inEffFire) return;
			if (EventMgr.CheckEvent(EventMgr.NAME_EVENT) != EventMgr.CURRENT_IN_EVENT)
			{
				BulletScenario.getInstance().TimeOutFlag = true;
				GuiMgr.getInstance().guiHuntFish.Hide();
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết thời gian diễn ra sự kiện Tết", 310, 200, 1);
				return;
			}
			if (BulletScenario.getInstance().RoundUpFlag || 
				BulletScenario.getInstance().TimeOutFlag || 
				BulletScenario.getInstance().inEffIce ||
				GuiMgr.getInstance().guiHuntFish.inEffectComeInRound ||
				GuiMgr.getInstance().guiBuyMultiRock.IsVisible ||
				GuiMgr.getInstance().guifinishRound.IsVisible ||
				GuiMgr.getInstance().guiStoreNoel.IsVisible ||
				GuiMgr.getInstance().guiFinishEventAuto.IsVisible
				)
			{
				return;
			}
			if (GuiMgr.getInstance().guiBuyMultiRock.inHide)
			{
				GuiMgr.getInstance().guiBuyMultiRock.inHide = false;
				canFire = true;
				return;
			}
			if (GuiMgr.getInstance().guifinishRound.inHide)
			{
				GuiMgr.getInstance().guifinishRound.inHide = false;
				canFire = true;
				return;
			}
			if (GuiMgr.getInstance().guiFinishEventAuto.inHide)
			{
				GuiMgr.getInstance().guiFinishEventAuto.inHide = false;
				canFire = true;
				return;
			}
			if (GuiMgr.getInstance().guiStoreNoel.inHide)
			{
				GuiMgr.getInstance().guiStoreNoel.inHide = false;
				canFire = true;
				return;
			}
			
			/*if (!GuiMgr.getInstance().guifinishRound.inHide && GuiMgr.getInstance().guifinishRound.IsVisible)
			{
				return;
			}
			if (!GuiMgr.getInstance().guiStoreNoel.inHide && GuiMgr.getInstance().guiStoreNoel.IsVisible)
			{
				return;
			}*/
			
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var price:int, gold:Number, nameBullet:String;
			if (curTime - preTimeFire > DELTA_TIME_FIRE && canFire)//có thể sinh đạn
			{
				if (BulletScenario.getInstance().UseGold)//dùng vàng
				{
					if (BulletScenario.getInstance().checkHasBulletGold())//còn đạn vàng
					{
						effectGun(mouseClickPos);//effect bắn
						//trace("ban dan vang:");
						//EventSvc.getInstance().updateItem("BulletGold", 1, -1);
					}
					else
					{
						if (autoChangeBulletFromGold())//chuyển đạn từ vàng mà còn đạn
						{
							nameBullet = Localization.getInstance().getString("EventNoel_NameBullet" + BulletScenario.getInstance().bulletId);
							EventUtils.effText(this.img, gun.img, 0, -30, 0, -50, 0xffff00, "Hết Vàng! Chuyển sang " + nameBullet);
						}
						else
						{
							GuiMgr.getInstance().guiBuyMultiRock.priceType = "Money";
							price = ConfigJSON.getInstance().getItemInfo("Noel_Bullet")["BulletGold"]["1"]["Money"];
							GuiMgr.getInstance().guiBuyMultiRock.costPerPack = price;
							var myMoney:Number = GameLogic.getInstance().user.GetMoney();
							GuiMgr.getInstance().guiBuyMultiRock.showGUI(int(myMoney / price), "Đạn Thường", "GuiHuntFish_BulletGoldShop", function f(num:int):void
							{
								if (num > 0)
								{
									if (Ultility.payMoney("Money", price * num))
									{
										var pk:SendBuyBulletGold = new SendBuyBulletGold(num);
										Exchange.GetInstance().Send(pk);
										EventSvc.getInstance().updateItem("BulletGold", 1, num);
										itmBulletGold.refreshTextNum();
									}
								}
							});
						}
					}
				}
				else
				{
					var bulletId:int = BulletScenario.getInstance().bulletId;//đạn hiện tại
					var zmoney:int = GameLogic.getInstance().user.GetZMoney();
					price = ConfigJSON.getInstance().getItemInfo("Noel_Bullet")["Bullet"][bulletId]["ZMoney"];
					if (BulletScenario.getInstance().checkHasBullet())//còn đạn
					{
						if (_isAuto)
						{
							if (price <= zmoney)
							{
								effectGun(mouseClickPos);//effect bắn
							}
						}
						else
						{
							effectGun(mouseClickPos);//effect bắn
						}
					}
					else//đạn hiện tại hết đạn
					{
						if (_isAuto)
						{
							
							
							if (price > zmoney)//hết G
							{
								//cho dùng G bằng false
								if (autoChangeBullet(bulletId))//chuyển đạn thành công
								{
									var str:String;
									var color:Object;
									if (BulletScenario.getInstance().UseGold)
									{
										str = "EventNoel_NameBulletGold";
										color = 0xff0000;
									}
									else
									{
										str = "EventNoel_NameBullet";
										color = 0xffff00;
									}
									nameBullet = Localization.getInstance().getString(str + BulletScenario.getInstance().bulletId);
									EventUtils.effText(this.img, gun.img, 0, -30, 0, -50, color, "Hết G! Chuyển sang " + nameBullet);
								}
								else//hết sạch đạn, hết sạch G
								{
									//MsgBox
								}
							}
							else//còn G
							{
								//GameLogic.getInstance().user.UpdateUserZMoney( -price);
								effectGun(mouseClickPos);//effect bắn
							}
						}
						else
						{
							if (autoChangeBullet(bulletId))//chuyển đạn thành công
							{
								bulletId = BulletScenario.getInstance().bulletId;
								if (BulletScenario.getInstance().UseGold)//chuyển về đạn vàng
								{
									nameBullet = Localization.getInstance().getString("EventNoel_NameBulletGold" + BulletScenario.getInstance().bulletId);
									EventUtils.effText(this.img, gun.img, 0, -30, 0, -50, 0xff0000, "Hết đạn!\nChuyển sang " + nameBullet);
								}
								else
								{
									nameBullet = Localization.getInstance().getString("EventNoel_NameBullet" + BulletScenario.getInstance().bulletId);
									EventUtils.effText(this.img, gun.img, 0, -30, 0, -50, 0xffff00, "Hết đạn!\nChuyển sang " + nameBullet);
								}
								
							}
							else//hết sạch đạn
							{
								//MsgBox
							}
						}
					}
				}
				preTimeFire = curTime;
			}
			canFire = true;
			/*if (!GuiMgr.getInstance().guiExchangeNoelCollection.IsVisible &&
				!GuiMgr.getInstance().guiExchangeNoelItem.IsVisible)
			{
				if(!clickToStore)
					canFire = true;
				else
					clickToStore = false;
			}
			if (!GuiMgr.getInstance().guiStoreNoel.IsVisible)
			{
				if (!clickToStore)
				{
					canFire = true;
				}
				else
				{
					clickToStore = false;
				}
			}*/
			/*if (GuiMgr.getInstance().guiStoreNoel.inHide)
			{
				GuiMgr.getInstance().guiStoreNoel.inHide = false;
				canFire = true;
			}*/
			/*if (GuiMgr.getInstance().guiExchangeNoelCollection.inHide)
			{
				GuiMgr.getInstance().guiExchangeNoelCollection.inHide = false;
				canFire = true;
			}*/
			/*if (GuiMgr.getInstance().guifinishRound.inHide)
			{
				GuiMgr.getInstance().guifinishRound.inHide = false;
				canFire = true;
			}*/
			/*if (GuiMgr.getInstance().guiBuyMultiRock.inHide)
			{
				GuiMgr.getInstance().guiBuyMultiRock.inHide = false;
				canFire = true;
			}*/
		}
		
		private function fireNow(mouseClickPos:Point):void
		{
			if (gun.img == null) return;//nguyên nhân là do timeout hay dayout
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var vectorDir:Point = mouseClickPos.subtract(gun.CurPos);
			vectorDir.normalize(1000);
			var desPos:Point = gun.CurPos.add(vectorDir);
			BulletScenario.getInstance().generateBullet(gun.CurPos, desPos);
			_itmBullet.refreshTextNum();
			//trace("refresh:", _itmBullet.ItemId);
		}
		public function ShowInHunt():void 
		{
			isShowHuntFish = true;
			Show();
		}
		
		override public function removeAllEvent():void 
		{
			if (img == null) return;
			super.removeAllEvent();
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
			layer.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
		}
		
		public function updateTime(curTime:Number):void 
		{
			if (EventMgr.CheckEvent(EventMgr.NAME_EVENT) != EventMgr.CURRENT_IN_EVENT)
			{
				if (isShowHuntFish)
				{
					BulletScenario.getInstance().TimeOutFlag = true;
					GuiMgr.getInstance().guiHuntFish.Hide();
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết thời gian diễn ra sự kiện Tết", 310, 200, 1);
				}
				else
				{
					if (GuiMgr.getInstance().guiGotoHunt.IsVisible)
					{
						GuiMgr.getInstance().guiGotoHunt.Hide();
					}
				}
			}
			if (isShowHuntFish)
			{
				if (GuiMgr.getInstance().guiHuntFish.IsFinishRoomOut)//đếm thời gian ở cái progress
				{
					var round:RoundNoel = RoundScene.getInstance().Round;
					if (curTime - _timeGui > 1)
					{
						var timeStart:Number = round.getTimeStart();
						var passTime:Number = curTime - timeStart;
						var timeRound:Number = round.getTimeRound();
						var remainTime:Number = timeRound - passTime - 2;//cho hết trước 2s
						if (remainTime < 0)//thông báo hết giờ
						{
							BulletScenario.getInstance().TimeOutFlag = true;
							EventNoelMgr.getInstance().LastTimeFinish = GameLogic.getInstance().CurServerTime;
							GuiMgr.getInstance().guiHuntFish.Hide();
							_isUpdateToFire = false;
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết thời gian chơi", 310, 200, 1);
							EventNoelMgr.getInstance().StartTimeGame = -1;
							return;
						}
						else//còn thời gian
						{
							tfTime.text = Ultility.convertToTime(int(remainTime));
							if (RoundScene.getInstance().InUseIce)//trong thời gian đóng băng
							{
								var remainTimeIce:Number = RoundScene.getInstance().getRemainTimeIce(curTime);
								tfTimeIce.text = Ultility.convertToTime(int(remainTimeIce));
								var inUseIce:Boolean = RoundScene.getInstance().InUseIce = remainTimeIce > 0;
								if (!inUseIce)
								{
									RoundScene.getInstance().unFreezeAll();
									tfTimeIce.visible = false;
								}
							}
						}
						_timeGui = curTime;
						prgClock.setStatus(remainTime / timeRound);
					}
				}
				//đếm thời gian 1s kể từ lần cuối khai hỏa gửi lên 1 phát
				if (GuiMgr.getInstance().guiHuntFish.IsInitAllOk)
				{
					if (_isUpdateToFire)
					{
						if (curTime - _lastTimeFire > DELTA_TIME_SEND_FIREGUN)
						{
							var isSendOk:Boolean = GuiMgr.getInstance().guiHuntFish.sendFireGun();
							if (isSendOk)//nếu có dữ liệu fireInfo
							{
								BulletScenario.getInstance().flushAllFireInfo();
							}
							_isUpdateToFire = false;
						}
					}
				}
			}
		}
		
		public function updateFishDie():void
		{
			var numFishDie:int = RoundScene.getInstance().Round.NumFishDie;
			var fishRequired:int = RoundScene.getInstance().Round.getNumRequired();
			prgFishDie.setStatus(numFishDie / fishRequired);
			tfFishDie.text = Ultility.StandardNumber(numFishDie) + "/" + Ultility.StandardNumber(fishRequired);
		}
		
		public function updateRoundBar():void
		{
			var idRound:int = RoundScene.getInstance().Round.IdRound;			//id của round hiện tại
			var icTick:Image, icRound:Image, passRound:Boolean;
			for (var i:int = 1; i <= 5; i++)
			{
				icTick = this["icTick" + i];
				icRound = this["icRound" + i];
				passRound = i < idRound;
				icTick.img.visible = passRound;
				icRound.img.visible = !passRound;
			}
			imgRoundSelect.img.x = 231 + (idRound - 1) * 82;
		}
		
		override public function OnHideGUI():void 
		{
			isShowHuntFish = false;
		}
		
		public function effectGun(mouseClickPos:Point):void 
		{
			rotateGun(mouseClickPos.x, mouseClickPos.y);
			gun.img.visible = false;
			inFire = true;
			inEffFire = true;
			var swf:EffGunFire = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER,
													"GuiHuntFish_EffGunFire",
													null, gun.img.x, gun.img.y, false, false, null,
													gunComp) as EffGunFire;
			swf.img.rotation = gun.img.rotation;
			swf.funcJoin = function joinFrame():void
			{
				if (!BulletScenario.getInstance().TimeOutFlag && !BulletScenario.getInstance().RoundUpFlag)
				{
					fireNow(mouseClickPos);
				}
			}
			function gunComp():void
			{
				inEffFire = false;
				if (!BulletScenario.getInstance().TimeOutFlag)
				{
					if(gun.img)
						gun.img.visible = true;
				}
			}
		}
		/**
		 * bắt đầu tính thời điểm để gửi gói tin bắn
		 */
		public function startTimeFire():void 
		{
			_isUpdateToFire = true;
			_lastTimeFire = GameLogic.getInstance().CurServerTime;
		}
		
		public function initPrgFishDie():void 
		{
			var isShow:Boolean = RoundScene.getInstance().Round.IdRound != RoundNoel.ROUND_BOSS;
			prgFishDie.setVisible(isShow);
			imgFishDie.img.visible = isShow;
			tfFishDie.visible = isShow;
			if(isShow)
				updateFishDie();
		}
		
		public function startUseIce():void 
		{
			tfTimeIce.visible = true;
		}
		override public function ClearComponent():void 
		{
			if (isShowHuntFish)
			{
				for (var i:int = 1; i <= 3; i++)
				{
					if (this["itmBullet" + i] != null)
					{
						var itm:ItemBullet = this["itmBullet" + i];
						itm.Destructor();
					}
				}
				if (itmBulletGold != null)
				{
					itmBulletGold.Destructor();
				}
			}
			
			
			super.ClearComponent();
		}
		
		public function getIsAuto():Boolean 
		{
			return _isAuto;
		}
	}
}






















