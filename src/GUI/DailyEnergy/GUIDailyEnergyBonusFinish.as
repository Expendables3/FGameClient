package GUI.DailyEnergy 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIDailyEnergyBonusFinish extends BaseGUI 
	{
		private const BTN_CLOSE:String = "BtnThoat";
		private const BTN_GET_GIFT:String = "BtnGetGiftDailyEnergy";
		private var obj:Object;
		
		public function GUIDailyEnergyBonusFinish(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIDailyEnergyBonusFinish";
		}
		
		override public function InitGUI():void 
		{
			//super.InitGUI();
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				OpenRoomOut();
			}
			LoadRes("GuiDailyEnergyBonusFinish_Theme");
		}
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			AddButton(BTN_CLOSE, "BtnThoat", img.width - 28, 36, this);
			AddButton(BTN_GET_GIFT, "GuiDailyEnergyBonusFinish_BtnGetGift", img.width / 2 - 70, img.height - 60, this);
			obj = ConfigJSON.getInstance().GetItemList("Param")["DailyEnergy"]["Special"];
			
			//var imgGift:Image = AddImage("", obj["ItemType"] + obj.ItemId, 0, 0, true, ALIGN_LEFT_TOP);
			var imgGift:Image = AddImage("", "IcEnergy", 0, 0, true, ALIGN_LEFT_TOP);
			imgGift.FitRect(60, 60, new Point(155, 130));
			
			var txtFormat:TextFormat = new TextFormat("Arial", 15, 0x601020);
			txtFormat.bold = true;
			txtFormat.color = 0xFFFF00;
			txtFormat.size = 16;
			var lbGift:TextField = AddLabel("x" + obj["Num"], 135, 178, 0xFFFF00, 1, 0x26709C);
			lbGift.setTextFormat(txtFormat);
			
			var strLb:String = "Chúc mừng bạn đã qua đủ 30 nhà bạn\nBạn nhận được:";
			var lb:TextField = AddLabel(strLb, 145, 90);
			txtFormat = new TextFormat();
			txtFormat.font = "Arial";
			txtFormat.bold = true;
			txtFormat.size = 15;
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
				case BTN_GET_GIFT:
					HideGUI();
				break;
			}
		}
		
		private function HideGUI():void 
		{
			//if (GuiMgr.getInstance().GuiStore.IsVisible)
			//{
				//GuiMgr.getInstance().GuiStore.UpdateStore(obj.ItemType, obj.Id, obj.Num);
			//}
			//else 
			//{
				//GameLogic.getInstance().user.UpdateStockThing(obj.ItemType, obj.Id, obj.Num);
			//}
			GameLogic.getInstance().updateEnergyOver(int(obj["Num"]));	
			GuiMgr.getInstance().GuiMessageBox.ShowOK(	"Bạn đã nhận hết số lượng quà trong ngày rồi. Hãy quay lại vào ngày mai nhé ^_^", 
														310, 200, GUIMessageBox.NPC_MERMAID_NORMAL);
			Hide();
		}
	}

}