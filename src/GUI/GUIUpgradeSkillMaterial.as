package GUI 
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import Logic.GameLogic;
	import Logic.User;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIUpgradeSkillMaterial extends BaseGUI
	{
		public static const BTN_CLOSE:String = "btnClose";
		public static const BTN_FEED:String = "btnFeed";
		public static const BONUS:String = "Bonus";
		public static const ITEM_TYPE:String = "ItemType";
		public static const ITEM_ID:String = "ItemId";
		public static const NUM:String = "Num";
		
		private var bonus:Object;
		
		public function GUIUpgradeSkillMaterial(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIUpgradeSkillMaterial";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(170, 80);
				
				AddButton(BTN_CLOSE, "BtnThoat", 408, 22, this);
				var btnFeed:Button = AddButton(BTN_FEED, "GuiUpgradeSkillMaterial_BtnGreen", 192, 345, this);
				btnFeed.img.width = 109;
				btnFeed.img.height = 34;
				var txtField:TextField = AddLabel("Chia sẻ", 215, 317, 0xFFFF00, 0, 0x000000);
				var format:TextFormat = new TextFormat();
				format.size = 15;
				txtField.setTextFormat(format);
				
				var s:String;
				var x:int = 150;
				var y:int = 210;
				var dx:int = 82;
				var distance:int = 0;
				var strTemp:String = "ép ngư thạch";
				var st:String = "Chúc mừng bạn đã nâng cấp kỹ năng ép ngư thạch thành công!";
				var txtCongrat:TextField = AddLabel(st, 180, 110);
				format = new TextFormat();
				var count:int = 0;
				for (s in bonus) 
				{
					count ++;
				}
				distance = (270 - 70 * count) / count;
				x = 300 - 35 * count - distance / 2 * (count - 1) / 2;
				format.align = "center";
				format.size = 20;
				txtCongrat.width = 340;			
				txtCongrat.wordWrap = true;
				txtCongrat.setTextFormat(format);
				format.color = 0xff0000;
				txtCongrat.setTextFormat(format, st.indexOf(strTemp), st.indexOf(strTemp) + strTemp.length);
				//AddImage("", "imgChosen" + skillName, 212, 140, true, ALIGN_LEFT_TOP);
				//AddImage("", "imgLevel" + skillName, 254, 182, true, ALIGN_LEFT_TOP);
				//AddLabel(userSkill["Level"], 217, 185, 0xffffff);
				for (s in bonus)
				{
					drawGift(bonus[s], x, y);
					x += dx;
				}
				GameLogic.getInstance().user.GetMyInfo().MatPoint = 0;
			}
			LoadRes("GuiUpgradeSkillMaterial_Theme");
		}
		public function setInfo(bonus:Object):void
		{
			this.bonus = bonus;
		}
		private function drawGift(bonus:Object, x:int, y:int):void 
		{	
			var ctn:Container;
			ctn = AddContainer("", "GuiUpgradeSkillMaterial_CtnGiftUpgrade", x, y);
			if(bonus[ITEM_TYPE] == "Material")
			{
				var item_Name_Image:String = bonus[ITEM_ID].toString();
				if (bonus[ITEM_ID] > 100)
				{
					item_Name_Image = (bonus[ITEM_ID] % 100).toString() + "S";
				}
				ctn.AddImage("", bonus[ITEM_TYPE] + item_Name_Image, ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_LEFT_TOP);
			}
			else
			{
				ctn.AddImage("", bonus[ITEM_TYPE] + bonus[ITEM_ID], ctn.img.width / 2, ctn.img.height / 2);
			}
			ctn.AddLabel("x"+bonus[NUM], -14, 50, 0xffffff);
		}
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{
				case BTN_CLOSE:
				{
					Hide();
					if (GuiMgr.getInstance().GuiRawMaterials.IsVisible)
					{
						GuiMgr.getInstance().GuiRawMaterials.Hide();
						GuiMgr.getInstance().GuiRawMaterials.Show(Constant.GUI_MIN_LAYER, 6);
					}
					break;					
				}
				case BTN_FEED:
				{
					if (GuiMgr.getInstance().GuiRawMaterials.IsVisible)
					{
						GuiMgr.getInstance().GuiRawMaterials.Hide();
						GuiMgr.getInstance().GuiRawMaterials.Show(Constant.GUI_MIN_LAYER, 6);
					}
					feed();
					break;
				}
			}
		}
		public function feed():void 
		{
			var user:User = GameLogic.getInstance().user;
			GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_UPGRADE_SKILL_MATERIAL, user.GetMyInfo().MatLevel.toString());
			this.Hide();
		}
	}

}