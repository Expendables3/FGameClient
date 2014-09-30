package GUI.Reputation
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ScrollBar;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.Reputation.SendGetGiftReputation;
	import NetworkPacket.PacketSend.Reputation.SendGetQuickReputation;
	import particleSys.myFish.CometEmit;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GuiReputation extends BaseGUI
	{
		private static const VO_DANH:int = 1;
		private static const TIEU_TU:int = 2;
		private static const DAI_HIEP:int = 3;
		private static const CAI_THE:int = 4;
		private static const SIEU_PHAM:int = 5;
		private static const TUYET_THE:int = 6;
		private static const DA_LANG:int = 7;
		private static const SO_PHUONG:int = 8;
		private static const CUONG_LONG:int = 9;
		private static const CHIEN_LONG:int = 10;
		private static const THAN_LONG:int = 11;
		private static const AC_LONG:int = 12;
		private static const THAN_TUOC:int = 13;
		private static const TU_THAN:int = 14;
		private static const CHIEN_THAN:int = 15;
		
		private static const QUEST:String = "Quest";
		private static const QUICK:String = "Quick";
		private static const SEPERATE:String = "_";
		private static const BTN_CLOSE:String = "BtnClose";
		private static const CTN_FAME:String = "ctnFame";
		
		public var ctnAllQuest:Container;
		public var listQuest:ListBox;
		public var ctnFame:Container;
		public var imgFame:Image;
		public var imgFameChild:DisplayObject
		public var typeFame:Image;
		public var mask:Image;
		public var wave:Image;
		public var maskWave:Image;
		public var nameFame:Image;
		public var scoreFame:TextField;
		public var scoreLost:TextField;
		public var tfLevelReputation:TextField
		
		private var emitStar:Array = [];
		
		private var fameLevel:int;
		private var famePoint:int;
		private var fameQuest:Array;
		private var fameConf:Object;
		private var fameBonusConf:Object;
		private var posImgFame:Point = new Point();
		private var posImgFameSub:Point = new Point();
		
		public function GuiReputation(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP)
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		public override function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				addContent();
				OpenRoomOut();
			}
			
			LoadRes("GuiReputation");
		}
		
		private function addContent():void
		{
			var fm:TextFormat = new TextFormat();
			fm.bold = true;
			fm.size = 14;
			//AddButton(BTN_CLOSE, "GuiReputation_btnRed", 255, 449);
			AddButton(BTN_CLOSE, "BtnThoat", 674, 127);
			//AddLabel("Đóng", 245, 452, 0xffffff).setTextFormat(fm);
			// add listbox các quest
			ctnAllQuest = AddContainer("", "GuiReputation_ctnAllQuest", 266, 158);
			var ctnQuest:Container;
			listQuest = ctnAllQuest.AddListBox(ListBox.LIST_Y, 5, 1, 0, 5, true);
			listQuest.setPos(20, 17);
			var scroll:ScrollBar = ctnAllQuest.AddScroll("", "GuiReputation_scroll", 368, 0);
			scroll.setScrollImage(listQuest.img, listQuest.img.width, 330);
			fm.bold = true;			
			var i:int;
			for (i = 0; i < fameQuest.length; i++)
			{
				var id:int = fameQuest[i]["Id"];
				var questContent:TextField;
				var questConf:Object = fameConf[fameLevel][id];
				var questName:String = getquetName(id, fameQuest[i]["Action"]);
				if (fameQuest[i]["Num"] >= fameConf[fameLevel][id]["Num"])
				{
					ctnQuest = ctnAllQuest.AddContainer("", "GuiReputation_ctnQuestDone", 10, 12);
					if (!fameQuest[i]["isGetGift"])
					{
						ctnQuest.AddButton(QUEST + SEPERATE + id, "GuiReputation_btnReceive", 254, 37, this);
						fm.size = 18;						
						ctnQuest.AddLabel(fameConf[fameLevel][id]["Num"] + " / " + fameConf[fameLevel][id]["Num"], 235, 8, 0x009900, 1).setTextFormat(fm);
					}
					else
					{
						ctnQuest.AddImage("", "GuiReputation_imgReceived", 254, 9, true, ALIGN_LEFT_TOP);
					}
					questContent = ctnQuest.AddLabel(questName, 74, 11, 0x009900, 0);
				}
				else
				{
					ctnQuest = ctnAllQuest.AddContainer("", "GuiReputation_ctnQuest", 10, 12);
					ctnQuest.AddButton(QUICK + SEPERATE + id, "GuiReputation_btnZMoney", 254, 37, this);
					fm.size = 18;			
					ctnQuest.AddLabel(fameQuest[i]["Num"] + " / " + fameConf[fameLevel][id]["Num"], 235, 8, 0xffffff, 1).setTextFormat(fm);
					fm.size = 14;
					ctnQuest.AddLabel(Ultility.StandardNumber(fameConf[fameLevel][id]["ZMoney"]), 235, 34, 0x000000, 1).setTextFormat(fm);
					questContent = ctnQuest.AddLabel(questName, 74, 11, 0xffffff, 0, 0);
					
				}
				var ctnIcon:Container = ctnQuest.AddContainer("", "GuiReputation_ctnFameType", 35, 32);
				ctnIcon.AddImage("", "GuiReputation_IconFame" + fameLevel, 0, 0, true, ALIGN_LEFT_TOP);
				ctnIcon.setTooltipText("Điểm uy danh nhận được\nkhi hoàn thành nhiệm vụ");
				questContent.width = 160;
				questContent.wordWrap = true;
				fm.size = 12;
				//fm.align = TextFormatAlign.JUSTIFY;
				fm.color = null;
				questContent.setTextFormat(fm);
				listQuest.addItem(QUEST + SEPERATE + id, ctnQuest);
				if (GameLogic.getInstance().CurServerTime >= fameBonusConf["FromTime"] && GameLogic.getInstance().CurServerTime <= fameBonusConf["ToTime"])
				{
					ctnQuest.AddLabel("+" + fameConf[fameLevel][id]["AddPoint"], -38, 42, 0xffffff, 2, 0);
					ctnQuest.AddImage("", "GuiReputation_x" + fameBonusConf["Rate"], 53, 1, true, ALIGN_LEFT_TOP);
				}
				else
				{
					ctnQuest.AddLabel("+" + fameConf[fameLevel][id]["AddPoint"], -38, 42, 0xffffff, 2, 0);
				}
			}
			if (listQuest.length <= 5)
			{
				scroll.visible = false;
			}
			else
			{
				scroll.visible = true;
			}
			
			// thông tin chung về uy danh
			ctnFame = AddContainer(CTN_FAME, "GuiReputation_ctnFameType", 90, 185, true, this);
			ctnFame.AddImage("", "fameLable", 0, 0, true, ALIGN_LEFT_TOP);
			switch(fameLevel)
			{
				case VO_DANH:
					posImgFame.x = 43;
					posImgFame.y = 136;
					posImgFameSub.x = posImgFame.x - 22;
					posImgFameSub.y = posImgFame.y + 60;
					break;
				case TIEU_TU:
					posImgFame.x = 44;
					posImgFame.y = 137;
					posImgFameSub.x = posImgFame.x - 22;
					posImgFameSub.y = posImgFame.y + 60;
					break;
				case DAI_HIEP:
					posImgFame.x = 45;
					posImgFame.y = 152;
					posImgFameSub.x = posImgFame.x - 22;
					posImgFameSub.y = posImgFame.y + 60;
					break;
				case CAI_THE:
					posImgFame.x = 45;
					posImgFame.y = 149;
					posImgFameSub.x = posImgFame.x - 22;
					posImgFameSub.y = posImgFame.y + 60;
					break;
				case SIEU_PHAM:
					posImgFame.x = 45;
					posImgFame.y = 150;
					posImgFameSub.x = posImgFame.x - 22;
					posImgFameSub.y = posImgFame.y + 60;
					break;
				case TUYET_THE:
					posImgFame.x = 44;
					posImgFame.y = 170;
					posImgFameSub.x = posImgFame.x - 22;
					posImgFameSub.y = posImgFame.y + 60;
					break;
				case DA_LANG:
					posImgFame.x = 38;
					posImgFame.y = 153;
					posImgFameSub.x = posImgFame.x - 22;
					posImgFameSub.y = posImgFame.y + 60;
					break;
				case SO_PHUONG:
					posImgFame.x = 44;
					posImgFame.y = 177;
					posImgFameSub.x = posImgFame.x - 22;
					posImgFameSub.y = posImgFame.y + 60;
					break;
				case CUONG_LONG:
					posImgFame.x = 47;
					posImgFame.y = 176;
					posImgFameSub.x = posImgFame.x - 22;
					posImgFameSub.y = posImgFame.y + 60;
					break;
				case CHIEN_LONG:
					posImgFame.x = 47;
					posImgFame.y = 185;
					posImgFameSub.x = posImgFame.x - 20;
					posImgFameSub.y = posImgFame.y + 64;
					break;
				case THAN_LONG:
					posImgFame.x = 45;
					posImgFame.y = 236;
					posImgFameSub.x = posImgFame.x - 15;
					posImgFameSub.y = posImgFame.y + 70;
					break;
				case AC_LONG:
					posImgFame.x = 40;
					posImgFame.y = 206;
					posImgFameSub.x = posImgFame.x - 19;
					posImgFameSub.y = posImgFame.y + 70;
					break;
				case THAN_TUOC:
					posImgFame.x = 53;
					posImgFame.y = 169;
					posImgFameSub.x = posImgFame.x - 20;
					posImgFameSub.y = posImgFame.y + 66;
					break;
				case TU_THAN:
					posImgFame.x = 52;
					posImgFame.y = 172;
					posImgFameSub.x = posImgFame.x - 25;
					posImgFameSub.y = posImgFame.y + 87;
					break;
				case CHIEN_THAN:
					posImgFame.x = 93;
					posImgFame.y = 225;
					posImgFameSub.x = posImgFame.x - 27;
					posImgFameSub.y = posImgFame.y + 73;
					break;
			}
			if(fameLevel <= CUONG_LONG)
			{
				typeFame = ctnFame.AddImage("", "GuiReputation_ctnFameType" + fameLevel, posImgFame.x, posImgFame.y, true, ALIGN_LEFT_TOP);
				mask = ctnFame.AddImage("", "GuiReputation_mask", typeFame.CurPos.x, typeFame.CurPos.y, true, ALIGN_LEFT_TOP);
				typeFame.img.mask = mask.img
				maskWave = ctnFame.AddImage("", "GuiReputation_maskWave", typeFame.CurPos.x, typeFame.CurPos.y, true, ALIGN_LEFT_TOP);
				wave = ctnFame.AddImage("", "GuiReputation_wave", typeFame.CurPos.x, typeFame.CurPos.y, true, ALIGN_LEFT_TOP);
				wave.img.mask = maskWave.img;
				wave.img.blendMode = BlendMode.ADD;
				imgFame = ctnFame.AddImage("", "GuiReputation_imgFameType" + fameLevel, typeFame.CurPos.x, typeFame.CurPos.y, true, ALIGN_LEFT_TOP);
			}
			else
			{
				imgFame = ctnFame.AddImage("", "GuiReputation_imgFameType" + fameLevel, posImgFame.x, posImgFame.y, true, ALIGN_LEFT_TOP);
				imgFameChild = imgFame.img.getChildByName("imgFameType" + fameLevel);
				mask = new Image(imgFame.img, "GuiReputation_mask", imgFameChild.x, imgFameChild.y, true, ALIGN_LEFT_TOP);
				imgFameChild.mask = mask.img;
				maskWave = new Image(imgFame.img, "GuiReputation_maskWave", imgFameChild.x, imgFameChild.y, true, ALIGN_LEFT_TOP);
				wave = new Image(imgFame.img, "GuiReputation_wave", imgFameChild.x, imgFameChild.y, true, ALIGN_LEFT_TOP);				
				imgFame.img.setChildIndex(wave.img, imgFame.img.getChildIndex(imgFameChild) + 1);
				wave.img.mask = maskWave.img;
				wave.img.blendMode = BlendMode.ADD;
				
				if (fameLevel == THAN_TUOC)
				{
					imgFame.SetScaleXY(0.8);
				}
				else if (fameLevel == TU_THAN)
				{
					imgFame.SetScaleXY(0.76);
				}
			}
			
			fm.bold = true;
			fm.size = 10;
			nameFame = ctnFame.AddImage("", "GuiReputation_fameName" + fameLevel, 73, 14, true, ALIGN_LEFT_TOP);
			nameFame.SetScaleXY(0.54);
			fm.bold = true;
			fm.size = 12;
			scoreFame = ctnFame.AddLabel(Ultility.StandardNumber(famePoint) + " / " + Ultility.StandardNumber(fameConf[fameLevel]["RequirePoint"]), posImgFame.x - 22, posImgFame.y - 25, 0xffffff, 1, 0);
			scoreFame.setTextFormat(fm);
			scoreFame.defaultTextFormat = fm;
			scoreLost = ctnFame.AddLabel("-" + Ultility.StandardNumber(fameConf[fameLevel]["SubtractPoint"]), posImgFameSub.x, posImgFameSub.y, 0xff0000, 1, 0xffffff);
			scoreLost.setTextFormat(fm);
			scoreLost.defaultTextFormat = fm;
			
			fm.size = 14;
			AddLabel("Danh sách nhiệm vụ sẽ được làm mới khi qua ngày", 270, 568, 0xffffff, 0, 0).setTextFormat(fm);
			if (GameLogic.getInstance().CurServerTime >= fameBonusConf["FromTime"] && GameLogic.getInstance().CurServerTime <= fameBonusConf["ToTime"])
			{
				fm.align = "center";
				var date:Date = new Date((fameBonusConf["FromTime"] + 25200) * 1000);
				var st1:String = date.getUTCDate() + "/" + (date.getUTCMonth() + 1);
				date.setTime((fameBonusConf["ToTime"] + 25200) * 1000);
				var st2:String = date.getUTCDate() + "/" + (date.getUTCMonth() + 1);
				ctnFame.AddLabel("Nhân " + fameBonusConf["Rate"] + " điểm Uy Danh nhận\nđược từ " + st1 + " - " + st2, 29, 330, 0xffff00, 1, 0).setTextFormat(fm);
			}
			tfLevelReputation = AddLabel("", 110, 160, 0x000000, 1, 0x000000);
			fm = new TextFormat("Arial", 12, 0xffffff, true);
			tfLevelReputation.defaultTextFormat = fm;
			tfLevelReputation.text = "Cấp " + GameLogic.getInstance().user.getReputationLevel();
			updateReputaion();
		}
		
		private function getquetName(id:int, action:String):String
		{
			if (id == 34)
			{
				var asd:int = 1;
			}
			var name:String = Localization.getInstance().getString("Reputation_" + action);
			var questConf:Object = fameConf[fameLevel][id];
			
			if (name == "")
			{
				trace("action", action);
			}
			if (name.search("@QuestId") >= 0)
			{
				name = name.replace("@QuestId", questConf["OutputParam"][1]["Num"]);
			}
			if (name.search("@GemId") >= 0)
			{
				name = name.replace("@GemId", questConf["OutputParam"][1]["Num"]);
			}
			if (name.search("@enchantLevel") >= 0)
			{
				name = name.replace("@enchantLevel", questConf["OutputParam"][1]["Num"]);
			}
			if (name.search("@RoundId") >= 0)
			{				
				name = name.replace("@RoundId", questConf["OutputParam"][2]["Num"]);
			}
			if (name.search("@SeaId") >= 0)
			{
				name = name.replace("@SeaId", Localization.getInstance().getString("Sea" + questConf["OutputParam"][1]["Num"]));
			}
			if (name.search("@Mode") >= 0)
			{
				name = name.replace("@Mode", Localization.getInstance().getString("Intensity" + questConf["OutputParam"][1]["Num"]));
			}
			
			switch(action)
			{
				case "acttackMonster":
					if (questConf["InputParam"] && questConf["InputParam"][1]["Name"] == "SeaId" &&
						questConf["InputParam"][1]["Num"] == 3)
					{
						name = "Chiến thắng Boss Pipi tại Biển Băng Giá"
					}
					if (questConf["InputParam"] && questConf["InputParam"][1]["Name"] == "SeaId" &&
						questConf["InputParam"][1]["Num"] == 4)
					{
						if(questConf["OutputParam"][1]["Num"] == 1)
						{
							name = "Tiêu diệt thằn lằn xanh trong Biển Hắc Lâm";
						}
						else if(questConf["OutputParam"][1]["Num"] == 3)
						{
							name = "Tiêu diệt rắn chúa trong Biển Hắc Lâm";
						}
						else
						{
							name = "Tiêu diệt " + questConf["Num"] + " vị thần trong Biển Hắc Lâm";
						}					
					}
					break;
				case "acttackBoss":
					if (questConf["InputParam"] && questConf["InputParam"][1]["Name"] == "SeaId" &&
						questConf["InputParam"][1]["Num"] == 3)
					{
						name = "Chiến thắng đầu " + (questConf["InputParam"][2]["Num"] - 1) + " của Boss Biển Băng Giá"
					}
					
					break;
			}
			return name;
		}
		
		public function updateReputaion():void
		{
			if (!fameConf)
				return;
			
			scoreFame.text = Ultility.StandardNumber(famePoint) + " / " + Ultility.StandardNumber(fameConf[fameLevel]["RequirePoint"]);
			var percent:Number = famePoint / fameConf[fameLevel]["RequirePoint"];
			if (fameLevel <= CUONG_LONG)
			{
				wave.img.y = typeFame.CurPos.y - 91;
				mask.img.y = typeFame.CurPos.y - 91;
			}
			else
			{
				wave.img.y = imgFameChild.y - 91;
				mask.img.y = imgFameChild.y - 87;
			}
			if (0 <= percent && percent < 1)
			{
				if (fameLevel <= CUONG_LONG)
				{
					wave.img.y = typeFame.CurPos.y - 105 * percent;
					mask.img.y = typeFame.CurPos.y - 105 * percent;
				}
				else
				{
					if (fameLevel == THAN_TUOC)
					{
						wave.img.y = imgFameChild.y - 84 * percent;
						mask.img.y = imgFameChild.y - 84 * percent;
					}
					else if (fameLevel == TU_THAN)
					{
						wave.img.y = imgFameChild.y - 80 * percent;
						mask.img.y = imgFameChild.y - 80 * percent;
					}
					else
					{
						wave.img.y = imgFameChild.y - 105 * percent;
						mask.img.y = imgFameChild.y - 105 * percent;
					}
				}
			}
			else if (percent < 0)
			{
				return;
			}
			else if (percent >= 1)			
			{
				if(fameConf[fameLevel + 1] != null)
				{
					while (fameConf[fameLevel + 1] != null && famePoint >= fameConf[fameLevel]["RequirePoint"])
					{						
						fameLevel++;
						famePoint = int(fameConf[fameLevel]["AddPoint"]);
						GameLogic.getInstance().user.updateReputationLevel(fameLevel);
						GameLogic.getInstance().user.updateReputationPoint(famePoint);
						GameLogic.getInstance().user.resetReputationQuest();
					}
					
					//var index1:int = typeFame.img.parent.getChildIndex(typeFame.img);
					//var index2:int = imgFame.img.parent.getChildIndex(imgFame.img);
					//typeFame.LoadRes("GuiReputation_ctnFameType" + fameLevel);
					//typeFame.img.parent.setChildIndex(typeFame.img, index1);
					//imgFame.LoadRes("GuiReputation_imgFameType" + fameLevel);
					//imgFame.img.parent.setChildIndex(imgFame.img, index2);
					
					//typeFame.img.mask = mask.img
					//wave.img.mask = maskWave.img;
					
					hideFameInfo();
					this.Hide();
					GuiMgr.getInstance().guiFameUp.showGui();
				}
				
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case BTN_CLOSE: 
					Hide();
					break;
				default: 
					var arr:Array = buttonID.split(SEPERATE);
					var id:String;
					var ctn:Container;
					var questName:String;
					var questContent:TextField;
					var ctnIcon:Container;
					var fm:TextFormat = new TextFormat();
					if (arr[0] == QUEST)	// nhận thưởng
					{
						id = QUEST + SEPERATE + arr[1];
						ctn = listQuest.removeAndReturnItem(id);
						ctn.Clear();
						ctn.LoadRes("GuiReputation_ctnQuestDone");
						ctnIcon = ctn.AddContainer("", "GuiReputation_ctnFameType", 35, 32);
						ctnIcon.AddImage("", "GuiReputation_IconFame" + fameLevel, 0, 0, true, ALIGN_LEFT_TOP);
						ctnIcon.setTooltipText("Điểm uy danh nhận được\nkhi hoàn thành nhiệm vụ");
						ctn.AddImage("", "GuiReputation_imgReceived", 254, 9, true, ALIGN_LEFT_TOP);
						if (GameLogic.getInstance().CurServerTime >= fameBonusConf["FromTime"] && GameLogic.getInstance().CurServerTime <= fameBonusConf["ToTime"])
						{
							ctn.AddLabel("+" + fameConf[fameLevel][arr[1]]["AddPoint"], -38, 42, 0xffffff, 2, 0);
							ctn.AddImage("", "GuiReputation_x2", 53, 1, true, ALIGN_LEFT_TOP);
						}
						else
						{
							ctn.AddLabel("+" + fameConf[fameLevel][arr[1]]["AddPoint"], -38, 42, 0xffffff, 2, 0);
						}
						listQuest.addItemAt(id, ctn, listQuest.length);
						if (GameLogic.getInstance().CurServerTime >= fameBonusConf["FromTime"] && GameLogic.getInstance().CurServerTime <= fameBonusConf["ToTime"])
						{
							famePoint += fameConf[fameLevel][arr[1]]["AddPoint"] * fameBonusConf["Rate"];
						}
						else
						{
							famePoint += fameConf[fameLevel][arr[1]]["AddPoint"];
						}
						
						questName = getquetName(arr[1], fameConf[fameLevel][arr[1]]["Action"]);
						questContent = ctn.AddLabel(questName, 74, 11, 0x009900, 0);
						questContent.width = 160;
						questContent.wordWrap = true;
						fm.size = 12;
						fm.bold = true;
						questContent.setTextFormat(fm);
						
						var cmdGift:SendGetGiftReputation = new SendGetGiftReputation(arr[1]);
						Exchange.GetInstance().Send(cmdGift);
						GameLogic.getInstance().user.updateReputationQuest(arr[1], -1, true);
						var fromP:Point = GameInput.getInstance().MousePos;
						//var toP:Point = (ctnFame.img.localToGlobal(typeFame.CurPos));
						var toP:Point = (ctnFame.img.localToGlobal(posImgFame));
						if (GameLogic.getInstance().CurServerTime >= fameBonusConf["FromTime"] && GameLogic.getInstance().CurServerTime <= fameBonusConf["ToTime"])
						{
							particalStar(fromP, toP, new ColorTransform(0, 0, 0, 1, Ultility.RandomNumber(100, 255), Ultility.RandomNumber(100, 255), Ultility.RandomNumber(100, 255), 0), completePartical, fameConf[fameLevel][arr[1]]["AddPoint"] * fameBonusConf["Rate"], 1);
						}
						else
						{
							particalStar(fromP, toP, new ColorTransform(0, 0, 0, 1, Ultility.RandomNumber(100, 255), Ultility.RandomNumber(100, 255), Ultility.RandomNumber(100, 255), 0), completePartical, fameConf[fameLevel][arr[1]]["AddPoint"], 1);
						}						
					}
					else if (arr[0] == QUICK)	// làm nhanh
					{
						if (GameLogic.getInstance().user.GetZMoney() < fameConf[fameLevel][arr[1]]["ZMoney"])
						{
							GuiMgr.getInstance().GuiNapG.Init();
							return;
						}						
						
						id = QUEST + SEPERATE + arr[1];
						ctn = listQuest.removeAndReturnItem(id);
						ctn.Clear();
						ctn.LoadRes("GuiReputation_ctnQuestDone");
						ctn.AddButton(id, "GuiReputation_btnReceive", 254, 37, this);
						ctnIcon = ctn.AddContainer("", "GuiReputation_ctnFameType", 35, 32);
						ctnIcon.AddImage("", "GuiReputation_IconFame" + fameLevel, 0, 0, true, ALIGN_LEFT_TOP);
						ctnIcon.setTooltipText("Điểm uy danh nhận được\nkhi hoàn thành nhiệm vụ");
						fm.size = 18;						
						ctn.AddLabel(fameConf[fameLevel][arr[1]]["Num"] + " / " + fameConf[fameLevel][arr[1]]["Num"], 235, 8, 0x009900, 1).setTextFormat(fm);
						if (GameLogic.getInstance().CurServerTime >= fameBonusConf["FromTime"] && GameLogic.getInstance().CurServerTime <= fameBonusConf["ToTime"])
						{
							ctn.AddLabel("+" + fameConf[fameLevel][arr[1]]["AddPoint"], -38, 42, 0xffffff, 2, 0);
							ctn.AddImage("", "GuiReputation_x2", 53, 1, true, ALIGN_LEFT_TOP);
						}
						else
						{
							ctn.AddLabel("+" + fameConf[fameLevel][arr[1]]["AddPoint"], -38, 42, 0xffffff, 2, 0);
						}
						
						questName = getquetName(arr[1], fameConf[fameLevel][arr[1]]["Action"]);
						questContent = ctn.AddLabel(questName, 74, 11, 0x009900, 0);
						questContent.width = 160;
						questContent.wordWrap = true;
						fm.size = 12;
						fm.bold = true;
						questContent.setTextFormat(fm);
						listQuest.addItemAt(id, ctn, 0);
						
						GameLogic.getInstance().user.UpdateUserZMoney(-fameConf[fameLevel][arr[1]]["ZMoney"]);
						var cmdQuick:SendGetQuickReputation = new SendGetQuickReputation(arr[1]);
						Exchange.GetInstance().Send(cmdQuick);
						GameLogic.getInstance().user.updateReputationQuest(arr[1], fameConf[fameLevel][arr[1]]["Num"]);
					}
					break;
			}
		}
		
		private function completePartical(point:int):void
		{
			if (!IsVisible)
				return;
			updateReputaion();
			if(tfLevelReputation)
				tfLevelReputation.text = "Cấp " + GameLogic.getInstance().user.getReputationLevel();
			var fromP:Point = ctnFame.img.localToGlobal(posImgFame)
			var toP:Point = new Point(fromP.x, fromP.y - 40);
			var parentObj:DisplayObject;
			parentObj = this.img;
			var fm:TextFormat = new TextFormat();
			fm.color = 0x00FF00;
			fm.size = 20;
			fm.bold = true;
			fm.align = "left";
			fm.font = "SansationBold";
			Ultility.ShowEffText("+" + point.toString(), parentObj, fromP, toP, fm, 6, 0x4F4D2E, 1, -0.05, true);
		}
		
		override public function Hide():void
		{
			// clear partical
			var i:int;
			for (i = 0; i < emitStar.length; i++)
			{
				emitStar[i].destroy();
				emitStar.splice(i, 1);
				i--;
			}
			
			super.Hide();
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case CTN_FAME: 
					showFameInfo()
					break;
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case CTN_FAME: 
					hideFameInfo();
					break;
			}
		}
		
		private function hideFameInfo():void
		{
			GuiMgr.getInstance().guiFameInfo.Hide();
		}
		
		public function showFameInfo():void
		{
			GuiMgr.getInstance().guiFameInfo.showGui();
		}
		
		public function showGui():void
		{
			fameLevel = GameLogic.getInstance().user.getReputationLevel();
			famePoint = GameLogic.getInstance().user.getReputationPoint();
			fameConf = ConfigJSON.getInstance().getItemInfo("ReputationInfo");
			fameBonusConf = ConfigJSON.getInstance().getItemInfo("Param")["ReputationAward"];
			fameQuest = new Array();
			var questConf:Object;
			var st:String;
			var i:int = 0;
			for (st in GameLogic.getInstance().user.GetMyInfo().ReputationQuest)
			{
				fameQuest.push(GameLogic.getInstance().user.GetMyInfo().ReputationQuest[st]);
				fameQuest[i]["Id"] = int(st);
				if (fameQuest[i]["Num"] >= fameConf[fameLevel][st]["Num"])
				{
					fameQuest[i]["notDone"] = false;
				}
				else
				{
					fameQuest[i]["notDone"] = true;
				}
				i++;
			}
			fameQuest.sortOn(["isGetGift", "notDone", "Id"]);
			Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		public function updateInfo():void
		{
			//Update particle
			var i:int;
			for (i = 0; i < emitStar.length; i++)
			{
				emitStar[i].updateEmitter();
				if (!emitStar[i].allowSpawn && emitStar[i].particleList.length < 1)
				{
					emitStar[i].destroy();
					emitStar.splice(i, 1);
					i--;
				}
			}
			updateReputaion();
			if(tfLevelReputation)
			tfLevelReputation.text = "Cấp " + GameLogic.getInstance().user.getReputationLevel();
		}
		
		/**
		 * Hàm tạo effect 1 chùm sao bay theo đường cong từ điểm này tới điểm kia
		 * @param	fromPoint : điểm bắt đầu
		 * @param	toPoint : điểm kết thúc
		 * @param	colorTransform : transform màu cho sao
		 * @param	isReverse : có bay ngược từ toPoint đến fromPoint hay không, mặc định là không
		 * @param	completeFunction : hàm thưc hiện khi xong effect
		 * @param	params : tham số cho hàm completeFunction
		 * @param	mid : chọn điểm giữa, 0 là random, 1 là hướng vòng lên, -1 là hướng vòng xuống, 2 là bay thẳng
		 * @param	spawnCount : số sao bay
		 */
		private function particalStar(fromPoint:Point, toPoint:Point, colorTransform:ColorTransform, completeFunction:Function = null, params:Object = null, time:Number = 0.5, isReverse:Boolean = false, mid:int = 0, spawnCount:int = 7):void
		{
			var emit:CometEmit = new CometEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));
			emit.spawnCount = spawnCount;
			var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;
			sao.transform.colorTransform = colorTransform;
			sao.blendMode = BlendMode.ADD;
			emit.imgList.push(sao);
			emitStar.push(emit);
			if (isReverse)
			{
				var temp:Point = toPoint.clone();
				toPoint = fromPoint.clone();
				fromPoint = temp;
			}
			
			var midPoint:Point = midPoint = getThroughPoint(fromPoint, toPoint, mid);
			
			if (emit)
			{
				img.addChild(emit.sp);
				emit.sp.x = fromPoint.x;
				emit.sp.y = fromPoint.y;
				if (mid != 2)
				{
					emit.velTolerance = new Point(1.5, 1.5);
					TweenMax.to(emit.sp, time, {bezierThrough: [{x: midPoint.x, y: midPoint.y}, {x: toPoint.x, y: toPoint.y}], ease: Cubic.easeOut, onComplete: onCompleteTween, onCompleteParams: [completeFunction, params]});
				}
				else
				{
					emit.velTolerance = new Point(1.2, 1.2);
					TweenMax.to(emit.sp, time, {bezierThrough: [{x: toPoint.x, y: toPoint.y}], ease: Cubic.easeOut, onComplete: onCompleteTween, onCompleteParams: [completeFunction, params]});
				}
			}
			
			function onCompleteTween():void
			{
				if (IsVisible)
				{
					if (emit)
					{
						emit.stopSpawn();
					}
					if (emit && emit.sp && emit.sp.parent == img)
					{
						img.removeChild(emit.sp);
					}
				}
				if (completeFunction != null)
				{
					completeFunction(params);
				}
			}
		}
		
		/**
		 * Tìm điểm trung gian giữa 2 điểm nguồn và đích để bay vòng qua đó cho đẹp
		 * @param	psrc	điểm nguồn
		 * @param	pdes	điểm đích
		 * @return
		 */
		private function getThroughPoint(psrc:Point, pdes:Point, mid:int = 0):Point
		{
			var p:Point = pdes.subtract(psrc); //Vector từ nguồn đến đích
			if (p.y == 0)
				return new Point(p.x / 2, 0);
			var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2); //Trung điểm của nguồn và đích
			var v:Point = new Point(-p.y, p.x); //Vector vuông góc với vector(nguồn, đích)
			
			//Random hướng vuông góc
			var n:int;
			if (mid == 0)
			{
				n = Math.round(Math.random()) * 2 - 1;
			}
			else
			{
				n = mid;
			}
			v.x = n * v.x;
			v.y = n * v.y;
			var l:Number = Math.min(120, v.length / 3);
			v.normalize(l); //Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			var result:Point = med.add(v); //Tính ra điểm cần đi xuyên qua
			return result;
		}
	}

}