package GUI.CreateEquipment 
{
	import Effect.EffectMgr;
	import flash.geom.Point;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.FishWar.FishEquipment;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemEquip extends Container 
	{
		public var itemType:String;
		private var color:int;
		public var imageEquip:Image;
		public var itemColor:int;
		public var itemLevel:int;
		public var itemElement:int;
		
		public var equip:FishEquipment;
		
		public function ItemEquip(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		public function initEquip(color:int, _itemType:String = "", _itemLevel:int = 0, _element:int = 0, percentSuccess:int = 0):void
		{
			LoadRes("");
			/*switch(color)
			{
				case 1:
					AddContainer("", "CtnEquipment", 0, 0);
					break;
				case 2:
					AddContainer("", "CtnEquipmentSpecial", 0, 0);
					break;
				case 3:
					AddContainer("", "CtnEquipmentRare", 0, 0);
					break;
				case 4:
					AddContainer("", "CtnEquipmentDivine", 0, 0);
					break;
			}*/
			AddContainer("", FishEquipment.GetBackgroundName(color), 0, 0);
			
			AddImage("", "GuiCreateEquipment_Percent_Bg", 0, 85, true, ALIGN_LEFT_TOP);
			itemColor = color;
			itemType = _itemType;
			itemLevel = _itemLevel;
			itemElement = _element;
			var equipName:String = "";
			if (itemType != "")
			{
				equipName = itemType + (itemElement * 100 + itemLevel) + "_Shop";
			}
			if (equipName != "")
			{
				imageEquip = AddImage("", equipName, 0, 0, true, ALIGN_LEFT_TOP);
				imageEquip.FitRect(70, 70, new Point(0, 0));
			}
			
			AddLabel(percentSuccess.toString() + "%", -13, 87, 0xffffff);
			equip = null;
		}
		
		public function showEffFail():void
		{
			equip = null;
			/*EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiCreateEquipment_Eff_Fail", null, CurPos.x + 392, CurPos.y + 300, false, false, null, function f():void
			{
				if (imageEquip != null && imageEquip.img != null)
				{
					imageEquip.img.visible = false;
				}
			});*/
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiCreateEquipment_Eff_Fail", null, CurPos.x + 400, CurPos.y + 300, false, false, null, hide);
		}
		
		private function hide():void
		{
			if(img != null)
			{
				img.visible = false;
			}
		}
		
		public function showEffSuccess():void
		{
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiCreateEquipment_Eff_Success", null, CurPos.x + 400, CurPos.y + 300);
		}
		
	}

}