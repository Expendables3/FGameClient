package GUI 
{
	import com.adobe.utils.ArrayUtil;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventLuckyMachine.EventLuckyMachineMgr;
	import Event.EventMgr;
	import Event.Factory.FactoryLogic.EventSvc;
	import fl.containers.ScrollPane;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.trace.Trace;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.EventBirthDay.EventLogic.BirthDayItemMgr;
	import Logic.GameLogic;
	import flash.text.TextFormat;
	import flash.display.Sprite;
	import Data.*;
	import NetworkPacket.PacketSend.SendLoadGift;
	
	import NetworkPacket.PacketSend.SendRemoveMessage;
	import Sound.SoundMgr;
	import fl.controls.ScrollBar;
	import fl.controls.ScrollBarDirection;
	import fl.events.ScrollEvent;
	import flash.geom.ColorTransform;
	import GameControl.HelperMgr;
	import NetworkPacket.PacketSend.SendAcceptGift;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author thint
	 * Hien thi cac mon qua duoc gui cho minh
	 */
	public class GUIReceiveGift extends BaseGUI
	{
		private const GUI_GIFT_BTN_SEND:String = "ButtonGiftSend";
		private const GUI_RECEIVELETTER_BTN_CLOSE:String = "ButtonClose";	
		private const GUI_GIFT_BTN_NEXT:String = "ButtonNext";
		private const GUI_GIFT_BTN_BACK:String = "ButtonBack";
		private const GUI_GIFT_BTN_RESPONSE: String = "Response";
		private const ICON_HOPQUA:String = "HopQua";

		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		
		private var WaitData:Sprite = new DataLoading();
		public var Scroll: ScrollPane = new ScrollPane();
		public var Content: Sprite = new Sprite();
		public var ChosenGift: String;
		public var GiftContainerArr: Array = [];
		public var GiftSave: Array = [];
		public var curClickBtnID:String = "";
		
		public function GUIReceiveGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIReceiveGift";
		}
		
		public override function InitGUI(): void
		{
			this.setImgInfo = function():void
			{
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				SetPos(30, 30);
				InitComponent();
				
				WaitData = new DataLoading();
				WaitData.x = 310;
				WaitData.y = 250;
				img.addChild(WaitData);
				
				
				trace("OpenRoomOut");
				//Gửi lên server yêu cầu trả về quà tặng nhận được
				var sendGift: SendLoadGift = new SendLoadGift();
				Exchange.GetInstance().Send(sendGift);
			}
			
			LoadRes("GuiReceiveGift_Theme");
		}
		
		//Khởi tạo các button
		public function InitComponent(): void
		{
			var btnClose: Button = AddButton(GUI_RECEIVELETTER_BTN_CLOSE, "BtnThoat", 706, 20, this);
			var btnSend:Button = AddButton(GUI_GIFT_BTN_SEND, "GuiReceiveGift_BtnTangQua", 300, 515, this, "BtnSendGift1");
			btnSend.SetDisable();
			
			var i: int, j: int;
			var g: Array = GameLogic.getInstance().user.GiftArr;
			for (i = 0; i < GiftSave.length; i++ )
				for (j = 0; j < g.length; j++ )
					if (GiftSave[i] == g[j].Id)
					{
						g.splice(j, 1);
						break;
					}
			GiftSave.splice(0, GiftSave.length);
		}
		
		//Remove cac button de ve lai
		public function RemoveAllButton(container: Container):void
		{
			var i:int;
			var s: String;
			if (container.ButtonArr)
			{
				for (i = 0; i < container.ButtonArr.length; i++)
				{
					var btn1:Button = container.ButtonArr[i] as Button;
					btn1.RemoveAllEvent();
					container.img.removeChild(btn1.img);
					btn1.img = null;
					
				}
				container.ButtonArr.splice(0, ButtonArr.length);
				
				for (i = 0; i < container.LabelArr.length; i++ )
				{
					s = container.LabelArr[i].text;
					if (s == "Nhận quà" || s == "Hủy")
					{
						var tf:TextField = container.LabelArr[i] as TextField;
						container.img.removeChild(tf);
						tf = null;
						container.LabelArr.splice(i, 1);
						i -= 1;
					}
				}
			}
		}
		
		public function removeBtnSendAgain(): void
		{	
			var con:Container;
			var btn:Button;
			if (curClickBtnID.split("_")[0] != GUI_GIFT_BTN_RESPONSE)
				return;
			
			for (var i:int = 0; i < GiftContainerArr.length; i++ )
			{
				con = GiftContainerArr[i];
				con.RemoveButton(curClickBtnID);
			}			
		}

		
		public function UpdateContainer(container: Container, uID:String, giftID:String): void
		{			
			RemoveAllButton(container);
			
			if (allowAgain(parseInt(uID)))
			{
				container.AddButton("Response_" + uID + "_" + giftID, "GuiReceiveGift_BtnTangLai", 400, 20, this);
			}
			container.AddImage("IcComplete", "GuiReceiveGift_IcComplete", 365, 60);
			
			var i: int;
			var tf: TextField;
			for (i = 0; i < container.LabelArr.length; i++ )
			{
				tf = container.LabelArr[i];
				if (tf.text.indexOf("Còn") >= 0)
				{
					container.img.removeChild(tf);
					container.LabelArr.splice(i, 1);
					break;
				}
			}
			
			var textformat: TextFormat = new TextFormat("", 14, 0x3ACD15);
			tf = container.AddLabel("Đã nhận", 289, 72);
			tf.setTextFormat(textformat);
		}
		
		public function TakeGift(index: String): void
		{
			var sarr: Array = index.split("_", 3);
			var i: int, j: int;
			var tf: TextField;
			var container: Container;
			var button: Button;
			
			var garr: Array = GameLogic.getInstance().user.GiftArr;
			var idx:int = int(sarr[1]);
			var gift:Object = garr[idx];
			var obj: Object = ConfigJSON.getInstance().getGiftInfo(gift.GiftId);
			if (gift["GiftId"] == 17)
			{
				//GuiMgr.getInstance().GuiStore.UpdateStore(obj["type"], obj["typeid"]);	//StoneMaze
				HalloweenMgr.getInstance().updateRockStore(obj["typeid"], 1);	//Thạch bảo đồ
				//EventSvc.getInstance().updateItem(obj["type"], obj["typeid"], 1);		//FishHunter...
			}
			for (i = 0; i < GiftContainerArr.length; i++)
			{
				container = GiftContainerArr[i] as Container;
				if (sarr[1] == container.IdObject)
				{
					
					if (sarr[0] == "Take")
					{
						UpdateContainer(container, sarr[2], gift.GiftId);
					}
					else
					{
						Content.removeChild(container.img);
						container = null;
						GiftContainerArr.splice(i, 1);
					}
				}
			}
			
			if (sarr[0] == "Take")
			{
				var sendGift: SendAcceptGift = new SendAcceptGift(gift.Id);
				Exchange.GetInstance().Send(sendGift);
				var obj1: Object = ConfigJSON.getInstance().getItemInfo(obj["type"], obj["typeid"]);
				var type: String = obj["type"];
				var Numb: int = obj1["Num"];
				
				//kiem tra neu la food
				if (type == "Food")
				{
					GameLogic.getInstance().user.UpdateFoodCount(Numb);
				}                                     
				else
				{
					if (obj != null && type != "Balls")
					{
						if (type == "Gem")
						{
							var cfg:Object = ConfigJSON.getInstance().getItemInfo("Gift", gift.GiftId);
							//updae lại kho
							GuiMgr.getInstance().GuiStore.UpdateStore("Gem$" + cfg.Element + "$" + cfg.ItemId, cfg.Day, 1);
						}
						else if (type == "Ticket")
						{
							EventLuckyMachineMgr.getInstance().updateTicket(1);
						}
						else if ((type != "ItemCollection" || obj["typeid"] != 16) && type != "HalItem")//&& type != "Island_Item")//&& type!= "Arrow")//&& type != "Candy") 
						{
							//updae lại kho
							GuiMgr.getInstance().GuiStore.UpdateStore(type, obj["typeid"], 1);
						}
					}
				}
				GiftSave.push(gift.Id);
			}
			else
			{
				var sendRemove: SendRemoveMessage = new SendRemoveMessage(1, gift.Id);
				Exchange.GetInstance().Send(sendRemove);
				garr.splice(idx, 1);
				RefreshComponent();
			}
		}

		public override function OnButtonClick(event: MouseEvent, buttonID: String): void
		{
			curClickBtnID = buttonID;
			switch(buttonID)
			{
				case GUI_RECEIVELETTER_BTN_CLOSE:
					Hide();
				break;
				
				case GUI_GIFT_BTN_SEND:
					if (GameLogic.getInstance().user.GetMyInfo().NumReceiver == 0)
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message9"));
					}
					else
					{
						//Hide();
						GuiMgr.getInstance().GuiGift.showGuiGift();
					}
				break;
				
				default:
					var para:Array = buttonID.split("_");
					if (para[0] == GUI_GIFT_BTN_RESPONSE)
					{
						if (allowSendAgain(rcv)) //Nếu đủ điều kiện gửi thì hiện gui chọn quà lên để chọn quà
						{
							var rcv:int = parseInt(para[1]);
							var giftId:int = para[2];
							GuiMgr.getInstance().GuiGift.showGuiGift(rcv, giftId);						
						}
						else //Nếu ko đủ điều kiện thì xóa nút tặng lại đi
						{
							removeBtnSendAgain();
						}
					}
					else
					{
						TakeGift(buttonID);
					}
				break;
			}
		}
		
		//Gửi lên server yêu cầu trả về quà tặng nhận được
		public override function EndingRoomOut(): void
		{
			
		}
		
		//Load quà tặng
		public function RefreshComponent(): void
		{
			trace("RefreshComponent");
			if  (img.contains(WaitData))
				img.removeChild(WaitData);
			
			var i: int;
			var button: Button;
			
			for (i = 0; i < ButtonArr.length; i++ )
			{
				button = ButtonArr[i] as Button;
				if (button.ButtonID == GUI_GIFT_BTN_SEND)
				{
					button.SetEnable();
					break;
				}
			}
			if (GameLogic.getInstance().user.GiftArr.length == 0)
			{
				var tf: TextField = AddLabel("", 318, 238, 0x604220);
				var textformat: TextFormat = new TextFormat("", 20, 0x604220);
				tf.text = Localization.getInstance().getString("GUILabel6");
				tf.setTextFormat(textformat);
			}
			else
			{
				InitScroll();
				AddAllGift();
			}
		}

		/**
		 * Khởi tạo Scroll Bar
		 */
		public function InitScroll(): void
		{
			var bg: Sprite = new Sprite();
			bg.graphics.beginFill(0xffffff, 0);
			bg.graphics.drawRect(0, 0, 400, 300);
			bg.graphics.endFill();
			Scroll.setStyle("upSkin", bg);
			
			var up:Sprite = ResMgr.getInstance().GetRes("GuiReceiveGift_ImgUpArrowNone") as Sprite;
			var over: Sprite = ResMgr.getInstance().GetRes("GuiReceiveGift_ImgUpArrowOver") as Sprite;
			Scroll.setStyle("upArrowUpSkin", up);
			Scroll.setStyle("upArrowDownSkin", up);
			Scroll.setStyle("upArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiReceiveGift_ImgDownArrowNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiReceiveGift_ImgDownArrowOver") as Sprite;
			Scroll.setStyle("downArrowUpSkin", up);
			Scroll.setStyle("downArrowDownSkin", up);
			Scroll.setStyle("downArrowOverSkin", over);
			
			up = ResMgr.getInstance().GetRes("GuiReceiveGift_ImgTrackBarNone") as Sprite;
			over = ResMgr.getInstance().GetRes("GuiReceiveGift_ImgTrackBarOver") as Sprite;
			Scroll.setStyle("thumbUpSkin", up);
			Scroll.setStyle("thumbDownSkin", up);
			Scroll.setStyle("thumbOverSkin", over);
			Scroll.setStyle("thumbIcon", "");

			up = ResMgr.getInstance().GetRes("GuiReceiveGift_BtnKhungKeo") as Sprite;
			Scroll.setStyle("trackUpSkin", up);
			Scroll.setStyle("trackDownSkin", up);
			Scroll.setStyle("trackOverSkin", up);
			
			Scroll.setSize(664, 405);
			Scroll.verticalScrollBar.setScrollPosition(0);
			
			img.addChild(Scroll);
			Scroll.x = 34;
			Scroll.y = 78;
		}
		
		public function AddAllGift(): void
		{
			var i: int;
			
			var garr: Array = GameLogic.getInstance().user.GiftArr;
			var farr: Array = GameLogic.getInstance().user.FriendArr;
			
			for (i = 0; i < GiftContainerArr.length; i++ )
			{
				Content.removeChild(GiftContainerArr[i].img);
			}
			GiftContainerArr.splice(0, GiftContainerArr.length);
			
			var GiftList: Object = ConfigJSON.getInstance().GetItemList("Gift");
			var giftId: int;
			var y:int = 0;
			for (i = 0; i < garr.length; i++ )
			{
				giftId = garr[i].GiftId;
				for (var j: int = 0; j < farr.length; j++)
					if (farr[j].ID == garr[i].FromId)
					{
						//TODO: hardcode xoa bong event euro tat sau khi het event
						if (EventMgr.CheckEvent(GUITopInfo.NAME_CURRENT_IN_EVENT) != EventMgr.CURRENT_IN_EVENT && garr[i].GiftId == 17)
						{
							break;
						}
						var obj: Object = ConfigJSON.getInstance().getGiftInfo(garr[i].GiftId);
						
						//Nhận được tôm thần hay cua thần
						//if (obj["type"] == "ItemCollection" && (obj["typeid"] == 9 || obj["typeid"] == 10))
						//{
							//obj["typeid"] == 16;
						//}
						
						var obj1: Object = ConfigJSON.getInstance().getItemInfo(obj["type"], obj["typeid"]);
						var image: String = GuiMgr.getInstance().GuiGift.getImageGift(GiftList[giftId]["ItemType"], giftId.toString());
						var name: String = obj1[ConfigJSON.KEY_NAME];
						if (obj["type"] == "Gem")
						{
							var cfg:Object = ConfigJSON.getInstance().getItemInfo("Gift", giftId);
							name = Localization.getInstance().getString("Gem" + cfg["Element"]);
							name = name.replace("@Type@", Localization.getInstance().getString("GemType" + cfg["Element"]));
							name = name.replace("@Rank@", "cấp " + obj["typeid"]);
							name = name.split('\n')[0];
						}
						//var image_name:String;
						//if (obj["type"] == "IceCreamItem")
						//{
							//image = "EventIceCream_Item" + obj.typeid;
						//}
						//if (obj["type"] == "ColPItem")
						//{
							//image = "EventTeacher_NoelItem5";
						//}
						if (obj["type"] == "HalItem")
						{
							name = "Đá mật mã quý hiếm";
						}
						if (obj["type"] == "Island_Item")
						{
							name = "Chìa khóa";
						}
						if (obj["type"] == "Ticket")
						{
							name = "Vỏ Sò May Mắn";
						}
						AddGift(garr[i].GiftId, farr[j].NickName, farr[j].ID, farr[j].imgName, image, name, garr[i].FromTime, i, y);
						y += 104;
					}
			}
			Scroll.source = Content;
		}
		
		/**
		 * Thêm một quà tặng vào
		 * @param	giftID
		 * @param	sender
		 * @param	avatar
		 * @param	giftimg
		 * @param	giftname
		 * @param	timeSend
		 * @param	index
		 */
		public function AddGift(giftID: String, sender: String, senderID:String, avatar: String, giftimg: String, giftname: String, timeSend: int, index: int, posY:int): void
		{
			var firstX: int;
			var firstY: int, increY: int;
			firstX = 10;
			firstY = 0;
			increY = 110;
			
			//Calculate time:
			var curTime: int = GameLogic.getInstance().CurServerTime;
			var longTime: int = curTime - timeSend;
			var timeleft: int = 7 - (longTime / (24 * 3600));
			var date:Date = new Date(timeSend * 1000);
			
			var tf: TextField;
			var image: Image;
			var button: Button;
			
			//var container: Container = new Container(Content, "ImgGiftBackground", firstX, firstY + increY * index);
			var container: Container = new Container(Content, "GuiReceiveGift_ImgGiftBackground", firstX, firstY + posY);

			container.AddImage("Avatar_bg", "GuiReceiveGift_ImgFrameAvatar", 50, 37);
			image = container.AddImage("ImgAvatar", avatar, 20, 7, false, ALIGN_LEFT_TOP);
			image.SetSize(60, 60);
			
			var name: String = sender;
			if (name.length > 15)
			{
				name = name.substring(0, 15);
				name += "...";
			}
			var st: String = name + " vừa gửi tặng bạn " + giftname;// + "\n" + date.getFullYear() + "- " + date.getMonth() + "- " + date.getDay();
			tf = container.AddLabel(st, 95, 7, 0x000000, 0);
			
			var textformat: TextFormat = new TextFormat("", 14);
			//textformat.align = TextFormatAlign.CENTER;
			tf.setTextFormat(textformat);
			
			textformat.bold = true;
			textformat.color = "0x3ACD15";
			tf.setTextFormat(textformat, 0, name.length);
			tf.width = 210;
			tf.multiline = true;
			tf.wordWrap = true;
			
			//Format đoạn: " vừa gửi tặng bạn "
			textformat.color = "0x00000";
			textformat.bold = true;
			tf.setTextFormat(textformat, name.length + 1, name.length + 17); 
			
			//Format tên quà
			textformat.color = "0xFF9918";
			textformat.bold = true;
			tf.setTextFormat(textformat, name.length + 17, name.length + 17 + giftname.length + 1);
			
			//tf = container.AddLabel(date.getFullYear() + "-" + date.getMonth() + "-" + date.getDay(), 72, 50);
			
			image = container.AddImage(index.toString(), giftimg, 370, 60);
			var point:Point = new Point(315, 10);
			image.FitRect(50, 50, point);
			//nếu là thức ăn thì hard code số lượng = 4 vào
			if (giftimg == "ImgFoodBox") container.AddLabel("4", image.img.x - 25, image.img.y + 10, 0xffffff, 1, 0x0066ff);
			
			//Kiểm tra quà đã nhận hay chưa để hiện thị cho phù hợp
			var i: int;
			var ok: Boolean = false;
			var garr: Array = GameLogic.getInstance().user.GiftArr;
			for (i = 0; i < GiftSave.length; i++ )
				if (garr[index].Id == GiftSave[i])
				{
					ok = true;
					break;
				}
			if (ok) UpdateContainer(container, senderID, garr[index].GiftId);
			else
			{
				textformat.bold = true;
				textformat.color = "0x000000";
				tf = container.AddLabel("Còn " + timeleft + " ngày", 292, 72);
				tf.setTextFormat(textformat);
				textformat.color = "0xFF9918";
				tf.setTextFormat(textformat, 4, 5);
				
				button = container.AddButton("Take_" + index.toString() + "_" + senderID, "GuiReceiveGift_BtnNhanQua", 400, 20, this);
				button = container.AddButton("Destroy_" + index.toString(), "GuiReceiveGift_BtnTuChoi", 515, 20, this);
			}
			
			container.IdObject = index.toString();
			GiftContainerArr.push(container);
		}
		
		public function allowSendAgain(receiverID:int):Boolean
		{
			if (GameLogic.getInstance().user.GetMyInfo().NumReceiver < 1)
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message23"));
				return false;
			}
			
			var rarr: Array = GameLogic.getInstance().user.GetMyInfo().ReceiverGiftList;
			for (var i:int = 0; i < rarr.length; i++ )
			{
				if (receiverID == rarr[i])
				{
					GuiMgr.getInstance().GuiMessageBox.ShowOK(Localization.getInstance().getString("Message24"));
					return false;
				}
			}
			
			return true;
		}
		
		public function allowAgain(receiverID:int):Boolean
		{
			if (GameLogic.getInstance().user.GetMyInfo().NumReceiver < 1)
			{
				return false;
			}
			
			var rarr: Array = GameLogic.getInstance().user.GetMyInfo().ReceiverGiftList;
			for (var i:int = 0; i < rarr.length; i++ )
			{
				if (receiverID == rarr[i])
				{
					return false;
				}
			}
			
			return true;
		}
	}

}