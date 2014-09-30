package Event.EventIceCream 
{
	import adobe.utils.CustomActions;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import particleSys.myFish.IceCreamEmit;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIHarvestIceCream extends BaseGUI 
	{
		public const BTN_NEXT:String = "BtnNext";
		public const BTN_BACK:String = "BtnBack";
		public const BTN_GET_GIFT:String = "BtnGetGift";
		public const ELEMENT_GIFT:String = "ElementGift_";
		
		public var data:Object;
		public var numIceCream:int;
		public var SlotId:int;
		public var ListGift:ListBox;
		public var isMyMachine:Boolean;
		
		public var arrNumGiftBackup:Array = [];
		public var arrObjGiftBackup:Array = [];
		public var arrNameGiftBackup:Array = [];
		public var arrToolTipGiftBackup:Array = [];
		
		public var arrNumGift:Array = [];
		public var arrObjGift:Array = [];
		public var arrNameGift:Array = [];
		public var arrToolTipGift:Array = [];
		
		public var arrNameFriendTheft:Array = [];
		public var arrNumFriendTheft:Array = [];
		
		public function GUIHarvestIceCream(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIHarvestIceCream";
		}
		public function Init(_data:Object, _SlotId:int, _isMyMachine:Boolean = true):void 
		{
			if (IsVisible)	Hide();
			if (GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit)
			{
				GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit.destroy();
				GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit = null;
			}
			data = _data;
			SlotId = _SlotId;
			isMyMachine = _isMyMachine;
			numIceCream = data.IceCreamNum;
			var istr:String;
			var jstr:String;
			var j:int = 0;
			var kstr:String;
			
			arrNameFriendTheft.splice(0, arrNameFriendTheft.length);
			arrNumFriendTheft.splice(0, arrNumFriendTheft.length);
			var arrFriend:Array = GameLogic.getInstance().user.FriendArr;
			
			for (istr in data.TheftList) 
			{
				arrNumFriendTheft.push(data.TheftList[istr]);
				for (j = 0; j < arrFriend.length; j++) 
				{
					var objFriend:Object = arrFriend[j];
					if (int(objFriend.ID) == int(istr))
					{
						var strNameTheft:String = (objFriend.NickName as String).substr(0, 12);
						if ((objFriend.NickName as String).length > 12)	strNameTheft = strNameTheft + "...";
						arrNameFriendTheft.push(strNameTheft);
						break;
					}
				}
			}
			
			arrNumGift.splice(0, arrNumGift.length);
			arrObjGift.splice(0, arrObjGift.length);
			arrNameGift.splice(0, arrNameGift.length);
			arrToolTipGift.splice(0, arrToolTipGift.length);
			
			var item:Object = new Object();
			var strName:String = "";
			var strToolTip:String = "";
			var numGift:int = 0;
			
			for (istr in data.GiftList) 
			{
				trace("istr = ", istr);
				if(istr == "Normal")
				{
					for (j = 0; j < (data.GiftList[istr] as Array).length; j++ ) 
					{
						item = data.GiftList[istr][j];
						if(item.Num)
						{
							numGift = item.Num;
						}
						else
						{
							numGift = 0;
						}
						var isAddArr:Boolean = true;
						switch (item.ItemType) 
						{
							case "Exp":
								strName = "IcExp";
								strToolTip = "Kinh nghiệm";
								break;
							case "Material":
							case "EnergyItem":
							case "RankPointBottle":
								strName = item.ItemType + item.ItemId;
								if (item.ItemId >= 100)
								{
									strName = item.ItemType + (item.ItemId % 100) + "S";
								}
								strToolTip = Localization.getInstance().getString(item.ItemType + item.ItemId);
								GameLogic.getInstance().user.UpdateStockThing(item.ItemType, item.ItemId, numGift);
								break;
							case "PowerTinh":
							case "SixColorTinh":
								strName = item.ItemType;
								strToolTip = Localization.getInstance().getString(item.ItemType);
								GameLogic.getInstance().user.updateIngradient(item.ItemType, numGift);
								break;
							case "Gem":
								strName = item.ItemType + "_" + item.Element + "_" + item.ItemId;
								strToolTip = Localization.getInstance().getString(String(item.ItemType + item.Element));
								strToolTip = strToolTip.replace("@Type@", Localization.getInstance().getString("GemType" + item.Element));
								strToolTip = strToolTip.replace("@Rank@", "cấp " + item.ItemId);
								var config:Object = ConfigJSON.getInstance().GetItemList("Gem");
								var value:int = config[String(item.ItemId)][String(item.Element)];
								strToolTip = strToolTip.replace("@value@", String(value));
								strToolTip = strToolTip.replace("@day@", String(item.Day));
								break;
							default:
								isAddArr = false;
								break;
						}
						if(isAddArr)
						{
							arrNumGift.push(numGift);
							arrNameGift.push(strName);
							arrToolTipGift.push(strToolTip);
							arrObjGift.push(item);
						}
					}
					
				}
				else if(istr == "Special")
				{
					for (jstr in data.GiftList[istr]) 
					{
						item = data.GiftList[istr][jstr];
						strName = item.Type + item.Rank + "_Shop";
						strToolTip = "";
						numGift = 1;
						arrNumGift.push(numGift);
						arrNameGift.push(strName);
						arrToolTipGift.push(strToolTip);
						arrObjGift.push(item);
						GameLogic.getInstance().user.GenerateNextID();
					}
				}
			}
			for (var l:int = 0; l < arrNameGift.length; l++) 
			{
				arrNameGiftBackup.push(arrNameGift[l]);
				arrNumGiftBackup.push(arrNumGift[l]);
				arrObjGiftBackup.push(arrObjGift[l]);
				arrToolTipGiftBackup.push(arrToolTipGift[l]);	
			}
			
			// thực hiện việc gộp tên và số lượng
			var _arrNameGift:Array = [];
			var _arrObjGift:Array = [];
			var _arrNumGift:Array = [];
			var _arrToolTipGift:Array = [];
			var i:int = 0;
			var k:int = 0;
			for (i = 0; i < arrNameGift.length; i++) 
			{
				if((arrNameGift[i] as String).search("_Shop") < 0)
				{
					var isExistInArr:Boolean = false;
					for (k = 0; k < _arrNameGift.length; k++) 
					{
						if (_arrNameGift[k] == arrNameGift[i])
						{
							_arrNumGift[k] = _arrNumGift[k] + arrNumGift[i];
							isExistInArr = true;
							break;
						}
					}
					if(!isExistInArr)
					{
						_arrNameGift.push(arrNameGift[i]);
						_arrNumGift.push(arrNumGift[i]);
						_arrObjGift.push(arrObjGift[i]);
						_arrToolTipGift.push(arrToolTipGift[i]);
					}
				}
				else 
				{
					_arrNameGift.push(arrNameGift[i]);
					_arrNumGift.push(arrNumGift[i]);
					_arrObjGift.push(arrObjGift[i]);
					_arrToolTipGift.push(arrToolTipGift[i]);
				}
			}
			
			// Cập nhật lại các mảng dữ liệu
			arrNameGift.splice(0, arrNameGift.length);
			arrNumGift.splice(0, arrNumGift.length);
			arrObjGift.splice(0, arrObjGift.length);
			arrToolTipGift.splice(0, arrToolTipGift.length);
			for (i = 0; i < _arrNameGift.length; i++) 
			{
				arrNameGift.push(_arrNameGift[i]);
				arrNumGift.push(_arrNumGift[i]);
				arrObjGift.push(_arrObjGift[i]);
				arrToolTipGift.push(_arrToolTipGift[i]);
			}
			
			Show(Constant.GUI_MIN_LAYER, 3);// Gift từ game
		}
		override public function OnHideGUI():void 
		{
			if (GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit == null)
			{
				GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit = new IceCreamEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));
			}
			var id:int;
			var type:String;
			for (var i:int = 0; i < arrNameGift.length; i++) 
			{
				var item:String = arrNameGift[i];
				if (item == "IcExp")
				{
					GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + arrNumGift[i]);
				}
				if (item.search("Gem") >= 0)
				{
					var arrGem:Array = item.split("_");
					GameLogic.getInstance().user.UpdateStockThing(arrGem[0] + "$" + arrGem[1] + "$" + arrGem[2], 7, arrNumGift[i]);
				}
			}
			var dataIceCream:Object = GuiMgr.getInstance().GuiMainEventIceCream.DataIceCream;
			var ctn:Container;
			var guiM:GUIMainEventIceCream = GuiMgr.getInstance().GuiMainEventIceCream;
			if(!GameLogic.getInstance().user.IsViewer())
			{
				dataIceCream[SlotId.toString()] = new Array();
				
				// Hiển thị
				ctn = guiM.GetContainer(guiM.CTN_SLOT_ICE_CREAM	+ (SlotId - 1));
				if(ctn != null)
				{
					var txtTime:TextField = ctn.LabelArr[0];
					var indexText:int = guiM.arrTextTimeNeed.indexOf(txtTime);
					if(indexText >= 0)
					{
						ctn.LabelArr.splice(0, ctn.LabelArr.length);
						guiM.arrTextTimeNeed.splice(indexText, 1);
						txtTime.parent.removeChild(txtTime);
					}
				
					var imgContents:Image = ctn.GetImage(guiM.IMG_CONTENT_ICE_CREAM);
					if (imgContents != null)
					{
						ctn.ImageArr.splice(ctn.ImageArr.indexOf(imgContents), 1);
						imgContents.img.parent.removeChild(imgContents.img);
						imgContents.Destructor();
					}
				}
			}
			else
			{
				dataIceCream[SlotId.toString()].IceCreamNum += numIceCream;
				dataIceCream[SlotId.toString()].TheftList[String(GameLogic.getInstance().user.Id)] = numIceCream;
				ctn = guiM.GetContainer(guiM.CTN_SLOT_ICE_CREAM + (SlotId - 1));
				if(ctn != null)
				{
					if(ctn.GetImage(guiM.IMG_CONTENT_ICE_CREAM).img != null)
					{
						(ctn.GetImage(guiM.IMG_CONTENT_ICE_CREAM).img as MovieClip).gotoAndStop(5);
					}
				}
			}
		}
		
		public function InitTheftList():void 
		{
			var strBase:String = "@User đã ăn trộm @Value chiếc kem";
			var strShow:String = "";
			for (var i:int = 0; i < arrNameFriendTheft.length; i++) 
			{
				strShow = strBase.replace("@User", arrNameFriendTheft[i]);
				strShow = strShow.replace("@Value", arrNumFriendTheft[i]);
				var txtFieldNameTheft:TextField = AddLabel(strShow, 440, 220 + i * 20, 0xFFFFFF, 0, 0x000000);
				var txtF:TextFormat = new TextFormat();
				txtF.color = 0x009900;
				txtFieldNameTheft.setTextFormat(txtF, 0, (arrNameFriendTheft[i] as String).length);
			}
		}
		
		public function InitListGift():void 
		{
			for (var i:int = 0; i < arrNameGift.length; i++) 
			{
				var container:Container = new Container(ListGift, "EventIceCream_ImgSlotGift");
				//if (arrObjGift[i])
				
				// Nếu là đồ đặc biệt, quý thì cho cái nền khác		
				if((arrNameGift[i] as String).search("_Shop") >= 0)
				{
					if (arrObjGift[i].Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
					{
						container.LoadRes(FishEquipment.GetBackgroundName(arrObjGift[i].Color));
					}
					else
					{
						container.LoadRes("CtnEquipmentInfo");
					}
				}
				var strName:String = arrNameGift[i];
				var imageContent:Image;
				imageContent = container.AddImage("ImgContent", strName, 0, 0, true, ALIGN_CENTER_CENTER, false);
				
				imageContent.FitRect(40, 40, new Point(15, 5));
				var txtFormat:TextFormat = new TextFormat();
				txtFormat.bold = true;
				txtFormat.color = 0xFFFF00;
				txtFormat.size = 16;
				var txtBox:TextField = container.AddLabel("x" + Ultility.StandardNumber(arrNumGift[i]), -15, 54, 0xFFFF00, 1, 0x26709C);
				txtBox.setTextFormat(txtFormat);
				
				var tt:TooltipFormat = new TooltipFormat();
				tt.text = arrToolTipGift[i];
				if(tt.text != "")
				{
					container.setTooltip(tt);
				}
				
				ListGift.addItem(ELEMENT_GIFT + i.toString(), container, this)
			}
			UpdateButtonNextBack();
		} 
		private function UpdateButtonNextBack():void 
		{
			if (ListGift == null)	return;
			if (ListGift.getNumPage() <= 1)
			{
				GetButton(BTN_NEXT).SetVisible(false);
				GetButton(BTN_BACK).SetVisible(false);
			}
			else
			{
				GetButton(BTN_NEXT).SetVisible(true);
				GetButton(BTN_BACK).SetVisible(true);
				if (ListGift.getCurPage() == 0)
				{
					GetButton(BTN_NEXT).SetEnable();
					GetButton(BTN_BACK).SetDisable();
				}
				else if (ListGift.getCurPage() == (ListGift.getNumPage() - 1))
				{
					GetButton(BTN_NEXT).SetDisable();
					GetButton(BTN_BACK).SetEnable();
				}
				else
				{
					GetButton(BTN_BACK).SetEnable();
					GetButton(BTN_NEXT).SetEnable();
				}
			}
			
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void 
			{
				SetPos(40, 10);
				OpenRoomOut();
			}
			if(isMyMachine)
			{
				LoadRes("EventIceCream_ImgBgGuiHarvestIceCream");
			}
			else
			{
				LoadRes("EventIceCream_ImgBgGuiTheftIceCream");
			}
		}
		override public function EndingRoomOut():void 
		{
			var objIceCream:Object = GuiMgr.getInstance().GuiMainEventIceCream.DataIceCream[SlotId.toString()];
			var idIceCream:int = objIceCream.ItemId;
			(AddImage("", "EventIceCream_Item" + idIceCream, 380, 230, true, ALIGN_CENTER_CENTER).img as MovieClip).gotoAndStop(4);
			AddLabel("x" + numIceCream, 360, 230, 0x00AA00, 1, 0x000000).setTextFormat(new TextFormat("Arial", 18));
			AddButton(BTN_GET_GIFT,"EventIceCream_BtnGetGift", 310, 540, this);
			ListGift = AddListBox(ListBox.LIST_X, 2, 6, 10, 10);
			ListGift.setPos(105, 315);
			AddButton(BTN_BACK, "EventIceCream_Btn_Next", 60, 420, this);
			AddButton(BTN_NEXT, "EventIceCream_Btn_Pre", 665, 420, this);
			InitListGift();
			InitTheftList();
			//GuiMgr.getInstance().GuiMainEventIceCream.DataIceCream[SlotId.toString()] = new Array();
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_GET_GIFT:
					Hide();
				break;
				case BTN_BACK:
					ListGift.showPrePage();
					UpdateButtonNextBack()
				break;	
				case BTN_NEXT:
					ListGift.showNextPage();
					UpdateButtonNextBack();
				break;	
			}
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if(buttonID.search(ELEMENT_GIFT) >= 0)
			{	
				var index:int = buttonID.split("_")[1];
				var strName:String = arrNameGift[index];
				var item:Object = arrObjGift[index];
				if (item.Type && item.Rank && ((item.Type + item.Rank + "_Shop") == strName))
				{
					var equip:FishEquipment = new FishEquipment();
					equip.SetInfo(item);
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
				}
			}
		}
	}

}