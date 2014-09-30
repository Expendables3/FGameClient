package GUI.unused
{
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TextBox;
	import Logic.Friend;
	import Logic.GameLogic;
	import flash.events.Event;
	import flash.display.Sprite;
	import Data.*;
	import NetworkPacket.PacketSend.SendInitRun;
	import NetworkPacket.PacketSend.SendRefreshFriend;
	import com.adobe.utils.StringUtil;
	
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Hien
	 */
	public class GUIFriend extends BaseGUI
	{
		private const GUI_FRIEND_UPDATE:String = "ButtonUpdate";
		private const GUI_FRIEND_NEXT:String = "ButtonNext";
		private const GUI_FRIEND_BACK:String = "ButtonBack";
		private const GUI_FRIEND_START:String = "ButtonStart";
		private const GUI_FRIEND_END:String = "ButtonEnd";
		private const GUI_FRIEND_BTN_CLOSE: String = "ButtonClose";
		
		private const GUI_FRIEND_BTN_FIND: String = "ButtonFind";
		private const GUI_FRIEND_SEARCH: String = "timkiem";
		private const GUI_FRIEND_CONTAINER: String = "container";
		private var txt: TextBox;
		private var btnNext: ButtonEx;
		private var btnBack: ButtonEx;
		private var btnStart: ButtonEx;
		private var btnEnd: ButtonEx;
		
		public var CurrentPage: int = 0;
		public var MaxPage: int = 1;
		public var FriendSearch: Array = [];
		//public var FriendArr: Array = [];
		
		private var image: Image;
		private var txtSearch: TextBox;
		
		private  var container: Container;
		private const MAX_FRIEND_SHOW: int  = 8;	
		public var IsRefresh: Boolean = false;
		
		
		//public var chuoi: String = "";
			
		public function GUIFriend(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIFriend";			
		}
		public override function InitGUI(): void
		{
			LoadRes("ImgBgFriendAvatar");
			
			btnNext = AddButtonEx(GUI_FRIEND_NEXT, "ButtonNext", 770,14,this);	
			btnBack = AddButtonEx(GUI_FRIEND_BACK, "ButtonBack", 170, 14, this);				
			btnStart = AddButtonEx(GUI_FRIEND_START, "ButtonEnd", 170, 62,this);			
			btnEnd = AddButtonEx(GUI_FRIEND_END, "ButtonStartMovie", 770, 62, this);	
			AddButtonEx(GUI_FRIEND_UPDATE, "ButtonUpdateFriend", 120, 45, this);					
			AddButtonEx(GUI_FRIEND_BTN_FIND, "ButtonSearch", 125, 25, this);	 
			
			var txtFormat: TextFormat = new TextFormat("Arial", 14, 0xffffff);
			txtSearch = AddTextBox(GUI_FRIEND_SEARCH, "", 25,20, 111, 22);			
			txtSearch.textField.defaultTextFormat = txtFormat;
			txtSearch.textField.border = false;						
			txtSearch.MyParent = this;
		//	txtSearch.textField.text = chuoi;			
			txtSearch.textField.addEventListener("change", search);
						
			//FriendArr = GameLogic.getInstance().user.GetFriendArr();
			AddFriendArr(0);
			SetPos(0, 540);					
				
		}
		
		//Hien danh sach ban be
		public function AddFriend(FriendID: int,stt: int,x: int, y: int,imgName: String,NickName: String): void
		{				
			var imgF: Image;
			var i: int = 0;
			var index: int;	
			var name: String = NickName;
			var container:Container = AddContainer(FriendID + "_" + stt, "ImgAvatar", x - 15, y, true, this);	
			
			imgF = container.AddImage("", imgName, 5, 22, false, ALIGN_LEFT_TOP);			 
			imgF.SetSize(50, 50);	
			
			var txtFormat: TextFormat = new TextFormat("Arial", 14, 0x783696);
			for (i = 0; i < GameLogic.getInstance().user.FriendArr.length; i++ )
			{
				if (GameLogic.getInstance().user.FriendArr[i].ID == FriendID)
				{
					index = GameLogic.getInstance().user.FriendArr[i].Index;					
					break;
				}
			}			
			var indexF: TextField = container.AddLabel((index +1).toString(), -20, 2);
			indexF.setTextFormat(txtFormat);									
			
			if (name.length > 9)
			{
				name = name.substring(0,9);
				name = name.concat("...");			
			}
			var nameF:TextField = container.AddLabel(name, -15, 75);						
			container.TooltipText = NickName;			
			
		}	
		
		public function AddFriendArr(page: int): void
		{
			//this.Hide();
			//this.Show(Constant.GUI_MIN_LAYER+1);	
			var j:int;			
			var length: int;		
			if (FriendSearch.length == 0)			
				length = GameLogic.getInstance().user.FriendArr.length;
			else
				length = FriendSearch.length;
									
			var nCol:int = 1;
			var nPageSlot:int = MAX_FRIEND_SHOW * nCol;
			MaxPage = Math.ceil(length / nPageSlot);			
			CurrentPage = page;			
			RemoveImage(image);			
			for (j = 0; j < GameLogic.getInstance().user.FriendArr.length; j++)
			{
				for (var k: int = 0; k < MAX_FRIEND_SHOW; k++)
				{					
					RemoveContainer(GameLogic.getInstance().user.FriendArr[j].ID + "_" + k);					
				}
			}
			
					
			if (CurrentPage >= MaxPage) 
			{
				CurrentPage = MaxPage - 1;
			}
			if (CurrentPage < 0)
			{
				CurrentPage = 0;
			}		
			var vt:int = CurrentPage * nPageSlot;
			var imgName: String;
			var nickName: String;
			var index: int;
			var nItem:int = nPageSlot;
			
			if (vt + nItem >= length)
			{	
				if (length > MAX_FRIEND_SHOW)
				{
					var remain: int = length - nPageSlot * CurrentPage;
					vt -= (MAX_FRIEND_SHOW - remain);												
				}
				else
				{
					nItem = length - vt;
				}
			}
			
			var r: int;
			var c: int;
			var x: int;
			var y: int;
			for (var i:int = vt; i < vt + nItem; i++)
			{
				if ((i -   vt) > MAX_FRIEND_SHOW * nCol+1 )
				{
					return;
				}
				
				r = (i - vt)/ MAX_FRIEND_SHOW;
				c = (i - vt) % MAX_FRIEND_SHOW;
				x = 220 + c * (54 + 17);
				y = -7 + r * (82 + 30);		
				if (FriendSearch.length == 0)
				{										
					AddFriend(GameLogic.getInstance().user.FriendArr[i].ID, i - vt, x, y, GameLogic.getInstance().user.FriendArr[i].imgName, GameLogic.getInstance().user.FriendArr[i].NickName);										
					UpdateAvatar(i, i - vt);
				}
				else
				{
					for (j = 0; j < GameLogic.getInstance().user.FriendArr.length; j++ )
					{						
						if (FriendSearch[i] == GameLogic.getInstance().user.FriendArr[j].ID)
						{
							imgName = GameLogic.getInstance().user.FriendArr[j].imgName;
							nickName = GameLogic.getInstance().user.FriendArr[j].NickName;
							index = GameLogic.getInstance().user.FriendArr[j].Index;
							AddFriend(FriendSearch[i], i - vt, x, y, imgName, nickName);
							//UpdateAvatar(index, i - nPageSlot*page);
							UpdateAvatar(index, i - vt);
							break;
						}						
					}
				}					
			}
			InitFriendButton();			
		}
		
		public function InitFriendButton(): void
		{
			if (MaxPage >1)
			{		
				
				if (CurrentPage == 0)
				{
					btnBack.SetEnable(false);
					btnNext.SetEnable(true);
					btnStart.SetEnable(false);
					btnEnd.SetEnable(true);
				}
				if (CurrentPage == MaxPage - 1)
				{
					btnNext.SetEnable(false);
					btnBack.SetEnable(true);	
					btnEnd.SetEnable(false);
					btnStart.SetEnable(true);
				}
				if (CurrentPage > 0 && CurrentPage < MaxPage - 1)
				{
					btnNext.SetEnable(true);
					btnBack.SetEnable(true);
					btnEnd.SetEnable(true);
					btnStart.SetEnable(true);
				}
			}
			else
			{
				btnBack.SetDisable();
				btnNext.SetDisable();
				btnEnd.SetEnable(false);
				btnStart.SetEnable(false);
			}
			
		}
		
		public function UpdateAvatar(FriendIndex: int, ContainerIndex: int): void
		{
			var friend: Friend = GameLogic.getInstance().user.FriendArr[FriendIndex] as Friend;
			if (friend.IsChoose)
			{
				var container: Container = ContainerArr[ContainerIndex] as Container;
				image = AddImage("", "VC_Avatar1", container.GetPosition().x + 23 , container.GetPosition().y + 40, true);				
				image.SetSize(55, 55);					
			}
		}
		
		public function search(e: Event): void
		{						
			var searchText:String = txtSearch.textField.text.toLowerCase();
			searchText = StringUtil.trim(searchText);
			var find: String = searchText;						
			var i: int;
			var j: int;
			
			var n: int = 0;
			var myId: int = GameLogic.getInstance().user.GetMyInfo().Id;
			FriendSearch.splice(0, FriendSearch.length);			
			for (i = 0; i < GameLogic.getInstance().user.FriendArr.length; i++ )
			{	
				for (j = 0; j < MAX_FRIEND_SHOW; j++ )
				{
					RemoveContainer(GameLogic.getInstance().user.FriendArr[i].ID + "_" +j);
				}
			}
			
					
			RemoveImage(image);
			if (searchText != "")
			{			
				for (i = 0; i < GameLogic.getInstance().user.FriendArr.length; i++ )
				{						
					var k: String;
					var m: int;
					k = GameLogic.getInstance().user.FriendArr[i].NickName;
					k = k.toLowerCase();
					m = k.indexOf(find);									
					if (m != -1)
					{								
						FriendSearch[n] = GameLogic.getInstance().user.FriendArr[i].ID;						
						n ++;		
						AddFriendArr(0);	
					}						
				}					
							
			}
			else
			{
				AddFriendArr(0);
			}
		}
		
				
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			
			switch(buttonID)
			{
				case GUI_FRIEND_BTN_CLOSE:					
					Hide();
				break;
				case GUI_FRIEND_NEXT:					
					if (CurrentPage < MaxPage - 1)
					{
						AddFriendArr(CurrentPage + 1);
					}					
				break;		
				case GUI_FRIEND_BACK:
					if (CurrentPage > 0)
					{
						AddFriendArr(CurrentPage - 1);
					}
				break;
				case GUI_FRIEND_START:
				{																
					 AddFriendArr(0);       		
				}break;
				case GUI_FRIEND_END:
				{											
					AddFriendArr(MaxPage);
				}break;
				case GUI_FRIEND_BTN_FIND:
				{
					
				}break;
				case GUI_FRIEND_UPDATE:
					for (var j: int; j < GameLogic.getInstance().user.FriendArr.length; j++)
					{
						for (var k: int = 0; k < MAX_FRIEND_SHOW; k++)
						{
							VisibleContainer(GameLogic.getInstance().user.FriendArr[j].ID + "_" + k);
						}
					}
					RemoveImage(image);
					var friendlist: SendRefreshFriend = new SendRefreshFriend(true);
					Exchange.GetInstance().Send(friendlist);
					IsRefresh = true;					
				break;
				default:
				{
					LoadFriend(buttonID);
				}break;
			}
		}
		//Load game cua ban be theo ID button- dua vao ID ban be
		public function LoadFriend(FriendID: String): void
		{
			var data: Array = FriendID.split("_");
			if (data.length < 2)
				return;
			var FriendId: int = data[0];						
			var stt: int = data[1];
			var i: int = 0;
			var friend: Friend;
			if (image != null)
				this.RemoveImage(image);	
			for (i = 0; i < GameLogic.getInstance().user.FriendArr.length; i++ )
			{
				friend = GameLogic.getInstance().user.FriendArr[i] as Friend;
				if (friend.ID == FriendId)
				{						
					friend.IsChoose = true;					
					UpdateAvatar(i, stt);
				}
				else
					friend.IsChoose = false;					
			}
			var st:String = "GoToLake_1_" + FriendId.toString();
			GameController.getInstance().UseTool(st);
			//GameLogic.getInstance().DoGoToLake(1, FriendId);
		}
		
		public function LoadMySelf(): void
		{			
			var i: int;			
			var friend: Friend;	
			var index: int = 0;
			for (i = 0; i < GameLogic.getInstance().user.FriendArr.length; i++)
			{
				friend = GameLogic.getInstance().user.FriendArr[i] as Friend;
				if (friend.ID == GameLogic.getInstance().user.GetMyInfo().Id)
				{				
					friend.IsChoose = true;
					index = friend.Index;
				}
				else
				{
					friend.IsChoose = false;
				}
			}
			
			AddFriendArr(index/MAX_FRIEND_SHOW);			
		}
	}
	
	
		
}
		
		
		