package GUI.FirstPay 
{
	import Effect.EffectMgr;
	import GUI.GUIChooseElementAbstract;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiElementFirstPay extends GUIChooseElementAbstract 
	{
		private var _id:int;
		private var _data:Object;//chứa tập đồ cần chọn hệ
		private var _isFall:Boolean = false;
		public function GuiElementFirstPay(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiElementFirstPay";
			Type = "Element";
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function set data(value:Object):void 
		{
			_data = value;
		}
		
		override public function receiveGift(element:int):void 
		{
			var gift:AbstractGift;
			var imageName:String;
			var receiveNum:int = 0;
			var count:int = 0;
			var pk:SendGetGiftPay = new SendGetGiftPay(_id, element);
			Exchange.GetInstance().Send(pk);
			var xDes:int;
			
			for (var itm:String in _data)
			{
				count++;
				gift = _data[itm];
				if (gift.ClassName == "GiftSpecial")
				{
					(gift as GiftSpecial).Element = element;
				}
				else if (gift.ClassName == "GiftNormal")
				{
					if ((gift as GiftNormal).ItemType == "Soldier")
					{
						(gift as GiftNormal).RecipeId = element;
					}
				}
				imageName = gift.getImageName();
				xDes = 130 + 330 * Math.random();
				_isFall = true;
				EffectMgr.setEffBounceDown("Nhận Thành Công", imageName, xDes, 280, onCompFallEquip);
			}
			function onCompFallEquip():void
			{
				//GameLogic.getInstance().user.GenerateNextID();
				receiveNum++;
				if (receiveNum == count)//cho rơi hết các đồ xuống mới đóng gui
				{
					Hide();
					GuiMgr.getInstance().guiPayGift.chooseElementComp(element);
					_isFall = false;
				}
			}
		}
		
		override protected function onClose():void 
		{
			if (_isFall)
			{
				return;
			}
			GuiMgr.getInstance().guiPayGift.IsReceiveGift = false;
			super.onClose();
		}
		
		
	}

}



























