package GUI.TrainingTower.TrainingGUI 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Event.EventMgr;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.TrainingTower.TrainingLogic.Room;
	import GUI.TrainingTower.TrainingLogic.TrainingMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LogicGift.GiftNormal;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class PageRoom extends Container 
	{
		private const XBUFF:int = 22;
		private const YBUFF:int = 26;
		static public const ID_BTN_MERIDIAN:String = "idBtnMeridian";
		static public const ID_BTN_START:String = "idBtnStart";
		static public const ID_BTN_STOP:String = "idBtnStop";
		static public const ID_BTN_SPEEDUP:String = "idBtnSpeedup";
		static public const ID_BTN_RECEIVE:String = "idBtnReceive";
		static public const ID_PRG_TIME:String = "idPrgTime";
		private const ID_PRG_RANK:String = "idPrgRank";
		private const ID_BTN_PRE_FISH:String = "idBtnPreFish";
		private const ID_BTN_NEXT_FISH:String = "idBtnNextFish";
		private const ID_LISTBOX:String = "idListBox";
		private const COMBOTIME:String = "ComboTime";
		private const COMBOINTENSITY:String = "ComboIntensity";
		private const DELTA_TIME:int = 60;
		
		private const ID_CHK_TIME_DIAMOND:String = "idChkTimeDiamond";
		private const ID_CHK_TIME_ZMONEY:String = "idChkTimeZmoney";
		private const ID_CHK_INTENSITY_DIAMOND:String = "idChkIntensityDiamond";
		private const ID_CHK_INTENSITY_ZMONEY:String = "idChkIntensityZmoney";
		private const ID_UCHK_TIME_DIAMOND:String = "idUChkTimeDiamond";
		private const ID_UCHK_TIME_ZMONEY:String = "idUChkTimeZmoney";
		private const ID_UCHK_INTENSITY_DIAMOND:String = "idUChkIntensityDiamond";
		private const ID_UCHK_INTENSITY_ZMONEY:String = "idUChkIntensityZmoney";
		
		// gui
		public var imageSoldier:Image;
		public var curSoldier:FishSoldier;
		public var listFish:Array;

		public var tfPriceTime:TextField;
		public var tfPriceDiamondTime:TextField;
		public var tfPriceIntensity:TextField;
		public var tfPriceDimamondIntensity:TextField;
		public var imgXuTime:Image;
		public var imgDiamondTime:Image;
		public var imgXuIntensity:Image;
		public var imgDiamondIntensity:Image;
		public var imgGoldTime:Image;
		public var imgGoldIntensity:Image;
		private var btnNextFish:Button;
		private var btnPrevFish:Button;
		private var _fmBlack:TextFormat;
		private var prgRankPoint:ProgressBar;
		private var tfRank:TextField;
		private var tfMeri:TextField;
		private var tfPercentRank:TextField;
		private var tfMeridian:TextField;
		private var comboIntensity:ComboBoxEx;
		private var comboTime:ComboBoxEx;
		private var btnMeridian:Button;
		public var btnStop:Button;
		public var btnStart:Button;
		public var btnSpeedUp:Button;
		public var tfPriceSpeedUp:TextField;
		private var btnReceive:Button;
		private var imgClock:Image;
		private var prgClock:ProgressBar;
		private var imgH1:Image, imgH2:Image;
		private var imgM1:Image, imgM2:Image;
		private var imgS1:Image, imgS2:Image;
		private var tfStatus:TextField;
		private var fmStatus:TextFormat;
		private var tfRankPoint:TextField;
		private var tfMeridianPoint:TextField;
		private var tfGift2:TextField;
		private var tfGift3:TextField;
		private var tfGift4:TextField;
		private var tfGift5:TextField;
		private var effTraining:Image;
		private var fmEff:TextFormat;
		private var tfLimitTime:TextField;
		private var imgRankStar:Image;
		private var tfStatusTrain:TextField;
		private var effFinish:Image;
		
		private var chkTimeZMoney:Button;
		private var chkTimeDiamond:Button;
		private var chkIntensityZMoney:Button;
		private var chkIntensityDiamond:Button;
		private var uchkTimeZMoney:Button;
		private var uchkTimeDiamond:Button;
		private var uchkIntensityZMoney:Button;
		private var uchkIntensityDiamond:Button;
	
		// logic
		private var _room:Room;
		private const boxIntensityData:Array = ["Thong thả", "Thường", "Chăm chỉ", "Khắc nghiệt"];
		private var imgColon1:Image;
		private var imgColon2:Image;
		private var boxRankPoint:Object=null;
		private var boxMeridian:Object=null;
		public var isFinishPlusRankPoint:Boolean=false;
		public var isFinishPlusMeridian:Boolean=false;
		public var boxTimeDataInt:Array = [];
		public var boxTimeDataStr:Array = [];
		public var curTimeType:int;
		public var curIntensityType:int;
		private var _timePage:Number;
		public var inSeek:Boolean;
		public var deltaTimeRankPoint:int;
		public var deltaTimeMeridian:int;
		public var markTimeRank:Number;
		public var markTimeMeridian:Number;
		public var curRankPointGift:int = 0;
		public var curMeriPointGift:int = 0;
		public var moneyIntensity:int=0;
		public var zmoneyIntensity:int=0;
		public var moneyTime:int=0;
		public var zmoneyTime:int = 0;
		public var diamondTime:int = 0;
		public var diamondIntensity:int = 0;
		public var activeId:int = 0;
		
		public var priceType_time:String;
		public var priceType_intensity:String;
		
		public function PageRoom(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "PageRoom";
			_fmBlack = new TextFormat("arial", 12, 0x000000);
			//_fmBlack.italic = true;
			//_fmBlack.align = TextFormatAlign.RIGHT;
			fmStatus = new TextFormat("arial", 24, 0x330066, true);
			//fmStatus.align = TextFormatAlign.CENTER;
			fmEff = new TextFormat("SansationBold", 22, null, true);
		}
		
		public function initBoxTime():void
		{
			boxTimeDataStr.splice(0, boxTimeDataStr.length);
			boxTimeDataInt.splice(0, boxTimeDataInt.length);
			var config:Object = ConfigJSON.getInstance().getItemInfo("CustomTraining");
			var oTime:Object = config["Time"];
			for (var i:String in oTime)
			{
				var value:int = int(i);
				boxTimeDataInt.push(value);
			}
			boxTimeDataInt.sort(Array.NUMERIC);
			
			var str:String;
			for (var j:int = 0; j < boxTimeDataInt.length; j++)
			{
				var time:int = boxTimeDataInt[j];
				if (time < 60) {
					str = time + " phút";
				}
				else {
					str = int(time / 60) + " giờ";
				}
				boxTimeDataStr.push(str);
			}
		}
		
		public function initData(room:Room):void
		{
			_room = room;
		}
		
		public function initPage():void
		{
			initButton();
			initFishProperty();	//khởi tạo các thông số của con cá
			initListFish();		//khởi tạo cái listFish
			initCheckBox();
			initCombo();		//khởi tạo 2 cái combo time và intensity
			initGift();			//khởi tạo quà
			initPrice();		//khởi tạo giá của mỗi combo item
			initStatusTrain();	//khởi tạo về thời gian luyện
			initSpeedUpLimit();	//khởi tạo số lần tua tối đa
			
		}
		
		private function initSpeedUpLimit():void 
		{
			if (tfLimitTime == null) {
				tfLimitTime = AddLabel("", 490, 429 + YBUFF, 0xFFFF00, 1, 0x000000);
				var fm:TextFormat = new TextFormat("arial", 11);
				//fm.italic = true;
				tfLimitTime.defaultTextFormat = fm;
			}
			updateTimeToTraing();
		}
		
		public function updateTimeToTraing():void 
		{
			//if (_room.State == Room.STATE_TRAIN) {
				tfLimitTime.visible = true;
				//var speedUpLimit:int = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Time"][_room.TimeType.toString()]["SpeedUpLimit"];
				//var remainSpeed:int =  speedUpLimit - TrainingMgr.getInstance().SpeedUpNum;
				//tfLimitTime.text = "Bạn còn " + Ultility.StandardNumber(remainSpeed) +" luợt tăng tốc";
				var str:String = "Hôm nay ngư thủ còn " + getTimeToTraing(_room.SoldierId) +" để luyện";
				tfLimitTime.text = str;
				var fm:TextFormat = new TextFormat("arial", 11, 0xff0000);
				//fm.italic = true;
				var indexStart:int = str.search("còn ") + 4;
				var indexEnd:int = str.search(" để luyện");
				tfLimitTime.setTextFormat(fm, indexStart, indexEnd);
			//}
			//else {
				//tfLimitTime.visible = false;
			//}
			
		}
		
		private function getTimeToTraing(soldierId:int):String 
		{
			var soldierArr:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			var time:int;
			for (var i:int = 0; i < soldierArr.length; i++) {
				var soldier:FishSoldier = soldierArr[i] as FishSoldier;
				if (soldier.Id == soldierId) {
					time = soldier.timeToTraining;
				}
			}
			var hh:int = int(time / 3600);
			var dh:int = time % 3600;
			var mm:int = int(dh / 60);
			//var dm:int = dh % 60;
			var sh:String = (hh < 10)?"0" + hh.toString():hh.toString();
			var sm:String = (mm < 10)?"0" + mm.toString():mm.toString();
			return sh + " giờ " + sm + " phút";
		}
		
		private function initStatusTrain():void 
		{
			if (tfStatus == null)
			{
				tfStatus = AddLabel("", 145, 440 + YBUFF);
				tfStatus.defaultTextFormat = fmStatus;
				tfStatusTrain = AddLabel("Đang tu luyện ...", 145, 427 + YBUFF);
				tfStatusTrain.defaultTextFormat = new TextFormat("Arial", 12, 0x000000);
				tfStatusTrain.visible = false;
				if (_room.State == Room.STATE_IDLE)
				{
					tfStatus.text = "Chưa tu luyện!"; 
					if (TrainingMgr.getInstance().ListIdleSoldier.length == 0) {
						tfStatus.text = "Không có ngư thủ";
					}
				}
				else if (_room.State == Room.STATE_FINISH)
				{
					tfStatus.text = "Hoàn thành!";
				}
				else if (_room.State == Room.STATE_TRAIN)
				{
					tfStatusTrain.visible = true;
					var remainTime:int = _room.TimeTrain - (timePage - _room.StartTime);
					var objTime:Object = { "hour":0, "minute":0, "second":0 };
					objTime = TrainingMgr.getInstance().countTime(remainTime);
					AddTime(objTime, 141, 196, 256, 468);
				}
			}
			else
			{
				UpdateStaus(0);
			}
			
		}
		
		private function initCheckBox():void
		{
			if (chkTimeDiamond == null)
			{
				chkTimeZMoney = AddButton(ID_CHK_TIME_ZMONEY, "GuiTraining_CheckBox", 560, 395);
				chkTimeDiamond = AddButton(ID_CHK_TIME_DIAMOND, "GuiTraining_CheckBox", 633, 395);
				chkIntensityZMoney = AddButton(ID_CHK_INTENSITY_ZMONEY, "GuiTraining_CheckBox", 560, 430);
				chkIntensityDiamond = AddButton(ID_CHK_INTENSITY_DIAMOND, "GuiTraining_CheckBox", 633, 430);
				chkTimeDiamond.SetVisible(false);
				chkTimeZMoney.SetVisible(false);
				chkIntensityDiamond.SetVisible(false);
				chkIntensityZMoney.SetVisible(false);
				
				uchkTimeZMoney = AddButton(ID_UCHK_TIME_ZMONEY, "GuiTraining_UncheckBox", 560, 395);
				uchkTimeDiamond = AddButton(ID_UCHK_TIME_DIAMOND, "GuiTraining_UncheckBox", 633, 395);
				uchkIntensityZMoney = AddButton(ID_UCHK_INTENSITY_ZMONEY, "GuiTraining_UncheckBox", 560, 430);
				uchkIntensityDiamond = AddButton(ID_UCHK_INTENSITY_DIAMOND, "GuiTraining_UncheckBox", 633, 430);
				uchkTimeDiamond.SetVisible(false);
				uchkTimeZMoney.SetVisible(false);
				uchkIntensityDiamond.SetVisible(false);
				uchkIntensityZMoney.SetVisible(false);
				
				//_room.TimePayType = "Free";
				//_room.IntensityPayType = "Free";
				//priceType_time = "";
				//priceType_intensity = "";
			}
			
		}
		private function UpdateStaus(time:Number):void 
		{
			if (_room.State == Room.STATE_IDLE)
			{
				//tfStatus.x = 145;
				//tfStatus.y = 440;
				tfStatus.visible = true;
				if (imgH1)
				{
					imgH1.img.visible = imgH2.img.visible =
					imgM1.img.visible = imgM2.img.visible =
					imgS1.img.visible = imgS2.img.visible = 
					imgColon1.img.visible = imgColon2.img.visible = tfStatusTrain.visible = 
					imgClock.img.visible = false;
					prgClock.setVisible(false);
				}
				if (TrainingMgr.getInstance().ListIdleSoldier.length == 0) {
					tfStatus.text = "Không có ngư thủ";
				}
				else {
					tfStatus.text = "Chưa tu luyện!";
				}
				//tfStatus.setTextFormat(fmStatus);
				
			}
			else if (_room.State == Room.STATE_FINISH)
			{
				tfStatus.visible = true;
				if (imgH1)
				{
					imgH1.img.visible = imgH2.img.visible =
					imgM1.img.visible = imgM2.img.visible =
					imgS1.img.visible = imgS2.img.visible = 
					imgColon1.img.visible = imgColon2.img.visible = tfStatusTrain.visible =
					imgClock.img.visible = false;
					prgClock.setVisible(false);
				}
				//tfStatus.x = 145;
				//tfStatus.y = 440;
				tfStatus.text = "Hoàn thành!";
				
				//tfStatus.setTextFormat(fmStatus);
			}
			else if (_room.State == Room.STATE_TRAIN)
			{
				tfStatus.visible = false;
				tfStatusTrain.visible = true;
				var remainTime:int = _room.TimeTrain - (time - _room.StartTime);
				var objTime:Object = { "hour":0, "minute":0, "second":0 };
				if (time > 0)
				{
					objTime = TrainingMgr.getInstance().countTime(remainTime);
				}
				AddTime(objTime, 141, 196, 256, 468);
				updateTime(objTime);
				//imgH1.img.visible = imgH2.img.visible =
				//imgM1.img.visible = imgM2.img.visible =
				//imgS1.img.visible = imgS2.img.visible = 
				imgColon1.img.visible = imgColon2.img.visible =
				imgClock.img.visible = true;
				prgClock.setVisible(true);
			}
		}
		
		private function AddTime(objTime:Object, xh:int, xm:int, xs:int, y:int):void 
		{
			if (imgH1 == null)
			{
				prgClock = AddProgress(ID_PRG_TIME, "GuiTraining_PrgTime", 112, 446, EventHandler, true);
				imgClock = AddImage("", "GuiTraining_ImgClock", 108, 467);
				imgColon1 = AddImage("", "GuiTraining_TxtColon", 181, 468);
				imgColon2 = AddImage("", "GuiTraining_TxtColon", 236, 468);
				var hour:int = objTime["hour"];
				var h1:int = hour / 10;
				var h2:int = hour % 10;
				imgH1 = AddImage("idTime", "GuiTraining_TxtNo" + h1, xh, y);
				imgH2 = AddImage("idTime", "GuiTraining_TxtNo" + h2, xh + imgH1.img.width + 1, y);
				
				var minute:int = objTime["minute"];
				var m1:int = minute / 10;
				var m2:int = minute % 10;
				imgM1 = AddImage("idTime", "GuiTraining_TxtNo" + m1, xm, y);
				imgM2 = AddImage("idTime", "GuiTraining_TxtNo" + m2, xm + imgM1.img.width + 1, y);
				
				var second:int = objTime["second"];
				var s1:int = second / 10;
				var s2:int = second % 10;
				imgS1 = AddImage("idTime", "GuiTraining_TxtNo" + s1, xs, y);
				imgS2 = AddImage("idTime", "GuiTraining_TxtNo" + s2, xs + imgS1.img.width + 1, y);
			}
		}
		
		private function updateTime(objTime:Object):void
		{
			var hour:int = objTime["hour"];
			var h1:int = hour / 10;
			var h2:int = hour % 10;
			imgH1.LoadRes("GuiTraining_TxtNo" + h1);
			imgH2.LoadRes("GuiTraining_TxtNo" + h2);
			imgH2.img.x = imgH1.img.x + imgH1.img.width + 1;
			
			var minute:int = objTime["minute"];
			var m1:int = minute / 10;
			var m2:int = minute % 10;
			imgM1.LoadRes("GuiTraining_TxtNo" + m1);
			imgM2.LoadRes("GuiTraining_TxtNo" + m2);
			imgM2.img.x = imgM1.img.x + imgM1.img.width + 1;
			
			var second:int = objTime["second"];
			var s1:int = second / 10;
			var s2:int = second % 10;
			imgS1.LoadRes("GuiTraining_TxtNo" + s1);
			imgS2.LoadRes("GuiTraining_TxtNo" + s2);
			imgS2.img.x = imgS1.img.x + imgS1.img.width + 1;
		}
		private function initButton():void 
		{
			if (btnMeridian == null && btnStart == null && 
				btnStop == null && btnSpeedUp == null &&
				btnReceive == null)
			{
				btnMeridian = AddButton(ID_BTN_MERIDIAN, "GuiTraining_BtnMeridian", 150, 390 + YBUFF, EventHandler);
				btnStart = AddButton(ID_BTN_START, "GuiTraining_BtnStartTrain", 475, 454 + YBUFF, EventHandler, "StartTraining");
				btnStop = AddButton(ID_BTN_STOP, "GuiTraining_BtnStopTrain", 395, 458 + YBUFF, EventHandler);
				btnSpeedUp = AddButton(ID_BTN_SPEEDUP, "GuiTraining_BtnSpeedUp", 510, 454 + YBUFF, EventHandler, "SpeedUp");
				btnReceive = AddButton(ID_BTN_RECEIVE, "GuiTraining_BtnReceive", 475, 454 + YBUFF, EventHandler, "GetGiftTraining");
				btnMeridian.SetVisible(false); btnStart.SetVisible(false);
				btnStop.SetVisible(false); btnSpeedUp.SetVisible(false);
				btnReceive.SetVisible(false);
				tfPriceSpeedUp = AddLabel("1", 540, 459 + YBUFF, 0xffffff, 1, 0x000000);
				tfPriceSpeedUp.visible = false;
			}
			updateStateButton();
		}
		
		private function updateStateButton():void 
		{
			//btnSpeedUp.SetEnable(hasSpeedUp());
			switch(_room.State)
			{
				case Room.STATE_IDLE:
					btnStart.SetVisible(true);
					btnMeridian.SetVisible(true);
					btnStop.SetVisible(false); btnReceive.SetVisible(false); btnSpeedUp.SetVisible(false);
					tfPriceSpeedUp.visible = false;
					updateStateStartButton();
					btnStart.SetEnable(TrainingMgr.getInstance().ListIdleSoldier.length > 0);
				break;
				case Room.STATE_LOCK:
					
				break;
				case Room.STATE_FINISH:
					btnReceive.SetVisible(true);
					btnMeridian.SetVisible(true);
					btnStart.SetVisible(false); btnStop.SetVisible(false); btnSpeedUp.SetVisible(false);
					tfPriceSpeedUp.visible = false;
				break;
				case Room.STATE_TRAIN:
					var objTime:Object = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Time"];
					var zmoneySpeedUp:int = objTime[_room.TimeType.toString()]["SpeedUpZMoney"];
					btnSpeedUp.SetVisible(true);
					btnStop.SetVisible(true);
					btnReceive.SetVisible(false); btnStart.SetVisible(false); btnMeridian.SetVisible(true);
					tfPriceSpeedUp.text = zmoneySpeedUp.toString();
					tfPriceSpeedUp.visible = true;
					btnSpeedUp.ButtonID = ID_BTN_SPEEDUP + "_" + zmoneySpeedUp;
					//btnSpeedUp.SetEnable(!room.inSeek && hasSpeedUp());
					btnSpeedUp.SetEnable(!room.inSeek);
					btnStop.SetEnable(!room.inSeek);
				break;
			}
		}
		
		private function updateStateStartButton():void 
		{
			//var isEnable:Boolean = curSoldier!=null && TrainingMgr.getInstance().ListIdleSoldier.length > 0 &&
									//curSoldier.timeToTraining >= _room.TimeTrain;
			//btnStart.SetEnable(isEnable);
		}
		
		public function hasSpeedUp():Boolean 
		{
			var limit:int = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Time"][_room.TimeType.toString()]["SpeedUpLimit"];
			var remainNum:int = limit - TrainingMgr.getInstance().SpeedUpNum;
			if (remainNum > 0) {
				return true;
			}
			else {
				return false;
			}
		}
		
		private function initGift():void 
		{
			RemoveAllButtonEx();//xóa hết các quà ở page trước đó (nếu có)
			var objIntensity:Object = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Intensity"];
			var giftNum:int = objIntensity[_room.IntensityType.toString()]["GiftNum"];
			var knowGift:Boolean = (_room.State == Room.STATE_FINISH);
			var giftList:Array = _room.GiftList;
			var x:int = 553, y:int = 230;
			var tip:TooltipFormat;
			var imgGift:ButtonEx;
			//var multi:int = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Intensity"][_room.IntensityType.toString()]["GiftNum"];
			
			if (tfRankPoint == null && tfMeridianPoint == null) 
			{
				curRankPointGift = 0;
				curMeriPointGift = 0;
				tfRankPoint = AddLabel("0", 450 + XBUFF, 262 + YBUFF, 0xffffff, 1, 0x000000);
				tfMeridianPoint = AddLabel("0", 350 + XBUFF, 262 + YBUFF, 0xffffff, 1, 0x000000);
				tfGift2 = AddLabel("", 547 + XBUFF, 262 + YBUFF, 0xffffff, 1, 0x000000);
				tfGift3 = AddLabel("", 347 + XBUFF, 340 + YBUFF, 0xffffff, 1, 0x000000);
				tfGift4 = AddLabel("", 447 + XBUFF, 340 + YBUFF, 0xffffff, 1, 0x000000);
				tfGift5 = AddLabel("", 547 + XBUFF, 340 + YBUFF, 0xffffff, 1, 0x000000);
			}
			if (knowGift) 
			{
				for (var str:String in giftList) {
					if (giftList[str]["ItemType"] == "RankPoint") {
						tfRankPoint.text = Ultility.StandardNumber(giftList[str]["Num"]);
						isFinishPlusRankPoint = true;
					}
					else if (giftList[str]["ItemType"] == "Meridian") {
						tfMeridianPoint.text = Ultility.StandardNumber(giftList[str]["Num"]);
						isFinishPlusMeridian = true;
					}
				}
			}
			else {
				if (room.State == Room.STATE_TRAIN) {
					var curTime:Number = GameLogic.getInstance().CurServerTime;
					var minRank:int = boxRankPoint[_room.TimeType.toString()]["min"];
					var minMeri:int = boxMeridian[_room.TimeType.toString()]["min"];
					curRankPointGift = int((curTime - _room.StartTime) / deltaTimeRankPoint) * minRank;
					curMeriPointGift = int((curTime - _room.StartTime) / deltaTimeMeridian) * minMeri;
					tfRankPoint.text = Ultility.StandardNumber(curRankPointGift);
					tfMeridianPoint.text = Ultility.StandardNumber(curMeriPointGift);
				}
				else {
					tfRankPoint.text = getBoundStr("Time", _room.TimeType, 1);
					tfMeridianPoint.text = getBoundStr("Time", _room.TimeType, 2);
					tfGift2.text = "";tfGift3.text = "";tfGift4.text = "";tfGift5.text = "";
				}
				
			}
			x = 593; y = 222;
			for (var i:int = 2; i < giftNum + 2; i++)
			{
				tip = new TooltipFormat();
				if (knowGift)
				{
					var index:int = i;
					var giftN:GiftNormal = giftList[index] as GiftNormal;
					tip.text = giftN.getTooltipText();
					imgGift = AddButtonEx("", giftN.getImageName(), x, y + YBUFF);
					if (giftN.ItemType == "SoulRock") {
						var sp:Sprite = ResMgr.getInstance().GetRes("Number_" + giftN.ItemId) as Sprite;
						sp.scaleX=sp.scaleY=0.5
						imgGift.img.addChild(sp);
						sp.x = 10; sp.y = 15;
					}
					imgGift.FitRect(53, 42, new Point(x, y + YBUFF));
					(this["tfGift" + i] as TextField).text = Ultility.StandardNumber(giftN.Num);
				}
				else
				{
					tip.text = Localization.getInstance().getString("WhatGift");
					imgGift = AddButtonEx("", "GuiTraining_ImgWhatGift", x, y);
					imgGift.FitRect(53, 42, new Point(x, y + YBUFF));
					tip.text = "Phần thưởng ngẫu nhiên";
					(this["tfGift" + i] as TextField).text = "";
				}
				imgGift.setTooltip(tip);
				x += 100;
				if (i == 2) {
					x = 395;
					y = 301;
				}
			}
		}
		private function initPrice():void 
		{
			//vẽ 2 textfield về giá của mỗi item combo
			if (tfPriceTime == null && tfPriceDiamondTime == null && tfPriceIntensity == null &&
				tfPriceDimamondIntensity == null
				&& imgXuIntensity == null && imgXuTime == null
				&&imgGoldIntensity == null && imgGoldTime == null)
			{
				tfPriceTime = AddLabel("free", 535, 368 + YBUFF);
				tfPriceDiamondTime = AddLabel("free", 605, 368 + YBUFF);
				//tfPriceTime.border = true;
				tfPriceIntensity = AddLabel("free", 535, 403 + YBUFF);
				tfPriceDimamondIntensity = AddLabel("free", 605, 403 + YBUFF);
				//tfPriceIntensity.border = true;
				//tfPriceTime.width = tfPriceIntensity.width = 55;
				//tfPriceTime.height = tfPriceIntensity.height = 20;
				tfPriceTime.defaultTextFormat = 
				tfPriceDiamondTime.defaultTextFormat = 
				tfPriceDimamondIntensity.defaultTextFormat =
				tfPriceIntensity.defaultTextFormat = _fmBlack;
				
				imgXuTime = AddImage("", "IcZingXu", 620, 378 + YBUFF);
				imgDiamondTime = AddImage("", "IcDiamond", 690, 382 + YBUFF);
				imgDiamondTime.SetScaleXY(0.75);
				imgGoldTime = AddImage("", "IcGold", 620, 378 + YBUFF);
				imgXuIntensity = AddImage("", "IcZingXu", 620, 413 + YBUFF);
				imgDiamondIntensity = AddImage("", "IcDiamond", 690, 417 + YBUFF);
				imgDiamondIntensity.SetScaleXY(0.75);
				imgGoldIntensity = AddImage("", "IcGold", 620, 413 + YBUFF);
				imgXuTime.img.visible = imgXuIntensity.img.visible =
				imgDiamondTime.img.visible = imgDiamondIntensity.img.visible = 
				imgGoldTime.img.visible = imgGoldIntensity.img.visible = false;
			}
			updatePriceTime(_room.TimeType);
			updatePriceIntensity(_room.IntensityType);
		}
		
		private function initListFish():void 
		{
			/*b1: khởi tạo listbox, 2 nút next và previous*/
			if (btnNextFish == null && btnPrevFish == null)
			{
				btnPrevFish = AddButton(ID_BTN_PRE_FISH, "GuiTraining_BtnPrev", 43, 333 + YBUFF);
				btnNextFish = AddButton(ID_BTN_NEXT_FISH, "GuiTraining_BtnNext", 302, 333 + YBUFF);
			}
			
			btnNextFish.SetVisible(false);
			btnPrevFish.SetVisible(false);
			/*b2: thực hiện vẽ ra những con cá*/
			if (effTraining != null) {
				RemoveImage(effTraining);
				effTraining = null;
			}
			if (_room.State == Room.STATE_IDLE)
			{
				drawFishIdleList(TrainingMgr.getInstance().ListIdleSoldier);
			}
			else if (_room.State == Room.STATE_TRAIN)
			{
				drawTrainingFish(TrainingMgr.getInstance().getSoldierFromTrainingList(_room.SoldierId));
			}
			else if (_room.State == Room.STATE_FINISH)
			{
				drawFinishFish(TrainingMgr.getInstance().getSoldierFromTrainingList(_room.SoldierId));
			}
		}
		
		private function initFishProperty():void 
		{
			if (tfMeri == null && tfRank == null && tfMeridian == null && prgRankPoint == null && imgRankStar == null)
			{
				
				var txtFormat:TextFormat = new TextFormat("arial", 13, 0xffffff, true);
				tfRank = AddLabel("Điểm chiến công", 86, 205 + 26, 0xffffff, 1, 0x000000);
				tfRank.defaultTextFormat = txtFormat;
				tfRank.autoSize = TextFieldAutoSize.CENTER;
				tfMeri = AddLabel("Điểm ngư mạch", 225, 206 + 26, 0xffffff, 1, 0x000000);
				tfMeri.setTextFormat(txtFormat);
				prgRankPoint = AddProgress(ID_PRG_RANK, "GuiTraining_PrgRankPoint", 80, 233 + 26, this, true);
				prgRankPoint.setStatus(0);
				tfPercentRank = AddLabel("", 100, 235 + 26, 0xffffff, 1, 0x000000);
				tfPercentRank.defaultTextFormat = txtFormat;
				tfMeridian = AddLabel("0", 230, 235 + 26, 0xffffff, 1, 0x000000);
				txtFormat.color = 0xffffff;
				tfMeridian.defaultTextFormat = txtFormat;
				imgRankStar = AddImage("", "IcStarRank", 65, 244 + 26);
			}
		}
		private function updateFishProperty(soldier:FishSoldier):void
		{
			if (soldier == null) {
				tfRank.text = "Điểm chiến công";
				tfPercentRank.text = "";
				prgRankPoint.setStatus(0);
				tfMeridian.text = "";
			}
			else {
				var str:String = "Cấp " + soldier.Rank + " - " +
							Localization.getInstance().getString("FishSoldierRank" + soldier.Rank);
				if (str.length > 26) {
					str = str.substr(0, 22) + "...";
				}
				tfRank.text = str;
				tfPercentRank.text = Ultility.StandardNumber(soldier.RankPoint) + 
										" / " + 
										Ultility.StandardNumber(soldier.MaxRankPoint);
				tfMeridian.text = Ultility.StandardNumber(soldier.meridianPoint);
				prgRankPoint.setStatus(soldier.RankPoint / soldier.MaxRankPoint);
			}
		}
		
		private function initCombo():void 
		{
			/* khởi tạo 2 combo */
			if (comboTime == null && comboIntensity == null)
			{
				comboTime = new ComboBoxEx(this.img, 420, 365 + YBUFF, boxTimeDataStr[0], boxTimeDataStr);
				comboTime.setEventHandler(this, COMBOTIME);
				comboTime.width -= 10;
				comboIntensity = new ComboBoxEx(this.img, 420, 398 + YBUFF, boxIntensityData[0], boxIntensityData);
				comboIntensity.width -= 10;
				comboIntensity.setEventHandler(this, COMBOINTENSITY);
			}
			
			/*update 2 combo*/
			if (_room.TimeType <= 0 && _room.IntensityType <= 0)
			{
				_room.TimeType = boxTimeDataInt[0];
				_room.IntensityType = 1;
			}
			updateCombo("time", _room.TimeType, _room.State == Room.STATE_IDLE);
			updateCombo("intensity", _room.IntensityType, _room.State == Room.STATE_IDLE);
		}
		
		private function updateCombo(comboType:String, type:int, enable:Boolean = true):void 
		{
			var combo:ComboBoxEx;
			var index:int;
			var str:String;
			var idCombo:String;
			if (comboType == "intensity")
			{
				combo = comboIntensity;
				index = type - 1;
				str = boxIntensityData[index];
				idCombo = COMBOINTENSITY;
			}
			else if (comboType == "time")
			{
				combo = comboTime;
				index = boxTimeDataInt.indexOf(type, 0);
				str = boxTimeDataStr[index];
				idCombo = COMBOTIME;
			}
			
			combo.defaultLabel = str;
			
			if (enable)
			{
				combo.setEventHandler(this, idCombo);
				combo.filters = null;
				combo.mouseEnabled = true;
				combo.keyButton.mouseEnabled = true;
				combo.keyButtonBg.img.mouseEnabled = true;
			}
			else
			{
				combo.setEventHandler(null, "");
				combo.mouseEnabled = false;
				combo.keyButtonBg.img.mouseEnabled = false;
				combo.keyButton.mouseEnabled = false;
				var elements:Array =
					[0.43, 0.43, 0.43, 0, 0,
					0.43, 0.43, 0.43, 0, 0,
					0.43, 0.43, 0.43, 0, 0,
					0, 0, 0, 1, 0];
				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
				combo.filters = [colorFilter];
			}
		}
		
		private function drawFinishFish(soldier:FishSoldier):void 
		{
			if (soldier == null) {
				return;
			}
			if (effTraining) {
				RemoveImage(effTraining);
				effTraining = null;
			}
			btnNextFish.SetVisible(false);
			btnPrevFish.SetVisible(false);
			if (effFinish == null) {
				effFinish = AddImage("", "EffFinishTraining", 370, 527 + YBUFF, true, ALIGN_CENTER_CENTER, true);
				RemoveButton(ID_BTN_MERIDIAN);
				btnMeridian = AddButton(ID_BTN_MERIDIAN, "GuiTraining_BtnMeridian", 150, 390 + YBUFF, EventHandler);
			}
			curSoldier = soldier;
			showSoldier(curSoldier);
			updateFishProperty(soldier);
			_room.SoldierId = curSoldier.Id;
			_room.LakeId = curSoldier.LakeId;
			
		}
		
		private function drawTrainingFish(soldier:FishSoldier):void {
			
			if (soldier == null) {
				return;
			}
			if (effFinish) {
				RemoveImage(effFinish);
				effFinish = null;
			}
			btnNextFish.SetVisible(false);
			btnPrevFish.SetVisible(false);
			curSoldier = soldier;
			showSoldier(curSoldier);
			updateFishProperty(soldier);
			_room.SoldierId = curSoldier.Id;
			_room.LakeId = curSoldier.LakeId;
			if (effTraining == null) {
				effTraining = AddImage("", "EffTraining" + _room.IntensityType, _room.EffPosition.x, _room.EffPosition.y + YBUFF, true, ALIGN_CENTER_CENTER, true);
				effTraining.img.mouseEnabled = false;
				
				RemoveButton(ID_BTN_MERIDIAN);
				btnMeridian = AddButton(ID_BTN_MERIDIAN, "GuiTraining_BtnMeridian", 150, 390 + YBUFF, EventHandler);
			}
		}
		private function drawFishIdleList(listIdleSoldier:Array):void 
		{
			if (effTraining != null) {
				RemoveImage(effTraining);
				effTraining = null;
			}
			if (effFinish != null) {
				RemoveImage(effFinish);
				effFinish = null;
			}

			btnMeridian.SetVisible(true);
			btnNextFish.SetVisible(true);
			btnPrevFish.SetVisible(true);
			if (listIdleSoldier.length > 0) 
			{
				curSoldier = listIdleSoldier[0] as FishSoldier;
				showSoldier(curSoldier);
			}
			else {
				btnMeridian.SetVisible(false);
				
				if (imageSoldier != null) {
					RemoveImage(imageSoldier);
				}
				curSoldier = null;
				//effTraining = AddImage("", "EffTraining", 294, 420, true, ALIGN_CENTER_CENTER, true);
			}
			
			if (curSoldier != null) {
				_room.SoldierId = curSoldier.Id;
				_room.LakeId = curSoldier.LakeId;
			}
			updateFishProperty(curSoldier);
			updateStateStartButton();
			if (listIdleSoldier.length <= 1) {
				btnNextFish.SetVisible(false);
				btnPrevFish.SetVisible(false);
			}
		}
		
		private function showSoldier(soldier:FishSoldier):void 
		{
			if (imageSoldier != null)
			{
				//imageSoldier.img.removeChild(imageSoldier.img.getChildByName("nameSoldier"));
				RemoveImage(imageSoldier);
			}
			imageSoldier = AddImage("", Fish.ItemType + curSoldier.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 
										0, 0);
			if (curSoldier.Element == 3) {
				imageSoldier.FitRect(150, 150, new Point(135, 270 + YBUFF));
			}
			else {
				imageSoldier.FitRect(150, 150, new Point(110, 270 + YBUFF));
			}
			
			UpdateFishContent(curSoldier, imageSoldier);
		}
		
		private function UpdateFishContent(curSoldier:FishSoldier, curSoldierImg:Image):void
		{
			var s:String;
			var i:int;
			
			for (s in curSoldier.EquipmentList)
			{
				for (i = 0; i < curSoldier.EquipmentList[s].length; i++)
				{
					var eq:FishEquipment = curSoldier.EquipmentList[s][i];
					ChangeEquipment(curSoldierImg, eq);
				}
			}
			
			
			var txtField:TextField = new TextField();
			//txtField.text = _fishSoldier.Name
			
			if (curSoldier.nameSoldier == null) {
				txtField.text = TrainingMgr.getInstance().getNameDefault(curSoldier.Element);
			}
			else {
				if (curSoldier.nameSoldier.length <= 0) {
					txtField.text = TrainingMgr.getInstance().getNameDefault(curSoldier.Element);
				}
				else {
					txtField.text = curSoldier.nameSoldier;
				}
			}
			
			var length:int = txtField.text.length;
			var txtFormat:TextFormat = new TextFormat("arial", 16, 0xffff00, true);
			txtField.setTextFormat(txtFormat);
			txtField.y = -60;
			txtField.x = -50;
			txtField.autoSize = TextFieldAutoSize.CENTER;
			txtField.name = "nameSoldier";
			imageSoldier.img.addChild(txtField);
		}
		
		/**
		 * Đổi vũ khí trang bị
		 * @param	Type	mũ áo
		 */
		private function ChangeEquipment(curSoldierImg:Image, equip:FishEquipment):void
		{
			var Type:String = equip.Type;
			var resName:String = equip.imageName;
			var color:int = equip.Color;
			
			if (resName == "")	return;
			
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(curSoldierImg.img, Type);
			
			if (child != null)
			{
				var index:int = child.parent.getChildIndex(child);
				var eq:FishEquipment = new FishEquipment();
				eq.loadComp = function f():void
				{
					try
					{
						var dob :DisplayObject = child.parent.addChildAt(eq.img, index);
						dob.name = Type;
						child.parent.removeChild(child);
						FishSoldier.EquipmentEffect(dob, color);
					}
					catch (e:*)
					{
						
					}
				}
				eq.loadRes(resName);
			}
		}
		
		public function updatePriceIntensity(intensityType:int):void 
		{
			var objIntensity:Object = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Intensity"];
			moneyIntensity = objIntensity[intensityType]["Money"];
			zmoneyIntensity = objIntensity[intensityType]["ZMoney"];
			diamondIntensity = 0;
			var strPriceIntensity:String;
			//xet voi combo intensity
			if (moneyIntensity >= 0 && zmoneyIntensity <= 0)
			{
				strPriceIntensity = getMoneyString(moneyIntensity);
				tfPriceIntensity.text = strPriceIntensity;
				imgGoldIntensity.img.x = tfPriceIntensity.x + tfPriceIntensity.width + 4;
				imgXuIntensity.img.x = imgGoldIntensity.img.x;
				if (moneyIntensity != 0)
				{
					imgGoldIntensity.img.visible = true;
					imgXuIntensity.img.visible = false;
					
				}
				else {
					imgGoldIntensity.img.visible = false;
					imgXuIntensity.img.visible = false;
					imgDiamondIntensity.img.visible = false;
					tfPriceDimamondIntensity.visible = false;
					chkIntensityDiamond.img.visible = uchkIntensityDiamond.img.visible =
					chkIntensityZMoney.img.visible = uchkIntensityZMoney.img.visible = false;
					priceType_intensity = "";
					_room.IntensityPayType = "Free";
				}
			}
			else if (moneyIntensity <= 0 && zmoneyIntensity >= 0)
			{
				strPriceIntensity = getMoneyString(zmoneyIntensity);
				var diamond:int = objIntensity[intensityType]["Diamond"];
				var strDiamondIntensity:String = getMoneyString(diamond);
				
				tfPriceIntensity.text = strPriceIntensity;
				tfPriceDimamondIntensity.text = strDiamondIntensity;
				
				imgGoldIntensity.img.x = tfPriceIntensity.x + tfPriceIntensity.width + 4;
				imgXuIntensity.img.x = imgGoldIntensity.img.x;
				imgDiamondIntensity.img.x = tfPriceDimamondIntensity.x + tfPriceDimamondIntensity.width + 4;
				if (zmoneyIntensity != 0)
				{
					imgGoldIntensity.img.visible = false;
					imgXuIntensity.img.visible = true;
					tfPriceDimamondIntensity.visible = true;
					imgDiamondIntensity.img.visible = true;
					switch(_room.IntensityPayType)
					{
						case "Free":
						case "ZMoney":
							chkIntensityZMoney.img.visible = uchkIntensityDiamond.img.visible = true;
							chkIntensityDiamond.img.visible = uchkIntensityZMoney.img.visible = false;
							_room.IntensityPayType = "ZMoney";
						break;
						case "Diamond":
							chkIntensityZMoney.img.visible = uchkIntensityDiamond.img.visible = false;
							chkIntensityDiamond.img.visible = uchkIntensityZMoney.img.visible = true;
							zmoneyIntensity = 0;
							diamondIntensity = diamond;
						break;
					}
				}
				else {
					imgGoldIntensity.img.visible = false;
					imgXuIntensity.img.visible = false;
					imgDiamondIntensity.img.visible = false;
					tfPriceDimamondIntensity.visible = false;
				}
			}
		}
		
		public function updatePriceTime(timeType:int):void 
		{
			var objTime:Object = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Time"];
			moneyTime = objTime[timeType]["Money"];
			zmoneyTime = objTime[timeType]["ZMoney"];
			diamondTime = 0;
			var strPriceTime:String;
			//xet voi combo time
			if (moneyTime >= 0 && zmoneyTime <= 0)
			{
				strPriceTime = getMoneyString(moneyTime);
				tfPriceTime.text = strPriceTime;
				imgGoldTime.img.x = tfPriceTime.x + tfPriceTime.width + 4;
				imgXuTime.img.x = imgGoldTime.img.x;
				if (moneyTime != 0)
				{
					imgGoldTime.img.visible = true;
					imgXuTime.img.visible = false;
					
				}
				else {
					imgGoldTime.img.visible = false;
					imgXuTime.img.visible = false;
					imgDiamondTime.img.visible = false;
					tfPriceDiamondTime.visible = false;
					chkTimeDiamond.img.visible = uchkTimeDiamond.img.visible =
					chkTimeZMoney.img.visible = uchkTimeZMoney.img.visible = false;
					priceType_time = "";
					_room.TimePayType = "Free";
				}
			}
			else if (moneyTime <= 0 && zmoneyTime >= 0)
			{
				strPriceTime = getMoneyString(zmoneyTime);
				var diamond:int = objTime[timeType]["Diamond"];
				var strDiamondTime:String = getMoneyString(diamond);
				
				tfPriceTime.text = strPriceTime;
				tfPriceDiamondTime.text = strDiamondTime;
				
				imgGoldTime.img.x = tfPriceTime.x + tfPriceTime.width + 4;
				imgXuTime.img.x = imgGoldTime.img.x;
				imgDiamondTime.img.x = tfPriceDiamondTime.x + tfPriceDiamondTime.width + 4;
				if (zmoneyTime != 0)
				{
					imgGoldTime.img.visible = false;
					imgXuTime.img.visible = true;
					imgDiamondTime.img.visible = true;
					tfPriceDiamondTime.visible = true;
					switch(_room.TimePayType)
					{
						case "Free":
						case "ZMoney":
							chkTimeZMoney.img.visible = uchkTimeDiamond.img.visible = true;
							chkTimeDiamond.img.visible = uchkTimeZMoney.img.visible = false;
							_room.TimePayType = "ZMoney";
						break;
						case "Diamond":
							chkTimeZMoney.img.visible = uchkTimeDiamond.img.visible = false;
							chkTimeDiamond.img.visible = uchkTimeZMoney.img.visible = true;
							zmoneyTime = 0;
							diamondTime = diamond;
						break;
					}
				}
				else {
					imgGoldTime.img.visible = false;
					imgXuTime.img.visible = false;
					imgDiamondTime.img.visible = false;
					tfPriceDiamondTime.visible = false;
				}
			}
		}
		
		private function getMoneyString(money:int):String
		{
			if (money <= 0)
			{
				return "Miễn phí";
			}
			else
			{
				return Ultility.StandardNumber(money);
			}
		}
		
		public function get room():Room 
		{
			return _room;
		}
		
		public function set room(value:Room):void 
		{
			_room = value;
			
			initPage();
		}
		
		public function get timePage():Number 
		{
			return _timePage;
		}
		
		public function set timePage(value:Number):void 
		{
			_timePage = value;
			if (_room.State == Room.STATE_TRAIN) {
				var timeTrain:int = _timePage - _room.StartTime;
				var cosoRank:int = int(timeTrain / deltaTimeRankPoint);
				var cosoMeri:int = int(timeTrain / deltaTimeMeridian);
				markTimeMeridian = _room.StartTime + cosoRank * deltaTimeRankPoint;
				markTimeRank = _room.StartTime + cosoMeri * deltaTimeMeridian;
			}
		}
		
		public function updateRoom(room:Room):void 
		{
			_room = room;
			initPage();
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (_room.State != Room.STATE_IDLE)
			{
				return;
			}
			var fs:FishSoldier;
			var itemFish:ItemFishSolider;
			var objIntensity:Object;
			var objTime:Object;
			switch(buttonID)
			{
				case ID_BTN_NEXT_FISH:
					//trace("next fish");
					var listIdleFish:Array = TrainingMgr.getInstance().ListIdleSoldier;
					var indexNext:int = listIdleFish.indexOf(curSoldier);
					if (indexNext == listIdleFish.length - 1) {
						indexNext = 0;
					}
					else {
						indexNext++;
					}
					curSoldier = listIdleFish[indexNext];
					showSoldier(curSoldier);

					updateFishProperty(curSoldier);
					_room.SoldierId = curSoldier.Id;
					_room.LakeId = curSoldier.LakeId;
					_room.SoldierName = curSoldier.nameSoldier;
					updateTimeToTraing();
					updateStateStartButton();
				break;
				case ID_BTN_PRE_FISH:
					listIdleFish = TrainingMgr.getInstance().ListIdleSoldier;
					var indexBack:int = listIdleFish.indexOf(curSoldier);
					if (indexBack == 0) {
						indexBack = listIdleFish.length - 1;
					}
					else {
						indexBack--;
					}
					curSoldier = listIdleFish[indexBack];
					showSoldier(curSoldier);

					updateFishProperty(curSoldier);
					_room.SoldierId = curSoldier.Id;
					_room.LakeId = curSoldier.LakeId;
					_room.SoldierName = curSoldier.nameSoldier;
					updateTimeToTraing();
					updateStateStartButton();
				break;
				
				case ID_UCHK_TIME_DIAMOND:
					objTime = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Time"];
					chkTimeDiamond.img.visible = uchkTimeZMoney.img.visible = true;
					chkTimeZMoney.img.visible = uchkTimeDiamond.img.visible = false;
					priceType_time = "Diamond";
					_room.TimePayType = "Diamond";
					zmoneyTime = 0;
					diamondTime = objTime[_room.TimeType]["Diamond"];
				break;
				case ID_UCHK_TIME_ZMONEY:
					objTime = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Time"];
					chkTimeDiamond.img.visible = uchkTimeZMoney.img.visible = false;
					chkTimeZMoney.img.visible = uchkTimeDiamond.img.visible = true;
					priceType_time = "ZMoney";
					_room.TimePayType = "ZMoney";
					diamondTime = 0;
					zmoneyTime = objTime[_room.TimeType]["ZMoney"];
				break;
				case ID_UCHK_INTENSITY_DIAMOND:
					objIntensity = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Intensity"];
					chkIntensityDiamond.img.visible = uchkIntensityZMoney.img.visible = true;
					chkIntensityZMoney.img.visible = uchkIntensityDiamond.img.visible = false;
					priceType_intensity = "Diamond";
					_room.IntensityPayType = "Diamond";
					zmoneyIntensity = 0;
					diamondIntensity = objIntensity[_room.IntensityType]["Diamond"];
				break;
				case ID_UCHK_INTENSITY_ZMONEY:
					objIntensity = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Intensity"];
					chkIntensityDiamond.img.visible = uchkIntensityZMoney.img.visible = false;
					chkIntensityZMoney.img.visible = uchkIntensityDiamond.img.visible = true;
					priceType_intensity = "ZMoney";
					_room.IntensityPayType = "ZMoney";
					diamondIntensity = 0;
					zmoneyIntensity = objIntensity[_room.IntensityType]["ZMoney"];
				break;
				
				
			}
		}
		override public function onComboboxChange(event:Event, comboboxId:String):void 
		{
			var strSelected:String;
			switch(comboboxId)
			{
				case COMBOINTENSITY:
					strSelected = comboIntensity.selectedItem;
					_room.IntensityType = boxIntensityData.indexOf(strSelected, 0) + 1;
					initGift();
					updatePriceIntensity(_room.IntensityType);
					updateStateButton();
				break;
				case COMBOTIME:
					strSelected = comboTime.selectedItem;
					var index:int = boxTimeDataStr.indexOf(strSelected);
					_room.TimeType = boxTimeDataInt[index];
					initGift();
					updatePriceTime(_room.TimeType);
					updateStateButton();
				break;
			}
		}
		
		public function updatePage(time:Number):void
		{
			UpdateStaus(time);
			if (_room.State == Room.STATE_FINISH) {
				btnSpeedUp.SetEnable();
				btnStop.SetEnable();
				updateStateButton();
				updateTimeToTraing();
				initGift();
				if (effTraining) {
					RemoveImage(effTraining);
					effTraining = null;
				}
				if (effFinish == null) {
					effFinish = AddImage("", "EffFinishTraining", 370, 527, true, ALIGN_CENTER_CENTER, true);
					RemoveButton(ID_BTN_MERIDIAN);
					btnMeridian = AddButton(ID_BTN_MERIDIAN, "GuiTraining_BtnMeridian", 150, 390 + YBUFF, EventHandler);
				}
				showSoldier(curSoldier);
			}
			else {
				//xử lý cho effect bay lên và + vào
				if (_room.State == Room.STATE_TRAIN) {
					var tickcountRank:int = time - markTimeRank;
					var tickcountMeri:int = time - markTimeMeridian;
					var plusPoint:int;
					var str:String;
					
					var posCurveSrc:Point;
					var posCurveDes:Point;
					var x:int = img.x, y:int = img.y;
					posCurveSrc = new Point(x + 322, y + 412);
					posCurveSrc = img.globalToLocal(posCurveSrc);
					
					posCurveDes = new Point(x + 604 - 32, y + 338 - 32);
					posCurveDes = img.globalToLocal(posCurveDes);
					
					var st:String;
					var txtFormat:TextFormat;
					var tmp:Sprite;
					var eff:ImgEffectFly;
					
					var multi:int = 1;
					
					//var percent:Number = 1;
					if (_room.inSeek) {
						multi *= (_room.TimeType / boxTimeDataInt[0]);
						//percent = 1;
						//prgClock.setStatus(percent);
						//prgClock.setStatus(1);
						GameLogic.getInstance().AddPrgToProcess(prgClock, 1);
					}
					else {
						//percent = tickcountMeri / deltaTimeMeridian;
					}
					//GameLogic.getInstance().AddPrgToProcess(prgClock, percent);
					//prgClock.setStatus(percent);
					
					var multi2:int = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Intensity"][_room.IntensityType.toString()]["GiftNum"];
					var multiEvent:Number = 1;
					if (TrainingMgr.getInstance().checkMultiEvent())
					{
						multiEvent = ConfigJSON.getInstance().getItemInfo("Param")["TrainingGround"]["multi"];
					}
					if (tickcountRank > deltaTimeRankPoint * multi) {
						plusPoint = boxRankPoint[_room.TimeType.toString()]["min"];
						plusPoint *= multi * multi2;
						txtFormat = new TextFormat("SansationBold", 24, 0xffffff, true);
						txtFormat.align = "left";
						st = "+" + Ultility.StandardNumber(plusPoint);
						txtFormat.color = 0x00cc00;
						tmp = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E, true);
						
						EffectMgr.getInstance().curveIcon(Constant.GUI_MIN_LAYER, "IconRankPoint",
												posCurveSrc.x, posCurveSrc.y,
												posCurveDes.x, posCurveDes.y,
												1,
												finishRank);
						function finishRank():void {
							//trace("finishCurve rank");
							eff = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
							eff.SetInfo(x + 530, y + 400, x + 530, y + 350, 4);
							if (!isFinishPlusRankPoint) {
								curRankPointGift += plusPoint;
								tfRankPoint.text = Ultility.StandardNumber(curRankPointGift);
							}
							
						}
						markTimeRank = time;
					}
					
					if (tickcountMeri > deltaTimeMeridian * multi) {
						plusPoint = boxMeridian[_room.TimeType.toString()]["min"];
						plusPoint *= multi * multi2 * multiEvent;
						txtFormat = new TextFormat("SansationBold", 24, 0xffffff, true);
						txtFormat.align = "left";
						st = "+" + Ultility.StandardNumber(plusPoint);
						txtFormat.color = 0xff0000;
						tmp = Ultility.CreateSpriteText(st, txtFormat, 6, 0x4F4D2E, true);
						
						posCurveDes = new Point(x + 514 - 32, y + 332 - 32);
						posCurveDes = img.globalToLocal(posCurveDes);
						
						EffectMgr.getInstance().curveIcon(Constant.GUI_MIN_LAYER, "IconMeridian",
															posCurveSrc.x, posCurveSrc.y,
															posCurveDes.x, posCurveDes.y,
															1,
															finishMeridian);
						function finishMeridian():void {
							//trace("finishCurve meridian");
							eff = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
							eff.SetInfo(x + 450, y + 400, x + 450, y + 350, 4);
							if (!isFinishPlusMeridian) {
								curMeriPointGift += plusPoint;
								tfMeridianPoint.text = Ultility.StandardNumber(curMeriPointGift);
							}
							
						}
						markTimeMeridian = time;
					}
				}
			}
		}
		
		public function countDeltaTime():void {
			var obj:Object;
			var gift:Object;
			var str:String;
			var arrRank:Array = [];
			var arrMeridian:Array = [];
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Time"];
			var deltaTimeRank:int;
			var deltaTimeMeri:int;
			for (str in cfg) {
				gift = cfg[str]["Gift"];
				deltaTimeRank = int(str) / gift["1"]["Num"][0] * 60;
				arrRank.push(deltaTimeRank);
				deltaTimeMeri = int(str) / gift["2"]["Num"][0] * 60;
				arrMeridian.push(deltaTimeMeri);
			}
			deltaTimeRankPoint =  Ultility.maxArr(arrRank);// Math.max(arrRank);
			deltaTimeMeridian =  Ultility.maxArr(arrMeridian);// Math.max(arrMeridian);
			var iMax:int;
			boxRankPoint = new Object();
			boxMeridian = new Object();
			for (str in cfg) {
				gift = cfg[str]["Gift"];
				//khởi tạo cho boxRankPoint
				obj = new Object();
				iMax = (gift["1"]["Num"] as Array).length - 1;
				obj["min"] = gift["1"]["Num"][0] * deltaTimeRankPoint / (int(str) * 60);
				obj["max"] = gift["1"]["Num"][iMax] * deltaTimeRankPoint / (int(str) * 60);
				boxRankPoint[str] = obj;
				//khởi tạo cho boxMeridian
				obj = new Object();
				iMax = (gift["2"]["Num"] as Array).length - 1;
				obj["min"] = gift["2"]["Num"][0] * deltaTimeRankPoint / (int(str) * 60);
				obj["max"] = gift["2"]["Num"][iMax] * deltaTimeRankPoint / (int(str) * 60);
				boxMeridian[str] = obj;
			}
		}
		
		public function receiveGift():void 
		{
			var soldier:FishSoldier = TrainingMgr.getInstance().getSoldierFromTrainingList(_room.SoldierId);
			var giftList:Array = _room.GiftList;
			for (var i:int = 0; i < giftList.length; i++) {
				var gift:GiftNormal = giftList[i] as GiftNormal;
				if (gift.ItemType == "RankPoint") {
					//soldier.RankPoint += gift.Num;
					soldier.updateRankPoint(gift.Num);
					//soldier.UpdateKillMarkPoint(gift.Num);
					/*cập nhật cho con cá ngoài hồ*/
					var gSoldierArr:Array = GameLogic.getInstance().user.FishSoldierArr;
					var len:int = gSoldierArr.length;
					for (var ii:int = 0; ii < len; ii++) {
						var gSoldier:FishSoldier = gSoldierArr[ii] as FishSoldier;
						if (gSoldier.Id == soldier.Id) {
							gSoldier.updateRankPoint(gift.Num);
							//gSoldier.UpdateKillMarkPoint(gift.Num);
							break;
						}
					}
					
				}
				else if (gift.ItemType == "Meridian")
				{
					soldier.meridianPoint += gift.Num;
				}
			}
		}
		
		public function updateProgessbarClock(curTime:Number):void 
		{
			if (_room.inSeek) {
				GameLogic.getInstance().AddPrgToProcess(prgClock, 1);
			}
			else {
				var tickcountMeri:Number = curTime - markTimeMeridian;
				var percent:Number = tickcountMeri / deltaTimeMeridian;
				GameLogic.getInstance().AddPrgToProcess(prgClock, percent);
			}
			
			//if (tickcountMeri > deltaTimeMeridian) {
				//markTimeMeridian = curTime;
			//}
		}
		
		public function updateMeridianForCurrentSoldier():void 
		{
			tfMeridian.text = Ultility.StandardNumber(curSoldier.meridianPoint);
		}
		private function getBoundStr(type:String, id:int,idGift:int):String
		{
			var arr:Array = ConfigJSON.getInstance().getItemInfo("CustomTraining")[type][id.toString()]["Gift"][idGift.toString()]["Num"];
			var multi:int = ConfigJSON.getInstance().getItemInfo("CustomTraining")["Intensity"][_room.IntensityType.toString()]["GiftNum"];
			if (TrainingMgr.getInstance().checkMultiEvent())
			{
				if (idGift != 1)
				{
					var multi1:int = ConfigJSON.getInstance().getItemInfo("Param")["TrainingGround"]["multi"];
					multi *= multi1;
				}
			}
			var obj:Object = Ultility.searchBound(arr);
			return multi*obj["min"] + " ~ " + multi*obj["max"];
		}
	}

}


















