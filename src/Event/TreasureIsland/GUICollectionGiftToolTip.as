package Event.TreasureIsland 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class GUICollectionGiftToolTip extends BaseGUI 
	{
		private var gList:ListBox;
		
		public function GUICollectionGiftToolTip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUICollectionGiftToolTip";
		}
		
		override public function InitGUI():void
		{
			SetPos(GameInput.getInstance().MousePos.x - 220, GameInput.getInstance().MousePos.y - 120);	
			LoadRes("GUICollectionGiftToolTip");
			gList = AddListBox(ListBox.LIST_Y, 2, 2, 10, 5);
			gList.setPos(20, 30);
		}
		
		//type:1 collection, 2 change medal
		public function showGUI(id:int, type:int = 1):void 
		{
			super.Show(Constant.GUI_MIN_LAYER);
			var config:Object
			//if (type == 1)
			//{
				config = ConfigJSON.getInstance().getItemInfo("IsLand_Collection");
			//}
			//else
			//{
				//config = ConfigJSON.getInstance().getItemInfo("Island_GiftMedal");
			//}
			var aGift:Array = [];
			for (var str:String in config[id]["Gift"])
			{
				aGift.push(config[id]["Gift"][str]);
			}
			var item:Image;
			for (var i:int = 0; i < aGift.length; i++ )
			{
				var container:Container = new Container(img, "AutoDigItemBg", 0, 0);
				var txtNum:TextField = container.AddLabel("x1", -10, 55, 0xFFFF00, 1, 0x717100);
				switch (aGift[i]["ItemType"])
				{
					case "Matertial":
					case "Material":
						container.AddImage("", aGift[i]["ItemType"] + aGift[i]["ItemId"] , 60, 55);
						txtNum.text = "x" + Ultility.StandardNumber(aGift[i]["Num"]);
						break;
					case "Exp":
						container.AddImage("", "IcExp" , 40, 40);
						txtNum.text = "x" + Ultility.StandardNumber(aGift[i]["Num"]);
						break;
					case "RankPointBottle":
						item = container.AddImage("", aGift[i]["ItemType"] + aGift[i]["ItemId"], 45, 45);
						txtNum.text = "x" + Ultility.StandardNumber(aGift[i]["Num"]);
						item.SetScaleXY(0.7);
						break;
					case "Ring":
					case "Belt":
						item = container.AddImage("", "GuiCollection_Jewel" + "_Trunk_" + aGift[i]["Color"], 65, 55);
						item.SetScaleXY(0.5);
						container.AddImage("", "ImgLaMa" + aGift[i]["Rank"], 70, 70);
						break;
					case "Weapon":
						item = container.AddImage("", "GuiCollection_" + aGift[i]["ItemType"] + "_Trunk_" + aGift[i]["Color"], 65, 55);
						item.SetScaleXY(0.5);
						container.AddImage("", "ImgLaMa" + aGift[i]["Rank"], 60, 60);
						break;
					case "AllChest":
						item = container.AddImage("", aGift[i]["ItemType"] + aGift[i]["Rank"] + "_" + aGift[i]["ItemType"], 40, 30);
						break;
				}
				gList.addItem("", container, this);
			}
		}
	}
}