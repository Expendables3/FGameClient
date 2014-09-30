package GUI.ExtendDeco 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ListBox;
	import GUI.component.ScrollBar;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.GameState;
	import NetworkPacket.PacketReceive.GetLoadInventory;
	import NetworkPacket.PacketSend.ExtendDeco.SendExpiredDeco;
	import NetworkPacket.PacketSend.ExtendDeco.SendExtendDeco;
	
	/**
	 * GUI gia hạn đồ trang trí
	 * @author dongtq
	 */
	public class GUIExtendDeco extends BaseGUI 
	{
		private const BTN_CLOSE:String = "BtnClose";
		private const BTN_EXTEND:String = "BtnExtend";
		private const BTN_TAB_NAME:String = "BtnTabName";
		private const BTN_TAB_TIME:String = "BtnTabTime";
		private const BTN_TAB_EXTEND:String = "BtnTabExtend";
		
		private const PROPERTY_NAME:String = "sortName";//Thuộc tính tên để sắp xếp trong ItemDeco
		private const PROPERTY_TIME:String = "remainTime";//Thuộc tính thời gian để sắp xếp trong ItemDeco
		private const PROPERTY_COST:String = "cost";//Thuộc tính giá gia hạn để sắp xếp trong ItemDeco
		
		private var buttonClose:Button;
		private var buttonExtend:Button;
		private var buttonTabName:Button;
		private var buttonTabTime:Button;
		private var buttonTabExtend:Button;
		
		private var labelExtend:TextField;
		private var _costExtend:int;//Giá gia hạn toàn bộ
		private var listBoxDeco:ListBox;
		private var scrollBar:ScrollBar;
		
		private var increaseName:Boolean;//Lưu lựa chọn sắp xếp tăng dần hay giảm dần theo tên
		private var increaseTime:Boolean;//Lưu lựa chọn sắp xếp tăng dần hay giảm dần theo thời gian
		private var increaseCost:Boolean;//Lưu lựa chọn sắp xếp tăng dần hay giảm dần theo giá gia hạn
		
		private var id:int;
		
		public function GUIExtendDeco(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				buttonClose = AddButton(BTN_CLOSE, "BtnThoat", 705, 20);	
				
				buttonTabName = AddButton(BTN_TAB_NAME, "GuiExtendDeco_Btn_Tab_Name", 54, 78);
				buttonTabTime = AddButton(BTN_TAB_TIME, "GuiExtendDeco_Btn_Tab_Time", 282, 78);
				buttonTabExtend = AddButton(BTN_TAB_EXTEND, "GuiExtendDeco_Btn_Tab_Extend", 480, 78);
				
				buttonExtend = AddButton(BTN_EXTEND, "GuiExtendDeco_Btn_G", 510, 523);
				labelExtend = AddLabel("cost", 490, 525);
				var txtFormat:TextFormat = new TextFormat("arial", 18, 0xffffff, true);
				labelExtend.defaultTextFormat = txtFormat;
				costExtend = 100;
				SetPos(50, 20);
				
				listBoxDeco = new ListBox(ListBox.LIST_Y, 3, 1);
				scrollBar = AddScroll("", "GuiExtendDeco_ScrollBarExtendDeco", 670, 90);
				scrollBar.setScrollImage(listBoxDeco.img, 0, 360);
				initData();
				listBoxDeco.x = 65;
				listBoxDeco.y = 125;
				
				this.img.addChild(listBoxDeco);
				
				increaseName = false;
				increaseTime = true;
				increaseName = false;
				
				if (id != -1)
				{
					focusToId(id);
				}
			}
			LoadRes("GuiExtendDeco_Theme");
		}
		
		/**
		 * Khởi tạo dữ liệu
		 */
		public function initData():void
		{
			var data:Array = [];
			var stockThing:GetLoadInventory = GameLogic.getInstance().user.StockThingsArr;
			/*data = data.concat(stockThing["Other"]);
			data = data.concat(stockThing["OceanAnimal"]);
			data = data.concat(stockThing["OceanTree"]);
			data = data.concat(stockThing["BackGround"]);*/
			data = GameLogic.getInstance().user.GetStore("Decorate");
			
			//Thêm thuộc tính đánh dấu deco ở túi đồ
			var obj:Object;
			for each(obj in data)
			{
				obj["lakeId"] = 0;
			}
			
			var dataInLake:Array = [];
			dataInLake = dataInLake.concat(GameLogic.getInstance().user.item);
			
			//Thêm thuộc tính đánh dấu ở hồ cho deco
			var lakeId:int = GameLogic.getInstance().user.CurLake.Id;
			for each(obj in dataInLake)
			{
				obj["lakeId"] = lakeId;
			}
			data = data.concat(dataInLake);
			
			//Lọc dữ liệu để gia hạn
			filterData(data);
			
			var numExtendItem:int = 0;
			for (var i:int = 0; i < data.length; i++)
			{
				var itemDeco:ItemDeco = new ItemDeco(listBoxDeco);
				itemDeco.initItem(data[i]["ItemType"], data[i]["ItemId"], data[i]["ExpiredTime"], data[i]["lakeId"], data[i]["Id"]);
				itemDeco.index = i + 1;
				listBoxDeco.addItem(itemDeco.index.toString(), itemDeco);
				if (itemDeco.canExtend())
				{
					numExtendItem++;
				}
			}
			if (data.length <= 3)
			{
				scrollBar.visible = false;
			}
			else
			{
				scrollBar.visible = true;
			}
			
			//update giá gia hạn toàn bộ
			updateCost();
			//sortData(PROPERTY_TIME, true);
			smartSortData();
		}
		
		/**
		 * Loại deco hết hạn 7 ngày và chưa đến hạn 6 ngày
		 * @param	data
		 */
		private function filterData(data:Array):void
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			for (var i:int = 0; i < data.length; i++)
			{
				//Qúa thời gian gia hạn hoặc chưa đến thời gian gia hạn
				if (data[i]["ItemType"] != "BackGround" || (data[i]["ExpiredTime"] + Constant.TIME_DISAPPEAR - 60) < curTime || data[i]["ExpiredTime"] > (curTime + Constant.TIME_CAN_EXTEND))
				{
					data.splice(i, 1);
					i--;
				}
			}
		}
		
		/**
		 * ShowGUI và focus vào item có id
		 * @param	id = -1 thì showGUI theo sắp xếp mặc định (smartSortData)
		 */
		public function showGUI(id:int = -1):void
		{
			this.id = id;
			GameLogic.getInstance().SaveEditDecorate();
			Show(Constant.GUI_MIN_LAYER, 10);
		}
		
		/**
		 * hightlight deco theo id trong danh sách
		 * @param	id
		 */
		private function focusToId(id:int):void
		{
			if (id != -1)
			{
				var arr:Array = listBoxDeco.itemList;
				var index:int;
				for each(var itemDeco:ItemDeco in arr)
				{
					if (itemDeco.id == id)
					{
						index = itemDeco.index;
						itemDeco.SetHighLight(0xff0000);
					}
				}
				
				var dy:Number = (scrollBar.bar.height -scrollBar.getBtnBarHeight())  * ((index -1) / (listBoxDeco.numItem));
				scrollBar.setScrollPos(30 + dy);
				listBoxDeco.showItem(index - 1);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_EXTEND:
					if (costExtend <= GameLogic.getInstance().user.GetZMoney())
					{
						GuiMgr.getInstance().GuiStore.Hide();
						GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
						
						var sendExtendDeco:SendExtendDeco = new SendExtendDeco();
						for each(var itemDeco:ItemDeco in listBoxDeco.itemList)
						{
							if(itemDeco.canExtend())
							{
								sendExtendDeco.addItem(itemDeco.itemType, itemDeco.id, itemDeco.lakeId);
								itemDeco.extendItem();
							}
						}
						Exchange.GetInstance().Send(sendExtendDeco);
						
						buttonExtend.SetEnable(false);
						GameLogic.getInstance().user.UpdateUserZMoney( -costExtend);
					}
					else
					{
						GuiMgr.getInstance().GuiNapG.Init();
					}
					break;
				case BTN_TAB_NAME:
					//Sắp xếp theo tên
					increaseName = !increaseName;
					sortData(PROPERTY_NAME, increaseName);
					break;
				case BTN_TAB_TIME:
					//Sắp xếp theo thời gian
					increaseTime = !increaseTime;
					sortData(PROPERTY_TIME, increaseTime);
					break;
				case BTN_TAB_EXTEND:
					//Sắp xếp theo giá gia hạn
					increaseCost = !increaseCost;
					sortData(PROPERTY_COST, increaseCost);
					break;
			}
		}
		
		public function get costExtend():int 
		{
			return _costExtend;
		}
		
		public function set costExtend(value:int):void 
		{
			_costExtend = value;
			labelExtend.text = value.toString();
		}
		
		/**
		 * Sắp xếp tăng dần 1 mảng
		 * @param	arr
		 */
		private function sortIncreate(arr:Array, typeProperty:String):Array
		{
			for (var i:int = 0; i < arr.length; i++)
			{
				for (var j:int = arr.length - 1; j > i ; j--)
				{
					if (arr[j][typeProperty] > arr[i][typeProperty])
					{
						var temp:Object = arr[i];
						arr[i] = arr[j];
						arr[j] = temp;
					}
				}
			}
			return arr;
		}
		
		/**
		 * Sắp xếp dữ liệu
		 * @param	type: loại thuộc tính gồm thời gian, tên, giá gia hạn
		 * @param	increase: sắp xếp tăng dần hoặc giảm dần
		 */
		private function sortData(type:String, increase:Boolean):void
		{
			var arr:Array = new Array();
			arr = listBoxDeco.itemList.splice(0, listBoxDeco.itemList.length);
			listBoxDeco.removeAllItem();
			arr = sortIncreate(arr, type);
			if (increase)
			{
				for (var i:int = 0; i < arr.length; i++)
				{
					ItemDeco(arr[i]).index = i +1;
					listBoxDeco.addItem(i.toString(), arr[i]);
				}
			}
			else
			{
				for (var j:int = arr.length -1 ; j >= 0; j--)
				{
					ItemDeco(arr[j]).index = arr.length - j;
					listBoxDeco.addItem((arr.length - j).toString(), arr[j]);
				}
			}
			scrollBar.setPercent(0, true);
		}
		
		/**
		 * update giá gia hạn toàn bộ
		 */
		public function updateCost():void
		{
			var numExtendItem:int = 0;
			costExtend = 0;
			for each(var itemDeco:ItemDeco in listBoxDeco.itemList)
			{
				if (itemDeco.canExtend())
				{
					costExtend += itemDeco.cost;
					numExtendItem ++;
				}
			}
			
			//Kiểm tra đc gia hạn toàn bộ hay không
			if(numExtendItem >= Constant.NUM_CAN_EXTEND_ALL)
			{
				costExtend = Math.ceil(costExtend * 0.8);
				buttonExtend.setTooltip(null);
			}
			else
			{
				buttonExtend.SetEnable(false);
				var tooltip:TooltipFormat = new TooltipFormat();
				tooltip.text = "Từ 5 đồ trở lên \nmới được gia hạn toàn bộ";
				buttonExtend.setTooltip(tooltip);
			}
		}
		
		/**
		 * Sắp xếp deco sắp hết hạn trc rồi mới đến deco hết hạn(mặc định khi showGUI)
		 */
		private function smartSortData():void
		{
			var arr:Array = new Array();
			arr = listBoxDeco.itemList.splice(0, listBoxDeco.itemList.length);
			listBoxDeco.removeAllItem();
			var arr1:Array = [];
			var arr2:Array = [];
			var i:int = 0;
			var j:int = 0;
			var temp:Object;
			for (i = 0; i < arr.length; i++)
			{
				if (arr[i][PROPERTY_TIME] > 0)
				{
					arr1.push(arr[i]);
				}
				else
				{
					arr2.push(arr[i]);
				}
			}
			
			for (i = 0; i < arr1.length; i++)
			{
				for (j = arr1.length -1; j > i ; j--)
				{
					if (arr1[j][PROPERTY_TIME] < arr1[i][PROPERTY_TIME])
					{
						temp = arr1[i];
						arr1[i] = arr1[j];
						arr1[j] = temp;
					}
				}
			}
			
			for (i = 0; i < arr2.length; i++)
			{
				for (j = arr2.length -1; j > i; j--)
				{
					if (arr2[j][PROPERTY_TIME] < arr2[i][PROPERTY_TIME])
					{
						temp = arr2[i];
						arr2[i] = arr2[j];
						arr2[j] = temp;
					}
				}
			}
			
			for (i = 0; i < arr1.length; i++)
			{
				ItemDeco(arr1[i]).index = i +1;
				listBoxDeco.addItem(i.toString(), arr1[i]);
			}
			
			for (i = 0; i < arr2.length; i++)
			{
				ItemDeco(arr2[i]).index = i +1 + arr1.length;
				listBoxDeco.addItem((i + arr1.length).toString(), arr2[i]);
			}
			scrollBar.setPercent(0, true);
		}
	}

}