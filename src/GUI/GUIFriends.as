package GUI 
{
	import com.adobe.utils.StringUtil;
	import Data.INI;
	import Data.ResMgr;
	import Effect.ImageEffect;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import GameControl.GameController;
	import GameControl.HelperMgr;
	import GUI.component.ActiveTooltip;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import GUI.component.TooltipFormat;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.MyUserInfo;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendRefreshFriend;
	import Data.ConfigJSON;
	/**
	 * ...
	 * @author ...
	 */
	public class GUIFriends extends BaseGUI 
	{
		private const TIME_FOR_INVITE:int = 28800;
		public static const MAX_SHOW:int = 6;
		public static const DEFAULT_LAKE:int = 1;
		public static const SORT_BY_LEVEL:String = "level";
		public static const SORT_BY_NAME:String = "name";
		
		private const GUI_FRIENDS_UPDATE:String = "ButtonUpdate";
		private const GUI_FRIENDS_NEXT:String = "ButtonNext";
		private const GUI_FRIENDS_BACK:String = "ButtonBack";
		private const GUI_FRIENDS_LIST_BG:String = "BackgroundListFriend";
		private const GUI_FRIENDS_FIRST:String = "ButtonFirst";
		private const GUI_FRIENDS_LAST:String = "ButtonLast";		
		private const GUI_FRIENDS_BTN_FIND: String = "ButtonFind";
		private const GUI_FRIENDS_TXTSEARCH: String = "txtSearch";
		public static const GUI_FRIENDS_BTN_INVITE_FRIEND:String = "BtnInviteFriend";
		
		private const BORDER_AVATAR:String = "borderAvatar";
		
		public var btnNext:Button;
		public var btnBack:Button;
		public var btnStart:Button;
		public var btnEnd:Button;
		public var imageBgListFriend:Image;
		public var txtSearch:TextBox;
		//public var highlight:Image = null;
		public var page:int;
		public var totalpage:int;
		
		public var ListBackup:Array = [];
		public var FriendList:Array = [];
		public var FriendShow:Array = [];
		public var FriendAttacked:Object;
		
		//hiepnm2 cái này để lưu lại thời gian feed mời bạn lần cuối, tạm thời để ở đây :D mong chủ nhà cho chú ngụ :))
		public static var so:SharedObject;
		public static var savedSetting:Object;
		public var icHelper:Image;
		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		private var WaitData:Sprite = new DataLoading();
		
		public function GUIFriends(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{			
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFriends";
		}
		
		public override function Show(ilayer:int = Constant.GUI_MIN_LAYER, ShowModal:int = 0):void
		{
			super.Show(ilayer, ShowModal);
		}
		
		public override function InitGUI(): void
		{
			LoadRes("");
			SetPos(4, Constant.STAGE_HEIGHT - 105);
			LastX = img.x;
			LastY = img.y;
			imageBgListFriend = AddImage(GUI_FRIENDS_LIST_BG, "ImgBgListFriend", 480, 48);
			//ListBackup = [];
			//FriendList = [];
			//FriendShow = [];
			//imageBgListFriend.SetSize(595, 100);
			btnNext = AddButton(GUI_FRIENDS_NEXT, "BtnNext", 770,17,this);	
			btnBack = AddButton(GUI_FRIENDS_BACK, "BtnPrev", 170, 17, this);				
			btnStart = AddButton(GUI_FRIENDS_FIRST, "BtnFirst", 170, 51,this);			
			btnEnd = AddButton(GUI_FRIENDS_LAST, "BtnEnd", 770, 51, this);	
			AddImage("", "TxtSearch", 9, 34, true, ALIGN_LEFT_TOP);
			//AddButton(GUI_FRIENDS_UPDATE, "BtnUpdateListFriend", 125, 50, this);					
			AddButton(GUI_FRIENDS_UPDATE, "BtnUpdateListFriend", 15, 70, this);					
			AddButtonEx(GUI_FRIENDS_BTN_FIND, "BtnSearch", 120, 37, this);			
			var btn:Button = AddButton(GUI_FRIENDS_BTN_INVITE_FRIEND, "BtnMoibanchoavatar", 210, 21, this);
			btn.img.width = btn.img.width * 0.8;
			btn.img.height = btn.img.height * 0.8;
			var txtFormat: TextFormat = new TextFormat("Arial", 14, 0xffffff);
			txtSearch = AddTextBox(GUI_FRIENDS_TXTSEARCH, "", 15, 36, 111, 22);			
			txtSearch.textField.defaultTextFormat = txtFormat;
			txtSearch.textField.border = false;						
			txtSearch.MyParent = this;
			
			//highlight = AddImage("", "ImgVCAvatar1", 204, 11, true, Image.ALIGN_LEFT_TOP);
			//highlight.SetSize(56, 56);
			MoveBorder(-1);
			
			btnNext.SetEnable(false)
			btnBack.SetEnable(false)
			btnStart.SetEnable(false)
			btnEnd.SetEnable(false)
			FriendShow.splice(0, FriendShow.length)	
			
			img.addChild(WaitData);
			WaitData.x = img.width / 2 + 60;
			WaitData.y = img.height / 2 - 10;
		}
		
		public function AddFriendList(arr:Array):void
		{
			var i:int;
			FriendList.splice(0, FriendList.length);
			ListBackup.splice(0, ListBackup.length);
			var currentTime:Number = GameLogic.getInstance().CurServerTime;
			for (i = 0; i < arr.length; i++)
			{
				if (arr[i]["Id"] < 0)
				{
					arr[i]["Active"] = 2;
				}
				else
				if ((currentTime - arr[i]["LastDayLogin"]) < 24 * 3600)
				{
					arr[i]["Active"] = 1;
				}
				else
				{
					arr[i]["Active"] = 0;
				}
				FriendList.push(arr[i]);
				ListBackup.push(arr[i]);
			}
			var user:MyUserInfo = GameLogic.getInstance().user.GetMyInfo();
			var Myself:Object = new Object();
			Myself["Active"] = 1;
			Myself["AvatarPic"] = user.AvatarPic;
			Myself["Exp"] = user.Exp;
			Myself[ConfigJSON.KEY_ID] = user.Id;
			Myself["Level"] = user.Level;
			Myself[ConfigJSON.KEY_NAME] = user.Name;
			FriendList.push(Myself);
			ListBackup.push(Myself);
			Myself = null;
			ShowFriend();
			CheckButton();
			if (img && img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
		}
		
		public function ShowFriend(page:int = 1):void
		{
			FriendAttacked = GameLogic.getInstance().user.GetMyInfo().Avatar;
			
			if (imageBgListFriend.img.visible == false)
			{
				imageBgListFriend.img.visible = true;
			}
			while(FriendShow.length > 0)
			{
				var tmpContainer:Container = FriendShow[0];
				HelperMgr.getInstance().ClearHelper(tmpContainer.HelperName);
				tmpContainer.Clear();
				FriendShow.splice(0, 1);
			}
			this.totalpage = Math.ceil(FriendList.length / MAX_SHOW);
			if (page < 1 || page > totalpage)
			{
				return;
			}
			// sắp xếp theo level, exp			
			SortFriend();
			
			// Chuẩn bị show hàng			
			this.page = page;
			var tmpPage:Number;
			if (this.page == totalpage)
			{
				if(FriendList.length >= MAX_SHOW)
					tmpPage = (FriendList.length - MAX_SHOW + 1) / MAX_SHOW;
				else
					tmpPage = 1 / FriendList.length;
			}
			else
			{
				tmpPage = (page + (MAX_SHOW - 1) * (page - 1))/MAX_SHOW;
			}
			
			// Show ra 8 người bạn
			var i:int = 0;			
			if (FriendList.length <= 0)
			{
				return;
			}
			var max:int = FriendList.length;
			if (FriendList.length >= MAX_SHOW)
			{
				max = MAX_SHOW;
			}
			
			/*var idHelper:int;
			// Kiếm 1 bạn bè ngẫu nhiên để hiện helper sang tấn công
			if (FriendList[max * tmpPage - 1].Id != GameLogic.getInstance().user.GetMyInfo().Id)
			{
				idHelper = 0;
			}
			else
			{
				idHelper = 1;
			}*/
			if (icHelper == null)
			{
				icHelper = AddImage("", "IcHelper", 35 + 280, 8, true, ALIGN_LEFT_TOP);
				icHelper.img.visible = false;
			}
			for (i = 0; i < max; i++)
			{
				var slot:int = i + max * tmpPage;
				var container:Container;
				container = AddContainer(FriendList[slot - 1].Id + "_" + i, "ImgAvatar", 280 + i * 80, 18, true, this);
				//if (i == 0)
				//{
					//container = AddContainer(FriendList[slot - 1].Id + "_" + i, "ImgAvatar", 280 + i * 80, 18, true, this, "VisitFriend");
					//
				//}
				//else
				//{
					//container = AddContainer(FriendList[slot - 1].Id + "_" + i, "ImgAvatar", 280 + i * 80, 18, true, this);
				//}
				container.AddImage("", "ImgFrameAvatar", 0, 0, true, Image.ALIGN_LEFT_TOP);
				if (FriendList[slot - 1].AvatarPic == null || FriendList[slot - 1].AvatarPic == "")
				{
					FriendList[slot - 1].AvatarPic = Main.staticURL + "/avatar.png";
				}
				if (FriendList[slot - 1].Name == null || !FriendList[slot - 1].Name)
				{
					FriendList[slot - 1].Name = "Unknown";
				}
				
				//FriendList[slot - 1].AvatarPic = "abc";
				
				var setInfo:Function = function loadAvatarComplete():void
				{
					this.SetSize(50, 50);
					this.SetPos(9, 10);
					this.img.mouseEnabled = false;
					this.img.mouseChildren = false;		
					var index:int;
					if (this.img.parent.numChildren > 1)
					{
						index = 1;
					}
					else
					{
						index = 0;
					}
					
					this.img.parent.setChildIndex(this.img, index);				
				}
				var imgAva:AvatarImage = new AvatarImage(container.img, FriendList[slot - 1].AvatarPic, 9, 10, false, ALIGN_LEFT_TOP, false, setInfo);
				//var imgAva:AvatarImage = new AvatarImage(container.img);
				//imgAva.initAvatar(FriendList[slot - 1].AvatarPic, setInfo);
				
				
				//var imgAva:Image = container.AddImage("", FriendList[slot-1].AvatarPic, 9, 10, false, Image.ALIGN_LEFT_TOP);
				//imgAva.SetSize(50, 50);
				//imgAva.img.mouseEnabled = false;
				//imgAva.img.mouseChildren = false;
				
				var imgHighlight:Image = container.AddImage(BORDER_AVATAR, "ImgVCAvatar1", 7, 8, true, Image.ALIGN_LEFT_TOP);
				imgHighlight.img.visible = false;
				imgHighlight.SetSize(54, 54);
				MoveBorder( -1);
				container.AddImage("", "ImgEXP", 40, 44, true, Image.ALIGN_LEFT_TOP);
				var txtFormat: TextFormat = new TextFormat("Arial", 14, 0xFFFF00);
				txtFormat.align = "center";
				
				if (FriendList[slot - 1].Level == null) return;//hiepnm2
				var txtLevel:TextField = container.AddLabel(FriendList[slot-1].Level.toString(), 7, 51, 0, 1, 0x26709C);				
				var name:TextField;
				var nick:String;
				if (FriendList[slot-1].Name.length <= 8)
				{
					nick = FriendList[slot-1].Name;
				}
				else
				{
					nick = FriendList[slot-1].Name.substr(0, 8) + "..";
				}
				name = container.AddLabel(nick, -16, -18, 0, 1);
				txtLevel.setTextFormat(txtFormat);
				
				txtFormat.size = 12;
				txtFormat.color = 0x0D789C;
				name.wordWrap = true;
				name.setTextFormat(txtFormat);
				//var tooltip:TooltipFormat = new TooltipFormat();
				//tooltip.text = FriendList[slot - 1].Name
				//container.setTooltip(tooltip);
				
				var str:String = "";	// xâu bạn đã chiến thắng / thất bại
				
				// Icon thắng thua
				var imgg:Image;
				if (FriendAttacked)
				if (FriendAttacked[FriendList[slot - 1].Id])
				{
					if (FriendAttacked[FriendList[slot - 1].Id] == 1)
					{
						 //Icon thua
						imgg = container.AddImage("", "ImgAttackLose", 17, 17);
						str = "Bạn đã thua ";
					}
					else if (FriendAttacked[FriendList[slot - 1].Id] >= 2)
					{
						 //Icon thắng
						imgg = container.AddImage("", "ImgAttackWin", 17, 17);
						str = "Bạn đã thắng ";
					}
					imgg.SetScaleXY(0.7);
				}
				
				FriendShow.push(container);
				
				var tooltip:TooltipFormat = new TooltipFormat();
				tooltip.text = str + FriendList[slot - 1].Name;
				container.setTooltip(tooltip);
			}
			CheckBorder(GameLogic.getInstance().user.Id);
		}
		
		public function HideFriend():void 
		{
			imageBgListFriend.img.visible = false;
			for (var i:int = 0; i < FriendShow.length; i++) 
			{
				var tmpContainer:Container = FriendShow[i];
				tmpContainer.Clear();
			}
		}
		
		public function SortFriend(type:String = SORT_BY_LEVEL):void
		{
			switch(type)
			{
				case SORT_BY_LEVEL:
					FriendList.sortOn(["Active", "Level", "Exp"], Array.DESCENDING | Array.NUMERIC);
					break;
				case SORT_BY_NAME:
					FriendList.sortOn(ConfigJSON.KEY_NAME);
					break;
			}
		}
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID)
			{
				case GUI_FRIENDS_BTN_INVITE_FRIEND:
				{
					if (!GetCanInvite())
					{
						var tooltip:TooltipFormat = new TooltipFormat();
						tooltip.text = "Chờ 8 tiếng để đăng thông báo tiếp";
						ActiveTooltip.getInstance().showNewToolTip(tooltip, GetButton(GUI_FRIENDS_BTN_INVITE_FRIEND).img);
					}
					break;
				}
			}
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			ActiveTooltip.getInstance().clearToolTip();
		}
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{	
			switch (buttonID)
			{
				case GUI_FRIENDS_NEXT:					
					ShowFriend(page + 1);
					break;		
				case GUI_FRIENDS_BACK:
					ShowFriend(page -1);
					break;
				case GUI_FRIENDS_FIRST:
					ShowFriend(1);
					break;
				case GUI_FRIENDS_LAST:
					ShowFriend(totalpage);
					break;
				case GUI_FRIENDS_BTN_FIND:
					Search(txtSearch.GetText());
					break;
				case GUI_FRIENDS_UPDATE:
					UpdateFriend();
					break;
				case GUI_FRIENDS_TXTSEARCH:
					break;
				case GUI_FRIENDS_BTN_INVITE_FRIEND:
					//dieu kien de feed la lan feed truoc cach lan feed nay hon 8 tieng
					if (GetCanInvite())
					{
						GameLogic.getInstance().SetState(GameState.GAMESTATE_INIVTE_FRIEND);
						GameLogic.getInstance().InviteFriend();
					}
					else
					{
						//hien thi tooltip doi 8 tieng nua
						var tooltip:TooltipFormat = new TooltipFormat();
						tooltip.text = "Chờ 8 tiếng để đăng thông báo tiếp";
						ActiveTooltip.getInstance().showNewToolTip(tooltip, GetButton(GUI_FRIENDS_BTN_INVITE_FRIEND).img);
					}
					break;
				default:
					GoToFriend(buttonID);
					return;
			}
			CheckButton();
		}
		
		public function UpdateFriend():void
		{
			MoveBorder( -1);
			img.addChild(WaitData);
			while(FriendShow.length > 0)
			{
				var tmpContainer:Container = FriendShow[0];
				tmpContainer.Clear();
				FriendShow.splice(0, 1);
			}
			
			var friendlist:SendRefreshFriend = new SendRefreshFriend(true);
			Exchange.GetInstance().Send(friendlist);
		}
		
		public function GoToFriend(UID:String):void
		{	
			var stt:int = UID.split("_")[1];
			var st:String = "GoToLake_" + DEFAULT_LAKE + "_" + UID;
			GameController.getInstance().UseTool(st);
			MoveBorder(stt);
		}
		
		public function MoveBorder(stt:int):void
		{
			var container:Container;
			var highlight:Image;
			if (stt < 0)
			{
				for (var i:int = 0; i < FriendShow.length; i++)
				{
					container = FriendShow[i];
					highlight = container.GetImage(BORDER_AVATAR) as Image;
					//highlight.img.alpha = 0;
					highlight.img.visible = false;				
				}
			}
			else
			{
				MoveBorder( -1);
				container = FriendShow[stt];
				highlight = container.GetImage(BORDER_AVATAR) as Image;		
				//highlight.img.alpha = 100;
				highlight.img.visible = true;
			}
		}
		
		public function CheckButton():void
		{
			if (totalpage == 1 || totalpage == 0)
			{
				btnEnd.SetEnable(false);
				btnNext.SetEnable(false);
				btnBack.SetEnable(false);
				btnStart.SetEnable(false);
			}
			else if (this.page == totalpage)
			{
				btnEnd.SetEnable(false);
				btnNext.SetEnable(false);
				btnBack.SetEnable(true);
				btnStart.SetEnable(true);
			}
			else if (this.page == 1)
			{
				btnEnd.SetEnable(true);
				btnNext.SetEnable(true);
				btnBack.SetEnable(false);
				btnStart.SetEnable(false);
			}
			else
			{
				btnEnd.SetEnable(true);
				btnNext.SetEnable(true);
				btnBack.SetEnable(true);
				btnStart.SetEnable(true);
			}
		}
		
		public override function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void
		{
			Search(txtSearch.GetText());
			CheckButton();
		}
		
		public function Search(st:String):void
		{
			st = StringUtil.trim(st);
			st = Ultility.filterVietnameseCharacter(st, true);
			var i:int;			
			FriendList.splice(0, FriendList.length);
			for (i = 0; i < ListBackup.length; i++)
			{
				var name:String = ListBackup[i].Name;
				if (name == null) continue;
				name = Ultility.filterVietnameseCharacter(name, true);
				if (name.search(st.toLocaleLowerCase()) != -1)
				{
					FriendList.push(ListBackup[i]);
				}
			}
			ShowFriend();
		}
		
		public function CheckBorder(CurrentId:int):void
		{
			var i:int;
			for (i = 0; i < FriendShow.length; i++)
			{
				var FriendId:int = FriendShow[i].IdObject.split("_")[0]
				if (CurrentId == FriendId)
				{
					MoveBorder(i);
					return;
				}
			}
			MoveBorder( -1);;
		}
		
		public override function Fullscreen(IsFull:Boolean, dx:int = 0, dy:int = 0, scaleX:Number = 1, scaleY:Number = 1):void
		{	
			if (IsFull)
			{
				var BgLayer:Layer = LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER);
				img.y = BgLayer.y + BgLayer.height - img.height + 20;
			}
			else
			{			
				img.x = LastX;
				img.y = LastY;
			}
		}
		/**
		 * xét xem user có thể feed mời bạn hay không
		 * @return true: nếu có thể feed, false nếu không thể
		 */
		public function GetCanInvite():Boolean
		{
			if (savedSetting.lastTimeFeed)
			{
				var saveTime:Number = savedSetting.lastTimeFeed;
				var currentTime:Number = GameLogic.getInstance().CurServerTime;
				var khoangthoigian:Number = currentTime - savedSetting.lastTimeFeed;
				if (khoangthoigian < TIME_FOR_INVITE)
					return false;
				else
					return true;
			}
			else
				return true;
		}
		/**
		 * lưu thời điểm feed cuối cùng của user
		 */
		public function SavedFeed():void
		{
			//lưu lại người feed và thời điểm cuối cùng người đó feed
			savedSetting.lastTimeFeed = GameLogic.getInstance().CurServerTime;
		}
		/**
		 * thực hiện truy suất SharedObject để lấy hay gán thời gian feed cuối cùng của user
		 */
		public static function AchiveSavedSetting():void
		{
			var userId:int = GameLogic.getInstance().user.GetMyInfo().Id;
			var addressSaved:String = "SavedInviteFriendSetting_" + GameLogic.getInstance().user.GetMyInfo().Id;
			so = SharedObject.getLocal(addressSaved);
			if (so.data.uId != null)					//lay trong cache trong truong hop co du lieu
				savedSetting = so.data.uId;
			else										//luu vao trong cache trong truong hop ko co du lieu
			{
				savedSetting = new Object();
				so.data.uId = savedSetting;
			}
		}
	}

}






























