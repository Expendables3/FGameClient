package GUI.unused
{
	import com.greensock.motionPaths.RectanglePath2D;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import flash.events.*;
	import Logic.*;
	import Data.*;
	import GameControl.*;
	import NetworkPacket.PacketSend.SendUpgradeLake;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class GUIBuyShop extends BaseGUI
	{
		private const GUI_BUYSHOP_BTN_OTHER:String = "Other";
		private const GUI_BUYSHOP_BTN_TREE:String = "OceanTree";
		private const GUI_BUYSHOP_BTN_ANIMAL:String = "OceanAnimal";
		private const GUI_BUYSHOP_BTN_FOOD:String = "Food";
		
		private const GUI_BUYSHOP_BTN_NEXT:String = "BtnNext";
		private const GUI_BUYSHOP_BTN_BACK:String = "BtnBack";
		
		// con tro cac button
		private var btnOther:Button;
		private var btnTree:Button;
		private var btnAnimal:Button;
		
		// con tro cac label
		private var lblPage:TextField;

		public var BuyType:String = "Money";
		public var BuyObjID:int = 0;
		
		// shop page
		public var CurrentPage:int = 0;
		public var CurrentShop:String = "Fish";
		private var MaxPage:int = 1;
		
		public function GUIBuyShop(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIBuyShop";
		}
		
		public override function InitGUI() :void
		{
			//trace("FUCKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
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
			var dx:int = 5;
			var dy:int = 5;
			var x0:int = 51;
			var y0:int = 134;
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
				AddImage("", "BtnDeco2", 58, 97, true, ALIGN_LEFT_TOP);
				btnOther = AddButton(GUI_BUYSHOP_BTN_OTHER, "BtnDeco", 58, 97, this, INI.getInstance().getHelper("helper3"));
				
				AddImage("", "BtnDongVat2", 156, 97, true, ALIGN_LEFT_TOP);
				btnAnimal = AddButton(GUI_BUYSHOP_BTN_ANIMAL, "BtnDongVat", 156, 97, this);
				
				AddImage("", "BtnThucVat2", 256, 97, true, ALIGN_LEFT_TOP);
				btnTree = AddButton(GUI_BUYSHOP_BTN_TREE, "BtnThucVat", 256, 97, this, INI.getInstance().getHelper("helper11"));
				
				UpdateButtonFocusState();
				lblPage = null;
			}
			
			if (MaxPage > 1)
			{
				var btnNext:Button = AddButton(GUI_BUYSHOP_BTN_NEXT, "BtnNextShop", 631, 295, this);
				var btnBack:Button = AddButton(GUI_BUYSHOP_BTN_BACK, "BtnPreShop", 5, 295, this);
				
				//Add số trang
				//var txtFormat:TextFormat = new TextFormat("Arial", 28, 0xF8F3D6, true);
				//lblPage = AddLabel("1/1", 320, 510, 0xF8F3D6);
				//lblPage.text = (CurrentPage+1) + "/" + MaxPage.toString();
				//lblPage.setTextFormat(txtFormat);
				
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
		
		public function InitShop(ListName:String, page:int):void
		{
			var i:int;
			var obj:Object;
			var user:User = GameLogic.getInstance().user;
			var nRow:int = 2;
			var nCol:int = 3;
			var nPageSlot:int = nRow * nCol;
			
			CurrentShop = ListName;
			// clear current shop
			this.Hide();
			this.Show(Constant.GUI_MIN_LAYER);
			//this.Show();
			
			var p:Point = GuiMgr.getInstance().GuiShop.CurPos;
			SetPos(p.x, p.y);
			CurrentPage = 0;
			var ItemList:Array = INI.getInstance().getItemList(ListName);
			
			// loc ra nhung cai 0 mua dc
			for (i = 0; i < ItemList.length; i++)
			{
				switch (ItemList[i]["type"])
				{
					case "LakeUnlock":
					case "LakeUpgrade":
						obj = ItemList[i];
						break;
					default:
						obj = INI.getInstance().getItemInfo(ItemList[i][ConfigJSON.KEY_ID], ItemList[i]["type"]);
						break;
				}
				
				if (obj["type"] == "LevelMixLake")
				{
					if (obj[ConfigJSON.KEY_ID] != (user.LevelMixLake+1))
					{
						ItemList.splice(i, 1);
						i = i - 1;
						continue;
					}
				}
				
				if ((obj["UnlockType"] == 3) || (obj["UnlockType"] == 5) || (obj["UnlockType"] == 6))
				{
					ItemList.splice(i, 1);
					i = i - 1;
					continue;
				}
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
				var CanBuy:Boolean = true;
				switch (ItemList[i]["type"])
				{
					case "LakeUnlock":
					case "LakeUpgrade":
						obj = ItemList[i];
						break;
					default:
						obj = INI.getInstance().getItemInfo(ItemList[i][ConfigJSON.KEY_ID], ItemList[i]["type"]);
						break;
				}
				var container:Container = ContainerArr[i - vt] as Container;
				
				// icon bg
				var image:Image;
				//var w:int;
				//var h:int;
				if (obj["type"] == "Fish" || obj["type"] == "LakeUpgrade" || obj["type"] == "LakeUnlock" || obj["type"] == "LevelMixLake")
				{
					image = container.AddImage("", "CtnMuaCaBg", container.img.width/ 2, 55);
					
				}
				else
				{
					image = container.AddImage("", "CtnDoTrangTriBg", container.img.width/ 2, 70);
				}
				//w = image.img.width - 10;
				//h = image.img.height - 10;				
				var rect:Rectangle = image.img.getBounds(container.img);
				
				// icon cua item
				var lbl:TextField;
				var txtFormat:TextFormat;
				
				var imgName:String;
				switch (obj["type"])
				{
					case "LakeUpgrade"://Mở rộng hồ
						imgName = "IconUpgradeLake";
						image = container.AddImage("", imgName, 62, 100, true, ALIGN_LEFT_TOP);
						//image.FitRect(w, h, new Point(12, 30));
						image.FitRect(rect.width, rect.height, new Point(rect.x, rect.y));
						// ten ho`
						lbl = container.AddLabel(obj[ConfigJSON.KEY_ID], image.img.x - 79, image.img.y - 60);
						txtFormat = new TextFormat("Arial", 16, 0xffffff, true);
						lbl.setTextFormat(txtFormat);
						Ultility.SetHightLight(lbl);
						
					break;
					case "LakeUnlock"://Mua hồ mới
						imgName = "IconUnlockLake";
						image = container.AddImage("", imgName, 62, 100, true, ALIGN_LEFT_TOP);
						//image.FitRect(w, h, new Point(12, 30));
						image.FitRect(rect.width, rect.height, new Point(rect.x, rect.y));
						lbl = container.AddLabel(obj[ConfigJSON.KEY_ID], image.img.x - 81, image.img.y - 34);
						txtFormat = new TextFormat("Arial", 16, 0xffffff, true);
						lbl.setTextFormat(txtFormat);
						Ultility.SetHightLight(lbl);
					break;
					case "Other":
						imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
						image = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);
						//image.FitRect(w, h, new Point(12, 35));
						image.FitRect(rect.width, rect.height, new Point(rect.x, rect.y));
					break;
					
					case "MixLake":
						imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
						image = container.AddImage("", imgName, 60, 70, true, ALIGN_LEFT_TOP);
						//image.FitRect(w, h, new Point(16, 33));
						image.FitRect(rect.width, rect.height, new Point(rect.x, rect.y));
					break;
					
					case "OceanTree":
						imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
						image = container.AddImage("", imgName, 66, 105, true, ALIGN_LEFT_TOP);
						//image.FitRect(w, h, new Point(12, 30));
						image.FitRect(rect.width, rect.height, new Point(rect.x, rect.y));
						break;
						
					case "OceanAnimal":
						imgName = obj["type"] + obj[ConfigJSON.KEY_ID];
						image = container.AddImage("", imgName, 66, 100, true, ALIGN_LEFT_TOP);
						image.GoToAndStop(2);
						//image.FitRect(w, h, new Point(12, 30));
						image.FitRect(rect.width, rect.height, new Point(rect.x, rect.y));
						break;
					
					case "Fish":
						imgName = GetFishImageName(obj);
						image = container.AddImage("", imgName, 60, 55, true, ALIGN_LEFT_TOP);						
						//image.FitRect(75, 75);
						image.FitRect(rect.width, rect.height, new Point(rect.x, rect.y));
						
						// kiem tra xem co mua dc ko
						if (obj["UnlockType"] != 1)
						{
							CanBuy = GameLogic.getInstance().user.CheckFishUnlocked(obj[ConfigJSON.KEY_ID]);
							container.AddImage("", "IconUnlockFish", 18, 38);
							if (!CanBuy)
							{
								// khóa
								if (obj["type"] != "Fish")
								{
									container.AddImage("", "ImgShopItemLock", 40, 97, true, ALIGN_LEFT_TOP);
								}
								else
								{
									container.AddImage("", "ImgShopItemLock", 40, 93, true, ALIGN_LEFT_TOP);
								}
								
								// ten cua item
								txtFormat = new TextFormat("Arial", 14, 0x854F3D, true);
								lbl = container.AddLabel(Localization.getInstance().getString("GUILabe20"), 45, 3);
								lbl.setTextFormat(txtFormat);
								// cach unlock
								var st:String = "";
								switch (obj["UnlockType"])
								{
									case "2": // unlock = lai
										st = Localization.getInstance().getString("GUILabe21");
										break;
									case "4": // unlock = quest
										st = Localization.getInstance().getString("GUILabe22");
										break;
								}
								
								txtFormat = new TextFormat("Arial", 11, 0xff0000);
								txtFormat.align = TextFormatAlign.CENTER;
								lbl = container.AddLabel(st, 30, 120);
								lbl.setTextFormat(txtFormat);
								lbl.width = 95;
								lbl.multiline = true;
								lbl.wordWrap = true;
								lbl.x = 45;
								lbl.y = 140;
							}
						}
						break;
						
					case "Food":
						imgName = "ImgFoodBox";
						image = container.AddImage("", imgName, 60, 66, true, ALIGN_LEFT_TOP);
						//img.FitRect(100, 80, new Point(60, 66));
						image.FitRect(rect.width, rect.height, new Point(rect.x, rect.y));
						// SO LUONG
						//image = container.AddImage("", "BGSoLuong", 70, 76, true, ALIGN_LEFT_TOP);
						txtFormat = new TextFormat("Arial", 14, 0xffffff);
						txtFormat.align = TextFormatAlign.CENTER;
						var tg:int = obj["Numb"] / 5;
						lbl = container.AddLabel(tg.toString(), 65, 80, 0, 1, 0x26709C);
						lbl.setTextFormat(txtFormat);
						break;
					case "LevelMixLake"://Bi kip lai
						imgName = "IconBiKip";
						image = container.AddImage("", imgName, 66, 110, true, ALIGN_LEFT_TOP);
						//image.FitRect(w, h, new Point(17, 30));
						image.FitRect(rect.width, rect.height, new Point(rect.x, rect.y));
						// so hien thi bi kip
						lbl = container.AddLabel(obj[ConfigJSON.KEY_ID], image.img.x - 1, image.img.y - 10);
						txtFormat = new TextFormat("Arial", 14, 0xffffff, true);
						lbl.setTextFormat(txtFormat);
						lbl.autoSize = TextFieldAutoSize.CENTER;
						Ultility.SetHightLight(lbl);
						// thong tin
						if (obj["levelRequire"] <= user.GetLevel())
						{
							txtFormat = new TextFormat("Arial", 11, 0x000000, true);
							txtFormat.align = TextFormatAlign.CENTER;
							st = Localization.getInstance().getString("GUILabel32");
							lbl = container.AddLabel(st + " " + obj["MaxFishLevel"], 45, 88);
							lbl.setTextFormat(txtFormat);
							lbl.multiline = true;
							lbl.wordWrap = true;
							
						}
						break;
				}
				
				if (CanBuy)
				{
					// do vat mo'i
					if (obj["IsNew"] == true)
					{
						container.AddImage("", "IcNewShop", 35, 45);
					}
					
					// ten cua item
					st = obj[ConfigJSON.KEY_NAME];
					if (obj["type"] == "LevelMixLake")
					{
						st = Localization.getInstance().getString("LevelMixLake") + " " + obj[ConfigJSON.KEY_ID];
					}
					txtFormat = new TextFormat("Arial", 14, 0x854F3D, true);
					lbl = container.AddLabel(st, 45, 3);
					lbl.setTextFormat(txtFormat);
					// cap do yeu cau
					if (obj["levelRequire"] > user.GetLevel())
					{
						container.AddLabel("Cấp : " + obj["levelRequire"], 45, 140, 0xff0000);
						
						// khóa
						if (obj["type"] != "Fish")
						{
							container.AddImage("", "ImgShopItemLock", 40, 97, true, ALIGN_LEFT_TOP);
						}
						else
						{
							container.AddImage("", "ImgShopItemLock", 40, 93, true, ALIGN_LEFT_TOP);
						}
					}
					else
					{
						// thong tin chi tiet
						switch (obj["type"])
						{
							case "Fish":
								txtFormat = new TextFormat("Arial", 11, 0x604220);
								txtFormat.bold = true;
								lbl = container.AddLabel(Localization.getInstance().getString("GUILabel3") + " " + Math.round(obj["MoneyGet"] * 0.7), 45, 102);
								lbl.setTextFormat(txtFormat);
								
								lbl = container.AddLabel(Localization.getInstance().getString("GUILabel4") + " " + obj["ExpGet"], 45, 116);
								lbl.setTextFormat(txtFormat);
								
								lbl = container.AddLabel(Localization.getInstance().getString("GUILabel2") + " " + obj["HarvestTime"] / 3600 + "h", 45, 88);
								lbl.setTextFormat(txtFormat);
							break;
							case "LakeUpgrade":
							case "LakeUnlock":
								// suc chua
								txtFormat = new TextFormat("Arial", 11, 0x374965, true);
								lbl = container.AddLabel("Sức chứa " + obj["capacity"], 45, 88);
								lbl.setTextFormat(txtFormat);
								// exp
								txtFormat = new TextFormat("Arial", 11, 0x374965, true);
								lbl = container.AddLabel(Localization.getInstance().getString("GUILabel4") + obj["ExpGet"], 45, 102);
								lbl.setTextFormat(txtFormat);
								break;
						}
						
						// so gold can mua
						if (obj["gold"] <= 0)		obj["gold"] = 0;
						image = container.AddImage("", "IcGold", 35, 137);
						image.SetScaleX(0.8);
						image.SetScaleY(0.8);
						if (obj["gold"] > user.GetMoney())
						{
							//Nếu không đủ tiền thì hiện màu đỏ
							lbl = container.AddLabel(obj["gold"], 42, 126, 0xff0000, 0);
							CanBuy = false;
						}
						else
						{							
							lbl = container.AddLabel(obj["gold"], 42, 126, 0x604220, 0);
						}
						//Nếu không có xu thì căn vào giữa
						//if (obj["xu"] <= 0)
						//{
							//image.SetPos(45, 145);
							//lbl.x = 57;
							//lbl.y = 135;
						//}
							
						// so xu can mua
						if (obj["xu"] <= 0)		obj["xu"] = 0;
						// so xu can mua
						image = container.AddImage("", "IcZingXu", 138, 137);
						image.SetScaleX(0.8);
						image.SetScaleY(0.8);
						if (obj["xu"] > user.GetZMoney())
						{
							//Nếu không đủ tiền thì hiện màu đỏ
							lbl = container.AddLabel(obj["xu"], 145, 126, 0xff0000, 0);
							CanBuy = false;
						}
						else
						{							
							lbl = container.AddLabel(obj["xu"], 145, 126, 0x604220, 0);
						}
						//Nếu không có vàng thì căn vào giữa
						//if (obj["gold"] <= 0)
						//{
							//image.SetPos(50, 145);
							//lbl.x = 62;
							//lbl.y = 135;
						//}
								
						// nut mua gold
						var HelperID:String = "";
						
						//if (obj["gold"] > 0)
						{
							HelperID = obj["type"] + "_" + obj[ConfigJSON.KEY_ID] + "_gold";
							var btnGold:Button = container.AddButton(obj["type"] + "_" + obj[ConfigJSON.KEY_ID] + "_gold", "BtnBuyGold", 13, 147, this, HelperID);
							//if (obj["xu"] <= 0)
							//{
								//btnGold.SetPos(35, 165);
							//}
							//btnGold.img.scaleX = 0.85;
							//btnGold.img.scaleY = 0.85;
							if (obj["gold"] > user.GetMoney() || obj["gold"] == 0)
							{
								btnGold.SetDisable();
							}
						}
						
						// nut mua xu
						//if (obj["xu"] > 0)
						{
							HelperID = obj["type"] + "_" + obj[ConfigJSON.KEY_ID] + "_xu";
							var btnXu:Button = container.AddButton(obj["type"] + "_" + obj[ConfigJSON.KEY_ID] + "_xu", "BtnBuyXu", 113, 147, this, HelperID);
							//if (obj["gold"] <= 0)
							//{
								//btnXu.SetPos(35, 165);
							//}
							//btnXu.img.scaleX = 0.85;
							//btnXu.img.scaleY = 0.85;
							if (obj["xu"] > user.GetZMoney() || obj["xu"] == 0)
							{
								btnXu.SetDisable();
							}
						}			
					}
				}
			}
			
			// them cac loai button khac
			InitShopButton();
			
		}
		
		private function GetFishImageName(obj:Object):String
		{
			if (obj["UnlockType"] != 1)
			{
				if (!GameLogic.getInstance().user.CheckFishUnlocked(obj[ConfigJSON.KEY_ID]))
				{
					return "IconCaChuaUnlock";
				}
			}
			
			return ("Fish" + obj[ConfigJSON.KEY_ID] + "_Old_Idle");
		}
		
		private function BuySomeThing(ID:String):void
		{	
			var data:Array = ID.split("_");
			if (data.length < 2) return;
				
			var objType:String = data[0];
			var objID:int = data[1];	
			
			BuyType = data[2];
			BuyObjID = objID;
			switch (objType)
			{
				case "Other":
				case "OceanTree":
				case "OceanAnimal":
					BuyDecorate(objID, objType);
					break;
					
				case "MixLake":
					BuySpecial(objID, objType);
					break;
				
				case "Fish":
					BuyFish(objID);
					break;
				case "Food":
					BuyFood(objID, objType);
					break;
				case "LakeUpgrade":
					ShowUpgradeLake(objID);
					
					//GameLogic.getInstance().DoUpgradeLake();
					//GameController.getInstance().UseTool("Shop");
					break;
					
				case "LakeUnlock":
					ShowUnlockLake(objID-1);
					//GameLogic.getInstance().DoUnlockLake(lake);
					//GameController.getInstance().UseTool("Shop");
					break;
					
				case "LevelMixLake":
					GameLogic.getInstance().DoUpgradeMixLake();
					break;
			}

		}
		
		private function ShowUpgradeLake(objID:int):void
		{
			var lake:Lake;
			var st:String;
			

			lake = GameLogic.getInstance().user.GetLake(objID);
			st = Localization.getInstance().getString("Message2");
			st = st.replace("@GiaTien", lake.GetUpgradeMoney());
			st = st.replace("@LoaiTien", Localization.getInstance().getString("Money"));
			GameLogic.getInstance().SetState(GameState.GAMESTATE_UPGRADE_LAKE);
			GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(st);
		}
		
		private function ShowUnlockLake(objID:int):void
		{
			var lake:Lake;
			var st:String;
			
			lake = GameLogic.getInstance().user.LakeArr[objID];
			GuiMgr.getInstance().GuiMain.SelectedLake = lake;
			GameLogic.getInstance().SetState(GameState.GAMESTATE_UNLOCK_LAKE);
			st = Localization.getInstance().getString("Message1");
			st = st.replace("@GiaTien", lake.GetUnlockMoney());
			st = st.replace("@LoaiTien", Localization.getInstance().getString("Money"));
			GuiMgr.getInstance().GuiMessageBox.ShowOkCancel(st);
		}
		
		public function BuySpecial(ItemId:int, ItemType:String):void
		{
			GameLogic.getInstance().BuySpecial(ItemId, ItemType);
			this.Hide();
			GuiMgr.getInstance().GuiShop.Hide();
		}
		
		public function BuyFood(ItemId:int, ItemType:String):void
		{
			GameLogic.getInstance().BuyItem(ItemId, ItemType);
			this.Hide();
			GuiMgr.getInstance().GuiShop.Hide();
		}
		
		public function FinishBuy():void
		{
			// hide cover layer
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			if (layer != null)
			{
				layer.HideDisableScreen();
			}
		}
		
		public function BuyFish(ID:int):void
		{
			var pt:Point = Ultility.PosScreenToLake(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y);
			GameLogic.getInstance().gameState = GameState.GAMESTATE_BUY_FISH;
			
			var fish:Fish = new Fish(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), Fish.ItemType + ID + "_Baby_Happy");
			fish.img.scaleX = fish.img.scaleY = 0.5;
			fish.FishTypeId = ID;
			fish.SetPos(pt.x, pt.y);
			GameController.getInstance().SetActiveObject(fish);
			GuiMgr.getInstance().GuiSetFishInfo.fish = fish;
			
			this.Hide();
			GuiMgr.getInstance().GuiShop.Hide();
			//GuiMgr.getInstance().GuiSetFishInfo.Show(Constant.GUI_MIN_LAYER + 1);
			GuiMgr.getInstance().GuiSetFishInfo.Show();
			
			//Tăng số lượng cá đã mua lên 1
			GuiMgr.getInstance().GuiSetFishInfo.nFish++;			
			
			// show cover layer
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			if (layer != null)
			{
				layer.ShowDisableScreen(0);
			}
		}
		
		public function BuyDecorate(ItemID:int, ItemType:String):void
		{
			var pt:Point = Ultility.PosScreenToLake(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y);
			GameLogic.getInstance().gameState = GameState.GAMESTATE_BUY_DECORATE;
			
			var deco:Decorate = new Decorate(LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER), ItemType + ItemID, pt.x, pt.y, ItemType, ItemID);
			deco.SetHighLight();
			deco.ObjectState = BaseObject.OBJ_STATE_BUY;
			deco.UpdateDeep();
			if (!deco.CheckPosition())
			{
				deco.ShowDisable(true);
			}
			GameController.getInstance().SetActiveObject(deco);	
			//GameController.getInstance().UpdateActiveObjPos(pt.x, pt.y);
			this.Hide();
			GuiMgr.getInstance().GuiShop.Hide();
			
			// show buy decorate GUI
			//var obj:Object = INI.getInstance().getItemInfo(ItemID.toString(), ItemType);
			//GuiMgr.getInstance().GuiBuyDecorate.ShowBuyDeco(Constant.GUI_MIN_LAYER + 1, obj[ConfigJSON.KEY_NAME], obj["gold"]);
			
			// show cover layer
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.COVER_LAYER);
			if (layer != null)
			{
				layer.ShowDisableScreen(0.01);
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
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_BUYSHOP_BTN_OTHER:
				case GUI_BUYSHOP_BTN_TREE:
				case GUI_BUYSHOP_BTN_ANIMAL:
					InitShop(buttonID, 0);
				break;
				
				case GUI_BUYSHOP_BTN_NEXT:
				if (CurrentPage < MaxPage - 1)
				{
					InitShop(CurrentShop, CurrentPage + 1);
				}
				break;
				
				case GUI_BUYSHOP_BTN_BACK:
				if (CurrentPage > 0)
				{
					InitShop(CurrentShop, CurrentPage - 1);
				}
				break;

				default:
				BuySomeThing(buttonID);
				break;
				

			}
		}
		
	}

}