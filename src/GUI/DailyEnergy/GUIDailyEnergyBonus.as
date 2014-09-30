package GUI.DailyEnergy 
{
	import Data.Config;
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import Logic.GameLogic;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.GetDailyEnergy;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIDailyEnergyBonus extends BaseGUI 
	{
		private const BTN_CLOSE:String = "BtnThoat";
		private const BTN_GET_GIFT:String = "BtnGetGiftDailyEnergy";
		private var obj:Object;
		
		public function GUIDailyEnergyBonus(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIDailyEnergyBonus";
		}
		override public function InitGUI():void 
		{
			//super.InitGUI();
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				OpenRoomOut();
			}
			
			LoadRes("GuiDailyEnergyBonus_Theme");
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			AddButton(BTN_CLOSE, "BtnThoat", img.width - 28, 36, this);
			AddButton(BTN_GET_GIFT, "GuiDailyEnergyBonus_BtnGetGift", img.width / 2 - 70, img.height - 60, this);
			obj = ConfigJSON.getInstance().GetItemList("Param")["DailyEnergy"];
			
			var imgEXP:Image = AddImage("", obj["Exp"]["ItemType"], 184, 126, true, ALIGN_LEFT_TOP);
			imgEXP.FitRect(40, 40, new Point(137, 138));
			var imgEnergy:Image = AddImage("", "IcEnergy", 210, 140, true, ALIGN_LEFT_TOP);
			imgEnergy.SetScaleXY(1.25);
			
			var txtFormat:TextFormat = new TextFormat("Arial", 16, 0x601020);
			txtFormat.bold = true;
			txtFormat.color = 0xFFFF00;
			txtFormat.size = 16;
			var lbExp:TextField = AddLabel("x" + obj["Exp"]["Num"], 105, 175, 0xFFFF00, 1, 0x26709C);
			var lbEnergy:TextField = AddLabel("x" + obj["Energy"]["Num"], 105 + 67, 175, 0xFFFF00, 1, 0x26709C);
			lbExp.setTextFormat(txtFormat);
			lbEnergy.setTextFormat(txtFormat);
			
			var strLb:String = "Chào mừng bạn đã ghé thăm \n" + GameLogic.getInstance().user.Name;
			var lb:TextField = AddLabel(strLb, 145, 90);
			txtFormat = new TextFormat();
			txtFormat.font = "Arial";
			txtFormat.bold = true;
			txtFormat.size = 16;
			txtFormat.align = "center";
			txtFormat.color = 0x1C688E;
			lb.setTextFormat(txtFormat);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_GET_GIFT:
					HideGUI();
				break;
				default:
					
				break;
			}
		}
		
		private function HideGUI():void 
		{
			Hide();
			AddBonusToStore();
		}
		
		private function AddBonusToStore():void 
		{
			var user:User = GameLogic.getInstance().user;
			var getDailyEnergy:GetDailyEnergy = new GetDailyEnergy(user.Id);
			Exchange.GetInstance().Send(getDailyEnergy);
			var numExp:int = obj["Exp"]["Num"];
			var numEnergy:int = obj["Energy"]["Num"];
			//var typeEnergy:int = obj["Energy"]["ItemId"];
			//user.UpdateStockThing("EnergyItem", typeEnergy, numEnergy);
			if (user.GetMyInfo().NumGetGift == user.GetMyInfo().MaxGetGift - 1)
			{
				GuiMgr.getInstance().guiDailyEnergyBonusFinish.Show(Constant.GUI_MIN_LAYER, 1);
			}
			user.GetMyInfo().DailyEnergy[user.Id.toString()] = true;
			user.GetMyInfo().NumGetGift ++;
			// Effect
			EffectMgr.getInstance().fallFlyXP(Constant.STAGE_WIDTH / 2, Constant.STAGE_HEIGHT / 2, numExp, true);
			GameLogic.getInstance().updateEnergyOver(numEnergy);		
		}
	}

}