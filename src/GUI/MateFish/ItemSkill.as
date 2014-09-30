package GUI.MateFish 
{
	import Data.ConfigJSON;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendUpgradeSkill;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemSkill extends Container 
	{
		public static const SKILL_LEVEL:String = "LevelSkill";
		public static const SKILL_MONEY:String = "MoneySkill";
		public static const SKILL_SPECIAL:String = "SpecialSkill";
		public static const SKILL_RARE:String = "RareSkill";
		
		public var typeSkill:String;
		private var _level:int;
		private var _mastery:int;
		
		public var masteryRequire:int;
		public var buff:Number;
		public var id:int;
		private var _levelRequire:int;
		public var spendEnergy:int;
		
		private var progressBar:ProgressBar;
		private var textFieldLevel:TextField;
		
		public var isSelected:Boolean = false;
		
		private var ctnSkill:Container;
		
		public function ItemSkill(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		public function initItemSkill(_typeSkill:String, _level:int, _mastery:int):void
		{
			LoadRes("");
			//ctnSkill = AddContainer("", "Ctn" + _typeSkill, 0, 0);
			ctnSkill = AddContainer("", "GuiMateFish_Ctn_" + _typeSkill, 5, 0);
			ctnSkill.GoToAndStop(0);
			//AddContainer("", "ImgLevel" + _typeSkill, img.x + 46, img.y + 44, true, this);
			textFieldLevel = AddLabel(_level.toString(), img.x - 6, img.y + 30, 0xffffff);
			var txtFormat:TextFormat = new TextFormat("arial", 13);
			textFieldLevel.defaultTextFormat = txtFormat;
			/*progressBar = AddProgress("", "Prg" + _typeSkill, img.x + 8, img.y + 73);
			progressBar.SetBackGround("ProgressBarSkill_Bg");*/
			progressBar = AddProgress("", "GuiMateFish_Bar_" + _typeSkill, img.x + 12, img.y + 52);
			//progressBar.SetBackGround("ProgressBarSkill_Bg");
			progressBar.SetBackGround("GuiMateFish_Progress_Skill_Bg");
			img.buttonMode = true;
			
			typeSkill = _typeSkill;
			level = _level;
			mastery = _mastery;
			
			//img.scaleX = img.scaleY = 0.7;
		}
		
		public function get mastery():int 
		{
			return _mastery;
		}
		
		public function set mastery(value:int):void 
		{
			_mastery = value;
			
			if (_mastery > masteryRequire && masteryRequire != 0)
			{
				_mastery = masteryRequire;
			}
			//Nâng cấp kĩ năng
			if (canUpgrade())
			{
				/*var numLevel:int = _mastery / masteryRequire;
				for (var i:int = 0; i < numLevel; i++)
				{
					var cmd:SendUpgradeSkill = new SendUpgradeSkill(typeSkill);
					Exchange.GetInstance().Send(cmd);
				}
				_mastery -= numLevel*masteryRequire;
				level += numLevel;*/
				
				var cmd:SendUpgradeSkill = new SendUpgradeSkill(typeSkill);
				Exchange.GetInstance().Send(cmd);
				//upgradeComplete();
			}
			
			if(masteryRequire != 0)
			{
				progressBar.setStatus(_mastery / masteryRequire);
			}
			else
			{
				progressBar.setStatus(0);
			}
		}
		
		public function upgradeComplete():void
		{
			_mastery = 0;
			level++;
			
			var userSkill:Object = GameLogic.getInstance().user.GetMyInfo().Skill;
			userSkill[typeSkill]["Mastery"] = _mastery;
			userSkill[typeSkill]["Level"] = level;
			
			// Hiển thị gui chúc mừng 
			GuiMgr.getInstance().GuiUpgradeSkill.Show(Constant.GUI_MIN_LAYER, 6);
			GuiMgr.getInstance().GuiUpgradeSkill.setInfo(typeSkill);			
			
			// update thông số trên gui TopInfo
			//GuiMgr.getInstance().GuiTopInfo.updateSkillInfo();
			
			progressBar.setStatus(0);
		}
		
		public function get level():int 
		{
			return _level;
		}
		
		public function set level(value:int):void 
		{
			_level = value;
			textFieldLevel.text = value.toString();
			
			var config:Object = ConfigJSON.getInstance().getItemInfo(typeSkill, level);
			masteryRequire = config["MasteryRequire"];
			buff = config["Buff"];
			id = config["Id"];
			levelRequire = config["LevelRequire"];
			spendEnergy = config["SpendEnergy"];
		}
		
		public function get levelRequire():int 
		{
			return _levelRequire;
		}
		
		public function set levelRequire(value:int):void 
		{
			_levelRequire = value;
			if (!canUse())
			{
				var elements:Array =
					[0.33, 0.33, 0.33, 0, 0,
					0.33, 0.33, 0.33, 0, 0,
					0.33, 0.33, 0.33, 0, 0,
					0, 0, 0, 1, 0];
					
				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
				img.filters = [colorFilter];				
			}
			else
			{
				img.filters = null;
			}
		}
		
		public function canUse():Boolean
		{
			if (GameLogic.getInstance().user.GetLevel() < _levelRequire)
			{
				return false;
			}
			return true;
		}
		
		public function canUpgrade():Boolean
		{
			var nextConfig:Object = ConfigJSON.getInstance().getItemInfo(typeSkill, level + 1);
			if (_mastery >= masteryRequire && masteryRequire > 0 && nextConfig != null && (nextConfig["LevelRequire"] <= GameLogic.getInstance().user.Level))
			{
				return true;
			}
			return false;
		}
		
		public function showEffSelected(on:Boolean):void
		{
			if(on)
			{
				ctnSkill.SetHighLight(0xa367fe);
				ctnSkill.GoToAndPlay(0);
			}
			else
			{
				ctnSkill.SetHighLight( -1);
				ctnSkill.GoToAndStop(0);
			}
		}
	}

}