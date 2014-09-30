package Event.EventMidAutumn 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Event.EventMidAutumn.EventPackage.SendRebornLantern;
	import Event.EventMidAutumn.ItemEvent.Lantern;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * GUI hồi sinh đèn trời
	 * @author HiepNM2
	 */
	public class GuiRebornLantern extends BaseGUI 
	{
		private const ID_BTN_CLOSE:String = "IdBtnClose";
		//private const ID_BTN_LOOK_DROP:String = "IdBtnLookDrop";
		private const ID_BTN_REBORN:String = "IdBtnReborn";
		
		private var inReborn:Boolean = false;
		private var timeSend:Number;
		private var tfHigh:TextField;
		public function GuiRebornLantern(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiRebornLantern";
		}
		override public function InitGUI():void 
		{
			setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				var curHigh:int = GuiMgr.getInstance().guiFrontEvent.lantern.High;
				var str:String = Localization.getInstance().getString("EventMidAutumn_TipGuiReborn1");
				str = str.replace("@Distance@", Ultility.StandardNumber(curHigh));
				tfHigh = AddLabel(str, img.width / 2 - 37, 89, 0xffffff);
				tfHigh.setTextFormat(new TextFormat("Arial", 17));
				AddButton(ID_BTN_CLOSE, "BtnThoat", 540, 18);
				//AddButton(ID_BTN_LOOK_DROP, "EventMidAutumnGuiReborn_BtnLookFall", 325, 390);
				AddButton(ID_BTN_REBORN, "EventMidAutumnGuiReborn_BtnReborn", 220, 390);
				var price:int = ConfigJSON.getInstance().getItemInfo("Param")["MidMoon"]["Reborn"]["ZMoney"];
				var sPrice:String = Ultility.StandardNumber(price);
				var tfPrice:TextField = AddLabel(sPrice, 255, 400, 0xffffff, 1, 0x000000);
				tfPrice.mouseEnabled = false;
			}
			LoadRes("EventMidAutumnGuiReborn_Theme");
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (inReborn)
			{
				return;
			}
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
				//case ID_BTN_LOOK_DROP:
					//dropLantern();
					Hide();
				break;
				case ID_BTN_REBORN:
					rebornLantern();
				break;
			}
			
		}
		private function dropLantern():void
		{
			//gửi gói tin rằng là cho đèn trời chết lun
			
			//rơi
			var dHigh:int = GuiMgr.getInstance().guiFrontEvent.lantern.High;
			GuiMgr.getInstance().guiFrontEvent.lantern.fall(dHigh);
		}
		private function rebornLantern():void
		{
			inReborn = true;
			var price:int = ConfigJSON.getInstance().getItemInfo("Param")["MidMoon"]["Reborn"]["ZMoney"];
			var myMoney:int = GameLogic.getInstance().user.GetZMoney();
			if (myMoney < price)
			{
				GuiMgr.getInstance().GuiNapG.Init();
				return;
			}
			GameLogic.getInstance().user.UpdateUserZMoney( -price);
			var pk:SendRebornLantern = new SendRebornLantern("ZMoney");
			Exchange.GetInstance().Send(pk);
			timeSend = GameLogic.getInstance().CurServerTime;
		}
		
		public function processReborn():void
		{
			var lantern:Lantern = GuiMgr.getInstance().guiFrontEvent.lantern;
			lantern.Blood = 3;
			lantern.ClearComponent();
			lantern.draw();
			
			inReborn = false;
			Hide();
		}
		
		public function updateGUI(curTime:Number):void 
		{
			if (inReborn)
			{
				if (curTime - timeSend > 4)
				{
					inReborn = false;
				}
			}
		}
	}

}













