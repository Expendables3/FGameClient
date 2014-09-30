package GUI.EventMagicPotions.GUISelectNumHerb 
{
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.TextBox;
	import GUI.EventMagicPotions.NetworkPacket.UseHerbPotion;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * GUI chọn số lượng herb sử dụng
	 * @author longpt
	 */
	public class GUISelectNumberHerb extends BaseGUI 
	{
		private const BTN_THOAT:String = "BtnThoat";
		private const BTN_USE:String = "BtnUse";
		private const BTN_NEXT:String = "BtnNext";
		private const BTN_BACK:String = "BtnBack";
		private const TXT_BOX:String = "TextBox";
		
		private var btnNext:Button;
		private var btnBack:Button;
		
		private var itemId:int;
		private var lakeId:int;
		private var fishId:int;
		private var numUse:int = 0;
		private var maxNum:int;
		
		private var txtBox:TextBox;
		private var txtFormatForTxtBox:TextFormat;
		
		public function GUISelectNumberHerb(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUISelectNumberHerb";
		}
		
		public override function InitGUI():void
		{
			LoadRes("GuiSelectNumberHerb_Theme");
			SetPos(170, 140);
			RefreshContent();
		}
		
		public function InitData(id:int, lakeId:int, fishId:int):void
		{
			this.itemId = id;
			this.lakeId = lakeId;
			this.fishId = fishId;
			
			this.maxNum = GameLogic.getInstance().user.GetStoreItemCount("HerbPotion", itemId);
			if (this.maxNum > 30)
			{
				this.maxNum = 30;
			}
			this.numUse = this.maxNum;
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		public function RefreshContent():void
		{
			AddButton(BTN_THOAT, "BtnThoat", 420, 20);
			AddButton(BTN_USE, "GuiSelectNumberHerb_BtnUse", 170, 210);
			
			var txtF:TextField;
			var tF:TextFormat;
			
			tF = new TextFormat();
			tF.size = 20;
			tF.color = 0x00ff00;
			txtF = AddLabel("Nhập số lượng sử dụng:", 100, 70, 0xffffff, 0, 0x000000);
			txtF.setTextFormat(tF);
			
			AddImage("", "GuiSelectNumberHerb_Cell_Tach", 200, 130, true, ALIGN_LEFT_TOP);
			
			btnNext = AddButton(BTN_NEXT, "GuiSelectNumberHerb_Btn_Pre", 256, 135);
			btnBack = AddButton(BTN_BACK, "GuiSelectNumberHerb_Btn_Next", 177, 135);
			
			txtBox = AddTextBox(TXT_BOX, maxNum + "", 202, 140, 46, 25, this);
			txtFormatForTxtBox = new TextFormat();
			txtFormatForTxtBox.size = 20;
			txtFormatForTxtBox.color = 0xffffff;
			txtFormatForTxtBox.bold = true;
			txtFormatForTxtBox.align = "right";
			txtBox.SetTextFormat(txtFormatForTxtBox);
			
			UpdateButtonNextBack();
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_THOAT:
					this.Hide();
					break;
				case BTN_NEXT:
					if (numUse >= maxNum)
					{
						numUse = maxNum;
					}
					else
					{
						numUse++;
						txtBox.SetText(numUse + "");
						txtBox.SetTextFormat(txtFormatForTxtBox);
					}
					UpdateButtonNextBack();
					break;
				case BTN_BACK:
					if (numUse <= 0)
					{
						numUse = 0;
					}
					else
					{
						numUse--;
						txtBox.SetText(numUse + "");
						txtBox.SetTextFormat(txtFormatForTxtBox);
					}
					UpdateButtonNextBack();
					break;
				case BTN_USE:
					// DO something here =))
					// Cmd
					var cmd:UseHerbPotion = new UseHerbPotion(itemId, lakeId, fishId, numUse);
					Exchange.GetInstance().Send(cmd);
					
					// UpdateStore
					GuiMgr.getInstance().GuiStore.UpdateStore("HerbPotion", itemId, -numUse);
					
					// Check MouseStatus
					if (GameLogic.getInstance().user.GetStoreItemCount("HerbPotion", itemId) == 0)
					{
						GameLogic.getInstance().BackToIdleGameState();
					}
					
					this.Hide();
					break;
				}
		}
		
		public override function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void 
		{
			var numTextBox:int = int(txtBox.GetText());
			if (event.keyCode == Keyboard.NUMPAD_0)
			{
				var str:String = txtBox.GetText();
				if (str.substr(0,1) == "0")
				{
					txtBox.SetText(str.substring(1, str.length));
				}
			}
			else if (event.keyCode == Keyboard.BACKSPACE)
			{
				if (numTextBox == 0)
				{
					numTextBox = 1;
					txtBox.SetText("1");
				}
				numUse = numTextBox;
				UpdateButtonNextBack();
				return;
			}
			
			if (numTextBox <= 0)
			{
				numUse = numTextBox = 1;
			}
			else if (numTextBox >= maxNum)
			{
				numUse = numTextBox = maxNum;
			}
			else
			{
				numUse = numTextBox;
				UpdateButtonNextBack();
			}
			txtBox.SetText(numTextBox + "");
			txtBox.SetTextFormat(txtFormatForTxtBox);
			
			UpdateButtonNextBack();
		}
		
		public function UpdateButtonNextBack():void
		{
			if (numUse >= maxNum)
			{
				btnBack.SetEnable();
				btnNext.SetDisable();
				if (numUse == 1)
				{
					btnBack.SetDisable();
				}
			}
			else if (numUse <= 1)
			{
				btnNext.SetEnable();
				btnBack.SetDisable();
			}
			else
			{
				btnNext.SetEnable();
				btnBack.SetEnable();
			}
		}
		
	}

}