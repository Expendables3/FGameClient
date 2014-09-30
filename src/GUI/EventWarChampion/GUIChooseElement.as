package GUI.EventWarChampion 
{
	import Data.ConfigJSON;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.EventWarChampion.SendGetRewardWarChampion;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIChooseElement extends BaseGUI 
	{
		private var element:int;
		private var rewardType:int;
		private var idWeek:int;
		static public const BTN_GET_GIFT:String = "btnGetGift";
		static public const BTN_CLOSE:String = "btnClose";
		static public const CTN_ELEMENT:String = "ctnElement";
		
		public function GUIChooseElement(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUI_Choose_Element");
			AddButton(BTN_GET_GIFT, "Btn_Get_Gift", 177 + 24, 148 + 130).SetEnable(false);
			AddButton(BTN_CLOSE, "BtnThoat", 512 - 18, 48, this);	
			SetPos(157, 100);
			
			OpenRoomOut();
		}
		
		override public function EndingRoomOut():void 
		{
			for (var i:int = 0; i < 5; i++)
			{
				var ctnElement:Container = AddContainer(CTN_ELEMENT + "_" +  (i + 1).toString(), "Item_Element_Bg", i * 89 + 50, 140, true, this);
				ctnElement.AddImage("", "Element" + (i + 1), 38, 38);
				ctnElement.img.buttonMode = true;
			}
		}
		
		public function showGUI(rewardType:int, idWeek:int):void
		{
			Show(Constant.GUI_MIN_LAYER, 6);
			this.rewardType = rewardType;
			this.idWeek = idWeek;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLOSE:
					Hide();
					break;
				case BTN_GET_GIFT:
					//trace(element);
					Exchange.GetInstance().Send(new SendGetRewardWarChampion(rewardType, idWeek, element));
					
					//Sinh id do moi
					var config:Object = ConfigJSON.getInstance().getItemInfo("EventInGameFW_Reward", -1);
					var obj:Object;
					var i:int;
					if(rewardType == 2)
					{
						GuiMgr.getInstance().guiWarChampion.tabTopUserWeek.GetButton(GUIWarChampion.BTN_TOP_GIFT_WEEK).SetEnable(false);
						if (GameLogic.getInstance().user.GetMyInfo().outGameFW == null)
						{
							GameLogic.getInstance().user.GetMyInfo().outGameFW = new Object();
							GameLogic.getInstance().user.GetMyInfo().outGameFW["Reward"] = new Object();
						}
						else if(GameLogic.getInstance().user.GetMyInfo().outGameFW["Reward"] == null)
						{
							GameLogic.getInstance().user.GetMyInfo().outGameFW["Reward"] = new Object();
						}
						GameLogic.getInstance().user.GetMyInfo().outGameFW["Reward"][idWeek] = true;
						var topWeek:int = GuiMgr.getInstance().guiWarChampion.topWeek;
						var imgNameGift:String;
						if (topWeek > 5)
						{
							imgNameGift = "LiXi_5";
						}
						else
						{
							imgNameGift = "LiXi_" + topWeek;
						}
						GuiMgr.getInstance().guiCongratulation.showReward(imgNameGift, 1, "Phần thưởng top " + topWeek + " tuần");
						
						
						//Sinh id qua
						var typeGift:int = topWeek;
						//var test:int = 0;
						if (topWeek >= 4 && topWeek <=10)
						{
							typeGift = 4;
						}
						//Giai 1 den 4
						if (typeGift < 5)
						{
							for each(obj in config["Weekly"][typeGift]["Reward"])
							{
								//trace("type       :", obj["ItemType"], obj["Num"]);
								if (obj["ItemType"] != null && (obj["ItemType"] == "Weapon" || obj["ItemType"] == "Armor" || obj["ItemType"] == "Helmet" 
								|| obj["ItemType"] == "Ring" || obj["ItemType"] == "Necklace" || obj["ItemType"] == "Bracelet" || obj["ItemType"] == "Belt"))
								{
									for (i = 0; i < obj["Num"]; i++)
									{
										GameLogic.getInstance().user.GenerateNextID();
									}
									//test += obj["Num"];
								}
							}
						}
						//trace("so id tang them", test);
						//Giai ghi danh
						//else
						//{
							//GameLogic.getInstance().user.GenerateNextID();
						//}
					}
					else
					{
						GuiMgr.getInstance().guiWarChampion.tabTopUserMonth.GetButton(GUIWarChampion.BTN_TOP_GIFT_MONTH).SetEnable(false);
						if (GameLogic.getInstance().user.GetMyInfo().outGameFW == null)
						{
							GameLogic.getInstance().user.GetMyInfo().outGameFW = new Object();
							GameLogic.getInstance().user.GetMyInfo().outGameFW["Reward"] = new Object();
						}
						else if(GameLogic.getInstance().user.GetMyInfo().outGameFW["Reward"] == null)
						{
							GameLogic.getInstance().user.GetMyInfo().outGameFW["Reward"] = new Object();
						}
						GameLogic.getInstance().user.GetMyInfo().outGameFW["Reward"]["Month"] = true;
						var topMonth:int = GuiMgr.getInstance().guiWarChampion.topMonth;
						
						//Sinh id qua
						var typeGiftM:int = topMonth;
						if (topMonth >= 4 && topMonth <=100)
						{
							typeGiftM = 4;
						}
						
						GuiMgr.getInstance().guiCongratulation.showReward("LiXi_" + typeGiftM, 1, "Phần thưởng top " + topMonth +  " tháng");
						
						//var test:int = 0;
						if (typeGiftM < 5)
						{
							for each(obj in config["Month"][typeGiftM]["Reward"])
							{
								if (obj["ItemType"] != null && (obj["ItemType"] == "Weapon" || obj["ItemType"] == "Armor" || obj["ItemType"] == "Helmet" 
								|| obj["ItemType"] == "Ring" || obj["ItemType"] == "Necklace" || obj["ItemType"] == "Bracelet" || obj["ItemType"] == "Belt"))
								{
									for (i = 0; i < obj["Num"]; i++)
									{
										GameLogic.getInstance().user.GenerateNextID();
									}
									//test += obj["Num"];
								}
							}
						}
						else
						{
							//trace("type gift month", typeGiftM);
						}
						
						//trace("So do tang id", test);
					}
					
					Hide();
					break;
				default:
					if (buttonID.search(CTN_ELEMENT) >= 0)
					{
						for each(var ctnElement:Container in ContainerArr)
						{
							if (ctnElement.IdObject == buttonID)
							{
								ctnElement.SetHighLight(0xff0000);
								var arr:Array = ctnElement.IdObject.split("_");
								element = arr[1];
								GetButton(BTN_GET_GIFT).SetEnable(true);
							}
							else
							{
								ctnElement.SetHighLight( -1);
							}
						}
					}
			}
			
		}
	}

}