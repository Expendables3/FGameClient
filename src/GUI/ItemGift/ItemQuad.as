package GUI.ItemGift 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import GUI.TrungLinhThach.GUILinhThachToolTip;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftQuad;
	import Logic.Ultility;
	/**
	 * Vẽ ra các huy hiệu
	 * @author HiepNM2
	 */
	public class ItemQuad extends AbstractItemGift 
	{
		private const widthSlot:Object = { "QWhite":81.9, "QGreen":81.9, "QYellow":84.55, "QPurple":81.9, "QVIP":81.9 };
		private const heightSlot:Object = { "QWhite":91.7, "QGreen":94.9, "QYellow":91.7, "QPurple":91.7, "QVIP":91.7 };
		public function ItemQuad(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemQuad";
		}
		override public function initData(gift:AbstractGift, slotName:String = "", widthSlot:int = WSLOT, heightSlot:int = HSLOT, hasSlot:Boolean = false):void 
		{
			_gift = gift;
			_hasSlot = hasSlot;
			_slotName = slotName;
			wSlot = 84;
			hSlot = 110;
		}
		override public function drawGift():void 
		{
			/*ve slot*/
			var loadSlotComp:Function = function():void
			{
				drawQuad();
			}
			AddImage("", "Slot" + _gift.ItemType, 0, 0, true, ALIGN_LEFT_TOP, false, loadSlotComp);
			img.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			img.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			var data:Object = new Object();
			data["Type"] = _gift.ItemType;
			data["ItemId"] = _gift.ItemId;
			data["Level"] = (_gift as GiftQuad).Level;
			data["Id"] = (_gift as GiftQuad).Id;
			data["Point"] = (_gift as GiftQuad).Point;
			GuiMgr.getInstance().guiTooltipEgg.showGUI(data, e.stageX, e.stageY);
		}
		private function onMouseOut(e:MouseEvent):void 
		{
			if (GuiMgr.getInstance().guiTooltipEgg.IsVisible)
			{
				GuiMgr.getInstance().guiTooltipEgg.Hide();
			}
		}
		private function drawQuad():void
		{
			var gift:GiftQuad = _gift as GiftQuad;
			var loadQuadComp:Function = function():void
			{
				this.img.x = (widthSlot[_gift.ItemType] - this.img.width) / 2;
				this.img.y = 20;
			}
			var imgQuad:Image = AddImage("", _gift.getImageName(), 0, 0, true, ALIGN_LEFT_TOP, false, loadQuadComp);
			/*draw level*/
			AddLabel(Ultility.StandardNumber(gift.Level), widthSlot[_gift.ItemType] / 2 - 48, 3, 0xffff00, 1, 0x000000);
		}
		override public function removeAllEvent():void 
		{
			if (img == null)
				return;
			removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			super.removeAllEvent();
			
		}
		
	}

}