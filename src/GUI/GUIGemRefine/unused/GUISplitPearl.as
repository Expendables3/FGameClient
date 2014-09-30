package GUI.GUIGemRefine.unused 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.TextBox;
	import Logic.Pearl;
	import org.papervision3d.lights.PointLight3D;
	
	/**
	 * ...
	 * @author SieuSon
	 */
	public class GUISplitPearl extends BaseGUI 
	{
		
		private const BTN_CLOSE:String = "btnClose";
		private const BTN_SPLIT:String = "btnSplit";
		private const BTN_PRE:String = "btnPre";
		private const BTN_NEXT:String = "btnNext";
		private const BTN_DRAG:String = "btnDrag";
		
		private const TEXT_BOX1:String = "textBox1";
		private const TEXT_BOX2:String = "textBox2";
		
		private const DISTANCE:int = 82;
		private const LENGHT_BAR:int = 265;
		
		private const CTN_BAR:String = "ctnBar";
		private var ctn:Container;
		
		private var textBox1:TextBox;
		private var textBox2:TextBox;
		
		//private var pearl:Pearl;
		private var idPearl:int = -1;
		
		public var isMove:Boolean = false;
		
		private var ctnDrag:Container;
		private var btNext:Button;
		private var btPre:Button;
		
		private var guiHuyDanNumber:GUIHuyDanNumber = new GUIHuyDanNumber(null, "");

		
		
		public function GUISplitPearl(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButton(BTN_CLOSE, "BtnThoat", 420, 17);
				AddButton(BTN_SPLIT, "GuiSplitPearl_Btn_HuyNew_TuLuyenNgoc", 180, 211);
				ctn = AddContainer(CTN_BAR, "GuiSplitPearl_IMG_IconBar_TuLuyenNgoc", 82, 120, true, this);
				ctn.img.buttonMode = true;
				//ctn.EventHandler = this;
				//var bt:ButtonEx = ctn.AddButtonEx(BTN_DRAG, "Btn_DragBar_TuLuyenNgoc", 0, 0,this);
				//bt.img.buttonMode = true;// , 120);
				//AddButtonEx(BTN_DRAG, "Btn_DragBar_TuLuyenNgoc", 0, 0,this);
				ctnDrag = AddContainer(BTN_DRAG, "GuiSplitPearl_Btn_DragBar_TuLuyenNgoc", DISTANCE, 106, true, this);
				ctnDrag.img.buttonMode = true;
				btNext=AddButton(BTN_NEXT, "GuiSplitPearl_Btn_Pre_TuLuyenNgoc", 363, 110, this);
				btPre = AddButton(BTN_PRE, "GuiSplitPearl_Btn_Next_TuLuyenNgoc", 64, 110, this);
				btPre.SetDisable();
				var ctn1:Container = AddContainer("", "GuiSplitPearl_IMG_Cell_Tach_TuLuyenNgoc", 57, 160);
				var ctn2:Container = AddContainer("", "GuiSplitPearl_IMG_Cell_Tach_TuLuyenNgoc", 340, 160);
				var p:Pearl = GuiMgr.getInstance().GuiPearlRefine.pearlList[idPearl];
				var f:TextFormat = new TextFormat();
				f.size = 13;
				f.color = 0xD70000;
				AddLabel("Số lượng đan còn lại ",45,205).setTextFormat(f);
				AddLabel("Số lượng đan hủy", 315, 205).setTextFormat(f);
				
				textBox1 = ctn1.AddTextBox(TEXT_BOX1, p.number.toString(), 0, 10, 50, 41, this);
				textBox2 = ctn2.AddTextBox(TEXT_BOX2, "0", 0, 10, 50, 41, this);
				SetFormatTextBox(textBox1);
				SetFormatTextBox(textBox2);
				
				//imgBar.x = DISTANCE + LENGHT_BAR;
				//imgBar.y = 120;
				//imgBar.addChild(new Button(BTN_DRAG, "Btn_ThanhKeo_TuLuyenNgoc", 0, 0));
				//img.addChild(imgBar);
				
				ShowDisableScreen(0.5);
				SetPos(190, 170);
			}
			LoadRes("GuiSplitPearl_Theme");
		}
		
		private function SetFormatTextBox(textBox:TextBox):void 
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
		
		override public function OnTextboxChange(event:Event, txtID:String):void 
		{
			var n1:int;
			var n2:int;
			var p:Pearl = GuiMgr.getInstance().GuiPearlRefine.pearlList[idPearl];
		

			switch (txtID) 
			{
				case TEXT_BOX1:
					n1 = parseInt( textBox1.GetText());
					if (p)
					{
						n2 = p.number - n1;
						if (n2 <0)
						{
							n2 = 0;
							n1 = p.number;
						}
						if (n2 >= 0 && n2 <= p.number)
						{
							textBox2.SetText(n2.toString());
							textBox1.SetText(n1.toString());
						//	SetFormatTextBox(textBox2);
							ctnDrag.img.x = n2/ p.number * LENGHT_BAR + DISTANCE;
						}
					
						SetButtonEnable(n2);
					}
				break;
				case TEXT_BOX2:
					n2 = parseInt( textBox2.GetText());
					if (p)
					{
						n1 = p.number - n2;
						if (n1 < 0)
						{
							n1 = 0;
							n2 = p.number;
						}
						if (n1 >= 0 && n1 <= p.number)
						{
							textBox1.SetText(n1.toString());
							textBox2.SetText(n2.toString());
							//SetFormatTextBox(textBox1);
							ctnDrag.img.x = n2/ p.number * LENGHT_BAR + DISTANCE;
						}	
					}
					SetButtonEnable(n2);
				break;
			}
			SetFormatTextBox(textBox1);
			SetFormatTextBox(textBox2);
		}
		
		public function ShowGui(id:int ):void 
		{
			idPearl = id;
			Show();
		}
		
		override public function OnButtonDown(event:MouseEvent, buttonID:String):void 
		{
			var bt:Container;
			bt = GetContainer(buttonID);

			switch (buttonID) 
			{
				case BTN_DRAG:
					if (bt)
					{
						bt.img.startDrag(false, new Rectangle(DISTANCE, 106, LENGHT_BAR, 0));
						isMove = true;
						img.stage.addEventListener(MouseEvent.MOUSE_UP, FinishMove);
						//AddEventMouseUpFog(FinishMove);
					}
				break;
			}
		}
		
		private function SetButtonEnable(number:int):void 
		{
			var p:Pearl = GuiMgr.getInstance().GuiPearlRefine.pearlList[idPearl];
			if (p)
			{
				var bt1:Button;
				var bt2:Button;
				bt2 = GetButton(BTN_NEXT);
				bt1 = GetButton(BTN_PRE);
				bt1.SetEnable();
				bt2.SetEnable();
				if (number>=p.number)
				{
					bt2.SetDisable();
				}
				else 
				{
					if (number<=0)
					{
						bt1.SetDisable();
					}
				}
			}
			
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var p:Pearl = GuiMgr.getInstance().GuiPearlRefine.pearlList[idPearl];
			var bt:Container;
			var number:int;

			switch (buttonID) 
			{
				case CTN_BAR:
					bt = GetContainer(BTN_DRAG);
					if (bt)
					{
						var h:Number = event.localX ; 
						if (h >  LENGHT_BAR)
						{
							h =  LENGHT_BAR;
						}
						bt.img.x = h + DISTANCE;
						 number = ( h / LENGHT_BAR ) * p.number;
						textBox2.SetText(number.toString());
						textBox1.SetText((p.number - number).toString());
						SetFormatTextBox(textBox1);
						SetFormatTextBox(textBox2);
						var bt1:Button;
						var bt2:Button;
						bt1 = GetButton(BTN_NEXT);
						bt2 = GetButton(BTN_PRE);
						if (number>=p.number)
						{
							bt1.SetDisable();
							bt2.SetEnable();
						}
						else 
						{
							bt1.SetEnable();
							bt2.SetEnable();
							if (number<=0)
							{
								bt2.SetDisable();
							}
						}
					}
				break;
				case BTN_SPLIT:
					number = parseInt(textBox2.GetText());
					var n2:int;
					if (number)
					{
						n2 = parseInt(textBox1.GetText());
						if (n2 >= 0)
						{
							if (number <= p.number && n2 < p.number)
							{
							
								guiHuyDanNumber.ShowGui(idPearl, number);
							}
						}
					}
					Hide();
					HideDisableScreen();
				break;
				case BTN_CLOSE:
					Hide();
					HideDisableScreen();
				break;
				case  BTN_NEXT:
					number = parseInt(textBox2.GetText());
					bt = GetContainer(BTN_DRAG);
					if (number <p.number)
					{
						number++;
						textBox2.SetText(number.toString());
						textBox1.SetText((p.number - number).toString());
						SetFormatTextBox(textBox1);
						SetFormatTextBox(textBox2);
						bt.img.x = number / p.number * LENGHT_BAR + DISTANCE;
						if (number >= p.number)
						{
							GetButton(BTN_NEXT).SetDisable();
						}
						if (number > 0)
						{
							GetButton(BTN_PRE).SetEnable();
						}
						
					}
				break;
				case BTN_PRE:
					number = parseInt(textBox1.GetText());
					bt = GetContainer(BTN_DRAG);

					if (number<p.number)
					{
						//trace("truoc",number);
						number++;
						//trace("sau",number);
						textBox1.SetText( number.toString());	
						textBox2.SetText((p.number - number).toString());
						SetFormatTextBox(textBox1);
						SetFormatTextBox(textBox2);
						bt.img.x = (p.number - number) / p.number * LENGHT_BAR + DISTANCE;
						if (number <p.number)
						{
							GetButton(BTN_NEXT).SetEnable();
						}
						if (number >= p.number)
						{
							GetButton(BTN_PRE).SetDisable();
						}
					}
					
				break;
			}

			
		}
		

		
		private function FinishMove(e:MouseEvent):void 
		{
			var bt:Container;
			bt = GetContainer(BTN_DRAG);
			isMove = false;
			setLengthBar();
			bt.img.stopDrag();
			img.stage.removeEventListener(MouseEvent.MOUSE_UP, FinishMove);

				//RemoveEventMouseUpFog(FinishMove)
			//}
		}
		
	
	
		public function loop():void 
		{
			if (isMove)
			{
				setLengthBar();
			}
		}
		
		private function setLengthBar():void 
		{
			var p:Pearl = GuiMgr.getInstance().GuiPearlRefine.pearlList[idPearl];
			if (ctnDrag)
			{
				var h:Number = ctnDrag.img.x-DISTANCE;
				var number:int = ( h / LENGHT_BAR ) * p.number;
				textBox2.SetText( number.toString());
				textBox1.SetText((p.number - number).toString());
				SetFormatTextBox(textBox1);
				SetFormatTextBox(textBox2);
				btNext.SetEnable();
				btPre.SetEnable();
				if (number>=p.number)
				{
					btNext.SetDisable();
				}
				else 
				{
					if (number<=0)
					{
						btPre.SetDisable();
					}
				}
			}		
		}
		
	
	}
}