package Event.TreasureIsland 
{
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.ScrollBar;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GuiMgr;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class GUITreasureChests extends BaseGUI 
	{
		public const BTN_CLOSE:String = "BtnThoat";
		private var gList:Array;
		private var listBox:ListBox;
		
		public function GUITreasureChests(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUITreasureChests";
		}
		
		override public function InitGUI():void
		{
			SetPos(420, 660);
			LoadRes("GUITreasureChests");
			AddButton(BTN_CLOSE, "BtnTreasure", 290, 332, this);
			if (gList.length <= 0)
			{
				var txt:TextField = AddLabel("", 100, 150, 0xD90000);
				txt.wordWrap = true;
				txt.width = 400;
				txt.text = "Bạn chưa đào được món đồ nào!";
				return;
			}
			listBox = AddListBox(ListBox.LIST_Y, 3, 4, 5, 5);
			listBox.setPos(22, 60);
			addGift(gList);
			if (gList.length > 12)	
			{
				var scrollBar:ScrollBar = AddScroll("", "ScrollBarGift", 350, 60);
				scrollBar.setScrollImage(listBox.img, 320, 220);
			}
		}
		
		private function addGift(gList:Array):void 
		{
			listBox.removeAllItem();
			equipArr = new Object();
			var item:Image;
			for (var i:int = 0; i < gList.length; i++)
			{
				if (gList[i] as Array) continue;
				var tip:TooltipFormat = new TooltipFormat();
				var container:Container = new Container(img, "AutoDigItemBg", 0, 0);
				var giftType:String = gList[i]["ItemType"];
				var txtNum:TextField = container.AddLabel("x" + Ultility.StandardNumber(gList[i]["Num"]), -10, 55, 0xFFFF00, 1, 0x717100);
				var idObj:String;
				if (gList[i].hasOwnProperty("ItemType"))
				{
					switch (giftType)
					{
						case "Exp":
							container.AddImage("", "IcExp", 40, 30);
							tip.text = "Kinh nghiệm";
							break;
						case "Money":
							container.AddImage("", "IcGold", 40, 40);
							tip.text = "Tiền vàng";
							break;
						case "Matertial":
						case "Material":
							container.AddImage("", "Material" + gList[i]["ItemId"], 60, 55);
							tip.text = "Ngư thạch cấp " + gList[i]["ItemId"];
							break;
						case "Island_Item":
							item = container.AddImage("", "IslandItem" + gList[i]["ItemId"], 65, 65);
							item.SetScaleXY(0.8);
							tip.text = Localization.getInstance().getString(giftType + gList[i]["ItemId"]);
							break;
						case "EnergyItem":
							item = container.AddImage("", giftType + gList[i]["ItemId"], 40, 30);
							tip.text = Localization.getInstance().getString(giftType + gList[i]["ItemId"]);
							break;
						case "RankPointBottle":
							item = container.AddImage("", giftType + gList[i]["ItemId"], 45, 40);
							tip.text = Localization.getInstance().getString(giftType + gList[i]["ItemId"]);
							item.SetScaleXY(0.7);
							break;
						case "HammerWhite":
							container.AddImage("", "GuiTrungLinhThach_Hammer_1", 35, 30);
							tip.text = "Búa thường";
							break;
						case "HammerGreen":
							container.AddImage("", "GuiTrungLinhThach_Hammer_2", 35, 30);
							tip.text = "Búa đặc biệt";
							break;
						case "HammerYellow":
							container.AddImage("", "GuiTrungLinhThach_Hammer_3", 35, 30);
							tip.text = "Búa quí";
							break;
						case "HammerPurple":
							container.AddImage("", "GuiTrungLinhThach_Hammer_4", 35, 30);
							tip.text = "Búa thần";
							break;
					}
					container.setTooltip(tip);
					idObj = "Normal_" + i;
				}
				else
				{
					var equip:FishEquipment = new FishEquipment();
					equip.SetInfo(gList[i]);
					equipArr[i] = equip;
					container.AddContainer("", FishEquipment.GetBackgroundName(equip.Color), 0, 0);
					
					txtNum = container.AddLabel("x1", -10, 55, 0xFFFF00, 1, 0x717100);
					var s:String = gList[i]["Type"] + gList[i]["Rank"];
					item = container.AddImage("", s + "_Shop", 43, 45);
					item.SetScaleXY(0.7);
					idObj = "Special_" + i;
				}
				listBox.addItem(idObj, container, this);
			}
		}
		
		public function ShowGUI(giftList:Array):void
		{
			gList = giftList;
			super.Show(Constant.GUI_MIN_LAYER, 3);
			
			TweenMax.to(this.img, 0.5, { bezier:[{x:420, y:140}], ease:Back.easeInOut} );
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_CLOSE:
					Hide();
					GuiMgr.getInstance().guiTreasureIsLand.imgTreasureOpenClose.GoToAndStop(1);
					break;
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (buttonID.split("_")[0] == "Special")
			{
				if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
				{
					GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				}
			}
		}
		private var equipArr:Object;
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			var arr:Array = buttonID.split("_");
			if (arr[0] == "Special")
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equipArr[arr[1]], GUIEquipmentInfo.INFO_TYPE_SPECIFIC, null, 0);
			}
		}
	}

}