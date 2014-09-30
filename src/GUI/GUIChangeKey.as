package GUI 
{
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Elastic;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.TooltipFormat;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import NetworkPacket.PacketSend.SendBuyEvent;
	import NetworkPacket.PacketSend.SendChangeKey;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import Sound.SoundMgr;
	
	/**
	 * ...
	 * @author tuannm3
	 */
	public class GUIChangeKey extends BaseGUI
	{
		private const GUI_CHANGEKEY_EXIT:String = "BtnExit";
		private const GUI_CHANGEKEY_BTN_CHANGE_WOODKEY:String = "BtnChangeWoodKey";
		private const GUI_CHANGEKEY_BTN_CHANGE_SILVERKEY:String = "BtnChangeSilverKey";
		private const GUI_CHANGEKEY_BTN_CHANGE_GOLDKEY:String = "BtnChangeGoldKey";
		private const GUI_CHANGEKEY_BTN_REMIND_FRIEND:String = "BtnRemindFriend";
		private const CARD_PEARL:String = "CardPearl";
		private const XCTN:int = 55;
		
		public static const MYFISH:int = 1;
		public static const FISH_WOOD:int = 2;
		public static const FISH_SILVER:int = 3;
		public static const FISH_GOLD:int = 4;
		public static const POULP_WOOD:int = 5;
		public static const POULP_SILVER:int = 6;
		public static const POULP_GOLD:int = 7;
		public static const MERMAID_WOOD:int = 8;
		public static const MERMAID_SILVER:int = 9;
		public static const MERMAID_GOLD:int = 10;
		
		private const WOOD:String = "Wood";
		private const SILVER:String = "Silver";
		private const GOLD:String = "Gold";		
		private const ID_WOOD:int = 1;
		private const ID_SILVER:int = 2;
		private const ID_GOLD:int = 3;		
		
		private var IsDataReady:Boolean;
		
		private var iconData:Object;
		private var keyData:Object;
		private var txtFormat:TextFormat;
		
		public static const TIME_TO_DELAY:int = 2000;
		private var listItemBuy:Object;
		private var timer:Timer;
		
		
		[Embed(source='../../content/dataloading.swf', symbol='DataLoading')]
		private var DataLoading:Class;
		private var WaitDataStore:Sprite = new DataLoading();
		
		public function GUIChangeKey(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIChangeKey";
		}
		
		public function AddBntClose():void
		{
			AddImage("", "ImgTitleNgocTraBiAn", 215, 33);
			AddButton(GUI_CHANGEKEY_EXIT, "BtnThoat", 706, 19, this);
		}
		
		public override function InitGUI() :void
		{
			var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
			if (sound != null)
			{
				sound.play();
			}
			IsDataReady = false;	
			var cmd1:SendLoadInventory = new SendLoadInventory();
			Exchange.GetInstance().Send(cmd1);
			LoadRes("GUIChangeKey_");	
			AddBntClose();
			img.addChild(WaitDataStore);
			WaitDataStore.x = 285;
			WaitDataStore.y = 280;
			var xPos:int = (Constant.STAGE_WIDTH - this.img.width) / 2;
			var yPos:int = (Constant.STAGE_HEIGHT - this.img.height) / 2;
			SetPos(xPos, yPos);
			OpenRoomOut();
			if(!txtFormat)
			{
				txtFormat = new TextFormat();
			}
			
			timer = new Timer(TIME_TO_DELAY, 1);
			timer.addEventListener(TimerEvent.TIMER, SendAllAction);
		}
		
		override public function EndingRoomOut():void
		{
			RefreshComponent(IsDataReady);
		}
		
		public function RefreshComponent(dataAvailable:Boolean = false):void
		{
			IsDataReady = dataAvailable;
			if (!IsDataReady || !IsFinishRoomOut) return;
			//Clear các component trong gui
			if (img.contains(WaitDataStore))
			{
				img.removeChild(WaitDataStore);
			}
			
			ClearComponent();
			AddBntClose();
			setDataInfo();
			drawContainerWoodKey();
			drawContainerSilverKey();
			drawContainerGoldKey();					
		}
		
		//Vẽ background của container và chìa khóa
		private function drawContainerKey(keyType:int, x:int , y:int):Container
		{
			var ctn:Container = AddContainer("", "CtnChangeKey", x, y);
			var idCard:String = CARD_PEARL + "_" + "Key" + "_" + keyType;
			var card:Image = ctn.AddButtonEx(idCard, "ImgCardKey", 530, 20, this);
			var key:Image = ctn.AddButtonEx(idCard, "Key" + keyType, 0, 0, this);//buttonEx
			key.FitRect(100, 80, new Point(515, 18));						
			var tf:TextField = ctn.AddLabel(keyData[keyType], 515 , 15, 0);			
			var fm:TextFormat = new TextFormat("Arial", 14);
			tf.setTextFormat(fm);
			return ctn;
		}
		
		/**
		 * 
		 * @param	ctn
		 * @param	category Loại gỗ, vàng, bạc: "Wood", "Silver", "Golde"
		 * @param	iconType loại icon(1 trong 10 loại)
		 * @param	x	tọa độ vị trí theo x
		 * @param	y	tọa độ vị trí theo y
		 * @param	buyXu	có nút mua xu hay không
		 * @return true nếu có đủ số icon so với số yêu cầu
		 */
		private function drawIcon(ctn:Container, category:String, iconType:int, x:int, y:int, buyXu:Boolean = true):Boolean
		{
			//Ảnh icon
			ctn.AddImage("", "Icon" + iconType, x + 50, y - 40);
			
			//Số lượng / số yêu cầu
			var numb:int = 0;			
			if (iconData[iconType])
				numb = iconData[iconType];
			var requireNumb:int = ConfigJSON.getInstance().getRequireIconNumb(category, iconType);
			var color:int = 0x000000;
			if (numb < requireNumb)
				color = 0xff0000
			var tf:TextField = ctn.AddLabel(numb + "/" + requireNumb, x, y - 5);
			var fm:TextFormat = new TextFormat("Arial", null, color);
			tf.setTextFormat(fm);
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Icon", iconType);
			//Nút mua bằng xu
			
			if(buyXu)
			{
				var btnBuyXu:Button = ctn.AddButton(iconType.toString(), "BtnBuyKey", x + 20, y + 20, this);
				if (obj["UnlockType"] == 6) 
				{
					btnBuyXu.SetVisible(false);
					return (numb >= requireNumb);
				}
				if (GameLogic.getInstance().user.GetZMoney() < obj["ZMoney"])
				{
					btnBuyXu.SetDisable();
				}
				else
				{
					btnBuyXu.SetEnable();
				}
				
				txtFormat.size = 14;				
				ctn.AddLabel(obj["ZMoney"], x + 17, y + 20, 0x27362d).setTextFormat(txtFormat);
			}
			else
			{//đối với bình nước myFish, dựa vào mốc ConfigJson::InfoList["Event"]["IconExchange2"]["ExpireTime"]
				var event:Object = ConfigJSON.getInstance().getEventInfo("IconExchange2");
				/*if (obj["UnlockType"] == 6)
				{
					ViewButtonRemind(ctn, x, y);
				}
				else if(obj["UnlockType"] == 1)
				{*/
					var endTime:Number = event["ExpireTime"];
					var buyDayTime:Number = event["BuyDay"] * 86400;
					ViewButton(ctn, iconType, x, y, obj["ZMoney"], endTime, buyDayTime);
					//var btnBuyXu2:Button = ctn.AddButton(iconType.toString(), "BtnBuyKey", x + 20, y + 20, this);
					//if (GameLogic.getInstance().user.GetZMoney() < obj["ZMoney"])
					//{
						//btnBuyXu2.SetDisable();
					//}
					//else
					//{
						//btnBuyXu2.SetEnable();
					//}
					//
					//txtFormat.size = 14;				
					//ctn.AddLabel(obj["ZMoney"], x + 17, y + 20, 0x27362d).setTextFormat(txtFormat);
				//}
			}
			
			return (numb >= requireNumb);
		}
		//vẽ các cái đĩa phía dưới.
		private function AddDisk(ctn:Container, x:int, y:int, dx:int):void
		{
			ctn.AddImage("", "ImgDisc", x, y);
			ctn.AddImage("", "ImgDisc", x + dx, y);
			ctn.AddImage("", "ImgDisc", x + 2 * dx, y);
			ctn.AddImage("", "ImgDisc", x + 3 * dx, y);
		}
		//Vẽ container chìa khóa gỗ
		private function drawContainerWoodKey():void
		{
			var ctn:Container = drawContainerKey(ID_WOOD, XCTN, 90);
			var x:int = 0;
			var y:int = 80;
			var dx:int = 120;
			AddDisk(ctn, x + 50, y - 15, dx);
			var enough1:Boolean, enough2:Boolean, enough3:Boolean, enough4:Boolean;
			enough1 = drawIcon(ctn, WOOD, FISH_WOOD, x, y);
			enough2 = drawIcon(ctn, WOOD, POULP_WOOD, x + dx, y);
			enough3 = drawIcon(ctn, WOOD, MERMAID_WOOD,  x + 2 * dx, y);
			enough4 = drawIcon(ctn, WOOD, MYFISH,  x + 3 * dx, y, false);			
			
			var btn:Button = ctn.AddButton(GUI_CHANGEKEY_BTN_CHANGE_WOODKEY, "BtnChangeKey", 540, 100, this);
			if (!enough1 || !enough2 || !enough3 || !enough4)
				btn.SetDisable();				
		}
	
		//Vẽ container chìa khóa bạc
		private function drawContainerSilverKey():void
		{
			var ctn:Container = drawContainerKey(ID_SILVER, XCTN, 237);
			var x:int = 0;
			var y:int = 80;
			var dx:int = 120;
			AddDisk(ctn, x + 50, y - 15, dx);
			var enough1:Boolean, enough2:Boolean, enough3:Boolean, enough4:Boolean;
			enough1 = drawIcon(ctn, SILVER, FISH_SILVER, x, y);
			enough2 = drawIcon(ctn, SILVER, POULP_SILVER, x + dx, y);
			enough3 = drawIcon(ctn, SILVER, MERMAID_SILVER,  x + 2 * dx, y);
			enough4 = drawIcon(ctn, SILVER, MYFISH,  x + 3 * dx, y, false);					
			
			var btn:Button = ctn.AddButton(GUI_CHANGEKEY_BTN_CHANGE_SILVERKEY, "BtnChangeKey", 540, 100, this);
			if (!enough1 || !enough2 || !enough3 || !enough4)
				btn.SetDisable();
		}
		
		//Vẽ container chìa khóa vàng
		private function drawContainerGoldKey():void
		{
			var ctn:Container = drawContainerKey(ID_GOLD, XCTN, 385);			
			var x:int = 0;
			var y:int = 80;
			var dx:int = 120;
			AddDisk(ctn, x + 50, y - 15, dx);
			var enough1:Boolean, enough2:Boolean, enough3:Boolean, enough4:Boolean;
			enough1 = drawIcon(ctn, GOLD, FISH_GOLD, x, y);
			enough2 = drawIcon(ctn, GOLD, POULP_GOLD, x + dx, y);
			enough3 = drawIcon(ctn, GOLD, MERMAID_GOLD,  x + 2 * dx, y);
			enough4 = drawIcon(ctn, GOLD, MYFISH,  x + 3 * dx, y, false);		
			
			var btn:Button = ctn.AddButton(GUI_CHANGEKEY_BTN_CHANGE_GOLDKEY, "BtnChangeKey", 540, 100, this);	
			if (!enough1 || !enough2 || !enough3 || !enough4)
				btn.SetDisable();
		}
		
		/**
		 * Set data về số lượng các icon trong kho
		 */
		public function setDataInfo():void
		{
			//thong tin icon
			var iconArr:Array = GameLogic.getInstance().user.StockThingsArr["Icon"];
			iconData = new Object();
			for (var i:int = 1; i < 10; i++) 
			{	
				iconData[i] = 0;
			}
			for (i= 0; i < iconArr.length; i++) 
			{
				iconData[iconArr[i]["Id"]] = iconArr[i]["Num"];
			}
			
			//thong tin key
			var keyArr:Array = GameLogic.getInstance().user.StockThingsArr["Key"];
			keyData = new Object();
			for (i = 1; i < 4; i++) 
			{
				keyData[i] = 0;
			}
			for (i= 0; i < keyArr.length; i++) 
			{
				keyData[keyArr[i]["Id"]] = keyArr[i]["Num"];
			}
		}
		
		public override function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			switch (buttonID)
			{
				case GUI_CHANGEKEY_EXIT:
					SendAllAction();
					Hide();
					break;
				case GUI_CHANGEKEY_BTN_CHANGE_WOODKEY:
					SendAllAction();
					changeWoodKey();
					break;
				case GUI_CHANGEKEY_BTN_CHANGE_SILVERKEY:
					SendAllAction();
					changeSilverKey();
					break;
				case GUI_CHANGEKEY_BTN_CHANGE_GOLDKEY:
					SendAllAction();
					changeGoldKey();
					break;
				case GUI_CHANGEKEY_BTN_REMIND_FRIEND:
					SendAllAction();
					remindFriend();
					break;
				default:
					buyIconBuyXu(buttonID);
					break;
			}
		}
		
		//Xử lý khi click vào nút đổi chìa khóa gỗ
		private function changeWoodKey():void
		{
			EffectMgr.setEffBounceDown("Đổi thành công", "Key1", 330, 280);
			
			//Gửi gói tin
			var cmd:SendChangeKey = new SendChangeKey(ID_WOOD);
			Exchange.GetInstance().Send(cmd);
			
			//Update lại số lượng icon cá gỗ trong kho
			var requireNumb:int = ConfigJSON.getInstance().getRequireIconNumb(WOOD, FISH_WOOD);
			GameLogic.getInstance().user.UpdateStockThing("Icon", FISH_WOOD, -requireNumb);
			
			//Update lại số lượng icon bạch tuộc gỗ trong kho
			requireNumb = ConfigJSON.getInstance().getRequireIconNumb(WOOD, POULP_WOOD);
			GameLogic.getInstance().user.UpdateStockThing("Icon", POULP_WOOD, -requireNumb);
			
			//Update lại số lượng icon tiên cá gỗ trong kho
			requireNumb = ConfigJSON.getInstance().getRequireIconNumb(WOOD, MERMAID_WOOD);
			GameLogic.getInstance().user.UpdateStockThing("Icon", MERMAID_WOOD, -requireNumb);
			
			//Update lại số lượng logo myFish trong kho
			requireNumb = ConfigJSON.getInstance().getRequireIconNumb(WOOD, MYFISH);
			GameLogic.getInstance().user.UpdateStockThing("Icon", MYFISH, -requireNumb);
			
			//Update lại số lượng chìa khóa gỗ trong kho
			GameLogic.getInstance().user.UpdateStockThing("Key", ID_WOOD, 1);
			
			//Update lại hiển thị của kho
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.RefreshComponent();				
			}
			
			RefreshComponent(true);
		}
		
		//Xử lý khi click vào nút đổi chìa khóa bạc
		private function changeSilverKey():void
		{
			EffectMgr.setEffBounceDown("Đổi thành công", "Key2", 330, 280);
			
			//Gửi gói tin
			var cmd:SendChangeKey = new SendChangeKey(ID_SILVER);
			Exchange.GetInstance().Send(cmd);
			
			//Update lại số lượng icon cá bạc trong kho
			var requireNumb:int = ConfigJSON.getInstance().getRequireIconNumb(SILVER, FISH_SILVER);
			GameLogic.getInstance().user.UpdateStockThing("Icon", FISH_SILVER, -requireNumb);
			
			//Update lại số lượng icon bạch tuộc bạc trong kho
			requireNumb = ConfigJSON.getInstance().getRequireIconNumb(SILVER, POULP_SILVER);
			GameLogic.getInstance().user.UpdateStockThing("Icon", POULP_SILVER, -requireNumb);
			
			//Update lại số lượng icon tiên cá bạc trong kho
			requireNumb = ConfigJSON.getInstance().getRequireIconNumb(SILVER, MERMAID_SILVER);
			GameLogic.getInstance().user.UpdateStockThing("Icon", MERMAID_SILVER, -requireNumb);
			
			//Update lại số lượng logo myFish trong kho
			requireNumb = ConfigJSON.getInstance().getRequireIconNumb(SILVER, MYFISH);
			GameLogic.getInstance().user.UpdateStockThing("Icon", MYFISH, -requireNumb);
			
			//Update lại số lượng chìa khóa bạc trong kho
			GameLogic.getInstance().user.UpdateStockThing("Key", ID_SILVER, 1);
			
			//Update lại hiển thị của kho
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.RefreshComponent();				
			}
			
			//Update lại hiển thị
			RefreshComponent(true);
		}
		
		
		//Xử lý khi click vào nút đổi chìa khóa vàng
		private function changeGoldKey():void
		{
			EffectMgr.setEffBounceDown("Đổi thành công", "Key3", 330, 280);
			
			//Gửi gói tin
			var cmd:SendChangeKey = new SendChangeKey(ID_GOLD);
			Exchange.GetInstance().Send(cmd);
			
			//Update lại số lượng icon cá vàng trong kho
			var requireNumb:int = ConfigJSON.getInstance().getRequireIconNumb(GOLD, FISH_GOLD);
			GameLogic.getInstance().user.UpdateStockThing("Icon", FISH_GOLD, -requireNumb);
			
			//Update lại số lượng icon bạch tuộc vàng trong kho
			requireNumb = ConfigJSON.getInstance().getRequireIconNumb(GOLD, POULP_GOLD);
			GameLogic.getInstance().user.UpdateStockThing("Icon", POULP_GOLD, -requireNumb);
			
			//Update lại số lượng icon tiên cá vàng trong kho
			requireNumb = ConfigJSON.getInstance().getRequireIconNumb(GOLD, MERMAID_GOLD);
			GameLogic.getInstance().user.UpdateStockThing("Icon", MERMAID_GOLD, -requireNumb);
			
			//Update lại số lượng logo myFish trong kho
			requireNumb = ConfigJSON.getInstance().getRequireIconNumb(GOLD, MYFISH);
			GameLogic.getInstance().user.UpdateStockThing("Icon", MYFISH, -requireNumb);
			
			//Update lại số lượng chìa khóa vàng trong kho
			GameLogic.getInstance().user.UpdateStockThing("Key", ID_GOLD, 1);
			
			//Update lại hiển thị của kho
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.RefreshComponent();				
			}
			
			//Update lại hiển thị
			RefreshComponent(true);
		}
		
		private function remindFriend():void
		{
			var so:SharedObject = SharedObject.getLocal("SavedSetting");
			var data:Object;
			if (so.data.uId != null)
			{
				data = so.data.uId;
			}
			else
			{
				data = new Object();
				so.data.uId = data;
			}
			
			if (data.RestrictFeed == GUIFeedWall.FEED_TYPE_REMIND_FRIEND && 
				GameLogic.getInstance().CurServerTime - data.lastTimeFeed < 30*60)
			{
				return;
			}
			GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_REMIND_FRIEND);
			
		}
		
		private function buyIconBuyXu(btnId:String):void
		{
			//GameLogic.getInstance().BuyItem(parseInt(btnId), "Icon", "ZMoney");			
			var obj:Object = ConfigJSON.getInstance().getItemInfo("Icon", parseInt(btnId));
			var MoneyHave:int = GameLogic.getInstance().user.GetZMoney();
			var nMoney:int = obj["ZMoney"];
			if (nMoney > MoneyHave)
			{
				return;
			}
			
			//var cmd:SendBuyEvent = new SendBuyEvent(parseInt(btnId), 1, "ZMoney");
			//Exchange.GetInstance().Send(cmd);
			MergeBuyAction(parseInt(btnId), 1);
			
			GameLogic.getInstance().user.UpdateUserZMoney( -nMoney);
			GameLogic.getInstance().user.UpdateStockThing("Icon", parseInt(btnId), 1);
			
			//Hiện thông báo mua thành công
			EffectMgr.setEffBounceDown("Mua thành công", "Icon" + btnId, 330, 280);
			
			//Update lại hiển thị của kho
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.RefreshComponent();				
			}
			
			//Update lại hiển thị
			RefreshComponent(true);
		}
		
		public function MergeBuyAction(itemId:int, num:int):void
		{
			if (listItemBuy == null)
			{
				listItemBuy = new Object();
			}
			if (listItemBuy[itemId] == null)
			{
				listItemBuy[itemId] = 0;
			}
			listItemBuy[itemId]++;			
			timer.delay = TIME_TO_DELAY;
			timer.start();
		}
		
		public function SendAllAction(e:TimerEvent = null):void
		{
			if (listItemBuy == null)
			{
				return;
			}
			for (var s:String in listItemBuy)
			{
				var cmd:SendBuyEvent = new SendBuyEvent(parseInt(s), listItemBuy[s], "ZMoney");
				Exchange.GetInstance().Send(cmd);
			}
			listItemBuy = null;
		}
		
		override public function OnButtonMove(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var type:int = (int)(data[2]);
			
			switch(command)
			{
				case CARD_PEARL:
					GUIPearlInfo.GetInstacne().ShowGUI(type);
					break;
			}
		}
		override public function OnButtonOut(event:MouseEvent, buttonID:String):void 
		{
			
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var type:String = data[2];
			switch(command)
			{
				case CARD_PEARL:
					GUIPearlInfo.GetInstacne().Hide();
					break;
			}//*/
		}
		public function ViewButton(ctn:Container, iconType:int, x:int, y:int,nZMoney:int, endTime:Number, buyDayTime:Number):void
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (curTime >= endTime-buyDayTime && curTime <= endTime)
			{
				//thực hiện view Button mua
				var btnBuyXu2:Button = ctn.AddButton(iconType.toString(), "BtnBuyKey", x + 20, y + 20, this);
				if (GameLogic.getInstance().user.GetZMoney() < nZMoney)
				{
					btnBuyXu2.SetDisable();
				}
				else
				{
					btnBuyXu2.SetEnable();
				}
				
				txtFormat.size = 14;				
				ctn.AddLabel(nZMoney.toString(), x + 17, y + 20, 0x27362d).setTextFormat(txtFormat);
			}
			else
			{
				//thực hiện view button nhờ bạn
				ViewButtonRemind(ctn, x, y);
			}
		}
		
		private function ViewButtonRemind(ctn:Container,x:int,y:int):void
		{
			var btnRemind:Button = ctn.AddButton(GUI_CHANGEKEY_BTN_REMIND_FRIEND, "BtnRemindFriend", x + 15, y + 20, this);
			var so:SharedObject = SharedObject.getLocal("SavedSetting");
			var data:Object;
			if (so.data.uId != null)
			{
				data = so.data.uId;
			}
			else
			{
				data = new Object();
				so.data.uId = data;
			}
			if (data.RestrictFeed == GUIFeedWall.FEED_TYPE_REMIND_FRIEND && 
				GameLogic.getInstance().CurServerTime - data.lastTimeFeed < 30*60)
			{
				var remain:int = 30 * 60 - (GameLogic.getInstance().CurServerTime - data.lastTimeFeed);
				var tip:TooltipFormat = new TooltipFormat();
				tip.text = "Hai lần thông báo\ncách nhau 30 phút";
				btnRemind.setTooltip(tip);
			}
		}
	}

}





































