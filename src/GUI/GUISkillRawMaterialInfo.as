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
	import Logic.User;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUISkillRawMaterialInfo extends BaseGUI
	{
		
		public function GUISkillRawMaterialInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIRawMaterialInfo";
		}
		public override function InitGUI() :void
		{
			var user:User = GameLogic.getInstance().user;
			var objSkillRaw:Object = ConfigJSON.getInstance().getItemInfo("M_MaterialSkill", user.GetMyInfo().MatLevel);
			var objSkillRawNext:Object;
			
			var format:TextFormat = new TextFormat();
			var imgTitle:Image
			var txtCurLevel:TextField;
			var txtPercent:TextField;
			var txtCurBuff:TextField;
			var txtCurLevelMat:TextField;
			var txtNextLevel:TextField;
			var txtLevelRequire:TextField;
			var txtNextBuff:TextField;
			var txtNextEnergy:TextField;
			var buff:String;
			var level:String;
			
			if (user.GetMyInfo().MatLevel == 1 && objSkillRaw["LevelRequire"] > GameLogic.getInstance().user.GetLevel())
			{
				LoadRes("GuiRawMaterials_ImgBgGUISkillInfoBase");
				SetPos(225, 130);
				imgTitle = AddImage("", "GuiRawMaterials_TxtRawMaterial", img.width / 2, 19, true, ALIGN_LEFT_TOP);
				format.bold = true;
				format.size = 12;
				txtCurLevel = AddLabel("Cấp độ: " + user.GetMyInfo().MatLevel, 40, 32);
				txtCurLevel.setTextFormat(format);
				format.size = 22;
				format.color = 0xffffff;
				txtCurLevel.setTextFormat(format, txtCurLevel.length - user.GetMyInfo().MatLevel.toString().length, txtCurLevel.length);
				
				format.bold = true;
				format.size = 10;
				format.color = 0x000000;
				txtLevelRequire = AddLabel("Yêu cầu cấp độ: " + objSkillRaw["LevelRequire"], 40, 60);
				txtLevelRequire.setTextFormat(format);				
				txtLevelRequire.background = true;
				txtLevelRequire.backgroundColor = 0xff0000;
				
				buff = Localization.getInstance().getString("buffRawMaterial");
				buff = buff.replace("@PERCENT", objSkillRaw["SuccessRate"]);
				format.bold = true;
				format.size = 10;
				format.color = 0x000000;
				txtCurBuff = AddLabel(buff, 40, 75);
				txtCurBuff.setTextFormat(format);
				txtCurBuff.antiAliasType = AntiAliasType.ADVANCED;
				
				format.bold = true;
				format.size = 10;
				format.color = 0x000000;
				level = Localization.getInstance().getString("LevelRawMaterial");
				level = level.replace("@Level", objSkillRaw["Craftable"]);
				txtCurLevelMat = AddLabel(level, 40, 102);
				txtCurLevelMat.setTextFormat(format);
				txtCurLevelMat.antiAliasType = AntiAliasType.ADVANCED;
			}
			else
			{
				if (user.GetMyInfo().MatLevel < GuiMgr.getInstance().GuiRawMaterials.MAX_LEVEL_SKILL_RAW)
				{
					LoadRes("GuiRawMaterials_ImgBgGUISkillInfo");
					SetPos(225, 130);
					imgTitle = AddImage("", "GuiRawMaterials_TxtRawMaterial", img.width / 2, 14, true, ALIGN_LEFT_TOP);
					
					format.bold = true;
					format.size = 12;
					txtCurLevel = AddLabel("Cấp độ hiện tại: " + user.GetMyInfo().MatLevel, 40, 27);
					txtCurLevel.setTextFormat(format);
					format.size = 22;
					format.color = 0xffffff;
					txtCurLevel.setTextFormat(format, txtCurLevel.length - user.GetMyInfo().MatLevel.toString().length, txtCurLevel.length);
					
					var percent:Number = user.GetMyInfo().MatPoint / objSkillRaw.Mastery;
					AddProgress("", "GuiRawMaterials_PrgLevelSkill", 53, 65).setStatus(percent);
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					txtPercent = AddLabel(Math.min(Math.floor(percent*100), 100).toString() + "%", 70, 60);
					txtPercent.setTextFormat(format);
					
					buff = Localization.getInstance().getString("buffRawMaterial");
					buff = buff.replace("@PERCENT", objSkillRaw["SuccessRate"]);
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					txtCurBuff = AddLabel(buff, 40, 75);
					txtCurBuff.setTextFormat(format);
					txtCurBuff.antiAliasType = AntiAliasType.ADVANCED;
					
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					level = Localization.getInstance().getString("LevelRawMaterial");
					level = level.replace("@Level", objSkillRaw["Craftable"]);
					txtCurLevelMat = AddLabel(level, 40, 102);
					txtCurLevelMat.setTextFormat(format);
					txtCurLevelMat.antiAliasType = AntiAliasType.ADVANCED;
					
					/**********************************/
					objSkillRawNext = ConfigJSON.getInstance().getItemInfo("M_MaterialSkill", user.GetMyInfo().MatLevel + 1);
					
					format.bold = true;
					format.size = 12;
					txtNextLevel = AddLabel("Cấp độ tiếp theo: " + (user.GetMyInfo().MatLevel + 1), 212, 27);
					txtNextLevel.setTextFormat(format);
					format.size = 22;
					format.color = 0xffffff;
					txtNextLevel.setTextFormat(format, txtNextLevel.length - (user.GetMyInfo().MatLevel+1).toString().length, txtNextLevel.length);
					
					format.bold = true;
					format.size = 10;					
					format.color = 0x000000;
					txtLevelRequire = AddLabel("Yêu cầu cấp độ: " + objSkillRawNext.LevelRequire, 212, 60, 0x000000);
					txtLevelRequire.setTextFormat(format);					
					txtLevelRequire.background = true;
					txtLevelRequire.backgroundColor = 0xff0000;
					
					buff = Localization.getInstance().getString("buffRawMaterial");
					buff = buff.replace("@PERCENT", objSkillRawNext["SuccessRate"]);
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					txtCurBuff = AddLabel(buff, 212, 75);
					txtCurBuff.setTextFormat(format);
					txtCurBuff.antiAliasType = AntiAliasType.ADVANCED;
					
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					level = Localization.getInstance().getString("LevelRawMaterial");
					level = level.replace("@Level", objSkillRawNext["Craftable"]);
					txtCurLevelMat = AddLabel(level, 212, 102);
					txtCurLevelMat.setTextFormat(format);
					txtCurLevelMat.antiAliasType = AntiAliasType.ADVANCED;
				}
				else
				{
					LoadRes("GuiRawMaterials_ImgBgGUISkillInfoBase");
					SetPos(325, 130);
					imgTitle = AddImage("", "GuiRawMaterials_TxtRawMaterial", img.width / 2, 19, true, ALIGN_LEFT_TOP);
					format.bold = true;
					format.size = 12;
					txtCurLevel = AddLabel("Cấp độ: " + user.GetMyInfo().MatLevel, 40, 32);
					txtCurLevel.setTextFormat(format);
					format.size = 22;
					format.color = 0xffffff;
					txtCurLevel.setTextFormat(format, txtCurLevel.length - user.GetMyInfo().MatLevel.toString().length, txtCurLevel.length);
					
					buff = Localization.getInstance().getString("buffRawMaterial");
					buff = buff.replace("@PERCENT", objSkillRaw["SuccessRate"]);
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					txtCurBuff = AddLabel(buff, 40, 65);
					txtCurBuff.setTextFormat(format);
					txtCurBuff.antiAliasType = AntiAliasType.ADVANCED;
					
					format.bold = true;
					format.size = 10;
					format.color = 0x000000;
					level = Localization.getInstance().getString("LevelRawMaterial");
					level = level.replace("@Level", objSkillRaw["Craftable"]);
					txtCurLevelMat = AddLabel(level, 40, 99);
					txtCurLevelMat.setTextFormat(format);
					txtCurLevelMat.antiAliasType = AntiAliasType.ADVANCED;
				}
			}
		}
	}

}