package GUI.BlackMarket 
{
	import Data.Localization;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIConfirmBuyItem extends BaseGUI 
	{
		private var okFunction:Function;
		static public const BTN_CLOSE:String = "btnClose";
		static public const BTN_OK:String = "btnOk";
		static public const BTN_CANCEL:String = "btnCancel";
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		public var itemMarket:ItemMarket;
		
		public function GUIConfirmBuyItem(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUI_Confirm_Buy_Market");
			AddButton(BTN_CLOSE, "BtnThoat", 412, 17);
			AddButton(BTN_OK, "Btn_Ok_Market", 120, 299);
			AddButton(BTN_CANCEL, "Btn_Exit", 252, 299);
			SetPos(201, 125);
		}
		
		public function showGUI(cost:int, objName:String, itemBg:String, imgName:String, _okFunction:Function = null, fontColor:int = 0xffffff, enchantLevel:int = 0, color:int = 0):void
		{
			Show(Constant.GUI_MIN_LAYER, 6);
			var txtFormat:TextFormat = new TextFormat("arial", 18, 0xff00ff, true);
			AddLabel(cost.toString(), 50 + 128, 50 + 201, 0x00ffff, 1, 0x000000).setTextFormat(txtFormat);
			txtFormat.color = fontColor;
			AddLabel(objName, 50 + 134, 70 + 56, fontColor, 1, 0x000000).setTextFormat(txtFormat);
			AddImage("", itemBg, 100 + 131, 198);
			var objImage:Image = AddImage("", imgName, 100 + 131 + 16, 198 + 14, true, Image.ALIGN_CENTER_CENTER, false, function f():void
			{
				if (color != 0)
				{
					FishSoldier.EquipmentEffect(this.img, color);
					if (color == 6)
					{
						AddImage("", "IcMax", 50 + 128 + 92, 50 + 201 - 69).SetScaleXY(0.7);
					}
				}
			});
			objImage.FitRect(70, 70, new Point(50 + 131 + 16, 148 + 14));
			okFunction = _okFunction;
			
			if (enchantLevel != 0)
			{
				txtFormat.color = 0xffff00;
				AddLabel("+" + enchantLevel.toString(), 190 - 32, 157, 0xffff00, 1, 0x000000).setTextFormat(txtFormat);
			}
			img.addChild(WaitData);
			WaitData.x = img.width / 2;
			WaitData.y = img.height / 2 - 20;
			WaitData.visible = true;
			GetButton(BTN_OK).SetEnable(false);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
				case BTN_CANCEL:
					Hide();
					break;
				case BTN_OK:
					if(okFunction != null)
					{
						okFunction();
						okFunction = null;
					}
					Hide();
					break;
			}
		}
		
		public function setBuy(canBuy:Boolean):void 
		{
			if (canBuy)
			{
				WaitData.visible = false;
				GetButton(BTN_OK).SetEnable(true);
			}
			else
			{
				Hide();
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("ErrorMsg116"));
				GuiMgr.getInstance().guiMarket.refreshCurPage();
			}
		}
	}

}