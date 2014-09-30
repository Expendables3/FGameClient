package Event.EventTeacher 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Factory.FactoryLogic.EventUtils;
	import Event.Factory.FactoryGui.GuiCollectionAbstract;
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	import Event.Factory.FactoryPacket.SendExchangeGift;
	import Event.Tet2013.gui.itemgui.TooltipGiftBox;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.SpriteExt;
	import GUI.GuiBuyAbstract.BuyItemSvc;
	import GUI.GuiBuyAbstract.SendBuyAbstract;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftSpecial;
	import Logic.MotionObject;
	import Logic.Ultility;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiCollectionTeacher extends GuiCollectionAbstract 
	{
		private const CMD_RECEIVE:String = "cmdReceive";
		private const CMD_BUY_ALL:String = "cmdBuyAll";
		private const CMD_SHOW_GIFT_TOOLTIP:String = "cmdShowGiftTooltip";
		//private const CMD_RECEIVE_ALL:String = "cmdReceiveAll";
		private const ID_GIFT_BOX:String = "idGiftBox";
		private const CMD_TAB:String = "cmdTab";
		private const POSDESX1:int = 65;
		private const CMD_TAB_COMBO:String = "cmdTabCombo";
		private const CMD_RECEIVE_COMBO:String = "cmdReceiveCombo";
		private const ID_BTN_GUIDE:String = "idBtnGuide";
		private var imgGiftBox:ButtonEx;
		private var _listChar:Array = [];//các chữ
		private var _listGift:Array = [];//quà từ các tab tôn sư trọng đạo
		private var btnReceive1:Button;
		private var btnReceive2:Button;
		private var btnReceive3:Button;
		private var btnReceiveCombo1:Button;
		private var btnReceiveCombo2:Button;
		private var btnReceiveCombo3:Button;
		
		private var curTabId:int;
		private var inReceiveAll:Boolean = false;
		//private var checkBox:Button;
		private var inReceiveEquip:Boolean;
		private var tfTipTab:TextField;
		private var tfTipReceive:TextField;
		
		private var prgPoint:ProgressBar;
		private var tfPoint:TextField;
		private var inExchangePoint:Boolean;
		private var tooltipGift:TooltipGiftBox = new TooltipGiftBox(null, "");
		public function GuiCollectionTeacher(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiCollectionTeacher";
			_urlBuyAPI = "EventService.colp_buyColItem";
			_idBuyAPI = "";
			ThemeName = "GuiCollectionTeacher_Theme";
		}
		
		override protected function onInitGui():void 
		{
			if (Ultility.IsOtherDay(EventSvc.getInstance().logTime, GameLogic.getInstance().CurServerTime))
			{
				EventTeacherMgr.getInstance().resetRemainCount();
			}
			EventSvc.getInstance().logTime = GameLogic.getInstance().CurServerTime;
			var numRow:int = EventSvc.getInstance().NumRow;
			var oRequired:Object = EventSvc.getInstance().getListRequire();
			var x:int = 48, y:int = 118, isEnable:Boolean = true, price:int, i:int, idItem:String;
			var btnChange:Button, tfPrice:TextField, item:ItemCollectionEvent, info:ItemCollectionInfo;
			_oItemEvent = new Object();
			AddButton(ID_BTN_CLOSE, "BtnThoat", 762, 19);
			AddButton(ID_BTN_GUIDE, "GuiCollectionTeacher_BtnGuide", 720, 19);
			var fm:TextFormat;
			fm = new TextFormat("Arial", 14);
			/*vẽ phần điểm tích lũy*/
			var bg:Image = AddImage("", "GuiCollectionTeacher_ImgGiftPointPrgBg", 171, 74, true, ALIGN_LEFT_TOP);
			prgPoint = AddProgress("", "GuiCollectionTeacher_PrgGiftPoint", 189, 75);
			var point:int = EventTeacherMgr.getInstance().getPoint();
			var maxPoint:int = EventTeacherMgr.getInstance().getMaxPoint();
			prgPoint.setStatus(Number(point) / Number(maxPoint));
			var startG:ButtonEx = AddButtonEx("", "GuiCollectionTeacher_ImgStartPrg", 100, 69);
			startG.img.buttonMode = false;
			startG.setTooltipText("Số lần câu");
			tfPoint = AddLabel("", 120, 74, 0xffffff, 0, 0x000000);
			tfPoint.mouseEnabled = false;
			tfPoint.defaultTextFormat = fm;
			tfPoint.text = Ultility.StandardNumber(point) + " lần";
			
			/////////////đặt các hộp quà lên trên progressbar điểm
			var oGift:Object = ConfigJSON.getInstance().getItemInfo("ColP_ExchangeGift")["PointGift"];
			const lengPrg:Number = 454.8;
			const xPrgPoint:Number = 189;
			var lengOnePercent:Number = lengPrg / 100;
			var percentMoc:Number;
			var maxMoc:Number = EventUtils.getMaxElementFormObject(oGift);
			var imgGiftMoc:ButtonEx;
			var tfMocPoint:TextField;
			var xMocGift:Number;
			tfMocPoint = AddLabel("0", xPrgPoint, 93, 0xffffff, 0, 0x000000);
			for (var moc:String in oGift)
			{
				percentMoc = Number(moc) / maxMoc * 100;
				xMocGift = xPrgPoint + percentMoc * lengOnePercent - 16;
				imgGiftMoc = AddButtonEx(CMD_SHOW_GIFT_TOOLTIP + "_" + moc, "GuiCollectionTeacher_ImgGiftPoint", xMocGift, 70);
				//imgGiftMoc.setTooltipText(Localization.getInstance().getString("EventTeacher_TooltipMocGift" + moc));
				imgGiftMoc.img.buttonMode = false;
				tfMocPoint = AddLabel("", xMocGift + 3, 93, 0xffffff, 0, 0x000000);
				tfMocPoint.text = Ultility.StandardNumber(Number(moc));
			}
			/*vẽ phần dưới*/
			for (i = 1; i <= numRow; i++)
			{
				_oItemEvent[i] = new Object();
				/*add tất cả các collection chung chung thuộc dòng*/
				isEnable = true;
				for (idItem in oRequired[i])
				{
					info = EventSvc.getInstance().getItemInfo("ColPItem", int(idItem));
					item = ItemCollectionEvent.createItemEvent(info.ItemType,
																this.img, 
																"GuiCollectionTeacher_ImgSlot", 
																x, y);
					item.initData(info);
					(item as ItemTeacherEvent).maxNum = oRequired[i][idItem];
					item.drawGift();
					_oItemEvent[i][idItem] = item;
					price = EventSvc.getInstance().getPrice(info.ItemType, info.ItemId, "ZMoney");
					AddButton(CMD_BUY + "_" + info.ItemType + "_" + info.ItemId + "_" + price + "_ZMoney",
								"GuiCollectionTeacher_BtnBuyZMoney", x + 12, y + 107);
					tfPrice = AddLabel("", x + 9, y + 109, 0xffffff, 1, 0x000000);
					tfPrice.text = Ultility.StandardNumber(price);
					tfPrice.mouseEnabled = false;
					x += 108;
					isEnable &&= (info.Num >= oRequired[i][idItem]);
				}
				/*add collection item đặc thù của dòng đó*/
				imgGiftBox = AddButtonEx(ID_GIFT_BOX, "GuiCollectionTeacher_ImgBox", 697, 137);
				imgGiftBox.img.buttonMode = false;
				imgGiftBox.setTooltipText(Localization.getInstance().getString("EventTeacher_CharBox"));
				this["btnChange" + i] = AddButton(CMD_CHANGE + "_ColPItem_" + i, 
								"GuiCollectionTeacher_BtnChange", 
								x + 60, y + 90);//nút đổi
				btnChange = this["btnChange" + i];
				btnChange.SetEnable(isEnable);
				
				this["btnChangeAll" + i] = AddButton(CMD_CHANGE_ALL + "_ColPItem_" + i, 
							"GuiCollectionTeacher_BtnChangeAll",
							x + 42, y + 120);
				(this["btnChangeAll" + i] as Button).SetEnable(isEnable);
			}
			/*nút mua tất cả*/
			AddButton(CMD_BUY_ALL, "GuiCollectionTeacher_BtnBuyAll", 248, 257);
			tfPrice = AddLabel("", 285, 258, 0xffffff, 1, 0x000000);
			price = ConfigJSON.getInstance().getItemInfo("ColP_BuyItem")["Collection"]["1"]["Price"]["ZMoney"];
			tfPrice.text = Ultility.StandardNumber(price);
			tfPrice.mouseEnabled = false;
			
			/*vẽ phần "TÔN SƯ TRỌNG ĐẠO"*/
			x = 51; y = 315;
			_listChar = [];
			for (i = 1; i <= 4; i++)
			{
				info = EventSvc.getInstance().getItemInfo("ColPGGift", i);
				item = ItemCollectionEvent.createItemEvent(info.ItemType, this.img,
														//"GuiCollectionTeacher_ImgSlotChar" + i, 
														"KhungFriend", 
														x, y);
				item.initData(info);
				item.drawGift();
				(item as ItemCharater).setButtonMode(true);
				item.EventHandler = this;
				item.IdObject = CMD_TAB + "_" + i;
				_listChar.push(item);
				x += 97;
			}
			
			/*vẽ cái combo*/
			info = EventTeacherMgr.getInstance().getCombo();
			item = ItemCollectionEvent.createItemEvent(info.ItemType, this.img,
														//"GuiCollectionTeacher_ImgSlotChar5", 
														"KhungFriend", 
														453, 311);
			item.initData(info);
			item.drawGift();
			(item as ItemCharater).setButtonMode(true);
			item.EventHandler = this;
			item.IdObject = CMD_TAB_COMBO + "_5";
			_listChar.push(item);
			var tfNotice:TextField = AddLabel("", 551, 418, 0x264904);
			fm = new TextFormat("Arial", 12, 0x264904, true);
			tfNotice.defaultTextFormat = fm;
			tfNotice.text = "(Đủ mỗi loại 5 con)";
			/*vẽ các nút nhận thưởng*/
			x = 215;
			for (i = 1; i <= 3; i++)
			{
				this["btnReceive" + i] = AddButton(CMD_RECEIVE + "_" + i,
													"GuiCollectionTeacher_BtnReceive",
													x, 544);
				this["btnReceiveCombo" + i] = AddButton(CMD_RECEIVE_COMBO + "_" + i,
													"GuiCollectionTeacher_BtnReceive",
													x, 544);
				(this["btnReceiveCombo" + i] as Button).SetVisible(false);
				
				x += 130;
			}
			curTabId = 1;
			/*vẽ phần "phần thưởng"*/
			tfTipTab = AddLabel("", 300, 416);
			fm = new TextFormat("Arial", 12, 0x096791, true);
			tfTipTab.defaultTextFormat = fm;
			tfTipReceive = AddLabel("", 620, 450);
			//fm = new TextFormat("Arial", 12, 0x096791, true);
			fm = new TextFormat("Arial", 12, 0xff0000, true);
			tfTipReceive.defaultTextFormat = fm;
			changeTab(curTabId);
			
			//tfNotice = AddLabel("", 657, 541, 0x264904);
			//fm = new TextFormat("Arial", 15, 0x264904, true);
			//tfNotice.defaultTextFormat = fm;
			//tfNotice.text = "Dùng tất cả";
			/*vẽ cái checkbox*/
			//checkBox = AddButton(CMD_RECEIVE_ALL, 
									//"GuiCollectionTeacher_BtnCheck" + inReceiveAll, 
									//630, 535);
			//checkBox.setTooltipText(Localization.getInstance().getString("EventTeacher_Check" + inReceiveAll));
		}
		
		private function getTipTab(tabId:int):String 
		{
			var sChar:String = Localization.getInstance().getString("EventTeacher_TipChar" + tabId);
			var sTip:String = Localization.getInstance().getString("EventTeacher_TipTab");
			sTip = sTip.replace("@Char@", sChar);
			return sTip;
		}
		
		private function removeAllTabGift():void
		{
			var item:AbstractItemGift;
			for (var i:int = 0; i < _listGift.length; i++)
			{
				item = _listGift[i];
				item.Destructor();
			}
			_listGift.splice(0, _listGift.length);
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case CMD_SHOW_GIFT_TOOLTIP:
					var moc:int = int(data[1]);
					tooltipGift.IdGift = moc;
					tooltipGift.Show();
					tooltipGift.SetPos(GameInput.getInstance().MousePos.x - 120, GameInput.getInstance().MousePos.y + 20);
					//trace("Show Tooltip for moc", moc);
					break;
			}
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case CMD_SHOW_GIFT_TOOLTIP:
					//var moc:int = int(data[1]);
					tooltipGift.Hide();
					//trace("Hide Tooltip for moc", moc);
					break;
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (Ultility.IsOtherDay(EventSvc.getInstance().logTime, GameLogic.getInstance().CurServerTime))
			{
				GuiMgr.getInstance().GuiMessageBox.inReload = true;
				GuiMgr.getInstance().GuiMessageBox.ShowReload("Qua ngày\nBạn hãy click lại vào nút Event để tiếp tục chơi nhé", 310, 200, 1);
				EventTeacherMgr.getInstance().resetRemainCount();
				Hide();
				return;
			}
			if (inReceiveEquip) return;
			super.OnButtonClick(event, buttonID);
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			var type:String, id:int, num:int;
			var pk:BasePacket, ans:int;
			var gift:AbstractGift;
			switch(cmd)
			{
				case ID_BTN_GUIDE:
					GuiMgr.getInstance().guiGuideTeacher.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case CMD_RECEIVE://ấn nút nhận thưởng
					id = curTabId;
					if (EventTeacherMgr.getInstance().getRemainCount(id) <= 0)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã hết số lần đổi quà chữ " + Localization.getInstance().getString("EventTeacher_TipChar" + id) + " trong ngày", 310, 200, 1);
						return;
					}
					EventTeacherMgr.getInstance().updateRemainCount(id, -1);
					ans = int(data[1]);
					
					type = "ColPGGift";
					num = 1;
					//if (inReceiveAll)
					//{
						//num = EventSvc.getInstance().getNumItem("ColPGGift", id);
					//}
					
					pk = SendExchangeGift.createPacketExchagne(type, id, type, num);
					(pk as SendExchangeGiftFromChar).Ans = ans;
					
					gift = EventTeacherMgr.getInstance().getGift(id, ans);
					if (Ultility.categoriesGift(gift.ItemType) == 0)//nhận quà thường
					{
						(pk as SendExchangeGiftFromChar).IsNormalGift = true;
						EffectMgr.setEffBounceDown("Nhận Thành Công", gift.getImageName(), 330, 280, null, num * gift["Num"]);
					}
					else
					{
						inReceiveEquip = true;
					}
					Exchange.GetInstance().Send(pk);
					EventSvc.getInstance().updateItem("ColPGGift", id, -num);
					EventSvc.getInstance().processGetGift(gift, gift["Num"] * num);
					effText((_listChar[id - 1] as ItemCollectionEvent).img, 45, 105, 45, 95, "-", num);
					(_listChar[id - 1] as ItemCollectionEvent).refreshTextNum();
					EventTeacherMgr.getInstance().updateCombo();
					(_listChar[4] as ItemCollectionEvent).refreshTextNum();
					tfTipReceive.text = getTipReceive(id);
					updateAllButtonReceive(id);
					break;
				case CMD_RECEIVE_COMBO:
					if (EventTeacherMgr.getInstance().getRemainCount(5) <= 0)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã hết số lần đổi quà từ bộ\n\"Sò Tôm Cua Cá\" hôm nay", 310, 200, 1);
						return;
					}
					EventTeacherMgr.getInstance().updateRemainCount(5, -1);
					ans = int(data[1]);
					num = 1;
					pk = SendExchangeGift.createPacketExchagne("Combo", 1, "Combo", num);
					(pk as SendGetGiftCombo).Ans = ans;
					gift = EventTeacherMgr.getInstance().getComboGift()[ans - 1];
					if ((gift.ItemType == "Material" && gift.ItemId == 10) || gift.ItemType == "HammerPurple" || (gift.ItemType == "RankPointBottle" && gift.ItemId == 4))
					{
						inReceiveEquip = true;
					}
					else
					{
						(pk as SendGetGiftCombo).IsNormalGift = true;
						EffectMgr.setEffBounceDown("Nhận Thành Công", gift.getImageName(), 330, 280, null, num * gift["Num"]);
					}
					Exchange.GetInstance().Send(pk);
					
					var item:ItemCollectionEvent;
					var buff:int;
					for (var i:int = 1; i <= 4; i++)
					{
						buff = EventTeacherMgr.getInstance().getNumRequireCombo(i);
						EventSvc.getInstance().updateItem("ColPGGift", i, -(num * buff));
						item = _listChar[i - 1];
						item.refreshTextNum();
						//cho chữ bay lên
						effText(item.img, 45, 105, 45, 95, "-", num * buff);
					}
					EventTeacherMgr.getInstance().updateCombo();
					effText((_listChar[4] as ItemCollectionEvent).img, 45, 105, 45, 95, "-", num);
					(_listChar[4] as ItemCollectionEvent).refreshTextNum();
					tfTipReceive.text = getTipReceive(5);
					updateAllButtonReceiveCombo();
					break;
				case CMD_BUY_ALL:
					var price:int = ConfigJSON.getInstance().getItemInfo("ColP_BuyItem")["Collection"]["1"]["Price"]["ZMoney"];
					if (BuyItemSvc.getInstance().buyItem("Collection", 1, "ZMoney", price))
					{
						buyAllItem(1);
						refreshAllTextNum();
					}
					break;
				//case CMD_RECEIVE_ALL:
					//RemoveButton(CMD_RECEIVE_ALL);
					//inReceiveAll = !inReceiveAll;
					//checkBox = AddButton(CMD_RECEIVE_ALL, 
									//"GuiCollectionTeacher_BtnCheck" + inReceiveAll, 
									//630, 535);
					//checkBox.setTooltipText(Localization.getInstance().getString("EventTeacher_Check" + inReceiveAll));
					//break;
				case CMD_TAB:
					if (inReceiveGift) return;
					if (curTabId != int(data[1]))
					{
						(_listChar[curTabId - 1] as ItemCharater).setButtonMode(true);
						curTabId = int(data[1]);
						changeTab(curTabId);
					}
					break;
				case CMD_TAB_COMBO:
					if (inReceiveGift) return;
					if (curTabId != int(data[1]))
					{
						(_listChar[curTabId - 1] as ItemCharater).setButtonMode(true);
						curTabId = int(data[1]);
						changeTabCombo(curTabId);
					}
					break;
				
			}
		}
		private function changeTab(idTab:int):void
		{
			removeAllTabGift();
			tfTipTab.text = getTipTab(idTab);
			tfTipReceive.text = getTipReceive(idTab);
			var x:int = 209, y:int = 438;
			var listGift:Array = EventTeacherMgr.getInstance().getTabGift(idTab);
			var numChar:int = EventSvc.getInstance().getItemInfo("ColPGGift", idTab)["Num"];
			var btnReceive:Button,btnReceiveCombo:Button , temp:AbstractGift,itemGift:AbstractItemGift;
			for (var i:int = 0; i < listGift.length; i++)
			{
				temp = listGift[i];
				itemGift = AbstractItemGift.createItemGift(temp.ItemType, this.img,
															"GuiCollectionTeacher_ImgSlotGift",
															x, y, true);
				itemGift.initData(temp, "", 136, 157);
				itemGift.setPosBuff(-5, -25);
				itemGift.xNum = 12;
				itemGift.yNum = 105;
				itemGift.hasTooltipImg = false;
				itemGift.hasTooltipText = true;
				itemGift.setHasBackGroundColor(false);
				itemGift.drawGift();
				itemGift.addNum(12, 102, 12, 0xffffff);
				_listGift.push(itemGift);
				btnReceive = this["btnReceive" + (i + 1)];
				btnReceive.SetVisible(true);
				btnReceive.SetEnable(numChar > 0);
				btnReceiveCombo = this["btnReceiveCombo" + (i + 1)];
				btnReceiveCombo.SetVisible(false);
				img.swapChildren(itemGift.img, btnReceive.img);
				x += 130;
			}
			(_listChar[idTab - 1] as ItemCharater).setButtonMode(false);
		}
		
		private function changeTabCombo(idTab:int):void 
		{
			removeAllTabGift();
			tfTipTab.text = Localization.getInstance().getString("EventTeacher_TipTab5");
			tfTipReceive.text = getTipReceive(idTab);
			var x:int = 209, y:int = 438;
			var listGift:Array = EventTeacherMgr.getInstance().getComboGift();
			var numCombo:int = EventTeacherMgr.getInstance().getCombo().Num;
			var btnReceiveCombo:Button, btnReceive:Button, temp:AbstractGift,itemGift:AbstractItemGift;
			for (var i:int = 0; i < listGift.length; i++)
			{
				temp = listGift[i];
				itemGift = AbstractItemGift.createItemGift(temp.ItemType, this.img,
															"GuiCollectionTeacher_ImgSlotGift",
															x, y, true);
				itemGift.initData(temp, "", 136, 157);
				itemGift.setPosBuff(-5, -25);
				itemGift.xNum = 12;
				itemGift.yNum = 105;
				itemGift.hasTooltipImg = false;
				itemGift.hasTooltipText = true;
				itemGift.setHasBackGroundColor(false);
				itemGift.drawGift();
				itemGift.addNum(12, 102, 12, 0xffffff);
				_listGift.push(itemGift);
				btnReceiveCombo = this["btnReceiveCombo" + (i + 1)];
				btnReceiveCombo.SetVisible(true);
				btnReceiveCombo.SetEnable(numCombo > 0);
				btnReceive = this["btnReceive" + (i + 1)];
				btnReceive.SetVisible(false);
				img.swapChildren(itemGift.img, btnReceiveCombo.img);
				x += 130;
			}
			for (i = listGift.length; i < 3; i++)
			{
				btnReceive = this["btnReceive" + (i + 1)];
				btnReceive.SetVisible(false);
			}
			(_listChar[idTab - 1] as ItemCharater).setButtonMode(false);
		}
		/**
		 * mua tất cả item tại 1 dòng nào đó
		 * @param	idRow
		 */
		private function buyAllItem(idRow:int):void 
		{
			var num:int;
			var item:ItemCollectionEvent;
			for (var idItem:String in _oItemEvent[idRow])
			{
				item = _oItemEvent[idRow][idItem];
				num = EventSvc.getInstance().getRequired(idRow, int(idItem));
				EventSvc.getInstance().updateItem("ColPItem", int(idItem), num);
				/*Cho chữ bay lên*/
				effText(item.img, 45, 105, 45, 95, "+", num);
			}
		}
		
		private function updateAllButtonReceive(id:int):void 
		{
			var numChar:int = EventSvc.getInstance().getNumItem("ColPGGift", id);
			var btnReceive:Button;
			for (var i:int = 1; i <= 3; i++)
			{
				btnReceive = this["btnReceive" + i];
				btnReceive.SetEnable(numChar > 0);
			}
		}
		private function updateAllButtonReceiveCombo():void 
		{
			var numChar:int = EventTeacherMgr.getInstance().getCombo().Num;
			var btnReceive:Button;
			for (var i:int = 1; i <= 3; i++)
			{
				btnReceive = this["btnReceiveCombo" + i];
				btnReceive.SetEnable(numChar > 0);
			}
		}
		
		/**
		 * đổi lấy chữ
		 * @param	type loại mang đi đổi
		 * @param	id : id của dòng
		 */
		override protected function changeGift(type:String, id:int):void 
		{
			var pk:SendExchangeGift = SendExchangeGift.createPacketExchagne("ColPItem", 
																				id, "Collection", 1);
			Exchange.GetInstance().Send(pk);
			EventSvc.getInstance().changeGift(type, id);
			/*effect trừ hoa*/
			var oRequired:Object = EventSvc.getInstance().getListRequire()["1"];
			for (var i:String in oRequired)
			{
				var numRequire:int = oRequired[i];
				var item:ItemCollectionEvent = _oItemEvent["1"][i];
				effText(item.img, 45, 105, 45, 85, "-", numRequire);
			}
			
			refreshAllTextNum();
			super.changeGift(type, id);
		}
		
		private function addPointUser(num:int):void 
		{
			effText(prgPoint.img, 120, 110, 120, 90, "+", num);
			var prePoint:int = EventTeacherMgr.getInstance().getPoint();
			EventTeacherMgr.getInstance().increasePoint(num);
			var point:int = EventTeacherMgr.getInstance().getPoint();
			var maxPoint:int = EventTeacherMgr.getInstance().getMaxPoint();
			prgPoint.setStatus(Number(point) / Number(maxPoint));
			tfPoint.text = Ultility.StandardNumber(point) + " lần";
			var listPointGift:Array = [];
			var hasGift:Boolean = EventTeacherMgr.getInstance().checkGift(prePoint, point, listPointGift);
			if (hasGift)//nếu có quà => listPointGift.length >0 => gui goi tin len server
			{
				var pk:SendGiftTarget = new SendGiftTarget(listPointGift);
				Exchange.GetInstance().Send(pk);
				inExchangePoint = true;
			}
		}
		public function processExchangePoint(data:Object, oldData:Object = null):void
		{
			var listGift:Array = EventSvc.getInstance().initGiftServer(data);
			var num:int = EventUtils.countObjElement(data["Gifts"]["Normal"]) + EventUtils.countObjElement(data["Gifts"]["Equipment"]);
			GuiMgr.getInstance().guiGiftEventTeacher.isFeed = true;
			GuiMgr.getInstance().guiGiftEventTeacher.typeFeed = "GiftPoint";
			GuiMgr.getInstance().guiGiftEventTeacher.setNumSlot(num);
			GuiMgr.getInstance().guiGiftEventTeacher.Show(Constant.GUI_MIN_LAYER, 5);
		}
		override protected function changeAllGift(type:String, id:int):void 
		{
			var num:int = EventSvc.getInstance().getMinNum(1);
			var pk:SendExchangeGift = SendExchangeGift.createPacketExchagne("ColPItem", 
																			id, "Collection", 
																			num);
			Exchange.GetInstance().Send(pk);
			EventSvc.getInstance().changeGift(type, id, num);
			/*effect trừ hoa*/
			var oRequired:Object = EventSvc.getInstance().getListRequire()["1"];
			for (var i:String in oRequired)
			{
				var numRequire:int = oRequired[i];
				var item:ItemCollectionEvent = _oItemEvent["1"][i];
				effText(item.img, 45, 105, 45, 85, "-", numRequire * num);
			}
			refreshAllTextNum();
			super.changeAllGift(type, id);
		}
		/**
		 * lấy về 1 trong các chữ "TÔN" "SƯ" "TRỌNG" "ĐẠO"
		 * @param	data
		 */
		override protected function receiveGiftComp(data:Object, oldData:Object = null):void  
		{
			/*xử lý với việc cộng điểm*/
			addPointUser((oldData as SendExchangeChar).Num);
			var x:int = imgGiftBox.img.x + img.x;
			var y:int = imgGiftBox.img.y + img.y;
			var name:String;
			var i:String;
			var count:int = 0;
			var length:int = 0;
			var listSum:Array = [0, 0, 0, 0];
			var listNum:Array = [0, 0, 0, 0];
			for (i in data)
			{
				listNum[data[i]["ItemId"] - 1] = data[i]["Num"];
			}
			var oData:Object = EventSvc.getInstance().splitData(data);
			for (i in oData)
			{
				length++;
			}
			var posDesX:int, posDesY:int = 370;//tọa độ x, y của điểm bay vào
			var ptr:Sprite = img;
			var item:ItemCollectionEvent;
			imgGiftBox.SetVisible(false);
			var listCharacter:Array = [];
			var temp:ItemCollectionEvent;
			var effOpenBox:EffOpenBox = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiCollectionTeacher_EffOpenBox", null, x, y, false, false, null, effOpenComp) as EffOpenBox;
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
					temp = _listChar[index - 1];
					listSum[index - 1] += num;
					var num1:int = listNum[index - 1];
					var num2:int = listSum[index - 1];
					if (listSum[index - 1] == listNum[index - 1])
					{
						effText(temp.img, 45, 105, 45, 95, "+", listNum[index - 1]);
						temp.refreshTextNum();
					}
					count++;
					if (count == length)
					{
						(_listChar[4] as ItemCollectionEvent).refreshTextNum();
						if (curTabId == 5)
						{
							var combo:ItemCollectionInfo = EventTeacherMgr.getInstance().getCombo();
							if (combo.Num > 0 && !btnReceiveCombo1.enable)
							{
								enableAllButtonReceive(true);
							}
						}
						else
						{
							var numChar:int = EventSvc.getInstance().getNumItem("ColPGGift", curTabId);
							if (!btnReceive1.enable && numChar > 0)
							{
								enableAllButtonReceive();
							}
						}
						//if (!btnReceive1.enable || (curTabId == 5 && !btnReceiveCombo1.enable))
						//{
							//enableAllButtonReceive();
						//}
						inReceiveGift = false;
					}
				}
				for (i in oData)
				{
					item = _listChar[oData[i]["ItemId"] - 1];
					listCharacter.push(item);
					EventSvc.getInstance().updateItem(oData[i]["ItemType"], oData[i]["ItemId"], oData[i]["Num"]);
					posDesX = getPosDesX(oData[i]["ItemId"]);
					name = "EventTeacher_" + oData[i]["ItemType"] + oData[i]["ItemId"];
					EventUtils.effFallFly("EventTeacher", Constant.GUI_MIN_LAYER, name, x, y, 200, posDesX, posDesY, fComp, oData[i]["Num"], oData[i]["ItemId"]);
				}
				EventTeacherMgr.getInstance().updateCombo();
			}
		}
		
		private function enableAllButtonReceive(combo:Boolean = false):void
		{
			var sCombo:String = combo?"Combo":"";
			for (var i:int = 1; i <= 3; i++)
			{
				(this["btnReceive" + sCombo + i] as Button).SetEnable();
			}
		}
		
		private function getPosDesX(id:int):int 
		{
			return POSDESX1 + (id - 1) * 97;
		}
		
		override public function ClearComponent():void 
		{
			for (var i:int = 0; i < _listChar.length; i++)
			{
				var item:ItemCollectionEvent = _listChar[i];
				item.Destructor();
			}
			_listChar.splice(0, _listChar.length);
			
			removeAllTabGift();
			
			super.ClearComponent();
		}
		
		public function processGetEquipmentGift(data:Object, oldData:Object):void 
		{
			if (oldData["IsNormalGift"])
			{
				return;
			}
			var num:int = 1;
			var ans:int;
			var listGiftServer:Array;
			EventSvc.getInstance().initGiftServer(data);
			switch((oldData as BasePacket).GetID())
			{
				case Constant.CMD_RECEIVE_CHARACTER_GIFT:
					num = (oldData as SendExchangeGiftFromChar).Num;
					GuiMgr.getInstance().guiGiftEventTeacher.isFeed = false;			//event tet 2013
					//GuiMgr.getInstance().guiGiftEventTeacher.typeFeed = "AllChest";
					listGiftServer = EventSvc.getInstance().getGiftServer();
					for (var i:int = 0; i < listGiftServer.length; i++)
					{
						var gift:AbstractGift = listGiftServer[i];
						/*if ((gift as GiftSpecial).Rank == 4)
						{
							GuiMgr.getInstance().guiGiftEventTeacher.isFeed = true;
						}*/
					}
					break;
				case Constant.CMD_RECEIVE_COMBO_GIFT:
					num = (oldData as SendGetGiftCombo).Num;
					ans = (oldData as SendGetGiftCombo).Ans;
					/*if (ans == 3)
					{
						GuiMgr.getInstance().guiGiftEventTeacher.typeFeed = "Material";
					}
					else if (ans == 2)
					{
						GuiMgr.getInstance().guiGiftEventTeacher.typeFeed = "AllChest";
						listGiftServer = EventSvc.getInstance().getGiftServer();
						num = listGiftServer.length;
					}*/
					GuiMgr.getInstance().guiGiftEventTeacher.isFeed = true;
					GuiMgr.getInstance().guiGiftEventTeacher.typeFeed = "Combo";
					break;
			}
			GuiMgr.getInstance().guiGiftEventTeacher.setNumSlot(num);
			GuiMgr.getInstance().guiGiftEventTeacher.Show(Constant.GUI_MIN_LAYER, 5);
			inReceiveEquip = false;
		}
		
		private function getTipReceive(idTab:int):String 
		{
			var str:String = (idTab == 5) ? Localization.getInstance().getString("EventTeacher_TipReceive5") :
								Localization.getInstance().getString("EventTeacher_TipReceive");
			var sChar:String = Localization.getInstance().getString("EventTeacher_TipChar" + idTab);
			str = str.replace("@Char@", sChar);
			var sNum:String = Ultility.StandardNumber(EventTeacherMgr.getInstance().getRemainCount(idTab));
			str = str.replace("@Num@", sNum);
			return str;
		}
	}
}





















