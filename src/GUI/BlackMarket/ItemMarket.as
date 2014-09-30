package GUI.BlackMarket 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.ActiveTooltip;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import GUI.TrungLinhThach.GUILinhThachToolTip;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.BlackMarket.SendBuyConfirm;
	import NetworkPacket.PacketSend.BlackMarket.SendBuyItem;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemMarket extends Container 
	{
		static public const BTN_BUY:String = "btnBuy";
		private var buttonBuy:Button;
		private var textFieldCost:TextField;
		private var textFieldIndex:TextField;
		private var textFieldName:TextField;
		private var textFieldTime:TextField;
		
		private var _cost:Number;
		private var _time:Number;
		private var _name:String;
		public var position:int;
		
		//private var equipment:FishEquipment;
		private var itemImage:Image;
		private var itemBg:Container;
		public var sortName:String;
		public var seller:Object;
		
		public var data:Object;
		private var labelNum:TextField;
		private var _num:int;
		public var itemType:String;
		public var autoId:int;
		private var tooltipFish:TooltipFormat;
		//private var GuiToolTip:GUILinhThachToolTip;
		private const nameQuartz:Object = 
		{
			"1":"Huy Hiệu Dũng Mãnh", "2":"Huy Hiệu Phi Phàm", "3":"Huy Hiệu Sức Mạnh", "4":"Huy Hiệu Khổng Tước", "5":"Huy Hiệu Chiến Tranh", 
			"6":"Huy Hiệu Thần Vệ", "7":"Huy Hiệu Thần Linh", "8":"Huy Hiệu Biển Cả", "9":"Huy Hiệu Song Ngư", "10":"Huy Hiệu Thánh Ngư", 
			"11":"Huy Hiệu Mãng Xà", "12":"Huy Hiệu Hải Tặc", "13":"Huy Hiệu Hải Mã"
		}
		
		public function ItemMarket(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			LoadRes("");
			itemBg = AddContainer("", "ItemMarket_Bg", 50 - 35, -4);
			itemBg.toBmp = true;
			buttonBuy = AddButton(BTN_BUY, "Btn_Buy_Market", 300 - 32, 60 - 33);
			var txtFormat:TextFormat = new TextFormat("arial", 18, 0xffffff, true);
			txtFormat.align = "center";
			textFieldCost = AddLabel("3", 305 - 50,2);
			textFieldCost.defaultTextFormat = txtFormat;
			
			//textFieldIndex = AddLabel("1", 10 - 58, 72 - 51);
			//textFieldIndex.defaultTextFormat = txtFormat;
			
			textFieldName = AddLabel("Name", 75 + 22, 2);
			textFieldName.wordWrap = true;
			//textFieldName.border = true;
			textFieldName.width = 100;
			textFieldName.height = 50;
			textFieldName.defaultTextFormat = txtFormat;
			
			textFieldTime = AddLabel("20 ngày", 500, 22, 0x1283a0);
			txtFormat = new TextFormat("arial", 18, 0xffffff, true);
			textFieldTime.defaultTextFormat = txtFormat;
			textFieldTime.autoSize = TextFieldAutoSize.RIGHT;
			
			labelNum = AddLabel("", -17, 50, 0xffffff, 2, 0x000000); 
			txtFormat = new TextFormat("arial", 17, 0xffffff, true);
			labelNum.defaultTextFormat = txtFormat;
		}
		
		public function init(type:String, objData:Object, cost:Number, time:Number, position:int, _seller:Object, _autoId:int):void
		{
			var imageName:String = "";
			var numItem:int = 0;
			var st:String;
			var tooltip:TooltipFormat = new TooltipFormat();
			
			itemType = type;
			autoId = _autoId;
			var level:int;
			switch(type)
			{
				case "Weapon":
				case "Armor":
				case "Helmet":
				case "Bracelet":
				case "Necklace":
				case "Ring":
				case "Belt":
					if (int(objData["Color"]) == FishEquipment.FISH_EQUIP_COLOR_WHITE)
					{
						itemBg.LoadRes("ItemMarket_Bg");
					}
					else
					{
						itemBg.LoadRes(FishEquipment.GetBackgroundName(int(objData["Color"])));
					}
					this.img.setChildIndex(itemBg.img, 0);
					imageName = FishEquipment.GetEquipmentName(objData["Type"], objData["Rank"], objData["Color"]) + "_Shop";
					name = FishEquipment.GetEquipmentLocalizeName(objData["Type"], objData["Rank"], objData["Color"]);
					level = objData["EnchantLevel"];
					break;
				case "Fish":
				case "Soldier":
					imageName = Fish.ItemType + objData["FishTypeId"] + "_" + Fish.OLD + "_" + Fish.IDLE;
					name = Localization.getInstance().getString("Fish" + objData["FishTypeId"]);
					
					st = "<font size='16' color = '#ff33ff'>Ngư thủ</font>";	
					st += "\nLực chiến: " + objData["Damage"];
					st += "\nDanh hiệu: " + Localization.getInstance().getString("FishSoldierRank" + objData["Rank"]);
					st += "\nSố sao: " + Ultility.getStarByReceiptType(objData["RecipeType"]["ItemType"]);
					st += "\nNgười bán: <font size = '16' color = '#ff33ff'>" + Ultility.StandardString(_seller["userName"]) + "</font>";
					break;
				case "Sparta":
				case "Spiderman":
				case "Ironman":
				case "Swat":
				case "Batman":
					imageName = objData["Type"];
					name = Localization.getInstance().getString(type);
					
					var obj:Object = ConfigJSON.getInstance().GetItemList("SuperFish");
					var objFishSpecial:Object = obj[objData["Type"]];
					st = "<font size='18' color ='#ff33ff'>" + Localization.getInstance().getString(objData["Type"]) + "</font>";					
					st += "\nTiền: " + objFishSpecial["Active"]["Money"];
					st += "\nEXP: " + objFishSpecial["Active"]["Exp"];
					for (var s:String in objData["Option"])
					{
						st += "\n" + OptionTooltip(s) + objData["Option"][s] + "%";
					}
					st += "\nNgười bán: <font size = '16' color = '#ff33ff'>" + Ultility.StandardString(_seller["userName"]) + "</font>";
					break;
				case "Material":
					imageName = Ultility.GetNameMatFromType(objData["ItemId"]);
					name = Localization.getInstance().getString(type + objData["ItemId"]);
					numItem = int(objData["Num"]);
					st = "<font size='16' color = '#ff33ff'>" + name + "</font>";
					st += "\nNgười bán: <font size = '16' color = '#ff33ff'>" + Ultility.StandardString(_seller["userName"]) + "</font>";
					break;
				case "QWhite":
				case "QGreen":
				case "QYellow":
				case "QPurple":
				case "QVIP":
					imageName = objData["Type"] + objData["ItemId"];
					name = nameQuartz[objData["ItemId"]];
					st = "<font size='16' color = '#ff33ff'>" + name + "</font>";
					st += "\nNgười bán: <font size = '16' color = '#ff33ff'>" + Ultility.StandardString(_seller["userName"]) + "</font>";
					level = objData["Level"];
					break;
			}
			
			if (st != null)
			{
				tooltip.htmlText = st;				
				tooltipFish = tooltip;
			}
			itemImage = AddImage("", imageName, 0, 0, true, Image.ALIGN_CENTER_CENTER, false, function f():void
			{
				if (objData["Color"] != null)
				{
					FishSoldier.EquipmentEffect(this.img, objData["Color"]);
					if (objData["Color"] == 6)
					{
						AddImage("", "IcMax", 90, 43 - 14).SetScaleXY(0.7);
					}
				}
			});
			itemImage.FitRect(70, 70, new Point(17, 2));
			if (level > 0)
			{
				var txt:TextField = AddLabel("+" + level, 12, 0, 0x000000, 0, 0x000000);
				txt.setTextFormat(new TextFormat("arial", 18, 0xffff00, true));
			}
			if (numItem != 0)
			{
				num = numItem;
			}
			itemImage.img.mouseChildren = true;
			itemImage.img.mouseEnabled = true;
			img.mouseChildren = true;
			img.mouseEnabled = true;
			var rect:Sprite = new Sprite();
			rect.graphics.beginFill(0xffffff, 0);
			rect.graphics.drawRect(0, 0, 70, 70);
			rect.graphics.endFill();
			rect.x = 10;
			rect.y = -2;
			img.addChild(rect);
			rect.addEventListener(MouseEvent.MOUSE_OVER, overEquipment);
			rect.addEventListener(MouseEvent.MOUSE_OUT, outEquipment);
			
			seller = _seller;
			if (seller["uId"] == GameLogic.getInstance().user.GetMyInfo().Id)
			{
				buttonBuy.SetEnable(false);
				tooltip = new TooltipFormat();
				tooltip.text = "Bạn không thể mua đồ của mình";
				buttonBuy.setTooltip(tooltip);
			}
			this.cost = cost;
			this.time = time;
			this.position = position;
			sortName = Ultility.filterVietnameseCharacter(name, true);
			trace(sortName);
			data = objData;
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
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID == BTN_BUY)
			{
				//Đang khóa hoặc xin phá khóa
				var passwordState:String = GameLogic.getInstance().user.passwordState;
				if (passwordState == Constant.PW_STATE_IS_LOCK || passwordState == Constant.PW_STATE_IS_CRACKING || passwordState == Constant.PW_STATE_IS_BLOCKED)
				{
					GuiMgr.getInstance().guiPassword.showGUI();
				}
				//Không có mật khẩu hoặc đã mở khóa
				else
				if(GameLogic.getInstance().user.getDiamond() >= cost)
				{
					var fontColor:int = 0xffffff;
					if (data["Color"] != null)
					{
						switch(int(data["Color"]))
						{
							case 2:
								fontColor = 0x00ff00;
								break;
							case 3:
								fontColor = 0xffff00;
								break;
							case 4:
								fontColor = 0xff00ff;
								break;
							default:
								fontColor = 0xffffff;
								break;
						}
					}
					var levelEnchant:int = 0;
					if (data["EnchantLevel"] != null)
					{
						levelEnchant = data["EnchantLevel"];
					}
					
					//Gửi gói tin xác nhận việc mua
					var guiMarket:GUIMarket = GuiMgr.getInstance().guiMarket;			
					Exchange.GetInstance().Send(new SendBuyConfirm(guiMarket.pageType, guiMarket.pageId, position, autoId));
					GuiMgr.getInstance().guiConfirmBuyItem.itemMarket = this;
					var color:int = 0;
					if (data["Color"] != null)
					{
						color = data["Color"];
					}
					//Hiện gui mua
					GuiMgr.getInstance().guiConfirmBuyItem.showGUI(cost, name, itemBg.ImgName, itemImage.ImgName, buyItem, fontColor, levelEnchant, color);
				}
				else
				{
					GuiMgr.getInstance().guiNoDiamond.Show(Constant.GUI_MIN_LAYER, 3);
				}
			}
		}
		
		private function buyItem():void
		{
			var guiMarket:GUIMarket = GuiMgr.getInstance().guiMarket;
			var sendBuyItem:SendBuyItem = new SendBuyItem(guiMarket.pageType, guiMarket.pageId, position, autoId);
			Exchange.GetInstance().Send(sendBuyItem);
			GetButton(BTN_BUY).SetEnable(false);
			
			if (itemType == "Material")
			{
				sendBuyItem.ItemId = data["ItemId"];
				sendBuyItem.Num = data["Num"];
			}
			
			if (itemType == "QWhite" || itemType == "QGreen" || itemType == "QYellow" || itemType == "QPurple")
			{
				sendBuyItem.ItemId = data["ItemId"];
				sendBuyItem.Id = data["Id"];
				sendBuyItem.Level = data["Level"];
				sendBuyItem.Type = data["Type"];
			}
			
			guiMarket.removeItem(this);
			EffectMgr.setEffBounceDown("Mua thành công", itemImage.ImgName, 340, 300);
			
			//Trừ kim cương
			EffectMgr.getInstance().textFly("-" + cost, new Point(358 + 56 + 151, 562 + 52), new TextFormat("arial", 18, 0xff00ff, true));
			guiMarket.numDiamond -= cost;
			GameLogic.getInstance().user.setDiamond(guiMarket.numDiamond);
		}
		
		private function outEquipment(e:MouseEvent):void 
		{
			GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			GuiMgr.getInstance().guiTooltipEgg.Hide();
			ActiveTooltip.getInstance().clearToolTip();
		}
		
		private function overEquipment(e:MouseEvent):void 
		{
			if (data["Type"] == "QWhite" || data["Type"] == "QGreen" || data["Type"] == "QYellow" || data["Type"] == "QPurple")
			{
				GuiMgr.getInstance().guiTooltipEgg.showGUI(data, e.stageX, e.stageY);
			}
			else
			{
				if (data["Type"] == "Weapon" || data["Type"] == "Armor" || data["Type"] == "Helmet" || data["Type"] == "Ring" || data["Type"] == "Necklace" || 
				data["Type"] == "Belt" || data["Type"] == "Bracelet") 
				{
					var equip:FishEquipment = new FishEquipment();
					equip.SetInfo(data);
					equip.seller = seller;
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(e.stageX, e.stageY, equip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
				}
				else if (tooltipFish != null)
				{
					ActiveTooltip.getInstance().showNewToolTip(tooltipFish, itemImage.img);
				}
			}
		}
		
		public function get cost():Number 
		{
			return _cost;
		}
		
		public function set cost(value:Number):void 
		{
			_cost = value;
			textFieldCost.text = Ultility.StandardNumber(value);
		}
		
		public function get time():Number 
		{
			return _time;
		}
		
		public function set time(value:Number):void 
		{
			_time = value;
			textFieldTime.text = "Còn: " + Ultility.ConvertTimeToString(value);
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
			textFieldName.text = value;
		}
		
		public function get num():int 
		{
			return _num;
		}
		
		public function set num(value:int):void 
		{
			_num = value;
			labelNum.text = "x" + Ultility.StandardNumber(value);
			img.setChildIndex(labelNum, img.numChildren - 1);
		}
	}

}