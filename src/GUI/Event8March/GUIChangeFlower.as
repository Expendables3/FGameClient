package GUI.Event8March 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import GUI.FishWorld.Network.SendLoadOcean;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.User;
	import NetworkPacket.PacketSend.SendBuyFlower;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import NetworkPacket.PacketSend.SendOpenFlowerBox;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIChangeFlower extends BaseGUI 
	{
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const ID_BTN_GUIDE:String = "idBtnGuide";
		private const ID_BTN_CHANGE:String = "idBtnChange";
		private const ID_BTN_BUY:String = "idBtnBuy";
		private const ID_GIFT:String = "idGift";
		private const ID_BTN_REMIND:String = "idBtnRemind";
		
		private const cfgFlowerName:String = "Event_8_3_Flower";
		private const cfgChangeName:String = "GiftBox";
		private const FIRST_X:int = 80;
		private const FIRST_Y:int = 100;
		private const DELTA_X:int = 10;
		private const DELTA_Y:int = 150;
		
		private const STRCHANGE:String = "Bạn đã đổi @num  lần ";
		public static const idHoaChamChiXanh:int = 1;
		public static const idHoaChamChiVang:int = 2;
		public static const idHoaChamChiDo:int = 3;
		public static const idHoaBangHuu:int = 11;
		public static const idHoaChienCong:int = 10;
		public static const idHoaThamHiem:int = 13;
		public static const idHoaKienTri:int = 12;
		
		//private var tfChangeRedGift:TextField;
		private var numChangeRedGift:int = 0;
		private var oId:Object;
		private var oFlower:Object;
		private var _formatRed:TextFormat;
		private var _formatGreen:TextFormat;
		private var oMaxFlower:Object;
		private var arrNumTf:Array;
		private var cfg:Object;	//thông tin toàn bộ hoa và quà của gui này
		public var guiTipArr:Array = new Array();
		public var guiGuide:GUIFlowerGuide = new GUIFlowerGuide(null, "");
		private var guiCongrate:GUIEventCongrate = new GUIEventCongrate(null, "");
		
		public function GUIChangeFlower(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIChangeFlower";
		}
		
		override public function InitGUI():void 
		{
			GuiMgr.getInstance().GuiStore.Hide();
			_formatRed = new TextFormat();
			_formatRed.size = 14;
			_formatRed.color = 0xff0000;
			_formatGreen = new TextFormat();
			_formatGreen.size = 14;
			_formatGreen.color = 0x00ff00;
			cfg = ConfigJSON.getInstance().getItemInfo(cfgChangeName);
			setoId();
			setoFlower();
			setoMaxFlower();
			LoadRes("GUIChangeFlower");
			/*vẽ ra các bông hoa theo config*/
			drawGUI();
			AddButton(ID_BTN_CLOSE, "BtnThoat", 705, 20);
			AddButton(ID_BTN_GUIDE, "Event_BtnGuide", 662, 20);
			var name:String = "\"Hộp Quà Đỏ\"";//Localization.getInstance().getString("Event_8_3_Gift3");
			var strChange:String = STRCHANGE + name;
			if (GameLogic.getInstance().user.GetMyInfo().coralTree)
			{
				if (numChangeRedGift == 0)
				{
					numChangeRedGift = GameLogic.getInstance().user.GetMyInfo().coralTree.OpenBoxNum;//lấy khi init run
				}
			}
			else
			{
				numChangeRedGift = 0;
			}
			strChange = strChange.replace("@num", numChangeRedGift);
			//tfChangeRedGift = AddLabel(strChange, 530, img.height - 60 , 0xFF0000, 1, 0xFFFFFF);
			//var tfURL:TextField = AddLabel("", 550, img.height - 45, 0x0000ff, 1, 0xffffff);
			//tfChangeRedGift.scaleX = tfChangeRedGift.scaleY = tfURL.scaleX = tfURL.scaleY =  1.1;
			//tfURL.htmlText = "<a href = \"http://me.zing.vn/apps/blog?params=fish_gsn/blog/detail/id/747543446?from=feed\" target = \"_blank\"><u>Xem chi tiết</u></a>";
			//tfURL.mouseEnabled = true;
			
			SetPos(40, 20);
		}
		private function drawGUI():void
		{
			ClearComponent();
			var len:int = guiTipArr.length;
			for (var k:int = 0; k < len; k++)
			{
				(guiTipArr[k] as TooltipFlower).Destructor();
			}
			guiTipArr.splice(0, len);
			arrNumTf = new Array();
			var strTip:String;
			var btnEx:ButtonEx;
			var x:int = FIRST_X, y:int = FIRST_Y;
			var idFlower:int;
			var tooltip:TooltipFormat;
			var btnBuy:Button;
			var zmoney:int;
			var unlockType:int;
			var str:String;
			var tf:TextField;
			var bg:Image;
			var guiTip:TooltipFlower;
			for (var i:int = 1; i <= 3; i++)
			{//vẽ ra một hàng
				guiTip = new TooltipFlower(null, "");
				x = FIRST_X;
				for (var j:int = 1; j <= 5; j++)
				{//vẽ ra 1 hoa
					AddImage("", "Event83_ImgSlot", x + 25, y + 55);
					tooltip = new TooltipFormat();
					idFlower = cfg[i]["Input"][j]["ItemId"];
					btnEx = AddButtonEx("", cfgFlowerName + idFlower, x, y);			//vẽ ảnh hoa
					btnEx.SetAlign(ALIGN_LEFT_TOP);
					strTip = Localization.getInstance().getString(cfgFlowerName + "_Name" + idFlower) + "\n" + 
							Localization.getInstance().getString(cfgFlowerName + "_Collection" + idFlower);
					tooltip.text = strTip;
					btnEx.setTooltip(tooltip);							//setTooltip cho ảnh
					//thêm vào bảng và lable số lượng
					
					bg = AddImage("", "Num_Bg", x + 40, y + 78);
					bg.SetScaleXY(0.6);
					str = oFlower[idFlower] + "/" + oMaxFlower[i][idFlower];
					tf = AddLabel(str, x - 25, y + 63);
					if (oFlower[idFlower] >= oMaxFlower[i][idFlower])
					{
						tf.setTextFormat(_formatGreen);
					}
					else
					{
						tf.setTextFormat(_formatRed);
					}
					arrNumTf.push(tf);
					//nút mua và nhờ bạn
					zmoney = ConfigJSON.getInstance().getItemInfo(cfgFlowerName, idFlower)["ZMoney"];
					if (idFlower != 11)//11 là id của hoa bằng hữu
					{
						
						unlockType = ConfigJSON.getInstance().getItemInfo(cfgFlowerName, idFlower)["UnlockType"];
						btnBuy = AddButton("idBtnBuy_" + idFlower + "_" + zmoney, "Event83_BtnBuy", x - 10, y + 90);
						if (unlockType == 6)
						{
							btnBuy.SetVisible(false);
						}
						else
							AddLabel(zmoney.toString(), x - 15, y + 90, 0xFFFFFF, 1, 0x000000);
					}
					else
					{
						addRemindFriend(x - 10, y + 90, zmoney, idFlower);
						//AddButton(ID_BTN_REMIND, "Event83_NhoBan", x - 10, y + 90);
					}
					x += 80 + DELTA_X;
				}
				//vẽ nút đổi
				AddButton(ID_BTN_CHANGE + "_" + i, "Event83_BtnDoi", 595, y + 90);
				x += DELTA_X;
				//vẽ hộp quà
				AddButtonEx("idGift" + "_" + i, "Img_8_3_Gift" + i, 595, y + 10, this);
				y += DELTA_Y;
				guiTip.init(cfg[i]["Output"], i);
				guiTipArr.push(guiTip);
			}
			setBtnChange();
		}
		public function init():void
		{
			this.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var id:int = (int)(data[1]);
			switch(command)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case ID_BTN_GUIDE:
					guiGuide.Show(Constant.GUI_MIN_LAYER, 6);
				break;
				case ID_BTN_REMIND:
					remindFriend();
				break;
				case ID_BTN_CHANGE:
					changeGift(id);
				break;
				case ID_BTN_BUY:
					buyFlower(id,(int)(data[2]));
			}
		}
		
		private function changeGift(id:int):void
		{
			//send dữ liệu lên server
			var pk:SendOpenFlowerBox = new SendOpenFlowerBox(id);
			Exchange.GetInstance().Send(pk);
			//trừ số lượng hoa của user ứng với mức đổi tương ứng
			for (var i:String in oId)
			{
				if (oMaxFlower[id][i])
				{
					GameLogic.getInstance().user.UpdateStockThing("Event_8_3_Flower", (int)(i), -oMaxFlower[id][i]);
					oFlower[i] -= oMaxFlower[id][i];
				}
			}
			//vẽ lại nút đổi, và số lượng hoa của user ở bên trái dấu /
			drawNumFlower();
			setBtnChange();
			//if (id == 3)
			//{
				//numChangeRedGift++;
				//var str:String = STRCHANGE + "\"Hộp Quà Đỏ\"";// Localization.getInstance().getString("Event_8_3_Gift3");
				//tfChangeRedGift.text  = str.replace("@num", numChangeRedGift);
			//}
		}
		public function receiveGift(data:Object):void
		{
			var imName:String;
			//trace ("feed lên tường -------------- id = " );
			if (data["Equipment"] is Array && data["Gift"] is Object)
			{//nhận quà thường
				
				imName = data["Gift"]["ItemType"] + data["Gift"]["ItemId"];
				if (data["Gift"]["Element"])
				{
					imName = data["Gift"]["ItemType"] + "_" + data["Gift"]["Element"] + "_" + data["Gift"]["ItemId"];
				}
				if (data["Gift"]["ItemType"] == "Gem")
				{
					var type:String = "Gem$" + data["Gift"]["Element"];
					var pk:SendLoadInventory = new SendLoadInventory();
					Exchange.GetInstance().Send(pk);
					//GuiMgr.getInstance().GuiStore.UpdateStore(type, data["Gift"]["ItemId"], data["Gift"]["Num"]);
					//GameLogic.getInstance().user.UpdateStockThing(type, data["Gift"]["ItemId"], data["Gift"]["Num"]);
				}
			}
			else if (data["Gift"] is Array && data["Equipment"] is Object)
			{//nhận quà khủng
				guiCongrate.showGui(data["Equipment"]);
				//imName = data["Equipment"]["Type"] + data["Equipment"]["Rank"] + "_Shop";
				GameLogic.getInstance().user.GenerateNextID();
				return;
			}
			EffectMgr.setEffBounceDown("Nhận thành công", imName, 330, 280,null,data["Gift"]["Num"]);
			//trace("nhận dữ liệu từ server trả về");
		}
		private function buyFlower(id:int, zmoney:int):void
		{
			var _user:User = GameLogic.getInstance().user;
			var myMoney:int = _user.GetMyInfo().ZMoney;
			
			if (myMoney >= zmoney)
			{
				var objTemp:Object = new Object();
				objTemp["ItemType"] = "Event_8_3_Flower";
				objTemp["Event"] = "Event_8_3_Flower";
				objTemp["ItemId"] = id;
				objTemp["Num"] = 1;

				var pk:SendBuyFlower = new SendBuyFlower(objTemp);
				Exchange.GetInstance().Send(pk);
				_user.UpdateUserZMoney(0 - zmoney);
				_user.UpdateStockThing("Event_8_3_Flower", id, 1);
				//effect mua thành công
				EffectMgr.setEffBounceDown("Mua thành công", cfgFlowerName + id, 330, 280);
				oFlower[id]++;
				drawNumFlower();
				setBtnChange();
			}
			else
			{
				GuiMgr.getInstance().GuiNapG.Init();
			}
		}
		
		private function drawNumFlower():void
		{
			for (var i:int = 0; i < arrNumTf.length; i++)
			{
				(arrNumTf[i] as TextField).text = oFlower[(int)(i % 5 + 10).toString()]
													+ "/"
													+ oMaxFlower[(int)(i / 5 + 1).toString()][(int)(i % 5 + 10).toString()];
				if (oFlower[(int)(i % 5 + 10).toString()] >= oMaxFlower[(int)(i / 5 + 1).toString()][(int)(i % 5 + 10).toString()])
				{
					(arrNumTf[i] as TextField).setTextFormat(_formatGreen);
				}
				else
				{
					(arrNumTf[i] as TextField).setTextFormat(_formatRed);
				}
			}
			var k:int = 4;
			for (var j:int = 1; j <= 3; j++)
			{
				(arrNumTf[k] as TextField).text = oFlower[j] + "/" + oMaxFlower[j][j];
				if (oFlower[j] >= oMaxFlower[j][j])
				{
					(arrNumTf[k] as TextField).setTextFormat(_formatGreen);
				}
				else
				{
					(arrNumTf[k] as TextField).setTextFormat(_formatRed);
				}
				k += 5;
			}
		}
		private function remindFriend():void
		{
			var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var today:String = date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString();
			var so:SharedObject = SharedObject.getLocal("PressRemind" + GameLogic.getInstance().user.GetMyInfo().Id);
			var data:Object;
			if (so.data.uId != null)//đã feed nhờ bạn ít nhất 1 lần => chắc chắn có lastday
			{
				data = so.data.uId;
				if (data.lastDay != today)//chưa bấm feed hôm nay
				{
					trace("hiện guifeed ---- chưa feed hôm nay");
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_REMIND_FRIEND);
				}
			}
			else//chưa feed nhờ bạn lần nào trong đời
			{
				trace("hiện guifeed ---- chưa feed lần nào trong đời");
				GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_REMIND_FRIEND);
				
			}
		}
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var id:int = (int)(data[1]);
			switch(command)
			{
				case ID_GIFT:
					(guiTipArr[id - 1] as TooltipFlower).Show();
				break;
			}
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var id:int = (int)(data[1]);
			switch(command)
			{
				case ID_GIFT:
					(guiTipArr[id - 1] as TooltipFlower).Hide();
				break;
			}
		}
		private function setBtnChange():void
		{
			var i:int;
			var isEnable:Boolean;
			for (i = 1; i <= 3; i++)
			{
				isEnable = true;
				for (var j:String in oMaxFlower[i])
				{
					isEnable = isEnable && (oFlower[j] >= oMaxFlower[i][j]);
				}
				GetButton(ID_BTN_CHANGE + "_" + i).SetEnable(isEnable);
			}
		}
		
		private function setoId():void
		{
			oId = new Object();
			for (var i:int = 1; i <= 3; i++)
			{
				oId[i.toString()] = i;
			}
			oId[idHoaBangHuu.toString()] = idHoaBangHuu;
			oId[idHoaChienCong.toString()] = idHoaChienCong;
			oId[idHoaKienTri.toString()] = idHoaKienTri;
			oId[idHoaThamHiem.toString()] = idHoaThamHiem;
		}
		private function setoMaxFlower():void
		{
			oMaxFlower = new Object();
			for (var i:int = 1; i <= 3; i++)
			{
				oMaxFlower[i] = new Object();
				for (var j:int = 1; j <= 4; j++)
				{
					oMaxFlower[i][j + 9] = cfg[i]["Input"][j]["Num"];
				}
				oMaxFlower[i][i]=cfg[i]["Input"][5]["Num"];
			}
		}
		private function setoFlower():void
		{
			oFlower = new Object();
			for (var i:String in oId)
			{
				oFlower[i] = GameLogic.getInstance().user.GetStoreItemCount(cfgFlowerName, (int)(i));
			}
		}
		
		private function addRemindFriend(x:int,y:int,zmoney:int,idFlower:int):void
		{
			//chỉ get value từ shareObject ra chứ ko ghi vào shareObject
			var btnRemind:Button;
			var btnBuy:Button;
			var date:Date = new Date(GameLogic.getInstance().CurServerTime * 1000);
			var today:String = date.getDate().toString() + date.getMonth().toString() + date.getFullYear().toString();
			var so:SharedObject = SharedObject.getLocal("PressRemind" + GameLogic.getInstance().user.GetMyInfo().Id);
			var data:Object;
			if (so.data.uId != null)//đã feed nhờ bạn ít nhất 1 lần
			{
				data = so.data.uId;
				if (data.lastday != today)//chưa feed nhờ bạn hôm nay
				{
					trace("thêm nút nhờ bạn ---- chưa feed hôm nay");
					btnRemind = AddButton(ID_BTN_REMIND, "Event83_NhoBan", x, y);
					
				}
				else//đã feed nhờ bạn hôm nay
				{
					trace("thêm nút mua ---- đã feed hôm nay");
					btnBuy = AddButton("idBtnBuy_" + idFlower + "_" + zmoney, "Event83_BtnBuy", x, y);
					AddLabel(zmoney.toString(), x - 5, y, 0xFFFFFF, 1, 0x000000);
				}
			}
			else//chưa feed nhờ bạn lần nào trong đời
			{
				btnRemind = AddButton(ID_BTN_REMIND, "Event83_NhoBan", x, y);
				trace("thêm nút nhờ bạn ---- chưa feed lần nào trong đời");
			}
		}
		public function changeRemindToBuy():void
		{
			var i:int;
			for (i = 0; i < ButtonArr.length; i++)
			{
				if ((ButtonArr[i] as Button).ButtonID == ID_BTN_REMIND)
				{
					(ButtonArr[i] as Button).SetVisible(false);
				}
			}
			var zmoney:int = ConfigJSON.getInstance().getItemInfo(cfgFlowerName, 11)["ZMoney"];
			var x:int = 160, y:int = 190;
			for (i = 0; i < 3; i++)
			{
				AddButton("idBtnBuy_" + "11" + "_" + zmoney, "Event83_BtnBuy", x, y);
				AddLabel(zmoney.toString(), x - 5, y, 0xFFFFFF, 1, 0x000000);
				y += 150;
			}
		}
	}
}