package GUI.FishWorld 
{
	import adobe.utils.CustomActions;
	import com.bit101.components.Text;
	import com.flashdynamix.utils.SWFProfiler;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Effect.ImageEffect;
	import Effect.ImgEffectFly;
	import Effect.SwfEffect;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.FishWorld.FishWorldController;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import GUI.GUIShop;
	import Logic.FallingObject;
	import Logic.Fish;
	import GUI.FishWar.FishEquipment;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.GameMode;
	import Logic.LayerMgr;
	import Logic.QuestMgr;
	import Logic.StockThings;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.SendAttackFriendLake;
	import NetworkPacket.PacketSend.SendBuyOther;
	import NetworkPacket.PacketSend.SendUseItemSoldier;
	import GUI.component.ProgressBar;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIFishWarBoss extends BaseGUI 
	{
		private static const BUTTON_CLOSE:String = "ButtonClose";
		private static const BUTTON_WAR:String = "ButtonWar";
		private static const BUTTON_NEXT:String = "ButtonNext";
		private static const BUTTON_BACK:String = "ButtonBack";
		private static const BUTTON_NEXT_GEM:String = "ButtonNextGem";
		private static const BUTTON_BACK_GEM:String = "ButtonBackGem";
		private static const BUTTON_CANCEL:String = "ButtonCancel";
		private static const BUTTON_G:String = "ButtonG";
		private static const BUTTON_ITEM_SAMURAI_1:String = "Item_Samurai_1";
		private static const BUTTON_ITEM_SAMURAI_2:String = "Item_Samurai_2";
		private static const BUTTON_ITEM_SAMURAI_3:String = "Item_Samurai_3";
		private static const BUTTON_ITEM_RESISTANCE:String = "Item_Resistance_1";
		private static const BUTTON_ITEM_BUFF_EXP:String = "Item_BuffExp_1";
		private static const BUTTON_ITEM_BUFF_MONEY:String = "Item_BuffMoney_1";
		private static const BUTTON_ITEM_STORE_RANK:String = "Item_StoreRank_1";
		private static const BUTTON_ITEM_BUFF_RANK:String = "Item_BuffRank_1";
		private static const PRG_HP:String = "ProgressBar_HP";
		private static const PRG_DAMAGE:String = "ProgressBar_Damage";
		private static const PRG_DEFENCE:String = "ProgressBar_Defence";
		private static const PRG_CRITICAL:String = "ProgressBar_Critical";
		private static const CTN_RATIO:String = "ContainerRatio";
		private static const CTN_KHAC:String = "CtnKhac";
		private static const CTN_SLOT_GEM:String = "CtnSlotGem_";
		private static const CTN_PRG_RANK:String = "CtnPrgRank_";
		public static const IMG_CUR_FISH_SOLDIER:String = "ImgCurFishSoldier";
		private static const ItemNameArr:Array = ["Samurai", "Resistance", "BuffExp", "BuffMoney", "BuffRank", "StoreRank"];
		private static const GiftNameArr:Array = ["ItemCollection", "Gem", "IcRank"];
		
		private var myDmg:TextField;
		private var myCrit:TextField;
		private var myDef:TextField;
		private var myVita:TextField;
		
		public var myFish:FishSoldier;
		
		public var myFishImg:Image;
		
		public var myItemUsedList:Container;
		
		public var SupportList:Array = new Array();
		
		public var isResistance:Boolean = false;
		public var ItemUse:Array;
		
		public var MaxPage:int;
		public var CurrentPage:int;
		
		private var arrFishSoldier:Array;
		
		public function GUIFishWarBoss(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFishWarBoss";
		}
		
		public override function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				SetPos(12, 12);
				
				AddButton(BUTTON_CLOSE, "BtnThoat", 752, 20);
				AddButton(BUTTON_WAR, "GuiFishWarBoss_BtnFight", 307, 345);
				
				AddButton(BUTTON_BACK, "GuiFishWarBoss_BtnBackFishSoldier", 268, 292);
				AddButton(BUTTON_NEXT, "GuiFishWarBoss_BtnNextFishSoldier", 437, 292);
				
				myItemUsedList = AddContainer("", "GuiFishWarBoss_ImgFrameFriend", 320, 116);
				InitItemUsed(myFish.BuffItem);
				ShowMyItemUsed(SupportList);
				
				ShowItemSupport(SupportList);
				
				CalculateRatios();
				
				ShowFish(myFish);			//UpdateEquipment(myFish.img, myFish);
				
				InitGemCanUse(CurrentPage);
				
				InitPrg();
			}
			LoadRes("GuiFishWarBoss_Theme");
		}
		
		public function Init(mfish:FishSoldier):void
		{
			ClearComponent();
			
			arrFishSoldier = Ultility.GetFishSoldierCanWar();
			
			myDef = null;
			myCrit = null;
			myDmg = null;
			myVita = null;
			
			myFish = mfish;
			myFish.UpdateBonusEquipment();
			myFish.UpdateCombatSkill();
			ItemUse = [];
			
			isResistance = false;
			if (myFish && myFish.isResistance)
			{
				isResistance = true;
			}
			
			//Item Support
			SupportList.splice(0, SupportList.length);
			SupportList = ConfigJSON.getInstance().GetBuffItemList();
			var i:int;
			for (i = 0; i < SupportList.length; i++)
			{
				if (SupportList[i]["Type"] == "Dice")
				{
					SupportList.splice(i, 1);
					i--;
				}
			}
			
			for (i = 0; i < SupportList.length; i++)
			{
				var num:int = GameLogic.getInstance().user.GetStoreItemCount(SupportList[i]["Type"], SupportList[i]["Id"]);
				SupportList[i]["Count"] = num;
				SupportList[i]["Used"] = 0;
				//ItemUse.push(new Object());
			}
			
			this.Show(Constant.GUI_MIN_LAYER, 6);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			//super.OnButtonClick(event, buttonID);
			var i:int = 0;
			var index:int;
			switch (buttonID) 
			{
				case BUTTON_CLOSE:
				case BUTTON_CANCEL:
					Hide();
					GameLogic.getInstance().SetMode(GameMode.GAMEMODE_WAR);
					UpdateEffectGem();
					if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)
					{
						GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
					}
					//RemoveListGem();
				break;
				case BUTTON_WAR:
					var EnergyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillBoss");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillBoss"];
					if (GameLogic.getInstance().user.GetEnergy() < EnergyCost)
					{
						//trace("Thiếu năng lượng");
						GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 1);
						return;
					}
					for (i = 0; i < arrFishSoldier.length; i++) 
					{
						if (arrFishSoldier[i].Status == FishSoldier.STATUS_HEALTHY)
						{
							GuiMgr.getInstance().GuiMainFishWorld.StartKillBoss();
							Hide();
							UpdateEffectGem();
							return;
						}
					}
					
					GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg28"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					
					Hide();
				break;
				case BUTTON_NEXT_GEM:
					if (CurrentPage < MaxPage)
					{
						RemoveListGem();
						InitGemCanUse(CurrentPage +1);
					}
				break;
				case BUTTON_BACK_GEM:
					if (CurrentPage > 0)
					{
						RemoveListGem();
						InitGemCanUse(CurrentPage - 1);
					}
				break;
				case BUTTON_NEXT:
					index = arrFishSoldier.indexOf(myFish);
					var fn:FishSoldier;
					if (index < arrFishSoldier.length - 1)
					{
						fn = arrFishSoldier[index + 1];
						myFish = null;
						Init(fn);
					}
				break;
				case BUTTON_BACK:
					index = arrFishSoldier.indexOf(myFish);
					var fb:FishSoldier;
					if (index > 0)
					{
						fb = arrFishSoldier[index - 1];
						myFish = null;
						Init(fb);
					}
				break;
				
				default:
					var a:Array = buttonID.split("_");
					if (a[0] == "BtnG")
					{
						for (i = 0; i < SupportList.length; i++)
						{
							if ((SupportList[i]["Type"] == a[1]) && (SupportList[i]["Id"] == a[2]))
							{
								break;
							}
						}
						
						if (SupportList[i]["Count"] == 0)
						{
							if (SupportList[i]["ZMoney"] > GameLogic.getInstance().user.GetZMoney())
							{
								GuiMgr.getInstance().GuiNapG.Init();
							}
							else
							{
								ProcessBuyItem(buttonID);
							}
						}
						else
						{
							ProcessUseItem(buttonID);
						}
					}
					else if (a[0] == "CtnSlotGem" && a[1] == "Use" && String(a[2]).split("$")[0] == "Gem")
					{
						DoUseGem(a[2], int(a[3]), GetContainer(buttonID).img);
					}
				break;
			}
		}
		
		public function UpdateEffectGem():void 
		{
			var arr:Array = GameLogic.getInstance().user.FishSoldierActorMine;
			var i:int = 0;
			for (i = 0; i < arr.length; i++)
			{
				if(arr[i].GemEffect && arr[i].GemEffect.parent != arr[i].aboveContent)
				{
					arr[i].GemEffect.parent.removeChild(arr[i].GemEffect);
					arr[i].GemEffect = null;
					arr[i].addGemEffect(true);
				}
			}
		}
		
		private function InitPrg():void 
		{
			var ctn:Container = AddContainer(CTN_PRG_RANK, "GuiFishWarBoss_CtnInfoRank", 505, 140);
			var prg:ProgressBar = ctn.AddProgress("", "GuiFishWarBoss_PrgRank", 85, 29, null, true);
			prg.setStatus(myFish.RankPoint / myFish.MaxRankPoint);
			//prg.setStatus(1);
			ctn.AddLabel(Ultility.StandardNumber(Math.floor(myFish.RankPoint)) + "/" + Ultility.StandardNumber(myFish.MaxRankPoint), 95, 27, 0x000000, 1, 0xffffff);
			var rankName:String;
			if (myFish.Rank > 13)
			{
				rankName = "Rank13";
			}
			else
			{
				rankName = "Rank" + myFish.Rank;
			}
			ctn.AddImage("", rankName, 32, 32);
			
			ctn.AddLabel("Cấp " + myFish.Rank + " - " + Localization.getInstance().getString("FishSoldierRank" + myFish.Rank), 90, 8, 0xFFF100, 1, 0x603813);
			ctn.AddImage("", "IcRank", 0, 0).FitRect(30, 30, new Point(60, 20));
			var toolTip:TooltipFormat = new TooltipFormat();
			toolTip.text = Localization.getInstance().getString("Tooltip71");
			toolTip.text = toolTip.text.replace("@Rank", Localization.getInstance().getString("FishSoldierRank" + myFish.Rank));
			toolTip.text = toolTip.text.replace("@Score", Ultility.StandardNumber(Math.floor(myFish.RankPoint)));
			ctn.setTooltip(toolTip);
		}
		
		private function UpdateButtonNextBack():void 
		{
			var index:int = arrFishSoldier.indexOf(myFish);
			if (arrFishSoldier.length <= 1)
			{
				GetButton(BUTTON_BACK).SetVisible(false);
				GetButton(BUTTON_NEXT).SetVisible(false);
			}
			else if(index == 0)
			{
				GetButton(BUTTON_BACK).SetEnable(false);
				GetButton(BUTTON_NEXT).SetEnable(true);
			}
			else if (index == (arrFishSoldier.length - 1))
			{
				GetButton(BUTTON_BACK).SetEnable(true);
				GetButton(BUTTON_NEXT).SetEnable(false);
			}
			
			
		}
		
		private function DoUseGem(Gem:String, id:int, parentEff:DisplayObject = null):void 
		{
			GuiMgr.getInstance().GuiStore.curItemId = id;
			GameLogic.getInstance().curItemUsed = Gem;
			var a:Array = GameLogic.getInstance().curItemUsed.split("$");
			
			if(int(a[1]) == FishSoldier.ELEMENT_WOOD)
			{
				// Eff không được dùng bay lên
				var str:String = Localization.getInstance().getString("Message37");	
				var posStart:Point = parentEff.localToGlobal(new Point(30, 70));
				var posEnd:Point = new Point(posStart.x, posStart.y - 70);
				Ultility.ShowEffText(str, parentEff, posStart, posEnd);
			}
			else 
			{
				myFish.processBuffGem(false);

				UpdateParamFish(myFish);
				InitGemCanUse(CurrentPage);
			}
		}
		
		/**
		 * Thực hiện xóa các 1 số thành phần để tránh lặp content
		 */
		private function RemoveListGem():void 
		{
			var i:int = 0;
			for (i = 0; i < ContainerArr.length; i++) 
			{
				var container:Container = ContainerArr[i] as Container;
				if(container.IdObject.search(CTN_SLOT_GEM) >= 0)
				{
					container.Destructor();
					ContainerArr.splice(i, 1);
					i--;
				}
			}
			
			
			// all button
			for (i = 0; i < ButtonArr.length; i++)
			{
				var btn:Button = ButtonArr[i] as Button;
				if(btn.ButtonID == BUTTON_BACK_GEM || btn.ButtonID == BUTTON_NEXT_GEM)
				{
					btn.RemoveAllEvent();
					HelperMgr.getInstance().ClearHelper(btn.HelperName);
					img.removeChild(btn.img);
					btn.img = null;
					ButtonArr.splice(i, 1);
					i--;
				}
			}
		}
		
		/**
		 * Xử lý mua các item nếu như không có
		 * @param	buttonID
		 */
		public function ProcessBuyItem(buttonID:String):void
		{
			var ar:Array = buttonID.split("_");
			var i:int;
			// Gửi gói tin mua item
			var buy:SendBuyOther = new SendBuyOther();
			buy.AddNew(ar[1], ar[2], 1, "ZMoney");
			Exchange.GetInstance().Send(buy);
			
			// Update vào kho
			GuiMgr.getInstance().GuiStore.UpdateStore(ar[1], ar[2], 1);
			
			for (i = 0; i < SupportList.length; i++)
			{
				if ((SupportList[i]["Id"] == ar[2]) && (SupportList[i]["Type"] == ar[1]))
				{
					break;
				}
			}
			
			SupportList[i]["Count"] += 1;
			GameLogic.getInstance().user.UpdateUserZMoney( -SupportList[i]["ZMoney"]);
			ProcessUseItem(buttonID);
		}
		
		/**
		 * Hàm sử dụng các item bổ trợ
		 * @param	buttonID
		 */
		public function ProcessUseItem(buttonID:String):void
		{
			var arS:Array = buttonID.split("_");
			var i:int;
			var j:int;
			
			for (i = 0; i < SupportList.length; i++)
			{
				if ((SupportList[i]["Id"] == arS[2]) && (SupportList[i]["Type"] == arS[1]))
				{
					break;
				}
			}
			SupportList[i]["Used"] += 1;
			
			// Các hành động nếu không phải là item buffExp và BuffMOney
			if (arS[1] != "BuffExp" && arS[1] != "BuffMoney" && arS[1] != "BuffRank")
			{
				// Gửi gói tin
				var cmd:SendUseItemSoldier = new SendUseItemSoldier(myFish.LakeId, myFish.Id);
				cmd.SetItemList(arS[1], arS[2], 1, SupportList[i].Turn);
				Exchange.GetInstance().Send(cmd);
				
				var isBuffed:Boolean = false;
				if (!myFish.BuffItem)	myFish.BuffItem = new Array;
				for (j = 0; j < myFish.BuffItem.length; j++)
				{
					if (myFish.BuffItem[j].ItemType == arS[1] && myFish.BuffItem[j].ItemId == arS[2])
					{
						isBuffed = true;
						break;
					}
				}
				
				// Nếu đã từng buff item này vào con cá
				if (isBuffed)
				{
					// Nếu là item 1 turn
					if (SupportList[i].Turn == 1)
					{
						myFish.BuffItem[j].Num += 1;
					}
					else	// Item nhiều turn thì cộng dồn vào turn
					{
						myFish.BuffItem[j].Turn += SupportList[i].Turn;
					}
				}
				else	// Buff Item này lần đầu
				{
					// Thêm giá trị vào Mảng BuffItem
					var ob:Object = new Object();
					ob.ItemType = arS[1];
					ob.ItemId = arS[2];
					ob.Num = 1;
					ob.Turn = SupportList[i].Turn;
					myFish.BuffItem.push(ob);
				}
				
				// Cập nhật kho
				GuiMgr.getInstance().GuiStore.UpdateStore(arS[1], arS[2], -1);
			}
			
			if (SupportList[i]["Count"] > 0)
			{
				SupportList[i]["Count"] -= 1;
			
				var c:Container = GetContainer("Ctn_" + arS[1] + "_" + arS[2]);
				c.ClearComponent();
				DrawItem(c, SupportList[i]);
				
				// Tác dụng tức thì
				switch (arS[1])
				{
					// Tăng lực chiến
					case "Samurai":
						myFish.DamagePlus += SupportList[i]["Num"];
						myDmg.text = String(parseInt(myDmg.text) + SupportList[i]["Num"]);
						var ft:TextFormat = new TextFormat();
						ft.color = 0x00ff00;
						myDmg.setTextFormat(ft);
						break;
					// Tăng % quân hàm rơi ra
					case "BuffRank":
						break;
					// Tăng % exp rơi ra
					case "BuffExp":
						break;
					// Tăng % Tiền rơi ra
					case "BuffMoney":
						break;
					// Giữ quân hàm khi thua
					case "StoreRank":
						break;
					// Miễn kháng
					case "Resistance":
						isResistance = true;
						if (GetImage("Khac"))
						{
							GetImage("Khac").img.visible = false;
							//GetContainer(CTN_KHAC).SetVisible(false);
						}
						break;
				}
				
				CalculateRatios();
			}
			ShowMyItemUsed(SupportList);
		}
		
		/**
		 * Hàm tính toán 4 tỷ lệ (công thủ chí mạng máu)
		 */
		private function CalculateRatios():void
		{
			
		}
		
		private function ShowItemSupport(ItemList:Array):void
		{
			var x0:int = 60;
			var y0:int = 100;
			var dx:int = 90;
			var dy:int = 101;
			var maxRow:int = 4;
			//SupportList.sortOn("Type");
			SupportList.sortOn("Order", 1);
			for (var j:int = 0; j < SupportList.length; j++)
			{
				var Pos:Point = new Point();
				Pos.x = x0 + (int(j / maxRow)) * dx;
				Pos.y = y0 + (int(j % maxRow)) * dy;
				var ctn:Container = AddContainer("Ctn_" + SupportList[j]["Type"] + "_" + SupportList[j]["Id"], "GuiFishWarBoss_ImgBgItemFishWar", Pos.x, Pos.y, true, this);
				var toolTip:TooltipFormat = new TooltipFormat();
				toolTip.text = Localization.getInstance().getString(SupportList[j]["Type"] + SupportList[j]["Id"]);
				toolTip.text = toolTip.text.replace("@Value@", SupportList[j]["Num"] + "");
				var arr:Array = Localization.getInstance().getString(SupportList[j]["Type"] + SupportList[j]["Id"]).split("\n");
				var l:int = (arr[0] as String).length;
				var txtF:TextFormat = new TextFormat();
				txtF.size = 14;
				txtF.color = 0xff00ff;
				txtF.bold = true;
				toolTip.setTextFormat(txtF, 0, l);
				ctn.setTooltip(toolTip);
				DrawItem(ctn, SupportList[j]);
			}
		}
		
		/**
		 * Vẽ các item hỗ trợ chiến đấu
		 * @param	c		Container chứa
		 * @param	Ob		Thông tin của item
		 */
		private function DrawItem(c:Container, Ob:Object):void
		{
			c.AddImage("", Ob["Type"] + Ob["Id"], c.img.width / 2, c.img.height / 2, true, ALIGN_CENTER_CENTER).FitRect(50, 50, new Point(7, 5));
			//var btnG:Button = c.AddButton("BtnG_" + Ob["Type"] + "_" + Ob["Id"], "Btngreen", 5, 81, this);
			var btnG:Button = c.AddButton("BtnG_" + Ob["Type"] + "_" + Ob["Id"], "GuiFishWarBoss_BtnBuyG", -2, 67, this);
			var tl:TextField;
			var tf:TextFormat = new TextFormat();
			
			if (Ob["Count"] == 0)
			{
				var ImgG:Image = c.AddImage("", "IcZingXu", 65, 77);
				tl = c.AddLabel("Mua " + Ob["ZMoney"], 0, 67, 0x264904, 0);
				tf.size = 15;
				tf.color = 0x264904;
				tf.bold = true;
				tl.setTextFormat(tf);
				tl.defaultTextFormat = tf;
			}
			else
			{
				if (!Ob["Count"]) Ob["Count"] = 0;
				tl = c.AddLabel("Dùng", 10, 67, 0x264904, 0);
				tf.size = 15;
				tf.color = 0x264904;
				tf.bold = true;
				tl.setTextFormat(tf);
				tl.defaultTextFormat = tf;
			}
			c.AddLabel(String(Ob["Count"]), 5, 40, 0x000000, 1, 0xffffff);			
			
			// Item giá = 0 thì ko cho xài
			if (Ob.UnlockType == GUIShop.UNLOCK_TYPE_UNUSED)
			{
				btnG.SetDisable();
				var ttt:TooltipFormat = new TooltipFormat();
				ttt.text = "Sắp ra mắt";
				btnG.setTooltip(ttt);
			}
			
			if ((Ob["Used"] == Ob["MaxTimes"]) || (Ob["Type"] == "BuffExp") || (Ob["Type"] == "BuffMoney") || (Ob["Type"] == "BuffRank") || (Ob["Type"] == "StoreRank"))
			{
				btnG.SetDisable();
			}
		}
		
		// Ok
		/**
		 * Add ảnh cá và các chỉ số có liên quan (Công thủ chí mạng máu)
		 * @param	fish	:	Con cá cần hiện thông tin
		 */
		private function ShowFish(fish:FishSoldier):void
		{
			var a:Array;
			var Pos:Point;
			var image:Image;
			var ctn:Container;
			var ft:TextFormat;
			// Add cái element ở đây
			ctn = AddContainer("", "GuiFishWarBoss_CtnElement", 240, 95);
			ctn.AddImage("Element", "Element" + fish.Element, 13, 15, true, ALIGN_LEFT_TOP).SetScaleXY(1.3);
			ctn.GetImage("Element").FitRect(50, 50, new Point(10, 10));
			var ToolTip:TooltipFormat = new TooltipFormat();
			ToolTip.text = "Biểu tượng hệ " + Ultility.GetNameElement(fish.Element);
			ctn.setTooltip(ToolTip);
			
			UpdateParamFish(fish);
			
			if (fish.EquipmentList && fish.EquipmentList.Mask && fish.EquipmentList.Mask[0])
			{
				image = AddImage(IMG_CUR_FISH_SOLDIER, fish.EquipmentList.Mask[0].TransformName, 0, 0, true, ALIGN_LEFT_TOP);
			}
			else
			{
				image = AddImage(IMG_CUR_FISH_SOLDIER, Fish.ItemType + fish.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, 0, 0, true, ALIGN_LEFT_TOP);
			}
			UpdateEquipment(image.img, fish);
			myFish.addGemEffect(true, false);
			//var posX:Number = 365 - image.img.width / 2;
			//var posY:Number = image.img.height / 2;
			var scaleX:Number;
			var scaleY:Number;
			var scale:Number;
			if (myFish.GemEffect) 
			{
				scaleX = 200 / image.img.width;
				scaleY = 200 / image.img.height;
			}
			else
			{
				scaleX = 120 / image.img.width;
				scaleY = 120 / image.img.height;
			}
			scale = Math.min(scaleX, scaleY);
			image.SetScaleXY(scale);
			
			image.SetPos(365, 220);
			
			if (fish.DamagePlus > 0)
			{
				ft = new TextFormat();
				ft.color = 0x00ff00;
				myDmg.setTextFormat(ft);
			}
			else if (fish.DamagePlus < 0)
			{
				ft = new TextFormat();
				ft.color = 0xff0000;
				myDmg.setTextFormat(ft);
			}
			
			if (fish.CriticalPlus > 0)
			{
				ft = new TextFormat();
				ft.color = 0x00ff00;
				myCrit.setTextFormat(ft);
			}
			else if (fish.CriticalPlus < 0)
			{
				ft = new TextFormat();
				ft.color = 0xff0000;
				myCrit.setTextFormat(ft);
			}
			
			UpdateButtonNextBack();
		}
		
		private function UpdateParamFish(fish:FishSoldier):void 
		{
			// Các thông số của con cá cần show
			if (myDmg)
			{
				myDmg.parent.removeChild(myDmg);
				LabelArr.splice(LabelArr.indexOf(myDmg), 1);
			}
			myDmg = AddLabel(String(fish.getTotalDamage()), 590, 220, 0xFFFFFF, 0, 0x603813);
			
			if (myDef)
			{
				myDmg.parent.removeChild(myDef);
				LabelArr.splice(LabelArr.indexOf(myDef), 1);
			}
			myDef = AddLabel(String(fish.getTotalDefence()), 590, 248, 0xFFFFFF, 0, 0x603813);
			
			if(myCrit)
			{
				myDmg.parent.removeChild(myCrit);
				LabelArr.splice(LabelArr.indexOf(myCrit), 1);
			}
			myCrit = AddLabel(String(fish.getTotalCritical()), 590, 276, 0xFFFFFF, 0, 0x603813);
			if (myVita)
			{
				myDmg.parent.removeChild(myVita);
				LabelArr.splice(LabelArr.indexOf(myVita), 1);
			}
			myVita = AddLabel(String(fish.getTotalVitality()), 590, 304, 0xFFFFFF, 0, 0x603813);
		}
		
		private function UpdateEquipment(sp:Sprite, fish:FishSoldier):void
		{
			var i:int;
			var s:String;
			for (s in fish.EquipmentList)
			{
				for (i = 0; i < fish.EquipmentList[s].length; i++)
				{
					ChangeEquipment(fish.EquipmentList[s][i].Type, fish.EquipmentList[s][i].imageName, sp);
				}
				//Add effect Ngoc An
				if (s == "Seal")
				{
					var activeRowSeal:int = Ultility.getActiveRowSeal(fish.EquipmentList["Seal"][0], fish);
					if (activeRowSeal > 0)
					{
						var wings:Sprite = ResMgr.getInstance().GetRes("Wings" + fish.EquipmentList["Seal"][0]["Rank"] + activeRowSeal) as Sprite;
						
						switch(fish.Element)
						{
							case 4:
							case 2:
							case 1:
								wings.y = -30;
								wings.x = 16;
								break;
							case 3:
								wings.y = -40;
								wings.x = -16;
								break;
							case 5:
								wings.y = -25;
								wings.x = 20;
								break;
						}
						
						sp.addChild(wings);
						sp.setChildIndex(wings, 0);
					}
				}
			}
		}
		
		public function ChangeEquipment(Type:String, resName:String, sp:Sprite):void
		{
			if (resName == "")	return;
			
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(sp, Type);
			
			if (child != null)
			{
				var index:int = child.parent.getChildIndex(child);
				var eq:FishEquipment = new FishEquipment();
				eq.loadComp = function f():void
				{
					child.parent.addChildAt(eq.img, index).name = Type;
					child.parent.removeChild(child);
				}
				eq.loadRes(resName);
			}
			
		}
		/**
		 * Hàm vẽ các item mình đã sử dụng ra - Ok
		 * @param	a
		 */
		public function ShowMyItemUsed(a:Array):void
		{
			myItemUsedList.ClearComponent();
			var x0:int = 25;
			var y0:int = 30;
			var dx:int = 29;
			var index:int = 0;
			
			for (var i:int = 0; i < a.length; i++)
			{
				if (a[i]["Type"] != "Samurai" && a[i]["Used"] > 0)
				{
					myItemUsedList.AddImage("", a[i]["Type"] + a[i]["Id"], x0 + dx * index, y0).SetScaleXY(0.5);
					myItemUsedList.AddLabel(a[i]["Used"], x0 + dx * index - 50,  y0 - 10, 0xFFF100, 1, 0x603813);
					index++;
				}
			}
		}
		
		private function InitItemUsed(List:Array):void
		{
			var i:int;
			var j:int;
			if(List)
			{
				for (i = 0; i < List.length; i++)
				{
					for (j = 0; j < SupportList.length; j++)
					{
						if (List[i].ItemType == SupportList[j].Type && List[i].ItemId == SupportList[j].Id)
						{
							SupportList[j].Used = List[i].Num;
						}
					}
				}
			}
		}
		
		
		/**
		 * KHởi tạo đan có thể sử dụng được
		 * @param	Type
		 * @param	page
		 */
		public function InitGemCanUse(page:int):void 
		{
			var MaxSlot:int = 5;
			var Type:String = "Gem";
			// lay danh sach cac slot
			var ItemList:Array = GameLogic.getInstance().user.GetStore(Type);
			if (ItemList.length <= 0)
			{
				var txtFormat:TextFormat = new TextFormat("Arial", 30, 0x707070);
				var txt:TextField = AddLabel(Localization.getInstance().getString("GUILabel147") , 360, 30);
				txt.setTextFormat(txtFormat);
			}
			
			// Nếu là kho Gem thì lược bớt Phế và Tán không show ra
			for (i = ItemList.length - 1; i >= 0; i--)
			{
				var GemType:int = int(ItemList[i].ItemType.split("$")[2]);
				if (ItemList[i].Id <= 0 || GemType == 0)
				{
					ItemList.splice(i, 1);
				}
			}
			
			// so page toi da
			MaxPage = Math.ceil(ItemList.length / MaxSlot);
			CurrentPage = page;
			InitStoreButton();
			if (CurrentPage >= MaxPage) 
			{
				CurrentPage = MaxPage - 1;
			}
			if (CurrentPage < 0)
			{
				CurrentPage = 0;
			}
			
			// them cac thanh phan GUI
			var vt:int = CurrentPage * MaxSlot;	//Tổng số slot của n-1 trang trước
			var nItem:int = MaxSlot;	//Số slot lẻ ra ở trang hiện tại
			if (vt + nItem >= ItemList.length)
			{
				nItem = ItemList.length - vt;
			}
			InitStoreSlot(nItem);

			var obj:Object;
			var i:int = 0;
			for (i = vt; i < vt + nItem; i++)
			{	
				var container:Container = GetContainer(CTN_SLOT_GEM + (i - vt));	
				var st:StockThings = new StockThings();
				st.SetInfo(ItemList[i]);
				obj = ConfigJSON.getInstance().getItemInfo(st.ItemType, st.Id);
				container.IdObject = CTN_SLOT_GEM + "Use_" + obj["type"] + "_"  + obj[ConfigJSON.KEY_ID];
				DrawItemGem(container, obj, st.Num);
			}
		}
		
		public function InitStoreSlot(nSlot:int):void
		{
			var icon:Sprite = ResMgr.getInstance().GetRes( "GuiFishWarBoss_CtnSlotGemBoss") as Sprite;
			var w:int = icon.width + 5;
			var h:int = icon.height;
			var MaxSlot:int = 5;
			
			var i:int;
			var container:Container;
			for (i = 0; i < nSlot; i++)
			{
				if (i >= MaxSlot)
				{
					break;
				}
				container = AddContainer(CTN_SLOT_GEM + i, "GuiFishWarBoss_CtnSlotGemBoss", 265 + i * w, 418, true, this);
			}
		}
		
		private function DrawItemGem(container:Container, obj:Object, num:int):void
		{
			var icon:Sprite = ResMgr.getInstance().GetRes( "GuiFishWarBoss_CtnSlotFishWorld") as Sprite;
			var w:int = icon.width;
			var h:int = icon.height;
			var img1:Image;
			var st:String ;
			var tooltip:TooltipFormat;
			var fmt:TextFormat;
			var str:String ;
			var _format:TextFormat ;
			_format = new TextFormat();
			_format.color = 0xFF0000;
			_format.size = 14;
			_format.bold = true;
			var iEnd:int;
			
			img1 = DrawOther(container, obj);
			img1.FitRect(w - 5, h - 5, new Point(3, 0));
			tooltip = new TooltipFormat();
			var aa:Array = obj["type"].split("$");
			str = Localization.getInstance().getString(aa[0] + aa[1]);
			
			str = str.replace("@Type@", Localization.getInstance().getString("GemType" + aa[2]));
			
			str = str.replace("@Rank@", "cấp " + aa[2]);
			
			var config:Object = ConfigJSON.getInstance().GetItemList("Gem");
			var value:int = config[aa[2]][aa[1]];
			str = str.replace("@value@", String(value));
			str = str.replace("@day@", obj["Id"]);
			tooltip.text = str;
			container.setTooltip(tooltip);
			
			var txtFormat:TextFormat = new TextFormat("Arial", 16);
			var txt:TextField = container.AddLabel(num.toString(), 3, 2, 0xFFFFFF, 0, 0x26709C);
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.setTextFormat(txtFormat);
		}
		
		private function DrawOther(container:Container, obj:Object):Image
		{
			var img1:Image;
			var imgName:String;
			var fmt:TextFormat = new TextFormat();
			imgName = getImgName(obj);//obj["type"] + obj[ConfigJSON.KEY_ID];
			img1 = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);
			
			var btn:Button;
			var a:Array = obj["type"].split("$");
			if (a[0] == "Gem" && int(a[2]) != 0 && obj["Id"] != 0)
			{
				fmt = new TextFormat();
				fmt.bold = true;
				fmt.color = 0xffffff;
				//btn = container.AddButton(CTN_SLOT_GEM + "Use_" + obj["type"] + "_" + obj[ConfigJSON.KEY_ID], "BtnBuyG", 8, 80, this);
				btn = container.AddButton("", "GuiFishWarBoss_BtnBuyG", 8, 80, this);
				container.AddLabel("Dùng", -5, 80).setTextFormat(fmt);
			}
					
			return img1;
		}
		
		private function getImgName(obj:Object): String
		{
			var image_Name_return:String = obj["type"] + obj[ConfigJSON.KEY_ID];
			if (obj["type"].search("Gem") != -1)
			{
				var a:Array = obj["type"].split("$");
				image_Name_return = "Gem_" + a[1] + "_" + a[2];
			}					
			return image_Name_return;
		}
		
		// Update State Các button
		private function InitStoreButton():void
		{	
			var btnNext:Button = AddButton(BUTTON_NEXT_GEM, "GuiFishWarBoss_BtnNextFishSoldier", 718, 450, this);
			var btnBack:Button = AddButton(BUTTON_BACK_GEM, "GuiFishWarBoss_BtnBackFishSoldier", 237, 450, this);
			
			if (MaxPage > 1)
			{
				if (CurrentPage == 0)
				{
					btnBack.SetDisable();
				}
				if (CurrentPage == MaxPage - 1)
				{
					btnNext.SetDisable();
				}
			}
			else
			{
				btnBack.SetVisible(false);
				btnNext.SetVisible(false);
			}
		}
	}

}