package GUI.MateFish 
{
	import com.adobe.utils.IntUtil;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImgEffectFly;
	import Effect.SwfEffect;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ProgressBar;
	import GUI.component.TooltipFormat;
	import GUI.GUIFeedWall;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import GUI.GUIShop;
	import GUI.MateFish.ItemFish;
	import GUI.MateFish.ItemFormula;
	import GUI.MateFish.ItemMaterial;
	import Logic.Fish;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.LayerMgr;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendBuyOther;
	import NetworkPacket.PacketSend.SendMateFish;
	import particleSys.myFish.CometEmit;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIMateFish extends BaseGUI 
	{
		static public const BTN_BACK_FORMULA_LIST:String = "btnBackFormulaList";
		static public const BTN_NEXT_FORMULA_LIST:String = "btnNextFormulaList";
		static public const CTN_FORMULA:String = "ctnFormula";
		static public const CTN_USED_FORMULA:String = "ctnUsedFormula";
		public var isReceivedStore:Boolean = false;
		public var isReceivedFish:Boolean = false;
		
		private const CTN_SKILL:String = "CtnSkill";
		private const BTN_CLOSE:String = "BtnClose";
		private const BTN_PAY_FULL:String = "BtnPayFull";
		private const BTN_BUY_VIAGRA:String = "BtnBuyViagra";
		private const CTN_VIAGRA:String = "CtnViagra";
		private const CTN_MATERIAL:String = "CtnMaterial";
		private const CTN_USED_MATERIAL:String = "CtnUsedMaterial";
		private const BTN_BUY_MATERIAL:String = "BtnBuyMaterial";
		private const BTN_BACK_MATER_LIST:String = "btnBackMaterList";
		private const BTN_NEXT_MATER_LIST:String = "btnNextMaterList";
		private const CTN_BOY:String = "ctnBoy";
		private const CTN_GIRL:String = "ctnGirl";
		private const BTN_MATE:String = "btnMate";
		
		private const BTN_BACK_BOY_LIST:String = "btnUpBoyList";
		private const BTN_NEXT_BOY_LIST:String = "btnDownBoyList";
		private const BTN_BACK_GIRL_LIST:String = "btnUpGirlList";
		private const BTN_NEXT_GIRL_LIST:String = "btnDownGirlList";
		private const BTN_BACK_RESULT_LIST:String = "btnBackResultList";
		private const BTN_NEXT_RESULT_LIST:String = "btnNextResultList";
		
		private const IMAGE_EFF_COLOR:String = "Image_Eff_Color";
		private const IMAGE_EFF_LIGHT:String = "Image_Eff_Light";
		
		private const MAX_SLOT_MATERIAL:int = 6;
		private const MAX_OVER_LEVEL:int = 5;
		private const PERCENT_UNEQUAL_LEVEL:int = 10;
		private const PERCENT_UNEQUAL_LEVEL_MAX:int = 50;
		
		private const QUEST_CHOOSE_BOY:int = 1;
		private const QUEST_CHOOSE_GIRL:int = 2;
		private const QUEST_SKILL_MONEY:int = 3;
		private const QUEST_SKILL_LEVEL:int = 4;
		private const QUEST_SKILL_SPECIAL:int = 5;
		private const QUEST_SKILL_RARE:int = 6;
		private const QUEST_MATE:int = 7;
		
		private var listBoxSkill:ListBox;
		
		private var curEnergy:int;
		private var maxEnergy:int;
		private var prgCurEnergy:ProgressBar;
		private var prgEnergy:ProgressBar;
		private var txtEnergy:TextField;
		private var btnFillEnergy:Button;
		
		private var btnBuyViagra:Button;
		private var _numViagra:int;
		private var textFieldViagra:TextField;
		private var ctnViagra:Container;
		
		private var listMaterial:ListBox;
		private var listBoy:ListBox;
		private var listGirl:ListBox;
		private var boyArr:Array;
		private var girlArr:Array;
		private var listUsedMaterial:ListBox;
		private var listResult:ListBox;	
		
		private var chosenBoy:Image;
		private var chosenGirl:Image;
		private var father:Fish;
		private var mother:Fish;
		
		private var _price:int;
		private var _percentLevel:Number;
		private var _percentSpecial:Number;
		private var _percentRare:Number;
		
		private var txtPrice:TextField;
		private var txtLevel:TextField;
		private var txtSpecial:TextField;
		private var txtRare:TextField;
		private var txtWarning:TextField;
		
		private var _buffMoney:Number;
		private var _buffLevel:Number;
		private var _buffSpecial:Number;
		private var _buffRare:Number;
		
		private var numSlotMaterial:int;
		
		private var itemFather:ItemFish;
		private var itemMother:ItemFish;
		
		private var emitStar:Array = [];
		
		private var levelMin:int;
		private var levelMax:int;
		private var txtNumGirl:TextField;
		private var txtNumBoy:TextField;
		private var _numGirl:int;
		private var _numBoy:int;
		
		private var isMating:Boolean;
		
		//Quest
		private var imageHelper:Image;
		private var questName:Array;
		private var questStatus:int;
		
		//Công thức lai
		private var listFormula:ListBox;
		private var txtFoundFormula:TextField;
		
		private var labelLevel:TextField;
		private var labelSpecial:TextField;
		private var labelRare:TextField;
		private var labelCost:TextField;
		private var itemFormula:ItemFormula;
		
		private var _formulaAvailble:Boolean = false;
		private var foundFormula:Boolean = false;
		private var effUseFormula:Boolean = false;
		private var autoFormula:Boolean;
		private var effUseMaterial:Boolean = false;
		
		public function GUIMateFish(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				if (!isReceivedFish  || !isReceivedStore)
				{
					return;
				}
				GameLogic.getInstance().HideFish();
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				img.getChildByName("Eff_Father").visible = false;
				img.getChildByName("Eff_Mother").visible = false;
				AddButton(BTN_CLOSE, "BtnThoat", 735 - 76, 7 + 21, this);
				SetPos(25, 25);	
				
				effUseFormula = false;
				OpenRoomOut();
			}
			
			LoadRes("GuiMateFish_Theme");
		}
		
		
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			
			//Tạo danh sách kĩ năng lai cá
			var userSkill:Object = GameLogic.getInstance().user.GetMyInfo().Skill;
			listBoxSkill = new ListBox(ListBox.LIST_X, 1, 4, 0);
			var sortSkill:Array = new Array();
			var obj:Object = new Object();
			obj = userSkill[ItemSkill.SKILL_MONEY];
			obj["typeSkill"] = ItemSkill.SKILL_MONEY;
			sortSkill.push(obj);
			obj = userSkill[ItemSkill.SKILL_LEVEL];
			obj["typeSkill"] = ItemSkill.SKILL_LEVEL;
			sortSkill.push(obj);
			obj = userSkill[ItemSkill.SKILL_SPECIAL];
			obj["typeSkill"] = ItemSkill.SKILL_SPECIAL;
			sortSkill.push(obj);
			obj = userSkill[ItemSkill.SKILL_RARE];
			obj["typeSkill"] = ItemSkill.SKILL_RARE;
			sortSkill.push(obj);
			var check:Boolean = false;
			for (var h:int = 0; h < sortSkill.length; h++)
			{
				var itemSkill:ItemSkill = new ItemSkill(listBoxSkill, "");
				itemSkill.initItemSkill(sortSkill[h]["typeSkill"], sortSkill[h]["Level"], sortSkill[h]["Mastery"]);
				listBoxSkill.addItem(CTN_SKILL + sortSkill[h]["typeSkill"], itemSkill, this);
				if (itemSkill.canUse())
				{
					check = true;
				}
			}
			listBoxSkill.x = 213 + 42;
			listBoxSkill.y = 87 + 15;
			this.img.addChild(listBoxSkill);
			if (!check)
			{
				listBoxSkill.img.visible = false;
			}
			
			//Năng lượng		
			curEnergy = GameLogic.getInstance().user.GetEnergy();
			maxEnergy = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel(true));
			prgCurEnergy = AddProgress("", "GuiMateFish_Bar_Estimate_Energy", 288, 79);
			prgEnergy = AddProgress("", "GuiMateFish_Bar_Energy", 288, 79);
			prgCurEnergy.setStatus(curEnergy / maxEnergy);
			prgEnergy.setStatus(curEnergy / maxEnergy);
			txtEnergy = AddLabel(Ultility.StandardNumber(curEnergy) + " / " + Ultility.StandardNumber(maxEnergy), prgEnergy.x + 30, prgEnergy.y - 2, 0, 1, 0x000000);
			var format:TextFormat = new TextFormat();
			format.size = 14;
			format.color = 0xffffff;
			format.bold = true;
			txtEnergy.setTextFormat(format);
			txtEnergy.defaultTextFormat = format;
			btnFillEnergy = AddButton(BTN_PAY_FULL, "GuiMateFish_Btn_Fill_Energy", 438, 77, this);
			//btnFillEnergy.img.height = 28;
			//btnFillEnergy.img.width = 73;
			btnFillEnergy.SetEnable();
			
			//Thuốc vui vẻ
			AddImage("", "GuiMateFish_Item_Viagra_Bg", 549 + 10, 124);
			btnBuyViagra = AddButton(BTN_BUY_VIAGRA, "GuiMateFish_Btn_Buy_Viagra", 520 + 10, 169, this);
			var costViagraTxt:TextField = AddLabel("", 488 + 10, 168, 0xffffff, 1);
			var config:Object = ConfigJSON.getInstance().GetItemList("Viagra");
			costViagraTxt.text = config["1"]["ZMoney"];
			//btnBuyViagra.img.height = 25;
			//btnBuyViagra.img.width = 70;
			
			var tip:TooltipFormat = new TooltipFormat();
			tip.text =Localization.getInstance().getString("TooltipViagra1");
			var fmt:TextFormat = new TextFormat();
			fmt.color = 0xff0000;
			tip.setTextFormat(fmt);
			ctnViagra = AddContainer(CTN_VIAGRA, "GuiMateFish_CtnViagra1", 519 + 10, 86, true, this);
			ctnViagra.setTooltip(tip);
			ctnViagra.img.buttonMode = true;
			
			textFieldViagra = AddLabel("-1",524 + 10, 151, 0xffffff, 1, 0x26709C);
			var arr:Array = GameLogic.getInstance().user.StockThingsArr.Viagra;
			if(arr && arr.length != 0)
			{
				numViagra = arr[0]["Num"];
			}
			else
			{
				numViagra = 0;
			}
			
			//Nguyên liệu
			AddButton(BTN_BUY_MATERIAL, "GuiMateFish_Btn_Buy_Material", 171, 521, this);
			AddButton(BTN_BACK_MATER_LIST, "GuiMateFish_Btn_Previous", 213 - 98, 495 + 35, this);
			AddButton(BTN_NEXT_MATER_LIST, "GuiMateFish_Btn_Next", 632,528, this);
			listMaterial = AddListBox(ListBox.LIST_X, 1, 6, 5, 50);
			listMaterial.setPos(225, 510);
			img.addChild(listMaterial);
			updateListMaterial();
			
			//Danh sách slot ngư thạch
			listUsedMaterial = AddListBox(ListBox.LIST_X, 1, 6, 18, 50);
			listUsedMaterial.removeAllItem();
			numSlotMaterial = GameLogic.getInstance().user.GetMyInfo().SlotUnlock;
			for (var j:int = 0; j < MAX_SLOT_MATERIAL; j++)
			{
				var itemUsedMaterial:ItemSlot = new ItemSlot(listUsedMaterial);
				itemUsedMaterial.index = j + 1;
				if (j >= numSlotMaterial)
				{
					itemUsedMaterial.id = -1;
					
				}
				listUsedMaterial.addItem(CTN_USED_MATERIAL + j, itemUsedMaterial, this);
			}
			listUsedMaterial.setPos(200 - 14, 400 + 24);
			
			//Danh sach ca dem lai
			initMateFish();
			
			//Các chỉ số lai
			labelLevel = AddLabel("Vượt cấp", 183.65, 402.05, 0x5ec53f);
			format = new TextFormat("arial", 18, 0x5ec53f);
			labelLevel.defaultTextFormat = format;
			labelLevel.setTextFormat(format);
			labelSpecial = AddLabel("Đặc biệt", 297, 402.05, 0x00adee);
			format = new TextFormat("arial", 18, 0x00adee);
			labelSpecial.defaultTextFormat = format;
			labelSpecial.setTextFormat(format);
			labelRare = AddLabel("Quý", 395.5, 403.05, 0xf05a28);
			format = new TextFormat("arial", 18, 0xf05a28);
			labelRare.defaultTextFormat = format;
			labelRare.setTextFormat(format);
			
			txtPrice = AddLabel("0", 480, 397, 0, 1, 0);
			format = new TextFormat("arial", 20, 0xffff00, true);
			format.align = "center";
			txtPrice.setTextFormat(format);
			txtPrice.defaultTextFormat = format;	
			txtLevel = AddLabel("", 218, 377, 0, 0, 0x000000);
			txtSpecial = AddLabel("", 313 - 20, 377, 0, 1, 0x000000);
			txtRare = AddLabel("", 424 - 30, 377, 0, 1, 0x000000);
			format.size = 18;
			format.color = 0xffffff;
			txtLevel.defaultTextFormat = format;
			txtSpecial.defaultTextFormat = format;
			txtRare.defaultTextFormat = format;	
			
			txtWarning = AddLabel(Localization.getInstance().getString("Message25"), 335, 174, 0xffff00, 1, 0xff0000);
			format.size = 17;
			txtWarning.setTextFormat(format);
			txtWarning.visible = false;
			
			//Bí kíp lai cá
			AddImage("", "GuiMateFish_Item_Viagra_Bg", 30 + 183, 124);
			itemFormula = new ItemFormula(this.img);
			itemFormula.IdObject = CTN_USED_FORMULA;
			itemFormula.EventHandler = this;
			itemFormula.SetPos(185, 120);
			formulaAvailble = false;
			AddLabel("Công thức\ncá lính", 50 + 110, 164, 0xffffff, 1, 0x000000).setTextFormat(new TextFormat("arial", 11, 0xffffff, true, null, null, null, null, "center"));
			
			/*listFormula = AddListBox(ListBox.LIST_X, 1, 1);
			listFormula.setPos(50 + 173 - 41, 124 - 28);
			var backBtn:Button = AddButton(BTN_BACK_FORMULA_LIST, "Btn_Previous", 173, 96 + 26, this);
			backBtn.img.scaleX = backBtn.img.scaleY = 0.6;
			var nextBtn:Button = AddButton(BTN_NEXT_FORMULA_LIST, "Btn_Next", 236, 96 + 26, this);
			nextBtn.img.scaleX = nextBtn.img.scaleY = 0.6;*/
			
			/*updateStateNextPreList(listFormula, nextBtn, backBtn);
			listFormula.visible = false;
			backBtn.SetVisible(false);
			nextBtn.SetVisible(false);*/
			txtFoundFormula = AddLabel("Phát hiện công thức lai", 335, 174, 0xffff00, 1, 0xff0000);
			txtFoundFormula.setTextFormat(format);
			txtFoundFormula.visible = false;
			
			updateButton();
			
			buffMoney = 0;
			buffLevel = 0;
			buffSpecial = 0;
			buffRare = 0;
			isMating = false;
			autoFormula = true;
			
			//Quest
			imageHelper = AddImage("", "IcHelper", 120, 185);
			questName = QuestMgr.getInstance().GetCurTutorial().split("//");
			if (questName != null && questName[0] == "MixTool")
			{
				questStatus = QUEST_CHOOSE_BOY;
			}
			updateHelper();
		}
		
		public function updateListMaterial(priorityFormula:Array = null):void 
		{
			listMaterial.removeAllItem();
			if (priorityFormula == null || priorityFormula.length == 0)
			{
				initMaterial();
				initFormula();
			}
			else
			{
				initFormula();
				initMaterial();
				for (var j:int = 0; j < priorityFormula.length; j++)
				{
					var temp:ItemFormula = listMaterial.getItemById(priorityFormula[j]) as ItemFormula;
					var newItem:ItemFormula = new ItemFormula(listMaterial.img);
					newItem.initFormula(temp.itemType, temp.itemId, temp.num);
					newItem.canUse = true;
					newItem.SetHighLight(0xff0000);
					
					listMaterial.removeItem(priorityFormula[j]);
					listMaterial.addItemAt(temp.IdObject, newItem, 0, this);
				}
			}
			updateStateNextPreList(listMaterial, GetButton(BTN_NEXT_MATER_LIST), GetButton(BTN_BACK_MATER_LIST));
		}
		
		private function initMaterial():void
		{
			//Sắp xếp mảng nguyên liệu
				var materials:Array = GameLogic.getInstance().user.StockThingsArr.Material;
				for (var t:int = 0; t < materials.length; t++)
				{
					for (var n:int = materials.length -1; n > t; n--)
					{
						if ((materials[n]["Id"] % 100 < materials[t]["Id"] % 100) || (materials[n]["Id"] % 100 == materials[t]["Id"] % 100 && int(materials[n]["Id"]) < int(materials[t]["Id"])))
						{
							var temp:Object = materials[t];
							materials[t] = materials[n];
							materials[n] = temp;
						}
					}
				}
				for (var i:int = materials.length -1; i >= 0; i--)
				{
					if (materials[i]["Num"] > 0)
					{
						var itemMaterial:ItemMaterial = new ItemMaterial(listMaterial);
						itemMaterial.initItemMaterial(materials[i]["Id"], materials[i]["Num"]);
						listMaterial.addItem(CTN_MATERIAL + materials[i]["Id"], itemMaterial, this);
					}
				}
		}
		
		private function initFormula():void
		{
			//Mảng giấy phép
			var formula:Array = GameLogic.getInstance().user.StockThingsArr.Draft;
			formula = formula.concat(GameLogic.getInstance().user.StockThingsArr.GoatSkin);
			formula = formula.concat(GameLogic.getInstance().user.StockThingsArr.Paper);
			formula = formula.concat(GameLogic.getInstance().user.StockThingsArr.Blessing);
			for (var i:int = 0; i < formula.length; i++)
			{
				var itemDraft:ItemFormula = new ItemFormula(listMaterial.img);
				itemDraft.initFormula(formula[i]["ItemType"], formula[i]["Id"], formula[i]["Num"]);
				listMaterial.addItem(CTN_FORMULA + "_" + itemDraft.itemType + "_" + itemDraft.itemId, itemDraft, this);
			}
		}
		
		private function updateButton():void 
		{
			updateStateNextPreList(listBoy, GetButton(BTN_NEXT_BOY_LIST), GetButton(BTN_BACK_BOY_LIST));
			updateStateNextPreList(listGirl, GetButton(BTN_NEXT_GIRL_LIST), GetButton(BTN_BACK_GIRL_LIST));
			updateStateNextPreList(listMaterial, GetButton(BTN_NEXT_MATER_LIST), GetButton(BTN_BACK_MATER_LIST));
			//updateStateNextPreList(listResult, GetButton(BTN_NEXT_RESULT_LIST), GetButton(BTN_BACK_RESULT_LIST));
		}
		
		private function initMateFish():void
		{
			//Danh sách cá đực
			listBoy = AddListBox(ListBox.LIST_Y, 2, 1, 10, 40);
			listBoy.setPos(5, 163);
			//Danh sách cá cái
			listGirl = AddListBox(ListBox.LIST_Y, 2, 1, 10, 40);
			listGirl.setPos(615, 163);
			//Danh sách kết quả lai
			listResult = AddListBox(ListBox.LIST_X, 1, 1, 10, 10, true);
			listResult.setPos(306, 200);
			AddButton(BTN_MATE, "GuiMateFish_Btn_Mate", 336, 323, this).SetEnable(false);
			AddImage(IMAGE_EFF_COLOR, "GuiMateFish_Eff_Color", 336 + 50, 323 + 21);
			AddImage(IMAGE_EFF_LIGHT, "GuiMateFish_Eff_Light", 336 + 50 + 26, 322);
			GetImage(IMAGE_EFF_COLOR).img.visible = false;
			GetImage(IMAGE_EFF_LIGHT).img.visible = false;
			AddButton(BTN_BACK_BOY_LIST, "GuiMateFish_Btn_Up", 68, 133, this).SetEnable(false);
			AddButton(BTN_NEXT_BOY_LIST, "GuiMateFish_Btn_Down", 68, 431, this).SetEnable(false);
			AddButton(BTN_BACK_GIRL_LIST, "GuiMateFish_Btn_Up", 673, 128, this).SetEnable(false);
			AddButton(BTN_NEXT_GIRL_LIST, "GuiMateFish_Btn_Down", 673, 427, this).SetEnable(false);
			//AddButton(BTN_BACK_RESULT_LIST, "GuiMateFish_Btn_Previous", 565 - 270, 288 + 48, this).SetEnable(false);
			//AddButton(BTN_NEXT_RESULT_LIST, "GuiMateFish_Btn_Next", 718 - 270, 288 + 48, this).SetEnable(false);
			
			var arrFish:Array = GameLogic.getInstance().user.AllFishArr;
			boyArr = new Array();
			girlArr = new Array();
			var i:int;
			for (i = 0; i < arrFish.length; i++)
			{
				if (arrFish[i]["FishType"] != Fish.FISHTYPE_SOLDIER)
				{
					var imgName:String = Fish.ItemType + arrFish[i].FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE;
					var f:Fish = new Fish(this.img, imgName);
					f.SetInfo(arrFish[i]);
					f.Init(0, 0);									
					// Check again
					var growth:Number = f.Growth();
					if (growth < 0 || f.IsEgg)
					{
						f.SetAgeState(Fish.EGG);
					}
					else if (growth < 0.5)
					{
						f.SetAgeState(Fish.BABY);
					}
					else
					{
						f.SetAgeState(Fish.OLD);
					}
					f.RefreshEmotion();
					f.RefreshImg();
					f.Hide();
					updateHavertTime(f);
					if (f.Sex == 1)
					{
						boyArr.push(f);					
					}
					else
					{
						girlArr.push(f);
					}	
				}
			}
			
			//boyArr = SortFishList(boyArr, true);
			//girlArr = SortFishList(girlArr, true);
			listBoy.removeAllItem();
			var fish:Fish;
			for (i = 0; i < boyArr.length; i++)
			{
				fish = boyArr[i] as Fish;
				var itemBoy:ItemFish = new ItemFish(listBoy);
				itemBoy.initItemFish(fish);
				listBoy.addItem(CTN_BOY + fish.Id, itemBoy, this);
			}
			sortListFish(listBoy);
			
			listGirl.removeAllItem();
			for (i = 0; i < girlArr.length; i++)
			{
				fish = girlArr[i] as Fish;
				var itemGirl:ItemFish = new ItemFish(listGirl);
				itemGirl.initItemFish(fish);
				listGirl.addItem(CTN_GIRL + fish.Id, itemGirl, this);
			}
			sortListFish(listGirl);
			
			//Add item cá bố, cá mẹ
			itemFather = new ItemFish(this.img);
			itemFather.IdObject = CTN_BOY + itemFather.id;
			itemFather.EventHandler = this;
			itemFather.SetPos(168, 246);
			itemMother = new ItemFish(this.img);
			itemMother.IdObject = CTN_GIRL + itemMother.id;
			itemMother.EventHandler = this;
			itemMother.SetPos(460, 246);
			
			//Số lượng cá đực, cái
			txtNumGirl = AddLabel("", 650, 81, 0xFFFFFF, 1, 0xffffff);
			txtNumBoy = AddLabel("", 55, 81, 0xFFFFFF, 1, 0xffffff);
			var txtFormat:TextFormat = new TextFormat("arial", 24, 0x4993e6, 1);
			txtNumBoy.defaultTextFormat = txtFormat;
			txtFormat.color = 0xbc1580;
			txtNumGirl.defaultTextFormat = txtFormat;
			numBoy = boyArr.length;
			numGirl = girlArr.length;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					if(!isMating)
					{
						Hide();
					}
					break;
				case BTN_MATE:
					//GuiMgr.getInstance().guiMateFish.upgradeSkill("MoneySkill");
					if (!effUseFormula)
					{
						if (foundFormula && !formulaAvailble)
						{
							GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(Localization.getInstance().getString("Message34"));
						}
						else
						{
							mateFish();
						}
					}
					break;
				case BTN_PAY_FULL:
					fillFullEnergy();
					break;
				case BTN_BUY_VIAGRA:
					buyViagra();
					break;
				case CTN_VIAGRA:
					if (numViagra > 0)
					{
						if (GameLogic.getInstance().gameState != GameState.GAMESTATE_RESET_MATE_FISH)
						{
							GameLogic.getInstance().SetState(GameState.GAMESTATE_RESET_MATE_FISH);
							GameLogic.getInstance().MouseTransform("Viagra1",  1, -45, 10, 0);
							ctnViagra.SetHighLight(0xffffff);
						}
						else
						{
							ctnViagra.SetHighLight( -1);
							GameLogic.getInstance().MouseTransform("");
							GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
						}
					}
					break;
				case BTN_BUY_MATERIAL:
					Hide();
					GuiMgr.getInstance().GuiShop.CurrentShop = "Special";
					GuiMgr.getInstance().GuiShop.curPage = 2;
					GameController.getInstance().UseTool("Shop");
					break;
				case BTN_BACK_MATER_LIST:
					listMaterial.showPrePage();
					GetButton(BTN_NEXT_MATER_LIST).SetEnable(true);
					if (listMaterial.curPage == 0)
					{
						GetButton(BTN_BACK_MATER_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_BACK_MATER_LIST).SetEnable(true);
					}
					break;
				
				case BTN_NEXT_MATER_LIST:
					listMaterial.showNextPage();
					GetButton(BTN_BACK_MATER_LIST).SetEnable(true);
					if (listMaterial.curPage == listMaterial.getNumPage() - 1)
					{
						GetButton(BTN_NEXT_MATER_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_NEXT_MATER_LIST).SetEnable(true);
					}
					break;
				case BTN_BACK_BOY_LIST:
					listBoy.showPrePage();
					GetButton(BTN_NEXT_BOY_LIST).SetEnable(true);
					if (listBoy.curPage == 0)
					{
						GetButton(BTN_BACK_BOY_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_BACK_BOY_LIST).SetEnable(true);
					}
					break;
				case BTN_NEXT_BOY_LIST:
					listBoy.showNextPage();
					GetButton(BTN_BACK_BOY_LIST).SetEnable(true);
					if (listBoy.curPage == listBoy.getNumPage() - 1)
					{
						GetButton(BTN_NEXT_BOY_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_NEXT_BOY_LIST).SetEnable(true);
					}
					break;
				case BTN_BACK_GIRL_LIST:
					listGirl.showPrePage();
					GetButton(BTN_NEXT_GIRL_LIST).SetEnable(true);
					if (listGirl.curPage == 0)
					{
						GetButton(BTN_BACK_GIRL_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_BACK_GIRL_LIST).SetEnable(true);
					}
					break;
				case BTN_NEXT_GIRL_LIST:
					listGirl.showNextPage();
					GetButton(BTN_BACK_GIRL_LIST).SetEnable(true);
					if (listGirl.curPage == listGirl.getNumPage() - 1)
					{
						GetButton(BTN_NEXT_GIRL_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_NEXT_GIRL_LIST).SetEnable(true);
					}
					break;
				case BTN_BACK_FORMULA_LIST:
					listFormula.showPrePage();
					GetButton(BTN_NEXT_FORMULA_LIST).SetEnable(true);
					if (listFormula.curPage == 0)
					{
						GetButton(BTN_BACK_FORMULA_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_BACK_FORMULA_LIST).SetEnable(true);
					}
					break;
				case BTN_NEXT_FORMULA_LIST:
					listFormula.showNextPage();
					GetButton(BTN_BACK_FORMULA_LIST).SetEnable(true);
					if (listFormula.curPage == listFormula.getNumPage() - 1)
					{
						GetButton(BTN_NEXT_FORMULA_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_NEXT_FORMULA_LIST).SetEnable(true);
					}
					break;
				/*case BTN_BACK_RESULT_LIST:	
					listResult.showPrePage();
					GetButton(BTN_NEXT_RESULT_LIST).SetEnable(true);
					if (listResult.curPage == 0)
					{
						GetButton(BTN_BACK_RESULT_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_BACK_RESULT_LIST).SetEnable(true);
					}
					break;
				
				case BTN_NEXT_RESULT_LIST:
					listResult.showNextPage();
					GetButton(BTN_BACK_RESULT_LIST).SetEnable(true);
					if (listResult.curPage == listResult.getNumPage() - 1)
					{
						GetButton(BTN_NEXT_RESULT_LIST).SetEnable(false);
					}
					else
					{
						GetButton(BTN_NEXT_RESULT_LIST).SetEnable(true);
					}
					break;*/
				case CTN_USED_FORMULA:
					//trace("remove formula");
					removeFormula();
					break;
				default:
					//Sử dụng kĩ năng lai cá
					if (buttonID.search(CTN_SKILL) >= 0)
					{
						var itemSkill:ItemSkill = listBoxSkill.getItemById(buttonID) as ItemSkill;
						useSkill(itemSkill);
					}
					//Sử dụng ngư thạch
					else if (buttonID.search(CTN_MATERIAL) >= 0)
					{
						if(int(buttonID.split(CTN_MATERIAL)[1]) % 100 <= 10)
						{
							var itemMaterial:ItemMaterial = listMaterial.getItemById(buttonID) as ItemMaterial;
							useMaterial(itemMaterial);
						}
						else
						{
							var posStart:Point;
							var posEnd:Point;
							posStart = GameInput.getInstance().MousePos;
							posEnd = new Point(posStart.x, posStart.y - 100);
							var txtFormat1:TextFormat = new TextFormat(null, 14, 0xFFFF00);
							txtFormat1.align = "center";
							txtFormat1.bold = true;
							txtFormat1.font = "Arial";
							var str:String = "Không thể dùng\nngư thạch này\nđể lai cá được";
							Ultility.ShowEffText(str, img, posStart, posEnd, txtFormat1, 1, 0x000000);
						}
					}
					//Loại bỏ ngư thạch đã add
					else if (buttonID.search(CTN_USED_MATERIAL) >= 0)
					{
						var usedMaterialItem:ItemSlot = listUsedMaterial.getItemById(buttonID) as ItemSlot;
						if(usedMaterialItem.id > 0)
						{
							removeMaterial(usedMaterialItem);
						}
						else if(usedMaterialItem.canUnlock())
						{
							GuiMgr.getInstance().GuiMessageBox.ShowBuySlotMaterial(numSlotMaterial+1, GUIMessageBox.NPC_MERMAID_NORMAL);
						}
					}
					//Click cá bố
					else if (buttonID.search(CTN_BOY) >= 0)
					{
						if (!isMating)
						{
							var itemBoy:ItemFish = listBoy.getItemById(buttonID) as ItemFish;
							
							if (GameLogic.getInstance().gameState == GameState.GAMESTATE_RESET_MATE_FISH)
							{
								//Dùng thuốc cho cá trong list
								if(itemBoy != null)
								{
									useViagra(itemBoy);
								}
								//Dùng thuốc cho cá bố
								else
								{
									useViagra(itemFather);
									calculate();
								}
							}
							else if(itemBoy != null && itemBoy.id != itemFather.id)
							{
								chooseFish(itemBoy);
							}
						}
					}
					//Cllick cá mẹ
					else if (buttonID.search(CTN_GIRL) >= 0)
					{
						if (!isMating)
						{
							var itemGirl:ItemFish = listGirl.getItemById(buttonID) as ItemFish;
							if (GameLogic.getInstance().gameState == GameState.GAMESTATE_RESET_MATE_FISH)
							{
								//Dùng thuốc cho cá trong list
								if(itemGirl != null)
								{
									useViagra(itemGirl);
								}
								//Dùng thuốc cho cá mẹ
								else
								{
									useViagra(itemMother);
									calculate();
								}
							}
							else if(itemGirl != null && itemGirl.id != itemMother.id)
							{
								chooseFish(itemGirl);
							}
						}
					}
					else if (buttonID.search(CTN_FORMULA) >= 0)
					{
						//trace("use formula");
						var itemFormula:ItemFormula = listMaterial.getItemById(buttonID) as ItemFormula;
						useFormula(itemFormula);
					}
			}
		}
		
		private function buyViagra():void 
		{
			var config:Object = ConfigJSON.getInstance().GetItemList("Viagra");
			trace("buyViagra()== " + buyViagra());
			if (GameLogic.getInstance().user.GetZMoney() >= config["1"]["ZMoney"])
			{
				var testBuy:SendBuyOther = new SendBuyOther();
				testBuy.AddNew("Viagra", 1, 1, "ZMoney");
				Exchange.GetInstance().Send(testBuy);
				numViagra++;
				// update vào kho
				GuiMgr.getInstance().GuiStore.UpdateStore("Viagra", 1, 1);
				GameLogic.getInstance().user.UpdateUserZMoney(-config["1"]["ZMoney"]);
				EffectMgr.setEffBounceDown("Mua thành công", "Viagra1", 335, 300);
			}
			else
			{
				GuiMgr.getInstance().GuiNapG.Init();
			}
		}
		
		private function useViagra(itemFish:ItemFish):void 
		{
			if (itemFish.statusMate == ItemFish.ALREADY)
			{
				var config:Object = ConfigJSON.getInstance().getItemInfo("Param", -1);
				GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + config["UseViagra"]);
				
				itemFish.statusMate = ItemFish.PASS_VIAGRA;
				var fish:Fish = getFish(itemFish.id, itemFish.sex);
				GameLogic.getInstance().UseViagra(fish, true);
				
				numViagra--;
				if (numViagra <= 0)
				{
					ctnViagra.SetHighLight( -1);
					GameLogic.getInstance().MouseTransform("");
					GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
				}
				
				fish.ViagraUsed = 1;
				fish.LastTimeViagra = GameLogic.getInstance().CurServerTime;
				fish.LastBirthTime = 0;
				
				// effect khi dung Viagra
				var posFish:Point;
				if (mother != null && fish.Id == mother.Id)
				{
					mother.ViagraUsed = 1;
					mother.LastTimeViagra = GameLogic.getInstance().CurServerTime;
					mother.LastBirthTime = 0;
					posFish = itemFish.Parent.localToGlobal(itemFish.CurPos);
				}
				else if(father != null && fish.Id == father.Id)
				{
					father.ViagraUsed = 1;
					father.LastTimeViagra = GameLogic.getInstance().CurServerTime;
					father.LastBirthTime = 0;
					posFish = itemFish.Parent.localToGlobal(itemFish.CurPos);
				}
				else
				{
					if (fish.Sex == 1)
					{
						itemFish = listBoy.getItemById(itemFish.IdObject) as ItemFish;
						posFish = listBoy.img.localToGlobal(itemFish.CurPos);
					}
					else
					{
						itemFish = listGirl.getItemById(itemFish.IdObject) as ItemFish;
						posFish = listGirl.img.localToGlobal(itemFish.CurPos);
					}
				}
				
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffHappy", null, posFish.x + 70, posFish.y, false, false, null);
			}
		}
		
		/**
		 * Đổ đầy năng lượng
		 */
		private function fillFullEnergy():void 
		{	
			var objGeneral:Object = ConfigJSON.getInstance().GetItemList("Param"); //GetItemInfo("General", user.GetMyInfo().NumFill);
			var obj:Object = objGeneral.FillEnergy;
			var toolTip:TooltipFormat = new TooltipFormat();
			var datLast:Date = new Date(GameLogic.getInstance().user.GetMyInfo().LastFillEnergy * 1000);
			var datCur:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			if (datLast.getDate() != datCur.getDate() || (datLast.getDate() == datCur.getDate() && datCur.getMonth() != datLast.getMonth()))
			{
				GameLogic.getInstance().user.GetMyInfo().NumFill = 1;
			}
			if (GameLogic.getInstance().user.GetMyInfo().NumFill <= GuiMgr.getInstance().GuiFillEnergy.MAX_FILL_A_DAY 
				&& GameLogic.getInstance().user.GetEnergy() < ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel(true)))
			{
				GuiMgr.getInstance().GuiFillEnergy.Show(Constant.GUI_MIN_LAYER, 3);
			}
			else 
			{
				if (GameLogic.getInstance().user.GetMyInfo().NumFill > GuiMgr.getInstance().GuiFillEnergy.MAX_FILL_A_DAY)
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn đã nạp hết số lần trong ngày");
				}
				else 
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK("Bạn vẫn còn đầy năng lượng mà");
				}
			}
			
		}
		
		public function mateFish():void 
		{	
			autoFormula = true;
			isMating = true;
			imageHelper.img.visible = false;
			questStatus = 0;
			questName = new Array();
			//listResult.img.visible = false;
			var fishList:Array = [];
			var obj:Object = new Object();
			obj["Id"] = father.Id;
			obj["LakeId"] = father.LakeId;
			fishList.push(obj);			
			obj = new Object();
			obj["Id"] = mother.Id;
			obj["LakeId"] = mother.LakeId;
			fishList.push(obj);
			
			var materialList:Array = [];
			for each(var usedMaterial:ItemSlot in listUsedMaterial.itemList)
			{
				if (usedMaterial.id > 0)
				{
					obj = new Object;
					obj["TypeId"] = usedMaterial.id;
					obj["Num"] = 1;
					materialList.push(obj);
					//Cập nhật nguyên liệu
					GameLogic.getInstance().user.UpdateStockThing("Material", usedMaterial.id, -1);
					usedMaterial.id = 0;
				}
			}
			
			var cmd:SendMateFish = new SendMateFish();
			if (!formulaAvailble)
			{
				var skillName:String;
				var selectedSkill:ItemSkill = getUsedSkill();
				if (selectedSkill != null)
				{
					skillName = selectedSkill.typeSkill;
				}
				cmd.AddNew(fishList, materialList, skillName);
			}
			else
			{
				cmd.AddNew(fishList);
				cmd.setMixFormula(itemFormula.itemType, itemFormula.itemId);
			}
			Exchange.GetInstance().Send(cmd);
			
			//Effect
			var fromP:Point;// = new Point(itemMother.img.x + itemMother.img.width / 2 + 20, itemMother.img.y + itemMother.img.height / 2 + 20);
			var toP:Point;// = new Point(listResult.x + 104, listResult.y + 63);
			
			if (percentLevel + buffLevel != 0)
			{
				fromP = new Point(txtLevel.x, txtLevel.y);
				toP = new Point(listResult.x + 104 - 48, listResult.y + 63 + 60);
				particalStar(fromP, toP, new ColorTransform(0, 0, 0, 1, 100, 255, 100, 0), null, null, 0.8, false, 2, 2);
			}
			
			if (percentSpecial + buffSpecial != 0)
			{
				fromP = new Point(txtSpecial.x, txtSpecial.y);
				toP = new Point(listResult.x + 104 - 40, listResult.y + 63 + 60);
				particalStar(fromP, toP, new ColorTransform(0, 0, 0, 1, 50, 255, 255, 0), null, null, 0.8, false, 2, 2);
			}
			
			if (percentRare + buffRare != 0)
			{
				fromP = new Point(txtRare.x, txtRare.y);
				toP = new Point(listResult.x + 104 + 40, listResult.y + 63 + 60);
				particalStar(fromP, toP, new ColorTransform(0, 0, 0, 1, 255, 33, 255, 0), null, null, 0.8, false, 2, 2);
			}
			
			fromP = new Point(txtPrice.x, txtPrice.y);
			toP = new Point(listResult.x + 104 + 48, listResult.y + 63 + 60);
			particalStar(fromP, toP, new ColorTransform(0, 0, 0, 1, 255, 100, 100, 0), null, null, 0.8, false, 2, 2);
			
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiMateFish_Eff_Mate", null, 357 + 52, 329 - 40);
			
			img.getChildByName("Eff_Father").visible = false;
			img.getChildByName("Eff_Mother").visible = false;
			GetImage(IMAGE_EFF_COLOR).img.visible = false;
			
			//Cập cá trong hồ
			var fish:Fish = GameLogic.getInstance().GetFishCurLake(father.Id);
			if (fish)
			{
				fish.LastBirthTime = GameLogic.getInstance().CurServerTime;
				if (formulaAvailble)
				{
					fish.FishType = 0;
					fish.RateOption = new Object();
					fish.Material = new Array();
					fish.Emotion = Fish.IDLE;
					fish.RefreshImg();
				}
			}
			father.LastBirthTime = GameLogic.getInstance().CurServerTime;
			
			if (itemFather.statusMate == ItemFish.PASS_VIAGRA)
			{
				itemFather.statusMate = ItemFish.ALREADY_VIAGRA;
			}
			else
			{
				itemFather.statusMate = ItemFish.ALREADY;
			}
			
			fish = GameLogic.getInstance().GetFishCurLake(mother.Id);
			if (fish)
			{
				fish.LastBirthTime = GameLogic.getInstance().CurServerTime;
				if (formulaAvailble)
				{
					fish.FishType = 0;
					fish.RateOption = new Object();
					fish.Material = new Array();
					fish.Emotion = Fish.IDLE;
					fish.RefreshImg();
				}
			}
			
			mother.LastBirthTime = GameLogic.getInstance().CurServerTime;
			if (itemMother.statusMate == ItemFish.PASS_VIAGRA)
			{
				itemMother.statusMate = ItemFish.ALREADY_VIAGRA;
			}
			else
			{
				itemMother.statusMate = ItemFish.ALREADY;
			}
			
			// gán lại thời điểm sinh sản cho cá trong list tất cả các hồ
			for (var i:int = 0; i < GameLogic.getInstance().user.AllFishArr.length; i++)
			{
				obj = GameLogic.getInstance().user.AllFishArr[i];
				if(obj.Id == father.Id || obj.Id == mother.Id)
				{
					obj.LastBirthTime = GameLogic.getInstance().CurServerTime;
				}
			}	
			
			if (formulaAvailble)
			{
				GameLogic.getInstance().user.UpdateUserMoney( -itemFormula.config["MixPrice"], true);
			}
			else
			{
				GameLogic.getInstance().user.UpdateUserMoney(-Math.round(price * (1 - buffMoney)), true);
			}
			price = 0;
			buffLevel = 0;
			buffMoney = 0;
			buffSpecial = 0;
			buffRare = 0;
			percentLevel = 0;
			percentSpecial = 0;
			percentRare = 0;
			
			ctnViagra.SetHighLight( -1);
			GameLogic.getInstance().MouseTransform("");
			GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
			
			//Lai cá lính
			if (formulaAvailble)
			{
				itemFormula.num = 0;
				GuiMgr.getInstance().GuiStore.UpdateStore(itemFormula.itemType, itemFormula.itemId, -1);
				formulaAvailble = false;
				txtFoundFormula.visible = false;
				updateListMaterial();
				
				father.FishType = 0;
				father.RateOption = new Object();
				father.FishType = Fish.FISHTYPE_NORMAL;
				var fis:Object = GameLogic.getInstance().user.getFishInfo(father.Id);
				fis.FishType = Fish.FISHTYPE_NORMAL;
				
				mother.FishType = 0;
				mother.RateOption = new Object();
				mother.FishType = Fish.FISHTYPE_NORMAL;
				fis = GameLogic.getInstance().user.getFishInfo(mother.Id);
				fis.FishType = Fish.FISHTYPE_NORMAL;			
				
				itemFather.initItemFish(father);
				itemMother.initItemFish(mother);
				
				GameLogic.getInstance().user.UpdateOptionCurLake();
			}
		}
		
		public function unlockSlotMaterial(byZMoney:Boolean):void 
		{
			var itemUnlock:ItemSlot = listUsedMaterial.itemList[numSlotMaterial];
			itemUnlock.id = 0;
			numSlotMaterial++;
			GameLogic.getInstance().user.GetMyInfo().SlotUnlock++;
			
			var obj:Object = ConfigJSON.getInstance().getItemInfo("LevelUnlockSlot", numSlotMaterial);
			var gold:int = obj.Money;
			var zxu:int = obj.ZMoney;
			
			if (byZMoney)
			{
				GameLogic.getInstance().user.UpdateUserZMoney(-zxu);
			}
			else
			{
				GameLogic.getInstance().user.UpdateUserMoney( -gold);
			}
		}
		
		private function removeMaterial(usedMaterialItem:ItemSlot, useEff:Boolean = true):void 
		{
			//Effect
			var mc:Sprite = Ultility.CloneImage(usedMaterialItem.materialImage.img);
			img.addChild(mc);
			var pS:Point = img.globalToLocal(usedMaterialItem.img.localToGlobal(new Point(usedMaterialItem.materialImage.img.x, usedMaterialItem.materialImage.img.y)));
			mc.x = pS.x;
			mc.y = pS.y;
			
			var pD:Point;
			var hasItem:Boolean = false;
			var itemMaterial:ItemMaterial;
			for (var i:int = 0; i < listMaterial.itemList.length; i++)// itemMaterial in listMaterial.itemList)
			{
				if (listMaterial.itemList[i]["ClassName"] == "ItemMaterial")
				{
					itemMaterial = listMaterial.itemList[i] as ItemMaterial;
					if (itemMaterial.id == usedMaterialItem.id)
					{
						//itemMaterial.num++;
						hasItem = true;
						pD = img.globalToLocal(itemMaterial.img.localToGlobal(new Point(itemMaterial.materialImage.img.x, itemMaterial.materialImage.img.y)));
						break;
					}
				}
			}
			//Không còn ngư thạch này trong listMaterial
			if (!hasItem)
			{
				itemMaterial = new ItemMaterial(listMaterial);
				itemMaterial.initItemMaterial(usedMaterialItem.id, 1);
				listMaterial.addItem(CTN_MATERIAL +itemMaterial.id, itemMaterial, this);
				updateButton();
				pD = img.globalToLocal(itemMaterial.img.localToGlobal(new Point(itemMaterial.materialImage.img.x, itemMaterial.materialImage.img.y)));
				itemMaterial.SetVisible(false);
			}
			if(useEff)
			{
				TweenMax.to(mc, 0.3, { bezierThrough:[ { x:pD.x, y:pD.y } ], ease:Expo.easeIn, onComplete:finishRemoveMaterialEff, onCompleteParams:[mc, itemMaterial, hasItem] } );
			}
			else
			{
				finishRemoveMaterialEff(mc, itemMaterial, hasItem);
			}
			usedMaterialItem.materialImage.img.visible = false;
			usedMaterialItem.id = 0;
		}
		
		private function finishRemoveMaterialEff(mc:Sprite, itemMaterial:ItemMaterial, hasItem:Boolean):void 
		{
			if(hasItem)
			{
				itemMaterial.num ++;
			}
			else
			{
				itemMaterial.SetVisible(true);
			}
			img.removeChild(mc);
			calculate();
		}
		
		private function useMaterial(itemMaterial:ItemMaterial):void 
		{
			//Đang chạy effect dùng công thức lai
			if (effUseFormula)
			{
				return;
			}
			var usedMaterial:ItemSlot;
			var noSlot:Boolean = true;
			for each(var item:ItemSlot in listUsedMaterial.itemList)
			{
				if (item.id == 0)
				{
					usedMaterial = item;
					usedMaterial.id = itemMaterial.id;
					usedMaterial.materialImage.img.visible = false;
					noSlot = false;
					break;
				}
			}
			//Hết slot ngư thạch
			if (noSlot)
			{
				return;
			}
			
			itemMaterial.num--;
			
			//effect
			effUseMaterial = true;
			var mc:Sprite = Ultility.CloneImage(usedMaterial.materialImage.img);
			img.addChild(mc);
			var pS:Point = img.globalToLocal(itemMaterial.img.localToGlobal(new Point(itemMaterial.materialImage.img.x, itemMaterial.materialImage.img.y)));
			mc.x = pS.x;
			mc.y = pS.y;
			var pD:Point = img.globalToLocal(usedMaterial.img.localToGlobal(new Point(usedMaterial.materialImage.img.x, usedMaterial.materialImage.img.y)));
			TweenMax.to(mc, 0.3, { bezierThrough:[ { x:pD.x, y:pD.y } ], ease:Expo.easeIn, onComplete:finishUseMaterialEff, onCompleteParams:[mc, usedMaterial] } );
			
			if (itemMaterial.num == 0)
			{
				listMaterial.removeItem(itemMaterial.IdObject);
			}
		}
		
		private function finishUseMaterialEff(mc:Sprite, usedMaterial:ItemSlot):void 
		{
			img.removeChild(mc);
			if(usedMaterial.materialImage.img != null)
			{
				usedMaterial.materialImage.img.visible = true;
			}
			effUseMaterial = false;
			if (formulaAvailble)
			{
				removeFormula(false);
			}
			else
			{
				calculate();
			}
		}
		
		/**
		 * Sử dụng kĩ năng lai cá
		 * @param	itemSkill
		 */
		private function useSkill(itemSkill:ItemSkill):void
		{
			if (isMating || formulaAvailble)
			{
				return;
			}
			if (itemSkill.canUse())
			{
				//Hiện gui nạp năng lượng
				if (GameLogic.getInstance().user.GetEnergy() < itemSkill.spendEnergy)
				{
					GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 3);
				}
				//Sử dụng skill
				else
				{
					for each(var item:ItemSkill in listBoxSkill.itemList)
					{
						if (item == itemSkill)
						{
							if (!item.isSelected)
							{
								item.showEffSelected(true);
								//Eff sao bay
								startParticleUseSkill(itemSkill);
								item.isSelected = true;
								
								// effect trừ năng lượng
								var txtFormat:TextFormat = new TextFormat("Arial", 14, 0xffffff, true);
								var tmp:Sprite = Ultility.createSpriteFromText("-" + item.spendEnergy.toString(), txtFormat);
								var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
								eff.SetInfo(489, 83, 405, 83, 7);
								
								var remainEnergy:Number = curEnergy - item.spendEnergy;
								txtEnergy.text = Ultility.StandardNumber(remainEnergy) + " / " + Ultility.StandardNumber(maxEnergy);
								prgEnergy.setStatus(remainEnergy / maxEnergy);
							}
						}
						else
						{
							if(item.canUse())
							{
								item.showEffSelected(false);
							}
							item.isSelected = false;
						}
					}
					
					if (questName != null && questName[0] != null && questName[0] == "MixTool" && questName[1] != null && itemMother.canMate() && itemFather.canMate())
					{
						if (questName[1] == itemSkill.typeSkill)
						{
							questStatus = QUEST_MATE;
						}
						else
						{
							switch(questName[1])
							{
								case ItemSkill.SKILL_MONEY:
									questStatus = QUEST_SKILL_MONEY;
									break;
								case ItemSkill.SKILL_LEVEL:
									questStatus = QUEST_SKILL_LEVEL;
									break;
								case ItemSkill.SKILL_SPECIAL:
									questStatus = QUEST_SKILL_SPECIAL;
									break;
								case ItemSkill.SKILL_RARE:
									questStatus = QUEST_SKILL_RARE;
									break;
								default:
									questStatus = QUEST_MATE;
							}
						}
						updateHelper();
					}
				}
			}
		}
		
		/**
		 * Hàm chọn cá để lai,
		 * @param	itemFish đối tượng được chọn
		 */
		private function chooseFish(itemFish:ItemFish):void
		{
			if (isMating)
			{
				return;
			}
			autoFormula = true;
			switch (itemFish.statusMate)
			{
				case ItemFish.HUNGRY:
				case ItemFish.BABY:
				case ItemFish.ALREADY:
				case ItemFish.NOT_EXIST:
				case ItemFish.ALREADY_VIAGRA:
					return;
				case ItemFish.PASS:
				case ItemFish.PASS_VIAGRA:
					var mc:Sprite;
					var pS:Point;
					var pD:Point;
					if (itemFish.sex == 0)
					{
						//Effect chọn cá
						//mc = Ultility.CloneImage(itemFish.ImageArr[0].img);
						//img.addChild(mc);
						pS = img.globalToLocal(listGirl.img.localToGlobal(new Point(itemFish.img.x + itemFish.img.width/2 + 20, itemFish.img.y + itemFish.img.height/2 + 20)));
						//mc.x = pS.x;
						//mc.y = pS.y;
						pD = new Point(itemMother.img.x + itemMother.img.width/2 + 20, itemMother.img.y + itemMother.img.height/2 + 20);
						//var med:Point = getThroughPoint(pS, pD);
						//TweenMax.to(mc, 0.3, { bezierThrough:[ { x:med.x, y:med.y }, { x:pD.x, y:pD.y } ], ease:Expo.easeIn, onComplete:finishChooseFish, onCompleteParams:[mc] } );
						particalStar(pS, pD, new ColorTransform(0, 0, 0, 1, 153, 255, 255, 0), completeChooseFish, itemFish, 0.3);
						
						itemMother.SetVisible(false);
						
						//Có quest lai cá
						if (questName != null && questName[0] == "MixTool")
						{
							//Lai cá dùng kĩ năng
							if (questName[1] != null)
							{
								//Đã chọn cá bố
								if (itemFather.canMate())
								{
									//Đã chọn đúng kĩ năng
									if (getUsedSkill() != null && getUsedSkill().typeSkill == questName[1])
									{
										questStatus = QUEST_MATE;
									}
									else
									{
										switch(questName[1])
										{
											case ItemSkill.SKILL_MONEY:
												questStatus = QUEST_SKILL_MONEY;
												break;
											case ItemSkill.SKILL_LEVEL:
												questStatus = QUEST_SKILL_LEVEL;
												break;
											case ItemSkill.SKILL_SPECIAL:
												questStatus = QUEST_SKILL_SPECIAL;
												break;
											case ItemSkill.SKILL_RARE:
												questStatus = QUEST_SKILL_RARE;
												break;
											default:
												questStatus = QUEST_MATE;
										}
									}
								}
							}
							//Lai cá không kĩ năng
							else
							{
								if(itemFather.canMate())
								{
									questStatus = QUEST_MATE;
								}
							}
							updateHelper();
						}
					}
					else
					{
						//Effect chọn cá
						//mc = Ultility.CloneImage(itemFish.ImageArr[0].img);
						//img.addChild(mc);
						pS = img.globalToLocal(listBoy.img.localToGlobal(new Point(itemFish.img.x + itemFish.img.width/2 + 20, itemFish.img.y + itemFish.img.height/2 + 20)));
						//mc.x = pS.x;
						//mc.y = pS.y;
						pD = new Point(itemFather.img.x + itemFather.img.width/2 + 20, itemFather.img.y + itemFather.img.height/2 + 20);
						//TweenMax.to(mc, 1, { bezierThrough:[ { x:pD.x, y:pD.y } ], ease:Expo.easeIn, onComplete:completeChooseFish, onCompleteParams:[mc] } );
						particalStar(pS, pD, new ColorTransform(0, 0, 0, 1, 153, 255, 255, 0), completeChooseFish, itemFish, 0.3);
						
						itemFather.SetVisible(false);
						
						//Có quest lai cá
						if (questName != null && questName[0] == "MixTool")
						{
							//Lai cá dùng kĩ năng
							if (questName[1] != null)
							{
								//Chưa chọn cá mẹ
								if(!itemMother.canMate())
								{
									questStatus = QUEST_CHOOSE_GIRL;
								}
								//Đã chọn cá mẹ và chưa chọn đúng kĩ năng
								else if(getUsedSkill() == null || getUsedSkill().typeSkill != questName[1])
								{
									switch(questName[1])
									{
										case ItemSkill.SKILL_MONEY:
											questStatus = QUEST_SKILL_MONEY;
											break;
										case ItemSkill.SKILL_LEVEL:
											questStatus = QUEST_SKILL_LEVEL;
											break;
										case ItemSkill.SKILL_SPECIAL:
											questStatus = QUEST_SKILL_SPECIAL;
											break;
										case ItemSkill.SKILL_RARE:
											questStatus = QUEST_SKILL_RARE;
											break;
										default:
											questStatus = QUEST_MATE;
									}
								}
								//Đã chọn cá mẹ và chọn đúng kĩ năng
								else
								{
									questStatus = QUEST_MATE;
								}
							}
							//Lai cá không dùng kĩ năng
							else
							{
								if (itemMother.canMate())
								{
									questStatus = QUEST_MATE;
								}
							}
							updateHelper();
						}
					}
					
					//updateButton();
					break;
			}
			
			/*function finishChooseFish(mc:Sprite):void
			{
				trace("test");
				img.removeChild(mc);
			}*/
		}
		
		private function completeChooseFish(itemFish:ItemFish):void 
		{
			if (itemFish.sex == 0)
			{
				//Thêm itemMother vào danh sách listGirl
				if (mother != null)
				{
					var newItemGirl:ItemFish = new ItemFish(listGirl);
					newItemGirl.initItemFish(mother);
					listGirl.addItem(CTN_GIRL + mother.Id, newItemGirl, this);
				}
				
				mother = getFish(itemFish.id, 0);
				img.getChildByName("Eff_Mother").visible = true;
				
				itemMother.initItemFish(mother);
				itemMother.IdObject = CTN_GIRL + mother.Id;
				itemMother.SetVisible(true);
				
				//Loại item đc chọn trong danh sách listGirl
				listGirl.removeItem(itemFish.IdObject);
				
				sortListFish(listGirl);
				
				//Chạy list để thấy sự thay đổi
				listGirl.speed = 0;
				listGirl.showLastPage();
				listGirl.speed = 60;
				listGirl.showFirstPage();
			}
			else
			{
				//Thêm itemFather vào danh sách listBoy
				if (father != null)
				{
					var newItemBoy:ItemFish = new ItemFish(listBoy);
					newItemBoy.initItemFish(father);
					listBoy.addItem(CTN_BOY + father.Id, newItemBoy, this);
				}
				
				father = getFish(itemFish.id, 1);
				img.getChildByName("Eff_Father").visible = true;
				
				itemFather.initItemFish(father);
				itemFather.IdObject = CTN_BOY + father.Id;	
				itemFather.SetVisible(true);
				
				//Loại item đc chọn trong ds listBoy
				listBoy.removeItem(itemFish.IdObject);
				
				sortListFish(listBoy);
				
				//Chạy list để thấy sự thay đổi
				listBoy.speed = 0;
				listBoy.showLastPage();
				listBoy.speed = 60;
				listBoy.showFirstPage();
			}
			updateButton();
			calculate();
		}
		
		/**
		 * Hàm tính tiền và phần trăm cá vượt cấp, cá đặc biệt, cá hiếm khi lai
		 * @param	
		 * @return
		 */
		private function calculate():void
		{
			if (!itemFather.canMate() || !itemMother.canMate())
			{
				return;
			}
			//Eff
			GetImage(IMAGE_EFF_COLOR).img.visible = true;
			
			price = 0;
			percentLevel = 0;
			percentSpecial = 0;
			percentRare = 0;
			
			var fish:Fish = (father.Level < mother.Level) ? father : mother;
			var levelMin:int = Math.min(fish.Level, GameLogic.getInstance().user.Level + 5);
			var levelMax:int = Math.min(GameLogic.getInstance().user.Level + 5, fish.Level + 2);
			
			this.levelMin = levelMin;
			this.levelMax = levelMax;
			//Tính tiền
			var config:Object = ConfigJSON.getInstance().GetItemList("MateFishCost");
			var maxPrice:int = config[levelMin];
			for (var i:int = levelMin; i <= levelMax; i++)
			{
				if (config[i] > maxPrice)
				{
					maxPrice = config[i];
				}
			}
			price = maxPrice;
			
			//Cập nhật chỉ số với ngư thạch
			for each(var itemUsedMaterial:ItemSlot in listUsedMaterial.itemList)
			{
				if (itemUsedMaterial.id != 0 && itemUsedMaterial.id != -1)
				{
					config = ConfigJSON.getInstance().getOptionMaterial(levelMin, itemUsedMaterial.id);
					if (config != null)
					{
						percentLevel += config["RateOverLevel"];
						percentSpecial += config["RateSpecial"];
						percentRare += config["RateRare"];
					}
				}
			}
			
			//Phần trăm vượt cấp
			percentLevel += Number(fish.RateMate["Uplevel"]);
			if (levelMin <= 17)
			{
				var bonus:Number = PERCENT_UNEQUAL_LEVEL * (GameLogic.getInstance().user.GetLevel() - levelMin);
				if (bonus > PERCENT_UNEQUAL_LEVEL_MAX)
				{
					bonus = PERCENT_UNEQUAL_LEVEL_MAX;
				}
				percentLevel += bonus;		// tăng khi lai cá cấp thấp
			}
			else
			{
				if (levelMin > GameLogic.getInstance().user.GetLevel())
				{
					var minus:Number = (levelMin - GameLogic.getInstance().user.GetLevel()) * 2;
					percentLevel -= minus;	// giảm khi lai cá cấp cao
				}
			}				
			percentLevel = Math.min(percentLevel, ConfigJSON.getInstance().getItemInfo("MixFish", fish.FishTypeId).MaxOverLevel);
			if (percentLevel < 0 || levelMin >= GameLogic.getInstance().user.GetLevel() + MAX_OVER_LEVEL)
			{
				percentLevel = 0;
			}
			if (percentLevel > 100)
			{
				percentLevel = 100;
			}
			
			//Phần trăm cá đặc biệt
			if (!isNaN(father.RateMate["Special"]))
			{
				percentSpecial += Number(father.RateMate["Special"]);
			}
			if (father.RateOption && father.RateOption[Fish.OPTION_MIX_SPECIAL])
			{
				percentSpecial += father.RateOption[Fish.OPTION_MIX_SPECIAL];
			}
			if (!isNaN(mother.RateMate["Special"]))
			{
				percentSpecial += Number(mother.RateMate["Special"]);
			}
			if (mother.RateOption && mother.RateOption[Fish.OPTION_MIX_SPECIAL])
			{
				percentSpecial += mother.RateOption[Fish.OPTION_MIX_SPECIAL];
			}
			if (percentSpecial > 100)
			{
				percentSpecial = 100;
			}
			
			//Phần trăm cá quí hiếm
			if (!isNaN(father.RateMate["Rare"]))
			{
				percentRare += Number(father.RateMate["Rare"]);
			}
			if (father.RateOption && father.RateOption[Fish.OPTION_MIX_RARE])
			{
				percentRare += father.RateOption[Fish.OPTION_MIX_RARE];
			}
			if (!isNaN(mother.RateMate["Rare"]))
			{
				percentRare += Number(mother.RateMate["Rare"]);
			}
			if (mother.RateOption && mother.RateOption[Fish.OPTION_MIX_RARE])
			{
				percentRare += mother.RateOption[Fish.OPTION_MIX_RARE];
			}
			if (percentRare > 100)
			{
				percentRare = 100;
			}
			
			//Ẩn cá con cũ
			listResult.img.visible = false;
			
			//Kiểm tra công thức lai
			var fishA:Object = new Object();
			fishA["FishType"] = itemMother.fishType;
			fishA["FishTypeId"] = itemMother.fishTypeId;
			var fishB:Object = new Object();
			fishB["FishType"] = itemFather.fishType;
			fishB["FishTypeId"] = itemFather.fishTypeId;
			
			var formula:Object = findFormula(fishA, fishB);
			var idFormulaArr:Array = checkFormula();
			
			var checkMaterial:Boolean = false;
			for each(var slotMaterial:ItemSlot in listUsedMaterial.itemList)
			{
				if (slotMaterial.id > 0)
				{
					checkMaterial = true;
					break;
				}
			}
			if(!checkMaterial)
			{
				updateListMaterial(idFormulaArr);
			}
			//Tìm thấy công thức lai
			if(formula != null)
			{
				itemFormula.initFormula(formula["itemType"], formula["itemId"], 0);
				itemFormula.SetPos(185, 120);
				itemFormula.SetVisible(true);
				formulaAvailble = false;
				txtFoundFormula.visible = true;
				txtWarning.visible = false;
				
				foundFormula = true;
				if (idFormulaArr.length > 0 && autoFormula)
				{
					var tempItem:ItemFormula = listMaterial.getItemByIndex(0) as ItemFormula;
					if (tempItem != null)
					{
						useFormula(tempItem);
						autoFormula = false;
					}
				}
			}
			else
			{
				txtFoundFormula.visible = false;
				if (itemFormula != null && itemFormula.img != null)
				{
					itemFormula.SetVisible(false);
				}
				foundFormula = false;
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_MATE:
					if (GetButton(BTN_MATE).enable)
					{
						GetImage(IMAGE_EFF_LIGHT).img.visible = true;
					}
				default:
					if (buttonID.search(CTN_SKILL) >= 0)
					{
						var item:ItemSkill = listBoxSkill.getItemById(buttonID) as ItemSkill;
						GuiMgr.getInstance().GuiSkillInfo.Show();
						GuiMgr.getInstance().GuiSkillInfo.setInfo(item.typeSkill);
					}
					else
					if (buttonID.search(CTN_USED_FORMULA) >= 0)
					{
						//var itemFormula:ItemFormula = listMaterial.getItemById(buttonID) as ItemFormula;
						//var p:Point = listMaterial.img.globalToLocal(new Point(itemFormula.img.x, itemFormula.img.y));
						var p:Point = new Point(itemFormula.img.x, itemFormula.img.y);
						//GuiMgr.getInstance().GuiMixFormulaInfo.InitAll(itemFormula.config, p.x - 111, p.y - 142);
						GuiMgr.getInstance().GuiMixFormulaInfo.InitAll(itemFormula.config, p.x + 50, p.y + 30);
					}
					else if (buttonID.search(CTN_FORMULA) >= 0)
					{
						var itemF:ItemFormula = listMaterial.getItemById(buttonID) as ItemFormula;
						var point:Point = listMaterial.img.localToGlobal(new Point(itemF.img.x, itemF.img.y));
						//var p:Point = new Point(itemFormula.img.x, itemFormula.img.y);
						GuiMgr.getInstance().GuiMixFormulaInfo.InitAll(itemF.config, point.x, point.y );// - 150);
						//GuiMgr.getInstance().GuiMixFormulaInfo.SetPos(point.x + 50, point.y - 170);
					}
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			GuiMgr.getInstance().GuiSkillInfo.Hide();
			if (buttonID == BTN_MATE)
			{
				GetImage(IMAGE_EFF_LIGHT).img.visible = false;
			}
			else
			if (buttonID.search(CTN_USED_FORMULA) >= 0 || buttonID.search(CTN_FORMULA) >= 0)
			{
				GuiMgr.getInstance().GuiMixFormulaInfo.Hide();
			}
		}
		
		public function get numViagra():int 
		{
			return _numViagra;
		}
		
		public function set numViagra(value:int):void 
		{
			_numViagra = value;
			textFieldViagra.text = value.toString();
		}
		
		public function get price():int 
		{
			return _price;
		}
		
		public function set price(value:int):void 
		{
			_price = value;
			txtPrice.text = Ultility.StandardNumber(Math.round(value*(1-buffMoney)));
			if (Math.round(value*(1-buffMoney)) > GameLogic.getInstance().user.GetMoney() || Math.round(value*(1-buffMoney)) == 0)
			{
				GetButton(BTN_MATE).SetEnable(false);
				GetImage(IMAGE_EFF_LIGHT).img.visible = false;
				if (Math.round(value * (1 - buffMoney)) != 0)
				{
					var tooltip:TooltipFormat = new TooltipFormat();
					tooltip.text = "Bạn không đủ tiền";
				}
				GetButton(BTN_MATE).setTooltip(tooltip);
			}
			else
			{
				GetButton(BTN_MATE).SetEnable(true);
				GetButton(BTN_MATE).setTooltip(null);
			}
		}
		
		public override function OnMouseClick(event:MouseEvent):void
		{
			if (event.target == img)
			{
				ctnViagra.SetHighLight( -1);
				GameLogic.getInstance().MouseTransform("");
				GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
			}
		}
		
		public function get buffMoney():Number 
		{
			return _buffMoney;
		}
		
		public function set buffMoney(value:Number):void 
		{
			_buffMoney = value;
			txtPrice.text = Ultility.StandardNumber(Math.round(price * (1 - buffMoney)));
		}
		
		public function get percentLevel():Number 
		{
			return _percentLevel;
		}
		
		public function set percentLevel(value:Number):void 
		{
			_percentLevel = value;
			var realPercentLevel:Number = Math.min(100, value + 100 * buffLevel);
			realPercentLevel = int(realPercentLevel * 10) / 10;
			if (levelMin >= GameLogic.getInstance().user.GetLevel() + MAX_OVER_LEVEL)
			{
				realPercentLevel = 0;
				txtWarning.visible = true;
			}
			else
			{
				txtWarning.visible = false;
			}
			txtLevel.text = realPercentLevel.toString() + " %";
		}
		
		public function get percentSpecial():Number 
		{
			return _percentSpecial;
		}
		
		public function set percentSpecial(value:Number):void 
		{
			_percentSpecial = value;
			var realPercentSpecial:Number = Math.min(100, value + 100 * buffSpecial);
			realPercentSpecial = int(realPercentSpecial * 10) / 10;
			txtSpecial.text = realPercentSpecial.toString() + "%";
		}
		
		public function get percentRare():Number 
		{
			return _percentRare;
		}
		
		public function set percentRare(value:Number):void 
		{
			_percentRare = value;
			var realPercentRare:Number = Math.min(100, value + 100 * buffRare);
			realPercentRare = int(realPercentRare * 10) / 10;
			txtRare.text = realPercentRare.toString() + "%";
		}
		
		public function get buffLevel():Number 
		{
			return _buffLevel;
		}
		
		public function set buffLevel(value:Number):void 
		{
			_buffLevel = value;
			var realPercentLevel:Number = Math.min(100, percentLevel + 100 * value);
			realPercentLevel = int(realPercentLevel * 10) / 10;
			if (levelMin >= GameLogic.getInstance().user.GetLevel() + MAX_OVER_LEVEL)
			{
				realPercentLevel = 0;
				txtWarning.visible = true;
			}
			else
			{
				txtWarning.visible = false;
			}
			txtLevel.text = realPercentLevel.toString() + "%";
		}
		
		public function get buffSpecial():Number 
		{
			return _buffSpecial;
		}
		
		public function set buffSpecial(value:Number):void 
		{
			_buffSpecial = value;
			var realPercentSpecial:Number = Math.min(100, (percentSpecial + value * 100));
			realPercentSpecial = int(realPercentSpecial * 10) / 10;
			txtSpecial.text = realPercentSpecial.toString() + "%";
		}
		
		public function get buffRare():Number 
		{
			return _buffRare;
		}
		
		public function set buffRare(value:Number):void 
		{
			_buffRare = value;
			var realPercentRare:Number = Math.min(100, percentRare + 100 * buffRare);
			realPercentRare = int(realPercentRare * 10) / 10;
			txtRare.text = realPercentRare.toString() + "%";
		}
		
		public function get numGirl():int 
		{
			return _numGirl;
		}
		
		public function set numGirl(value:int):void 
		{
			_numGirl = value;
			txtNumGirl.text = value.toString();
		}
		
		public function get numBoy():int 
		{
			return _numBoy;
		}
		
		public function set numBoy(value:int):void 
		{
			_numBoy = value;
			txtNumBoy.text = value.toString();
		}
		
		public function get formulaAvailble():Boolean 
		{
			return _formulaAvailble;
		}
		
		public function set formulaAvailble(value:Boolean):void 
		{
			_formulaAvailble = value;
			if (itemFormula != null && itemFormula.img != null)
			{
				if (value)
				{
					itemFormula.img.alpha = 1;
					labelLevel.text = "Thành công";
					labelSpecial.text = "Khởi sự";
					labelRare.text = "Lực chiến";
					
					txtLevel.text = itemFormula.config["SuccessPercent"] + "%";
					txtSpecial.text = GuiMgr.getInstance().GuiMixFormulaInfo.ArrRank[itemFormula.config["Rank"]-1];
					
					/*var damage:Array = ConfigJSON.getInstance().GetItemDamageFishSoldier(itemFormula.itemType, itemFormula.itemId);
					var minDamage:int = int.MAX_VALUE;
					var maxDamage:int = int.MIN_VALUE;
					for (var i:int = 0; i < damage.length; i++) 
					{
						var item:int = damage[i];
						if (item < minDamage) 
						{
							minDamage = item;
						}
						else 
						{
							if (item > maxDamage) 
							{
								maxDamage = item;
							}
						}
					}
					if(maxDamage != int.MIN_VALUE)
					{
						txtRare.text = minDamage + " - " + maxDamage;
					}
					else
					{
						txtRare.text = minDamage.toString();
					}*/
					var configRankRate:Object = ConfigJSON.getInstance().getItemInfo("RankPoint", itemFormula.config["Rank"]);
					var config:Object = ConfigJSON.getInstance().getItemInfo("Damage", -1);
					config = config[itemFormula.itemType][itemFormula.itemId.toString()];
					//Chỉ số lực chiến
					var damage:Object = config["Damage"];//ConfigJSON.getInstance().GetItemDamageFishSoldier(type, Id);
					var st:String = Math.ceil(damage["Min"] * Math.pow((1 + configRankRate["RateDamage"]), itemFormula.config["Rank"] -1)) + " - " + Math.ceil(damage["Max"] * Math.pow((1 + configRankRate["RateDamage"]), itemFormula.config["Rank"] -1));
			
					//var damage:Object = ConfigJSON.getInstance().GetItemDamageFishSoldier(itemFormula.itemType, itemFormula.itemId);
					//txtRare.text = damage["Min"] + " - " + damage["Max"];
					txtRare.text = st;
					
					txtPrice.text = Ultility.StandardNumber(itemFormula.config["MixPrice"]);
					if (itemFormula.config["MixPrice"] > GameLogic.getInstance().user.GetMoney() || itemFormula.config["MixPrice"] == 0)
					{
						GetButton(BTN_MATE).SetEnable(false);
						GetImage(IMAGE_EFF_LIGHT).img.visible = false;
						if (itemFormula.config["MixPrice"] != 0)
						{
							var tooltip:TooltipFormat = new TooltipFormat();
							tooltip.text = "Bạn không đủ tiền";
						}
						GetButton(BTN_MATE).setTooltip(tooltip);
					}
					else
					{
						GetButton(BTN_MATE).SetEnable(true);
						GetButton(BTN_MATE).setTooltip(null);
					}
				}
				else
				{
					itemFormula.img.alpha = 0.3;
					labelLevel.text = "Vượt cấp";
					labelSpecial.text = "Đặc biệt";
					labelRare.text = "Quý";
				}
			}
		}
		
		override public function Hide():void 
		{
			GameLogic.getInstance().ShowFish();
			buffLevel  = 0;
			buffSpecial = 0;
			buffMoney = 0;
			buffRare = 0;
			price = 0;
			percentLevel = 0;
			percentSpecial = 0;
			percentRare  = 0;
			levelMax = 0;
			levelMin = 0;
			super.Hide();
			GameLogic.getInstance().BackToIdleGameState();
			father = null;
			mother = null;
			
			//Hủy particle
			while (emitStar[0])
			{
				emitStar[0].destroy();
				emitStar.splice(0, 1);
			}	
			
			//tắt đi thì mới bật phần nhận thưởng quest
			var questArr:Array = QuestMgr.getInstance().finishedQuest;
			if (questArr.length > 0)
			{
				GameLogic.getInstance().OnQuestDone(questArr[0]);		
				questArr.splice(0, 1);
			}
		}
		
		public function mateFishComplete(fish:Fish, skill:Object):void 
		{
			//Lai thành công
			if (fish != null)
			{
				GameLogic.getInstance().user.GenerateNextID();
				
				var itemResult:ItemFish = new ItemFish(listResult);
				itemResult.initItemFish(fish, true);
				listResult.addItem(itemResult.id.toString(), itemResult);
				listResult.img.visible = true;
				listResult.showLastPage();
				updateButton();
				
				var selectedSkill:ItemSkill = getUsedSkill();
				if (selectedSkill != null && skill != null)
				{
					//Cong mastery va exp tu server
					var numMastery:int = skill[selectedSkill.typeSkill]["Mastery"] - selectedSkill.mastery;
					if (numMastery != 0)
					{
						var txtFormat:TextFormat = new TextFormat("Arial", 14);
						txtFormat.bold = true;
						switch(selectedSkill.typeSkill)
						{
							case ItemSkill.SKILL_MONEY:
								txtFormat.color = 0xfcc046;
								break;
							case ItemSkill.SKILL_LEVEL:
								txtFormat.color = 0x00ff00;
								break;
							case ItemSkill.SKILL_SPECIAL:
								txtFormat.color = 0x0093ff;
								break;
							case ItemSkill.SKILL_RARE:
								txtFormat.color = 0xff0000;
								break;
						}
						var tmp:Sprite = Ultility.CreateSpriteText("+" + numMastery.toString(), txtFormat, 6, 0, false);					
						var pos:Point = listBoxSkill.img.localToGlobal(selectedSkill.CurPos);
						var eff:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp) as ImgEffectFly;
						eff.SetInfo(pos.x + 35 + 28, 321, pos.x + 35 + 28, 231, 7);
						
						selectedSkill.mastery = skill[selectedSkill.typeSkill]["Mastery"];
						var userSkill:Object = GameLogic.getInstance().user.GetMyInfo().Skill;
						userSkill[selectedSkill.typeSkill]["Mastery"] = selectedSkill.mastery;
						userSkill[selectedSkill.typeSkill]["Level"] = selectedSkill.level;
					}
					//Cập nhật cho skill
					selectedSkill.showEffSelected(false);
					selectedSkill.isSelected = false;
					
					//Cập nhật năng lượng
					GameLogic.getInstance().user.UpdateEnergy( -selectedSkill.spendEnergy);
					curEnergy -= selectedSkill.spendEnergy;
					prgCurEnergy.setStatus(curEnergy / maxEnergy);
				}
				
				var imageNameFeed:String;
				//Feed lên tường cá quí
				if (fish.FishType == Fish.FISHTYPE_SPECIAL)
				{
					GuiMgr.getInstance().GuiFeedWall.SetFishType(fish.FishTypeId);
					imageNameFeed = Fish.ItemType + fish.FishTypeId + ".png";
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_SPECIAL_FISH, "", "", imageNameFeed);
				}
				//Feed cá đặc biệt
				else if (fish.FishType == Fish.FISHTYPE_RARE)
				{
					GuiMgr.getInstance().GuiFeedWall.SetFishType(fish.FishTypeId);
					imageNameFeed = Fish.ItemType + fish.FishTypeId + ".png";
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_RARE_FISH, "", "", imageNameFeed);
				}
				//Feed cá mới
				else
				{
					var obj:Object = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, fish.FishTypeId);
					var item_name:String = Localization.getInstance().getString("Fish" + fish.FishTypeId);
					if (obj.UnlockType == GUIShop.UNLOCK_TYPE_MIX && GameLogic.getInstance().user.CheckFishUnlocked(fish.FishTypeId) == 0)
					{
						GuiMgr.getInstance().GuiFeedWall.SetFishType(fish.FishTypeId);
						imageNameFeed = Fish.ItemType + fish.FishTypeId + ".png";
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_NEW_FISH, item_name,"",imageNameFeed);
					}
					//Feed vượt cấp
					else 
					{
						if (fish.Level > mother.Level && fish.Level > father.Level && fish.Level > levelMax)
						{
							GuiMgr.getInstance().GuiFeedWall.SetFishType(fish.FishTypeId);
							imageNameFeed = Fish.ItemType + fish.FishTypeId + ".png";
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_MIX_OVER_LEVEL, item_name,"", imageNameFeed);
						}
					}
				}
				
				// Unlock cá trong shop
				var config:Object = ConfigJSON.getInstance().getItemInfo(Fish.ItemType, fish.FishTypeId);
				if (config.UnlockType == GUIShop.UNLOCK_TYPE_MIX && GameLogic.getInstance().user.CheckFishUnlocked(fish.FishTypeId) == 0)
				{
					GameLogic.getInstance().user.AddFishUnlock(fish.FishTypeId, GUIShop.UNLOCK_TYPE_MIX);
				}
			
			}
			//Lai xịt cá lính
			else
			{
				//trace("xịt");
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "GuiMateFish_Eff_Fail", null, 385, 250);
			}
			
			isMating = false;
		}
		
		public function updateFillEnergy():void 
		{
			maxEnergy = ConfigJSON.getInstance().getMaxEnergy(GameLogic.getInstance().user.GetLevel(true));
			curEnergy = GameLogic.getInstance().user.GetEnergy();
			var objSkill:Object;
			var selectedSkill:ItemSkill = getUsedSkill();
			if (selectedSkill != null && selectedSkill.level != 0)
			{
				objSkill = ConfigJSON.getInstance().getItemInfo(selectedSkill.typeSkill, selectedSkill.level);
			}
			var energy:int = 0;
			if (objSkill)	energy = objSkill.SpendEnergy;
			var remainEnergy:int = curEnergy - energy;
			txtEnergy.text = Ultility.StandardNumber(remainEnergy) + " / " + Ultility.StandardNumber(maxEnergy);
			prgCurEnergy.setStatus(GameLogic.getInstance().user.GetEnergy() / maxEnergy);
			prgEnergy.setStatus(remainEnergy / maxEnergy);
			var objGeneral:Object = ConfigJSON.getInstance().GetItemList("Param"); //GetItemInfo("General", user.GetMyInfo().NumFill);
			var obj:Object = objGeneral.FillEnergy;
		}
		
		/**
		 * Sắp xếp mảng cá theo tiêu chí: có thể lai, cá quí, đặc biệt, cấp độ cá
		 * @param	list: ListBox cần sắp xếp
		 */
		private function sortListFish(list:ListBox):void
		{
			if (list == null || list.length == 0)
			{
				return ;
			}
			
			//var can:Array = [];
			//var cant:Array = [];
			var itemFish:ItemFish;
			var arr:Array = list.itemList.concat(new Array());
			/*
			arr.sortOn(["fishTypeId", "id"], Array.DESCENDING | Array.NUMERIC);
			for (var i:int = 0; i < arr.length; i++)
			{
				itemFish = arr[i] as ItemFish;
				if (itemFish.canMate())
				{
					can.push(itemFish);
				}
				else
				{
					cant.push(itemFish);					
				}
			}			
			list.itemList.splice(0, list.itemList.length);
			for each(itemFish in can)
			{
				list.addItem(itemFish.IdObject, itemFish, this);
			}
			for each(itemFish in cant)
			{
				list.addItem(itemFish.IdObject, itemFish, this);
			}*/
			
			arr.sortOn(["statusMate", "fishType", "fishTypeId"], Array.DESCENDING | Array.NUMERIC);
			list.itemList.splice(0, list.itemList.length);
			for each(itemFish in arr)
			{
				list.addItem(itemFish.IdObject, itemFish, this);
			}
		}
		
		private function updateStateNextPreList(listBox:ListBox, btnN:Button, btnP:Button):void
		{
			if (listBox.getNumPage() <= 1)
			{
				if(btnN)	btnN.SetDisable();
				if(btnP)	btnP.SetDisable();
			}
			else 
			{
				switch (listBox.curPage) 
				{
					case 0:
						if(btnP)	btnP.SetDisable();
						if(btnN)	btnN.SetEnable();
					break;
					
					case listBox.getNumPage() - 1:
						if(btnN)	btnN.SetEnable(false);
						if(btnP)	btnP.SetEnable();
					break;
					
					default:
						if(btnP)	btnP.SetEnable();
						if(btnN)	btnN.SetEnable();
					break;
					
				}
			}
		}
		
		private function updateHavertTime(fish:Fish):void
		{
			fish.HarvestTime = ConfigJSON.getInstance().getFishHarvest(fish.FishTypeId, fish.FishType, fish);
			var LakeId:int = fish.LakeId;
			fish.HarvestTime = fish.HarvestTime * ( 1 - Math.min(GameLogic.getInstance().user.buffTimeAllLake[LakeId.toString()]["Time"], Constant.MAX_BUFF_TIME) / 100);
		}
		
		/**
		 * Function này sẽ lấy ra con cá theo id truyền vào
		 * @param	id: id của cá muốn lấy
		 * @return	cá tương ứng với id truyền vào
		 */
		private function getFish(id:int, sex:int):Fish
		{
			var f:Fish;
			var i:int;
			var listFish:Array;
			if (sex == 1)
			{
				listFish = boyArr;
			}
			else
			{
				listFish = girlArr;
			}
			for (i = 0; i < listFish.length; i++)
			{
				f = listFish[i];
				if (f.Id == id)
				{
					return f;
				}
			}
			
			return null;
		}
		
		private function getUsedSkill():ItemSkill
		{
			for each(var itemSkill:ItemSkill in listBoxSkill.itemList)
			{
				if (itemSkill.isSelected)
				{
					return itemSkill;
				}
			}
			return null;
		}
		
		/**
		 * Thêm particle từ nút chọn skill đến giữa gui lai
		 * @param	SkillName	tên loại kỹ năng lai
		 */
		private function startParticleUseSkill(itemSkill:ItemSkill):void
		{
			var fromP:Point;
			var toP:Point;
			var colorTransform:ColorTransform;
			switch(itemSkill.typeSkill)
			{
				case ItemSkill.SKILL_MONEY:
					fromP = new Point(267, 130);
					toP = new Point(txtPrice.x + 25, txtPrice.y + 15);				
					colorTransform = new ColorTransform(0, 0, 0, 1, 255, 255, 100, 0);
					break;
				case ItemSkill.SKILL_LEVEL:
					fromP = new Point(347, 130);
					toP = new Point(txtLevel.x + 25, txtLevel.y + 20);
					colorTransform = new ColorTransform(0, 0, 0, 1, 100, 255, 100, 0);
					break;
				case ItemSkill.SKILL_SPECIAL:
					fromP = new Point(427, 130);
					toP = new Point(txtSpecial.x + 25, txtSpecial.y + 20);
					colorTransform = new ColorTransform(0, 0, 0, 1, 50, 255, 255, 0);
					break;
				case ItemSkill.SKILL_RARE:
					fromP = new Point(507, 130);	
					toP = new Point(txtRare.x + 25, txtRare.y + 20);
					colorTransform = new ColorTransform(0, 0, 0, 1, 255, 100, 100, 0);
					break;
			}
			particalStar(fromP, toP, colorTransform, completeUseSkill, itemSkill);	
		}
		
		private function completeUseSkill(itemSkill:ItemSkill):void
		{
			switch(itemSkill.typeSkill)
			{
				case ItemSkill.SKILL_MONEY:
					if(buffMoney == 0)
					{
						buffMoney = itemSkill.buff;
						buffLevel = 0;
						buffSpecial = 0;
						buffRare = 0;
					}
					break;
				case ItemSkill.SKILL_LEVEL:
					if(buffLevel == 0)
					{
						buffLevel = itemSkill.buff;
						buffMoney = 0;
						buffSpecial = 0;
						buffRare = 0;
					}
					break;
				case ItemSkill.SKILL_SPECIAL:
					if(buffSpecial == 0)
					{
						buffSpecial = itemSkill.buff;
						buffMoney = 0;
						buffLevel = 0;
						buffRare = 0;
					}
					break;
				case ItemSkill.SKILL_RARE:
					if(buffRare == 0)
					{
						buffRare = itemSkill.buff;
						buffMoney = 0;
						buffLevel = 0;
						buffSpecial = 0;
					}
					break;
			}
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
				if(mid != 2)
				{
					emit.velTolerance = new Point(1.5, 1.5);
					TweenMax.to(emit.sp , time, { bezierThrough:[ { x:midPoint.x, y:midPoint.y }, { x:toPoint.x, y:toPoint.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween, onCompleteParams:[completeFunction,params]} );					
				}
				else
				{
					emit.velTolerance = new Point(1.2, 1.2);
					TweenMax.to(emit.sp , time, { bezierThrough:[ { x:toPoint.x, y:toPoint.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween, onCompleteParams:[completeFunction, params] } );					
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
					img.removeChild(emit.sp);	
				}
				if(completeFunction != null)
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
			var p:Point = pdes.subtract(psrc);//Vector từ nguồn đến đích
			if (p.y == 0)
				return new Point(p.x/2, 0);
			var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2);//Trung điểm của nguồn và đích
			var v:Point = new Point( -p.y, p.x);//Vector vuông góc với vector(nguồn, đích)
			
			//Random hướng vuông góc
			var n:int;
			if(mid == 0)
			{
				n = Math.round(Math.random()) * 2 - 1;
			}
			else
			{
				n = mid;
			}
			v.x = n*v.x;
			v.y = n*v.y;
			var l:Number = Math.min(120, v.length / 3);
			v.normalize(l);//Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			var result:Point = med.add(v);//Tính ra điểm cần đi xuyên qua
			return result;			
		}
		
		override public function UpdateObject():void 
		{
			//Update particle
			for (var i:int; i < emitStar.length; i++)
			{
				emitStar[i].updateEmitter();
				if (!emitStar[i].allowSpawn && emitStar[i].particleList.length < 1)
				{
					emitStar[i].destroy();
					emitStar.splice(i, 1);
					i--;					
				}
			}	
		}
		
		public function upgradeSkill(typeSkill:String):void 
		{
			for each(var itemSkill:ItemSkill in listBoxSkill.itemList)
			{
				if (itemSkill.typeSkill == typeSkill)
				{
					itemSkill.upgradeComplete();
					break;
				}
			}
		}
		
		private function updateHelper():void
		{
			imageHelper.img.visible = true;
			switch(questStatus)
			{
				case QUEST_CHOOSE_BOY:
					imageHelper.SetPos(100, 217);
					break;
				case QUEST_CHOOSE_GIRL:
					imageHelper.SetPos(702, 217);
					break;
				case QUEST_SKILL_MONEY:
					imageHelper.SetPos(300, 130);
					break;
				case QUEST_SKILL_LEVEL:
					imageHelper.SetPos(365, 130);
					break;
				case QUEST_SKILL_SPECIAL:
					imageHelper.SetPos(432, 130);
					break;
				case QUEST_SKILL_RARE:
					imageHelper.SetPos(500, 130);
					break;
				case QUEST_MATE:
					imageHelper.SetPos(401, 345);
					break;
				default:
					imageHelper.img.visible = false;
			}
		}
		
		/**
		 * Kiểm tra cá đem lai có trong công thức không
		 * @return index của công thức lai trong listFormula
		 */
		private function checkFormula():Array
		{
			var fishA:Object = new Object();
			fishA["FishType"] = itemMother.fishType;
			fishA["FishTypeId"] = itemMother.fishTypeId;
			var fishB:Object = new Object();
			fishB["FishType"] = itemFather.fishType;
			fishB["FishTypeId"] = itemFather.fishTypeId;
			
			var result:Array = [];
			
			var priority:Object = 
			{
				"Draft":1,
				"Paper":2,
				"GoatSkin":3,
				"Blessing":4
			};
			
			for (var i:int = 0; i < listMaterial.itemList.length; i++)
			{
				if (listMaterial.getIdByIndex(i).search(CTN_FORMULA) >= 0)
				{
					var itemDraft:ItemFormula = listMaterial.itemList[i] as ItemFormula;
					if (ItemFormula.checkFormula(fishA, fishB, itemDraft.fishA, itemDraft.fishB))
					{
						itemDraft.canUse = true;
						result.push(itemDraft);
					}
					else
					{
						itemDraft.canUse = false;
					}
				}
			}
			
			//Sắp xếp mảng kết quả
			for (var h:int = 0; h < result.length; h++)
			{
				for (var k:int = result.length - 1; k > h; k--)
				{
					trace(priority[result[h]["itemType"]], priority[result[k]["itemType"]]);
					if (priority[result[h]["itemType"]] < priority[result[k]["itemType"]])
					{
						var temp:ItemFormula = result[h];
						result[h] = result[k];
						result[k] = temp;
					}
				}
			}
			
			var sortResult:Array = [];
			for (var n:int = result.length - 1; n >= 0; n--)
			{
				sortResult.push(result[n]["IdObject"]);
			}
			
			return sortResult;
		}
		
		private function findFormula(fishA:Object, fishB:Object):Object
		{
			var config:Object = ConfigJSON.getInstance().getItemInfo("MixFormula", -1);
			var arr:Object = new Object();
			arr["Draft"] = config["Draft"];
			arr["Paper"] = config["Paper"];
			arr["GoatSkin"] = config["GoatSkin"];
			arr["Blessing"] = config["Blessing"];
			
			for (var h:String in arr)
			{
				for (var i:String in arr[h])
				{
					if (ItemFormula.checkFormula(fishA, fishB, arr[h][i]["Fish_1"], arr[h][i]["Fish_2"]))
					{
						var result:Object = new Object();
						result["itemType"] = h;
						result["itemId"] = i;
						return result;
					}
				}
			}
			return null;
		}
		
		private function useFormula(_itemFormula:ItemFormula):void
		{
			if (!foundFormula || !_itemFormula.canUse || (itemFormula.itemType == _itemFormula.itemType && itemFormula.itemId == _itemFormula.itemId && formulaAvailble)|| effUseFormula)
			{
				return;
			}
			
			GuiMgr.getInstance().GuiMixFormulaInfo.Hide();
			
			if (formulaAvailble)
			{
				removeFormula(false, false);
			}
			
			//remove ngư thạch
			for each(var slotMaterial:ItemSlot in listUsedMaterial.itemList)
			{
				if(slotMaterial.id > 0)
				{
					removeMaterial(slotMaterial, false);
				}
			}
			
			//effect
			effUseFormula = true;
			var mc:Sprite = Ultility.CloneImage(_itemFormula.imageFormula.img);
			img.addChild(mc);
			var pS:Point = img.globalToLocal(_itemFormula.img.localToGlobal(new Point(_itemFormula.imageFormula.img.x, _itemFormula.imageFormula.img.y)));
			mc.x = pS.x;
			mc.y = pS.y;
			var pD:Point = new Point(itemFormula.img.x, itemFormula.img.y);
			TweenMax.to(mc, 0.5, { bezierThrough:[ { x:pD.x, y:pD.y } ], ease:Expo.easeIn, onComplete:finishUseFormula, onCompleteParams:[mc, _itemFormula] } );
			
			_itemFormula.num --;
			if (_itemFormula.num == 0)
			{
				listMaterial.removeItem(_itemFormula.IdObject);
			}
		}
		
		private function finishUseFormula(mc:Sprite, _itemFormula:ItemFormula):void 
		{
			img.removeChild(mc);
			itemFormula.initFormula(_itemFormula.itemType, _itemFormula.itemId, 1);
			formulaAvailble = true;
			effUseFormula = false;
		}
		
		private function removeFormula(useEff:Boolean = true, callCaculate:Boolean = true):void 
		{
			if (!formulaAvailble)
			{
				return;
			}
			//Effect
			var mc:Sprite = Ultility.CloneImage(itemFormula.imageFormula.img);
			img.addChild(mc);
			var pS:Point = img.globalToLocal(itemFormula.img.localToGlobal(new Point(itemFormula.imageFormula.img.x, itemFormula.imageFormula.img.y)));
			mc.x = pS.x;
			mc.y = pS.y;
			
			var pD:Point;
			var hasItem:Boolean = false;
			var ctnFormula:ItemFormula;
			for (var i:int = 0; i < listMaterial.itemList.length; i++)
			{
				if (listMaterial.itemList[i]["ClassName"] == "ItemFormula" && listMaterial.itemList[i]["itemType"] == itemFormula.itemType && listMaterial.itemList[i]["itemId"] == itemFormula.itemId)
				{
					ctnFormula = listMaterial.itemList[i] as ItemFormula;
					hasItem = true;
					pD = img.globalToLocal(ctnFormula.img.localToGlobal(new Point(ctnFormula.imageFormula.img.x, ctnFormula.imageFormula.img.y)));
					break;
				}
			}
			//Không còn ngư thạch này trong listMaterial
			if (!hasItem)
			{
				ctnFormula = new ItemFormula(listMaterial);
				ctnFormula.initFormula(itemFormula.itemType, itemFormula.itemId, 1);
				listMaterial.addItem(CTN_FORMULA + "_" + ctnFormula.itemType + "_" + ctnFormula.itemId, ctnFormula, this);
				updateButton();
				pD = img.globalToLocal(ctnFormula.img.localToGlobal(new Point(ctnFormula.imageFormula.img.x, ctnFormula.imageFormula.img.y)));
				ctnFormula.SetVisible(false);
			}
			if(useEff)
			{
				TweenMax.to(mc, 0.5, { bezierThrough:[ { x:pD.x, y:pD.y } ], ease:Expo.easeIn, onComplete:finishRemoveFormulaEff, onCompleteParams:[mc, ctnFormula, hasItem, callCaculate] } );
			}
			else
			{
				finishRemoveFormulaEff(mc, ctnFormula, hasItem, callCaculate);
			}
		}
		
		private function finishRemoveFormulaEff(mc:Sprite, ctnFormula:ItemFormula, hasItem:Boolean, callCaculate:Boolean = true):void 
		{
			img.removeChild(mc);
			if (hasItem)
			{
				ctnFormula.num++;
			}
			else
			{
				ctnFormula.SetVisible(true);
			}
			itemFormula.num = 0;
			formulaAvailble = false;
			
			if(callCaculate)
			{
				calculate();
			}
		}
	}

}