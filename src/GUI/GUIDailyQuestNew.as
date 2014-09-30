package GUI 
{
	import com.bit101.components.List;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Data.ResMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.engine.JustificationStyle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.QuestBonus;
	import Logic.QuestInfo;
	import Logic.QuestMgr;
	import Logic.TaskInfo;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendAcceptGift;
	import NetworkPacket.PacketSend.SendCompleteDailyQuestNew;
	import NetworkPacket.PacketSend.SendDoneByXu;
	import NetworkPacket.PacketSend.SendGetDailyQuestNew;
	import NetworkPacket.PacketSend.SendResetDailyQuest;
	import NetworkPacket.PacketSend.SendUnlockByXu;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author longpt
	 */
	public class GUIDailyQuestNew extends BaseGUI
	{
		private var btnTemp:Button				//Ẩn hiện button
		private var isDataReady:Boolean;
		private const GUI_DAILYQUEST_EXIT:String = "BtnExit";
		private const GUI_DAILYQUEST_CLOSE:String = "BtnClose";
		private const GUI_DAILYQUEST_TAB1:String = "0";
		private const GUI_DAILYQUEST_TAB2:String = "1";
		private const GUI_DAILYQUEST_TAB3:String = "2";
		private const BTN_UNLOCK_QUEST_2:String = "UnlockQuest2";
		private const BTN_RETRY:String = "RetryDailyQuest";
		
		private var btnQuest1: Button;
		private var btnQuest2: Button;
		private var btnQuest3: Button;
		private var btnUnlockQuest2: Button;
		
		private var doneQuestImg1:Image;
		private var doneQuestImg2:Image;
		private var doneQuestImg3:Image;
		
		private var btnQuest1_img:Image;
		private var btnQuest2_img:Image;
		private var btnQuest3_img:Image;
		
		private var bg1:Image;
		private var bg2:Image;
		
		private var imgCantDoQuest:Image;
		
		public var questBox:ListBox = new ListBox(ListBox.LIST_Y, 5, 1);
		public var questList:Array;
		private var currentTab:String = "Quest1";
		private var cantDoQuest:TextField; 
		public var bonusContainer:Container;
		
		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		
		public function GUIDailyQuestNew(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIDailyQuestNew";
		}
		
		public override function InitGUI() :void
		{
			this.setImgInfo = function():void
			{
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				SetPos(120, 90);
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;	
				
				AddExitButton();
				
				questBox.setPos(10, 10);
				bonusContainer = new Container(img, "", 60, 350);
				
				var cmdNew:SendGetDailyQuestNew = new SendGetDailyQuestNew(true);
				Exchange.GetInstance().Send(cmdNew);
				
				OpenRoomOut();
			}
			
			LoadRes("GuiDailyQuest_Theme");
		}
		
		private function AddExitButton():void
		{
			//Add button đóng ở góc trên bên phải
			var bt:Button = AddButton(GUI_DAILYQUEST_EXIT, "BtnThoat", 542, 22, this);
		}
		
		private function AddUnlockButton():Button
		{
			//Add button ở giữa phía dưới
			var btn:Button = AddButton(BTN_UNLOCK_QUEST_2, "GuiDailyQuest_BtnNhanNhiemVu", 190, 400, this);
			return btn;
		}
		
		private function AddRetryButton():void
		{
			AddButton(BTN_RETRY, "GuiDailyQuest_BtnLamLai", 210, 395, this).SetVisible(false);
		}
		
		public function Init(dataAvailable:Boolean = true):void
		{
			isDataReady = dataAvailable;
			GameLogic.getInstance().BackToIdleGameState();
			//this.Hide();
			this.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		public override function  EndingRoomOut():void
		{
			if (isDataReady)
			{
				refreshComponent();
			}
		}
		
		/**
		 * Hiển thị lại nội dung GUI
		 * @param	dataAvailable
		 */
		
		public function refreshComponent(dataAvailable:Boolean = true):void
		{
			isDataReady = dataAvailable;
			if (!isDataReady || !IsFinishRoomOut)
			{
				return;
			}
			
			if (img == null) return;
			
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}

			var curQuest:int = QuestMgr.getInstance().curDailyQuest;
			
			if (curQuest != -1)
			{
				// Hiển thị Quest đang thực hiện
				showTab(String(curQuest));	
				ChangeTabPos(String(curQuest));
			}
			else
			{
				ClearComponent();
				
				// Disable tất cả các nút
				AddTabButtons();
				btnQuest1.SetDisable();
				btnQuest2.SetDisable();
				btnQuest3.SetDisable();
				
				var myLevel:int = GameLogic.getInstance().user.GetMyInfo().Level;
				var rcost:int = ConfigJSON.getInstance().GetDailyQuestXu(myLevel)["XuReset"];
				if ((QuestMgr.getInstance().retryTime > 0) || (GameLogic.getInstance().user.GetZMoney() < rcost))
				{
					GetButton(BTN_RETRY).SetDisable();
				}
				
				if (QuestMgr.getInstance().retryTime > 0)
				{
					tmpField = AddLabel(Localization.getInstance().getString("DailyQuestNotification4"), 93, 177, 0x000000, 0);
					var fmt:TextFormat = new TextFormat("Arial", 24, 0x604220, true);
					fmt.align = "center";
					tmpField.wordWrap = true;
					tmpField.width = 400;
					tmpField.setTextFormat(fmt);
				}
				else
				{
					tmpField = AddLabel(Localization.getInstance().getString("DailyQuestNotification3"), 93, 177, 0x000000, 0);
					var fmt1:TextFormat = new TextFormat("Arial", 24, 0x604220, true);
					fmt1.align = "center";
					tmpField.wordWrap = true;
					tmpField.width = 400;
					tmpField.setTextFormat(fmt1);
					
					// Nút làm lại nhiệm vụ hàng ngày
					GetButton(BTN_RETRY).SetVisible(true);
					
					var tmpField: TextField = AddLabel(String(rcost), 259, 399);
					formatText(tmpField, "Arial", 0x006600, 18, 1);
				}
			}
			
			if (QuestMgr.getInstance().isQuestDone())
			{
				var SendCompleteQuest:SendCompleteDailyQuestNew = new SendCompleteDailyQuestNew();
				Exchange.GetInstance().Send(SendCompleteQuest);
				GuiMgr.getInstance().GuiCompleteDailyQuestNew.Init(null, -1, false);
				
				var task:TaskInfo;
				// Hoàn thành quest tinh lực
				if (curQuest == 0) // quest 1
				{
					task = QuestMgr.getInstance().QuestPowerTinh[QuestMgr.QUEST_PT_DONE_QUEST_1].TaskList[0];
					if (!task.Status)
					{
						task.Num += 1;
					}
				}
				else if (curQuest == 1)	// quest 2
				{
					task = QuestMgr.getInstance().QuestPowerTinh[QuestMgr.QUEST_PT_DONE_QUEST_2].TaskList[0];
					if (!task.Status)
					{
						task.Num += 1;
					}
				}
				QuestMgr.getInstance().UpdatePointReceive();
			}
		}
		
		/**
		 * Hàm chuyển vị trí các Tab
		 * @param	quest:	Id của Quest
		 */
		
		public function ChangeTabPos(quest:String):void
		{
			btnQuest1_img.img.visible = false;
			btnQuest2_img.img.visible = false;
			btnQuest3_img.img.visible = false;
			
			switch (quest)
			{
				case GUI_DAILYQUEST_TAB1:
					//btnQuest1.SetFocus(true);
					btnQuest1_img.img.visible = true;
					break;					
				case GUI_DAILYQUEST_TAB2:
					//btnQuest2.SetFocus(true);
					btnQuest2_img.img.visible = true;
					break;				
				case GUI_DAILYQUEST_TAB3:
					//btnQuest3.SetFocus(true);
					btnQuest3_img.img.visible = true;
					break;				
			}
		}
		
		/**
		 * Hàm hiển thị nội dung của 1 Tab
		 * @param	quest:	Id của quest
		 */
		
		public function showTab(quest:String):void
		{
			ClearComponent();	// Xóa toàn bộ GUI !
			//AddTabButtons();	// Add buttons
			//
			bg1 = AddImage("", "GuiDailyQuest_ImgBgBonusDailyQuest1", 280, 315);		// Add nền
			bg2 = AddImage("", "GuiDailyQuest_ImgBgBonusDailyQuest2", 288, 310);		// Add nền
			bg1.img.visible = false;
			bg2.img.visible = false;
			
			// Hiển thị danh sách nhiệm vụ trong Quest
			var row:int = 3;
			var col:int = 1;
			questBox = AddListBox(ListBox.LIST_X, row, col, 6, 5); 			
			questBox.setPos(70, 111);
			questList = QuestMgr.getInstance().GetDailyQuestNew();
			for (var j:int = 0; j < questList[int(quest)]["TaskList"].length; j ++)
			{
				addQuestItem(questList[int(quest)]["TaskList"][j], int(quest), j);
			}
				
			// Hiển thị các phần thưởng nhận được trong quest
			if (int(quest) >= 0)
				addBonus(int(quest));
			
			// Thông báo chưa unlock nên chưa làm dc q2
			if ((int(quest) == 1) && (!QuestMgr.getInstance().isUnlock) && (QuestMgr.getInstance().curDailyQuest == 1))
			{
				imgCantDoQuest = AddImage("", "GuiDailyQuest_ImgCoverDailyQuest", 287, 255);
			}
			
			// Nếu như ấn sang Quest chưa được thực hiện (do chưa làm xong các quest trước đó)
			if (QuestMgr.getInstance().curDailyQuest < int(quest))
			{
				// Hiển thị nội dung thông báo chưa làm dc Quest này
				if ((imgCantDoQuest == null) || (imgCantDoQuest.img == null))
					imgCantDoQuest = AddImage("", "GuiDailyQuest_ImgCoverDailyQuest", 287, 255);
					
				AddImage("", "NPC_Mermaid_New", 260, 550);	
				AddImage("", "GuiDailyQuest_ImgQuote", 288, 142);
				cantDoQuest = AddLabel(Localization.getInstance().getString("DailyQuestNotification" + quest), 180, 114, 0x000000, 0);
				formatText(cantDoQuest, "Arial", 0x3299FF, 14, 0, true, 220);
			}

			AddTabButtons();	// Add buttons
		
			// Disable các nhiệm vụ đã làm xong (không cho view lại) và hiện icon hoàn thành
			if (int(quest) >= 0)
			{
				doneQuestImg1.img.visible = false;
				doneQuestImg2.img.visible = false;
				doneQuestImg3.img.visible = false;
				var curQ:int = QuestMgr.getInstance().curDailyQuest;
				for (var i:int = curQ-1; i >= 0; i--)
				{
					btnTemp = this.GetButton(String(i));
					btnTemp.SetDisable();
					if (i == 0)
					{
						doneQuestImg1.img.visible = true;
					}
					else if (i == 1)
					{
						doneQuestImg1.img.visible = true;
						doneQuestImg2.img.visible = true;
					}
					else
					{
						doneQuestImg1.img.visible = true;
						doneQuestImg2.img.visible = true;
						doneQuestImg3.img.visible = true;
					}
				}
			}			

			// Nếu không là quest 2, ẩn nút unlock Quest2
			if (btnUnlockQuest2 != null)
			btnUnlockQuest2.SetVisible(false);
			
			// Hiển thị nền
			bg1.img.visible = false;
			bg2.img.visible = false;
			
			switch (quest)
			{
				case GUI_DAILYQUEST_TAB1:
					bg1.img.visible = true;
					break;
				case GUI_DAILYQUEST_TAB2:
					// Nếu là quest 2, hiển thị button unlock
					// Nếu chưa unlock quest 2
					if (!QuestMgr.getInstance().isUnlock)
					{
						//Hiển thị button unlock bằng xu
						btnUnlockQuest2 = AddUnlockButton();
						var tFld:TextField = AddLabel(String(QuestMgr.getInstance().XuInfo["XuUnlock"]), 299, 403, 0x00000, 1);
						formatText(tFld, "Arial", 0x006600, 20, 3, true);		
						//AddImage("", "IcZingXu", 350, 390);
						var zmoney:int = GameLogic.getInstance().user.GetZMoney();
						var curZmoney:int = QuestMgr.getInstance().XuInfo["XuUnlock"];
						var curDailyQuest:int = QuestMgr.getInstance().curDailyQuest;
						var isDisable:Boolean;
						if (GameLogic.getInstance().isMonday())
						{//không cần biết đủ tiền hay không đủ tiền
							isDisable = curDailyQuest < int(quest);//quan tâm đến việc thực hiện quest 1 chưa
							btnUnlockQuest2.SetEnable(!isDisable);
							tFld.text = "0";
							formatText(tFld, "Arial", 0x006600, 20, 3, true);
						}
						else
						{
							isDisable = (zmoney < curZmoney) || (curDailyQuest < int(quest));
							btnUnlockQuest2.SetEnable(!isDisable);
						}
					}
					bg2.img.visible = true;
					break;
				case GUI_DAILYQUEST_TAB3:
					bg2.img.visible = true;
					break;
			}
		}
		
		// Add các nút
		private function AddTabButtons():void 
		{
			btnQuest1 = AddButton(GUI_DAILYQUEST_TAB1, "GuiDailyQuest_BtnDailyQuest1", 54, 68, this);
			btnQuest1_img = AddImage("", "GuiDailyQuest_ImgBgBtnDailyQuest1", 54, 68, true, ALIGN_LEFT_TOP);
			btnQuest1_img.img.visible = false;

			btnQuest2 = AddButton(GUI_DAILYQUEST_TAB2, "GuiDailyQuest_BtnDailyQuest2", 160, 68, this);
			btnQuest2_img = AddImage("", "GuiDailyQuest_ImgBgBtnDailyQuest2", 160, 68, true, ALIGN_LEFT_TOP);
			btnQuest2_img.img.visible = false;

			btnQuest3 = AddButton(GUI_DAILYQUEST_TAB3, "GuiDailyQuest_BtnDailyQuest3", 266, 68, this);
			btnQuest3_img = AddImage("", "GuiDailyQuest_ImgBgBtnDailyQuest3", 266, 68, true, ALIGN_LEFT_TOP);
			btnQuest3_img.img.visible = false;
			
			// Các Image hiển thị Hoàn thành Quest
			doneQuestImg1 = AddImage("", "GuiDailyQuest_IcDoneDailyQuest", 56, 70);
			doneQuestImg2 = AddImage("", "GuiDailyQuest_IcDoneDailyQuest", 162, 70);
			doneQuestImg3 = AddImage("", "GuiDailyQuest_IcDoneDailyQuest", 268, 70);
			
			// Add các nút
			AddExitButton();
			//AddCloseButton();
			AddRetryButton();
		}
		
		/**
		 * Hàm hiển thị các bonus của 1 quest
		 */
		public function addBonus(questId:int):void
		{
			var tF:TextField;
			var quest:QuestInfo = questList[questId] as QuestInfo;
			var dx:int;
			var x0:int;
			var x1:int = 264;
			
			if (questId == 0)
			{
				dx = 65;
				x0 = 219;
			}
			else
			{
				dx = 65;
				x0 = 120;
			}
			
			var bonus1:QuestBonus = quest.Bonus[0];

			for (var i:String in bonus1["Sure"])
			{
				var image:Image;
				var gift:Object = bonus1["Sure"][i];
				
				var normalCon:Container = AddContainer("", "GuiDailyQuest_ImgBgGiftNormal", x0, 272);
				var toolTip:TooltipFormat = new TooltipFormat();
				
				switch(gift.ItemType)
				{
					case "Money":
						image = normalCon.AddImage("", "IcGold", 11, 2, true, ALIGN_LEFT_TOP);
						image.SetScaleXY(1.8);
						tF = normalCon.AddLabel(Ultility.StandardNumber(gift.Num), -20, 42, 0x0000, 1, 0xffffff);
						formatText(tF, "Arial", 0xFF3300, 15, 1, true);
						x0 += dx;
						
						// Tooltip
						toolTip.text = "Tiền vàng";
						normalCon.setTooltip(toolTip);
						break;
					case "Exp":
						image = normalCon.AddImage("", "IcExp", 8, 2, true, ALIGN_LEFT_TOP);
						image.SetScaleXY(1.5);
						tF = normalCon.AddLabel(Ultility.StandardNumber(gift.Num), -20, 42, 0x0000, 1, 0xffffff);
						formatText(tF, "Arial", 0xFF3300, 15, 1, true);
						x0 += dx;
						
						// Tooltip
						toolTip.text = "Kinh nghiệm";
						normalCon.setTooltip(toolTip);
						break;			
				}			
			}
			
			if (questId > 0)
			{
				for (var j:String in bonus1["Lucky"])
				{
					var image1:Image;
					var image2:Image;
					var bonus:Object = bonus1["Lucky"][j];
					var con:Container = AddContainer("", "", x1, 272);
					var tip:TooltipFormat = new TooltipFormat();
					
					switch(bonus.ItemType)
					{
						case "Money":
							con.LoadRes("GuiDailyQuest_ImgBgGiftNormal");
							image1 = con.AddImage("", "IcGold", 11, 2, true, ALIGN_LEFT_TOP);
							image1.SetScaleXY(1.8);
							tF = con.AddLabel(Ultility.StandardNumber(bonus.Num), -20, 42, 0x000000, 1, 0xffffff);
							formatText(tF, "Arial", 0xFF3300, 15, 1, true);
							x1 += dx;
							
							// Tooltip
							tip.text = "Tiền vàng";
							con.setTooltip(tip);
							break;
						case "Exp":
							con.LoadRes("GuiDailyQuest_ImgBgGiftNormal");
							image1 = con.AddImage("", "IcExp", 8, 2, true, ALIGN_LEFT_TOP);
							image1.SetScaleXY(1.5);
							image1
							tF = con.AddLabel(Ultility.StandardNumber(bonus.Num), -20, 42, 0x000000, 1, 0xffffff);
							formatText(tF, "Arial", 0xFF3300, 15, 1, true);
							x1 += dx;
							
							// Tooltip
							tip.text = "Kinh nghiệm";
							con.setTooltip(tip);
							break;		
						case "Material":
							con.LoadRes("GuiDailyQuest_ImgBgGiftSpecial");
							image1 = con.AddImage("", "Material" + bonus.ItemId, 31, 23, true, ALIGN_LEFT_TOP);
							image1.SetScaleXY(1.2);
							tF = con.AddLabel(Ultility.StandardNumber(bonus.Num), -20, 42, 0x000000, 1, 0xffffff);
							formatText(tF, "Arial", 0xFF3300, 15, 1, true);
							x1 += dx;
							
							// Tooltip
							tip.text = "Ngư thạch cấp " + bonus.ItemId;
							con.setTooltip(tip);
							break;			
						case "RankPointBottle":
							con.LoadRes("GuiDailyQuest_ImgBgGiftSpecial");
							image1 = con.AddImage("", bonus.ItemType + bonus.ItemId, 36, 30, true, ALIGN_CENTER_CENTER);
							image1.SetScaleXY(0.8);
							tF = con.AddLabel(Ultility.StandardNumber(bonus.Num), -20, 42, 0x000000, 1, 0xffffff);
							formatText(tF, "Arial", 0xFF3300, 15, 1, true);
							x1 += dx;
							
							// Tooltip
							tip.text = Localization.getInstance().getString(String(bonus.ItemType + bonus.ItemId));
							con.setTooltip(tip);
							break;		
						case "EquipmentChest":
							con.LoadRes("GuiDailyQuest_ImgBgGiftSpecial");
							image1 = con.AddImage("", bonus.ItemType + bonus.Color + "_" + bonus.ItemType, 0, 0, true, ALIGN_LEFT_TOP);
							//image1.SetScaleXY(1.2);
							image2 = con.AddImage("", "ImgLaMa" + bonus.ItemId, 47, 36, true, ALIGN_LEFT_TOP);
							// Tooltip
							tip.text = Localization.getInstance().getString(String(bonus.ItemType + bonus.ItemId));
							con.setTooltip(tip);
							x1 += dx;
							break;
						case "JewelChest":
							con.LoadRes("GuiDailyQuest_ImgBgGiftSpecial");
							image1 = con.AddImage("", bonus.ItemType + bonus.Color + "_" + bonus.ItemType, 0, 0, true, ALIGN_LEFT_TOP);
							//image1.SetScaleXY(1.2);
							image2 = con.AddImage("", "ImgLaMa" + bonus.ItemId, 47, 36, true, ALIGN_LEFT_TOP);
							// Tooltip
							tip.text = Localization.getInstance().getString(String(bonus.ItemType + bonus.ItemId));
							con.setTooltip(tip);
							x1 += dx;
							break;
						case "Ring":
							con.LoadRes("GuiDailyQuest_ImgBgGiftSpecial");
							// Add nền xịn cho đồ đb và quý
							if (int(bonus.Color) != FishEquipment.FISH_EQUIP_COLOR_WHITE)
							{
								image1 = con.AddImage("", FishEquipment.GetBackgroundName(int(bonus.Color)), 0, 0, true, ALIGN_LEFT_TOP);
								image1.SetScaleX(0.9);
								image1.SetScaleY(0.78);
							}
							
							image1 = con.AddImage("", bonus.ItemType + bonus.ItemId + "_Shop", 31, 23, true, ALIGN_LEFT_TOP)
							image1.FitRect(50, 50, new Point(5, 5));
							tF = con.AddLabel(Ultility.StandardNumber(bonus.Num), -20, 42, 0x0000, 1, 0xffffff);
							formatText(tF, "Arial", 0xFF3300, 15, 1, true);
							x1 += dx;
							
							// Glow lên tùy theo màu
							FishSoldier.EquipmentEffect(image1.img, bonus.Color);
							
							// Tooltip
							tip.text = Localization.getInstance().getString(bonus.ItemType + bonus.ItemId) + " - " + Localization.getInstance().getString("EquipmentColor" + bonus.Color);
							con.setTooltip(tip);
							break;
						case "Sparta":
							con.LoadRes("GuiDailyQuest_ImgBgGiftSpecial");
							var setInfo:Function = function():void
							{
								//Vẽ aura bằng glowFilter
								var cl:int = 0xff0000;
								TweenMax.to(this.img, 1, { glowFilter: { color:cl, alpha:1, blurX:37, blurY:37, strength:1.5 }} );								
							}
							image1 = con.AddImage("", "Sparta", 45, 30, true, ALIGN_LEFT_TOP, false, setInfo);
							x1 += dx;
							
							// Tooltip
							tip.text = "Cá chiến binh";
							con.setTooltip(tip);								
							break;		
						case "Superman":
							con.LoadRes("GuiDailyQuest_ImgBgGiftSpecial");
							var setInfo1:Function = function():void
							{
								//Vẽ aura bằng glowFilter
								var cl:int = 0xff0000;
								TweenMax.to(this.img, 1, { glowFilter: { color:cl, alpha:1, blurX:37, blurY:37, strength:1.5 }} );								
							}
							image1 = con.AddImage("", "Superman", 30, 30, true, ALIGN_LEFT_TOP, false, setInfo1);
							image1.SetScaleXY(0.7);
							x1 += dx;
							
							// Tooltip
							tip.text = GuiMgr.getInstance().GuiStore.GetNameFishSpecial("Superman");
							con.setTooltip(tip);	
							break;
					}
				}
			}
		
		}
		
		/**
		 * Hàm thay đổi trạng thái quest 2 sau khi được unlock
		 */
		public function unlockQuest2():void
		{
			refreshComponent();
		}
		
		/**
		 * Hàm hiển thị 1 task của quest
		 * @param	task
		 * @param	questId
		 * @param	taskId
		 */
		public function addQuestItem(task:TaskInfo, questId: int, taskId: int):void
		{
			var xuxu:int = GameLogic.getInstance().user.GetZMoney();			// Số xu của user
			var txtFld:TextField;							
			var xu:Object = QuestMgr.getInstance().XuInfo;						// Thông tin xu phải trả để làm nhanh (unlock)
			
			// Khởi tạo container chứa task
			var container:Container = new Container(img, "GuiDailyQuest_ImgBgContainerDailyQuest", 20, 20);
			var quest:QuestInfo = questList[questId] as QuestInfo;
			var task: TaskInfo = quest.TaskList[taskId] as TaskInfo;
			
			//add button trả xu để hoàn thành task
			btnTemp = container.AddButton("doneByXu_" + task.Id, "GuiDailyQuest_BtnLamNhanh", 330, 4, this);
			
			// nếu như task đã hoàn thành
			if (task.Status == true)
			{
				container.AddImage("", "GuiDailyQuest_IcComplete1",  16, 12);	// Hiển thị icon task đã hoàn thành
				btnTemp.SetVisible(false);							// Ẩn nút hoàn thành nhanh
				task.Num = task.MaxNum;								// Số lần đã thực hiện = tổng số yêu cầu
			}
			else
			{
				// Nếu chưa unlock quest 2 thì không cho hoàn thành nhanh
				if (((!QuestMgr.getInstance().isUnlock) && (questId == 1)) || (questId > QuestMgr.getInstance().curDailyQuest))
				{
					if (txtFld)	txtFld.visible = false;
					btnTemp.SetVisible(false);
				}
				
				// Nếu chưa hoàn thành task thì hiển thị button hoàn thành nhanh
				btnTemp.SetVisible(true);
				txtFld = container.AddLabel(xu[String(questId + 1)], 315, 0, 0x000000, 2);	// Hiển thị số xu
				formatText(txtFld, "Arial", 0x006600, 20, 3, true);							// cần thiết
			}
			
			// Nếu ko đủ xu -> disable nút làm nhanh
			if (xuxu < xu[String(questId + 1)])
			{
				btnTemp.SetDisable();
			}
			
			// Hiển thị số task/tổng số task
			txtFld = container.AddLabel(Ultility.StandardNumber(task.Num) + "/" + Ultility.StandardNumber(task.MaxNum), 190, 4, 0x00000, 2);
			// Tô màu tương ứng
			if (task.Num == task.MaxNum)
			{
				formatText(txtFld, "Arial", 0x009900, 16, 0 , true);
			}
			else
			{
				formatText(txtFld, "Arial", 0xFF3300, 16, 0 , true);
			}
			
			// Hiển thị mô tả task
			txtFld = container.AddLabel(Localization.getInstance().getString("DailyDescriptionNew" + task.Id) , 50, 4, 0xaf09d2, 0);
			formatText(txtFld, "Arial", 0x330000, 15, 0, true);
	
			// Add task vào listBox
			questBox.addItem(String(task.Id), container);
		}

		private function formatText(txtField:TextField, font:String = "Arial", color:int = 0x000000, size:int = 14, align:int = 3, isBold:Boolean = true, width:int = -1 ):void
		{
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.color = color;
			txtFormat.size = size;
			txtFormat.font = font;
			txtFormat.bold = isBold;
			txtField.setTextFormat(txtFormat);
			if (width != -1)
			{
				txtField.wordWrap = true;
				txtField.width = width;
				
			}
		}
		
		public function processUnlock():void
		{
			// Cập nhật trạng thái mở khóa luôn mà ko chờ đợi sơ vơ
			// Đoạn code nếu chờ ở Exchange (search CMD_UNLOCK_DAILYQUEST)
			var cost:int = QuestMgr.getInstance().XuInfo["XuUnlock"];
			if (GameLogic.getInstance().isMonday())
			{
				cost = 0;
			}
			QuestMgr.getInstance().isUnlock = true;
			GameLogic.getInstance().user.UpdateUserZMoney( -cost);
			QuestMgr.getInstance().UnlockQuest2();			
		}
		
		public function processDoneQuestByXu(taskId:String):void
		{
			// Cập nhật hoàn thành task luôn mà ko chờ đợi server nữa :(
			// Đoạn code nếu chờ ở Exchange (search DONE_DAILY_QUEST_BY_XU)
			var QuestName:String = String(QuestMgr.getInstance().curDailyQuest + 1);
			var costFast:int = QuestMgr.getInstance().XuInfo[QuestName];
			GameLogic.getInstance().user.UpdateUserZMoney( -costFast);
			QuestMgr.getInstance().DoneTaskWithXu("Quest" + QuestName, int(taskId));
		}
		
		public function processResetQuestByXu():void
		{
			var myLevel:int = GameLogic.getInstance().user.GetMyInfo().Level;
			var costReset:int = ConfigJSON.getInstance().GetDailyQuestXu(myLevel)["XuReset"];
			GameLogic.getInstance().user.UpdateUserZMoney( -costReset);
			
			var CmdSendGetDailyQuest:SendGetDailyQuestNew = new SendGetDailyQuestNew();
			Exchange.GetInstance().Send(CmdSendGetDailyQuest);
			refreshComponent(false);
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_DAILYQUEST_EXIT:
				case GUI_DAILYQUEST_CLOSE:
					this.Hide();
					break;
				case GUI_DAILYQUEST_TAB1:
					showTab(GUI_DAILYQUEST_TAB1);
					ChangeTabPos(buttonID);
					break;
				case GUI_DAILYQUEST_TAB2:
					showTab(GUI_DAILYQUEST_TAB2);
					ChangeTabPos(buttonID);
					break;
				case GUI_DAILYQUEST_TAB3:
					showTab(GUI_DAILYQUEST_TAB3);
					ChangeTabPos(buttonID);
					break;
				case BTN_UNLOCK_QUEST_2:
					var CmdUnlockQuest2:SendUnlockByXu = new SendUnlockByXu();
					Exchange.GetInstance().Send(CmdUnlockQuest2);
					btnUnlockQuest2.SetDisable();
					
					processUnlock();
					break;
				case BTN_RETRY:
					var CmdResetDailyQuest:SendResetDailyQuest = new SendResetDailyQuest();
					Exchange.GetInstance().Send(CmdResetDailyQuest);
					GetButton(buttonID).SetDisable();
					
					// Quest PowerTinh
					var task:TaskInfo = QuestMgr.getInstance().QuestPowerTinh[QuestMgr.QUEST_PT_RETRY_QUEST].TaskList[0] as TaskInfo;
					if (!task.Status)
					{
						task.Num += 1;
					}
					QuestMgr.getInstance().UpdatePointReceive();
					
					processResetQuestByXu();
					break;
				default:
					var arr:Array = buttonID.split("_");
					if (arr[0] == "doneByXu")
					{
						if (GameLogic.getInstance().user.GetZMoney() >= 1)
						{
							var cmdDoneByXu:SendDoneByXu = new SendDoneByXu(QuestMgr.getInstance().curDailyQuest, arr[1]);
							Exchange.GetInstance().Send(cmdDoneByXu);
							var btn:Button = questBox.getItemById(arr[1]).GetButton(buttonID);
							btn.SetDisable();
							
							processDoneQuestByXu(arr[1]);
						}
					}
					break;
			}
		}
	}
}