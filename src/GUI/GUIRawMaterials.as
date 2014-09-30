package GUI 
{
	import com.bit101.components.Label;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Quint;
	import com.greensock.loading.data.ImageLoaderVars;
	import com.greensock.TweenMax;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.ImageEffect;
	import Effect.ImgEffectFly;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.trace.Trace;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.ButtonEx;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import Logic.BaseObject;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.QuestMgr;
	import Logic.StockThings;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketReceive.GetLoadInventory;
	import GUI.component.ProgressBar;
	import NetworkPacket.PacketSend.SendLevelMaterialSkill;
	//import NetworkPacket.PacketSend.SendLevelMaterialSkill;
	import NetworkPacket.PacketSend.SendMaterialService;
	import Data.ConfigJSON;
	/**
	 * ...
	 * @author ...
	 */
	public class GUIRawMaterials extends BaseGUI
	{
			// Danh sach cac constant
			public const IMG_BG_BUTTON_RAW:String = "ImgBgButtonRaw";
			public const IMG_BG_BUTTON_RAW_STOP:String = "ImgBgButtonRawStop";
			public const BTN_RAW_MATERIAL:String = "btnRawMaterial";
			public const BTN_RAW_MATERIAL_BY_G:String = "btnRawMaterialByG";
			public const BTN_RAW_MATERIAL_BY_GOLD:String = "btnRawMaterialByGold";
			public const BTN_CLOSE:String = "btnClose";
			public const BTN_BUY:String = "Mua_nguyen_Lieu_lai";
			public const BTN_NEXT:String = "btnNext";
			public const BTN_PRE:String = "btnPre";
			public const BTN_LOOP:String = "btnLoop";
			public const BTN_STOP_LOOP:String = "btnStopLoop";
			public const IMG_TICKED:String = "imgTicked";
			public const IMG_NUM_LOOP:String = "imgNumLoop";
			public const CTN_LOOP:String = "ctnLoop";
			public const CTN_CHOOSE_MATERIAL_LOOP:String = "ctnChooseMaterialLoop";
			public const CTN_RATIO_LEVEL:String = "ctnRatioLevel";
			public const CTN_SLOT_MATERIAL:String = "ctnSlotMater_";
			public const IMG_SLOT_MATERIAL_BG:String = "imgSlotMaterBg_";
			public const CTN_RESULT_MATERIAL:String = "ctnResultMaterial";
			public const IMG_MATERIAL_CENTER:String = "ImgRawMaterialCenter";
			public const CTN_BOT:String = "ctnBottom";
			public const LABEL_SUCCESS:String = "LabelSuccess";
			public const PRG_SUCCESS:String = "PrgSuccess";
			public const PRG_SUCCESS_NUM_LOOP:String = "PrgNumLoop";
			
			//public const DISTANCE_X:Number = 25;
			public var MAX_TYPE_CAN_USE:int = 9;
			public const DISTANCE_X:Number = 5;
			public const DISTANCE_Y:Number = 0;
			public const NUM_ELEMENT_IN_LIST:int = 3;		// số phần tử trong 1 trang của list ngư thạch
			public const MAX_TYPE_MATERIAL:Number = MAX_TYPE_CAN_USE * 2 + 2;		// Số loại ngư thạch có, MAX_TYPE_MATERIAL - 2 là số loại ngư thạc có thể dùng để ghép
			public const MAX_LEVEL_SKILL_RAW:int = 12;
			public const MAX_SLOT_MATERIAL:Number = 5;
			public const CONTAINER_BOT_WIDTH:int = 335;
			public const GUI_WIDTH:int = 215;
			public const MATERIAL:String = "Material_";
			public const SUPPER:String = "_S";
			public const DELTA_X:int = -35;
			public const DELTA_Y:int = 12;
			public const TIME_OUT:int = 26;
			static public const ICON_HELPER:String = "iconHelper";
		
		
			// Danh sach cac bien
			public var arrMaterialSlot:Array;	// Mang chua cac slot nguyen lieu
			public var arrNumMaterial:Array;	// Mang chua so nguyen lieu nguoi dung co
			public var arrUsedSlot:Array;			// Mang ghi lai cac slot da co nguyen lieu
			
			public var container_result_material:Container;	// Container chua ket qua khi day nguyen lieu len cac slot
			private var container_bot:Container;			// Container chua danh sach cac nguyen lieu user co
			private var container_loop:Container;			// Container chua nut cho phep loop hay không
			private var container_RatioLevel:Container;
			public var labelProgress:TextField;
			public var labelProgressNumLoop:TextField;
			public var progress:ProgressBar;
			public var labelRatioLevel:TextField;
			public var labelLevelSkill:TextField;
			public var progressNumLoop:ProgressBar;
			public var RawButton:ButtonEx;
			public var btnRawByGold:Button;
			public var btnRawByG:Button;
			public var btnNext:Button;
			public var btnPre:Button;
			public var btnBuyMat:Button;
			public var btnLoop:ButtonEx;
			public var btnStopLoop:Button;
			public var imgTicked:Image;
			public var lisRawMaterial:ListBox;				// ListBox chua danh sach cac nguyen lieu user co
			public var user:User;
			public var numMatInSlot:int;
			public var ResultMaxLevel:int;
			public var PercentSuccess:Number;
			public var LevelMat:int;				// Cấp ngư thạch cao nhất mà với level của người chơi đó có thể dùng để ghép
			public var LevelNeed:int;
			public var NumLoop:int;
			public var TotalLoop:int;
			public var TypeLoop:int;
			public var Data:Object;
			public var StateBuyShop:int;	//0 - chưa vào shop, 1 - dang o trong shop, 2 - có mua trong shop
			
			public var txtFormat:TextFormat;
			public var toolTip:TooltipFormat;
			public var txtMoney:TextField;
			public var txtZMoney:TextField;
			public var LabelLoop:TextField;
			
			public var isMultiClick:Boolean
			public var isEff:Boolean;				// Check OK
			public var isStartRaw:Boolean;			// Check OK
			public var isFlying:Boolean;			// Check OK
			public var IsEffSendFinish:Boolean;		// Check OK
			public var IsReceived:Boolean;			// Check ???
			public var IsLoop:Boolean;				// Check OK
			public var IsStartChooseLoop:Boolean;	// Biến cho biết có thể dừng quá trình lặp lại không
			public var IsUpgardeLevelMat:Boolean;	// Check OK
			public var IsSupperMatLoop:Boolean;		// Check OK
			public var IsCanChooseMaterial:Boolean = false;		// Check xem có thể chọn ghép tay hay không
			public var timeStartChooseLoop:int;
			public var OldData:Object;
			public var NewData:Object;
		
			
			public var XPMatCurrent:int;		// XP hiện tại của user
			public var XPMatNeedToLevelUp:int;	// XP Cần để lên level
			public var XPMatCurrentLevel:int;	// XP cần để lên level lấy từ config
			public var LevelXPMatCurrent:int;		// Level hiện tại của user
			
		public function GUIRawMaterials(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIRawMaterials";
		}
		public override function InitGUI(): void
		{
			this.setImgInfo = function():void
			{
				var i:int = 0;
				SetPos((Constant.STAGE_WIDTH - img.width) / 2, (Constant.STAGE_HEIGHT - img.height) / 2);
				{	
					// Khoi tao cac thanh phan co ban
					arrMaterialSlot = new Array();
					arrNumMaterial = new Array();
					arrUsedSlot = new Array();
					txtFormat = new TextFormat();
					toolTip = new TooltipFormat();
					txtMoney = new TextField();
					txtZMoney = new TextField();
					LabelLoop = new TextField();
					user = GameLogic.getInstance().user;
					isMultiClick = false;
					isEff = false;
					isStartRaw = false;
					isFlying = false;
					numMatInSlot = 0;
					ResultMaxLevel = 0;
					PercentSuccess = 0;
					//LevelMat = 0;
					LevelNeed = 0;
					NumLoop = 0;
					TotalLoop = 0;
					IsSupperMatLoop = false;
					IsCanChooseMaterial = true;
					IsUpgardeLevelMat = false;
					Data = new Object();
					StateBuyShop = 0;
					TypeLoop = -1;
					InitLevelMat();
					IsEffSendFinish = true;
					IsReceived = false;
					IsLoop = false;
					IsStartChooseLoop = false;
					LevelXPMatCurrent = user.GetMyInfo().MatLevel;
					//LevelXPMatCurrent = 1;
					XPMatCurrent = user.GetMyInfo().MatPoint;
					var objMatLevel:Object = ConfigJSON.getInstance().getItemInfo("M_MaterialSkill", LevelXPMatCurrent);
					if(objMatLevel)
					{
						XPMatCurrentLevel = objMatLevel["Mastery"];
					}
					if(XPMatCurrentLevel == 0)
					{
						XPMatCurrentLevel = int.MAX_VALUE;
					}
					XPMatNeedToLevelUp = XPMatCurrentLevel - XPMatCurrent;
				}
				
				{	
					// Add cac component cơ bản
					// add cac nut
					var btnClose:Button = AddButton(BTN_CLOSE, "BtnThoat", 0, 0, this);
					btnClose.SetPos(img.width - btnClose.img.width - 68, 25);
					
					AddImage(IMG_BG_BUTTON_RAW, "GuiRawMaterials_ImgBgButtonRaw", 169 + 136, 412 + 35);
					//AddImage(IMG_BG_BUTTON_RAW_STOP, "GuiRawMaterials_ImgBgButtonRawStop", 235 + 65, 405 + 43).img.visible = false;
					btnStopLoop = AddButton(BTN_STOP_LOOP, "GuiRawMaterials_BtnStopLoop", 235, 405, this);
					//AddImage(BTN_RAW_MATERIAL + "_img_G", "ImgMoneyNeedToRaw", 368, 433);
					//AddImage(BTN_RAW_MATERIAL + "_img_Gold", "ImgMoneyNeedToRaw", 237, 433);
					btnRawByG = AddButton(BTN_RAW_MATERIAL_BY_G, "GuiRawMaterials_BtnRawByG", 313, 452);
					btnRawByGold = AddButton(BTN_RAW_MATERIAL_BY_GOLD, "GuiRawMaterials_BtnRawByGold", 181, 452);
					btnRawByG.SetDisable();
					btnRawByGold.SetDisable();
					btnStopLoop.SetVisible(false);
					
					
					//btnStopLoop.SetPos(img.width / 2 - 71, img.height * 2 / 3 + 50);
					//btnStopLoop.SetPos(img.width / 2 - 45, img.height * 2 / 3 + 55);
					//btnStopLoop.SetVisible(false);
					//btnStopLoop.img.scaleX = 0.7;
					//btnStopLoop.img.scaleY = 0.7;
						
					txtMoney = AddLabel("0", 188, 420, 0xFFCC32, 1, 1);
					txtFormat = new TextFormat();
					txtFormat.size = 13;
					txtMoney.setTextFormat(txtFormat);
					
					txtZMoney = AddLabel("0", 318, 420, 0x00FF00, 1, 1);
					txtFormat = new TextFormat();
					txtFormat.size = 13;
					txtMoney.setTextFormat(txtFormat);
					
					container_loop = AddContainer(CTN_LOOP, "GuiRawMaterials_BtnAutomatic", 41, 471, true, this);
					imgTicked = container_loop.AddImage(IMG_TICKED, "GuiRawMaterials_ImgTicked", 15, 6, true);
					imgTicked.img.visible = IsLoop;
					toolTip = new TooltipFormat();
					toolTip.text = "Chọn / bỏ chọn lặp tự động";
					container_loop.setTooltip(toolTip);
					//BlackWhiteImage(container_loop.img);
					
					container_RatioLevel = AddContainer(CTN_RATIO_LEVEL, "GuiRawMaterials_PrgRatioLevelSkill_bg", 167, 82, true, this);
				}
				
				{	// add danh sach cac nguyen lieu
					container_bot = AddContainer(CTN_BOT, "GuiRawMaterials_ImgBgListMaterial", 0, 0, true, this);
					container_bot.SetPos((img.width - container_bot.img.width) / 2, img.height - container_bot.img.height - 20);
					
					lisRawMaterial = container_bot.AddListBox(ListBox.LIST_X, 1, NUM_ELEMENT_IN_LIST, DISTANCE_X, DISTANCE_Y, true);
					//lisRawMaterial.setPos(15, 0);
					lisRawMaterial.setPos(82, 0);
					InitArrNumMaterial(user.StockThingsArr.Material);
					InitMaterialList(arrNumMaterial);
					
					//container_bot.AddImage(BTN_NEXT + "_bg", "NextPre_bg", CONTAINER_BOT_WIDTH, container_bot.img.height / 2,true,ALIGN_CENTER_CENTER);
					btnNext = container_bot.AddButton(BTN_NEXT, "GuiRawMaterials_BtnNext", 0, 0, this);
					btnNext.SetPos(CONTAINER_BOT_WIDTH - btnNext.img.width / 2, (container_bot.img.height - btnNext.img.height) / 2);
					
					//container_bot.AddImage(BTN_PRE + "_bg", "NextPre_bg", 2, container_bot.img.height / 2,true,ALIGN_CENTER_CENTER);
					btnPre = container_bot.AddButton(BTN_PRE, "GuiRawMaterials_BtnPrev", 0, 0, this);
					btnPre.SetPos( -btnNext.img.width / 2 + 3, (container_bot.img.height - btnNext.img.height) / 2);
					
					btnBuyMat = container_bot.AddButton(BTN_BUY, "GuiRawMaterials_BtnBuyMaterial1", 0, 0, this);
					//btnBuyMat.SetPos((CONTAINER_BOT_WIDTH - btnBuyMat.img.width) / 2, container_bot.img.height - btnBuyMat.img.height / 3 + 5);
					btnBuyMat.SetPos(32, 20);
					//btnBuyMat.SetPos(0, 0);
					
					UpdateStateBtnNextPre(lisRawMaterial);
				}
				
				{	// Add 5 slot dùng để ép nguyên liệu và slot kết quả thu được
					var slot:Container;
					var StartX:int = GUI_WIDTH + 5;
					var StartY:int = 230;
					var distanceR:int = 100;
					var Pos_X:int = 0;
					var Pos_Y:int = 0;
					AddImage(IMG_SLOT_MATERIAL_BG + "0", "GuiRawMaterials_CtnMaterialSlotBg0", 300, 203);
					slot = AddContainer(CTN_SLOT_MATERIAL + "0", "GuiRawMaterials_CtnMaterialSlot0", 0 , 0, true, this);
					slot.SetPos(251 + 47, 109 + 47);
					arrMaterialSlot.push(slot);			
					arrUsedSlot[0] = 0;

					AddImage(IMG_SLOT_MATERIAL_BG + "1", "GuiRawMaterials_CtnMaterialSlotBg1", 400, 243);
					slot = AddContainer(CTN_SLOT_MATERIAL + "1", "GuiRawMaterials_CtnMaterialSlot1", 0 , 0, true, this);
					slot.SetPos(380 + 47, 164 + 47);
					arrMaterialSlot.push(slot);			
					arrUsedSlot[1] = 0;

					AddImage(IMG_SLOT_MATERIAL_BG + "2", "GuiRawMaterials_CtnMaterialSlotBg2", 423, 354);
					slot = AddContainer(CTN_SLOT_MATERIAL + "2", "GuiRawMaterials_CtnMaterialSlot2", 0 , 0, true, this);
					slot.SetPos(427 + 47, 304 + 47);
					arrMaterialSlot.push(slot);			
					arrUsedSlot[2] = 0;

					AddImage(IMG_SLOT_MATERIAL_BG + "3", "GuiRawMaterials_CtnMaterialSlotBg3", 174, 354);
					slot = AddContainer(CTN_SLOT_MATERIAL + "3", "GuiRawMaterials_CtnMaterialSlot3", 0 , 0, true, this);
					slot.SetPos(81 + 47, 304 + 47);
					arrMaterialSlot.push(slot);			
					arrUsedSlot[3] = 0;

					AddImage(IMG_SLOT_MATERIAL_BG + "4", "GuiRawMaterials_CtnMaterialSlotBg4", 201, 243);
					slot = AddContainer(CTN_SLOT_MATERIAL + "4", "GuiRawMaterials_CtnMaterialSlot4", 0 , 0, true, this);
					slot.SetPos(123 + 47, 164 + 47);
					arrMaterialSlot.push(slot);			
					arrUsedSlot[4] = 0;
					
					container_result_material = AddContainer(CTN_RESULT_MATERIAL, "GuiRawMaterials_CtnMaterialResult", 0, 0, true, this);
					container_result_material.SetPos(202, 227);
				}
				
				{	// Add label ty le thanh cong, progress va 1 so thu khac lien quan den no
					LabelLoop = AddLabel("Đang ép tự động ...", 260, 375, 0xFFCC32, 1, 1);
					txtFormat = new TextFormat();
					txtFormat.size = 20;
					LabelLoop.setTextFormat(txtFormat);
					LabelLoop.visible = false;
					
					progress = container_RatioLevel.AddProgress(PRG_SUCCESS, "GuiRawMaterials_PrgRatioLevelSkill", 2, 3, this, true);
					progress.SetPosBackGround( -2, -3);
					progress.setStatus(XPMatCurrent / XPMatCurrentLevel);
					
					AddImage(IMG_NUM_LOOP, "GuiRawMaterials_ImgMoneyNeedToRaw", 40, 446,true, ALIGN_LEFT_TOP);
					txtFormat = new TextFormat();
					txtFormat.size = 13;
					txtFormat.bold = true;
					labelProgressNumLoop = AddLabel("0", 40, 446, 0xffffff, 1, 1);
					labelProgressNumLoop.setTextFormat(txtFormat);
					
					txtFormat = new TextFormat();
					txtFormat.size = 25;
					txtFormat.bold = true;
					txtFormat.font = "myFish";
					labelProgress = AddLabel("", 250, 230, 0xffffff, 1, 1);
					labelProgress.setTextFormat(txtFormat);
					labelProgress.defaultTextFormat = txtFormat;
					labelProgress.embedFonts = true;
					
					txtFormat = new TextFormat();
					txtFormat.size = 18;
					//txtFormat.bold = true;
					txtFormat.font = "myFish";
					labelRatioLevel = container_RatioLevel.AddLabel("", 195, -25, 0xffffff, 1, 1);
					labelRatioLevel.setTextFormat(txtFormat);
					labelRatioLevel.defaultTextFormat = txtFormat;
					labelRatioLevel.embedFonts = true;
					labelRatioLevel.text = (Math.min(int(XPMatCurrent / XPMatCurrentLevel * 1000) / 10, 100)).toString() + "%";
					
					txtFormat = new TextFormat();
					txtFormat.size = 13;
					txtFormat.bold = true;
					txtFormat.font = "Arial";
					labelLevelSkill = container_RatioLevel.AddLabel("", -11, -20, 0x00FFFF, 1, 1);
					labelLevelSkill.setTextFormat(txtFormat);
					labelLevelSkill.defaultTextFormat = txtFormat;
					//labelLevelSkill.embedFonts = true;
					labelLevelSkill.text = "Cấp độ " + LevelXPMatCurrent.toString();
				}
				ShowImgBgSlot();
				
				//Tutorial
				var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
				if (curTutorial.search("ChooseMaterial") >= 0)
				{
					AddImage(ICON_HELPER, "IcHelper", 100 + 164, 520);
				}
			}
			
			// khởi tạo hình nền
			LoadRes("GuiRawMaterials_Theme");
		}
		override public function OnHideGUI():void 
		{
			var questArr:Array = QuestMgr.getInstance().finishedQuest;
			if (questArr.length > 0)
			{
				GameLogic.getInstance().OnQuestDone(questArr[0]);
				questArr.splice(0, 1);
			}
		}
		
		/**
		 * Khởi tạo level max của đá có thể đem ghép.
		 */
		public function InitLevelMat():void 
		{
			//for (var i:int = 0; i < int(MAX_TYPE_MATERIAL / 2) - 1; i++) 
			//{
				//var objMatInfo:Object = ConfigJSON.getInstance().GetItemInfo("UpgradeMaterial", i + 1);
				//if (user.Level < objMatInfo["LevelUnlock"]) 
				//{
					//LevelMat = i + 1;
					//LevelNeed = objMatInfo["LevelUnlock"];
					//break;
				//}
			//}
			//if (LevelMat == 0)	LevelMat = MAX_TYPE_CAN_USE + 1;
			LevelMat = MAX_TYPE_CAN_USE + 1;
			LevelNeed = 1;
		}
		/**
		 * Khoi tao mang chua so luong nguyen lieu user co khi moi vao game
		 * @param	ArrUserMaterial = user.StockThingArr.Material (chinh la mang chua so luong nguyen lieu trong user)
		 */
		public function InitArrNumMaterial(ArrUserMaterial:Array):void 
		{
			var i:int = 0;
			for (i = 0; i < MAX_TYPE_MATERIAL; i++) 
			{
				arrNumMaterial[i] = 0;
			}
			for (i = 0; i < ArrUserMaterial.length; i++) 
			{
				var index:int = int(ArrUserMaterial[i][ConfigJSON.KEY_ID]);
				if(index < 100)
				{
					arrNumMaterial[2 * (index - 1)] = ArrUserMaterial[i]["Num"];
				}
				else 
				{
					arrNumMaterial[2 * (index - 100 - 1) + 1] = ArrUserMaterial[i]["Num"];
				}
			}
		}
		/**
		 * 
		 * @param	listBox	: ListBox chua nguyen lieu dang co
		 */
		public function UpdateStateBtnNextPre(listBox:ListBox):void
		{
			if (listBox.getNumPage() <= 1)
			{
				btnNext.SetDisable();
				if(listBox.getCurPage() == listBox.getNumPage())
				{
					btnPre.SetEnable();
				}
				else
				{
					btnPre.SetDisable();
				}
			}
			else 
			{
				switch (listBox.curPage) 
				{
					case 0:
						btnPre.SetDisable();
						btnNext.SetEnable();
					break;
					
					case listBox.getNumPage() - 1:
						btnNext.SetEnable(false);
						btnPre.SetEnable();
					break;
					
					default:
						btnPre.SetEnable();
						btnNext.SetEnable();
					break;
					
				}
			}
		}
		/**
		 * Cập nhật lại kết quả phần trăm thành công và nguyên liệu ép lên được
		 */
		private function UpdatePercentResult():void 
		{
			ResultMaxLevel = 0;
			PercentSuccess = 0;
			var count:int = 0;
			var i:int = 0;
			for (i = 0; i < arrUsedSlot.length; i++) 
			{
				if (arrUsedSlot[i] % 100 >= ResultMaxLevel) ResultMaxLevel = arrUsedSlot[i] % 100 + 1;
			}
			if (ResultMaxLevel == 1)	ResultMaxLevel = 0;
			var isNoExistNormalMat:Boolean = true;
			var isExistSupperMat:Boolean = false;
			for ( i = 0; i < arrUsedSlot.length; i++) 
			{
				PercentSuccess = PercentSuccess + percentSuccess(arrUsedSlot[i], ResultMaxLevel);
				if (arrUsedSlot[i] < 100 && (arrUsedSlot[i] % 100 + 1) == ResultMaxLevel)
				{
					isNoExistNormalMat = false;
				}
				if (arrUsedSlot[i] > 100 && (arrUsedSlot[i] % 100 + 1) == ResultMaxLevel)
				{
					isExistSupperMat = true;
				}
				if (arrUsedSlot[i] > 0)
				{
					count ++;
				}
			}
			var BaseMaterial:int = 0;
			if (count > 0)
			{
				BaseMaterial = ResultMaxLevel - 1;
				if (isNoExistNormalMat)	BaseMaterial = ResultMaxLevel + 99;
				if (PercentSuccess >=  percentSuccess(BaseMaterial, ResultMaxLevel))
					PercentSuccess -= percentSuccess(BaseMaterial, ResultMaxLevel);
			}
			
			var obj:Object = ConfigJSON.getInstance().getItemInfo("M_MaterialSkill", user.GetMyInfo().MatLevel);
			if(count > 1 && obj)
			{
				PercentSuccess += obj["SuccessRate"];
				PercentSuccess = Math.min(PercentSuccess, 100);
			}
			
			if (isExistSupperMat)
			{
				txtFormat = new TextFormat();
				txtFormat = labelProgress.defaultTextFormat;
				//txtFormat.size = 35;
				//txtFormat.bold = true;
				//txtFormat.font = "myFish";
				txtFormat.color = 0x00CC33;
				labelProgress.setTextFormat(txtFormat);
				labelProgress.defaultTextFormat = txtFormat;
				labelProgress.embedFonts = true;
			}
			else 
			{
				
				txtFormat = new TextFormat();
				txtFormat = labelProgress.defaultTextFormat;
				//txtFormat.size = 35;
				//txtFormat.bold = true;
				//txtFormat.font = "myFish";
				txtFormat.color = 0xffffff;
				labelProgress.setTextFormat(txtFormat);
				labelProgress.defaultTextFormat = txtFormat;
				labelProgress.embedFonts = true;
			}
		}
		/**
		 * Khoi tao cac phan tu cho ListMaterial
		 * @param	arr : mang chua so luong material user co
		 */
		public function InitMaterialList(arr:Array):void
		{
			var type:int;		// Loai material nao
			var ctn:Container;
			for (var i:int = 0; i < arr.length; i++)
			{
				if (i % 2 == 0)
				{
					type = i / 2 + 1;
					if (arr[i] > 0)
					{	
						ctn = DrawMaterial(type, arr[2 * (type - 1)], false);
						lisRawMaterial.addItem(MATERIAL + type.toString() , ctn, this)
					}
				}
				else 
				{
					type = (i - 1) / 2 + 1;
					if (arr[i] > 0)
					{	
						ctn = DrawMaterial(type, arr[2 * (type - 1) + 1], true);
						lisRawMaterial.addItem(MATERIAL + type.toString() + SUPPER, ctn, this)
					}
				}
			}
			//lisRawMaterial.sortById();
			lisRawMaterial = sortOn(lisRawMaterial);
		}
		
		private function sortOn(list:ListBox):ListBox
		{
			var arr:Array = list.itemList;
			var arrNew:Array = [];
			var obj:Object;
			for (var i:int = 0; i < arr.length; i++) 
			{
				var item:Container = arr[i] as Container;
				var id:String = item.IdObject.split("_")[1].toString();
				for (var j:int = 0; j < 2 - id.length; j++) 
				{
					id = "0" + id;					
				}
				obj = new Object();
				obj["key"] = id;
				obj["Object"] = item;
				arrNew.push(obj);
			}
			arrNew.sortOn("key");
			list.itemList.splice(0, list.itemList.length);
			for (var k:int = 0; k < arrNew.length; k++) 
			{
				list.itemList.push(arrNew[k]["Object"]);
			}
			list.updateAllItemPos();
			return list;
		}
		
		/**
		 * Ve container cua nguyen lieu cap TYPE va so luong la NUM
		 * @param	type 	: 	TYPE
		 * @param	num		:	NUM
		 * @return
		 */
		public function DrawMaterial(type:int, num:int, isSuper:Boolean = false):Container
		{
			var obj:Object;
			var ctn:Container = new Container(lisRawMaterial, "GuiRawMaterials_ImgMaterialSlotBottom");
			var imageSlot:Image;
			if (isSuper)
			{
				imageSlot = ctn.AddImage(MATERIAL, "Material" + (type % 100).toString() + "S", ctn.img.width / 2, ctn.img.height / 2 , true, ALIGN_LEFT_TOP);
				obj = ConfigJSON.getInstance().getItemInfo("Material", type + 100);
			}
			else 
			{
				imageSlot = ctn.AddImage(MATERIAL, "Material" + type, ctn.img.width / 2, ctn.img.height / 2 , true, ALIGN_LEFT_TOP);
				obj = ConfigJSON.getInstance().getItemInfo("Material", type);
			}
			ctn.AddLabel(num.toString(), - ctn.img.width / 2 + 13, ctn.img.height / 1.4 + 9, 0xffffff, 1, 0x26709C);
			// tooltip
			txtFormat = new TextFormat()
			txtFormat.bold = true;
			txtFormat.color = 0xF37621;
			toolTip = new TooltipFormat();
			toolTip.text = obj["Name"];
			if(obj["Name"].length > 0)
				toolTip.setTextFormat(txtFormat, 0, obj["Name"].length);
			ctn.setTooltip(toolTip);
			//var ctnChoose:Container = ctn.AddContainer(CTN_CHOOSE_MATERIAL_LOOP, "GuiRawMaterials_CtnChooseMaterialLoop", ctn.img.width - 18, 5, true, this);
			var ctnChoose:Container = ctn.AddContainer(CTN_CHOOSE_MATERIAL_LOOP, "GuiRawMaterials_CtnChooseMaterialLoop", 5, 5, true, this);
			ctnChoose.AddImage(IMG_TICKED, "GuiRawMaterials_ImgTicked", 15, 5).img.visible = false;
			ctnChoose.SetVisible(false);
			return ctn;
		}
		/**
		 * Chon nguyen lieu co id la 1 2 3 4 5 len slot nguyen lieu
		 * @param	id
		 */
		public function ChooseMaterial(id:int,IsChooseSupper:Boolean = false):void
		{
			isStartRaw = true;
			var i:int;
			var slotOfMaterial:Container;
			var materialInList:Container;
			var obj:Object;
			var isChooseSupper:Boolean = IsChooseSupper;
			var pD:Point;
			var mc:Sprite;
			
			//Chuyen nguyen lieu len slot
			for (i = 0; i < MAX_SLOT_MATERIAL; i++)
			{
				if (arrUsedSlot[i] == 0) 
				{
					
					if(ResultMaxLevel <= id)
						ResultMaxLevel = id + 1;	
					slotOfMaterial = arrMaterialSlot[i] as Container;
					var typeMaterial:String;
					if (!isChooseSupper)
					{
						typeMaterial = id.toString();
					}
					else 
					{
						typeMaterial = (id + 100).toString();
					}
					slotOfMaterial.IdObject += "_" + typeMaterial;
					
					//Show Effect
					EffChooseMaterial(id, i, isChooseSupper);
					//Set Tooltip cho slot vừa mới đưa nguyên liệu lên
					{
						toolTip = new TooltipFormat();
						obj = ConfigJSON.getInstance().getItemInfo("Material", id);
						if(isChooseSupper)	obj = ConfigJSON.getInstance().getItemInfo("Material", id + 100);
						toolTip.text = obj["Name"];
						txtFormat = new TextFormat();
						txtFormat.bold = true;			
						txtFormat.color = 0xF37621;
						toolTip.setTextFormat(txtFormat);
						slotOfMaterial.setTooltip(toolTip);
					}
					// set tooltip kết quả
					toolTip = new TooltipFormat();
					obj = ConfigJSON.getInstance().getItemInfo("Material", ResultMaxLevel);
					toolTip.text = obj["Name"];	
					toolTip.setTextFormat(txtFormat);
					container_result_material.setTooltip(toolTip);
					
					break;
				}
			}
			if (numMatInSlot > 0)
			{
				toolTip = new TooltipFormat();
				toolTip.text = "Ép lên ngư thạch cấp " + ResultMaxLevel + "\n" + 
					"Tỉ lệ ép thành công là: " + PercentSuccess.toString() + "%";
				//progress.setTooltip(toolTip);
			}
			else
			{
				toolTip = new TooltipFormat();
				toolTip.text = "Hãy chọn ngư thạch!";
				//progress.setTooltip(toolTip);
			}
			ShowImgBgSlot();
		}
		/**
		 * Hàm xóa ngư thạch khỏi slot
		 * @param	id idObject của slot nguyên liệu
		 */
		public function RemoveMaterial(id:String):void
		{
				var arr:Array = id.split("_");
				var obj:Object;
				var num:int;
				var isMatSupper:Boolean = false;
				if (arr.length != 3)
				{
					return;
				}
				if (int(arr[2]) > 100) 
				{
					isMatSupper = true;
				}
				// Xóa nguyên liệu khỏi slot
				var type:int = arr[2];			
				var slotMaterial:Container = GetContainer(id);
				slotMaterial.IdObject = CTN_SLOT_MATERIAL + id.split("_")[1];
				var MaterialInList:Container;
				if (isMatSupper)
				{
					MaterialInList = lisRawMaterial.getItemById(MATERIAL + (type - 100).toString() + SUPPER);
				}
				else 
				{
					MaterialInList = lisRawMaterial.getItemById(MATERIAL + type.toString());
				}
				
				// Effect
				EffReturnMaterial(MaterialInList, slotMaterial, type, false, isMatSupper);
				// Cập nhật lại hình ảnh trong ô kết quả
				{
					if (container_result_material.ImageArr.length > 0) 
					{
						container_result_material.RemoveImage(container_result_material.ImageArr[0]);
					}
					if (numMatInSlot > 0)
					{
						container_result_material.AddImage(CTN_RESULT_MATERIAL, "Material" + (ResultMaxLevel), container_result_material.img.width / 2, 
							container_result_material.img.height / 2, true, ALIGN_LEFT_TOP);
						// Cập nhật lại kết quả
						obj = ConfigJSON.getInstance().getItemInfo("Material", ResultMaxLevel);
						if (obj)
						{
							toolTip = new TooltipFormat();
							toolTip.text = obj["Name"];		
							txtFormat = new TextFormat();
							txtFormat.bold = true;			
							txtFormat.color = 0xF37621;	
							toolTip.setTextFormat(txtFormat)
							container_result_material.setTooltip(toolTip);
						}
					}
					else 
					{
						container_result_material.tooltip = null;
					}
				}
				// Set lại trạng thái của thanh progress và label các nút
				//progress.setStatus(PercentSuccess / 100);
				// thanh progress và các nút ghép
				if (numMatInSlot > 0)
				{
					toolTip = new TooltipFormat();
					labelProgress.text = PercentSuccess.toString() + "%";
					toolTip.text = "Ép lên ngư thạch cấp " + ResultMaxLevel + "\n" +
						"Tỉ lệ ép thành công là: " + PercentSuccess + "%";
					//progress.setTooltip(toolTip);
					txtMoney.text = Ultility.StandardNumber(PayGoal(ResultMaxLevel));
					txtZMoney.text = Ultility.StandardNumber(PayG(ResultMaxLevel));
				}
				else 
				{
					toolTip = new TooltipFormat();
					labelProgress.text = "";
					toolTip.text = "Ghép nguyên liêu cấp ?\nTỉ lệ thành công: ?%";
					//progress.setTooltip(toolTip);
					txtMoney.text = "0";
					txtZMoney.text = "0";
				}
				// Cập nhật trạng thái của nút
				UpdateBtnGoalZXu(ResultMaxLevel, numMatInSlot);
				// Xóa tooltip đang hiển thị
				ActiveTooltip.getInstance().clearToolTip();
				ShowImgBgSlot();
		}
		/**
		 * Thuc hien chon nguyen lieu len slot
		 * @param	id		type cua loai nguyen lieu
		 * @param	iSlot	id cua slot
		 */
		private function EffChooseMaterial(id:int, iSlot:int, isEffSupperMat:Boolean = false, isRawByG:Boolean = false):void 
		{
			numMatInSlot++;
			arrUsedSlot[iSlot] = id;
			IsStartChooseLoop = true;
			var pD:Point;
			var mc:Sprite;
			
			var materialInList:Container = lisRawMaterial.getItemById(MATERIAL + id.toString());
			if (isEffSupperMat)	
			{
				materialInList = lisRawMaterial.getItemById(MATERIAL + id.toString() + SUPPER);
			}
			else 
			{
				materialInList = lisRawMaterial.getItemById(MATERIAL + id.toString());
			}
			var slotOfMaterial:Container = arrMaterialSlot[iSlot] as Container;
			var numMatInTypeChoose:int;
			
			if (isEffSupperMat)	arrUsedSlot[iSlot] = id + 100;
			
			mc = Ultility.CloneImage(materialInList.ImageArr[0].img);
			img.addChild(mc);
			pD = img.globalToLocal(materialInList.img.localToGlobal(new Point(materialInList.ImageArr[0].img.x/2 , materialInList.ImageArr[0].img.y)));
			mc.x = pD.x;
			mc.y = pD.y;
			//pD = img.globalToLocal(slotOfMaterial.img.localToGlobal(new Point(slotOfMaterial.img.width / 2 , slotOfMaterial.img.height / 20)));
			pD = img.globalToLocal(slotOfMaterial.img.localToGlobal(new Point(0 , 0)));
			isFlying = true;
			TweenMax.to(mc, 0.1, { bezierThrough:[ { x:(pD.x ), y:(pD.y) } ], ease:Quint.easeOut, 
					onComplete:onFinishTween, onCompleteParams:[mc, slotOfMaterial, 0 , 0, iSlot, isRawByG] } );
					//onComplete:onFinishTween, onCompleteParams:[mc, slotOfMaterial, slotOfMaterial.img.width / 2 , slotOfMaterial.img.height / 2, iSlot, isRawByG] } );
			// Cap nhat lai so luong nguyen lieu trong listMaterial
			numMatInTypeChoose = int((materialInList.LabelArr[0] as TextField).text);
			numMatInTypeChoose--;
			if (!isEffSupperMat)
			{
				arrNumMaterial[(id - 1) * 2]--;
			}
			else 
			{
				arrNumMaterial[(id - 1) * 2 + 1]--;
			}
			
			if (numMatInTypeChoose <= 0)
			{
				if (!isEffSupperMat)
				{
					lisRawMaterial.hideItem(MATERIAL + id.toString());
				}
				else
				{
					lisRawMaterial.hideItem(MATERIAL + id.toString() + SUPPER);
				}
				//lisRawMaterial.sortById();
				lisRawMaterial = sortOn(lisRawMaterial);
				UpdateStateBtnNextPre(lisRawMaterial);
			}
			else 
			{
				(materialInList.LabelArr[0] as TextField).text = numMatInTypeChoose.toString();
			}
			// Cập nhật lại tỉ lệ phần trăm
			UpdatePercentResult();
			//progress.setStatus(PercentSuccess / 100);
			labelProgress.text = PercentSuccess + "%";
			// Hien gia tien len
			txtMoney.text = Ultility.StandardNumber(PayGoal(ResultMaxLevel));
			txtZMoney.text = Ultility.StandardNumber(PayG(ResultMaxLevel));
			//Cap nhat lai trang thai nut goal va xu
			UpdateBtnGoalZXu(ResultMaxLevel, numMatInSlot);
			
			// cap nhat lai nguyen lieu muon ep len
			container_result_material.ClearComponent();
			container_result_material.AddImage(IMG_MATERIAL_CENTER, "Material" + (ResultMaxLevel), container_result_material.img.width / 2, 
			container_result_material.img.height / 2, true, ALIGN_LEFT_TOP);
			ShowImgBgSlot();
		}
		
		private function ShowImgBgSlot():void 
		{
			for (var i:int = 0; i < 5; i++) 
			{
				var item:Image = GetImage(IMG_SLOT_MATERIAL_BG + i);
				if (arrUsedSlot[i] == 0)
				{
					Ultility.SetEnableSprite(item.img, false);
				}
				else
				{
					Ultility.SetEnableSprite(item.img);
				}
			}
		}
		/**
		 * Hàm thực hiện cho nguyên liệu bay về
		 * @param	id
		 */
		private function EffReturnMaterial(MaterialInList:Container, slotMaterial:Container, type:int , IsResult:Boolean = false, IsEffSupper:Boolean = false, isRawByG:Boolean = false):void 
		{
			var i:int;
			numMatInSlot--;
			arrUsedSlot[arrMaterialSlot.indexOf(slotMaterial)] = 0;
			// cập nhật lại tỷ lệ phần trăm và nguyên liệu kết quả
			UpdatePercentResult();
			var pD:Point;
			var mc1:Sprite = new Sprite();
			var image1:Image;
			if (!IsEffSupper) 
			{
				image1 = new Image(mc1, "Material" + type.toString());
			}
			else
			{
				image1 = new Image(mc1, "Material" + (type - 100).toString() + "S");
			}
			var num:int;
			slotMaterial.tooltip = null;
			ActiveTooltip.getInstance().clearToolTip();
			if(IsResult)
			{
				for (i = 0; i < MAX_SLOT_MATERIAL; i++) 
				{
					arrUsedSlot[i] = 0;
				}
			}
			// else của if này đã xử lý trong hàm remove mat
			
			// Nếu ngư thạch chưa có trong lis thì khởi tạo
			if (!MaterialInList)	
			{
				var Item_ID_Object:String = type.toString();
				if (type > 100)
				{
					MaterialInList = DrawMaterial(type - 100, 0, true);
					Item_ID_Object = (type % 100).toString() + SUPPER;
				}
				else 
				{
					MaterialInList = DrawMaterial(type, 0, false);
				}
				lisRawMaterial.addItem(MATERIAL + Item_ID_Object , MaterialInList, this);
				//lisRawMaterial.sortById();
				lisRawMaterial = sortOn(lisRawMaterial);
			}
			// Eff bay ngư thạch về
			img.addChild(mc1);
			pD = img.globalToLocal(slotMaterial.img.localToGlobal(new Point(0 , 0)));
			mc1.x = pD.x;
			mc1.y = pD.y;
			pD = img.globalToLocal(MaterialInList.img.localToGlobal(new Point(MaterialInList.img.width / 3, - MaterialInList.img.height / 4 + 13)));
			
			var indexMaterial:int = lisRawMaterial.getIndexById(MATERIAL + type.toString());
			if(IsEffSupper)	indexMaterial = lisRawMaterial.getIndexById(MATERIAL + (type-100).toString() + SUPPER);
			
			var indexStart:int = int(indexMaterial / NUM_ELEMENT_IN_LIST ) * NUM_ELEMENT_IN_LIST;
			var indexEnd:int = (int(indexMaterial / NUM_ELEMENT_IN_LIST) + 1) * NUM_ELEMENT_IN_LIST;
			pD.x = 225 + (indexMaterial - indexStart + 1) * (MaterialInList.img.width + DISTANCE_X) -DISTANCE_X - MaterialInList.img.width / 2;
			//lisRawMaterial.showPage(int(indexMaterial / NUM_ELEMENT_IN_LIST));
			
			UpdateStateBtnNextPre(lisRawMaterial);
			isFlying = true;
			TweenMax.to(mc1, 0.7, { bezierThrough:[{ x:(pD.x ), y:(pD.y + MaterialInList.img.height / 2) } ], 
						ease:Quint.easeOut, onComplete:onFinishTweenRemove, onCompleteParams:[mc1, type, numMatInSlot, IsResult, isRawByG] } );
			
			
			
			if (!IsResult)
			{
				num = int((MaterialInList.LabelArr[0] as TextField).text);
				num++;
				if(!IsEffSupper)
				{
					arrNumMaterial[(type - 1) * 2] = num;
				}
				else 
				{
					arrNumMaterial[(type % 100 - 1) * 2 + 1] = num;
				}
			}
			else 
			{
				if(!IsEffSupper)
				{
					num = arrNumMaterial[(type - 1) * 2];
				}
				else 
				{
					num = arrNumMaterial[(type % 100 - 1) * 2 + 1];
				}
			}
			(MaterialInList.LabelArr[0] as TextField).text = num.toString();
			
			if (IsResult && !IsLoop && !IsUpgardeLevelMat && !GuiMgr.getInstance().GuiUpgradeSkillMaterial.IsVisible)
			{
				switch (type) 
				{
					//case 3:
						//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_MATERIAL_3,"","",Localization.getInstance().getString("FeedIcon" + GUIFeedWall.FEED_TYPE_MATERIAL_3));
					//break;
					case 103:
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_MATERIAL_3,"","",Localization.getInstance().getString("FeedIcon" + GUIFeedWall.FEED_TYPE_MATERIAL_3));
					break;
					//case 4:
						//GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_MATERIAL_4,"","",Localization.getInstance().getString("FeedIcon" + GUIFeedWall.FEED_TYPE_MATERIAL_4));
					//break;
					case 104:
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_MATERIAL_4,"","",Localization.getInstance().getString("FeedIcon" + GUIFeedWall.FEED_TYPE_MATERIAL_4));
					break;
					case 105:
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_MATERIAL_5,"","",Localization.getInstance().getString("FeedIcon" + GUIFeedWall.FEED_TYPE_MATERIAL_4));
					break;
					case 5:
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_MATERIAL_5,"","",Localization.getInstance().getString("FeedIcon" + GUIFeedWall.FEED_TYPE_MATERIAL_5));
					break;
				} 
			}
			slotMaterial.ClearComponent();
			ShowImgBgSlot();
		}
		/**
		 * Cac hanh dong sau khi nhan duoc ket qua
		 * @param	ctn_
		 * @param	Data
		 */
		private function EffAfter(ctn_:Container, Data:Object, isRawByG:Boolean = false):void 
		{
				// Effect
				var isMatSupper:Boolean = false;
				if (Data["TypeId"] > 100)	
				{
					isMatSupper = true;
				}
				EffReturnMaterial(ctn_, container_result_material, Data["TypeId"], true, isMatSupper, isRawByG);
				isEff = false;
		}
		private function EffAfterFail(isRawByG:Boolean = false):void 
		{
			numMatInSlot = 0;
			for (var i:int = 0; i < MAX_SLOT_MATERIAL; i++) 
			{
				arrUsedSlot[i] = 0;
			}
			if (IsLoop)
			{
				NumLoop--;
				//progressNumLoop.setStatus(NumLoop / TotalLoop);
				labelProgressNumLoop.text = NumLoop.toString();
				RawLoop(0, IsSupperMatLoop, isRawByG);
			}
			else 
			{
				if (IsUpgardeLevelMat)
				{
					UpdateSkillRaw();
					IsUpgardeLevelMat = false;
					UpdateGiftToStore(Data["Gift"]);
					GuiMgr.getInstance().GuiUpgradeSkillMaterial.setInfo(Data["Gift"]);
					GuiMgr.getInstance().GuiUpgradeSkillMaterial.Show();
				}
			}
			isStartRaw = false;
			numMatInSlot = 0;
			isEff = false;
		}
		/**
		 * Hàm thực hiện eff sau khi thực hiện eff khi kích vào nút ghép
		 * @param	materialPack
		 */
		private function EffSend(materialPack:SendMaterialService):void 
		{
			FlyRaw();
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiRawMaterials_EffRawAfterClick", null, container_result_material.CurPos.x 
				+ 240 + DELTA_X, container_result_material.CurPos.y + DELTA_Y  + 150,false,false,null, function():void{EffSendAfterClick(materialPack)});
			//RawButton.SetDisable();
			btnRawByG.SetDisable();
			btnRawByGold.SetDisable();
		}
		/**
		 * Hàm thực hiện gửi gói tin sau khi hết eff ép nguyên liệu
		 * @param	materialPack
		 */
		private function EffSendAfterClick(materialPack:SendMaterialService):void 
		{
			isEff = false;
			IsEffSendFinish = true;
		}
		/**
		 * add anh trong sprite mc vao trong container ctn tai vi tri x, y
		 * @param	mc
		 * @param	ctn
		 * @param	x
		 * @param	y
		 */
		private function onFinishTween(mc:Sprite, ctn:Container, x:int, y:int, iLoop:int, isRawByG:Boolean = false):void 
		{
			if (ctn.img == null)	return;
			ctn.ClearComponent();
			ctn.AddImageBySprite(mc, x, y);
			if (IsLoop)
			{
				if (iLoop == MAX_SLOT_MATERIAL - 1)
				{
					timeStartChooseLoop = GameLogic.getInstance().CurServerTime;
				}
			
				if (iLoop == MAX_SLOT_MATERIAL - 1)
				{
					//timeStartChooseLoop = GameLogic.getInstance().CurServerTime;
					var i:int = 0;
					if(!isRawByG)
					{
						user.UpdateUserMoney(-PayGoal(ResultMaxLevel), true);
					}
					else 
					{
						user.UpdateUserZMoney(-PayG(ResultMaxLevel), true);
					}
					var arr:Array = [];
					for (i = 0; i < MAX_TYPE_MATERIAL; i++) 
					{
						arr.push(0);
					}
					for (i = 0; i < MAX_SLOT_MATERIAL; i++) 
					{
						if (arrUsedSlot[i] != 0)
						{
							var iTempUsed:int = arrUsedSlot[i];
							var r:int = iTempUsed % 100;
							var q:int = iTempUsed / 100;
							arr[(r - 1) * 2 + q]++;
						}
					}
					if (LevelXPMatCurrent <= MAX_LEVEL_SKILL_RAW)
					{
						var materialPack:SendMaterialService;
						if (!isRawByG)
						{
							materialPack = new SendMaterialService(arr);
						}
						else
						{
							materialPack = new SendMaterialService(arr, "ZMoney");
						}
						Exchange.GetInstance().Send(materialPack);
					}
				}
				else 
				{
					EffChooseMaterial(TypeLoop, iLoop + 1, IsSupperMatLoop, isRawByG);
				}
			}
			isFlying = false;
			
			//Tutorial
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("JoinMaterial") >= 0 && GetButton(BTN_RAW_MATERIAL_BY_GOLD).enable && GetImage(ICON_HELPER) != null)
			{
				GetImage(ICON_HELPER).SetPos(251, 465);
			}
		}
		/**
		 * 
		 * @param	mc
		 * @param	idShow
		 * @param	num
		 */
		private function onFinishTweenRemove(mc:Sprite, idShow:int, num:int, isResult:Boolean = false, isRawByG:Boolean = false):void 
		{
			mc.visible = false;
			isStartRaw = false;
			if (isResult)	
			{
				container_result_material.ClearComponent();
				numMatInSlot = 0;
				if (!IsLoop && IsUpgardeLevelMat) 
				{
					UpdateSkillRaw();
					UpdateGiftToStore(Data["Gift"]);
					IsUpgardeLevelMat = false;
					GuiMgr.getInstance().GuiUpgradeSkillMaterial.setInfo(Data["Gift"]);
					GuiMgr.getInstance().GuiUpgradeSkillMaterial.Show();
				}
			}
			else 
			{
				for (var i:int = 0; i < MAX_SLOT_MATERIAL; i++) 
				{
					if (arrUsedSlot[i] != 0)
					{
						isStartRaw = true;
					}
					if (isStartRaw)
					{
						break;
					}
				}
			}
			if (IsLoop)
			{
				NumLoop--;
				//progressNumLoop.setStatus(NumLoop / TotalLoop);
				labelProgressNumLoop.text = NumLoop.toString();
				RawLoop(0, IsSupperMatLoop, isRawByG);
			}
			isFlying = false;
			
		}
		private function onFinishTweenRaw(mc:Sprite):void 
		{
			mc.visible = false;
			isFlying = false;
			//container_result_material.ClearComponent();
			numMatInSlot = 0;
		}
		private function FlyRaw():void 
		{
			var pD:Point;
			arrUsedSlot = [];
			for (i = 0; i < MAX_SLOT_MATERIAL; i++)
			{
				arrUsedSlot[i] = 0;
			}
			for (var i:int = 0; i < MAX_SLOT_MATERIAL; i++)
			{
				var slot:Container = arrMaterialSlot[i];
				
				if (slot.ImageArr != null && slot.ImageArr.length != 0)
				{
					var mc:Sprite = new Sprite();
					var arrIDObject:Array = slot.IdObject.split("_");
					var imgTemp:Image;
					if (int(arrIDObject[2]) > 100)
					{
						imgTemp = new Image(mc, "Material" + (int(arrIDObject[2]) % 100).toString() + "S");
					}
					else
					{
						if(int(arrIDObject[2]) > 0)
						{
							imgTemp = new Image(mc, "Material" + arrIDObject[2].toString());
						}
					}
					img.addChild(mc);
					pD = img.globalToLocal(slot.img.localToGlobal(new Point(0 , 0)));
					mc.x = pD.x;
					mc.y = pD.y;
					pD = img.globalToLocal(container_result_material.img.localToGlobal(new Point(0, 0)));
					isFlying = true;
					TweenMax.to(mc, 0.2, { bezierThrough:[{ x:(pD.x + container_result_material.img.width/2), y:(pD.y + container_result_material.img.height/2)}], 
						ease:Expo.easeIn, onComplete:onFinishTweenRaw, onCompleteParams:[mc] } );
				}
				slot.ClearComponent();
				slot.tooltip = null;
			}
			ActiveTooltip.getInstance().clearToolTip();
		}
		/**
		 * Kiem tra xem co du tien khong
		 * @param	ResultMaterial
		 * @param	numMatInSlot
		 */
		public function UpdateBtnGoalZXu(ResultMaterial:int, numMatInSlot:int):void
		{
			// CheckGold
			if (PayGoal(ResultMaxLevel) <= user.GetMoney())
			{
				if (numMatInSlot > 1)
				{
					//RawButton.SetEnable(true);
					toolTip = null;
					//RawButton.setTooltip(toolTip);
					btnRawByGold.SetEnable(true);
					btnRawByGold.setTooltip(toolTip);
				}
				else	
				{
					//RawButton.SetDisable();
					toolTip = new TooltipFormat();
					toolTip.text = Localization.getInstance().getString("Tooltip40");
					//RawButton.setTooltip(toolTip);
					btnRawByGold.SetDisable();
					btnRawByGold.setTooltip(toolTip);
				}
			}
			else	
			{
				toolTip = new TooltipFormat();
				toolTip.text = Localization.getInstance().getString("Tooltip41");
				//RawButton.setTooltip(toolTip);
				//RawButton.SetDisable();
				btnRawByGold.SetDisable();
				btnRawByGold.setTooltip(toolTip);
			}
			// Check G
			if (PayG(ResultMaxLevel) <= user.GetZMoney())
			{
				if (numMatInSlot > 1)
				{
					//RawButton.SetEnable(true);
					toolTip = null;
					//RawButton.setTooltip(toolTip);
					btnRawByG.SetEnable(true);
					btnRawByG.setTooltip(toolTip);
				}
				else	
				{
					//RawButton.SetDisable();
					toolTip = new TooltipFormat();
					toolTip.text = Localization.getInstance().getString("Tooltip40");
					//RawButton.setTooltip(toolTip);
					btnRawByG.SetDisable();
					btnRawByG.setTooltip(toolTip);
				}
			}
			else	
			{
				toolTip = new TooltipFormat();
				toolTip.text = Localization.getInstance().getString("Tooltip41");
				//RawButton.setTooltip(toolTip);
				//RawButton.SetDisable();
				btnRawByG.SetDisable();
				btnRawByG.setTooltip(toolTip);
			}
		}
		/**
		 * Luong goal phai tra khi ep ra da cap level
		 * @param	level
		 * @return
		 */
		private function PayGoal(level:int = 0):int 
		{
			var levelUser:int = GameLogic.getInstance().user.Level;
			var goldNeed:int = 0;
			if (level > 1 && level <= MAX_TYPE_MATERIAL)
			{
				var obj:Object = ConfigJSON.getInstance().getItemInfo("UpgradeMaterial",level - 1);
				goldNeed = obj["Money"];
				if (GameLogic.getInstance().isMonday())
				{
					goldNeed /= 2;
				}
			}
			return goldNeed;
		}
		/**
		 * Luong goal phai tra khi ep ra da cap level
		 * @param	level
		 * @return
		 */
		private function PayG(level:int = 0):int 
		{
			var levelUser:int = GameLogic.getInstance().user.Level;
			var gNeed:int = 0;
			if (level > 1 && level <= MAX_TYPE_MATERIAL)
			{
				var obj:Object = ConfigJSON.getInstance().getItemInfo("UpgradeMaterial",level - 1);
				gNeed = obj["ZMoney"];
				//if (GameLogic.getInstance().isMonday())
				//{
					//gNeed /= 2;
				//}
			}
			return gNeed;
		}
		private function BlackWhiteImage(image:Sprite):void 
		{
			image.mouseEnabled = false;
			
			var elements:Array =
			[0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0.33, 0.33, 0.33, 0, 0,
			0, 0, 0, 1, 0];

			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
			image.filters = [colorFilter];
		}
		private function DeBlackWhiteImage(image:Sprite):void 
		{
			image.mouseEnabled = true;
			image.filters = null;
		}
		/**
		 * Trả về tỉ lệ phần trăm thành công
		 * @param	levelFrom	ngư thạch dùng
		 * @param	levelTo		ngư thạch muốn thu được
		 * @return
		 */
		private function percentSuccess(levelFrom:int, levelTo:int):Number
		{
			var obj:Object = ConfigJSON.getInstance().getItemInfo("UpgradeMaterial", levelFrom);
			if (levelFrom > 0)
			{
				//var returnPercent:int = obj["Show"][levelTo.toString()] * 100;
				var returnPercent:Number = obj[levelTo.toString()];
				return (Math.round(returnPercent * 100)) / 100;
			}
			return 0;
		}	
		private function UpdateElementLoop(TypeRaw:int = 0):void 
		{
			var i:int;
			NumLoop = 0;
			var stkth:GetLoadInventory = GameLogic.getInstance().user.StockThingsArr;
			var indexTypeLoop:int = (TypeLoop - 1) * 2;
			if (IsSupperMatLoop)	indexTypeLoop++;
			
			if(TypeLoop <= 0 || arrNumMaterial[indexTypeLoop] < MAX_SLOT_MATERIAL)
			{
				IsSupperMatLoop = false;
				TypeLoop = 0;
				for (i = 0; i < arrNumMaterial.length - 2; i++) 
				{
					if (arrNumMaterial[i] >= MAX_SLOT_MATERIAL)
					{
						TypeLoop = int(i / 2) + 1;
						if (i % 2 == 1) 
						{
							IsSupperMatLoop = true;
						}
						break;
					}
				}
			}
			indexTypeLoop = (TypeLoop - 1) * 2;
			if (IsSupperMatLoop)	indexTypeLoop++;
			
			TotalLoop = 0;
			//for (i = 0; i < arrNumMaterial.length - 2; i++) 
			//{
				//if (arrNumMaterial[i] >= MAX_SLOT_MATERIAL && i == indexTypeLoop)
				//{
					//TypeLoop = int(i / 2) + 1;
					//if (IsLoop && i % 2 == 1) 
					//{
						//IsSupperMatLoop = true;
					//}
					switch (TypeRaw) 
					{
						case 0:
							NumLoop = 	Math.max(Math.min(int(arrNumMaterial[indexTypeLoop] / MAX_SLOT_MATERIAL), int(user.GetMyInfo().ZMoney / PayG(TypeLoop + 1))),
											Math.min(int(arrNumMaterial[indexTypeLoop] / MAX_SLOT_MATERIAL), int(user.GetMyInfo().Money / PayGoal(TypeLoop + 1))));
						break;
						case 2:
							NumLoop = Math.min(int(arrNumMaterial[indexTypeLoop] / MAX_SLOT_MATERIAL), int(user.GetMyInfo().ZMoney / PayG(TypeLoop + 1)));
						break;
						case 1:
							NumLoop = Math.min(int(arrNumMaterial[indexTypeLoop] / MAX_SLOT_MATERIAL), int(user.GetMyInfo().Money / PayGoal(TypeLoop + 1)));
						break;
					}
					TotalLoop = NumLoop;
					//break;
				//}
			//}
			//for (i = 0; i < arrUsedSlot.length; i++) 
			//{
				//if (arrUsedSlot[i] > 100)
				//{
					//IsSupperMatLoop = true;
				//}
			//}
		}
		public function  UpdateTimeOut():void 
		{
			var timeNow:int = GameLogic.getInstance().CurServerTime;
			if (timeNow - timeStartChooseLoop > TIME_OUT)
			{
				Show(Constant.GUI_MIN_LAYER, 6);
				//GuiMgr.getInstance().GuiMessageBox.ShowOK("Lỗi hệ thống!\nThao tác lại nhé ^x^");
			}
		}
		public function SetVisiableRaw(check:Boolean, isByG:Boolean = false):void 
		{
			//RawButton.SetVisible(check);
			btnRawByG.SetVisible(check);
			btnRawByGold.SetVisible(check);
			GetImage(IMG_BG_BUTTON_RAW).img.visible = check;
			//GetImage(IMG_BG_BUTTON_RAW_STOP).img.visible = !check;
			btnStopLoop.SetVisible(!check);
			LabelLoop.visible = !check;
			if (!IsLoop)
			{
				txtMoney.visible = true;
				txtMoney.x = 225;
				txtMoney.y = 420;
				txtZMoney.visible = true;
				txtZMoney.x = 365;
				txtZMoney.y = 420;
			}
		}
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{		
			var passwordState:String = GameLogic.getInstance().user.passwordState;
			switch (buttonID)
			{
				case BTN_CLOSE:	
					if (!isEff && !isFlying)
					{
						Hide();
					}
					break;
				case BTN_NEXT:
					lisRawMaterial.showNextPage();
					UpdateStateBtnNextPre(lisRawMaterial);
					break;
				case BTN_BUY:
					if (!isEff && !isFlying && !IsLoop)
					{
						GuiMgr.getInstance().GuiShop.CurrentShop = "Special";
						GuiMgr.getInstance().GuiShop.curPage = 2;
						GuiMgr.getInstance().GuiShop.Show(Constant.GUI_MIN_LAYER, 6);
						StateBuyShop = 1;
						//Hide();
					}
					break;
				case BTN_PRE:
					lisRawMaterial.showPrePage();
					UpdateStateBtnNextPre(lisRawMaterial);
					break;
				case BTN_STOP_LOOP:
					if (!IsStartChooseLoop)
					{
						DoOnButtonClickStopLoop(buttonID);
						IsCanChooseMaterial = true;
					}
					break;
				case BTN_RAW_MATERIAL_BY_GOLD:
					//Đang khóa hoặc xin phá khóa
					if (passwordState == Constant.PW_STATE_IS_LOCK || passwordState == Constant.PW_STATE_IS_CRACKING|| passwordState == Constant.PW_STATE_IS_BLOCKED)
					{
						GuiMgr.getInstance().guiPassword.showGUI();
						break;
					}
					if (!IsLoop)
					{
						if(!isEff && !isFlying && ResultMaxLevel != 0 && user.GetMoney() > PayGoal(ResultMaxLevel))
						{
							//ClearTooltipSlot();
							SendPackGold();
						}
					}
					else 
					{
						IsCanChooseMaterial = false
						doLoopRaw();
					}
					if (GetImage(ICON_HELPER) != null)
					{
						RemoveImage(GetImage(ICON_HELPER));
					}
					break;
				case BTN_RAW_MATERIAL_BY_G:
					//Đang khóa hoặc xin phá khóa
					if (passwordState == Constant.PW_STATE_IS_LOCK || passwordState == Constant.PW_STATE_IS_CRACKING || passwordState == Constant.PW_STATE_IS_BLOCKED)
					{
						GuiMgr.getInstance().guiPassword.showGUI();
						break;
					}
					if (!IsLoop)
					{
						if(!isEff && !isFlying && ResultMaxLevel != 0 && user.GetZMoney() > PayG(ResultMaxLevel))
						{
							//ClearTooltipSlot();
							SendPackG();
						}
					}
					else 
					{
						IsCanChooseMaterial = false;
						doLoopRaw(true);
					}
					break;
				case CTN_LOOP:
					DoOnButtonClickLoop();
				break;
				default:
					if (buttonID.search(MATERIAL) >= 0 )
					{
						DoOnButtonClickChooseMaterial(buttonID)
					}
					else 
						if (buttonID.search(CTN_SLOT_MATERIAL) >= 0)
						{
							if(!isEff && !isFlying && !IsLoop)
								RemoveMaterial(buttonID);
						}
					break;
			}
		}
		private function DoOnButtonClickChooseMaterial(buttonID:String):void 
		{
			//var obj:Object = ConfigJSON.getInstance().GetItemInfo("Material", buttonID.split(MATERIAL)[1]);
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Material", buttonID.split("_")[1]);
			if (buttonID.split("_").length > 2)
			{
				obj = ConfigJSON.getInstance().getItemInfo("Material", buttonID.split("_")[1] + 100);
			}
			var ctn:Container = lisRawMaterial.getItemById(buttonID);
			var typeMaterial:int = buttonID.split("_")[1];
			// typeMaxInLevel1 là cấp độ cao nhất có thể dùng với level skill của người chơi
			var typeMaxInLevel:int = ConfigJSON.getInstance().getItemInfo("M_MaterialSkill", LevelXPMatCurrent)["Craftable"] - 1;
			if (buttonID.split("_")[1] < MAX_TYPE_MATERIAL / 2)
			{
				if (typeMaterial <= typeMaxInLevel)
				{
					if(!IsLoop)
					{
						if (!isEff && !isFlying)
						{
							// quangvh01
							//var typeMaxInLevel1:int = MAX_TYPE_CAN_USE;
							
							if (LevelMat < int(MAX_TYPE_MATERIAL / 2))
							{
								if (buttonID.split("_")[1] >= LevelMat)	
								{
									if(!isMultiClick)
									{
										ActiveTooltip.getInstance().clearToolTip();
										txtFormat = new	 TextFormat();
										txtFormat.bold = true;			
										txtFormat.color = 0xF37621;
										toolTip = new TooltipFormat();
										var objMatInfo:Object = ConfigJSON.getInstance().getItemInfo("UpgradeMaterial", typeMaterial);
										toolTip.text = "Bạn cần lên level " + objMatInfo["LevelUnlock"].toString() + "\nĐể ép được ngư thạch này";
										toolTip.setTextFormat(txtFormat);
										ActiveTooltip.getInstance().showNewToolTip(toolTip, ctn.img);
									}
								}
								else 
								{
									if (buttonID.split("_")[2] && buttonID.split("_")[2] == "S")
									{
										ChooseMaterial(buttonID.split("_")[1], true);
									}
									else
									{
										ChooseMaterial(buttonID.split("_")[1]);
									}
								}
							}
							else 
							{
								if (buttonID.split("_")[2] && buttonID.split("_")[2] == "S")
								{
									ChooseMaterial(buttonID.split("_")[1], true);
								}
								else
								{
									ChooseMaterial(buttonID.split("_")[1]);
								}
							}
						}
					}
					else
					{
						if(IsCanChooseMaterial && !isEff && !isFlying)
						{	
							//UpdateElementLoop();
							var arrIdObject:Array = buttonID.split("_");
							var indexMat:int = (arrIdObject[1] - 1) * 2;
							if (arrIdObject.length > 2)
							{
								indexMat ++;
							}
							if(arrNumMaterial[indexMat] >= MAX_SLOT_MATERIAL)
							{
								var IdMat:int = arrIdObject[1];
								TypeLoop = IdMat % 100;
								var isEnoughMoney:Boolean = false;
								var isEnoughZMoney:Boolean = false;
								if (PayGoal(TypeLoop % 100 + 1) > GameLogic.getInstance().user.GetMyInfo().Money) 
								{
									btnRawByGold.SetDisable();
								}
								else
								{
									btnRawByGold.SetEnable();
									isEnoughMoney = true;
									
								}
								if (PayG(TypeLoop % 100 + 1) > GameLogic.getInstance().user.GetMyInfo().ZMoney) 
								{
									btnRawByG.SetDisable();
								}
								else
								{
									btnRawByG.SetEnable();
									isEnoughZMoney = true;
								}
								if (!isEnoughMoney && !isEnoughZMoney)
								{
									if (!isMultiClick)
									{
										ActiveTooltip.getInstance().clearToolTip();
										txtFormat = new	 TextFormat();
										txtFormat.bold = true;			
										txtFormat.color = 0xF37621;
										toolTip = new TooltipFormat()
										toolTip.text = "Bạn không đủ tiền\nđể ép viên ngư thạch này";
										toolTip.setTextFormat(txtFormat);
										ctn.setTooltip(toolTip);
										ActiveTooltip.getInstance().showNewToolTip(toolTip, ctn.img);
										isMultiClick = true;
									}
									return;
								}
								if (arrIdObject.length > 2)
								{
									IsSupperMatLoop = true;
								}
								else
								{
									IsSupperMatLoop = false;
								}
								if(TypeLoop <= typeMaxInLevel)
								{
									for (var j2:int = 0; j2 < lisRawMaterial.length; j2++) 
									{
										var item2:Container = lisRawMaterial.getItemByIndex(j2);
										var item_ChooseMatLoop2:Container = item2.GetContainer(CTN_CHOOSE_MATERIAL_LOOP);
										item_ChooseMatLoop2.SetVisible(IsLoop);
										if(item2.IdObject.split("_")[1] == IdMat)
										{
											if((IsSupperMatLoop && item2.IdObject.split("_").length == 3) || (!IsSupperMatLoop && item2.IdObject.split("_").length == 2))
											{
												item_ChooseMatLoop2.GetImage(IMG_TICKED).img.visible = true;
												item2.SetHighLight(0xFF0000, true);
												//lisRawMaterial.showItem(j2);
												UpdateStateBtnNextPre(lisRawMaterial);
											}
											else
											{
												item_ChooseMatLoop2.GetImage(IMG_TICKED).img.visible = false;
											}
										}
										else
										{
											item_ChooseMatLoop2.GetImage(IMG_TICKED).img.visible = false;
										}
									}
									
									txtMoney.text = Ultility.StandardNumber(PayGoal(TypeLoop % 100 + 1));
									txtZMoney.text = Ultility.StandardNumber(PayG(TypeLoop % 100 + 1));
									
									NumLoop = 	Math.max(Math.min(int(arrNumMaterial[indexMat] / MAX_SLOT_MATERIAL), int(user.GetMyInfo().ZMoney / PayG(TypeLoop + 1))),
															Math.min(int(arrNumMaterial[indexMat] / MAX_SLOT_MATERIAL), int(user.GetMyInfo().Money / PayGoal(TypeLoop + 1))));
									labelProgressNumLoop.text = Ultility.StandardNumber(NumLoop);
								}
								else
								{
									if (!isMultiClick)
									{
										ActiveTooltip.getInstance().clearToolTip();
										txtFormat = new	 TextFormat();
										txtFormat.bold = true;			
										txtFormat.color = 0xF37621;
										toolTip = new TooltipFormat()
										toolTip.text = "Bạn chưa đủ kỹ năng\nđể ép viên ngư thạch này";
										toolTip.setTextFormat(txtFormat);
										ctn.setTooltip(toolTip);
										ActiveTooltip.getInstance().showNewToolTip(toolTip, ctn.img);
										isMultiClick = true;
									}
								}
							}
							else
							{
								ActiveTooltip.getInstance().clearToolTip();
								txtFormat = new	 TextFormat();
								txtFormat.bold = true;			
								txtFormat.color = 0xF37621;
								toolTip = new TooltipFormat()
								toolTip.text = "Bạn không đủ ngư thạch\nđể ghép tự động";
								toolTip.setTextFormat(txtFormat);
								ctn.setTooltip(toolTip);
								ActiveTooltip.getInstance().showNewToolTip(toolTip, ctn.img);
							}
						}
						
					}
				}
				else 
				{
					if (!isMultiClick)
					{
						ActiveTooltip.getInstance().clearToolTip();
						txtFormat = new	 TextFormat();
						txtFormat.bold = true;			
						txtFormat.color = 0xF37621;
						toolTip = new TooltipFormat()
						toolTip.text = "Bạn chưa đủ kỹ năng\nđể ép viên ngư thạch này";
						toolTip.setTextFormat(txtFormat);
						ctn.setTooltip(toolTip);
						ActiveTooltip.getInstance().showNewToolTip(toolTip, ctn.img);
						isMultiClick = true;
					}
				}
			}
			else 
			{
				ActiveTooltip.getInstance().clearToolTip();
				txtFormat = new	 TextFormat();
				txtFormat.bold = true;			
				txtFormat.color = 0xF37621;
				toolTip = new TooltipFormat();
				toolTip.text = "Không thể ghép\nngư thạch này";
				//toolTip.text = "Ngư thạch \n đã đạt cấp tối đa" + "\nKhông thể \nép được nữa";
				toolTip.setTextFormat(txtFormat);
				ctn.setTooltip(toolTip);
				ActiveTooltip.getInstance().showNewToolTip(toolTip, ctn.img);
				
				var posStart:Point;
				var posEnd:Point;
				posStart = GameInput.getInstance().MousePos;
				posEnd = new Point(posStart.x, posStart.y - 100);
				var txtFormat1:TextFormat = new TextFormat(null, 14, 0xFFFF00);
				txtFormat1.align = "center";
				txtFormat1.bold = true;
				txtFormat1.font = "Arial";
				var str:String = "Không thể ghép\nngư thạch này"
				Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat1, 1, 0x000000);
			}
		}
		private function DoOnButtonClickStopLoop(buttonID:String):void 
		{
			var typeMaterial:int = buttonID.split("_")[1];
			IsLoop = false;
			imgTicked.img.visible = IsLoop;
			SetVisiableRaw(!IsLoop);
			//RawButton.SetEnable(IsLoop);
			btnRawByG.SetDisable();
			btnRawByGold.SetDisable();
			DeBlackWhiteImage(container_loop.img);
			//progressNumLoop.setStatus(0);
			labelProgressNumLoop.text = "0";
			container_result_material.ClearComponent();
			for (var j1:int = 0; j1 < lisRawMaterial.length; j1++) 
			{
				var item1:Container = lisRawMaterial.getItemByIndex(j1);
				var item_ChooseMatLoop1:Container = item1.GetContainer(CTN_CHOOSE_MATERIAL_LOOP);
				item_ChooseMatLoop1.SetVisible(false);
				if(item1.IdObject.search(typeMaterial.toString()) >= 0)
				{
					item_ChooseMatLoop1.GetImage(IMG_TICKED).img.visible = false;
				}
				else
				{
					item_ChooseMatLoop1.GetImage(IMG_TICKED).img.visible = false;
				}
			}
		}
		private function DoOnButtonClickLoop():void 
		{
			if (!isStartRaw) 
			{
				UpdateElementLoop();
				var typeMaterial:int = TypeLoop;
				var typeMaxInLevel:int = ConfigJSON.getInstance().getItemInfo("M_MaterialSkill", LevelXPMatCurrent)["Craftable"] - 1;
				if (typeMaterial <= typeMaxInLevel)
				{	
					
					if (TypeLoop < LevelMat && (user.GetMyInfo().Money >= PayGoal(TypeLoop % 100 + 1) || user.GetMyInfo().ZMoney >= PayG(TypeLoop % 100 + 1))) 
					{
						for (var j:int = 0; j < lisRawMaterial.length; j++) 
						{
							var item:Container = lisRawMaterial.getItemByIndex(j);
							var item_ChooseMatLoop:Container = item.GetContainer(CTN_CHOOSE_MATERIAL_LOOP);
							item_ChooseMatLoop.SetVisible(!IsLoop);
							if(item.IdObject.split("_")[1] == typeMaterial)
							{
								if((IsSupperMatLoop && item.IdObject.split("_").length == 3) || (!IsSupperMatLoop && item.IdObject.split("_").length == 2))
								{
									item_ChooseMatLoop.GetImage(IMG_TICKED).img.visible = true;
									item.SetHighLight(0xFF0000, true);
									lisRawMaterial.showItem(j);
									UpdateStateBtnNextPre(lisRawMaterial);
								}
								else
								{
									item_ChooseMatLoop.GetImage(IMG_TICKED).img.visible = false;
								}
							}
							else
							{
								item_ChooseMatLoop.GetImage(IMG_TICKED).img.visible = false;
							}
						}
						var checkUsedSlot:Boolean = false;
						for (var i:int = 0; i < arrUsedSlot.length; i++)
						{
							if (arrUsedSlot[i] > 0)
							{
								checkUsedSlot = true;
								break;
							}
						}
						
						if(!checkUsedSlot)
						{
							IsLoop = !IsLoop;
							imgTicked.img.visible = IsLoop;
							if(!IsLoop)
							{
								IsCanChooseMaterial = !IsLoop;
							}
							if (IsLoop)
							{
								SetVisiableRaw(true);
								ResultMaxLevel = TypeLoop + 1;
								if (TypeLoop > 0)
								{
									if (TypeLoop < LevelMat && TypeLoop > 0)
									{
										//RawButton.SetDisable();
										if(user.GetZMoney() <= PayG(TypeLoop % 100 + 1))
										{
											btnRawByG.SetDisable();
										}
										else 
										{
											btnRawByG.SetEnable();
										}
										if(user.GetMoney() <= PayGoal(TypeLoop % 100 + 1))
										{
											btnRawByGold.SetDisable();
										}
										else 
										{
											btnRawByGold.SetEnable();
										}
									}
									txtMoney.text = Ultility.StandardNumber(PayGoal(TypeLoop % 100 + 1));
									txtZMoney.text = Ultility.StandardNumber(PayG(TypeLoop % 100 + 1));
								}
								else 
								{
									//RawButton.SetDisable();
									btnRawByG.SetDisable();
									btnRawByGold.SetDisable();
								}
								//progressNumLoop.setStatus(NumLoop / TotalLoop);
								labelProgressNumLoop.text = NumLoop.toString();
							}
							else
							{
								NumLoop = 0;
								TotalLoop = 0;
								IsSupperMatLoop = false;
								TypeLoop = 0;
								//progressNumLoop.setStatus(NumLoop / TotalLoop);
								labelProgressNumLoop.text = NumLoop.toString();
								//progressNumLoop.setStatus(0);
								labelProgressNumLoop.text = "0";
								txtMoney.visible = true;
								txtMoney.x = 225;
								txtMoney.y = 420;
								txtMoney.text = "0";
								txtZMoney.visible = true;
								txtZMoney.x = 365;
								txtZMoney.y = 420;
								txtZMoney.text = "0";
								btnStopLoop.SetVisible(false);
								btnRawByG.SetVisible(true);
								btnRawByGold.SetVisible(true);
								btnRawByG.SetDisable();
								btnRawByGold.SetDisable();
							}
						}
						if (container_loop.tooltip.text != "Chọn / bỏ chọn lặp tự động")
						{
							toolTip = new TooltipFormat();
							toolTip.text = "Chọn / bỏ chọn lặp tự động";
							container_loop.setTooltip(toolTip);
						}
					}
					else 
					{
						toolTip = new TooltipFormat();
						toolTip.text = "Bạn chưa đủ level hoặc\nkhông đủ tiền để\ntự động ép nguyên liệu này";
						container_loop.setTooltip(toolTip);
						ActiveTooltip.getInstance().showNewToolTip(toolTip, container_loop.img);
					}
				}
				else 
				{
					toolTip = new TooltipFormat();
					toolTip.text = "Bạn chưa đủ kỹ năng để\nghép nguyên liệu cấp: " + (typeMaxInLevel + 1);
					container_loop.setTooltip(toolTip);
					ActiveTooltip.getInstance().showNewToolTip(toolTip, container_loop.img);
				}
			}
		}
		private function doLoopRaw(isByG:Boolean = false):void 
		{
			UpdateElementLoop();
			var canRaw:Boolean = false;
			if (isByG)
			{
				if (user.GetZMoney() >= PayG(TypeLoop % 100 + 1))
				{
					canRaw = true;
				}
			}
			else
			{
				if (user.GetMoney() >= PayGoal(TypeLoop % 100 + 1))
				{
					canRaw = true;
				}
			}
			if (TypeLoop < LevelMat && TypeLoop > 0 && canRaw)
			{
				SetVisiableRaw(false);
				//progressNumLoop.setStatus(NumLoop / TotalLoop);
				labelProgressNumLoop.text = NumLoop.toString();
				if (TypeLoop < int(MAX_TYPE_MATERIAL / 2))
				{
					if(isByG)
					{
						UpdateElementLoop(2);
					}
					else
					{
						UpdateElementLoop(1);
					}
					RawLoop(0, IsSupperMatLoop, isByG);
					var indexMaterial:int = lisRawMaterial.getIndexById(MATERIAL + TypeLoop.toString());
					if(IsSupperMatLoop)	indexMaterial = lisRawMaterial.getIndexById(MATERIAL + TypeLoop.toString() + SUPPER);
					var indexStart:int = int(indexMaterial / NUM_ELEMENT_IN_LIST ) * NUM_ELEMENT_IN_LIST;
					var indexEnd:int = (int(indexMaterial / NUM_ELEMENT_IN_LIST) + 1) * NUM_ELEMENT_IN_LIST;
					//lisRawMaterial.showPage(indexMaterial / NUM_ELEMENT_IN_LIST);
					BlackWhiteImage(container_loop.img);
				}
			}
			if (!isByG)
			{
				txtMoney.visible = true;
				txtMoney.x = 285;
				txtMoney.y = 410;
				txtZMoney.visible = false;
			}
			else
			{
				txtMoney.visible = false;
				txtZMoney.visible = true;
				txtZMoney.x = 295;
				txtZMoney.y = 410;
			}
		}
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			var ctn:Container;		
			switch (buttonID) 
			{
				case CTN_RATIO_LEVEL:
					GuiMgr.getInstance().GuiSkillRawMaterialInfo.Show();
					break;
				default:
					if(buttonID && buttonID.search(MATERIAL) >= 0 && buttonID.split("_")[0] == "Material")
					{
						var obj:Object = ConfigJSON.getInstance().getItemInfo("Material", buttonID.split(MATERIAL)[1]);
						ctn = lisRawMaterial.getItemById(buttonID);
						if (LevelMat < 5)
						{
							if (buttonID.split(MATERIAL)[1] >= LevelMat)	
							{
								txtFormat = new	 TextFormat();
								txtFormat.bold = true;			
								txtFormat.color = 0xF37621;
								toolTip = new TooltipFormat()
								toolTip.text = obj["Name"];
								toolTip.setTextFormat(txtFormat);
								ctn.setTooltip(toolTip);
							}
						}
						
						if (ctn)
						{
							ctn.SetHighLight(0x00FF00, true);
						}
					}
					break;
			}
		}
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			var ctn:Container;
			switch (buttonID)
			{	
				case CTN_RATIO_LEVEL:
					if(GuiMgr.getInstance().GuiSkillRawMaterialInfo.IsVisible)
						GuiMgr.getInstance().GuiSkillRawMaterialInfo.Hide();
					break;	
				case CTN_LOOP:
					toolTip = new TooltipFormat();
					toolTip.text = "Chọn/Bỏ chọn lặp tự động";
					container_loop.setTooltip(toolTip);
					//ActiveTooltip.getInstance().showNewToolTip(toolTip, container_loop.img);
				break;
				default:								
					var MatType:int = buttonID.split("_")[1];
					if(buttonID.split("_")[0] == "Material")
					{
						if (buttonID.split("_")[2] && buttonID.split("_")[2] == "S") 
						{
							MatType += 100;
						}
						var obj:Object = ConfigJSON.getInstance().getItemInfo("Material", MatType);
						if (buttonID.search(MATERIAL) >= 0)
						{
							ctn = lisRawMaterial.getItemById(buttonID);
						}
						if (ctn)
						{
							ctn.SetHighLight( -1);
							if (buttonID.split("_")[1] == 5)	
							{
								txtFormat = new	 TextFormat();
								txtFormat.bold = true;			
								txtFormat.color = 0xF37621;
								toolTip = new TooltipFormat()
								toolTip.text = obj["Name"];
								toolTip.setTextFormat(txtFormat);
								ctn.setTooltip(toolTip);
							}
						}
						var typeMaterial:int = buttonID.split("_")[1];
						var typeMaxInLevel:int = ConfigJSON.getInstance().getItemInfo("M_MaterialSkill", LevelXPMatCurrent)["Craftable"] - 1;
						if (buttonID.split("_")[1] && typeMaterial > typeMaxInLevel)
						{
							txtFormat = new	 TextFormat();
							txtFormat.bold = true;			
							txtFormat.color = 0xF37621;
							toolTip = new TooltipFormat()
							toolTip.text = obj["Name"];
							toolTip.setTextFormat(txtFormat);
							ctn.setTooltip(toolTip);
						}
						isMultiClick = false;
					}
					break;
			}
		}
		
		/**
		 * Hàm thực hiện gửi gói tin, cập nhật các param cần và eff khi kích vào btn g
		 */
		private function SendPackG():void 
		{
			var i:int = 0;
			var arr:Array = [];
			var count:int = 0;
			for (i = 0; i < MAX_TYPE_MATERIAL; i++) 
			{
				arr.push(0);
			}
			for (i = 0; i < MAX_SLOT_MATERIAL; i++) 
			{
				if (arrUsedSlot[i] != 0)
				{
					var r:int = arrUsedSlot[i] % 100;
					var q:int = arrUsedSlot[i] / 100;
					arr[(r - 1) * 2 + q]++;
					count++;
				}
			}
			if (count > 1)
			{
				IsEffSendFinish = false;
				//RawButton.SetDisable();
				btnRawByG.SetDisable();
				btnRawByGold.SetDisable();
				timeStartChooseLoop = GameLogic.getInstance().CurServerTime;
				user.UpdateUserZMoney( -PayG(ResultMaxLevel), true);
				IsReceived = false;
				var materialPack:SendMaterialService = new SendMaterialService(arr, "ZMoney");
				Exchange.GetInstance().Send(materialPack);
				isEff = true;
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiRawMaterials_EffClickRaw", null, DELTA_X + container_result_material.CurPos.x + 238, 
					container_result_material.CurPos.y  + 165 + DELTA_Y, false, false, null, function():void { EffSend(materialPack) } );
			}
		}
		/**
		 * Hàm thực hiện gửi gói tin, cập nhật các param cần và eff khi kích vào btn goal
		 */
		private function SendPackGold():void 
		{
			var i:int = 0;
			var arr:Array = [];
			var count:int = 0;
			for (i = 0; i < MAX_TYPE_MATERIAL; i++) 
			{
				arr.push(0);
			}
			for (i = 0; i < MAX_SLOT_MATERIAL; i++) 
			{
				if (arrUsedSlot[i] != 0)
				{
					var r:int = arrUsedSlot[i] % 100;
					var q:int = arrUsedSlot[i] / 100;
					arr[(r - 1) * 2 + q]++;
					count++;
				}
			}
			if (count > 1)
			{
				IsEffSendFinish = false;
				//RawButton.SetDisable();
				btnRawByG.SetDisable();
				btnRawByGold.SetDisable();
				timeStartChooseLoop = GameLogic.getInstance().CurServerTime;
				user.UpdateUserMoney( -PayGoal(ResultMaxLevel), true);
				IsReceived = false;
				var materialPack:SendMaterialService = new SendMaterialService(arr);
				Exchange.GetInstance().Send(materialPack);
				isEff = true;
				if(IsVisible)
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiRawMaterials_EffClickRaw", null, DELTA_X + container_result_material.CurPos.x + 238, 
					container_result_material.CurPos.y  + 165 + DELTA_Y, false, false, null, function():void { EffSend(materialPack) } );
			}
		}
		public function UpdateMaterialUserOk(newData:Object,oldData:Object):void 
		{
			IsReceived = true;
			NewData = newData;
			OldData = oldData;
			IsStartChooseLoop = false;
		}
		public function UpdateMaterialUserOkStart():void 
		{
			//var isExist:Boolean = false;
			//var indexResult:int = -1;
			//var index:int = NewData["TypeId"] - 1;
			var isRawByG:Boolean;
			if (OldData.PriceType == "Money")
			{
				isRawByG = false;
			}
			else
			{
				isRawByG = true;
			}
			var i:int = 0;
			var isSuccess:Boolean = false;
			if (NewData["TypeId"] != -1)	isSuccess = true;
			var arr:Array = [];
			var itemId_return:String = NewData["TypeId"].toString();
			if (NewData["TypeId"] > 100)	itemId_return = (NewData["TypeId"] % 100).toString() + "S";
			var child1:String = "Material" + itemId_return;
			arr.push(child1);
			ResultMaxLevel = 0;
			
			if (NewData["Error"] == 0)
			{
				// cập nhật lại số nguyên liệu có trong kho
				for (var j:int = 0; j < OldData["MaterialList"].length; j++) 
				{
					for (i = 0; i < user.StockThingsArr.Material.length; i++) 
					{
						if (user.StockThingsArr.Material[i][ConfigJSON.KEY_ID] == OldData["MaterialList"][j]["TypeId"].toString())
						{
							if (OldData["MaterialList"][j]["Num"] >= user.StockThingsArr.Material[i]["Num"])
							{
								i--;
							}
							user.UpdateStockThing("Material", OldData["MaterialList"][j]["TypeId"], -OldData["MaterialList"][j]["Num"]);
							break;
						}
					}
				}
				// cập nhật thêm vào mảng danh sách các nguyên liệu nếu thành công
				if (isSuccess)
				{
					user.UpdateStockThing("Material", NewData["TypeId"], 1);
				}
				// Xử lý eff và GUI khi success thay fail
				var con:Container;
				var LevelReturn:int;
				var objMatMasteryPoint:Object;
				var tmp:Sprite;
				var pos:Point;
				var eff:ImgEffectFly;
				if (isSuccess)	
				{
					// Cập nhật lại XP của việc ép nguyên liệu
					var MatPoitAdd:int = 0;
					LevelReturn = NewData["TypeId"] % 100 - 1;
					objMatMasteryPoint = ConfigJSON.getInstance().getItemInfo("M_MasteryPoint", user.GetMyInfo().MatLevel);
					if (objMatMasteryPoint && objMatMasteryPoint[LevelReturn.toString()])
					{
						if (NewData["TypeId"] > 100)
						{
							if(objMatMasteryPoint[LevelReturn.toString()]["Critical"])
								MatPoitAdd = objMatMasteryPoint[LevelReturn.toString()]["Critical"];
						}
						else 
						{
							if(objMatMasteryPoint[LevelReturn.toString()]["Success"])
								MatPoitAdd = objMatMasteryPoint[LevelReturn.toString()]["Success"];
						}
					}
					user.GetMyInfo().MatPoint += MatPoitAdd;
					XPMatCurrent += MatPoitAdd;
					progress.setStatus(XPMatCurrent / XPMatCurrentLevel);
					labelRatioLevel.text = (Math.min(int(XPMatCurrent / XPMatCurrentLevel * 1000) / 10, 100)).toString() + "%";
					// effect bay điểm về
					txtFormat = new TextFormat("Arial", 18);
					txtFormat.color = 0x79D0F4;
					txtFormat.bold = true;
					tmp = Ultility.CreateSpriteText("+" + MatPoitAdd.toString(), txtFormat, 6, 0, false);					
					pos = this.img.localToGlobal(container_RatioLevel.CurPos);
					eff = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
					eff.SetInfo(440, 287, 440, 118, 7);
					// Xóa các component của các slot để chuẩn bị cho lần ép sau
					for (i= 0; i < arrMaterialSlot.length; i++) 
					{
						con = arrMaterialSlot[i] as Container;
						con.ClearComponent();
						con.IdObject = CTN_SLOT_MATERIAL + i;
					}
					// Cập nhật lại ảnh của kết quả ở trung tâm (kết quả lấy từ server)
					container_result_material.AddImage(IMG_MATERIAL_CENTER, "Material" + itemId_return, container_result_material.img.width / 2, 
						container_result_material.img.height / 2, true, ALIGN_LEFT_TOP);
					// Show hiệu ứng khi thành công
					// Eff ứng với kết quả
					var itemId_return_List:String;
					var ctn:Container;
					if (NewData["TypeId"] > 100)	
					{
						itemId_return_List = (NewData["TypeId"] % 100).toString() + "_S";
						ctn = lisRawMaterial.getItemById(MATERIAL + itemId_return_List);
						isEff = true;
						EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiRawMaterials_EffRawLucky", arr, DELTA_X + container_result_material.CurPos.x 
							+ 238, container_result_material.CurPos.y  + 98 + DELTA_Y, false, false, null,  function():void { EffAfter(ctn, NewData, isRawByG) } );
					}
					else 
					{
						itemId_return_List = NewData["TypeId"].toString();
						ctn = lisRawMaterial.getItemById(MATERIAL + itemId_return_List);
						isEff = true;
						EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiRawMaterials_EffRawSucces", arr, DELTA_X + container_result_material.CurPos.x 
							+ 238, container_result_material.CurPos.y  + 98 + DELTA_Y, false, false, null,  function():void { EffAfter(ctn, NewData, isRawByG) } );
					}
				}
				else
				{
					LevelReturn = 0;
					for (i = 0; i < OldData["MaterialList"].length; i++ ) 
					{
						var objtemp:Object = OldData["MaterialList"][i];
						if (objtemp["TypeId"] % 100 > LevelReturn)
						{
							LevelReturn = objtemp["TypeId"] % 100;
						}
					}
					
					objMatMasteryPoint = ConfigJSON.getInstance().getItemInfo("M_MasteryPoint", user.GetMyInfo().MatLevel);
					
					if (objMatMasteryPoint && objMatMasteryPoint[LevelReturn.toString()] && objMatMasteryPoint[LevelReturn.toString()]["Fail"])
					{
						MatPoitAdd = objMatMasteryPoint[LevelReturn.toString()]["Fail"];
					}
					else 
					{
						MatPoitAdd = 0;
					}
					user.GetMyInfo().MatPoint += MatPoitAdd;
					XPMatCurrent += MatPoitAdd;
					progress.setStatus(XPMatCurrent / XPMatCurrentLevel);
					labelRatioLevel.text = (Math.min(int(XPMatCurrent / XPMatCurrentLevel * 1000) / 10, 100)).toString() + "%";
					// effect bay điểm về
					txtFormat = new TextFormat("Arial", 18);
					txtFormat.color = 0x79D0F4;
					txtFormat.bold = true;
					tmp = Ultility.CreateSpriteText("+" + MatPoitAdd.toString(), txtFormat, 6, 0, false);					
					pos = this.img.localToGlobal(container_RatioLevel.CurPos);
					eff = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
					//eff.SetInfo(pos.x + 35, 321, pos.x + 35, 231, 7);
					eff.SetInfo(440, 287, 440, 118, 7);
					
					// Cập nhật lại số lượng material của user
					for (i= 0; i < arrMaterialSlot.length; i++) 
					{
						con = arrMaterialSlot[i] as Container;
						con.ClearComponent();
						con.IdObject = CTN_SLOT_MATERIAL + i;
					}
					// Hiện effect thất bại
					isEff  = true;
					EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiRawMaterials_EffRawFail", arr, DELTA_X + container_result_material.CurPos.x
						+ 240, container_result_material.CurPos.y  + 150 + DELTA_Y,false,false,null,function():void{EffAfterFail(isRawByG)});
					container_result_material.ClearComponent();
				}
				// cập nhật lại các tooltip cần thiết
				txtMoney.text = "0";
				txtZMoney.text = "0";
				//progress.setStatus(0);
				labelProgress.text = "";
				InitArrNumMaterial(user.StockThingsArr.Material);
				// Cập nhật lại level ép nguyên liệu
				var objMatLevel:Object = ConfigJSON.getInstance().getItemInfo("M_MaterialSkill", LevelXPMatCurrent + 1);
				var LevelUserNeedToUpgradeNextSkill:int;
				if(objMatLevel)
				{
					LevelUserNeedToUpgradeNextSkill = objMatLevel["LevelRequire"];
				}
				else 
				{
					LevelUserNeedToUpgradeNextSkill = int.MAX_VALUE;
				}
				if (XPMatCurrent >= XPMatCurrentLevel && LevelXPMatCurrent <= MAX_LEVEL_SKILL_RAW && user.GetLevel() >= LevelUserNeedToUpgradeNextSkill)
				{
					// Gửi gói tin lên Level cho server
					Exchange.GetInstance().Send(new SendLevelMaterialSkill());
				}
			}
			else 
			{
				user.UpdateUserMoney(PayGoal(ResultMaxLevel));
				Show(Constant.GUI_MIN_LAYER, 6);
			}
		}
		// Slot đầu tiên khi chọn
		public function RawLoop(iSlot:int = 0, isLoopSupperMat:Boolean = false, isRawByG:Boolean = false):void 
		{
			if (IsUpgardeLevelMat) 
			{
				// Cập nhật lại hiển thị skill trong GUIRaw
				UpdateSkillRaw();
				UpdateGiftToStore(Data["Gift"]);
				// hiện GUI khi có quà
				IsLoop = false;
				imgTicked.img.visible = false;
				SetVisiableRaw(true);
				DeBlackWhiteImage(container_loop.img);
				//RawButton.SetDisable();
				btnRawByG.SetDisable();
				btnRawByGold.SetDisable();
				GuiMgr.getInstance().GuiUpgradeSkillMaterial.setInfo(Data["Gift"]);
				GuiMgr.getInstance().GuiUpgradeSkillMaterial.Show();
			}
			if (NumLoop == 0) 
			{
				SetVisiableRaw(true);
				DeBlackWhiteImage(container_loop.img);
				if(isRawByG)
				{
					UpdateElementLoop(2);
				}
				else
				{
					UpdateElementLoop(1);
				}
				//progressNumLoop.setStatus(0);
				labelProgressNumLoop.text = "0";
				container_result_material.ClearComponent();
				IsLoop = false;
				imgTicked.img.visible = IsLoop;
				for (var j:int = 0; j < lisRawMaterial.length; j++) 
				{
					var item:Container = lisRawMaterial.getItemByIndex(j);
					var item_ChooseMatLoop:Container = item.GetContainer(CTN_CHOOSE_MATERIAL_LOOP);
					item_ChooseMatLoop.SetVisible(IsLoop);
				}
				TypeLoop = -1;
				IsSupperMatLoop = false;
				//RawButton.SetDisable();
				btnRawByG.SetDisable();
				btnRawByGold.SetDisable();
				IsUpgardeLevelMat = false;
				txtMoney.visible = true;
				txtMoney.x = 225;
				txtMoney.y = 420;
				txtZMoney.visible = true;
				txtZMoney.x = 365;
				txtZMoney.y = 420;
				IsCanChooseMaterial = true;
				return;
			}
			else 
			{
				if (!IsUpgardeLevelMat)
				{
					if((!isRawByG && user.GetMoney() >= PayGoal(TypeLoop + 1)) || (isRawByG && user.GetZMoney() >= PayG(TypeLoop + 1)))
					{
						isStartRaw = true;
						EffChooseMaterial(TypeLoop, iSlot, isLoopSupperMat, isRawByG);
					}
					else 
					{
						SetVisiableRaw(true);
						DeBlackWhiteImage(container_loop.img);
						//RawButton.SetDisable();
						btnRawByG.SetDisable();
						btnRawByGold.SetDisable();
					}
				}
				else 
				{
					IsUpgardeLevelMat = false;
					return;
				}
			}
		}
		
		public function UpdateSkillRaw():void 
		{
			GameLogic.getInstance().user.GetMyInfo().MatLevel++;
			GameLogic.getInstance().user.GetMyInfo().MatPoint -= XPMatCurrentLevel;
			XPMatCurrent = 0;
			//XPMatCurrent -= XPMatCurrentLevel;
			LevelXPMatCurrent ++;
			var objMatLevel:Object = ConfigJSON.getInstance().getItemInfo("M_MaterialSkill", LevelXPMatCurrent);
			if(objMatLevel)
			{
				XPMatCurrentLevel = objMatLevel["Mastery"];
			}
			progress.setStatus(XPMatCurrent / XPMatCurrentLevel);
			labelRatioLevel.text = (Math.min(int(XPMatCurrent / XPMatCurrentLevel * 1000) / 10, 100)).toString() + "%";
			labelLevelSkill.text = "Cấp độ " + LevelXPMatCurrent.toString();
			
		}
		
		public function UpdateGiftToStore(Gift:Object):void 
		{
			for (var s:String in Gift)
			{
				var mat:Array = GameLogic.getInstance().user.StockThingsArr.Material;
				GameLogic.getInstance().user.UpdateStockThing(Gift[s]["ItemType"], int(Gift[s]["ItemId"]), int(Gift[s]["Num"]));
				
			}
		}
		
	}
}