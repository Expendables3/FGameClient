package GUI.ItemGift 
{
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.Ultility;
	
	/**
	 * item chứa quà bình thường
	 * @author HiepNM2
	 */
	public class ItemNormalGift extends AbstractItemGift 
	{
		private const ID_IMG_GIFT:String = "idImgGift";
		private const ID_IMG_SLOT:String = "idImgSlot";
		
		private var imgGift:Image;
		private var tfNum:TextField;
		
		public function ItemNormalGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemNormalGift";
		}
		
		override public function initData(gift:AbstractGift, slotName:String = "KhungFriend",
											widthSlot:int = WSLOT, heightSlot:int = HSLOT,
											hasSlot:Boolean = false):void 
		{
			_gift = gift;
			_hasSlot = hasSlot;
			_slotName = slotName;
			wSlot = widthSlot;
			hSlot = heightSlot;
		}
		public function get Gift():GiftNormal
		{
			return _gift as GiftNormal;
		}
		
		override public function drawGift():void 
		{
			/* ảnh cái slot */
			if (_hasSlot)
			{
				var imgSlot:Image = AddImage(ID_IMG_SLOT, _slotName, 0, 0);
				imgSlot.FitRect(wSlot, hSlot, new Point(0, 0));
			}
			drawNormalGift();
		}
		
		private function drawNormalGift():void
		{
			/*b1: ảnh quà */
			var giftN:GiftNormal = _gift as GiftNormal;
			var imageName:String = giftN.getImageName();
			var loadGiftComp:Function = function f():void
			{
				positing(this.img, giftN);//b1: chỉnh lại tọa độ và kích thước của ảnh
				addingMore(giftN);//b2: add thêm gì đó
			}
			imgGift = AddImage(ID_IMG_GIFT, imageName, 0, 0, true, ALIGN_LEFT_TOP, false, loadGiftComp);
			/*b2: số lượng */
			if (_hasNum)
			{
				var num:int = giftN.Num;
				tfNum = AddLabel("x" + Ultility.StandardNumber2(num), _xNum + _dx, _yNum + _dy, 0xffffff, 1, 0x000000);
			}
			
			/*b3: tooltip*/
			if (_hasTooltipText)
			{
				var format:TextFormat = new TextFormat();
				format.align = TextFormatAlign.CENTER;
				var tip:TooltipFormat = new TooltipFormat();
				tip.text = Gift.getTooltipText();
				tip.setTextFormat(format);
				this.setTooltip(tip);
			}
		}
		
		private function addingMore(giftN:GiftNormal):void 
		{
			switch(giftN.ItemType)
			{
				case "SoulRock":
					var imageRank:Image = AddImage("", "Number_" + giftN.ItemId, 30 + _dx, 30 + _dy, true, ALIGN_LEFT_TOP);
					imageRank.img.width = 20;
					imageRank.img.height = 20;
					break;
			}
		}
		
		private function positing(img1:Sprite, giftN:GiftNormal):void 
		{
			var w:int;
			var h:int;
			var ratW:Number = Number(wSlot) / Number(WSLOT);
			var ratH:Number = Number(hSlot) / Number(HSLOT);
			if (ratW > 1 || ratH > 1)
			{
				ratW = 1;
				ratH = 1;
			}
			switch(giftN.ItemType)
			{
				case "Material":
					Ultility.fitRec(img1, wSlot, hSlot, wSlot / 2 + _dx, hSlot / 2 + _dy);
					img1.x = wSlot / 2;
					img1.y = hSlot / 2;
					break;
				case "Soldier":
					w = 0;
					h = 0;
					switch(giftN.RecipeId)
					{
						case 1:
							img1.width = 75 * ratW;
							img1.height = 64 * ratH;
							break;
						case 2:
							img1.width = 70 * ratW;
							img1.height = 67 * ratH;
							break;
						case 3:
							img1.width = 80 * ratW;
							img1.height = 55 * ratH;
							break;
						case 4:
							img1.width = 65 * ratW;
							img1.height = 61 * ratH;
							break;
						case 5:
							img1.width = 75 * ratW;
							img1.height = 70 * ratH;
							break;
						
					}
					var x:int = (wSlot - w) / 2 + _dx;
					var y:int = (hSlot - h) / 2 + _dy;
					img1.x = x;
					img1.y = y;
					break;
				default:
					Ultility.fitRec(img1, wSlot, hSlot, _dx, _dy);
			}
		}
		
		override public function transform(data:Object = null):void 
		{
			var pos:Point = new Point(30, 30);
			pos = img.localToGlobal(pos);
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER,
													"EffAnNgoc",
													null,
													pos.x, pos.y,
													false,
													false,
													null,
													function ():void 
													{ 
														onCompleteTransform(data); 
													} 
												);
		}
		
		private function onCompleteTransform(data:Object):void
		{
			for (var itm:String in data)
			{
				_gift[itm] = data[itm];
			}
			RemoveAllTexture();
			drawNormalGift();
		}
		
		private function RemoveAllTexture():void
		{
			if (tfNum)
			{
				img.removeChild(tfNum);
			}
			LabelArr.splice(0, LabelArr.length);
			tfNum = null;
			if (imgGift)
			{
				imgGift.CurPos = null;
				RemoveImage(imgGift);
			}
			
			imgGift = null;
		}
		
		override public function refreshTextNum():void 
		{
			var giftN:GiftNormal = _gift as GiftNormal;
			tfNum.text = "x" + Ultility.StandardNumber(giftN.Num);
		}
		override public function setPosBuff(dx:int, dy:int):void 
		{
			_dx = dx;
			_dy = dy;
		}
		override public function fitRect(x:int, y:int, w:int, h:int):void 
		{
			var scale:Number = 1;
			if (imgGift.img.width > w)
			{
				scale = w / imgGift.img.width;
			}
			imgGift.img.scaleX = imgGift.img.scaleY = scale;
			if (imgGift.img.height > h)
			{
				scale *= h / imgGift.img.height;
			}
			imgGift.img.scaleX = imgGift.img.scaleY = scale;
			try
			{
				imgGift.img.x = x - /*img["originalPosition"]["x"] * scale*/ + w / 2 - imgGift.img.width / 2;
				imgGift.img.y = y - /*img["originalPosition"]["y"] * scale*/ + h / 2 - imgGift.img.height / 2;
			}
			catch (e:*)
			{
				img.x = x + w / 2 - imgGift.img.width / 2;
				img.y = y + h / 2 - imgGift.img.height / 2;
			}
		}
	}

}



























