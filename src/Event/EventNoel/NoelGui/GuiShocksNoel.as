package Event.EventNoel.NoelGui 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Event.EventNoel.NoelPacket.SendReceiveShocksGift;
	import Event.Factory.FactoryLogic.EventSvc;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Image;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import GUI.GuiGetStatus.SendGetStatus;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * GUI online chăm chỉ nhận quà hàng ngày
	 * @author HiepNM2
	 */
	public class GuiShocksNoel extends GUIGetStatusAbstract 
	{
		private const CMD_CLOSE:String = "cmdClose";
		private const CMD_RECEIVE:String = "cmdReceive";
		private const CMD_REVERT:String = "cmdRevert";
		private const ID_IMG_SHOCKS:String = "idImgShocks";
		private const DAY_CONFIG:int = 14;
		private var imgShocks1:AbstractItemGift, imgShocks2:AbstractItemGift, imgShocks3:AbstractItemGift, imgShocks4:AbstractItemGift, imgShocks5:AbstractItemGift, 
					imgShocks6:AbstractItemGift, imgShocks7:AbstractItemGift, imgShocks8:AbstractItemGift, imgShocks9:AbstractItemGift, imgShocks10:AbstractItemGift, 
					imgShocks11:AbstractItemGift, imgShocks12:AbstractItemGift, imgShocks13:AbstractItemGift, imgShocks14:AbstractItemGift;
		private var imgGift1:Image, imgGift2:Image, imgGift3:Image, imgGift4:Image, imgGift5:Image, 
					imgGift6:Image, imgGift7:Image, imgGift8:Image, imgGift9:Image, imgGift10:Image, 
					imgGift11:Image, imgGift12:Image, imgGift13:Image, imgGift14:Image;
		private var imgTick1:Image, imgTick2:Image, imgTick3:Image, imgTick4:Image, imgTick5:Image, 
					imgTick6:Image, imgTick7:Image, imgTick8:Image, imgTick9:Image, imgTick10:Image, 
					imgTick11:Image, imgTick12:Image, imgTick13:Image, imgTick14:Image;
		private var imgMiss1:Image, imgMiss2:Image, imgMiss3:Image, imgMiss4:Image, imgMiss5:Image, 
					imgMiss6:Image, imgMiss7:Image, imgMiss8:Image, imgMiss9:Image, imgMiss10:Image, 
					imgMiss11:Image, imgMiss12:Image, imgMiss13:Image, imgMiss14:Image;
		private var imgReceived1:Image, imgReceived2:Image, imgReceived3:Image, imgReceived4:Image, imgReceived5:Image, 
					imgReceived6:Image, imgReceived7:Image, imgReceived8:Image, imgReceived9:Image, imgReceived10:Image, 
					imgReceived11:Image, imgReceived12:Image, imgReceived13:Image, imgReceived14:Image;
		private var btnReceive1:Button, btnReceive2:Button, btnReceive3:Button, btnReceive4:Button, btnReceive5:Button, 
					btnReceive6:Button, btnReceive7:Button, btnReceive8:Button, btnReceive9:Button, btnReceive10:Button, 
					btnReceive11:Button, btnReceive12:Button, btnReceive13:Button, btnReceive14:Button;
		private var tfPriceRevert:TextField;
		private var btnRevert1:Button;
		//logic
		private var _maxDayLogin:int;
		private var _dayIndex:int;
		private var _dayAll:int;
		private var inRevert:Boolean;
		private var inReceive:Boolean;
		private var oStatus:Object = 
		{
			"1":0, "2":0, "3":0, "4":0, "5":0, "6":0, "7":0, "8":0, "9":0, "10":0, "11":0, "12":0, "13":0, "14":0
		};
		private const listSocksPos:Object = 
		{ 
			"1": { "x":70, "y":295 }, "2": { "x":160, "y":295 }, "3": { "x":260, "y":295 }, "4": { "x":360, "y":295 }, "5": { "x":460, "y":295 }, "6": { "x":560, "y":295 }, "7": { "x":663, "y":295 }, 
			"8": { "x":70, "y":436 }, "9": { "x":160, "y":436 }, "10": { "x":260, "y":436 }, "11": { "x":360, "y":436 }, "12": { "x":460, "y":436 }, "13": { "x":560, "y":436 }, "14": { "x":663, "y":436 }
		};
		private var _listItem:Array;
		public function GuiShocksNoel(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			_imgThemeName = "GuiShocksNoel_Theme";
			_urlService = "KeepLoginService.getKeepLogin";
			_idPacket = Constant.CMD_GET_KEEP_LOGIN;
		}
		override protected function onInitGuiBeforeServer():void 
		{
			AddButton(CMD_CLOSE, "BtnThoat", 760, 20);
			drawShocks(DAY_CONFIG);
		}
		
		override protected function onInitData(data1:Object):void 
		{
			_dayIndex = data1["KeepLogin"]["NumCurrentLogin"];
			_dayAll = data1["KeepLogin"]["NumCanLogin"];
			for (var i:int = 1; i <= 14; i++)
			{
				oStatus[i] = data1["KeepLogin"]["Status"][i];
			}
			_maxDayLogin = 0;
			for (var s:String in data1["KeepLogin"]["Status"])
			{
				_maxDayLogin++;
			}
		}
		override protected function onInitGuiAfterServer():void 
		{
			updateShocks(DAY_CONFIG);
		}
		
		private function drawShocks(day:int):void 
		{
			var imgShocks:AbstractItemGift, imgGift:Image, 
				imgReceived:Image, imgTick:Image, imgMiss:Image, 
				btnReceive:Button/*, btnRevert:Button*/, 
				x:int, y:int, info:AbstractGift, obj:Object;
			_listItem = [];
			for (var i:int = 1; i <= day; i++)
			{
				x = listSocksPos[i]["x"];
				y = listSocksPos[i]["y"];
				obj = ConfigJSON.getInstance().getItemInfo("KeepLogin_Gift")[i]["Gift"]["1"];
				info = AbstractGift.createGift(obj["ItemType"]);
				info.setInfo(obj);
				imgShocks = this["imgShocks" + i] = AbstractItemGift.createItemGift(info.ItemType, this.img, "GuiShocksNoel_ImgDisc", x, y - 10,true);
				imgShocks.initData(info);
				imgShocks.setPosBuff(0, -50);
				imgShocks.setHasBackGroundColor(false);
				imgShocks.drawGift();
				
				_listItem.push(imgShocks);
				//imgShocks = this["imgShocks" + i] = AddButtonEx(ID_IMG_SHOCKS + "_" + i, "GuiShocksNoel_ImgShocks", x, y);
				imgGift = this["imgGift" + i] = AddImage("", "GuiShocksNoel_ImgGift", x - 10, y - 59, true, ALIGN_LEFT_TOP);
				imgReceived = this["imgReceived" + i] = AddImage("", "GuiShocksNoel_ImgReceived", x - 25, y - 8, true, ALIGN_LEFT_TOP);
				btnReceive = this["btnReceive" + i] = AddButton(CMD_RECEIVE + "_" + i, "GuiShocksNoel_BtnReceive", x, y + 30);
				//btnRevert = this["btnRevert" + i] = AddButton(CMD_REVERT + "_" + i, "GuiShocksNoel_BtnRevert", x - 10, y + 80);
				imgTick = this["imgTick" + i] = AddImage("", "GuiShocksNoel_ImgTick", x + 57, y - 83, true, ALIGN_LEFT_TOP);
				imgMiss = this["imgMiss" + i] = AddImage("", "GuiShocksNoel_ImgMiss", x + 60, y - 83, true, ALIGN_LEFT_TOP);
				imgReceived.img.visible = imgShocks.img.visible = btnReceive.img.visible =  
				imgGift.img.visible = imgTick.img.visible = imgMiss.img.visible =
				/*btnRevert.img.visible =*/ imgShocks.img.buttonMode = false;
			}
			btnRevert1 = AddButton(CMD_REVERT, "GuiShocksNoel_BtnRevert", 0, 0);
			btnRevert1.setTooltipText(Localization.getInstance().getString("EventNoel_TipBtnRevert"));
			tfPriceRevert = AddLabel("", 0, 0, 0xffffff, 0, 0x000000);
			btnRevert1.img.visible = tfPriceRevert.visible = false;
		}
		private function updateShocks(day:int):void 
		{
			var imgShocks:AbstractItemGift, imgGift:Image, 
					imgReceived:Image, btnReceive:Button, 
					/*btnRevert:Button, */imgTick:Image, imgMiss:Image;
			for (var i:int = 1; i <= day; i++)
			{
				imgShocks = this["imgShocks" + i];
				imgGift = this["imgGift" + i];
				imgReceived = this["imgReceived" + i];
				btnReceive = this["btnReceive" + i];
				//btnRevert = this["btnRevert" + i];
				imgTick = this["imgTick" + i];
				imgMiss = this["imgMiss" + i];
				
				imgShocks.img.visible = oStatus[i] != 2;
				imgGift.img.visible = oStatus[i] == 2 && _dayIndex >= i;
				imgReceived.img.visible = oStatus[i] == 2 && _dayIndex >= i;
				btnReceive.img.visible = _dayIndex >= i && oStatus[i] == 1;
				imgMiss.img.visible = (i > _maxDayLogin && i <= _dayAll);
				imgTick.img.visible = ((_dayIndex >= i) && (oStatus[i] == 2));
			}
			if (_maxDayLogin < _dayAll)//có nút revert
			{
				var priceRevert:int = 0;
				var priceDay:int;
				for (i = _maxDayLogin + 1; i <= _dayAll; i++)
				{
					priceDay = ConfigJSON.getInstance().getItemInfo("KeepLogin_Gift")[i]["Price"]["ZMoney"];
					priceRevert += priceDay;
				}
				//btnRevert = this["btnRevert" + _dayAll];
				btnReceive = this["btnReceive" + _dayAll];
				btnRevert1.img.x = btnReceive.img.x;
				btnRevert1.img.y = btnReceive.img.y;
				btnRevert1.ButtonID = CMD_REVERT + "_" + priceRevert;
				tfPriceRevert.x = btnReceive.img.x + 69;
				tfPriceRevert.y = btnReceive.img.y + 1;
				btnRevert1.img.visible = tfPriceRevert.visible = true;
				tfPriceRevert.text = Ultility.StandardNumber(priceRevert);
			}
			else
			{
				tfPriceRevert.visible = false;
				btnRevert1.img.visible = false;
				//btnReceive.img.visible = true;
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (inRevert || inReceive) return;
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			var day:int;
			switch(cmd)
			{
				case CMD_CLOSE:
					Hide();
					break;
				case CMD_RECEIVE:
					day = int(data[1]);
					receiveGift(day);
					break;
				case CMD_REVERT:
					//day = int(data[1]);
					var price:int = int(data[1]);
					if (Ultility.payMoney("ZMoney", price))
					{
						revertDay(day);
					}
			}
		}
		
		private function receiveGift(day:int):void 
		{
			inReceive = true;
			var pk:SendReceiveShocksGift = new SendReceiveShocksGift(day);
			Exchange.GetInstance().Send(pk);
		}
		
		public function processReceiveGift(data:Object, oldData:Object):void
		{
			var pk:SendReceiveShocksGift = oldData as SendReceiveShocksGift;
			var day:int = pk.DayIndex;
			
			EventSvc.getInstance().initGiftServer2(data,"RetBonus");
			var num:int = EventSvc.getInstance().getGiftServer().length;
			GuiMgr.getInstance().guiGiftEventNoel.setNumSlot(num);
			GuiMgr.getInstance().guiGiftEventNoel.Show(Constant.GUI_MIN_LAYER, 5);
			
			oStatus[day] = 2;
			var imgGift:Image = this["imgGift" + day];
			var imgShocks:AbstractItemGift = this["imgShocks" + day];
			var imgReceived:Image = this["imgReceived" + day];
			var btnReceive:Button = this["btnReceive" + day];
			var imgTick:Image = this["imgTick" + day];
			imgShocks.img.visible = btnReceive.img.visible = false;
			imgGift.img.visible = imgReceived.img.visible = imgTick.img.visible = true; 
			inReceive = false;
		}
		
		private function revertDay(day:int):void 
		{
			inRevert = true;
			var pk:SendGetStatus = new SendGetStatus("KeepLoginService.restoreKeepLogin", 
														Constant.CMD_REVERT_NOEL_DAY_LOGIN);
			Exchange.GetInstance().Send(pk);
			//processRevertDay();
		}
		public function processRevertDay():void
		{
			_dayIndex = _dayAll;
			for (var i:int = 1; i <= _dayAll; i++)
			{
				if (oStatus[i] != 2)
				{
					oStatus[i] = 1;
				}
			}
			_maxDayLogin = _dayAll;
			updateShocks(_dayAll);
			inRevert = false;
		}
		override public function ClearComponent():void 
		{
			if (_listItem != null)
			{
				for (var i:int = 0; i < _listItem.length; i++)
				{
					var imgShocks:AbstractItemGift = _listItem[i];
					imgShocks.Destructor();
				}
				_listItem.splice(0, _listItem.length);
			}
			super.ClearComponent();
		}
	}

}

















