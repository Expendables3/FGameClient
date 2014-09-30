package Event.EventTeacher 
{
	import Event.Factory.FactoryGui.GuiGiftEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiGiftEventTeacher extends GuiGiftEvent 
	{
		private var _tip:String;
		private var _xtip:int;
		private var _ytip:int;
		public var typeFeed:String;
		public function GuiGiftEventTeacher(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGiftEventTeacher";
		}
		override public function addTip():void 
		{
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
					xReceive = isFeed ? 147 : 157;
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
					yNextPrev = 265;
					xClose = 530;
					yClose = 42;
					xReceive = 250;
					yReceive = 430;
					dRow = 20;			
					dCol = 20;			
					_xtip = 232;
					_ytip = 120;
					if (typeFeed == "GiftPoint")
					{
						_tip = "Bạn nhận được phần thưởng tích lũy câu cá";
					}
					else
					{
						_tip = "Bạn nhận được phần thưởng";
					}
					
			}
		}
		override protected function onFeedWall():void 
		{
			switch(typeFeed)
			{
				case "Material":
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_TEACHER_MATERIAL13);
					break;
				case "AllChest":
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_TEACHER_EQUIP4);
					break;
				case "GiftPoint":
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_TET2013_GIFT_POINT);
					break;
				case "Combo":
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_TET2013_COMBO);
					break;
			}
		}
		override public function OnHideGUI():void 
		{
			super.OnHideGUI();
			isFeed = false;
		}
	}

}