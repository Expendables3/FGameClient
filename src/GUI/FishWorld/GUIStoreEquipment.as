package GUI.FishWorld 
{
	import Data.Localization;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ScrollBar;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendDeleteEquipment;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import NetworkPacket.PacketSend.SendStoreEquipment;
	import NetworkPacket.PacketSend.SendUseEquipmentSoldier;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIStoreEquipment extends BaseGUI 
	{
		private static const BTN_CLOSE:String = "Btn_Close";		
		private static const TAB_ALL:String = "Tab_All";
		private static const TAB_HELMET:String = "Tab_Helmet";
		private static const TAB_ARMOR:String = "Tab_Armor";
		private static const TAB_WEAPON:String = "Tab_Weapon";
		private static const TAB_JEWELRY:String = "Tab_Jewelry";
		private static const IMG_ALL:String = "ImgAll";
		private static const IMG_HELMET:String = "ImgHelmet";
		private static const IMG_ARMOR:String = "ImgArmor";
		private static const IMG_WEAPON:String = "ImgWeapon";
		private static const IMG_JEWELRY:String = "ImgJewelry";
		private static const BTN_SORT:String = "Btn_Sort";
		private static const BTN_EXTEND:String = "Btn_Extend";
		private static const BTN_DEL:String = "Btn_Del";
		private static const BTN_SHOP:String = "Btn_Shop";
		
		private static const CTN_HELMET:String = "Ctn_Helmet";
		private static const CTN_ARMOR:String = "Ctn_Armor";
		private static const CTN_WEAPON:String = "Ctn_Weapon";
		private static const CTN_BELT:String = "Ctn_Belt";
		private static const CTN_BRACELET:String = "Ctn_Bracelet";
		private static const CTN_NECKLACE:String = "Ctn_Necklace";
		private static const CTN_RING:String = "Ctn_Ring";
		private static const CTN_UNUSED:String = "Ctn_Unused";
	
		private var btnAll:Button;							// Pointer
		private var btnHelmet:Button;						// Pointer
		private var btnArmor:Button;						// Pointer
		private var btnWeapon:Button;						// Pointer
		private var btnJewelry:Button;						// Pointer
		
		private var imgAll:Image;							// Pointer
		private var imgHelmet:Image;						// Pointer
		private var imgArmor:Image;							// Pointer
		private var imgWeapon:Image;						// Pointer
		private var imgJewelry:Image;						// Pointer
		
		private var btnSort:Button;							// Pointer
		private var btnExtend:Button;						// Pointer
		private var btnDel:Button;							// Pointer
		
		private var curEquip:FishEquipment;					// Current Equipment Selected
		
		private var listBox:ListBox;						// Component
		private var scroll:ScrollBar;						// Component
		
		
		private var ItemList:Array = new Array();			// List all the item can be shown
		private var InteractiveCtn:Array = new Array();		// List all the Container can be interact
		private var ItemPos:Object;							// Positions of all the container in GUI (fixed)
		private var ObjectUse:Object;						// Object item used
		private var ObjectStore:Object;						// Object item stored
		
		private var curTab:String;							// Current Tab
		public var curHighlight:Container;					// Current Container highlighted
		private var curSoldier:FishSoldier;					// Current Soldier is changing equips
		private var curSoldierImg:Image;					// Current Soldier image in GUI
		private var curCtnIdDown:String;					// Current Container's Id that mouse down
		
		private var isWare:Boolean = true;					// Variable to check what drag means (ware or unware equip)
		
		private var scrollPercent:Number = 0;				// Goto the current "page" of listBox
		
		private var lastTimeClick:Number = 0;				// Double click purpose
		private var lastTimeCtn:String = "";				// Double click purpose
		
		private var ctnHelmet:Container;
		private var ctnArmor:Container;
		private var ctnWeapon:Container;
		
		public var numItemInTab:int;
		
		private var isReleaseItem:Boolean;					// Flag
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var isDataReady:Boolean;
		
		public function GUIStoreEquipment(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIStoreEquipment";
		}
		
		override public function InitGUI():void 
		{
			//super.InitGUI();
			this.setImgInfo = function():void
			{
				SetPos(220, 35);
				
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;	
				
				// Load lại kho để refresh trang bị
				var cmd:SendLoadInventory = new SendLoadInventory();
				Exchange.GetInstance().Send(cmd);
				OpenRoomOut();
			}
			LoadRes("GuiStoreEquipment_Theme");	
		}
		
		public function Init():void
		{
			ObjectStore = new Object();
			ObjectUse = new Object();
			
			ItemList.splice(0, ItemList.length);
			isDataReady = false;
			
			this.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			//SetPos(35, 10);
			AddButton(BTN_CLOSE, "BtnThoat", 707, 19);
			
			if (isDataReady)
			{
				ClearComponent();
				refreshComponent();
			}
		}
		
		public function refreshComponent(dataAvailable:Boolean = true):void
		{
			isDataReady = dataAvailable;
			if (!isDataReady || !IsFinishRoomOut)
			{
				return;
			}
			
			if (img == null) return;
			
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			
			AddButtons();
			
			ChangeTab(TAB_ALL);
			ShowTab(TAB_ALL, false, true);
		}
		
		/**
		 * All buttons add here
		 */
		private function AddButtons():void
		{
			imgAll = AddImage(IMG_ALL, "GuiStoreEquipment_ImgBtnAll", 63, 94, true, ALIGN_LEFT_TOP);
			imgHelmet = AddImage(IMG_HELMET, "GuiStoreEquipment_ImgBtnHelmet", imgAll.CurPos.x + 55, 94, true, ALIGN_LEFT_TOP);
			imgArmor = AddImage(IMG_ARMOR, "GuiStoreEquipment_ImgBtnArmor", imgHelmet.CurPos.x + 55, 94, true, ALIGN_LEFT_TOP);
			imgWeapon = AddImage(IMG_WEAPON, "GuiStoreEquipment_ImgBtnWeapon", imgArmor.CurPos.x + 55, 94, true, ALIGN_LEFT_TOP);
			imgJewelry = AddImage(IMG_JEWELRY, "GuiStoreEquipment_ImgBtnJewelry", imgWeapon.CurPos.x + 55, 94, true, ALIGN_LEFT_TOP);
			
			btnAll = AddButton(TAB_ALL, "GuiStoreEquipment_BtnAll", imgAll.CurPos.x, imgAll.CurPos.y);
			var tt:TooltipFormat = new TooltipFormat();
			tt.text = "Tất cả";
			btnAll.setTooltip(tt);
			
			btnHelmet = AddButton(TAB_HELMET, "GuiStoreEquipment_BtnHelmet", imgHelmet.CurPos.x, imgHelmet.CurPos.y);
			tt = new TooltipFormat();
			tt.text = "Mũ giáp";
			btnHelmet.setTooltip(tt);
			
			btnArmor = AddButton(TAB_ARMOR, "GuiStoreEquipment_BtnArmor", imgArmor.CurPos.x, imgArmor.CurPos.y);
			tt = new TooltipFormat();
			tt.text = "Áo giáp";
			btnArmor.setTooltip(tt);
			
			btnWeapon = AddButton(TAB_WEAPON, "GuiStoreEquipment_BtnWeapon", imgWeapon.CurPos.x, imgWeapon.CurPos.y);
			tt = new TooltipFormat();
			tt.text = "Vũ khí";
			btnWeapon.setTooltip(tt);
			
			btnJewelry = AddButton(TAB_JEWELRY, "GuiStoreEquipment_BtnJewelry", imgJewelry.CurPos.x, imgJewelry.CurPos.y);
			tt = new TooltipFormat();
			tt.text = "Trang sức";
			btnJewelry.setTooltip(tt);
			
			btnSort = AddButton(BTN_SORT, "GuiStoreEquipment_BtnSort", 80, 425);
			btnExtend = AddButton(BTN_EXTEND, "GuiStoreEquipment_BtnExtend", btnSort.img.x + 80, btnSort.img.y);
			btnDel = AddButton(BTN_DEL, "GuiStoreEquipment_BtnDel", btnExtend.img.x + 80, btnExtend.img.y);
			//AddButton(BTN_SHOP, "BtnShopEquipment", 361, 479);
			AddButton(BTN_CLOSE, "BtnThoat", 368, 19);
		}
		
		public function ChangeTab(buttonID:String):void
		{
			curTab = buttonID;
			
			btnAll.SetVisible(true);
			btnHelmet.SetVisible(true);
			btnArmor.SetVisible(true);
			btnWeapon.SetVisible(true);
			btnJewelry.SetVisible(true);
			
			GetButton(buttonID).SetVisible(false);
		}
		
		public function ShowTab(buttonID:String, isSort:Boolean = false, isInit:Boolean = false):void
		{
			ClearScroll();
			ClearListBox();
			curHighlight = null;
			
			// Re-add list box
			listBox = AddListBox(ListBox.LIST_Y, 3, 3, 7, 10);
			listBox.setPos(70, 135);

			if (isInit)
			{
				ItemList = GetItemList(buttonID);
			}
			SortItem(isSort);
			
			var i:int;
			var numItem:int = 0;
			for (i = 0; i < ItemList.length; i++)
			{
				if (ItemList[i].Type != buttonID.split("_")[1] && buttonID != TAB_JEWELRY && buttonID != TAB_ALL)	continue;
				if (buttonID == TAB_JEWELRY && ItemList[i].Type != "Belt" && ItemList[i].Type != "Bracelet" && ItemList[i].Type != "Ring" && ItemList[i].Type != "Necklace")	continue; 
				AddOneEquipment(ItemList[i] as FishEquipment);
				numItem++;
			}
			
			numItemInTab = numItem;
			
			// Add scroll
			scroll = AddScroll("", "GuiStoreEquipment_ScrollBarExtendDeco", 306, 137);
			scroll.setScrollImage(listBox.img, listBox.img.width, 200);
			if (numItemInTab <= listBox.RowShow * listBox.ColShow)
			{
				scroll.img.visible = false;
				AddMoreContainers(listBox.RowShow * listBox.ColShow - numItemInTab);
			}
			else
			{
				listBox.setInfo(7, 10, 70, 70);
				scroll.setPercent(scrollPercent, true);
			}
		}
		
		private function AddMoreContainers(num:int):void
		{
			var ctn:Container;
			var i:int;
			for (i = 0; i < num; i++)
			{
				ctn = AddContainer("Ctn_" + "Empty", "GuiStoreEquipment_CtnEquipment", 10, 10, true, this);
				listBox.addItem(ctn.IdObject, ctn, this);
				ContainerArr.splice(ContainerArr.length - 1, 1);
				
				ctn.enable = true;
			}
		}
		
		private function AddOneEquipment(o:FishEquipment):void
		{
			var ctn:Container;
			ctn = AddContainer("Ctn_" + o.Id, "GuiStoreEquipment_CtnEquipment", 10, 10, true, this);
			
			// Add nền nếu là đồ quý, đặc biệt
			if (o.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
			{
				ctn.AddImage("", FishEquipment.GetBackgroundName(o.Color), 0, 0, true, ALIGN_LEFT_TOP);
			}
			
			var imag:Image = ctn.AddImage("", o.imageName + "_Shop", 10, 10);
			imag.setImgInfo = function f():void { FishSoldier.EquipmentEffect(imag.img, o.Color) };
			imag.FitRect(60, 60, new Point(7, 7));
			FishSoldier.EquipmentEffect(imag.img, o.Color);
			
			if (o.EnchantLevel > 0)
			{
				var txt:TextField = ctn.AddLabel("+" + o.EnchantLevel, 2, 2, 0xFFF100, 0, 0x603813);
				var tF:TextFormat = new TextFormat();
				tF.size = 18;
				tF.bold = true;
				txt.setTextFormat(tF);
			}
			
			if (curSoldier && (o.Element == curSoldier.Element || o.Element == FishSoldier.ELEMENT_NONE) || !curSoldier)
			{
				
			}
			else
			{
				ctn.AddImage("", "GuiStoreEquipment_ImgDeny", 0, 0).FitRect(15, 15, new Point(50, 55));
			}
			
			if (o.Durability <= 0)
			{
				ctn.enable = false;
			}
			else
			{
				ctn.enable = true;
			}
			
			listBox.addItem(ctn.IdObject, ctn, this);
			ContainerArr.splice(ContainerArr.length - 1, 1);
		}
		
		private function GetItemList(buttonID:String):Array
		{
			var tempList:Array = new Array();
			var tabName:String = buttonID.split("_")[1];
			if (buttonID != TAB_ALL)
			{
				tempList = GameLogic.getInstance().user.GetStore(tabName);
			}
			else if (buttonID == TAB_JEWELRY)
			{
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Belt"));
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Bracelet"));
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Necklace"));
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Ring"));
			}
			else
			{
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Helmet"));
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Armor"));
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Weapon"));
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Belt"));
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Bracelet"));
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Necklace"));
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Ring"));
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Mask"));
			}
			
			//var i:int;
			//for (i = 0; i < tempList.length; i++)
			//{
				//var eq:FishEquipment = new FishEquipment();
				//eq.SetInfo(tempList[i]);
				//ItemList.push(tempList[i]);
			//}
			
			return tempList;
		}
		
		/**
		 * Sort các item trong kho theo thứ tự:
		 * - Đồ dùng được
		 * - Đồ quý
		 * - Đồ đặc biệt
		 * - Đồ thường
		 * - Dmg
		 * - Def
		 * - HP
		 * - Crit
		 * @param	isSort
		 */
		private function SortItem(isSort:Boolean):void
		{
			if (!isSort)	return;
			
			var i:int;
			var j:int;
			var itemTemp:FishEquipment;
			
			var arrTemp:Array = [];
			
			for (i = 0; i < ItemList.length; i++)
			{
				for (j = i + 1; j < ItemList.length; j++)
				{
					if (curSoldier)
					{
						if (ItemList[j].Element == curSoldier.Element && ItemList[i].Element != curSoldier.Element)
						{
							itemTemp = ItemList[i];
							ItemList[i] = ItemList[j];
							ItemList[j] = itemTemp;
							continue;
						}
					}
						
					if (ItemList[i].Color < ItemList[j].Color)
					{
						itemTemp = ItemList[i];
						ItemList[i] = ItemList[j];
						ItemList[j] = itemTemp;
						continue;
					}
				}
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_SHOP:
					scrollPercent = scroll.getScrollCurrentPercent();
					GuiMgr.getInstance().GuiShop.CurrentShop = "Helmet";
					GuiMgr.getInstance().GuiShop.curPage = 1;
					GameController.getInstance().UseTool("Shop");
					break;
				case TAB_ALL:
				case TAB_HELMET:
				case TAB_ARMOR:
				case TAB_WEAPON:
				case TAB_JEWELRY:
					scrollPercent = 0;
					ChangeTab(buttonID);
					ShowTab(buttonID);
					break;
				case BTN_EXTEND:
					scrollPercent = scroll.getScrollCurrentPercent();
					GuiMgr.getInstance().GuiExtendEquipment.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case BTN_SORT:
					scrollPercent = scroll.getScrollCurrentPercent();
					ShowTab(curTab, true);
					break;
				case BTN_DEL:
					if (curHighlight)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOkCancelDelEquip(Localization.getInstance().getString("FishWarMsg17"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					}
					else
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg15"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					}
					break;
				case BTN_CLOSE:
					this.Hide();
					break;
			}
		}
		
		/**
		 * Send packet to server when decide to delete equips
		 * @param	id
		 */
		public function processDeleteClothes(id:int):void
		{	
			// Get thông tin trang bị trước
			var info:FishEquipment = GetEquipmentInfo(id);
			
			// Nếu là vừa cởi đồ ra rồi xóa ngay -> gửi gói tin cởi đồ trước
			if (ObjectStore[id])
			{
				var unwarePacket:SendStoreEquipment = new SendStoreEquipment(info.Type, info.Id, curSoldier.Id, curSoldier.LakeId);
				Exchange.GetInstance().Send(unwarePacket);
				
				// Xóa trong ObjectStore
				delete(ObjectStore[id]);
			}
			
			var deletePacket:SendDeleteEquipment = new SendDeleteEquipment(info.Type, id);
			Exchange.GetInstance().Send(deletePacket);
			
			// Remove from ItemList
			for (var i:int = 0; i < ItemList.length; i++)
			{
				if (ItemList[i].Id == id)
				{
					ItemList.splice(i, 1);
					break;
				}
			}
			
			scrollPercent = scroll.getScrollCurrentPercent();
			ShowTab(curTab);
			
			curHighlight = null;
			
			GameLogic.getInstance().user.UpdateEquipmentToStore(info, false);
		}
		
		/**
		 * Send packet to server when finish changing equips
		 */
		private function processChangeClothes():void
		{
			var s:String;
			var s1:String;
			var i:int;
			
			// Cut all the unnecessary task (ware -> unware... so on) in the ObjectSore and ObjectUse
			for (s in ObjectStore)
			{
				if (s in ObjectUse)
				{
					delete(ObjectStore[s]);
					delete(ObjectUse[s]);
				}
			}
			
			var info:FishEquipment;
			for (s in ObjectStore)
			{
				info = GetEquipmentInfo(int(s));
				var storePacket:SendStoreEquipment = new SendStoreEquipment(info.Type, info.Id, curSoldier.Id, curSoldier.LakeId);
				Exchange.GetInstance().Send(storePacket);
				
				GameLogic.getInstance().user.UpdateEquipmentToStore(info);
				
				for (s1 in curSoldier.EquipmentList)
				{
					for (i = 0; i < curSoldier.EquipmentList[s1].length; i++)
					{
						if (curSoldier.EquipmentList[s1][i].Id == int(s))
						{
							curSoldier.EquipmentList[s1].splice(i, 1);
						}
					}
				}
				
				//curSoldier.WareEquipment(false, info);
			}
			
			for (s in ObjectUse)
			{
				info = GetEquipmentInfo(int(s));
				var usePacket:SendUseEquipmentSoldier = new SendUseEquipmentSoldier(info.Type, info.Id, curSoldier.Id, curSoldier.LakeId);
				Exchange.GetInstance().Send(usePacket);
				
				GameLogic.getInstance().user.UpdateEquipmentToStore(info, false);
				
				for (i = 0; i < ItemList.length; i++)
				{
					if (ItemList[i].Id == int(s))
					{
						curSoldier.EquipmentList[info.Type].push(ItemList[i]);
					}
				}
				
				//curSoldier.WareEquipment(true, info);
			}
			
			ObjectUse = new Object();
			ObjectStore = new Object();
		}
		
		/**
		 * Get all info of one Equipment by it's Id (in ItemList or in current Soldier Equipment)
		 * @param	id
		 * @return
		 */
		private function GetEquipmentInfo(id:int):FishEquipment
		{
			for (var i:int = 0; i < ItemList.length; i++)
			{
				if (ItemList[i].Id == id)
				{
					return ItemList[i];
				}
			}
			
			if (!curSoldier)	return null;
			
			var curItem:Object = curSoldier.EquipmentList;
			var s:String;
			var s1:String;
			for (s in curItem)
			{
				for (s1 in curItem[s])
				{
					if (curItem[s][s1].Id == id)
					{
						return curItem[s][s1];
					}
				}
			}
			
			return null;
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			if (buttonID == BTN_CLOSE)	return;
			
			var a:Array = buttonID.split("_");
			var obj:Object;
			var c:Container;
			switch (a[0] + "_" + a[1])
			{
				case CTN_ARMOR:
				case CTN_HELMET:
				case CTN_WEAPON:
				case CTN_BELT:
				case CTN_NECKLACE:
				case CTN_BRACELET:
				case CTN_RING:
					try
					{
						obj = curSoldier.EquipmentList[a[1]][a[2]];
						c = GetContainer(buttonID);
					}
					catch (err:Error)
					{
						
					}
					
					if (obj && curEquip == null && !isReleaseItem)
					{
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, obj, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
					}
					break;
				default:
					if (buttonID != CTN_UNUSED)
					{
						obj = GetEquipmentInfo(parseInt(a[1]));
						c = listBox.getItemById(buttonID);
					}
					
					if (obj && curEquip == null && !isReleaseItem)
					{
						if (curSoldier)
						{
							GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, obj, GUIEquipmentInfo.INFO_TYPE_SPECIFIC,
								curSoldier.EquipmentList[obj.Type][0]);
						}
						else
						{
							GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, obj, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
						}
					}
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
			isReleaseItem = false;
		}
	}

}