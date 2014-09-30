package GUI.EventMidle8 
{
	import adobe.utils.CustomActions;
	import Data.ConfigJSON;
	import Data.LoadingBar;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendUpdateG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIAutomaticGame extends BaseGUI 
	{
		private var objGiftBase:Object;
		private var objGiftTotal:Object;
		private var objPriceAuto:Object;
		private var priceFastScan:int;
		private var priceDeepScan:int;
		private var idChoose:int;
		
		private const BTN_CLOSE:String = "BtnThoat";
		private const BTN_GET_GIFT_BASE:String = "BtnGetGiftBase";
		private const BTN_GET_GIFT_TOTAL:String = "BtnGetGiftAll";
		
		public function GUIAutomaticGame(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIAutomaticGame";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("GUIAutomaticGame_Background");
			SetPos(65, 170);
			OpenRoomOut();
		}
		
		override public function EndingRoomOut():void 
		{
			initListGiftBase();
			initListGiftTotal();
			objPriceAuto = ConfigJSON.getInstance().GetItemList("Param")["AutoMap"];
			priceFastScan = objPriceAuto["2"];
			priceDeepScan = objPriceAuto["1"];
			
			AddButton(BTN_CLOSE, "BtnThoat", 520, 15, this);
			AddButton(BTN_GET_GIFT_BASE, "GUIGameEventMidle8_BtnBuyByG", 120, 375 - 62, this);
			AddLabel(priceFastScan.toString(), 90, 375 - 62, 0x00FF00, 1, 0x000000);
			AddButton(BTN_GET_GIFT_TOTAL, "GUIGameEventMidle8_BtnBuyByG", 375, 375 - 62, this);
			AddLabel(priceDeepScan.toString(), 345, 375 - 62, 0x00FF00, 1, 0x000000);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			//super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
				break;
				case BTN_GET_GIFT_BASE:
					if(GameLogic.getInstance().user.GetZMoney() >= priceFastScan)
					{
						GetButton(BTN_GET_GIFT_TOTAL).SetDisable();
						GetButton(BTN_GET_GIFT_BASE).SetDisable();
						idChoose = 2;
						if (GuiMgr.getInstance().GuiGameTrungThu.arrNameGift.length > 0)
						{
							GuiMgr.getInstance().GuiMsg_Game.Show(Constant.GUI_MIN_LAYER, 1);
						}
						else
						{
							StartSendPacket();
						}
					}
					else
					{
						GuiMgr.getInstance().GuiNapG.Init();
					}
				break;
				case BTN_GET_GIFT_TOTAL:
					if (GameLogic.getInstance().user.GetZMoney() >= priceDeepScan)
					{
						GetButton(BTN_GET_GIFT_TOTAL).SetDisable();
						GetButton(BTN_GET_GIFT_BASE).SetDisable();
						idChoose = 1;
						if (GuiMgr.getInstance().GuiGameTrungThu.arrNameGift.length > 0)
						{
							GuiMgr.getInstance().GuiMsg_Game.Show(Constant.GUI_MIN_LAYER, 1);
						}
						else
						{
							StartSendPacket();
						}
					}
					else
					{
						GuiMgr.getInstance().GuiNapG.Init();
					}
				break;
			}
		}
		
		public function StartSendPacket():void 
		{
			GuiMgr.getInstance().GuiGameTrungThu.ReNewMap(false);
			Exchange.GetInstance().Send(new SendStartAutomatic(idChoose));
			if (idChoose == 1)
			{
				GameLogic.getInstance().user.UpdateUserZMoney( -priceDeepScan);
			}
			else
			{
				GameLogic.getInstance().user.UpdateUserZMoney( -priceFastScan);
			}
		}
		
		private function initListGiftBase():void
		{
			objGiftBase = ConfigJSON.getInstance().getItemInfo("AutoMap", 2);
			var count:int = 0;
			for (var i:String in objGiftBase) 
			{
				//for (var j:String in objGiftBase[i]) 
				{
					var item:Object = objGiftBase[i]//[j];
					Draw(count, item);
					count++;
				}
			}
		}
		
		private function initListGiftTotal():void 
		{
			objGiftTotal = ConfigJSON.getInstance().getItemInfo("AutoMap", 1);
			var count:int = 0;
			for (var i:String in objGiftTotal) 
			{
				//for (var j:String in objGiftTotal[i]) 
				{
					var item:Object = objGiftTotal[i]//[j];
					Draw(count, item, false);
					count++;
					if (count >= 12)	break;
				}
			}
		}
		
		private function Draw(IdPos:int, obj:Object, isBaseGift:Boolean = true):void 
		{
			if (!obj.hasOwnProperty("Num")) return;
			var constX:Number = 30;
			var constY:Number = 31;
			
			var posStartX:Number;
			var posStartY:Number = 107;
			
			var min:Number = getMinValueInArray(obj.Num);
			var max:Number = getMaxValueInArray(obj.Num);
			var strName:String = getNameGift(obj);

			if (isBaseGift)
			{
				posStartX = 26;
			}
			else
			{
				posStartX = 280;
			}
			var deltaY:Number = 65;
			var deltaX:Number = 62;
			
			var distanceX:Number = (int(IdPos % 4)) * deltaX;
			var distanceY:Number = (int(IdPos / 4)) * deltaY;
			
			var posX:Number = posStartX + distanceX;
			var posY:Number = posStartY + distanceY;
			
			var imgBg:Image;
			var imgContent:Image;
			var imgRankEquip:Image;
			var ctn:Container = AddContainer("", "GUIGameEventMidle8_ImgFrameFriend", posX, posY, true, this);
			var tt:TooltipFormat = new TooltipFormat();
			// Add anh hien thi
			if(obj.ItemType == "Equipment" || obj.ItemType == "AllChest")
			{
				switch (obj.Color) 
				{
					case FishEquipment.FISH_EQUIP_COLOR_GREEN:
						tt.text = "Đồ Đặc biệt cấp " + obj.Rank;
						imgBg = ctn.AddImage("imgBg", "CtnEquipmentSpecial", 0, 0, true, ALIGN_LEFT_TOP);
					break;
					case FishEquipment.FISH_EQUIP_COLOR_GOLD:
						tt.text = "Đồ Quí cấp " + obj.Rank;
						imgBg = ctn.AddImage("imgBg", "CtnEquipmentRare", 0, 0, true, ALIGN_LEFT_TOP);
					break;
					case FishEquipment.FISH_EQUIP_COLOR_PINK:
						tt.text = "Đồ Thần cấp " + obj.Rank;
						imgBg = ctn.AddImage("imgBg", "CtnEquipmentDivine", 0, 0, true, ALIGN_LEFT_TOP);
					break;
					case FishEquipment.FISH_EQUIP_COLOR_VIP:
						tt.text = "Đồ VIP cấp " + obj.Rank;
						imgBg = ctn.AddImage("imgBg", "CtnEquipmentVip", 0, 0, true, ALIGN_LEFT_TOP);
					break;
				}
				imgContent = ctn.AddImage("imgContent", strName, 0, 0, true, ALIGN_LEFT_TOP);
				imgRankEquip = ctn.AddImage("", "ImgLaMa" + obj.Rank, 47, 36, true, ALIGN_LEFT_TOP);
			}
			else
			{
				if (obj.ItemType == "Money" || obj.ItemType == "Exp" || obj.ItemType == "VipMedal" || obj.ItemType == "VipTag")
				{
					tt.text = Localization.getInstance().getString(obj.ItemType);
				}
				else
				{
					tt.text = Localization.getInstance().getString(obj.ItemType + obj.ItemId);
				}
				imgContent = ctn.AddImage("imgContent", strName, 0, 0, true, ALIGN_LEFT_TOP);
			}
			if(imgBg)	imgBg.FitRect(60, 62, new Point(0, 0));
			if(imgContent)	imgContent.FitRect(40, 40, new Point(10, 10));
			
			
			// label số lượng
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.bold = true;
			txtFormat.color = 0xFFFF00;
			txtFormat.size = 12;
			var strNum:String = "";
			if (int(obj.Rate) < 100)	strNum = "0~" + min.toString();
			else if (min == max)	strNum = min.toString();
			else if((min % 1000000 == 0) && (max % 1000000 == 0))
			{
				strNum = (min / 1000000) + "~" + (max / 1000000) + "triệu";
			}
			else if((min % 1000 == 0) && (max % 1000 == 0))
			{
				strNum = (min / 1000) + "~" + (max / 1000) + "k";
			}
			else
			{
				strNum = min + "~" + max;
			}
			var txtBox:TextField = ctn.AddLabel(strNum, - 20, 45, 0xFFFF00, 1, 0x26709C);
			txtBox.setTextFormat(txtFormat);
			txtBox.defaultTextFormat = txtFormat;
			ctn.setTooltip(tt);
		}
		
		private function getNameGift(obj:Object):String
		{
			var strName:String = "";
			switch (obj.ItemType) 
			{
				case "Material":
					if (obj.ItemId > 100)
					{
						strName = obj.ItemType + (obj.ItemId % 100) + "S";
					}
					else
					{
						strName = obj.ItemType + obj.ItemId;
					}
				break;
				case "Equipment":
				case "AllChest":
					strName = "EquipmentChest" + obj.Color + "_EquipmentChest";
				break;
				case "Money":
					strName = "IcGold";
				break;
				case "Exp":
					strName = "IcExp";
				break;
				case "VipMedal":
					strName = "GUIAutomatic_VipMedal";
				break;
				case "VipTag":
					strName = "VipTag1";
				break;
				default:
					strName = obj.ItemType + obj.ItemId;
				break;
			}
			return strName;
		}
		
		private function getMaxValueInArray(arr:*):Number
		{
			var maxValue:Number = Number.MIN_VALUE;
			if(arr is Array)
			{
				for (var i:int = 0; i < arr.length; i++) 
				{
					if (maxValue < arr[i])	
					{
						maxValue = arr[i];
					}
				}
			}
			else
			{
				return arr;
			}
			return maxValue;
		}
		
		private function getMinValueInArray(arr:*):Number
		{
			var minValue:Number = Number.MAX_VALUE;
			if(arr is Array)
			{
				for (var i:int = 0; i < arr.length; i++) 
				{
					if (minValue > arr[i])	
					{
						minValue = arr[i];
					}
				}
			}
			else
			{
				return arr;
			}
			return minValue;
		}
	}

}