package GUI.BossServer 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.ListBox;
	import GUI.EventEuro.ItemGiftEuro;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUITooltipGiftStone extends BaseGUI 
	{
		private var data:Object;
		private var x:Number;
		private var y:Number;
		private var listGift:ListBox;
		private var title:String;
		
		public function GUITooltipGiftStone(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GuiMainBossServer_TooltipGiftBg");
			var txtFormat:TextFormat = new TextFormat("arial", 18, 0xffff00, true);
			var label:TextField = AddLabel("", img.width / 2 - 53, 10, 0xffff00, 1, 0x000000);
			txtFormat.align = "center";
			label.defaultTextFormat = txtFormat;
			label.htmlText = title;
			listGift = AddListBox(ListBox.LIST_X, 2, 4, 17);
			listGift.setPos(22, 60);
			var itemGift:ItemGiftEuro;
			var t:String;
			for (t in data)
			{
				itemGift = new ItemGiftEuro(listGift.img, "");
				itemGift.initItem(data[t]);
				listGift.addItem(t, itemGift);
			}
			x = x - img.width / 2;
			y += 10;
			if (x  + img.width> Constant.STAGE_WIDTH)
			{
				x = Constant.STAGE_WIDTH - img.width;
			}
			if (x < 0)
			{
				x = 0;
			}
			if (y + img.height > Constant.STAGE_HEIGHT)
			{
				y = y - img.height - 10;// Constant.STAGE_HEIGHT - img.height - 10;
			}
			SetPos(x, y);
		}
		
		public function showGUI(_data:Object, _x:Number, _y:Number, _title:String):void
		{
			data = _data;
			x = _x;
			y = _y;
			title = _title;
			Show();
		}
		
	}

}