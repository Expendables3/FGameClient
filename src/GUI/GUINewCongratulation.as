package GUI 
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import Logic.FishSoldier;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUINewCongratulation extends BaseGUI 
	{
		static public const BTN_OK:String = "btnOk";
		static public const BTN_CLOSE:String = "btnClose";
		static public const ITEM_BG:String = "itemBg";
		static public const IMAGE_ITEM:String = "imageItem";
		private var message:String;
		private var btnName:String;
		private var imagename:String;
		private var textField:TextField;
		private var labelNum:TextField;
		private var num:int;
		private var okFunction:Function;
		private var image:Image;
		private var itemEquipment:FishEquipment;
		private var itemBgName:String;
		
		public function GUINewCongratulation(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(220, 100);
				AddButton(BTN_CLOSE, "BtnThoat", 500 - 155, 44);
				var btnOk:Button = AddButton(BTN_OK, btnName, 205, 245);
				btnOk.img.x = 205 -btnOk.img.width / 2;
				
				if (itemBgName != null && itemBgName != "")
				{
					var ctnBg:Container = AddContainer(ITEM_BG, itemBgName, 0, 0, true, this);
					ctnBg.FitRect(80, 80, new Point(165-8, 145-8));
				}
				//image = AddContainer(IMAGE_ITEM, imagename, 165, 150, true, this);
				var cL:int;
				if (itemEquipment != null)
				{
					cL = itemEquipment.Color;
				}
				image = AddImage(IMAGE_ITEM, imagename, 0, 0, true, Image.ALIGN_CENTER_CENTER, false, function f():void
				{
					if (itemEquipment != null)
					{
						FishSoldier.EquipmentEffect(this.img, cL);
					}
					this.img.mouseChildren = false;
					this.img.mouseEnabled = false;
				});
				if(cL == 6)
				{
					this.AddImage("", "IcMax", 74 + 160, 30 + 135).SetScaleXY(0.7);
				}
				image.FitRect(60, 60, new Point(165, 145));
				textField = AddLabel("", 16, 87, 0x0c6298);
				textField.width = 260;
				textField.wordWrap = true;
				var txtFormat:TextFormat = new TextFormat("Arial", 18, 0x0c6298, true);
				txtFormat.align = "center";
				textField.defaultTextFormat = txtFormat;
				labelNum = AddLabel("", 183, 183, 0, 0, 0x26709c);
				txtFormat.size = 15;
				txtFormat.color = 0xffffff;
				labelNum.defaultTextFormat = txtFormat;
				
				textField.htmlText = message;
				if(num != 0)
				{
					labelNum.text = "x" + Ultility.StandardNumber(num);
				}
			}
			LoadRes("GuiCongratulation_Theme");
		}
		
		public function showGUI(_imageName:String, _num:int = 0, _message:String = "", _okFunction:Function = null, _btnName:String = "BtnNhanThuong"):void
		{
			imagename = _imageName;
			btnName = _btnName;
			num = _num;
			message = _message;
			okFunction = _okFunction;
			
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID == BTN_OK && okFunction != null)
			{
				okFunction();
			}
			Hide();
		}
		
		public function showEquipment(_itemEquipment:FishEquipment, _num:int = 0, _message:String = "", _okFunction:Function = null, _btnName:String = "BtnNhanThuong"):void
		{
			itemEquipment = _itemEquipment;
			imagename = FishEquipment.GetEquipmentName(itemEquipment.Type, itemEquipment.Rank, itemEquipment.Color) + "_Shop";
			itemBgName = FishEquipment.GetBackgroundName(itemEquipment.Color);
			btnName = _btnName;
			num = _num;
			message = _message;
			okFunction = _okFunction;
			
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ITEM_BG:
				case IMAGE_ITEM:
					if (itemEquipment != null)
					{
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, itemEquipment, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
					}
					break;
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ITEM_BG:
				case IMAGE_ITEM:
					if (itemEquipment != null)
					{
						GuiMgr.getInstance().GuiEquipmentInfo.Hide();
					}
					break;
			}
		}
		
		override public function OnHideGUI():void 
		{
			itemEquipment = null;
			imagename = "";
			itemBgName = "";
			message = "";
			okFunction = null;
		}
	}

}