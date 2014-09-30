package Event.EventNoel.NoelGui.ItemGui 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Event.EventNoel.NoelLogic.ItemInfo.BulletInfo;
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import flash.text.TextField;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemBullet extends ItemCollectionEvent 
	{
		private var imgGift:Image;
		private var tfNum:TextField;
		private var tfPrice:TextField;
		private var imgXu:Image;
		private var imgDisc:Image;
		private var imgArrow:Image;
		public function ItemBullet(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemBullet";
			_hasNum = true;
		}
		override public function initData(gift:AbstractGift, slotName:String = "", widthSlot:int = WSLOT, heightSlot:int = HSLOT, hasSlot:Boolean = false):void 
		{
			_gift = gift;
		}
		
		override public function drawGift():void 
		{
			var info:BulletInfo = _gift as BulletInfo;
			/*ảnh cái đĩa*/
			//imgDisc = AddImage("", "EventNoel_ImgDisc", 0, 0);
			var ptr:Container = this;
			/*mũi tên*/
			var loadComp:Function, imageName:String, xN:int, yN:int, xImg:int = 0, yImg:int = 0;
			if (ImgName == "GuiExchangeCandy_ImgSlotGift")
			{
				xN = 10; yN = 92;
				imageName = info.getBulletShopName();
				loadComp = function loadBulletShopComp():void
				{
					var wBullet:Number = this.img.width;
					var hBullet:Number = this.img.height;
					this.img.x = (ptr.img.width - wBullet) / 2;
					this.img.y = ptr.img.height - hBullet - 30;
				}
			}
			else if (ImgName == "KhungFriend")
			{
				xImg = 0; yImg = -10; xN = -50; yN = -60;
				imageName = info.getImageName();
				loadComp = function loadImgGiftComp():void
				{
					var y:int = this.img.y;
					var height:int = int(this.img.height);
					imgArrow = ptr.AddImage("", "GuiHuntFish_ImgBarSelected", 0, y - height/2, true, ALIGN_LEFT_TOP);
					imgArrow.img.visible = false;
				}
			}
			imgGift = AddImage("", imageName, xImg, yImg, true, ALIGN_LEFT_TOP, false, loadComp);
			/*số lượng*/
			if (_hasNum)
			{
				tfNum = AddLabel("", xN, yN, 0xFFFF00, 1, 0x000000);
				tfNum.text = Ultility.StandardNumber(_gift["Num"]);
				tfNum.mouseEnabled = false;
				if (ImgName == "KhungFriend")
				{
					imgXu = AddImage("", "GuiHuntFish_IcXu", 17, 10, true, ALIGN_LEFT_TOP);
					tfPrice = AddLabel("", -10, 2, 0xffffff, 0, 0x000000);
					var price:int = ConfigJSON.getInstance().getItemInfo("Noel_Bullet")[_gift.ItemType][_gift.ItemId]["ZMoney"];
					tfPrice.text = Ultility.StandardNumber(price);
				}
			}
			/*tooltip*/
			var tip:String;
			if (ImgName == "KhungFriend")
			{
				tip = _gift.getTooltipText();
			}
			else if (ImgName == "GuiExchangeCandy_ImgSlotGift")
			{
				tip = Localization.getInstance().getString("EventNoel_Shop" + _gift.ItemType + _gift.ItemId);
			}
			this.setTooltipText(_gift.getTooltipText());
		}
		
		override public function refreshTextNum():void 
		{
			tfNum.text = Ultility.StandardNumber(_gift["Num"]);
		}
		
		public function setSelected(isSelect:Boolean = true):void
		{
			imgArrow.img.visible = isSelect;
		}
		public function get ItemId():int { return _gift.ItemId; }
	}

}




















