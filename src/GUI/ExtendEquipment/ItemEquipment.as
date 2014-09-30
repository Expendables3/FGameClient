package GUI.ExtendEquipment 
{
	import adobe.utils.ProductManager;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.JointStyle;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import GUI.FishWar.FishEquipment;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Ultility;
	import NetworkPacket.PacketReceive.GetLoadInventory;
	import NetworkPacket.PacketSend.SendExtendEquipment;
	import NetworkPacket.PacketSend.SendExtendEquipment;
	
	/**
	 * ...
	 * @author longpt ft dongtq
	 */
	public class ItemEquipment extends Container 
	{
		static public const BTN_EXTEND_DIAMOND:String = "btnExtendDiamond";
		private const BTN_EXTEND_ZMONEY:String = "BtnExtend_ZMoney";
		private const BTN_EXTEND_MONEY:String = "BtnExtend_Money";
		private var itemImage:Image;
		private var _itemName:String;//Tên hiển thị
		public var sortName:String;//Tên dùng để sắp xếp
		private var _remainDurability:Number;//Thời gian còn lại
		public var NewDurability:int;//Thời gian gia hạn mới
		private var _costZMoney:int;
		private var _costMoney:int;
		private var buttonExtendZMoney:Button;
		private var buttonExtendMoney:Button;
		private var _index:int;
		private var textFieldCostZMoney:TextField;
		private var textFieldCostMoney:TextField;
		private var textFieldTime:TextField;
		private var textFieldIndex:TextField;
		private var textFieldName:TextField;
		private var textFieldDisappear:TextField;
		private var _costDiamond:int;
		private var labelCostDiamond:TextField;
		private var btnDiamond:Button;
		
		public var itemType:String;
		public var itemId:int;
		public var fishId:int;
		public var lakeId:int;
		
		public var itemInfo:FishEquipment;
		
		public function ItemEquipment(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, "GuiExtendEquipment_ItemEquipBg", x, y, isLinkAge, imgAlign);
			
			buttonExtendZMoney = AddButton(BTN_EXTEND_ZMONEY, "GuiExtendEquipment_BtnBuyXu", 450, 65);
			buttonExtendZMoney.img.scaleX = buttonExtendZMoney.img.scaleY = 1.4;
			var txtFormat:TextFormat = new TextFormat("arial", 18, 0xffffff, true);
			txtFormat.align = "center";
			textFieldCostZMoney = AddLabel("3", 440, 67);
			textFieldCostZMoney.defaultTextFormat = txtFormat;
			
			buttonExtendMoney = AddButton(BTN_EXTEND_MONEY, "GuiExtendEquipment_BtnBuyGold", 450, 40);
			buttonExtendMoney.img.scaleX = buttonExtendMoney.img.scaleY = 1.4;
			txtFormat = new TextFormat("arial", 18, 0xffffff, true);
			txtFormat.align = "center";
			textFieldCostMoney = AddLabel("3", 440, 42);
			textFieldCostMoney.defaultTextFormat = txtFormat;
			
			btnDiamond = AddButton(BTN_EXTEND_DIAMOND, "GuiExtendEquipment_BtnDiamon", 450, 15);
			btnDiamond.img.scaleX = btnDiamond.img.scaleY = 1.4;
			labelCostDiamond = AddLabel("", 440, 17);
			labelCostDiamond.defaultTextFormat = txtFormat;
			
			textFieldIndex = AddLabel("1", -13, 72);
			textFieldIndex.defaultTextFormat = txtFormat;
			
			textFieldName = AddLabel("Name", 75, 85);
			txtFormat.size = 14;
			textFieldName.defaultTextFormat = txtFormat;
			
			textFieldTime = AddLabel("20 ngày", 305 - 50, 38);
			txtFormat = new TextFormat("arial", 18, 0x1283a0, true);
			textFieldTime.defaultTextFormat = txtFormat;
			
			textFieldDisappear = AddLabel("Còn 7 ngày biến mất", 275, 85, 0x1283a0, 1, 0xa9ecff);
			//txtFormat.color = 0xff0000;
			//txtFormat.size = 11;
			//textFieldDisappear.defaultTextFormat = txtFormat;
		}
		
		public function initItem(item:FishEquipment, enchant:int, itemType:String, itemId:String, itemName:String, remain:Number, id:int, fId:int = 0, lId:int = 0):void
		{
			/*if (itemType == "QWhite" || itemType == "QGreen" || itemType == "QYellow" || itemType == "QPurple")
			{
				return;
			}*/
			itemInfo = item;
			// Add nền nếu là đồ quý, đặc biệt...
			//var ctn:Container = AddContainer("ItemContainer", FishEquipment.GetBackgroundName(int(itemId.split("$")[1])), 93, 6, true, this);
			var ctn:Container = AddContainer("ItemContainer", "ImgFrameFriend", 93, 6, true, this);
			ctn.AddImage("", FishEquipment.GetBackgroundName(int(itemId.split("$")[1])), 0, 0, true, ALIGN_LEFT_TOP, true);
			
			itemImage = ctn.AddImage("", itemName + "_Shop", 0, 0, true, ALIGN_CENTER_CENTER, false, function f():void { this.FitRect(60, 60, new Point(7, 7)); FishSoldier.EquipmentEffect(this.img, int(itemId.split("$")[1])) });
			if (enchant > 0)
			{
				var txt:TextField = ctn.AddLabel("+" + enchant, 2, 2, 0xFFF100, 0, 0x603813);
				var tF:TextFormat = new TextFormat();
				tF.size = 18;
				tF.bold = true;
				txt.setTextFormat(tF);
			}
			//var config:Object = ConfigJSON.getInstance().GetItemInfo(itemType, itemId);
			var config:Object = ConfigJSON.getInstance().GetEquipmentInfo(itemType, itemId);
			
			this.itemType = itemType;
			this.itemId = id;
			//itemName = config["Name"];
			itemName = Localization.getInstance().getString(itemType + itemId.split("$")[0]);
			textFieldName.text = itemName;
			sortName = filterVietnameseCharacter(itemName);
			
			NewDurability = config.Durability;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			RemainDurability = Math.ceil(remain);
			
			fishId = fId;
			lakeId = lId;
			
			// Config giá tiền
			var cost:Object = ConfigJSON.getInstance().getItemInfo("Equipment_Extend", -1)[itemType][itemId.split("$")[1]];
			var DurExtend:int = NewDurability - RemainDurability;
			for (var s:String in cost)
			{
				if (cost[s]["Durability"]["Max"] >= DurExtend && cost[s]["Durability"]["Min"] <= DurExtend)
				{
					this.costZMoney = cost[s]["ZMoney"];
					this.costMoney = cost[s]["Money"];
					this.costDiamond = cost[s]["Diamond"];
					break;
				}
			}
			
			if (canExtend())
			{
				buttonExtendZMoney.SetEnable(true);
				buttonExtendMoney.SetEnable(true);
			}
			else
			{
				buttonExtendZMoney.SetEnable(false);
				buttonExtendMoney.SetEnable(false);
			}
			
			if (costZMoney <= 0)	
			buttonExtendZMoney.SetEnable(false);
			if (costMoney <= 0)		
			buttonExtendMoney.SetEnable(false);
		}
		
		public function get costZMoney():int 
		{
			return _costZMoney;
		}
		
		public function set costZMoney(value:int):void 
		{
			_costZMoney = value;
			textFieldCostZMoney.text = Ultility.StandardNumber(value);
			if (value <= 0)
			{
				textFieldCostZMoney.visible = false;
				GetButton(BTN_EXTEND_ZMONEY).SetVisible(false);
			}
			else
			{
				textFieldCostZMoney.visible = true;
				GetButton(BTN_EXTEND_ZMONEY).SetVisible(true);
			}
		}
		
		public function get costMoney():int
		{
			return _costMoney;
		}
		
		public function set costMoney(value:int):void
		{
			_costMoney = value;
			textFieldCostMoney.text = Ultility.StandardNumber(value);
			if (value <= 0)
			{
				textFieldCostMoney.visible = false;
				GetButton(BTN_EXTEND_MONEY).SetVisible(false);
			}
			else
			{
				textFieldCostMoney.visible = true;
				GetButton(BTN_EXTEND_MONEY).SetVisible(true);
			}
		}
		
		public function get RemainDurability():Number 
		{
			return _remainDurability;
		}
		
		public function set RemainDurability(value:Number):void 
		{
			_remainDurability = value;
			if(value >= 0)
			{
				textFieldTime.htmlText = "Độ bền: <font color = '#ff0000'>" + value + "/" + NewDurability + "</font>";
				textFieldDisappear.text = "";
			}
			else
			{
				textFieldTime.htmlText = "Độ bền: <font color = '#ff0000'> 0/" + NewDurability + "</font>";
				//textFieldDisappear.htmlText = "Còn <font color = '#ff0000'>" + getDate(7 * 24 * 3600 + RemainDurability) + "</font> biến mất";// Math.ceil((7 * 24 * 3600 + remainTime) / (24 * 3600)) + " ngày biến mất";
			}
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
			textFieldIndex.text = value.toString();
		}
		
		public function get itemName():String 
		{
			return _itemName;
		}
		
		public function set itemName(value:String):void 
		{
			_itemName = value;
			textFieldName.text = value;
			sortName = filterVietnameseCharacter(value);
		}
		
		public function get costDiamond():int 
		{
			return _costDiamond;
		}
		
		public function set costDiamond(value:int):void 
		{
			_costDiamond = value;
			labelCostDiamond.text = Ultility.StandardNumber(value);
			if (value <= 0)
			{
				labelCostDiamond.visible = false;
				GetButton(BTN_EXTEND_DIAMOND).SetVisible(false);
			}
			else
			{
				labelCostDiamond.visible = true;
				GetButton(BTN_EXTEND_DIAMOND).SetVisible(true);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var sendExtendEquip:SendExtendEquipment;
			switch(buttonID)
			{
				case BTN_EXTEND_MONEY:
					if (costMoney <= GameLogic.getInstance().user.GetMoney())
					{
						sendExtendEquip = new SendExtendEquipment(itemType, itemId,  "Money", fishId, lakeId);
						Exchange.GetInstance().Send(sendExtendEquip);
						
						GameLogic.getInstance().user.UpdateUserMoney( -costMoney);
						extendItem();
						
						//Ẩn gui store
						GuiMgr.getInstance().GuiStore.Hide();
						GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
					}
					else
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không đủ tiền!", 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					}
					break;
				case BTN_EXTEND_ZMONEY:
					if (costZMoney <= GameLogic.getInstance().user.GetZMoney())
					{
						sendExtendEquip = new SendExtendEquipment(itemType, itemId,  "ZMoney", fishId, lakeId);
						Exchange.GetInstance().Send(sendExtendEquip);
						
						GameLogic.getInstance().user.UpdateUserZMoney( -costZMoney);
						extendItem();
						//Ẩn gui store
						GuiMgr.getInstance().GuiStore.Hide();
						GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
					}
					else
					{
						GuiMgr.getInstance().GuiNapG.Init();
					}
					break;
				case BTN_EXTEND_DIAMOND:
					if (costDiamond <= GameLogic.getInstance().user.getDiamond())
					{
						sendExtendEquip = new SendExtendEquipment(itemType, itemId,  "Diamond", fishId, lakeId);
						Exchange.GetInstance().Send(sendExtendEquip);
						
						GameLogic.getInstance().user.updateDiamond( -costDiamond);
						extendItem();
						//Ẩn gui store
						GuiMgr.getInstance().GuiStore.Hide();
						GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
					}
					else
					{
						GuiMgr.getInstance().guiNoDiamond.Show(Constant.GUI_MIN_LAYER, 3);
					}
					break;
			}
		}
		
		public function extendItem():void
		{
			RemainDurability = NewDurability;
			
			buttonExtendZMoney.SetEnable(false);
			buttonExtendMoney.SetEnable(false);
			btnDiamond.SetEnable(false);
			
			// Cập nhật thông tin vào item
			var stockThing:GetLoadInventory = GameLogic.getInstance().user.StockThingsArr;
			var data:Array = [];
			data = data.concat(stockThing[itemType]);
			
			if (fishId == 0)
			{
				// Đồ trong kho
				for each(var eq:FishEquipment in data)
				{
					if (eq.Id == itemId)
					{
						isFind = true;
						eq.Durability = NewDurability;
						break;
					}
				}
			}
			else
			{
				// Đồ này mặc trên người cá
				var f:FishSoldier;
				var i:int;
				var j:int;
				var k:int;
				var isFind:Boolean = false;
				var fArr:Array = GameLogic.getInstance().user.GetFishSoldierArr();
				for (i = 0; i < fArr.length; i++)
				{
					if (fArr[i].Id == fishId)
					{
						for (j = 0; j < fArr[i].EquipmentList[itemType].length; j++)
						{
							if (fArr[i].EquipmentList[itemType][j].Id == itemId)
							{
								isFind = true;
								fArr[i].EquipmentList[itemType][j].Durability = NewDurability;
								f = fArr[i];
								break;
							}
						}
						
						if (isFind)	break;
					}
				}
				
				fArr = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
				if (f)
				for (k = 0; k < fArr.length; k++)
				{
					if (fArr[k].Id == f.Id)
					{
						fArr[k].EquipmentList[itemType][j].Durability = NewDurability;
						break;
					}
				}
			}
		}
		
		/**
		 * Chuyển thành chữ không dấu để sắp xếp
		 * @param	value
		 * @param	toLowerCase
		 * @return
		 */
		private function filterVietnameseCharacter(value:String, toLowerCase:Boolean = true):String {
			var _value:String = value;
			if(toLowerCase)_value = value.toLowerCase();
			_value = _value.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g,"a");  
			_value = _value.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g,"e");  
			_value = _value.replace(/ì|í|ị|ỉ|ĩ/g,"i");  
			_value = _value.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g,"o");  
			_value = _value.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g,"u");  
			_value = _value.replace(/ỳ|ý|ỵ|ỷ|ỹ/g,"y");  
			_value = _value.replace(/đ/g, "d");
			//trace(_value);
			return _value;
		}
		
		public function canExtend():Boolean
		{
			if (RemainDurability >= Constant.DAY_TO_EXTEND * 24 * 60 * 60)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * Chuyển giây thành ngày giờ phút
		 * @param	remainSecond
		 * @return
		 */
		private function getDate(remainSecond:Number):String
		{
			var day:int = Math.floor(remainSecond / (24 * 3600));
			var hour:int = Math.floor((remainSecond - day * 24 * 3600) / (3600));
			var minute:int = Math.floor((remainSecond - day * 24 * 3600 - hour * 3600) / (60));
			var result:String = "";
			if (day != 0)
			{
				result += day + " ngày ";
			}
			if (hour != 0)
			{
				result += hour + " giờ ";
			}
			if (minute != 0)
			{
				result += minute + " phút";
			}
			if (day + hour + minute == 0)
			{
				result = "0 phút";
			}
			return result;
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			if (buttonID == "ItemContainer")
			{
				if (!GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
				{
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, itemInfo, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
				}
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (buttonID == "ItemContainer")
			{
				if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
				{
					GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				}
			}
		}
	}

}