package GUI.EventNationalCelebration 
{
	import com.bit101.components.IndicatorLight;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import GameControl.GameController;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import NetworkPacket.PacketSend.SendGetGiftEventND;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIGetEventGift extends BaseGUI 
	{
		private const BTN_GET_GIFT:String = "btnGetGift";
		private const BTN_CLOSE:String = "btnClose";
		private const BTN_GUIDE:String = "btnGuide";
		public var buttonGetGift:Button;
		private var closeButton:Button;
		private var listGift:ListBox;
		private var listObject:ListBox;
		public var timer:Timer;
		private var oldIndex:int;
		private var curIndex:int;
		private var check:Boolean;//Tăng dần
		private var count:int;
		private var clicked:Boolean;
		private var indexStop:int = -1;
		private var numGift:int = 8;
		public const delayStart:int = 40; 
		public var serverRespond:Boolean = false;
		
		public function GUIGetEventGift(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			timer = new Timer(delayStart);
			timer.addEventListener(TimerEvent.TIMER, runEffect);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUI_Get_Gift");
			buttonGetGift = AddButton(BTN_GET_GIFT, "Btn_Change_Noel", 307 +8, 375 + 15);
			var tooltip:TooltipFormat = new TooltipFormat();
			tooltip.text = "Bạn sẽ nhận được những phần thưởng có số lượng nhất định ở dưới.\nHết loại giải thưởng này sẽ tự động chuyển qua loại giải thưởng khác";
			buttonGetGift.setTooltip(tooltip);
			//buttonGetGift.img.scaleX = buttonGetGift.img.scaleY = 1.5;
			closeButton = AddButton(BTN_CLOSE, "BtnThoat", 655 + 8, 22 + 6, this);		
			AddButton(BTN_GUIDE, "BtnGuide", 613 + 8, 23 +6);
			SetPos(50, 20);
		}
		
		private function runEffect(e:TimerEvent):void 
		{
			//trace(timer.delay);
			setHightLightGift(count);
			if (clicked)
			{
				timer.delay += 5;
				//Lỗi
				if (timer.delay >= 1500)
				{
					trace("GuiGetEventGift error cup dien");
					var st:String = Localization.getInstance().getString("ErrorMsg101");
					GuiMgr.getInstance().GuiMessageBox.ShowOK(st);	
					//timer.stop();
					resetEff();
					Hide();
				}
			}
			
			if (serverRespond)
			{
				timer.delay += 40;
				if (count == indexStop && timer.delay >= 350)
				{
					//trace("delay", timer.delay);
					//timer.stop();
					resetEff();
					getGift();
				}
			}
			
			//Đi tiến
			if (check)
			{
				count++;
			}
			//Đi lùi
			else
			{
				count--;
			}
		}
		
		//Xử lí sau khi chọn được quà
		private function getGift():void
		{
			var itemGift:ItemGift = listGift.getItemByIndex(indexStop) as ItemGift;
			itemGift.num -= 1;
			
			//Hiệu ứng -1
			var p:Point = listGift.localToGlobal(itemGift.CurPos);
			p.x += itemGift.img.width / 2 - 2;
			p.y += itemGift.img.height;
			EffectMgr.getInstance().textFly("-1", p);
			
			//update user profile
			GameLogic.getInstance().user.GetMyInfo()["event"]["IconChristmas"]["Gift"][listGift.getIdByIndex(indexStop)]--;
			
			GuiMgr.getInstance().guiCongratulation.showGUI(itemGift.itemType, itemGift.itemId, itemGift.xNum);
			closeButton.SetEnable(true);
			buttonGetGift.SetEnable(canGetGift());
			
			serverRespond = false;
			if(itemGift.num > 0)
			{
				setHightLightGift(indexStop);
			}
			else
			{
				setHightLightGift(indexStop, false);
			}
		}
		
		public function showGUI():void
		{
			Show(Constant.GUI_MIN_LAYER, 10);
			initData();
			count = 0;
			/*timer.reset();
			timer.delay = delayStart;
			check = true;
			clicked = false;*/
			if (canGetGift())
			{
				buttonGetGift.SetEnable(true);
				startEffect();
				//timer.start();
			}
			else
			{
				buttonGetGift.SetEnable(false);
				//timer.stop();
				resetEff();
			}
			//startEffect();
		}
		
		public function resetEff():void
		{
			//Tắt highlight oldindex
			if (listGift.getItemByIndex(oldIndex) != null)
			{
				if(ItemGift(listGift.getItemByIndex(oldIndex)).num > 0)
				{
					listGift.getItemByIndex(oldIndex).SetHighLight(-1);
				}
				else
				{
					listGift.getItemByIndex(oldIndex).enable = false;
				}
			}
			timer.reset();
			timer.delay = delayStart;
			check = true;
			clicked = false;
			serverRespond = false;
		}
		
		private function initData():void
		{
			var config:Object;
			var configNum:Object;
			//Tạo danh sách quà tặng (pải trc ds object)
			if (listGift == null)
			{
				listGift = new ListBox(ListBox.LIST_X, 1, 8);
				
				//Khởi tạo mảng quà từ config
				config = ConfigJSON.getInstance().GetItemList("EventGift");
				configNum = ConfigJSON.getInstance().GetItemList("EventChristmas_Gift");
				for (var st:String in config)
				{
					var itemGift:ItemGift = new ItemGift(listGift);
					itemGift.id = int(st);
					itemGift.initItem(config[st]["ItemType"], config[st]["ItemId"], config[st]["Num"], configNum[st]);
					listGift.addItem(st, itemGift);
				}
				
				listGift.setInfo(10, 10, 55, 40);
				listGift.x = 80 +8;
				listGift.y = 417 + 6;
			}
			//Cập nhật số lượng còn lại của quà
			var data:Object = GameLogic.getInstance().user.GetMyInfo()["event"]["IconChristmas"]["Gift"];
			for (var m:String in data)
			{
				ItemGift(listGift.getItemById(m)).num = data[m];
			}
			this.img.addChild(listGift);
			
			
			//Tạo danh sách object đem đổi quà
			if (listObject == null)
			{
				listObject = new ListBox(ListBox.LIST_X, 1, 3, 45);
				
				//Khởi tạo các IconObject từ config
				config =  ConfigJSON.getInstance().GetItemList("IconChristmas");
				configNum = ConfigJSON.getInstance().GetItemList("EventContent");
				for (var s:String in config)
				{
					var itemObject:ItemObject = new ItemObject(listObject, "IconChristmas" + s);
					itemObject.maxNum = configNum[s];
					itemObject.cost = config[s]["ZMoney"];
					if (config[s]["Money"] != 0)
					{
						itemObject.costGold = config[s]["Money"];
					}
					itemObject.id = int(s);
					listObject.addItem(s, itemObject);
				}
				
				//listObject.setInfo(20, 10, 132, 129);
				
				listObject.x = 95;
				listObject.y = 100;
			}
			//Cập nhật số lượng cho các IconND
			data = GameLogic.getInstance().user.StockThingsArr["IconChristmas"];
			for (var t:String in data)
			{
				if(data[t]["Id"] != 4)
				{
					ItemObject(listObject.getItemById(data[t]["Id"])).num = data[t]["Num"];
				}
			}
			this.img.addChild(listObject);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case BTN_GET_GIFT:		
					if(!GameLogic.getInstance().isEventND())
					{
						GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian diễn ra event.");	
						this.Hide();
						//GuiMgr.getInstance().GuiTopInfo.buttonGetGiftEvent.SetVisible(false);
						return;
					}
					//trace(timer.running);
					closeButton.SetEnable(false);
					//startEffect();
					
					//Chỉ còn 1 quà duy nhất
					if (getNumGift() == 1)
					{
						for (i = 0; i < listGift.length; i++) 
						{
							var itemGift:ItemGift = listGift.getItemByIndex(i) as ItemGift;
							if (itemGift.num > 0)
							{
								indexStop = i;
								resetEff();
								getGift();
								break;
							}
						}
					}
					else
					{
						clicked = true;
						timer.delay = delayStart + 5;
					}
					
					
					//Trừ số lượng các item dem đổi
					for (var i:int = 0; i < listObject.length; i++)
					{
						var itemObject:ItemObject = listObject.getItemByIndex(i) as ItemObject;
						itemObject.num -= itemObject.maxNum;
					}
					
					buttonGetGift.SetEnable(false);
					//Gửi các gói tin mua icon
					sendBuyIcon();
					Exchange.GetInstance().Send(new SendGetGiftEventND());
					
					//Ẩn gui store
					if (GuiMgr.getInstance().GuiMain.IsVisible)
					{
						GuiMgr.getInstance().GuiMain.img.visible = true;
						GuiMgr.getInstance().GuiMain.imgBgLake.img.visible = true;
					}
					if (GuiMgr.getInstance().GuiFriends.IsVisible)
					{
						GuiMgr.getInstance().GuiFriends.ShowFriend(GuiMgr.getInstance().GuiFriends.page);
					}
					GameLogic.getInstance().BackToIdleGameState();
					GameController.getInstance().UseTool("Default");
					GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
					GuiMgr.getInstance().GuiMain.ShowLakes();
					GuiMgr.getInstance().GuiStore.Hide();
					
					//Hiệu ứng trừ số lượng item object
					for (var j:int = 0; j < listObject.length; j++)
					{
						var item:ItemObject = listObject.getItemByIndex(j) as ItemObject;
						//Hiệu ứng -1
						var p:Point = listObject.localToGlobal(item.CurPos);
						p.x += item.img.width / 2 + 20;
						p.y += item.img.height - 50;
						EffectMgr.getInstance().textFly("-" + item.maxNum, p);
					}
					//trace(timer.running);
					
					break;
				case BTN_CLOSE:	
					sendBuyIcon();
					hideGUI();
					break;
				case BTN_GUIDE:	
					GuiMgr.getInstance().GuiHelp.Show();
					break;
			}
		}
		
		public function startEffect():void
		{
			if (!timer.running)
			{
				//Tắt highlight oldindex
				if (listGift.getItemByIndex(oldIndex) != null)
				{
					if(ItemGift(listGift.getItemByIndex(oldIndex)).num > 0)
					{
						listGift.getItemByIndex(oldIndex).SetHighLight(-1);
					}
					else
					{
						listGift.getItemByIndex(oldIndex).enable = false;
					}
				}
				timer.delay = delayStart;
				timer.start();
				clicked = false;
				serverRespond = false;
				indexStop = -1;
				check = true;
			}
		}
		
		public function setHightLightGift(index:int, enable:Boolean = true):void
		{
			//Tắt highlight oldindex
			if (listGift.getItemByIndex(oldIndex) != null && ItemGift(listGift.getItemByIndex(oldIndex)).num > 0)
			{
				listGift.getItemByIndex(oldIndex).SetHighLight(-1);
			}
			
			if (!enable)
			{
				listGift.getItemByIndex(index).SetHighLight(0xc82daf, false, false);
				oldIndex = index;
				if (index == 0)
				{
					check = true;
				}
				
				//Set trạng thái đi lùi
				if (index == numGift -1)
				{
					check = false;
				}
				return;
			}
			
			//Xử lí khi gặp item num <= 0
			if (ItemGift(listGift.getItemByIndex(index)).num <= 0)
			{				
				var temp:int = 0;//Biến đếm để thoát khỏi vòng kiểm tra nếu đi hết danh sách mà không có item num >0
				while (ItemGift(listGift.getItemByIndex(index)).num <= 0 && index >= 0 && index <= numGift -1)
				{
					temp++;
					if (temp >= numGift-2)
					{
						break;
					}
					if (check)
					{
						//Đi đến cuối danh sách mà không gặp đc item num > 0
						if (index >= numGift - 1)
						{
							check = false;
							index = count - 2;
						}
						else
						{
							index++;
						}
					}
					else
					{
						//Đi đến đầu danh sách mà không gặp đc item num > 0
						if (index <= 0)
						{
							check = true;
							index = count + 2;
						}
						else
						{
							index--;
						}
					}
				}
			}
			
			
			//Set trạng thái đi tiến
			if (index == 0)
			{
				check = true;
			}
			
			//Set trạng thái đi lùi
			if (index == numGift -1)
			{
				check = false;
			}
			
			if (ItemGift(listGift.getItemByIndex(index)).num > 0)
			{
				oldIndex = index;
				//update lại biến count
				count = index;
				listGift.getItemByIndex(index).SetHighLight(0xc82daf);
				//trace("count", count);
			}
		}
		
		public function hideGUI():void
		{
			Hide();
			//timer.stop();
			resetEff();
		}
		
		public function canGetGift():Boolean
		{
			for (var i:int = 0; i < listObject.length; i++)
			{
				var itemObject:ItemObject = listObject.getItemByIndex(i) as ItemObject;
				if (itemObject.num < itemObject.maxNum)
				{
					return false;
				}
			}
			
			if (getNumGift() == 0)
			{
				return false;
			}
			
			return true;
		}
		
		public function getNumGift():int
		{
			var temp:int = 0;
			for (var i:int = 0; i < listGift.length; i++) 
			{
				var item:ItemGift = listGift.getItemByIndex(i) as ItemGift;
				if (item.num > 0)
				{
					temp++;
				}
			}
			return temp;
		}
		
		public function setIdGift(idItem:int):void
		{
			indexStop = listGift.getIndexById(idItem.toString());
			var config:Object = ConfigJSON.getInstance().GetItemList("EventGift");
			for (var st:String in config)
			{
				if (idItem == int(st) && config[st]["ItemType"] == "Exp")
				{
					GameLogic.getInstance().user.ExpWillBeAddLater();
				}
			}
		}
		
		private function sendBuyIcon():void
		{
			for (var i:int = 0; i < listObject.length; i++)
			{
				var itemObject:ItemObject = listObject.getItemByIndex(i) as ItemObject;
				itemObject.sendPacket();
				if (itemObject.canByGold)
				{
					itemObject.sendPacketGold();
				}
			}
		}
	}

}