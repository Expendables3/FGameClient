package GUI 
{
	import Data.Localization;
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.media.Sound;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendUpdateG;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUINapG extends BaseGUI
	{
		private static var BUTTON_CHARGE:String = "ButtonCharge";
		private static var BUTTON_QUIT:String = "ButtonQuit";
		private static var BUTTON_CLOSE:String = "ButtonClose";
		
		public function GUINapG(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			x = 240;
			y = 800;
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUINapG";
		}
		
		public override function InitGUI(): void
		{
			this.setImgInfo = function():void
			{
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				//SetPos(210, 130);
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				var btnCharge:GUI.component.Button = AddButton(BUTTON_CHARGE, "GuiNapG_BtnNapG", 110, 190);
				btnCharge.img.width = 111;
				btnCharge.img.height = 40;
				AddButton(BUTTON_QUIT, "GuiNapG_BtnBoQua", 235, 188);
				AddButton(BUTTON_CLOSE, "BtnThoat", 413, 18);
			}
			LoadRes("GuiNapG_Theme");
		}
			
		public function Init():void
		{
			this.Show(Constant.GUI_MIN_LAYER + 1, 3);
			
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{	
				case BUTTON_CHARGE:
					GuiMgr.getInstance().guiAddZMoney.Show(Constant.GUI_MIN_LAYER, 3);
					/*if (ExternalInterface.available)
					{
						ExternalInterface.addCallback("updateG", function ():void {
							Exchange.GetInstance().Send(new SendUpdateG());
						});						
						ExternalInterface.call("payment", GameLogic.getInstance().user.GetMyInfo().UserName);
					}*/
					Hide();
					break;
				case BUTTON_QUIT:
					this.Hide();
					break;
				case BUTTON_CLOSE:
					this.Hide();
					break;
			}
		}
	}

}