package GUI 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.Text;
	import Data.ConfigJSON;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.sampler.NewObjectSample;
	import flash.text.TextField;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import Logic.Friend;
	import flash.events.MouseEvent;
	import Logic.GameLogic;
	import flash.geom.Rectangle;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent
	import Logic.QuestMgr;
	import NetworkPacket.PacketSend.SendGift;
	import Data.INI;
	import flash.text.TextFormat;
	import com.adobe.utils.StringUtil;
	import flash.text.TextFieldAutoSize;
	import Data.Localization;
	import flash.ui.Mouse;	
	import flash.utils.getTimer;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import fl.containers.ScrollPane;
	import fl.controls.ScrollBar;
	import fl.controls.ScrollBarDirection;
	import fl.events.ScrollEvent;
	import Data.ResMgr;
	import flash.geom.ColorTransform;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author thint
	 * Gui chọn bạn để tặng quà
	 */ 
	public class GUIGiftSend extends BaseGUI
	{
		static public const ICON_HELPER:String = "iconHelper";
		private const GUI_GIFT_BUTTON_SEND:String = "ButtonSend";
		private const GUI_GIFT_BUTTON_CANCEL: String = "cancel";
		private const GUI_GIFT_BUTTON_CLOSE:String = "ButtonDong";
		private const GUI_GIFT_BUTTON_THANHKEO: String = "ButtonThanhKeo";
		private const GUI_GIFT_BUTTON_POPUP: String = "ButtonPopUp";
		private const GUI_GIFT_BUTTON_POPDOWN: String = "ButtonPopDown";
		private const GUI_GIFT_BUTTON_POPUPSUB: String = "ButtonPopUpSub";
		private const GUI_GIFT_BUTTON_POPDOWNSUB: String = "ButtonPopDownSub";
		private const GUI_GIFT_BUTTON_SCROLLBAR: String = "ScrollBar";
		private const GUI_GIFT_BUTTON_SCROLLBARSUB: String = "ScrollBarSub";
		private const GUI_GIFT_SEARCH: String = "Search";

		public var BackgroundImage: Image;
		public var NameTextbox: TextBox;
		public var TextboxImage: Image;
		public var NumPeople: TextField;
		public var ScrollTop: ScrollPane = new ScrollPane();
		public var ScrollBot: ScrollPane = new ScrollPane();
		public var ContentTop: Sprite = new Sprite();
		public var ContentBot: Sprite = new Sprite();
		public var SearchFriendArr: Array = [];
		public var FriendContainerArr: Array = [];
		public var Label1: TextField;
		public var Label2: TextField;
		public var buttonSend: Button;
		
		public var PickFriendArr: Array = [];
		//public var indexFriend: int = -1;
		
		public function GUIGiftSend(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIGiftSend";
		}
		
		public override function InitGUI():void
		{
			this.setImgInfo = function():void
			{
				SetPos(111, 100);	
				OpenRoomOut();
			}
			
			LoadRes("GuiSendGift_Theme");
		}
		
		public override function  EndingRoomOut():void
		{
			var giftID: String = GuiMgr.getInstance().GuiGift.currentGiftID;
			
			var obj: Object = ConfigJSON.getInstance().getGiftInfo(giftID);
			
			//var obj1: Object = INI.getInstance().getItemInfo(obj["typeid"], obj["type"]);
			var obj1: Object = ConfigJSON.getInstance().getItemInfo(obj["type"], obj["typeid"]);
			
			var imgName: String = GuiMgr.getInstance().GuiGift.getImageGift(obj["type"], obj[ConfigJSON.KEY_ID]);
			var container: Container = AddContainer(giftID, "GuiSendGift_ImgBackgroundGift", 104, 117);
			
			var gift: Image = container.AddImage(giftID, imgName, 20, 20);
			gift.FitRect(60, 60, new Point(23, 45));
			if (obj.type == "Gem")
			{
				var cfg:Object = ConfigJSON.getInstance().GetItemList("Gift")[giftID];
				var str:String = Localization.getInstance().getString("Gem" + cfg.Element);
				str = str.split("\n")[0];
				str = str.replace("@Type@", Localization.getInstance().getString("GemType" + cfg.ItemId));
				str = str.replace("@Rank@", "cấp " + cfg.ItemId);
				container.AddLabel(str, 2, 15);
			}
			else if (obj.type == "ColPItem")
			{
				container.AddLabel(Localization.getInstance().getString("EventTeacher_FriendShip"), 2, 15);	
			}
			else if (obj.type == "Candy")
			{
				container.AddLabel(Localization.getInstance().getString("EventNoel_FriendShip"), 2, 15);	
			}
			else if (obj.type == "Island_Item")
			{
				container.AddLabel("Chìa khóa", 2, 15);	
			}
			else if (obj.type == "HalItem")
			{
				container.AddLabel("Đá mật mã quý hiếm", 2, 15);	
			}
			else
			{
				container.AddLabel(obj1[ConfigJSON.KEY_NAME], 2, 15);	
			}
			
			TextboxImage = AddImage("CheckboxImage", "GuiSendGift_ImgTimKiem", 352, 85);
			NameTextbox = AddTextBox(GUI_GIFT_SEARCH, "Tìm kiếm bạn bè", 252, 75, 200, 30, this);
			
			var khung: Image = AddImage("Khung", "GuiSendGift_ImgBackgroundSendGift", 352, 169);
			khung.SetScaleY(1.1);
			khung = AddImage("Khung", "GuiSendGift_ImgBackgroundSendGift", 352, 313);
			khung.SetScaleY(1.1);
			
			AddButton(GUI_GIFT_BUTTON_CANCEL, "GuiSendGift_BtnBoQua", 320, 400, this);
			buttonSend = AddButton(GUI_GIFT_BUTTON_SEND, "GuiSendGift_BtnTangBanBe", 150, 400, this);
			
			var buttonClose: Button = AddButton(GUI_GIFT_BUTTON_CLOSE, "BtnThoat", 540, 20, this);
			
			var numreceiver: int = GameLogic.getInstance().user.GetMyInfo().NumReceiver;
			var s: String = Localization.getInstance().getString("GUILabel7");
			s = s.replace("@nguoi", numreceiver);
			var s1: String = Localization.getInstance().getString("GUILabel8");
			
			var txtFormat: TextFormat = new TextFormat("Arial", 14, 0x2E69B3);
			Label1 = AddLabel(s, 88, 290, 0x000000, 2);
			Label2 = AddLabel(s1, 108, 310, 0x000000, 2);
			
			PickFriendArr = [];
			InitScrollPaneTop();
			InitScrollPaneBot();
			InitFriendArr();
			UpdateTopContent();
			UpdateBotContent();
			
			//Tutorial
			var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
			if (curTutorial.search("ChooseFriend") >= 0)
			{
				AddImage(ICON_HELPER, "IcHelper", 50 + 288, 50 + 84);
			}
		}
		
		/**
		 * Init FriendArr
		 */
		public function InitFriendArr(): void
		{
			SearchFriendArr = [];
			var rarr:Array = GameLogic.getInstance().user.GetMyInfo().ReceiverGiftList;
			var farr:Array = GameLogic.getInstance().user.FriendArr;
			
			var i:int = 0, j:int = 0;
			for (i = 0; i < farr.length; i++)
			{
				SearchFriendArr.push(farr[i]);
			}

			
			for (i = 0; i < rarr.length; i++ )
				for (j = 0; j < SearchFriendArr.length; j++ )
					if (rarr[i] == SearchFriendArr[j].ID)
					{
						SearchFriendArr.splice(j, 1);
					}
					
			for (i = 0; i < PickFriendArr.length; i++ )
				for (j = 0; j < SearchFriendArr.length; j++ )
					if (PickFriendArr[i].ID == SearchFriendArr[j].ID)
					{
						SearchFriendArr.splice(j, 1);
						break;
					}
		}
		
		/**
		 * Remove tat ca cac Friend
		 */
		public function RemoveAllFriendContainer(): void
		{
			var container: Container;
			for (var i: int = 0; i < FriendContainerArr.length; i++ )
			{	
				container = FriendContainerArr[i] as Container;
				container.Clear();
			}
			FriendContainerArr.splice(i, FriendContainerArr.length);
		}
	
		/**
		 * Chuyển tên bạn từ trên xuống dưới
		 * @param	id
		 */
		public function ReplaceContent(id: String): void
		{			
			var s: Array = id.split("_", 3);
			
			var indexFriend: int = int(s[0]);
			if (indexFriend >= 0)
			{
				if (s[2] == "top")
				{
					if (GameLogic.getInstance().user.GetMyInfo().NumReceiver - PickFriendArr.length > 0)
					{
						PickFriendArr.push(SearchFriendArr[indexFriend]);
						SearchFriendArr.splice(indexFriend, 1);
					}
					else
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message11"));
					}					
				}
				else
				{
					SearchFriendArr.push(PickFriendArr[indexFriend]);
					PickFriendArr.splice(indexFriend, 1);
				}
				
				//Update dòng hiện thị số bạn bè còn lại có thể gửi	
				var numreceiver: int = GameLogic.getInstance().user.GetMyInfo().NumReceiver - PickFriendArr.length;
				var s1: String = Localization.getInstance().getString("GUILabel7");
				s1 = s1.replace("@nguoi", numreceiver);
				
				var txtFormat: TextFormat = new TextFormat("Arial", 14, 0x2E69B3);
				Label1.text = s1;
			}
			else
			{
				PickFriendArr.splice(0, PickFriendArr.length);
			}
		}
		
		/**
		 * Update lại content của scroll bar trên
		 */
		public function UpdateTopContent(): void
		{
			RemoveAllFriendContainer();

			var firstX: int, firstY: int;
			firstX = 20;
			firstY = 0;
			var increY: int;
			increY = 25;
			
			var container: Container;
			var name: TextField;
			var i: int;
			for (i = 0; i < SearchFriendArr.length; i++ )
			{
				container = new Container(ContentTop, "GuiSendGift_CtnIndexFriend", firstX, firstY + increY * i);
				container.EventHandler = this;
				container.IdObject = i.toString() + "_" + FriendContainerArr.length + "_top";
				container.AddImage("Plus", "GuiSendGift_ImgDauCong", 5, 4, true, ALIGN_LEFT_TOP);
				var nameStr: String = SearchFriendArr[i].NickName;
				if (nameStr.length > 20)
				{
					nameStr = nameStr.substring(0, 20);
					nameStr += "...";
				}
				name = container.AddLabel(nameStr, 30, 0, 0, 0);
				FriendContainerArr.push(container);
			}
			ScrollTop.source = ContentTop;
		}
		
		/**
		 * Update lại content của scroll bar dưới
		 */
		public function UpdateBotContent(): void
		{
			//RemoveAllFriendContainer();
			
			var firstX: int, firstY: int;
			firstX = 20;
			firstY = 0;
			var increY: int;
			increY = 25;
			
			var container: Container;
			var name: TextField;
			var i: int;
			
			for (i = 0; i < PickFriendArr.length; i++ )
			{
				container = new Container(ContentBot, "GuiSendGift_CtnIndexFriend", firstX, firstY + increY * i);
				container.EventHandler = this;
				container.IdObject = i.toString() + "_" + FriendContainerArr.length + "_bot";
				container.AddImage("Multi", "GuiSendGift_ImgDauNhan",  5, 4, true, ALIGN_LEFT_TOP);
				
				var nameStr: String = PickFriendArr[i].NickName;
				if (nameStr.length > 20)
				{
					nameStr = nameStr.substring(0, 20);
					nameStr += "...";
				}
				name = container.AddLabel(nameStr, 30, 0, 0, 0);
				FriendContainerArr.push(container);
			}
			ScrollBot.source = ContentBot;
		}
		
		/**
		 * Khởi tạo scroll bar trên
		 */
		private function InitScrollPaneTop():void
		{
			//thay đổi khung viền mặc định bằng khung trắng
			var bg: Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff, 0);
			bg.graphics.drawRect(0, 0, 300, 200);
			bg.graphics.endFill();
			ScrollTop.setStyle("upSkin", bg);
			
			var color:ColorTransform = new ColorTransform(1.8, 1.8, 1.8);
			var up:Sprite = ResMgr.getInstance().GetRes("GuiSendGift_ImgArrowUp") as Sprite;
			ScrollTop.setStyle("upArrowUpSkin", up);
			ScrollTop.setStyle("upArrowDownSkin", up);
			var over:Sprite = ResMgr.getInstance().GetRes("GuiSendGift_ImgArrowUp") as Sprite;
			over.transform.colorTransform = color;
			ScrollTop.setStyle("upArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiSendGift_ImgArrowDown") as Sprite;
			ScrollTop.setStyle("downArrowUpSkin", up);
			ScrollTop.setStyle("downArrowDownSkin", up);
			over = ResMgr.getInstance().GetRes("GuiSendGift_ImgArrowDown") as Sprite;
			over.transform.colorTransform = color;
			ScrollTop.setStyle("downArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiSendGift_ImgThanhTruot") as Sprite;
			ScrollTop.setStyle("thumbUpSkin", up);
			ScrollTop.setStyle("thumbDownSkin", up);
			over = ResMgr.getInstance().GetRes("GuiSendGift_ImgThanhTruot") as Sprite;
			over.transform.colorTransform = color;
			ScrollTop.setStyle("thumbOverSkin", over);
			ScrollTop.setStyle("thumbIcon", "");

			up = ResMgr.getInstance().GetRes("GuiSendGift_BtnKhungKeo") as Sprite;
			ScrollTop.setStyle("trackUpSkin", up);
			ScrollTop.setStyle("trackDownSkin", up);
			ScrollTop.setStyle("trackOverSkin", up);
			
			ScrollTop.setSize(250, 119);
			
			ScrollTop.x = 240;
			ScrollTop.y = 116;
			img.addChild(ScrollTop);
			ScrollTop.addEventListener(ScrollEvent.SCROLL, scroll)
		}

		/**
		 * Khởi tạo scroll bar dưới
		 */
		private function InitScrollPaneBot(): void
		{
			var bg: Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff, 0);
			bg.graphics.drawRect(0, 0, 300, 200);
			bg.graphics.endFill();
			ScrollBot.setStyle("upSkin", bg);
			
			var up:Sprite = ResMgr.getInstance().GetRes("GuiSendGift_ImgArrowUp") as Sprite;
			ScrollBot.setStyle("upArrowUpSkin", up);
			ScrollBot.setStyle("upArrowDownSkin", up);
			var over:Sprite = ResMgr.getInstance().GetRes("GuiSendGift_ImgArrowUp") as Sprite;
			var color:ColorTransform = new ColorTransform(1.8, 1.8, 1.8);
			over.transform.colorTransform = color;
			ScrollBot.setStyle("upArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiSendGift_ImgArrowDown") as Sprite;
			ScrollBot.setStyle("downArrowUpSkin", up);
			ScrollBot.setStyle("downArrowDownSkin", up);
			over = ResMgr.getInstance().GetRes("GuiSendGift_ImgArrowDown") as Sprite;
			over.transform.colorTransform = color;
			ScrollBot.setStyle("downArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiSendGift_ImgThanhTruot") as Sprite;
			ScrollBot.setStyle("thumbUpSkin", up);
			ScrollBot.setStyle("thumbDownSkin", up);
			over = ResMgr.getInstance().GetRes("GuiSendGift_ImgThanhTruot") as Sprite;
			over.transform.colorTransform = color;
			ScrollBot.setStyle("thumbOverSkin", over);
			ScrollBot.setStyle("thumbIcon", "");

			up = ResMgr.getInstance().GetRes("GuiSendGift_BtnKhungKeo") as Sprite;
			ScrollBot.setStyle("trackUpSkin", up);
			ScrollBot.setStyle("trackDownSkin", up);
			ScrollBot.setStyle("trackOverSkin", up);
			
			ScrollBot.setSize(250, 119);
			
			ScrollBot.x = 240;
			ScrollBot.y = 259;
			img.addChild(ScrollBot);
			ScrollBot.addEventListener(ScrollEvent.SCROLL, scroll)
		}
		
		private function scroll(event:ScrollEvent):void 
		{
		
		}
		
		/**
		 * Tìm theo tên bạn bè
		 * @param	text: Từ nhập vào ô textbox
		 */
		public function Search(txtID: String): void
		{
			RemoveAllFriendContainer();
			InitFriendArr();
			var i: int;
			
			var name: String, text: String;
			var tb: TextBox;
			
			for (i = 0; i < TextBoxArr.length; i++ )
			{
				tb = TextBoxArr[i] as TextBox;
				if (tb.TextBoxID == txtID)
					{
						text = tb.GetText();
						break;
					}
			}
			
			text = Ultility.filterVietnameseCharacter(text, true);
			
			for (i = 0; i < SearchFriendArr.length; i++ )
			{
				name = SearchFriendArr[i].NickName as String;
				name = Ultility.filterVietnameseCharacter(name, true);
				if (name.indexOf(text) == -1)
				{
					SearchFriendArr.splice(i, 1);
					i -= 1;
				}
			}
			UpdateTopContent();
			UpdateBotContent();
		}
		
		public override function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void 
		{
			switch (txtID)
			{
				case GUI_GIFT_SEARCH:
					Search(txtID);
				break;
			}
		}
		public override function OnButtonMove(event: MouseEvent, buttonID: String): void
		{
			switch(buttonID)
			{
				case GUI_GIFT_BUTTON_CANCEL:
				break;
				
				case GUI_GIFT_BUTTON_CLOSE:
				break;
				
				case GUI_GIFT_BUTTON_SEND:
				break;
				
				default:
					var s: Array = buttonID.split("_", 3);
					var id: int = int(s[1]);
					var container:Container = FriendContainerArr[id];
					var tf: TextField = container.LabelArr[0];
					tf.textColor = 0xD71717;
				break;
			}
		}
		
		public override function OnButtonOut(event: MouseEvent, buttonID: String): void
		{
			switch(buttonID)
			{
				case GUI_GIFT_BUTTON_CANCEL:
				break;
				
				case GUI_GIFT_BUTTON_CLOSE:
				break;
				
				case GUI_GIFT_BUTTON_SEND:
				break;
				
				default:
					var s: Array = buttonID.split("_", 3);
					var id: int = int(s[1]);
					var container:Container = FriendContainerArr[id];
					var tf: TextField = container.LabelArr[0];
					tf.textColor = 0x000000;
				break;
			}
		}
		
		public override function OnButtonClick(event: MouseEvent, buttonID: String): void
		{
			switch(buttonID)
			{
				case GUI_GIFT_BUTTON_CANCEL:
					Hide();
				break;
				
				case GUI_GIFT_BUTTON_CLOSE:
					Hide();
				break;
				
				case GUI_GIFT_BUTTON_SEND:
					var ID: int = int(GuiMgr.getInstance().GuiGift.currentGiftID);
					if (PickFriendArr.length <= 0)
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Chọn bạn để tặng quà");
					else
					{
						//Gói tin gửi quà
						var sendGift: SendGift = new SendGift(ID);
						
						//Add những người nhận quà vào gói tin gửi quà và Update lại danh sách những người đã nhận quà
						var rarr: Array = GameLogic.getInstance().user.GetMyInfo().ReceiverGiftList;
						for (var i:int = 0; i < PickFriendArr.length; i++)
						{						
							sendGift.AddReceive(PickFriendArr[i].ID);
							rarr.push(PickFriendArr[i].ID);
						}
						//Tính toán lại số lượng người còn được nhận quà
						GameLogic.getInstance().user.GetMyInfo().NumReceiver -= PickFriendArr.length;						
						
						//Gửi gói tin đi											
						Exchange.GetInstance().Send(sendGift);
						Hide();
						//GuiMgr.getInstance().GuiGift.Hide();
						GuiMgr.getInstance().GuiReceiveGift.Hide();
					}
					
					//Hide();
					//GuiMgr.getInstance().GuiGift.Hide();
					//GuiMgr.getInstance().GuiReceiveGift.Hide();
				break;
				
				case GUI_GIFT_SEARCH:
					NameTextbox.SetText("");
					Search(GUI_GIFT_SEARCH);
				break;
				
				default:					
					ReplaceContent(buttonID);
					UpdateTopContent();
					UpdateBotContent();					
					
					//Set trạng thái nút gửi cho bạn bè
					if (PickFriendArr.length > 0) buttonSend.SetEnable();
					else buttonSend.SetDisable();
					
					//Tutorial
					var curTutorial:String = QuestMgr.getInstance().GetCurTutorial();
					if (curTutorial.search("BtnSendGift3") >= 0)
					{
						GetImage(ICON_HELPER).SetPos(150 + 86, 30 + 381);
					}
				break;
			}
		}
	}
}

