package GUI.ExtendEquipment 
{
	import com.adobe.utils.IntUtil;
	import Data.Config;
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ScrollBar;
	import GUI.component.TooltipFormat;
	import GUI.ExtendDeco.ItemDeco;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import GUI.FishWar.FishEquipment;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameState;
	import NetworkPacket.PacketReceive.GetLoadInventory;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import NetworkPacket.PacketSend.SendExtendEquipment;
	
	/**
	 * GUI gia hạn đồ cá lính
	 * @author longpt ft dongtq
	 */
	public class GUIExtendEquipment extends BaseGUI 
	{
		private const BTN_CLOSE:String = "BtnClose";
		private const BTN_EXTEND_ZMONEY:String = "BtnExtend_ZMoney";
		private const BTN_EXTEND_MONEY:String = "BtnExtend_Money";
		private const BTN_TAB_NAME:String = "BtnTabName";
		private const BTN_TAB_TIME:String = "BtnTabTime";
		private const BTN_TAB_EXTEND:String = "BtnTabExtend";
		
		private const PROPERTY_NAME:String = "sortName";			//Thuộc tính tên để sắp xếp trong Equip
		private const PROPERTY_TIME:String = "RemainDurability";			//Thuộc tính thời gian để sắp xếp trong Equip
		private const PROPERTY_COST:String = "costZMoney";			//Thuộc tính giá gia hạn để sắp xếp trong Equip
		
		private var buttonClose:Button;
		private var buttonExtendZMoney:Button;
		private var buttonExtendMoney:Button;
		private var buttonTabName:Button;
		private var buttonTabTime:Button;
		private var buttonTabExtend:Button;
		
		private var listBoxEquip:ListBox;
		private var scrollBar:ScrollBar;
		
		private var increaseName:Boolean;//Lưu lựa chọn sắp xếp tăng dần hay giảm dần theo tên
		private var increaseTime:Boolean;//Lưu lựa chọn sắp xếp tăng dần hay giảm dần theo thời gian
		private var increaseCost:Boolean;//Lưu lựa chọn sắp xếp tăng dần hay giảm dần theo giá gia hạn
		
		private var numItemInFishes:int;
		
		public function GUIExtendEquipment(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIExtendEquipment";
		}
		
		public override function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(35, 15);
				
				buttonClose = AddButton(BTN_CLOSE, "BtnThoat", 705, 20);	
				
				buttonTabName = AddButton(BTN_TAB_NAME, "GuiExtendEquipment_Btn_Tab_Name_Equipment", 54, 78);
				buttonTabTime = AddButton(BTN_TAB_TIME, "GuiExtendEquipment_Btn_Tab_Time_Equipment", 282, 78);
				buttonTabExtend = AddButton(BTN_TAB_EXTEND, "GuiExtendEquipment_Btn_Tab_Extend_Equipment", 480, 78);		
				
				listBoxEquip = new ListBox(ListBox.LIST_Y, 3, 1);
				scrollBar = AddScroll("", "GuiExtendEquipment_ScrollBarExtendDeco", 670, 90);
				
				initData();
				listBoxEquip.x = 65;
				listBoxEquip.y = 125;
				
				scrollBar.setScrollImage(listBoxEquip.img, 0, 360);
				
				this.img.addChild(listBoxEquip);
				
				increaseName = false;
				increaseTime = true;
				increaseName = false;
			}
			
			LoadRes("GuiExtendEquipment_Theme");
		}
		
		/**
		 * Khởi tạo dữ liệu
		 */
		public function initData():void
		{
			var data:Array = [];
			
			// Lấy cả đồ trên người con cá
			data = data.concat(getFishEquips());
			numItemInFishes = data.length;
			
			var stockThing:GetLoadInventory = GameLogic.getInstance().user.StockThingsArr;
			data = data.concat(stockThing["Helmet"]);
			data = data.concat(stockThing["Armor"]);
			data = data.concat(stockThing["Weapon"]);
			data = data.concat(stockThing["Belt"]);
			data = data.concat(stockThing["Bracelet"]);
			data = data.concat(stockThing["Ring"]);
			data = data.concat(stockThing["Necklace"]);
			
			//Lọc dữ liệu để gia hạn
			filterData(data);
			
			var numExtendItem:int = data.length;
			
			for (var i:int = 0; i < data.length; i++)
			{
				if (data[i].Type == null)
				{
					continue;
				}
				// check xem đồ này có phải đang được cá mặc hay ko
				var fId:int = 0;
				var lId:int = 0;
				if (i < numItemInFishes && data[i].FishOwn)
				{
					fId = data[i].FishOwn.Id;
					lId = data[i].FishOwn.LakeId;
				}
				
				var itemEquip:ItemEquipment = new ItemEquipment(listBoxEquip);
				itemEquip.initItem(data[i], data[i].EnchantLevel, data[i].Type, data[i]["Rank"] + "$" + data[i]["Color"], data[i]["imageName"], data[i]["Durability"], data[i].Id, fId, lId);
				itemEquip.index = i + 1;
				listBoxEquip.addItem(itemEquip.index.toString(), itemEquip);
				if (itemEquip.canExtend())
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
			
			//smartSortData();
		}
		
		public function getFishEquips():Array
		{
			var a:Array = [];
			
			var i:int;
			var j:int;
			var s:String;
			var SoldierList:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			for (i = 0; i < SoldierList.length; i++)
			{
				if (SoldierList[i].SoldierType == FishSoldier.SOLDIER_TYPE_MIX)
				{
					for (s in SoldierList[i].EquipmentList)
					{
						for (j = 0; j < SoldierList[i].EquipmentList[s].length; j++)
						{
							var data:Object = SoldierList[i].EquipmentList[s][j];
							if(!(data.Type == "QWhite" || data.Type == "QGreen" || data.Type == "QYellow" || data.Type == "QPurple" || data.Type == "QVIP"))
							{
								a.push(SoldierList[i].EquipmentList[s][j]);
							}
						}
					}
				}
			}
			return a;
		}
		
		/**
		 * Loại equips còn nguyên độ bền
		 * @param	data
		 */
		public function filterData(data:Array):void
		{
			var numChecked:int = 0;					// Số item đã duyệt
			var numInFish:int = numItemInFishes;	// Đếm số item trong người cá cần extend
			
			for (var i:int = 0; i < data.length; i++)
			{
				if (data[i].Type == "QWhite" || data[i].Type == "QGreen" || data[i].Type == "QYellow" || data[i].Type == "QPurple")
				{
					data.splice(i, 1);
					continue;
				}
				if (data[i].Type == "Seal")
				{
					data.splice(i, 1);
					i--;
					if (numChecked < numInFish)
					{
						numItemInFishes--;
						numChecked++;
						continue;
					}
				}
				
				var eq:FishEquipment = data[i] as FishEquipment;
				if (eq.Type == null) continue;
				
					var config:Object = ConfigJSON.getInstance().GetEquipmentInfo(eq.Type, eq.Rank + "$" + eq.Color);
					if (eq.Durability < 0)
					{
						eq.Durability = 0;
					}
					if (Math.ceil(eq.Durability) >= config.Durability)
					{
						data.splice(i, 1);
						i--;
						if (numChecked < numInFish)
						{
							numItemInFishes--;
						}
					}
					
					numChecked++;
				
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					
					// Nếu GUI Chọn đồ còn mở thì sẽ cập nhật lại
					if (GuiMgr.getInstance().GuiChooseEquipment.IsVisible)
					{
						// Load lại kho để refresh trang bị
						var cmd:SendLoadInventory = new SendLoadInventory();
						Exchange.GetInstance().Send(cmd);
					}
					
					// Check xem còn đồ cần gia hạn không, nếu không thì ẩn cái nút đi
					GuiMgr.getInstance().GuiMain.CheckButtonExtendVisible(GameLogic.getInstance().user.IsViewer());
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
			arr = listBoxEquip.itemList.splice(0, listBoxEquip.itemList.length);
			listBoxEquip.removeAllItem();
			arr = sortIncreate(arr, type);
			if (increase)
			{
				for (var i:int = 0; i < arr.length; i++)
				{
					ItemEquipment(arr[i]).index = i +1;
					listBoxEquip.addItem(i.toString(), arr[i]);
				}
			}
			else
			{
				for (var j:int = arr.length -1 ; j >= 0; j--)
				{
					ItemEquipment(arr[j]).index = arr.length - j;
					listBoxEquip.addItem((arr.length - j).toString(), arr[j]);
				}
			}
			scrollBar.setPercent(0, true);
		}
		
		/**
		 * Sắp xếp deco sắp hết hạn trc rồi mới đến deco hết hạn(mặc định khi showGUI)
		 */
		private function smartSortData():void
		{
			var arr:Array = new Array();
			arr = listBoxEquip.itemList.splice(0, listBoxEquip.itemList.length);
			listBoxEquip.removeAllItem();
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
				listBoxEquip.addItem(i.toString(), arr1[i]);
			}
			
			for (i = 0; i < arr2.length; i++)
			{
				ItemDeco(arr2[i]).index = i +1 + arr1.length;
				listBoxEquip.addItem((i + arr1.length).toString(), arr2[i]);
			}
			scrollBar.setPercent(0, true);
		}
	}

}