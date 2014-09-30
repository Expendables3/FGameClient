package GUI.BossServer 
{
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.BitmapEffect;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.BaseObject;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.SendGetAllSoldier;
	import NetworkPacket.PacketSend.SendInitRun;
	import particleSys.myFish.CometEmit;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIMainBossServer extends BaseGUI 
	{
		static public const BTN_HOME:String = "btnHome";
		static public const BTN_ATTACK:String = "btnAttack";
		static public const BTN_DICE:String = "btnDice";
		static public const EFF_DICE_BUFF:String = "effDiceBuff";
		static public const EFF_FIGHTING:String = "effFighting";
		static public const EFF_DESTROY_CASTLE:String = "effDestroyCastle";
		static public const CTN_TOP_INFO:String = "ctnTopInfo";
		static public const BTN_REBORN_GOLD:String = "btnReborn";
		static public const GIFT_STONE:String = "giftStone";
		static public const IC_TICKED:String = "icTicked";
		static public const BTN_REBORN_ZMONEY:String = "btnRebornZMoney";
		static public const TOP_GIFT:String = "topGift";
		static public const BTN_DICE_VIP:String = "btnDiceVip";
		static public const BTN_DICE_ZMONEY:String = "btnDiceZmoney";
		static public const BTN_DICE_GOLD:String = "btnDiceGold";
		private var prgCastle:ProgressBar;
		private var ctnDice:Container;
		private var labelDiceValue:TextField;
		private var imageCastle:Image;
		private var imageBoss:Image;
		private var _diceValue:int;
		
		private var emitStar:Array = [];
		private var effState:String = "";
		private var fightingTurn:int;
		private var count:int;
		private var _remainTime:int;
		private var labelRemainTime:TextField;
		private var lastTimeAttack:Number=0;
		private var bossId:int;
		private var hasDiceResult:Boolean = false;
		private var diceResult:int;
		private var attackData:Object;
		private var hasAttackBossResult:Boolean = false;
		private var finishEffDiceBuff:Boolean = false;
		private var diedSoldiers:Object;
		private var swfEffDestroy:BitmapEffect;
		private var labelDiceCostZMoney:TextField;
		private var _costDice:int;
		private var prgBoss:ProgressBar;
		private var ctnTopInfo:Container;
		private var loadContentComplete:Boolean = false;
		public var dataRoom:Object;
		private var labelBossVitality:TextField;
		private var labelCastle:TextField;
		private var ctnAutoReborn:Container;
		private var ctnDiceValue:Container;
		private var imgPrgBoss:Image;
		private var isBossShock:Boolean = false;
		//private var imgIcZMoney:Image;
		private var configWaitTime:Object;
		private var freeDice:int;
		private var btnFree:Button;
		private var btnZMoney:Button;
		private var prgGift:ProgressBar;
		private var labelTotalDamage:TextField;
		private var attackNum:int;
		private var maxDamageGift:Number;
		private var configGift:Object;
		private var labelCostRebornGold:TextField;
		private var _costReborn:int;
		private var _costRebornGold:int;
		private var labelCostRebornZMoney:TextField;
		private var circle:Sprite;
		private var ctnGiftStone:Container;
		private var _totalDamage:Number;
		private var castleTime:Number;
		private var MAX_NUM_ATTACK:int;
		private var ctnDiceVip:Container;
		private var _diceValueVip:int;
		private var labelDiceCostVip:TextField;
		private var ctnDiceValueVip:Container;
		private var btnZMoneyVip:Button;
		private var labelDiceValueVip:TextField;
		private var _costDiceVip:int;
		private var hasDiceResultVip:Boolean;
		private var diceResultVip:int;
		private var btnGold:Button;
		private var labelDiceCostGold:TextField;
		private var _costDiceGold:int;
		private var btnFreeVip:Button;
		private var freeDiceVip:int;
		private var configDice:Object;
		private var imgDice:Container;
		private var imgDiceVip:Container;
		
		public function GUIMainBossServer(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{	
				configDice = ConfigJSON.getInstance().GetItemList("ServerBossDice");
				configWaitTime = ConfigJSON.getInstance().GetItemList("ServerBossTime");
				var count:int = 0;
				for (var k:String in configWaitTime)
				{
					count ++;
				}
				MAX_NUM_ATTACK = count;
				
				//Moc qua
				configGift = ConfigJSON.getInstance().GetItemList("ServerBossGift");
				configGift = configGift[bossId];
				ctnGiftStone = AddContainer("", "", 0, 0);
				ctnGiftStone.LoadRes("");
				prgGift = ctnGiftStone.AddProgress("", "GuiMainBossServer_GiftStoneBar", 140, 50);
				prgGift.SetBackGround("GuiMainBossServer_GiftStoneBg");
				prgGift.SetPosBackGround( -70, -8);
				labelTotalDamage = ctnGiftStone.AddLabel("0", 140 - 83, 47, 0xffff00, 1, 0x000000);
				maxDamageGift = 0;
				var s:String;
				for(s in configGift)
				{
					if (maxDamageGift < configGift[s]["DamageRequire"])
					{
						maxDamageGift = configGift[s]["DamageRequire"];
					}
				}
				for (s in configGift)
				{
					ctnGiftStone.AddContainer(GIFT_STONE + "_" + s, "GuiMainBossServer_GiftStone", 120 + Number(configGift[s]["DamageRequire"]) / maxDamageGift * 447, 40, true, this);
					ctnGiftStone.AddImage(IC_TICKED + "_" + s, "GuiMainBossServer_IcTicked", 140 + Number(configGift[s]["DamageRequire"]) / maxDamageGift * 447, 40).img.visible = false;
					ctnGiftStone.AddLabel(Ultility.StandardNumber(configGift[s]["DamageRequire"]), 90 + Number(configGift[s]["DamageRequire"])/maxDamageGift *447, 82, 0xffff00, 1, 0x000000);
				}
				
				//Lau dai
				imageCastle = AddImage("", "GuiMainBossServer_Castle", 25, 150, true, ALIGN_LEFT_TOP, true);
				prgCastle = AddProgress("", "GuiMainBossServer_PrgVitality", 300 - 95 - 153, 125);
				prgCastle.SetBackGround("GuiMainBossServer_PrgVitality_Bg");
				AddImage("", "GuiMainBossServer_ImgPrgVitalBg", 300 - 155, 400 - 266);
				prgCastle.setStatus(0);
				labelCastle = AddLabel("0", 93, 123, 0xffffff, 1, 0x000000);
				effState = EFF_DESTROY_CASTLE;
				AddImage("", "GuiMainBossServer_Guide", 225, 190);
				
				//Boss
				prgBoss = AddProgress("", "GuiMainBossServer_PrgVitality", 450, 125);
				prgBoss.SetBackGround("GuiMainBossServer_PrgVitality_Bg");
				imgPrgBoss = AddImage("", "GuiMainBossServer_ImgPrgVitalBg", 543, 131);
				prgBoss.setStatus(1);
				imageBoss = AddImage("", "BossServer" + bossId + "_AttackNormal", 520, 350, true, ALIGN_LEFT_TOP, true);
				imageBoss.img.mouseEnabled = false;
				circle = new Sprite();
				circle.graphics.beginFill(0xff0000, 0);
				circle.graphics.drawCircle(500, 350, 70);
				circle.graphics.endFill();
				circle.buttonMode = true;
				this.img.addChild(circle);
				circle.addEventListener(MouseEvent.CLICK,  function clickCircle(e:MouseEvent):void 
				{
					OnButtonClick(e, BTN_ATTACK);
				});
				//imageBoss.img.scaleX = -1;
				labelBossVitality = AddLabel("", 502, 123, 0xffffff, 1, 0x000000);
				
				//Qua top
				for (var i:int = 1; i < 4; i++)
				{
					AddContainer(TOP_GIFT + "_" + i, "GuiMainBossServer_GiftTrunk" + i, 580 + i * 60, 500 - 92, true, this);
				}
				AddContainer(TOP_GIFT + "_" + i, "GuiMainBossServer_GiftTrunk4", 580 + 120, 500 - 25, true, this);
				
				//Xuc xac
				ctnDiceValue = AddContainer("", "GuiMainBossServer_DiceBg", 304 - 255, 480);
				btnFree = ctnDiceValue.AddButton(BTN_DICE, "GuiMainBossServer_BtnFree", 62 +15, 100, this);
				btnZMoney = ctnDiceValue.AddButton(BTN_DICE_ZMONEY, "GuiMainBossServer_BtnG", 62 + 15 + 35, 100, this);
				btnZMoney.SetVisible(false);
				btnGold = ctnDiceValue.AddButton(BTN_DICE_GOLD, "GuiMainBossServer_BtnGold", 62 + 15 - 45, 100, this);
				btnGold.SetVisible(false);
				labelDiceValue = ctnDiceValue.AddLabel("0%", 122, 24, 0xffffff, 1, 0x000000);
				var txtFormat:TextFormat = new TextFormat("arial", 15, 0xffff00, true);
				labelDiceValue.setTextFormat(txtFormat);
				labelDiceValue.defaultTextFormat = txtFormat;
				labelDiceCostZMoney = ctnDiceValue.AddLabel("", 42 + 15 + 35, 102, 0xffffff, 1, 0x000000);
				labelDiceCostGold = ctnDiceValue.AddLabel("", 42 + 15 - 45, 102, 0xffffff, 1, 0x000000);
				imgDice = ctnDiceValue.AddContainer("", "Dice1", 80, 50);
				imgDice.SetScaleXY(0.6);
				ctnDice = ctnDiceValue.AddContainer("", "GuiMainBossServer_EffRandomDice", 380 - 304, 538 - 480, true, this);
				ctnDice.GoToAndStop(0);
				ctnDice.SetScaleXY(0.4);
				//diceValue = 1;
				var tooltip:String = "Xúc xắc tăng tấn công\ncho toàn bộ ngư thủ:\n";
				for (s in configDice["1"])
				{
					if(int(s) > 0)
					{
						tooltip += "Mặt " + s + " tăng " + Ultility.StandardNumber(configDice["1"][s]) + "%\n";
					}
				}
				imgDice.setTooltipText(tooltip);
				ctnDice.setTooltipText(tooltip);
				MovieClip(ctnDice.img.getChildByName("Child1")).gotoAndStop(1);
				ctnDice.img.buttonMode = true;
				
				//Xuc xac vip
				ctnDiceValueVip = AddContainer("", "GuiMainBossServer_DiceBg", 304 - 55, 480);
				btnFreeVip = ctnDiceValueVip.AddButton(BTN_DICE_VIP, "GuiMainBossServer_BtnFree", 62 +15, 100, this);
				btnZMoneyVip = ctnDiceValueVip.AddButton(BTN_DICE_VIP, "GuiMainBossServer_BtnG", 62 + 15, 100, this);
				btnZMoneyVip.SetVisible(false);
				labelDiceValueVip = ctnDiceValueVip.AddLabel("0%", 122, 24, 0xffffff, 1, 0x000000);
				txtFormat = new TextFormat("arial", 15, 0xffff00, true);
				labelDiceValueVip.setTextFormat(txtFormat);
				labelDiceValueVip.defaultTextFormat = txtFormat;
				labelDiceCostVip = ctnDiceValueVip.AddLabel("", 42 + 15, 102, 0xffffff, 1, 0x000000);
				imgDiceVip = ctnDiceValueVip.AddContainer("", "Dice1", 80, 50);
				imgDiceVip.SetScaleXY(0.6);
				ctnDiceVip = ctnDiceValueVip.AddContainer(BTN_DICE_VIP, "GuiMainBossServer_EffRandomDice", 380 - 304, 538 - 480, true, this);
				ctnDiceVip.GoToAndStop(0);
				ctnDiceVip.SetScaleXY(0.4);
				//diceValueVip = 1;
				TweenMax.to(ctnDiceVip.img, 0.1, { glowFilter: { color:0x9900ff, alpha:1, blurX:10, blurY:10, strength:2.5 }} );
				TweenMax.to(imgDiceVip.img, 0.1, { glowFilter: { color:0x9900ff, alpha:1, blurX:10, blurY:10, strength:2.5 }} );
				tooltip = "Xúc xắc tăng tấn công\ncho toàn bộ ngư thủ:\n";
				for (s in configDice["2"])
				{
					if(int(s) > 0)
					{
						tooltip += "Mặt " + s + " tăng " + Ultility.StandardNumber(configDice["2"][s]) + "%\n" 
					}
				}
				imgDiceVip.setTooltipText(tooltip);
				ctnDiceVip.setTooltipText(tooltip);
				MovieClip(ctnDiceVip.img.getChildByName("Child1")).gotoAndStop(1);
				ctnDiceVip.img.buttonMode = true;
				
				AddButton(BTN_ATTACK, "GuiMainBossServer_BtnAttackBoss", 600 -141, 500 - 13).SetEnable(false);
				
				ctnAutoReborn = AddContainer("", "", 250 , 200, true);
				ctnAutoReborn.LoadRes("");
				ctnAutoReborn.img.graphics.beginFill(0x000000, 0.5);
				ctnAutoReborn.img.graphics.drawRect( -Constant.STAGE_WIDTH, -Constant.STAGE_HEIGHT, 2 * Constant.STAGE_WIDTH, 2 * Constant.STAGE_HEIGHT);
				ctnAutoReborn.img.graphics.endFill();
				ctnAutoReborn.AddImage("", "GuiMainBossServer_ImgAutoReborn", 0, 0, true, ALIGN_LEFT_TOP);
				ctnAutoReborn.AddButton(BTN_REBORN_GOLD, "GuiMainBossServer_BtnReborn", 129 - 88 - 20, 108, this);
				ctnAutoReborn.AddButton(BTN_REBORN_ZMONEY, "GuiMainBossServer_BtnRebornZMoney", 129 + 43, 108, this);
				labelCostRebornGold = ctnAutoReborn.AddLabel("1000", 80 -12, 112, 0xffffff, 1, 0x000000);
				labelCostRebornZMoney = ctnAutoReborn.AddLabel("1000", 80 +68 + 47, 112, 0xffffff, 1, 0x000000);
				costRebornZMoney = 0;
				costRebornGold = 0;
				labelRemainTime = ctnAutoReborn.AddLabel("Tự động hồi sinh: ", 163 - 52, 103 - 46, 0xffffff, 1, 0x000000);
				txtFormat = new TextFormat("arial", 20, 0xffffff, true);
				txtFormat.align = "center";
				labelRemainTime.defaultTextFormat = txtFormat;
				remainTime = 0;
				
				//Home
				AddButtonEx(BTN_HOME, "BtnHome", 316 + 415, 20).SetScaleXY(0.7);
				
				loadContentComplete = true;
				if(dataRoom != null)
				{
					updateRoomInfo(dataRoom);
				}
			}
			loadContentComplete = false;
			LoadRes("GuiMainBossServer_Theme");
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var title:String;
			if (buttonID.search(GIFT_STONE) >= 0)
			{
				var stone:int = buttonID.split("_")[1];
				title = "Phần thưởng Tích Lũy\n<font color='#ffffff' size = '12'>Dành cho người chơi tiêu diệt " + Ultility.StandardNumber(configGift[stone]["DamageRequire"]) + " máu " + Localization.getInstance().getString("BossServer" + bossId) + "</font>";
				GuiMgr.getInstance().guiTooltipGiftStone.showGUI(configGift[stone]["Gift"], event.stageX, event.stageY, title);
			}
			else
			if (buttonID.search(TOP_GIFT) >= 0)
			{
				var top:int = buttonID.split("_")[1];
				var config:Object = ConfigJSON.getInstance().GetItemList("ServerBossBonus")[bossId];
				switch(top)
				{
					case 1:
						title = "Phần thưởng Top 1\n<font color='#ffffff' size = '12'>Dành cho người chơi có thứ hạng cao nhất</font>";
						break;
					case 2:
						title = "Phần thưởng Top 5\n<font color='#ffffff' size = '12'>Dành cho người chơi có thứ hạng từ 2 đến 5</font>";
						break;
					case 3:
						title = "Phần thưởng Top 10\n<font color='#ffffff' size = '12'>Dành cho người chơi có thứ hạng từ 6 đến 10</font>";
						break;
					case 4:
						title = "Phần thưởng Kết Liễu\n<font color='#ffffff' size = '12'>Dành cho người chơi kết liễu " + Localization.getInstance().getString("BossServer" + bossId) + "</font>";
				}
				if (top < 4)
				{
					GuiMgr.getInstance().guiTooltipGiftStone.showGUI(config["TopBonus_" + Math.max(1,(top-1)*5)], event.stageX, event.stageY, title);
				}
				else
				{
					GuiMgr.getInstance().guiTooltipGiftStone.showGUI(config["LastHitBonus"], event.stageX, event.stageY, title);
				}
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(GIFT_STONE) >= 0 || buttonID.search(TOP_GIFT) >= 0)
			{
				GuiMgr.getInstance().guiTooltipGiftStone.Hide();
			}
		}
		
		public function get diceValue():int 
		{
			return _diceValue;
		}
		
		public function set diceValue(value:int):void 
		{
			_diceValue = value;
			if (value > 0)
			{
				labelDiceValue.text = "+" + Ultility.StandardNumber(configDice["1"][value]) + "%";
				imgDice.img.visible = false;
				ctnDice.SetVisible(true);
				if (ctnDiceValueVip != null && ctnDiceValueVip.img != null)
				{
					ctnDiceValueVip.SetVisible(false);
				}
			}
			else
			{
				labelDiceValue.text = "+0%";
				imgDice.img.visible = true;
				ctnDice.SetVisible(false);
			}
		}
		
		public function get remainTime():int 
		{
			return _remainTime;
		}
		
		public function set remainTime(value:int):void 
		{
			_remainTime = value;
			if (value > 0)
			{
				//labelRemainTime.visible = true;
				ctnAutoReborn.SetVisible(true);
				labelRemainTime.htmlText =  value.toString() + " giây";
			}
			else
			{
				//labelRemainTime.visible = false;
				ctnAutoReborn.SetVisible(false);
			}
		}
		
		public function get costDiceZMoney():int 
		{
			return _costDice;
		}
		
		public function set costDiceZMoney(value:int):void 
		{
			_costDice = value;
			if (value == 0)
			{
				btnZMoney.SetVisible(false);
				btnGold.SetVisible(false);
				btnFree.SetVisible(true);
				btnFree.SetEnable(true);
				labelDiceCostZMoney.text = "";
			}
			else
			{
				labelDiceCostZMoney.text = Ultility.StandardNumber(value);
				btnZMoney.SetVisible(true);
				btnZMoney.SetEnable(true);
				btnGold.SetVisible(true);
				btnGold.SetEnable(true);
				btnFree.SetVisible(false);
			}
		}
		
		public function get costRebornZMoney():int 
		{
			return _costReborn;
		}
		
		public function set costRebornZMoney(value:int):void 
		{
			_costReborn = value;
			labelCostRebornZMoney.text = Ultility.StandardNumber(value);
			if(value > 0)
			{
				ctnAutoReborn.GetButton(BTN_REBORN_ZMONEY).SetEnable(true);
			}
			else
			{
				ctnAutoReborn.GetButton(BTN_REBORN_ZMONEY).SetEnable(false);
			}
		}
		
		public function get costRebornGold():int 
		{
			return _costRebornGold;
		}
		
		public function set costRebornGold(value:int):void 
		{
			_costRebornGold = value;
			labelCostRebornGold.text = Ultility.StandardNumber(value);
			if (value > 0)
			{
				ctnAutoReborn.GetButton(BTN_REBORN_GOLD).SetEnable(true);
			}
			else
			{
				ctnAutoReborn.GetButton(BTN_REBORN_GOLD).SetEnable(false);
			}
		}
		
		public function get totalDamage():Number 
		{
			return _totalDamage;
		}
		
		public function set totalDamage(value:Number):void 
		{
			_totalDamage = value;
			prgGift.setStatus(totalDamage / maxDamageGift);
			labelTotalDamage.text = Ultility.StandardNumber(totalDamage);
		}
		
		public function get diceValueVip():int 
		{
			return _diceValueVip;
		}
		
		public function set diceValueVip(value:int):void 
		{
			_diceValueVip = value;
			if (value > 0)
			{
				labelDiceValueVip.text = "+" + Ultility.StandardNumber(configDice["2"][value]) + "%";
				imgDiceVip.img.visible = false;
				ctnDiceVip.SetVisible(true);
				if (ctnDiceValue != null && ctnDiceValue.img != null)
				{
					ctnDiceValue.SetVisible(false);
				}
			}
			else
			{
				labelDiceValueVip.text = "+0%";
				ctnDiceVip.SetVisible(false);
				imgDiceVip.img.visible = true;
			}
		}
		
		public function get costDiceVip():int 
		{
			return _costDiceVip;
		}
		
		public function set costDiceVip(value:int):void 
		{
			_costDiceVip = value;
			if (value == 0)
			{
				labelDiceCostVip.text = "";
				btnZMoneyVip.SetVisible(false);
				btnFreeVip.SetVisible(true);
			}
			else
			{
				labelDiceCostVip.text = Ultility.StandardNumber(value);
				btnFreeVip.SetVisible(false);
				btnZMoneyVip.SetVisible(true);
				btnZMoneyVip.SetEnable(true);
			}
		}
		
		public function get costDiceGold():int 
		{
			return _costDiceGold;
		}
		
		public function set costDiceGold(value:int):void 
		{
			_costDiceGold = value;
			if (value == 0)
			{
				btnGold.SetVisible(false);
				btnFree.SetVisible(true);
				btnFree.SetEnable(true);
				labelDiceCostGold.text = "";
			}
			else
			{
				labelDiceCostGold.text = Ultility.StandardNumber(value);
				btnGold.SetVisible(true);
				btnGold.SetEnable(true);
				btnFree.SetVisible(false);
			}
		}
		
		override public function OnHideGUI():void 
		{
			attackData = null;
			dataRoom = null;
			//Update particle
			for (var i:int; i < emitStar.length; i++)
			{
				emitStar[i].destroy();
				emitStar.splice(i, 1);
				i--;	
			}		
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var configJoinTime:Object = ConfigJSON.getInstance().GetItemList("Param")["ServerBoss"]["JoinTime"];
			var arrTimeStone:Array = new Array();
			var minuteFighting:int = 60;
			for (var h:String in configJoinTime)
			{
				var beginTime:String = configJoinTime[h]["BeginTime"];
				var arr:Array = beginTime.split("-");
				arrTimeStone.push(arr[0]);
				
				var endTime:String = configJoinTime[h]["EndTime"];
				var arr2:Array = endTime.split("-");
				minuteFighting = (Number(arr2[0]) - Number(arr[0])) * 60 + Number(arr2[1]) - Number(arr[1]);
			}
			
			var firstPoint:int = Math.min(arrTimeStone[0], arrTimeStone[1]);
			var secondPoint:int = Math.max(arrTimeStone[0], arrTimeStone[1]);
			var date:Date = new Date();
			date.setTime((GameLogic.getInstance().CurServerTime  + 7*3600) * 1000);
			//trace("h= " + date.hoursUTC + ", m= " + date.minutesUTC);
			castleTime = 0;
			if(date.hoursUTC == firstPoint)
			{
				castleTime = (minuteFighting - date.minutesUTC)*60 - date.secondsUTC;
			}
			if (date.hoursUTC == secondPoint)
			{
				castleTime = (minuteFighting - date.minutesUTC) * 60 - date.secondsUTC;
			}
			//trace("castle time", castleTime);		
			if (buttonID != BTN_HOME && (dataRoom == null  || castleTime <= 0))
			{
				return;
			}
			switch(buttonID)
			{
				case BTN_DICE_VIP:
					if(MovieClip(ctnDiceVip.img).currentFrame == 1 || MovieClip(ctnDiceVip.img).currentFrame == 30)
					{
						if (GameLogic.getInstance().user.GetZMoney() >= costDiceVip)
						{
							ctnDiceValue.SetVisible(false);
							imgDiceVip.img.visible = false;
							ctnDiceVip.SetVisible(true);
							hasDiceResultVip = false;
							ctnDiceVip.GoToAndPlay(0);
							Exchange.GetInstance().Send( new SendRandomDice("ZMoney", 2));
							GetButton(BTN_ATTACK).SetEnable(false);
							if (costDiceVip > 0)
							{
								GameLogic.getInstance().user.UpdateUserZMoney( -costDiceVip);
							}
							costDiceVip = configDice["2"]["ZMoney"];
						}
						else
						{
							GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
						}
					}
					break;
				case BTN_DICE:
					//trace(MovieClip(ctnDice.img).currentFrame);
					if(MovieClip(ctnDice.img).currentFrame == 1 || MovieClip(ctnDice.img).currentFrame == 30)
					{
						ctnDiceValueVip.SetVisible(false);
						imgDice.img.visible = false;
						ctnDice.SetVisible(true);
						freeDice --;
						hasDiceResult = false;
						ctnDice.GoToAndPlay(0);
						Exchange.GetInstance().Send( new SendRandomDice("Money", 1));
						GetButton(BTN_ATTACK).SetEnable(false);
						
						if(freeDice <= 0)
						{
							costDiceZMoney = configDice["1"]["ZMoney"];
							costDiceGold = configDice["1"]["Money"];
						}
						else
						{
							costDiceZMoney = 0;
							costDiceGold = 0;
						}
					}
					break;
				case BTN_DICE_ZMONEY:
					//trace(MovieClip(ctnDice.img).currentFrame);
					if(MovieClip(ctnDice.img).currentFrame == 1 || MovieClip(ctnDice.img).currentFrame == 30)
					{
						if (GameLogic.getInstance().user.GetZMoney() >= costDiceZMoney)
						{
							ctnDiceValueVip.SetVisible(false);
							imgDice.img.visible = false;
							ctnDice.SetVisible(true);
							freeDice --;
							hasDiceResult = false;
							ctnDice.GoToAndPlay(0);
							Exchange.GetInstance().Send( new SendRandomDice("ZMoney", 1));
							GetButton(BTN_ATTACK).SetEnable(false);
							if (costDiceZMoney > 0)
							{
								GameLogic.getInstance().user.UpdateUserZMoney( -costDiceZMoney);
							}
							if(freeDice <= 0)
							{
								costDiceZMoney = configDice["1"]["ZMoney"]
							}
							else
							{
								costDiceZMoney = 0;
							}
						}
						else
						{
							GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
						}
					}
					break;
				case BTN_DICE_GOLD:
					//trace(MovieClip(ctnDice.img).currentFrame);
					if(MovieClip(ctnDice.img).currentFrame == 1 || MovieClip(ctnDice.img).currentFrame == 30)
					{
						if (GameLogic.getInstance().user.GetMoney() >= costDiceGold)
						{
							ctnDiceValueVip.SetVisible(false);
							imgDice.img.visible = false;
							ctnDice.SetVisible(true);
							hasDiceResult = false;
							ctnDice.GoToAndPlay(0);
							Exchange.GetInstance().Send( new SendRandomDice("Money", 1));
							GetButton(BTN_ATTACK).SetEnable(false);
							if (costDiceGold > 0)
							{
								GameLogic.getInstance().user.UpdateUserMoney( -costDiceGold);
							}
						}
						else
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ tiền vàng!");
						}
					}
					break;
				case BTN_REBORN_ZMONEY:
					if (GameLogic.getInstance().user.GetZMoney() >= costRebornZMoney)
					{
						GameLogic.getInstance().user.UpdateUserZMoney(-costRebornZMoney);
						remainTime = 0;
						Exchange.GetInstance().Send(new SendGiveBirth("ZMoney"));
					}
					else
					{
						GuiMgr.getInstance().GuiNapG.Show();
					}
					break;
				case BTN_REBORN_GOLD:
					if (GameLogic.getInstance().user.GetMoney() >= costRebornGold)
					{
						GameLogic.getInstance().user.UpdateUserMoney(-costRebornGold);
						remainTime = 0;
						Exchange.GetInstance().Send(new SendGiveBirth("Money"));
					}
					else
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ vàng!");
					}
					break;
				case BTN_HOME:
					Hide();
					//GuiMgr.getInstance().guiUserInfo.Hide();
					//GuiMgr.getInstance().GuiSetting.Hide();
					GameController.getInstance().gotoMode(GameController.GAME_MODE_HOME);
					break;
				case BTN_ATTACK:
					var i:int;
					for (i = 0; i < img.numChildren; i++)
					{
						img.getChildAt(i).visible = false;
					}
					prgBoss.visible = true;
					imgPrgBoss.img.visible = true;
					labelBossVitality.visible = true;
					ctnGiftStone.img.visible = true;
					if (diceValue > 0)
					{
						ctnDiceValue.SetVisible(true);
						ctnDiceValue.img.mouseChildren = false;
						ctnDiceValue.img.mouseEnabled = false;
						btnFree.SetEnable(false);
						btnZMoney.SetEnable(false);
						btnGold.SetEnable(false);
					}
					else if(diceValueVip > 0)
					{
						ctnDiceValueVip.SetVisible(true);
						ctnDiceValueVip.img.mouseChildren = false;
						ctnDiceValueVip.img.mouseEnabled = false;
						btnFreeVip.SetEnable(false);
						btnZMoneyVip.SetEnable(false);
					}
					
					if (swfEffDestroy != null)
					{
						swfEffDestroy.FinishEffect();
					}
					// Tính các tọa độ cá nhà mình bơi ra
					var centerP:Point;
					var arrPosition:Array = [];
					switch(Ultility.RandomNumber(2, 4))
					{
						//case 1:
							//centerP= new Point(600, 450);
							//arrPosition.push(new Point(centerP.x + 50, centerP.y));
							//arrPosition.push(new Point(centerP.x + 50, centerP.y - 90));
							//arrPosition.push(new Point(centerP.x + 50, centerP.y + 90));
							//arrPosition.push(new Point(centerP.x - 50, centerP.y));
							//arrPosition.push(new Point(centerP.x - 50, centerP.y - 90));
							//arrPosition.push(new Point(centerP.x - 50, centerP.y + 90));
							//break;
						case 2:
							centerP= new Point(500, 450);
							arrPosition.push(new Point(centerP.x, centerP.y));
							arrPosition.push(new Point(centerP.x + 100, centerP.y - 100*Math.tan(Math.PI/6)));
							arrPosition.push(new Point(centerP.x + 100, centerP.y + 100*Math.tan(Math.PI/6)));
							arrPosition.push(new Point(centerP.x -100, centerP.y));
							arrPosition.push(new Point(centerP.x, centerP.y - 100));
							arrPosition.push(new Point(centerP.x, centerP.y + 100));
							break;
						case 4:
							centerP= new Point(550, 450);
							arrPosition.push(new Point(centerP.x - 80, centerP.y - 80*Math.tan(Math.PI/6)));
							arrPosition.push(new Point(centerP.x - 80, centerP.y + 80*Math.tan(Math.PI/6)));
							arrPosition.push(new Point(centerP.x, centerP.y - 80));
							arrPosition.push(new Point(centerP.x, centerP.y + 80));
							arrPosition.push(new Point(centerP.x + 70*Math.tan(Math.PI/3), centerP.y - 3*70*Math.tan(Math.PI/6)));
							arrPosition.push(new Point(centerP.x + 70*Math.tan(Math.PI/3), centerP.y + 3*70*Math.tan(Math.PI/6)));
							break;
						case 3:
							centerP= new Point(600, 450);
							arrPosition.push(new Point(centerP.x+20, centerP.y));
							arrPosition.push(new Point(centerP.x - 80, centerP.y - 80*Math.tan(Math.PI/6)));
							arrPosition.push(new Point(centerP.x - 80, centerP.y + 80*Math.tan(Math.PI/6)));
							arrPosition.push(new Point(centerP.x - 160, centerP.y));
							arrPosition.push(new Point(centerP.x - 160, centerP.y - 160*Math.tan(Math.PI/6)));
							arrPosition.push(new Point(centerP.x - 160, centerP.y + 160*Math.tan(Math.PI/6)));
							break;
					}
					
					var myInfo:User = GameLogic.getInstance().user;
					GameLogic.getInstance().arrSoldier = new Array();
					i = 0;
					for (var s:String in myInfo.soldierList)
					{
						for (var t:String in myInfo.soldierList[s])
						{
							if (myInfo.soldierList[s][t]["Status"] != 2)
							{
								var man:Soldier = new Soldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER));
								var posX:Number = 100;
								var posY:Number = Constant.TOP_LAKE + 50 + i * 50;
								man.initSoldier(myInfo.soldierList[s][t], posX, posY);
								if(myInfo.equipmentList[t] != null)
								{
									man.setEquipment(myInfo.equipmentList[t]["Equipment"], myInfo.equipmentList[t]["Index"]);
								}
								if (myInfo.meridianList[t] != null)
								{
									man.setMeridian(myInfo.meridianList[t]);
								}
								man.swimTo(arrPosition[i], 20);
								man.guiFront.showGUI(man);
								GameLogic.getInstance().arrSoldier.push(man);
								i++;
							}
						}
					}
					var boss:Soldier = new Soldier(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), "BossServer" + bossId + "_Idle");
					boss.isMine = false;
					boss.SetPos(1000, 450);
					boss.swimTo(new Point(850, 450), 20);
					GameLogic.getInstance().arrSoldier.push(boss);
					
					effState = EFF_DICE_BUFF;
					finishEffDiceBuff = false;
					attackData = new Object();
					hasAttackBossResult = false;
					Exchange.GetInstance().Send(new SendAttackBossServer());
					break;
			}
		}
		
		private function effDiceBuff():void 
		{
			finishEffDiceBuff = false;
			effState = "";
			var arrSoldier:Array = GameLogic.getInstance().arrSoldier;
			var p:Point;
			if (diceValue >= 2)
			{
				p = new Point(labelDiceValue.x, labelDiceValue.y);
				p = ctnDiceValue.img.localToGlobal(p);
			}
			else
			{
				p = new Point(labelDiceValueVip.x, labelDiceValueVip.y);
				p = ctnDiceValueVip.img.localToGlobal(p);
			}
			p = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).globalToLocal(p);
			var check:Boolean = true;
			for (var i:int = 0; i < arrSoldier.length -1; i++)
			{
				if(check)
				{
					check = false;
					particalStar(p, Soldier(arrSoldier[i]).CurPos, new ColorTransform(0, 0, 0, 1, 255, 100, 100, 0), completeEffDiceBuff, null, 1.5, false, 0, 10);
				}
				else
				{
					particalStar(p, Soldier(arrSoldier[i]).CurPos, new ColorTransform(0, 0, 0, 1, 255, 100, 100, 0), null, null, 1.5, false, 0, 10);
				}
			}
		}
		
		private function completeEffDiceBuff():void
		{
			finishEffDiceBuff = true;
			//Nếu nhận được kết quả đánh nhau từ server rồi thì chuyển effstate
			if(hasAttackBossResult)
			{
				effState = EFF_FIGHTING;
			}
			if (diceValue >= 2 || diceValueVip >= 1)
			{
				for (var i:int = 0; i < GameLogic.getInstance().arrSoldier.length - 1; i++)
				{
					var soldier:Soldier = GameLogic.getInstance().arrSoldier[i] as Soldier;
					//var effBuffDice:Sprite = ResMgr.getInstance().GetRes("GuiMainBossServer_EffBuffDice") as Sprite;
					//effBuffDice.x = 10;
					//effBuffDice.y = 10;
					//soldier.img.addChild(effBuffDice);
					soldier.guiFront.AddImage("", "GuiMainBossServer_EffBuffDice", 10, 10, true, ALIGN_LEFT_TOP, true);
				}
			}
		}
		
		override public function UpdateObject():void 
		{
			var i:int;
			//Update particle
			for (i = 0; i < emitStar.length; i++)
			{
				emitStar[i].updateEmitter();
				if (!emitStar[i].allowSpawn && emitStar[i].particleList.length < 1)
				{
					emitStar[i].destroy();
					emitStar.splice(i, 1);
					i--;					
				}
			}	
			
			//var swfEffDestroy:BitmapEffect;
			//Effect giảm máu tòa thành
			if (effState == EFF_DESTROY_CASTLE)
			{
				count++;
				if (count >= 30)
				{
					var configJoinTime:Object = ConfigJSON.getInstance().GetItemList("Param")["ServerBoss"]["JoinTime"];
					var arrTimeStone:Array = new Array();
					var minuteFighting:int = 60;
					for (var s:String in configJoinTime)
					{
						var beginTime:String = configJoinTime[s]["BeginTime"];
						var arr:Array = beginTime.split("-");
						arrTimeStone.push(arr[0]);
						
						var endTime:String = configJoinTime[s]["EndTime"];
						var arr2:Array = endTime.split("-");
						minuteFighting = (Number(arr2[0]) - Number(arr[0])) * 60 + Number(arr2[1]) - Number(arr[1]);
					}
						
					var firstPoint:int = Math.min(arrTimeStone[0], arrTimeStone[1]);
					var secondPoint:int = Math.max(arrTimeStone[0], arrTimeStone[1]);
					var date:Date = new Date();
					date.setTime((GameLogic.getInstance().CurServerTime  + 7*3600) * 1000);
					//trace("h= " + date.hoursUTC + ", m= " + date.minutesUTC);
					castleTime = 0;
					if(date.hoursUTC == firstPoint)
					{
						castleTime = (minuteFighting - date.minutesUTC)*60 - date.secondsUTC;
					}
					if (date.hoursUTC == secondPoint)
					{
						castleTime = (minuteFighting - date.minutesUTC) * 60 - date.secondsUTC;
					}
					if (castleTime > 0)
					{
						prgCastle.setStatus(castleTime / (minuteFighting * 60));
						var alpha:Number = 3600000 / (minuteFighting * 60);
						EffectMgr.getInstance().textFly("-" + Ultility.StandardNumber(alpha), new Point(175, 154 + 170), new TextFormat("arial", 22, 0xff0000, true), null, 0, -50, 5);
						labelCastle.text = Ultility.StandardNumber(castleTime * alpha);// + "/3,600,000";
					}
					else
					{
						imageCastle.img.visible = false;
						var p:Point = imageCastle.CurPos;
						p = img.localToGlobal(p);
						p = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).globalToLocal(p);
						EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiMainBossServer_DestroyCastle", null,  p.x, p.y, false, false, null, function f():void
						{
							OnButtonClick(null, BTN_HOME);
						});
						effState = "";
						return;
					}
					
					count = 0;
				}
				
				//Có kết quả xúc xắc và đã nhận chạy xong eff
				if (ctnDice != null && ctnDice.img.visible && (MovieClip)(ctnDice.img).currentFrame >= 19 && hasDiceResult)
				{
					showDiceResult(diceResult);
				}
				
				if (ctnDiceVip != null && ctnDiceVip.img.visible && (MovieClip)(ctnDiceVip.img).currentFrame >= 19 && hasDiceResultVip)
				{
					showDiceResultVip(diceResultVip);
				}
				
				//Hết thời gian chờ
				if (remainTime <= 0)
				{
					//Nếu xúc xắc đang đứng yên
					if(MovieClip(ctnDice.img).currentFrame == 1 || MovieClip(ctnDice.img).currentFrame == 30)
					{
						GetButton(BTN_ATTACK).SetEnable(true);
					}
				}
				else
				{
					if(attackNum > 0)
					{
						remainTime = configWaitTime[attackNum]["Time"] + lastTimeAttack - GameLogic.getInstance().CurServerTime;
						costRebornZMoney = configWaitTime[attackNum]["ZMoney"];
						costRebornGold = configWaitTime[attackNum]["Money"];
					}
					else
					{
						remainTime = lastTimeAttack - GameLogic.getInstance().CurServerTime;
					}
				}
			}
			else
			//Start effect khi cá đã vào vị trí
			if (effState == EFF_DICE_BUFF && GameLogic.getInstance().arrSoldier != null && GameLogic.getInstance().arrSoldier.length > 0)
			{
				//if (swfEffDestroy != null)
				//{
					//swfEffDestroy.FinishEffect();
				//}
				var fish:BaseObject = GameLogic.getInstance().arrSoldier[0] as BaseObject;
				//trace("reach des", fish.ReachDes);
				if (fish.ReachDes)
				{
					if (diceValue >= 2 || diceValueVip >= 1)
					{
						effDiceBuff();
					}
					else
					{
						completeEffDiceBuff();
					}
				}
			}
			else
			//Effect cá đánh nhau
			if (effState == EFF_FIGHTING)
			{
				effState = "";
				var arrSoldier:Array = GameLogic.getInstance().arrSoldier;
				var check:Boolean = false;//Danh dau de chay completeFightingEff theo 1 con ca linh
				for (i = 0; i < arrSoldier.length; i++)
				{
					var soldier:Soldier = arrSoldier[i] as Soldier;
					var effName:String;
					var swfEff:BitmapEffect;
					var angle:Number;
					var from:Point;
					var to:Point;
					//Lượt đánh của cá mình
					if (fightingTurn % 2 == 0)
					{
						if (soldier.isMine && !diedSoldiers[soldier.Id])
						{
							//if (soldier.Equipments.Mask[0])
							//{
								//effName = "GuiMainBossServer_EffWarMask";
							//}
							//else
							{
								effName = "GuiMainBossServer_EffWar" + soldier.Element;
							}
							if(!check)
							{
								//var eff:SwfEffect = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, effName, null, soldier.img.x, soldier.img.y, false, false, null, completeFightingEff);
								swfEff = EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, effName, soldier.img.x, soldier.img.y, false, false, completeFightingEff);
								check = true;
							}
							else
							{
								//var eff:SwfEffect = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, effName, null, soldier.img.x, soldier.img.y);
								swfEff = EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, effName, soldier.img.x, soldier.img.y);
							}
							
							//Xoay eff
							from = soldier.CurPos;
							to = Soldier(arrSoldier[arrSoldier.length -1]).CurPos;
							angle = 180 * Math.atan2(Math.abs(to.y - from.y), Math.abs(to.x - from.x)) / Math.PI;
							if ((from.x > to.x && from.y < to.y) || (from.x < to.x && from.y > to.y))
							{
								swfEff.img.rotation = -angle;
							}
							else
							{
								swfEff.img.rotation = angle;
							}
						}
					}
					//Lượt đánh của boss
					else if(!soldier.isMine)
					{
						if(!isBossShock)
						{
							effName = "BossServer" + bossId + "_AttackNormal";
						}
						else
						{
							effName = "BossServer" + bossId + "_AttackHard";
						}
						//var swfEff1:SwfEffect = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, effName, null, soldier.img.x, soldier.img.y, false, false, null, completeFightingEff);
						swfEff = EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, effName, soldier.img.x, soldier.img.y, false, false, completeFightingEff);
						//swfEff.img.scaleX = -1;
						soldier.img.visible = false;
					}
				}
			}
		}
		
		public function showDiceResultVip(_diceResultVip:int):void 
		{
			if (MovieClip(ctnDiceVip.img).currentFrame >= 19)
			{
				ctnDiceVip.GoToAndPlay(20);
				MovieClip(ctnDiceVip.img.getChildByName("Child0")).gotoAndStop(_diceResultVip);
				diceValueVip = _diceResultVip;
				hasDiceResultVip = false;
				if (remainTime <= 0)
				{
					GetButton(BTN_ATTACK).SetEnable(true);
				}
			}
			else
			{
				hasDiceResultVip = true;
				diceResultVip = _diceResultVip;
			}
		}
		
		private function completeFightingEff():void
		{
			var arrSoldier:Array = GameLogic.getInstance().arrSoldier;
			var p:Point;
			var turn:int = Math.floor(fightingTurn / 2) + 1;
			var leftVitality:Number = 0;
			var status:int;
			var txtFormat:TextFormat;
			
			//Finish oanh boss
			if (attackData["Scene"][turn] == null)
			{
				effState = "";
				//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarLose", null, 500, 500, false, false, null, finishFighting);
				EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarLose", 500, 500, false, false, finishFighting);
				return;
			}
					
			//Boss bi oanh
			if (fightingTurn % 2 == 0)
			{
				var boss:Soldier = arrSoldier[arrSoldier.length - 1] as Soldier;
				p = boss.CurPos;
				var objBoss:Object = attackData["Scene"][turn]["Vitality"]["Defence"];
				var config:Object = ConfigJSON.getInstance().GetItemList("ServerBossInfo");
				config = config[bossId];
				//trace("mau boss", Number(attackData["Scene"][turn]["Vitality"]["Defence"]["Left"]) / config["Vitality"]);
				prgBoss.setStatus(Number(attackData["Scene"][turn]["Vitality"]["Defence"]["Left"]) / config["Vitality"]);
				labelBossVitality.text = Ultility.StandardNumber(Number(attackData["Scene"][turn]["Vitality"]["Defence"]["Left"]));// + "/" + Ultility.StandardNumber(config["Vitality"]);
				
				isBossShock = false;
				//Rơi quà ở lượt đánh boss cuối cùng
				if (attackData["Scene"][turn + 1] == null && attackData["Bonus"] != null)
				{
					for (var t:String in attackData["Bonus"])
					{
						if (attackData["Bonus"][t]["ItemType"] == "Exp")
						{
							EffectMgr.getInstance().fallExpMoney(attackData["Bonus"][t]["Num"], 0, new Point(boss.img.x, boss.img.y), attackData["Bonus"][t]["Num"]/10, 0 );
						}
						else if (attackData["Bonus"][t]["ItemType"] == "Money")
						{
							EffectMgr.getInstance().fallExpMoney(0, attackData["Bonus"][t]["Num"], new Point(boss.img.x, boss.img.y), 0, attackData["Bonus"][t]["Num"]/10);
						}
						else
						{
							GameLogic.getInstance().dropGiftFishWorld(attackData["Bonus"][t], boss.img.x, boss.img.y);
						}
					}
					//Boss nộ
					if(attackData["Scene"][turn]["Vitality"]["Defence"]["Left"] > 0)
					{
						TweenMax.to(boss.img, 1, { glowFilter: { color:0xff0000, alpha:1, blurX:20, blurY:20, strength:1.5 }} );
						isBossShock = true;
					}
				}
				
				//Boss chet
				if (attackData["Scene"][turn]["Vitality"]["Defence"]["Left"] == null || attackData["Scene"][turn]["Vitality"]["Defence"]["Left"] == 0)
				{
					effState = "";
					EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "BossServer" + bossId + "_Shock", null, boss.img.x, boss.img.y, false, false, null, function f():void
					{
						if(!attackData["LastHit"])
						{
							//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarWin", null, 670, 340, false, false, null, finishFighting);
							EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarWin",  670, 340, false, false, finishFighting);
						}
						//Last hit
						else
						{
							//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "Boss1_Shock_Gold", null, 670, 340, false, false, null, finishFighting);
							EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, "BossServer" + bossId + "_Dead",  boss.img.x, boss.img.y, false, false, finishFighting);
						}
					});
					boss.img.visible = false;
				}
				//Boss an don
				else
				{
					boss.img.visible = false;
					//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "Boss1_Shock_Gold", null, 670, 340, false, false, null, function f():void
					EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, "BossServer" + bossId + "_Shock",  boss.img.x, boss.img.y, false, false, function f():void
					{
						effState = EFF_FIGHTING;
						fightingTurn ++;
						boss.img.visible = true;
					});
				}
				
				var n:int = 0;
				var addDam:Number = 0;
				for (var s:String in objBoss["ListAtt"])
				{
					leftVitality = 0 - objBoss["ListAtt"][s];
					addDam -= leftVitality;
					status = attackData["Scene"][turn]["Status"]["Attack"][s];
					switch(status)
					{
						case 0:
							txtFormat = new TextFormat("arial", 20, 0xff0000, false);
							EffectMgr.getInstance().textFly(Ultility.StandardNumber(leftVitality), new Point(boss.CurPos.x - 230, boss.CurPos.y -134 - n*20), txtFormat, null, 0, -70, 2);
							break;
						case 2:
							//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarTruot", null, boss.img.x, boss.img.y - n * 45 + 70, false, false, null);
							EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarTruot",  boss.img.x, boss.img.y - n * 45 + 70, false, false);
							txtFormat = new TextFormat("arial", 20, 0xff0000, false);
							EffectMgr.getInstance().textFly(Ultility.StandardNumber(leftVitality), new Point(boss.CurPos.x - 230, boss.CurPos.y -134 - n*20), txtFormat, null, 0, -70, 2);
							break;
						case 1:
							//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarChiMang", null, boss.img.x, boss.img.y - n * 45 + 70, false, false, null);
							EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarChiMang",  boss.img.x, boss.img.y - n * 45 + 70, false, false);
							txtFormat = new TextFormat("arial", 30, 0xff0000, true);
							txtFormat.align = "center";
							EffectMgr.getInstance().textFly(Ultility.StandardNumber(leftVitality), new Point(boss.CurPos.x - 230, boss.CurPos.y -134- n*20), txtFormat, null, 0, -70, 2);
							break;
					}
					n++;
				}
				EffectMgr.getInstance().textFly("+" + Ultility.StandardNumber(addDam), new Point(158, 130), new TextFormat("arial", 15, 0xffff00, true), null, 0, -70, 2);
				updateGiftStone(totalDamage + addDam);
			}
			//Ca bi danh
			else
			{
				Soldier(arrSoldier[arrSoldier.length - 1]).img.visible = true;
				status = attackData["Scene"][turn]["Status"]["Defence"];
				switch(status)
				{
					case 0:
						txtFormat = new TextFormat("arial", 20, 0xff0000, false);
						txtFormat.align = "center";
						break;
					case 2:
						//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarTruot", null, 600, 450, false, false, null);
						EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarTruot",  600, 450, false, false);
						break;
					case 1:
						txtFormat = new TextFormat("arial", 30, 0xff0000, true);
						txtFormat.align = "center";
						//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarChiMang", null, 600, 450, false, false, null);
						EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarChiMang",  600, 450, false, false);
						break;
				}
				
				fightingTurn ++;
				var numDiedSoldier:int = 0;
				for (var i:int = 0; i < arrSoldier.length -1; i++)
				{
					if (diedSoldiers[arrSoldier[i].Id])
					{
						numDiedSoldier ++;
					}
					else
					{
						var soldier:Soldier = arrSoldier[i] as Soldier;
						p = soldier.CurPos;
						leftVitality = attackData["Scene"][turn]["Vitality"]["Attack"][soldier.Id] - attackData["Scene"][turn -1]["Vitality"]["Attack"][soldier.Id];
						if(leftVitality != 0)
						{
							EffectMgr.getInstance().textFly(Ultility.StandardNumber(leftVitality), new Point(soldier.CurPos.x - 230, soldier.CurPos.y - 134), txtFormat, null, 0, -70, 2);
						}
						soldier.guiFront.setVitality(attackData["Scene"][turn]["Vitality"]["Attack"][soldier.Id] , soldier.getTotalVitality());
						//soldier.GuiFishStatus.ShowHPBar(soldier, attackData["Scene"][turn]["Vitality"]["Attack"][soldier.Id] , soldier.getTotalVitality(), true);
						//trace("xu li ca", arrSoldier[i].Id);
						//Ca chet
						if (attackData["Scene"][turn]["Vitality"]["Attack"][arrSoldier[i].Id] == null || attackData["Scene"][turn]["Vitality"]["Attack"][arrSoldier[i].Id] == 0)
						{
							//trace("ca chet", arrSoldier[i].Id);
							//arrSoldier[i].standbyPos = new Point(90, 90);
							arrSoldier[i].swimTo(new Point(90, 450), 20);
							diedSoldiers[arrSoldier[i].Id] = true;
							numDiedSoldier ++;
						}
						else
						TweenMax.to(arrSoldier[i].img, 0.5, { bezierThrough:[ { x:p.x - 35, y:p.y }, { x:p.x, y:p.y } ], ease:Expo.easeOut, onComplete:function f(i:int):void
						{
							effState = EFF_FIGHTING;
							//trace("mau con", i, GameLogic.getInstance().arrSoldier[i].Id, attackData["Scene"][turn]["Vitality"]["Attack"][arrSoldier[i].Id]);
						}, onCompleteParams:[i]});
					}
				}
				
				//trace("num die", numDiedSoldier);
				if (numDiedSoldier == arrSoldier.length - 1)
				{
					effState = "";
					//EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarLose", null, 670, 340, false, false, null, finishFighting);
					EffectMgr.getInstance().AddBitmapEffect(Constant.OBJECT_LAYER, "GuiMainBossServer_EffFishWarLose",  670, 340, false, false, finishFighting);
				}
			}
			
			//trace("eff state", effState);
		}
		
		public function finishFighting():void
		{
			var arrSoldier:Array = GameLogic.getInstance().arrSoldier;
			var i:int;
			for (i = 0; i < arrSoldier.length; i++)
			{
				Soldier(arrSoldier[i]).Destructor();
			}
			arrSoldier.slice(0, arrSoldier.length);
			
			for (i = 0; i < img.numChildren; i++)
			{
				img.getChildAt(i).visible = true;
			}
			
			fightingTurn  = 0;
			effState = EFF_DESTROY_CASTLE;
			GetButton(BTN_ATTACK).SetEnable(false);
			
			updateRoomInfo(attackData);
			//Nếu không có quà tức là boss chưa chết
			if(dataRoom != null && dataRoom["GiftList"] == null)
			{
				//lastTimeAttack = GameLogic.getInstance().CurServerTime;
				if(attackNum > 0)
				{
					//remainTime =  configWaitTime[attackNum]["Time"];
					costRebornZMoney = configWaitTime[attackNum]["ZMoney"];
					costRebornGold = configWaitTime[attackNum]["Money"];
				}
				//else
				//{
					//remainTime = 0;
				//}
				if(freeDice <= 0)
				{
					costDiceZMoney = configDice["1"]["ZMoney"]
				}
				else
				{
					costDiceZMoney = 0;
				}
				diceValue = 0;
				ctnDice.GoToAndStop(MovieClip(ctnDice.img).totalFrames);
				MovieClip(ctnDice.img.getChildByName("Child0")).gotoAndStop(diceValue);
				
				if(freeDiceVip <= 0)
				{
					costDiceVip = configDice["2"]["ZMoney"];
				}
				else
				{
					costDiceVip = 0;
				}
				diceValueVip = 0;
				ctnDiceVip.GoToAndStop(MovieClip(ctnDiceVip.img).totalFrames);
				MovieClip(ctnDice.img.getChildByName("Child0")).gotoAndStop(diceValueVip);
				
			}
		}
		
		public function showGUI(_bossId:int):void 
		{
			bossId = _bossId;
			Show();
		}
		
		public function showDiceResult(_diceResult:int):void 
		{
			if (MovieClip(ctnDice.img).currentFrame >= 19)
			{
				ctnDice.GoToAndPlay(20);
				MovieClip(ctnDice.img.getChildByName("Child0")).gotoAndStop(_diceResult);
				diceValue = _diceResult;
				hasDiceResult = false;
				if (remainTime <= 0)
				{
					GetButton(BTN_ATTACK).SetEnable(true);
				}
			}
			else
			{
				hasDiceResult = true;
				diceResult = _diceResult;
			}
		}
		
		public function updateAttackBossResult(result:Object):void 
		{
			attackData = result;
			
			//Boss chưa chết
			if (result["Scene"] != null)
			{
				hasAttackBossResult = true;
				
				diedSoldiers = new Object();
				fightingTurn = result["Scene"][0]["AttackFirst"];
				//Nếu xong effect buff dice thì chuyển qua eff đánh nhau
				if (finishEffDiceBuff)
				{
					effState = EFF_FIGHTING;
				}
			}
			else
			{
				finishFighting();
			}
		}
		
		public function updateRoomInfo(_dataRoom:Object):void 
		{
			dataRoom = _dataRoom;
			if (!loadContentComplete)
			{
				return;
			}
			
			RemoveContainer(CTN_TOP_INFO);
			ctnTopInfo = AddContainer(CTN_TOP_INFO, "GuiMainBossServer_TopUserBg", 647, 43);
			var bossVitality:Number = ConfigJSON.getInstance().GetItemList("ServerBossInfo")[bossId]["Vitality"];
			var myId:int = GameLogic.getInstance().user.GetMyInfo().Id;
			var check:Boolean = false;
			var s:String;
			var percent:Number;
			var labelTop:TextField;
			var labelName:TextField;
			var position:String;
			/*for (var i:int = 1; i < 11; i++)
			{
				dataRoom["TopUser"][i] = new Object();
				dataRoom["TopUser"][i]["DamageTotal"] = i;
				dataRoom["TopUser"][i]["UserName"] = "truong quang dong";
			}*/
			var ctnTooltip:Container;
			for (s in dataRoom["TopUser"])
			{
				if (int(s) <= 10)
				{
					percent = 100 * Number(dataRoom["TopUser"][s]["DamageTotal"]) / bossVitality;
					percent = Math.min(100, int(percent * 1000) / 1000);
					labelTop = ctnTopInfo.AddLabel(percent + " %", 110, int(s) * 30 - 13, 0xffffff, 0, 0x000000);
					var userName:String = dataRoom["TopUser"][s]["UserName"] == null ? "Không Tên" : dataRoom["TopUser"][s]["UserName"];
					labelName = ctnTopInfo.AddLabel(Ultility.StandardString(userName, 10), 35, int(s) * 30 - 13, 0xffffff, 0, 0x000000);
					ctnTooltip = ctnTopInfo.AddContainer("", "", 35, int(s) * 30 - 13);
					ctnTooltip.LoadRes("");
					ctnTooltip.img.graphics.beginFill(0xff0000, 0);
					ctnTooltip.img.graphics.drawRect(0, 0, 75, 20);
					ctnTooltip.img.graphics.endFill();
					ctnTooltip.setTooltipText(dataRoom["TopUser"][s]["UserName"]);
					if (dataRoom["TopUser"][s]["UserId"] == myId)
					{
						labelTop.textColor = 0xffffff;
						labelName.textColor = 0xffff00;
						check = true;
					}
				}
			}
			if (!check)
			{
				percent = 100 * Number(dataRoom["UserInfo"]["DamTotal"]) / bossVitality;
				percent = int(percent * 100) / 100;
				position = int(dataRoom["UserInfo"]["Position"]) > 0 ? dataRoom["UserInfo"]["Position"] : ">100";
				labelTop = ctnTopInfo.AddLabel(position + "                             " + percent  + " %", 12,11 * 30-13, 0xffffff, 0, 0x000000);
				labelName = ctnTopInfo.AddLabel(Ultility.StandardString(GameLogic.getInstance().user.GetMyInfo().Name, 10), 35, 11 * 30 - 13, 0xffff00, 0, 0x000000);
				ctnTooltip = ctnTopInfo.AddContainer("", "", 35, 11 * 30 - 13);
				ctnTooltip.LoadRes("");
				ctnTooltip.img.graphics.beginFill(0xff0000, 0);
				ctnTooltip.img.graphics.drawRect(0, 0, 75, 20);
				ctnTooltip.img.graphics.endFill();
				ctnTooltip.setTooltipText(GameLogic.getInstance().user.GetMyInfo().Name);
			}
			
			prgBoss.setStatus(Math.max(0, Number(dataRoom["Vitality"])) / bossVitality);
			labelBossVitality.text = Ultility.StandardNumber(Math.max(0, Number(dataRoom["Vitality"]))) ;// + "/" + Ultility.StandardNumber(bossVitality);
			
			freeDice = dataRoom["UserInfo"]["FreeDice"];
			if(freeDice <= 0)
			{
				costDiceZMoney = configDice["1"]["ZMoney"];
				costDiceGold = configDice["1"]["Money"];
			}
			else
			{
				costDiceZMoney = 0;
				costDiceGold = 0;
			}
			diceValue = dataRoom["UserInfo"]["Dice"];
			ctnDice.GoToAndStop(MovieClip(ctnDice.img).totalFrames);
			MovieClip(ctnDice.img.getChildByName("Child0")).gotoAndStop(diceValue);
			ctnDiceValue.img.mouseChildren = true;
			ctnDiceValue.img.mouseEnabled = true;
			
			freeDiceVip = dataRoom["UserInfo"]["FreeSpecialDice"];;
			if (freeDiceVip <= 0)
			{
				costDiceVip = configDice["2"]["ZMoney"];
			}
			else
			{
				costDiceVip = 0;
			}
			diceValueVip = dataRoom["UserInfo"]["SpecialDice"];
			ctnDiceVip.GoToAndStop(MovieClip(ctnDiceVip.img).totalFrames);
			MovieClip(ctnDiceVip.img.getChildByName("Child0")).gotoAndStop(diceValueVip);
			ctnDiceValueVip.img.mouseChildren = true;
			ctnDiceValueVip.img.mouseEnabled = true;
			
			
			lastTimeAttack = dataRoom["UserInfo"]["LastTimeAttack"];
			attackNum = dataRoom["UserInfo"]["AttackNum"];
			if (attackNum > MAX_NUM_ATTACK)
			{
				attackNum = MAX_NUM_ATTACK;
			}
			if(attackNum > 0)
			{
				remainTime = -GameLogic.getInstance().CurServerTime + lastTimeAttack + configWaitTime[attackNum]["Time"];
				costRebornZMoney = configWaitTime[attackNum]["ZMoney"];
				costRebornGold = configWaitTime[attackNum]["Money"];
			}
			else
			{
				remainTime = -GameLogic.getInstance().CurServerTime + lastTimeAttack;
			}
			
			//Cap nhat moc qua
			updateGiftStone(Number(dataRoom["UserInfo"]["DamTotal"]));
			
			//Cap nhat data ca linh
			if (dataRoom["SoldierData"] != null)
			{
				var user:User = GameLogic.getInstance().user;
				user.soldierList = dataRoom["SoldierData"]["SoldierList"];
				user.equipmentList = dataRoom["SoldierData"]["EquipmentList"];
				user.meridianList = dataRoom["SoldierData"]["MeridianList"];
			}
			
			//Quà sau khi đánh boss
			if (attackData != null)
			{
				if (dataRoom["GiftList"] != null)
				{
					if (dataRoom != null && !dataRoom["LastHit"])
					{
						effState = "";
						imageBoss.img.visible = false;
						EffectMgr.getInstance().AddBitmapEffect(Constant.GUI_MIN_LAYER, "BossServer" + bossId + "_Dead",  imageBoss.img.x, imageBoss.img.y, false, false, function f():void
						{
							GuiMgr.getInstance().guiGiftBossServer.showGUI(dataRoom["GiftList"], true, dataRoom["UserInfo"]["Position"]);
						});
					}
					else
					{
						effState = "";
						imageBoss.img.visible = false;
						GuiMgr.getInstance().guiGiftBossServer.showGUI(dataRoom["GiftList"], true, dataRoom["UserInfo"]["Position"]);
					}
				}
				else
				{
					if (dataRoom["Vitality"] <= 0)
					{
						OnButtonClick(null, BTN_HOME);
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Boss đã chết. Bạn quay lại vào lần sau nhé!");
					}
				}
			}
			//Quà khi vào phòng nhận của lần trước
			else
			{
				if(dataRoom["GiftList"] != null)
				{
					GuiMgr.getInstance().guiGiftBossServer.showGUI(dataRoom["GiftList"], false, dataRoom["UserInfo"]["Position"]);
				}
				//Nếu boss đã chết
				if (dataRoom["Vitality"] <= 0)
				{
					OnButtonClick(null, BTN_HOME);
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Boss đã chết. Bạn quay lại vào lần sau nhé!");
				}
			}
		}
		
		private function updateGiftStone(_totalDamage:Number):void 
		{
			totalDamage = _totalDamage;
			var maxDamageRequire:Number = 0;
			var ticked:String;
			for (var s:String in configGift)
			{
				if (configGift[s]["DamageRequire"] <= totalDamage && configGift[s]["DamageRequire"] > maxDamageRequire)
				{
					maxDamageRequire = configGift[s]["DamageRequire"];
					ticked = s;
				}
			}
			
			for (s in configGift)
			{
				
				if (s == ticked)
				{
					ctnGiftStone.GetImage(IC_TICKED + "_" + s).img.visible = true;
				}
				else
				{
					ctnGiftStone.GetImage(IC_TICKED + "_" + s).img.visible = false;
				}
			}
		}
		
		/**
		 * Hàm tạo effect 1 chùm sao bay theo đường cong từ điểm này tới điểm kia
		 * @param	fromPoint : điểm bắt đầu
		 * @param	toPoint : điểm kết thúc
		 * @param	colorTransform : transform màu cho sao
		 * @param	isReverse : có bay ngược từ toPoint đến fromPoint hay không, mặc định là không
		 * @param	completeFunction : hàm thưc hiện khi xong effect
		 * @param	params : tham số cho hàm completeFunction
		 * @param	mid : chọn điểm giữa, 0 là random, 1 là hướng vòng lên, -1 là hướng vòng xuống, 2 là bay thẳng
		 * @param	spawnCount : số sao bay
		 */
		private function particalStar(fromPoint:Point, toPoint:Point, colorTransform:ColorTransform, completeFunction:Function = null, params:Object = null, time:Number = 0.5, isReverse:Boolean = false, mid:int = 0, spawnCount:int = 7):void
		{
			var emit:CometEmit = new CometEmit(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER));		
			emit.spawnCount = spawnCount;
			var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;
			sao.transform.colorTransform = colorTransform;
			emit.imgList.push(sao);
			emitStar.push(emit);
			if (isReverse)
			{
				var temp:Point = toPoint.clone();
				toPoint = fromPoint.clone();
				fromPoint = temp;
			}
			
			var midPoint:Point = midPoint = getThroughPoint(fromPoint, toPoint, mid);
			
			if (emit)
			{
				img.addChild(emit.sp);
				emit.sp.x = fromPoint.x;
				emit.sp.y = fromPoint.y;
				if(mid != 2)
				{
					emit.velTolerance = new Point(1.5, 1.5);
					TweenMax.to(emit.sp , time, { bezierThrough:[ { x:midPoint.x, y:midPoint.y }, { x:toPoint.x, y:toPoint.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween, onCompleteParams:[completeFunction,params]} );					
				}
				else
				{
					emit.velTolerance = new Point(1.2, 1.2);
					TweenMax.to(emit.sp , time, { bezierThrough:[ { x:toPoint.x, y:toPoint.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween, onCompleteParams:[completeFunction, params] } );					
				}
			}
			
			function onCompleteTween():void
			{
				if (IsVisible)
				{
					if (emit)
					{
						emit.stopSpawn();
					}
					img.removeChild(emit.sp);	
				}
				if(completeFunction != null)
				{
					if(params != null)
					{
						completeFunction(params);
					}
					else
					{
						completeFunction();
					}
				}
			}
		}
		
				/**
		 * Tìm điểm trung gian giữa 2 điểm nguồn và đích để bay vòng qua đó cho đẹp
		 * @param	psrc	điểm nguồn
		 * @param	pdes	điểm đích
		 * @return
		 */
		private function getThroughPoint(psrc:Point, pdes:Point, mid:int = 0):Point
		{
			var p:Point = pdes.subtract(psrc);//Vector từ nguồn đến đích
			if (p.y == 0)
				return new Point(p.x/2, 0);
			var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2);//Trung điểm của nguồn và đích
			var v:Point = new Point( -p.y, p.x);//Vector vuông góc với vector(nguồn, đích)
			
			//Random hướng vuông góc
			var n:int;
			if(mid == 0)
			{
				n = Math.round(Math.random()) * 2 - 1;
			}
			else
			{
				n = mid;
			}
			v.x = n*v.x;
			v.y = n*v.y;
			var l:Number = Math.min(120, v.length / 3);
			v.normalize(l);//Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			var result:Point = med.add(v);//Tính ra điểm cần đi xuyên qua
			return result;			
		}
		
	}

}