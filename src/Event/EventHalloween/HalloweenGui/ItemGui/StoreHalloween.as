package Event.EventHalloween.HalloweenGui.ItemGui 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ListBox;
	import GUI.component.ScrollBar;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class StoreHalloween extends BaseGUI 
	{
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const CMD_ITEM:String = "cmdItem";
		private const SHOW_X:int = 250;//310
		private const HIDE_X:int = 575;//635
		private const YGUI:int = 345;
		private var btnClose:Button;
		private var scrollBar:ScrollBar;
		private var listGift:ListBox;
		public var inShift:Boolean = false;
		public function StoreHalloween(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "StoreHalloween";
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GuiHalloween_StoreTheme");
			SetPos(HIDE_X, YGUI);
			btnClose = AddButton(ID_BTN_CLOSE, "BtnThoat", 287, 6);
			btnClose.img.width = btnClose.img.height = 25;
			scrollBar = AddScroll("", "GuiHalloween_ScrollBar", 265, 30);
			listGift = AddListBox(ListBox.LIST_Y, 2, 3, 5);
			addAllGift();
			listGift.x = 20;
			listGift.y = 30;
			scrollBar.setScrollImage(listGift.img, 0, 100);
			
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0x000000);
			sp.graphics.drawRect(245, 330, 325, 260);
			sp.graphics.endFill();
			Parent.addChild(sp);
			img.mask = sp;
			
			scrollBar.img.visible = listGift.length > 6;
		}
		
		/**
		 * vẽ tất cả quà trong kho
		 */
		private function addAllGift():void
		{
			var store:Array = HalloweenMgr.getInstance().getStoreGift();
			var i:int;
			var gift:AbstractGift;
			for (i = 0; i < store.length; i++)
			{
				gift = store[i];
				addGift(gift);
			}
		}
		
		/**
		 * add 1 quà vào trong kho
		 * @param	gift
		 */
		public function addGift(gift:AbstractGift):void
		{
			var itmGift:AbstractItemGift;
			var kind:int = Ultility.categoriesGift(gift["ItemType"]);
			if (kind == 0)
			{
				itmGift = new ItemNormalGift(listGift.img, "GuiHalloween_ImgSlot1");
				itmGift.initData(gift, "", 75, 78, false);
			}
			else if(kind == 1)
			{
				itmGift = new ItemSpecialGift(listGift.img, "KhungFriend");
				itmGift.initData(gift);
			}
			itmGift.drawGift();
			listGift.addItem(CMD_ITEM, itmGift, this);
			
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					GuiMgr.getInstance().guiHalloween.showTrunk(false);
					break;
			}
		}
		
		public function showTrunk(isShow:Boolean = true):void
		{
			inShift = true;
			if (isShow)
			{
				//trượt ra vị trí cần show
				TweenMax.to(img, 1,
								{
									x:SHOW_X, y:YGUI,
									ease:Expo.easeIn,
									onComplete:onCompleteShift
								}
							);
			}
			else
			{
				//trượt về vị trí ẩn
				TweenMax.to(img, 1,
								{
									x:HIDE_X, y:YGUI,
									ease:Expo.easeOut,
									onComplete:onCompleteShift
								}
							);
			}
			function onCompleteShift():void
			{
				inShift = false;
			}
		}
		
		public function refreshTrunk():void
		{
			listGift.removeAllItem();
			addAllGift();
		}
		
		public function updateItem(gift:AbstractGift):void
		{
			var i:int, length:int = listGift.length;
			var kind:int = Ultility.categoriesGift(gift["ItemType"]);
			var itmGift:AbstractItemGift;
			var temp:AbstractGift;
			var itmTemp:AbstractItemGift;
			var trunk:Array = HalloweenMgr.getInstance().getStoreGift();
			var isPush:Boolean = true;
			var strSlot:String;
			if (kind == 1)
			{
				strSlot = "KhungFriend";
			}
			else
			{
				strSlot = "GuiHalloween_ImgSlot1";
				var type:int;
				for (i = 0; i < length; i++)
				{
					itmTemp = listGift.itemList[i] as AbstractItemGift;
					temp = itmTemp["Gift"];
					type = Ultility.categoriesGift(temp["ItemType"]);
					if (type == 0)
					{
						if (temp["ItemType"] == gift["ItemType"])
						{
							if (gift["ItemId"] != null)//co itemid
							{
								if (temp["ItemId"] == gift["ItemId"])
								{
									if (temp["ItemType"] == "Gem")
									{
										if (temp["Element"] == gift["Element"] && temp["Day"] == gift["Day"])
										{
											temp["Num"] += gift["Num"];
											itmTemp.refreshTextNum();
											isPush = false;
											break;
										}
									}
									else if (temp["ItemType"] == "Soldier")
									{
										if (temp["RecipeType"] == gift["RecipeType"] && temp["RecipeId"] == gift["RecipeId"])
										{
											temp["Num"] += gift["Num"];
											itmTemp.refreshTextNum();
											isPush = false;
											break;
										}
									}
									else
									{
										temp["Num"] += gift["Num"];
										itmTemp.refreshTextNum();
										isPush = false;
										break;
									}
								}
							}
							else
							{
								temp["Num"] += gift["Num"];
								itmTemp.refreshTextNum();
								isPush = false;
								break;
							}
						}
					}
				}
			}
			if (isPush)
			{
				if (kind == 0)
				{
					itmGift = new ItemNormalGift(listGift.img, strSlot);
				}
				else
				{
					itmGift = new ItemSpecialGift(listGift.img, strSlot);
				}
				itmGift.initData(gift, "", 75, 78, false);
				itmGift.drawGift();
				listGift.addItem(CMD_ITEM, itmGift, this);
				listGift.setInfo(10, 10, 75, 78);
				trunk.push(gift);
			}
			scrollBar.img.visible = listGift.length > 6;
		}
		
		override public function OnHideGUI():void 
		{
			HalloweenMgr.getInstance().freeStoreGift();//giải phóng dữ liệu về kho
		}
	}

}



























