package GUI 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.MateFish.ItemSkill;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author 
	 */
	public class GUIUpgradeSkill extends BaseGUI 
	{
		public static const BTN_CLOSE:String = "btnClose";
		public static const BTN_FEED:String = "btnFeed";
		public static const BONUS:String = "Bonus";
		public static const ITEM_TYPE:String = "ItemType";
		public static const ITEM_ID:String = "ItemId";
		public static const NUM:String = "Num";
		
		private var skillName:String;
		
		public function GUIUpgradeSkill(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIUpgradeSkill";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				SetPos(170, 80);
				
				AddButton(BTN_CLOSE, "BtnThoat", 410, 18, this);
				
				var btnFeed:Button = AddButton(BTN_FEED, "BtnFeed", 188, 309, this);			
				btnFeed.img.width = 109;
				btnFeed.img.height = 34;
				
				//var btnFeed:Button = AddButton(BTN_FEED, "BtnFeed", 192, 345, this);			
				//btnFeed.img.width = 109;
				//btnFeed.img.height = 34;
			}
			LoadRes("GuiUpgradeSkill_Theme");
		}
		
		public function UpdateGiftToStore(Gift:Object):void 
		{
			for (var s:String in Gift)
			{
				var mat:Array = GameLogic.getInstance().user.StockThingsArr.Material;
				GameLogic.getInstance().user.UpdateStockThing(Gift[s]["ItemType"], int(Gift[s]["ItemId"]), int(Gift[s]["Num"]));
				
			}
		}
		
		public function UpdateArrMat(useSlot:Array, arrMat:Array):Array
		{
			var i:int = 0;
			for (i = 0; i < useSlot.length; i++) 
			{
				if (useSlot[i] > 0)
				{
					var type:int = useSlot[i];
					type = int(type / 100) + (type % 100 - 1) * 2
					arrMat[type] --;
				}
			}
			return arrMat;
		}
		
		public function setInfo(skillName:String):void
		{
			this.skillName = skillName;
			var userSkill:Object = GameLogic.getInstance().user.GetMyInfo().Skill[skillName];
			var objSkill:Object = ConfigJSON.getInstance().getItemInfo(skillName, userSkill["Level"]);
			var bonus:Object = objSkill["Bonus"];
			UpdateGiftToStore(bonus);
			var s:String;
			var x:int = 252;
			var y:int = 233;
			var dx:int = 82;
			
			var nameSkill:String = Localization.getInstance().getString(skillName);
			var st:String = "Chúc mừng bạn đã nâng cấp " + nameSkill + " thành công!";
			var txtCongrat:TextField = AddLabel(st, 210, 70);
			var format:TextFormat = new TextFormat();
			format.align = "center";
			format.size = 15;
			txtCongrat.width = 340;			
			txtCongrat.wordWrap = true;
			txtCongrat.setTextFormat(format);
			format.color = 0xff0000;
			txtCongrat.setTextFormat(format, st.indexOf(nameSkill), st.indexOf(nameSkill) + nameSkill.length);
			
			AddImage("", "GuiUpgradeSkill_ImgChosen" + skillName, 212, 140, true, ALIGN_LEFT_TOP);
			//AddImage("", "ImgLevel" + skillName, 254, 182, true, ALIGN_LEFT_TOP);
			AddLabel(userSkill["Level"], 217, 185, 0xffffff);
			for (s in bonus)
			{
				drawGift(bonus[s], x, y);
				x += dx;
			}
		}
		
		private function drawGift(bonus:Object, x:int, y:int):void 
		{	
			var ctn:Container;
			ctn = AddContainer("", "GuiUpgradeSkill_CtnGiftUpgrade", x, y);
			if(bonus[ITEM_TYPE] == "EnergyItem")
			{
				ctn.AddImage("", bonus[ITEM_TYPE] + bonus[ITEM_ID], ctn.img.width / 2, ctn.img.height / 2);
			}
			else
			{
				ctn.AddImage("", bonus[ITEM_TYPE] + bonus[ITEM_ID], ctn.img.width / 2, ctn.img.height / 2, true, ALIGN_LEFT_TOP);
			}
			ctn.AddLabel("x"+bonus[NUM], -14, 50, 0xffffff);
		}
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{			
			switch (buttonID)
			{
				case BTN_CLOSE:
				{
					HideGUI();
					break;					
				}
				case BTN_FEED:
				{
					feed();
					break;
				}
			}
		}
		
		public function HideGUI():void 
		{
			Hide();
			/*if (GuiMgr.getInstance().GuiMixFish.IsVisible)
			{
				GuiMgr.getInstance().GuiMixFish.InitArrNumMaterial(GameLogic.getInstance().user.StockThingsArr.Material);
				GuiMgr.getInstance().GuiMixFish.arrMaterial = UpdateArrMat(GuiMgr.getInstance().GuiMixFish.usedSlot, GuiMgr.getInstance().GuiMixFish.arrMaterial);
				GuiMgr.getInstance().GuiMixFish.InitMaterialList(GuiMgr.getInstance().GuiMixFish.arrMaterial);
			}*/
			if (GuiMgr.getInstance().guiMateFish.IsVisible)
			{
				GuiMgr.getInstance().guiMateFish.updateListMaterial();
			}
		}
		
		public function feed():void 
		{
			var obj:Object = GameLogic.getInstance().user.GetMyInfo().Skill[skillName];
			var stName:String = Localization.getInstance().getString(skillName);
			switch (skillName)
			{
				case ItemSkill.SKILL_MONEY:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_UPGRADE_SKILL_MONEY, stName, obj["Level"]);
					break;
				case ItemSkill.SKILL_LEVEL:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_UPGRADE_SKILL_LEVEL, stName, obj["Level"]);
					break;
				case ItemSkill.SKILL_SPECIAL:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_UPGRADE_SKILL_SPECIAL, stName, obj["Level"]);
					break;
				case ItemSkill.SKILL_RARE:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_UPGRADE_SKILL_RARE, stName, obj["Level"]);
					break;
			}
			this.HideGUI();
		}
	}

}