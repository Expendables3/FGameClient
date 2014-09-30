package Event.EventNoel.NoelGui 
{
	import Event.Factory.FactoryGui.GuiGiftEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiGiftEventNoel extends GuiGiftEvent 
	{
		public var typeFeed:String;
		private var _tip:String;
		private var _xtip:int;
		private var _ytip:int;
		public function GuiGiftEventNoel(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGiftEventNoel";
		}
		override public function addTip():void 
		{
			RemoveButton(ID_BTN_CLOSE);
			var tf:TextField = AddLabel("", _xtip, _ytip, 0x096791);
			var fm:TextFormat = new TextFormat("Arial", 20, 0x096791, true);
			tf.defaultTextFormat = fm;
			tf.text = _tip;
		}
		public function setNumSlot(num:int):void
		{
			switch(num)
			{
				case 1:
					ThemeName = "GuiInputCodeSuccess_Theme_Single";
					_slotName = "KhungFriend";
					xListBox = 148;
					yListBox = 127;
					xClose = 370;
					yClose = 20;
					xReceive = isFeed ? 142 : 157;
					yReceive = 255;
					_tip = "Phần thưởng";
					_xtip = 155;
					_ytip = 93;
					break;
				default:
					ThemeName = "GuiInputCodeSuccess_Theme_Multi";
					_slotName = _guiName + "_Slot1";
					numCol = 4;
					numRow = 2;
					xListBox = 95;
					yListBox = 200;
					xPrev = 38;
					xNext = 518;
					//xNext = 518;
					yNextPrev = 265;
					xClose = 530;
					yClose = 42;
					xReceive = isFeed ? 240 : 250 ;
					yReceive = 430;
					dRow = 20;			
					dCol = 20;			
					_xtip = 232;
					_ytip = 120;
					_tip = "Bạn nhận được phần thưởng";
			}
		}
		override protected function onFeedWall():void 
		{
			GuiMgr.getInstance().GuiFeedWall.ShowFeed(typeFeed);
		}
		override public function OnHideGUI():void 
		{
			/*var inHuntFish:Boolean = GuiMgr.getInstance().guiHuntFish.IsVisible;
			if (inHuntFish)
			{
				var inEffectRoundUp:Boolean = GuiMgr.getInstance().guiHuntFish.inEffectRoundUp;
				var inDataReady:Boolean = GuiMgr.getInstance().guiHuntFish.DataReady;
				if (inDataReady && !inEffectRoundUp)
				{
					GuiMgr.getInstance().guiHuntFish.initRound();
				}
			}*/
		}
	}

}





















