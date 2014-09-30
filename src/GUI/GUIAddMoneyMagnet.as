package GUI 
{
	import com.adobe.crypto.SHA1;
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendBuyOther;
	
	/**
	 * ...
	 * @author SieuSon
	 */
	public class GUIAddMoneyMagnet extends BaseGUI 
	{
		private const BTN_CLOSE:String = "btnClose";
		private const BTN_BUY_ONE:String = "btnBuy1";
		private const BTN_BUY_THREE:String = "btnBuy2";
		private const BTN_GUIDE:String = "btnGuide";
		private const XU_REQUIRE_ONE:int = 1;
		private const XU_REQUIRE_THREE:int = 3;
		
		private var paramList:Array = new Array();
		
		private var guiGuide:GUIGuideMoneyMagnet = new GUIGuideMoneyMagnet(null, "");
		
		public function GUIAddMoneyMagnet(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			SetParam();
		}
		
		public function ShowGui():void 
		{
			Show();
		}
		
		private function SetParam():void 
		{
			var obj:Object = ConfigJSON.getInstance().GetItemList("MagnetItem");			
			
			for (var s:String in obj)
			{
				var item:Object = obj[s];
				item["type"] = "MagnetItem";
				paramList.push(item);
			}
			paramList.sortOn("Id", Array.NUMERIC);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				AddButtons();
				ShowDisableScreen(0.5);
				SetPos(200, 100);
			}
			
			LoadRes("GuiAddMoneyMagnet_Theme");
		}
		
		private function AddButtons():void 
		{
			var tf:TextFormat = new TextFormat();
			tf.size = 14;
			tf.color = 0x000000;
			tf.bold = true;
			AddButton(BTN_CLOSE, "BtnThoat", 418, 18, this);
			AddButton(BTN_GUIDE,"GuiAddMoneyMagnet_BtnGuide",375, 18, this);

			var bt1:Button = AddButton(BTN_BUY_ONE, "GuiAddMoneyMagnet_Btn_BuyGMagnet", 130, 175, this);
			bt1.SetText(paramList[0].ZMoney);
			bt1.text.x = bt1.img.x-10;
			bt1.text.y = bt1.img.y-2;
			bt1.text.mouseEnabled = false;
			bt1.text.setTextFormat(tf);

			
			var bt2:Button=AddButton(BTN_BUY_THREE, "GuiAddMoneyMagnet_Btn_BuyGMagnet", 262, 175, this);
			bt2.SetText(paramList[1].ZMoney);
			bt2.text.x = bt2.img.x-10;
			bt2.text.y = bt2.img.y-2;
			bt2.text.mouseEnabled = false;
			bt2.text.setTextFormat(tf);
			

		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
					HideDisableScreen();
				break;
				case BTN_BUY_ONE:
					CheckG(XU_REQUIRE_ONE,buttonID);
					Hide();
					HideDisableScreen();
				break;
				case BTN_BUY_THREE:
					CheckG(XU_REQUIRE_THREE,buttonID);
					Hide();
					HideDisableScreen();
				break;
				case  BTN_GUIDE:
					guiGuide.ShowGui();
				break;
			}
		}
		
		private function CheckG(xuRequire:int,buttonID:String):void 
		{
			var num:int;
			var s:String = buttonID;
			var index:int = parseInt(s.substr(6, 7));
			var type:String = "";
			if (index > 0)
			{
				
				num = paramList[index - 1].NumUse;
				type = paramList[index - 1].type;
				var xu:int = GameLogic.getInstance().user.GetZMoney();
				// Nếu đủ xu thì cho chọn lại
				if (xu >= xuRequire)
				{
					var cmd:SendBuyOther = new SendBuyOther();
					cmd.AddNew(type, index, 1, "ZMoney");
					Exchange.GetInstance().Send(cmd);
					GameLogic.getInstance().user.UpdateUserZMoney( -xuRequire);
					GameLogic.getInstance().user.moneyMagnet.ProcessAddXu(num);
					GameLogic.getInstance().user.moneyMagnet.SetImg();
					if (GameLogic.getInstance().balloonArr.length > 0)
					{
						GameLogic.getInstance().user.moneyMagnet.ProcessMagnet();		
					}
					
				}
				// Không đủ thì bắt nạp xu
				else
				{
					GuiMgr.getInstance().GuiNapG.Init();
				}	
			}
		}
		
	}

}