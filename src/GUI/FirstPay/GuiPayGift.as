package GUI.FirstPay 
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Bounce;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.GuiGetStatus.GUIGetStatusAbstract;
	import GUI.GUIMain;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	import Logic.MyUserInfo;
	import Logic.Ultility;
	import Logic.User;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiPayGift extends GUIGetStatusAbstract 
	{
		private const ID_BOX_INSIDE:String = "idBoxInside";
		private const ID_BTN_NAPG:String = "idBtnNapg";
		private const CMD_TAB_LIGHT:String = "cmdTabLight";
		private const IMG_RECEIVED:String = "imgReceived";
		private const IMG_TAB:String = "imgTab";
		private const CMD_TAB:String = "cmdTab";
		private const TIME_TRANS:int = 4;
		private const ID_BTN_RECEIVE:String = "idBtnReceive";
		private const ID_BTN_CLOSE:String = "idBtnClose";
		
		private var btnReceive:Button;
		
		private var isReceiveGift:Boolean = false;
		
		private var _tabId:int;		//id của tab hiện tại
		private var _numXu:int;
		private var _oReceived:Object;
		private var _oGift:Object;
		private var _listUnReceive:Array = [];
		private var _listItemGift:Array = [];
		private const obj:Object = { "Draft":1, "Paper":2, "GoatSkin":3, "Blessing":4, "Rent":9 };
		private var dataTrans:Object;
		private var _timeTrans:Number = -1;
		private var posReceive:Object;//mảng vị trí nút đã nhận
		private var posTabSelect:Object;
		private var posBtnTab:Object;
		private var posBtnTabLight:Object;
		private var btnNapG:Button;
		private var tfTip:TextField;
		private var boxInside:Container;
		private var guiReceiveGift:GuiReceiveGiftPay = new GuiReceiveGiftPay(null, "");
		
		public function GuiPayGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiPayGift";
			_imgThemeName = "GuiFirstPay_Theme";
			_idPacket = Constant.CMD_GET_PAY_INFO;
			_urlService = "UserService.getPayInfo";
		}
		private function initPosition(cfg:Object):void
		{
			posReceive = new Object();
			posTabSelect = new Object();
			posBtnTab = new Object();
			posBtnTabLight = new Object();
			var _listIndex:Array = [];
			var yRec:int = 93, yTab:int = 97, yBtnTab:int = 97, yTabLight:int = 97;
			var xRec:int = 433, xTab:int = 423, xBtnTab:int = 433, xTabLight:int = 433 ;
			var posRec:Point,posTab:Point,posBTab:Point,posTabLight:Point;
			for (var itm:String in cfg)
			{
				_listIndex.push(int(itm));
			}
			_listIndex.sort(Array.NUMERIC|Array.DESCENDING);
			for (var i:int = 0; i < _listIndex.length; i++)
			{
				posRec = new Point(xRec, yRec);
				posReceive[String(_listIndex[i])] = posRec;
				yRec += 47;
				
				posTab = new Point(xTab, yTab);
				posTabSelect[String(_listIndex[i])] = posTab;
				yTab += 47;
				
				posBTab = new Point(xBtnTab, yBtnTab);
				posBtnTab[String(_listIndex[i])] = posBTab;
				yBtnTab += 47;
				
				posTabLight = new Point(xTabLight, yTabLight);
				posBtnTabLight[String(_listIndex[i])] = posTabLight;
				yTabLight += 47;
			}
		}
		override protected function onInitGuiBeforeServer():void 
		{
			SetPos(img.x, img.y);
			AddButton(ID_BTN_CLOSE, "BtnThoat", 585, 18);
			btnReceive = AddButton(ID_BTN_RECEIVE, "GuiFirstPay_BtnNhanThuong", 180, 320);
			boxInside = AddContainer(ID_BOX_INSIDE, "KhungFriend", 0, 0);
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0xff0000);
			mask.graphics.drawRect(60, 37, 372, 270);
			mask.graphics.drawRect(60, 357, 337, 378);
			mask.graphics.endFill();
			mask.visible = false;
			boxInside.img.addChild(mask);
			boxInside.img.mask = mask;
			boxInside.img.mouseEnabled = false;
		}
		
		override protected function onInitData(data1:Object):void 
		{
			_listUnReceive.splice(0, _listUnReceive.length);
			//server
			_numXu = data1["PayInfo"]["FirstAddXu"];
			_oReceived = data1["PayInfo"]["FirstAddXuGift"];
			//config
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("FirstAddXuGift");
			//khoi tao mang qua
			_oGift = new Object();
			var gift:AbstractGift;
			var itm:String;
			var str:String;
			var infoGift:Object;
			for (itm in cfg)
			{
				if (_oReceived[itm] == null)//khong co mat trong mảng quà đã nhận
				{
					_listUnReceive.push(int(itm));
					_oGift[itm] = new Object();
					for (str in cfg[itm])
					{
						infoGift = cfg[itm][str];
						gift = AbstractGift.createGift(infoGift["ItemType"]);
						gift.setInfo(infoGift);
						_oGift[itm][str] = gift;
					}
				}
			}
			_listUnReceive.sort(Array.NUMERIC);
			if (_listUnReceive.length == 0)
			{
				_tabId = -1;
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã nhận hết quà", 310, 200, 1);
				Hide();
				return;
			}
			else
			{
				_tabId = _listUnReceive[0];
			}
			
			initPosition(cfg);
		}
		
		override protected function onInitGuiAfterServer():void 
		{
			_listItemGift.splice(0, _listItemGift.length);
			drawAllGift();
			btnReceive.SetEnable(_tabId <= _numXu);
			btnNapG = AddButton(ID_BTN_NAPG, "GuiFirstPay_BtnNapG", 300, 100);
			var tf:TextField = AddLabel(Ultility.StandardNumber(_numXu), 440, 405, 0x723F0C);
			var fm:TextFormat = new TextFormat("Arial", 18);
			tf.setTextFormat(fm);
			tfTip = AddLabel("", 140, 95, 0x723F0C);
			fm = new TextFormat("Arial", 14);
			fm.align = "center";
			tfTip.defaultTextFormat = fm;
			changeTip(_tabId);
			//changeTab(1);
			var itm:String;
			var i:int;
			var imgTab:Image;
			var btnTab:Button;
			var btnTabLight:Button;
			var imgReceived:Image;
			for (itm in _oReceived)
			{
				imgReceived = AddImage(IMG_RECEIVED + "_" + itm, "GuiFirstPay_ImgReceived" + itm, posReceive[itm].x, posReceive[itm].y,true,ALIGN_LEFT_TOP);
			}
			for (i = 0; i < _listUnReceive.length; i++)
			{
				itm = String(_listUnReceive[i]);
				imgTab = AddImage(IMG_TAB + "_" + itm, "GuiFirstPay_ImgTab" + itm, posTabSelect[itm].x, posTabSelect[itm].y,true,ALIGN_LEFT_TOP);
				imgReceived = AddImage(IMG_RECEIVED + "_" + itm, "GuiFirstPay_ImgReceived" + itm, posReceive[itm].x, posReceive[itm].y,true,ALIGN_LEFT_TOP);
				btnTab = AddButton(CMD_TAB + "_" + itm, "GuiFirstPay_BtnUnActive" + itm, posBtnTab[itm].x, posBtnTab[itm].y);
				btnTabLight = AddButton(CMD_TAB_LIGHT + "_" + itm, "GuiFirstPay_BtnActive" + itm, posBtnTabLight[itm].x, posBtnTabLight[itm].y);
				imgReceived.img.visible = false;
				imgTab.img.visible = false;
				if (_numXu < _listUnReceive[i])
				{
					btnTab.img.visible = true;
					btnTabLight.img.visible = false;
				}
				else
				{
					btnTabLight.img.visible = true;
					btnTab.img.visible = false;
				}
				if (_tabId == _listUnReceive[i])
				{
					imgTab.img.visible = true;
					btnTabLight.img.visible = false;
					btnTab.img.visible = false;
					
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (isReceiveGift)//đang nhận quà thì click cliếc gì cả
			{
				return;
			}
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			
			switch(cmd)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_NAPG:
					GuiMgr.getInstance().GuiNapG.Init();
					Hide();
				break;
				case ID_BTN_RECEIVE:
					receiveGift();
				break;
				case CMD_TAB:
				case CMD_TAB_LIGHT:
					var id:String = data[1];
					/*Chuyển cái tab hiện tại về nút*/
					GetImage(IMG_TAB + "_" + _tabId).img.visible = false;
					if (_numXu < _tabId)
					{
						GetButton(CMD_TAB + "_" + _tabId).SetVisible(true);
					}
					else
					{
						GetButton(CMD_TAB_LIGHT + "_" + _tabId).SetVisible(true);
					}
					/*chuyển tab*/
					changeTab(int(id));
				break;
			}
		}
		
		private function receiveGift():void 
		{
			isReceiveGift = true;
			//xét xem trong phần thưởng có equipment không, nếu có thì add vào data rồi gọi gui chọn hệ
			//b1: khởi tạo cho data là tập equipment
			var countEquip:int = 0;
			dataTrans = new Object();//tập equipment cần chọn hệ
			var oTabGift:Object = _oGift[_tabId];
			for (var itm:String in oTabGift)
			{
				var oGift:AbstractGift = oTabGift[itm];
				if (oGift.ClassName == "GiftSpecial")
				{
					countEquip++;
					dataTrans[itm] = oGift;
				}
				else if (oGift.ClassName == "GiftNormal")
				{
					if ((oGift as GiftNormal).ItemType == "Soldier")
					{
						countEquip++;
						dataTrans[itm] = oGift;
					}
				}
			}
			//b2: xét xem có equipmnet không
			if (countEquip > 0)//nếu có: hiện gui chọn hệ
			{
				var guiChooseElement:GuiElementFirstPay = new GuiElementFirstPay(null, "");
				guiChooseElement.data = dataTrans;
				guiChooseElement.id = _tabId;
				guiChooseElement.Show(Constant.GUI_MIN_LAYER, 5);
			}
			else//nếu không có: cho rơi xuống khay luôn
			{
				dataTrans = null;
				//gửi gói tin nhận thưởng lên
				var pk:SendGetGiftPay = new SendGetGiftPay(_tabId);
				Exchange.GetInstance().Send(pk);
				dropToTray();
			}
		}
		
		//private function changeTab(tabId:int):void
		public function changeTab(tabId:int):void
		{
			/*chuyển cái nút về ảnh*/
			GetImage(IMG_TAB + "_" + tabId).img.visible = true;
			if (_numXu < tabId)
			{
				GetButton(CMD_TAB + "_" + tabId).img.visible = false;
			}
			else
			{
				GetButton(CMD_TAB_LIGHT + "_" + tabId).img.visible = false;
			}
			/*chuyển tip*/
			changeTip(tabId);
			
			removeAllGift();
			_tabId = tabId;
			btnReceive.SetEnable(_tabId <= _numXu);
			drawAllGift();
		}
		
		private function changeTip(tabId:int):void 
		{
			if (tabId == 1 && _numXu == 0)
			{
				tfTip.text = Localization.getInstance().getString("FirstPay1");
			}
			else
			{
				if (_numXu >= tabId)
				{
					tfTip.text = Localization.getInstance().getString("FirstPay3");
				}
				else
				{
					var num:int = tabId - _numXu;
					var str:String = Localization.getInstance().getString("FirstPay2");
					str = str.replace("@num", Ultility.StandardNumber(num));
					tfTip.text = str;
				}
			}
		}
		
		public function chooseElementComp(element:int):void 
		{
			var itmGift:AbstractItemGift;
			var data:Object;
			for (var i:int = 0; i < _listItemGift.length; i++)
			{
				data = null;
				itmGift = _listItemGift[i];
				if (itmGift.ClassName == "ItemSpecialGift")
				{
					data = new Object();
					data["Element"] = element;
				}
				else if (itmGift.ClassName == "ItemNormalGift")
				{
					if ((itmGift as ItemNormalGift).Gift.ItemType == "Soldier")
					{
						data = new Object();
						data["RecipeId"] = element;
					}
				}
				if (data)
				{
					itmGift.transform(data);
				}
			}
			_timeTrans = GameLogic.getInstance().CurServerTime;//tạo khoảng thời gian cho việc transform
		}
		
		/**
		 * rơi xuống khay
		 */
		private function dropToTray():void
		{
			var yDes:int = 372;
			var xDes:int;
			var posDes:Point;
			var posLocal:Point;
			var len:int = _listItemGift.length;
			var i:int;
			var itGift:AbstractItemGift;
			var count:int = 0;
			for (i = 0; i < len; i++)
			{
				itGift = _listItemGift[i];
				xDes = 85 + Math.random() * 210;
				posLocal = new Point(xDes, yDes);
				posDes = img.localToGlobal(posLocal);
				posLocal = null;
				TweenMax.to(itGift.img, 1, 
								{ bezierThrough:[ { x:xDes, y:yDes } ], ease:Bounce.easeOut,
								onComplete:onTweenComp});
			}
			function onTweenComp():void
			{
				count++;
				if (count == len)//tất cả các ô đều đã rơi xuống
				{
					//flyToStore();
					guiReceiveGift.Show(Constant.GUI_MIN_LAYER, 5);
					receiveAllGiftComp();
				}
			}
		}
		
		/**
		 * bay từ khay vào kho
		 */
		private function flyToStore():void 
		{
			var guiMain:GUIMain = GuiMgr.getInstance().GuiMain;
			if (guiMain == null)
			{
				return;
			}
			var btnStore:ButtonEx;
			var posStore:Point;
			var posMed:Point;
			var posStoreLocal:Point;
			var yMed:int = 490;
			var xMed:int;
			var i:int;
			var len:int = _listItemGift.length;
			var itGift:AbstractItemGift;
			var count:int = 0;
			
			btnStore = guiMain.btnInventory;
			posStoreLocal = new Point(btnStore.img.x - 135, btnStore.img.y - 60);
			posStore = guiMain.img.localToGlobal(posStoreLocal);
			posStoreLocal = null;
			for (i = 0; i < len; i++)
			{
				itGift = _listItemGift[i];
				xMed = 40 + Math.random() * 300;
				var posMedLocal:Point = new Point(xMed, yMed);
				posMed = img.localToGlobal(posMedLocal);
				posMedLocal = null;
				TweenMax.to(itGift.img, 1, 
							{ 
								bezierThrough:
											[ 
												{ x:posMed.x, y:posMed.y }, 
												{ x:posStore.x, y:posStore.y } 
											],
								onComplete:onFlyComp 
							} );
			}
			function onFlyComp():void
			{
				count++;
				btnStore.setStateMouseOver();
				if (count == len)
				{
					posStore = null;
					posMed = null;
					guiReceiveGift.Show(Constant.GUI_MIN_LAYER, 5);
					receiveAllGiftComp();
					//btnStore.setStateMouseOut();
				}
				
				//itGift.img.visible = false;
			}
		}
		
		/**
		 * nhận xong hết các quà
		 */
		private function receiveAllGiftComp():void
		{
			isReceiveGift = false;
			/*b1: tìm tab hiển thị tiếp theo*/
			_oReceived[_tabId] = 1;
			var index:int = _listUnReceive.indexOf(_tabId);
			_listUnReceive.splice(index, 1);
			_oGift[_tabId] = null;
			if (_listUnReceive.length == 0)
			{
				FinishPayGift();
			}
			else
			{
				//chuyển cái nút hiện tại về đã nhận
				GetImage(IMG_TAB + "_" + _tabId).img.visible = false;
				GetImage(IMG_RECEIVED +"_" + _tabId).img.visible = true;
				changeTab(_listUnReceive[0]);
			}
		}
		
		private function FinishPayGift():void 
		{
			GuiMgr.getInstance().guiFrontScreen.removeGiftPay();
			onFinishPayGift();
			Hide();
		}
		
		private function onFinishPayGift():void 
		{
			GuiMgr.getInstance().guiFrontScreen.addBtnNapThe();
		}
		
		override public function ClearComponent():void 
		{
			removeAllGift();
			super.ClearComponent();
		}
		
		private function removeAllGift():void
		{
			var itmGift:AbstractItemGift;
			for (var i:int = 0; i < _listItemGift.length; i++)
			{
				itmGift = _listItemGift[i];
				itmGift.Destructor();
				itmGift = null;
			}
			_listItemGift.splice(0, _listItemGift.length);
		}
		
		private function drawAllGift():void
		{
			var oTabGift:Object = _oGift[_tabId];
			var itmGift:AbstractItemGift;
			var gift:AbstractGift;
			var x:int = 95, y:int = 150;
			var i:int = 0;
			for (var str:String in oTabGift)
			{
				i++;
				gift = oTabGift[str];
				
				if (gift.ClassName == "GiftNormal")
				{
					//itmGift = new ItemNormalGift(this.img, "KhungFriend", x, y);
					itmGift = new ItemNormalGift(boxInside.img, "KhungFriend", x, y);
					(itmGift as ItemNormalGift).xNum = -23;
					(itmGift as ItemNormalGift).yNum = 45;
				}
				else if (gift.ClassName == "GiftSpecial")
				{
					//itmGift = new ItemSpecialGift(this.img, "GuiFirstPay_SlotGift", x, y);
					itmGift = new ItemSpecialGift(boxInside.img, "GuiFirstPay_SlotGift", x, y);
					if ((gift as GiftSpecial).ItemType != "Seal")
					{
						itmGift.hasTooltipImg = false;
						//(itmGift as ItemSpecialGift).HasTooltip = false;
						var rank:int = (gift as GiftSpecial).Rank;
						var type:String = gift.ItemType;
						var strTip:String = Localization.getInstance().getString("Equipment" + type) + " " +
											(gift as GiftSpecial).getColorName() + " cấp ";

						var kind:int = (gift as GiftSpecial).categoryType();
						if (kind == GiftSpecial.JEWELRY)
						{
							strTip += rank.toString();
						}
						else if (kind == 0)
						{
							strTip += rank % 100 + "\nĐược quyền chọn hệ";
							gift["Element"] = 1;
						}
						(itmGift as ItemSpecialGift).setTooltipText(strTip);
					}
				}
				itmGift.initData(gift, "GuiFirstPay_SlotGift", 60, 58, true);
				itmGift.drawGift();
				if (gift.ClassName == "GiftSpecial")
				{
					itmGift.FitRect(53, 56, new Point(x, y));
				}
				else
				{
					if ((gift as GiftNormal).ItemType == "Soldier")
					{
						itmGift.setTooltipText("Cá lính " + 
												obj[(gift as GiftNormal).RecipeType] + 
												" sao\n"  + 
												"Được quyền chọn hệ"
											);
					}
				}
				
				_listItemGift.push(itmGift);
				x += 70;
				if (i % 4 == 0)
				{
					x = 95;
					y = 232;
				}
			}
		}
		
		override public function updateGUI():void 
		{
			if (_timeTrans > 0)
			{
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				if (curTime-_timeTrans > TIME_TRANS)
				{
					dropToTray();
					_timeTrans = -1;
				}
			}
		}
		
		public function set IsReceiveGift(value:Boolean):void
		{
			isReceiveGift = value;
		}
		
		override public function OnHideGUI():void 
		{
			var itm:String;
			for (itm in posBtnTab)
			{
				posBtnTab[itm] = null;
			}
			posBtnTab = null;
			for (itm in posBtnTabLight)
			{
				posBtnTabLight[itm] = null;
			}
			posBtnTabLight = null;
			for (itm in posReceive)
			{
				posReceive[itm] = null;
			}
			posReceive = null;
			for (itm in posTabSelect)
			{
				posTabSelect[itm] = null;
			}
			posTabSelect = null;
			if (_numXu != 0)
			{
				GiftPayBag.firstClick = false;
			}
			var user:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
			user.FirstAddXuGift = _oReceived;
		}
		
		public function processGetGift(oldData:Object):void 
		{
			var pack:SendGetGiftPay = oldData as SendGetGiftPay;
			var oGift:Object = _oGift[pack.GiftType];
			var itm:String;
			var gift:AbstractGift;
			var user:User = GameLogic.getInstance().user;
			for (itm in oGift)
			{
				gift = oGift[itm];
				switch(gift["ItemType"])
				{
					case "Money":
						user.UpdateUserMoney((gift as GiftNormal).Num);
					break;
					case "Exp":
						user.SetUserExp(user.GetExp() + (gift as GiftNormal).Num);
					break;
				}
			}
		}
		
		public function initListGiftFromServer(data:Object):void
		{
			var listGift:Array = [];
			var listEquip:Array = data["Equipment"];
			var listNor:Array = data["Normal"];
			var tem:Object;
			var gift:AbstractGift;
			var i:int;
			if (listEquip != null)
			{
				for (i = 0; i < listEquip.length; i++)
				{
					tem = listEquip[i];
					gift = new GiftSpecial();
					gift.setInfo(tem);
					
					listGift.push(gift);
				}
			}
			if (listNor != null)
			{
				for (i = 0; i < listNor.length; i++)
				{
					tem = listNor[i];
					gift = new GiftNormal();
					gift.setInfo(tem);
					if ((gift as GiftNormal).ItemType == "Soldier")
					{
						(gift as GiftNormal).RecipeId = (gift as GiftNormal).Element;
					}
					listGift.push(gift);
				}
			}
			guiReceiveGift.initData(listGift);
		}
	}

}



































