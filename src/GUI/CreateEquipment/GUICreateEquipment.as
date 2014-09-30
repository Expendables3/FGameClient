package GUI.CreateEquipment 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GameControl.HelperMgr;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ProgressBar;
	import GUI.component.ScrollBar;
	import GUI.component.TooltipFormat;
	import GUI.component.Tree.Tree;
	import GUI.component.Tree.TreeNode;
	import GUI.CreateEquipment.ItemSkillCreate;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIChooseEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.CreateEquipment.SendCreateEquip;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUICreateEquipment extends BaseGUI 
	{
		private var tree:Tree;
		private var scrollBar:ScrollBar;
		private var treeBg:Container;
		private var progressBar:ProgressBar;
		private var listIngradient:ListBox;
		private var listEquip:ListBox;
		private var itemType:String;
		private var itemLevel:int;
		private var itemElement:int;
		private var labelNumSpirit:TextField;
		private var typeSkill:String;
		private var _numSpirit:int;
		private var curNode:TreeNode;
		private var levelSkill:int;
		private var itemSkill:ItemSkillCreate;
		private var timer:Timer;
		private var isGetResult:Boolean = false;
		private var imageArrow:Image;
		static public const BTN_CLOSE:String = "btnClose";
		static public const CTN_TREE:String = "ctnTree";
		static public const CREATE_WEAPON:String = "Weapon";
		static public const CREATE_ARMOR:String = "Armor";
		static public const CREATE_HELMET:String = "Helmet";
		static public const CREATE_JEWEL:String = "Jewel";
		static public const CREATE_MAGIC:String = "Magic";
		static public const BTN_CREATE:String = "btnCreate";
		static public const BTN_BUY_SPIRIT:String = "btnBuySpirit";
		static public const CTN_EQUIP:String = "ctnEquip";
		static public const BTN_GET:String = "btnGet";
		
		public function GUICreateEquipment(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(40, 30);
				OpenRoomOut();
			}			
			LoadRes("GuiCreateEquipment_Theme");
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case CTN_TREE:
					//click vao nut cha
					var father:TreeNode = tree.getSelectedNode();
					if(father != null)
					{
						//trace(father.labelName.text);
					}
					break;
				case BTN_CREATE:
					//Đang khóa hoặc xin phá khóa
					var passwordState:String = GameLogic.getInstance().user.passwordState;
					if (passwordState == Constant.PW_STATE_IS_LOCK || passwordState == Constant.PW_STATE_IS_CRACKING || passwordState == Constant.PW_STATE_IS_BLOCKED)
					{
						GuiMgr.getInstance().guiPassword.showGUI();
						break;
					}
					tree.isListen = false;
					isGetResult = false;
					//Eff thanh chay
					timer.reset();
					timer.start();
					progressBar.visible = true;
					progressBar.setStatus(0);
					GetButton(BTN_CREATE).SetVisible(false);
					
					//Gui goi tin tao do
					GameLogic.getInstance().user.GenerateNextID();
					var sendCreateEquip:SendCreateEquip = new SendCreateEquip(typeSkill, itemLevel, itemElement, itemType);
					Exchange.GetInstance().Send(sendCreateEquip);
					
					//trace(typeSkill, "level", itemLevel, "element", itemElement, itemType);
					//Set lại số lượng nguyên liệu
					var ingradient:Object = GameLogic.getInstance().user.ingradient;
					for each(var itemIngradient:ItemIngradientRequire in listIngradient.itemList)
					{
						if (itemIngradient.itemType != null)
						{
							if (itemIngradient.itemType != "SoulRock")
							{
								ingradient[itemIngradient.itemType] -= itemIngradient.numRequire;
								itemIngradient.num = ingradient[itemIngradient.itemType];
							}
							else
							{
								ingradient[itemIngradient.itemType][itemIngradient.rank] -= itemIngradient.numRequire;
								itemIngradient.num = ingradient[itemIngradient.itemType][itemIngradient.rank];
							}
						}
					}
					//Set lại tinh lực
					//var point:Point = new Point(560, 150);
					//Ultility.ShowEffText("-" + Ultility.StandardNumber(numSpirit - ingradient["PowerTinh"]), img, point, new Point(point.x, point.y - 20), new TextFormat("arial", 16, 0xffff00, true), 1, 0x000000);
					numSpirit = ingradient["PowerTinh"];
					
					GetButton(BTN_CLOSE).SetEnable(false);
					break;
				case BTN_GET:
					GetButton(BTN_CLOSE).SetEnable(true);
					GetButton(BTN_GET).SetVisible(false);
					for each(var itemEquip:ItemEquip in listEquip.itemList)
					{
						if (itemEquip.equip != null)
						{
							EffectMgr.setEffBounceDown("", itemEquip.equip.imageName + "_Shop", 450, 200/*, bounceDownComplete*/);
						}
					}
					bounceDownComplete();
					
					//Cộng điểm exp kĩ năng
					var config:Object = ConfigJSON.getInstance().GetItemList("Crafting_Exp")["ExpCrafted"];
					var numExpSkill:int = config[levelSkill][itemLevel];
					var oldSkillLevel:int = itemSkill.level;
					itemSkill.exp += numExpSkill;
					var craftingData:Object = GameLogic.getInstance().user.craftingSkills;
					if (craftingData == null)
					{
						craftingData = new Object();
					}
					if (craftingData[itemSkill.type] == null)
					{
						craftingData[itemSkill.type] = new Object();
					}
					craftingData[itemSkill.type]["Exp"] = itemSkill.exp;
					craftingData[itemSkill.type]["Level"] = itemSkill.level;
					levelSkill = itemSkill.level;
					var p:Point = new Point(210 + 137, 154);
					Ultility.ShowEffText("+" + numExpSkill, img, p, new Point(p.x, p.y - 20), new TextFormat("arial", 16, 0xffff00, true), 1, 0x000000);
					
					//Set lai cay neu len cap
					if (itemSkill.level > oldSkillLevel)
					{
						ClearScroll();
						tree.Clear();
						initTree(typeSkill, itemSkill.level);
						var message:String = "Lên cấp " + itemSkill.level + " kĩ năng chế tạo "  + Localization.getInstance().getString(itemSkill.type);
						GuiMgr.getInstance().guiCongratulation.showReward("IconUpgradeSkillCreate", -1, message, function feed():void
						{
							var skillName:String = Localization.getInstance().getString(itemSkill.type);
							GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_UPGRADE_SKILL_CREATE, skillName, itemSkill.level.toString());
						}
						);
					}
					//update guiFactory
					if (GuiMgr.getInstance().guiChooseFactory.IsVisible)
					{
						GuiMgr.getInstance().guiChooseFactory.updateSkillCreate(craftingData);
					}
					
					tree.isListen = true;
					break;
				case BTN_BUY_SPIRIT:
					GuiMgr.getInstance().guiBuySpirit.Show(Constant.GUI_MIN_LAYER, 3);
					break;
			}
		}
		
		private function bounceDownComplete():void
		{
			if (IsVisible)
			{
				onClickTreeNode(curNode);
				GetButton(BTN_CREATE).SetVisible(true);
			}
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_EQUIP) >= 0)
			{
				var itemEquip:ItemEquip = listEquip.getItemById(buttonID) as ItemEquip;
				var obj:Object;
				if (itemEquip.imageEquip != null && itemEquip.imageEquip.img != null && itemEquip.imageEquip.img.visible && itemEquip.itemLevel != 0)
				{
					if(itemEquip.equip == null)
					{
						obj = ConfigJSON.getInstance().GetEquipmentInfo(itemEquip.itemType, (itemEquip.itemElement * 100 + itemEquip.itemLevel) + "$" + itemEquip.itemColor);
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, obj);
					}
					else
					{
						obj = itemEquip.equip;
						GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX,event.stageY, obj, GUIEquipmentInfo.INFO_TYPE_SPECIFIC);
					}
				}
			}
		}
		
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			if (buttonID.search(CTN_EQUIP) >= 0)
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
			}
		}
		
		override public function onClickTreeNode(childNode:TreeNode):void
		{
			if (imageArrow != null && imageArrow.img != null)
			{
				imageArrow.img.visible = false;
			}
			curNode = childNode;
			itemType = childNode.data["type"];
			itemLevel = childNode.data["level"];
			if(childNode.data["element"] != null)
			{
				itemElement = childNode.data["element"];
			}
			else
			{
				itemElement = 0;
			}
			var config:Object = ConfigJSON.getInstance().GetItemList("CraftingEquip");
			if(typeSkill != "Magic")
			{
				config = config[itemType][itemLevel];
			}
			else
			{
				config = config["Magic"][itemLevel];
			}
			
			//Set danh sach equipment
			listEquip.removeAllItem();
			var i:int;
			for (i = 1; i < 5; i++)
			{
				var itemEquip:ItemEquip = new ItemEquip(listEquip.img);
				itemEquip.initEquip(i, itemType, config["Rank"], itemElement, config["RF"][i]);
				listEquip.addItem(CTN_EQUIP + i.toString(), itemEquip, this);
			}
			GetButton(BTN_CREATE).SetVisible(true);
			GetButton(BTN_GET).SetVisible(false);
			progressBar.visible = false;
			
			//Set danh sach nguyen lieu can che tao
			var ingradient:Object = GameLogic.getInstance().user.ingradient;
			listIngradient.removeAllItem();
			GetButton(BTN_CREATE).SetEnable(true);
			for (var s:String in config["Ingredients"])
			{
				var num:int;
				var numRequire:int = config["Ingredients"][s]["Num"];
				var type:String = config["Ingredients"][s]["Type"];
				var itemIngradient:ItemIngradientRequire = new ItemIngradientRequire(listIngradient.img);
				if(type != "SoulRock")
				{
					if (ingradient != null)
					{
						num = ingradient[type];
					}
					else
					{
						num = 0;
					}
					itemIngradient.initIngradient(type, 0);
				}
				else
				{
					//var color:int = config["Ingredients"][s]["Color"];
					var rank:int = config["Ingredients"][s]["Rank"];
					if (ingradient != null && ingradient[type] != null)
					{
						num = ingradient[type][rank];
					}
					else
					{
						num = 0;
					}
					itemIngradient.initIngradient(type, rank);
				}
				itemIngradient.num = num;
				itemIngradient.numRequire = numRequire;
				//itemIngradient.SetScaleXY(1.3);
				listIngradient.addItem(i.toString(), itemIngradient);
				
				if (num < numRequire)
				{
					GetButton(BTN_CREATE).SetEnable(false);
				}
			}
			
			for (i = 0; i < 3 - listIngradient.length; i++)
			{
				var emptyItem:ItemIngradientRequire = new ItemIngradientRequire(listIngradient.img);
				//emptyItem.SetScaleXY(1.3);
				listIngradient.addItem("", emptyItem);
			}
			
			if (!GetButton(BTN_CREATE).enable)
			{
				var tooltipFormat:TooltipFormat = new TooltipFormat();
				tooltipFormat.text = "Bạn không đủ nguyên liệu";
				GetButton(BTN_CREATE).setTooltip(tooltipFormat);
			}
			else
			{
				GetButton(BTN_CREATE).setTooltip(null);
				HelperMgr.getInstance().SetHelperData("BtnCreateEquip", GetButton(BTN_CREATE).img);
			}
		}
		
		override public function EndingRoomOut():void 
		{
			AddButton(BTN_CLOSE, "BtnThoat", 702, 18, this);
			treeBg = AddContainer("", "", 20 + 36, 197);
			treeBg.LoadRes("");
			initTree(typeSkill, levelSkill);
			
			//Thanh cap do ki nang che tao
			var craftingData:Object = GameLogic.getInstance().user.craftingSkills;
			itemSkill = new ItemSkillCreate(img, "");
			itemSkill.initSkill(typeSkill, levelSkill, craftingData[typeSkill]["Exp"], true);
			itemSkill.SetPos(137 + 50, 97);
			
			//Ti le che tao
			var txtFormat:TextFormat = new TextFormat("arial", 18, 0xffff00, true);
			AddLabel("Tỷ Lệ Chế Tạo", 438, 300 - 104, 0xffff00, 1, 0x000000).setTextFormat(txtFormat);
			listEquip = AddListBox(ListBox.LIST_X, 1, 4);
			for (var i:int = 1; i < 5; i++)
			{
				var itemEquip:ItemEquip = new ItemEquip(listEquip.img);
				itemEquip.initEquip(i);
				listEquip.addItem(i.toString(), itemEquip);
			}
			listEquip.setPos(329, 227);
			AddButton(BTN_CREATE, "GuiCreateEquipment_Btn_Create", 250 + 170, 180 + 170).SetEnable(false);
			var tooltipFormat:TooltipFormat = new TooltipFormat();
			tooltipFormat.text = "Bạn chưa chọn tầng chế tạo";
			GetButton(BTN_CREATE).setTooltip(tooltipFormat);
			AddButton(BTN_GET, "GuiCreateEquipment_Btn_Get", 250 + 193, 180 + 170).SetVisible(false);
			progressBar = AddProgress("", "GuiCreateEquipment_Bar_Eff", 394, 362);
			progressBar.SetBackGround("GuiCreateEquipment_ProgressBar_Bg");
			progressBar.setStatus(0);
			progressBar.visible = false;
			
			//Nguyen lieu yeu cau
			txtFormat = new TextFormat("arial", 16, 0xffff00, true);
			AddLabel("Nguyên Liệu Yêu Cầu", 438, 402, 0xffff00, 1, 0x000000).setTextFormat(txtFormat);
			listIngradient = AddListBox(ListBox.LIST_X, 1, 3, 20);
			listIngradient.setPos(302 + 15 + 44, 439 - 14);
			for (i = 0; i < 3 ; i++)
			{
				var itemIngradient:ItemIngradientRequire = new ItemIngradientRequire(listIngradient.img);
				//itemIngradient.SetScaleXY(1.3);
				listIngradient.addItem(i.toString(), itemIngradient);
			}
			txtFormat.size = 12;
			txtFormat.color = 0x990000;
			AddLabel("Chú ý: Nguyên liệu chế tạo có được từ tách đồ", 420, 433+ 90, 0xff0000, 1).setTextFormat(txtFormat);
			
			
			//Điểm tinh lực
			var ingradient:Object = GameLogic.getInstance().user.ingradient;
			//labelNumSpirit = AddLabel("", 435, 20 + 90, 0xffffff, 1, 0x000000);
			//txtFormat = new TextFormat("arial", 18, 0xffffff, true);
			//labelNumSpirit.defaultTextFormat = txtFormat;
			//if (ingradient != null && ingradient["PowerTinh"] != null)
			//{
				numSpirit = ingradient["PowerTinh"];
			//}
			//txtFormat.size = 14;
			//txtFormat.color = 0xffff00;
			//AddLabel("Điểm Tinh Lực", 410, 86, 0xffff00, 1, 0x000000).setTextFormat(txtFormat);
			//AddImage("", "PowerTinh", 535, 100).SetScaleXY(0.6);
			var btnBuySpirit:Button =  AddButton(BTN_BUY_SPIRIT, "GuiCreateEquipment_Btn_Buy_PowerTinh", 300 + 295 + 24, 20 + 90 + 359);
			btnBuySpirit.img.scaleX = btnBuySpirit.img.scaleY = 0.8;
			
			timer = new Timer(10, 1000);
			timer.addEventListener(TimerEvent.TIMER, runTime);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerComplete);
			
			//Mui ten huong dan
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if ((itemSkill.level == 1 && itemSkill.exp == 0) || curTutorial.search("CreateWeaponSkill") >= 0)
			{
				imageArrow = AddImage("", "IcHelper", 80, 252);
				imageArrow.img.rotation -= 90;
			}
		}
		
		private function timerComplete(e:TimerEvent):void 
		{
			//trace("complete");
			if (progressBar != null)
			{
				progressBar.visible = false;
			}
		}
		
		private function runTime(e:TimerEvent):void 
		{
			if (progressBar != null)
			{
				//trace(Number(timer.currentCount) / 20);
				if(progressBar.percent < 1)
				{
					progressBar.setStatus(progressBar.percent + 0.1);
				}
				else
				{
					timer.stop();
					progressBar.visible = false;
					if (isGetResult)
					{
						GetButton(BTN_GET).SetVisible(true);
					}
				}
			}
		}
		
		public function showGUI(_typeSkill:String, _levelSkill:int):void 
		{
			typeSkill = _typeSkill;
			levelSkill = _levelSkill;
			Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function OnHideGUI():void 
		{
			timer.stop();
			timer = null;
		}
		
		private function initTree(typeSkill:String, level:int):void 
		{
			tree = new Tree(treeBg.img, "");
			var arrFather:Array = [];
			var listChild:Array = [];
			var arrChild:Array;
			var i:int;
			var j:int;
			var name:String;
			var obj:Object;
			var rank:int;
			var config:Object = ConfigJSON.getInstance().GetItemList("CraftingEquip");
			var itemConfig:Object;
			var listJewel:Array;
			var h:int;
			switch(typeSkill)
			{
				case CREATE_WEAPON:
				case CREATE_ARMOR:
				case CREATE_HELMET:
					for (i = level; i >= 1; i--)
					{
						obj = new Object();
						obj["name"] = "Chế Tạo " + Localization.getInstance().getString(typeSkill) + " - Tầng " + i;
						obj["data"] = new Object();
						obj["data"]["level"] = i;
						obj["data"]["type"] = typeSkill;
						arrFather.push(obj);
						arrChild = [];
						itemConfig = config[typeSkill][i];
						rank = itemConfig["Rank"];
						for (j = 1; j <= 5; j++)
						{
							obj = new Object();
							obj["name"] = Localization.getInstance().getString(typeSkill + j + "0" + rank);
							obj["data"] = new Object();
							obj["data"]["level"] = i;
							obj["data"]["type"] = typeSkill;
							obj["data"]["element"] = j;
							arrChild.push(obj);
						}
						listChild.push(arrChild);
					}
					break;
				case CREATE_JEWEL:
					for (i = level; i >= 1; i--)
					{
						obj = new Object();
						obj["name"] = "Chế Tạo Trang Sức - Tầng " + i;
						obj["data"] = new Object();
						obj["data"]["level"] = i;
						obj["data"]["type"] = "Jewel";
						arrFather.push(obj);
						arrChild = [];
						
						listJewel = ["Ring", "Necklace", "Bracelet", "Belt"];
						for (h = 0; h < listJewel.length; h++)
						{
							itemConfig = config[listJewel[h]][i];
							rank = itemConfig["Rank"];
							obj = new Object();
							obj["name"] = Localization.getInstance().getString(listJewel[h] + rank);
							obj["data"] = new Object();
							obj["data"]["level"] = i;
							obj["data"]["type"] = listJewel[h];
							arrChild.push(obj);
						}
						
						listChild.push(arrChild);
					}
					break;
				case CREATE_MAGIC:
					var listType:Array = ["Weapon", "Armor", "Helmet", "Jewel"];
					for (i = level; i >= 1; i--)
					{
						obj = new Object();
						obj["name"] = "Chế Tạo " + Localization.getInstance().getString(typeSkill) + " - Tầng " + i;
						obj["data"] = new Object();
						obj["data"]["level"] = i;
						obj["data"]["type"] = typeSkill;
						arrFather.push(obj);
						
						arrChild = [];
						for (var k:int = 0; k < listType.length; k++)
						{
							var type:String = listType[k];
							
							if (type != "Jewel")
							{
								itemConfig = config[type][i];
								rank = itemConfig["Rank"];
								for (j = 1; j <= 5; j++)
								{
									obj = new Object();
									obj["data"] = new Object();
									obj["data"]["level"] = i;
									obj["data"]["type"] = type;
									obj["name"] = Localization.getInstance().getString(type + j + "0" + rank);
									obj["data"]["element"] = j;
									arrChild.push(obj);
								}
							}
							else
							{
								listJewel = ["Ring", "Necklace", "Bracelet", "Belt"];
								for (h = 0; h < listJewel.length; h++)
								{
									itemConfig = config[listJewel[h]][i];
									rank = itemConfig["Rank"];
									obj = new Object();
									obj["name"] = Localization.getInstance().getString(listJewel[h] + rank);
									obj["data"] = new Object();
									obj["data"]["level"] = i;
									obj["data"]["type"] = listJewel[h];
									arrChild.push(obj);
								}
							}
						}
						listChild.push(arrChild);
					}
					break;
			}
			
			tree.initTree(arrFather, listChild);
			TreeNode(tree.listNode[0]).setClose(false);
			tree.IdObject = CTN_TREE;
			treeBg.AddContainer2(tree, 0, 0, this);
			
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0xffff00);
			mask.graphics.drawRect(-10, -10, tree.img.width + 12, 279);
			mask.graphics.endFill();
			treeBg.img.addChild(mask);
			tree.img.mask = mask;
			
			if (tree.img.height > 270)
			{
				scrollBar = this.AddScroll("", "GuiCreateEquipment_ScrollBarExtendDeco", 230, 200);
				scrollBar.setScrollImage(tree.img, 0, 270);
				scrollBar.img.scaleX = scrollBar.img.scaleY = 0.8;
			}
		}
		
		public function get numSpirit():int 
		{
			return _numSpirit;
		}
		
		public function set numSpirit(value:int):void 
		{
			_numSpirit = value;
			//labelNumSpirit.text = Ultility.StandardNumber(value);
		}
		
		public function updateNumSpirit():void
		{
			//Tong so tinh luc
			var ingradient:Object = GameLogic.getInstance().user.ingradient;
			if (ingradient != null && ingradient["PowerTinh"] != null)
			{
				numSpirit = ingradient["PowerTinh"];
			}
			
			//So tinh luc o nguyen lieu
			GetButton(BTN_CREATE).SetEnable(true); 
			var check:Boolean = true;
			for each(var itemIngradient:ItemIngradientRequire in listIngradient.itemList)
			{
				if (itemIngradient.itemType == "PowerTinh")
				{
					itemIngradient.num = ingradient[itemIngradient.itemType];
				}
				if (itemIngradient.num < itemIngradient.numRequire)
				{
					GetButton(BTN_CREATE).SetEnable(false);
				}
				if (itemIngradient.itemType != null)
				{
					check = false;
				}
			}
			
			if (check)
			{
				GetButton(BTN_CREATE).SetEnable(false); 
			}
			
			/*if(curNode != null)
			{
				onClickTreeNode(curNode);
			}*/
		}
		
		/**
		 * Hiện kết quả chế đồ từ server
		 * @param	equip
		 */
		public function showResult(equip:Object):void 
		{
			isGetResult = true;
			if(progressBar.percent < 1)
			{
				if(progressBar.percent < 0.7)
				{
					//progressBar.setStatus(0.7);
				}
			}
			else
			{
				GetButton(BTN_GET).SetVisible(true);
			}
			
			var newEquip:FishEquipment = new FishEquipment();
			newEquip.SetInfo(equip);
			GameLogic.getInstance().user.UpdateEquipmentToStore(newEquip);
			
			var guiChooseEquipment:GUIChooseEquipment = GuiMgr.getInstance().GuiChooseEquipment;
			if (guiChooseEquipment.IsVisible)
			{
				guiChooseEquipment.ItemList.push(newEquip);
				guiChooseEquipment.ShowTab(guiChooseEquipment.curTab);
			}
			
			for each(var itemEquip:ItemEquip in listEquip.itemList)
			{
				if (itemEquip.itemColor != equip["Color"])
				{
					itemEquip.showEffFail();
				}
				else
				{
					itemEquip.equip = newEquip;
					itemEquip.showEffSuccess();
				}
			}
			//GetButton(BTN_GET).SetVisible(true);
		}
	}

}