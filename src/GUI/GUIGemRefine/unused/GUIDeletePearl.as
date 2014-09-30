package GUI.GUIGemRefine.unused 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import GUI.GUIGemRefine.unused.CTNPearl;
	import GUI.GUIGemRefine.unused.Pearl;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author Sonbt
	 */
	public class GUIDeletePearl extends BaseGUI 
	{
	
		private const BTN_THOAT:String = "btnThoat";
		private const BTN_DELETE:String = "btnDelete";
		private const CTN_CELL:String = "ctnCell";
		private const BTN_PRE:String = "btnPre";
		private const BTN_NEXT:String = "btnNext";
		private const TEXT_BOX:String = "textBox";
		
		
		public var idPearl:int = -1;
		public var ctn:Container;
		
		private var textBox:TextBox;
		//private var guiHuyDanNumber:GUIHuyDanNumber = new GUIHuyDanNumber(null, "");
		
		public function GUIDeletePearl(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButton(BTN_THOAT, "BtnThoat", 419, 17, this);
				AddButton(BTN_DELETE, "GuiDeletePearl_Btn_HuyNew_TuLuyenNgoc", 180, 210, this);
				ctn = AddContainer(CTN_CELL, "GuiDeletePearl_IMG_Cell_Tach_TuLuyenNgoc", 200, 160, true, this); 
				ctn.AddButton(BTN_NEXT, "GuiDeletePearl_Btn_Pre_TuLuyenNgoc", 53, 4, this).SetDisable();
				ctn.AddButton(BTN_PRE, "GuiDeletePearl_Btn_Next_TuLuyenNgoc", -21, 4, this);
				
				ShowDisableScreen(0.5);
				SetPos ( 180, 150);
				var p:Pearl = GuiMgr.getInstance().GuiPearlRefine.pearlList[idPearl];
				textBox = ctn.AddTextBox(TEXT_BOX, p.number.toString(),0,7, 50, 41, this);
				SetFormatTextBox();
			
				var f:TextFormat = new TextFormat();
				f.size = 20;
				f.color = 0xF00000;
				f.size = 14;
				f.color = 0x000000;
				AddLabel(Ultility.GetNamePearl(p.element, p.level), 175, 65).setTextFormat(f);
				// add icon
				var ctn1:Container = AddContainer("CELL","GuiDeletePearl_Img_Cell_TuLuyenNgoc",205,87); 
				var ctnp:CTNPearl = new CTNPearl(idPearl, ctn1.img,  Ultility.GetNameImgPearl(p.element, p.level));
				var ts:Container = ctn1.AddContainer2(ctnp, 0, 0, this); 
				ctnp.FitRect(40, 45, new Point(0, 0));
				f.color = 0xF00000;
				AddLabel("Chọn số lượng muốn hủy :", 180, 135).setTextFormat(f);
			}
			
			LoadRes("GuiDeletePearl_Theme");
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
			//textBox.textField.wordWrap = true;

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
					}
					SetFormatTextBox();
				
				break;
			}
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
				case BTN_DELETE:
					if (number)
					{
						if (number <= p.number)
						{	
							GuiMgr.getInstance().GuiPearlRefine.DeletePearl(idPearl,number);
							Hide();
							HideDisableScreen();
							//guiHuyDanNumber.ShowGui(idPearl, number);	
						}
						Hide();
						HideDisableScreen();
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
						SetFormatTextBox();

					}	
				break;
			}
		}
	}

}