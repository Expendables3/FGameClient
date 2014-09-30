package GUI.unused
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author tuannm3
	 */
	public class GUIBuyItem extends BaseGUI
	{
		private const GUI_BUYITEM_BTN_CLOSE:String = "ButtonClose";
		private const GUI_BUYITEM_BTN_BUY:String = "ButtonBuy";
		private const GUI_BUYITEM_BTN_NEXT:String = "ButtonNext";
		private const GUI_BUYITEM_BTN_BACK:String = "ButtonBack";
		private const GUI_BUYITEM_TB_SOLUONG:String = "TBSoLuong";
		
		private var item:Object = new Object();
		private var TextboxSoLuong:TextBox;
		private var tfMoney:TextField;
		private var xuIcon:Image;
		private var btMuaxu:Button;
		
		public function GUIBuyItem(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUISetFishInfo";
		}	
		
		public function showBuyItem(Item:Object):void
		{
			Show(Constant.GUI_MIN_LAYER, 4);
			item = Item;
		}
		
		public override function InitGUI() :void
		{
			LoadRes("Gui_BuyItem");
			var button:Button = AddButton(GUI_BUYITEM_BTN_CLOSE, "BtnThoat", 190, 2, this);
			SetPos(300, 200);
			OpenRoomOut();
		}
		
		public override function EndingRoomOut():void
		{
			var txtFormat:TextFormat = new TextFormat("Arial", 16 ,0x854F3D, true);
			var tf:TextField = AddLabel(item[ConfigJSON.KEY_NAME], 63, 11);
			tf.setTextFormat(txtFormat);
			var icon:Image = AddImage("", item["ItemType"] + item["ItemId"], 0, 0);
			icon.SetScaleXY(2);
			icon.FitRect(100, 100, new Point(60, 30));
			
			//Text box để nhập số lượng
			TextboxSoLuong = AddTextBox(GUI_BUYITEM_TB_SOLUONG, "1", 75, 125, 120, 20, this);
			txtFormat = new TextFormat("Arial", 16);
			txtFormat.align = TextFormatAlign.CENTER;
			txtFormat.bold = true;
			TextboxSoLuong.SetTextFormat(txtFormat);
			TextboxSoLuong.SetDefaultFormat(txtFormat);
			TextboxSoLuong.textField.restrict = "0-9";
			TextboxSoLuong.textField.width = 70;
			
			//Các button
			var bt:Button = AddButton(GUI_BUYITEM_BTN_BACK, "BtnPreShop", 30, 120);
			bt.img.scaleX = bt.img.scaleY = 0.7;
			bt = AddButton(GUI_BUYITEM_BTN_NEXT, "BtnNextShop", 160, 120);
			bt.img.scaleX = bt.img.scaleY = 0.7;
			btMuaxu = AddButton(GUI_BUYITEM_BTN_BUY, "BtnBuyXu", 60, 180);	
			
			//So tien
			tfMoney = AddLabel(item["ZMoney"], 130, 175, 0, 0);
			txtFormat = new TextFormat("Arial", 24, 0x016701);
			txtFormat.align = TextFormatAlign.CENTER;
			txtFormat.bold = true;
			tfMoney.setTextFormat(txtFormat);
			tfMoney.defaultTextFormat = txtFormat;
			
			xuIcon = AddImage("", "IcZingXu", tfMoney.x + tfMoney.textWidth + 8, tfMoney.y + 4, true, ALIGN_LEFT_TOP);
		}
		
		public function buyItem(number:int):void
		{
			var MoneyHave:int = GameLogic.getInstance().user.GetZMoney();
			var nMoney:int = item["ZMoney"];
			if (nMoney > MoneyHave)
			{
				return;
			}			
			
			GameLogic.getInstance().user.UpdateUserZMoney( -number*nMoney);
			GameLogic.getInstance().user.UpdateStockThing(item["ItemType"], item["ItemId"], 1);
			
			//Hiện thông báo mua thành công
			EffectMgr.setEffBounceDown("Mua thành công", item["ItemType"] + item["ItemId"], 330, 280);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case GUI_BUYITEM_BTN_CLOSE:
					Hide();
					break;
				case GUI_BUYITEM_BTN_BUY:		
					var n:int = parseInt(TextboxSoLuong.GetText());
					buyItem(n);
					Hide();
					GuiMgr.getInstance().GuiShop.EndingRoomOut();
					break;
				case GUI_BUYITEM_BTN_NEXT:	
					var num:int = parseInt(TextboxSoLuong.GetText()) + 1;
					if (num > 1000) num = 1000;
					TextboxSoLuong.SetText(num.toString());
					changeItemNumb();
					break;
				case GUI_BUYITEM_BTN_BACK:		
					num = parseInt(TextboxSoLuong.GetText()) - 1;
					if (num < 1) num = 1;
					TextboxSoLuong.SetText(num.toString());
					changeItemNumb();
					break;
			}
		}
		
		public override function OnTextboxChange(event:Event, txtID:String):void
		{
			changeItemNumb();
		}
		
		private function changeItemNumb():void
		{
			var st:String = TextboxSoLuong.GetText();
			
			//Xử lý xóa hết cá số 0 ở đầu đi
			var arrSt:Array = st.split("");
			while (arrSt[0] == "0")
			{
				arrSt.shift();
				st = arrSt.join("");
			}			
			TextboxSoLuong.SetText(st);

			//Check đủ điêu kiện thì mới enable nút mua
			var n:Number = parseInt(st);
			if (isNaN(n) || n < 1)
			{
				btMuaxu.SetDisable();
			}
			else
			{
				btMuaxu.SetEnable();
			}
			
			//Check vượt quá 1000 thì đặt về 1000
			if (n > 1000)
			{
				n = 1000;
				TextboxSoLuong.SetText(n.toString());
			}
			else
			{
				var maxCanBuy:int = GameLogic.getInstance().user.GetZMoney() / item["ZMoney"];
				if (n > maxCanBuy)//Check vượt quá số tiền có thể mua được
				{
					n = maxCanBuy;
					TextboxSoLuong.SetText(n.toString());
				}
			}
			var money:int = n * item["ZMoney"];
			tfMoney.text = money.toString();
			xuIcon.SetPos(tfMoney.x + tfMoney.textWidth + 8, tfMoney.y + 4);
		}
	}

}