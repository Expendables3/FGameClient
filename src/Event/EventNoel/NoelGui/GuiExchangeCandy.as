package Event.EventNoel.NoelGui 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Event.EventNoel.NoelGui.ItemGui.ItemCandy;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import Event.EventTeacher.EffOpenBox;
	import Event.EventTeacher.ItemTeacherEvent;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Factory.FactoryGui.GuiCollectionAbstract;
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import Event.Factory.FactoryLogic.EventUtils;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	import Event.Factory.FactoryPacket.SendExchangeGift;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.GuiBuyAbstract.BuyItemSvc;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * GUI chế tạo đạn kẹo
		* bấm để chế tạo các loại đạn
		* Link sang GuiGotoHunt.
	 * @author HiepNM2
	 */
	public class GuiExchangeCandy extends GuiCollectionAbstract 
	{
		private const CMD_BUY_ALL:String = "cmdBuyAll";
		private const CMD_GO_HUNT:String = "cmdGoHunt";
		private const ID_BTN_GUIDE:String = "idBtnGuide";
		private const CMD_CB_CHANGEALL:String = "cmdCbChangeAll";
		private const POSDESX:int = 413;
		
		private var imgGiftBox:ButtonEx;
		private var btnHunt:Button;
		private var _listBullet:Array = [];
		private var listPosCandy:Object = {
											"1": { "x":77, "y":100 },
											"2": { "x":181, "y":100 },
											"3": { "x":77, "y":234 },
											"4": { "x":181, "y":234 },
											"5": { "x":126, "y":367 }
										};
		private var listPosBullet:Object = {
											"1": { "x":341, "y":340 },
											"2": { "x":472, "y":340 },
											"3": { "x":604, "y":340 }
										};
		private var checkboxChangeAll:Button;//check box để đổi tất cả
		private var isChangeAll:Boolean;
		public function GuiExchangeCandy(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiExchangeCandy";
			_urlBuyAPI = "EventService.buyCandy";
			_idBuyAPI = "";
			ThemeName = "GuiExchangeCandy_Theme";
		}
		
		override protected function onInitGui():void 
		{
			var numRow:int = EventSvc.getInstance().NumRow;
			var oRequired:Object = EventSvc.getInstance().getListRequire();
			var x:int, y:int, isEnable:Boolean = true, price:int, i:int, idItem:String;
			var btnChange:Button, tfPrice:TextField, item:ItemCollectionEvent, info:ItemCollectionInfo;
			var fm:TextFormat;
			if (Ultility.IsOtherDay(EventSvc.getInstance().logTime, GameLogic.getInstance().CurServerTime))
			{
				//trace("xử lý với việc qua ngày");
			}
			EventSvc.getInstance().logTime = GameLogic.getInstance().CurServerTime;
			AddButton(ID_BTN_CLOSE, "BtnThoat", 760, 20);
			//AddButton(ID_BTN_GUIDE, "GuiExchangeCandy_BtnGuide", 720, 20);
			/*vẽ phần collection*/
			_oItemEvent = new Object();
			for (i = 1; i <= numRow; i++)
			{
				_oItemEvent[i] = new Object();
				isEnable = true;
				for (idItem in oRequired[i])
				{
					x = listPosCandy[idItem]["x"];
					y = listPosCandy[idItem]["y"];
					info = EventSvc.getInstance().getItemInfo("Candy", int(idItem));
					item = ItemCollectionEvent.createItemEvent(info.ItemType,
																this.img, 
																"GuiExchangeCandy_ImgSlot", 
																x, y);
					item.initData(info);
					(item as ItemCandy).maxNum = oRequired[i][idItem];
					item.drawGift();
					_oItemEvent[i][idItem] = item;
					price = EventSvc.getInstance().getPrice(info.ItemType, info.ItemId, "ZMoney");
					AddButton(CMD_BUY + "_" + info.ItemType + "_" + info.ItemId + "_" + price + "_ZMoney",
								"GuiExchangeCandy_BtnBuyZMoney", x + 20, y + 107);
					tfPrice = AddLabel("", x - 10, y + 107, 0xffffff, 1, 0x000000);
					tfPrice.text = Ultility.StandardNumber(price);
					tfPrice.mouseEnabled = false;
					isEnable &&= (info.Num >= oRequired[i][idItem]);
				}
				AddImage("", "GuiExchangeCandy_ImgDisc", 544, 241, true, ALIGN_LEFT_TOP);
				imgGiftBox = AddButtonEx("", "GuiExchangeCandy_ImgBox", 590, 235);
				imgGiftBox.img.buttonMode = false;
				imgGiftBox.setTooltipText(Localization.getInstance().getString("EventNoel_TipBulletBox"));
				this["btnChange" + i] = AddButton(CMD_CHANGE + "_Candy_" + i, 
								"GuiExchangeCandy_BtnChange", 
								325, 187);//nút đổi
				btnChange = this["btnChange" + i];
				btnChange.SetEnable(isEnable);
				isChangeAll = false;
				checkboxChangeAll = AddButton(CMD_CB_CHANGEALL, "EventNoel_CheckBox" + isChangeAll, 344, 264);
				checkboxChangeAll.setTooltipText(Localization.getInstance().getString("EventNoel_TipCheckBox" + isChangeAll));
				var tfChangeAll:TextField = AddLabel("", 370, 264, 0x30587B, 0);
				fm = new TextFormat("Arial", 14, 0x30587B, true, true);
				tfChangeAll.defaultTextFormat = fm;
				tfChangeAll.text = Localization.getInstance().getString("EventNoel_TipCheckBox");
				AddButton(CMD_BUY_ALL, "GuiExchangeCandy_BtnBuyAll", 112, 504);
				tfPrice = AddLabel("", 145, 504, 0xffffff, 1, 0x000000);
				price = ConfigJSON.getInstance().getItemInfo("Noel_Candy")["Package"]["1"]["ZMoney"];
				tfPrice.text = Ultility.StandardNumber(price);
				tfPrice.mouseEnabled = false;
			}
			var tfStore:TextField = AddLabel("", 336, 287, 0x30587B, 0);
			fm = new TextFormat("Arial", 18, 0x30587B, true, true);
			tfStore.defaultTextFormat = fm;
			tfStore.text = "Kho đạn:";
			/*vẽ phần đạn*/
			_listBullet = [];
			for (i = 1; i <= 3; i++)
			{
				x = listPosBullet[i]["x"];
				y = listPosBullet[i]["y"];
				info = EventSvc.getInstance().getItemInfo("Bullet", i);
				item = ItemCollectionEvent.createItemEvent(info.ItemType, this.img,
														"GuiExchangeCandy_ImgSlotGift", 
														x, y);
				item.initData(info);
				item.drawGift();
				_listBullet.push(item);
			}
			
			btnHunt = AddButton(CMD_GO_HUNT, "GuiExchangeCandy_BtnHuntFish", 420, 486);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case CMD_BUY_ALL:
					var price:int = ConfigJSON.getInstance().getItemInfo("Noel_Candy")["Package"]["1"]["ZMoney"];
					if (BuyItemSvc.getInstance().buyItem("Package", 1, "ZMoney", price))
					{
						buyAllItem(1);
						refreshAllTextNum();
					}
					break;
				case CMD_GO_HUNT:
					if (inReceiveGift) return;
					EventNoelMgr.getInstance().processGotoHunt();
					Hide();
					break;
				case CMD_CB_CHANGEALL:
					isChangeAll = !isChangeAll;
					RemoveButton(CMD_CB_CHANGEALL);
					checkboxChangeAll = AddButton(CMD_CB_CHANGEALL, "EventNoel_CheckBox" + isChangeAll, 344, 264);
					checkboxChangeAll.setTooltipText(Localization.getInstance().getString("EventNoel_TipCheckBox" + isChangeAll))
					break;
			}
		}
		
		private function buyAllItem(idRow:int):void 
		{
			var num:int;
			var item:ItemCollectionEvent;
			for (var idItem:String in _oItemEvent[idRow])
			{
				item = _oItemEvent[idRow][idItem];
				num = EventSvc.getInstance().getRequired(idRow, int(idItem));
				EventSvc.getInstance().updateItem("Candy", int(idItem), num);
				/*Cho chữ bay lên*/
				effText(item.img, 25, 105, 25, 95, "+", num);
			}
		}
		
		/**
		 * nhận các viên đạn (thường, nổ , trùm)
		 * @param	data : dữ liệu nhận về
		 */
		override protected function receiveGiftComp(data:Object, oldData:Object = null):void  
		{
			var x:int = imgGiftBox.img.x + img.x - 43;
			var y:int = imgGiftBox.img.y + img.y - 53;
			var name:String;
			var i:String;
			var count:int = 0;
			var length:int = 0;
			var listSum:Array = [0, 0, 0];
			var listNum:Array = [0, 0, 0];
			for (i in data)
			{
				listNum[data[i]["ItemId"] - 1] = data[i]["Num"];
			}
			var oData:Object = EventSvc.getInstance().splitData(data);
			for (i in oData)
			{
				length++;
			}
			var posDesX:int, posDesY:int = 500;//tọa độ x, y của điểm bay vào
			
			imgGiftBox.SetVisible(false);
			var temp:ItemCollectionEvent;
			var effOpenBox:EffOpenBox = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiExchangeCandy_EffOpenBox", null, x, y, false, false, null, effOpenComp) as EffOpenBox;
			function effOpenComp():void
			{
				imgGiftBox.SetVisible(true);
				IsPressChangeEnable = true;
			}
			effOpenBox.funcJoin = function():void//hàm bắt đầu join vào frame
			{
				var fComp:Function = function flyComp(num:int, index:int):void
				{
					/*cho chữ bay lên*/
					temp = _listBullet[index - 1];
					listSum[index - 1] += num;
					var num1:int = listNum[index - 1];
					var num2:int = listSum[index - 1];
					if (listSum[index - 1] == listNum[index - 1])
					{
						effText(temp.img, 35, 105, 35, 95, "+", listNum[index - 1]);
						temp.refreshTextNum();
					}
					count++;
					if (count == length)
					{
						inReceiveGift = false;
					}
				}
				for (i in oData)
				{
					EventSvc.getInstance().updateItem(oData[i]["ItemType"], oData[i]["ItemId"], oData[i]["Num"]);
					posDesX = POSDESX + (oData[i]["ItemId"] - 1) * 130;
					name = "EventNoel_" + oData[i]["ItemType"] + oData[i]["ItemId"];
					EventUtils.effFallFly("EventNoel", Constant.GUI_MIN_LAYER, name, x, y, 310, posDesX, posDesY, fComp, oData[i]["Num"], oData[i]["ItemId"]);
				}
			}
		}
		
		override protected function changeGift(type:String, id:int):void 
		{
			var num:int = isChangeAll ? EventSvc.getInstance().getMinNum(1) : 1;
			var pk:SendExchangeGift = SendExchangeGift.createPacketExchagne(type, id, "Make", num);
			Exchange.GetInstance().Send(pk);
			EventSvc.getInstance().changeGift(type, id, num);
			var oRequired:Object = EventSvc.getInstance().getListRequire()["1"];
			for (var i:String in oRequired)
			{
				var numRequire:int = oRequired[i];
				var item:ItemCollectionEvent = _oItemEvent["1"][i];
				effText(item.img, 25, 105, 25, 85, "-", numRequire * num);
			}
			refreshAllTextNum();
			inReceiveGift = true;
		}
		
		override public function ClearComponent():void 
		{
			for (var i:int = 0; i < _listBullet.length; i++)
			{
				var item:ItemCollectionEvent = _listBullet[i];
				item.Destructor();
			}
			_listBullet.splice(0, _listBullet.length);
			super.ClearComponent();
		}
	}

}



























