package GUI 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.EventMagicPotions.NetworkPacket.SendExchangeHerbMedal;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	
	/**
	 * GUI đổi quà sau event
	 * @author longpt
	 */
	public class GUIGetGiftAfterEvent extends BaseGUI 
	{
		private static const BTN_THOAT:String = "BtnThoat";
		private static const BTN_EXCHANGE_MATERIAL:String = "BtnExchangeMaterial";
		private static const BTN_EXCHANGE_RARE:String = "BtnExchangeRare";
		private static const BTN_EXCHANGE_DIVINE:String = "BtnExchangeDivine";
		
		private var cfg:Object;
		private var sealObj:Object;
		
		public function GUIGetGiftAfterEvent(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGetGiftAfterEvent";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(120, 60);				
				RefreshContent();
			}
			LoadRes("GuiGetGiftAfterEvent_Theme");
		}
		
		public function RefreshContent():void
		{
			ClearComponent();
			AddButton(BTN_THOAT, "BtnThoat", 540, 20);
			
			cfg = ConfigJSON.getInstance().GetItemList("MagicPotion_ExchangeJadeSeal");
			sealObj = new Object();
			
			var ctn:Container;
			var imag:Image;
			var tt:TooltipFormat;
			var txtF:TextFormat;
			
			// Quà là ngư thạch cấp 11
			ctn = AddContainer("Ctn_0", "GuiGetGiftAfterEvent_Ctn", 44, 175, true, this);
			imag = ctn.AddImage("", "Material11", 42, 40, true);
			imag.SetScaleXY(1.6);
			AddLabel("Ngư thạch cấp 11", 24, 150, 0xffffff, 0, 0x000000).setTextFormat(new TextFormat(null, 15));
			// Tooltip
			var seal:FishEquipment = new FishEquipment();
			seal.Color = FishEquipment.FISH_EQUIP_COLOR_PINK;
			seal.Type = "Seal";
			seal.Rank = 1;
			sealObj[ctn.IdObject] = seal;
			// Nút nhận quà
			AddButton(BTN_EXCHANGE_MATERIAL, "GuiGetGiftAfterEvent_Btn", 44, 300).img.scaleX = 0.8;
			imag = AddImage("", "HerbMedal1", 164, 320);
			imag.SetScaleXY(0.9);
			imag.img.mouseEnabled = false;
			txtF = new TextFormat();
			txtF.size = 25;
			AddLabel("19", 44, 300, 0xffffff, 1, 0x000000).setTextFormat(txtF);
			
			// Quà là vũ khí VIP cấp 3
			ctn = AddContainer("Ctn_1", "GuiGetGiftAfterEvent_Ctn", 229, 175, true, this);
			imag = ctn.AddImage("", "EquipmentChest5_EquipmentChest", 42, 40, true, ALIGN_CENTER_CENTER, false, function():void{FishSoldier.EquipmentEffect(this.img, FishEquipment.FISH_EQUIP_COLOR_VIP);});
			imag.SetScaleXY(1.4);
			AddLabel("Vũ khí VIP - Cấp 3", 209, 150, 0xffffff, 0, 0x000000).setTextFormat(new TextFormat(null, 15));
			// Tooltip
			seal = new FishEquipment();
			seal.Color = FishEquipment.FISH_EQUIP_COLOR_VIP;
			seal.Type = "Weapon";
			seal.Rank = 3;
			sealObj[ctn.IdObject] = seal;
			// Nút nhận quà
			AddButton(BTN_EXCHANGE_RARE, "GuiGetGiftAfterEvent_Btn", 229, 300).img.scaleX = 0.8;
			imag = AddImage("", "HerbMedal1", 349, 320);
			imag.SetScaleXY(0.9);
			imag.img.mouseEnabled = false;
			AddLabel("299", 229, 300, 0xffffff, 1, 0x000000).setTextFormat(txtF);
			
			// Quà là Ấn thần cấp 3
			ctn = AddContainer("Ctn_2", "GuiGetGiftAfterEvent_Ctn", 414, 175, true, this);
			imag = ctn.AddImage("", "Seal3_Shop", 42, 40, true, ALIGN_CENTER_CENTER, false, function():void{FishSoldier.EquipmentEffect(this.img, FishEquipment.FISH_EQUIP_COLOR_PINK);});
			imag.SetScaleXY(1.6);
			AddLabel("Vô song ấn - Thần", 394, 150, 0xffffff, 0, 0x000000).setTextFormat(new TextFormat(null, 15));
			// Tooltip
			seal = new FishEquipment();
			seal.Color = FishEquipment.FISH_EQUIP_COLOR_PINK;
			seal.Type = "Seal";
			seal.Rank = 3;
			sealObj[ctn.IdObject] = seal;
			// Nút nhận quà
			AddButton(BTN_EXCHANGE_DIVINE, "GuiGetGiftAfterEvent_Btn", 414, 300).img.scaleX = 0.8;
			imag = AddImage("", "HerbMedal1", 534, 320);
			imag.SetScaleXY(0.9);
			imag.img.mouseEnabled = false;
			AddLabel("999", 414, 300, 0xffffff, 1, 0x000000).setTextFormat(txtF);
			
			// Số lượng huy chương mình có
			txtF = new TextFormat();
			txtF.size = 25;
			var numMedal:int = GameLogic.getInstance().user.GetStoreItemCount("HerbMedal", 1);
			AddLabel(numMedal + "", 305, 96, 0xffffff, 0, 0x000000).setTextFormat(txtF);
			
			ctn = AddContainer("", "HerbMedal1", 367, 92);
			tt = new TooltipFormat();
			tt.text = "Huy Chương Thần Thánh";
			ctn.setTooltip(tt);
			ctn.SetScaleXY(0.8);
			
			if (numMedal < 19)
			{
				GetButton(BTN_EXCHANGE_MATERIAL).SetDisable();
			}
			if (numMedal < 299)
			{
				//GetButton(BTN_EXCHANGE_RARE).SetDisable();
			}
			if (numMedal < 999)
			{
				GetButton(BTN_EXCHANGE_DIVINE).SetDisable();
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_THOAT:
					this.Hide();
					break;
				case BTN_EXCHANGE_MATERIAL:
					break;
				case BTN_EXCHANGE_RARE:
					GuiMgr.getInstance().GuiChooseElementEventMidle8.showGUI(function f(element:int):void
						{
							var cmd1:SendExchangeHerbMedal = new SendExchangeHerbMedal(1);
							Exchange.GetInstance().Send(cmd1);
							EffectMgr.setEffBounceDown("Nhận thưởng thành công", "Seal1_Shop", 320, 280);
							GuiMgr.getInstance().GuiStore.UpdateStore("HerbMedal", 1, -cfg["2"].Require);
							if (GuiMgr.getInstance().GuiStore.IsVisible)
							{
								GuiMgr.getInstance().GuiStore.Hide();
							}
							GameLogic.getInstance().user.GenerateNextID();
							RefreshContent();
							
							// Feed
							GuiMgr.getInstance().GuiFeedWall.ShowFeed("EventMagicPotionSeal");
						});
					break;
				case BTN_EXCHANGE_DIVINE:
					var cmd2:SendExchangeHerbMedal = new SendExchangeHerbMedal(2);
					Exchange.GetInstance().Send(cmd2);
					EffectMgr.setEffBounceDown("Nhận thưởng thành công", "Seal3_Shop", 320, 280);
					GuiMgr.getInstance().GuiStore.UpdateStore("HerbMedal", 1, -cfg["3"].Require);
					if (GuiMgr.getInstance().GuiStore.IsVisible)
					{
						GuiMgr.getInstance().GuiStore.Hide();
					}
					GameLogic.getInstance().user.GenerateNextID();
					RefreshContent();
					
					// Feed
					GuiMgr.getInstance().GuiFeedWall.ShowFeed("EventMagicPotionSeal");
					break;
			}
		}
		
		public function SendGetWeapon():void 
		{
			var cmd1:SendExchangeHerbMedal = new SendExchangeHerbMedal(1);
			Exchange.GetInstance().Send(cmd1);
			EffectMgr.setEffBounceDown("Nhận thưởng thành công", "Seal1_Shop", 320, 280);
			GuiMgr.getInstance().GuiStore.UpdateStore("HerbMedal", 1, -cfg["2"].Require);
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.Hide();
			}
			GameLogic.getInstance().user.GenerateNextID();
			RefreshContent();
			
			// Feed
			GuiMgr.getInstance().GuiFeedWall.ShowFeed("EventMagicPotionSeal");
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (buttonID.search("Ctn") >= 0 && int(buttonID.split("_")[1]) > 0)
			{
				if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
				{
					GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				}
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			if (buttonID.search("Ctn") >= 0 && int(buttonID.split("_")[1]) > 1)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, sealObj[buttonID], GUIEquipmentInfo.INFO_TYPE_SPECIFIC, null);
			}
		}
	}

}