package GUI.FishWar 
{
	import adobe.utils.CustomActions;
	import com.bit101.components.Text;
	import com.flashdynamix.utils.SWFProfiler;
	import com.greensock.easing.Cubic;
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
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.FishWorld.FishWorldController;
	import GUI.FishWorld.Network.SendAttackWorld;
	import GUI.FishWorld.SubBossIce;
	import GUI.FishWorld.SubBossMetal;
	import GUI.GUIMessageBox;
	import GUI.GuiMgr;
	import GUI.GUIShop;
	import Logic.FallingObject;
	import Logic.Fish;
	import GUI.FishWar.FishEquipment;
	import Logic.FishSoldier;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.QuestMgr;
	import Logic.Ultility;
	import Logic.User;
	import NetworkPacket.PacketSend.SendAttackFriendLake;
	import NetworkPacket.PacketSend.SendBuyOther;
	import NetworkPacket.PacketSend.SendUseItemSoldier;
	import GUI.component.ProgressBar;
	import particleSys.myFish.CometEmit;
	
	/**
	 * GUI hiển thị thông tin trước khi chọi cá và chọn item...
	 * @author longpt
	 */
	public class GUIFishWar extends BaseGUI 
	{
		public static const BUTTON_CLOSE:String = "ButtonClose";
		public static const BUTTON_WAR:String = "ButtonWar";
		public static const BUTTON_CANCEL:String = "ButtonCancel";
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
		private static const ItemNameArr:Array = ["Samurai", "Resistance", "BuffExp", "BuffMoney", "BuffRank", "StoreRank"];
		private static const GiftNameArr:Array = ["ItemCollection", "Gem", "IcRank"];
		
		public var myDmg:TextField;
		public var myCrit:TextField;
		public var myVit:TextField;
		public var myDef:TextField;
		
		public var theirDmg:TextField;
		public var theirCrit:TextField;
		public var theirVit:TextField;
		public var theirDef:TextField;
		
		public var prgDmg:ProgressBar;
		public var prgDef:ProgressBar;
		public var prgCrit:ProgressBar;
		public var prgHP:ProgressBar;
		
		public var myFish:FishSoldier;
		public var theirFish:FishSoldier;
		
		public var myFishImg:Image;
		public var theirFishImg:Image;
		
		public var myItemUsedList:Container;
		public var theirItemUsedList:Container;
		
		public var SupportList:Array = new Array();
		
		public var isResistance:Boolean = false;
		public var ItemUse:Array;
		
		public var AtkTime:int;
		public var ResultTime:int;
		public var NumCombo:int;
		
		public var myAllDmg:int;
		public var theirAllDmg:int;
		
		public var myAllDef:int;
		public var theirAllDef:int;
		
		public var myAllCrit:int;
		public var theirAllCrit:int;
		
		public var myAllHP:int;
		public var theirAllHP:int;
		
		public var myElementNote:TextField;
		public var theirsElementNote:TextField;
		
		public var emitStar:Array = [];
		public var isEffecting:Boolean = false;
		
		public function GUIFishWar(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFishWar";
		}
		
		public override function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				SetPos(12, 12);
				
				if ((myFish && myFish.isResistance) || (theirFish && theirFish.isResistance))
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
				
				myItemUsedList = AddContainer("", "GuiFishWar_ImgFrameFriend", 285, 477);
				InitItemUsed(myFish.BuffItem);
				ShowMyItemUsed(SupportList);
				
				theirItemUsedList = AddContainer("", "GuiFishWar_ImgFrameFriend", 715, 477);
				ShowTheirItemUsed(theirFish.BuffItem);
				
				ShowItemSupport(SupportList);
				ShowGiftCanClaim();

				//CalculateWinRatio();
				CalculateRatios();
				
				ShowFish(myFish, true);			//UpdateEquipment(myFish.img, myFish);
				ShowFish(theirFish, false);		//UpdateEquipment(theirFish.img, theirFish);
				
				AddButton(BUTTON_CLOSE, "BtnThoat", 752, 20);
				AddButton(BUTTON_WAR, "GuiFishWar_BtnFight", 432, 340);
				
				var counter:int = checkCounter(myFish, theirFish);
				if (counter != 0 && !isResistance)
				{
					var imaggg:Image = AddImage("CounterArrow", "GuiFishWar_CounterArrow", 485, 139);
					imaggg.SetScaleX( -counter / Math.abs(counter));
					imaggg.FitRect(100, 100, new Point(435, 95));
					AddImage("Khac", "GuiFishWar_TxtCounter", 485, 145);
				}
				else
				{
					AddImage("", "GuiFishWar_Ic_Vs", 485, 139);
				}
			}
			
			LoadRes("GuiFishWar_Theme");
		}
		
		public function Init(mfish:FishSoldier, tfish:FishSoldier):void
		{
			myFish = mfish;
			myFish.UpdateBonusEquipment();
			myFish.UpdateCombatSkill();
			
			//theirFish = GameLogic.getInstance().user.CurSoldier[1];
			theirFish = tfish;
			theirFish.UpdateBonusEquipment();
			theirFish.UpdateCombatSkill();
			
			ItemUse = [];
			isResistance = false;
			
			ClearComponent();
			this.Show(Constant.GUI_MIN_LAYER, 6);
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
		
		public function ShowGiftCanClaim():void
		{
			// Phần thưởng thường
			var x0:int = 320;
			var y0:int = 464;
			var dx:int = 53;
			var dy:int = 0;
			var tf:TooltipFormat;
			
			var n:int = 3;
			var isOceanForest:Boolean = false;
			if (FishWorldController.GetSeaId() == Constant.OCEAN_FOREST)	isOceanForest = true;
			//if (isOceanForest)	n = 2;
			for (var i:int = 0; i < n; i++)
			{
				var ctn:Container = AddContainer("Bonus_" + GiftNameArr[i], "GuiFishWar_ImgFrameFriend", x0 + i * dx, y0 + i * dy);
				var im:Image = ctn.AddImage("", "GuiFishWar_ImgBgGiftNormal", 0, 0);
				im.img.scaleX = 0.8;
				im.img.scaleY = 0.8;
				
				var giftImgName:String = GiftNameArr[i];
				if (GiftNameArr[i] == "ItemCollection")
				{
					if (Ultility.IsInMyFish())
					{
						ctn.AddImage("", "GuiFishWar_TemDefault", 1, 1).FitRect(45, 45, new Point( -27, -27));
					}
					else
					{
						switch (FishWorldController.GetSeaId()) 
						{
							case Constant.OCEAN_NEUTRALITY:
								ctn.AddImage("", "GuiFishWar_LeDefault", 1, 1).FitRect(45, 45, new Point( -27, -27));
							break;
							case Constant.OCEAN_METAL:
								ctn.AddImage("", "GuiFishWar_DuoiDefault", 1, 1).FitRect(45, 45, new Point( -27, -27));
							break;
							case Constant.OCEAN_ICE:
								ctn.AddImage("", "GuiFishWar_CotDefault", 1, 1).FitRect(45, 45, new Point( -27, -27));
							break;
							case Constant.OCEAN_FOREST:
								ctn.AddImage("", "IcGold", 1, 1).FitRect(45, 45, new Point( -27, -27));
							break;
						}
					}
				}
				else if (GiftNameArr[i] == "Gem")
				{
					if(!isOceanForest)
					{
						var cfg:Array = ConfigJSON.getInstance().GetItemList("RankPoint")[theirFish.Rank]["Gem"];
						giftImgName += "_" + theirFish.Element + "_" + cfg[cfg.length - 1].GemId;
						ctn.AddImage("", giftImgName, 1, 1).FitRect(45, 45, new Point( -27, -27));
					}
					else
					{
						ctn.AddImage("", "IcExp", 1, 1).FitRect(45, 45, new Point( -27, -27));
					}
				}
				else
				{
					if(!isOceanForest)
						ctn.AddImage("", giftImgName, 1, 1).FitRect(45, 45, new Point( -27, -27));
				}
				
				switch (GiftNameArr[i])
				{
					case "ItemCollection":
						tf = new TooltipFormat();
						tf.text = "Bộ sưu tập";
						if(isOceanForest)	tf.text = "Tiền vàng";
						break;
					case "Gem":
						tf = new TooltipFormat();
						if(isOceanForest)	tf.text = "Kinh nghiệm";
						else	tf.text = Localization.getInstance().getString("Element" + theirFish.Element) + " " + Localization.getInstance().getString("GemType" + cfg[cfg.length - 1].GemId) + " cấp " + cfg[cfg.length - 1].GemId;
						break;
					case "IcRank":
						tf = new TooltipFormat();
						tf.text = "Điểm chiến công";
						break;
				}
				ctn.setTooltip(tf);
			}
			
			// Phần thưởng đặc biệt
			var con:Container = AddContainer("", "GuiFishWar_ImgBgGiftSpecial", 555, 428);
			var tt:TooltipFormat = new TooltipFormat();
			if(!isOceanForest)
			{
				con.AddImage("", "GuiFishWar_FormulaDefaultPaper", 0, 0).FitRect(50, 50, new Point(4, 4));
				tt.text = "Công thức lai Ngư thủ";	
			}
			else
			{
				con.AddImage("", "Gem7", 0, 0).FitRect(50, 50, new Point(4, 4));
				tt.text = "Đan cấp 7";	
			}
			con.setTooltip(tt);
		}
		
		public function ShowFish(fish:FishSoldier, isMyFish:Boolean):void
		{
			var str:String;
			var a:Array;
			var Pos:Point;
			var tf:TextField;
			var image:Image;
			var ctn:Container;
			var ft:TextFormat;
			var tt:TooltipFormat;
			var counter:int = checkCounter(myFish, theirFish);
			if (isMyFish)
			{
				// Add cái element ở đây
				ctn = AddContainer("", "GuiFishWar_CtnElement", 340, 110);
				ctn.AddImage("", "Element" + fish.Element, 15, 15, true, ALIGN_LEFT_TOP).SetScaleXY(1.3);
				tt = new TooltipFormat();
				tt.text = "Hệ " + Localization.getInstance().getString("Element" + fish.Element);
				ctn.setTooltip(tt);
				
				// Nếu khắc hệ (hoặc bị khắc hệ thì add thêm thông số dc cộng (trừ)
				var dameEnviroment:int = FishWorldController.GetValueOfEnviroment(myFish);
				if ((counter != 0 && !isResistance) || dameEnviroment != 0)
				{
					if (myAllDmg - (myFish.getTotalDamage()) + dameEnviroment > 0)
					{
						myElementNote = AddLabel("Tăng Công: " + Math.abs(myAllDmg - (myFish.getTotalDamage()) + dameEnviroment), 326, 170, 0xffffff, 1, 0x000000);
					}
					else
					{
						myElementNote = AddLabel("Giảm Công: " + Math.abs(myAllDmg - (myFish.getTotalDamage()) + dameEnviroment), 326, 170, 0xffffff, 1, 0x000000);
					}
				}
				myDmg = AddLabel((myAllDmg + dameEnviroment).toString(), 305, 203, 0xFFFFFF, 2, 0x603813);
				myDef = AddLabel(String(fish.getTotalDefence()), 305, 238, 0xFFFFFF, 2, 0x603813);
				myCrit = AddLabel(String(fish.getTotalCritical()), 305, 273, 0xFFFFFF, 2, 0x603813);
				myVit = AddLabel(String(fish.getTotalVitality()), 305, 308, 0xFFFFFF, 2, 0x603813);
				
				Pos = new Point(420, 270);
				
				if (fish.EquipmentList && fish.EquipmentList.Mask && fish.EquipmentList.Mask[0])
				{
					image = AddImage("", fish.EquipmentList.Mask[0].TransformName, Pos.x, Pos.y, true, ALIGN_CENTER_TOP);
				}
				else
				{
					image = AddImage("", Fish.ItemType + fish.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, Pos.x, Pos.y, true, ALIGN_CENTER_TOP);
					UpdateEquipment(image.img, fish);
				}
				//UpdateEquipment(image.img, fish);
				
				if (fish.DamagePlus + dameEnviroment > 0)
				{
					ft = new TextFormat();
					ft.color = 0x00ff00;
					myDmg.setTextFormat(ft);
				}
				else if (fish.DamagePlus + dameEnviroment < 0)
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
				
				if (fish.VitalityPlus > 0)
				{
					ft = new TextFormat();
					ft.color = 0x00ff00;
					myVit.setTextFormat(ft);
				}
				else if (fish.VitalityPlus < 0)
				{
					ft = new TextFormat();
					ft.color = 0xff0000;
					myVit.setTextFormat(ft);
				}
				
				if (fish.DefencePlus > 0)
				{
					ft = new TextFormat();
					ft.color = 0x00ff00;
					myDef.setTextFormat(ft);
				}
				else if (fish.DefencePlus < 0)
				{
					ft = new TextFormat();
					ft.color = 0xff0000;
					myDef.setTextFormat(ft);
				}
			}
			else
			{
				// Add cái element ở đây
				ctn = AddContainer("", "GuiFishWar_CtnElement", 560, 110);
				ctn.AddImage("", "Element" + fish.Element, 15, 15, true, ALIGN_LEFT_TOP).SetScaleXY(1.3);
				tt = new TooltipFormat();
				tt.text = "Hệ " + Localization.getInstance().getString("Element" + fish.Element);
				ctn.setTooltip(tt);
				
				// Nếu khắc hệ (hoặc bị khắc hệ thì add thêm thông số dc cộng (trừ)
				var dameEnviroment1:int = FishWorldController.GetValueOfEnviroment(theirFish);
				if ((counter != 0 && !isResistance) || dameEnviroment1 != 0)
				{
					if (theirAllDmg - (theirFish.getTotalDamage()) + dameEnviroment1 > 0)
					{
						theirsElementNote = AddLabel("Tăng Công: " + (Math.abs(theirAllDmg - (theirFish.getTotalDamage()) + dameEnviroment1)), 545, 170, 0xffffff, 1, 0x000000);
					}
					else
					{
						theirsElementNote = AddLabel("Giảm Công: " + Math.abs(theirAllDmg - (theirFish.getTotalDamage()) + dameEnviroment1), 545, 170, 0xffffff, 1, 0x000000);
					}
				}
				
				theirDmg = AddLabel((theirAllDmg + dameEnviroment1) + "", 565, 203, 0xFFFFFF, 0, 0x603813);
				theirDef = AddLabel(String(fish.getTotalDefence()), 565, 238, 0xFFFFFF, 0, 0x603813);
				theirCrit = AddLabel(String(fish.getTotalCritical()), 565, 273, 0xFFFFFF, 0, 0x603813);
				theirVit = AddLabel(String(fish.getTotalVitality()), 565, 308, 0xFFFFFF, 0, 0x603813);
				
				Pos = new Point(630, 270);
				if (fish is SubBossMetal)
				{
					image = AddImage("", "Bolt_Normal", Pos.x, Pos.y, true, ALIGN_CENTER_TOP);
					image.img.rotation = 180;
				}
				else if (fish is SubBossIce)
				{
					image = AddImage("", "SubBoss2_Attack", Pos.x, Pos.y, true, ALIGN_CENTER_TOP);
					image.img.rotationZ = 180;
					image.img.rotationX = 180;
				}
				else
				{
					if (fish.EquipmentList && fish.EquipmentList.Mask && fish.EquipmentList.Mask[0])
					{
						image = AddImage("", fish.EquipmentList.Mask[0].TransformName, Pos.x, Pos.y, true, ALIGN_CENTER_TOP);
					}
					else
					{
						image = AddImage("", Fish.ItemType + fish.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, Pos.x, Pos.y, true, ALIGN_CENTER_TOP);
						UpdateEquipment(image.img, fish);
					}
				}
				//image = AddImage("", Fish.ItemType + fish.FishTypeId + "_" + Fish.OLD + "_" + Fish.IDLE, Pos.x, Pos.y, true, ALIGN_CENTER_TOP);
				//UpdateEquipment(image.img, fish);
				
				if (fish.DamagePlus + dameEnviroment1 > 0)
				{
					ft = new TextFormat();
					ft.color = 0x00ff00;
					theirDmg.setTextFormat(ft);
				}
				else if (fish.DamagePlus + dameEnviroment1 < 0)
				{
					ft = new TextFormat();
					ft.color = 0xff0000;
					theirDmg.setTextFormat(ft);
				}
				
				if (fish.CriticalPlus > 0)
				{
					ft = new TextFormat();
					ft.color = 0x00ff00;
					theirCrit.setTextFormat(ft);
				}
				else if (fish.CriticalPlus < 0)
				{
					ft = new TextFormat();
					ft.color = 0xff0000;
					theirCrit.setTextFormat(ft);
				}
				
				if (fish.VitalityPlus > 0)
				{
					ft = new TextFormat();
					ft.color = 0x00ff00;
					theirVit.setTextFormat(ft);
				}
				else if (fish.VitalityPlus < 0)
				{
					ft = new TextFormat();
					ft.color = 0xff0000;
					theirVit.setTextFormat(ft);
				}
				
				if (fish.DefencePlus > 0)
				{
					ft = new TextFormat();
					ft.color = 0x00ff00;
					theirDef.setTextFormat(ft);
				}
				else if (fish.VitalityPlus < 0)
				{
					ft = new TextFormat();
					ft.color = 0xff0000;
					theirDef.setTextFormat(ft);
				}
			}
			
			if (!isMyFish)
			{
				image.img.scaleX = -1;
				image.FitRect(120, 120, new Point(610, 230));
			}
			else
			{
				image.FitRect(120, 120, new Point(240, 230));
			}		
		}
		
		private function ShowItemSupport(ItemList:Array):void
		{
			var x0:int = 60;
			var y0:int = 100;
			var dx:int = 90;
			var dy:int = 90;
			var maxRow:int = 4;
			//SupportList.sortOn("Type", 1);
			SupportList.sortOn("Order", 1);
			for (var j:int = 0; j < SupportList.length; j++)
			{
				var Pos:Point = new Point();
				Pos.x = x0 + (int(j / maxRow)) * dx;
				Pos.y = y0 + (int(j % maxRow)) * dy;
				var ctn:Container = AddContainer("Ctn_" + SupportList[j]["Type"] + "_" + SupportList[j]["Id"], "GuiFishWar_ImgBgItemFishWar", Pos.x, Pos.y, true, this);
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
			var btnG:Button = c.AddButton("BtnG_" + Ob["Type"] + "_" + Ob["Id"], "GuiFishWar_BtnGreen", 5, 81, this);
			btnG.img.scaleX = 0.5;
			btnG.img.scaleY = 0.6;
			
			if (Ob["Count"] == 0)
			{
				var ImgG:Image = c.AddImage("", "IcZingXu", 60, 70);
				c.AddLabel("Mua " + Ob["ZMoney"], 10, 60, 0xffffff, 0);
			}
			else
			{
				if (!Ob["Count"]) Ob["Count"] = 0;
				c.AddLabel("Dùng", 16, 60, 0xffffff, 0);
			}
			c.AddLabel(String(Ob["Count"]), 5, 40, 0x000000, 1, 0xffffff);			
			
			//if ((Ob["Used"] == Ob["MaxTimes"]) 
				//|| (((Ob["Type"] == "BuffExp") 
				//|| (Ob["Type"] == "BuffMoney") 
				//|| (Ob["Type"] == "BuffRank")) && !Ultility.IsInMyFish()))
			if (Ob["Used"] == Ob["MaxTimes"]) 
			{
				btnG.SetDisable();
			}
			
			//if (((Ob["Type"] == "BuffExp") 
				//|| (Ob["Type"] == "BuffMoney") 
				//|| (Ob["Type"] == "BuffRank")) && !Ultility.IsInMyFish())
			//{
				//btnG.SetDisable();
			//}
			
			// Item giá = 0 thì ko cho xài
			if (Ob.UnlockType == GUIShop.UNLOCK_TYPE_UNUSED)
			{
				btnG.SetDisable();
				var ttt:TooltipFormat = new TooltipFormat();
				ttt.text = "Sắp ra mắt";
				btnG.setTooltip(ttt);
			}
		}
		
		/**
		 * Hàm tính toán 4 tỷ lệ (công thủ chí mạng máu)
		 */
		private function CalculateRatios():void
		{
			var ct:Container = GetContainer(CTN_RATIO);
			if (!ct)
			{
				ct = AddContainer(CTN_RATIO, "GuiFishWar_ImgFrameFriend", 300, 300);
				
				prgDmg = ct.AddProgress(PRG_DAMAGE, "GuiFishWar_PrgWar", 110, -95, this, true);
				prgDef = ct.AddProgress(PRG_DEFENCE, "GuiFishWar_PrgWar", 110, -60, this, true);
				prgCrit = ct.AddProgress(PRG_CRITICAL, "GuiFishWar_PrgWar", 110, -25, this, true);
				prgHP = ct.AddProgress(PRG_HP, "GuiFishWar_PrgWar", 110, 10, this, true);
				
				ct.AddLabel("Công", 135, -115, 0xFFF100, 1, 0x603813);
				ct.AddLabel("Thủ", 135, -80, 0xFFF100, 1, 0x603813);
				ct.AddLabel("Chí mạng", 135, -45, 0xFFF100, 1, 0x603813);
				ct.AddLabel("Máu", 135, -10, 0xFFF100, 1, 0x603813);
			}
			else
			{
				//ct.ClearLabel();
			}
			
			myAllDmg = myFish.getTotalDamage();
			myAllDmg = Math.ceil(myAllDmg * (1 + checkCounter(myFish, theirFish, isResistance) / 100));
			myAllDef = myFish.getTotalDefence();
			myAllCrit = myFish.getTotalCritical();
			myAllHP = myFish.getTotalVitality();
			
			if(Ultility.IsInMyFish())
			{
				theirAllDmg = theirFish.getTotalDamage();
				theirAllDmg = Math.ceil(theirAllDmg * (1 - checkCounter(myFish, theirFish, isResistance) / 100));
				theirAllDef = theirFish.getTotalDefence();
				theirAllCrit = theirFish.getTotalCritical();
				theirAllHP = theirFish.getTotalVitality();
			}
			else
			{
				theirAllDmg = theirFish.Damage;
				theirAllDmg = Math.ceil(theirAllDmg * (1 - checkCounter(myFish, theirFish, isResistance) / 100));
				theirAllDef = theirFish.Defence;
				theirAllCrit = theirFish.Critical;
				theirAllHP = theirFish.Vitality;
			}
			

			// Nếu là trong thế giới cá, chỉ số là chỉ số ko có đồ đạc j hết
			//if (!Ultility.IsInMyFish())
			//{
				//theirAllDmg = theirFish.Damage;
				//theirAllCrit = theirFish.Critical;
				//theirAllHP = theirFish.Vitality;
				//theirAllDef = theirFish.Defence;
			//}
			
			prgDmg.setStatusProgress(myAllDmg / (myAllDmg + theirAllDmg), 0.5);
			prgDef.setStatusProgress(myAllDef / (myAllDef + theirAllDef), 0.5);
			prgCrit.setStatusProgress(myAllCrit / (myAllCrit + theirAllCrit), 0.5);
			prgHP.setStatusProgress(myAllHP / (myAllHP + theirAllHP), 0.5);
		}
		
		/**
		 * Hàm trả về chênh lệch & so với base dựa trên tương khắc
		 * @param	mFish
		 * @param	tFish
		 * @return
		 */
		public function checkCounter(mFish:FishSoldier, tFish:FishSoldier, isResistance:Boolean = false):int
		{
			// Kiểm tra tương khắc
			var EleMinus:int = myFish.Element - theirFish.Element;
			var isKhac:Boolean;		// Khắc: true, BỊ khắc: false;
			var tt:TooltipFormat;
			
			// Trường hợp xảy ra tương khắc
			if (((Math.abs(EleMinus) == 1) || (Math.abs(EleMinus) == 4)) && !isResistance)
			{
				// Add cái icon chí mạng
				//var ctnn:Container = AddContainer(CTN_KHAC, "IcChiMang", 510, 170);
				
				var s:String;
				var myElement:String = Localization.getInstance().getString("Element" + mFish.Element);
				var theirElement:String = Localization.getInstance().getString("Element" + tFish.Element);
				
				
				if ((myFish.Element + theirFish.Element) == 6)
				{
					// Hỏa và Kim (trường hợp 1 và 5)
					if (myFish.Element > theirFish.Element)
					{
						isKhac = true;
					}
					else
					{
						isKhac = false;
					}
				}
				else
				{
					if (myFish.Element < theirFish.Element)
					{
						isKhac = true;
					}
					else
					{
						isKhac = false;
					}
				}
				
				var CounterRate:int = ConfigJSON.getInstance().GetItemList("Param").ConflictDamageRate;
				
				if (isKhac)
				{
					return CounterRate;					
				}
				else
				{
					return -CounterRate;
				}
				
			}
			else
			{
				return 0;
			}
		}
		
		public function ProcessBuyItem(buttonID:String):void
		{
			var ar:Array = buttonID.split("_");
			var i:int;
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
			// Gửi gói tin mua item
			var buy:SendBuyOther = new SendBuyOther();
			buy.AddNew(ar[1], ar[2], 1, "ZMoney");
			Exchange.GetInstance().Send(buy);
			
			ProcessUseItem(buttonID);
		}
		
		/**
		 * Hàm vẽ các item họ đã sử dụng ra
		 * @param	a
		 */
		public function ShowTheirItemUsed(buffArr:Array):void
		{
			theirItemUsedList.ClearComponent();
			var x0:int = -10;
			var y0:int = -112;
			var dx:int = -29;
			var index:int = 0;
			
			for (var i:int = 0; i < buffArr.length; i++)
			{
				if (buffArr[i].ItemType == "Resistance" || buffArr[i].ItemType == "StoreRank")
				{
					theirItemUsedList.AddImage("", buffArr[i].ItemType + buffArr[i].ItemId, x0 + dx * index, y0).SetScaleXY(0.5);
					theirItemUsedList.AddLabel(buffArr[i].Num + "", x0 + dx * index - 50,  y0 - 10, 0xFFF100, 1, 0x603813);
					index++;
				}
			}
		}
		
		/**
		 * Hàm vẽ các item mình đã sử dụng ra
		 * @param	a
		 */
		public function ShowMyItemUsed(a:Array):void
		{
			myItemUsedList.ClearComponent();
			var x0:int = -10;
			var y0:int = -112;
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
						myAllDmg = myFish.getTotalDamage();
						
						var counter:int = checkCounter(myFish, theirFish, isResistance);
						if (counter > 0)
						{
							myAllDmg = Math.ceil(myAllDmg * (1 + counter / 100));
							myElementNote.text = "Tăng Công: " + int(myAllDmg - (myFish.getTotalDamage()));
						}
						else if (counter < 0)
						{
							myAllDmg = Math.ceil(myAllDmg * (1 + counter / 100));
							myElementNote.text = "Giảm Công: " + Math.abs(myAllDmg - (myFish.getTotalDamage()));
						}
						
						StartParticleUseSamurai(GameInput.getInstance().MousePos, myAllDmg);
						break;
					// Tăng % quân hàm rơi ra
					case "BuffRank":
						//break;
					// Tăng % exp rơi ra
					case "BuffExp":
						//break;
					// Tăng % Tiền rơi ra
					case "BuffMoney":
						//break;
					// Giữ quân hàm khi thua
					case "StoreRank":
						StartParticleUseOtherItem(GameInput.getInstance().MousePos);
						break;
					// Miễn kháng
					case "Resistance":
						if (checkCounter(myFish, theirFish, isResistance) == 0)
						{
							StartParticleUseOtherItem(GameInput.getInstance().MousePos);
						}
						else
						{
							StartParticleUseResistanceItem(GameInput.getInstance().MousePos);
						}
						break;
				}
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{	
				case BUTTON_CLOSE:
				case BUTTON_CANCEL:
					if (isEffecting)	return;
					if (GuiMgr.getInstance().GuiInfoWarInWorld.IsVisible)
					{
						GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
					}
					this.Hide();
					break;
				case BUTTON_WAR:
					if (isEffecting)	return;
					
					// Nếu hết máu hoặc hết hạn thì thông báo và đóng GUI
					if (myFish.Status == FishSoldier.STATUS_REVIVE)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg28"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
						if (!Ultility.IsInMyFish())
						{
							GuiMgr.getInstance().GuiInfoWarInWorld.HideDisableScreen(true);
						}
						Hide();
						return;
					}
					
					if (theirFish.Status == FishSoldier.STATUS_REVIVE)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg24"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
						Hide();
						return;
					}
					
					if(GameLogic.getInstance().user.CurSoldier[0] && GameLogic.getInstance().user.CurSoldier[1])
					{
						var energyCost:int = ConfigJSON.getInstance().getEnergyForAttack(myFish.Rank);//ConfigJSON.getInstance().getItemInfo("RankPoint", myFish.Rank).AttackEnergy;// Math.floor(myFish.Damage / 20);
						if (!Ultility.IsInMyFish())
						{
							energyCost = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillMonster");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillMonster"];
						}
						if (energyCost > GameLogic.getInstance().user.GetEnergy())
						{
							GuiMgr.getInstance().GuiAddEnergy.Show(Constant.GUI_MIN_LAYER, 1);
						}
						else
						{
							ProcessWar();
						}
						break;
					}
					
					if (!GameLogic.getInstance().user.CurSoldier[1] && GameLogic.getInstance().user.GetFishArr().length > 0)
					{
						// Thông báo cá hết tuổi thọ
						Hide();
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("FishWarMsg24"), 310, 200, GUIMessageBox.NPC_MERMAID_WAR);
					}
					else 
					{
						Hide();
					}
					break;
				default:
					var a:Array = buttonID.split("_");
					if (a[0] == "BtnG")
					{
						for (var i:int = 0; i < SupportList.length; i++)
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
					break;
			}
		}
		
		public function ProcessWar():void
		{
			var mySoldier:FishSoldier = GameLogic.getInstance().user.CurSoldier[0];
			var theirSoldier:FishSoldier = GameLogic.getInstance().user.CurSoldier[1];
			
			// Gửi gói tin oánh nhau lên
			var obj:Object = new Object();
			if(Ultility.IsInMyFish())
			{
				obj["myFishId"] = mySoldier.Id;
				obj["myLakeId"] = mySoldier.LakeId;
				obj["theirId"] = GameLogic.getInstance().user.Id;
				obj["theirLake"] = GameLogic.getInstance().user.CurLake.Id;
				obj["VictimId"] = theirSoldier.Id;
				var fight:SendAttackFriendLake = new SendAttackFriendLake(obj);
				fight.SetItemList(SupportList);
				Exchange.GetInstance().Send(fight);
			}
			else 
			{
				obj["IdSoldier"] = mySoldier.Id;
				obj["SeaId"] = FishWorldController.GetSeaId();
				obj["LakeId"] = mySoldier.LakeId;
				obj["IdMonster"] = theirSoldier.Id;
				var energyCost:int = ConfigJSON.getInstance().getEnergyForFishWorld("EnergyKillMonster");//ConfigJSON.getInstance().GetItemList("Param")["EnergyKillMonster"];
				// Effect trừ năng lượng
				GameLogic.getInstance().user.UpdateEnergy( -energyCost);
				//trace("tru nang luong o GuiFishWar: " + energyCost);
				var fightWorld:SendAttackWorld = new SendAttackWorld(obj);
				fightWorld.SetItemList(SupportList);
				Exchange.GetInstance().Send(fightWorld);
				GameLogic.getInstance().isFighting = true;
			}
			
			// Lưu lại thời gian click gửi gói tin để chặn ko cho gửi nữa
			GameInput.getInstance().lastAttackTime = GameLogic.getInstance().CurServerTime;
			
			// Cập nhật kho đối với các item buff exp rank gold
			for (var i:int = 0; i < SupportList.length; i++)
			{
				if (SupportList[i].Type == "BuffRank" || SupportList[i].Type == "BuffExp" || SupportList[i].Type == "BuffMoney")
				{
					if (SupportList[i].Used > 0)
					{
						GuiMgr.getInstance().GuiStore.UpdateStore(SupportList[i].Type, SupportList[i].Id, -SupportList[i].Used);
					}
				}
			}
			this.Hide();
		}
		
		public function UpdateEquipment(sp:Sprite, fish:FishSoldier):void
		{
			var i:int;
			var s:String;
			for (s in fish.EquipmentList)
			{
				for (i = 0; i < fish.EquipmentList[s].length; i++)
				{
					ChangeEquipment(fish.EquipmentList[s][i].Type, fish.EquipmentList[s][i].Color, fish.EquipmentList[s][i].imageName, sp);
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
		
		public function ChangeEquipment(Type:String, Color:int, resName:String, sp:Sprite):void
		{
			if (resName == "")	return;
			
			var child:DisplayObject;
			var i:int = 1;
			child = Ultility.findChild(sp, Type);
			
			if (child != null)
			{
				var index:int = child.parent.getChildIndex(child);
				var eq:FishEquipment = new FishEquipment();
				eq.parent = child.parent as Sprite;
				eq.index = index;
				eq.oldChild = child;
				eq.Color = Color;
				eq.loadComp = function f():void
				{
					var dob:DisplayObject = this.parent.addChildAt(this.img, this.index);
					dob.name = Type;
					if (this.oldChild != null && this.parent.contains(this.oldChild))
						this.parent.removeChild(this.oldChild);
					FishSoldier.EquipmentEffect(dob, this.Color);
				}
				eq.loadRes(resName);
			}	
		}
		
		private function StartParticleUseResistanceItem(startPoint:Point):void
		{
			isEffecting = true;
			
			var pos:Point, med:Point;
			var des:Point;
			var time:Number = 1;
			var emit:CometEmit = new CometEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));
			var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;
			
			pos = startPoint;
			des = new Point(500, 180);
			sao.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 255, 0, 0);
			emit.imgList.push(sao);
			emitStar.push(emit);
			med = getThroughPoint(pos, des);
			
			if (emit)
			{
				img.stage.addChild(emit.sp);
				emit.sp.x = pos.x;
				emit.sp.y = pos.y;
				TweenMax.to(emit.sp , time, { bezierThrough:[ { x:med.x, y:med.y }, { x:des.x, y:des.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween, onCompleteParams:[] } );					
			}
			
			function onCompleteTween():void
			{
				if (emit)
				{
					emit.stopSpawn();
				}
				img.stage.removeChild(emit.sp);
				
				emitStar.splice(emitStar.indexOf(emit), 1);
				emit.destroy();
				
				ShowMyItemUsed(SupportList);
				isResistance = true;
				if (GetImage("Khac"))
				{
					GetImage("Khac").img.visible = false;
					GetImage("CounterArrow").img.visible = false;
					AddImage("", "GuiFishWar_Ic_Vs", 485, 139);
				}
				CalculateRatios();
				myDmg.text = myAllDmg + "";
				theirDmg.text = theirAllDmg + "";
				if (myElementNote)
				{
					myElementNote.text = "";
				}
				if (theirsElementNote)
				{
					theirsElementNote.text = "";
				}
				
				if (!emitStar || emitStar.length == 0)
				{
					isEffecting = false;
				}
			}
		}
		
		/**
		 * Tạo particle bay vào list item đã xài
		 */
		private function StartParticleUseOtherItem(startPoint:Point):void
		{
			isEffecting = true;
			
			var pos:Point, med:Point;
			var des:Point;
			var time:Number = 1;
			var emit:CometEmit = new CometEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));		
			var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;
			
			pos = startPoint;
			des = new Point(305, 377);				
			sao.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 255, 0, 0);			
			emit.imgList.push(sao);
			emitStar.push(emit);
			med = getThroughPoint(pos, des);
			
			if (emit)
			{
				img.stage.addChild(emit.sp);
				emit.sp.x = pos.x;
				emit.sp.y = pos.y;
				TweenMax.to(emit.sp , time, { bezierThrough:[ { x:med.x, y:med.y }, { x:des.x, y:des.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween, onCompleteParams:[] } );					
			}
			
			function onCompleteTween():void
			{
				if (emit)
				{
					emit.stopSpawn();
				}
				img.stage.removeChild(emit.sp);
				
				emitStar.splice(emitStar.indexOf(emit), 1);
				emit.destroy();
				
				ShowMyItemUsed(SupportList);
				
				if (!emitStar || emitStar.length == 0)
				{
					isEffecting = false;
				}
			}
		}
		
		/**
		 * Tạo particle bay vào ô dmg của mình
		 * @param	startPoint
		 * @param	dmgAfter
		 */
		private function StartParticleUseSamurai(startPoint:Point, dmgAfter:int):void
		{
			isEffecting = true;
			
			var pos:Point, med:Point;
			var des:Point;
			var time:Number = 1;
			var emit:CometEmit = new CometEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));		
			var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;
			
			pos = startPoint;
			des = new Point(405, 210);				
			sao.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 255, 0, 0);			
			emit.imgList.push(sao);
			emitStar.push(emit);
			med = getThroughPoint(pos, des);
			
			if (emit)
			{
				img.stage.addChild(emit.sp);
				emit.sp.x = pos.x;
				emit.sp.y = pos.y;
				TweenMax.to(emit.sp , time, { bezierThrough:[ { x:med.x, y:med.y }, { x:des.x, y:des.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween, onCompleteParams:[dmgAfter] } );					
			}
			
			function onCompleteTween(dmgAfter:int):void
			{
				if (emit)
				{
					emit.stopSpawn();
				}
				img.stage.removeChild(emit.sp);
				
				emitStar.splice(emitStar.indexOf(emit), 1);
				emit.destroy();
				
				myDmg.text = dmgAfter + "";
				var ft:TextFormat = new TextFormat();
				ft.color = 0x00ff00;
				myDmg.setTextFormat(ft);
				
				if (!emitStar || emitStar.length == 0)
				{
					isEffecting = false;
				}
				
				CalculateRatios();
			}
		}
		
		/**
		 * Tìm điểm trung gian giữa 2 điểm nguồn và đích để bay vòng qua đó cho đẹp
		 * @param	psrc	điểm nguồn
		 * @param	pdes	điểm đích
		 * @return
		 */
		private function getThroughPoint(psrc:Point, pdes:Point):Point
		{
			var p:Point = pdes.subtract(psrc);//Vector từ nguồn đến đích
			if (p.y == 0)
				return new Point(p.x/2, 0);
			var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2);//Trung điểm của nguồn và đích
			var v:Point = new Point( -p.y, p.x);//Vector vuông góc với vector(nguồn, đích)
	
			//Random hướng vuông góc
			var n:int = Math.round(Math.random()) * 2 - 1;
			v.x = n*v.x;
			v.y = n*v.y;
			var l:Number = Math.min(120, v.length / 3);
			v.normalize(l);//Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			var result:Point = med.add(v);//Tính ra điểm cần đi xuyên qua
			return result;			
		}
		
		public override function Hide():void
		{		
			super.Hide();
			
			//Hủy particle
			while (emitStar[0])
			{
				emitStar[0].destroy();
				emitStar.splice(0, 1);
			}		
		}
		
		/**
		 * Vòng lặp chạy liên tục theo từng frame với UpdateLogic của GameLogic, sử lý hiển thị là chính
		 * cụ thể ở đây là để làm các textfield tỉ lệ, giá tiền chạy linh tinh
		 */
		public function UpdateInfo():void 
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
	}

}