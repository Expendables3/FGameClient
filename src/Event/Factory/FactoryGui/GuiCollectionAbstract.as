package Event.Factory.FactoryGui 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import Event.Factory.FactoryLogic.EventSvc;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.GuiBuyAbstract.BuyItemSvc;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiCollectionAbstract extends BaseGUI
	{
		protected const ID_BTN_CLOSE:String = "idBtnClose";
		protected const CMD_BUY:String = "cmdBuy";
		protected const CMD_CHANGE:String = "cmdChange";
		protected const CMD_CHANGE_ALL:String = "cmdChangeAll";
		
		private var _themeName:String;
		protected var IsChangeComp:Boolean = true;
		protected var IsPressChangeEnable:Boolean = true;
		protected var _guiName:String;
		protected var _urlBuyAPI:String;
		protected var _idBuyAPI:String;
		
		protected var _oItemEvent:Object;
		protected var inReceiveGift:Boolean;
		
		protected var btnChange1:Button;//tạm thời cho tối đa 3 nút đổi quà (thế là đủ)
		protected var btnChange2:Button;
		protected var btnChange3:Button;
		protected var btnChangeAll1:Button;
		protected var btnChangeAll2:Button;
		protected var btnChangeAll3:Button;
		
		public function GuiCollectionAbstract(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiCollectionAbstract";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				if (GuiMgr.getInstance().GuiStore.IsVisible)
				{
					GuiMgr.getInstance().GuiStore.Hide();
				}
				GameLogic.getInstance().BackToIdleGameState();
				onInitGui();
				BuyItemSvc.getInstance().UrlBuyAPI = _urlBuyAPI;
				BuyItemSvc.getInstance().IdBuyAPI = _idBuyAPI;
				OpenRoomOut();
			}
			LoadRes(_themeName);
		}
		
		protected virtual function onInitGui():void { }
		protected virtual function receiveGiftComp(data:Object,oldData:Object=null):void { }
		
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (!EventSvc.getInstance().checkInEvent())
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Hết thời gian diễn ra event", 310, 200, 1);
				Hide();
				return;
			}
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			var id:int;
			var type:String;
			switch(cmd)
			{
				case ID_BTN_CLOSE:
					if (inReceiveGift) return;
					Hide();
					break;
				case CMD_BUY:
					//if (inReceiveGift) return;
					type = data[1];
					id = data[2];
					var price:int = int(data[3]);
					var priceType:String = data[4];
					if (BuyItemSvc.getInstance().buyItem(type, id, priceType, price))
					{
						EventSvc.getInstance().updateItem(type, id, 1);
						refreshAllTextNum();
						EffectMgr.setEffBounceDown("Mua thành công", "EventNoel_" + type + id, 330, 280);
					}
					break;
				case CMD_CHANGE:
					if (inReceiveGift) return;
					if (IsPressChangeEnable)
					{
						BuyItemSvc.getInstance().sendBuyAction();
						type = data[1];
						id = data[2];
						changeGift(type, id);
						IsPressChangeEnable = false;
					}
					
					break;
				case CMD_CHANGE_ALL:
					if (inReceiveGift) return;
					if (IsPressChangeEnable)
					{
						BuyItemSvc.getInstance().sendBuyAction();
						type = data[1];
						id = data[2];
						changeAllGift(type, id);
						IsPressChangeEnable = false;
					}
					break;
			}
		}
		
		protected virtual function changeAllGift(type:String, id:int):void 
		{
			inReceiveGift = true;
		}
		
		protected virtual function changeGift(type:String, id:int):void 
		{ 
			inReceiveGift = true;
		}
		/**
		 * xử lý nhận thưởng
		 * @param	data
		 */
		public function processReceiveGift(data:Object,oldData:Object=null):void 
		{
			receiveGiftComp(data,oldData);
		}
		
		protected function refreshAllTextNum():void
		{
			var idRow:String,idItem:String,item:ItemCollectionEvent, isEnable:Boolean, isOk:Boolean;
			if (_oItemEvent)
			{
				for (idRow in _oItemEvent)
				{
					isEnable = true;
					for (idItem in _oItemEvent[idRow])
					{
						item = _oItemEvent[idRow][idItem];
						isOk = item.refreshTextNumEvent();
						isEnable &&= isOk;
					}
					(this["btnChange" + idRow] as Button).SetEnable(isEnable);
					//(this["btnChangeAll" + idRow] as Button).SetEnable(isEnable);
				}
			}
		}
		
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
		
		override public function ClearComponent():void 
		{
			var idRow:String,idItem:String,item:ItemCollectionEvent;
			if (_oItemEvent)
			{
				for (idRow in _oItemEvent)
				{
					for (idItem in _oItemEvent[idRow])
					{
						item = _oItemEvent[idRow][idItem];
						item.Destructor();
						_oItemEvent[idRow][idItem] = null;
					}
					_oItemEvent[idRow] = null;
				}
			}
			_oItemEvent = null;
			super.ClearComponent();
		}
		
		protected function effText(img1:Sprite, dx1:int, dy1:int, dx2:int,dy2:int,asign:String = "+", num:int = 1):void
		{
			var str:String = asign + Ultility.StandardNumber(num);
			var posStart:Point = new Point(img1.x + dx1, img1.y + dy1);
			posStart  = img.localToGlobal(posStart);
			var posEnd:Point = new Point(img1.x + dx2, img1.y + dy2);
			posEnd = img.localToGlobal(posEnd);
			var fm:TextFormat = new TextFormat("Arial", 16);
			fm.align = "center";
			fm.bold = true;
			if (asign == "-")
			{
				fm.color = 0xff0000;
			}
			else
			{
				fm.color = 0xffff00;
			}
			Ultility.ShowEffText(str, null, posStart, posEnd, fm);
		}
	}

}





















