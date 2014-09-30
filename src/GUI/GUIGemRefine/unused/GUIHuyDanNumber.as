package GUI.GUIGemRefine.unused 
{
	import com.bit101.components.Text;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.TextBox;
	import Logic.GameLogic;
	import Logic.Pearl;
	import Logic.PearlMgr;
	
	/**
	 * ...
	 * @author Sonbt
	 */
	public class GUIHuyDanNumber extends BaseGUI 
	{
		private var BTN_CLOSE:String = "BtnThoat";
		private var BTN_CHAC_CHAN:String = "BtnChacChan";
		private var BTN_BOQUA:String = "BtnBoQua";
		
		private var idPearl:int = - 1;
		private var number:int = 0;

		private var htmlText:TextField = new TextField();
		public function GUIHuyDanNumber(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUI_HuyDan_TuLuyenNgoc");
			AddButtons();
			AddText();
			
		}
		
		
		public function ShowGui(id:int,num:int=0 ):void 
		{
			idPearl = id;
			number = num;
			Show();
			ShowDisableScreen(0.5);
			SetPos(200, 100);
		}
		
		private function AddButtons():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 420, 17, this);
			AddButton(BTN_CHAC_CHAN, "Btn_ChacChan_TuLuyenNgoc", 112, 210, this);
			AddButton(BTN_BOQUA, "Btn_BoQua_TuLuyenNgoc", 255, 210, this);
			
			
		}
		
		private function AddText():void 
		{
			
			var format:TextFormat = new TextFormat();
			var a:Array = GuiMgr.getInstance().GuiPearlRefine.pearlList;

			

			if (a)
			{
				var p:Pearl = a[idPearl];
				format.size = 20;
				format.color = 0x004080;
				format.font = "Arial";
				
				var s:String = "";
				//s ="&#60;font color=&#34;#00FFFF&#34;&#62;@name@&#60;/font&#62; Theo &#60;font color=&#34;#00FF00&#34; &#62;@money@&#60;/font&#62";
				//	<String id="NPCMsg9">&#60;font color=&#34;#00FFFF&#34;&#62;@name@&#60;/font&#62; bị buộc rời khỏi phòng vì đã thua sạch túi</String>

			//	s = " Bạn sẽ hủy " + p.number +" "+ GetNameElement(p.element) + " cấp " + p.level;
			//	s += "\n Bạn có chắc chắn không ?";
				//var lb2:TextField = AddLabel(s, 50, 70, 0x804040);
				if (p.level > 0)
				{
					s = "<b><font color='#004080' size='20' face='Arial'>" + "Bạn sẽ hủy " +"</font>" + "<font color='#FF0000' size='20' >" + number +"</font>";
					s += "<font color='#0033CC' size='20' face='Arial'>" +" " + GetNameElement(p.element) +" cấp " + p.level + "</font></b>";
				}
				else 
				{
					
					{
						if (p.level == 0)
						{
							s = "<b><font color='#004080' size='20' face='Arial'>" + "Bạn sẽ hủy " +"</font>" + "<font color='#FF0000' size='20' >" + number +"</font>";
							s += "<font color='#0033CC' size='20' face='Arial'>" +" viên tán" + "</font></b>";
						}
					}
				}
			//	s +="<br>" +"<font color='#004080' size='20' face=' Arial'>" + " Bạn có chắc chắn hủy không ?" +"</font>";
				htmlText.mouseEnabled = false;
				htmlText.htmlText = s;
				
				htmlText.width = img.width
				htmlText.height = img.height;
				htmlText.x = 90;
				htmlText.y = 110;
				img.addChild(htmlText);
			/*	if (p.level > 0)
				{
					s = "Bạn sẽ hủy " + p.number +" " + GetNameElement(p.element) + " cấp " + p.level;
				}
				else
				{
					if (p.level == 0)
					{
						s="Bạn sẽ hủy "+p.number+" viên tán";
					*/}
				
			//	var text:TextField = AddLabel(s, 50, 100, 0x004080);
				var lb:TextField = AddLabel(" Bạn có chắc chắn hủy không ?", 50, 120, 0x004080);
				lb.setTextFormat(format);
				lb.x = 70;
				lb.y = 140;
				//lb2.htmlText = s;
			//	lb2.setTextFormat(format);
				//lb2.x = 50;
				//lb2.y = 70;
			
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_CLOSE:
				case BTN_BOQUA:
					Hide();
					HideDisableScreen();
				break;
				case BTN_CHAC_CHAN:
					GuiMgr.getInstance().GuiPearlRefine.DeletePearl(idPearl,number);
					Hide();
					HideDisableScreen();
				break;
			}
		}
		
		private function GetNameElement(e:int=0):String 
		{
			switch (e) 
			{
				case 1:
					return "Kim đan";
				break;
				case 2:
					return "Mộc đan";
				break;
				case 3:
					return "Thổ đan";
				break;
				case 4:
					return "Thủy đan";
				break;
				case 5:
					return "Hỏa đan";
				break;
			}
			return "";
		}
		
	
		
	}

}