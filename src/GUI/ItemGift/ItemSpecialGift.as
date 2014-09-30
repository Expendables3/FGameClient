package GUI.ItemGift 
{
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import Logic.FishSoldier;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftSpecial;
	import Logic.Ultility;
	
	/**
	 * item chứa quà đặc biệt
	 * @author HiepNM2
	 */
	public class ItemSpecialGift extends AbstractItemGift 
	{
		private const ID_IMG_COLOR:String = "idImgColor";
		private const ID_IMG_GIFT:String = "idImgGift";
		
		/**POINTER**/
		private var imgColor:Image;
		private var imgGift:Image;
		private var imgLama:Image;
		private var imgLock:Image;
		private var tfEnchant:TextField;
		private var tfName:TextField;
		private var tfNum:TextField;
		private var _hasBackGroundColor:Boolean = true;
		
		
		public function ItemSpecialGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemSpecialGift";
			_hasTooltipText = false;
			_hasNum = false;
		}
		
		
		override public function initData(gift:AbstractGift, slotName:String = "", 
											widthSlot:int = WSLOT, heightSlot:int = HSLOT,
											hasSlot:Boolean=false):void 
		{
			_gift = gift;
			_hasSlot = hasSlot;
			_slotName = slotName;
			wSlot = widthSlot;
			hSlot = heightSlot;
		}
		public function get Gift():GiftSpecial
		{
			return _gift as GiftSpecial;
		}
		override public function drawGift():void 
		{
			var giftS:GiftSpecial = Gift;
			var x:int = int(img.width / 2 - 75 / 2);
			var y:int = int(img.height / 2 - 78 / 2);
			if (giftS.Color > 0)/*ảnh background nếu là đồ quý, đặc biệt, thần, vip*/
			{
				if (_hasBackGroundColor)
				{
					var colorImageName:String = giftS.getBackGroundName();
					imgColor = AddImage(ID_IMG_COLOR, colorImageName, 0, 0, true, ALIGN_LEFT_TOP, false,
										function():void
										{
											this.img.x = (wSlot - this.img.width) / 2 + _dx;
											this.img.y = (hSlot - this.img.height) / 2 + _dy;
										});
				}
				
			}
			/*ảnh equipment*/
			var imageName:String = giftS.getImageName();
			var loadGiftComp:Function = function f():void
			{
				if (this.img.width > 0)
				{
					positing(this.img, giftS);//b1: chỉnh lại tọa độ và kích thước của ảnh
					addingMore(this.img, giftS);//b2: add thêm gì đó
				}
			}
			imgGift = AddImage(ID_IMG_GIFT, imageName, 0, 0, true, ALIGN_LEFT_TOP, false, loadGiftComp);
			/*tooltip*/
			if (_hasTooltipImg)
			{
				if (guiTooltip == null)
				{
					guiTooltip = new TooltipSpecialGift(null, "");
					(guiTooltip as TooltipSpecialGift).wGift = img.width * img.scaleX;
					(guiTooltip as TooltipSpecialGift).hGift = img.height * img.scaleY;
					(guiTooltip as TooltipSpecialGift).initInfo(Gift);
				}
			}
			if (_hasTooltipText)
			{
				this.setTooltipText(giftS.getTooltipText());
			}
		}
		
		
		
		private function positing(img1:Sprite, giftS:GiftSpecial):void 
		{
			if (!(giftS.ItemType == "AllChest" && (giftS.Color == 6 || giftS.Color == 5)))
			{
				FishSoldier.EquipmentEffect(img1, giftS.Color);
			}
			
			if (_hasBackGroundColor)
			{
				img1.x = imgColor.img.x + (imgColor.img.width - img1.width) / 2;
				img1.y = imgColor.img.y + (imgColor.img.height - img1.height) / 2;
			}
			else
			{
				//img1.x = (wSlot - img1.width) / 2 + _dx;
				//img1.y = (hSlot - img1.height) / 2 + _dy;
				Ultility.fitRec(img1, wSlot, hSlot, _dx, _dy);
				//img1.x =  10;//hard code cho cái gui tất noel
				//img1.y =  - img1.height / 2;
			}
		}
		
		private function addingMore(img1:Sprite, giftS:GiftSpecial):void 
		{
			if (giftS.EnchantLevel > 0)
			{
				var xEnchant:int, yEnchant:int = 2;
				if (_hasBackGroundColor)
				{
					xEnchant = imgColor.img.x + 2;
				}
				else
				{
					xEnchant = img1.x;
				}
				//var xEnchant:int = _hasBackGroundColor?imgColor.img.x + 2:2;//hard code cho eventNoel
				tfEnchant = AddLabel("", xEnchant, 2, 0xFFF100, 0, 0x603813);
				var tF:TextFormat = new TextFormat("Arial", 18, 0xFFF100, true);
				tfEnchant.defaultTextFormat = tF;
				tfEnchant.text = "+" + giftS.EnchantLevel;
			}
			//Đối với cái dương thì còn thêm vào Rank là số La Mã
			if (giftS.ItemType == "EquipmentChest" || giftS.ItemType == "JewelChest"|| giftS.ItemType == "AllChest")
			{
				_hasTooltipImg = false;
				_hasTooltipText = true; 
				var xLM:int, yLM:int;
				if (_hasBackGroundColor)
				{
					xLM = imgColor.img.x + 11;
					yLM = imgColor.img.y + 65;
				}
				else
				{
					xLM = img1.x;
					yLM = img1.y + img1.height - 10;
				}
				//var xLM:int = _hasBackGroundColor?imgColor.img.x + 11:11;
				//var yLM:int = _hasBackGroundColor?imgColor.img.y + 65:27;//hard code cho tất noel
				imgLama = AddImage("", "ImgLaMa" + giftS.Rank, xLM, yLM);
				if (_hasNum)
				{
					addNum(img1.width - 10, yLM, 12, 0xffffff);
				}
			}
			else 
			{
				if (!giftS.canSell())
				{
					var xLock:int, yLock:int;
					if (_hasBackGroundColor)
					{
						xLock = imgColor.img.x + 14;
						yLock = imgColor.img.y + 64;
					}
					else
					{
						xLock = img1.x;
						yLock = img1.y - 10;
					}
					//var xLock:int = _hasBackGroundColor?imgColor.img.x + 14:14;
					//var yLock:int = _hasBackGroundColor?imgColor.img.y + 64:64;
					if (_hasLock)
					{
						imgLock = AddImage("idLock", "Lock", xLock, yLock);
					}
				}
			}
			//add chữ Max với đồ VIP MAXs
			if (Gift.Color == 6)
			{
				AddImage("", "IcMax", 50, 20);
			}
			
		}
		public function addName(x:int, y:int):void	
		{
			var giftS:GiftSpecial = _gift as GiftSpecial;
			var name:String = Localization.getInstance().getString(_gift.ItemType + (100 * giftS.Element + giftS.Rank));
			var colorName:String = giftS.getColorName();
			tfName = AddLabel(name + " " +colorName, x, y, 0xffffff, 1, 0x000000);
		}
		override public function addNum(x:int, y:int, size:int, color:int):void 
		{
			var giftS:GiftSpecial = _gift as GiftSpecial;
			var num:int = giftS.Num;
			var fm:TextFormat = new TextFormat("Arial");
			fm.size = size;
			fm.color = color;
			tfNum = AddLabel("x " + Ultility.StandardNumber(num), x, y, 0xffffff, 0, 0x000000);
			tfNum.setTextFormat(fm);
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
				//(_gift as GiftSpecial).Primitive[itm] = data[itm];
			}
			RemoveAllTexture();
			drawGift();
		}
		
		private function RemoveAllTexture():void
		{
			//giftInfo.Hide();
			if (tfName) 
			{
				img.removeChild(tfName);
			}
			if (tfNum)
			{
				img.removeChild(tfNum);
			}
			if (tfEnchant)
			{
				img.removeChild(tfEnchant);
			}
			tfName = tfNum = tfEnchant = null;
			if (imgGift)
			{
				imgGift.CurPos = null;
				RemoveImage(imgGift);
			}
			if (imgColor)
			{
				imgColor.CurPos = null;
				RemoveImage(imgColor);
			}
			if (imgLama)
			{
				imgLama.CurPos = null;
				RemoveImage(imgLama);
			}
			if (imgLock)
			{
				imgLock.CurPos = null;
				RemoveImage(imgLock);
			}
			imgGift = imgColor = 
			imgLama = imgLock = null;
		}
		
		override public function refreshTextNum():void 
		{
			var giftS:GiftSpecial = _gift as GiftSpecial;
			tfNum.text = "x " + Ultility.StandardNumber(giftS.Num);
		}
		override public function fitRect(x:int, y:int, w:int, h:int):void 
		{
			//var xImg:int = x + int(w / 2 - img.width / 2);
			//var yImg:int = y + int(h / 2 - img.height / 2);
			//SetPos(xImg, yImg);
		}
		
		override public function stretchRect(x:int, y:int, w:int, h:int):void 
		{
			SetPos(x, y);
			img.width = w;
			img.height = h;
		}
		override public function setPosBuff(dx:int, dy:int):void 
		{
			_dx = dx;
			_dy = dy;
		}
		override public function setHasBackGroundColor(val:Boolean):void 
		{
			_hasBackGroundColor = val;
		}
	}

}


























