package GUI.FishWorld 
{
	import adobe.utils.CustomActions;
	import Data.ConfigJSON;
	import Data.Localization;
	import fl.controls.Button;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.FishWorld.Network.SendJoinSeaAgain;
	import GUI.GuiMgr;
	import Logic.FallingObject;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIWaitReJoinMap extends BaseGUI 
	{
		public static const MAX_JOIN_SEA_A_DAY:int = 11;
		private var seaId:int;
		private var numZXu:int;
		private var numLoggedIn:int;
		private var txtTimeWait:TextField;
		private var hour:int;
		private var min:int;
		private var sec:int;
		private var numSecWait:int;
		private var numMinWait:int;
		
		private var lastJoinTime:Number;
		
		public const IMG_OCEAN_SEA:String = "ImgOceanSea";
		public const BTN_CLOSE:String = "BtnClose";
		public const BTN_RELOG:String = "BtnReLog";
		public const CTN_RELOG_BY_G:String = "BtnReLogByG";
		
		private var isRequestURejoin:Boolean = false;
		
		public function GUIWaitReJoinMap(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiWaitReJoinMap";
		}
		override public function InitGUI():void 
		{
			//super.InitGUI();
			this.setImgInfo = function():void
			{
				SetPos(120, 100);
				AddImage(IMG_OCEAN_SEA, "GuiWaitRejoinMap_ImgOceanSea" + seaId, 200 + 175 / 2, 187);
				AddButton(BTN_CLOSE, "BtnThoat", img.width - 20, 0, this);
				var txtNumLogIn:TextField = AddLabel(Localization.getInstance().getString("FishWorldMsg5") + " " + numLoggedIn, 235, 23);
				var fm:TextFormat = new TextFormat(null, 20, 0x990000, true);
				txtNumLogIn.setTextFormat(fm);
				var txtLabelTimeWait:TextField = AddLabel(Localization.getInstance().getString("FishWorldMsg6"), 150, 330);
				fm = new TextFormat(null, 16, 0x990000, true);
				txtLabelTimeWait.setTextFormat(fm);
				var txtLabelGoNow:TextField = AddLabel(Localization.getInstance().getString("FishWorldMsg7"), 310, 330);
				txtLabelGoNow.setTextFormat(fm);
				var txtCostGoNow:TextField = AddLabel(numZXu.toString(), 298, 355);
				txtCostGoNow.setTextFormat(fm);
				AddImage("", "IcZingXu", 367, 365);
				
				//numSecWait = getTimeWait();
				sec = numSecWait % 60;
				numMinWait = (numSecWait - sec) / 60;
				min = numMinWait % 60;
				hour = numMinWait / 60;
				var strHour:String;
				var strMin:String;
				var strSec:String;
				if (hour < 10)	strHour = "0" + hour.toString();
				else strHour = hour.toString();
				if (min < 10)	strMin = "0" + min.toString();
				else strMin = min.toString();
				if (sec < 10)	strSec = "0" + sec.toString();
				else strSec = sec.toString();
				txtTimeWait = AddLabel(strHour + ":" + strMin + ":" + strSec, 150, 355);
				fm = new TextFormat(null, 16, 0x990000, true);
				txtTimeWait.setTextFormat(fm);
				txtTimeWait.defaultTextFormat = fm;
				
				var btn:GUI.component.Button = AddButton(BTN_RELOG, "GuiWaitRejoinMap_BtnBuyG", 163, 385);
				fm = new TextFormat(null, null, 0xffffff,true);
				AddLabel("Vào", 150, 385).setTextFormat(fm);
				if (numSecWait > 0)
				{
					btn.SetDisable();
				}
				
				var ctn:Container = AddContainer(CTN_RELOG_BY_G, "GuiWaitRejoinMap_ImgFrameFriend", 315, 385, true, this);
				ctn.AddButton("", "GuiWaitRejoinMap_BtnBuyG", 0, 0);
				fm = new TextFormat(null, null, 0xffffff,true);
				ctn.AddLabel("Vào ngay", -18, 0).setTextFormat(fm);
				ctn.AddImage("", "IcZingXu", 73, 10);
			}
			LoadRes("GuiWaitRejoinMap_Theme");
		}
		public function UpdateGUI():void 
		{
			if(!isRequestURejoin)
			{
				var curTimeNow:Number = GameLogic.getInstance().CurServerTime;
				if (curTimeNow - lastJoinTime >= 1)
				{
					if(numSecWait > 0)
					{
						lastJoinTime = int(curTimeNow);
						numSecWait--;
						sec = numSecWait % 60;
						numMinWait = (numSecWait - sec) / 60;
						min = numMinWait % 60;
						hour = numMinWait / 60;			
						var strHour:String;
						var strMin:String;
						var strSec:String;
						if (hour < 10)	strHour = "0" + hour.toString();
						else strHour = hour.toString();
						if (min < 10)	strMin = "0" + min.toString();
						else strMin = min.toString();
						if (sec < 10)	strSec = "0" + sec.toString();
						else strSec = sec.toString();
						txtTimeWait.text = strHour + ":" + strMin + ":" + strSec;
					}
					else if(numSecWait == 0)
					{
						GetButton(BTN_RELOG).SetEnable();
						numSecWait --;
					}
				}
			}
		}
		override public function OnHideGUI():void 
		{
			super.OnHideGUI();
			isRequestURejoin = false;
		}
		public function Init(SeaId:int, NumLogIn:int, LastTimeJoin:Number, NumZXu:int):void 
		{
			seaId = SeaId;
			numLoggedIn = NumLogIn;
			lastJoinTime = Math.ceil(LastTimeJoin);
			numZXu = NumZXu;
			
			var curServerTime:Number = GameLogic.getInstance().CurServerTime;
			var deltaTime:Number = curServerTime - lastJoinTime;
			var obj:Object = ConfigJSON.getInstance().GetItemList("Param");
			var objJoinSeaTime:Object = obj.JoinSeaTime;
			var objJoinSeaZingxu:Object = obj.JoinSeaZingxu;
			var numSec:int = objJoinSeaTime[(NumLogIn + 1).toString()];
			numSecWait = numSec - Math.max(deltaTime - 5, 0);
			
			Show(Constant.GUI_MIN_LAYER, 1);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var ZXuUser:int = GameLogic.getInstance().user.GetZMoney();
			var cmd:SendJoinSeaAgain;
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_CLOSE:
					GuiMgr.getInstance().GuiMapOcean.isComingOcean = false;
					Hide();
				break;
				case BTN_RELOG:
					if(!isRequestURejoin)
					{
						GetButton(BTN_CLOSE).SetDisable();
						isRequestURejoin = true;
						cmd = new SendJoinSeaAgain(seaId, "");
						Exchange.GetInstance().Send(cmd);
					}
				break;
				case CTN_RELOG_BY_G:
					if(!isRequestURejoin)
					{
						if (ZXuUser < numZXu)
						{
							GuiMgr.getInstance().GuiNapG.Init();
							var posStart:Point = GameInput.getInstance().MousePos;
							Ultility.ShowEffText("Bạn không đủ xu để thực hiện\nHãy nạp thêm nhé", GetContainer(CTN_RELOG_BY_G).img, posStart,
								new Point(posStart.x, posStart.y - 100));
						}
						else
						{
							GetButton(BTN_CLOSE).SetDisable();
							isRequestURejoin = true;
							cmd = new SendJoinSeaAgain(seaId, "ZMoney");
							Exchange.GetInstance().Send(cmd);
							GameLogic.getInstance().user.UpdateUserZMoney( -numZXu);
						}
					}
				break;
				default:
					
				break;
			}
		}
	}

}