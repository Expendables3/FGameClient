package GUI.CreateEquipment 
{
	import Effect.EffectMgr;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.ListBox;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIChooseEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.QuestMgr;
	import Logic.TaskInfo;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.CreateEquipment.SendAutoSeparateEquip;
	import NetworkPacket.PacketSend.CreateEquipment.SendGetIngradient;
	import NetworkPacket.PacketSend.CreateEquipment.SendSeparateEquip;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUISeparateEquipment extends BaseGUI 
	{
		private var listIngradient:ListBox;
		public var listItemSeparate:ListBox;
		static public const BTN_CLOSE:String = "btnClose";
		static public const CTN_ITEM_SEPARATE:String = "ctnItemSeparate";
		static public const BTN_SEPARATE:String = "btnSeparate";
		static public const CTN_ITEM_INGRADIENT:String = "ctnItemMaterial";
		static public const BTN_GET:String = "btnGet";
		static public const BTN_BACK_INGRADIENT:String = "btnBackIngradient";
		static public const BTN_NEXT_INGRADIENT:String = "btnNextIngradient";
		static public const ICON_HELPER:String = "iconHelper";
		static public const BTN_TAB_MANUAL:String = "btnTabManual";
		static public const BTN_TAB_AUTOMATIC:String = "btnTabAutomatic";
		static public const COMBO_BOX_RANK:String = "comboBoxRank";
		static public const COMBO_BOX_QUALITY:String = "comboBoxQuality";
		static public const BTN_NEXT_AUTO:String = "btnNextAuto";
		static public const BTN_BACK_AUTO:String = "btnBackAuto";
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var btnTabManual:Button;
		private var btnTabAutomatic:Button;
		private var ctnAutomatic:Container;
		private var listAutomatic:ListBox;
		private var curTab:String = BTN_TAB_MANUAL;
		private var comboBoxRank:ComboBoxEx;
		private var comboBoxQuality:ComboBoxEx;
		private var rank:int;
		private var quality:int;
		private var sumaryObj:Object;
		private var ctnManual:Container;
		
		public function GUISeparateEquipment(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButton(BTN_CLOSE, "BtnThoat", 418 - 41, 19 - 44, this);
				
				AddImage("", "GuiSeparateEquipment_SelectedManualSeparate", 30, 30, true, ALIGN_LEFT_TOP);
				AddImage("", "GuiSeparateEquipment_SelectedAutoSeparate", 130, 30, true, ALIGN_LEFT_TOP);
				btnTabManual = AddButton(BTN_TAB_MANUAL, "GuiSeparateEquipment_BtnManualSeparate", 30, 30);
				btnTabAutomatic = AddButton(BTN_TAB_AUTOMATIC, "GuiSeparateEquipment_BtnAutoSeparate", 130, 30);
				
				SetPos(0, 50);
				//Tach tu dong
				ctnAutomatic = AddContainer("", "GuiSeparateEquipment_CtnAuto", 24, 62, true, this);
				comboBoxRank = new ComboBoxEx(ctnAutomatic.img, 137, 57, "Tất Cả", ["Tất Cả", "Lưỡng Cực", "Anh Hùng", "Vô Song"]);
				comboBoxRank.setEventHandler(this, COMBO_BOX_RANK);
				comboBoxQuality = new ComboBoxEx(ctnAutomatic.img, 137, 97, "Thường", ["Thường", "Đặc Biệt", "Quí Hiếm", "Thần"]);
				comboBoxQuality.setEventHandler(this, COMBO_BOX_QUALITY);
				listAutomatic = ctnAutomatic.AddListBox(ListBox.LIST_X, 2, 6, 5);
				listAutomatic.setPos(45, 150);
				var i:int;
				for (i = 0; i < 12; i++)
				{
					var itemEmpty:ItemInGradient = new ItemInGradient(listAutomatic.img);
					itemEmpty.SetScaleXY(0.6);
					listAutomatic.addItem(i.toString(), itemEmpty);
				}
				ctnAutomatic.AddButton(BTN_NEXT_AUTO, "GuiSeparateEquipment_Btn_Next", 316, 188, this);
				ctnAutomatic.AddButton(BTN_BACK_AUTO, "GuiSeparateEquipment_Btn_Previous", 16, 188, this);
				updateBtnNextBack();
				
				//Tach bang tay
				ctnManual = AddContainer("", "GuiSeparateEquipment_CtnManual", 24, 62, true, this);
				//Slot trang bi
				listItemSeparate = ctnManual.AddListBox(ListBox.LIST_X, 2, 3, 5, 20);
				listItemSeparate.setPos(42, 45);
				for (i = 0; i < 6; i++)
				{
					//AddContainer(, "CtnEquipment", (i % 3) * 80 + 110, int(i / 3) * 80 + 135);
					var itemSeparate:ItemSeparate = new ItemSeparate(this.img);
					listItemSeparate.addItem(CTN_ITEM_SEPARATE + i.toString(), itemSeparate, this);
				}
				
				//List nguyen lieu
				AddButton(BTN_SEPARATE, "GuiSeparateEquipment_Btn_Separate", 230 - 97, 350 - 27, this).SetEnable(false);
				AddButton(BTN_GET, "GuiSeparateEquipment_Btn_Get", 230 - 80, 350 - 27, this).SetVisible(false);
				listIngradient = AddListBox(ListBox.LIST_X, 1, 4);
				listIngradient.setPos(50, 402 - 8);
				AddButton(BTN_BACK_INGRADIENT, "GuiSeparateEquipment_Btn_Previous", 213 - 98 - 87 - 10, 495 + 35 - 106, this).SetEnable(false);
				AddButton(BTN_NEXT_INGRADIENT, "GuiSeparateEquipment_Btn_Next", 632 - 282 + 13, 528 - 106, this).SetEnable(false);
				WaitData.x = 200;
				WaitData.y = 445;
				img.addChild(WaitData);
				if (GameLogic.getInstance().user.ingradient != null)
				{
					updateListIngradient(GameLogic.getInstance().user.ingradient);
				}
				else
				{
					Exchange.GetInstance().Send(new SendGetIngradient());
				}
				
				showTab(curTab);
			}
			LoadRes("GuiSeparateEquipment_Theme");
		}
		
		private function updateBtnNextBack():void 
		{
			if (listAutomatic.getCurPage() == 0)
			{
				ctnAutomatic.GetButton(BTN_BACK_AUTO).SetVisible(false);
			}
			if (listAutomatic.getCurPage() >= listAutomatic.getNumPage() -1)
			{
				ctnAutomatic.GetButton(BTN_NEXT_AUTO).SetVisible(false);
			}
		}
		
		private function showTab(tabName:String):void
		{
			curTab = tabName;
			switch(tabName)
			{
				case BTN_TAB_MANUAL:
					ctnAutomatic.SetVisible(false);
					ctnManual.SetVisible(true);
					btnTabManual.SetFocus(true);
					btnTabAutomatic.SetFocus(false);
					GetButton(BTN_SEPARATE).SetEnable(false);
					break;
				case BTN_TAB_AUTOMATIC:
					ctnAutomatic.SetVisible(true);
					ctnManual.SetVisible(false);
					btnTabManual.SetFocus(false);
					btnTabAutomatic.SetFocus(true);
					GetButton(BTN_SEPARATE).SetEnable(true);
					break;
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_ITEM_SEPARATE) >= 0)
			{
				var itemSeparate:ItemSeparate = listItemSeparate.getItemById(buttonID) as ItemSeparate;
				if(itemSeparate.itemState == ItemSeparate.HAS_EQUIPMENT)
				{
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, itemSeparate.equipment, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
				}
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_ITEM_SEPARATE) >= 0)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}
		
		public function addIngradientData(data:Object):void
		{
			var ingredient:Object = GameLogic.getInstance().user.ingradient;
			for(var s:String in data)
			{
				if (s != "SoulRock")
				{
					if(ingredient[s] != null)
					{
						ingredient[s] += data[s];
					}
					else
					{
						ingredient[s] = int(data[s]);
					}
				}
				else
				{
					for (var t:String in data[s])
					{
						if (ingredient[s] == null)
						{
							ingredient[s] = new Object();
						}
						if (ingredient[s][t] == null)
						{
							ingredient[s][t] = data[s][t];
						}
						else
						{
							ingredient[s][t]  += data[s][t];
						}
					}
				}
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var itemSeparate:ItemSeparate;
			switch(buttonID)
			{
				case BTN_NEXT_AUTO:
					listAutomatic.showNextPage();
					updateBtnNextBack();
					break;
				case BTN_BACK_AUTO:
					listAutomatic.showPrePage();
					updateBtnNextBack();
					break;
				case BTN_TAB_AUTOMATIC:
				case BTN_TAB_MANUAL:
					//Dang tach
					if (!GetButton(BTN_CLOSE).enable)
					{
						var txtFormat:TextFormat = new TextFormat("arial", 12, 0xff0000);
						txtFormat.align = "center";
						EffectMgr.getInstance().textFly("Bạn không thể chuyển chế độ tách\nkhi hệ thống đang tách đồ!", new Point(240, 150), txtFormat);
						break;
					}
					if (curTab == BTN_TAB_MANUAL)
					{
						for each(itemSeparate in listItemSeparate.itemList)
						{
							if(itemSeparate.itemState == ItemSeparate.HAS_EQUIPMENT)
							{
								itemSeparate.removeEquipment();
							}
							else if(itemSeparate.itemState == ItemSeparate.SEPARATED)
							{
								addIngradientData(itemSeparate.result);
								itemSeparate.itemState = ItemSeparate.EMPTY;
								itemSeparate.ClearComponent();
							}
						}
					}
					else
					{
						if(sumaryObj != null)
						{
							addIngradientData(sumaryObj);
							sumaryObj = new Object();
							listAutomatic.removeAllItem();
							for (var i:int = 0; i < 12; i++)
							{
								var itemEmpty:ItemInGradient = new ItemInGradient(listAutomatic.img);
								itemEmpty.SetScaleXY(0.6);
								listAutomatic.addItem(i.toString(), itemEmpty);
							}
						}
					}
					updateListIngradient(GameLogic.getInstance().user.ingradient);
					showTab(buttonID);
					GetButton(BTN_GET).SetVisible(false);
					GetButton(BTN_SEPARATE).SetVisible(true);
					break;
				case BTN_NEXT_INGRADIENT:
					listIngradient.showNextPage();
					GetButton(BTN_BACK_INGRADIENT).SetEnable(true);
					if (listIngradient.curPage == listIngradient.getNumPage() -1)
					{
						GetButton(BTN_NEXT_INGRADIENT).SetEnable(false);
					}
					else
					{
						GetButton(BTN_NEXT_INGRADIENT).SetEnable(true);
					}
					break;
				case BTN_BACK_INGRADIENT:
					listIngradient.showPrePage();
					GetButton(BTN_NEXT_INGRADIENT).SetEnable(true);
					if (listIngradient.curPage == 0)
					{
						GetButton(BTN_BACK_INGRADIENT).SetEnable(false);
					}
					else
					{
						GetButton(BTN_BACK_INGRADIENT).SetEnable(true);
					}
					break;
				case BTN_GET:
					if (curTab == BTN_TAB_MANUAL)
					{
						for each(itemSeparate in listItemSeparate.itemList)
						{
							addIngradientData(itemSeparate.result);
							itemSeparate.itemState = ItemSeparate.EMPTY;
						}
					}
					else
					{
						addIngradientData(sumaryObj);
						sumaryObj = new Object();
					}
					Clear();
					InitGUI();
					showTab(curTab);
					break;
				case BTN_SEPARATE:
					//Đang khóa hoặc xin phá khóa
					var passwordState:String = GameLogic.getInstance().user.passwordState;
					if (passwordState == Constant.PW_STATE_IS_LOCK || passwordState == Constant.PW_STATE_IS_CRACKING || passwordState == Constant.PW_STATE_IS_BLOCKED)
					{
						GuiMgr.getInstance().guiPassword.showGUI();
						break;
					}
					GetButton(BTN_CLOSE).SetEnable(false);
					var guiChooseEquipment:GUIChooseEquipment = GuiMgr.getInstance().GuiChooseEquipment;
					guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_CLOSE).SetEnable(false);
					//guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_ENCHANT).SetEnable(false);
					//guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_CREATE).SetEnable(false);
					guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_EXTEND).SetEnable(false);
					
					if (curTab == BTN_TAB_MANUAL)
					{
						var arrayEquip:Array = new Array();
						for each(itemSeparate in listItemSeparate.itemList)
						{
							if (itemSeparate.itemState == ItemSeparate.HAS_EQUIPMENT)
							{
								var obj:Object = new Object();
								obj["type"] = itemSeparate.equipment.Type;
								obj["id"] = itemSeparate.equipment.Id;
								arrayEquip.push(obj);
								itemSeparate.showEffSeparate();
								
								//Xóa đồ tách trong kho
								GameLogic.getInstance().user.UpdateEquipmentToStore(itemSeparate.equipment, false);
							}
							else
							{
								arrayEquip.push(null);
							}
							
							itemSeparate.itemState = ItemSeparate.SEPARATING;
						}
						GetButton(BTN_SEPARATE).SetVisible(false);
						
						var sendSeparateEquip:SendSeparateEquip = new SendSeparateEquip(arrayEquip);
						Exchange.GetInstance().Send(sendSeparateEquip);
					}
					else
					{
						rank = 0;
						quality = 1;
						var confirmMessage:String = "Bạn có muốn tách ";
						switch(comboBoxRank.selectedItem)
						{
							case "Tất Cả":
								rank = 0;
								confirmMessage += "tất cả trang bị ";
								break;
							case "Lưỡng Cực":
								rank = 1;
								confirmMessage += "tất cả trang bị Lưỡng Cực ";
								break;
							case "Anh Hùng":
								rank = 2;
								confirmMessage += "tất cả trang bị Anh Hùng ";
								break;
							case "Vô Song":
								rank = 3;
								confirmMessage += "tất cả trang bị Vô Song ";
								break;
						}
						confirmMessage += comboBoxQuality.selectedItem + "?";
						switch(comboBoxQuality.selectedItem)
						{
							case "Thường":
								quality = 1;
								break;
							case "Đặc Biệt":
								quality = 2;
								break;
							case "Quí Hiếm":
								quality = 3;
								break;
							case "Thần":
								quality = 4;
								break;
						}
						trace(rank, quality);
						if (quality == 3 || quality == 4)
						{
							GuiMgr.getInstance().guiConfirm.showGUI(confirmMessage, function f():void
							{
								sumaryObj = new Object();
								WaitData.visible = true;
								GetButton(BTN_SEPARATE).SetVisible(false);
								
								Exchange.GetInstance().Send(new SendAutoSeparateEquip(quality, rank));
							});
						}
						else
						{
							sumaryObj = new Object();
							WaitData.visible = true;
							GetButton(BTN_SEPARATE).SetVisible(false);
							
							Exchange.GetInstance().Send(new SendAutoSeparateEquip(quality, rank));
						}
					}
					
					if (GetImage(ICON_HELPER) != null)
					{
						RemoveImage(GetImage(ICON_HELPER));
					}
					// QuestPowerTinh
					var task:TaskInfo = QuestMgr.getInstance().QuestPowerTinh[QuestMgr.QUEST_PT_INGREDIENT].TaskList[0] as TaskInfo;
					if (!task.Status)
					{
						task.Num += 1;
					}
					QuestMgr.getInstance().UpdatePointReceive();
					break;
				case BTN_CLOSE:
					Hide();
					break;
				default:
					if (buttonID.search(CTN_ITEM_SEPARATE) != -1)
					{
						ItemSeparate(listItemSeparate.getItemById(buttonID)).removeEquipment();
						GetButton(BTN_SEPARATE).SetEnable(false);
						for each(itemSeparate in listItemSeparate.itemList)
						{
							if (itemSeparate.itemState == ItemSeparate.HAS_EQUIPMENT)
							{
								GetButton(BTN_SEPARATE).SetEnable(true);
								break;
							}
						}
					}
			}
		}
		
		override public function OnHideGUI():void 
		{
			GuiMgr.getInstance().GuiChooseEquipment.stateSeparate = false;
			for each(var itemSeparate:ItemSeparate in listItemSeparate.itemList)
			{
				if(itemSeparate.itemState == ItemSeparate.HAS_EQUIPMENT)
				{
					itemSeparate.removeEquipment();
				}
				else if(itemSeparate.itemState == ItemSeparate.SEPARATED)
				{
					addIngradientData(itemSeparate.result);
				}
			}
			if(sumaryObj != null)
			{
				addIngradientData(sumaryObj);
				sumaryObj = new Object();
			}
			super.OnHideGUI();
		}
		
		/**
		 * Hàm add trang bị vào gui tách đồ
		 * @param	equipment
		 * @return add được hay không
		 */
		public function addEquipment(equipment:FishEquipment):Boolean 
		{
			//Chặn tách đồ vip
			if (equipment.Color >= 5)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không thể tách đồ VIP!");
				return false;
			}
			
			//Chặn tách ấn
			if (equipment.Type == "Seal")
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không thể tách ấn!");
				return false;
			}
			
			//Chặn tách mặt nạ
			if (equipment.Type == "Mask")
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không thể tách mặt nạ!");
				return false;
			}
			
			if (curTab == BTN_TAB_AUTOMATIC)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Đang ở chế độ tách tự động!");
				return false;
			}
			
			var itemSeparate:ItemSeparate;
			var isSeparating:Boolean = false;
			for each(itemSeparate in listItemSeparate.itemList)
			{
				//trace(itemSeparate.itemState);
				if (itemSeparate.itemState == ItemSeparate.EMPTY)
				{
					itemSeparate.setEquipment(equipment);
					GetButton(BTN_SEPARATE).SetEnable(true);
					
					var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
					if (curTutorial.search("SeparateEquipment") >= 0 && GetImage(ICON_HELPER) == null)
					{
						AddImage(ICON_HELPER, "IcHelper", 50 + 166, 50 + 258);
					}
					return true;
				}
				if (itemSeparate.itemState == ItemSeparate.SEPARATING)
				{
					isSeparating = true;
				}
			}
			if (isSeparating)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Đang tách đồ!");
			}
			else
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Kho tách trang bị đã đầy!");
			}
			return false;
		}
		
		
		/**
		 * Update kho nguyên liệu tách được
		 * @param	data
		 */
		public function updateListIngradient(data:Object):void
		{
			if(img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			listIngradient.removeAllItem();
			
			var itemIngradient:ItemIngradientRequire;
			for(var s:String in data)
			{
				if (s != "SoulRock")
				{
					if (data[s] != 0)
					{
						itemIngradient = new ItemIngradientRequire(listIngradient.img);
						itemIngradient.initIngradient(s);
						itemIngradient.num = data[s];
						listIngradient.addItem(CTN_ITEM_INGRADIENT + s, itemIngradient);
					}
				}
				else
				{
					for (var t:String in data[s])
					{
						if (data[s][t] != 0)
						{
							itemIngradient = new ItemIngradientRequire(listIngradient.img);
							itemIngradient.initIngradient(s, int(t));
							itemIngradient.num = data[s][t];
							listIngradient.addItem(CTN_ITEM_INGRADIENT + s +"_" + t, itemIngradient);
						}
					}
				}
			}
			
			if (listIngradient.getNumPage() > 1)
			{
				GetButton(BTN_NEXT_INGRADIENT).SetEnable(true);
			}
			else
			{
				GetButton(BTN_NEXT_INGRADIENT).SetEnable(false);
			}
		}
		
		/**
		 * Hiển thị kết quả sau khi tách
		 * @param	result
		 */
		public function showResult(result:Array):void 
		{
			//GetButton(BTN_CLOSE).SetEnable(true);
			//GetButton(BTN_GET).SetVisible(true);
			for (var i:int = 0; i < result.length; i++)
			{
				var itemSeparate:ItemSeparate =  listItemSeparate.itemList[i] as ItemSeparate;
				itemSeparate.separateEquip(result[i]);
			}
		}
		
		public function showAutoResult(result:Object):void
		{
			WaitData.visible = false;
			GetButton(BTN_CLOSE).SetEnable(true);
			GetButton(BTN_GET).SetVisible(true);
			var guiChooseEquipment:GUIChooseEquipment = GuiMgr.getInstance().GuiChooseEquipment;
			guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_CLOSE).SetEnable(true);
			//guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_ENCHANT).SetEnable(true);
			//guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_CREATE).SetEnable(true);
			guiChooseEquipment.GetButton(GUIChooseEquipment.BTN_EXTEND).SetEnable(true);
			// Remove from ItemList
			//trace("equip length", guiChooseEquipment.ItemList.length);
			for (var i:int = 0; i < guiChooseEquipment.ItemList.length; i++)
			{
				if(guiChooseEquipment.ItemList[i]["Type"] != "Seal" && guiChooseEquipment.ItemList[i]["Type"] != "Mask" && (int(guiChooseEquipment.ItemList[i]["Color"]) == quality && (rank == 0 || int(guiChooseEquipment.ItemList[i]["Rank"])%10 == rank)))
				{
					GameLogic.getInstance().user.UpdateEquipmentToStore(guiChooseEquipment.ItemList[i], false);
					guiChooseEquipment.ItemList.splice(i, 1);
					i--;
				}
				
			}
			guiChooseEquipment.ShowTab(guiChooseEquipment.curTab);
			//trace("asdfasdfa", quality, rank);
			
			trace(result);
			//Tổng hợp kết quả thành 1 obj
			sumaryObj = new Object();
			var h:String;
			var s:String;
			var t:String;
			for (h in result)
			{
				for(s in result[h])
				{
					if (s != "SoulRock")
					{
						if (sumaryObj[s] == null)
						{
							sumaryObj[s] = 0;
						}
						sumaryObj[s] += result[h][s];
					}
					else
					{
						for (t in result[h][s])
						{
							if (sumaryObj[s] == null)
							{
								sumaryObj[s] = new Object();
							}
							if (sumaryObj[s][t] == null)
							{
								sumaryObj[s][t] = 0;
							}
							sumaryObj[s][t] += result[h][s][t];
						}
					}
				}
			}
			
			//Show item tach duoc
			listAutomatic.removeAllItem();
			var itemIngradient:ItemInGradient;
			for(s in sumaryObj)
			{
				if (s != "SoulRock")
				{
					if (sumaryObj[s] != 0)
					{
						itemIngradient = new ItemInGradient(listAutomatic.img);
						itemIngradient.initIngradient(Ultility.StandardNumber(sumaryObj[s]), s, 0, 18);
						itemIngradient.SetScaleXY(0.6);
						listAutomatic.addItem(CTN_ITEM_INGRADIENT + s, itemIngradient);
					}
				}
				else
				{
					for (t in sumaryObj[s])
					{
						if (sumaryObj[s][t] != 0)
						{
							itemIngradient = new ItemInGradient(listAutomatic.img);
							itemIngradient.initIngradient(Ultility.StandardNumber(sumaryObj[s][t]), s, int(t), 18);
							itemIngradient.SetScaleXY(0.6);
							listAutomatic.addItem(CTN_ITEM_INGRADIENT + s +"_" + t, itemIngradient);
						}
					}
				}
			}
			if (listAutomatic.itemList.length == 0)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Trong kho không có loại trang bị bạn muốn tách. Hãy thử loại trang bị khác xem sao!");
				OnButtonClick(null, BTN_GET);
			}
			else if (listAutomatic.itemList.length < 12)
			{
				for (var j:int = 0; j < 12 - listAutomatic.itemList.length; i++)
				{
					itemIngradient = new ItemInGradient(listAutomatic.img);
					itemIngradient.SetScaleXY(0.6);
					listAutomatic.addItem(j.toString(), itemIngradient);
				}
			}
			
			updateBtnNextBack();
		}
	}

}