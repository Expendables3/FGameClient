package GUI 
{
	import Event.EventLuckyMachine.EventLuckyMachineMgr;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ListBox;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	
	/**
	 * GUI hiển thị quà cho user nhận về.
	 * overide các hàm sau để thay đổi gui:
	 * 		addTip: Thêm vào câu nói cho gui vd: " Bạn được đền các phần thưởng sau khi nạp code "
	 * 		initListGift: Khởi tạo cho ListGift, dữ liệu lấy từ bên ngoài vd: User.MailArr
	 * 		addGift(gift:GiftAbstract): thêm gift vào ListGift
	 * @author HiepNM2
	 */
	public class GUIReceiveMultiGiftAbstract extends BaseGUI 
	{
		// const
		protected const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_RECEIVE:String = "idBtnReceive";
		private const ID_BTN_NEXT:String = "idBtnNext";
		private const ID_BTN_PREV:String = "idBtnPrev";
		
		protected const ELEMENT_GIFT:String = "ElementGift_";
		
		protected var ListGift:ListBox;
		private var btnNext:Button;
		private var btnPrev:Button;
		private var _themeName:String;			//tên ảnh về theme
		protected var _guiName:String;
		
		
		protected var numCol:int = 4;
		protected var numRow:int = 2;
		protected var xListBox:int = 95;
		protected var yListBox:int = 200;
		protected var xPrev:int = 38;
		protected var xNext:int = 518;
		protected var yNextPrev:int = 265;
		protected var xClose:int = 530;
		protected var yClose:int = 42;
		protected var xReceive:int = 250;
		protected var yReceive:int = 430;
		protected var dRow:int = 20;			//khoang cach giua cac hang
		protected var dCol:int = 20;			//khoang cach giua cac cot
		public var isFeed:Boolean = false;
		public function GUIReceiveMultiGiftAbstract(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIReceiveMultiGiftAbstract";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
				ListGift = AddListBox(ListBox.LIST_X, numRow, numCol, dCol, dRow, true);
				ListGift.setPos(xListBox, yListBox);
				initListGift();
				var wMask:Number = ListGift.mask.width;
				var hMask:Number = ListGift.mask.height;
				if (wMask < 100 || hMask < 100)
				{
					ListGift.createMask(400, 200);
				}
				addBgr();
				addTip();
				updateStateBtnNextBack();
			}
			LoadRes(_themeName);
		}
		
		/**
		 * lấy quà từ bên ngoài và khởi tạo vào cho ListGift
		 */
		public virtual function initListGift():void 
		{
			
		}
		
		/**
		 * add 1 quà vào ListGift
		 * @param	gift: quà này sẽ được add vào itemList của ListGift
		 */
		public virtual function addGift(gift:AbstractGift):void
		{
			
		}
		public virtual function addTip():void 
		{
			
		}
		
		private function addBgr():void 
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", xClose, yClose);
			if (isFeed)
			{
				AddButton(ID_BTN_RECEIVE, "BtnFeed", xReceive, yReceive);
			}
			else
			{
				AddButton(ID_BTN_RECEIVE, _guiName + "_BtnReceive", xReceive, yReceive);
			}
			
			btnNext = AddButton(ID_BTN_NEXT, _guiName + "_BtnNext", xNext, yNextPrev);
			btnPrev = AddButton(ID_BTN_PREV, _guiName + "_BtnPrev", xPrev, yNextPrev);
			btnNext.SetVisible(false);
			btnPrev.SetVisible(false);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case ID_BTN_CLOSE:
					processGetGift();
					Hide();
					break;
				case ID_BTN_RECEIVE:
					processGetGift();
					if (isFeed)
					{
						onFeedWall();
					}
					Hide();
				break;
				case ID_BTN_NEXT:
					ListGift.showNextPage();
					updateStateBtnNextBack();
				break;
				case ID_BTN_PREV:
					ListGift.showPrePage();
					updateStateBtnNextBack();
				break;
			}
		}
		
		protected virtual function onFeedWall():void 
		{
			
		}
		
		public virtual function processGetGift():void
		{
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.Hide();
			}
			var length:int = ListGift.length;
			for (var i:int = 0; i < length; i++)
			{
				var itemGift:AbstractItemGift = ListGift.getItemByIndex(i) as AbstractItemGift;
				if (itemGift.ClassName == "ItemNormalGift")
				{
					var itemGiftNormal:ItemNormalGift = itemGift as ItemNormalGift;
					var gift:GiftNormal = itemGiftNormal.Gift;
					if (gift.IsGenerateNextId)
					{
						GameLogic.getInstance().user.GenerateNextID();
						continue;
					}
					
					switch(gift.ItemType) 
					{
						case "Money":
							GameLogic.getInstance().user.UpdateUserMoney(gift.Num);
						break;
						case "ZMoney":
							GameLogic.getInstance().user.UpdateUserZMoney(gift.Num);
						break;
						case "Exp":
							GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + gift.Num);
						break;
						case "PowerTinh":
						case "Iron":
						case "Jade":
						case "SoulRock":
						case "SixColorTinh":
							GameLogic.getInstance().user.updateIngradient(gift.ItemType, gift.Num, gift.ItemId);
						break;
						case "Diamond":
							var curDiamond:int = GameLogic.getInstance().user.getDiamond();
							GameLogic.getInstance().user.setDiamond(curDiamond + gift.Num);
						break;
						case "Medal":
							GameLogic.getInstance().numMedalHalloween += gift.Num;
							break;
						case "Ticket":
							EventLuckyMachineMgr.getInstance().updateTicket(gift.Num);
							break;
					}
				}
				else if (itemGift.ClassName == "ItemSpecialGift" || itemGift.ClassName == "ItemQuad")
				{
					//var itemGiftSpecial:ItemSpecialGift = itemGift as ItemSpecialGift;
					//var gift2:GiftSpecial = itemGiftSpecial.Gift;
					GameLogic.getInstance().user.GenerateNextID();
				}
			}
		}
		
		
		private function updateStateBtnNextBack():void
		{
			var curPage:int = ListGift.curPage + 1;
			var totalPage:int = ListGift.getNumPage();
			if (totalPage <= 1)
			{
				btnNext.SetVisible(false);
				btnPrev.SetVisible(false);
			}
			else if (curPage == 1)
			{
				btnNext.SetVisible(true);
				btnPrev.SetVisible(true);
				btnNext.SetEnable(true);
				btnPrev.SetEnable(false);
			}
			else if (curPage == totalPage)
			{
				btnNext.SetVisible(true);
				btnPrev.SetVisible(true);
				btnNext.SetEnable(false);
				btnPrev.SetEnable(true);
			}
			else
			{
				btnNext.SetVisible(true);
				btnPrev.SetVisible(true);
				btnNext.SetEnable(true);
				btnPrev.SetEnable(true);
			}
		}
		
		protected function set ThemeName(value:String):void 
		{
			_themeName = value;
			var data:Array = value.split("_");
			_guiName = data[0];
		}
	}

}

