package GUI 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author MinhT
	 */
	public class GUISkillInfo extends BaseGUI 
	{		
		public function GUISkillInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUISkillInfo";
		}		
		
		public function setInfo(skillName:String):void 
		{
			// 	userSkill.Level
			//	userSkill.Mastery
			var userSkill:Object = GameLogic.getInstance().user.GetMyInfo().Skill[skillName];
			
			//	objSkill.LevelRequire
			//	objSkill.MasteryRequire
			//	objSkill.SpendEnergy
			//	objSkill.Buff
			var objSkill:Object = ConfigJSON.getInstance().getItemInfo(skillName, userSkill.Level);
			
			var format:TextFormat = new TextFormat();
			var imgTitle:Image
			var txtCurLevel:TextField;
			var txtPercent:TextField;
			var txtCurBuff:TextField;
			var txtCurEnergy:TextField;
			var txtNextLevel:TextField;
			var txtLevelRequire:TextField;
			var txtNextBuff:TextField;
			var txtNextEnergy:TextField;
			var buff:String;
			
			if (userSkill.Level == 1 && objSkill.LevelRequire > GameLogic.getInstance().user.GetLevel())
			{
				LoadRes("GuiMateFish_ImgBgGUISkillInfoBase");
				SetPos(320, 204);
				imgTitle = AddImage("", "GuiMateFish_Txt" + skillName, img.width / 2, 19, true, ALIGN_LEFT_TOP);
				format.bold = true;
				format.size = 12;
				txtCurLevel = AddLabel("Cấp độ: " + userSkill.Level, 40, 32);
				txtCurLevel.setTextFormat(format);
				format.size = 22;
				format.color = 0xffffff;
				txtCurLevel.setTextFormat(format, txtCurLevel.length - userSkill.Level.toString().length, txtCurLevel.length);
				
				format.bold = true;
				format.size = 10;
				format.color = 0x000000;
				txtLevelRequire = AddLabel("Yêu cầu cấp độ: " + objSkill.LevelRequire, 40, 60);
				txtLevelRequire.setTextFormat(format);				
				txtLevelRequire.background = true;
				txtLevelRequire.backgroundColor = 0xff0000;
				
				buff = Localization.getInstance().getString("buff" + skillName);
				buff = buff.replace("@PERCENT", objSkill.Buff * 100);
				format.bold = true;
				format.size = 10;
				format.color = 0x000000;
				txtCurBuff = AddLabel(buff, 40, 80);
				txtCurBuff.setTextFormat(format);
				txtCurBuff.antiAliasType = AntiAliasType.ADVANCED;
				
				format.bold = true;
				format.size = 10;
				format.color = 0x000000;
				txtCurEnergy = AddLabel("Tiêu hao: " + objSkill.SpendEnergy + " năng lượng", 40, 99);
				txtCurEnergy.setTextFormat(format);
				txtCurEnergy.antiAliasType = AntiAliasType.ADVANCED;
			}
			else
			{
				if (userSkill.Level < 7)
				{
					LoadRes("GuiMateFish_ImgBgGUISkillInfo");
					SetPos(225, 204);
					imgTitle = AddImage("", "GuiMateFish_Txt" + skillName, img.width / 2, 14, true, ALIGN_LEFT_TOP);
					
					format.bold = true;
					format.size = 12;
					txtCurLevel = AddLabel("Cấp độ hiện tại: " + userSkill.Level, 40, 27);
					txtCurLevel.setTextFormat(format);
					format.size = 22;
					format.color = 0xffffff;
					txtCurLevel.setTextFormat(format, txtCurLevel.length - userSkill.Level.toString().length, txtCurLevel.length);
					
					var percent:Number = userSkill.Mastery / objSkill.MasteryRequire;
					AddProgress("", "GuiMateFish_Prg" + skillName, 53, 65).setStatus(percent);
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					txtPercent = AddLabel(Math.floor(percent*100).toString() + "%", 70, 60);
					txtPercent.setTextFormat(format);
					
					buff = Localization.getInstance().getString("buff" + skillName);
					buff = buff.replace("@PERCENT", objSkill.Buff * 100);
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					txtCurBuff = AddLabel(buff, 40, 80);
					txtCurBuff.setTextFormat(format);
					format.size = 12;
					txtCurBuff.setTextFormat(format, buff.indexOf((objSkill.Buff * 100).toString()), buff.indexOf((objSkill.Buff * 100).toString()) + (objSkill.Buff * 100).toString().length +2);
					txtCurBuff.antiAliasType = AntiAliasType.ADVANCED;
					
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					txtCurEnergy = AddLabel("Tiêu hao: " + objSkill.SpendEnergy + " năng lượng", 40, 99);
					txtCurEnergy.setTextFormat(format);
					txtCurEnergy.antiAliasType = AntiAliasType.ADVANCED;
					
					/**********************************/
					objSkill = ConfigJSON.getInstance().getItemInfo(skillName, userSkill.Level + 1);
					format.bold = true;
					format.size = 12;
					txtNextLevel = AddLabel("Cấp độ tiếp theo: " + int(userSkill.Level + 1), 212, 27);
					txtNextLevel.setTextFormat(format);
					format.size = 22;
					format.color = 0xffffff;
					txtNextLevel.setTextFormat(format, txtNextLevel.length - (userSkill.Level+1).toString().length, txtNextLevel.length);
					
					format.bold = true;
					format.size = 10;					
					format.color = 0x000000;
					txtLevelRequire = AddLabel("Yêu cầu cấp độ: " + objSkill.LevelRequire, 212, 60, 0x000000);
					txtLevelRequire.setTextFormat(format);					
					txtLevelRequire.background = true;
					txtLevelRequire.backgroundColor = 0xff0000;
					
					buff = Localization.getInstance().getString("buff" + skillName);
					buff = buff.replace("@PERCENT", objSkill.Buff * 100);
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					txtNextBuff = AddLabel(buff, 212, 80);
					txtNextBuff.setTextFormat(format);
					format.size = 12;
					txtNextBuff.setTextFormat(format, buff.indexOf((objSkill.Buff * 100).toString()), buff.indexOf((objSkill.Buff * 100).toString()) + (objSkill.Buff * 100).toString().length +2);
					
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;				
					txtNextEnergy = AddLabel("Tiêu hao: " + objSkill.SpendEnergy + " năng lượng", 212, 99);
					txtNextEnergy.setTextFormat(format);
					txtNextEnergy.antiAliasType = AntiAliasType.ADVANCED;
				}
				else
				{
					LoadRes("GuiMateFish_ImgBgGUISkillInfoBase");
					SetPos(320, 204);
					imgTitle = AddImage("", "GuiMateFish_Txt" + skillName, img.width / 2, 19, true, ALIGN_LEFT_TOP);
					format.bold = true;
					format.size = 12;
					txtCurLevel = AddLabel("Cấp độ: " + userSkill.Level, 40, 32);
					txtCurLevel.setTextFormat(format);
					format.size = 22;
					format.color = 0xffffff;
					txtCurLevel.setTextFormat(format, txtCurLevel.length - userSkill.Level.toString().length, txtCurLevel.length);
					
					//format.bold = true;
					//format.size = 10;
					//format.color = 0xff0000;
					//txtLevelRequire = AddLabel("Yêu cầu cấp độ: " + objSkill.LevelRequire, 40, 60);
					//txtLevelRequire.setTextFormat(format);
					
					buff = Localization.getInstance().getString("buff" + skillName);
					buff = buff.replace("@PERCENT", objSkill.Buff * 100);
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					txtCurBuff = AddLabel(buff, 40, 60);
					txtCurBuff.setTextFormat(format);
					txtCurBuff.antiAliasType = AntiAliasType.ADVANCED;
					
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					txtCurEnergy = AddLabel("Tiêu hao: " + objSkill.SpendEnergy + " năng lượng", 40, 80);
					txtCurEnergy.setTextFormat(format);
					txtCurEnergy.antiAliasType = AntiAliasType.ADVANCED;
				}
			}
			
			//AddLabel(Localization.getInstance().getString(skillName), 80, 40);
			//AddLabel("Cấp độ: " + userSkill.Level, 80, 60);
			//var txtLevel:TextField = AddLabel("Yêu cầu cấp độ " + objSkill.LevelRequire, 80, 80);
			//var buff:String = Localization.getInstance().getString("buff" + skillName);
			//buff = buff.replace("@PERCENT", objSkill.Buff * 100);
			//AddLabel(buff, 80, 100);
			//AddLabel("Tiêu hao: " + objSkill.SpendEnergy + " năng lượng", 80, 120);
			
			//if (GameLogic.getInstance().user.GetLevel() < objSkill.LevelRequire)
			//{
				//var format:TextFormat = new TextFormat();
				//format.color = 0xff0000;
				//txtLevel.setTextFormat(format);
			//}
		}
	}

}