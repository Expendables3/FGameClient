package GUI.EnchantEquipment 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendBuyOther;
	
	/**
	 * GUI mua bùa bảo vệ
	 * @author longpt
	 */
	public class GUIBuyGodCharm extends BaseGUI 
	{
		public var numBuy:int = 0;
		
		private static const CTN_BUY:String = "CtnBuy";
		private static const BTN_BUY:String = "BtnBuy";
		private static const BTN_CLOSE:String = "BtnClose";
		
		private var numItem:TextField;
		private var curGodCharmId:int;
		
		public function GUIBuyGodCharm(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIBuyGodCharm";
		}
		
		public override function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				SetPos(200, 155);
				RefreshGUI();
			}
			
			LoadRes("GuiBuyGodCharm_Theme");
		}
		
		public function SetId(id:int):void
		{
			curGodCharmId = id;
		}
		
		public function RefreshGUI():void
		{
			ClearComponent();
			var ctn:Container = AddContainer(CTN_BUY, "GuiBuyGodCharm_Container", 160, 110);
			AddButton(BTN_BUY, "GuiBuyGodCharm_BtnBuy", 153, 203);
			AddButton(BTN_CLOSE, "BtnThoat", 374, 20);
			
			var lb:TextField = AddLabel("Mua " + ConfigJSON.getInstance().GetItemList("GodCharm")[curGodCharmId].ZMoney, 145, 205, 0xffffff, 1);
			var txtF:TextFormat = new TextFormat();
			txtF.size = 20;
			lb.setTextFormat(txtF);
			
			var imag:Image = ctn.AddImage("", "GodCharm" + curGodCharmId, ctn.img.width / 2, ctn.img.height / 2);
			imag.setImgInfo = function():void
			{
				this.FitRect(75, 75, new Point(5, 5));
			}
			imag.FitRect(75, 75, new Point(5, 5));
			
			lb = AddLabel("Bạn đang có: ", 120, 74, 0xffffff, 1, 0x000000);
			txtF = new TextFormat();
			txtF.size = 16;
			txtF.italic = true;
			lb.setTextFormat(txtF);
			
			AddImage("", "GodCharm" + curGodCharmId, 0, 0).FitRect(30, 30, new Point(270, 70));
			
			numBuy = GameLogic.getInstance().user.GetStoreItemCount("GodCharm", curGodCharmId);
			
			numItem = AddLabel("", 194, 71, 0xffffff, 1, 0x000000);
			txtF = new TextFormat();
			txtF.size = 20;
			txtF.align = "center";
			numItem.defaultTextFormat = txtF;
			numItem.text = numBuy + "";
			
			var tt:TooltipFormat = new TooltipFormat();
			var str:String = Localization.getInstance().getString("GodCharm" + curGodCharmId);
			tt.text = str;
			var textFormat:TextFormat = new TextFormat();
			textFormat.color = 0xff0000;
			textFormat.size = 16;
			textFormat.bold = true;
			tt.setTextFormat(textFormat, 0, str.split("\n")[0].length);
			setTooltip(tt);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE:
					this.Hide();
					GuiMgr.getInstance().GuiEnchantEquipment.GetGodCharmSlot().refreshInfo(GuiMgr.getInstance().GuiEnchantEquipment.EquipmentChoose);
					break;
				case BTN_BUY:
					var cfg:Object = ConfigJSON.getInstance().GetItemList("GodCharm")[curGodCharmId];
					if (GameLogic.getInstance().user.GetZMoney() < cfg.ZMoney)
					{
						GuiMgr.getInstance().GuiNapG.Init();
					}
					else
					{
						var cmd:SendBuyOther = new SendBuyOther();
						cmd.AddNew("GodCharm", curGodCharmId, 1, "ZMoney");
						Exchange.GetInstance().Send(cmd);						
						GameLogic.getInstance().user.UpdateUserZMoney( -cfg.ZMoney);
						GuiMgr.getInstance().GuiStore.UpdateStore("GodCharm", curGodCharmId, 1);
						numBuy++;
						numItem.text = numBuy + "";
					}
					break;
			}
		}
		
		public override function OnHideGUI():void
		{
			if (GuiMgr.getInstance().GuiEnchantEquipment.IsVisible)
			{
				GuiMgr.getInstance().GuiEnchantEquipment.ShowInfo();
			}
		}
	}

}