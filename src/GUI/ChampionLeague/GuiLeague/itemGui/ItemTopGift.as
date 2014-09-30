package GUI.ChampionLeague.GuiLeague.itemGui 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	import GUI.ChampionLeague.FakeServer.FakeConfigMgr;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import Logic.Ultility;
	
	/**
	 * Thể hiện 1 item quà trong top
	 * @author HiepNM2
	 */
	public class ItemTopGift extends Container 
	{
		
		// const
		static public const ID_BTN_GIFT:String = "idBtnGift";
		// logic
		private var _top:int;
		private var isOver:Boolean = false;
		private var _posTooltip:Point;
		// gui
		private var _background:Image;
		private var _imgGift:ButtonEx;
		private var _tfTop:TextField;
		private var _tooltipGift:TooltipLeagueGift = new TooltipLeagueGift(null, "");
		private var _timer:Timer;
		
		public function ItemTopGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "ItemRankGift";
			_timer = new Timer(4000);
		}
		
		public function get top():int 
		{
			return _top;
		}
		
		public function set top(value:int):void 
		{
			_top = value;
			_tooltipGift.top = value;
			drawItem();
		}
		
		private function drawItem():void 
		{
			trace("drawItem() Top " + _top);
			//_background = AddImage("", "GuiLeague_CtnGift", 0, 0);
			_imgGift = AddButtonEx(ID_BTN_GIFT, "GuiLeague_TrunkTop" + _top, 10, 5);
			_imgGift.img.buttonMode = false;
			_tfTop = AddLabel("Top " + _top, -40, 30, 0xffff00, 1, 0x000000);
			var gift:Object = new Object();// = FakeConfigMgr.getInstance().GiftTop[_top.toString()];
			//var gift:Object  = FakeConfigMgr.getInstance().GiftTop[_top.toString()];
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("Occupy_Gifts")["Top"][_top.toString()];
			gift["Normal"] = new Object();
			gift["Special"] = new Object();
			var indexNormal:int = 0;
			var indexSpecial:int = 0;
			for (var i:String in cfg)
			{
				if (Ultility.categoriesGift(cfg[i]["ItemType"]) == 0)
				{
					indexNormal++;
					gift["Normal"][indexNormal] = cfg[i];
				}
				else if (Ultility.categoriesGift(cfg[i]["ItemType"]) == 1)
				{
					indexSpecial++;
					gift["Special"][indexSpecial] = cfg[i];
				}
			}
			_tooltipGift.init(gift);
			_timer.addEventListener(TimerEvent.TIMER, onTimeForHideTooltip);
		}
		
		private function onTimeForHideTooltip(e:TimerEvent):void 
		{
			if (_tooltipGift)
			{
				if (_tooltipGift.IsVisible)
				{
					_tooltipGift.Hide();
					isOver = false;
				}
			}
			_timer.stop();
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID) {
				case ID_BTN_GIFT:
					if (!isOver)//nếu chưa được move qua, thì cho move qua và ko hiện tooltip nữa
					{
						isOver = true;
						_tooltipGift.Show();
						_timer.start();
						_tooltipGift.SetPos(_posTooltip.x, _posTooltip.y);
					}
					
				break;
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID) {
				case ID_BTN_GIFT:
					_tooltipGift.Hide();
					isOver = false;
					trace("buttonId = " + buttonID);
				break;
			}
		}
		
		override public function Destructor():void 
		{
			if (_tooltipGift)
			{
				if (_tooltipGift.img)
				{
					if (_tooltipGift.img.visible)
					{
						_tooltipGift.Hide();
					}
				}
				_tooltipGift.Destructor();
				_tooltipGift = null;
			}
			super.Destructor();
		}
		/**
		 * xác định vị trí của tooltip dựa vào RockIndex
		 */
		public function set RockIndex(value:int):void 
		{
			_posTooltip = new Point(0, 0);
			switch(value) {
				case 1:
					_posTooltip.x = 240;
					_posTooltip.y = 270;
				break;
				case 2:
					_posTooltip.x = 340;
					_posTooltip.y = 270;
				break;
				case 3:
					_posTooltip.x = 440;
					_posTooltip.y = 270;
				break;
				case 4:
					_posTooltip.x = 500;
					_posTooltip.y = 270;
				break;
				case 5:
					_posTooltip.x = 283;
					_posTooltip.y = 178;
				break;
				case 6:
					_posTooltip.x = 370;
					_posTooltip.y = 170;
				break;
				case 7:
					_posTooltip.x = 370;
					_posTooltip.y = 170;
				break;
				case 8:
					_posTooltip.x = 370;
					_posTooltip.y = 170;
				break;
				case 9:
					_posTooltip.x = 370;
					_posTooltip.y = 170;
				break;
				case 10:
					_posTooltip.x = 370;
					_posTooltip.y = 170;
				break;
				case 11:
					_posTooltip.x = 370;
					_posTooltip.y = 170;
				break;
				case 12:
					_posTooltip.x = 370;
					_posTooltip.y = 170;
				break;
				case 13:
					_posTooltip.x = 370;
					_posTooltip.y = 170;
				break;
				
				default:
					_posTooltip.x = 0;
					_posTooltip.y = 0;
			}
			
		}
	}

}

















