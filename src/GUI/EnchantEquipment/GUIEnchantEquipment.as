package GUI.EnchantEquipment 
{
	import com.greensock.easing.Quint;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
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
	import NetworkPacket.PacketSend.SendEnchantEquipment;
	import NetworkPacket.PacketSend.SendLoadInventory;
	
	/**
	 * GUI cường hóa trang bị cá lính
	 * @author longpt
	 */
	public class GUIEnchantEquipment extends BaseGUI 
	{
		static public const XBUFF:int = 0;
		static public const YBUFF:int = 0;
		private const XPOS:int = 35;
		private const YPOS:int = 42;
		static public const ICON_HELPER:String = "iconHelper";
		private const CTN_POWERTINH:String = "ctnPowertinh";
		private const CTN_TYPE_CHANGE_EQUIPMENT_DES:String = "ctnTypeChangeEquipmentDes";
		private const CTN_TYPE_CHANGE_EQUIPMENT_SRC:String = "ctnTypeChangeEquipmentSrc";
		private const BTN_CHANGE_MONEY:String = "btnChangeMoney";
		private const BTN_CHANGE_ZMONEY:String = "btnChangeZmoney";
		private const ID_CTN_INFO:String = "idCtnInfo";
		private static const BTN_CLOSE:String = "Btn_Close";
		private static const BTN_BUY_MATERIAL:String = "Btn_Material";
		private static const BTN_ENCHANT:String = "Btn_Enchant";
		private static const BTN_ENCHANT_MONEY:String = "Btn_Enchant_Money";
		private static const BTN_ENCHANT_ZMONEY:String = "Btn_Enchant_G";
		private static const BTN_NEXT:String = "Btn_Next";
		private static const BTN_BACK:String = "Btn_Back";
		//private static const BTN_BUY_GOD_CHARM:String = "Btn_Buy_God_Charm";
		
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
		
		private var btnNext:Button;									// Pointer
		private var btnPre:Button;									// Pointer
		private var btnEnchantMoney:Button;							// Pointer
		private var btnEnchantZMoney:Button;						// Pointer
		private var btnChangeMoney:Button;							// Pointer
		private var btnChangeZMoney:Button;						// Pointer
		
		private static const DOUBLE_CLICK_TIMER:Number = 0.5;
		private static const MAX_ENCHANT_SLOT:int = 8;
		private static const NUM_ELEMENT_IN_LIST:int = 6;
		
		private var curEnchantSlot:int;								// Slot ID of next enchant slot
		private var curEquipImage:Image;							// Image dragable
		private var curEquip:FishEquipment;							// Current Equipment Selected
		private var curMaterial:Container = null;  					// Current Material container selected
		private var enchantCtn:Container = null;					// Container of equip enchanted
		private var changesrcCtn:Container = null;					// Container of equip source change
		private var changedesCtn:Container = null;					// Container of equip destination change
		private var infoCtn:Container = null;						// Container infomations
		private var godCharmSlot:GodCharmSlot = null;				// Container god charm
		private var ctnPowerTinh:Container = null;				// Container god charm
		private var tfPowerTinh:TextField = null;				// Container god charm
		
		private var listBoxEquipment:ListBox = null;				// Component
		private var listBoxMaterial:ListBox = null;					// Component
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
		private var numMaterialChoose:int = 0;
		
		private var lastTimeClick:Number = 0;						// Double click purpose
		private var lastTimeCtn:String = "";						// Double click purpose
		
		private var isReleaseItem:Boolean;							// Flag
		
		private var scrollPercent:Number = 0;						// Goto the current "page" of listBox
		
		private var MaterialList:Array = [];						// Array of materials
		private var MaterialChooseList:Object = new Object();		// Array of materials is chosen to enchant
		public var EquipmentChoose:FishEquipment = null;			// Equip to enchant
		public var ChangeSrcChoose:FishEquipment = null;			// Equip to enchant
		public var ChangeDesChoose:FishEquipment = null;			// Equip to enchant
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var isDataReady:Boolean;
		
		private var _iTab:int = 0;
		public function GUIEnchantEquipment(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIEnchantEquipment";
		}
		
		public override function InitGUI() :void//chuyen thanh tab
		{
			this.setImgInfo = function():void
			{
				SetPos(XPOS, YPOS);
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = 369;
				WaitData.y = 284;
				
				// Load lại kho để refresh trang bị
				var cmd:SendLoadInventory = new SendLoadInventory();
				Exchange.GetInstance().Send(cmd);
				
				//OpenRoomOut();//chuyển thành tab
			}
			//LoadRes("GuiEnchant_Theme");
			LoadRes("KhungFriend");//chuyen thanh tab
		}
		
		public override function EndingRoomOut():void
		{
			//SetPos(35, 10);
			//AddButton(BTN_CLOSE, "BtnThoat", 707, 19);//chuyển thành tab
			
			if (isDataReady)
			{
				ClearComponent();
				RefreshComponent();
			}
		}
		
		public function RefreshComponent(dataAvailable:Boolean = true):void
		{
			isDataReady = dataAvailable;
			//if (!isDataReady || !IsFinishRoomOut)
			//{
				//return;
			//}
			if (!isDataReady)//chuyển thành tab => không còn IsFinishRoomOut
			{
				return;
			}
			
			if (img == null) return;
			
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}			
			
			ResetVariable();
			
			ShowInfo();
			ShowGodCharmSlot();
			ShowEnchantItem();
			ShowEnchantSlots();
			AddButtons();
			ChangeTab(TAB_ALL);
			ShowTab(TAB_ALL, true);
			ShowMaterial();
			
			//Tutorial
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("EquipmentEnchant") >= 0)
			{
				AddImage(ICON_HELPER, "IcHelper", 20 + 429, 148+20);
			}
		}
		
		private function ShowGodCharmSlot():void
		{
			if (godCharmSlot == null)
			{
				godCharmSlot = new GodCharmSlot(infoCtn.img, "GuiEnchant_CtnGodCharm", 30 + XBUFF, 14 + YBUFF);
			}
			godCharmSlot.refreshInfo(EquipmentChoose);
		}
		
		public function ShowInfo():void
		{
			if (_iTab == 1)
			{
				ShowInfo2();
				return;
			}
			if (infoCtn == null)
			{
				infoCtn = AddContainer("", "GuiEnchant_CtnInfoEnchant", 50, 80);
			}
			else
			{
				infoCtn.ClearComponent();
			}
			
			if (btnEnchantMoney == null)
			{
				btnEnchantMoney = AddButton(BTN_ENCHANT_MONEY, "GuiEnchant_BtnEnchant_Money", 97 + XBUFF, 290 + YBUFF);
			}
			if (btnEnchantZMoney == null)
			{
				btnEnchantZMoney = AddButton(BTN_ENCHANT_ZMONEY, "GuiEnchant_BtnEnchant_ZMoney", 207 + XBUFF, 290 + YBUFF);
			}
			btnEnchantMoney.SetDisable();
			btnEnchantZMoney.SetDisable();
			var txtField:TextField;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 16;
			txtFormat.color = 0xF2F2F2;
			txtFormat.bold = true;
			txtFormat.align = "center";
			if (!EquipmentChoose)
			{				
				txtField = infoCtn.AddLabel(Localization.getInstance().getString("EnchantMsg1"), 55, 132);
				txtField.wordWrap = true;
				txtField.width = 175;
				txtField.setTextFormat(txtFormat);
				
				if (btnEnchantMoney != null)
				{
					btnEnchantMoney.SetDisable();
				}
				
				if (btnEnchantZMoney != null)
				{
					btnEnchantZMoney.SetDisable();
				}
			}
			else
			{
				// Nếu đã cường hóa tối đa (9 lần)
				if (EquipmentChoose.EnchantLevel >= Constant.MAX_ENCHANT_TIMES)
				{
					txtField = infoCtn.AddLabel(Localization.getInstance().getString("EnchantMsg5"), 55, 132);
					txtField.wordWrap = true;
					txtField.width = 175;
					txtField.setTextFormat(txtFormat);
					
					if (btnEnchantMoney != null)
					{
						btnEnchantMoney.SetDisable();
					}
					
					if (btnEnchantZMoney != null)
					{
						btnEnchantZMoney.SetDisable();
					}
					
					return;
				}
				
				// Get config
				//var cfg:Object = ConfigJSON.getInstance().getItemInfo("EnchantEquipment_" + Ultility.GetConfigListNameSuffix(EquipmentChoose.Type), EquipmentChoose.Color);
				var cfg:Object = ConfigJSON.getInstance().getItemInfo("EnchantEquipment_" + Ultility.GetConfigListNameSuffix(EquipmentChoose.Type), EquipmentChoose.Rank % 100);
				cfg = cfg[EquipmentChoose.Color][EquipmentChoose.EnchantLevel + 1];
				
				if (numMaterialChoose > 0)
				{
					txtField = infoCtn.AddLabel(Localization.getInstance().getString("EnchantMsg4"), 74, 132);
					txtField.setTextFormat(txtFormat);
					
					txtField = infoCtn.AddLabel(GetSuccessRatio(cfg) + "%", 165, 132);
					txtFormat = new TextFormat();
					txtFormat.size = 16;
					txtFormat.color = 0xF9EC31;
					txtFormat.bold = true;
					txtField.setTextFormat(txtFormat);
					
					// Hiển thị có bị giảm sao hay không
					if (godCharmSlot.GetCheckBoxStatus())
					{
						txtField = infoCtn.AddLabel(Localization.getInstance().getString("EnchantMsg7"), 100, 152, 0x000000, 1, 0x000000);
						txtFormat = new TextFormat();
						txtFormat.size = 14;
						txtFormat.color = 0x00FF00;
						txtFormat.bold = true;
						txtFormat.align = "center";
						txtField.setTextFormat(txtFormat);
					}
					else
					{
						txtField = infoCtn.AddLabel(Localization.getInstance().getString("EnchantMsg8"), 100, 152, 0x000000, 1, 0x000000);
						txtFormat = new TextFormat();
						txtFormat.size = 14;
						txtFormat.color = 0xFF0000;
						txtFormat.bold = true;
						txtFormat.align = "center";
						txtField.setTextFormat(txtFormat);
					}
					
					// Add Price Money
					//infoCtn.AddImage("", "GuiEnchant_IcMoney", 90, 160);
					txtField = infoCtn.AddLabel(Ultility.StandardNumber(cfg.Money), 75, 185, 0x000000, 0);
					txtFormat = new TextFormat();
					txtFormat.size = 14;
					txtFormat.color = 0xF9EC31;
					txtFormat.bold = true;
					txtFormat.align = "center";
					txtField.setTextFormat(txtFormat);
					
					// Add Price ZMoney
					//infoCtn.AddImage("", "GuiEnchant_IcZMoney", 90, 160);
					txtField = infoCtn.AddLabel(Ultility.StandardNumber(cfg.ZMoney), 195, 185, 0x000000, 0);
					txtField.setTextFormat(txtFormat);
					
					if (btnEnchantMoney != null)
					{
						btnEnchantMoney.SetEnable();
					}
					
					if (btnEnchantZMoney != null)
					{
						btnEnchantZMoney.SetEnable();
					}
				}
				else
				{
					txtField = infoCtn.AddLabel(Localization.getInstance().getString("EnchantMsg3"), 55, 132);
					txtField.wordWrap = true;
					txtField.width = 175;
					txtField.setTextFormat(txtFormat);
					
					if (btnEnchantMoney != null)
					{
						btnEnchantMoney.SetDisable();
					}
					
					if (btnEnchantZMoney != null)
					{
						btnEnchantZMoney.SetDisable();
					}
				}
				
				//if (cfg.Money > GameLogic.getInstance().user.GetMoney())
				//{
					//btnEnchant.SetDisable();
				//}
			}
		}
		
		private function ShowEnchantItem(eq:FishEquipment = null):void
		{
			enchantCtn = ShowEnchantItem2(eq, CTN_TYPE_ENCHANT_EQUIPMENT);
			//if (enchantCtn == null)
			//{
				//enchantCtn = AddContainer(CTN_TYPE_ENCHANT_EQUIPMENT, "GuiEnchant_CtnEnchantEquipment", 164, 100, true, this);
			//}
			//else
			//{
				//enchantCtn.ClearComponent();
			//}
			//
			//if (eq)
			//{
				// Add nền nếu là đồ quý, đặc biệt
				//if (eq.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
				//{
					//enchantCtn.AddImage("", FishEquipment.GetBackgroundName(eq.Color), 0, 0, true, ALIGN_LEFT_TOP);
				//}
				//var imag:Image = enchantCtn.AddImage("", eq.imageName + "_Shop", 0, 0);
				//imag.FitRect(60, 60, new Point(7, 7));
//
				//FishSoldier.EquipmentEffect(imag.img, eq.Color);
				//
				//if (eq.EnchantLevel > 0)
				//{
					//var txt:TextField = enchantCtn.AddLabel("+" + eq.EnchantLevel, 2, 2, 0xFFF100, 0, 0x603813);
					//var tF:TextFormat = new TextFormat();
					//tF.size = 18;
					//tF.bold = true;
					//txt.setTextFormat(tF);
				//}
			//}
		}
		private function ShowEnchantItem2(eq:FishEquipment = null, idCtn:String = null,  x:int = 164, y:int = 100):Container
		{
			var ctn:Container = GetContainer(idCtn);
			if (ctn == null)
			{
				ctn = AddContainer(idCtn, "GuiEnchant_CtnEnchantEquipment", x, y, true, this);
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
				var icMax:Image;
				if (eq.Color == 6)
				{
					icMax = ctn.AddImage("", "IcMax", 74, 26);
					icMax.SetScaleXY(0.7);
				}
			}
			return ctn;
		}
		
		private function ShowEnchantSlots(num:int = MAX_ENCHANT_SLOT):void
		{
			var i:int;
			var ctn:Container;
			
			var x0:int = 102;
			var y0:int = 318;
			
			var dx:int = 50;
			var dy:int = 53;
			if (_iTab == 1)
			{
				x0 = 72;
				y0 = 320;
				dx = 47;
				dy = 50;
			}
			var maxCol:int = 4;
			
			curEnchantSlot = 0;
			for (i = 0; i < num; i++)
			{
				if (!MaterialChooseList[String(i)])
				{
					MaterialChooseList[String(i)] = 0;
				}
				
				ctn = AddContainer(CTN_TYPE_ENCHANT_SLOT + "_" + i, "GuiEnchant_CtnEnchantSlot", x0 + dx * (i % maxCol) + XBUFF, y0 + dy * int(i / maxCol) + YBUFF, true, this);
				ctn.SetScaleXY(0.6);
				
				if (MaterialChooseList[String(i)] != 0)
				{
					ctn.AddImage("", GetMaterialName(MaterialChooseList[String(i)]), 0, 0).FitRect(50, 50, new Point(5, 5));
				}
				
				//if (i >= numEnchantableSlot)
				//{
					//ctn.AddImage("", "ImgShopItemLock", 0, 0).FitRect(50, 50, new Point(7, 7));
				//}
			}
			
			FindNextSlot();
		}
		
		/**
		 * All buttons add here
		 */
		private function AddButtons():void
		{
			imgAll = AddImage(IMG_ALL, "GuiEnchant_ImgBtnAll", 382 + XBUFF, 80 + YBUFF, true, ALIGN_LEFT_TOP);
			imgHelmet = AddImage(IMG_HELMET, "GuiEnchant_ImgBtnHelmet", imgAll.CurPos.x + 60 + XBUFF, 79 + YBUFF, true, ALIGN_LEFT_TOP);
			imgArmor = AddImage(IMG_ARMOR, "GuiEnchant_ImgBtnArmor", imgHelmet.CurPos.x + 60 + XBUFF, 79 + YBUFF, true, ALIGN_LEFT_TOP);
			imgWeapon = AddImage(IMG_WEAPON, "GuiEnchant_ImgBtnWeapon", imgArmor.CurPos.x + 60 + XBUFF, 79 + YBUFF, true, ALIGN_LEFT_TOP);
			imgJewelry = AddImage(IMG_JEWELRY, "GuiEnchant_ImgBtnJewelry", imgWeapon.CurPos.x + 60 + XBUFF, 79 + YBUFF, true, ALIGN_LEFT_TOP);
			
			btnAll = AddButton(TAB_ALL, "GuiEnchant_BtnAll", imgAll.CurPos.x + XBUFF, imgAll.CurPos.y + YBUFF);
			var tt:TooltipFormat = new TooltipFormat();
			tt.text = "Tất cả";
			btnAll.setTooltip(tt);
				
			btnHelmet = AddButton(TAB_HELMET, "GuiEnchant_BtnHelmet", imgHelmet.CurPos.x + XBUFF, imgHelmet.CurPos.y + YBUFF);
			tt = new TooltipFormat();
			tt.text = "Mũ giáp";
			btnHelmet.setTooltip(tt);
			
			btnArmor = AddButton(TAB_ARMOR, "GuiEnchant_BtnArmor", imgArmor.CurPos.x + XBUFF, imgArmor.CurPos.y + YBUFF);
			tt = new TooltipFormat();
			tt.text = "Áo giáp";
			btnArmor.setTooltip(tt);
			
			btnWeapon = AddButton(TAB_WEAPON, "GuiEnchant_BtnWeapon", imgWeapon.CurPos.x + XBUFF, imgWeapon.CurPos.y + YBUFF);
			tt = new TooltipFormat();
			tt.text = "Vũ khí";
			btnWeapon.setTooltip(tt);
			
			btnJewelry = AddButton(TAB_JEWELRY, "GuiEnchant_BtnJewelry", imgJewelry.CurPos.x + XBUFF, imgJewelry.CurPos.y + YBUFF);
			tt = new TooltipFormat();
			tt.text = "Trang sức";
			btnJewelry.setTooltip(tt);
			
			// All other buttons
			//AddButton(BTN_CLOSE, "BtnThoat", 707, 19);//chuyen thanh tab
			AddButton(BTN_BUY_MATERIAL, "GuiEnchant_BtnShop", 78 + XBUFF, 479 + YBUFF).SetDisable();
			
			
			
			btnNext = AddButton(BTN_NEXT, "GuiEnchant_BtnNextShop", 615 + XBUFF, 479 + YBUFF);
			btnPre = AddButton(BTN_BACK, "GuiEnchant_BtnPreShop", 130 + XBUFF, 479 + YBUFF);
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
		
		/**
		 * List all materials of user
		 */
		public function ShowMaterial(page:int = 0, isUpdate:Boolean = false):void
		{
			var i:int;
			
			if (listBoxMaterial == null)
			{
				listBoxMaterial = AddListBox(ListBox.LIST_X, 1, NUM_ELEMENT_IN_LIST, 7, 0);
				listBoxMaterial.setPos(170 + XBUFF, 464 + YBUFF);
			}
			else
			{
				listBoxMaterial.removeAllItem();
			}
			
			if (MaterialList.length == 0 || isUpdate)
			{
				MaterialList.splice(0, MaterialList.length);
				MaterialList = GetMaterialsList();
			}
			
			// Re-sort >"<
			for (i = 0; i < MaterialList.length; i++)
			{
				if (!MaterialList[i].IdObject)
				{
					AddIdObject(MaterialList[i]);
				}
			}
			MaterialList = MaterialList.sortOn("IdObject", Array.NUMERIC);
			
			for (i = 0; i < MaterialList.length; i++)
			{
				AddOneMaterial(MaterialList[i]);
			}
			
			listBoxMaterial.showPage(page);
			UpdateButtonListBox(listBoxMaterial);
		}
		
		public function ShowTab(buttonID:String, isInit:Boolean = false):void
		{
			ClearScroll();
			//ClearListBox();
			curHighlight = null;
			
			// Re-add list box
			if (listBoxEquipment == null)
			{
				listBoxEquipment = AddListBox(ListBox.LIST_Y, 3, 3, 3, 5);
				listBoxEquipment.setPos(393 + XBUFF, 149 + YBUFF);
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
			scroll = AddScroll("", "GuiEnchant_ScrollBar", 630 + XBUFF, 140 + YBUFF);
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
				if (!EquipmentChoose || tempList[i].Id != EquipmentChoose.Id)
				{
					ItemList.push(tempList[i]);
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
				//ctn.AddImage("", FishEquipment.GetBackgroundName(o.Color), 0, 0, true, ALIGN_LEFT_TOP);
				ctn.AddImage("", FishEquipment.GetBackgroundName(o.Color), -4, -2, true, ALIGN_LEFT_TOP, true);
			}
			else
			{
				ctn.AddImage("", "GuiEnchant_CtnEquipment", 0, 0, true, ALIGN_LEFT_TOP);
			}
			
			var imag:Image = ctn.AddImage("", o.imageName + "_Shop", 10, 10);
			imag.setImgInfo = function f():void { FishSoldier.EquipmentEffect(imag.img, o.Color) };
			imag.FitRect(60, 60, new Point(7, 7));
			FishSoldier.EquipmentEffect(imag.img, o.Color);
			var icMax:Image;
			if (o.Color == 6)
			{
				icMax = ctn.AddImage("", "IcMax", 74, 26);
				icMax.SetScaleXY(0.7);
			}
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
				ctn = AddContainer("Ctn_" + "Empty", "GuiEnchant_CtnEquipment", 10 + XBUFF, 10 + YBUFF, true, this);
				listBoxEquipment.addItem(ctn.IdObject, ctn, this);
				ContainerArr.splice(ContainerArr.length - 1, 1);
			}
		}
		
		private function ResetVariable():void
		{
			listBoxEquipment = null;
			listBoxMaterial = null;
			enchantCtn = null;
			infoCtn = null;
			godCharmSlot = null;
			ItemList = [];
			MaterialChooseList = new Object();
			MaterialList = [];
			EquipmentChoose = null;
			btnEnchantMoney = null;
			btnEnchantZMoney = null;
			numMaterialChoose = 0;
			
			_iTab = 0;
			ChangeSrcChoose = null;
			ChangeDesChoose = null;
			changesrcCtn = null;
			changedesCtn = null;
			btnChangeMoney = null;
			btnChangeZMoney = null;
			ctnPowerTinh = null;
			tfPowerTinh = null;
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			if (isEnchanting)	return;
			switch (buttonID)
			{
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
				case BTN_BUY_MATERIAL:
					//this.Hide();
					GuiMgr.getInstance().GuiShop.CurrentShop = "Special";
					GuiMgr.getInstance().GuiShop.curPage = 2;
					GameController.getInstance().UseTool("Shop");
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
				//case BTN_ENCHANT:
					//processEnchantEquip(true);
					//break;
				case BTN_ENCHANT_MONEY:
					RemoveImage(GetImage(ICON_HELPER));
					processEnchantEquip(true);
					break;
				case BTN_ENCHANT_ZMONEY:
					processEnchantEquip(false);
					break;
				case BTN_CHANGE_MONEY:
					processEnchantEquip2(true);
				break;
				case BTN_CHANGE_ZMONEY:
					processEnchantEquip2(false);
				break;
				case BTN_NEXT:
					listBoxMaterial.showNextPage();
					UpdateButtonListBox(listBoxMaterial);
					break;
				case BTN_BACK:
					listBoxMaterial.showPrePage();
					UpdateButtonListBox(listBoxMaterial);
					break;
				default:
					var arr:Array = buttonID.split("_");
					if (arr[0] == CTN_TYPE_MATERIAL)							//	Click on materials to use!
					{
						if (_iTab == 0 && EquipmentChoose == null)	break;		//	Must choose equipment first
						if (isFlying) 								break;		//	If effect is not finish
						if (curEnchantSlot >= numEnchantableSlot)	break;		//	If has been reach max slot allow
						if (curEnchantSlot >= MAX_ENCHANT_SLOT)		break;		//	If has been reach max slot allow
						if (_iTab == 1 && (ChangeSrcChoose == null || ChangeDesChoose == null)) 
							break;
						EffectMaterialIn(listBoxMaterial.getItemById(buttonID), int(arr[1]));
						UpdateMaterials(int(arr[1]));
						break;
					}
					
					if (arr[0] == CTN_TYPE_ENCHANT_SLOT)						//	Click to un-do use materials
					{
						if (int(arr[1]) < numEnchantableSlot)
						{
							if (isFlying) 								break;		//	If effect is not finish
							if (MaterialChooseList[arr[1]])
							{
								//var id:int = MaterialChooseList[arr[1]];			// Id of material
								//
								EffectMaterialOut(GetContainer(buttonID), MaterialChooseList[arr[1]]);
								UpdateMaterials(MaterialChooseList[arr[1]], arr[1]);
								break;
							}
						}
						else
						{
							
						}
					}
					break;
			}
		}

		public override function OnButtonDown(event:MouseEvent, buttonID:String):void
		{
			if (isEnchanting)	return;
			if (isChanging) return;
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
						ProcessChooseEquip();
					}
					else
					{
						ProcessUnChooseEquip();
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
				case CTN_TYPE_MATERIAL:
					if (curMaterial != null)
					{
						curMaterial.SetHighLight( -1);
					}
					curMaterial = listBoxMaterial.getItemById(buttonID);
					curMaterial.SetHighLight();
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
			
			if (curMaterial)
			{
				curMaterial.SetHighLight( -1);
			}
			
			if (buttonID.split("_")[0] == CTN_TYPE_ENCHANT_SLOT)
			{
				var c:Container = GetContainer(buttonID);
				if (c.ImageArr[0])
				{
					c.ImageArr[0].SetScaleXY(1);
				}
			}
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
				if (_iTab == 0)
				{
					if (curEquipImage.img.hitTestObject(enchantCtn.img))					// if collision detected
					{
						ProcessChooseEquip();
					}
				}
				else if (_iTab == 1)
				{
					if (curEquipImage.img.hitTestObject(changesrcCtn.img))
					{
						ProcessChooseEquip2(true);
					}
					if(curEquipImage.img.hitTestObject(changedesCtn.img))
					{
						ProcessChooseEquip2(false);
					}
				}
			}
			else
			{
				if (_iTab == 0)
				{
					if (!curEquipImage.img.hitTestObject(enchantCtn.img))
					{
						ProcessUnChooseEquip();
					}
				}
				else if (_iTab == 1)
				{
					if (!curEquipImage.img.hitTestObject(changesrcCtn.img) &&
						!curEquipImage.img.hitTestObject(changedesCtn.img))
					{
						ProcessUnChooseEquip();
					}
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
		
		private function processEnchantEquip(isMoney:Boolean):void
		{
			//Đang khóa hoặc xin phá khóa
			var passwordState:String = GameLogic.getInstance().user.passwordState;
			if (passwordState == Constant.PW_STATE_IS_LOCK || passwordState == Constant.PW_STATE_IS_CRACKING || passwordState == Constant.PW_STATE_IS_BLOCKED)
			{
				GuiMgr.getInstance().guiPassword.showGUI();
				return;
			}
			if (EquipmentChoose == null)
			{
				return;
			}
			
			// Get config
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("EnchantEquipment_" + Ultility.GetConfigListNameSuffix(EquipmentChoose.Type), EquipmentChoose.Rank % 100);
			cfg = cfg[EquipmentChoose.Color][EquipmentChoose.EnchantLevel + 1];
			
			if (cfg.Money > GameLogic.getInstance().user.GetMoney() && isMoney)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("EnchantMsg6"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
				return;
			}
			else if (cfg.ZMoney > GameLogic.getInstance().user.GetZMoney() && !isMoney)
			{
				GuiMgr.getInstance().GuiNapG.Init();
				return;
			}
			
			isEnchanting = true;
			btnEnchantMoney.SetDisable();
			btnEnchantZMoney.SetDisable();

			var arr:Array = [];
			var s:String;
			var obj:Object = new Object();
			
			for (s in MaterialChooseList)
			{
				if (MaterialChooseList[s] != 0)
				{
					if (obj[MaterialChooseList[s]])
					{
						obj[MaterialChooseList[s]] += 1;
					}
					else
					{
						obj[MaterialChooseList[s]] = 1;
					}
				}
			}
			for (s in obj)
			{
				var o:Object = new Object();
				o.ItemId = FindIdByIdObject(int(s));
				o.Num = obj[s];
				arr.push(o);
			}
			
			if (arr.length == 0)
			{
				isEnchanting = false;
				btnEnchantMoney.SetEnable();
				return;
			}
			
			var enchant:SendEnchantEquipment = new SendEnchantEquipment(EquipmentChoose.Type, EquipmentChoose.Id, isMoney, arr, godCharmSlot.GetCheckBoxStatus());
			Exchange.GetInstance().Send(enchant);
			
			// Update ngư thạch trong kho
			for (var i:int = 0; i < arr.length; i++)
			{
				GuiMgr.getInstance().GuiStore.UpdateStore("Material", arr[i].ItemId, -arr[i].Num);
			}
		}
		
		private function ProcessChooseEquip():void
		{
			if (_iTab == 1)
			{
				ProcessChooseEquip2();
				return;
			}
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
			
			ShowGodCharmSlot();
			
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("ChooseEnchantMaterial") >= 0)
			{
				GetImage(ICON_HELPER).SetPos(220, 489);
			}
		}
		
		private function ProcessUnChooseEquip():void
		{
			if (_iTab == 1)
			{
				processUnChooseEquip2();
				return;
			}
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
			
			ShowGodCharmSlot();
		}
		
		private function GetMaterialsList():Array
		{
			var a:Array = [];
			var b:Array = GameLogic.getInstance().user.StockThingsArr.Material;
			var i:int;
			for (i = 0; i < b.length; i++)
			{
				var obj:Object = new Object();
				for (var s:String in b[i])
				{
					obj[s] = b[i][s];
					
					if (s == "Num")
					{
						for (var j:String in MaterialChooseList)
						{
							if (FindIdByIdObject(MaterialChooseList[j]) == b[i].Id)
							{
								obj[s] = obj[s] - 1;
							}
						}
					}
				}
				a.push(obj);
			}
			return a;
		}
		
		private function AddOneMaterial(o:Object):Container
		{
			var ctn:Container;
			ctn = AddContainer(CTN_TYPE_MATERIAL + "_" + o.IdObject, "GuiEnchant_SlotMaterial", 10 + XBUFF, 10 + YBUFF, true, this);
			
			var imag:Image = ctn.AddImage(CTN_TYPE_MATERIAL + "_" + o.Id, GetMaterialName(o), 0, 0);
			imag.FitRect(50, 50, new Point(5, 5));
			ctn.AddLabel(o.Num, 0, 40, 0xffffff, 1, 0x26709C);
			
			var ttip:TooltipFormat = new TooltipFormat();
			var rank:String;
			if (o.Id < Constant.MAX_NORMAL_MATERIAL)
			{
				rank = String(o.Id);
			}
			else
			{
				rank = String(o.Id - 100) + " đặc biệt";
			}
			var str:String = Localization.getInstance().getString("EnchantMsg2");
			if (int(o["Id"]) % 100 > 10)
			{
				str = Localization.getInstance().getString("EnchantMsg10");
			}
			str = str.replace("@Rank@", String(rank)); 
			ttip.text = str;
			ctn.setTooltip(ttip);
			
			listBoxMaterial.addItem(ctn.IdObject, ctn, this);
			ContainerArr.splice(ContainerArr.length - 1, 1);
			return ctn;
		}
		
		private function GetMaterialName(o:Object):String
		{
			var str:String;
			
			if (o.Id <= Constant.MAX_NORMAL_MATERIAL)		// ngư thạch thường
			{
				str = o.ItemType + o.Id;
			}
			else		// super
			{
				str = o.ItemType + int(o.Id - 100) + "S";
			}
			return str;
		}
		
		public override function OnHideGUI():void
		{
			ResetVariable();
			//tắt đi thì mới bật phần nhận thưởng quest
			var questArr:Array = QuestMgr.getInstance().finishedQuest;
			if (questArr.length > 0)
			{
				GameLogic.getInstance().OnQuestDone(questArr[0]);		
				questArr.splice(0, 1);
			}
		}
		
		/**
		 * Get all info of one Equipment by it's Id (in ItemList or in current Soldier Equipment)
		 * @param	id
		 * @return
		 */
		private function GetEquipmentInfo(id:int):FishEquipment
		{
			//var ItemList1:Array = GetEquipmentList(TAB_ALL);
			for (var i:int = 0; i < ItemList.length; i++)
			{
				if (ItemList[i].Id == id)
				{
					return ItemList[i];
				}
			}
			return null;
		}
		
		private function EffectMaterialIn(ctn:Container, id:int):void
		{
			var mc:Sprite = Ultility.CloneImage(ctn.ImageArr[0].img);
			img.addChild(mc);
			var point:Point = img.globalToLocal(ctn.img.localToGlobal(new Point(ctn.ImageArr[0].img.x / 2, ctn.ImageArr[0].img.y)));
			mc.x = point.x;
			mc.y = point.y;
			var slotOfMaterial:Container = GetContainer(CTN_TYPE_ENCHANT_SLOT + "_" + curEnchantSlot);
			point = img.globalToLocal(slotOfMaterial.img.localToGlobal(new Point(slotOfMaterial.img.width / 2, slotOfMaterial.img.height / 2)));
			isFlying = true;
			TweenMax.to(mc, 0.1, { bezierThrough:[ { x:(point.x ), y:(point.y) } ], ease:Quint.easeOut, 
			onComplete:onFinishTween, onCompleteParams:[mc, slotOfMaterial, 5 , 5] } );
		}
		
		private function EffectMaterialOut(ctn:Container, id:int):void
		{
			var mc:Sprite = Ultility.CloneImage(ctn.ImageArr[0].img);
			img.addChild(mc);
			var point:Point = img.globalToLocal(ctn.img.localToGlobal(new Point(ctn.img.width / 2, ctn.img.height / 2)));
			mc.x = point.x;
			mc.y = point.y;
			
			ctn.ClearComponent();
			
			
			var i:int;
			var isHaveContainer:Boolean = false;
			for (i = 0; i < MaterialList.length; i++)
			{
				if (MaterialList[i].IdObject == id)
				{
					isHaveContainer = true;
					break;
				}
			}
			
			if (!isHaveContainer)
			{
				var ob:Object = new Object();
				ob.ItemType = "Material";
				ob.Id = FindIdByIdObject(id);
				ob.Num = 0;
				MaterialList.push(ob);
				ShowMaterial();
			}
			
			var container:Container = listBoxMaterial.getItemById(CTN_TYPE_MATERIAL + "_" + id);
			var indexMaterial:int = listBoxMaterial.getIndexById(CTN_TYPE_MATERIAL + "_" + id);
			var indexStart:int = int(indexMaterial / NUM_ELEMENT_IN_LIST ) * NUM_ELEMENT_IN_LIST;
			var indexEnd:int = (int(indexMaterial / NUM_ELEMENT_IN_LIST) + 1) * NUM_ELEMENT_IN_LIST;
			
			listBoxMaterial.showPage(int(indexMaterial / NUM_ELEMENT_IN_LIST));
			point = img.globalToLocal(container.img.localToGlobal(new Point(container.img.width / 2, 0)));
			
			isFlying = true;
			TweenMax.to(mc, 0.4, { bezierThrough:[{ x:(point.x ), y:(point.y + container.img.height / 2) } ], 
						ease:Quint.easeOut, onComplete:onFinishTweenRemove, onCompleteParams:[mc, container, id] } );
			
			UpdateButtonListBox(listBoxMaterial);
		}
		
		/**
		 * Add anh trong sprite mc vao trong container ctn tai vi tri x, y
		 * @param	mc
		 * @param	ctn
		 * @param	x
		 * @param	y
		 */
		private function onFinishTween(mc:Sprite, ctn:Container, x:int, y:int):void 
		{
			ctn.ClearComponent();
			ctn.AddImageBySprite(mc, x, y).FitRect(60, 60, new Point(x, y));
			isFlying = false;
			FindNextSlot();
			
			numMaterialChoose++;
			ShowInfo();
			
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("DoEnchant") >= 0)
			{
				GetImage(ICON_HELPER).SetPos(150, 302);
			}
		}
		
		/**
		 * Cộng thêm 1 vào ngư thạch trong list
		 * @param	mc	
		 * @param	ctn		COntainer chứa ngư thạch
		 * @param	id
		 */
		private function onFinishTweenRemove(mc:Sprite, ctn:Container, id:int):void
		{
			mc.parent.removeChild(mc);
			isFlying = false;
			ctn.LabelArr[0].text = String(int (ctn.LabelArr[0].text) + 1);
			FindNextSlot();
			
			numMaterialChoose--;
			ShowInfo();
		}
		
		private function UpdateMaterials(id:int, pos:int = -1):void
		{
			var i:int;
			if (pos < 0)		// minus
			{
				for (i = 0; i < MaterialList.length; i++)
				{
					if (MaterialList[i].IdObject == id)
					{
						MaterialList[i].Num -= 1;
						if (MaterialList[i].Num == 0)
						{
							MaterialList.splice(i, 1);
							listBoxMaterial.removeItem(CTN_TYPE_MATERIAL + "_" + id);
						}
						else
						{
							var ctn:Container = listBoxMaterial.getItemById(CTN_TYPE_MATERIAL + "_" + id);
							ctn.ClearLabel();
							ctn.AddLabel(MaterialList[i].Num, 0, 40, 0xffffff, 1, 0x26709C);
						}
						
						var str:String = String(curEnchantSlot);
						MaterialChooseList[str] = id;
						break;
					}
				}
			}
			else	// plus
			{
				var bPush:Boolean = true;
				for (i = 0; i < MaterialList.length; i++)
				{
					if (MaterialList[i].IdObject == id)
					{
						MaterialList[i].Num += 1;
						MaterialChooseList[pos] = 0;
						bPush = false;
						break;
					}
				}
				if (bPush)
				{
					var o:Object = new Object();
					o["IdObject"] = id;
					o["Num"] = 1;
					o["Id"] = FindIdByIdObject(id);
					o["ItemType"] = "Material";
					MaterialChooseList[pos] = 0;
					MaterialList.push(o);
				}
			}
		}
		
		/**
		 * Add thêm IdObject cho 1 đối tượng Material, phục vụ việc sort lại các viên cấp S
		 * @param	obj
		 */
		private function AddIdObject(obj:Object):void
		{
			if (obj.Id < Constant.MAX_NORMAL_MATERIAL)
			{
				obj.IdObject = int(String(obj.Id) + "0");
			}
			else
			{
				obj.IdObject = int(String(obj.Id - Constant.MAX_NORMAL_MATERIAL) + "1");
			}
		}
		
		private function FindNextSlot():void
		{
			var i:int;
			for (i = 0; i < MAX_ENCHANT_SLOT; i ++)
			{
				if (MaterialChooseList[String(i)] == 0 && i < numEnchantableSlot)
				{
					curEnchantSlot = i;
					return;
				}
			}
			curEnchantSlot = numEnchantableSlot;
		}
		
		/**
		 * Tìm Id của 1 material thông qua IdObject xài để sort
		 * @param	IdObject
		 * @return
		 */
		private function FindIdByIdObject(IdObject:int):int
		{
			var str:String = String(IdObject);
			var suffix:String = str.substr(str.length - 1, 1);
			if (suffix == "0")
			{
				return int(str.substr(0, str.length - 1));
			}
			else
			{
				return int(str.substr(0, str.length - 1)) + 100;
			}
		}
		
		private function UpdateButtonListBox(listBox:ListBox):void
		{
			if (listBox.getNumPage() <= 1)
			{
				btnNext.SetDisable();
				btnPre.SetDisable();
			}
			else 
			{
				switch (listBox.curPage) 
				{
					case 0:
						btnPre.SetDisable();
						btnNext.SetEnable();
					break;
					
					case listBox.getNumPage() - 1:
						btnNext.SetEnable(false);
						btnPre.SetEnable();
					break;
					
					default:
						btnPre.SetEnable();
						btnNext.SetEnable();
					break;
					
				}
			}
		}
		
		public function ProcessUnlockEnchantSlot(numUnlock:int):void
		{
			GetContainer(CTN_TYPE_ENCHANT_SLOT + "_" + numEnchantableSlot).ClearComponent();
			numEnchantableSlot = numUnlock;
		}
		
		public function ProcessEnchantEquipAfter(isSuccess:Boolean, isMoney:Boolean, isUseGodCharm:Boolean, lvAfter:int):void
		{
			// Get config
			var cfg:Object = ConfigJSON.getInstance().getItemInfo("EnchantEquipment_" + Ultility.GetConfigListNameSuffix(EquipmentChoose.Type), EquipmentChoose.Rank % 100);
				cfg = cfg[EquipmentChoose.Color][EquipmentChoose.EnchantLevel + 1];

			// Trừ tiền user
			if (isMoney)
			{
				GameLogic.getInstance().user.UpdateUserMoney( -cfg.Money);
			}
			else
			{
				GameLogic.getInstance().user.UpdateUserZMoney( -cfg.ZMoney);
			}
			
			//isEnchanting = true;
			// Tọa độ fix cứng :">
			var ef:SwfEffect = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiEnchant_EffEnchant", null, 451, 380,
							false, false, null, function():void { UpdateEquipment(isSuccess, isUseGodCharm, lvAfter) } );

			var child:DisplayObject;
			if (isSuccess)
			{
				child = Ultility.findChild(ef.img, "Fail");
			}
			else
			{
				child = Ultility.findChild(ef.img, "Success");
			}
			
			child.parent.removeChild(child);
		}
		
		private function UpdateEquipment(isSuccess:Boolean, isUseGodCharm:Boolean, lvAfter:int):void
		{
			if (isUseGodCharm)
			{
				GuiMgr.getInstance().GuiStore.UpdateStore("GodCharm", GetGodCharmId(EquipmentChoose), -1);
				godCharmSlot.refreshInfo(EquipmentChoose);
			}
			
			var i:int;
			// Cập nhật mảng MaterialChooseList
			for (i = 0; i < MAX_ENCHANT_SLOT; i++)
			{
				MaterialChooseList[i] = 0;
			}
			FindNextSlot();
			
			// Cập nhật ngư thạch ở slot (xóa hết đi)
			for (i = 0; i < MAX_ENCHANT_SLOT; i++)
			{
				GetContainer(CTN_TYPE_ENCHANT_SLOT + "_" + i).ClearComponent();
			}
			
			var cfg:Object;
			var s:String;
			var paramList:Array = ["Damage", "Defence", "Critical", "Vitality"];
			var j:int;
			
			if (isSuccess)
			{
				// Cập nhật thông số cho Equipment nếu thành công
				cfg = ConfigJSON.getInstance().getItemInfo("EnchantEquipment_" + Ultility.GetConfigListNameSuffix(EquipmentChoose.Type), EquipmentChoose.Rank % 100);
				cfg = cfg[EquipmentChoose.Color][EquipmentChoose.EnchantLevel + 1];
				EquipmentChoose.EnchantLevel += 1;
				
				for (i = 0; i < paramList.length; i++)
				{
					if (EquipmentChoose[paramList[i]] > 0)
					{
						EquipmentChoose[paramList[i]] += cfg[paramList[i]];
					}
				}
				
				for (i = 0; i < EquipmentChoose.bonus.length; i++)
				{
					for (j = 0; j < paramList.length; j++)
					{
						if (EquipmentChoose.bonus[i][paramList[j]])
						{
							EquipmentChoose.bonus[i][paramList[j]] += cfg[paramList[j]];
						}
					}
				}
				
				ShowEnchantItem(EquipmentChoose);
			}
			else if (EquipmentChoose.EnchantLevel > 0)
			{
				if (!isUseGodCharm)
				{
					// Cập nhật thông số cho Equipment nếu thất bại
					var cfg1:Object = ConfigJSON.getInstance().getItemInfo("EnchantEquipment_" + Ultility.GetConfigListNameSuffix(EquipmentChoose.Type), EquipmentChoose.Rank % 100);
					while (EquipmentChoose.EnchantLevel > lvAfter)
					{
						cfg = cfg1[EquipmentChoose.Color][EquipmentChoose.EnchantLevel];
						EquipmentChoose.EnchantLevel -= 1;
						
						for (i = 0; i < paramList.length; i++)
						{
							if (EquipmentChoose[paramList[i]] > 0)
							{
								EquipmentChoose[paramList[i]] -= cfg[paramList[i]];
							}
						}
						
						for (i = 0; i < EquipmentChoose.bonus.length; i++)
						{
							for (j = 0; j < paramList.length; j++)
							{
								if (EquipmentChoose.bonus[i][paramList[j]])
								{
									EquipmentChoose.bonus[i][paramList[j]] -= cfg[paramList[j]];
								}
							}
						}
					}
					
					ShowEnchantItem(EquipmentChoose);
				}
			}
			
			var ctn:Container = GetContainer(CTN_TYPE_ENCHANT_EQUIPMENT);
			var pos:Point = ctn.img.localToGlobal(ctn.CurPos);
			
			numMaterialChoose = 0;
			isEnchanting = false;
			btnEnchantMoney.SetEnable();
			ShowInfo();
			
			// Nếu là lên cấp 3, 6, 9 thì feed tường
			if (isSuccess)
			{
				switch (EquipmentChoose.EnchantLevel)
				{
					case 3:
					case 6:
					case 9:
						GuiMgr.getInstance().GuiFeedWall.ShowFeed("EnchantEquipment@" + int(EquipmentChoose.EnchantLevel/3), EquipmentChoose.EnchantLevel + "");
						break;
				}
			}
		}
		
		public function GetSuccessRatio(cfg:Object):int
		{
			var str:String = "";
			var ratio:Number = 0;
			for (var s:String in MaterialChooseList)
			{
				if (MaterialChooseList[s] > 0)
				{
					ratio += cfg[FindIdByIdObject(MaterialChooseList[s])];
				}
			}
			
			if (ratio > 100)
			{
				ratio = 100;
			}
			
			return Math.floor(ratio);
		}
		
		public function GetGodCharmSlot():GodCharmSlot
		{
			return godCharmSlot;
		}
		
		public function IsEffecting():Boolean
		{
			return isEnchanting;
		}
		
		public function UpdateGUIEnchant():void
		{
			if (!EquipmentChoose)
			{
				GuiMgr.getInstance().GuiEnchantEquipment.ClearComponent();
				GuiMgr.getInstance().GuiEnchantEquipment.RefreshComponent();
			}
			else
			{
				ShowMaterial(0, true);
				ShowTab(curTab, true);
			}
		}
		
		private function GetGodCharmId(curEquip:FishEquipment):int
		{
			if (curEquip.Color > 5)
			{
				return 5;
			}
			return curEquip.Color;
		}
		/**
		 * ẩn gui này đi như 1 cái tab
		 */
		public function hideAsTab():void
		{
			godCharmSlot.img.visible = 
			infoCtn.img.visible =
			enchantCtn.img.visible =
			btnEnchantMoney.img.visible =
			btnEnchantZMoney.img.visible = false;
			var ctn:Container;
			for (var i:int = 0; i < MAX_ENCHANT_SLOT; i++)
			{
				ctn = GetContainer(CTN_TYPE_ENCHANT_SLOT + "_" + i);
				ctn.SetVisible(false);
			}
			
		}
		/**
		 * show gui này như 1 cái tab
		 */
		public function showAsTab():void
		{
			godCharmSlot.img.visible = 
			infoCtn.img.visible =
			enchantCtn.img.visible =
			btnEnchantMoney.img.visible =
			btnEnchantZMoney.img.visible = true;
			var ctn:Container;
			for (var i:int = 0; i < MAX_ENCHANT_SLOT; i++)
			{
				ctn = GetContainer(CTN_TYPE_ENCHANT_SLOT + "_" + i);
				ctn.SetVisible(true);
			}
		}
		public function ShowInfo2():void
		{
			if (infoCtn == null)
			{
				infoCtn = AddContainer("", "GuiEnchant_CtnInfoChange2", 50, 80);
			}
			else
			{
				infoCtn.ClearComponent();
			}
			
			if (btnChangeMoney == null)
			{
				btnChangeMoney = AddButton(BTN_CHANGE_MONEY, "GuiEnchant_BtnChangeMoney", 100, 293);
			}
			btnChangeMoney.SetDisable();
			
			if (btnChangeZMoney == null)
			{
				btnChangeZMoney = AddButton(BTN_CHANGE_ZMONEY, "GuiEnchant_BtnChangeZMoney", 213, 293);
			}
			btnChangeZMoney.SetDisable();
			
			var strTip:String;
			var txtField:TextField = infoCtn.AddLabel("", 50, 132);
			txtField.wordWrap = true;
			txtField.width = 180;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 14;
			txtFormat.color = 0xF2F2F2;
			txtFormat.bold = true;
			txtFormat.align = "center";
			txtField.defaultTextFormat = txtFormat;
			var iBegin:int = -1;
			var iEnd:int;
			if(tfPowerTinh)
				tfPowerTinh.text = Ultility.StandardNumber(GameLogic.getInstance().user.getPowerTinh());
			if (ChangeSrcChoose == null)
			{
				strTip = Localization.getInstance().getString("ChangeEnchantMsg1");
			}
			else 
			{
				if (ChangeDesChoose == null)
				{
					strTip = Localization.getInstance().getString("ChangeEnchantMsg2");
				}
				else//đã có cả 2 ô
				{
					if (ChangeDesChoose.Type != ChangeSrcChoose.Type)
					{
						strTip = Localization.getInstance().getString("ChangeEnchantMsg5");
					}
					else if ((ChangeDesChoose.Color != ChangeSrcChoose.Color) && !((ChangeDesChoose.Color == 5 && ChangeSrcChoose.Color == 6) || (ChangeDesChoose.Color == 6 && ChangeSrcChoose.Color == 5)))
					{
						strTip = Localization.getInstance().getString("ChangeEnchantMsg6");
					}
					else if (ChangeDesChoose.EnchantLevel >= ChangeSrcChoose.EnchantLevel)
					{
						strTip = Localization.getInstance().getString("ChangeEnchantMsg7");
					}
					else if (ChangeDesChoose.EnchantLevel >= Constant.MAX_ENCHANT_TIMES)
					{
						strTip = Localization.getInstance().getString("ChangeEnchantMsg4");
					}
					else 
					{
						strTip = Localization.getInstance().getString("EnchantMsg4");
						var kind:String = "EnchantEquipment_" + Ultility.GetConfigListNameSuffix(ChangeSrcChoose.Type);
						var iLevelScr:int = ChangeSrcChoose.Rank % 100;
						var iLevelDes:int = ChangeDesChoose.Rank % 100;
						var cfEnchant:Object = ConfigJSON.getInstance().getItemInfo(kind, iLevelDes);
						var ratio:int = getSuccessRatio2(cfEnchant, ChangeDesChoose.Color, iLevelScr, iLevelDes,
													ChangeSrcChoose.EnchantLevel);
						strTip += " " + ratio + "%";
						
						var cfPowerTinh:Object = ConfigJSON.getInstance().getItemInfo("PowerTinhRequireEnchant");
						cfPowerTinh = cfPowerTinh[ChangeDesChoose.Rank % 100][ChangeSrcChoose.EnchantLevel];
						var powerTinh:int = cfPowerTinh["PowerTinh"];
						tfPowerTinh.appendText(" / " + Ultility.StandardNumber(powerTinh));
						if (GameLogic.getInstance().user.getPowerTinh() < powerTinh)
						{
							iEnd = tfPowerTinh.text.search("/");
							txtFormat = new TextFormat("Arial", 14, 0xFF0000);
							tfPowerTinh.setTextFormat(txtFormat, 0, iEnd);
						}
						
						if (numMaterialChoose <= 0)
						{
							strTip += "\n" + Localization.getInstance().getString("EnchantMsg3");
						}
						else {
							
							if (ratio < 100)
							{
								strTip += "\n" + Localization.getInstance().getString("ChangeEnchantMsg8");
							}
							else
							{
								var money:int = cfPowerTinh["Money"];
								var zmoney:int = cfPowerTinh["ZMoney"];
								var tfMoney:TextField = infoCtn.AddLabel(Ultility.StandardNumber(money), 40, 190, 0x000000);
								var tfZMoney:TextField = infoCtn.AddLabel(Ultility.StandardNumber(zmoney), 150, 190, 0x000000);
								
								txtFormat = new TextFormat();
								txtFormat.size = 14;
								txtFormat.color = 0xF9EC31;
								txtFormat.bold = true;
								txtFormat.align = "center";
								tfMoney.setTextFormat(txtFormat);
								tfZMoney.setTextFormat(txtFormat);
								
								btnChangeMoney.SetEnable();
								btnChangeZMoney.SetEnable();
							}
						}
						iBegin = 18;
						iEnd = iBegin + ratio.toString().length + 1;
					}
				}
			}
			txtField.text = strTip;
			if (iBegin > 0)
			{
				var fm:TextFormat = new TextFormat("Arial");
				fm.color = 0xF9EC31;
				txtField.setTextFormat(fm, iBegin, iEnd);
				iBegin = iEnd;
				iEnd = strTip.length;
				if (iEnd > iBegin)
				{
					fm = new TextFormat();
					fm.color = 0xFF0000;
					txtField.setTextFormat(fm, iBegin, iEnd);
				}
			}
		}
		
		private function getSuccessRatio2(cf:Object, color:int,
											iLevel1:int, iLevel2:int, 
											iEnchant1:int):Number
		{
			var cfLevel:Object = ConfigJSON.getInstance().getItemInfo("ChangeEnchantLevel");
			var ratioByLevel:Number = cfLevel[iLevel1][iLevel2];		//tỷ lệ dựa trên Level của đồ
			var cfEnchant:Object = cf[color==6?5:color][iEnchant1];
			var ratioByEnchant:Number = GetSuccessRatio(cfEnchant);		//tỷ lệ dựa trên ngu thach
			var result:Number = ratioByEnchant + ratioByLevel;
			if (result > 100)
			{
				result = 100;
			}
			return result;
		}
		
		private function ShowChangeItems(eqSrc:FishEquipment = null, eqDes:FishEquipment = null):void 
		{
			changesrcCtn = ShowEnchantItem2(eqSrc, CTN_TYPE_CHANGE_EQUIPMENT_SRC, 90, 112);
			changedesCtn = ShowEnchantItem2(eqDes, CTN_TYPE_CHANGE_EQUIPMENT_DES, 237, 112);
			if (eqSrc == null)
			{
				changesrcCtn.AddImage("idImgA", "GuiEnchant_ImgCharacterA", 40, 40);
			}
			if (eqDes == null)
			{
				changedesCtn.AddImage("idImgB", "GuiEnchant_ImgCharacterB", 40, 40);
			}
		}

		public function ProcessChooseEquip2(replaceDes:Boolean = true):void
		{
			if (isChanging) return;
			if (replaceDes)
			{
				if (ChangeSrcChoose)
				{
					if (ChangeDesChoose)
					{
						ItemList.push(ChangeDesChoose);
					}
					ChangeDesChoose = curEquip;
				}
				else
				{
					ChangeSrcChoose = curEquip;
				}
			}
			else
			{
				if (ChangeDesChoose)
				{
					if (ChangeSrcChoose)
					{
						ItemList.push(ChangeSrcChoose);
					}
					ChangeSrcChoose = curEquip;
				}
				else
				{
					ChangeDesChoose = curEquip;
				}
			}
			ItemList.splice(ItemList.indexOf(curEquip), 1);
			ShowChangeItems(ChangeSrcChoose, ChangeDesChoose);
			scrollPercent = scroll.getScrollCurrentPercent();
			ShowTab(curTab);
		}
		
		public function processUnChooseEquip2():void
		{
			var goToTab:String = "Tab_" + curEquip.Type;		// Lưu lại để show tab đó
			
			var eq:FishEquipment;
			
			if (ChangeSrcChoose && curEquip.Id == ChangeSrcChoose.Id)
			{
				eq = ChangeSrcChoose;
				ChangeSrcChoose = null;
				changesrcCtn.ClearComponent();
				changesrcCtn.AddImage("idImgA", "GuiEnchant_ImgCharacterA", 40, 40);
			}
			else if (ChangeDesChoose && curEquip.Id == ChangeDesChoose.Id)
			{
				eq = ChangeDesChoose;
				ChangeDesChoose = null;
				changedesCtn.ClearComponent();
				changedesCtn.AddImage("idImgB", "GuiEnchant_ImgCharacterB", 40, 40);
			}
			ItemList.push(eq);
			scrollPercent = scroll.getScrollCurrentPercent();
			
			if (curTab != TAB_ALL)
			{
				if (curEquip.Type != "Ring" && curEquip.Type != "Bracelet" 
					&& curEquip.Type != "Necklace" && curEquip.Type != "Belt")
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
		}
		public function showPowertinh():void
		{
			if (ctnPowerTinh == null)
			{
				ctnPowerTinh = AddContainer(CTN_POWERTINH, "GuiEnchant_ImgPowerTinhSlot", 264, 325, true, this);
			}
			else
			{
				ctnPowerTinh.ClearComponent();
			}
			tfPowerTinh = null;
			ctnPowerTinh.AddImage("", "GuiEnchant_ImgPowerTinhNumSlot", -5, 68, true, ALIGN_LEFT_TOP);
			var imgPT:ButtonEx = ctnPowerTinh.AddButtonEx("", "PowerTinh", 18, 6);
			imgPT.setTooltipText("Tinh lực\nDùng để chuyển cường hóa");
			imgPT.img.buttonMode = false;
			
			var user:User = GameLogic.getInstance().user;
			var powerTinh:int = user.getPowerTinh();
			tfPowerTinh = ctnPowerTinh.AddLabel(Ultility.StandardNumber(powerTinh), -19, 70, 0xffff00);
		}

		public function get iTab():int 
		{
			return _iTab;
		}
		
		public function set iTab(value:int):void 
		{
			if (_iTab == 0)
			{
				if (EquipmentChoose)
				{
					ProcessUnChooseEquip();
				}
			}
			else
			{
				if (ChangeSrcChoose)
				{
					ItemList.push(ChangeSrcChoose);
					ChangeSrcChoose = null;
				}
				if (ChangeDesChoose)
				{
					ItemList.push(ChangeDesChoose);
					ChangeDesChoose = null;
				}
				scrollPercent = scroll.getScrollCurrentPercent();
				ChangeTab(curTab);
				ShowTab(curTab);
			}
			_iTab = value;
			RemoveContainer(ID_CTN_INFO);
			if (infoCtn != null)//tạm thời fix bug crash
			{
				infoCtn.Destructor();
				infoCtn = null;
			}
			removeAllSlotMaterial();
			flushAllMaterial();				//đẩy hết những material ở Slot Phía trên đi
			//ShowMaterial(0, true);
			if (_iTab == 0)
			{
				RemoveButton(BTN_CHANGE_MONEY);
				RemoveButton(BTN_CHANGE_ZMONEY);
				btnChangeMoney = null;
				btnChangeZMoney = null;
				RemoveContainer(CTN_TYPE_CHANGE_EQUIPMENT_SRC);
				RemoveContainer(CTN_TYPE_CHANGE_EQUIPMENT_DES);
				changesrcCtn.Destructor();
				changedesCtn.Destructor();
				changesrcCtn = null;
				changedesCtn = null;
				RemoveContainer(CTN_POWERTINH);
				ctnPowerTinh = null;
				
				ShowInfo();//show lại cái ctnInfo
				ShowEnchantItem();
				ShowEnchantSlots();
				ShowGodCharmSlot();
			}
			else 
			{
				RemoveButton(BTN_ENCHANT_MONEY);
				RemoveButton(BTN_ENCHANT_ZMONEY);
				btnEnchantMoney = null;
				btnEnchantZMoney = null;
				RemoveContainer(CTN_TYPE_ENCHANT_EQUIPMENT);
				enchantCtn.Destructor();
				enchantCtn = null;
				godCharmSlot.Destructor();
				godCharmSlot = null;
				
				
				ShowInfo2();
				ShowChangeItems();
				ShowEnchantSlots();
				showPowertinh();
			}
		}
		/**
		 * Đẩy hết material ở các slot phía trên đi
		 */
		private function flushAllMaterial():void
		{
			var o:Object = new Object();
			for (var i:int = 0; i < MAX_ENCHANT_SLOT; i++)
			{
				if (MaterialChooseList[i] != 0)
				{
					var itm:String = String(MaterialChooseList[i]);
					if (o[itm] == null)
					{
						o[itm] = new Object();
						o[itm]["ItemType"] = "Material";
						var idObject:int = MaterialChooseList[i];
						o[itm]["IdObject"] = idObject;
						o[itm]["Id"] = FindIdByIdObject(idObject);
						o[itm]["Num"] = 1;
					}
					else
					{
						o[itm]["Num"]++;
					}
					UpdateMaterials(MaterialChooseList[i], i);
					//UpdateMaterials(o[itm], i);
				}
			}
			for (var str:String in o)
			{
				updateOneMaterial(o[str]);
			}
		}
		
		private function updateOneMaterial(material:Object):void 
		{
			var ctn:Container = listBoxMaterial.getItemById(CTN_TYPE_MATERIAL + "_" + material["IdObject"]);
			if (ctn == null)
			{
				AddOneMaterial(material);
			}
			else
			{
				ctn.LabelArr[0].text = Ultility.StandardNumber(int(ctn.LabelArr[0].text) + material["Num"]);
			}
		}
		
		private function removeAllSlotMaterial():void
		{
			for (var i:int = 0; i < MAX_ENCHANT_SLOT; i++)
			{
				var id:String = CTN_TYPE_ENCHANT_SLOT + "_" + i;
				var ctn:Container = GetContainer(id);
				ctn.Destructor();
				RemoveContainer(id);
				ctn = null;
			}
		}
		
		private function processEnchantEquip2(isMoney:Boolean):void 
		{
			//chặn các trường hợp
			var msg:String;
			var isError:Boolean = false;
			if (ChangeSrcChoose == null || ChangeDesChoose == null)
			{
				msg = Localization.getInstance().getString("ChangeEnchantMsg14");
				isError = true;
			}
			else 
			{
				if (ChangeSrcChoose.Type != ChangeDesChoose.Type)
				{
					msg = Localization.getInstance().getString("EnchantMsg9");
					isError = true;
				}
				if (ChangeSrcChoose.Color != ChangeDesChoose.Color && ChangeDesChoose.Color != 5 && ChangeDesChoose.Color != 6)
				{
					msg = Localization.getInstance().getString("EnchantMsg10");
					isError = true;
				}
				if (ChangeSrcChoose.Durability <= 0)
				{
					if (ChangeDesChoose.Durability <= 0)
					{
						msg = Localization.getInstance().getString("EnchantMsg11");
					}
					else {
						msg = Localization.getInstance().getString("EnchantMsg12");
					}
					isError = true;
				}
				else {
					if (ChangeDesChoose.Durability <= 0)
					{
						msg = Localization.getInstance().getString("EnchantMsg13");
						isError = true;
					}
				}
				if (ChangeSrcChoose.EnchantLevel <= ChangeDesChoose.EnchantLevel)
				{
					msg = Localization.getInstance().getString("EnchantMsg15");
					isError = true;
				}
				if (ChangeDesChoose.EnchantLevel == Constant.MAX_ENCHANT_TIMES)
				{
					msg = Localization.getInstance().getString("EnchantMsg16");
					isError = true;
				}
			}
			if (isError)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(msg, 310, 200, 2);
				return;
			}
			var cfPowerTinh:Object = ConfigJSON.getInstance().getItemInfo("PowerTinhRequireEnchant");
			cfPowerTinh = cfPowerTinh[ChangeDesChoose.Rank % 100][ChangeSrcChoose.EnchantLevel];
			var user:User = GameLogic.getInstance().user;
			var cost:Number = 0;
			var balance:Number = 0;
			var priceType:String;
			if (isMoney)
			{
				balance = user.GetMoney();
				cost = cfPowerTinh["Money"];
				if (balance < cost)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("EnchantMsg6"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					return;
				}
				else
				{
					priceType = "Money";
				}
			}
			else 
			{
				balance = user.GetZMoney();
				cost = cfPowerTinh["ZMoney"];
				if (balance < cost)
				{
					GuiMgr.getInstance().GuiNapG.Init();
					return;
				}
				else
				{
					priceType = "ZMoney";
				}
			}
			var powertinh:int = cfPowerTinh["PowerTinh"];
			var myPowerTinh:int = user.getPowerTinh();
			if (myPowerTinh < powertinh)
			{
				GuiMgr.getInstance().guiBuySpirit.Show(Constant.GUI_MIN_LAYER, 5);
				return;
			}
			isChanging = true;
			btnChangeMoney.SetDisable();
			btnChangeZMoney.SetDisable();
			
			var arr:Array = [];			//mảng ngư thạch
			var s:String;
			var obj:Object = new Object();	//mảng chứa số lượng từng ngư thạch
			
			for (s in MaterialChooseList)
			{
				if (MaterialChooseList[s] != 0)
				{
					if (obj[MaterialChooseList[s]])
					{
						obj[MaterialChooseList[s]] += 1;
					}
					else
					{
						obj[MaterialChooseList[s]] = 1;
					}
				}
			}
			var objSend:Object = new Object();
			for (s in obj)
			{
				var o:Object = new Object();
				o.ItemId = FindIdByIdObject(int(s));
				o.Num = obj[s];
				objSend[o.ItemId] = obj[s];
				arr.push(o);
			}
			
			var inEquip:Object = new Object();
			var outEquip:Object = new Object();
			inEquip["Type"] = ChangeSrcChoose.Type;
			inEquip["Id"] = ChangeSrcChoose.Id;
			outEquip["Type"] = ChangeDesChoose.Type;
			outEquip["Id"] = ChangeDesChoose.Id;
			var pk:SendChangeEnchantLevel = new SendChangeEnchantLevel(inEquip, outEquip, priceType, objSend);
			Exchange.GetInstance().Send(pk);
			
			// Update ngư thạch trong kho
			for (var i:int = 0; i < arr.length; i++)
			{
				GuiMgr.getInstance().GuiStore.UpdateStore("Material", arr[i].ItemId, -arr[i].Num);
			}
		}
		
		/**
		 * Xử lý từ server về sau khi chuyển cường hóa
		 * @param	data1 : dữ liệu
		 * @param	oldData
		 */
		public function ProcessEnchantEquipAfter2(data1:Object, oldData:Object):void 
		{
			if (data1["Error"] != 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Lỗi: " + data1["Error"]);
				return;
			}
			//trừ tiền
			var pk:SendChangeEnchantLevel = oldData as SendChangeEnchantLevel;
			var user:User = GameLogic.getInstance().user;
			var cfPowerTinh:Object = ConfigJSON.getInstance().getItemInfo("PowerTinhRequireEnchant");
			cfPowerTinh = cfPowerTinh[ChangeDesChoose.Rank % 100][ChangeSrcChoose.EnchantLevel];
			var money:int = cfPowerTinh["Money"];
			var zmoney:int = cfPowerTinh["ZMoney"];
			if (pk.PriceType == "Money")
			{
				user.UpdateUserMoney( -money);
			}
			else if (pk.PriceType == "ZMoney")
			{
				user.UpdateUserZMoney( -zmoney);
			}
			var powerTinh:int = cfPowerTinh["PowerTinh"];
			if (powerTinh > 0)
			{
				//effect tru tinh luc
				user.updateIngradient("PowerTinh", 0 - powerTinh);
				var strPowerTinh:String = " - " + Ultility.StandardNumber(powerTinh);
				var txtFormat:TextFormat = new TextFormat("SansationBold", 24, 0xff0000, true);
				txtFormat.align = "left";
				var tmp:Sprite = Ultility.CreateSpriteText(strPowerTinh, txtFormat, 6, 0x4F4D2E, true);
				var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
				eff.SetInfo(300, 525, 300, 475, 4);
			}
			//effect
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, 
																	"GuiEnchant_EffChange", 
																	null, 233, 143,
																	//null, 0, 0,
																	false, false, null, 
																	ChangeEffComp);
			//hoan thanh effect chuyển cường hóa
			function ChangeEffComp():void
			{
				// Cập nhật mảng MaterialChooseList
				var i:int;
				for (i = 0; i < MAX_ENCHANT_SLOT; i++)
				{
					MaterialChooseList[i] = 0;
				}
				FindNextSlot();
				for (i = 0; i < MAX_ENCHANT_SLOT; i++)
				{
					GetContainer(CTN_TYPE_ENCHANT_SLOT + "_" + i).ClearComponent();
				}
				//cập nhật lại EnchantLevel và chỉ số công thủ, dòng, của đồ
				ChangeDesChoose.updateEnchantLevel(ChangeSrcChoose.EnchantLevel - ChangeDesChoose.EnchantLevel);
				ChangeSrcChoose.updateEnchantLevel(0 - ChangeSrcChoose.EnchantLevel);
				ShowChangeItems(ChangeSrcChoose, ChangeDesChoose);
				numMaterialChoose = 0;
				isChanging = false;
				ShowInfo();
			}
			//effect trừ điểm tinh lực
			
		}
		
		public function updatePowertinh():void 
		{
			var myPowerTinh:int = GameLogic.getInstance().user.getPowerTinh();
			var sPowerTinh:String = Ultility.StandardNumber(myPowerTinh);
			tfPowerTinh.replaceText(0, tfPowerTinh.text.indexOf(" / "), sPowerTinh);
		}
		public function get IsEnchanting():Boolean {
			return isEnchanting;
		}
		public function get IsChanging():Boolean {
			return isChanging;
		}
		public function get IsFlying():Boolean {
			return isFlying;
		}
		
	}

}