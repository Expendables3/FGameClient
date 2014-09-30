package GUI.unused
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.GuiMgr;
	
	import flash.events.*;
	import Logic.*;
	import Data.*;
	import GameControl.*;
	import NetworkPacket.PacketSend.SendSellStockThing;
	/**
	 * ...
	 * @author tuan
	 */
	public class GUISubInventory extends BaseGUI
	{
		private const GUI_BUYSHOP_BTN_OTHER:String = "Other";
		private const GUI_BUYSHOP_BTN_TREE:String = "OceanTree";
		private const GUI_BUYSHOP_BTN_ANIMAL:String = "OceanAnimal";
		
		private const GUI_BUYSHOP_BTN_NEXT:String = "BtnNext";
		private const GUI_BUYSHOP_BTN_BACK:String = "BtnBack";
		
		// con tro cac button
		private var btnOther:Button;
		private var btnTree:Button;
		private var btnAnimal:Button;
		
		// con tro cac label
		private var lblPage:TextField;
		
		// shop page
		public var CurrentPage:int = 0;
		public var CurrentShop:String = "Fish";
		private var MaxPage:int = 1;
		
		
		public function GUISubInventory(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUISubInventory";
			
		}
		
		
		public override function InitGUI() :void
		{
			//trace("FUCKCKCKCKCKCKFUCKCKCKCKCKCKFUCKCKCKCKCKCKFUCKCKCKCKCKCKFUCKCKCKCKCKCKFUCKCKCKCKCKCKFUCKCKCKCKCKCK");
			img = new Sprite();
			//try {
				Parent.addChild(img);
			//}catch (err:Error){
				//GameLogic.getInstance().CatchErr(err);
			//}
			SetPos(0, 0);			
		}
		
		
		private function AddItemSlots(nItem:int, maxRow:int, maxCol:int):void
		{
			var dx:int = 10;
			var dy:int = 40;
			var x0:int = 131;
			var y0:int = 100;
			var icon:Sprite = ResMgr.getInstance().GetRes( "CtnShopItem") as Sprite;
			var w:int = icon.width;
			var h:int = icon.height;
			var x:int, y:int;
			var r:int, c:int;
			
			for (var i:int = 0; i < nItem; i++)
			{
				if (i > maxRow * maxCol+1)
				{
					return;
				}
				
				r = i / maxCol;
				c = i % maxCol;
				x = x0 + c * (w + dx);
				y = y0 + r * (h + dy);
				var container:Container = AddContainer("", "CtnShopItem", x, y);
				//var container:Container = AddContainer("aaa", "test.png", x, y, false, this);
			}
		}
		
		
			
		private function InitShopButton():void
		{
			if ((CurrentShop == "OceanAnimal") || (CurrentShop == "OceanTree") || (CurrentShop == "Other"))
			{
				AddImage("", "BtnDeco2", 117, 56, true, ALIGN_LEFT_TOP);
				btnOther = AddButton(GUI_BUYSHOP_BTN_OTHER, "BtnDeco", 117, 54, this);
				
				AddImage("", "BtnDongVat2", 214, 56, true, ALIGN_LEFT_TOP);
				btnAnimal = AddButton(GUI_BUYSHOP_BTN_ANIMAL, "BtnDongVat", 214, 54, this);
				
				AddImage("", "BtnThucVat2", 314, 56, true, ALIGN_LEFT_TOP);
				btnTree = AddButton(GUI_BUYSHOP_BTN_TREE, "BtnThucVat", 314, 54, this);
				
				UpdateButtonFocusState();
			}
			
			if (MaxPage > 1)
			{
				var btnNext:ButtonEx = AddButtonEx(GUI_BUYSHOP_BTN_NEXT, "ButtonNext", 410, 510, this);
				var btnBack:ButtonEx = AddButtonEx(GUI_BUYSHOP_BTN_BACK, "ButtonBack", 320, 510, this);
				var txtFormat:TextFormat = new TextFormat("Arial", 28, 0xF8F3D6, true);
				lblPage = AddLabel("1/1", 330, 507, 0xF8F3D6);
				lblPage.text = (CurrentPage+1) + "/" + MaxPage.toString();
				lblPage.setTextFormat(txtFormat);
				
				if (CurrentPage == 0)
				{
					btnBack.SetDisable();
				}
				if (CurrentPage == MaxPage - 1)
				{
					btnNext.SetDisable();
				}
			}
		}
		
		private function UpdateButtonFocusState():void
		{
			btnOther.SetFocus(false);
			btnTree.SetFocus(false);
			btnAnimal.SetFocus(false);
			
			switch (CurrentShop)
			{
				case "Other":
					btnOther.SetFocus(true);
					break;
				case "OceanTree":
					btnTree.SetFocus(true);
					break;
				case "OceanAnimal":
					btnAnimal.SetFocus(true);
					break;
			}
		}
		
		public function InitInventory(ListName:String, page:int):void
		{
			var i:int;
			var obj:Object;
			var user:User = GameLogic.getInstance().user;
			var nRow:int = 2;
			var nCol:int = 4;
			var nPageSlot:int = nRow * nCol;
			
			CurrentShop = ListName;
			// clear current shop
			this.Hide();
			//this.Show(Constant.GUI_MIN_LAYER + 2);
			this.Show();
			
			var p:Point = GuiMgr.getInstance().GuiInvetory.CurPos;
			SetPos(p.x, p.y);
			CurrentPage = 0;
			var ItemList:Array = null;// GameLogic.getInstance().user.GetStockThings(ListName);
			
			if (ItemList.length <= 0)
			{
				var txtFormat:TextFormat = new TextFormat("Arial", 30, 0x707070);
				var txt:TextField = AddLabel(Localization.getInstance().getString("GUILabel1") , 340, 260);
				txt.setTextFormat(txtFormat);
			}
			
			// so page toi da
			MaxPage = Math.ceil(ItemList.length / nPageSlot);
			CurrentPage = page;
			if (CurrentPage >= MaxPage) 
			{
				CurrentPage = MaxPage - 1;
			}
			if (CurrentPage < 0)
			{
				CurrentPage = 0;
			}
			
			// them cac thanh phan GUI
			var vt:int = CurrentPage * nPageSlot;
			var nItem:int = nPageSlot;
			if (vt + nItem >= ItemList.length)
			{
				nItem = ItemList.length - vt;
			}
			AddItemSlots(nItem, nRow, nCol);

			
			
			for (i = vt; i < vt + nItem; i++)
			{		
				//st = ItemList[i] as StockThings;
				var st:StockThings = new StockThings();
				st.SetInfo(ItemList[i]);
				var container:Container = ContainerArr[i - vt] as Container;
				//obj = INI.getInstance().getItemInfo(st.Id.toString(), st.ItemType);
				obj = ConfigJSON.getInstance().getItemInfo(st.ItemType, st.Id);
				
				// icon bg
				var img:Image;
				if (obj["type"] != "Fish")
				{
					img = container.AddImage("", "CtnDoTrangTriBg", 59, 65);
				}
				else
				{
					img = container.AddImage("", "CtnMuaCaBg", 59, 55);
				}
				var w:int = img.img.width - 10;
				var h:int = img.img.height - 10;
				
				// icon cua item
				var imgName:String;
				switch (obj["type"])
				{
					case "Other":
						imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
						img = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);
						img.FitRect(w, h, new Point(12, 35));
						break;
					
					case "MixLake":
						imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
						img = container.AddImage("", imgName, 60, 70, true, ALIGN_LEFT_TOP);
						img.FitRect(w, h, new Point(16, 33));
						break;
					
					case "OceanTree":
						imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
						img = container.AddImage("", imgName, 66, 105, true, ALIGN_LEFT_TOP);
						img.FitRect(w, h, new Point(12, 30));
						break;
						
					case "OceanAnimal":
						imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
						img = container.AddImage("", imgName, 66, 100, true, ALIGN_LEFT_TOP);
						img.GoToAndStop(2);
						img.FitRect(w, h, new Point(12, 30));
						break;
					
					case "Fish":
						imgName = "Fish" + obj[ConfigJSON.KEY_ID] + "_Old_Idle";
						img = container.AddImage("", imgName, 66, 55, true, ALIGN_LEFT_TOP);
						img.FitRect(75, 75);
						break;
					//case "Food":
						//imgName = "ImgFoodBox";
						//img = container.AddImage("", imgName, 60, 66, true, ALIGN_LEFT_TOP);
						//break;
				}
			
				// ten cua item
				container.AddLabel(obj[ConfigJSON.KEY_NAME], 10, 2);
				
				// so luong
				container.AddLabel("Số lượng: " + st.Num, 10, 120);
				
				
				var btn:Button;
				
				// gia ban
				switch (obj["type"])
				{
					case "Fish":
						container.AddLabel("Giá bán: " + obj["gold"], 10, 132);
						// nut du`ng
						btn = container.AddButton("Sell_" + obj["type"] + "_" + st.Id, "ButtonSell", 40, 163, this);
						btn.img.scaleX = btn.img.scaleY = 0.8;
						break;
						
					default:
						container.AddLabel("Giá bán: " + obj["gold"] / 2, 10, 132);
						// nut ba'n
						btn = container.AddButton("Sell_" + obj["type"] + "_" + st.Id, "ButtonSell", 60, 163, this);
						btn.img.scaleX = btn.img.scaleY = 0.8;
						// nut du`ng
						btn = container.AddButton( "Use_" + obj["type"] + "_" + st.Id, "ButtonUse", 10, 163, this);
						btn.img.scaleX = btn.img.scaleY = 0.8;
						break;
				}
				
				
				
			}
			

			// them cac loai button khac
			InitShopButton();
		}
		
		
		public function Refresh():void
		{
			InitInventory(CurrentShop, CurrentPage);
			GuiMgr.getInstance().GuiInvetory.UpdateXuGold();
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_BUYSHOP_BTN_OTHER:
				case GUI_BUYSHOP_BTN_TREE:
				case GUI_BUYSHOP_BTN_ANIMAL:
				InitInventory(buttonID, 0);
				break;
				
				case GUI_BUYSHOP_BTN_NEXT:
				if (CurrentPage < MaxPage - 1)
				{
					InitInventory(CurrentShop, CurrentPage + 1);
				}
				break;
				
				case GUI_BUYSHOP_BTN_BACK:
				if (CurrentPage > 0)
				{
					InitInventory(CurrentShop, CurrentPage - 1);
				}
				break;

				default:
					ActOnStockThing(buttonID);
				break;
				

			}
		}
		
		
		public function ActOnStockThing(ID:String):void
		{
			var data:Array = ID.split("_");
			if (data.length != 3) return;
			
			var actType:String = data[0];
			var objType:String = data[1];
			var objID:int = data[2];
			
			if (actType == "Use")
			{
				UseStockThing(objType, objID);
			}
			else if (actType == "Sell")
			{
				SellStockThing(objType, objID);
			}
		}
		
		public function UseStockThing(type:String, id:int):void
		{
			switch (type)
			{
				case "Fish":
					break;
				default:
					UseDecorate(id, type);
					break;
			}
		}		
		
		public function SellStockThing(type:String, id:int):void
		{
			switch (type)
			{
				case "Fish":
					SellFish(id, type);
					break;
					
				default:
					SellDecorate(id, type);
					break;
			}
		}
		
		public function UseDecorate(ItemID:int, ItemType:String):void
		{
			var pt:Point = Ultility.PosScreenToLake(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y);
			GameLogic.getInstance().gameState = GameState.GAMESTATE_USE_DECORATE;
			
			var deco:Decorate = new Decorate(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), ItemType + ItemID, pt.x, pt.y, ItemType, ItemID);
			//deco.ItemId = ItemID;
			//deco.SetPos(pt.x, pt.y);
			//deco.ItemType = ItemType;
			GameController.getInstance().SetActiveObject(deco);	
			GameController.getInstance().UpdateActiveObjPos(pt.x, pt.y);
			
			var st:StockThings = new StockThings();
			st.Id = ItemID;
			st.ItemType = ItemType;
			st.Num = 1;
			DecreaseItem(st, 1);
			Refresh();
			
			this.Hide();
			GuiMgr.getInstance().GuiInvetory.Hide();
			// show cover layer
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			if (layer != null)
			{
				layer.ShowDisableScreen(0.1);
			}
		}
		
		public function SellDecorate(ItemID:int, ItemType:String):void
		{
			var st:StockThings = new StockThings();
			st.Id = ItemID;
			st.ItemType = ItemType;
			st.Num = 1;
			GameLogic.getInstance().SellStockDecorate(st);
		}
		
		public function SellFish(ItemID:int, ItemType:String):void
		{
			var st:StockThings = new StockThings();
			st.Id = ItemID;
			st.ItemType = ItemType;
			st.Num = 1;
			GameLogic.getInstance().SellStockFish(st);
		}
		
		public function DecreaseItem(item:StockThings, num:int):void
		{
			var StockThingsArr:Array = GameLogic.getInstance().user.StockThingsArr[item.ItemType];
			for (var i:int = 0; i < StockThingsArr.length; i++ )
			{				
				if (StockThingsArr[i].Id == item.Id)
				{
					StockThingsArr[i].Num -= num;
					if (StockThingsArr[i].Num <= 0)
					{
						StockThingsArr[i].Num = 0;
						StockThingsArr.splice(i, 1);
					}
					break;
				}
			}
		}

	}

}