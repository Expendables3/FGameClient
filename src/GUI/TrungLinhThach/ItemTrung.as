package GUI.TrungLinhThach 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.MotionObject;
	import Logic.Ultility;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Data.ConfigJSON;
	import GUI.GuiMgr;
	import NetworkPacket.PacketSend.SendLoadInventory;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class ItemTrung extends Container 
	{
		static public const ID_BTN_DAP_FREE:String = "idBtnDapFree";
		static public const ID_BTN_DAP_BUY:String = "idBtnDapBuy";
		static public const ID_BTN_BONUSS_ALL:String = "idBtnNhanAll";
		static public const CTN_BONUS:String = "ctnBonus";
		static public const BTN_TRUNG_ITEM:String = "btnTrungItem";
		static public const BTN_BOX_BONUS:String = "btnBoxBonus";
		static public const ITEM_TRUNG:String = "eggs";
		static public const SMASH_EGG:String = "smashEgg";
		static public const HAND_MOUSE:String = "handMouse";
		static public const CHECK_ALL_YES:String = "checkAllYes";
		static public const CHECK_ALL_NO:String = "checkAllNo";
		
		private var _trung:Object;//trỏ đến 1 trung cụ thể
		public var imgTab:Image;
		public var btnDapFree:Button;
		public var btnDapBuy:Button;
		public var BtnNhanAll:Button;
		private var tfEggsDamFree:TextField;
		static public const CMD_UNLOCK_trung:String = "cmdUnlocktrung";
		
		private var tipHammer:Image;
		private var imgColon1:Image;
		private var imgColon2:Image;
		private var imgH1:Image; 
		private var imgH2:Image;
		private var imgM1:Image;
		private var imgM2:Image;
		private var imgS1:Image; 
		private var imgS2:Image;
		public var VirtualTime:Number;
		
		public var ctnEggs:Container;
		public var ctnBonus:Container;
		private var ctnQuartz:Container;
		private var nameHammer:Array = ["Thường", "Đặc Biệt", "Quý", "Thần"];
		private var isTime:Boolean = false;
		private var bonusObjData:Object = new Object();
		public var nameItem:String;
		private var timeToBonus:int;
		private var txtTime:TextField;
		private var txtFormatTime:TextFormat;
		private const nameType:Object = 
		{
			"GreenEgg":"HammerGreen", "YellowEgg":"HammerYellow", "PurpleEgg":"HammerPurple"
		}
		private var btnTrungItem:Image;
		private var EffSmashEgg:Image;
		private var btnBoxIdol:Button;
		private var btnBoxBonus:Button;
		public var openBoxBonus:Image;
		private var mcHoiSinhTrung:Image;
		private var mcHand:Image;
		private var nenVoEgg:Image
		private var txtNumEgg:TextField;
		private var dataBonusSmash:Array = new Array;
		private var checkAllYes:Button;
		private var checkAllNo:Button;
		private var textLoadingSmash:TextField;
		
		private var arrImageTipX:Array = [31, 40, 37, 49];
		private var arrImageTipY:Array = [-11, -10, -10, -11];
		
		private var arrImageBoxX:Array = [145, 75, -30, -125];
		private var arrImageBoxY:Array = [280, 295, 300, 295];
		
		private var arrImageTimeXBonus:Array = [137, 68, -37, -130];
		private var arrImageTimeX:Array = [120, 58, -45, -125];
		private var arrImageTimeY:Array = [340, 355, 360, 357];
		
		private var isNhanHammer:Boolean = false;
		private var isClickBox:Boolean = false;
		
		private var arrImageSmashX:Array = [70, 80, 77, 93];
		private var arrImageSmashY:Array = [106, 107, 113, 117];
		
		private var arrNenSmashX:Array = [82, 94, 89, 106];
		private var arrNenSmashY:Array = [165, 170, 170, 173];
		
		private var arrQuartzBonusX:Array = [28, 3, 48];
		private var arrQuartzBonusY:Array = [ -25, 45 , 45];
		private var arrQuartzBonusItemX:Array = [-17, 0, 0, 16];
		private var totalQuartz:int = 0;
		
		private var arrStartX:Array = [190, 325, 455, 575];
		private var arrStartY:Array = [453, 468, 473, 458];
		
		private var arrStopX:Array = [-185, -30, 150, 290];
		private var arrStopY:Array = [-90, -90, -90, -90];
		
		private var arrStartTextX:Array = [10, -8, -66, -110];
		private var arrStopTextY:Array = [ -237, -222, -212, -217];
		
		private var arrQuartzStartX:Array = [100, 232, 455, 690];
		private var arrQuartzStartY:Array = [293, 308, 313, 298];
		
		private var arrCheckAllX:Array = [-17, -9, -3, 2];
		private var arrCheckAllY:Array = [196, 212, 218, 218];
		
		public var isStop:Boolean = false;
		public var idSortX:Number;
		public static const BL_BUBBLE:int = 1;
		public static const	BL_BOB:int = 2;
		public static const	BL_FLY:int = 3;
		public var movingState:int;
		private var isLoadBonus:Boolean = false;
		private var isLoadBox:Boolean = false;
		private var isSmash:Boolean = true;
		public var scale:Number;
		private var arrItemBonus:Array = new Array;
		private var arrQuartzEff:Array = new Array;
		private	var TOPPOS:int = 12;
		private	var specY:Number;
		private var isSmashMulti:Boolean = false;
		private var numMaxEgg:int = 50;
		private var totalQuartzStore:int
		
		public function ItemTrung(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "ItemTrung";
		}
		
		public function initData(trung:Object, ObjData:Object):void
		{
			_trung = trung;
			
			bonusObjData = ObjData;
		}
		
		public function drawItem():void
		{
			//trace("goi === drawItem()");
			
			ClearComponent();
			isSmash = true;
			isNhanHammer = false;
			isStop = false;
			isLoadBonus = false;
			isLoadBox = false;
			var strNameFish:String;
			nameItem = _trung.name;
			scale = 1;
			var timeConfig:int = ConfigJSON.getInstance().GetItemList("SmashEgg_EggHammer")[_trung.name].Time;
			
			timeToBonus = (_trung.Time + timeConfig) - GameLogic.getInstance().CurServerTime;
			
			if (timeToBonus < 0)
			{
				isNhanHammer = true;
				timeToBonus = 0;
				GuiMgr.getInstance().guiTrungLinhThach.pushStatusInItem(true, (_trung.id - 1));
			}
			else
			{
				isTime = true;
				GuiMgr.getInstance().guiTrungLinhThach.pushStatusInItem(false, (_trung.id - 1));
			}
			AddTime(30, 80, 130, 205);
			smashOKItem(false);
		}
		
		private function smashOKItem(isHoiSinh:Boolean):void
		{
			isLoadBonus = false;
			isLoadBox = false;
			isSmash = true;
			var item:Object = new Object();
			item.id = _trung.id;
			var tooltipFormat:TooltipFormat;
				
			ctnEggs = AddContainer('', "GuiTrungLinhThach_ItemTrung", 0, 0, true, this);
			if (isHoiSinh)
			{
				ctnEggs.img.alpha = 0;
				TweenMax.to(ctnEggs.img, 3, {alpha:1} );	
			}
			var GuiToolTip:GuiTrungLinhThachToolTip = new GuiTrungLinhThachToolTip(null, "");
			var globalParent:Point = ctnEggs.img.localToGlobal(new Point(0, 0));
			GuiToolTip.Init(_trung);
			GuiToolTip.InitPos(ctnEggs, "GuiTrungLinhThach_BgTipTrung", globalParent.x, globalParent.y, 0, -0, 0, 0, true, false);
			ctnEggs.setGUITooltip(GuiToolTip);
				
			btnTrungItem = ctnEggs.AddImage(BTN_TRUNG_ITEM, "GuiTrungLinhThach_TrungType" + _trung.id, 20, 127);
			btnTrungItem.img.buttonMode = true;
			btnTrungItem.img.addEventListener(MouseEvent.CLICK, clickSmashEgg);
			btnTrungItem.img.tabIndex = _trung.id;
			
			if (timeToBonus > 0)
			{
				if (btnBoxIdol)
				{
					btnBoxIdol.img.visible = true;
				}
				else
				{
					btnBoxIdol = AddButton(BTN_BOX_BONUS, "boxBonusType" + _trung.id, arrImageBoxX[_trung.id - 1], arrImageBoxY[_trung.id - 1]);
					btnBoxIdol.img.visible = true;
				}
				btnBoxIdol.setTooltipText("Mở hộp quà nhận Búa " + nameHammer[_trung.id - 1]);
				
				if (btnBoxBonus)
				{
					btnBoxBonus.img.visible = false;
					btnBoxBonus = null;
				}
			}
			else
			{
				if (btnBoxBonus)
				{
					btnBoxBonus.img.visible = true;
				}
				else
				{
					btnBoxBonus = AddButton(BTN_BOX_BONUS, "boxRung" + _trung.id, arrImageBoxX[_trung.id - 1], arrImageBoxY[_trung.id - 1]);
					btnBoxBonus.img.visible = true;
				}
				btnBoxBonus.setTooltipText("Mở hộp quà nhận Búa " + nameHammer[_trung.id - 1]);
				btnBoxBonus.img.addEventListener(MouseEvent.CLICK, clickReceive);
				btnBoxBonus.img.tabIndex = _trung.id;
				
				if (btnBoxIdol)
				{
					btnBoxIdol.img.visible = false;
					btnBoxIdol = null;
				}
				
				reportHammer();
			}
			
			txtNumEgg = ctnEggs.AddLabel("", arrImageTipX[_trung.id - 1] - 6, arrImageTipY[_trung.id - 1] + 12, 0xffffff, 0);
			var txtFormat:TextFormat = new TextFormat("arial", 15, 0xffffff, true);
			txtNumEgg.setTextFormat(txtFormat);
			txtNumEgg.defaultTextFormat = txtFormat;
			//txtNumEgg.text = "x" + GuiMgr.getInstance().guiHammerInfo.getNumberHammer(_trung.hammer);
			txtNumEgg.text = "x" + ConfigJSON.getInstance().GetItemList("SmashEgg_EggHammer")[_trung.name].Num;
			
			if (timeToBonus > 0 && btnDapFree)
			{
				btnDapFree.SetVisible(false);
			}
			
			checkAllYes = AddButton(CHECK_ALL_YES, "GuiTrungLinhThach_YesCheckAll", arrCheckAllX[_trung.id - 1], arrCheckAllY[_trung.id - 1]);
			checkAllYes.setTooltipText("Click bỏ chọn đập tất cả");
			checkAllNo = AddButton(CHECK_ALL_NO, "GuiTrungLinhThach_NoCheckAll", arrCheckAllX[_trung.id - 1], arrCheckAllY[_trung.id - 1]);
			checkAllNo.setTooltipText("Click chọn đập tất cả");
			
			var glow:GlowFilter = new GlowFilter(0x000000, 1, 4, 4, 10); 
			AddLabel("(Tối đa " + numMaxEgg + " búa/1 lần)", arrCheckAllX[_trung.id - 1], arrCheckAllY[_trung.id - 1] + 30, 0xFFFFFF).filters = [glow];
			
			if (isSmashMulti)
			{
				checkAllYes.SetVisible(true);
				checkAllNo.SetVisible(false);
			}
			else
			{
				checkAllYes.SetVisible(false);
				checkAllNo.SetVisible(true);
			}
			
			var txtLoading:TextFormat = new TextFormat("arial", 14, 0xFFFFFF, true);
			textLoadingSmash = ctnEggs.AddLabel("Đang tự động đập...", 2, 100);
			textLoadingSmash.setTextFormat(txtLoading);
			textLoadingSmash.defaultTextFormat = txtLoading;
			textLoadingSmash.filters = [glow];
			textLoadingSmash.visible = false;
		}
		
		private function smashOKNoReceive():void
		{
			isLoadBonus = true;
			isLoadBox = false;
			ctnEggs.ClearComponent();
			loadItemBonusSmash(dataBonusSmash);
		}
		
		public function updateGuiItem(ObjData:Array, OldData:Object):void
		{
			textLoadingSmash.visible = false;
			isSmash = false;
			//trace("=====ObjData.length== " + ObjData.length);
			for (var i:int = 0; i <  ObjData.length; i++)
			{
				/*var obj:FishEquipment = new FishEquipment();
				obj.Id = ObjData[i].Id;
				obj.Type = ObjData[i].Type;
				obj.Level = ObjData[i].Level;
				obj.ItemId = ObjData[i].ItemId;
				
				var dataStore:Object = GameLogic.getInstance().user.loadFunctionQuartz(obj.ItemId, obj.Type, obj.Level);
				
				obj.Damage = dataStore.Damage;
				obj.OptionDamage = dataStore.OptionDamage;
				
				obj.Defence = dataStore.Defence;
				obj.OptionDefence = dataStore.OptionDefence;
				
				obj.Critical = dataStore.Critical;
				obj.OptionCritical = dataStore.OptionCritical;
				
				obj.Vitality = dataStore.Vitality;
				obj.OptionVitality = dataStore.OptionVitality;
				
				obj.Source = ObjData[i].Source;
				obj.Durability = ObjData[i].Durability;
				obj.IsUsed = ObjData[i].IsUsed;
				obj.Author = ObjData[i].Author;*/
				
				//GameLogic.getInstance().user.UpdateQuartzToStore(obj, true)
				//trace("Goi o ham dap trung");
				GameLogic.getInstance().user.GenerateNextID();
			}
			
			// Load lại kho để refresh trang bị
			var cmd:SendLoadInventory = new SendLoadInventory();
			Exchange.GetInstance().Send(cmd);
			
			dataBonusSmash = ObjData;
			ctnEggs.ClearComponent();
			isLoadBonus = true;
			isLoadBox = false;
			
			if (EffSmashEgg)
			{
				EffSmashEgg = null;	
			}
			
			if (OldData.Num > 1)
			{
				ReceiveBonusOK();
				GuiMgr.getInstance().guiShowBonusAll.showGUI(ObjData, OldData);
			}
			else
			{
				loadAnimationSmash();
			}
			Constant.SMASH_EGG_EFF = false;
		}
		
		public function updateEggSmash(ObjData:Object, newTime:int):void
		{
			var timeConfig:int = ConfigJSON.getInstance().GetItemList("SmashEgg_EggHammer")[_trung.name].Time;
			timeToBonus = (newTime + timeConfig) - GameLogic.getInstance().CurServerTime;
			if (timeToBonus > timeConfig)
			{
				timeToBonus = timeConfig;
			}
			isTime = true;
			//trace("updateEggSmash timeConfig== " + timeConfig);
			if (GuiMgr.getInstance().guiHammerInfo.IsVisible)
			{
				GuiMgr.getInstance().guiHammerInfo.buyComplete(ObjData, ObjData);
			}
		}
		
		private function loadItemBonusSmash(dataAll:Array):void
		{
			arrQuartzEff.splice(0, arrQuartzEff.length);
			ctnBonus = AddContainer('', "GuiTrungLinhThach_ItemTrung", 0, 0, true, this);
			
			if (ctnQuartz == null)
			{
				ctnQuartz = AddContainer("", "", 0, 0);
				ctnQuartz.LoadRes("");
			}
			else
			{
				ctnQuartz.ClearComponent();
			}
			
			isStop = true;
			isLoadBonus = true;
			isLoadBox = false;
			isSmash = false;
			totalQuartz = dataAll.length;
			arrItemBonus.splice(0, arrItemBonus.length);
			
			for (var i:int = 0; i < dataAll.length; i++)
			{
				var data:Object = dataAll[i];
				
				/*if (data.ItemId > 4)
				{
					data.ItemId = 0;
				}*/
				var imagName:String = data.Type + data.ItemId;
				var ctn1:Container;
				//trace("_trung.id - 1== " + (_trung.id - 1));
				ctn1 = ctnQuartz.AddContainer("quartzReciver_" + data.Type + data.ItemId + "_" + i, imagName, arrQuartzBonusX[i] + arrQuartzBonusItemX[_trung.id - 1], arrQuartzBonusY[i], true, this);
				arrItemBonus.push(ctn1);
				
				var imgName:String = data.Type + data.ItemId;
				arrQuartzEff.push(imgName);
			}
			ctnBonus.img.addChild(ctnQuartz.img);
			
			nenVoEgg = ctnBonus.AddImage("", "bonusEggReceive" + _trung.id, arrNenSmashX[_trung.id - 1], arrNenSmashY[_trung.id - 1]);
			nenVoEgg.img.mouseChildren = false;
			nenVoEgg.img.mouseEnabled = false;
			nenVoEgg.img.parent.mouseEnabled = false;
			
		}
		
		private function EffQuartz(nameImageEff:String):void
		{
			var startX:int = arrQuartzStartX[_trung.id - 1];
			var startY:int = arrQuartzStartY[_trung.id - 1];
			var fallY:int = startY + 60;
			var stopX:int = 365;// GuiMgr.getInstance().guiTrungLinhThach.buttonWareRoom.img.x - 295;
			var stopY:int = -140;// GuiMgr.getInstance().guiTrungLinhThach.buttonWareRoom.img.y - 130;
			var numItemFly:int = 1;
				
			effFallFly(Constant.GUI_MIN_LAYER, nameImageEff, startX, startY, fallY, stopX, stopY, numItemFly);
		}
		
		private function ReceiveBonusOK():void
		{
			//trace("-----------------");
			isSmash = false;
			isStop = false;
			if (ctnBonus)
			{
				ctnBonus.ClearComponent();
				ctnBonus = null;
			}
			
			if (ctnQuartz)
			{
				ctnQuartz.ClearComponent();
				ctnQuartz = null;
			}
			isLoadBonus = false;
			isLoadBox = false;
			smashOKItem(true);
			
			mcHoiSinhTrung = AddImage(BTN_BOX_BONUS, "hoiSinhTrungSmash", arrNenSmashX[_trung.id - 1] - 65, arrNenSmashY[_trung.id - 1] - 50);
			mcHoiSinhTrung.GoToAndPlay(1);
			mcHoiSinhTrung.img.addEventListener(Event.ENTER_FRAME, onEnterHoiSinh);
		}
		
		private function onEnterHoiSinh(event:Event):void
		{
			if (mcHoiSinhTrung.currentFrame == 23)
			{
				mcHoiSinhTrung.GoToAndStop(23);
				mcHoiSinhTrung.img.removeEventListener(Event.ENTER_FRAME, onEnterHoiSinh);
				mcHoiSinhTrung.img.visible = false;
				mcHoiSinhTrung = null;
			}
		}
		
		private function AddTime(xh:int, xm:int, xs:int, y:int):void 
		{
			//trace("AddTime");
			var hour:int = timeToBonus / 3600;
			var strHour:String = hour.toString();
			if (hour < 10 && hour >= 0)	strHour = "0" + hour.toString();
			
			var min:int = (timeToBonus - Math.floor(timeToBonus / 3600) * 3600) / 60;
			var strMin:String = min.toString();
			if (min < 10 && min >= 0)	strMin = "0" + min.toString();
			
			var sec:int = timeToBonus - Math.floor(timeToBonus / 60) * 60;
			var strSec:String = sec.toString();
			if (sec < 10 && sec >= 0)	strSec = "0" + sec.toString();
			
			txtFormatTime = new TextFormat("arial", 14, 0xFFFF00, true);
			txtTime = AddLabel(strHour + ":" + strMin + ":" + strSec, arrImageTimeX[_trung.id - 1], arrImageTimeY[_trung.id - 1], 0xFFFF00);
			if (hour > 24)
			{
				var day:int = hour / 24;
				var strDay:String = day.toString();
				if (day < 10 && day >= 0)	strDay = "0" + day.toString();
				txtTime.text = strDay + " Ngày";
			}
			else
			{
				txtTime.text = strHour + ":" + strMin + ":" + strSec;
			}
			txtTime.defaultTextFormat = txtFormatTime;
			isTime = true;
			updateTime();
		}
		
		public function UpdateStaus(time:Number):void
		{
			//trace("UpdateStaus");
			timeToBonus--;
			if (timeToBonus < 0)
			{
				GuiMgr.getInstance().guiTrungLinhThach.pushStatusInItem(true, (_trung.id - 1));
				timeToBonus = 0;
				isNhanHammer = true;
				isTime = false;
				reportHammer();
				//trace("UpdateStaus isClickBox== " + isClickBox + " |name== " + _trung.name + " |SmashNum== " + _trung.SmashNum + " |numSmashConfig== " + ConfigJSON.getInstance().getItemInfo("SmashEgg_EggHammer")[_trung.name]["LimitDay"]);
				if (!isClickBox)
				{
					if (btnBoxIdol)
					{
						btnBoxIdol.img.visible = false;
					}
					
					if (btnBoxBonus)
					{
						btnBoxBonus.img.visible = true;
					}
					else
					{
						btnBoxBonus = AddButton(BTN_BOX_BONUS, "boxRung" + _trung.id, arrImageBoxX[_trung.id - 1], arrImageBoxY[_trung.id - 1]);
						btnBoxBonus.img.visible = true;
					}
					btnBoxBonus.setTooltipText("Mở hộp quà nhận Búa " + nameHammer[_trung.id - 1]);
					btnBoxBonus.img.addEventListener(MouseEvent.CLICK, clickReceive);
					btnBoxBonus.img.tabIndex = _trung.id;
				}
			}
			else
			{
				GuiMgr.getInstance().guiTrungLinhThach.pushStatusInItem(false, (_trung.id - 1));
				isNhanHammer = false;
				isClickBox = false;
				isTime = true;
			}
			//trace("ItemTrung UpdateStaus() time= " + time + " |timeToBonus= " + timeToBonus);
			updateTime();
		}
		
		private function bubble():void
		{
			/*for (var i:int = 0; i < arrItemBonus.length; i++)
			{
				arrItemBonus[i].
			}*/
		}
		
		private function reportHammer():void
		{
			txtTime.text = "Có thể nhận!";
			isTime = false;
			txtTime.defaultTextFormat = txtFormatTime;
			txtTime.x = arrImageTimeXBonus[_trung.id - 1];
		}
		
		private function updateTime():void
		{
			if (isTime)
			{
				//trace("vao trong cap nhap time == " + _trung.name);
				var hour:int = timeToBonus / 3600;
				var strHour:String = hour.toString();
				if (hour < 10 && hour >= 0)	strHour = "0" + hour.toString();
				
				var min:int = (timeToBonus - Math.floor(timeToBonus / 3600) * 3600) / 60;
				var strMin:String = min.toString();
				if (min < 10 && min >= 0)	strMin = "0" + min.toString();
				
				var sec:int = timeToBonus - Math.floor(timeToBonus / 60) * 60;
				var strSec:String = sec.toString();
				if (sec < 10 && sec >= 0)	strSec = "0" + sec.toString();
				
				txtFormatTime = new TextFormat("arial", 14, 0xFFFF00, true);
				//trace("hour== " + hour + " |strHour== " + strHour);
				if (hour > 24)
				{
					var day:int = hour / 24;
					var strDay:String = day.toString();
					if (day < 10 && day >= 0)	strDay = "0" + day.toString();
					txtTime.text = strDay + " Ngày";
				}
				else
				{
					txtTime.text = strHour + ":" + strMin + ":" + strSec;
				}
				txtTime.defaultTextFormat = txtFormatTime;
			}
			
			/*if (ctnBonus && ctnQuartz)
			{
				updateRock();
			}*/
		}
		
		public function updateItemRock():void
		{
			if (ctnBonus && ctnQuartz)
			{
				updateRock();
			}
		}
		
		public function updateRock():void
		{
			if (CurPos.y <= TOPPOS - 4)
			{
				specY = Math.random() * 0.3 + 0.2;
			}
			else if(CurPos.y >= TOPPOS + 4)
			{
				specY = -(Math.random() * 0.3 + 0.2);
			}
			
			CurPos.y += specY;
			ctnQuartz.SetPos(CurPos.x, CurPos.y);
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			if (buttonID)
			{
				var a:Array = buttonID.split("_");
				//trace("OnButtonClick buttonID== " + buttonID + " |a[0]== " + a[0] + " |a[1]== " + a[1]);
				switch(a[0])
				{
					case "quartzReciver":
						var b:Array = buttonID.split("_");
						//trace("OnButtonMove() buttonID== " + buttonID + "b[2]== " + b[2]);
						var ctnMove:Container = ctnQuartz.GetContainer(buttonID);
						var GuiToolTip:GUILinhThachToolTip = new GUILinhThachToolTip(null, "");
						var globalParent:Point = ctnMove.img.localToGlobal(new Point(0, 0));
						GuiToolTip.Init(dataBonusSmash[b[2]]);
						GuiToolTip.InitPos(ctnMove, "GuiTrungLinhThach_BgTipLinhThach", globalParent.x, globalParent.y, 0, -0, 0, 0, true, false);
						ctnMove.setGUITooltip(GuiToolTip);
						
						Mouse.hide();
						GameLogic.getInstance().MouseTransform("imgHand");
						break;
				}
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			//trace("OnButtonOut buttonID== " + buttonID);
			if (buttonID)
			{
				var a:Array = buttonID.split("_");
				//trace("OnButtonClick buttonID== " + buttonID + " |a[0]== " + a[0] + " |a[1]== " + a[1]);
				switch(a[0])
				{
					case "quartzReciver":
						//trace("OnButtonOut() quartzReciver");
						Mouse.show();
						GameLogic.getInstance().BackToOldMouse();
						break;
				}
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var numHammer:int = GuiMgr.getInstance().guiHammerInfo.getNumberHammer(_trung.hammer);
			if (buttonID)
			{
				var a:Array = buttonID.split("_");
				//trace("OnButtonClick buttonID== " + buttonID + " |a[0]== " + a[0] + " |a[1]== " + a[1]);
				switch(a[0])
				{
					case "quartzReciver":
						//trace("quartzReciver== " + arrQuartzEff.length);
						for (var i:int = 0; i < arrQuartzEff.length; i++ )
						{
							EffQuartz(arrQuartzEff[i]);
						}
						nenVoEgg.img.visible = false;
						nenVoEgg = null;
						ReceiveBonusOK();
						Mouse.show();
						GameLogic.getInstance().BackToOldMouse();
						
						/*var b:Array = buttonID.split("_");
						EffQuartz(b[1]);
						totalQuartz--;
						if (totalQuartz <= 0)
						{
							//trace("Het linh thach roi");
							nenVoEgg.img.visible = false;
							nenVoEgg = null;
							ReceiveBonusOK();
							Mouse.show();
							GameLogic.getInstance().BackToOldMouse();
						}*/
						event.currentTarget.visible = false;
						break;
					case CHECK_ALL_YES:
						if (numHammer > 1)
						{
							checkAllYes.SetVisible(false);
							checkAllNo.SetVisible(true);
							
							isSmashMulti = false;
						}
						break;
					case CHECK_ALL_NO:
						if (numHammer > 1)
						{
							checkAllYes.SetVisible(true);
							checkAllNo.SetVisible(false);
							
							isSmashMulti = true;
						}
						break;
				}
			}
		}
		
		private function SmashEggTheHammer():void
		{
			var numHammer:int = GuiMgr.getInstance().guiHammerInfo.getNumberHammer(_trung.hammer);
			
			var configHammer:int = ConfigJSON.getInstance().GetItemList("SmashEgg_EggHammer")[_trung.name].Num;
			if (numHammer >= configHammer)
			{
				if (GameLogic.getInstance().user.TotalQuartzStore() > Constant.ITEM_QUARTZ_MAX)
				{
					var msg:String = 'Số Huy Hiệu trong kho của bạn đã vượt quá ' + Constant.ITEM_QUARTZ_MAX + '. Hãy vào kho dọn bớt Huy Hiệu để được đập tiếp nhé!';
					GuiMgr.getInstance().GuiMessageBox.ShowOK(msg);
				}
				else
				{
					Constant.SMASH_EGG_EFF = true;
					if (isSmashMulti && numHammer > numMaxEgg)
					{
						numHammer = numMaxEgg;
					}
				
					isSmash = false;
					var cmdSmash:SendSmashEgg = new SendSmashEgg();
					cmdSmash.EggType = _trung.name;
					if (isSmashMulti)
					{
						textLoadingSmash.visible = true;
						cmdSmash.Num = numHammer;
						GuiMgr.getInstance().guiHammerInfo.updateNumberHammer(_trung.hammer, numHammer);
					}
					else
					{
						textLoadingSmash.visible = false;
						numHammer = configHammer;
						cmdSmash.Num = 1;
						GuiMgr.getInstance().guiHammerInfo.updateNumberHammer(_trung.hammer, configHammer);
					}
					Exchange.GetInstance().Send(cmdSmash);
					
					effText(GuiMgr.getInstance().guiHammerInfo.ctnHammerWhite.img, arrStartTextX[_trung.id - 1], -170, arrStartTextX[_trung.id - 1], arrStopTextY[_trung.id - 1], "-", numHammer);
				}
			}
			else
			{
				Constant.SMASH_EGG_EFF = false;
				var message:String;
				if (_trung.id == 1)
				{
					message = 'Rất tiếc bạn không có đủ ' + configHammer + ' búa ' + nameHammer[_trung.id - 1] + '. Hãy đợi thêm thời gian đề nhận miễn phí nhé!';
				}
				else
				{
					message = 'Rất tiếc bạn không có đủ ' + configHammer + ' búa ' + nameHammer[_trung.id - 1] + '. Hãy vào cửa hàng mua thêm búa nhé!';
				}
				GuiMgr.getInstance().GuiMessageBox.ShowOK(message);
			}
		}
				
		private function getBonusAll():void
		{
			var cmdBonus:SendReceiveBonus = new SendReceiveBonus();
			cmdBonus.EggType = _trung.name;
			Exchange.GetInstance().Send(cmdBonus);
		}
		
		public function unlockItem():void 
		{
			
		}
		
		public function get trung():Object 
		{
			var data:Object = new Object();
			return data;// _trung;
		}
		
		public function set trung(value:Object):void 
		{
			//_trung = value;
		}
		
		private function clickSmashEgg(event:MouseEvent):void
		{
			//trace("clickSmashEgg isSmash== " + isSmash);
			if (isSmash && !Constant.SMASH_EGG_EFF && mcHoiSinhTrung == null)
			{
				SmashEggTheHammer();
				dataBonusSmash.splice(0, dataBonusSmash.length);
			}
		} 
		
		private function loadAnimationSmash():void
		{
			isLoadBonus = true;
			isLoadBox = false;
			EffSmashEgg = AddImage(SMASH_EGG, "EggSmashType" + _trung.id, arrImageSmashX[_trung.id - 1], arrImageSmashY[_trung.id - 1]);
			EffSmashEgg.GoToAndPlay(1);
			EffSmashEgg.img.addEventListener(Event.ENTER_FRAME, onEnterSmash);
		}
		
		private function onEnterSmash(event:Event):void
		{
			//trace("currentFrame== " + EffSmashEgg.currentFrame);
			if (EffSmashEgg)
			{
				if(EffSmashEgg.currentFrame == 30)
				{
					EffSmashEgg.GoToAndStop(30);
					EffSmashEgg.img.removeEventListener(Event.ENTER_FRAME, onEnterSmash);
					EffSmashEgg.img.visible = false;
					EffSmashEgg = null;
					isLoadBonus = true;
					smashOKNoReceive();
				}
			}
		}
		
		private function clickReceive(event:MouseEvent):void
		{
			if (isNhanHammer)
			{
				isTime = false;
				isNhanHammer = false;
				isClickBox = true;
				btnBoxBonus.img.visible = false;
				btnBoxBonus = null;
				
				if (btnBoxIdol)
				{
					btnBoxIdol.img.visible = false;
				}
				
				isLoadBox = false;
				getLoadOpenBox();
				getBonusAll();
			}
			else
			{
				var message:String = 'Chưa đến giờ nhận Búa miễn phí!';
				GuiMgr.getInstance().GuiMessageBox.ShowOK(message);
			}
		}
		
		private function getLoadOpenBox():void
		{
			isLoadBox = true;
			if (btnBoxBonus)
			{
				btnBoxBonus.img.visible = false;
				btnBoxBonus = null;
			}
			if (btnBoxIdol)
			{
				btnBoxIdol.img.visible = false;
			}
			openBoxBonus = AddImage(BTN_BOX_BONUS, "boxLoadHammer" + _trung.id, arrImageBoxX[_trung.id - 1] + 90, arrImageBoxY[_trung.id - 1] + 42);
			openBoxBonus.GoToAndPlay(1);
			openBoxBonus.img.addEventListener(Event.ENTER_FRAME, onEnterOpenBox);
		}
		
		private function onEnterOpenBox(event:Event):void
		{
			if (openBoxBonus.currentFrame == 15)
			{
				var nameImageEff:String = 'GuiTrungLinhThach_Hammer_' + _trung.id;
				var startX:int = arrStartX[_trung.id - 1];
				var startY:int = arrStartY[_trung.id - 1];
				var fallY:int = startY - 30;
				var stopX:int = arrStopX[_trung.id - 1];
				var stopY:int = arrStopY[_trung.id - 1];
				var numItemFly:int = 1;
				
				effFallFly(Constant.GUI_MIN_LAYER, nameImageEff, startX, startY, fallY, stopX, stopY, numItemFly);
				
				effText(GuiMgr.getInstance().guiHammerInfo.ctnHammerWhite.img, arrStartTextX[_trung.id - 1], -170, arrStartTextX[_trung.id - 1], arrStopTextY[_trung.id - 1], "+", 1);
			}
			
			if (openBoxBonus.currentFrame == 35)
			{
				//trace("currentFrame== " + openBoxBonus.currentFrame);
				openBoxBonus.GoToAndStop(35);
				openBoxBonus.img.removeEventListener(Event.ENTER_FRAME, onEnterOpenBox);
				openBoxBonus.img.visible = false;
				openBoxBonus = null;
				
				if (btnBoxBonus)
				{
					btnBoxBonus.img.visible = false;
					btnBoxBonus = null;
				}
			
				if (btnBoxIdol)
				{
					btnBoxIdol.img.visible = true;
				}
				else
				{
					btnBoxIdol = AddButton(BTN_BOX_BONUS, "boxBonusType" + _trung.id, arrImageBoxX[_trung.id - 1], arrImageBoxY[_trung.id - 1]);
					btnBoxIdol.img.visible = true;
				}
				btnBoxIdol.setTooltipText("Mở hộp quà nhận Búa " + nameHammer[_trung.id - 1]);
				
				isLoadBox = false;
			}
		}
		
		private function effText(img1:Sprite, dx1:int, dy1:int, dx2:int,dy2:int,asign:String = "+", num:int = 1):void
		{
			if (img1)
			{
				var str:String = asign + Ultility.StandardNumber(num);
				var posStart:Point = new Point(img1.x + dx1, img1.y + dy1);
				posStart  = img.localToGlobal(posStart);
				var posEnd:Point = new Point(img1.x + dx2, img1.y + dy2);
				posEnd = img.localToGlobal(posEnd);
				var fm:TextFormat = new TextFormat("Arial", 16);
				fm.align = "center";
				fm.bold = true;
				if (asign == "-")
				{
					fm.color = 0xff0000;
				}
				else
				{
					fm.color = 0xffff00;
				}
				Ultility.ShowEffText(str, null, posStart, posEnd, fm);
			}
		}
		
		private function effFallFly(iLayer:int, imageName:String, xsrc:int, ysrc:int, ydestFall:int, xdestFly:int, ydestFly:int, num: int = 0, finishFallFly:Function = null, indexFunction:int = 1):void
		{
			var motion:MotionObject;
			motion = new EffCurveQuartz(LayerMgr.getInstance().GetLayer(iLayer), imageName, xsrc, ysrc, true, ALIGN_LEFT_TOP, 0);
			EffectMgr.getInstance().motionArr.push(motion);
			motion.fall(ydestFall, 4, 1);
			motion.finishMotion = function():void { complete(motion.MotionState) };
			function complete(motionState:int):void
			{
				if (motion.img == null) return;
				trace(motionState);
				switch(motionState)
				{
					case MotionObject.MOTION_FALL:
						//Effect										
						var pos:Point = Ultility.PosLakeToScreen(motion.CurPos.x, motion.CurPos.y);
						//Bay lượn
						var dir:int = pos.x < 300 ? 1 : -1;
						pos = Ultility.PosScreenToLake(xdestFly, ydestFly);
						motion.curve(pos.x, pos.y, dir, 0, 8);
						motion.desPosOnStage = new Point(xdestFly, ydestFly);
						break;
						
					case MotionObject.MOTION_CURVE:
						motion.roomOut(0.2, 1.7, -0.04);
						break;
					case MotionObject.MOTION_ROOM_OUT:
						motion.removeSelf();
						EffectMgr.getInstance().motionArr.splice(EffectMgr.getInstance().motionArr.indexOf(motion), 1);		
						if (finishFallFly != null)
						{
							finishFallFly(num, indexFunction);
						}
						break;
				}
			}
		}
		
		public function ClearItemBonus():void
		{
			if (isLoadBonus)
			{
				ReceiveBonusOK();
				
				if (EffSmashEgg)
				{
					EffSmashEgg.img.removeEventListener(Event.ENTER_FRAME, onEnterSmash);
					EffSmashEgg.img.visible = false;
					EffSmashEgg = null;	
				}
			}
			//trace("ClearItemBonus== " + isLoadBox);
			if (isLoadBox)
			{
				if (openBoxBonus)
				{
					openBoxBonus.img.removeEventListener(Event.ENTER_FRAME, onEnterOpenBox);
					openBoxBonus.img.visible = false;
					openBoxBonus = null;	
				}
			}
		}
	}

}