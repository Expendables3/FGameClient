package GUI.BlackMarket 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.ActiveTooltip;
	import GUI.component.Button;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import GUI.TrungLinhThach.GUILinhThachToolTip;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.BlackMarket.SendGetDiamond;
	import NetworkPacket.PacketSend.BlackMarket.SendGetItemBack;
	import NetworkPacket.PacketSend.BlackMarket.SendSellItem;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemSell extends Container 
	{
		static public const BTN_SELL:String = "btnSell";
		static public const IS_SELLING:String = "isSelling";
		static public const IS_EMPTY:String = "isEmpty";
		static public const IS_READY:String = "isReady";
		static public const IS_SOLD:String = "isSold";
		static public const BTN_GET_BACK:String = "btnGetBack";
		static public const BTN_GET_DIAMOND:String = "btnGetDiamond";
		static public const TXT_BOX_COST:String = "txtBoxCost";
		private var txtBoxCost:TextBox;
		private var txtName:TextField;
		private var btnSell:Button;
		private var comboBox:ComboBoxEx;
		private var txtSell:TextField;
		private var txtGuide:TextField;
		public var imageItem_Bg:Container;
		public var imageGoods:Image;
		public var data:Object;
		private var arrayTime:Array = ["1 giờ", "8 giờ", "24 giờ"];
		private var labelNum:TextField;
		private var _timeRemain:Number;
		private var _itemState:String;
		public var tabType:String;
		public var position:int;
		public var num:int;
		private var _channel:int;
		private var txtChanel:TextField;
		private var btnGetBack:Button;
		private var btnGetDiamond:Button;
		private var btnCancel:Button;
		private var _cost:int;
		private var tooltipFish:TooltipFormat;
		private var iconSold:Image;
		private var loadGoodsComplete:Boolean = false;
		private var contentItem:Container;
		//
		public var AutoId:int;
		
		private const nameQuartz:Object = 
		{
			"1":"Huy Hiệu Dũng Mãnh", "2":"Huy Hiệu Phi Phàm", "3":"Huy Hiệu Sức Mạnh", "4":"Huy Hiệu Khổng Tước", "5":"Huy Hiệu Chiến Tranh", 
			"6":"Huy Hiệu Thần Vệ", "7":"Huy Hiệu Thần Linh", "8":"Huy Hiệu Biển Cả", "9":"Huy Hiệu Song Ngư", "10":"Huy Hiệu Thánh Ngư", 
			"11":"Huy Hiệu Mãng Xà", "12":"Huy Hiệu Hải Tặc", "13":"Huy Hiệu Hải Mã"
		}
		
		public function ItemSell(parent:Object, imgName:String= "Item_Sell_Bg_Market", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			//trace("----------------ItemSell");
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			btnSell = AddButton(BTN_SELL, "Btn_Sell_Market", 450 + 93, 60 - 23);
			btnSell.SetEnable(false);
			
			var txtFormat:TextFormat = new TextFormat("arial", 18, 0xffffff, true);
			txtFormat.align = "right";
			
			txtBoxCost = AddTextBox(TXT_BOX_COST, "0", 242, 60 - 22, 106, 40, this);
			txtBoxCost.SetTextFormat(txtFormat);
			txtBoxCost.SetDefaultFormat(txtFormat);
			cost = 0;
			comboBox = new ComboBoxEx(this.img, 325 + 89, 34, arrayTime[0], arrayTime);
			comboBox.setWidth(80);
			imageItem_Bg = new Container(this.img, "", 0, 0);
			imageItem_Bg.toBmp = true;
			imageGoods = new Image(this.img, "", 20, 20);
			imageGoods.LoadRes("");
			
			txtFormat.align = "center";
			txtName = AddLabel("", 80, 20, 0x000000, 1);
			txtName.wordWrap = true;
			//textFieldName.border = true;
			txtName.width = 100;
			txtName.height = 50;
			txtName.defaultTextFormat = txtFormat;
			
			txtSell = AddLabel("Còn " + comboBox.selectedItem, 400, 36);
			txtChanel = AddLabel("", 466 + 8, 18);
			txtChanel.width = 100;
			txtChanel.wordWrap = true;
			txtChanel.defaultTextFormat = txtFormat;
			txtFormat.size = 15;
			txtSell.defaultTextFormat = txtFormat;
			txtSell.setTextFormat(txtFormat);
			txtSell.visible = false;
			
			txtGuide = AddLabel("Đặt giá bán                Chọn thời gian", 320, 36 +25);
			txtFormat.size = 15;
			txtGuide.setTextFormat(txtFormat);
			txtGuide.visible = false;
			
			labelNum = AddLabel("xNum", -35, 55, 0xffffff, 2, 0x000000); 
			txtFormat = new TextFormat("arial", 17, 0xffffff, true);
			labelNum.defaultTextFormat = txtFormat;
			labelNum.visible = false;
			
			iconSold = AddImage("", "IconSold", 453, 57);
			iconSold.img.visible = false;
			
			btnGetBack = AddButton(BTN_GET_BACK, "BtnGetBack", 543, 36);
			btnCancel = AddButton(BTN_GET_BACK, "Btn_CancelSell", 543, 47);
			btnGetDiamond = AddButton(BTN_GET_DIAMOND, "BtnGetDiamond", 543, 36);
			
			itemState = IS_EMPTY;
		}
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			if (txtID == TXT_BOX_COST)
			{
				var text:String = txtBoxCost.GetText();
				text = text.split(",").join("");
				cost = int(text);
			}
		}
		
		private function onDoubleClickButton(e:MouseEvent):void 
		{
			outEquipment(e);
			GUISell(EventHandler).onDoubleClick(e, IdObject);
		}
		
		public function setGoods(_tabType:String, objData:Object):void
		{
			tabType = _tabType;
			var imageName:String;
			var name:String;
			var level:int;
			switch(tabType)
			{
				case GUISell.BTN_TAB_EQUIP:
				case GUISell.BTN_TAB_JEWEL:
					if (int(objData["Color"]) == FishEquipment.FISH_EQUIP_COLOR_WHITE)
					{
						imageItem_Bg.LoadRes("ItemMarket_Bg");
					}
					else
					{
						imageItem_Bg.LoadRes(FishEquipment.GetBackgroundName(int(objData["Color"])));
					}
					imageName = FishEquipment.GetEquipmentName(objData["Type"], objData["Rank"], objData["Color"]) + "_Shop";
					name = FishEquipment.GetEquipmentLocalizeName(objData["Type"], objData["Rank"], objData["Color"]);
					num = 1;
					level = objData["EnchantLevel"];
					break;
				case GUISell.BTN_TAB_OTHER:
					//trace("case GUISell.BTN_TAB_OTHER:Type========= " + objData["Type"]);
					imageItem_Bg.LoadRes("ItemMarket_Bg");
					if (objData["Type"] == "Material")
					{
						imageName = Ultility.GetNameMatFromType(objData["ItemId"]);
						labelNum.text = "x" + Ultility.StandardNumber(objData["Num"]);
						labelNum.visible = true;
						num = objData["Num"];
						name = Localization.getInstance().getString(objData["ItemType"] + objData["ItemId"]);
					}
					else
					{
						/*if (objData["ItemId"] > 4)
						{
							objData["ItemId"] = 0;
						}*/
						imageName = objData["Type"] + objData["ItemId"];
						name =  nameQuartz[objData["ItemId"]];
						num = 1;
						level = objData["Level"];
						//trace("setGoods imageName============== " + imageName);
					}
					break;
				case GUISell.BTN_TAB_FISH:
					imageItem_Bg.LoadRes("ItemMarket_Bg");
					
					var st:String;
					var nameS:String;
					var money:String;
					var exp:String;
					tooltipFish = new TooltipFormat();
					var fmt:TextFormat = new TextFormat("arial", 14, 0x000000, true);
					fmt.align = TextFormatAlign.CENTER;
					fmt.size = 14;
					fmt.bold = true;
					if(objData["FishType"] == Fish.FISHTYPE_SOLDIER)
					{
						imageName = "Fish" + objData["FishTypeId"] + "_Old_Idle";
						name =  Localization.getInstance().getString("Fish" + objData["FishTypeId"]);
						
						nameS = "Ngư thủ";	
						money = "Lực chiến: " + objData["Damage"];
						exp = "Danh hiệu: " + Localization.getInstance().getString("FishSoldierRank" + objData["Rank"]);
						exp += "\nSố sao: " + Ultility.getStarByReceiptType(objData["RecipeType"]["ItemType"]);
						st = nameS + "\n" + money + "\n" + exp;
					}
					else
					{
						imageName = objData["Type"];
						name = Localization.getInstance().getString(imageName);
						
						var obj:Object = ConfigJSON.getInstance().GetItemList("SuperFish");
						var objFishSpecial:Object = obj[objData["Type"]];
						nameS = Localization.getInstance().getString(objData["Type"]);					
						money = "Tiền: " + objFishSpecial["Active"]["Money"];
						exp = "EXP: " + objFishSpecial["Active"]["Exp"];
						st = nameS + "\n" + money + "\n" + exp;
						var s: String;
						
						for (s in objData["Option"])
						{
							st += "\n" + OptionTooltip(s) + objData["Option"][s] + "%";
						}
					}
					
					fmt.color = "0xff33ff";
					tooltipFish.text = st;
					tooltipFish.setTextFormat(fmt, 0, nameS.length);
					fmt.size = 12;
					fmt.bold = false;
					fmt.color = "0x000000";
					tooltipFish.setTextFormat(fmt, nameS.length, tooltipFish.text.length);			
					
					num = 1;
					break;
				default:
					imageItem_Bg.LoadRes("ItemMarket_Bg");
					break;
			}
			
			imageGoods.setImgInfo = function f():void
			{
				imageGoods.img.mouseEnabled = false;
				imageGoods.img.buttonMode = true;
				imageGoods.FitRect(70, 70, new Point(0, 0));
				if (level > 0)
				{
					var txt:TextField = new TextField();
					txt.text = "+" + level;
					txt.setTextFormat(new TextFormat("arial", 18, 0xffff00, true));
					
					var outline:GlowFilter = new GlowFilter();
					outline.blurX = outline.blurY = 3.5;
					outline.strength = 8;
					outline.color = 0x000000;
					var arr:Array = [];
					arr.push(outline);
					txt.antiAliasType = AntiAliasType.ADVANCED;
					txt.filters = arr;
					
					txt.x = imageGoods.img.width/2 - 38;
					txt.y = imageGoods.img.height / 2 - 40;
					imageGoods.img.addChild(txt);
				}
				
				if (objData["Color"] != null)
				{
					FishSoldier.EquipmentEffect(this.img, objData["Color"]);
					if (objData["Color"] == 6)
					{
						AddImage("IcMax", "IcMax", 83 - 6, 43 - 14).SetScaleXY(0.7);
					}
				}
			}
			imageGoods.LoadRes(imageName);
			
			txtName.text = name;
			itemState = IS_READY;
			//cost = 0;
			data = objData;
			
			txtBoxCost.textField.selectable = true;
			txtBoxCost.textField.stage.focus = txtBoxCost.textField;
			
			//Hình vuông bắt sự kiện
			var rect:Sprite = new Sprite();
			rect.graphics.beginFill(0xffffff, 0);
			rect.graphics.drawRect(0, 0, 70, 70);
			rect.graphics.endFill();
			rect.x = 0;
			rect.y = 0;
			rect.buttonMode = true;
			img.addChild(rect);
			rect.doubleClickEnabled = true;
			rect.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickButton);
			rect.addEventListener(MouseEvent.MOUSE_OVER, overEquipment);
			rect.addEventListener(MouseEvent.MOUSE_OUT, outEquipment);
		}
		
		private function outEquipment(e:MouseEvent):void 
		{
			GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			GuiMgr.getInstance().guiTooltipEgg.Hide();
			if (tooltipFish != null)
			{
				ActiveTooltip.getInstance().clearToolTip();
			}
		}
		
		private function overEquipment(e:MouseEvent):void 
		{
			if (tabType == GUISell.BTN_TAB_EQUIP || tabType == GUISell.BTN_TAB_JEWEL)
			{
				if (data != null)
				{
					if (data as FishEquipment == null)
					{
						var fishEquip:FishEquipment = new FishEquipment();
						fishEquip.SetInfo(data);
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(e.stageX, e.stageY, fishEquip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
					}
					else
					{
						if (e && data)
						{
							GuiMgr.getInstance().GuiEquipmentInfo.InitAll(e.stageX, e.stageY, data, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
						}
					}
				}
			}
			else if (tabType == GUISell.BTN_TAB_OTHER && data)
			{
				if (data["Type"] != "Material")
				{
					GuiMgr.getInstance().guiTooltipEgg.showGUI(data, e.stageX, e.stageY);
				}
			}
			else
			if (tooltipFish != null)
			{
				ActiveTooltip.getInstance().showNewToolTip(tooltipFish, imageGoods.img);
			}
		}
		
		private function OptionTooltip(option: String): String
		{
			switch(option)
			{
				case "Time":
					return "Giảm thời gian: ";
				case "Money":
					return "Tăng tiền: ";
				case "Exp":
					return "Tăng exp: ";
				case "MixFish":
					return "Tăng lai ra cá quý: ";					
				case "MixSpecial":
					return "Tăng lai ra cá đặc biệt: "
				default:
					return option;
			}
		}
		
		public function removeGoods():void
		{
			if (itemState == IS_EMPTY)
			{
				return;
			}
			itemState = IS_EMPTY;
			cost = 0;
			tooltipFish = null;
			if (GetImage("IcMax") != null)
			{
				RemoveImage(GetImage("IcMax"));
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (imageGoods.img == null || imageGoods.img.width == 0 || imageGoods.img.x < 0)
			{
				return;
			}
			var guiSell:GUISell = GuiMgr.getInstance().guiSell;
			if (guiSell.isWaitingStore || guiSell.isWaitingListSell)
			{
				return;
			}
			switch(buttonID)
			{
				case  BTN_SELL:
					//Đang khóa hoặc xin phá khóa
					var passwordState:String = GameLogic.getInstance().user.passwordState;
					if (passwordState == Constant.PW_STATE_IS_LOCK || passwordState == Constant.PW_STATE_IS_CRACKING || passwordState == Constant.PW_STATE_IS_BLOCKED)
					{
						GuiMgr.getInstance().guiPassword.showGUI();
						break;
					}
					var diamon:int = cost;
					if (diamon > 0)
					{
						var time:Number =  getTimeCombobox(comboBox.selectedItem);
						var sendSellItem:SendSellItem = new SendSellItem(getTabType(data["Type"]), data["Type"], data["Id"], num, { "Diamond":diamon}, time, position);
						Exchange.GetInstance().Send(sendSellItem);
						initSell(time, diamon);
					}
					else
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn chưa đặt giá bán");
					}
					break;
				case BTN_GET_BACK:
					if (itemState == IS_SELLING && channel != 0)
					{
						btnCancel.SetEnable(false);
						Exchange.GetInstance().Send(new SendGetItemBack(position, AutoId));
						//guiSell.removeGoods(this);
					}
					break;
				case BTN_GET_DIAMOND:
					if (itemState == IS_SOLD)
					{
						var fee:Number = ConfigJSON.getInstance().GetItemList("Param")["Market"]["Fee"];
						var numGet:int =  cost - Math.ceil(cost*fee);
						GuiMgr.getInstance().guiNewCongratulation.showGUI("GuiBuyDiamond_Diamond", numGet, "<font size='18'>Bán thành công</font>\n<font size='13'>(đã thu 5% phí giao dịch)</font>", function f():void
						{
							Exchange.GetInstance().Send(new SendGetDiamond(position));
							//Cộng kim cương
							EffectMgr.getInstance().textFly("+" + numGet, new Point(event.stageX, event.stageY), new TextFormat("arial", 18, 0xff00ff, true));
							GameLogic.getInstance().user.setDiamond(GameLogic.getInstance().user.getDiamond() + numGet);
							
							removeGoods();
						}, "BtnGetDiamond");
					}
					break;
			}
		}
		
		public function getTabType(itemType:String):String
		{
			//trace("getTabType itemType== " + itemType);
			switch(itemType)
			{
				case "Weapon":
				case "Armor":
				case "Helmet":
				case "Ring":
				case "Necklace":
				case "Bracelet":
				case "Belt":
					return "SoldierEquipment";
				case "Sparta":
				case "Spiderman":
				case "Ironman":
				case "Swat":
				case "Batman":
				case "Superman":
					return "SuperFish";
				case "Soldier":
					return "Soldier";
				case "Material":
					return "Material";
				case "QWhite":
				case "QGreen":
				case "QYellow":
				case "QPurple":
				case "QVIP":
					return "Quartz";
			}
			return "";
		}
		
		/**
		 * Chuyển sang trạng thái rao bán
		 * @param	time
		 * @param	_cost
		 * @param	channelValue
		 */
		public function initSell(time:Number, _cost:Number, channelValue:int = 0):void
		{
			cost = _cost;
			timeRemain = time;
			if (channelValue != 0)
			{
				channel = channelValue;
			}
			else
			{
				txtChanel.text = "Đang rao bán";
			}
			itemState = IS_SELLING;
		}
		
		public function getTimeCombobox(labelValue:String):Number
		{
			switch(labelValue)
			{
				case arrayTime[0]:
					return 3600;
				case arrayTime[1]:
					return 8 * 3600;
				case arrayTime[2]:
					return 24 * 3600;
			}
			return 0;
		}
		
		public function get timeRemain():Number 
		{
			return _timeRemain;
		}
		
		public function set timeRemain(value:Number):void 
		{
			_timeRemain = value;
			if (value <= 0)
			{
				txtSell.text = "Đã hết hạn";
				txtChanel.visible = false;
				btnGetBack.SetVisible(true);
				btnCancel.SetVisible(false);
			}
			else
			{
				txtChanel.visible = true;
				btnGetBack.SetVisible(false);
				btnCancel.SetVisible(true);
				btnCancel.SetEnable(true);
				txtSell.text = "Còn " + Ultility.ConvertTimeToString(value);//int((value/3600)*10)/10 + " giờ";
			}
		}
		
		public function get channel():int 
		{
			return _channel;
		}
		
		public function set channel(value:int):void 
		{
			_channel = value;
			if(channel != 0)
			{
				txtChanel.text = "Kênh " + value;
			}
			else
			{
				txtChanel.text = "";
			}
		}
		
		public function get itemState():String 
		{
			return _itemState;
		}
		
		public function set itemState(value:String):void 
		{
			_itemState = value;
			switch(value)
			{
				case IS_EMPTY:
					labelNum.visible = false;
					txtGuide.visible = false;
					txtBoxCost.textField.selectable = true;
					txtBoxCost.textField.type = TextFieldType.INPUT;
					txtSell.visible = false;
					comboBox.visible = true;
					btnSell.SetVisible(true);
					btnSell.SetEnable(false);
					img.getChildByName("Image_Drag_Item").visible = true;
					txtName.text = "";
					if(imageItem_Bg != null && imageItem_Bg.img != null)
					{
						imageItem_Bg.img.visible = false;
					}
					if(imageGoods != null && imageGoods.img != null)
					{
						imageGoods.img.visible = false;
					}
					channel = 0;
					data = null;
					btnGetBack.SetVisible(false);
					btnGetDiamond.SetVisible(false);
					btnCancel.SetVisible(false);
					iconSold.img.visible = false;
					break;
				case IS_READY:
					img.getChildByName("Image_Drag_Item").visible = false;
					imageItem_Bg.img.visible = true;
					imageGoods.img.visible = true;
					img.setChildIndex(labelNum, img.numChildren-1);
					txtGuide.visible = true;
					btnSell.SetEnable(true);
					btnGetBack.SetVisible(false);
					btnGetDiamond.SetVisible(false);
					btnCancel.SetVisible(false);
					iconSold.img.visible = false;
					break;
				case IS_SELLING:
					txtBoxCost.textField.selectable = false;
					txtBoxCost.textField.type = TextFieldType.DYNAMIC;
					btnSell.SetVisible(false);
					comboBox.visible = false;
					txtSell.visible = true;
					txtGuide.visible = false;
					btnGetDiamond.SetVisible(false);
					if(timeRemain > 0)
					{
						btnCancel.SetVisible(true);
						btnCancel.SetEnable(true);
						btnGetBack.SetVisible(false);
					}
					else
					{
						btnCancel.SetVisible(false);
						btnGetBack.SetVisible(true);
					}
					iconSold.img.visible = false;
					break;
				case IS_SOLD:
					txtChanel.visible = false;
					//txtSell.text = "Đã bán";
					txtSell.visible = false;
					iconSold.img.visible = true;
					btnGetBack.SetVisible(false);
					btnCancel.SetVisible(false);
					btnGetDiamond.SetVisible(true);
					break;
			}
		}
		
		public function get cost():int 
		{
			return _cost;
		}
		
		public function set cost(value:int):void 
		{
			if (value < 0)
			{
				value = 0;
			}
			if (value > 1000000)
			{
				value = 1000000;
			}
			_cost = value;
			txtBoxCost.SetText(Ultility.StandardNumber(value));
		}
	}

}