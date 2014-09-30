package GUI 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import Logic.GameLogic;
	import Logic.Lake;
	import NetworkPacket.PacketReceive.GetLoadInventory;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUIExpandLake extends BaseGUI
	{
		
		private var GUI_EXPAND_BTN_CLOSE:String = "buttonClose";
		private var GUI_EXPAND_BTN_EXPAND:String = "buttonExpand";
		private var GUI_EXPAND_BTN_BUY_PERMIT:String = "buttonBuyPermit";
		
		public var txtLicense:TextField;
		
		private var btnExpand:Button;
		
		public function GUIExpandLake(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		//Add button đóng ở góc trên bên phải
		private function AddButtons():void
		{
			var bt:Button = AddButton(GUI_EXPAND_BTN_CLOSE, "BtnThoat", 372, 17, this);
			//bt.img.scaleX = bt.img.scaleY = 1.25;
			btnExpand = AddButton(GUI_EXPAND_BTN_EXPAND, "GuiExpandLake_BtnExpandLake", 70, 210, this);
			bt = AddButton(GUI_EXPAND_BTN_BUY_PERMIT, "GuiExpandLake_BtnGotoShop", 190, 210, this);
			//bt.img.scaleX = bt.img.scaleY = 0.65;
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(220, 180);	
				ClearComponent();
				AddButtons();
				OpenRoomOut();
			}
			
			LoadRes("GuiExpandLake_Theme");
		}
		
		public function ShowGUIExpand():void
		{
			GameLogic.getInstance().BackToIdleGameState();
			this.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		public override function  EndingRoomOut():void
		{
			var lake:Lake = GameLogic.getInstance().user.GetLake(GameLogic.getInstance().user.CurLake.Id);
			var userLicense:int;
			
			//AddImage("", "ImgLakeIcon" + lake.Id, 55, 135);
			
			if (GameLogic.getInstance().user.StockThingsArr.License[0] != null)
			{
				userLicense = GameLogic.getInstance().user.StockThingsArr.License[0].Num;
			}
			else
			{
				userLicense = 0;
			}

			var lakeLevelInfo:Object = lake.LakeLevels[lake.Level];
			var licenseNeed:int = lakeLevelInfo["License"];

			// Add thông tin lên GUI: giấy phép, level yêu cầu, tổng số cá
			var txtFld:TextField;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.font = "arial";
			txtFormat.size = 15;
			txtFormat.bold = true;
			txtFormat.align = "center";
			txtFormat.color = 0x000000;
			
			txtLicense = AddLabel(userLicense + "/" + licenseNeed, 260, 127);
			txtLicense.setTextFormat(txtFormat);
			txtFld = AddLabel(lakeLevelInfo["LevelRequire"], 260, 102);
			txtFld.setTextFormat(txtFormat);
			txtFld = AddLabel(lakeLevelInfo["TotalFish"] + "/" + lakeLevelInfo["TotalFish"], 54, 168, 0, 1, 0x26709C);
			txtFld.autoSize = "center";		
			txtFld.defaultTextFormat = txtFormat;
			
			txtFormat = new TextFormat();
			txtFormat.size = 18;
			txtFormat.color = 0xFFFFFF;
			txtFormat.bold = true;
			txtFormat.align = "center";
			txtFld.setTextFormat(txtFormat);
			txtFld.width = txtFld.textWidth;	
			
			
			if (userLicense < licenseNeed)
			{
				btnExpand.SetDisable();
			}
			else
			{
				btnExpand.SetEnable();
			}
		}
		
		public function UpdateLicense():void 
		{
			var lake:Lake = GameLogic.getInstance().user.GetLake(GameLogic.getInstance().user.CurLake.Id);
			var lakeLevelInfo:Object = lake.LakeLevels[lake.Level];
			var licenseNeed:int = lakeLevelInfo["License"];
			
			var userLicense:int;
			if (GameLogic.getInstance().user.StockThingsArr.License[0] != null)
			{
				userLicense = GameLogic.getInstance().user.StockThingsArr.License[0].Num;
			}
			else
			{
				userLicense = 0;
			}
			txtLicense.text = userLicense + "/" + licenseNeed;
			if (userLicense < licenseNeed)
			{
				btnExpand.SetDisable();
			}
			else
			{
				btnExpand.SetEnable();
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_EXPAND_BTN_CLOSE:
					this.Hide();
					break;
				case GUI_EXPAND_BTN_EXPAND:
					GameLogic.getInstance().DoUpgradeLake();
					Hide();
					break;
				case GUI_EXPAND_BTN_BUY_PERMIT:
					GuiMgr.getInstance().GuiShop.CurrentShop = "Special";
					GuiMgr.getInstance().GuiShop.curPage = 1;
					GameController.getInstance().UseTool("Shop");
					//GuiMgr.getInstance().GuiShop.Show(Constant.GUI_MIN_LAYER, 6);
					break;
				default:
					break;
			}
		}
	}

}