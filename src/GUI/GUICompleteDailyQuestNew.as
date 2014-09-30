package GUI 
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenMax;
	import Data.Localization;
	import Data.ResMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.QuestBonus;
	import Logic.QuestInfo;
	import Logic.QuestMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUICompleteDailyQuestNew extends BaseGUI
	{
		private var sureGift:Array;
		private var luckyGift:Object;
		private var questId:int;
		private var lucky:String;
		private var bonusObject:Object;
		
		private var isDataReady:Boolean;
		
		private const CTN_CHEST:String = "ctnChest";
		private static var  BUTTON_SHARE:String = "buttonShare";
		private static var	BUTTON_CLOSE:String = "buttonClose";
		private static var 	BUTTON_EXIT:String = "buttonExit";
		private static var 	BUTTON_GET:String = "buttonGet";
	
		
		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();

		public function GUICompleteDailyQuestNew(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUICompleteDailyQuestNew";
		}
		
		public override function InitGUI() :void
		{
			LoadRes("GuiDailyQuest_Complete_Theme");	
			SetPos(215, 200);
			
			//Add ảnh chờ load dữ liệu
			img.addChild(WaitData);
			WaitData.x = img.width / 2 - 5;
			WaitData.y = img.height / 2 - 5;	
		}
		
		public function Init(bonus:Object, idquest:int, isReady:Boolean = true):void
		{
			isDataReady = isReady;
			GameLogic.getInstance().BackToIdleGameState();
			//this.Hide();
			
			ClearComponent();
			
			//AddButton(BUTTON_CLOSE, "BtnThoat", 343, 4);
			
			if (isReady)
				ImportData(bonus, idquest);
			AddContent(isDataReady);
			
			
		}
		
		private function ImportData(bonus:Object, idquest:int):void
		{
			bonusObject = bonus;
			sureGift = [];
			for (var i:String in bonus["Sure"])
			{
				sureGift.push(bonus["Sure"][i]);
			}
			var r:String
			if (bonus["Lucky"] != null)
			{
				luckyGift = bonus["Lucky"][0];
			}
			
			questId = idquest;
			super.Show(Constant.GUI_MIN_LAYER, 5);
			
			if ((questId != 1) && (luckyGift != null) && ((luckyGift.ItemType == "Sparta") || (luckyGift.ItemType == "Superman") || luckyGift.ItemType == "Ring"))
			{
				AddButton(BUTTON_SHARE, "BtnFeed", 78, 262);
				AddButton(BUTTON_CLOSE, "BtnDong", 200, 262);
			}
			else
			{
				//AddButton(BUTTON_EXIT, "ButtonDong", 155, 220);
				AddButton(BUTTON_GET, "GuiDailyQuest_BtnNhanThuong", 121, 262);
			}
		}
		
		/**
		 * Add toàn bộ nội dung của GUI
		 */
		public function AddContent(dataAvailable:Boolean):void
		{
			
			isDataReady = dataAvailable;
			if (!isDataReady)
			{
				return;
			}
			
			if (img == null) return;
			
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			
			//AddButton(BUTTON_CLOSE, "BtnThoat", 343, 4);
			
			var txtField:TextField;
			AddImage("", "GuiDailyQuest_ImgNumberQuest" + questId, 304, 50);
			
			var x0:int;
			var dx:int = 65;
			
			if (questId == 1)
			{
				AddImage("", "GuiDailyQuest_ImgCtnDailyQuestGiftSure", 190, 175);
				x0 = 128;
			}
			else
			{
				AddImage("", "GuiDailyQuest_ImgCtnDailyQuestGiftSure", 140, 175);
				x0 = 78;
			}

			
			var image1:Image;
			
			for (var i:int = 0; i < sureGift.length; i++)
			{
				var bonus:Object = sureGift[i];
				
				var container_normal:Container = new Container(img, "ImgFrameFriend", x0, 146);
				var bg:Image = container_normal.AddImage("", "GuiDailyQuest_ImgBgGiftNormal", 0, 0, true, ALIGN_LEFT_TOP);
				//bg.SetScaleXY(1.35);
				
				var tip:TooltipFormat = new TooltipFormat();
				
				switch(bonus.ItemType)
				{
					case "Money":
						image1 = container_normal.AddImage("", "IcGold", 20, 14);
						image1.SetScaleXY(1.8);
						txtField = container_normal.AddLabel(Ultility.StandardNumber(bonus.Num), -18, 41, 0x000000, 1, 0xffffff);
						formatText(txtField, "Arial", 0xFF3300, 16, 0 , true);
						x0 += dx;
						
						// Tooltip
						tip.text = "Tiền vàng";
						container_normal.setTooltip(tip);
						break;
					case "Exp":
						image1 = container_normal.AddImage("", "IcExp", 25, 17);
						image1.SetScaleXY(1.5);
						txtField = container_normal.AddLabel(Ultility.StandardNumber(bonus.Num), -18, 41, 0x000000, 1, 0xffffff);
						formatText(txtField, "Arial", 0xFF3300, 16, 0 , true);
						x0 += dx;
						
						// Tooltip
						tip.text = "Kinh nghiệm";
						container_normal.setTooltip(tip);
						break;			
				}			
			}
			
			if ((luckyGift != null) && (questId != 1))
			{
				var container_lucky:Container = new Container(img, "GuiDailyQuest_ImgCtnDailyQuestGiftLucky", 230, 141);
				var toolTip:TooltipFormat = new TooltipFormat();
				if (luckyGift.ItemType != null) 
				{
					switch(luckyGift.ItemType)
					{
						case "Money":
							image1 = container_lucky.AddImage("", "IcGold", 25, 19);
							image1.SetScaleXY(1.8);
							txtField = container_lucky.AddLabel(Ultility.StandardNumber(luckyGift.Num), -13, 45, 0x000000, 1, 0xffffff);
							formatText(txtField, "Arial", 0xFF3300, 16, 0 , true);
							
							// Tooltip
							toolTip.text = "Tiền vàng";
							container_lucky.setTooltip(toolTip);
							break;
						case "Exp":
							image1 = container_lucky.AddImage("", "IcExp", 29, 22);
							image1.SetScaleXY(1.5);
							txtField = container_lucky.AddLabel(Ultility.StandardNumber(luckyGift.Num), -13, 45, 0x000000, 1, 0xffffff);
							formatText(txtField, "Arial", 0xFF3300, 16, 0 , true);
							
							// Tooltip
							toolTip.text = "Kinh nghiệm";
							container_lucky.setTooltip(toolTip);
							break;				
						case "Material":
							image1 = container_lucky.AddImage("", "Material" + luckyGift.ItemId, 37, 30, true, ALIGN_LEFT_TOP);
							image1.SetScaleX(1.2);
							image1.SetScaleY(1.2);
							txtField = container_lucky.AddLabel(Ultility.StandardNumber(luckyGift.Num), -13, 45, 0x000000, 1, 0xffffff);
							formatText(txtField, "Arial", 0xFF3300, 16, 0 , true);
							lucky = "ngư thạch cấp " + luckyGift.ItemId;
							
							// Tooltip
							toolTip.text = "Ngư thạch cấp " + luckyGift.ItemId;
							container_lucky.setTooltip(toolTip);
							break;	
						case "RankPointBottle":
							image1 = container_lucky.AddImage("", luckyGift.ItemType + luckyGift.ItemId, 42, 40, true, ALIGN_CENTER_CENTER);
							image1.SetScaleXY(0.8);
							txtField = container_lucky.AddLabel(Ultility.StandardNumber(luckyGift.Num), -13, 45, 0x000000, 1, 0xffffff);
							formatText(txtField, "Arial", 0xFF3300, 16, 0 , true);
							lucky = Localization.getInstance().getString(luckyGift.ItemType + luckyGift.ItemId);
							
							// Tooltip
							toolTip.text = lucky;
							container_lucky.setTooltip(toolTip);
							break;
						case "Ring":
							if (int(luckyGift.Color) != FishEquipment.FISH_EQUIP_COLOR_WHITE)
							{
								image1 = container_lucky.AddImage("", FishEquipment.GetBackgroundName(int(luckyGift.Color)), 0, 0, true, ALIGN_LEFT_TOP);
								image1.SetScaleX(1.05);
								image1.SetScaleY(0.95);
							}
							
							image1 = container_lucky.AddImage("", luckyGift.ItemType + luckyGift.ItemId + "_Shop", 37, 30, true, ALIGN_LEFT_TOP);
							image1.FitRect(60, 60, new Point(5, 5));
							txtField = container_lucky.AddLabel(Ultility.StandardNumber(luckyGift.Num), -13, 45, 0x000000, 1, 0xffffff);
							formatText(txtField, "Arial", 0xFF3300, 16, 0 , true);
							lucky = Localization.getInstance().getString(luckyGift.ItemType + luckyGift.ItemId) + " " + Localization.getInstance().getString("EquipmentColor" + luckyGift.Color);
							
							// Glow lên tùy theo màu
							FishSoldier.EquipmentEffect(image1.img, luckyGift.Color);
							
							// Tooltip
							toolTip.text = Localization.getInstance().getString(luckyGift.ItemType + luckyGift.ItemId) + " - " + Localization.getInstance().getString("EquipmentColor" + luckyGift.Color);
							container_lucky.setTooltip(toolTip);
							break;
						case "Sparta":
							var setInfo:Function = function():void
							{
								//Vẽ aura bằng glowFilter
								var cl:int = 0xff0000;
								TweenMax.to(this.img, 1, { glowFilter: { color:cl, alpha:1, blurX:37, blurY:37, strength:1.5 }} );								
							}
							image1 = container_lucky.AddImage("", "Sparta", 48, 40, true, ALIGN_LEFT_TOP, false, setInfo);
							//image1.SetScaleX(1.3);
							//image1.SetScaleY(1.3);
							lucky = "cá chiến binh";
							
							// Tooltip
							toolTip.text = "Cá chiến binh";
							container_lucky.setTooltip(toolTip);
							break;
						case "Superman":
							var setInfo1:Function = function():void
							{
								//Vẽ aura bằng glowFilter
								var cl:int = 0xff0000;
								TweenMax.to(this.img, 1, { glowFilter: { color:cl, alpha:1, blurX:37, blurY:37, strength:1.5 }} );								
							}
							image1 = container_lucky.AddImage("", "Superman", 28, 34, true, ALIGN_LEFT_TOP, false, setInfo1);
							image1.SetScaleX(0.8);
							image1.SetScaleY(0.8);
							lucky = GuiMgr.getInstance().GuiStore.GetNameFishSpecial("Superman");
							
							// Tooltip
							toolTip.text = GuiMgr.getInstance().GuiStore.GetNameFishSpecial("Superman");
							container_lucky.setTooltip(toolTip);
							break;
					}	
				}	
				else
				{
					if (luckyGift.Color != FishEquipment.FISH_EQUIP_COLOR_WHITE)
					{
						container_lucky.IdObject = CTN_CHEST;
						container_lucky.EventHandler = this;
						container_lucky.LoadRes(FishEquipment.GetBackgroundName(luckyGift.Color));
					}
					image1 = container_lucky.AddImage("", luckyGift.Type + luckyGift.Rank + "_Shop", 37, 40, true, ALIGN_CENTER_CENTER);
					lucky = Localization.getInstance().getString(luckyGift.Type + luckyGift.ItemId);
					GameLogic.getInstance().user.GenerateNextID();
				}
				
				container_lucky.AddImage("", "GuiDailyQuest_ImgTxtLucky", 60, 13, true, ALIGN_LEFT_TOP);
			}
			
		}
	
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonMove(event, buttonID);
			switch (buttonID) 
			{
				case CTN_CHEST:
					var equip:FishEquipment = new FishEquipment();
					equip.SetInfo(luckyGift);
					GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equip, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
				break;
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			super.OnButtonOut(event, buttonID);
			switch (buttonID) 
			{
				case CTN_CHEST:
					GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				break;
			}
		}
		
		private function formatText(txtField:TextField, font:String = "Arial", color:int = 0x000000, size:int = 14, align:int = 3, isBold:Boolean = true):void
		{
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.color = color;
			txtFormat.size = size;
			txtFormat.font = font;
			txtFormat.bold = isBold;
			txtField.setTextFormat(txtFormat);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BUTTON_SHARE:
					// Hiện GUI feed
					GuiMgr.getInstance().GuiFeedWall.ShowFeed("feedDailyQuest" + questId, lucky,"",Localization.getInstance().getString("FeedIconfeedDailyQuest" + luckyGift.ItemType));
					this.Hide();
					break;
					
				case BUTTON_CLOSE:
					this.Hide();
					break;
					
				case BUTTON_GET:
					this.Hide();
					break;
			}
			
			// Add quà cho user
			GameLogic.getInstance().user.ReceiveDailyQuestGiftNew(bonusObject);
			
			// Đổi sang quest mới
			QuestMgr.getInstance().nextQuest();
		}
	}

}