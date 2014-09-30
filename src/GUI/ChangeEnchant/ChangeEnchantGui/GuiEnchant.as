package GUI.ChangeEnchant.ChangeEnchantGui 
{
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.EnchantEquipment.GUIEnchantEquipment;
	import GUI.GuiMgr;
	import NetworkPacket.PacketSend.CreateEquipment.SendGetIngradient;
	import NetworkPacket.PacketSend.SendLoadInventory;
	
	/**
	 * GUI cường hóa và chuyển cường hóa
	 * @author HiepNM2
	 */
	public class GuiEnchant extends BaseGUI 
	{
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_TABCHANGE:String = "idBtnTabchange";
		private const ID_BTN_TABENCHANT:String = "idBtnTabenchant";
		private var tabEnchant:GUIEnchantEquipment;			//Pointer
		//private var tabChange:GuiChangeEnchant;				//Pointer
		private var btnTabEnchant:Button;
		private var imgTabEnchant:Image;
		private var btnTabChange:Button;
		private var imgTabChange:Image;
		private var imgNew:Image;
		private var isGetIngradient:Boolean = false;
		
		public function GuiEnchant(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiEnchant";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				AddButton(ID_BTN_CLOSE, "BtnThoat", 706, 19);
				
				if (!isGetIngradient)
				{
					var pk:SendGetIngradient = new SendGetIngradient();
					Exchange.GetInstance().Send(pk);
					isGetIngradient = true;
				}
				tabEnchant = GuiMgr.getInstance().GuiEnchantEquipment;
				//tabChange = GuiMgr.getInstance().guiChangeEnchant;
				tabEnchant.Show();
				//tabChange.Hide();
				OpenRoomOut();
			}
			LoadRes("GuiEnchant_Theme");
		}
		
		private function initButtonTab():void 
		{
			imgTabEnchant = AddImage("", "GuiEnchant_ImgTabEnchant", 70, 67, true, ALIGN_LEFT_TOP);
			btnTabEnchant = AddButton(ID_BTN_TABENCHANT, "GuiEnchant_BtnTabEnchant", 70, 67);
			imgTabChange = AddImage("", "GuiEnchant_ImgTabChange", 188, 67, true, ALIGN_LEFT_TOP);
			btnTabChange = AddButton(ID_BTN_TABCHANGE, "GuiEnchant_BtnTabChange", 188, 67);
			btnTabEnchant.img.visible = false;
			btnTabChange.img.visible = true;
			imgNew = AddImage("", "IcMoi", 355, 80);
			//btnTabChange.SetDisable();
			//btnTabChange.setTooltipText("Sắp ra mắt");
		}
		
		override public function EndingRoomOut():void 
		{
			initButtonTab();
			//tabEnchant.EndingRoomOut();
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					if (tabEnchant.IsChanging) return;
					if (tabEnchant.IsEnchanting) return;
					if (tabEnchant.IsFlying) return;
					// Nếu GUI Chọn đồ còn mở thì sẽ cập nhật lại
					if (GuiMgr.getInstance().GuiChooseEquipment.IsVisible)
					{
						// Load lại kho để refresh trang bị
						var cmd:SendLoadInventory = new SendLoadInventory();
						Exchange.GetInstance().Send(cmd);
					}
					Hide();
				break;
				case ID_BTN_TABCHANGE:
					//tabChange.Show();
					if (tabEnchant.IsEnchanting || tabEnchant.IsChanging)
					{
						return;
					}
					tabEnchant.iTab = 1;
					
					//tabEnchant.hideAsTab();
					btnTabChange.img.visible = false;
					btnTabEnchant.img.visible = true;
				break;
				case ID_BTN_TABENCHANT:
					if (tabEnchant.IsEnchanting || tabEnchant.IsChanging)
					{
						return;
					}
					//tabChange.Hide();
					tabEnchant.iTab = 0;
					//tabEnchant.showAsTab();
					btnTabChange.img.visible = true;
					btnTabEnchant.img.visible = false;
				break;
			}
		}
		
		override public function Hide():void 
		{
			tabEnchant.Hide();
			//tabChange.Hide();
			super.Hide();
		}
	}

}




























