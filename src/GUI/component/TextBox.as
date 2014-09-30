package GUI.component 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;	
	import flash.events.KeyboardEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;	
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * sinh ra 1 cái input text trên GUI
	 * @author ducnh
	 */
	public class TextBox
	{
		public var textField:TextField;
		public var TextBoxID:String;
		public var MyParent:Container;
		
		/**
		 * thêm 1 cái textbox vào
		 * @param txtID ID duy nhất của đối tượng trên GUI
		 * @param x tọa độ x tương đối trên container
		 * @param y tọa độ y tương đối trên container
		 * @param width chiều rộng của textbox
		 * @param height chiều cao của textbox
		 */
		public function TextBox(txtID:String, x:int, y:int, width:int, height:int) 
		{
			textField = new TextField();
			textField.x = x;
			textField.y = y;
			textField.type = TextFieldType.INPUT;
			SetSize(width, height);			
			textField.border = false;
			//textField.numLines = 5;
			 //textField.multiline = true;
			//textField.autoSize = TextFieldAutoSize.CENTER;
			textField.textColor = 0xFFFFFF;			
			textField.addEventListener(KeyboardEvent.KEY_UP , OnKeyUp);
			textField.addEventListener(MouseEvent.CLICK, OnClick);
			textField.addEventListener(Event.CHANGE, OnChange);
			
			TextBoxID = txtID;
			this.textField.tabEnabled = false;
		}
		
		/**
		 * Đăt vị trí cho đối tượng
		 * @param x tọa độ x tương đối trên container
		 * @param y tọa độ y tương đối trên container
		 */
		public function SetPos(x:int, y:int):void
		{
			textField.x = x;
			textField.y = y;
		}
		
		public function RemoveAllEvent():void
		{
			textField.removeEventListener(KeyboardEvent.KEY_UP , OnKeyUp);
			textField.removeEventListener(MouseEvent.CLICK, OnClick);
		}
		
		/**
		 * đặt text cho đối tượng
		 * @param txt chuỗi cần hiển thị
		 */
		public function SetText(txt:String):void
		{
			textField.text = txt;
		}
		
		/**
		 * lấy chuỗi input nhập vào
		 */
		public function GetText():String
		{
			return textField.text;
		}
		
		/**
		 * đặt kích thước cho textbox
		 * @param width chiều rộng
		 * @param height chiều cao
		 */
		public function SetSize(width:int, height:int):void
		{
			textField.width = width;
			textField.height = height;
		}
		
		public function SetBoder(isBorder:Boolean):void
		{
			textField.border = isBorder;
		}
		
		
		public function SetBackground(isBackground:Boolean, color:uint):void
		{
			textField.backgroundColor = color;
			textField.background = isBackground;
		}
		
		public function SetTextColor(color:uint):void
		{
			textField.textColor = color;
		}
		
		public function SetTextFormat(txtFormat:TextFormat):void
		{
			//textField.defaultTextFormat = txtFormat;
			textField.setTextFormat(txtFormat);
		}
		
		
		public function SetDefaultFormat(txtFormat:TextFormat):void
		{
			textField.defaultTextFormat = txtFormat;
		}
		
		private function OnClick(event: MouseEvent): void
		{
			if (MyParent == null) 
			{
				return;
			}
			
			MyParent.OnButtonClick(event, TextBoxID);
		}
		
		private function OnKeyUp(event:KeyboardEvent):void
		{
			if (MyParent == null) 
			{
				return;
			}
			
			MyParent.OnTextboxKeyUp(event, TextBoxID);
		}
		
		private function OnChange(event:Event):void
		{
			if (MyParent == null) 
			{
				return;
			}
			
			MyParent.OnTextboxChange(event, TextBoxID);
		}
	}

}