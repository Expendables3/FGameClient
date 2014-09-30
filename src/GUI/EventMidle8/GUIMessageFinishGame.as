package GUI.EventMidle8 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendBuyArrow;
	import NetworkPacket.PacketSend.SendGetEventOnRoad;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIMessageFinishGame extends BaseGUI 
	{
		private const BTN_CLOSE:String = "btnClose";
		private const BTN_BACK:String = "btnBack";
		private const BTN_BUY_BY_G:String = "btnBuyByG";
		private var numG:int = 0;
		private var objArrow:Object;
		private var txtPriceZMoney:TextField;
		
		public function GUIMessageFinishGame(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIMessageFinishGame";
		}
		
		override public function InitGUI():void 
		{
			super.InitGUI();
			LoadRes("GUIMessageFinishGame_ImgBgGUIMessageFinishGame");
			SetPos(Constant.STAGE_WIDTH / 2 - this.img.width / 2, Constant.STAGE_HEIGHT / 2 - this.img.height / 2);
			
			objArrow = ConfigJSON.getInstance().GetItemList("Arrow");
			var obj:Object = objArrow[GuiMgr.getInstance().GuiGameTrungThu.ARROW_KEY.toString()];
			numG = obj.ZMoney;
			
			AddButton(BTN_CLOSE, "BtnThoat", img.width - 35, 20);
			AddButton(BTN_BACK, "GUIHelpGame_BtnBackGameMidle8", 0, 0, this);
			var btnBuyByG:Button = AddButton(BTN_BUY_BY_G, "GUIMessageFinishGame_BtnBuyKeyByGInPopUpGameMidle8", 0, 0, this);
			
			GetButton(BTN_BACK).img.x =  img.width / 2 - GetButton(BTN_BACK).img.width - 55;
			GetButton(BTN_BACK).img.y =  img.height - 55;
			
			GetButton(BTN_BUY_BY_G).img.x =  img.width / 2 - 35;// + GetButton(BTN_BUY_BY_G).img.width - 55;
			GetButton(BTN_BUY_BY_G).img.y =  img.height - 55;
			
			var fm:TextFormat = new TextFormat();
			fm.size = 18;
			fm.align = "center";
			txtPriceZMoney = AddLabel(numG.toString() , btnBuyByG.img.x + btnBuyByG.img.width / 2 - 5, btnBuyByG.img.y + 4, 0x00FF00, 1, 0x000000);
			txtPriceZMoney.setTextFormat(fm);
			//AddLabel(numG.toString() , 300,225, 0x00FF00, 1, 0x000000);
			
			OpenRoomOut();
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			//if (!GuiMgr.getInstance().GuiGameTrungThu.CheckCanBuyIconInEvent("PearFlower"))
			//{
				//GetButton(BTN_BUY_BY_G).SetVisible(false);
				//GetButton(BTN_BACK).SetPos(img.width / 2 - GetButton(BTN_BACK).img.width / 2,  img.height - 55);
				//txtPriceZMoney.visible = false;
			//}
			//else 
			{
				GetButton(BTN_BUY_BY_G).SetVisible(true);
				GetButton(BTN_BACK).img.x =  img.width / 2 - GetButton(BTN_BACK).img.width - 55;
				GetButton(BTN_BACK).img.y =  img.height - 55;
				txtPriceZMoney.visible = true;
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			
			switch (buttonID) 
			{
				case BTN_CLOSE:
				case BTN_BACK:
					Hide();
					GuiMgr.getInstance().GuiGameTrungThu.RoadState = GuiMgr.getInstance().GuiGameTrungThu.ROAD_STATE_NORMAL;
				break;
				case BTN_BUY_BY_G:
					GetButton(BTN_BUY_BY_G).SetDisable();
					var price:int = int(objArrow[GuiMgr.getInstance().GuiGameTrungThu.ARROW_KEY.toString()]["ZMoney"]);
					if (price > GameLogic.getInstance().user.GetZMoney())
					{
						GuiMgr.getInstance().GuiNapG.Init();
						return;
					}
					var cmd:SendBuyArrow = new SendBuyArrow(GuiMgr.getInstance().GuiGameTrungThu.ARROW_KEY, "ZMoney");
					Exchange.GetInstance().Send(cmd);
					GameLogic.getInstance().user.UpdateUserZMoney( -price);
					//var cmd1:SendGetEventOnRoad = new SendGetEventOnRoad();
					//Exchange.GetInstance().Send(cmd1);
					//Hide();
				break;
			}
		}
	}

}