package GUI.GUIGemRefine.unused 
{
	import com.bit101.components.Text;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.TextBox;
	import GUI.GUIGemRefine.unused.Pearl;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.Balloon;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author SieuSon
	 */
	public class GUIRecoverPearl extends BaseGUI 
	{
		
		private const BTN_THOAT:String = "btnThoat";
		private const BTN_RECOVER:String = "btnRecover";
		private const CTN_CELL:String = "ctnCell";
		private const BTN_PRE:String = "btnPre";
		private const BTN_NEXT:String = "btnNext";
		private const TEXT_BOX:String = "textBox";
		
		
		public var idPearl:int = -1;
		public var ctn:Container;
		public var lbPrice:TextField;
		
		private var textBox:TextBox;
		
		public function GUIRecoverPearl(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButton(BTN_THOAT, "BtnThoat", 419, 17, this);
				AddButton(BTN_RECOVER, "GuiRecoverPearl_Btn_KhoiPhucNgay_TuLuyenNgoc", 160, 210, this);
				ctn=AddContainer(CTN_CELL, "GuiRecoverPearl_IMG_Cell_Tach_TuLuyenNgoc", 213, 131,true,this); 
				ctn.AddButton(BTN_NEXT, "GuiRecoverPearl_Btn_Pre_TuLuyenNgoc", 53, 4, this).SetDisable();
				ctn.AddButton(BTN_PRE, "GuiRecoverPearl_Btn_Next_TuLuyenNgoc", -21, 4, this);
				ShowDisableScreen(0.5);
				SetPos ( 180, 150);
				var l:Array=GuiMgr.getInstance().GuiPearlRefine.pearlList;
				var p:Pearl = GuiMgr.getInstance().GuiPearlRefine.pearlList[idPearl];
				textBox = ctn.AddTextBox(TEXT_BOX, p.number.toString(),0,7, 50, 41, this);
				SetFormatTextBox();
			
				
			
				var ctn1:Container;
				var number:int = 0;
				if (p.zmoneyRecover > 0)
				{
					ctn1 = AddContainer("", "IcZingXu", 350, 160);
					number = p.zmoneyRecover;
				}
				else
				{
					if (p.moneyRecover > 0)
					{
						ctn1 = AddContainer("", "IcGold", 350, 160);
						number = p.moneyRecover;
						
					}
				}
				if (ctn1)
				{
					number = number * p.number;
					lbPrice = ctn1.AddLabel(Ultility.StandardNumber(number), -40, -25, 0x000000);
				}
				var f:TextFormat = new TextFormat();
				f.size = 20;
				f.color = 0x000000;
				lbPrice.setTextFormat(f);
			//	lb.setTextFormat(f);
				f.size = 18;
				AddLabel(Ultility.GetNamePearl(p.element, p.level), 50, 140).setTextFormat(f);
			}
			
			LoadRes("GuiRecoverPearl_Theme");
		}
		
		private function SetFormatTextBox():void 
		{
			var f:TextFormat = new TextFormat();
			f.size = 20;
			f.color = 0x000000;
			f.align = TextFormatAlign.CENTER;
			textBox.textField.maxChars = 6;
			textBox.textField.autoSize = TextFieldAutoSize.CENTER;
			textBox.textField.setTextFormat(f);
		}
		
		public function ShowGui(id:int):void 
		{
			idPearl = id;
			Show();
		}
		
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
				var bt1:Button;
				var bt2:Button;
				bt1 = ctn.GetButton(BTN_NEXT);
				bt1.SetEnable();
				bt2 = ctn.GetButton(BTN_PRE);
				bt2.SetEnable();
			switch (txtID) 
			{
				case TEXT_BOX:
					var number:int = parseInt(textBox.GetText());
					var p:Pearl = GuiMgr.getInstance().GuiPearlRefine.pearlList[idPearl];
					var f:TextFormat = new TextFormat();
				
					f.size = 20;
					f.color = 0x000000;
					if (number)
					{
						if (number > p.number)
						{
							number = p.number;
						}
						if (number <= 0)
						{
							number = 0;
						}
						textBox.SetText(number.toString());
						lbPrice.text = Ultility.StandardNumber(GetPrice(number));
						lbPrice.setTextFormat(f);
				
					
						if (number >= p.number)
						{
							bt1.SetDisable();
						}
						if (number <= 0)
						{
							bt2.SetDisable();
						}
						
					}
					else 
					{
					
						if (number <= 0)
						{
							bt2.SetDisable();
						}
						lbPrice.text = GetPrice(0).toString();
						lbPrice.setTextFormat(f);
					}
					SetFormatTextBox();
				
				break;
			}
		}
		
		private function GetPrice(number:int):int
		{
			var p:Pearl = GuiMgr.getInstance().GuiPearlRefine.pearlList[idPearl];
			if (p.zmoneyRecover > 0)
			{
				return number * p.zmoneyRecover;
				
			}
			else 
			{
				if(p.moneyRecover > 0)
				{
					return number * p.moneyRecover;	
				}
			}
			return 0;
			
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var number:int = parseInt(textBox.GetText());
			var f:TextFormat = new TextFormat();
			f.size = 20;
			f.color = 0x000000;
			var p:Pearl = GuiMgr.getInstance().GuiPearlRefine.pearlList[idPearl];
			switch (buttonID) 
			{
				case BTN_THOAT :
					HideDisableScreen();
					Hide();
				break;
				case BTN_RECOVER:
					if (number)
					{
						if (number <= p.number)
						{
							CheckG();
						}
					}
					else
					{
						Hide();
						HideDisableScreen();
					}
					
				break;
				case BTN_PRE:
					if (number > 0)
					{
						number--;
						textBox.SetText(number.toString());
						if (number<p.number) 
						{
							ctn.GetButton(BTN_NEXT).SetEnable();
						}
						if (number <= 0)
						{
							ctn.GetButton(BTN_PRE).SetDisable();
						}
						lbPrice.text = Ultility.StandardNumber(GetPrice(number));
						lbPrice.setTextFormat(f);
					
						SetFormatTextBox();
					}
				break;
				case BTN_NEXT:
					if (number < p.number)
					{
						number++
						textBox.SetText(number.toString());
						if (number>=p.number) 
						{
							ctn.GetButton(BTN_NEXT).SetDisable();
						}
						if (number >= 0)
						{
							ctn.GetButton(BTN_PRE).SetEnable();
						}
						lbPrice.text = Ultility.StandardNumber(GetPrice(number));
						lbPrice.setTextFormat(f);
						SetFormatTextBox();

					}	
				break;
			}
		}
		
		private function CheckG():void 
		{
			var p:Pearl = GuiMgr.getInstance().GuiPearlRefine.pearlList[idPearl];
			var number:int = parseInt(textBox.GetText());
			if (number > 0)
			{
				var xu:Number ;
				var xuRequire:int; 
				var type:int = 0;
				if (p.zmoneyRecover > 0)
				{
					xu= GameLogic.getInstance().user.GetZMoney();
					xuRequire = p.zmoneyRecover*(parseInt(textBox.GetText()));
					type = 1;
				}
				else 
				{
					if (p.moneyRecover > 0)
					{
						xu= GameLogic.getInstance().user.GetMoney();
						xuRequire = p.moneyRecover*(parseInt(textBox.GetText()));
						type = 2;
					}
				}
				if (type) 
				{
					if (type == 1)
					{
						// Nếu đủ xu thì cho chọn lại
						if (xu >= xuRequire)
						{
							GameLogic.getInstance().user.pearlMgr.SendRecoverPearl(p.element, p.timeLife,number,idPearl, p.level);
							GameLogic.getInstance().user.UpdateUserZMoney( -xuRequire);
							Hide();
							HideDisableScreen();
						}
						// Không đủ thì bắt nạp xu
						else
						{
							GuiMgr.getInstance().GuiNapG.Init();
						}
					}
					else
					{
						if (type == 2)
						{
								// nếu đủ tiền
							if (xu >= xuRequire)
							{
								GameLogic.getInstance().user.pearlMgr.SendRecoverPearl(p.element, p.timeLife, number,idPearl, p.level);
								GameLogic.getInstance().user.UpdateUserMoney( -xuRequire);
								Hide();
								HideDisableScreen();
							}
							else
							{
								GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn không có đủ vàng. ",310,215, GUIMessageBox.NPC_MERMAID_NORMAL);
							}
						}
						else
						{
							Hide();
							HideDisableScreen();
						}
					}
				}
			}
		}
	}
}