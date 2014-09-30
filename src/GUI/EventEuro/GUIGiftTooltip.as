package GUI.EventEuro 
{
	import flash.geom.Point;
	import flash.text.TextField;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.ListBox;
	import Logic.Ultility;
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIGiftTooltip extends BaseGUI
	{
		private var posY:Number;
		private var posX:Number;
		private var listGift:ListBox;
		
		public function GUIGiftTooltip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GuiEuroTooltip_Theme");
			// Kích thước GUI
			var sizeX:int = img.width;
			var sizeY:int = img.height;
			
			var posCenterX:int;
			var posCenterY:int;
			
			var posGui:Point = new Point();
			
			posCenterX = Main.imgRoot.stage.width / 2;
			posCenterY = Main.imgRoot.stage.height / 2;
			
			if (posX <= posCenterX) 
			{
				if (posY <= posCenterY) 
				{
					//trace(" x<, y<");
					posGui.x = posX + 40;
					posGui.y = posY - img.height/2;
				}
				else 
				{
					//trace(" x<, y>");
					posGui.x = posX+ 10;
					posGui.y = posY - img.height;
				}
			}
			else 
			{
				if (posY <= posCenterY)  
				{
					//trace(" x>, y<");
					posGui.x = posX - sizeX - 40;
					posGui.y = posY - img.height/2;;
				}
				else 
				{
					//trace(" x>, y>");
					posGui.x = posX - sizeX - 10;
					posGui.y = posY - img.height;;
				}
			}
			SetPos(posGui.x, posGui.y);
		}
		
		public function showGUI(x:Number, y:Number, gift:Object):void
		{
			posX = x;
			posY = y;
			Show();
			listGift = AddListBox(ListBox.LIST_X, 2, 4, 19, 15);
			listGift.setPos(13, 60);
			var itemGift:ItemGiftEuro;
			var s:String;
			for (s in gift)
			{
				itemGift = new ItemGiftEuro(listGift.img);
				itemGift.initItem(gift[s]);
				listGift.addItem(s, itemGift);
				
				var name:String = itemGift.getNameItem();
				var labelName:TextField = AddLabel(name, itemGift.img.x + itemGift.img.width / 2, itemGift.img.y + itemGift.img.height + 66, 0xffffff, 1, 0x000000);
				labelName.autoSize = "center";
				labelName.width = 90;
				labelName.wordWrap = true;
			}
		}
	}

}