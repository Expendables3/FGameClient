package GUI.Collection 
{
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GameControl.HelperMgr;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.QuestMgr;
	import NetworkPacket.PacketSend.Collection.SendBuyItemCollection;
	import NetworkPacket.PacketSend.Collection.SendExchangeCollection;
	
	/**
	 * Bộ sưu tập: các item và quà
	 * @author dongtq
	 */
	public class SetCollection extends Container 
	{
		static public const BTN_CLAIM:String = "btnClaim";
		static public const BTN_BUY:String = "btnBuy";
		static public const IC_HELPER:String = "icHelper";
		public var listItem:Object;
		public var buttonClaim:Button;
		private var ctnReward:Container;
		private var setId:int;
		private var rewardColor:int;
		private var rewardRank:int;
		
		public var rewardTab:String;
		public var rewardType:String;
		public var rewardId:int;
		public var rewardNum:int;
		
		
		public function SetCollection(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, "GuiCollection_SetCollection_Bg", x, y, isLinkAge, imgAlign);
		}
		
		public function initSetCollection(data:Object, idPage:String):void
		{
			buttonClaim = AddButton(BTN_CLAIM, "GuiCollection_Btn_Exchange", 350 + 176, 60 + 48);
			
			rewardTab = idPage;
			rewardType = data["ItemType"];
			rewardId = data["ItemId"];
			rewardNum = data["Num"];
			rewardColor = data["Color"];
			rewardRank = data["Rank"];
			setId = data["Id"];
			var txtFormat:TextFormat;
			
			listItem = new ListBox(ListBox.LIST_X, 1, 5, 15);
			listItem = new Object();
			var i:int = 0;
			for each(var item:Object in data["NecessaryItem"])
			{
				var itemCollection:ItemCollection = new ItemCollection(img);
				itemCollection.initItemCollection(item["ItemType"], item["ItemId"], item["Num"]);
				listItem[item["ItemId"]] =  itemCollection;
				itemCollection.SetPos(i * 90, 0);
				i++;
				this.img.addChild(itemCollection.img);
				
				//Cho mua itemcollection ao giáp
				if (idPage == "Armor")
				{
					var btnG:Button = itemCollection.AddButton(BTN_BUY + "_" + item["ItemId"], "BtnBuyXu", 32, 117, this);
					//btnG.img.scaleX = btnG.img.scaleY = 0.6;
					itemCollection.AddLabel("1", 13, 117);
				}
			}
			
			buttonClaim.SetEnable(canClaim());
			
			if (rewardType == "Money")
			{
				ctnReward = AddContainer("", "IcGold", 450 + 75, 60 - 40);
				ctnReward.SetScaleXY(2);
				txtFormat = new TextFormat("arial", 28, 0xffffff, true);
				AddLabel(rewardNum.toString(), 497, 70, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
				AddLabel("Tiền vàng", 0, 0, 0xffff00, 0, 0x000000);
			}
			else if (rewardType == "Exp")
			{
				ctnReward = AddContainer("", "ImgEXP", 450 + 60, 60 - 47);
				ctnReward.SetScaleXY(2);
				txtFormat = new TextFormat("arial", 28, 0xffffff, true);
				AddLabel(rewardNum.toString(), 497, 70, 0xffffff, 1, 0x000000).setTextFormat(txtFormat);
				AddLabel("Kinh nghiệm", 0, 0, 0xffff00, 0, 0x000000);
			}
			else 
			{
				var trunkName:String = "";
				var quality:String = "";
				switch(rewardColor)
				{
					case 1:
						trunkName = "Thiết Bảo Rương";
						quality = "Thường";
						break;
					case 2:
						trunkName = "Ngân Bảo Rương";
						quality = "Đặc Biệt";
						break;
					case 3:
						trunkName = "Hoàng Kim Bảo Rương";
						quality = "Quý";
						break;
					case 4:
						trunkName = "Thần Bảo Rương";
						quality = "Thần";
						break;
				}
				
				var tabName:String = "";
				switch(rewardTab)
				{
					case "Weapon":
						tabName = "Vũ Khí";
						break;
					case "Armor":
						tabName = "Áo Giáp";
						break;
					case "Helmet":
						tabName = "Mũ Giáp";
						break;
					case "Sea":
					case "MetalSea":
					case "IceSea":
						tabName = "Đồ Trang Sức";
						break;
				}
				AddLabel(trunkName, 0, 0, 0xffff00, 0, 0x000000);
				trunkName += " - " + tabName;
				trunkName += "\n Mở ra nhận ngẫu nhiên " + tabName;
				switch(rewardRank)
				{
					case 1:
						trunkName += " Lưỡng Cực ";
						break;
					case 2:
						trunkName += " Anh Hùng ";
						break;
				}
				trunkName += quality;
				
				var pageTrunk:String;
				if (idPage == "IceSea" || idPage == "Sea" || idPage == "MetalSea")
				{
					pageTrunk = "Jewel";
				}
				else
				{
					pageTrunk = idPage;
				}
				
				ctnReward = AddContainer("", "GuiCollection_" + pageTrunk + "_Trunk_" + rewardColor, 450 + 62 - 17, 60 - 57 + 13);
				AddImage("", "GuiCollection_Trunk_Level_" + rewardRank, 450 + 62 - 17, 87, true, ALIGN_LEFT_TOP);
				//trace("GuiCollection_" + pageTrunk + "_Trunk_" + rewardId);
				var tooltipFormat:TooltipFormat = new TooltipFormat();
				tooltipFormat.text = trunkName;
				ctnReward.setTooltip(tooltipFormat);
				
			}
		}
		
		public function initData(data:Object):void 
		{
			for (var s:String in data)
			{
				if(listItem[data[s]["Id"]] != null)
				{
					ItemCollection(listItem[data[s]["Id"]]).num = data[s]["Num"];
				}
			}
			
			buttonClaim.SetEnable(canClaim());
			//Tutorial
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("BtnExchangeCollection") >= 0 && canClaim() && rewardTab == "Weapon" && setId == 1)
			{
				AddImage(IC_HELPER, "IcHelper", buttonClaim.img.x + 37, buttonClaim.img.y + 12);
			}
		}
		
		public function canClaim():Boolean
		{
			for each(var itemCollection:ItemCollection in listItem)
			{
				if (itemCollection.num < itemCollection.numRequire)
				{
					return false;
				}
			}
			return true;
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_CLAIM:
					//Tutorial
					RemoveImage(GetImage(IC_HELPER));
					
					if (!GuiMgr.getInstance().guiCollection.isGettingGift)
					{
						//Gửi gói tin
						Exchange.GetInstance().Send(new SendExchangeCollection(rewardTab, setId));
						
						//Add vật phẩm nhận đc
						if (rewardType == "Exp")
						{
							EffectMgr.setEffBounceDown(rewardNum.toString() + " kinh nghiệm", "ImgEXP", 335, 300);
							
							GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + rewardNum);
						}
						else if (rewardType == "Money")
						{
							EffectMgr.setEffBounceDown(rewardNum.toString() + " vàng", "IcGold", 335, 300);
							
							GameLogic.getInstance().user.UpdateUserMoney(rewardNum);
						}
						else
						{
							GuiMgr.getInstance().guiCollection.isGettingGift = true;
							
							//Disable screen
							var x:int = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).stage.fullScreenWidth;
							var y:int = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER).stage.fullScreenHeight;
							var Fog:Sprite = new Sprite();
							Fog.graphics.beginFill(0x000000, 0.5);
							Fog.graphics.drawRect(-x, -y, x*2, y*2);
							Fog.graphics.endFill();
							var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
							layer.addChild(Fog);
							EffectMgr.setEffBounceDown("", "GuiCollection_Open_Trunk_" + rewardColor, 335, 300, showGift);
							
							var equipFly:String = rewardTab;
							if (rewardTab == "Sea" || rewardTab == "MetalSea" || rewardTab == "IceSea")
							{
								equipFly = "Jewel";
							}
							EffectMgr.setEffBounceDown("", "GuiCollection_" + equipFly + "_Fly", 335, 300);
							
							function showGift():void
							{
								layer.removeChild(Fog);	
								if (GuiMgr.getInstance().guiCollection.serverRespond)
								{
									GameLogic.getInstance().showGiftCollection();
								}
								else
								{
									GuiMgr.getInstance().guiCollection.finishEff = true;
								}
							}
						}
						
						//Cập nhật dữ liệu túi đồ và gui collection
						var dataCollection:Object = GameLogic.getInstance().user.StockThingsArr["ItemCollection"];
						for each(var obj:Object in dataCollection)
						{
							for each(var itemCollection:ItemCollection in listItem)
							{
								if(obj["Id"] == itemCollection.itemId)
								{
									obj["Num"] -= itemCollection.numRequire;
								}
							}
						}
						
						GuiMgr.getInstance().guiCollection.initData(dataCollection);
						
						//Nếu không đủ bộ nữa thì reset thuộc tính show gui hoàn thành bộ sưu tập này
						/*if (!canClaim())
						{
							//trace("completed", rewardTab, rewardType + rewardId);
							GameLogic.getInstance().completedCollection[rewardTab][rewardType + rewardId] = false;
						}*/
					}
					break;
				default:
					if (buttonID.search(BTN_BUY) >= 0)
					{
						if ( GameLogic.getInstance().user.GetZMoney() >= 1)
						{
							var itemId:int = buttonID.split("_")[1];
							var item:ItemCollection = listItem[itemId] as ItemCollection;
							Exchange.GetInstance().Send(new SendBuyItemCollection(itemId));
							EffectMgr.setEffBounceDown("Mua thành công", item.itemType + item.itemId, 340, 300);
							item.num++;
							GameLogic.getInstance().user.UpdateStockThing(item.itemType, item.itemId, 1);
							GameLogic.getInstance().user.UpdateUserZMoney( -1);
							
							GuiMgr.getInstance().guiCollection.curPage.updateInfo();
						}
						else
						{
							GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
						}
					}
					break
			}
		}
		
		public function updateBtnClaim():void
		{
			if (canClaim())
			{
				GetButton(BTN_CLAIM).SetEnable(true);
			}
			else
			{
				GetButton(BTN_CLAIM).SetEnable(false);
			}
		}
	}

}