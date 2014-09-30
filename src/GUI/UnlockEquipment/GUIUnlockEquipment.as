package GUI.UnlockEquipment 
{
	import com.greensock.easing.Quint;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import GameControl.GameController;
	import GUI.ChangeEnchant.ChangeEnchantPackage.SendChangeEnchantLevel;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ScrollBar;
	import GUI.component.TooltipFormat;
	import GUI.EnchantEquipment.GodCharmSlot;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import GUI.FishWar.FishEquipment;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketReceive.GetLoadInventory;
	import NetworkPacket.PacketSend.SendLoadInventory;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIUnlockEquipment extends BaseGUI 
	{
		static public const XBUFF:int = 0;
		static public const YBUFF:int = 0;
		private const XPOS:int = 85;
		private const YPOS:int = 42;
		static public const ICON_HELPER:String = "iconHelper";
		private const CTN_POWERTINH:String = "ctnPowertinh";
		private const CTN_TYPE_CHANGE_EQUIPMENT_DES:String = "ctnTypeChangeEquipmentDes";
		private const CTN_TYPE_CHANGE_EQUIPMENT_SRC:String = "ctnTypeChangeEquipmentSrc";
		private const ID_CTN_INFO:String = "idCtnInfo";
		
		private static const BTN_CLOSE:String = "Btn_Close";
		private static const BTN_UNLOCK_EQUIP:String = "btnUnlockEquipment";
		private static const BTN_BUY_OPEN_KEY_ZMONEY:String = "btnBuyOpenKeyZMoney";
		private static const BTN_BUY_OPEN_KEY_DIAMOND:String = "btnBuyOpenKeyDiamond";
		
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
		
		private static const CTN_TYPE_EQUIPMENT:String = "Equipment";
		private static const CTN_TYPE_MATERIAL:String = "Material";
		private static const CTN_TYPE_ENCHANT_SLOT:String = "EnchantSlot";
		private static const CTN_TYPE_ENCHANT_EQUIPMENT:String = "EnchantEquipment";
		private static const CTN_OPEN_KEY:String = "OpenKey";
		
		private var btnAll:Button;									// Pointer
		private var btnHelmet:Button;								// Pointer
		private var btnArmor:Button;								// Pointer
		private var btnWeapon:Button;								// Pointer
		private var btnJewelry:Button;								// Pointer
		
		private var imgAll:Image;									// Pointer
		private var imgHelmet:Image;								// Pointer
		private var imgArmor:Image;									// Pointer
		private var imgWeapon:Image;								// Pointer
		private var imgJewelry:Image;								// Pointer
		
		private var btnUnlockEquipment:Button;							// Pointer
		private var btnBuyOpenKeyZMoney:Button;							// Pointer
		private var btnBuyOpenKeyDiamond:Button;							// Pointer
		
		private static const DOUBLE_CLICK_TIMER:Number = 0.5;
		
		private var curEnchantSlot:int;								// Slot ID of next enchant slot
		private var curEquipImage:Image;							// Image dragable
		private var curEquip:FishEquipment;							// Current Equipment Selected
		private var enchantCtn:Container = null;					// Container of equip enchanted
		private var openKeyCtn:Container = null;					// Container of equip enchanted
		private var changesrcCtn:Container = null;					// Container of equip source change
		private var changedesCtn:Container = null;					// Container of equip destination change
		private var infoCtn:Container = null;						// Container infomations
		private var ctnPowerTinh:Container = null;				// Container god charm
		private var tfPowerTinh:TextField = null;				// Container god charm
		private var lbCostOpenKeyItemZMoney:TextField = null;				// Container god charm
		private var lbCostOpenKeyItemDiamond:TextField = null;				// Container god charm
		
		private var listBoxEquipment:ListBox = null;				// Component
		private var scroll:ScrollBar;								// Component
		
		private var isFlying:Boolean;								// Check OK
		private var isEnchanting:Boolean;							// Check OK
		private var isChanging:Boolean;								// Check OK
		
		private var curTab:String;									// Current Tab
		public var curHighlight:Container;							// Current Container highlighted
		
		private var isPicked:Boolean = true;						// Variable to check what drag means (pick to Enchant and vice versa)
		
		private var ItemList:Array = new Array();					// List all the item can be shown
		
		private var numItemInTab:int;
		private var numEnchantableSlot:int = 8;						// Number of slots can be obtain materials
		
		private var lastTimeClick:Number = 0;						// Double click purpose
		private var lastTimeCtn:String = "";						// Double click purpose
		
		private var isReleaseItem:Boolean;							// Flag
		
		private var scrollPercent:Number = 0;						// Goto the current "page" of listBox
		
		public var EquipmentChoose:FishEquipment = null;			// Equip to enchant
		public var ChangeSrcChoose:FishEquipment = null;			// Equip to enchant
		public var ChangeDesChoose:FishEquipment = null;			// Equip to enchant
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var isDataReady:Boolean;
		public function GUIUnlockEquipment(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIUnlockEquipment";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(XPOS, YPOS);
				if (GetButton(BTN_CLOSE))	GetButton(BTN_CLOSE).SetPos(707, 19);
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = 369;
				WaitData.y = 284;
				
				// Load lại kho để refresh trang bị
				var cmd:SendLoadInventory = new SendLoadInventory();
				Exchange.GetInstance().Send(cmd);
			}
			LoadRes("GuiUnlockEquip_Theme");
			AddButton(BTN_CLOSE, "BtnThoat", 577, 19);//chuyển thành tab
		}
		
		public override function EndingRoomOut():void
		{
			if (isDataReady)
			{
				ClearComponent();
				RefreshComponent();
			}
		}
		
		public function RefreshComponent(dataAvailable:Boolean = true):void
		{
			isDataReady = dataAvailable;
			if (!isDataReady)
			{
				return;
			}
			if (img == null) return;
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}			
			
			ResetVariable();
			
			AddButton(BTN_CLOSE, "BtnThoat", 577, 19);
			ShowInfo();
			ShowEnchantItem();
			AddButtons();
			ChangeTab(TAB_ALL);
			ShowTab(TAB_ALL, true);
		}
		
		private function ResetVariable():void
		{
			listBoxEquipment = null;
			enchantCtn = null;
			infoCtn = null;
			ItemList = [];
			EquipmentChoose = null;
			btnUnlockEquipment = null;
			btnBuyOpenKeyDiamond = null;
			btnBuyOpenKeyZMoney = null;
			lbCostOpenKeyItemDiamond = null;
			lbCostOpenKeyItemZMoney = null;
			
			ChangeSrcChoose = null;
			ChangeDesChoose = null;
			changesrcCtn = null;
			changedesCtn = null;
			ctnPowerTinh = null;
			tfPowerTinh = null;
		}
		
		public function ShowInfo():void
		{
			if (infoCtn == null)
			{
				infoCtn = AddContainer("", "GuiUnlockEquip_CtnInfoUnlockEquip", 32, 80);
			}
			else
			{
				infoCtn.ClearComponent();
			}
			
			if (btnUnlockEquipment == null)
			{
				btnUnlockEquipment = AddButton(BTN_UNLOCK_EQUIP, "GuiUnlockEquip_BtnUnlockEquip", 110 + XBUFF, 240 + YBUFF);
			}
			btnUnlockEquipment.SetDisable();
			
			var cfgOKI:Object = ConfigJSON.getInstance().GetItemList("Param").OpenKeyItem;
			if (btnBuyOpenKeyZMoney == null)
			{
				btnBuyOpenKeyZMoney = AddButton(BTN_BUY_OPEN_KEY_ZMONEY, "GuiUnlockEquip_Buy", 150 + XBUFF, 400 + YBUFF);
				lbCostOpenKeyItemZMoney = AddLabel(String(cfgOKI.ZMoney),  120 + XBUFF, 400 + YBUFF);
			}
			btnBuyOpenKeyZMoney.SetVisible(false);
			lbCostOpenKeyItemZMoney.visible = false;
			
			if (btnBuyOpenKeyDiamond == null)
			{
				btnBuyOpenKeyDiamond = AddButton(BTN_BUY_OPEN_KEY_DIAMOND, "GuiUnlockEquip_BtnBuyByDiamond", 85 + XBUFF, 400 + YBUFF);
				lbCostOpenKeyItemDiamond = AddLabel(String(cfgOKI.Diamond),  55 + XBUFF, 400 + YBUFF);
			}
			btnBuyOpenKeyDiamond.SetVisible(false);
			lbCostOpenKeyItemDiamond.visible = false;
			
			if (openKeyCtn != null)
			{
				openKeyCtn.Destructor();
				openKeyCtn = null;
			}
			var txtField:TextField;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 16;
			txtFormat.color = 0xF2F2F2;
			txtFormat.bold = true;
			txtFormat.align = "center";
			var openKey:Array = GameLogic.getInstance().user.StockThingsArr.OpenKeyItem;
			if (!EquipmentChoose)
			{				
				txtField = infoCtn.AddLabel(Localization.getInstance().getString("EnchantMsg1"), 50, 277);
				txtField.wordWrap = true;
				txtField.width = 125;
				txtField.setTextFormat(txtFormat);
				
				if (btnUnlockEquipment != null)
				{
					btnUnlockEquipment.SetDisable();
				}
			}
			else
			{
				if (btnUnlockEquipment != null)
				{
					btnUnlockEquipment.SetEnable();
				}
				if (btnBuyOpenKeyZMoney != null)
				{
					btnBuyOpenKeyZMoney.SetVisible(true);
					btnBuyOpenKeyZMoney.SetEnable();
					lbCostOpenKeyItemZMoney.visible = true;
				}
				if (btnBuyOpenKeyDiamond != null)
				{
					btnBuyOpenKeyDiamond.SetVisible(true);
					btnBuyOpenKeyDiamond.SetEnable();
					lbCostOpenKeyItemDiamond.visible = true;
				}
				if (openKeyCtn == null)
				{
					var item:Object;
					for (var i:int = 0; i < openKey.length; i++) 
					{
						item = openKey[i];
						if (int(item[ConfigJSON.KEY_ID]) == 1)
						{
							break;
						}
					}
					openKeyCtn = AddContainer(CTN_OPEN_KEY, "GuiUnlockEquip_CtnOpenKeyItem", 115, 322, true, this);
					var imgKey:Image = openKeyCtn.AddImage("", "OpenKeyItem1", 0, 0);
					imgKey.FitRect(60, 60, new Point(0, 0));
					//openKeyCtn = AddContainer(CTN_OPEN_KEY, "OpenKeyItem1", 180, 245, true, this);
					if(item != null)
					{
						txtField = openKeyCtn.AddLabel("x" + item.Num, -44, 36);
					}
					else
					{
						txtField = openKeyCtn.AddLabel("x0", -44, 36);
					}
					txtField.wordWrap = true;
					txtField.width = 175;
					txtFormat.size = 18;
					txtField.setTextFormat(txtFormat);
					txtField.defaultTextFormat = txtFormat;
				}
			}
		}
		
		private function ShowEnchantItem(eq:FishEquipment = null):void
		{
			enchantCtn = ShowEnchantItem2(eq, CTN_TYPE_ENCHANT_EQUIPMENT);
		}
		
		private function ShowEnchantItem2(eq:FishEquipment = null, idCtn:String = null,  x:int = 110, y:int = 145):Container
		{
			var ctn:Container = GetContainer(idCtn);
			if (ctn == null)
			{
				ctn = AddContainer(idCtn, "GuiUnlockEquip_CtnEnchantEquipment", x, y, true, this);
			}
			else
			{
				ctn.ClearComponent();
			}
			
			if (eq)
			{
				// Add nền nếu là đồ quý, đặc biệt
				if (eq.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
				{
					ctn.AddImage("", FishEquipment.GetBackgroundName(eq.Color), 0, 0, true, ALIGN_LEFT_TOP);
				}
				var imag:Image = ctn.AddImage("", eq.imageName + "_Shop", 0, 0);
				imag.FitRect(60, 60, new Point(7, 7));

				FishSoldier.EquipmentEffect(imag.img, eq.Color);
				
				if (eq.EnchantLevel > 0)
				{
					var txt:TextField = ctn.AddLabel("+" + eq.EnchantLevel, 2, 2, 0xFFF100, 0, 0x603813);
					var tF:TextFormat = new TextFormat();
					tF.size = 18;
					tF.bold = true;
					txt.setTextFormat(tF);
				}
			}
			return ctn;
		}
		
		/**
		 * All buttons add here
		 */
		private function AddButtons():void
		{
			imgAll = AddImage(IMG_ALL, "GuiUnlockEquip_ImgBtnAll", 272 + XBUFF, 84 + YBUFF, true, ALIGN_LEFT_TOP);
			imgHelmet = AddImage(IMG_HELMET, "GuiUnlockEquip_ImgBtnHelmet", imgAll.CurPos.x + 57 + XBUFF, 84 + YBUFF, true, ALIGN_LEFT_TOP);
			imgArmor = AddImage(IMG_ARMOR, "GuiUnlockEquip_ImgBtnArmor", imgHelmet.CurPos.x + 57 + XBUFF, 84 + YBUFF, true, ALIGN_LEFT_TOP);
			imgWeapon = AddImage(IMG_WEAPON, "GuiUnlockEquip_ImgBtnWeapon", imgArmor.CurPos.x + 57 + XBUFF, 84 + YBUFF, true, ALIGN_LEFT_TOP);
			imgJewelry = AddImage(IMG_JEWELRY, "GuiUnlockEquip_ImgBtnJewelry", imgWeapon.CurPos.x + 57 + XBUFF, 84 + YBUFF, true, ALIGN_LEFT_TOP);
			
			btnAll = AddButton(TAB_ALL, "GuiUnlockEquip_BtnAll", imgAll.CurPos.x + XBUFF, imgAll.CurPos.y + YBUFF);
			var tt:TooltipFormat = new TooltipFormat();
			tt.text = "Tất cả";
			btnAll.setTooltip(tt);
				
			btnHelmet = AddButton(TAB_HELMET, "GuiUnlockEquip_BtnHelmet", imgHelmet.CurPos.x + XBUFF, imgHelmet.CurPos.y + YBUFF);
			tt = new TooltipFormat();
			tt.text = "Mũ giáp";
			btnHelmet.setTooltip(tt);
			
			btnArmor = AddButton(TAB_ARMOR, "GuiUnlockEquip_BtnArmor", imgArmor.CurPos.x + XBUFF, imgArmor.CurPos.y + YBUFF);
			tt = new TooltipFormat();
			tt.text = "Áo giáp";
			btnArmor.setTooltip(tt);
			
			btnWeapon = AddButton(TAB_WEAPON, "GuiUnlockEquip_BtnWeapon", imgWeapon.CurPos.x + XBUFF, imgWeapon.CurPos.y + YBUFF);
			tt = new TooltipFormat();
			tt.text = "Vũ khí";
			btnWeapon.setTooltip(tt);
			
			btnJewelry = AddButton(TAB_JEWELRY, "GuiUnlockEquip_BtnJewelry", imgJewelry.CurPos.x + XBUFF, imgJewelry.CurPos.y + YBUFF);
			tt = new TooltipFormat();
			tt.text = "Trang sức";
			btnJewelry.setTooltip(tt);
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
		
		public function ShowTab(buttonID:String, isInit:Boolean = false):void
		{
			ClearScroll();
			curHighlight = null;
			
			// Re-add list box
			if (listBoxEquipment == null)
			{
				listBoxEquipment = AddListBox(ListBox.LIST_Y, 3, 3, 2, 5);
				listBoxEquipment.setPos(283 + XBUFF, 149 + YBUFF);
			}
			else
			{
				listBoxEquipment.removeAllItem();
			}
			
			if (isInit)
			{
				GetEquipmentList(buttonID);
			}
			
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
			scroll = AddScroll("", "GuiUnlockEquip_ScrollBar", 520 + XBUFF, 140 + YBUFF);
			scroll.setScrollImage(listBoxEquipment.img, listBoxEquipment.img.width, 200);
			if (numItemInTab <= listBoxEquipment.RowShow * listBoxEquipment.ColShow)
			{
				scroll.img.visible = false;
				AddMoreContainers(listBoxEquipment.RowShow * listBoxEquipment.ColShow - numItemInTab);
			}
			else
			{
				scroll.setPercent(scrollPercent, true);
			}
		}
		
		private function GetEquipmentList(buttonID:String):Array
		{
			if (ItemList.length > 0) 	return ItemList;
			
			var tempList:Array = new Array();
			var tabName:String = buttonID.split("_")[1];
			if (buttonID != TAB_ALL)
			{
				tempList = GameLogic.getInstance().user.GetStore(tabName);
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
			}
			
			var i:int;
			for (i = 0; i < tempList.length; i++)
			{
				if(tempList[i].IsUsed)
				{
					if (!EquipmentChoose || tempList[i].Id != EquipmentChoose.Id)
					{
						ItemList.push(tempList[i]);
					}
				}
			}
			
			return ItemList;
		}
		
		private function AddOneEquipment(o:FishEquipment):void
		{
			var ctn:Container;
			//ctn = AddContainer(CTN_TYPE_EQUIPMENT + "_" + o.Id, "GuiEnchant_CtnEquipment", 10, 10, true, this);
			ctn = AddContainer(CTN_TYPE_EQUIPMENT + "_" + o.Id, "ImgFrameFriend", 10 + XBUFF, 10 + YBUFF, true, this);
			
			// Add nền nếu là đồ quý, đặc biệt
			if (o.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
			{
				ctn.AddImage("", FishEquipment.GetBackgroundName(o.Color), -4, -2, true, ALIGN_LEFT_TOP, true);
			}
			else
			{
				ctn.AddImage("", "GuiUnlockEquip_CtnEquipment", 0, 0, true, ALIGN_LEFT_TOP);
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
			
			if (o.Durability <= 0)
			{
				ctn.enable = false;
			}
			else
			{
				ctn.enable = true;
			}
			
			listBoxEquipment.addItem(ctn.IdObject, ctn, this);
			ContainerArr.splice(ContainerArr.length - 1, 1);
		}
		
		private function AddMoreContainers(num:int):void
		{
			var ctn:Container;
			var i:int;
			for (i = 0; i < num; i++)
			{
				ctn = AddContainer("Ctn_" + "Empty", "GuiUnlockEquip_CtnEquipment", 10 + XBUFF, 10 + YBUFF, true, this);
				listBoxEquipment.addItem(ctn.IdObject, ctn, this);
				ContainerArr.splice(ContainerArr.length - 1, 1);
			}
		}
		
		public function UpdateGUIUnlockEquip():void
		{
			if (!EquipmentChoose)
			{
				GuiMgr.getInstance().GuiUnlockEquipment.ClearComponent();
				GuiMgr.getInstance().GuiUnlockEquipment.RefreshComponent();
			}
			else
			{
				ShowTab(curTab, true);
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			if (isEnchanting)	return;
			var openKeyItem:Array = GameLogic.getInstance().user.StockThingsArr.OpenKeyItem;
			var cfgOKI:Object = ConfigJSON.getInstance().GetItemList("Param").OpenKeyItem;
			var item:Object;
			for (var i:int = 0; i < openKeyItem.length; i++) 
			{
				item = openKeyItem[i];
				if (int(item[ConfigJSON.KEY_ID]) == 1)
				{
					break;
				}
			}
			switch (buttonID)
			{
				case BTN_BUY_OPEN_KEY_ZMONEY:
					ProcessBuyByG();
				break;
				case BTN_BUY_OPEN_KEY_DIAMOND:
					ProcessBuyByDiamond();
				break;
				case BTN_CLOSE:
					if (isFlying)	return;
					if (isChanging) return;
					this.Hide();
					
					// Nếu GUI Chọn đồ còn mở thì sẽ cập nhật lại
					if (GuiMgr.getInstance().GuiChooseEquipment.IsVisible)
					{
						// Load lại kho để refresh trang bị
						var cmd:SendLoadInventory = new SendLoadInventory();
						Exchange.GetInstance().Send(cmd);
					}
					break;
				case TAB_ALL:
				case TAB_ARMOR:
				case TAB_HELMET:
				case TAB_WEAPON:
				case TAB_JEWELRY:
					scrollPercent = 0;
					ChangeTab(buttonID);
					ShowTab(buttonID);
					break;
				case BTN_UNLOCK_EQUIP:
					if (isFlying)	return;
					if (isChanging) return;
					// Thực hiện Unlock item
					isFlying = true;
					ProcessUnlockEquip();
					break;
				default:
					break;
			}
		}
		
		private function ProcessUnlockEquip():void 
		{
			var str:String;
			if (EquipmentChoose == null)
			{
				str = Localization.getInstance().getString("Tooltip94");
				ShowText(str);
				isFlying = false;
				return;
			}
			
			if (EquipmentChoose.Durability <= 0)
			{
				str = Localization.getInstance().getString("Tooltip95");
				ShowText(str);
				isFlying = false;
				return;
			}
			
			var canSell:Boolean = false;
			var cfg:Array = ConfigJSON.getInstance().GetItemList("Param").CanSellEquipment;
			for (var i:int = 0; i < cfg.length; i++) 
			{
				if (EquipmentChoose.Source == cfg[i])
				{
					canSell = true;
				}
			}
			
			if (!canSell)
			{
				str = Localization.getInstance().getString("Tooltip96");
				ShowText(str);
				isFlying = false;
				return;
			}
			
			var openKeyItem:Array = GameLogic.getInstance().user.StockThingsArr.OpenKeyItem;
			var cfgOKI:Object = ConfigJSON.getInstance().GetItemList("Param").OpenKeyItem;
			var item:Object;
			for (i = 0; i < openKeyItem.length; i++) 
			{
				if (int(openKeyItem[i][ConfigJSON.KEY_ID]) == 1)
				{
					item = openKeyItem[i];
					break;
				}
			}
			if(item == null || item.Num == null || int(item.Num) <= 0)
			{
				str = "Bạn không có chìa khóa";
				ShowText(str);
				isFlying = false;
				return;
			}

			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiUnlockEquip_EffUnlockEquip", null, 205, 205, false, false, null, ProcessUnlockItem);
		}
		
		private function ProcessBuyByDiamond():void 
		{
			var str:String;
			var openKeyItem:Array = GameLogic.getInstance().user.StockThingsArr.OpenKeyItem;
			var cfgOKI:Object = ConfigJSON.getInstance().GetItemList("Param").OpenKeyItem;
			var item:Object;
			if (isFlying)	return;
			if (isChanging) return;
			if (int(cfgOKI.Diamond) > GameLogic.getInstance().user.getDiamond())
			{
				GuiMgr.getInstance().guiBuyDiamond.Show(Constant.GUI_MIN_LAYER, 1);
				str = Localization.getInstance().getString("Tooltip97");
				ShowText(str);
				return;
			}
			Exchange.GetInstance().Send(new SendBuyOpenKeyItem("Diamond"));
			GameLogic.getInstance().user.updateDiamond(0 - int(cfgOKI.Diamond));
			GameLogic.getInstance().user.UpdateStockThing("OpenKeyItem", 1);
			for (var i:int = 0; i < openKeyItem.length; i++) 
			{
				item = openKeyItem[i];
				if (int(item[ConfigJSON.KEY_ID]) == 1)
				{
					break;
				}
			}
			(openKeyCtn.LabelArr[0] as TextField).text = "x" + item.Num;
			EffectMgr.setEffBounceDown("Mua thành công", item["ItemType"] + item["Id"], 330, 280);
		}
		
		private function ProcessBuyByG():void 
		{
			var str:String;
			var openKeyItem:Array = GameLogic.getInstance().user.StockThingsArr.OpenKeyItem;
			var cfgOKI:Object = ConfigJSON.getInstance().GetItemList("Param").OpenKeyItem;
			var item:Object;
			if (isFlying)	return;
			if (isChanging) return;
			if (int(cfgOKI.ZMoney) > GameLogic.getInstance().user.GetZMoney())
			{
				GuiMgr.getInstance().GuiNapG.Init();
				str = "Bạn không đủ G";
				ShowText(str);
				return;
			}
			Exchange.GetInstance().Send(new SendBuyOpenKeyItem());
			GameLogic.getInstance().user.UpdateUserZMoney(0 - int(cfgOKI.ZMoney));
			GameLogic.getInstance().user.UpdateStockThing("OpenKeyItem", 1);
			for (var i:int = 0; i < openKeyItem.length; i++) 
			{
				item = openKeyItem[i];
				if (int(item[ConfigJSON.KEY_ID]) == 1)
				{
					break;
				}
			}
			(openKeyCtn.LabelArr[0] as TextField).text = "x" + item.Num;
			EffectMgr.setEffBounceDown("Mua thành công", item["ItemType"] + item["Id"], 330, 280);
		}
		
		private function ProcessUnlockItem():void 
		{
			var sthArr:GetLoadInventory = GameLogic.getInstance().user.StockThingsArr;
			var openKeyItem:Array = GameLogic.getInstance().user.StockThingsArr.OpenKeyItem;
			var item:Object;
			for (var i:int = 0; i < openKeyItem.length; i++) 
			{
				if (int(openKeyItem[i][ConfigJSON.KEY_ID]) == 1)
				{
					item = openKeyItem[i];
					break;
				}
			}
			if(item == null || item.Num == null || int(item.Num) <= 0)
			{
				var str:String = "Bạn không có chìa khóa";
				ShowText(str);
				isFlying = false;
				return;
			}

			var cmd:SendUseOpenKeyItem = new SendUseOpenKeyItem(EquipmentChoose.Type, EquipmentChoose.Id);
			Exchange.GetInstance().Send(cmd);
			
			var arrEquip:Array = sthArr[EquipmentChoose.Type];
			for (var j:int = 0; j < arrEquip.length; j++) 
			{
				var itemEquip:Object = arrEquip[j];
				if (int(itemEquip.Id) == EquipmentChoose.Id)
				{
					itemEquip.IsUsed = false;
					EquipmentChoose.IsUsed = false;
				}
			}
			GameLogic.getInstance().user.UpdateStockThing("OpenKeyItem", 1, -1);
			
			if (openKeyCtn != null)
			{
				(openKeyCtn.LabelArr[0] as TextField).text = "x" + item.Num;
			}
			
			ProcessUnChooseEquip1();
			
			// Load lại kho để refresh trang bị
			UpdateGUIUnlockEquip();
			
			isFlying = false;
		}
		
		private function ShowText(str:String, txtFormat:TextFormat = null):void 
		{
			var posStart:Point = GameInput.getInstance().MousePos;
			var posEnd:Point = new Point(posStart.x, posStart.y - 100);
			if (txtFormat == null)
			{
				txtFormat = new TextFormat(null, 14, 0xFF0000);
				txtFormat.align = "center";
				txtFormat.bold = true;
				txtFormat.font = "Arial";
			}
			Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat);
		}
		
		public override function OnButtonDown(event:MouseEvent, buttonID:String):void
		{
			if (isEnchanting)	return;
			if (isChanging) return;
			if (isFlying) return;
			var a:Array = buttonID.split("_");
			var o:FishEquipment;
			var i:int;
			
			if (listBoxEquipment.getItemById(buttonID))
			{
				if (!listBoxEquipment.getItemById(buttonID).enable)
				{
					return;
				}
			}
			
			switch (a[0])
			{
				case CTN_TYPE_CHANGE_EQUIPMENT_SRC:
					isPicked = false;
					if (ChangeSrcChoose)
					{
						o = ChangeSrcChoose;
					}
				break;
				case CTN_TYPE_CHANGE_EQUIPMENT_DES:
					isPicked = false;
					if (ChangeDesChoose)
					{
						o = ChangeDesChoose;
					}
				break;
				case CTN_TYPE_ENCHANT_EQUIPMENT:
					isPicked = false;
					if (EquipmentChoose)
					{
						o = EquipmentChoose;
					}
					break;
				case CTN_TYPE_EQUIPMENT:
					isPicked = true;
					if (curHighlight)
					{
						curHighlight.SetHighLight( -1);
					}
					// Focus on this container
					curHighlight = listBoxEquipment.getItemById(buttonID);
					curHighlight.SetHighLight();
			
					for (i = 0; i < ItemList.length; i++)
					{
						if (parseInt(a[1]) == ItemList[i].Id)
						{
							o = ItemList[i];
							break;
						}
					}
					break;
				case CTN_TYPE_ENCHANT_SLOT:
					break;
				case CTN_TYPE_MATERIAL:
					break;
			}
			
			if (o)
			{
				curEquip = o;
				
				if (GameLogic.getInstance().CurServerTime - lastTimeClick < DOUBLE_CLICK_TIMER && lastTimeCtn == buttonID)
				{
					if (isPicked)
					{
						ProcessChooseEquip1();
					}
					else
					{
						ProcessUnChooseEquip1();
					}
					
					lastTimeClick = 0;
					lastTimeCtn = "";
					if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
					{
						GuiMgr.getInstance().GuiEquipmentInfo.Hide();
					}
					
					curEquip = null;
					ShowInfo();
				}
				else
				{
					lastTimeClick = GameLogic.getInstance().CurServerTime;
					curEquipImage = new Image(this.img, o.imageName + "_Shop");
					curEquipImage.img.startDrag();
					curEquipImage.img.x = event.stageX - curEquipImage.img.width / 2 - this.CurPos.x;
					curEquipImage.img.y = event.stageY - curEquipImage.img.height / 2 - this.CurPos.y;
					img.addEventListener(MouseEvent.MOUSE_UP, OnReleaseItem);
					lastTimeCtn = buttonID;
					Mouse.cursor = MouseCursor.HAND;
				}
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			var a:Array = buttonID.split("_");
			var obj:Object;
			var c:Container;
			switch (a[0])
			{
				case CTN_TYPE_EQUIPMENT:
					obj = GetEquipmentInfo(parseInt(a[1]));
					c = listBoxEquipment.getItemById(buttonID);
					if (obj && curEquip == null && !isReleaseItem)
					{
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, obj, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
					}
					break;
				case CTN_TYPE_ENCHANT_SLOT:
					c = GetContainer(buttonID);
					if (c.ImageArr[0])
					{
						c.ImageArr[0].SetScaleXY(1.2);
					}
					break;
				case CTN_TYPE_ENCHANT_EQUIPMENT:
				case CTN_TYPE_CHANGE_EQUIPMENT_DES:
				case CTN_TYPE_CHANGE_EQUIPMENT_SRC:
					c = GetContainer(buttonID);
					if (a[0] == CTN_TYPE_ENCHANT_EQUIPMENT) 
					{
						obj = EquipmentChoose;
					}
					else if (a[0] == CTN_TYPE_CHANGE_EQUIPMENT_SRC)
					{
						obj = ChangeSrcChoose;
					}
					else if (a[0] == CTN_TYPE_CHANGE_EQUIPMENT_DES)
					{
						obj = ChangeDesChoose;
					}
					if (obj && curEquip == null && !isReleaseItem)
					{
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, obj, GUIEquipmentInfo.INFO_TYPE_ENCHANT);
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
			
			if (buttonID.split("_")[0] == CTN_TYPE_ENCHANT_SLOT)
			{
				var c:Container = GetContainer(buttonID);
				if (c.ImageArr[0])
				{
					c.ImageArr[0].SetScaleXY(1);
				}
			}
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
			return null;
		}
		
		private function OnReleaseItem(event:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
			// Remove listener
			img.removeEventListener(MouseEvent.MOUSE_UP, OnReleaseItem);
			
			var i:int;		// Count purpose
			
			// Check drag successfully
			if (isPicked)
			{
				var oldUse:FishEquipment;
				if (curEquipImage.img.hitTestObject(enchantCtn.img))
				{
					ProcessChooseEquip1();
				}
			}
			else
			{
				if (!curEquipImage.img.hitTestObject(enchantCtn.img))
				{
					ProcessUnChooseEquip1();
				}
				
			}
			
			// Remove the image follow the mouse
			if (curEquipImage)
			{
				if (curEquipImage.img != null && curEquipImage.img.parent == img)
				{
					curEquipImage.img.stopDrag();
					img.removeChild(curEquipImage.img);
					curEquipImage.Destructor();
				}
			}
			
			curEquip = null;
			isReleaseItem = true;
			
			ShowInfo();
		}
		
		private function ProcessChooseEquip1():void
		{
			if (isEnchanting)	return;
			if (EquipmentChoose)
			{
				ItemList.push(EquipmentChoose);
			}
			
			EquipmentChoose = curEquip;
			ItemList.splice(ItemList.indexOf(curEquip), 1);
			
			ShowEnchantItem(EquipmentChoose);
			scrollPercent = scroll.getScrollCurrentPercent();
			ShowTab(curTab);
		}
		
		private function ProcessUnChooseEquip1():void
		{
			var goToTab:String = "Tab_" + EquipmentChoose.Type;		// Lưu lại để show tab đó
			
			ItemList.push(EquipmentChoose);
			
			ShowEnchantItem();
			scrollPercent = scroll.getScrollCurrentPercent();
			if (curTab != TAB_ALL)
			{
				if (EquipmentChoose.Type != "Ring" && EquipmentChoose.Type != "Bracelet" 
					&& EquipmentChoose.Type != "Necklace" && EquipmentChoose.Type != "Belt")
				{
					ChangeTab(goToTab);
					ShowTab(goToTab);
				}
				else
				{
					ChangeTab(TAB_JEWELRY);
					ShowTab(TAB_JEWELRY);
				}
			}
			else
			{
				ChangeTab(curTab);
				ShowTab(curTab);
			}
			
			EquipmentChoose = null;
		}
		
		public override function OnHideGUI():void
		{
			ResetVariable();
		}
		
	}
}