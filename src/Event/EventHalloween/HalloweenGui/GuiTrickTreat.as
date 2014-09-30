package Event.EventHalloween.HalloweenGui 
{
	import Data.ConfigJSON;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventHalloween.HalloweenPackage.SendTrickOrTreat;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.GuiGetStatus.SendGetStatus;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.BasePacket;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiTrickTreat extends BaseGUI 
	{
		//static public const CMD_CLOSE:String = "cmdClose";
		private const TIME_WAIT:int = 30;
		static public const CMD_TRICK:String = "cmdTrick";
		static public const CMD_TREAT:String = "cmdTreat";
		static public const CMD_TRICK_OR_TREAT:String = "cmdTrickOrTreat";
		static public const CMD_CLOSE:String = "cmdClose";
		
		private var btnTrick:Button;
		private var timeGui:Number;
		private var lockTime:Number;
		private var inUpdateGui:Boolean = false;
		private var tfTime:TextField;
		public function GuiTrickTreat(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiTrickTreat";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				inUpdateGui = true;
				timeGui = GameLogic.getInstance().CurServerTime;
				lockTime = timeGui;
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				btnTrick = AddButton(CMD_TRICK_OR_TREAT + "_3", "GuiTrickTreat_BtnTreat", 95 + 28, 270 + 43);
				var data:Object = HalloweenMgr.getInstance().dataGhost;
				var myValue:int = getMyValue(data["ItemType"], data["ItemId"]);
				btnTrick.SetVisible(myValue >= data["Num"]);
				AddButton(CMD_TRICK_OR_TREAT + "_2", "BtnThoat", 413, 18);
				AddButton(CMD_TRICK_OR_TREAT + "_2", "GuiTrickTreat_BtnTrick", 295, 310);
				var btnTrickZMoney:Button = AddButton(CMD_TRICK_OR_TREAT + "_1", "GuiTrickTreat_BtnTreatZMoney", 70, 310);
				btnTrickZMoney.SetVisible(!btnTrick.img.visible);
				var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["MakeSweet"]["ZMoney"];
				var tfPrice:TextField = AddLabel("", 135, 318, 0xffffff, 1, 0x000000);
				tfPrice.text = Ultility.StandardNumber(price);
				tfPrice.visible = btnTrickZMoney.img.visible;
				//vẽ quà cần cho
				AddImage("", getImageName(data["ItemType"], data["ItemId"]), 236, 180);
				var tfNum:TextField = AddLabel("", 180, 226);
				var fm:TextFormat = new TextFormat("Arial", 16);
				if (myValue >= data["Num"])
				{
					fm.color = 0x008000;
				}
				else
				{
					fm.color = 0xff0000;
				}
				tfNum.defaultTextFormat = fm;
				tfNum.text = Ultility.StandardNumber(myValue) + " / " + Ultility.StandardNumber(data["Num"]);
				//AddLabel("Chỉ còn", 300, 230, 0xffffff, 1, 0x000000);
				tfTime = AddLabel("", 175, 260, 0xfffffff, 1, 0x000000);
				fm = new TextFormat("Arial", 16);
				tfTime.defaultTextFormat = fm;
				tfTime.text = "00:30";
				//AddLabel("để quyết định", 300, 270, 0xffffff, 1, 0x000000);
			}
			LoadRes("GuiTrickTreat_Theme");
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			switch(cmd)
			{
				case CMD_TRICK_OR_TREAT:
					inUpdateGui = false;
					lockTime = -1;
					timeGui = -1;
					var pk:BasePacket;
					var ans:int = int(data[1]);
					if (ans == 1)
					{
						var price:int = ConfigJSON.getInstance().getItemInfo("Param")["Halloween"]["MakeSweet"]["ZMoney"];
						if (!Ultility.payMoney("ZMoney", price))
						{
							break;
						}
						pk = new SendTrickOrTreat(ans, "ZMoney");
					}
					else if (ans == 3)
					{
						var sub:Object = HalloweenMgr.getInstance().dataGhost;
						subtraction(sub["ItemType"], sub["ItemId"], sub["Num"]);
						pk = new SendTrickOrTreat(ans, "");
					}
					else
					{
						pk = new SendTrickOrTreat(ans, "");
					}
					Exchange.GetInstance().Send(pk);
					GuiMgr.getInstance().guiHalloween.inTrickOrTreat = true;
					Hide();
					break;
			}
		}
		
		public function updateGUI(curTime:Number):void 
		{
			if (inUpdateGui)
			{
				if (curTime-timeGui > 1)
				{
					var passTime:int = int(curTime - lockTime);
					var remainTime:int = TIME_WAIT - passTime;
					if (remainTime < 0)
					{
						inUpdateGui = false;
						lockTime = -1;
						timeGui = -1;
						var pk:SendTrickOrTreat = new SendTrickOrTreat(2, "");
						Exchange.GetInstance().Send(pk);
						Hide();
						return;
					}
					tfTime.text = Ultility.convertToTime(remainTime, false);
					timeGui = curTime;
				}
			}
			
		}
		
		private function subtraction(itemType:String, itemId:int, num:int):void 
		{
			switch(itemType)
			{
				case "Money":
					GameLogic.getInstance().user.UpdateUserMoney( -num);
					break;
				case "EnergyItem":
				case "Material":
				case "RankPointBottle":
					GameLogic.getInstance().user.UpdateStockThing(itemType, itemId, -num);
					break;
				case "HalItem":
					HalloweenMgr.getInstance().updateRockStore(itemId, -num);
					GuiMgr.getInstance().guiHalloween.effSubtractRock(itemId, -num);
					GuiMgr.getInstance().guiHalloween.refreshAllTextNumRock();
					break;
				default:
					
			}
		}
		
		private function getMyValue(itemType:String, itemId:int):int
		{
			var myValue:int;
			switch(itemType)
			{
				case "Money":
					myValue = GameLogic.getInstance().user.GetMoney();
					break;
				case "EnergyItem":
				case "Material":
				case "RankPointBottle":
					myValue = GameLogic.getInstance().user.GetStoreItemCount(itemType, itemId);
					break;
				case "HalItem":
					myValue = HalloweenMgr.getInstance().getRockNum(itemId);
					break;
				default:
					myValue = 0;
			}
			return myValue;
		}
		private function getImageName(itemType:String, itemId:int):String
		{
			var szImgName:String;
			switch(itemType)
			{
				case "Money":
					szImgName = "IcGold";
					break;
				case "EnergyItem":
				case "Material":
				case "RankPointBottle":
					szImgName = itemType + itemId;
					break;
				case "HalItem":
					szImgName = "EventHalloween_" + itemType + itemId;
					break;
				default:
					szImgName = "";
			}
			return szImgName;
		}
	}

}





















