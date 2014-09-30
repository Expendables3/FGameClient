package GUI 
{
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import Logic.GameLogic;
	import Logic.QuestMgr;
	import Logic.Ultility;
	/**
	 * ...
	 * @author ducnh
	 */
	public class GUILevelUp extends BaseGUI
	{
		public static const BONUS_MONEY:String = "Money";
		public static const BONUS_MATERIAL:String = "Material";
		public static const BONUS_ZMoney:String = "ZMoney";
		public static const BONUS_ENERGY:String = "EnergyItem";
		public static const BONUS_MEDICINE:String = "Medicine";
		public static const BONUS_OTHER:String = "Other";
		public static const BONUS_ANIMAL:String = "OceanAnimal";
		
		private const GUI_LEVELUP_BTN_CLOSE:String = "close";
		private const GUI_LEVELUP_BTN_NEXT:String = "next";
		private const GUI_LEVELUP_BTN_BACK:String = "back";
		private const GUI_LEVELUP_BTN_FEED:String = "feed";		
		private const GUI_LEVELUP_BTN_RECEIVE_AWARD:String = "receiveAward";		
		
		private const MaxItemLength:int = 3;
		private var nItem:int = 0;
		private var CurItemPos:int = 0;
		private var btnNext:Button;
		private var btnBack:Button;
		private var UnlockList:Array = [];
		private var btnClose:Button;
		private var Bonus:Array = null;
		
		public function GUILevelUp(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUILevelUp";
		}
		
		public override function InitGUI() :void
		{
			//LoadRes("ImgBgGUILevelUp");
			setImgInfo = function f():void
			{
				SetPos(220- 88, 100 - 12);
				
				btnClose = AddButton(GUI_LEVELUP_BTN_CLOSE, "BtnThoat", 358 + 171, 37 + 12, this);
				//Chỉ hiện nút chia sẻ khi level user > 7
				if(GameLogic.getInstance().user.Level > 7)
				{
					AddButton(GUI_LEVELUP_BTN_FEED, "BtnFeed", 137 + 169, 265 + 115, this);
				}
				else
				{
					AddButton(GUI_LEVELUP_BTN_RECEIVE_AWARD, "BtnDong", 137 + 169, 265 + 115, this);
				}
			}
			LoadRes("GuiLevelUp_Theme");
		}
		
		public function ShowNewLevelUp(level:int):void
		{
			super.Show(Constant.GUI_MIN_LAYER, 2);
			
			Bonus = [];
			var data:Object = ConfigJSON.getInstance().getItemInfo("LevelUpUser", level);
			for (var s:String in data) 
			{
				if(!isNaN(parseInt(s)))
				{
					Bonus.push(data[s]);
				}				
			}
	
			
			/*if (UnlockList.length > 0)
			{
				UnlockList.splice(0, UnlockList.length);
			}
			UnlockList = ConfigJSON.getInstance().getCurLevelList(GameLogic.getInstance().user.GetLevel());
			nItem = UnlockList.length;
			CurItemPos = 0;
			
			// them cac item se mua dc o lvl vao
			var st:String = "";
			var i:int;
			var obj:Object;
			var lbl:TextField;
			var txtFormat:TextFormat;
			for (i = 0; i < nItem; i++)
			{
				obj = UnlockList;
				if (UnlockList[i][ConfigJSON.KEY_NAME] != null)
				{
					if (st != "")
					{
						st += ", ";
					}
					if (UnlockList[i]["type"] == "MixLake")
					{
						st += "Hồ lai ";
					}
					st += UnlockList[i][ConfigJSON.KEY_NAME];
				}
			}
			if (st != "")
			{
				lbl = AddLabel("Bạn đã có thể mua: " + st, 60 + 133, 220 + 157);
				txtFormat = new TextFormat("Arial", 13, 0x003453);
				lbl.setTextFormat(txtFormat);
				lbl.width = 280;
				lbl.multiline = true;
				lbl.wordWrap = true;
			}*/
			
			/*//cau chuc mung
			st = Localization.getInstance().getString("Message3");
			st = st.replace("@CurLevel", GameLogic.getInstance().user.GetLevel());
			txtFormat = new TextFormat("Arial", 16, 0x003453);
			lbl = AddLabel(st, 150, 82);
			lbl.setTextFormat(txtFormat);
			
			 //phan thuong dc nhan
			st = Localization.getInstance().getString("GUILabel5");
			txtFormat = new TextFormat("Arial", 16, 0x601020);
			lbl = AddLabel(st, 150, 105);
			lbl.setTextFormat(txtFormat);*/
			
			var level:int = GameLogic.getInstance().user.GetLevel();
			var a:int = level / 100;
			var b:int = (level - a * 100) / 10;
			var c:int = level - a * 100 - b * 10;
			if (a > 0)
			{
				AddImage("", "Number_" + a, 320-45, 188).SetScaleXY(1.6);
			}
			if (b > 0 || (a > 0 && b == 0))
			{
				AddImage("", "Number_" + b, 360-45, 188).SetScaleXY(1.6);
			}
			if (c >= 0)
			{
				AddImage("", "Number_" + c, 400-45, 188).SetScaleXY(1.6);
			}
			
			
			for (var i:int = 0; i < Bonus.length; i++)
			{
				var tg:Object = Bonus[i];
				var obj:Object = ConfigJSON.getInstance().getItemInfo(tg["ItemType"],tg["ItemId"]);
				AddBonus(obj, tg["Num"], i, Bonus.length);
			}
			
			UpdateBonus();
		}
		
		private function UpdateBonus():void
		{
			if (Bonus == null) 
			{
				return;
			}
			
			var i:int;
			for (i = 0; i < Bonus.length; i++)
			{
				var tg:Object = Bonus[i];
				switch (tg["ItemType"])
				{
					case "Money":
						GameLogic.getInstance().user.UpdateUserMoney(tg["Num"]);
						break;
					case "ZMoney":
						GameLogic.getInstance().user.UpdateUserZMoney(tg["Num"]);
						break;
					case "Jade":
					case "Iron":
					case "SoulRock":
					case "SixColorTinh":
					case "PowerTinh":
					case "Jade":
						GameLogic.getInstance().user.updateIngradient(tg["ItemType"], tg["Num"], tg["ItemId"]);
						break;
					case "Gem":
						//GuiMgr.getInstance().GuiStore.UpdateStore(tg.ItemType + "$" + tg.Element + "$" + tg.ItemId, tg.Day, tg.Num);
						break;
					default:
						if (GuiMgr.getInstance().GuiStore.IsVisible)
						{
							GuiMgr.getInstance().GuiStore.UpdateStore(tg["ItemType"], tg["ItemId"], tg["Num"]);
						}
						else 
						{
							GameLogic.getInstance().user.UpdateStockThing(tg["ItemType"], tg["ItemId"], tg["Num"]);
						}
						
					break;
				}
			}
			
			Bonus = null;
		}
		
		private function AddBonus(obj:Object, num:int, CurBonus:int, MaxBonus:int):void
		{
			var pos:Point = new Point();
			var image:Image;
			var imgName:String;
			
			switch (obj["type"])
			{
				case BONUS_MONEY:
					imgName = "IcGold";
					break;
				case BONUS_ZMoney:
					imgName = "IcZingXu";
					break;
				case "Iron":
				case "SixColorTinh":
				case "PowerTinh":
				case "Jade":
				case "SoulRock":
					imgName = obj["type"];
					break;
				default:
					imgName = obj["type"] + obj[ConfigJSON.KEY_ID];	
					break;
			}
			image = AddImage("", imgName, 0, 0, true, ALIGN_LEFT_TOP);
			image.FitRect(59, 59, new Point(CurBonus * 70 + 259, 286));
			if (obj["type"] == "SoulRock")
			{
				AddImage("", "Number_" + obj["Id"], CurBonus * 70 + 259, 286, true, ALIGN_LEFT_TOP).FitRect(20, 20, new Point( CurBonus * 70 + 259, 286));;
			}
			var BonusText:TextField = AddLabel("x"+Ultility.StandardNumber(num), CurBonus * 70 + 259 -25, 340 - 11, 0xffff00, 1, 0x000000);
			var Format:TextFormat = new TextFormat("Arial", 14);
			BonusText.setTextFormat(Format);
		}
		
		private function ShowItemAt(pos:int):void
		{
			var i:int;
			var max:int = pos + MaxItemLength;
			if (max > nItem)
			{
				max = nItem;
			}
			
			RemoveAllImage();

			for (i = pos; i < max; i++)
			{
				//var obj:Object = INI.getInstance().getItemInfo(UnlockList[i][ConfigJSON.KEY_ID], UnlockList[i]["type"]);
				var obj:Object = ConfigJSON.getInstance().getItemInfo(UnlockList[i]["type"], UnlockList[i][ConfigJSON.KEY_ID]);
				AddItem(obj);
			}
		}
		
		override public function OnHideGUI():void 
		{
			GuiMgr.getInstance().guiIntroduceFeature.showGUI();
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_LEVELUP_BTN_CLOSE:		
				case GUI_LEVELUP_BTN_RECEIVE_AWARD:
					Hide();
					break;		
					
				case GUI_LEVELUP_BTN_NEXT:
					CurItemPos ++;
					if (CurItemPos > nItem - MaxItemLength)
					{
						CurItemPos = nItem - MaxItemLength;
					}
					ShowItemAt(CurItemPos);
					break;
					
				case GUI_LEVELUP_BTN_BACK:
					CurItemPos --;
					if (CurItemPos < 0)
					{
						CurItemPos = 0;
					}
					ShowItemAt(CurItemPos);
					break;
					
				case GUI_LEVELUP_BTN_FEED:
					{
						Hide();
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GuiMgr.getInstance().GuiFeedWall.FEED_TYPE_LEVEL_UP, 
								(GameLogic.getInstance().user.GetMyInfo().Level).toString(), "", Localization.getInstance().getString("FeedIcon" + GuiMgr.getInstance().GuiFeedWall.FEED_TYPE_LEVEL_UP));
					}
					
					break;
			}
		}
		
		private function AddItem(obj:Object):void
		{
			var pos:Point = new Point();
			var img:Image;
			var imgName:String;
			
			// find pos
			var n:int = ImageArr.length;
			pos.x = 100 + (n - 1) * 80;
			pos.y = 100;
			
			switch (obj["type"])
			{
				case "Other":
					imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
					img = AddImage("", imgName, pos.x, pos.y, true, ALIGN_LEFT_TOP);
					break;
				
				case "OceanTree":
					imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
					img = AddImage("", imgName, pos.x, pos.y, true, ALIGN_LEFT_TOP);
					img.SetScaleX(0.6);
					img.SetScaleY(0.6);
					break;
					
				case "OceanAnimal":
					imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
					img = AddImage("", imgName, pos.x, pos.y, true, ALIGN_LEFT_TOP);
					img.GoToAndStop(2);
					break;
				
				case "Fish":
					imgName = "Fish" + obj[ConfigJSON.KEY_ID] + "_Old_Idle";
					img = AddImage("", imgName, pos.x, pos.y, true, ALIGN_LEFT_TOP);
					break;
					
				case "Food":
					imgName = "ImgFoodBox";
					img = AddImage("", imgName, pos.x, pos.y, true, ALIGN_LEFT_TOP);
					break;
			}
		}
		
	}

}