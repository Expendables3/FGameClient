package GUI.FishWorld 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.QuestMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIIntroOcean extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const IC_HELPER:String = "icHelper";
		//private static const BTN_CLOSE:String = "BtnThoat";
		private static const BTN_ATTACK:String = "BtnAttack";
		private static const IMG_INTRO_OCEAN:String = "ImgInfoOcean";
		public var IdSeaIntro:int;
		public function GUIIntroOcean(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIIntroOcean";
		}
		override public function InitGUI():void 
		{
			//super.InitGUI();
			this.setImgInfo = function():void
			{
				SetPos(40, 70);
				AddButton(BTN_ATTACK,"BtnThoat", 700, 10, this)
				AddButton(BTN_ATTACK,"GuiIntroOcean_BtnAttackOcean", 289, 330, this)
				OpenRoomOut();
			}
			LoadRes("GuiIntroOcean_" + IdSeaIntro + "_Theme");
		}
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			var txtIntro:TextField;
			switch (FishWorldController.GetSeaId()) 
			{
				case Constant.OCEAN_NEUTRALITY:
					txtIntro = AddLabel(Localization.getInstance().getString("Message35"), 40, 65);
				break;
				case Constant.OCEAN_METAL:
					txtIntro = AddLabel(Localization.getInstance().getString("Message40"), 40, 65);
				break;
				case Constant.OCEAN_ICE:
					txtIntro = AddLabel(Localization.getInstance().getString("Message41"), 40, 65);
				break;
				case Constant.OCEAN_ICE:
					txtIntro = AddLabel(Localization.getInstance().getString("Message41"), 40, 65);
				break;
				case Constant.OCEAN_FOREST:
					//txtIntro = AddLabel(Localization.getInstance().getString("Message41"), 40, 65);
				break;
			}
			if(txtIntro != null)
			{
				txtIntro.wordWrap = true;
				txtIntro.multiline = true;
				txtIntro.width = 634;
				var tf:TextFormat = new TextFormat(null, 16, 0x264904, true);
				txtIntro.setTextFormat(tf);
				txtIntro.defaultTextFormat = tf;
			}
			if(FishWorldController.GetSeaId() != Constant.OCEAN_FOREST)
			{
				txtIntro = AddLabel(Localization.getInstance().getString("Message36"), 40, 280);
				txtIntro.wordWrap = true;
				txtIntro.multiline = true;
				txtIntro.width = 634;
				tf = new TextFormat(null, 16, 0x990000, true);
				txtIntro.setTextFormat(tf);
				txtIntro.defaultTextFormat = tf;
			}
			
			AddImage(IMG_INTRO_OCEAN, "GuiIntroOcean_ImgIntroOcean" + IdSeaIntro, 40 + 320, 120 + 64);
			AddImage(IMG_INTRO_OCEAN, "GuiIntroOcean_LabelNameOcean" + IdSeaIntro, 285 + 61, 5 + 10);
			
			//Main Quest
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("BtnAttack") >= 0)
			{
				AddImage(IC_HELPER, "IcHelper", 380, 335);
			}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var EnergyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillBoss");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillBoss"];
			super.OnButtonClick(event, buttonID);
			switch (buttonID) 
			{
				case BTN_ATTACK:
					if (GuiMgr.getInstance().GuiMapOcean.IsVisible)
					{
						GuiMgr.getInstance().GuiMapOcean.Hide();
					}
					if(IdSeaIntro != Constant.OCEAN_FOREST)
					{
						if (Ultility.IsKillBoss())
						{
							GameLogic.getInstance().SetMode(GameMode.GAMEMODE_WAR);
							GuiMgr.getInstance().GuiMainFishWorld.ProcessToWar();
						}
						else 
						{
							GuiMgr.getInstance().GuiMainFishWorld.ProcessToWar();
						}
					}
					Hide();
				break;
				default:
					
				break;
			}
		}
		public function ShowGUI():void 
		{
			IdSeaIntro = FishWorldController.GetSeaId();
			Show(Constant.GUI_MIN_LAYER, 1);
		}
	}
}