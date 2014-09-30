package GUI.EventBirthDay.EventGUI 
{
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import GUI.EventBirthDay.EventLogic.BirthDayItemMgr;
	import GUI.EventBirthDay.EventLogic.MagicLampItemInfo;
	import GUI.EventBirthDay.EventLogic.MagicLampMgr;
	import GUI.EventBirthDay.EventPackage.SendGetGiftMagicLamp;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.LogicGift.GiftNormal;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemMagicLamp extends Container 
	{
		static public const CMD_WISH:String = "cmdWish";
		static public const ID_PRG_WISHINGPOINT:String = "idPrgWishingpoint";
		// logic
		private var _itemWish:MagicLampItemInfo;
		private var _wishingPoint:int;
		private var isEnable:Boolean = true;
		// gui
		private var btnWish:Button;
		private var imgGift:Image;
		private var _parent:GUIMagicLamp;
		private var _guiChooseElement:GUIChooseElementBirthDay;
		//private var giftInfo:GUIEquipmentInfo = new GUIEquipmentInfo(null, "");
		//private var fishEquipment:FishEquipment = new FishEquipment();
		
		public function ItemMagicLamp(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemMagicLamp";
		}
		
		public function initData(itemWish:MagicLampItemInfo, parent:GUIMagicLamp):void 
		{
			if (_guiChooseElement == null)
			{
				_guiChooseElement = new GUIChooseElementBirthDay(null, "");
			}
			_itemWish = itemWish;
			_parent = parent;
		}
		
		public function drawItem():void 
		{
			SetPos(_itemWish.Position.x, _itemWish.Position.y);
			btnWish = AddButton(CMD_WISH + "_" + _itemWish.Id, "GuiMagicLamp_BtnWish" + _itemWish.Id, 0, 0, EventHandler);
			imgGift = AddImage("", _itemWish.ImageName, 0, 0);
			imgGift.img.buttonMode = true;

			var tip1:TooltipFormat = new TooltipFormat();
			tip1.text = _itemWish.TooltipText;
			this.setTooltip(tip1);

			
			if (_itemWish.Id != 2)
			{
				imgGift.FitRect(60, 60, new Point(15, 15));
			}
			else {
				imgGift.FitRect(60, 60, new Point(23, 26));
			}
			
			var wp:int = MagicLampMgr.getInstance().WishingPoint;
			if (wp < _itemWish.WishingPointNum)
			{
				isEnable = false;
				this.setEnable(false);
			}
			else
			{
				if (_itemWish.IsReceived)
				{
					isEnable = false;
					AddImage("", "IcComplete", 65, 77);
					var tip:TooltipFormat = new TooltipFormat();
					tip.text = "Đã nhận phần thưởng này";
					this.setTooltip(tip);
				}
				else
				{
					isEnable = true;
				}
			}
			
		}
		
		public function setEnable(isEnable:Boolean = true):void
		{
			if (!isEnable)
			{
				//img.mouseEnabled = false;
				var elements:Array =
				[0.43, 0.43, 0.43, 0, 0,
				0.43, 0.43, 0.43, 0, 0,
				0.43, 0.43, 0.43, 0, 0,
				0, 0, 0, 1, 0];

				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
				img.filters = [colorFilter];
			}
			else
			{
				img.mouseEnabled = true;
				img.filters = null;
			}
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			if (isEnable)
			{
				var GiftId:int = _itemWish.Id;
				if (_itemWish.HasSpecial)
				{
					_guiChooseElement.Type = "Element";
				}
				else
				{
					_guiChooseElement.Type = "Material";
				}
				_guiChooseElement.initData(_itemWish, _parent);
				_guiChooseElement.Show(Constant.GUI_MIN_LAYER, 6);
			}
			
		}
		/**
		 * cho rơi exp và money từ nút đèn xuống đáy hồ
		 * @param	itemWish: lấy money và exp từ đây ra.
		 */
		private function fallMoneyExp(itemWish:MagicLampItemInfo):void 
		{
			var moneyGift:GiftNormal = _itemWish.GiftObj["Money"] as GiftNormal;
			var money:int = moneyGift.Num;
			var expGift:GiftNormal = _itemWish.GiftObj["Exp"] as GiftNormal;
			var exp:int = expGift.Num;
			var pos:Point = new Point(930, 235);
			EffectMgr.getInstance().fallExpMoney(exp, money, pos, 50, 50);
		}
		
		override public function Destructor():void 
		{
			if (_guiChooseElement.img)
			{
				_guiChooseElement.Hide();
			}
			super.Destructor();
		}
		
		private function addTooltip():void
		{
			
		}
	}
}























