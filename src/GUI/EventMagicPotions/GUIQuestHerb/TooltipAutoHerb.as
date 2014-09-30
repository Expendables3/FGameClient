package GUI.EventMagicPotions.GUIQuestHerb 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.EventMagicPotions.NetworkPacket.SendAutoDoneHerbQuest;
	import GUI.EventMagicPotions.QuestHerbMgr;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * Tooltip lam` nhanh va` nhieu` lan`
	 * @author longpt
	 */
	public class TooltipAutoHerb extends BaseGUI 
	{
		private const BTN_THOAT:String = "BtnThoat";
		private const BTN_AUTO_10:String = "BtnAuto10";
		private const BTN_AUTO_100:String = "BtnAuto100";
		
		private var herbId:int;
		private var cfg:Object;
		
		public function TooltipAutoHerb(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_RIGHT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUITooltipAuto";
		}
		
		public override function InitGUI() :void
		{
			LoadRes("GuiQuestHerb_TooltipAuto");
			cfg = ConfigJSON.getInstance().GetItemList("MagicPotion_QuickDoneQuest")[herbId];
			RefreshContent(herbId);
		}
		
		public function Init(herbId:int, pos:Point):void
		{
			this.herbId = herbId;
			Show(Constant.GUI_MIN_LAYER, 2);
			SetPos(pos.x - 270, pos.y);
		}
		
		public function RefreshContent(id:int):void
		{
			ClearComponent();
			herbId = id;
			AddButton(BTN_THOAT, "BtnThoat", this.img.width - 23, 0);
			
			var txtF:TextFormat = new TextFormat();
			txtF.size = 15;
			
			var btn:Button = AddButton(BTN_AUTO_10, "Btngreen", 50, 160);
			btn.img.scaleX = 0.6;
			btn.img.scaleY = 0.7;
			AddImage("", "IcZingXu", 103, 143).SetScaleXY(1.3);
			AddLabel(cfg["10"]["ZMoney"] + "", 65, 137, 0xffffff, 0, 0x000000).setTextFormat(txtF);
			
			btn = AddButton(BTN_AUTO_100, "Btngreen", 200, 160);
			btn.img.scaleX = 0.6;
			btn.img.scaleY = 0.7;
			AddImage("", "IcZingXu", 253, 143).SetScaleXY(1.3);
			AddLabel(cfg["100"]["ZMoney"] + "", 210, 137, 0xffffff, 0, 0x000000).setTextFormat(txtF);
			
			var x0:int = 183;
			var y0:int = 80;
			var dx:int = 30;
			var dy:int = 0;
			var ddx:int = 5;
			for (var i:int = 0; i < herbId; i++)
			{
				AddImage("", "GuiQuestHerb_QuestStar", x0 + i * dx + (3 - herbId) * ddx, y0 + i * dy);
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			var gift:Object;
			var cost:int;
			switch (buttonID)
			{
				case BTN_THOAT:
					this.Hide();
					break;
				case BTN_AUTO_10:
					cost = cfg["10"]["ZMoney"];
					if (GameLogic.getInstance().user.GetZMoney() < cost)
					{
						GuiMgr.getInstance().GuiNapG.Init();
						return;
					}
					
					// Cmd
					var cmd:SendAutoDoneHerbQuest = new SendAutoDoneHerbQuest(herbId, 10);
					Exchange.GetInstance().Send(cmd);
					
					// Effect
					gift = cfg["10"]["Gift"];
					EffectMgr.setEffBounceDown("Tự động hoàn thành!", gift["ItemType"] + gift["ItemId"], 330, 280, null, gift["Num"]);
					
					// AddStore
					GuiMgr.getInstance().GuiStore.UpdateStore(gift["ItemType"], gift["ItemId"], gift["Num"]);
					
					// UpdateUserZMoney
					GameLogic.getInstance().user.UpdateUserZMoney( -cost);
					
					UpdateMixArea();
					break;
				case BTN_AUTO_100:
					cost = cfg["100"]["ZMoney"];
					if (GameLogic.getInstance().user.GetZMoney() < cost)
					{
						GuiMgr.getInstance().GuiNapG.Init();
						return;
					}
					
					// Cmd
					var cmd1:SendAutoDoneHerbQuest = new SendAutoDoneHerbQuest(herbId, 100);
					Exchange.GetInstance().Send(cmd1);
					
					// Effect
					gift = cfg["100"]["Gift"];
					EffectMgr.setEffBounceDown("Tự động hoàn thành!", gift["ItemType"] + gift["ItemId"], 330, 280, null, gift["Num"]);
					
					// AddStore
					GuiMgr.getInstance().GuiStore.UpdateStore(gift["ItemType"], gift["ItemId"], gift["Num"]);
					
					// UpdateUserZMoney
					GameLogic.getInstance().user.UpdateUserZMoney( -cost);
					
					UpdateMixArea();
					break;
			}
			
		}
		
		private function UpdateMixArea():void
		{
			var ctnList:Array = GuiMgr.getInstance().GuiQuestHerb.GetMixAreaList();
			for (var i:int = 0; i < ctnList.length; i++)
			{
				(ctnList[i] as MixAreaContainer).RefreshContent();
			}
		}
	}

}