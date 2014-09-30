package GUI.ChampionLeague.GuiLeague 
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.ChampionLeague.FakeServer.FakeConfigMgr;
	import GUI.ChampionLeague.GuiLeague.itemGui.ItemSlotGift;
	import GUI.component.BaseGUI;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	
	/**
	 * Tooltip khi di vào quà
	 * @author HiepNM2
	 */
	public class TooltipLeagueGift extends BaseGUI 
	{
		private var _listGift:Array = [];	//mảng quà sẽ có thể nhận được (lấy từ config)
		private var _listItemGift:Array = [];
		public var top:int;
		
		private var _tfTitle:TextField;
		private var _tfTip:TextField;
		
		public function TooltipLeagueGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "TooltipLeagueGift";
		}
		
		public function init(gift:Object):void 
		{
			var abGift:AbstractGift;
			var str:String;
			_listGift.splice(0, _listGift.length);
			for (str in gift["Normal"])
			{
				abGift = new GiftNormal();
				abGift.setInfo(gift["Normal"][str]);
				_listGift.push(abGift);
			}
			for (str in gift["Special"])
			{
				abGift = new GiftSpecial();
				abGift.setInfo(gift["Special"][str]);
				_listGift.push(abGift);
			}
		}
		override public function InitGUI():void 
		{
			LoadRes("GuiLeague_TooltipTheme");
			drawTip();
			drawGift();
		}
		
		private function drawTip():void 
		{
			//vẽ title
			var fm:TextFormat = new TextFormat("arial", 18);
			//fm.color = 0x016767;
			fm.color = 0xffffff;
			_tfTitle = AddLabel("Phần Thưởng TOP " + top, 104, 7,0xffffff,1,0x000000);
			_tfTitle.setTextFormat(fm);
			//vẽ dòng tip
			var strTip:String;
			if (top != 1)
			{
				strTip = "Dành cho người chơi có thứ hạng từ " + top + " đến ";
				var lstTop:Array = FakeConfigMgr.Top;
				var index:int = lstTop.indexOf(top.toString(), 0);
				var nextTop:int = int(lstTop[index - 1]) + 1;
				strTip += nextTop;
			}
			else {
				strTip = "Dành cho người chơi cao nhất";
			}
			_tfTip = AddLabel(strTip, 100, 35);
			fm = new TextFormat("arial", 12);
			fm.color = 0xffffff;
			_tfTip.setTextFormat(fm);
		}
		
		private function drawGift():void 
		{
			var col:int = Math.ceil(Number(Number(_listGift.length) / 2));
			var deltaX:int = 0;
			var x:int = 15;
			var y:int = 70;
			if (col == 3)
			{
				deltaX = 110;
			}
			else if (col == 4)
			{
				deltaX = 72;
			}
			else if (col == 2)
			{
				deltaX = 220;
			}
			deltaX = 72;
			var numSlot:int = 8;
			for (var i:int = 0; i < numSlot; i++)
			{
				var gift:AbstractGift = _listGift[i];
				if (gift != null) 
				{
					var itGift:AbstractItemGift;
					trace("gift.ClassName== " + gift.ClassName);
					if (gift.ClassName == "GiftNormal")
					{
						itGift = new ItemNormalGift(this.img, "KhungFriend", x, y);
					}
					else if (gift.ClassName == "GiftSpecial")
					{
						itGift = new ItemSpecialGift(this.img, "GuiLeague_SlotGift", x, y);
						
					}
					itGift.initData(gift, "GuiLeague_SlotGift", 60, 63, true);
					itGift.drawGift();
					if (gift.ClassName == "GiftSpecial") {
						itGift.FitRect(63, 66, new Point(x, y));
					}
					_listItemGift.push(itGift);
					
				}
				else 
				{
					AddImage("", "GuiLeague_SlotGift", x, y,true,ALIGN_LEFT_TOP);
				}
				
				//x += deltaX;
				y += 80;
				if (i % 2 == 1) {
					y = 70;
					x += deltaX;
				}
			}
			
		}
		
		override public function ClearComponent():void 
		{
			for (var i:int = 0; i < _listItemGift.length; i++)
			{
				var itGift:AbstractItemGift = _listItemGift[i];
				itGift.Destructor();
				itGift = null;
			}
			_listItemGift.splice(0, _listItemGift.length);
			super.ClearComponent();
		}
		
		
	}

}

