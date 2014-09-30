package GUI.FishWar 
{
	import adobe.utils.ProductManager;
	import com.adobe.net.DynamicURLLoader;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.data.VideoLoaderVars;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import GameControl.GameController;
	import GUI.component.Button;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ProgressBar;
	import GUI.component.ScrollBar;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.Fish;
	import GUI.FishWar.FishEquipment;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendDeleteEquipment;
	import NetworkPacket.PacketSend.SendStoreEquipment;
	import NetworkPacket.PacketSend.SendStoreItem;
	import NetworkPacket.PacketSend.SendUseEquipmentSoldier;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUISoliderInfo extends BaseGUI 
	{
		static public const BTN_BACK_SOLIDER:String = "btnBackSolider";
		static public const BTN_NEXT_SOLIDER:String = "btnNextSolider";
		private static const BTN_CLOSE:String = "Btn_Close";
		private static const BTN_SHOW_QUARTZ:String = "Btn_Show_Quartz";
		
		private static const CTN_HELMET:String = "Ctn_Helmet";
		private static const CTN_ARMOR:String = "Ctn_Armor";
		private static const CTN_WEAPON:String = "Ctn_Weapon";
		private static const CTN_BELT:String = "Ctn_Belt";
		private static const CTN_BRACELET:String = "Ctn_Bracelet";
		private static const CTN_NECKLACE:String = "Ctn_Necklace";
		private static const CTN_RING:String = "Ctn_Ring";
		private static const CTN_MASK:String = "Ctn_Mask";
		private static const CTN_SEAL:String = "Ctn_Seal";
		
		private static const CTN_INFO:String = "Group_Info";
		private static const TXT_EMPTY_SLOT:String = "Empty";
		
		private static const DOUBLE_CLICK_TIMER:Number = 0.5;
			
		private var curEquipImage:Image;					// Image dragable
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
		public var curSoldier:FishSoldier;					// Current Soldier is changing equips
		private var curSoldierImg:Image;					// Current Soldier image in GUI
		private var curCtnIdDown:String;					// Current Container's Id that mouse down
		
		private var isWare:Boolean = true;					// Variable to check what drag means (ware or unware equip)
		
		private var lastTimeClick:Number = 0;				// Double click purpose
		private var lastTimeCtn:String = "";				// Double click purpose
		
		private var ctnHelmet:Container;
		private var ctnArmor:Container;
		private var ctnWeapon:Container;
		
		public var numItemInTab:int;
		
		private var isUpdateSoldier:Boolean;				
		private var isReleaseItem:Boolean;					// Flag
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var isDataReady:Boolean;
		private var btnBackSolider:Button;
		private var btnNextSolider:Button;
		private var arrSolider:Array;
		private var wings:FishWings;
		private var btnShowQuartz:Button;
		
		public function GUISoliderInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIChooseEquipment";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				SetPos(190, 10);
				
				if (isUpdateSoldier)
				{
					ClearComponent();
					refreshComponent();
				}
				else
				{
					OpenRoomOut();
				}
			}
			LoadRes("GuiSoldierInfo_Theme");
		}
		
		public function Init(s:FishSoldier, updateSolider:Boolean = false):void
		{
			isUpdateSoldier = updateSolider;
			ObjectStore = new Object();
			ObjectUse = new Object();
			for (var i:int = 0; i < GameLogic.getInstance().user.FishSoldierAllArr.length; i++)
			{
				if (s.Id == GameLogic.getInstance().user.FishSoldierAllArr[i].Id)
				{
					curSoldier = GameLogic.getInstance().user.FishSoldierAllArr[i];
					break;
				}
			}
			//curSoldier = s;
			ItemList.splice(0, ItemList.length);
			
			this.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		public override function EndingRoomOut():void
		{
			AddButton(BTN_CLOSE, "BtnThoat", 707 - 290, 19);
			
			ClearComponent();
			refreshComponent();
		}
		
		public function refreshComponent():void
		{
			AddButtons();
			
			ShowSlots();
			if (curSoldier)
			{
				var nameSoldier:String = "Tiểu " + Ultility.GetNameElement(curSoldier.Element) + " Ngư";
				if (curSoldier.nameSoldier != null && curSoldier.nameSoldier != "")
				{
					nameSoldier = curSoldier.nameSoldier;
				}
				var txtFieldName:TextField = AddLabel(nameSoldier, 180, 191);
				txtFieldName.maxChars = 16;
				var txtFormat:TextFormat = new TextFormat("arial", 13, 0xffff00, true);
				txtFormat.align = "right";
				txtFieldName.setTextFormat(txtFormat);
				
				
				AddEquipsToSlot();
				//AddActor();
				UpdateFishContent();
				AddInfo();
			}
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
			
			ctnHelmet = AddContainer(CTN_HELMET + "_0", "GuiSoldierInfo_Ctn", ItemPos.Helmet.x, ItemPos.Helmet.y, true, this);
			InteractiveCtn.push(ctnHelmet);
			ctnArmor = AddContainer(CTN_ARMOR + "_0", "GuiSoldierInfo_Ctn", ItemPos.Armor.x, ItemPos.Armor.y, true, this);
			InteractiveCtn.push(ctnArmor);
			ctnWeapon = AddContainer(CTN_WEAPON + "_0", "GuiSoldierInfo_Ctn", ItemPos.Weapon.x, ItemPos.Weapon.y, true, this);
			InteractiveCtn.push(ctnWeapon);
			InteractiveCtn.push(AddContainer(CTN_SEAL + "_0", "GuiSoldierInfo_Ctn", ItemPos.Other1.x, ItemPos.Other1.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_MASK + "_0", "GuiSoldierInfo_Ctn", ItemPos.Other2.x, ItemPos.Other2.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_NECKLACE + "_0", "GuiSoldierInfo_Ctn", ItemPos.Other3.x, ItemPos.Other3.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_BELT + "_0", "GuiSoldierInfo_Ctn", ItemPos.Other4.x, ItemPos.Other4.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_RING + "_0", "GuiSoldierInfo_CtnSmall", ItemPos.Other5.x, ItemPos.Other5.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_RING + "_1", "GuiSoldierInfo_CtnSmall", ItemPos.Other6.x, ItemPos.Other6.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_BRACELET + "_0", "GuiSoldierInfo_CtnSmall", ItemPos.Other7.x, ItemPos.Other7.y, true, this));
			InteractiveCtn.push(AddContainer(CTN_BRACELET + "_1", "GuiSoldierInfo_CtnSmall", ItemPos.Other8.x, ItemPos.Other8.y, true, this));
		}
		
		/**
		 * Show fish is chosen
		 */
		private function AddActor():void
		{
			if (curSoldierImg)
			{
				if (curSoldierImg.img)
				img.removeChild(curSoldierImg.img);
			}
			
			if (curSoldier.EquipmentList.Mask[0])
			{
				curSoldierImg = AddImage("", curSoldier.EquipmentList.Mask[0].TransformName, 0, 0);
			}
			else
			{
				curSoldierImg = AddImage("", Fish.ItemType + curSoldier.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 0, 0);
			}
			
			curSoldierImg.FitRect(100, 100, new Point (160, 208));
		}
		
		private function AddInfo():void
		{
			RemoveContainer(CTN_INFO);
			var ctn:Container = AddContainer(CTN_INFO, "GuiSoldierInfo_ImgFrameFriend", 80, 415);
			
			var dmgTotal:int;
			var defTotal:int;
			var critTotal:int;
			var vitTotal:int;
			if (curSoldier.bonusEquipment == null)
			{
				dmgTotal = curSoldier.Damage;
				defTotal = curSoldier.Defence;
				critTotal = curSoldier.Critical;
				vitTotal = curSoldier.Vitality;
			}
			else 
			{
				dmgTotal = curSoldier.getTotalDamage();
				defTotal = curSoldier.getTotalDefence();
				critTotal = curSoldier.getTotalCritical();
				vitTotal = curSoldier.getTotalVitality();
			}
			
			var tF:TextField;
			var txtF:TextFormat;
			
			tF = ctn.AddLabel(dmgTotal + "", 150, 42, 0xFFFFFF, 0, 0x603813);
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
			
			tF = ctn.AddLabel(defTotal + "", 150, 62, 0xFFFFFF, 0, 0x603813);
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
			
			tF = ctn.AddLabel(critTotal + "", 150, 83, 0xFFFFFF, 0, 0x603813);
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
			
			tF = ctn.AddLabel(vitTotal + "", 150, 103, 0xFFFFFF, 0, 0x603813);
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
			
			var prg:ProgressBar = ctn.AddProgress("", "GuiSoldierInfo_PrgRank", 116, 16);
			prg.setStatus(curSoldier.RankPoint / curSoldier.MaxRankPoint);
			ctn.AddLabel(Ultility.StandardNumber(curSoldier.RankPoint) + "/" + Ultility.StandardNumber(curSoldier.MaxRankPoint), 125, 14, 0x000000, 1, 0xffffff);
			
			ctn.AddLabel("Cấp " + curSoldier.Rank + " - " + Localization.getInstance().getString("FishSoldierRank" + curSoldier.Rank), 120, -5, 0xFFF100, 1, 0x603813);
			var rankName:String;
			if (curSoldier.Rank > 13)
			{
				rankName = "Rank13";
			}
			else
			{
				rankName = "Rank" + curSoldier.Rank;
			}
			ctn.AddImage("", rankName, 55, 10);
			
			ctn.AddImage("", "Element" + curSoldier.Element, 255, 15);
			ctn.AddLabel("Hệ " + Localization.getInstance().getString("Element" + curSoldier.Element), 205, 30, 0x000000, 1, 0xffffff);
			
			ctn.AddImage("", "IcRank", 0, 0).FitRect(30, 30, new Point(93, 8));
		}
		
		/**
		 * Add current Equips of fishes
		 */
		private function AddEquipsToSlot():void
		{
			var curItem:Object = curSoldier.EquipmentList;
			var s:String;
			var k:int;
			var imag:Image;
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
						var imag1:Image = null;
						// Add nền nếu là đồ quý, đặc biệt
						if (curItem[s][k].Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
						{
							imag1 = ctn.AddImage("", FishEquipment.GetBackgroundName(curItem[s][k].Color), 0, 0, true, ALIGN_LEFT_TOP);
						}
						
						var imagName:String = curItem[s][k].imageName + "_Shop";
						var tF:TextFormat = new TextFormat();
						imag = drawImgEquip(ctn, curItem[s][k].Id, imagName, curItem[s][k].Color);
						
						var icMax:Image;
						if (curItem[s][k].Color == 6)
						{
							icMax = ctn.AddImage("", "IcMax", 74, 26);
							icMax.SetScaleXY(0.7);
						}
						
						if (s != "Bracelet" && s != "Ring")
						{
							imag.FitRect(60, 60, new Point( 7, 7));
							tF.size = 18;
							tF.bold = true;
						}
						else
						{
							if (icMax != null)
							{
								icMax.img.x -= 34;
							}
							if (imag1)
							{					
								imag1.FitRect(37, 37);							
							}
							imag.FitRect(30, 30, new Point( 3, 3));
							tF.size = 12;
							tF.bold = true;
						}
						
						if (curItem[s][k].EnchantLevel > 0)
						{
							var txt:TextField = ctn.AddLabel("+" + curItem[s][k].EnchantLevel, 2, 2, 0xFFF100, 0, 0x603813);
							txt.setTextFormat(tF);
						}
						
						// Nếu đồ hết hạn
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
						imag = ctn.AddImage(TXT_EMPTY_SLOT, "GuiSoldierInfo_txt" + s, 0, 0);
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
			AddButton(BTN_CLOSE, "BtnThoat", 707 - 300, 19);
			btnShowQuartz = AddButton(BTN_SHOW_QUARTZ, "GuiSoldierInfo_XemHuyHieu", 170, 556);
			btnShowQuartz.setTooltipText("Xem Huy Hiệu Ngư Thủ");
			
			btnBackSolider = AddButton(BTN_BACK_SOLIDER, "GuiSoldierInfo_Btn_Down", 68 + 83, 426 - 198, this);
			btnBackSolider.img.scaleX = btnBackSolider.img.scaleY = 0.7;
			btnBackSolider.img.rotation += 90;
			btnNextSolider = AddButton(BTN_NEXT_SOLIDER, "GuiSoldierInfo_Btn_Up", 285, 426 - 198, this);
			btnNextSolider.img.scaleX = btnNextSolider.img.scaleY = 0.7;
			btnNextSolider.img.rotation += 90;
			arrSolider = GameLogic.getInstance().user.FishSoldierAllArr;
			arrSolider = arrSolider.concat(new Array());
			for (var i:int = 0; i < arrSolider.length; i++)
			{
				if (FishSoldier(arrSolider[i]).SoldierType != FishSoldier.SOLDIER_TYPE_MIX)
				{
					arrSolider.splice(i, 1);
					i--;
				}
			}
			if (arrSolider == null || arrSolider.length < 2)
			{
				btnBackSolider.SetVisible(false);
				btnNextSolider.SetVisible(false);
			}
		}
		
		private function AddOneEquipment(o:FishEquipment):void
		{
			var ctn:Container;
			ctn = AddContainer("Ctn_" + o.Id, "GuiSoldierInfo_Ctn", 10, 10, true, this);
			
			
			var imag:Image = ctn.AddImage("", o.imageName + "_Shop", 10, 10);
			imag.setImgInfo = function f():void { FishSoldier.EquipmentEffect(imag.img, o.Color) };
			imag.FitRect(60, 60, new Point(7, 7));
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
		
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE:
					this.Hide();
					break;
				case BTN_BACK_SOLIDER:
					if (curSoldier)
					{
						processChangeClothes();
						UpdateAllFishArr();
						curSoldier.RefreshImg();
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
					Init(backSolider, true);
					break;
				case BTN_NEXT_SOLIDER:
					if (curSoldier)
					{
						processChangeClothes();
						UpdateAllFishArr();
						curSoldier.RefreshImg();
					}
					var nextSolider:FishSoldier;
					for (var j:int = 0; j < arrSolider.length; j++)
					{
						if (arrSolider[j].Id == curSoldier.Id)
						{
							if( j== 0)
							{
								nextSolider = arrSolider[arrSolider.length - 1];
							}
							else
							{
								nextSolider = arrSolider[j - 1];
							}
							break;
						}
					}
					Init(nextSolider, true);
					break;
				case BTN_SHOW_QUARTZ:
					this.Hide();
					GuiMgr.getInstance().guiShowQuartzUser.showGUI(curSoldier.Id);
					break;
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
		
		private function UpdateFishContent():void
		{
			var s:String;
			var i:int;
			
			AddActor();
			if (!curSoldier.EquipmentList.Mask[0])
			{
				for (s in curSoldier.EquipmentList)
				{
					for (i = 0; i < curSoldier.EquipmentList[s].length; i++)
					{
						var eq:FishEquipment = curSoldier.EquipmentList[s][i];
						ChangeEquipment(eq);
					}
				}
			}
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
		}
		
		/**
		 * Get all info of one Equipment by it's Id (in ItemList or in current Soldier Equipment)
		 * @param	id
		 * @return
		 */
		private function GetEquipmentInfo(id:int):FishEquipment
		{
			//var ItemList1:Array = GetItemList(TAB_ALL);
			//for (var i:int = 0; i < ItemList1.length; i++)
			//{
				//if (ItemList1[i].Id == id)
				//{
					//return ItemList1[i];
				//}
			//}
			
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
				eq.loadComp = function f():void
				{
					var dob :DisplayObject = child.parent.addChildAt(eq.img, index);
					dob.name = Type;
					child.parent.removeChild(child);
					FishSoldier.EquipmentEffect(dob, color);
				}
				eq.loadRes(resName);
			}
			
			if (eq.Type == "Seal")
			{
				if (wings != null && curSoldierImg.img.contains(wings.img))
				{
					curSoldierImg.img.removeChild(wings.img);
				}
				
				var activeRowSeal:int = Ultility.getActiveRowSeal(eq, curSoldier);
				if (activeRowSeal > 0)
				{
					//wings = ResMgr.getInstance().GetRes("Wings" + eq.Rank + activeRowSeal) as Sprite;
					wings = new FishWings(curSoldierImg.img, "Wings" + eq.Rank + activeRowSeal);
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
				}
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
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
					break;
			}
			
			if (obj && curEquip == null)
			{
				var activeRowSeal:int;
				if(obj["Type"] == "Seal")
				{
					activeRowSeal = Ultility.getActiveRowSeal(obj as FishEquipment, curSoldier);
				}
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, obj, GUIEquipmentInfo.INFO_TYPE_SPECIFIC, null, activeRowSeal);
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}

	}

}