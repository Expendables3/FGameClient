package GUI.ZingMeWallet 
{
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendUpdateG;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIChargeZMoney extends BaseGUI 
	{
		static public const BTN_INPUT_CARD:String = "btnInputCard";
		static public const BTN_WALLET:String = "btnWallet";
		static public const BTN_CLOSE:String = "btnClose";
		
		public function GUIChargeZMoney(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				SetPos(100, 100);
				AddButton(BTN_CLOSE, "BtnThoat", 100, 10);
				AddButton(BTN_INPUT_CARD, "BtnDong", 20, 100);
				AddButton(BTN_WALLET, "BtnDong", 150, 100);
			}
			LoadRes("GuiCongratulation_Theme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_INPUT_CARD:
					trace("acc name", GameLogic.getInstance().user.GetMyInfo().UserName);
					GetButton(BTN_INPUT_CARD).SetEnable(false);
					try
					{
						ExternalInterface.addCallback("updateG", function ():void {
							Exchange.GetInstance().Send(new SendUpdateG());
							GetButton(BTN_INPUT_CARD).SetEnable(true);
						});
						ExternalInterface.call("payment", GameLogic.getInstance().user.GetMyInfo().UserName);
					}
					catch (e:*)
					{
						
					}
					break;
				case BTN_WALLET:
					GuiMgr.getInstance().guiZingWallet.Show(Constant.GUI_MIN_LAYER, 3);
					break;
			}
		}
		
	}

}