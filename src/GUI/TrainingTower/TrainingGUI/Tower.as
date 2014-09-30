package GUI.TrainingTower.TrainingGUI 
{
	import flash.display.MovieClip;
	import GUI.component.ButtonEx;
	import GUI.component.TooltipFormat;
	import Logic.BaseObject;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class Tower extends BaseObject 
	{
		static public const STATE_FINISH:int = 2;	//có 1 phòng hoàn thành (ưu tiên hơn IDLE)
		static public const STATE_TRAIN:int = 1;	//khi tất cả các phòng đều bận
		static public const STATE_IDLE:int = 0;		// có 1 phòng rỗi
		private const GLOW_NAME:String = "Blink";
		private const NORMAL_NAME:String = "Normal";
		private var _state:int;
		private var _tooltip:TooltipFormat;
		
		public var _tower:ButtonEx;	//Reference đến nút btnTower của GuiTopInfo
		public function Tower(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "Tower";
		}
		
		public function initData(btnEx:ButtonEx):void {
			_tooltip = new TooltipFormat();
			_tower = btnEx;
		}
		
		public function get IsGlow():Boolean {
			return !(State == STATE_TRAIN);
		}
		public function set IsGlow(isGlow:Boolean):void 
		{
			if (img) 
			{
				var m:MovieClip = img.getChildAt(0) as MovieClip;
				if (isGlow) 
				{
					m.gotoAndStop(GLOW_NAME);
				}
				else 
				{
					m.gotoAndStop(NORMAL_NAME);
				}
			}
			
		}
		
		public function get State():int 
		{
			return _state;
		}
		
		public function set State(value:int):void 
		{
			_state = value;
			var strTip:String = "Chợ Trắng";
			switch(value) {
				case STATE_FINISH:
					strTip = "Có phòng luyện xong";
				break;
				case STATE_IDLE:
					strTip = "Có phòng trống";
				break;
				case STATE_TRAIN:
					strTip = "Các phòng đều đang luyện";
				break;
			}
			_tooltip.text = strTip;
			_tower.setTooltip(_tooltip);
			_tower.SetBlink(!(value == STATE_TRAIN));
		}
		
		public function drawTower():void 
		{
			ClearImage();
			LoadRes("BtnExQuest");
			IsGlow = !(State == STATE_TRAIN);
		}
		
		
	}

}





















