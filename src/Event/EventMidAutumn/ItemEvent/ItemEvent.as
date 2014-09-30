package Event.EventMidAutumn.ItemEvent 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * Các item: bộ sưu tập:
		 * 
		 * 
		 * 
	 * nguyên liệu đốt:
		 * cuộn giấy
		 * bình xăng
		 * tên lửa
	 * chong chóng
	 * item hỗ trợ:
		 * áo giáp
		 * nam châm
		 * tăng tốc
	 * @author HiepNM2
	 */
	public class ItemEvent extends AbstractItemGift 
	{
		private const ID_IMG_SLOT:String = "idImgSlot";
		private const ID_IMG_ITEM:String = "idImgItem";
		
		private var imgItem:Image;
		private var tfNum:TextField;
		public var IsTextNum:Boolean = true;
		
		public var tooltipText:ItemTooltip = new ItemTooltip(null, "");
		public var HasTooltipText:Boolean = false;
		public function ItemEvent(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemEvent";
			xNum = -53;
			yNum = 24;
		}
		override public function initData(gift:AbstractGift, slotName:String = "", widthSlot:int = 0, heightSlot:int = 0, hasSlot:Boolean = true):void 
		{
			_gift = gift;
			_hasSlot = hasSlot;
			_slotName = slotName;
			wSlot = widthSlot;
			hSlot = heightSlot;
			if (HasTooltipText)
			{
				tooltipText.setType(gift["ItemType"], gift["ItemId"]);
			}
		}
		
		override public function drawGift():void 
		{
			/* ảnh cái slot */
			if (_hasSlot)
			{
				var imgSlot:Image = AddImage(ID_IMG_SLOT, _slotName, 0, 0);
				imgSlot.FitRect(wSlot, hSlot, new Point(0, 0));
			}
			drawItemEvent();
		}
		
		private function drawItemEvent():void 
		{
			/*b1: add ảnh của item*/
			var item:EventItemInfo = _gift as EventItemInfo;
			var imageName:String = item.getImageName();
			imgItem = AddImage(ID_IMG_ITEM, imageName, 0, 0);
			/*b2: add số lượng item*/
			if (IsTextNum)
			{
				var num:int = item.Num;
				tfNum = AddLabel("x" + Ultility.StandardNumber(num), _xNum, _yNum, 0xffffff, 1, 0x000000);
			}
			
			/*b3: tooltip thường*/
			if (!HasTooltipText)
			{
				var format:TextFormat = new TextFormat();
				format.align = TextFormatAlign.CENTER;
				var tip:TooltipFormat = new TooltipFormat();
				tip.text = item.getTooltipText();
				tip.setTextFormat(format);
				this.setTooltip(tip);
			}
			this.img.buttonMode = true;
		}
		
		public function selected():void
		{
			this.SetHighLight(0x00ff00,true,true,1);
		}
		
		public function unSelected():void
		{
			this.SetHighLight(-1);
		}
		
		override public function refreshTextNum():void 
		{
			tfNum.text = "x" + Ultility.StandardNumber((_gift as EventItemInfo).Num);
		}
		
		public function showTooltipText(isShow:Boolean=true):void
		{
			if (isShow)
			{
				tooltipText.Show();
			}
			else
			{
				tooltipText.Hide();
			}
		}
	}

}





































