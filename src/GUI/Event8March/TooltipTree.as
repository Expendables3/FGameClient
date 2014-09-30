package GUI.Event8March 
{
	import Data.Localization;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class TooltipTree extends BaseGUI 
	{
		private var _timer:Timer;
		private var _countTime:int;
		private var labelTime:TextField;
		private var _format:TextFormat;
		private var prgTime:ProgressBar;
		private var prgLevel:ProgressBar;
		private var hasTimer:Boolean;
		private var _parent:CoralTree;
		
		public function TooltipTree(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "TooltipTree";
		}
		
		override public function InitGUI():void 
		{
			LoadRes("EventNoel_GUITooltipTree");
			//dựa vào gifts & time để vẽ ra những quà cho cây + progress bar + time
			AddImage("", "TooltipName" + _parent.Level, 160, 40);
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComp);
			if (!_parent.isUnLimitLevel)
			{
				initTime();
				initProgressBar();
			}
			else
			{
				hasTimer = false;
			}
			initBonus();
			var parentTree:Layer = _parent.Parent as Layer;
			var posTree:Point = _parent.CurPos;
			posTree = parentTree.localToGlobal(posTree)
			var widthTree:Number = this.img.width;
			SetPos(posTree.x - widthTree/2 - 120, 100);
		}
		/**
		 * @param	tree: cây mà tooltip phục vụ
		 */
		public function init(tree:CoralTree):void
		{
			_parent = tree;
		}
		private function initProgressBar():void
		{
			var cap:int = _parent.Level / 2 + 1;
			var dWidth:int = cap < 3?100:0;
			var pos:Point = new Point(320 + _parent.widthTree[cap] + dWidth, 345 - _parent.heightTree[cap] / 2);
			AddImage("", "EventNoel_Time_bg", pos.x, pos.y);
			prgLevel = AddProgress("idpgrLevel", "EventNoel_PrgTime", pos.x - 8, pos.y - 63);
			AddImage("", "EventNoel_Number" + _parent.Level, pos.x, pos.y + 50);
			prgLevel.setStatus(_parent.CareNum / _parent.MaxNumCare, false);
			if (!_parent.canCare())
			{
				AddImage("", "EventNoel_Clock_bg", 394, 362);
				prgTime = AddProgress("idprgTime", "EventNoel_PrgClock", 364, 354);
				var percent:Number;
				if (_parent.hasSeek)
				{
					percent = 1;
				}
				else
				{
					var curTime:Number = GameLogic.getInstance().CurServerTime;
					var remainTime:Number = curTime - _parent.LastCareTime;
					percent = remainTime / _parent.MaxTimeCare;
				}
				prgTime.setStatus(percent);
			}
			
			
		}
		private function initBonus():void
		{
			var imgFlower:Image;
			var num:int;
			/*quà thường vàng + kinh nghiệm*/
			var imExp:Image = AddImage("", "ImgEXP", 100, 138);
			imExp.SetScaleXY(1.2);
			num = _parent.Bonus[2]["Num"];
			AddLabel(Ultility.StandardNumber(num), 55, 162, 0xFFFFFF, 1, 0x000000);
			
			var imGold:Image = AddImage("", "IcGold", 198, 136);
			imGold.SetScaleXY(1.5);
			num = _parent.Bonus[1]["Num"];
			AddLabel(Ultility.StandardNumber(num), 155, 162, 0xFFFFFF, 1, 0x000000);
			
			/*quà đặc biệt 3 loại hoa*/
			var x:int = 70, y:int = 255;
			var objBound:Object;
			for (var i:int = 1; i <= 3; i++)
			{
				//ảnh
				objBound = new Object();
				imgFlower = AddImage("",  "EventNoel_" + _parent.FlowerBonus[i]["ItemType"] + _parent.FlowerBonus[i]["ItemId"], x, y);		//ảnh
				imgFlower.FitRect(60, 60, new Point(x - 30, y - 35));
				//tên
				var name:String = Localization.getInstance().getString(_parent.FlowerBonus[i]["ItemType"] + "_2Name" + _parent.FlowerBonus[i]["ItemId"]);
				AddLabel(name, x - 50, y + 35, 0x315068, 1, 0xffffff);
				//số lượng
				if(_parent.FlowerBonus[i]["Num"] is Array)
					objBound = searchBound(_parent.FlowerBonus[i]["Num"]);
				else
				{
					objBound["min"] = 0;
					objBound["max"] = _parent.FlowerBonus[i]["Num"];
				}
				//num = _parent.FlowerBonus[i]["Num"];
				AddLabel(objBound["min"] + " ~ " + objBound["max"], x - 50, y + 20, 0xFFFFFF, 1, 0x000000);
				x += 85;
			}
		}
		/**
		 * thêm vào thời gian đếm ngược chạy trên đầu cây hoa
		 */
		private function initTime():void
		{
			_format = new TextFormat();
			_format.align = "center";
			_format.size = 16;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:Number = curTime - _parent.LastCareTime;
			var strTime:String = "Đợi để chăm sóc\n";
			
			if (remainTime >= _parent.MaxTimeCare || _parent.hasSeek)
			{
				hasTimer = false;
				strTime = "Tưới nước để thu hoạch";
			}
			else
			{
				hasTimer = true;
				_countTime = (int)(_parent.MaxTimeCare- remainTime);
				strTime += convertToTime(_countTime);
				_timer.addEventListener(TimerEvent.TIMER, onTimer);
				_timer.start();
			}
			var cap:int = _parent.Level / 2 + 1;
			labelTime = AddLabel(strTime, 350, 335 - _parent.heightTree[cap], 0xFFFFFF, 1, 0x000000);
			labelTime.setTextFormat(_format);
		}
		private function onTimer(event:TimerEvent):void
		{
			_countTime--;
			labelTime.text = "Đợi để chăm sóc\n" + convertToTime(_countTime);
			labelTime.setTextFormat(_format);
		}
		private function onTimerComp(event:TimerEvent):void
		{
			_timer.stop();
			if (hasTimer)
			{
				_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			}
			_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onTimerComp);
		}
		override public function Hide():void 
		{
			_timer.dispatchEvent(new TimerEvent(TimerEvent.TIMER_COMPLETE));
			super.Hide();
		}
		private function convertToTime(time:int):String
		{
			if (time <= 0) 
				return "00:00:00";
			var h:int = time / 3600;
			var dH:int = time % 3600;
			var m:int = dH / 60;
			var dM:int = dH % 60;
			var s:int = dM;
			var sh:String = (h < 10)?"0" + h:h.toString();
			var sm:String = (m < 10)?"0" + m:m.toString();
			var ss:String = (s < 10)?"0" + s:s.toString();
			return sh + ":" + sm + ":" + ss;
		}
		private function searchBound(arr:Array):Object
		{
			var min:int  = 10000;
			var max:int = -1;
			var len:int = arr.length;
			for (var i:int = 0; i < len; i++)
			{
				if (min > arr[i])
				{
					min = arr[i];
				}
				if (arr[i] > max)
				{
					max = arr[i];
				}
			}
			var obj:Object = new Object();
			obj["min"] = min;
			obj["max"] = max;
			return obj;
		}
	}
}