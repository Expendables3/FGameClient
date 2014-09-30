package GUI 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.TooltipFormat;
	import Logic.GameLogic;
	import Logic.User;
	import NetworkPacket.PacketSend.SendFillEnergy;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIFillEnergy extends BaseGUI
	{
		public const BTN_FILL_ENERGY:String = "btnFillEnergy";
		public const BTN_CLOSE:String = "btnClose";
		public const IMG_ZXU:String = "ImgZXU";
		public const MAX_FILL_A_DAY:int = 5;
		
		public var txtFormat:TextFormat;
		public var Zxu:TextField;
		public var toolTip:TooltipFormat;
		public var btnFillEnergy:Button;
		
		public var objGeneral:Object;
		public var obj:Object;
		public var user:User;
		
		public function GUIFillEnergy(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GuiFillEnergy";
		}
		public override function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				var user:User = GameLogic.getInstance().user;
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				
				btnFillEnergy = AddButton(BTN_FILL_ENERGY, "GuiFillEnergy_BtnPayFull", 0, 0, this);
				btnFillEnergy.SetPos(img.width / 2 - btnFillEnergy.img.width / 2, img.height - btnFillEnergy.img.height - 15);
				
				var btnClose:Button = AddButton(BTN_CLOSE, "BtnThoat", 0, 0, this);
				btnClose.SetPos(img.width - btnClose.img.width - 7, 18);
				
				var objGeneral:Object = ConfigJSON.getInstance().GetItemList("Param"); //GetItemInfo("General", user.GetMyInfo().NumFill);
				var obj:Object = objGeneral.FillEnergy;
				txtFormat = new TextFormat();
				txtFormat.size = 18;
				txtFormat.bold = true;
				txtFormat.font = "myFish";
				txtFormat.color = 0x00CC33;
				Zxu = AddLabel(obj[(user.GetMyInfo().NumFill).toString()].toString(), 165, 182, 0xffffff, 1, 1);
				Zxu.setTextFormat(txtFormat);
				Zxu.defaultTextFormat = txtFormat;
				Zxu.embedFonts = true;
				
				AddImage(IMG_ZXU, "IcZingXu", img.width / 2 + 8, btnFillEnergy.GetPos().y - 20);
			}
			LoadRes("GuiFillEnergy_Theme");
		}
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			if (GameLogic.getInstance().user.GetMyInfo().NumFill <= GuiMgr.getInstance().GuiFillEnergy.MAX_FILL_A_DAY 
				&& GameLogic.getInstance().user.GetEnergy() < ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel(true)))
			{
				switch (buttonID) 
				{
					case BTN_FILL_ENERGY:
						var objGeneral:Object = ConfigJSON.getInstance().GetItemList("Param");
						var obj:Object = objGeneral.FillEnergy;
						if (GameLogic.getInstance().user.GetZMoney() >= obj[(GameLogic.getInstance().user.GetMyInfo().NumFill).toString()])
						{
							GameLogic.getInstance().user.GetMyInfo().NumFill ++;
							Exchange.GetInstance().Send(new SendFillEnergy());
						}
						else 
						{
							GuiMgr.getInstance().GuiNapG.Init();
							Hide();
						}
					break;
					
					case BTN_CLOSE:
						Hide();
					break;
				}
			}
		}
	}

}