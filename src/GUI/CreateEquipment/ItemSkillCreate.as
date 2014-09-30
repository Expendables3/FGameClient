package GUI.CreateEquipment 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemSkillCreate extends Container 
	{
		static public const BTN_CREATE:String = "btnCreate";
		private var _level:int;
		private var _exp:int;
		private var progressBar:ProgressBar;
		private var labelName:TextField;
		private var big:Boolean;
		private var imageLevel:Image;
		public var type:String;
		public var config:Object;
		
		public function ItemSkillCreate(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			config = ConfigJSON.getInstance().GetItemList("Crafting_Exp")["Require"]["Exp"];
		}
		
		public function initSkill(_type:String, _level:int, _exp:int, _big:Boolean = false):void
		{
			LoadRes("");
			big = _big;
			if(!big)
			{
				AddButton(BTN_CREATE, "Btn_SkillCreate_" + _type, 0, 0);
				
				progressBar = AddProgress("", "SkillCreate_Bar", 10, 110);
				progressBar.SetBackGround("SkillCreate_ProgressBar_Bg");
				
				AddImage("", "SkillCreate_Label_Bg", 6, 133, true, ALIGN_LEFT_TOP);
				labelName = AddLabel(Localization.getInstance().getString(_type), 8, 137, 0xffffff, 1, 0x000000);
				
				imageLevel = AddImage("", "Number_" + _level, -5, 100, true, ALIGN_LEFT_TOP);
				//var tooltip:TooltipFormat = new TooltipFormat();
				//tooltip.text = "Chế Tạo " + Localization.getInstance().getString(_type);
				//setTooltip(tooltip);
			}
			else
			{
				imageLevel = AddImage("", "Number_" + _level, 78,8);
				progressBar = AddProgress("", "GUICreate_ProgressBar", 3, 30);
				progressBar.SetBackGround("GUICreate_ProgressBar_Bg");
				var btnSkill:Button = AddButton("", "Btn_SkillCreate_" + _type, -7 -57, -2);
				btnSkill.img.scaleX = btnSkill.img.scaleY = 0.5;
				
				labelName = AddLabel(Ultility.StandardNumber(_exp) + " / " + Ultility.StandardNumber(config[_level + 1]), 110, 5, 0xffffff, 1, 0x000000);
				var txtFormat:TextFormat = new TextFormat("arial", 17, 0xffffff, true);
				labelName.defaultTextFormat = txtFormat;
			}
			
			progressBar.setStatus(Number(_exp) / config[_level + 1]);
			
			type = _type;
			level = _level;
			exp = _exp;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if(buttonID == BTN_CREATE)
			{
				GuiMgr.getInstance().guiCreateEquipment.showGUI(type, level);
			}
		}
		
		public function get exp():int 
		{
			return _exp;
		}
		
		public function set exp(value:int):void 
		{
			var levelMax:int = getMaxLevel();
			while (value >= config[level + 1] && level < levelMax)
			{
				value -= config[level + 1];
				level++;
			}
			_exp = value;
			progressBar.setStatus(Number(value) / config[level + 1]);
			//trace(exp, config[level +1]);
			if (big)
			{
				labelName.text = Ultility.StandardNumber(exp) + " / " + Ultility.StandardNumber(config[level + 1]);
			}
		}
		
		public function get level():int 
		{
			return _level;
		}
		
		public function set level(value:int):void 
		{
			_level = value;
			progressBar.setStatus(Number(exp) / config[value + 1]);
			RemoveImage(imageLevel);
			if(!big)
			{
				imageLevel = AddImage("", "Number_" + _level, 0, 100, true, ALIGN_LEFT_TOP);
			}
			else
			{
				imageLevel = AddImage("", "Number_" + _level, 78,8);
				labelName.text = exp + " / " + config[value + 1];
			}
		}
		
		private function getMaxLevel():int
		{
			var obj:Object = ConfigJSON.getInstance().GetItemList("CraftingEquip");
			if (type != "Jewel")
			{
				obj = obj[type];
			}
			else
			{
				obj = obj["Ring"];
			}
			var maxLevel:int = 0;
			for (var s:String in obj)
			{
				if (maxLevel < int(s))
				{
					maxLevel = int(s);
				}
			}
			if (maxLevel == 0)
			{
				trace("test");
			}
			return maxLevel;
		}
	}

}