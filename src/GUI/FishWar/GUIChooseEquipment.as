package GUI.FishWar 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Data.Tips;
	import Effect.EffectMgr;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import GameControl.GameController;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ProgressBar;
	import GUI.component.ScrollBar;
	import GUI.component.TextBox;
	import GUI.component.TooltipFormat;
	import GUI.CreateEquipment.GUISeparateEquipment;
	import GUI.CreateEquipment.ItemSeparate;
	import GUI.FishWar.FishEquipment;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.CreateEquipment.SendGetIngradient;
	import NetworkPacket.PacketSend.SendChangeSoliderName;
	import NetworkPacket.PacketSend.SendDeleteEquipment;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import NetworkPacket.PacketSend.SendStoreEquipment;
	import NetworkPacket.PacketSend.SendUseEquipmentSoldier;
	import Sound.SoundMgr;
	
	/**
	 * GUI about to change equipments of Fish Soldiers
	 * @author longpt
	 */
	public class GUIChooseEquipment extends BaseGUI 
	{
		static public const BTN_BACK_SOLIDER:String = "btnBackSolider";
		static public const BTN_NEXT_SOLIDER:String = "btnNextSolider";
		static public const BTN_CREATE:String = "btnCreate";
		static public const BTN_SEPARATE:String = "btnSeparate";
		static public const BTN_UNLOCK_ITEM:String = "btnUnlockItem";
		public static const BTN_CLOSE:String = "Btn_Close";		
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
		public static const BTN_EXTEND:String = "Btn_Extend";
		private static const BTN_DEL:String = "Btn_Del";
		public static const BTN_ENCHANT:String = "Btn_Enchant";
		private static const BTN_SHOP:String = "Btn_Shop";
		public static const ICON_NEW:String = "Icon_New";
		static public const TXTBOX_FISH_NAME:String = "txtboxFishName";
		static public const BTN_EDIT_SOLDIER_NAME:String = "btnEditSoldierName";
		static public const ICON_HELPER:String = "iconHelper";
		static public const ICON_HELPER_SEPARATE:String = "iconHelperSeparate";
		static public const BTN_SAVE_SOLDIER_NAME:String = "btnSaveSoldierName";
		
		private static const CTN_HELMET:String = "Ctn_Helmet";
		private static const CTN_ARMOR:String = "Ctn_Armor";
		private static const CTN_WEAPON:String = "Ctn_Weapon";
		private static const CTN_MASK:String = "Ctn_Mask";
		private static const CTN_BELT:String = "Ctn_Belt";
		private static const CTN_BRACELET:String = "Ctn_Bracelet";
		private static const CTN_NECKLACE:String = "Ctn_Necklace";
		private static const CTN_RING:String = "Ctn_Ring";
		private static const CTN_SEAL:String = "Ctn_Seal";
		private static const CTN_EMPTY:String = "Ctn_Empty";
		
		private static const CTN_INFO:String = "Group_Info";
		private static const TXT_EMPTY_SLOT:String = "Empty";
		
		private static const DOUBLE_CLICK_TIMER:Number = 0.5;
	
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
		private var btnEnchant:Button;						// Pointer
		
		private var curEquipImage:Image;					// Image dragable
		private var curEquip:FishEquipment;					// Current Equipment Selected
		
		private var listBox:ListBox;						// Component
		private var scroll:ScrollBar;						// Component
		
		
		public var ItemList:Array = new Array();			// List all the item can be shown
		private var InteractiveCtn:Array = new Array();		// List all the Container can be interact
		private var ItemPos:Object;							// Positions of all the container in GUI (fixed)
		private var ObjectUse:Object;						// Object item used
		private var ObjectStore:Object;						// Object item stored
		
		public var curTab:String;							// Current Tab
		public var curHighlight:Container;					// Current Container highlighted
		public var curSoldier:FishSoldier;					// Current Soldier is changing equips
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
		private var btnBackSolider:Button;
		private var btnNextSolider:Button;
		private var arrSolider:Array;
		private var btnSeparate:Button;
		private var btnUnlockItem:Button;
		private var btnCreate:Button;
		public var guiSeparateEquipment:GUISeparateEquipment;
		public var stateSeparate:Boolean = false;
		
		private var isUpdateSoldier:Boolean;
		private var wings:FishWings;
		private var txtBoxFishName:TextBox;
		private var imageBgSoldierName:Image;
		private var totalPercent:int;
		
		public function GUIChooseEquipment(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIChooseEquipment";
		}
		
		public override function InitGUI() :void
		{
			//trace("GUIChooseEquipment() InitGUI()");
			this.setImgInfo = function():void
			{
				SetPos(35, 10);
			
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				if (isUpdateSoldier)
				{
					ClearComponent();
					refreshComponent();
				}
				else
				{
					// Load lại kho để refresh trang bị
					var cmd:SendLoadInventory = new SendLoadInventory();
					Exchange.GetInstance().Send(cmd);
					OpenRoomOut();
				}
			}
			
			LoadRes("GuiChooseEquipment_Theme");	
		}
		
		public function Init(s:FishSoldier, updateSolider:Boolean = false):void
		{
			ObjectStore = new Object();
			ObjectUse = new Object();
			
			arrSolider = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			arrSolider = arrSolider.concat(new Array());
			for (var i:int = 0; i < arrSolider.length; i++)
			{
				if (FishSoldier(arrSolider[i]).SoldierType != FishSoldier.SOLDIER_TYPE_MIX)
				{
					arrSolider.splice(i, 1);
					i--;
				}
			}
			
			if (!s && arrSolider.length > 0)
			{
				curSoldier = arrSolider[0];
			}
			else
			{
				curSoldier = s;
			}
			
			//for (var i:int = 0; i < GameLogic.getInstance().user.GetFishSoldierArr().length; i++)
			//{
				//if (s.Id == GameLogic.getInstance().user.GetFishSoldierArr()[i].Id)
				//{
					//curSoldier = GameLogic.getInstance().user.GetFishSoldierArr()[i];
					//break;
				//}
			//}
			
			//if (curSoldier && curSoldier.SoldierType != FishSoldier.SOLDIER_TYPE_MIX)
			//{
				//curSoldier = null;
			//}
			
			//curSoldier = s;
			
			ItemList.splice(0, ItemList.length);
			isDataReady = false;
			
			isUpdateSoldier = updateSolider;
			this.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		public override function EndingRoomOut():void
		{
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
			ShowSlots();
			if (curSoldier)
			{
				//Text box dat ten ca
				imageBgSoldierName = AddImage("", "GuiChooseEquipment_SoldierNameBg", 213, 202);
				imageBgSoldierName.img.width = 118;
				imageBgSoldierName.img.visible = false;
				var nameSoldier:String = "Tiểu " + Ultility.GetNameElement(curSoldier.Element) + " Ngư";
				if (curSoldier.nameSoldier != null && curSoldier.nameSoldier != "")
				{
					nameSoldier = curSoldier.nameSoldier;
				}
				txtBoxFishName = AddTextBox(TXTBOX_FISH_NAME, nameSoldier, 135, 191, 110, 30, this);
				txtBoxFishName.textField.selectable = false;
				txtBoxFishName.textField.type = TextFieldType.INPUT;
				txtBoxFishName.textField.maxChars = 16;
				var txtFormat:TextFormat = new TextFormat("arial", 13, 0xffff00, true);
				txtFormat.align = "right";
				txtBoxFishName.textField.defaultTextFormat = txtFormat;
				txtBoxFishName.textField.setTextFormat(txtFormat);
				var tooltipFormat:TooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Đặt tên cá lính";
				AddButtonEx(BTN_EDIT_SOLDIER_NAME, "BtnWriteLetter", 255, 185).setTooltip(tooltipFormat);
				tooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Lưu tên cá lính";
				AddButton(BTN_SAVE_SOLDIER_NAME, "BtnSaveDeco", 247, 219).SetVisible(false);
				GetButton(BTN_SAVE_SOLDIER_NAME).setTooltip(tooltipFormat);
				
				AddEquipsToSlot();
				UpdateFishContent();
				AddInfo();
			}
			
			//Update unlock feature
			//Ultility.updateUnlockBtn(GetButton(BTN_ENCHANT), "Cường Hóa Trang Bị", 13);
			//Ultility.updateUnlockBtn(GetButton(BTN_CREATE), "Chế Tạo Trang Bị", 15);
			//Ultility.updateUnlockBtn(GetButton(BTN_SEPARATE), "Tách Trang Bị", 15);
		}
		
		/**
		 * Show all slots to wear clothes
		 */
		private function ShowSlots():void
		{
			InteractiveCtn.splice(0, InteractiveCtn.length);
			
			if (!ItemPos)
			{
				ItemPos = new Object();
				// Fix positions of slots
				ItemPos.Helmet = new Point(100, 100);		// coordinate of ctn Helmet
				ItemPos.Armor = new Point(60, 202);			// coordinate of ctn Armor
				ItemPos.Weapon = new Point(265, 307);		// coordinate of ctn Weapon
				ItemPos.Other1 = new Point (265, 100);		// coordinate of ctn Other (not used yet!)
				ItemPos.Other2 = new Point (183, 100);		// coordinate of ctn Other (not used yet!)
				ItemPos.Other3 = new Point (100, 307);		// coordinate of ctn Necklace
				ItemPos.Other4 = new Point (183, 307);		// coordinate of ctn Belt
				ItemPos.Other5 = new Point (289, 202);		// coordinate of ctn Ring 1
				ItemPos.Other6 = new Point (332, 202);		// coordinate of ctn Ring 2
				ItemPos.Other7 = new Point (289, 245);		// coordinate of ctn Bracelet 1
				ItemPos.Other8 = new Point (332, 245);		// coordinate of ctn Bracelet 2
			}
			
			ctnHelmet = AddContainer(CTN_HELMET + "_0", "GuiChooseEquipment_CtnEquipment", ItemPos.Helmet.x, ItemPos.Helmet.y, true, this);
			InteractiveCtn.push(ctnHelmet);
			ctnArmor = AddContainer(CTN_ARMOR + "_0", "GuiChooseEquipment_CtnEquipment", ItemPos.Armor.x, ItemPos.Armor.y, true, this);
			InteractiveCtn.push(ctnArmor);
			ctnWeapon = AddContainer(CTN_WEAPON + "_0", "GuiChooseEquipment_CtnEquipment", ItemPos.Weapon.x, ItemPos.Weapon.y, true, this);
			InteractiveCtn.push(ctnWeapon);
			InteractiveCtn.push(AddContainer(CTN_SEAL + "_0", "GuiChooseEquipment_CtnEquipment", ItemPos.Other1.x, ItemPos.Other1.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_MASK + "_0", "GuiChooseEquipment_CtnEquipment", ItemPos.Other2.x, ItemPos.Other2.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_NECKLACE + "_0", "GuiChooseEquipment_CtnEquipment", ItemPos.Other3.x, ItemPos.Other3.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_BELT + "_0", "GuiChooseEquipment_CtnEquipment", ItemPos.Other4.x, ItemPos.Other4.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_RING + "_0", "GuiChooseEquipment_CtnEquipUnwareSmall", ItemPos.Other5.x, ItemPos.Other5.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_RING + "_1", "GuiChooseEquipment_CtnEquipUnwareSmall", ItemPos.Other6.x, ItemPos.Other6.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_BRACELET + "_0", "GuiChooseEquipment_CtnEquipUnwareSmall", ItemPos.Other7.x, ItemPos.Other7.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_BRACELET + "_1", "GuiChooseEquipment_CtnEquipUnwareSmall", ItemPos.Other8.x, ItemPos.Other8.y, true, this));
		}
		
		/**
		 * Show fish is chosen
		 */
		private function AddActor():void
		{
			totalPercent = 0;
			if (curSoldierImg)
			{
				if (curSoldierImg.img)
				img.removeChild(curSoldierImg.img);
			}
			
			if (curSoldier.EquipmentList.Mask[0])
			{
				curSoldierImg = AddImage("", curSoldier.EquipmentList.Mask[0].TransformName, 0, 0);
				curSoldierImg.img.mouseChildren = false;
				curSoldierImg.img.mouseEnabled = false;
				curSoldierImg.img.parent.mouseEnabled = false;
			}
			else
			{
				curSoldierImg = AddImage("", Fish.ItemType + curSoldier.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 0, 0);
				curSoldierImg.img.parent.mouseEnabled = false;
				curSoldierImg.img.mouseChildren = false;
				curSoldierImg.img.mouseEnabled = false;
			}
			
			curSoldierImg.FitRect(100, 100, new Point (160, 208));
		}
		
		private function AddInfo():void
		{
			RemoveContainer(CTN_INFO);
			var ctn:Container = AddContainer(CTN_INFO, "GuiChooseEquipment_ImgFrameFriend", 80, 415);
			
			var dmgTotal:int;
			var critTotal:Number;
			var vitTotal:int;
			var defTotal:int;
			
			if (curSoldier.bonusEquipment == null)
			{
				dmgTotal = curSoldier.Damage;
				critTotal = curSoldier.Critical;
				vitTotal = curSoldier.Vitality;
				defTotal = curSoldier.Defence;
			}
			else 
			{
				dmgTotal = curSoldier.getTotalDamage();
				critTotal = curSoldier.getTotalCritical();
				vitTotal = curSoldier.getTotalVitality();
				defTotal = curSoldier.getTotalDefence();
			}
			
			var tF:TextField;
			var txtF:TextFormat;
			
			tF = ctn.AddLabel(dmgTotal + "", 150, 41, 0xFFFFFF, 0, 0x603813);
			if (dmgTotal > curSoldier.Damage)
			{
				txtF = new TextFormat();
				txtF.color = 0x00ff00;
				tF.setTextFormat(txtF);
			}
			else if (dmgTotal < curSoldier.Damage)
			{
				txtF = new TextFormat();
				txtF.color = 0xff0000;
				tF.setTextFormat(txtF);
			}
			
			tF = ctn.AddLabel(defTotal + "", 150, 61, 0xFFFFFF, 0, 0x603813);
			if (defTotal > curSoldier.Defence)
			{
				txtF = new TextFormat();
				txtF.color = 0x00ff00;
				tF.setTextFormat(txtF);
			}
			else if (defTotal < curSoldier.Defence)
			{
				txtF = new TextFormat();
				txtF.color = 0xff0000;
				tF.setTextFormat(txtF);
			}
			
			tF = ctn.AddLabel(critTotal + "", 150, 82, 0xFFFFFF, 0, 0x603813);
			if (critTotal > curSoldier.Critical)
			{
				txtF = new TextFormat();
				txtF.color = 0x00ff00;
				tF.setTextFormat(txtF);
			}
			else if (critTotal < curSoldier.Critical)
			{
				txtF = new TextFormat();
				txtF.color = 0xff0000;
				tF.setTextFormat(txtF);
			}
			
			tF = ctn.AddLabel(vitTotal + "", 150, 102, 0xFFFFFF, 0, 0x603813);
			if (vitTotal > curSoldier.Vitality)
			{
				txtF = new TextFormat();
				txtF.color = 0x00ff00;
				tF.setTextFormat(txtF);
			}
			else if (vitTotal < curSoldier.Vitality)
			{
				txtF = new TextFormat();
				txtF.color = 0xff0000;
				tF.setTextFormat(txtF);
			}
			
			var prg:ProgressBar = ctn.AddProgress("", "GuiChooseEquipment_PrgRank", 77, 15);
			prg.setStatus(curSoldier.RankPoint / curSoldier.MaxRankPoint);
			ctn.AddLabel(Ultility.StandardNumber(Math.floor(curSoldier.RankPoint)) + "/" + Ultility.StandardNumber(curSoldier.MaxRankPoint), 85, 14, 0x000000, 1, 0xffffff);
			
			ctn.AddLabel("Cấp " + curSoldier.Rank + " - " + Localization.getInstance().getString("FishSoldierRank" + curSoldier.Rank), 85, -5, 0xFFF100, 1, 0x603813);
			var rankName:String;
			if (curSoldier.Rank > 13)
			{
				rankName = "Rank13";
			}
			else
			{
				rankName = "Rank" + curSoldier.Rank;
			}
			ctn.AddImage("", rankName, 15, 74);
			
			ctn.AddImage("", "Element" + curSoldier.Element, 255, 15);
			ctn.AddLabel("Hệ " + Localization.getInstance().getString("Element" + curSoldier.Element), 205, 30, 0x000000, 1, 0xffffff);
			
			ctn.AddImage("", "GuiChooseEquipment_IcRank", 0, 0).FitRect(30, 30, new Point(53, 8));
			
			if(guiSeparateEquipment != null && guiSeparateEquipment.img != null)
			{
				img.setChildIndex(guiSeparateEquipment.img, img.numChildren - 1);
			}
		}
		
		/**
		 * Add current Equips of fishes
		 */
		private function AddEquipsToSlot():void
		{
			var curItem:Object = curSoldier.EquipmentList;
			var s:String;
			var k:int;
			var ctn:Container;
			
			for (k = 0; k < InteractiveCtn.length; k++)
			{
				InteractiveCtn[k].ClearComponent();
			}
			
			for (s in curItem)
			{
				for (k = 0; k < GetNumSlotEachType("Ctn_" + s); k++)
				{
					ctn = GetContainer("Ctn_" + s + "_" + k);
					if (curItem[s][k])
					{
						var imag:Image = null;
						// Add nền nếu là đồ quý, đặc biệt
						if (curItem[s][k].Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
						{
							imag = ctn.AddImage("", FishEquipment.GetBackgroundName(curItem[s][k].Color), -4, -2, true, ALIGN_LEFT_TOP, true);
						}
						
						var imagName:String = curItem[s][k].imageName + "_Shop";
						var tF:TextFormat = new TextFormat();
						
						var imag1:Image = drawImgEquip(ctn, curItem[s][k].Id, imagName, curItem[s][k].Color);
						/*var cL:int = curItem[s][k].Color;
						var imag1:Image = ctn.AddImage(curItem[s][k].Id, imagName, 0, 0, true, Image.ALIGN_CENTER_CENTER, false, function f():void
						{
							FishSoldier.EquipmentEffect(this.img, cL);
						});*/
						var icMax:Image;
						if (curItem[s][k].Color == 6)
						{
							icMax = ctn.AddImage("", "IcMax", 74, 26);
							icMax.SetScaleXY(0.7);
						}
						if (s != "Bracelet" && s != "Ring")
						{						
							imag1.FitRect(60, 60, new Point( 7, 7));
							tF.size = 18;
							tF.bold = true;
							if (!Ultility.checkSource(curItem[s][k]["Source"]) || curItem[s][k]["IsUsed"])
							{
								ctn.AddImage("", "Lock", 13, 65);
							}
						}
						else
						{
							if (icMax != null)
							{
								icMax.img.x -= 34;
							}
							if (imag)
							{
								//imag.FitRect(ctn.img.width / 2, ctn.img.height / 2);							
								imag.FitRect(37, 37, new Point(0, 0));	
							}
							imag1.FitRect(30, 30, new Point( 3, 3));
							tF.size = 12;
							tF.bold = true;
							if (!Ultility.checkSource(curItem[s][k]["Source"]) || curItem[s][k]["IsUsed"])
							{
								ctn.AddImage("", "Lock", 11, 31);
							}
						}
						if (curItem[s][k].EnchantLevel > 0)
						{
							var txt:TextField = ctn.AddLabel("+" + curItem[s][k].EnchantLevel, 2, 2, 0xFFF100, 0, 0x603813);
							txt.setTextFormat(tF);
						}
						
						// Add glow
						//FishSoldier.EquipmentEffect(imag1.img, curItem[s][k].Color);
						//var cL:int = curItem[s][k].Color;
						//imag1.setImgInfo = function():void
						//{
							//FishSoldier.EquipmentEffect(this.img, cL);
						//}
						
						// Nếu đồ hết độ bền thì SetDisable
						if (curItem[s][k].Durability > 0)
						{
							ctn.enable = true;
						}
						else
						{
							ctn.enable = false;
						}
					}
					else
					{
						imag = ctn.AddImage(TXT_EMPTY_SLOT, "GuiChooseEquipment_txt" + s, 0, 0);
						if (s != "Bracelet" && s != "Ring")
						{
							imag.FitRect(60, 60, new Point( 7, 7));
						}
						else
						{
							imag.FitRect(30, 30, new Point( 3, 3));
						}
						
						ctn.enable = true;
					}
				}
			}
		}
		
		private function drawImgEquip(ctn:Container, idObject:String, img:String, color:int):Image 
		{
			var imag1:Image = ctn.AddImage(idObject, img, 0, 0, true, Image.ALIGN_CENTER_CENTER, false, function f():void
			{
				FishSoldier.EquipmentEffect(this.img, color);
			});
			return imag1;
		}
		
		/**
		 * Return number of slots for each type of equipment
		 * @param	type
		 * @return
		 */
		private function GetNumSlotEachType(type:String):int
		{
			switch (type)
			{
				case CTN_HELMET:
				case CTN_WEAPON:
				case CTN_ARMOR:
				case CTN_BELT:
				case CTN_NECKLACE:
				case CTN_MASK:
				case CTN_SEAL:
					return 1;
				case CTN_RING:
				case CTN_BRACELET:
					return 2;				
			}
			return 0;
		}
		
		/**
		 * All buttons add here
		 */
		private function AddButtons():void
		{
			imgAll = AddImage(IMG_ALL, "GuiChooseEquipment_ImgBtnAll", 407, 84, true, ALIGN_LEFT_TOP);
			imgHelmet = AddImage(IMG_HELMET, "GuiChooseEquipment_ImgBtnHelmet", imgAll.CurPos.x + 55, 84, true, ALIGN_LEFT_TOP);
			imgArmor = AddImage(IMG_ARMOR, "GuiChooseEquipment_ImgBtnArmor", imgHelmet.CurPos.x + 55, 84, true, ALIGN_LEFT_TOP);
			imgWeapon = AddImage(IMG_WEAPON, "GuiChooseEquipment_ImgBtnWeapon", imgArmor.CurPos.x + 55, 84, true, ALIGN_LEFT_TOP);
			imgJewelry = AddImage(IMG_JEWELRY, "GuiChooseEquipment_ImgBtnJewelry", imgWeapon.CurPos.x + 55, 84, true, ALIGN_LEFT_TOP);
			
			btnAll = AddButton(TAB_ALL, "GuiChooseEquipment_BtnAll", imgAll.CurPos.x, imgAll.CurPos.y);
			var tt:TooltipFormat = new TooltipFormat();
			tt.text = "Tất cả";
			btnAll.setTooltip(tt);
			
			btnHelmet = AddButton(TAB_HELMET, "GuiChooseEquipment_BtnHelmet", imgHelmet.CurPos.x, imgHelmet.CurPos.y);
			tt = new TooltipFormat();
			tt.text = "Mũ giáp";
			btnHelmet.setTooltip(tt);
			
			btnArmor = AddButton(TAB_ARMOR, "GuiChooseEquipment_BtnArmor", imgArmor.CurPos.x, imgArmor.CurPos.y);
			tt = new TooltipFormat();
			tt.text = "Áo giáp";
			btnArmor.setTooltip(tt);
			
			btnWeapon = AddButton(TAB_WEAPON, "GuiChooseEquipment_BtnWeapon", imgWeapon.CurPos.x, imgWeapon.CurPos.y);
			tt = new TooltipFormat();
			tt.text = "Vũ khí";
			btnWeapon.setTooltip(tt);
			
			btnJewelry = AddButton(TAB_JEWELRY, "GuiChooseEquipment_BtnJewelry", imgJewelry.CurPos.x, imgJewelry.CurPos.y);
			tt = new TooltipFormat();
			tt.text = "Trang sức";
			btnJewelry.setTooltip(tt);
			
			btnSort = AddButton(BTN_SORT, "GuiChooseEquipment_BtnSort", 435, 460);
			btnExtend = AddButton(BTN_EXTEND, "GuiChooseEquipment_BtnExtend", btnSort.img.x + 80, btnSort.img.y);
			btnDel = AddButton(BTN_DEL, "GuiChooseEquipment_BtnDel", 435, 490);
			//btnSeparate = AddButton(BTN_SEPARATE, "GuiChooseEquipment_Btn_Separate", btnExtend.img.x + 80, btnExtend.img.y);
			btnUnlockItem = AddButton(BTN_UNLOCK_ITEM, "GuiChooseEquipment_Btn_UnlockEquip", btnExtend.img.x + 80, btnExtend.img.y);
			//btnSeparate = AddButton(BTN_SEPARATE, "GuiChooseEquipment_Btn_Separate", 435, btnExtend.img.y + 30);
			//btnCreate = AddButton(BTN_CREATE, "GuiChooseEquipment_Btn_Create", 438 + 78, btnExtend.img.y + 30, this, "BtnCreateEquip");
			//btnEnchant = AddButton(BTN_ENCHANT, "GuiChooseEquipment_BtnGoToEnchant", 438 + 158, btnExtend.img.y + 30);
			
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("BtnSeparateEquip") >= 0)
			{
				AddImage(ICON_HELPER_SEPARATE, "IcHelper", btnSeparate.img.x + btnSeparate.img.width/2, btnSeparate.img.y, true, ALIGN_LEFT_TOP);
			}
			
			
			//var date:Date = new Date(2012, 2, 26, 0, 0);
			//var curTime:Number = GameLogic.getInstance().CurServerTime;
			//trace(curTime);
			//var curDate:Date = new Date(curTime*1000);
			//if (date > curDate)
			//{
				//var tooltipFormat:TooltipFormat = new TooltipFormat();
				//tooltipFormat.text = "Sẽ ra mắt vào ngày 26/03/2012";
				//btnCreate.SetEnable(false);
				//btnSeparate.SetEnable(false);
				//btnCreate.setTooltip(tooltipFormat);
				//btnSeparate.setTooltip(tooltipFormat);
			//}
			//else
			//{
				//btnCreate.SetEnable(true);
				//btnSeparate.SetEnable(true);
			//}
			
			//btnCreate.SetEnable(true);
			//btnSeparate.SetEnable(true);
			
			//if (!Ultility.CheckNewFeatureIcon(3))
			//{
				//btnEnchant.SetDisable();
			//}
			
			// Hardcode add chữ New
			//if (Ultility.CheckNewFeatureIcon(3, 10))
			//{
				// Add chữ New
				//AddImage(ICON_NEW, "IcNew", btnEnchant.img.x, btnEnchant.img.y);
			//}
			
			//tt = new TooltipFormat();
			//tt.text = "Sắp ra mắt";
			//btnEnchant.setTooltip(tt);
			//btnEnchant.SetDisable();
			
			AddButton(BTN_SHOP, "GuiChooseEquipment_BtnShopEquipment", 361, 479);
			AddButton(BTN_CLOSE, "BtnThoat", 707, 19);
			
			btnBackSolider = AddButton(BTN_BACK_SOLIDER, "GuiChooseEquipment_Btn_Down", 68 + 83, 426 - 198, this);
			btnBackSolider.img.scaleX = btnBackSolider.img.scaleY = 0.7;
			btnBackSolider.img.rotation += 90;
			btnNextSolider = AddButton(BTN_NEXT_SOLIDER, "GuiChooseEquipment_Btn_Up", 285, 426 - 198, this);
			btnNextSolider.img.scaleX = btnNextSolider.img.scaleY = 0.7;
			btnNextSolider.img.rotation += 90;
			
			if (arrSolider == null || arrSolider.length < 2 || !Ultility.IsInMyFish())
			{
				btnBackSolider.SetVisible(false);
				btnNextSolider.SetVisible(false);
			}
		}
		
		public function ChangeTab(buttonID:String):void
		{
			curTab = buttonID;
			
			btnAll.SetVisible(true);
			btnHelmet.SetVisible(true);
			btnArmor.SetVisible(true);
			btnWeapon.SetVisible(true);
			btnJewelry.SetVisible(true);
			
			if (GetButton(buttonID) != null)
			{
				GetButton(buttonID).SetVisible(false);
			}
		}
		
		public function ShowTab(buttonID:String, isSort:Boolean = false, isInit:Boolean = false):void
		{
			ClearScroll();
			ClearListBox();
			curHighlight = null;
			
			// Re-add list box
			listBox = AddListBox(ListBox.LIST_Y, 3, 3, 7, 10);
			listBox.setPos(404, 144);

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
				if (buttonID == TAB_JEWELRY && ItemList[i].Type != "Belt" && ItemList[i].Type != "Bracelet" && ItemList[i].Type != "Ring" && ItemList[i].Type != "Necklace"&& ItemList[i].Type != "Seal")	continue; 
				AddOneEquipment(ItemList[i] as FishEquipment);
				numItem++;
				
				//tutorial
				var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
				var arr:Array = curTutorial.split("/");
				if (arr[arr.length -1] == "useEquipmentSoldier" && GetImage(ICON_HELPER) == null && curSoldier.Element == FishEquipment(ItemList[i]).Element)
				{
					var ctn:Container = listBox.getItemById("Ctn_" + FishEquipment(ItemList[i]).Id);
					var point:Point = listBox.img.localToGlobal(ctn.CurPos);
					point = img.globalToLocal(point);
					AddImage(ICON_HELPER, "IcHelper", point.x + 53, point.y + 10);
					
					var tooltipFormat:TooltipFormat = new TooltipFormat();
					tooltipFormat.text = "Click đúp chuột để mặc đồ";
					ActiveTooltip.getInstance().showNewToolTip(tooltipFormat, ctn.img);
					//ActiveTooltip.getInstance().setCountShow(0);
					//ActiveTooltip.getInstance().setCountDownHide(25);
				}
			}
			
			numItemInTab = numItem;
			
			// Add scroll
			scroll = AddScroll("", "GuiChooseEquipment_ScrollBarExtendDeco", 650, 146);
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
			
			if(guiSeparateEquipment != null && guiSeparateEquipment.img != null)
			{
				img.setChildIndex(guiSeparateEquipment.img, img.numChildren -1);
			}
		}
		
		private function AddMoreContainers(num:int):void
		{
			var ctn:Container;
			var i:int;
			for (i = 0; i < num; i++)
			{
				ctn = AddContainer(CTN_EMPTY, "GuiChooseEquipment_CtnEquipment", 10, 10, true, this);
				listBox.addItem(ctn.IdObject, ctn, this);
				ContainerArr.splice(ContainerArr.length - 1, 1);
				
				ctn.enable = true;
			}
		}
		
		private function AddOneEquipment(o:FishEquipment):void
		{
			var ctn:Container;
			//ctn = AddContainer("Ctn_" + o.Id, "GuiChooseEquipment_CtnEquipment", 10, 10, true, this);
			ctn = AddContainer("Ctn_" + o.Id, "ImgFrameFriend", 10, 10, true, this);
			
			// Add nền nếu là đồ quý, đặc biệt
			//if (o.Color == FishEquipment.FISH_EQUIP_COLOR_GOLD)
			//{
				//ctn.AddImage("", "CtnEquipmentRare1", 0, 0, true, ALIGN_LEFT_TOP, true);
				//ctn.AddImage("", "CtnEquipmentRare", 0, 0, true, ALIGN_LEFT_TOP);
			//}
			if (o.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
			{
				//ctn.AddImage("", FishEquipment.GetBackgroundName(o.Color), 0, 0, true, ALIGN_LEFT_TOP);
				ctn.AddImage("", FishEquipment.GetBackgroundName(o.Color), -3, -2, true, ALIGN_LEFT_TOP, true);
			}
			else
			{
				ctn.AddImage("", "CtnEquipment", 0, 0, true, ALIGN_LEFT_TOP).SetScaleXY(1.05);
			}
			
			var imag:Image;
			if (o.Type == "Ring" && o.Color >= FishEquipment.FISH_EQUIP_COLOR_VIP)
			{
				imag = ctn.AddImage("", FishEquipment.GetEquipmentName(o.Type, o.Rank, o.Color) + "_Shop", 10, 10);
			}
			else
			{
				//imag = ctn.AddImage("", o.imageName + "_Shop", 10, 10, true, ALIGN_LEFT_TOP);
				imag = ctn.AddImage("", o.imageName + "_Shop", 10, 10);
			}
			var col:int = o.Color;
			imag.setImgInfo = function f():void { FishSoldier.EquipmentEffect(imag.img, col) };
			imag.FitRect(60, 60, new Point(10, 10));
			FishSoldier.EquipmentEffect(imag.img, o.Color);
			if (o.Color == 6)
			{
				ctn.AddImage("", "IcMax", 74, 26).SetScaleXY(0.7);
			}
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
				ctn.AddImage("", "GuiChooseEquipment_ImgDeny", 0, 0).FitRect(15, 15, new Point(50, 55));
			}
			
			if (!Ultility.checkSource(o.Source) || o.IsUsed)
			{
				ctn.AddImage("", "Lock", 20, 72);
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
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Mask"));
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Seal"));
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
				tempList = tempList.concat(GameLogic.getInstance().user.GetStore("Seal"));
			}
			
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
					
					//if (ItemList[i].Damage < ItemList[j].Damage)
					//{
						//itemTemp = ItemList[i];
						//ItemList[i] = ItemList[j];
						//ItemList[j] = itemTemp;
						//continue;
					//}
					//
					//if (ItemList[i].Defence < ItemList[j].Defence)
					//{
						//itemTemp = ItemList[i];
						//ItemList[i] = ItemList[j];
						//ItemList[j] = itemTemp;
						//continue;
					//}
					//
					//if (ItemList[i].Vitality < ItemList[j].Vitality)
					//{
						//itemTemp = ItemList[i];
						//ItemList[i] = ItemList[j];
						//ItemList[j] = itemTemp;
						//continue;
					//}
					//
					//if (ItemList[i].Critical < ItemList[j].Critical)
					//{
						//itemTemp = ItemList[i];
						//ItemList[i] = ItemList[j];
						//ItemList[j] = itemTemp;
						//continue;
					//}
				}
				
				//arrTemp.push(ItemList[i]);
			}
			
			//ItemList = arrTemp;
		}
		
		public override function OnHideGUI():void
		{
			if(guiSeparateEquipment != null)
			{
				guiSeparateEquipment.Hide();
			}
			
			if (curSoldier)
			{
				processChangeClothes();
				UpdateAllFishArr();
				
				//curSoldier.RefreshImg();
				curSoldier = null;
				scrollPercent = 0;
			}
			curEquip = null;
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			//trace("OnButtonClick buttonID== " + buttonID);
			switch (buttonID)
			{
				case BTN_EDIT_SOLDIER_NAME:
					imageBgSoldierName.img.visible = true;
					txtBoxFishName.textField.selectable = true;
					txtBoxFishName.textField.stage.focus = txtBoxFishName.textField;
					txtBoxFishName.textField.setSelection(0, txtBoxFishName.textField.length);
					GetButton(BTN_SAVE_SOLDIER_NAME).SetVisible(true);
					GetButtonEx(BTN_EDIT_SOLDIER_NAME).SetVisible(false);
					break;
				case BTN_SAVE_SOLDIER_NAME:
					var distanceTime:Number = GameLogic.getInstance().CurServerTime - curSoldier.lastTimeChangeName;
					if ( distanceTime <= 1800)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn phải chờ " + Ultility.ConvertTimeToString(1800- distanceTime) + " để đặt lại tên!");
						return;
					}
					var soldierName:String = txtBoxFishName.GetText();
					var blackList:String = Tips.getInstance().getWrongText();
					blackList = blackList.toLowerCase();
					var checkName:String = soldierName.toLowerCase();
					checkName = Ultility.filterVietnameseCharacter(checkName);
					checkName = checkName.split(" ").join("");
					checkName.replace(/.|_|/g, "");
					//trace(checkName);
					if (blackList.search(checkName) >= 0)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Tên không hợp lệ!");
						return;
					}
					if (soldierName != "")
					{
						imageBgSoldierName.img.visible = false;
						txtBoxFishName.textField.selectable = false;
						//update cá ngoài hồ
						var arr:Array = GameLogic.getInstance().user.FishSoldierArr;
						for (var h:int = 0; h < arr.length; h++)
						{
							if (FishSoldier(arr[h]).Id == curSoldier.Id)
							{
								FishSoldier(arr[h]).nameSoldier = soldierName;
								FishSoldier(arr[h]).lastTimeChangeName = GameLogic.getInstance().CurServerTime;
								break;
							}
						}
						//update logic
						arr = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
						for (var k:int = 0; k < arr.length; k++)
						{
							if (FishSoldier(arr[k]).Id == curSoldier.Id)
							{
								FishSoldier(arr[k]).nameSoldier = soldierName;
								FishSoldier(arr[k]).lastTimeChangeName = GameLogic.getInstance().CurServerTime;
								break;
							}
						}
						GetButton(BTN_SAVE_SOLDIER_NAME).SetVisible(false);
						GetButtonEx(BTN_EDIT_SOLDIER_NAME).SetVisible(true);
						
						//Gửi gói tin
						Exchange.GetInstance().Send(new SendChangeSoliderName(curSoldier.LakeId, curSoldier.Id, txtBoxFishName.GetText()));
					}
					break;
				case BTN_SEPARATE:
					if (!stateSeparate)
					{
						//Gửi gói tin cập nhật đồ trên người cá
						if (curSoldier)
						{
							processChangeClothes();
							UpdateAllFishArr();
							
							//curSoldier.RefreshImg();
						}
						//Bật gui tách đồ
						stateSeparate = true;
						guiSeparateEquipment= new GUISeparateEquipment(this.img, "");
						AddContainer2(guiSeparateEquipment, 0, 50);
						
						var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
						if (curTutorial.search("ChooseSeparateEquipment") >= 0)
						{
							GetImage(ICON_HELPER_SEPARATE).SetPos(240 + 219 - 17, 460 - 259- 43 - 25);
						}
					}
					break;
				case BTN_UNLOCK_ITEM:
					Hide();
					GuiMgr.getInstance().GuiUnlockEquipment.Show(Constant.GUI_MIN_LAYER, 1);
					break;
				case BTN_CREATE:
					Hide();
					GuiMgr.getInstance().guiChooseFactory.Show(Constant.GUI_MIN_LAYER, 7);
					break;
				case BTN_SHOP:
					//this.Hide();
					if(guiSeparateEquipment != null)
					{
						guiSeparateEquipment.Hide();
					}
					scrollPercent = scroll.getScrollCurrentPercent();
					if (curSoldier)
					{
						processChangeClothes();
						UpdateAllFishArr();
						//curSoldier.RefreshImg();
					}
					
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
					if(guiSeparateEquipment != null)
					{
						guiSeparateEquipment.Hide();
					}
					scrollPercent = scroll.getScrollCurrentPercent();
					if (curSoldier)
					{
						processChangeClothes();
						UpdateAllFishArr();
						//curSoldier.RefreshImg();
					}
					
					GuiMgr.getInstance().GuiExtendEquipment.Show(Constant.GUI_MIN_LAYER, 5);
					//this.Hide();
					break;
				case BTN_SORT:
					//scrollPercent = 0;
					scrollPercent = scroll.getScrollCurrentPercent();
					ShowTab(curTab, true);
					break;
				case BTN_DEL:
					//Đang khóa hoặc xin phá khóa
					var passwordState:String = GameLogic.getInstance().user.passwordState;
					if (passwordState == Constant.PW_STATE_IS_LOCK || passwordState == Constant.PW_STATE_IS_CRACKING || passwordState == Constant.PW_STATE_IS_BLOCKED)
					{
						GuiMgr.getInstance().guiPassword.showGUI();
						break;
					}
					if (curHighlight)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOkCancelDelEquip(Localization.getInstance().getString("FishWarMsg17"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
						//var id:int = int(curHighlight.IdObject.split("_")[1]);
						//processDeleteCloth-es(id);
						//curHighlight = null;
					}
					else
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg15"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					}
					break;
				case BTN_ENCHANT:
					//if(guiSeparateEquipment != null)
					//{
						//guiSeparateEquipment.Hide();
					//}
					this.Hide();
					//scrollPercent = scroll.getScrollCurrentPercent();
					//if (curSoldier)
					//{
						//processChangeClothes();
						//UpdateAllFishArr();
						//curSoldier.RefreshImg();
					//}
					GuiMgr.getInstance().guiEnchant.Show(Constant.GUI_MIN_LAYER, 5);
					//GuiMgr.getInstance().GuiEnchantEquipment.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case BTN_CLOSE:
					this.Hide();
					break;
				case BTN_BACK_SOLIDER:
					//trace("GuiChooseEquipment() BTN_BACK_SOLIDER");
					scrollPercent = scroll.getScrollCurrentPercent();
					if (curSoldier)
					{
						processChangeClothes();
						UpdateAllFishArr();
					}
					var backSolider:FishSoldier;
					for (var i:int = 0; i < arrSolider.length; i++)
					{
						if (arrSolider[i].Id == curSoldier.Id)
						{
							if( i== 0)
							{
								backSolider = arrSolider[arrSolider.length - 1];
							}
							else
							{
								backSolider = arrSolider[i - 1];
							}
							break;
						}
					}
					var arrSoldierInLake:Array = GameLogic.getInstance().user.FishSoldierArr;
					for (var n:int = 0; n < arrSoldierInLake.length; n++)
					{
						if (arrSoldierInLake[n].Id == backSolider.Id)
						{
							backSolider = arrSoldierInLake[n];
							break;
						}
					}
					Init(backSolider, true);
					break;
				case BTN_NEXT_SOLIDER:
					scrollPercent = scroll.getScrollCurrentPercent();
					if (curSoldier)
					{
						processChangeClothes();
						UpdateAllFishArr();
					}
					var nextSolider:FishSoldier;
					for (var j:int = 0; j < arrSolider.length; j++)
					{
						if (arrSolider[j].Id == curSoldier.Id)
						{
							if( j== arrSolider.length - 1)
							{
								nextSolider = arrSolider[0];
							}
							else
							{
								nextSolider = arrSolider[j + 1];
							}
							break;
						}
					}
					var arrSoldierInLake2:Array = GameLogic.getInstance().user.FishSoldierArr;
					for (var m:int = 0; m < arrSoldierInLake2.length; m++)
					{
						if (arrSoldierInLake2[m].Id == nextSolider.Id)
						{
							nextSolider = arrSoldierInLake2[m];
							break;
						}
					}
					Init(nextSolider, true);
					break;
			}
		}
		
		public override function OnButtonDown(event:MouseEvent, buttonID:String):void
		{
			var a:Array = buttonID.split("_");
			var o:FishEquipment;
			var i:int;

			//if (listBox.getItemById(buttonID))
			//{
				//if (!listBox.getItemById(buttonID).enable)
				//{
					//return;
				//}
			//}
			
			if (a[0] == "Ctn")
			{
				switch (a[1])
				{
					case "Helmet":
					case "Armor":
					case "Weapon":		// When drag to unware items
					case "Belt":
					case "Necklace":
					case "Ring":
					case "Bracelet":
					case "Mask":
					case "Seal":
						//trace("GUIChooseEquipment.as Helmet()");
						if (!curSoldier)	return;
						isWare = false;
						if (curSoldier.EquipmentList[a[1]])
						{
							o = curSoldier.EquipmentList[a[1]][a[2]];
						}
						break;
					case "Empty":
						break;
					default:			// When drag to ware items
						if (curHighlight)
						{
							curHighlight.SetHighLight( -1, false, curHighlight.enable);
						}
						// Focus on this container
						curHighlight = listBox.getItemById(buttonID);
						curHighlight.SetHighLight(0x0000ff, false, curHighlight.enable);
				
						if (!curHighlight.enable)	break;
						isWare = true;
						for (i = 0; i < ItemList.length; i++)
						{
							if (parseInt(a[1]) == ItemList[i].Id)
							{
								o = ItemList[i];
								break;
							}
						}
						break;
				}
				
				if (stateSeparate)
				{
					//trace("Goi vao ben trong if (stateSeparate)");
					curEquip = o;
					curCtnIdDown = buttonID;
					if (GameLogic.getInstance().CurServerTime - lastTimeClick < DOUBLE_CLICK_TIMER && lastTimeCtn == buttonID)
					{
						//add đồ để tách
						if(curEquip != null)
						{
							if (guiSeparateEquipment.img != null && guiSeparateEquipment.listItemSeparate != null)
							{
								var success:Boolean = guiSeparateEquipment.addEquipment(curEquip);
								
								if (success)
								{
									ItemList.splice(ItemList.indexOf(curEquip), 1);			// logic
									
									scrollPercent = scroll.getScrollCurrentPercent();
									ShowTab(curTab);
									ChangeTab(curTab);
									
									if (GetImage(ICON_HELPER_SEPARATE) != null)
									{
										RemoveImage(GetImage(ICON_HELPER_SEPARATE));
									}
								}
							}
							curEquip = null;
						}
					}
					else if(curEquip != null)
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
				else
				if (o && curSoldier)
				{
					//trace("--->else if o== " + o + " |curSoldier== " + curSoldier + " |lastTimeCtn== " + lastTimeCtn);
					curEquip = o;
					curCtnIdDown = buttonID;
					
					if (GameLogic.getInstance().CurServerTime - lastTimeClick < DOUBLE_CLICK_TIMER && lastTimeCtn == buttonID)
					{
						switch (a[0] + "_" + a[1])
						{
							case CTN_ARMOR:
							case CTN_HELMET:
							case CTN_INFO:
							case CTN_WEAPON:
							case CTN_BELT:
							case CTN_BRACELET:
							case CTN_NECKLACE:
							case CTN_RING:
							case CTN_MASK:
							case CTN_SEAL:
								if(curSoldierImg.img != null)
								{
									ProcessUnware();
								}
								break;
							default:
								for (i = 0; i < GetNumSlotEachType("Ctn_" + curEquip.Type); i++)
								{
									var container:Container = GetContainer("Ctn_" + curEquip.Type + "_" + i);
									if (container.ImageArr[0].ImageId == TXT_EMPTY_SLOT)
									{
										break;
									}
								}
								//mặc đồ cho cá
								if(!stateSeparate && curSoldierImg.img != null)
								{
									//var rankRequire:int = ConfigJSON.getInstance().GetItemList("Param")["EquipmentLimit"][curEquip.Rank%100];
									//if (curSoldier.Rank >= rankRequire)
									//{
										if (Ultility.checkSource(curEquip.Source) && !curEquip.IsUsed)
										{
											GuiMgr.getInstance().guiConfirm.showGUI("Đồ sau khi mặc sẽ không giao dịch được. Bạn có chắc chắn muốn mặc không?", function():void
											{
												ProcessWare(container);
											});
										}
										else
										{
											ProcessWare(container);
										}
									//} 
									//else
									//{
										//GuiMgr.getInstance().GuiMessageBox.ShowOK("Ngư thủ không đủ cấp để mặc đồ này!");
									//}
								}
								break;
						}
						
						lastTimeClick = 0;
						lastTimeCtn = "";
						if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
						{
							GuiMgr.getInstance().GuiEquipmentInfo.Hide();
						}
						//curSoldier.UpdateBonusEquipment();		// Update infomations (damage, critical...)
						//AddInfo();
						//curEquip = null;
					}
					else
					{
						//trace("Goi vao ben trong else else");
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
		}
		
		/**
		 * Update fish equipment info in MyFishSoldierArr
		 */
		private function UpdateAllFishArr():void
		{
			var mySoldier:Array = GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			for (var i:int = 0; i < mySoldier.length; i++)
			{
				if (mySoldier[i].Id == curSoldier.Id)
				{
					mySoldier[i].EquipmentList = curSoldier.EquipmentList;
					mySoldier[i].bonusEquipment = curSoldier.bonusEquipment;
					break;
				}
			}
		}
		
		private function OnReleaseItem(event:MouseEvent):void
		{
			Mouse.cursor = MouseCursor.AUTO;
			// Remove listener
			img.removeEventListener(MouseEvent.MOUSE_UP, OnReleaseItem);
			trace("OnReleaseItem stateSeparate== " + stateSeparate);
			//Mặc đồ cá
			if (!stateSeparate)
			{
				var i:int;		// Count purpose
				trace("OnReleaseItem isWare== " + isWare);
				// Check drag successfully
				if (isWare)
				{
					var isProcessWare:Boolean = false;
					for (i = 0; i < GetNumSlotEachType("Ctn_" + curEquip.Type); i++)
					{
						var target:Container = GetContainer("Ctn_" + curEquip.Type + "_" + i);
						var oldUse:FishEquipment;
						if (curSoldierImg.img != null && curEquipImage.img.hitTestObject(target.img))// if collision detected
						{
							//var rankRequire:int = ConfigJSON.getInstance().GetItemList("Param")["EquipmentLimit"][curEquip.Rank%100];
							//if (curSoldier.Rank >= rankRequire)
							//{
								if (Ultility.checkSource(curEquip.Source)&& !curEquip.IsUsed)
								{
									GuiMgr.getInstance().guiConfirm.showGUI("Đồ sau khi mặc sẽ không giao dịch được. Bạn có chắc chắn muốn mặc không?", function():void
									{
										ProcessWare(target);
									});
								}
								else
								{
									ProcessWare(target);
								}
								isProcessWare = true;
							//}
							//else
							//{
								//GuiMgr.getInstance().GuiMessageBox.ShowOK("Ngư thủ không đủ cấp để mặc đồ này!");
							//}
							break;
						}
					}
					
					// Nếu ko thả trúng ô nào -> check xem thả vào cá hay không
					if (!isProcessWare && curSoldier)
					{
						trace("OnReleaseItem ìf isProcessWare== " + isProcessWare + " |curSoldier== " + curSoldier);
						if (curSoldierImg.img != null && curEquipImage.img.hitTestObject(curSoldierImg.img))
						{
							for (i = 0; i < GetNumSlotEachType("Ctn_" + curEquip.Type); i++)
							{
								var container:Container = GetContainer("Ctn_" + curEquip.Type + "_" + i);
								if (container.ImageArr[0].ImageId == TXT_EMPTY_SLOT)
								{
									break;
								}
							}
							//var rankFishRequire:int = ConfigJSON.getInstance().GetItemList("Param")["EquipmentLimit"][curEquip.Rank];
							//if (curSoldier.Rank >= rankFishRequire)
							//{
								if (Ultility.checkSource(curEquip.Source)&& !curEquip.IsUsed)
								{
									GuiMgr.getInstance().guiConfirm.showGUI("Đồ sau khi mặc sẽ không giao dịch được. Bạn có chắc chắn muốn mặc không?", function():void
									{
										ProcessWare(container);
									});
								}
								else
								{
									ProcessWare(container);
								}
							//}
							//else
							//{
								//GuiMgr.getInstance().GuiMessageBox.ShowOK("Ngư thủ không đủ cấp để mặc đồ này!");
							//}
						}
					}
				}
				else
				{
					trace("OnReleaseItem else isWare== " + isWare);
					//var curCtn:Container = GetContainer("Ctn_" + curEquip.Type);
					var curCtn:Container = GetContainer(curCtnIdDown);
					if (curSoldierImg.img != null && !curEquipImage.img.hitTestObject(curCtn.img))
					{
						ProcessUnware();
					}
				}
				
				//curSoldier.UpdateBonusEquipment();		// Update infomations (damage, critical...)
				AddInfo();
			}
			//add đồ để tách
			else if(guiSeparateEquipment.img != null && guiSeparateEquipment.listItemSeparate != null)
			{
				trace("OnReleaseItem add đồ để tách guiSeparateEquipment.img== " + guiSeparateEquipment.img + " |listItemSeparate== " + guiSeparateEquipment.listItemSeparate);
				var success:Boolean = guiSeparateEquipment.addEquipment(curEquip);
				/*var isSeparating:Boolean = false;
				if (curEquip.Color == 5)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không thể tách đồ VIP!");
				}
				else if (curEquip.Type == "Seal")
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không thể tách ấn!");
				}
				else
				for each(var itemSeparate:ItemSeparate in guiSeparateEquipment.listItemSeparate.itemList)
				{
					if (curEquipImage.img.hitTestObject(itemSeparate.img) && itemSeparate.itemState != ItemSeparate.SEPARATED)
					{
						if(itemSeparate.itemState == ItemSeparate.HAS_EQUIPMENT)
						{
							itemSeparate.removeEquipment();
						}
						if (itemSeparate.itemState == ItemSeparate.EMPTY)
						{
							itemSeparate.setEquipment(curEquip);
							guiSeparateEquipment.GetButton(GUISeparateEquipment.BTN_SEPARATE).SetEnable(true);
							success = true;
						}
						if (itemSeparate.itemState == ItemSeparate.SEPARATING || itemSeparate.itemState == ItemSeparate.SEPARATED)
						{
							isSeparating = true;
						}
						break;
					}
				}*/
				
				if (success)
				{
					if (GetImage(ICON_HELPER_SEPARATE) != null)
					{
						RemoveImage(GetImage(ICON_HELPER_SEPARATE));
					}
					ItemList.splice(ItemList.indexOf(curEquip), 1);			// logic
					
					scrollPercent = scroll.getScrollCurrentPercent();
					ShowTab(curTab);
					ChangeTab(curTab);
				}
				//else
				//{
					//if (isSeparating)
					//{
						//GuiMgr.getInstance().GuiMessageBox.ShowOK("Đang tách đồ!");
					//}
				//}
			}
			
			// Remove the image follow the mouse
			if (curEquipImage)
			{
				trace("Remove the image curEquipImagee== " + curEquipImage);
				if (curEquipImage.img != null && curEquipImage.img.parent == img)
				{
					curEquipImage.img.stopDrag();
					img.removeChild(curEquipImage.img);
					curEquipImage.Destructor();
				}
			}
			
			//curEquip = null;
			isReleaseItem = true;
		}
		
		private function ProcessUnware():void
		{
			//var curCtn:Container = GetContainer("Ctn_" + curEquip.Type);
			// Take off clothes :))
			//curCtn.ClearComponent();
			
			// Back to store and go to the tab relate to it
			curEquip.SetFishOwn(null);
			ItemList.push(curEquip);
			//trace("num slot", GetNumSlotEachType("Ctn_" + curEquip.Type));
			//trace("index curequip", curSoldier.EquipmentList[curEquip.Type].length, curSoldier.EquipmentList[curEquip.Type].indexOf(curEquip));
			curSoldier.EquipmentList[curEquip.Type].splice(curSoldier.EquipmentList[curEquip.Type].indexOf(curEquip), 1);
			
			scrollPercent = 0;
			// Back to the tab relates to it
			if (curTab != TAB_ALL && curTab != "Tab_" + curEquip.Type
				&& curEquip.Type != "Ring" && curEquip.Type != "Belt" && curEquip.Type != "Bracelet" && curEquip.Type != "Necklace" && curEquip.Type != "Seal")
			{
				if (curTab == "Tab_" + curEquip.Type)
				{
					scrollPercent = scroll.getScrollCurrentPercent();
				}
				ChangeTab("Tab_" + curEquip.Type);
				ShowTab("Tab_" + curEquip.Type);
			}
			else if ((curEquip.Type == "Seal" || curEquip.Type == "Ring" || curEquip.Type == "Belt" || curEquip.Type == "Bracelet" || curEquip.Type == "Necklace")
						&& curTab != TAB_ALL && curTab != TAB_JEWELRY)
			{
				if (curTab == TAB_JEWELRY)
				{
					scrollPercent = scroll.getScrollCurrentPercent();
				}
				ChangeTab(TAB_JEWELRY);
				ShowTab(TAB_JEWELRY);
			}
			else
			{
				scrollPercent = scroll.getScrollCurrentPercent();
				ChangeTab(curTab);
				ShowTab(curTab);
			}
			
			if (ObjectUse[curEquip.Id])
			{
				delete(ObjectUse[curEquip.Id]);
			}
			else
			{
				ObjectStore[curEquip.Id] = 1;
			}
			//processChangeClothes();
			
			UpdateFishContent();		// Update Equipment Image in actor
			
			AddEquipsToSlot();
			curEquip = null;
			curSoldier.UpdateBonusEquipment();
			AddInfo();
		}
		
		private function ProcessWare(ctn:Container = null):void
		{
			trace("Mặc đồ cho cá ------------ProcessWare()");
			var target:Container = ctn;
			var oldUse:FishEquipment;
			// If item and fish not have same element
			if (curSoldier.Element != curEquip.Element && curEquip.Element != FishSoldier.ELEMENT_NONE)
			{
				var sss:String = Localization.getInstance().getString("FishWarMsg14");
				sss = sss.replace("@FishElement@", Localization.getInstance().getString("Element" + String(curSoldier.Element)));
				sss = sss.replace("@EquipElement@", Localization.getInstance().getString("Element" + String(curEquip.Element)));
				
				var curPos:Point = GameInput.getInstance().MousePos;
				var txtFormat:TextFormat = new TextFormat("Arial", 12, 0xffff00);
				
				txtFormat.align = "left";
				
				EffectMgr.getInstance().textFly(sss, curPos, txtFormat, LayerMgr.getInstance().GetLayer(Constant.TopLayer), 0, -30);
				return;
			}
			else
			{
				
				// Get info of current item unused
				if (ctn.ImageArr[0].ImageId != TXT_EMPTY_SLOT)
				{
					oldUse = curSoldier.EquipmentList[curEquip.Type][ctn.IdObject.split("_")[2]];
				}

				ItemList.splice(ItemList.indexOf(curEquip), 1);			// logic
				curEquip.SetFishOwn(curSoldier);
				curSoldier.EquipmentList[curEquip.Type].push(curEquip);
				
				if (ObjectStore[curEquip.Id])
				{
					delete(ObjectStore[curEquip.Id]);
				}
				else
				{
					ObjectUse[curEquip.Id] = 1;
				}
				
				// Add container of current item unused
				if (oldUse)
				{					
					if (ObjectUse[oldUse.Id])
					{
						delete(ObjectUse[oldUse.Id]);
					}
					else
					{
						ObjectStore[oldUse.Id] = 1;
					}
					
					oldUse.FishOwn = null;
					curSoldier.EquipmentList[oldUse.Type].splice(curSoldier.EquipmentList[oldUse.Type].indexOf(oldUse), 1);
					ItemList.push(oldUse);
				}
				
				//processChangeClothes();
			}
			
			scrollPercent = scroll.getScrollCurrentPercent();
			ShowTab(curTab);
			ChangeTab(curTab);
			
			UpdateFishContent();		// Update Equipment Image in actor
			AddEquipsToSlot();
			curEquip = null;
			
			curSoldier.UpdateBonusEquipment();
			AddInfo();
			
			//TUTORIAL
			if (GetImage(ICON_HELPER) != null)
			{
				RemoveImage(GetImage(ICON_HELPER));
			}
		}
		
		private function UpdateFishContent():void
		{
			var s:String;
			var i:int;
			
			AddActor();
			
			for (s in curSoldier.EquipmentList)
			{
				for (i = 0; i < curSoldier.EquipmentList[s].length; i++)
				{
					var eq:FishEquipment = curSoldier.EquipmentList[s][i];
					ChangeEquipment(eq);
				}
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
			var soldierInLake:FishSoldier = null;
			for (i = 0; i < GameLogic.getInstance().user.FishSoldierArr.length; i++)
			{
				if (GameLogic.getInstance().user.FishSoldierArr[i].Id == curSoldier.Id)
				{
					soldierInLake = GameLogic.getInstance().user.FishSoldierArr[i];
					break;
				}
			}
			
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
				
				if (soldierInLake != null)
				{
					for (s1 in soldierInLake.EquipmentList)
					{
						for (i = 0; i < soldierInLake.EquipmentList[s1].length; i++)
						{
							if (soldierInLake.EquipmentList[s1][i].Id == int(s))
							{
								soldierInLake.EquipmentList[s1].splice(i, 1);
							}
						}
					}
				}
				
				//curSoldier.WareEquipment(false, info);
			}
			
			for (s in ObjectUse)
			{
				info = GetEquipmentInfo(int(s));
				info.IsUsed = true;
				var usePacket:SendUseEquipmentSoldier = new SendUseEquipmentSoldier(info.Type, info.Id, curSoldier.Id, curSoldier.LakeId);
				Exchange.GetInstance().Send(usePacket);
				
				GameLogic.getInstance().user.UpdateEquipmentToStore(info, false);
				
				//if (soldierInLake != null)
				//{
					//soldierInLake.EquipmentList[info.Type].push(info);
				//}
				//curSoldier.EquipmentList[info.Type].push(info);
			}
			
			ObjectUse = new Object();
			ObjectStore = new Object();
			
			if (soldierInLake != null)
			{
				soldierInLake.RefreshImg();
				//trace("soldierInLakeId = " + soldierInLake.Id);
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
		
		/**
		 * Đổi vũ khí trang bị
		 * @param	Type	mũ áo
		 */
		public function ChangeEquipment(eq:FishEquipment):void
		{
			var Type:String = eq.Type;
			var resName:String = eq.imageName;
			var color:int = eq.Color;
			
			if (resName == "")	return;
			
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(curSoldierImg.img, Type);
			
			if (child != null)
			{
				var index:int = child.parent.getChildIndex(child);
				var eq:FishEquipment = new FishEquipment();
				eq.parent = child.parent as Sprite;
				eq.index = index;
				eq.oldChild = child;
				eq.Color = color;
				eq.loadComp = function f():void
				{
					//var dob :DisplayObject = child.parent.addChildAt(eq.img, index);
					//dob.name = Type;
					//child.parent.removeChild(child);
					//FishSoldier.EquipmentEffect(dob, color);
					
					var dob:DisplayObject = this.parent.addChildAt(this.img, this.index);
					dob.name = Type;
					if (this.oldChild != null && this.parent.contains(this.oldChild))
					this.parent.removeChild(this.oldChild);
					FishSoldier.EquipmentEffect(dob, this.Color);
				}
				eq.loadRes(resName);
			}
			
			if (eq.Type == "Seal")
			{
				if (wings != null && curSoldierImg.img.contains(wings.img))
				{
					curSoldierImg.img.removeChild(wings.img);
				}
				totalPercent = 0;
				var activeRowSeal:int = Ultility.getActiveRowSeal(eq, curSoldier);
				if (activeRowSeal > 0)
				{
					var wingName:String =  "Wings" + eq.Rank + activeRowSeal;
					if (eq.Color >= 5)
					{
						wingName =  "Wings" + eq.Rank + 6;
					}
					wings = new FishWings(curSoldierImg.img, wingName);
					curSoldierImg.img.setChildIndex(wings.img, 0);
					switch(curSoldier.Element)
					{
						case 4:
						case 2:
						case 1:
							wings.img.y = -30;
							wings.img.x = 16;
							break;
						case 3:
							wings.img.y = -40;
							wings.img.x = -16;
							break;
						case 5:
							wings.img.y = -25;
							wings.img.x = 20;
							break;
					}
					//curSoldierImg.img.addChild(wings.img);
					
					var configSeal:Object = ConfigJSON.getInstance().GetItemList("Wars_Seal");
					if(configSeal[eq.Rank][eq.Color][activeRowSeal]["TotalPercent"] != null)
					{
						totalPercent = configSeal[eq.Rank][eq.Color][activeRowSeal]["TotalPercent"];
					}
				}
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			if (buttonID == BTN_CLOSE)	return;
			
			var a:Array = buttonID.split("_");
			var obj:Object;
			var c:Container;
			//trace("OnButtonMove buttonID== " + buttonID + " |a[0]== " + a[0] + " |a[1]== " + a[1]);
			switch (a[0] + "_" + a[1])
			{
				case CTN_ARMOR:
				case CTN_HELMET:
				case CTN_WEAPON:
				case CTN_BELT:
				case CTN_NECKLACE:
				case CTN_BRACELET:
				case CTN_RING:
				case CTN_MASK:
				case CTN_SEAL:
					try
					{
						obj = curSoldier.EquipmentList[a[1]][a[2]];
						c = GetContainer(buttonID);
					}
					catch (err:Error)
					{
						
					}
					
					if (obj /*&& curEquip == null */&& !isReleaseItem)
					{
						var activeRowSeal:int;
						if(obj["Type"] == "Seal")
						{
							activeRowSeal = Ultility.getActiveRowSeal(obj as FishEquipment, curSoldier);
						}
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, obj, GUIEquipmentInfo.INFO_TYPE_SPECIFIC, null, activeRowSeal, totalPercent);
					}
					break;
				default:
					if (buttonID != CTN_SEAL && buttonID.search("Tab") == -1 
						&& buttonID != BTN_SHOP && buttonID != BTN_SORT && buttonID != BTN_EXTEND && buttonID != BTN_DEL && buttonID != BTN_ENCHANT && buttonID != BTN_SEPARATE && buttonID != BTN_UNLOCK_ITEM)
					{
						obj = GetEquipmentInfo(parseInt(a[1]));
						c = listBox.getItemById(buttonID);
					}
					
					if (obj /*&& curEquip == null*/ && !isReleaseItem)
					{
						if (curSoldier)
						{
							var activeRow:int;
							if(obj["Type"] == "Seal")
							{
								activeRow = Ultility.getActiveRowSeal(obj as FishEquipment, curSoldier);
							}
							GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, obj, GUIEquipmentInfo.INFO_TYPE_SPECIFIC,
								curSoldier.EquipmentList[obj.Type][0], activeRow, totalPercent);
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
			//trace("OnButtonOut");
			if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
			isReleaseItem = false;
		}
	}

}