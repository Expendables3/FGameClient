package GUI.Expedition.ExpeditionGui 
{
	import Data.ConfigJSON;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.Expedition.ExpeditionLogic.ExpeditionMgr;
	import GUI.GuiMgr;
	import GUI.GUIReceiveMultiGiftAbstract;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * Gui Nhận quà trong viễn chinh, gồm nhận rương viễn chinh và nhận quà sau khi xong quest.
	 * @author HiepNM2
	 */
	public class GuiReceiveGiftExpedition extends GUIReceiveMultiGiftAbstract 
	{
		static public const TRUNK:int = 1;			//3 kiểu show: phần thưởng rương viễn chinh
		static public const QUEST:int = 2;			//phần thưởng hoàn thành nhiệm vụ
		static public const CHANCE:int = 3;			//phần thưởng khí vận
		
		static public const BAD:int = 2;
		static public const LUCKY:int = 1;
		
		private var _typeShow:int = 0;
		private var _typeChance:int = 0;
		private var _wSlot:int = 75;
		private var _hSlot:int = 78;
		public function GuiReceiveGiftExpedition(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiReceiveGiftExpedition";
			ThemeName = "GuiGiftExpedition_Theme";
		}
		
		override public function initListGift():void 
		{
			var i:int;
			var allGift:Array = [];
			allGift = ExpeditionMgr.getInstance().GiftServer;
			for (i = 0; i < allGift.length; i++)
			{
				var gift:AbstractGift = allGift[i] as AbstractGift;
				addGift(gift);
			}
		}
		
		override public function addGift(gift:AbstractGift):void 
		{
			var itemGift:AbstractItemGift = AbstractItemGift.createItemGift(gift.ItemType, 
																			this.img, 
																			_guiName + "_ImgSlot", 
																			0, 0, 
																			_typeShow==CHANCE && _typeChance == LUCKY);
			itemGift.initData(gift);
			if (_typeShow==CHANCE && _typeChance == LUCKY)
			{
				itemGift.xNum = 40;
				itemGift.yNum = 125;
			}
			itemGift.drawGift();
			ListGift.addItem(ELEMENT_GIFT, itemGift, this);
		}
		
		override public function addTip():void 
		{
			var type:int;
			switch(_typeShow)
			{
				case QUEST:
					type = ExpeditionMgr.getInstance().getQuest().Type;
					AddImage("", _guiName + "_ImgTip" + type, 343, 123);
					AddImage("", "GuiExpedition_Icon" + type, 343, 206);
				break;
				case TRUNK:
					var index:int = ExpeditionMgr.getInstance().Index;
					var idTrunk:int = int(index / 12);
					var silkRoad:Array = ExpeditionMgr.getInstance().getSilkRoad();
					type = silkRoad[idTrunk * 12];
					if (index == 59)
					{
						type = 100;
					}
					AddImage("", _guiName + "_ImgTip" + type, 343, 123);
					AddImage("", "GuiExpedition_Icon" + type, 343, 206);
				break;
				case CHANCE:
					switch(_typeChance)
					{
						case BAD:
							var tfTip:TextField = AddLabel("", 252, 137, 0xffffff, 1, 0x000000);
							var bad:int = ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["Bad"];
							tfTip.text = Ultility.StandardNumber(bad);
						break;
					}
				break;
				
			}
		}
		
		override public function OnHideGUI():void 
		{
			if (_typeChance == BAD)
			{
				GuiMgr.getInstance().guiExpedition.seekBadChance();
				_typeChance = 0;
				_typeShow = 0;
				return;
			}
			if (_typeShow == TRUNK)
			{
				if (ExpeditionMgr.getInstance().isFinish())
				{
					GuiMgr.getInstance().guiExpedition.finishAll();
				}
				_typeChance = 0;
				_typeShow = 0;
				return;
			}
			_typeChance = 0;
			_typeShow = 0;
			ExpeditionMgr.getInstance().resetQuest();
			GuiMgr.getInstance().guiExpedition.goStartPage();
		}
		
		public function get TypeChance():int 
		{
			return _typeChance;
		}
		
		public function set TypeChance(value:int):void 
		{
			_typeChance = value;
		}
		
		public function set TypeShow(value:int):void 
		{
			_typeShow = value;
			if (value == TRUNK || value == QUEST)
			{
				ThemeName = "GuiGiftExpedition_Theme";
				xNext = 610;
				xPrev = 50;
				yNextPrev = 430;
				xClose = 678;
				yClose = -9;
				xReceive = 287;
				yReceive = 540;
				xListBox = 111;
				yListBox = 336;
				numCol = 5;
				_wSlot = 75;
				_hSlot = 78;
			}
			else if (value == CHANCE)
			{
				if (_typeChance == LUCKY)
				{
					ThemeName = "GuiLuckyExpedition_Theme";
					xListBox = 154;
					yListBox = 120;
					xClose = 320;
					yClose = 15;
				}
				else if (_typeChance == BAD)
				{
					ThemeName = "GuiBadExpedition_Theme";
					xClose = 320;
					yClose = 14;
				}
				xReceive = 208;
				yReceive = 312;
				_wSlot = 184;
				_hSlot = 184;
			}
		}
	}

}























