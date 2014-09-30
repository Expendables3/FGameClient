package GUI.EnchantEquipment 
{
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * Container chứa item bảo vệ trang bị khi cường hóa
	 * @author longpt
	 */
	public class GodCharmSlot extends Container 
	{
		public static const BTN_BUY:String = "Btn_Buy";
		public static const CHECK_BOX:String = "Check_Box";
		public static const UNCHECK_BOX:String = "Uncheck_Box";
		public static const CHECK_BUTTON:String = "Check_Button";
		
		private var isChecked:Boolean = false;
		private var uncheckButton:Button;
		private var checkButton:Button;
		private var godId:int;
		
		public function GodCharmSlot(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GodCharmSlot";
		}
		
		public function refreshInfo(curEquip:FishEquipment):void
		{
			ClearComponent();
			
			if (curEquip == null)
			{
				return;
			}
			
			GetGodCharmId(curEquip);
			
			var tt:TooltipFormat = new TooltipFormat();
			var str:String = Localization.getInstance().getString("GodCharm" + godId);
			tt.text = str;
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xff0000;
			textFormat.size = 16;
			textFormat.bold = true;
			tt.setTextFormat(textFormat, 0, str.split("\n")[0].length);
			setTooltip(tt);
			
			var num:int = GameLogic.getInstance().user.GetStoreItemCount("GodCharm", godId);
			//ClearComponent();
			
			var image:Image = AddImage("", "GodCharm" + godId, 0, 0, true, ALIGN_LEFT_TOP, false, function():void { 
				this.FitRect(55, 55, new Point(0, 0)); } );
			image.FitRect(55, 55, new Point(0, 0));
			
			var lbl:TextField = AddLabel(num + "", 2, 2, 0xffffff, 0, 0x000000);
			lbl.setTextFormat(new TextFormat(null, 14));
			
			if (num > 0)
			{
				isChecked = true;
				checkButton = AddButton(CHECK_BOX, "GuiEnchant_CheckBox", 3, 63);
				checkButton.img.scaleX = checkButton.img.scaleY = 1.2;
				uncheckButton = AddButton(UNCHECK_BOX, "GuiEnchant_UncheckBox", checkButton.img.x, checkButton.img.y);
				uncheckButton.img.scaleX = uncheckButton.img.scaleY = 1.2;
				uncheckButton.SetVisible(false);
				AddLabel("Dùng", 22, 61, 0xffffff, 0, 0x000000);
			}
			else
			{
				AddButton(BTN_BUY, "GuiEnchant_Buy", 3, 50);
				AddLabel("Mua", 8, 50, 0xffffff, 0);
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void

		{
			if (GuiMgr.getInstance().GuiEnchantEquipment.IsEffecting())
			{
				return;
			}
			
			switch (buttonID)
			{
				case BTN_BUY:
					GuiMgr.getInstance().GuiBuyGodCharm.SetId(godId);
					GuiMgr.getInstance().GuiBuyGodCharm.Show(Constant.GUI_MIN_LAYER, 5);
					break;
				case CHECK_BOX:
				case UNCHECK_BOX:
					isChecked = !isChecked;
					uncheckButton.SetVisible(!uncheckButton.img.visible);
					checkButton.SetVisible(!checkButton.img.visible);
					
					GuiMgr.getInstance().GuiEnchantEquipment.ShowInfo();
					break;
			}
		}
		
		public function GetCheckBoxStatus():Boolean
		{
			var num:int = GameLogic.getInstance().user.GetStoreItemCount("GodCharm", godId);
			if (num <= 0)
			{
				return false;
			}
			return isChecked;
		}
		
		private function GetGodCharmId(curEquip:FishEquipment):int
		{
			godId = curEquip.Color;
			if (curEquip.Color > 5)
			{
				godId = 5;
			}
			return godId;
		}
	}

}