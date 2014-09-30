package GUI 
{
	import com.adobe.utils.IntUtil;
	import com.bit101.components.Text;
	import Event.EventMgr;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import GameControl.HelperMgr;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import Logic.BaseObject;
	import flash.events.MouseEvent;
	import Logic.*;
	import Data.*;
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.TextFormatAlign;
	import NetworkPacket.PacketReceive.GetLoadInventory;
	import NetworkPacket.PacketSend.SendGift;

	/**
	 * ...
	 * @author thint
	 * Gui chọn quà để tặng cho bạn bè
	 */
	public class GUIGift extends BaseGUI
	{		
		private const ID_ITEM_FRIEND_GIFT_FOR_CURRENT_EVENT:String = "17";
		
		private const GUI_GIFT_BUTTON_CHECK:String = "ButtonEnd";
		private const GUI_GIFT_BUTTON_CANCEL:String = "ButtonCancel";
		private const GUI_GIFT_BUTTON_SEND:String = "ButtonSend";
		private const GUI_GIFT_BUTTON_CHECKBOX:String = "ButtonCheckbox";
		private const GUI_GIFT_BUTTON_NEXT:String = "ButtonNext";
		private const GUI_GIFT_BUTTON_BACK:String = "ButtonBack";
		private const GUI_GIFT_BUTTON_CLOSE:String = "BtnThoat";		
		private const GUI_GIFT_CHECKBOX: String = "Buttoncheck";
		
		public var currentGiftID: String = "1";
		public var CheckedBox: Image;
		public var receiverID:int;
		public var giftId:int;
		
		public function GUIGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIGift";
		}
		
		public override function InitGUI(): void
		{
			this.setImgInfo = function():void
			{
				SetPos(37, 30);
				var ListGift:Object = filterGift(ConfigJSON.getInstance().GetItemList("Gift"));
				var btnClose: Button = AddButton(GUI_GIFT_BUTTON_CLOSE, "BtnThoat", 707, 18, this);
				AddButton(GUI_GIFT_BUTTON_SEND, "GuiSelectGift_BtnTangBanBe", 226, 520, this);
				AddButton(GUI_GIFT_BUTTON_CANCEL, "GuiSelectGift_BtnBoQua", 405, 520, this);

				currentGiftID = ConfigJSON.getInstance().getItemList("Gift")[0][ConfigJSON.KEY_ID];
				
				AddAllGift();
				CheckedBox = AddImage("", "GuiSelectGift_ImgCheckBox", ContainerArr[0].GetPosition().x + 58, ContainerArr[0].GetPosition().y + 108);
				if (EventMgr.CheckEvent(EventMgr.NAME_EVENT) == EventMgr.CURRENT_IN_EVENT && ListGift[ID_ITEM_FRIEND_GIFT_FOR_CURRENT_EVENT]!=null
					&& ListGift[ID_ITEM_FRIEND_GIFT_FOR_CURRENT_EVENT.toString()].LevelRequire <= GameLogic.getInstance().user.GetLevel())
				{
					var container:Container = ContainerArr[ContainerArr.length - 1] as Container;
					CheckedBox.SetPos(container.GetPosition().x + 58 , container.GetPosition().y + 108);
					currentGiftID = ID_ITEM_FRIEND_GIFT_FOR_CURRENT_EVENT;//hard code trong thời gian event
				}
				ChoseGift2();
				
				OpenRoomOut();
			}
			
			LoadRes("GuiSelectGift_Theme");
		}
		
		public function showGuiGift(ReceiverID:int = -1, GiftID:int = -1):void
		{
			super.Show(Constant.GUI_MIN_LAYER, 5);
			receiverID = ReceiverID;
			giftId = GiftID;
		}
		
		/**
		 * Add tất cả quà tặng
		 */
		public function AddAllGift(): void
		{
			var nRow: int = 6;
			var nCol: int = 3;
			var i: int = 0;
			
			var GiftList: Object = filterGift(ConfigJSON.getInstance().GetItemList("Gift"));
			for (var s: String in GiftList)
			{
				var obj: Object = GiftList[s];
				var imgName: String;
				var name: String;
				
				imgName = getImageGift(obj["ItemType"], s);
				name = getImageName(obj["ItemType"], obj["ItemId"], obj["Element"]);
				if (name == null)
				{
					name = "No name";
				}
				var jj: int = i / nRow;
				var ii: int = i - (jj * nRow);
				//trace("gift", imgName);
				AddGift(i, obj[ConfigJSON.KEY_ID], imgName, name, obj["ItemType"], obj["LevelRequire"], ii, jj);
				i++;
			}
			//var GiftList:Array = INI.getInstance().getItemList("Gift");
			//
			//for (i = 0; i < GiftList.length; i++ )
			//{
				//var obj: Object = INI.getInstance().getGiftInfo(GiftList[i][ConfigJSON.KEY_ID]);
				//var obj1: Object = INI.getInstance().getItemInfo(obj["typeid"], obj["type"]);
				//var imgName: String = GuiMgr.getInstance().GuiGift.getImage(obj[ConfigJSON.KEY_ID]);
				//
				//var jj: int = i / nRow;
				//var ii: int = i - (jj * nRow);
				//
				//AddGift(i, obj[ConfigJSON.KEY_ID], imgName, obj1[ConfigJSON.KEY_NAME], obj["type"], obj["levelrequire"], ii, jj);
			//}
		}
		
		/**
		 * Add quà tặng vào gui
		**/
		public function AddGift(num: int, giftID: String, giftImage: String, giftName: String, type: String, levelRequire: int, indexI: int, indexJ: int): void
		{
			if (giftID == "18")
			{
				trace(giftID);
			}
			var firstX: int, firstY: int;
			var increX: int, increY: int;
			firstX = 43;
			firstY = 80;
			increX = 110;
			increY = 145;
			
			var container: Container = AddContainer(giftID + "_" + num, "GuiSelectGift_ImgBackgroundGift", indexI * increX + firstX, indexJ * increY + firstY, true, this);
			
			var tf:TextField = container.AddLabel(giftName, 0, 5);
			tf.wordWrap = true;
			var tfm:TextFormat = new TextFormat("Arial", 12);
			tfm.align = TextFormatAlign.CENTER;
			tf.setTextFormat(tfm);
			

			var imageGift: Image = container.AddImage(giftID, giftImage, 0, 0);
			var point: Point = new Point(14, 35);
			imageGift.FitRect(70, 50, point);
			if (giftName == "Bóng Biển")
			{
				trace(giftID + "_" + num);
				HelperMgr.getInstance().SetHelperData("SeaBall", imageGift.img);
			}
			
			//nếu là thức ăn thì hard code số lượng = 4 vào
			if (giftImage == "ImgFoodBox") container.AddLabel("4", imageGift.img.x - 25, imageGift.img.y + 10, 0xffffff, 1, 0x0066ff);
			
			if (levelRequire > GameLogic.getInstance().user.GetLevel())
			{
				var lockImg: Image = container.AddImage("ImgShopItemLock", "GuiSelectGift_ImgShopItemLock", 22, 98);
				lockImg.SetScaleX(0.7); lockImg.SetScaleY(0.7);
				container.AddLabel("Cấp" + levelRequire, 0, 110);
			}
			else
			{
				container.AddButton(giftID + "_" + num, "GuiSelectGift_BtnCheckBox", 50, 100, this);
			}
		}
		
		/**
		 * Chọn quà khi click vào radiobox
		 * @param	buttonID
		 */
		public function ChoseGift(buttonID: String): void
		{
			var s: Array = buttonID.split("_", 2);			
			var gift:Object = ConfigJSON.getInstance().getItemInfo("Gift", parseInt(s[0]));
			if (gift["LevelRequire"] > GameLogic.getInstance().user.GetLevel()) return;
			currentGiftID = s[0];
			var index: String = s[1];
			var container:Container = ContainerArr[index] as Container;
			CheckedBox.SetPos(container.GetPosition().x + 58 , container.GetPosition().y + 108);
		}
		
		
		/**
		 * Chọn quà theo id của quà
		 */
		//public function ChoseGift2(giftId:int): Boolean
		public function ChoseGift2(): Boolean
		{
			if (giftId == -1)
			{
				return false;
			}
			var gift:Object = ConfigJSON.getInstance().getItemInfo("Gift", giftId);
			if (gift["LevelRequire"] > GameLogic.getInstance().user.GetLevel()) return false;
			
			var gId:String = giftId.toString();
			for (var i:int = 0; i < ContainerArr.length; i++) 
			{
				var con:Container = ContainerArr[i];
				if (con.IdObject.split("_")[0] == gId)
				{
					CheckedBox.SetPos(con.GetPosition().x + 58 , con.GetPosition().y + 108);
					currentGiftID = gId;
					return true;
				}				
			}			
			return false;
		}
		
		public override function OnButtonClick(event: MouseEvent, buttonID: String): void
		{
			switch(buttonID)
			{
				case GUI_GIFT_BUTTON_CLOSE:
					Hide();
				break;
				
				case GUI_GIFT_BUTTON_CANCEL:
					Hide();
				break;
				
				case GUI_GIFT_BUTTON_SEND:
					Hide();
					if (receiverID < 0)
					{
						GuiMgr.getInstance().GuiGiftSend.Show(Constant.GUI_MIN_LAYER, 5);
					}
					else
					{
						//Gói tin nhận quà
						var sendGift: SendGift = new SendGift(parseInt(currentGiftID));
						
						//Add người nhận quà vào gói tin gửi quà 
						sendGift.AddReceive(receiverID);
						
						//Update lại danh sách những người đã nhận quà
						var rarr: Array = GameLogic.getInstance().user.GetMyInfo().ReceiverGiftList;
						rarr.push(receiverID);
						
						//Tính toán lại số lượng người còn được nhận quà
						GameLogic.getInstance().user.GetMyInfo().NumReceiver -= 1;
						
						//Gửi gói tin đi
						Exchange.GetInstance().Send(sendGift);
						
						//Xóa btn tặng lại đi
						GuiMgr.getInstance().GuiReceiveGift.removeBtnSendAgain();
					}
				break;
				
				default:
					ChoseGift(buttonID);
					
					//Click vào bóng biển
					if (buttonID == "13_12")
					{
						HelperMgr.getInstance().SetHelperData("BtnSendGift2", GetButton(GUI_GIFT_BUTTON_SEND).img);
					}
				break;
			}
		}
		
		public function getImageGift(type: String, id: String): String
		{
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Gift", int(id));
			switch (obj["ItemType"])
			{
				case "HalItem":
					return "EventHalloween_" + obj["ItemType"] + obj["ItemId"];
				case "Island_Item":
					return "KeyGift";
				case "Balls":
					return "Ic_VIPBall";
				case "FishGift":
					return type + obj["ItemId"] + "_Old_Idle";
				case "Food":
					return "ImgFoodBox";
				case "Medicine":
					return "Medicine";
				case "ItemCollection":
					if (id == "9" || id == "10")
					{
						return type + "16";
					}
					else
					{
						return (type + obj["ItemId"]);
					}
				case "Gem":
					var cfg:Object = ConfigJSON.getInstance().GetItemList("Gift")[id];
					return (type + "_" + cfg.Element + "_" + cfg.ItemId);
				case "Arrow":
					return ("GUIGameEventMidle8_" + type + "4");
				case "ColPItem":
					return "EventTeacher_" + obj["ItemType"] + obj["ItemId"];
				case "Candy":
					return "EventNoel_" + obj["ItemType"] + obj["ItemId"];
				case "Ticket":
					return "EventLuckyMachine_" + obj["ItemType"] + obj["ItemId"];
				default:
					return (type + obj["ItemId"]);
			}
		}
		
		public function getImageName(type: String, id: int, element:int = 0): String
		{
			switch (type)
			{
				case "Balls":
					return "Bóng Vàng";
				case "Medicine":
					return "Thuốc tăng trưởng";
				case "Gem":
					var str:String = Localization.getInstance().getString("Gem" + element);
					str = str.split("\n")[0];
					str = str.replace("@Type@", Localization.getInstance().getString("GemType" + id));
					str = str.replace("@Rank@", "cấp " + id);
					return str;
				case "ColPItem":
					return Localization.getInstance().getString("EventTeacher_FriendShip");
				case "Candy":
					return Localization.getInstance().getString("EventNoel_FriendShip");
				case "Island_Item":
					return "Chìa khóa";
				case "Ticket":
					return "Vỏ Sò May Mắn";
				case "HalItem":
					return "Đá mật mã quý hiếm";
				default:
					return ConfigJSON.getInstance().getItemInfo(type, id)[ConfigJSON.KEY_NAME];
			}
		}
		
		/**
		 * Lấy ảnh từ id
		 * @param	Id
		 * @return
		 */
		/*public function getImage(Id: String): String
		{
			var imgName: String;
			var obj: Object = ConfigJSON.getInstance().getGiftInfo(Id);		
			var type: String = obj["type"];
			switch (type)
			{
				case "Other":
					var type1: String = obj["type"];
					var typeid1: String = obj["typeid"];
					imgName = type1 + typeid1;		
				break;		
				case "MixLake":
					imgName = obj["type"] + obj["typeid"];
				break;
				
				case "OceanTree":
					imgName = obj["type"] + obj["typeid"];					
					break;
					
				case "OceanAnimal":
					imgName = obj["type"] + obj["typeid"];			
					break;
				
				case "Fish":					
					imgName = "Fish" + obj["typeid"] + "_Old_Idle";									
					break;
					
				case "Food":				
					imgName = "ImgFoodBox";	
					break;
			}
			return imgName;
			
		}*/
		
		private function UpdateContainerHighLight(index:String):void
		{
			var i:int;
			for (i = 0; i < ContainerArr.length; i++)
			{
				var container:Container = ContainerArr[i] as Container;
				if (container.IdObject == index)
				{
					container.SetHighLight(0x00ff00, true);
				}
				else
				{
					container.SetHighLight(-1, true);
				}
			}
		}
		
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			UpdateContainerHighLight(buttonID);			
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			UpdateContainerHighLight("");			
		}
		
		private function filterGift(giftList:Object):Object
		{
			var newGiftList:Object = new Object();
			for (var s: String in giftList)
			{
				if (EventMgr.CheckEvent(EventMgr.NAME_EVENT) != EventMgr.CURRENT_IN_EVENT && int(s) >= 17)
				{
					continue;
				}
				newGiftList[s] = giftList[s];
			}
			
			return newGiftList;
		}
	}
}
