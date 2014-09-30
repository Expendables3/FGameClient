package Logic 
{
	import com.bit101.components.NumericStepper;
	import Data.BitmapMovie;
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.ActiveTooltip;
	import GUI.component.TooltipFormat;
	import GUI.GUIEnergyMachine;
	import GUI.GuiMgr;
	import NetworkPacket.PacketSend.SendExpiredEnergyMachine;
	/**
	 * ...
	 * @author HiepGa
	 */
	public class EnergyMachine extends BaseObject 
	{
		public var ExpiredTime:Number;						//khoảng thời gian để hết xăng
		public var StartTime:Number;						//thời gian bắt đầu đổ xăng
		public var Id:int;
		public var IsExpired:Boolean;						//đã hết xăng hay chưa
		
		public static const _x:int = 500;
		public static const _y:int = 300;
		
		public static const DELTA_TIME:int = -5;
		
		public var dateConLai:String = "";						//khoảng thời gian còn lại
		public function EnergyMachine(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			this.ClassName = "EnergyMachine";
		}
		//các hành động với chuột
		public override function OnMouseOver(event:MouseEvent):void
		{
			SetHighLight(0xFFFF32);
			
			var tooltip:TooltipFormat;
			tooltip = new TooltipFormat();
			if (ExpiredTime > 0)
			{
				tooltip.text = "Máy gia tăng giới hạn năng lượng\nTăng mức giới hạn thêm " + ConfigJSON.getInstance().GetItemList("Param").EnergyMachine+ " năng lượng\n Thời gian còn lại: ";
				tooltip.text += CountDateConLai();
			}
			else
			{
				tooltip.text = "Máy gia tăng giới hạn năng lượng\nTăng mức giới hạn thêm "+ ConfigJSON.getInstance().GetItemList("Param").EnergyMachine+ " năng lượng\n Thời gian còn lại: 0 ngày";
			}
			ActiveTooltip.getInstance().showNewToolTip(tooltip, this.img);
			
		}
		
		public override function OnMouseOut(event:MouseEvent):void
		{
			SetHighLight( -1);
			ActiveTooltip.getInstance().clearToolTip();
		}
		
		public override function OnMouseClick(event:MouseEvent):void
		{
			//thực hiện hiển thị bảng PopUp giới thiệu và đổ xăng
			var myId:Number = GameLogic.getInstance().user.GetMyInfo().Id;
			var uId:Number = GameLogic.getInstance().user.Id;
			if (myId == uId)
			{
				GuiMgr.getInstance().GuiEnergyMachine.ShowPetrol();
				//if (IsExpired) 
				//{
					//if (GameLogic.getInstance().user.GetStoreItemCount("Petrol", 1) > 0)
						//GuiMgr.getInstance().GuiEnergyMachine.GetButton(GUIEnergyMachine.ID_BTN_DO_XANG).SetEnable(true);
					//else
						//GuiMgr.getInstance().GuiEnergyMachine.GetButton(GUIEnergyMachine.ID_BTN_DO_XANG).SetEnable(false);
				//}
				//else
					//GuiMgr.getInstance().GuiEnergyMachine.GetButton(GUIEnergyMachine.ID_BTN_DO_XANG).SetEnable(false);
				var timeConlai:String = CountDateConLai();
				var textLbl:TextField = GuiMgr.getInstance().GuiEnergyMachine.AddLabel(CountDateConLai(), 290, 140);
				var format:TextFormat = new TextFormat();
				format.bold = true;
				format.color = 0xFF0000;
				format.size = 16;
				textLbl.setTextFormat(format);
			}
			
		}
		override public function SetInfo(data:Object):void 
		{
			super.SetInfo(data);
			this.SetScaleXY(0.8);
			SetInterface();
		}
		public function CountDateConLai():String
		{
			if (IsExpired)
			{
				result = "Đã hết hạn";
			}
			var currentTime:Number = GameLogic.getInstance().CurServerTime;
			var timeConlai:Number = this.StartTime + this.ExpiredTime-currentTime;
			
			var result:String = Math.ceil(timeConlai / 86400).toString() + " ngày";
			if (result == "0 ngày") result = "Đã hết hạn";
			if (Math.ceil(timeConlai / 86400) <= 1 && Math.ceil(timeConlai / 86400) > 0) 
			{
				var h:int = timeConlai / 3600;
				var min:int = (timeConlai - h * 3600) / 60;
				var sec:int = (timeConlai - h * 3600 - min * 60);
				result = h + ":" + min + ":" + sec;
			}
			if (StartTime == 0) result = "Đã hết hạn";
			return result;
		}
		/**
		 * thực hiện update liên tục về máy năng lượng, xét xem nó đã hết hạn chưa để đưa ra hành động: thực hiện cho cả máy của mình và bạn
		 */
		
		public function GetTimeRemain():Number
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			return (StartTime + ExpiredTime-curTime);
		}
		public function UpdateEnergyMachine(isMine:Boolean):void
		{
			var currentTime:Number = GameLogic.getInstance().CurServerTime;
			var timeConlai:Number = this.StartTime + this.ExpiredTime-currentTime;
			if (timeConlai < 0 && !IsExpired)//đến lúc hết hạn xăng
			{
				var id:int = GameLogic.getInstance().user.Id;
				var cmd:SendExpiredEnergyMachine = new SendExpiredEnergyMachine(id);
				Exchange.GetInstance().Send(cmd);
				IsExpired = true;
				StartTime = 0;
				ExpiredTime = 0;
				if (isMine)
				{
					GameLogic.getInstance().user.GetMyInfo().IsExpiredMachine = IsExpired;
					//GuiMgr.getInstance().GuiTopInfo.upadateMaxEnergy();
					GameLogic.getInstance().user.GetMyInfo().StartTimeEnergyMachine = 0;
					GameLogic.getInstance().user.GetMyInfo().ExpiredTimeEnergyMacnine = 0;
				}
				GameLogic.getInstance().user.updateBonusMachine(isMine);
				var iCurEnergy:int = GameLogic.getInstance().user.GetEnergy();
				var maxEnergy:int = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel());
				//GuiMgr.getInstance().GuiTopInfo.SuggestEnergyTooltip(iCurEnergy, maxEnergy);
				//GuiMgr.getInstance().guiFrontScreen.updateEnergy(iCurEnergy, maxEnergy);
				GuiMgr.getInstance().guiUserInfo.energy = iCurEnergy;
				SetInterface();
			}
		}
		public function SetInterface():void
		{
			ClearImage();
			if (IsExpired)//hết hạn
			{
				LoadRes("MayBuffExpired");
			}
			else	//còn hạn
			{
				LoadRes("MayBuff");
			}
			SetScaleXY(0.8);
		}
	}
}