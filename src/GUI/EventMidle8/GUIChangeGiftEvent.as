package GUI.EventMidle8 
{
	import Data.Config;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.Event8March.GUIChooseElementEvent;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIChangeGiftEvent extends BaseGUI 
	{
		private const CTN_MATERIAL:String = "CtnMaterial";
		private const CTN_VU_KHI:String = "CtnVuKhi";
		private const CTN_VU_KHI_9:String = "CtnVuKhi9";
		
		private const BTN_MATERIAL:String = "CtnMaterial";
		private const BTN_VU_KHI:String = "CtnVuKhi";
		private const BTN_VU_KHI_9:String = "CtnVuKhi9";
		
		private const BTN_CLOSE:String = "BtnThoat";
		private const BTN_GET_1:String = "BtnGet_1";
		private const BTN_GET_2:String = "BtnGet_2";
		private const BTN_GET_3:String = "BtnGet_3";
		
		private var vipMedalBox:Object;
		private var ctnMaterial:Container;
		private var ctnVKhi:Container;
		private var ctnVKhi9:Container;
		
		private var numMedal:int;
		
		private var txtAllMedal:TextField;
		
		public function GUIChangeGiftEvent(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIChangeGiftEvent";
		}
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("GUIChangeGiftEvent_GuiBg");
			SetPos(130, 90);
			var arr:Array = GameLogic.getInstance().user.StockThingsArr.VipMedal;
			if (arr.length <= 0) 
			{
				numMedal = 0;
			}
			else 
			{
				numMedal = arr[0].Num;
			}
			
			vipMedalBox = ConfigJSON.getInstance().GetItemList("VipMedalBox");
			OpenRoomOut();
		}
		override public function EndingRoomOut():void 
		{
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.size = 18;
			super.EndingRoomOut();
			
			txtAllMedal = AddLabel(numMedal.toString(), 280, 104, 0xff0000, 1, 0xFFFFFF);
			txtAllMedal.setTextFormat(txtFormat);
			txtAllMedal.defaultTextFormat = txtFormat;
			
			var tt:TooltipFormat = new TooltipFormat();
			// Container Đổi ngư thạch
			var objMat:Object = vipMedalBox["1"].Output["1"];
			ctnMaterial = AddContainer(CTN_MATERIAL, "GUIChangeGiftEvent_CtnMaterialBg", 71, 180, true, this);
			var imgMat:Image = ctnMaterial.AddImage("Image", objMat.ItemType + objMat.ItemId, ctnMaterial.img.width / 2, ctnMaterial.img.height / 2);
			imgMat.FitRect(100, 100, new Point(5, 5));
			ctnMaterial.AddLabel(String(vipMedalBox["1"].Input["1"].Num), 0, 130, 0xff0000, 1, 0xFFFF00).setTextFormat(txtFormat);
			AddButton(BTN_GET_1, "GUIChangeGiftEvent_BtnReceive", 100, 345, this);
			tt.text = Localization.getInstance().getString(objMat.ItemType + objMat.ItemId);
			ctnMaterial.setTooltip(tt);
			
			//Container đổi vũ khí VIP
			var objVKhi:Object = vipMedalBox["2"].Output["1"];
			ctnVKhi = AddContainer(CTN_VU_KHI, "GUIChangeGiftEvent_CtnVKhiBg", 227, 180, true, this);
			var imgVKhi:Image = ctnVKhi.AddImage("Image", "GUIAutomatic_ImgEquipment", 0, 0);
			imgVKhi.FitRect(100, 100, new Point(5, 5));
			ctnVKhi.AddLabel(String(vipMedalBox["2"].Input["1"].Num), 0, 130, 0xff0000, 1, 0xFFFFFF).setTextFormat(txtFormat);
			AddButton(BTN_GET_2, "GUIChangeGiftEvent_BtnReceive", 254, 345, this);
			tt = new TooltipFormat();
			tt.text = "Vũ khí Vô Song VIP\nĐược Chọn hệ";
			ctnVKhi.setTooltip(tt);
			
			//Container đổi ấn
			var objVKhi9:Object = vipMedalBox["3"].Output["1"];
			ctnVKhi9 = AddContainer(CTN_VU_KHI_9, "GUIChangeGiftEvent_CtnVKhiBg", 383, 180, true, this);
			var imgVKhi9:Image = ctnVKhi9.AddImage("Image", objVKhi9.ItemType + objVKhi9.Rank + "_Shop", 0, 0);
			imgVKhi9.FitRect(100, 100, new Point(5, 5));
			ctnVKhi9.AddLabel(String(vipMedalBox["3"].Input["1"].Num), 0, 130, 0xff0000, 1, 0xFFFFFF).setTextFormat(txtFormat);
			AddButton(BTN_GET_3, "GUIChangeGiftEvent_BtnReceive", 408, 345, this);
			tt = new TooltipFormat();
			tt.text = "Vô Song Ấn";
			ctnVKhi9.setTooltip(tt);
			
			AddButton(BTN_CLOSE, "BtnThoat", 539, 20, this);
			CheckStateButtonGet();
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
				break;
				case BTN_GET_1:
				case BTN_GET_2:
				case BTN_GET_3:
					var arr:Array = buttonID.split("_");
					if (arr[1] == 1 || arr[1] == 3)
					{
						Update(arr[1])
					}
					else
					{
						var newChooseElementEvent:GUIChooseElementEvent = new GUIChooseElementEvent(null, "");
						newChooseElementEvent.UseForChangeGiftHoaMuaXuan(arr[1]);
						newChooseElementEvent.Show(Constant.GUI_MIN_LAYER, 2);
					}
				break;
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonMove(event, buttonID);
			switch (buttonID) 
			{
				case CTN_VU_KHI_9:
					if(GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
						GuiMgr.getInstance().GuiEquipmentInfo.Hide();
					var seal:FishEquipment = new FishEquipment();
					seal.Color = FishEquipment.FISH_EQUIP_COLOR_PINK;
					seal.Type = "Seal";
					seal.Rank = 3;
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, seal, GUIEquipmentInfo.INFO_TYPE_SPECIFIC, null);
					break;
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonOut(event, buttonID);
			switch (buttonID) 
			{
				case CTN_VU_KHI_9:
					if(GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
						GuiMgr.getInstance().GuiEquipmentInfo.Hide();
					break;
			}
		}
		
		public function Update(id:int, element:int = 1):void 
		{
			var temp:int = 0;
			temp = vipMedalBox[id.toString()].Input["1"].Num;
			numMedal -= temp;
			//numMedal -= temp;
			txtAllMedal.text = numMedal.toString();
			CheckStateButtonGet();
			GameLogic.getInstance().user.UpdateStockThing("VipMedal", 1, -temp);
			Exchange.GetInstance().Send(new SendGetGiftEvent(id, element));
		}
		public function CheckStateButtonGet():void 
		{
			//if (numMedal >= int(vipMedalBox["3"].Input["1"].Num))
			if (numMedal >= int(999))
			{
				GetButton(BTN_GET_3).SetEnable();
			}
			else
			{
				GetButton(BTN_GET_3).SetDisable();
			}
			
			//if (numMedal >= int(vipMedalBox["2"].Input["1"].Num))
			if (numMedal >= int(299))
			{
				GetButton(BTN_GET_2).SetEnable();
			}
			else
			{
				GetButton(BTN_GET_2).SetDisable();
			}
			
			//if (numMedal >= int(vipMedalBox["1"].Input["1"].Num))
			if (numMedal >= int(19))
			{
				GetButton(BTN_GET_1).SetEnable();
			}
			else
			{
				GetButton(BTN_GET_1).SetDisable();
			}
		}
	}

}