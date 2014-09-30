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
	public class GUIAutoDigLand extends BaseGUI 
	{
		private const BTN_CLOSE:String = "Close";
		private const BTN_AUTO:String = "BtnAuto";
		private const ROW:int = 3;
		private const COL:int = 3;
		private var gList1:ListBox;
		private var gList2:ListBox;
		
		public function GUIAutoDigLand(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIAutoDigLand";
		}
		
		override public function InitGUI():void
		{
			SetPos(35, 30);
			LoadRes("GUIAutoDigLand");
			AddButton(BTN_CLOSE, "BtnThoat", 705, 20, this);
			gList1 = AddListBox(ListBox.LIST_Y, 4, 3, 20, 5);
			gList2 = AddListBox(ListBox.LIST_Y, 4, 3, 20, 5);
			gList1.setPos(80, 195);
			gList2.setPos(410, 195);
			addListGift();
		}
		
		private function addListGift():void 
		{
			var config:Object = ConfigJSON.getInstance().getItemInfo("IsLand_AutoDig");
			for (var i:int = 1; i <= 2; i++ )
			{
				for (var str:String in config[i]["Gift"])
				{
					var container:Container = new Container(img, "AutoDigItemBg", 0, 0);
					container.SetScaleXY(0.8);
					var tip:TooltipFormat = new TooltipFormat();
					var txtNum:TextField = container.AddLabel("1", -10, 55, 0xFFFF00, 1, 0x717100);
					var item:Image;
					var obj:Object = config[i]["Gift"][str];
					var n1:int;
					var n2:int;
					switch (obj["ItemType"])
					{
						case "Exp":
							container.AddImage("", "IcExp", 40, 30);
							tip.text = "Kinh nghiệm";
							if (obj["Num"] as Array)
							{
								n1 = obj["Num"][0] / 1000000;
								n2 = obj["Num"][obj["Num"].length - 1] / 1000000;
								if (n1 > 0)
								{
									txtNum.text = Ultility.StandardNumber(n1) + "triệu~" + Ultility.StandardNumber(n2)+"triệu";
								}
								else
								{
									n1 = obj["Num"][0] / 1000;
									n2 = obj["Num"][obj["Num"].length - 1] / 1000;
									if (n1 > 0)
										txtNum.text = Ultility.StandardNumber(n1) + "K ~ " + Ultility.StandardNumber(n2)+"K";
									else
										txtNum.text = Ultility.StandardNumber(obj["Num"][0]) + "~" + Ultility.StandardNumber(obj["Num"][obj["Num"].length - 1]);
								}
							}
							else
							{
								txtNum.text = Ultility.StandardNumber(obj["Num"]);
							}
							break;
						case "Money":
							container.AddImage("", "IcGold", 40, 30);
							tip.text = "Tiền vàng";
							if (obj["Num"] as Array)	
							{
								n1 = obj["Num"][0] / 1000000;
								n2 = obj["Num"][obj["Num"].length - 1] / 1000000;
								if (n1 > 0)
								{
									txtNum.text = Ultility.StandardNumber(n1) + "triệu~" + Ultility.StandardNumber(n2)+"triệu";
								}
								else
								{
									n1 = obj["Num"][0] / 1000;
									n2 = obj["Num"][obj["Num"].length - 1] / 1000;
									if (n1 > 0)
										txtNum.text = Ultility.StandardNumber(n1) + "K ~ " + Ultility.StandardNumber(n2)+"K";
									else
										txtNum.text = Ultility.StandardNumber(obj["Num"][0]) + "~" + Ultility.StandardNumber(obj["Num"][obj["Num"].length - 1]);
								}
							}
							else
							{
								txtNum.text = Ultility.StandardNumber(obj["Num"]);
							}
							break;
						case "Material":
							tip.text = "Ngư thạch cấp " + obj["ItemId"];
							container.AddImage("", "Material" + obj["ItemId"] , 60, 50);
							if (obj["Num"] as Array)	txtNum.text = Ultility.StandardNumber(obj["Num"][0]) + "~" + Ultility.StandardNumber(obj["Num"][obj["Num"].length - 1]);
							else	txtNum.text = Ultility.StandardNumber(obj["Num"]);
							break;
						case "Island_Item":
							item = container.AddImage("", "IslandItem" + obj["ItemId"], 60, 65);
							tip.text = Localization.getInstance().getString(obj["ItemType"] + obj["ItemId"]);
							if (obj["Num"] as Array)	txtNum.text = Ultility.StandardNumber(obj["Num"][0]) + "~" + Ultility.StandardNumber(obj["Num"][obj["Num"].length - 1]);
							else	txtNum.text = Ultility.StandardNumber(obj["Num"]);
							break;
						case "EnergyItem":
							item = container.AddImage("", obj["ItemType"] + obj["ItemId"], 40, 30);
							tip.text = Localization.getInstance().getString(obj["ItemType"] + obj["ItemId"]);
							if (obj["Num"] as Array)	txtNum.text = Ultility.StandardNumber(obj["Num"][0]) + "~" + Ultility.StandardNumber(obj["Num"][obj["Num"].length - 1]);
							else	txtNum.text = Ultility.StandardNumber(obj["Num"][0]);
							break;
						case "RankPointBottle":
							item = container.AddImage("", obj["ItemType"] + obj["ItemId"], 45, 40);
							tip.text = Localization.getInstance().getString(obj["ItemType"] + obj["ItemId"]);
							if (obj["Num"] as Array)	txtNum.text = Ultility.StandardNumber(obj["Num"][0]) + "~" + Ultility.StandardNumber(obj["Num"][obj["Num"].length - 1]);
							else	txtNum.text = Ultility.StandardNumber(obj["Num"]);
							item.SetScaleXY(0.7);
							break;
						case "AllChest":
							item = container.AddImage("", obj["ItemType"] + obj["Color"] + "_" + obj["ItemType"], 45, 40);
							item.SetScaleXY(0.8);
							var rank:int;
							if (obj["Rank"] != undefined)	rank = obj["Rank"];
							else rank = obj["ItemId"];
							container.AddImage("", "ImgLaMa" + rank, 60, 55);
							tip.text = "Thần Bảo Rương\nNgẫu nhiên nhận được đồ";
							switch(rank)
							{
								case 1:
									tip.text += " Lưỡng Cực Thần";
									break;
								case 2:
									tip.text += " Anh Hùng Thần";
									break;
								case 3:
									tip.text += " Hoàng Kim Thần";
									break;
								case 4:
									tip.text += " Phượng Hoàng Thần";
									break;
							}
							txtNum.text = Ultility.StandardNumber(obj["Num"]);
							break;
						case "HammerWhite":
							container.AddImage("", "GuiTrungLinhThach_Hammer_1", 35, 30);
							tip.text = "Búa thường";
							txtNum.text = Ultility.StandardNumber(obj["Num"]);
							break;
						case "HammerGreen":
							container.AddImage("", "GuiTrungLinhThach_Hammer_2", 35, 30);
							tip.text = "Búa đặc biệt";
							txtNum.text = Ultility.StandardNumber(obj["Num"]);
							break;
						case "HammerYellow":
							container.AddImage("", "GuiTrungLinhThach_Hammer_3", 35, 30);
							tip.text = "Búa quý";
							txtNum.text = Ultility.StandardNumber(obj["Num"]);
							break;
						case "HammerPurple":
							container.AddImage("", "GuiTrungLinhThach_Hammer_4", 35, 30);
							tip.text = "Búa thần";
							txtNum.text = Ultility.StandardNumber(obj["Num"]);
							break;
						case "VipTag":
							container.AddImage("", obj["ItemType"] + obj["ItemId"], 35, 30);
							tip.text = "Bùa mở bảo rương VIP";
							txtNum.text = Ultility.StandardNumber(obj["Num"]);
							break;
					}
					container.setTooltip(tip);
					(this["gList" + i] as ListBox).addItem("", container, this);
				}
				AddButton(BTN_AUTO + "_" + i, "Btn_Xu", 170 + 335 * (i - 1), 500);
				AddLabel(config[i]["ZMoney"], 140 + 335 * (i - 1), 500, 0x008000, 1, 0xFFFFB3);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var id:int = (int)(data[1]);
			switch (command) 
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_AUTO:
					var config:Object = ConfigJSON.getInstance().getItemInfo("IsLand_AutoDig");
					if (GameLogic.getInstance().user.GetZMoney() >= config[id]["ZMoney"])
					{
						idChoice = id;
						if (GuiMgr.getInstance().guiTreasureIsLand.treasureList.length > 0)
							GuiMgr.getInstance().guiMsgTreasure.Show(Constant.GUI_MIN_LAYER, 1);
						else
							GuiMgr.getInstance().guiTreasureIsLand.sendAuto(idChoice);
					}
					else
					{
						GuiMgr.getInstance().GuiNapG.Init();
					}
					break;
			}
		}
		public var idChoice:int = 1;
	}

}