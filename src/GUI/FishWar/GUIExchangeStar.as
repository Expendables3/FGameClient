package GUI.FishWar 
{
	import com.bit101.components.Text;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.Fish;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendExchangeStar;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUIExchangeStar extends BaseGUI 
	{
		public static const BTN_CLOSE:String = "BtnClose";
		public static const BTN_SHARE:String = "BtnShare";
		public var bonus:Object;
		public var numStar:int;
		
		public function GUIExchangeStar(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIExchangeStar";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(125, 40);
				
				// Gửi gói tin đổi quà event cá lính lên
				ClearComponent();
				
				AddImage("", "GuiExchangeStar_TitleEventFishWar", 250, 33);
				
				AddButtons();
				var cmd:SendExchangeStar = new SendExchangeStar();
				Exchange.GetInstance().Send(cmd);

				AddReward();
			}			
			LoadRes("GuiExchangeStar_Theme");	
		}
		
		public function Init():void
		{
			// số sao thu thập được
			numStar = GameLogic.getInstance().user.GetMyInfo().EventInfo["SoldierEvent"]["LuckyStar"];
			if (numStar >= 1)
			{
				this.Show(Constant.GUI_MIN_LAYER, 5);
			}
		}
		
		public function AddReward():void
		{
			var cfg:Object = ConfigJSON.getInstance().GetSoldierEventConfig("ChangeStar");
			var myInfo:Object = GameLogic.getInstance().user.GetMyInfo().EventInfo["SoldierEvent"];
			for (var i:int = 1; i <= 4; i++)
			{
				if (myInfo["LuckyStar"] >= cfg[String(i)]["StarNum"])
				{
					bonus = cfg[String(i)]["bonus"];
				}
				else
				{
					break;
				}
			}
			
			var tt:TooltipFormat;
			var ctn:Container = AddContainer("", "GuiExchangeStar_ImgBgGiftSpecial", 278, 222);
			ctn.SetScaleXY(1.8);
		
			var info:Object;
			if (bonus["FormulaType"])
			{
				info = ConfigJSON.getInstance().getItemInfo("MixFormula", -1)[bonus["FormulaType"]][bonus["ItemId"]];
				//ctn.AddImage("", Fish.ItemType + info.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 0, 0).FitRect(50, 50, new Point(5, 5));
				//tt = new TooltipFormat();
				//tt.text = Localization.getInstance().getString(Fish.ItemType + info.FishTypeId);
				ctn.AddImage("", "GuiExchangeStar_SpecialGiftEventFishWar", 0, 0).FitRect(50, 50, new Point(5, 5));
				tt = new TooltipFormat();
				tt.text = "Võ Lâm Ngư";
			}
			else
			{
				info = ConfigJSON.getInstance().getItemInfo("MixFormula", -1)[bonus["ItemType"]][bonus["ItemId"]];
				ctn.AddImage("", "GuiExchangeStar_FormulaDefault" + bonus.ItemType, 0, 0).FitRect(50, 50, new Point(5, 5));
				tt = new TooltipFormat();
				tt.text = Localization.getInstance().getString(bonus.ItemType);
			}
			
			ctn.setTooltip(tt);
			// Add NPC
			AddImage("", "NPC_Mermaid_War", 60, 105, true, ALIGN_LEFT_TOP);
			
			// Add thêm câu cú
			var tF:TextFormat = new TextFormat();
			var txtF: TextField = AddLabel("Bạn đã sưu tập được:  " + myInfo["LuckyStar"], 260, 100, 0xFFF100, 1, 0x603813);
			tF.size = 16;
			txtF.setTextFormat(tF);
			txtF = AddLabel("Chúc mừng bạn nhận được:", 280, 140, 0xFFF100, 1, 0x603813);
			txtF.setTextFormat(tF);
			//txtF = AddLabel(Localization.getInstance().getString("Fish" + info.FishTypeId), 280, 180, 0xFFF100, 1, 0x603813);
			//tF.size = 20;
			//txtF.setTextFormat(tF);
			
			AddImage("", "GuiExchangeStar_LuckyStar",  435, 110).SetScaleXY(0.8);
			
			// Xóa event
			delete(GameLogic.getInstance().user.GetMyInfo().EventInfo["SoldierEvent"]);

			// Cập nhật vào kho
			if (numStar >= 7)
			{
				GameLogic.getInstance().user.GenerateNextID();
			}
			else
			{
				GuiMgr.getInstance().GuiStore.UpdateStore(bonus.ItemType, bonus.ItemId, bonus.Num);
			}
		}
		
		public function AddButtons():void
		{
			AddButton(BTN_CLOSE, "BtnThoat", 543, 21);
			AddButton(BTN_SHARE, "BtnFeed", 280, 390);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE:
					this.Hide();
					break;
				case BTN_SHARE:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed("EventFishWar");
					this.Hide();
					break;
			}
		}
	}

}