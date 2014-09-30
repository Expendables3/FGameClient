package GUI.MainQuest 
{
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIIntroduceFeature extends BaseGUI 
	{
		static public const BTN_CLOSE:String = "btnClose";
		static public const FEATURE_NAME_FISH_WORLD:String = "featureNameFishWorld";
		static public const FEATURE_NAME_COLLECTION:String = "featureNameCollection";
		static public const FEATURE_NAME_TRAINING_TOWER:String = "featureNameTrainingTower";
		static public const FEATURE_NAME_ENCHANT_EQUIPMENT:String = "featureNameEnchantEquipment";
		static public const FEATURE_NAME_CREATE_EQUIPMENT:String = "featureNameCreateEquipment";
		
		public function GUIIntroduceFeature(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			setImgInfo = function f():void
			{
				AddButton(BTN_CLOSE, "BtnThoat", 348, 41);
				AddButton(BTN_CLOSE, "BtnDong", 138, 266);
				SetPos(219, 100);
			}
			LoadRes("GuiIntroduceFeature_Theme");
		}
		
		public function showGUI():void
		{
			var userLevel:int = GameLogic.getInstance().user.GetLevel();
			var message:String = "Chúc mừng bạn đã có thể sử dụng\nchức năng ";
			var iconName:String;
			switch(userLevel)
			{
				case 7:
					message += "Thế Giới Cá";
					iconName = "FishWorld";
					break;
				case 10:
					message += "Bộ Sưu Tập";
					iconName = "Collection";
					break;
				case 11:
					message += "Tu Luyện Đan";
					iconName = "Gem";
					break;
				case 13:
					message += "Cường Hóa";
					iconName = "Enchant";
					break;
				case 15:
					message += "Chế Tạo Trang Bị";
					iconName = "CreateEquipment";
					break;
				default:
					return;
			}
			
			Show(Constant.GUI_MIN_LAYER, 3);
			var iconFeature:Image = AddImage("", "GuiIntroduceFeature_Icon" + iconName, 50, 50);
			iconFeature.FitRect(120, 120, new Point(141 - 15, 117));
			
			var txtFormat:TextFormat = new TextFormat("arial", 14, 0x000000, true);
			txtFormat.align = "center";
			var label:TextField = AddLabel(message, 138, 90, 0x000000, 1, 0xffffff);
			label.setTextFormat(txtFormat);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID == BTN_CLOSE)
			{
				Hide();
				/*var userLevel:int = GameLogic.getInstance().user.GetLevel();
				switch(userLevel)
				{
					case 7:
						EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffUseGinseng", null, 100, 200);
						break;
					case 9:
						EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffUseGinseng", null, 200, 200);
						break;
					case 11:
						EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffUseGinseng", null, 300, 200);
						break;
					case 13:
						EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffUseGinseng", null, 400, 200);
						break;
					case 15:
						EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffUseGinseng", null, 500, 200);
						break;
					default:
						return;
				}*/
			}
		}
		
	}

}