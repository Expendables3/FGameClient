package GUI.component 
{
	import Data.ResMgr;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import Logic.Layer;
	import Logic.LayerMgr;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ComboBoxEx extends Sprite
	{
		static public const COMBOBOX_CHANGE:String = "comboboxChange";
		static public const BTN_KEY:String = "btnKey";
		private var guiComboBox:GUIComboBox;
		private var _selectedItem:String;
		public var items:Array;
		private var _defaultLabel:String;
		private var _isShow:Boolean;
		private var _defauTextFormat:TextFormat;
		public var keyButton:SimpleButton;
		private var txtFieldLabel:TextField;
		public var idCombobox:String;
		public var eventHandler:Container;
		public var keyButtonBg:Image;
		public var numVisibleItem:int;
		
		public function ComboBoxEx(parent:Sprite = null, xpos:Number = 0, ypos:Number = 0, defaultLabel:String = "", items:Array = null)
		{
			super();
			this.items = items;
			keyButtonBg = new Image(this, "Btn_ComboBox_Bg");
			keyButtonBg.img.buttonMode = true;
			keyButtonBg.img.mouseEnabled = true;
			keyButtonBg.img.addEventListener(MouseEvent.CLICK, clickKeyButton);
			keyButton =  ResMgr.getInstance().GetRes("Btn_ComboBox") as SimpleButton;
			keyButton.addEventListener(MouseEvent.CLICK, clickKeyButton);
			keyButton.x = keyButtonBg.img.width - keyButton.width;
			this.addChild(keyButton);
			
			txtFieldLabel = new TextField();
			txtFieldLabel.text = defaultLabel;
			txtFieldLabel.mouseEnabled = false;
			txtFieldLabel.height = 20;
			var txtFormat:TextFormat = new TextFormat("Arial", 13, 0xffffff, true);
			txtFieldLabel.setTextFormat(txtFormat);
			txtFieldLabel.defaultTextFormat = txtFormat;
			txtFieldLabel.x = 5;
			txtFieldLabel.y = 3;
			this.addChild(txtFieldLabel);
			
			this.setPos(xpos, ypos);
			parent.addChild(this);
			//isShow = false;
			this.stage.addEventListener(MouseEvent.CLICK, clickStage);
			
			//this.graphics.beginFill(0xff0000);
			//this.graphics.drawRect(0, 0, this.width, this.height);
			//this.graphics.endFill();
		}
		
		private function clickStage(e:MouseEvent):void 
		{
			//if (isShow && e.target != keyButton && e.target != guiComboBox.scrollBar.btnInc && e.target != guiComboBox.scrollBar.btnDec && e.target != guiComboBox.scrollBar.btnBar && e.target != guiComboBox.scrollBar.bar)
			if (isShow && e.target != keyButton && e.target != keyButtonBg.img && e.target.name != null && e.target.name != "bar" && e.target.name != "button_inc" 
			&& e.target.name != "button_dec" && e.target.name != "icon" && e.target.name != "button_bar")
			{
				isShow = false;
			}
		}
		
		public function setEnable(enable:Boolean = true):void
		{
			keyButton.mouseEnabled = enable;
			if (!enable)
				keyButtonBg.img.removeEventListener(MouseEvent.CLICK, clickKeyButton);
			else
				keyButtonBg.img.addEventListener(MouseEvent.CLICK, clickKeyButton);
		}
		
		private function clickKeyButton(e:MouseEvent):void 
		{
			isShow = !isShow;
		}
		
		public function setPos(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		public function get selectedItem():String 
		{
			return txtFieldLabel.text;
		}
		
		public function get defaultLabel():String 
		{
			return _defaultLabel;
		}
		
		public function set defaultLabel(value:String):void 
		{
			_defaultLabel = value;
			txtFieldLabel.text = value;
			//isShow = false;
		}
		
		public function get isShow():Boolean 
		{
			return _isShow;
		}
		
		public function set isShow(value:Boolean):void 
		{
			_isShow = value;
			if (value)
			{
				guiComboBox = new GUIComboBox(null, "");
				guiComboBox.comboBox = this;
				if(numVisibleItem != 0)
				{
					guiComboBox.numVisibleItem = numVisibleItem;
				}
				guiComboBox.showGUI(items);
				var p:Point = parent.localToGlobal(new Point(this.x, this.y));
				var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
				p = layer.globalToLocal(p);
				guiComboBox.SetPos(p.x + 2, p.y + keyButton.height + 2);
			}
			else
			{
				if(guiComboBox != null && guiComboBox.IsVisible)
				{
					guiComboBox.Hide();
				}
			}
		}
		
		public function get defauTextFormat():TextFormat 
		{
			return _defauTextFormat;
		}
		
		public function set defauTextFormat(value:TextFormat):void 
		{
			_defauTextFormat = value;
			for each(var item:ItemLabel in guiComboBox.listItem.itemList)
			{
				item.defaultTextFormat = value;
			}
		}
		
		public function setWidth(width:Number):void
		{
			keyButtonBg.img.width = width;
			keyButton.x = keyButtonBg.img.width - keyButton.width;
		}
		
		public function getWidth():Number
		{
			return keyButtonBg.img.width;
		}
		
		public function destructor():void
		{
			guiComboBox.Destructor();
			items.splice(0, items.length);
		}
		
		public function setEventHandler(_eventHandler:Container, _idCombobox:String):void
		{
			eventHandler = _eventHandler;
			idCombobox = _idCombobox;
		}
	}
}

import flash.events.Event;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import GUI.component.BaseGUI;
import GUI.component.Button;
import GUI.component.ScrollBar;
import GUI.component.Container;
import GUI.component.Image;
import GUI.component.ComboBoxEx;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;
import GUI.component.ListBox;

class GUIComboBox extends BaseGUI
{
	static public const CTN_ITEM:String = "ctnItem";
	private var _defaultLabel:String;
	public var listItem:ListBox;
	public var numVisibleItem:int = 11;
	public var scrollBar:ScrollBar;
	private var _isShow:Boolean;
	private var _items:Array;
	
	private var listBg:Image;
	
	public var comboBox:ComboBoxEx;
	
	public function GUIComboBox(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP)
	{
		super(parent, imgName, x, y, isLinkAge, imgAlign);
	}
	
	override public function InitGUI():void 
	{
		LoadRes("");
		listBg = AddImage("", "ComboBox_Bg", 0, 0);
		listBg.img.x = 0;
		listBg.img.y = 0;
		listBg.img.width = comboBox.keyButtonBg.img.width - 2;
		scrollBar = AddScroll("", "ScrollBarExtendDeco", listBg.img.width - 18, 3);
		//scrollBar.img.scaleX = scrollBar.img.scaleY = 0.6;
		addEventListener(ComboBoxEx.COMBOBOX_CHANGE, onComobBoxChange);
	}
	
	private function onComobBoxChange(e:Event):void 
	{
		if (comboBox.eventHandler != null)
		{
			comboBox.eventHandler.onComboboxChange(e, comboBox.idCombobox);
		}
	}
	
	public function showGUI(items:Array= null):void
	{
		Show();
		this.items = items;
	}
	
	override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
	{
		switch(buttonID)
		{
			default:
				if (buttonID.search(CTN_ITEM) >= 0)
				{
					var arr:Array = buttonID.split("_");
					defaultLabel = arr[1];
					dispatchEvent(new Event(ComboBoxEx.COMBOBOX_CHANGE));
				}
				break;
		}
	}
	
	override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
	{
		if (buttonID.search(CTN_ITEM) >= 0)
		{
			var ctn:Container = listItem.getItemById(buttonID) as Container;
			ctn.SetHighLight(0xff0000);
		}
	}
	override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
	{
		if (buttonID.search(CTN_ITEM) >= 0)
		{
			var ctn:Container = listItem.getItemById(buttonID) as Container;
			ctn.SetHighLight(-1);
		}
	}
	
	public function get defaultLabel():String 
	{
		return _defaultLabel;
	}
	
	public function set defaultLabel(value:String):void 
	{
		_defaultLabel = value;
		//labelValue.text = value;
		comboBox.defaultLabel = value;
	}
	
	public function get items():Array 
	{
		return _items;
	}
	
	public function set items(value:Array):void 
	{
		_items = value;
		
		//var itemWidth:Number = 0;
		var itemHeight:Number = 0;
		if(listItem != null && listItem.img != null)
		{
			listItem.removeAllItem();
			listItem.destructor();
			listItem = null;
		}
		
		if (value.length < numVisibleItem)
		{
			numVisibleItem = value.length;
		}
		listItem = AddListBox(ListBox.LIST_Y, numVisibleItem, 1, 0, 5);
		listItem.setPos(2, 3);
		if (_items != null)
		{
			for (var i:int = 0; i < _items.length; i++)
			{
				var item:ItemLabel = new ItemLabel(listItem.img);
				item.labelBg.img.width = comboBox.keyButtonBg.img.width - comboBox.keyButton.width;
				item.label = _items[i];
				item.IdObject = CTN_ITEM + "_" + _items[i];
				listItem.addItem(item.IdObject, item, this);
				item.img.buttonMode = true;
				
				//if (item.img.width > itemWidth)
				//{
					//itemWidth = item.img.width;
				//}
				if (item.img.height > itemHeight)
				{
					itemHeight = item.img.height;
				}
			}
		}
		
		//listItem.setInfo(0, 5, 70, itemHeight);
		listBg.img.height = numVisibleItem * (itemHeight + 5);
		//listBg.img.height = listItem.mask.height;
		scrollBar.setScrollImage(listItem.img, 0,  listBg.img.height - 7);
		scrollBar.img.height = numVisibleItem * (itemHeight + 5) - 5;
		scrollBar.img.width = 15;
		if (_items.length <= numVisibleItem)
		{
			scrollBar.visible = false;
		}
		
		if (scrollBar.visible && comboBox.defaultLabel != null && comboBox.defaultLabel != "")
		{
			var indexDefault:int = listItem.getIndexById(CTN_ITEM + "_" + comboBox.defaultLabel);
			//trace("index", comboBox.defaultLabel, indexDefault);
			if (indexDefault + numVisibleItem >= listItem.numItem - 1)
			{
				indexDefault -= numVisibleItem - 1;
			}
			indexDefault = Math.max(0, indexDefault);
			listItem.showItem(indexDefault);
			var percent:Number = Number(indexDefault) / listItem.length;
			//trace("percent", percent);
			scrollBar.setScrollPos(percent*scrollBar.height);
		}
	}
	
	//public function get isShow():Boolean 
	//{
		//return _isShow;
	//}
	//
	//public function set isShow(value:Boolean):void 
	//{
		//img.visible = value;
		///*_isShow = value;
		//if (isShow)
		//{
			//listItem.visible = true;
			//scrollBar.visible = true;
			//listBg.img.visible = true;
		//}
		//else
		//{
			//listItem.visible = false;
			//scrollBar.visible = false;
			//listBg.img.visible = false;
		//}*/
	//}
}

class ItemLabel extends Container
{
	private var txtFieldlabel:TextField;
	private var _label:String;
	private var _defaultTextFormat:TextFormat;
	public var labelBg:Image;
	
	public function ItemLabel(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
	{
		super(parent, imgName, x, y, isLinkAge, imgAlign);
		LoadRes("");
		labelBg = AddImage("", "Item_ComboBox_Bg", 52 + 10, 10);
		txtFieldlabel = AddLabel("", 0, 0, 0x1d5561, 0);
		txtFieldlabel.autoSize = TextFieldAutoSize.LEFT;
	}
	
	public function get label():String 
	{
		return _label;
	}
	
	public function set label(value:String):void 
	{
		_label = value;
		txtFieldlabel.text = value;
	}
	
	public function get defaultTextFormat():TextFormat 
	{
		return _defaultTextFormat;
	}
	
	public function set defaultTextFormat(value:TextFormat):void 
	{
		_defaultTextFormat = value;
		txtFieldlabel.defaultTextFormat = value;
	}
}