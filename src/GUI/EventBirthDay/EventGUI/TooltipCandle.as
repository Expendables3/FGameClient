package GUI.EventBirthDay.EventGUI 
{
	import Data.ConfigJSON;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.EventBirthDay.EventLogic.BirthdayCandleInfo;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class TooltipCandle extends BaseGUI 
	{
		// gui
		private var _tfTime:TextField;
		private var _prgTime:ProgressBar;
		private var _format:TextFormat;
		private var imgPrgBg:Image;
		// logic
		private var _candle:BirthdayCandleInfo;
		private var _timeGui:Number;
		private var hasUpdate:Boolean = false;				//có update gui hay không
		
		private function get Id():int {
			return _candle.ItemId;
		}
		public function TooltipCandle(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "TooltipCandle";
			_format = new TextFormat();
			_format.align = TextFormatAlign.CENTER;
			_format.size = 16;
		}
		override public function InitGUI():void 
		{
			LoadRes("EventBirthday_GUITooltipCandle");
			SetPos(_candle.Position.x - 540, 350);
			SetAlign(ALIGN_LEFT_BOTTOM);
			AddImage("", "EventBirthday_TxtCandle" + Id, 140, 18);
			_timeGui = GameLogic.getInstance().CurServerTime;
			initTime();
			initProgressbar();
			initBonus();
		}
		
		private function initBonus():void 
		{
			var num:int;
			/*quà thường vàng + kinh nghiệm*/
			var imExp:Image = AddImage("", "ImgEXP", 53, 141);
			imExp.SetScaleXY(1.3);
			num = _candle.Bonus[1]["Num"];
			AddLabel(Ultility.StandardNumber(num), 9, 170, 0xFFFFFF, 1, 0x000000);
			
			var imGold:Image = AddImage("", "IcGold", 132, 140);
			imGold.SetScaleXY(1.5);
			num = _candle.Bonus[2]["Num"];
			AddLabel(Ultility.StandardNumber(num), 88, 170, 0xFFFFFF, 1, 0x000000);
			
			
			var imWP:Image = AddImage("", _candle.Bonus[3]["ItemType"] + _candle.Bonus[3]["ItemId"], 216, 149);
			imWP.SetScaleXY(1.2);
			num = _candle.Bonus[3]["Num"];
			AddLabel(Ultility.StandardNumber(num), 165, 170, 0xFFFFFF, 1, 0x000000);
			var tfWP:TextField = AddLabel(ConfigJSON.getInstance().getItemInfo("BirthDayItem", _candle.Bonus[3]["ItemId"])["Name"], 
						173, 183, 0xffffff, 1, 0x000000);
			tfWP.scaleX = tfWP.scaleY = 0.8;
			
			var imKeo:Image = AddImage("", _candle.Bonus[4]["ItemType"] + _candle.Bonus[4]["ItemId"], 147, 246);
			imKeo.SetScaleXY(0.7);
			
			var objBound:Object;
			if (_candle.Bonus[4]["Num"] is Array)
			{
				objBound = Ultility.searchBound(_candle.Bonus[4]["Num"]);
				AddLabel(objBound["min"] + " ~ " + objBound["max"], 90, 268, 0xFFFFFF, 1, 0x000000);
			}
			AddLabel(ConfigJSON.getInstance().getItemInfo("BirthDayItem", _candle.Bonus[4]["ItemId"])["Name"],
						90, 285, 0xffffff, 1, 0x000000);
		}
		
		private function initTime():void 
		{
			var strTime:String = "Đợi để châm nến\n";
			if (canBurn())
			{
				hasUpdate = false;
				strTime = "Click châm nến để\nnhận thưởng";
			}
			else
			{
				hasUpdate = true;
				strTime += _candle.getRemainTime(_timeGui);
			}
			_tfTime = AddLabel(strTime, 280, 190, 0xFFFFFF, 1, 0x000000);
			_tfTime.setTextFormat(_format);
		}
		
		private function initProgressbar():void 
		{
			if (!canBurn())
			{
				imgPrgBg = AddImage("", "EventBirthday_Clock_bg", 340, 258);
				_prgTime = AddProgress("idPrgTime", "EventBirthday_PrgClock", 310, 250);
				var percent:Number = _candle.countRemain(_timeGui) / _candle.FireTime;
				_prgTime.setStatus(percent);
			}
		}
		
		public function initData(candle:BirthdayCandleInfo):void
		{
			_candle = candle;
		}
		
		public function updateGUI():void 
		{
			if (hasUpdate)
			{
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				var tickcount:Number = curTime - _timeGui;
				if (tickcount >= 1)
				{
					updateTime(curTime);
					//updateTime(_timeGui);
					_timeGui = curTime;
				}
			}
		}
		
		private function updateTime(curTime:int):void 
		{
			// update time lable
			if (_candle.canBurn(curTime) || _candle.Blowed)
			{
				_tfTime.text = "Click châm nến để\nnhận thưởng";
				_tfTime.setTextFormat(_format);
				if (imgPrgBg)
				{
					if (imgPrgBg.img)
					{
						imgPrgBg.img.visible = false;
					}
				}
				if (_prgTime)
				{
					if (_prgTime.img) {
						_prgTime.img.visible = false;
					}
				}
				hasUpdate = false;
				return;
			}
			_tfTime.text = "Đợi để châm nến\n" + _candle.getRemainTime(curTime);
			_tfTime.setTextFormat(_format);
			// update progress bar
			var percent:Number = _candle.countRemain(curTime) / _candle.FireTime;
			_prgTime.setStatus(percent);
		}
		
		private function canBurn():Boolean
		{
			return _candle.canBurn(_timeGui) || _candle.Blowed;
		}
	}

}







































