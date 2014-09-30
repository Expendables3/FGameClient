package GUI.Reputation 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GuiFameUp extends BaseGUI 
	{
		private static const BTN_FEED:String = "BtnFeed";
		
		private var fameLevel:int;		
		private var fameConf:Object;
		private var buffConf:Object;
		
		public function GuiFameUp(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				addContent();
				OpenRoomOut();
			}
			
			LoadRes("GuiReputation_guiFameUp");
		}
		
		private function addContent():void 
		{
			AddButton(BTN_FEED, "GuiReputation_btnFeed", 143, 260, this);
			
			var fm:TextFormat = new TextFormat();
			fm.bold = true;
			fm.size = 11;
			fm.font = "arial";
			var dmg:int = buffConf[fameLevel]['Damage'];
			var def:int = buffConf[fameLevel]['Defence'];
			var cri:int = buffConf[fameLevel]['Critical'];
			var vit:int = buffConf[fameLevel]['Vitality'];
			var x:int = 90;
			var y:int = 180;
			AddLabel("Công", x, y + 15*0, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("Thủ", x, y + 15*1, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("Chí mạng", x, y + 15*2, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("Máu", x, y + 15*3, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(dmg), x + 100, y + 15*0, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(def), x + 100, y + 15*1, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(cri), x + 100, y + 15*2, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(vit), x + 100, y + 15*3, 0x00ff00, 0).setTextFormat(fm);
			
			fm.size = 11;
			fm.align = "center";
			AddLabel("Tăng chỉ số của toàn bộ Ngư Thủ trong hồ", 125, 160, 0xffff00, 1).setTextFormat(fm);
			//AddLabel("Mất 500 điểm uy danh vào 0h hàng ngày", 90, 190, 0xff0000, 1, 0xffffff).setTextFormat(fm);
			
			AddImage("", "GuiReputation_fameName" + (fameLevel), 180, 110, true, ALIGN_LEFT_TOP);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_FEED:
					var fishSoldier:FishSoldier;					
					var arrSoldier:Array = GameLogic.getInstance().user.GetFishSoldierArr();
					for (var i:int = 0; i < arrSoldier.length; i++)
					{
						fishSoldier = arrSoldier[i];
						fishSoldier.updateReputation();
					}
					GuiMgr.getInstance().GuiFeedWall.ShowFeed("ReputationUp" + fameLevel);
					Hide();
					break;
			}
		}
		
		public function showGui():void 
		{
			fameLevel = GameLogic.getInstance().user.GetMyInfo().ReputationLevel;
			fameConf = ConfigJSON.getInstance().getItemInfo("ReputationInfo");
			buffConf = ConfigJSON.getInstance().getItemInfo("ReputationBuff");
			Show(Constant.GUI_MIN_LAYER, 1);
		}
		
	}

}