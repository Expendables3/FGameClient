package GUI.BlackMarket 
{
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.BlackMarket.SendBuyItemShopMarket;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class ItemShopMarket extends Container 
	{
		private var tabType:String;
		private var subTab:String;
		private var imageObject:Image;
		public var data:Object;
		static public const BTN_DIAMOND:String = "btnDiamon";
		static public const BTN_G:String = "btnG";
		public var idItemShop:int;
		
		public function ItemShopMarket(parent:Object, imgName:String = "GuiShopMarket_ItemShopBg", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		
		public function initItem(_data:Object, _idItemShop:int, _tabType:String, _subTab:String):void
		{
			idItemShop = _idItemShop;
			data = _data;
			tabType = _tabType;
			subTab = _subTab;
			var imageName:String = "Blessing_5";
			var name:String = "Giấy Ăn";
			switch(data["ItemType"])
			{
				case "Draft":
				case "Paper":
				case "GoatSkin":
				case "Blessing":
					imageName = data["ItemType"] + "_" + data["ItemId"];
					name = Localization.getInstance().getString(data["ItemType"]);
					break;
				case "Helmet":
				case "Armor":
				case "Weapon":
				case "Bracelet":
				case "Belt":
				case "Ring":
				case "Necklace":
					imageName = data["ItemType"] + data["Rank"] + "_Shop";
					name = Localization.getInstance().getString(data["ItemType"] + (int(data["Element"]) * 100 + int(data["Rank"])));
					break;
				case "Seal":
					imageName = data["ItemType"] + data["ItemId"] + "_Shop";
					name = Localization.getInstance().getString(data["ItemType"] + data["ItemId"]);
					break;
				case "Ginseng":
				case "RecoverHealthSoldier":
				case "GodCharm":
				case "Samurai":
				case "BuffRank":
				case "BuffExp":
				case "Resistance":
				case "BuffMoney":
				case "StoreRank":
					imageName = data["ItemType"] + data["ItemId"];
					name = Localization.getInstance().getString(data["ItemType"] + data["ItemId"]);
					name = name.split("\n")[0];
					break;
				case "Diamond":
					imageName = "GuiShopMarket_" + data["ItemType"] + data["ItemId"];
					name = data["Num"] + " Kim Cương";
					break;
				case "Ticket":
					imageName = "GuiShopMarket_" + data["ItemType"] + data["ItemId"];
					name = data["Num"] + " Vỏ Sò";
					AddImage("", "IcNewShop", 160, 70);
					break;
				default:
					imageName = data["ItemType"] + data["ItemId"];
					name = Localization.getInstance().getString(data["ItemType"] + data["ItemId"]);
					break;
			}
			//trace(imageName);
			
			imageObject = AddImage("", imageName, 10, 10);
			imageObject.FitRect(80, 80, new Point(55, 50));
			
			var lableName:TextField = AddLabel(name, 48, 20, 0x26709C, 1);
			var txtFormat:TextFormat = new TextFormat("arial", 14, 0x26709C, true);
			lableName.setTextFormat(txtFormat);
			
			if (data["Diamond"] > 0)
			{
				AddButton(BTN_DIAMOND, "GuiShopMarket_BtnDiamon", 40, 149);
				var numDiamond:int = data["Diamond"];
				AddLabel(numDiamond.toString(), 40, 149, 0xffffff);
			}
			else
			{
				AddButton(BTN_G, "GuiShopMarket_BtnG", 65, 149);
				var zMoney:int = data["ZMoney"];
				AddLabel(zMoney.toString(), 40, 149, 0xffffff);
			}
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var guiShopMarket:GUIShopMarket = GuiMgr.getInstance().guiShopMarket;
			switch(buttonID)
			{
				case BTN_DIAMOND:
					if (data["Diamond"] <= GameLogic.getInstance().user.getDiamond())
					{
						if (subTab == "Weapon" || subTab == "Armor" || subTab == "Helmet" || data["ItemType"] == "Seal")
						{
							GameLogic.getInstance().user.GenerateNextID();
						}
						var sendBuyItem:SendBuyItemShopMarket = new SendBuyItemShopMarket(tabType, idItemShop, subTab);
						Exchange.GetInstance().Send(sendBuyItem);
						
						EffectMgr.setEffBounceDown("Mua thành công", imageObject.ImgName, 330, 280);
						EffectMgr.getInstance().textFly("-" + data["Diamond"], new Point(358 + 56, 562 + 30), new TextFormat("arial", 18, 0xff00ff, true), null, 0, -20);
						
						
						guiShopMarket.numDiamond -= data["Diamond"];
						GameLogic.getInstance().user.setDiamond(GuiMgr.getInstance().guiShopMarket.numDiamond);
						
						updateToStore(data);
					}
					else
					{
						GuiMgr.getInstance().guiNoDiamond.Show(Constant.GUI_MIN_LAYER, 3);
					}
					break;
				case BTN_G:
					if (data["ZMoney"] <= GameLogic.getInstance().user.GetZMoney())
					{
						var sendBuyDiamond:SendBuyItemShopMarket = new SendBuyItemShopMarket(tabType, idItemShop, subTab);
						Exchange.GetInstance().Send(sendBuyDiamond);
						
						GameLogic.getInstance().user.UpdateUserZMoney( -data["ZMoney"]);
						EffectMgr.setEffBounceDown("Mua thành công", imageObject.ImgName, 330, 280);
						EffectMgr.getInstance().textFly("+" + data["Num"], new Point(358 + 56, 562 + 30), new TextFormat("arial", 18, 0xff00ff, true), null, 0, -20);
						
						guiShopMarket.numDiamond += data["Num"];
						GameLogic.getInstance().user.setDiamond(GuiMgr.getInstance().guiShopMarket.numDiamond);
					}
					else
					{
						GuiMgr.getInstance().GuiNapG.Show(Constant.GUI_MIN_LAYER, 3);
					}
					break;
			}
		}
		
		private function updateToStore(data:Object):void
		{
			var itemType:String = data["ItemType"];
			switch(itemType)
			{
				case "Draft":
				case "Paper":
				case "GoatSkin":
				case "Blessing":
				case "Ginseng":
				case "RecoverHealthSoldier":
				case "GodCharm":
				case "Samurai":
				case "BuffRank":
				case "BuffExp":
				case "Resistance":
				case "BuffMoney":
				case "StoreRank":
				case "Material":
					GuiMgr.getInstance().GuiStore.UpdateStore(itemType, data["ItemId"], data["Num"]);
					break;
				case "Ticket":
					GameLogic.getInstance().user.GetMyInfo().Ticket += data["Num"];
					break;
			}
		}
		
	}

}