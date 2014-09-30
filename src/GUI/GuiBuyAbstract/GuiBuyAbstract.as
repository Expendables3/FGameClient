package GUI.GuiBuyAbstract 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.User;
	import NetworkPacket.BasePacket;
	
	/**
	 * Gui mua đồ nhanh thực hiện override các hàm sau:
		* onInitGui(): 
			* chú ý các nút mua có id là CMD_BUY  + "_" + type + "_" + id + "_" + price + "_" + priceType
			* thực hiện vẽ gui các nút có tên là _guiName + tên nút
		* onUpdateAfterClickBuy();
			* thực hiện cập nhật gui sau khi ấn nút mua
	 * @author HiepNM2
	 */
	public class GuiBuyAbstract extends BaseGUI 
	{
		protected const ID_BTN_CLOSE:String = "idBtnClose";
		protected const CMD_BUY:String = "cmdBuy";
		private var _themeName:String;
		protected var _guiName:String;
		protected var _urlBuyAPI:String;
		protected var _idBuyAPI:String;
		protected var isBuyOnce:Boolean = false;
		
		public function GuiBuyAbstract(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiBuyAbstract";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				onInitGui();
				BuyItemSvc.getInstance().UrlBuyAPI = _urlBuyAPI;
				BuyItemSvc.getInstance().IdBuyAPI = _idBuyAPI;
			}
			LoadRes(_themeName);
		}
		
		protected virtual function onInitGui():void { }
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case ID_BTN_CLOSE:
					Hide();
					break;
				case CMD_BUY:
					var type:String = data[1];
					var id:int = data[2];
					var price:int = int(data[3]);
					var priceType:String = data[4];
					if (BuyItemSvc.getInstance().buyItem(type, id, priceType, price))
					{
						onUpdateAfterClickBuy(type, id);
					}
					if (isBuyOnce)
					{
						Hide();
					}
					break;
			}
		}

		
		protected virtual function onUpdateAfterClickBuy(type:String, id:int):void { }

		override public function OnHideGUI():void 
		{
			BuyItemSvc.getInstance().sendBuyAction();
		}
		
		public function updateGUI(curTime:Number):void 
		{
			BuyItemSvc.getInstance().updateTime(curTime);
		}
		
		protected function set ThemeName(value:String):void 
		{
			_themeName = value;
			var data:Array = value.split("_");
			_guiName = data[0];
		}
		
		
	}

}













