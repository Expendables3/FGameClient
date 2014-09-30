package GUI.Reputation 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GuiFameInfo extends BaseGUI 
	{		
		private var fameLevel:int;
		private var famePoint:int;
		private var fameConf:Object;
		private var buffConf:Object;
		
		public function GuiFameInfo(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);			
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				this.img.mouseChildren = false;
				this.img.mouseEnabled = false;
				SetPos(222, 402);
				addContent();
				OpenRoomOut();
			}
			
			LoadRes("GuiReputation_guiFameInfo");
		}
		
		private function addContent():void 
		{
			// cấp hiện tại
			var fm:TextFormat = new TextFormat();
			fm.bold = true;
			fm.size = 14;
			fm.font = "arial";
			var x:int = 60;
			var y:int = 120;
			var dmg:int = buffConf[fameLevel]['Damage'];
			var def:int = buffConf[fameLevel]['Defence'];
			var cri:int = buffConf[fameLevel]['Critical'];
			var vit:int = buffConf[fameLevel]['Vitality'];
			AddLabel("Công", x, y + 15*0, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("Thủ", x, y + 15*1, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("Chí mạng", x, y + 15*2, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("Máu", x, y + 15*3, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(dmg), x + 120, y + 15*0, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(def), x + 120, y + 15*1, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(cri), x + 120, y + 15*2, 0x00ff00, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(vit), x + 120, y + 15*3, 0x00ff00, 0).setTextFormat(fm);
			
			fm.size = 11;
			fm.align = "center";
			var titlePresent:TextField = AddLabel(Localization.getInstance().getString("Reputation_present" + fameLevel), 25, 55, 0xffff00, 0);
			titlePresent.setTextFormat(fm);
			titlePresent.width = 240;
			titlePresent.wordWrap = true;
			AddLabel("Tăng chỉ số của toàn bộ Ngư Thủ trong hồ", 97, 100, 0xcccccc, 1).setTextFormat(fm);
			AddLabel("Mất "+ Ultility.StandardNumber(fameConf[fameLevel]["SubtractPoint"]) + " điểm uy danh vào 0h hàng ngày", 97, 190, 0xff0000, 1, 0xffffff).setTextFormat(fm);
			
			fm.size = 15;
			AddImage("", "GuiReputation_fameName" + fameLevel, 150, 25, true, ALIGN_LEFT_TOP).SetScaleXY(0.8);
			
			if (fameConf[fameLevel + 1] == null)
			{
				return;
			}
			// cấp tiếp theo
			x = 345;
			dmg = buffConf[fameLevel + 1]['Damage'];
			def = buffConf[fameLevel + 1]['Defence'];
			cri = buffConf[fameLevel + 1]['Critical'];
			vit = buffConf[fameLevel + 1]['Vitality'];
			var color:uint = 0x00aa00;
			AddLabel("Công", x, y + 15*0, color, 0).setTextFormat(fm);
			AddLabel("Thủ", x, y + 15*1, color, 0).setTextFormat(fm);
			AddLabel("Chí mạng", x, y + 15*2, color, 0).setTextFormat(fm);
			AddLabel("Máu", x, y + 15*3, color, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(dmg), x + 120, y + 15*0, color, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(def), x + 120, y + 15*1, color, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(cri), x + 120, y + 15*2, color, 0).setTextFormat(fm);
			AddLabel("+" + Ultility.StandardNumber(vit), x + 120, y + 15*3, color, 0).setTextFormat(fm);
			
			fm.size = 11;
			fm.align = "center";
			var titlePresentNext:TextField = AddLabel(Localization.getInstance().getString("Reputation_present" + (fameLevel + 1)), 318, 55, 0xffff00, 0);
			titlePresentNext.setTextFormat(fm);
			titlePresentNext.width = 240;
			titlePresentNext.wordWrap = true;
			AddLabel("Tăng chỉ số của toàn bộ Ngư Thủ trong hồ", 390, 100, 0x999999, 1).setTextFormat(fm);
			AddLabel("Mất "+ Ultility.StandardNumber(fameConf[fameLevel + 1]["SubtractPoint"]) + " điểm uy danh vào 0h hàng ngày", 390, 190, 0xff0000, 1).setTextFormat(fm);
			
			fm.size = 15;
			
			AddImage("", "GuiReputation_fameName" + (fameLevel + 1), 450, 25, true, ALIGN_LEFT_TOP).SetScaleXY(0.8);
		}
		
		public function showGui():void
		{
			fameLevel = GameLogic.getInstance().user.getReputationLevel();
			famePoint = GameLogic.getInstance().user.getReputationPoint();
			fameConf = ConfigJSON.getInstance().getItemInfo("ReputationInfo");
			buffConf = ConfigJSON.getInstance().getItemInfo("ReputationBuff");
			
			Show(Constant.GUI_MIN_LAYER);
		}
	}

}