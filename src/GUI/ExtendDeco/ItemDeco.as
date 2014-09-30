package GUI.ExtendDeco 
{
	import com.greensock.events.LoaderEvent;
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.Decorate;
	import Logic.GameLogic;
	import Logic.GameState;
	import NetworkPacket.PacketSend.ExtendDeco.SendExtendDeco;
	
	/**
	 * Item trong danh sách gia hạn
	 * @author dongtq
	 */
	public class ItemDeco extends Container 
	{
		private const BTN_EXTEND:String = "BtnExtend";
		private var itemImage:Image;
		private var _itemName:String;//Tên hiển thị
		public var sortName:String;//Tên dùng để sắp xếp
		private var _remainTime:Number;//Thời gian còn lại
		public var extendTime:int;//Thời gian gia hạn mới
		private var _cost:int;
		private var buttonExtend:Button;
		private var _index:int;
		private var textFieldCost:TextField;
		private var textFieldTime:TextField;
		private var textFieldIndex:TextField;
		private var textFieldName:TextField;
		private var textFieldDisappear:TextField;
		
		public var itemType:String;
		public var id:int;
		public var lakeId:int;
		
		public function ItemDeco(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, "GuiExtendDeco_ItemDecoBg", x, y, isLinkAge, imgAlign);
			buttonExtend = AddButton(BTN_EXTEND, "GuiExtendDeco_Btn_G", 450, 60);
			var txtFormat:TextFormat = new TextFormat("arial", 18, 0xffffff, true);
			txtFormat.align = "center";
			textFieldCost = AddLabel("3", 440, 65);
			textFieldCost.defaultTextFormat = txtFormat;
			
			textFieldIndex = AddLabel("1", -13, 72);
			textFieldIndex.defaultTextFormat = txtFormat;
			
			textFieldName = AddLabel("Name", 75, 85);
			textFieldName.defaultTextFormat = txtFormat;
			
			textFieldTime = AddLabel("20 ngày", 305 - 50, 38);
			txtFormat = new TextFormat("arial", 18, 0x1283a0, true);
			textFieldTime.defaultTextFormat = txtFormat;
			
			textFieldDisappear = AddLabel("Còn 7 ngày biến mất", 275, 85, 0x1283a0, 1, 0xa9ecff);
			//txtFormat.color = 0xff0000;
			//txtFormat.size = 11;
			//textFieldDisappear.defaultTextFormat = txtFormat;
		}
		
		public function initItem(itemType:String, itemId:int, expiredTime:int, _lakeId:int, _id:int):void
		{
			itemImage = AddImage("", itemType + itemId.toString(), 160, 100);
			itemImage.FitRect(130, 85, new Point(63, -2));
			if (itemType == "OceanAnimal")
			{
				itemImage.GoToAndStop(2);
			}
			
			var config:Object = ConfigJSON.getInstance().getItemInfo(itemType, itemId);
			this.itemType = itemType;
			lakeId = _lakeId;
			id = _id;
			itemName = config["Name"];
			extendTime = config["TimeUse"];
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			remainTime = expiredTime - curTime;
			this.cost = Math.ceil(config["ZMoney"] / 2);
			
			var tooltip:TooltipFormat = new TooltipFormat();
			//tooltip.htmlText = "Giá mua mới: <font color='#ff0000'>" + config["ZMoney"] + " G</font>\nThời hạn sử dụng: <font color='#ff0000'>" + int(extendTime / (24 * 3600)) + " ngày</font>";
			if (lakeId == 0)
			{
				tooltip.htmlText = "Giá mua mới: <font color='#ff0000'>" + config["ZMoney"] + " G</font>\nThời hạn sử dụng: <font color='#ff0000'>" + int(extendTime / (24 * 3600)) + " ngày </font>\nĐồ vật trong túi đồ";//\n Còn " + Math.floor((7*24*3600 +remainTime)/(24*3600)) + " ngày biến mất";
				//tooltip.htmlText += "\nĐồ vật trong túi đồ";
			}
			else
			{
				tooltip.htmlText = "Giá mua mới: <font color='#ff0000'>" + config["ZMoney"] + " G</font>\nThời hạn sử dụng: <font color='#ff0000'>" + int(extendTime / (24 * 3600)) + " ngày </font>\nĐồ vật trong hồ " + lakeId;// + "\n Còn " + Math.floor((7 * 24 * 3600 +remainTime) / (24 * 3600)) + " ngày biến mất";;
				//tooltip.htmlText += "\nĐồ vật trong hồ " + lakeId; 
			}
			this.setTooltip(tooltip);
			
			if (canExtend())
			{
				buttonExtend.SetEnable(true);
			}
			else
			{
				buttonExtend.SetEnable(false);
			}
		}
		
		public function get cost():int 
		{
			return _cost;
		}
		
		public function set cost(value:int):void 
		{
			_cost = value;
			textFieldCost.text = value.toString();
		}
		
		public function get remainTime():Number 
		{
			return _remainTime;
		}
		
		public function set remainTime(value:Number):void 
		{
			_remainTime = value;
			if(value >= 0)
			{
				textFieldTime.htmlText = "Còn lại: <font color = '#ff0000'>" + Math.ceil(value / (24 * 3600)).toString() + " ngày</font>";
				textFieldDisappear.text = "";
			}
			else
			{
				textFieldTime.htmlText = "Còn lại: <font color = '#ff0000'>0 ngày</font>";
				textFieldDisappear.htmlText = "Còn <font color = '#ff0000'>" + getDate(7 * 24 * 3600 + remainTime) + "</font> biến mất";// Math.ceil((7 * 24 * 3600 + remainTime) / (24 * 3600)) + " ngày biến mất";
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
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (cost <= GameLogic.getInstance().user.GetZMoney())
			{
				var sendExtendDeco:SendExtendDeco = new SendExtendDeco();
				sendExtendDeco.addItem(itemType, id, lakeId);
				Exchange.GetInstance().Send(sendExtendDeco);
				GameLogic.getInstance().user.UpdateUserZMoney( -cost);
				extendItem();
				//Ẩn gui store
				GuiMgr.getInstance().GuiStore.Hide();
				GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
				
				GuiMgr.getInstance().guiExtendDeco.updateCost();
			}
			else
			{
				GuiMgr.getInstance().GuiNapG.Init();
			}
		}
		
		public function extendItem():void
		{
			if (remainTime <= 0)
			{
				remainTime = extendTime;
			}
			else
			{
				remainTime += extendTime;
			}
			buttonExtend.SetEnable(false);
			
			//Cập nhật đồ trang trí trên hồ
			if (lakeId != 0)
			{
				var decoArr:Array = GameLogic.getInstance().user.GetDecoArr();
				for each(var deco:Decorate in decoArr)
				{
					if (deco.Id == id)
					{
						deco.expiredTime = GameLogic.getInstance().CurServerTime + remainTime;
						deco.hideButtonExtend();
					}
				}
				
				var item:Object = GameLogic.getInstance().user.item;
				for each(var obj:Object in item)
				{
					if(obj["Id"] == id)
					{
						obj["ExpiredTime"] = GameLogic.getInstance().CurServerTime + remainTime;
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
			if (remainTime >= Constant.TIME_CAN_EXTEND)
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
	}

}