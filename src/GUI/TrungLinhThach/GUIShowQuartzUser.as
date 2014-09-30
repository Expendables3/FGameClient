package GUI.TrungLinhThach 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import Data.ResMgr;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.FishWings;
	import Logic.Fish;
	import Logic.FishSoldier;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import particleSys.myFish.CometEmit;
	
	import Sound.SoundMgr;
	import com.adobe.serialization.json.JSON;
	
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TextBox;
	import GUI.GuiMgr;
	import GUI.Event8March.CoralTree;
	
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class GUIShowQuartzUser extends BaseGUI 
	{
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var isDataReady:Boolean;
		public var IsInitFinish:Boolean = false;
		
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_BACK_SOLIDER:String = "btnBackSolider";
		static public const BTN_NEXT_SOLIDER:String = "btnNextSolider";
		private static const CTN_INFO:String = "Group_Info";
		private static const BTN_SHOW_EQUIMENT:String = "Btn_Show_Equiment";
		
		private var btnShowEquiment:Button;
		private var buttonClose:Button;
		private var btnBackSolider:Button;
		private var btnNextSolider:Button;
		
		private var InteractiveCtn:Array = new Array();		// List all the Container can be interact
		private var ItemPos:Object;							// Positions of all the container in GUI (fixed)
		
		private static const CTN_QUARTZ_1:String = "Ctn_Quartz_1";
		private static const CTN_QUARTZ_2:String = "Ctn_Quartz_2";
		private static const CTN_QUARTZ_3:String = "Ctn_Quartz_3";
		private static const CTN_QUARTZ_4:String = "Ctn_Quartz_4";
		private static const CTN_QUARTZ_5:String = "Ctn_Quartz_5";
		private static const CTN_QUARTZ_6:String = "Ctn_Quartz_6";
		private static const CTN_QUARTZ_7:String = "Ctn_Quartz_7";
		private static const CTN_QUARTZ_8:String = "Ctn_Quartz_8";
		
		private static const CTN_QUARTZ_WHITE:String = "Ctn_QWhite";
		private static const CTN_QUARTZ_GREEN:String = "Ctn_QGreen";
		private static const CTN_QUARTZ_YELLOW:String = "Ctn_QYellow";
		private static const CTN_QUARTZ_PURPLE:String = "Ctn_QPurple";
		private static const CTN_QUARTZ_VIP:String = "Ctn_QVIP";
		
		private var ctnQuartz_1:Container;
		private var ctnQuartz_2:Container;
		private var ctnQuartz_3:Container;
		private var ctnQuartz_4:Container;
		private var ctnQuartz_5:Container;
		private var ctnQuartz_6:Container;
		private var ctnQuartz_7:Container;
		private var ctnQuartz_8:Container;
		public var curSoldier:FishSoldier;					// Current Soldier is changing equips
		private var curSoldierImg:Image;					// Current Soldier image in GUI
		private var arrSolider:Array;
		private var labelSoldierName:TextField;
		private var labelSoldierLevel:TextField;
		
		private var curIdSoldier:int;
		private var ctnBonus:Container;
		private var wings:FishWings;
		private var slotData:Array = new Array();
		private var dataQuartz:Array = new Array();
		private var idShowSoldier:int;
		private var ctnQuart:Container;
		
		public function GUIShowQuartzUser(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GuiShowQuartzUser";
		}
		
		override public function InitGUI():void 
		{
			//trace("InitGUI()");
			this.setImgInfo = function():void
			{
				IsInitFinish = false;
				SetPos(175, 20);
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				
				OpenRoomOut();
				
			}
			LoadRes("GuiShowQuartzUser_Bg");
		}
		
		public function showGUI(id:int):void
		{
			idShowSoldier = id;
			isDataReady = false;
			//trace("showGUI()== " + isDataReady);
			this.Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function EndingRoomOut():void 
		{
			IsInitFinish = true;
			isDataReady = true;
			//trace("EndingRoomOut()== " + isDataReady);
			super.EndingRoomOut();
			if (isDataReady)
			{
				ClearComponent();
				refreshComponent();
			}
		}
		
		public function refreshComponent(dataAvailable:Boolean = true):void 
		{
			isDataReady = dataAvailable;
			//trace("refreshComponent()== " + isDataReady);
			if (!isDataReady || !IsFinishRoomOut)
			{
				return;
			}
			
			if (img == null) return;
			
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			
			addContent();
		}
		
		private function addContent():void
		{
			buttonClose = AddButton(BTN_CLOSE, "BtnThoat", 432, 19);
			buttonClose.setTooltipText("Đóng lại");
			
			btnShowEquiment = AddButton(BTN_SHOW_EQUIMENT, "GuiShowQuartzUser_XemTrangBi", 182, 537);
			btnShowEquiment.setTooltipText("Xem Trang Bị Ngư Thủ");
			
			ctnBonus = AddContainer(CTN_INFO, "GuiShowQuartzUser_ImgFrameFriend", 58, 390);
			
			addSolider(null);
			ShowSlots()
			loadSlotData();
		}
		
		private function addSolider(s:FishSoldier, updateSolider:Boolean = false):void
		{
			var glow:GlowFilter = new GlowFilter(0x330000, 1, 4, 4, 10); 
			
			arrSolider = GameLogic.getInstance().user.FishSoldierAllArr;// GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			arrSolider = arrSolider.concat(new Array());
			//trace("arrSolider.length== " + arrSolider.length);
			
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
				for (var j:int = 0; j < arrSolider.length; j++ )
				{
					if (arrSolider[j].Id == idShowSoldier)
					{
						curSoldier = arrSolider[j];
					}
				}
			}
			else
			{
				curSoldier = s;
			}
			
			if (updateSolider)
			{
				removeTextSolider();
				loadSlotData();
			}
			
			if (curSoldier)
			{
				curIdSoldier = curSoldier.Id;
				
				var nameSoldier:String = "Tiểu " + Ultility.GetNameElement(curSoldier.Element) + " Ngư";
				if (curSoldier.nameSoldier != null && curSoldier.nameSoldier != "")
				{
					nameSoldier = curSoldier.nameSoldier;
				}
				
				labelSoldierName = AddLabel(nameSoldier, 190, 157, 0xffffff, 0);
				var txtFormat:TextFormat = new TextFormat("arial", 13, 0xffff00, true);
				labelSoldierName.setTextFormat(txtFormat);
				labelSoldierName.defaultTextFormat = txtFormat;
				
				var levelSoldier:String = "Cấp " + curSoldier.Rank + " - " + Localization.getInstance().getString("FishSoldierRank" + curSoldier.Rank);
				labelSoldierLevel = AddLabel(levelSoldier, 180, 290, 0xFFFF00, 0);
				var txtFormatLevel:TextFormat = new TextFormat("arial", 13, 0xFFFF00, true);
				labelSoldierLevel.autoSize = TextFieldAutoSize.CENTER
				labelSoldierLevel.setTextFormat(txtFormatLevel);
				labelSoldierLevel.defaultTextFormat = txtFormatLevel;
				labelSoldierLevel.filters = [glow];
				
				UpdateFishContent();
				UpdateStart();
			}
			else
			{
				var labelSoldierReport:TextField = AddLabel("Bạn không có  ngư thủ nào", 120, 230, 0xffffff, 0);
				var txtFormatReport:TextFormat = new TextFormat("arial", 14, 0x000000, true);
				labelSoldierReport.setTextFormat(txtFormatReport);
				labelSoldierReport.defaultTextFormat = txtFormatReport;
			}
			AddInfo();
			
			btnBackSolider = AddButton(BTN_BACK_SOLIDER, "GuiShowQuartzUser_Btn_Down", 160, 240, this);
			btnBackSolider.img.scaleX = btnBackSolider.img.scaleY = 0.7;
			btnBackSolider.img.rotation += 90;
			btnNextSolider = AddButton(BTN_NEXT_SOLIDER, "GuiShowQuartzUser_Btn_Up", 320, 240, this);
			btnNextSolider.img.scaleX = btnNextSolider.img.scaleY = 0.7;
			btnNextSolider.img.rotation += 90;
			
			if (arrSolider == null || arrSolider.length < 2 || !Ultility.IsInMyFish())
			{
				btnBackSolider.SetVisible(false);
				btnNextSolider.SetVisible(false);
			}
		}
		
		private function removeTextSolider():void
		{
			if (labelSoldierName && img)
			{
				img.removeChild(labelSoldierName);
			}
			if (labelSoldierLevel && img)
			{
				img.removeChild(labelSoldierLevel);
			}
			LabelArr.splice(0, LabelArr.length);
			labelSoldierName = null;
			labelSoldierLevel = null;
		}
		
		private function UpdateFishContent():void
		{
			var s:String;
			var i:int;
			
			AddActor();
			
			for (s in curSoldier.EquipmentList)
			{
				//trace("s===== " + s + " |EquipmentList[s].length== " + curSoldier.EquipmentList[s].length);
				for (i = 0; i < curSoldier.EquipmentList[s].length; i++)
				{
					var eq:FishEquipment = curSoldier.EquipmentList[s][i];
					ChangeEquipment(eq);
				}
			}
		}
		
		private function AddActor():void
		{
			if (curSoldierImg)
			{
				if (curSoldierImg.img)
				img.removeChild(curSoldierImg.img);
			}
			
			if (curSoldier.EquipmentList.Mask[0])
			{
				curSoldierImg = AddImage("", curSoldier.EquipmentList.Mask[0].TransformName, -20, -70);
				curSoldierImg.img.mouseChildren = false;
				curSoldierImg.img.mouseEnabled = false;
				curSoldierImg.img.parent.mouseEnabled = false;
			}
			else
			{
				curSoldierImg = AddImage("", Fish.ItemType + curSoldier.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, -20, -70);
				curSoldierImg.img.parent.mouseEnabled = false;
				curSoldierImg.img.mouseChildren = false;
				curSoldierImg.img.mouseEnabled = false;
			}
			//trace("curSoldierImg.img.x== " + curSoldierImg.img.x + " |curSoldierImg.img.y== " + curSoldierImg.img.y);
			
			curSoldierImg.FitRect(100, 100, new Point (180, 200));
		}
		
		private function AddInfo():void
		{
			ctnBonus.ClearComponent();
			//RemoveContainer(CTN_INFO);
			
			var dmgTotal:int = 0;
			var critTotal:Number = 0;
			var vitTotal:int = 0;
			var defTotal:int = 0;
			
			if (curSoldier)
			{
				if (curSoldier.bonusEquipment == null)
				{
					//trace("AddInfo() tren curSoldier.bonusEquipment== " + curSoldier.bonusEquipment);
					dmgTotal = curSoldier.Damage;
					critTotal = curSoldier.Critical;
					vitTotal = curSoldier.Vitality;
					defTotal = curSoldier.Defence;
				}
				else 
				{
					//trace("AddInfo() duoi curSoldier.bonusEquipment== " + curSoldier.bonusEquipment);
					dmgTotal = curSoldier.getTotalDamage();
					critTotal = curSoldier.getTotalCritical();
					vitTotal = curSoldier.getTotalVitality();
					defTotal = curSoldier.getTotalDefence();
				}
				//trace("AddInfo() dmgTotal== " + dmgTotal + " |getTotalDamage()== " + curSoldier.getTotalDamage());
			}
			
			var tF:TextField;
			var txtF:TextFormat;
			
			tF = ctnBonus.AddLabel(dmgTotal + "", 75, 80, 0xFFFFFF, 0, 0x603813);
			
			if (curSoldier)
			{
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
			}
			
			tF = ctnBonus.AddLabel(defTotal + "", 75, 108, 0xFFFFFF, 0, 0x603813);
			if (curSoldier)
			{
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
			}
			
			tF = ctnBonus.AddLabel(critTotal + "", 240, 80, 0xFFFFFF, 0, 0x603813);
			if (curSoldier)
			{
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
			}
			
			tF = ctnBonus.AddLabel(vitTotal + "", 240, 108, 0xFFFFFF, 0, 0x603813);
			if (curSoldier)
			{
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
			}
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
				
				var activeRowSeal:int = Ultility.getActiveRowSeal(eq, curSoldier);
				if (activeRowSeal > 0)
				{
					wings = new FishWings(curSoldierImg.img, "Wings" + eq.Rank + activeRowSeal);
					curSoldierImg.img.setChildIndex(wings.img, 0);
					switch(curSoldier.Element)
					{
						case 4:
						case 2:
						case 1:
							trace("case 1:");
							wings.img.y = -30;
							wings.img.x = 16;
							break;
						case 3:
							trace("case 3:");
							wings.img.y = -40;
							wings.img.x = -16;
							break;
						case 5:
							trace("case 5:");
							wings.img.y = -25;
							wings.img.x = 20;
							break;
					}
				}
			}
		}
		
		private function UpdateAllFishArr():void
		{
			var mySoldier:Array = GameLogic.getInstance().user.FishSoldierAllArr;// GameLogic.getInstance().user.GetMyInfo().MySoldierArr;
			//trace("UpdateAllFishArr() mySoldier.length== " + mySoldier.length);
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
		
		private function GetNumSlotEachType(type:String):int
		{
			//trace("type== " + type);
			switch (type)
			{
				case CTN_QUARTZ_WHITE:
				case CTN_QUARTZ_GREEN:
				case CTN_QUARTZ_YELLOW:
				case CTN_QUARTZ_PURPLE:
				case CTN_QUARTZ_VIP:
					return 8;
			}
			return 0;
		}
		
		private function ShowSlots():void
		{
			InteractiveCtn.splice(0, InteractiveCtn.length);
			
			if (!ItemPos)
			{
				ItemPos = new Object();
				// Fix positions of slots
				ItemPos.Quartz_1 = new Point(180, 55);		// coordinate of ctn Quartz_1
				ItemPos.Quartz_2 = new Point(295, 100);		// coordinate of ctn Quartz_2
				ItemPos.Quartz_3 = new Point(335, 200);		// coordinate of ctn Quartz_3
				ItemPos.Quartz_4 = new Point (290, 300);	// coordinate of ctn Quartz_4
				ItemPos.Quartz_5 = new Point (185, 350);	// coordinate of ctn Quartz_5
				ItemPos.Quartz_6 = new Point (75, 305);	// coordinate of ctn Quartz_6
				ItemPos.Quartz_7 = new Point (35, 202);	// coordinate of ctn Quartz_7
				ItemPos.Quartz_8 = new Point (75, 100);	// coordinate of ctn Quartz_8 1
			}
			
			ctnQuartz_1 = AddContainer(CTN_QUARTZ_1, "GuiShowQuartzUser_ItemGhepBg", ItemPos.Quartz_1.x, ItemPos.Quartz_1.y, true, this);
			InteractiveCtn.push(ctnQuartz_1);
			ctnQuartz_2 = AddContainer(CTN_QUARTZ_2, "GuiShowQuartzUser_ItemGhepBg", ItemPos.Quartz_2.x, ItemPos.Quartz_2.y, true, this);
			InteractiveCtn.push(ctnQuartz_2);
			ctnQuartz_3 = AddContainer(CTN_QUARTZ_3, "GuiShowQuartzUser_ItemGhepBg", ItemPos.Quartz_3.x, ItemPos.Quartz_3.y, true, this);
			InteractiveCtn.push(ctnQuartz_3);
			ctnQuartz_4 = AddContainer(CTN_QUARTZ_4, "GuiShowQuartzUser_ItemGhepBg", ItemPos.Quartz_4.x, ItemPos.Quartz_4.y, true, this);
			InteractiveCtn.push(ctnQuartz_4);
			ctnQuartz_5 = AddContainer(CTN_QUARTZ_5, "GuiShowQuartzUser_ItemGhepBg", ItemPos.Quartz_5.x, ItemPos.Quartz_5.y, true, this);
			InteractiveCtn.push(ctnQuartz_5);
			ctnQuartz_6 = AddContainer(CTN_QUARTZ_6, "GuiShowQuartzUser_ItemGhepBg", ItemPos.Quartz_6.x, ItemPos.Quartz_6.y, true, this);
			InteractiveCtn.push(ctnQuartz_6);
			ctnQuartz_7 = AddContainer(CTN_QUARTZ_7, "GuiShowQuartzUser_ItemGhepBg", ItemPos.Quartz_7.x, ItemPos.Quartz_7.y, true, this);
			InteractiveCtn.push(ctnQuartz_7);
			ctnQuartz_8 = AddContainer(CTN_QUARTZ_8, "GuiShowQuartzUser_ItemGhepBg", ItemPos.Quartz_8.x, ItemPos.Quartz_8.y, true, this);
			InteractiveCtn.push(ctnQuartz_8);
		}
		
		private function loadSlotData():void
		{
			var cmdLinhThach:SendGetSmashEgg = new SendGetSmashEgg();
			cmdLinhThach.FriendId = GameLogic.getInstance().user.Id;
			Exchange.GetInstance().Send(cmdLinhThach);
		}
		
		public function receiveSlotUser(data:Object):void
		{
			//trace("receiveSlotUser");
			var slotObjData:Object = new Object();
			slotObjData = data["SmashEgg"]["Slot"];
			
			AddEquipsToSlot(slotObjData);
		}
		
		private function AddEquipsToSlot(slotObjData:Object):void
		{
			var k:int;
			if (curSoldier)
			{
				//trace("curSoldier.Id== " + curSoldier.Id);
				slotData.splice(0, slotData.length);
				var curItem:Object = curSoldier.EquipmentList;
				
				if (slotObjData[curSoldier.Id])
				{
					for (var h:int = 1; h < 9; h++)
					{
						if (slotObjData[curSoldier.Id][h])
						{
							var data:Object = new Object()
							data.slot = h;
							data.Id = slotObjData[curSoldier.Id][h].Id;
							data.QuartzType = slotObjData[curSoldier.Id][h].QuartzType;
							slotData.push(data);
						}
					}
				}
			}
			//trace("slotData.length== " + slotData.length);
			
			var s:String;
			var i:int = 0;
			dataQuartz.splice(0, dataQuartz.length);
			
			for (k = 0; k < InteractiveCtn.length; k++)
			{
				InteractiveCtn[k].ClearComponent();
				var obj:Object = new Object();
				dataQuartz.push(obj);
			}
			for (s in curItem)
			{
				for (k = 0; k < GetNumSlotEachType("Ctn_" + s); k++)
				{
					//trace("s== " + s + " |k== " + k + " |curItem[s][k]== " + curItem[s][k]);
					if (curItem[s][k])
					{
						for (var j:int = 0; j < slotData.length; j++ )
						{
							if (slotData[j].Id == curItem[s][k].Id && slotData[j].QuartzType == curItem[s][k].Type)
							{
								var indexArr:int = slotData[j].slot - 1;
								dataQuartz[indexArr] = curItem[s][k]
							}
						}
						i++;
					}
				}
			}
			dawItemSoldier();
		}
		
		private function dawItemSoldier():void
		{
			//trace("dawItemSoldier== " + dataQuartz.length);
			var index:int = 0;
			var ctn:Container;
			var tooltipFormat:TooltipFormat;
			for (var j:int = 0; j < dataQuartz.length; j++)
			{
				index++;
				
				ctn = this["ctnQuartz_" + index];
				ctn.IdObject = "Ctn_Quartz_" + index;
				var RequireLevel:int = ConfigJSON.getInstance().getItemInfo("SmashEgg_Slot")[index]["RequireLevel"];
				var userLevel:int = 0;
				if (curSoldier)
				{
					userLevel = curSoldier.Rank;
				}
				//trace("userLevel== " + userLevel + " |RequireLevel== " + RequireLevel);
				if (userLevel >= RequireLevel)
				{
					if (dataQuartz[j].Id)
					{
						var imageNen:Image  = ctn.AddImage("", "GuiShowQuartzUser_Bg_Item_" + dataQuartz[j].Type, 41, 46);
						var imag:Image = null;
						
						var imagName:String = dataQuartz[j].Type + dataQuartz[j].ItemId;
						var tF:TextFormat = new TextFormat();
						var imag1:Image = ctn.AddImage(dataQuartz[j].Id, imagName, 43, 51);
						
						var glow:GlowFilter = new GlowFilter(0x330000, 1, 4, 4, 10); 
						var labelNumber:TextField = ctn.AddLabel(Ultility.StandardNumber(dataQuartz[j].Level), -8, 1, 0xFFFF00, 0);
						labelNumber.autoSize = TextFieldAutoSize.CENTER
						labelNumber.filters = [glow];
						
						var GuiToolTip:GUILinhThachToolTip = new GUILinhThachToolTip(null, "");
						var globalParent:Point = ctn.img.localToGlobal(new Point(0, 0));
						GuiToolTip.Init(dataQuartz[j]);
						GuiToolTip.InitPos(ctn, "GuiTrungLinhThach_BgTipLinhThach", globalParent.x, globalParent.y, 0, -0, 0, 0, true, false);
						ctn.setGUITooltip(GuiToolTip);
						ctn.isQuartz = true;
					}
					else
					{
						ctn.isQuartz = false;
					}
				}
				else
				{
					var itemLook:Image = ctn.AddImage("", "GuiShowQuartzUser_lookItem", 43, 43);
					
					var numRequireLevel:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Slot")[j + 1].RequireLevel;
					var txtNumLevel:TextField = ctn.AddLabel("Cấp " + Ultility.StandardNumber(numRequireLevel), 20, 60, 0xffffff, 0);
					/*tooltipFormat = new TooltipFormat();
					tooltipFormat.text = "Cấp Ngư Thủ " + Ultility.StandardNumber(numRequireLevel) + " mới mở";
					ctn.setTooltip(tooltipFormat);*/
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_SHOW_EQUIMENT:
					Hide();
					GuiMgr.getInstance().guiSoliderInfo.Init(curSoldier);
					break;
				case BTN_BACK_SOLIDER:
					if (curSoldier)
					{
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
					addSolider(backSolider, true);
					break;
				case BTN_NEXT_SOLIDER:
					if (curSoldier)
					{
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
					addSolider(nextSolider, true);
					break;
			}
		}
		
		private function UpdateStart():void
		{
			var i:int;
			var s:String;
			var quartId:int;
			var quartType:String;
			var obj:Object = { "QWhite":1, "QGreen":2, "QYellow":3, "QPurple":4, "QVIP":5 };
			for (s in curSoldier.EquipmentList)
			{
				/*for (i = 0; i < curSoldier.EquipmentList[s].length; i++)
				{
					ChangeEquipment(curSoldier.EquipmentList[s][i]);
				}*/
				
				if (obj[s] != null &&  curSoldier.EquipmentList[s].length > 0 && obj[s] > quartId)
				{
					quartId = obj[s];
					quartType = s;
				}
			}
			
			if (ctnQuart != null)
			{
				ctnQuart.ClearComponent();
			}
			if (quartType != null)
			{
				var maxId:int;
				for (i = 0; i < curSoldier.EquipmentList[quartType].length; i++)
				{
					if (curSoldier.EquipmentList[quartType][i]["ItemId"] > maxId)
					{
						maxId = curSoldier.EquipmentList[quartType][i]["ItemId"];
					}
				}
				var numStar:int = ConfigJSON.getInstance().GetItemList("SmashEgg_Quartz")[quartType][maxId]["Star"];				
				if(ctnQuart == null)
				{
					ctnQuart = new Container(img, "", 245, 264);
					ctnQuart.LoadRes("");
				}
				ctnQuart.ClearComponent();
				for (i = 0; i < numStar; i++)
				{
					ctnQuart.AddImage("", "Ic" + quartType.substring(1, quartType.length) + "Star", (i - numStar / 2) * 17, -64);
					//trace(("Ic" + quartType.substring(1, quartType.length) + "Star") , ((i - numStar / 2) * 17));
				}
				img.addChild(ctnQuart.img);
			}
		}
		
		override public function OnHideGUI():void 
		{
			//trace("OnHideGUI");
		}
		
	}
}