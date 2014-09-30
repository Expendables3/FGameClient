package Event.EventNoel.NoelGui 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Event.EventNoel.NoelGui.ItemGui.ItemNoel;
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import Event.EventNoel.NoelLogic.ItemInfo.NoelItemInfo;
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Factory.FactoryLogic.ItemInfo.ItemCollectionInfo;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.Image;
	import GUI.component.ProgressBar;
	import GUI.GuiMgr;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * GUI vào khu săn cá:
		 * là 1 màn hình rộng => có button backhome
		 * có guiUserEventInfo => để show exp,money,zmoney,diamond (vì có thể nhận thưởng ở đây.
		 * Phần bộ sưu tập có thể đổi được nằm phía dưới màn hình.
		 * Link đến:
			 * GuiHuntFish khi click nút vào (=Xu or =Gold) => hide gui luôn
			 * GuiExchangeNoelItem khi click bất kỳ nút nhận thưởng nào => lấy ra được idRown => hiện gui lên
	 * @author HiepNM2
	 */
	public class GuiGotoHunt extends BaseGUI 
	{
		private const CMD_COME_XU:String = "cmdComeXu";
		private const CMD_COME_FREE:String = "cmdComeFree";
		private const CMD_RECEIVE:String = "cmdReceive";
		
		private var tfCountCome:TextField;
		private var tfTimeRemain:TextField;
		private var btnCome1:Button;
		private var btnCome:Button;
		private var prgClock:ProgressBar;
		private var imgCLock:Image;
		
		private var _timeShowUserInfo:Number = -1;
		private var _timeGui:Number;
		//private var _logTime:Number = 0;			//thời gian vào(ra) trước đó
		private var _logTime:Number = 1355765622;			//thời gian vào(ra) trước đó
		private var inUpdateTime:Boolean = false;
		private var _listItemCollection:Array;
		private var configGift:Object = { 
											"1": { "ItemType":"EquipmentChest", "ItemId":0, "Rank":4, "Color":4 } ,
											"2": { "ItemType":"VipTag", "ItemId":1 },
											"3":{"ItemType":"HammerPurple", "ItemId":1 },
											"4":{"ItemType":"RankPointBottle", "ItemId":4 },
											"5": { "ItemType":"Material", "ItemId":10 }
										};
		public function GuiGotoHunt(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiGotoHunt";
		}
		
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				_timeGui = GameLogic.getInstance().CurServerTime;
				
				SetPos(0, 0);
				drawTopArea();//vẽ phần bảng vào
				//drawBotArea();//vẽ phần nhận thưởng noelItem
				GuiMgr.getInstance().guiUserEventInfo.Show();
				_timeShowUserInfo = _timeGui;
				GuiMgr.getInstance().guiBtnControl.Show();
			}
			LoadRes("GuiHuntFish_BackGround");
		}
		private function drawTopArea():void
		{
			var fm:TextFormat;
			/*ảnh nền*/
			AddImage("", "GuiHuntFish_ImgComeSea", 120, 100, true, ALIGN_LEFT_TOP);
			_listItemCollection = [];
			var info:AbstractGift, item:AbstractItemGift,obj:Object;
			var x:int = 180;
			for (var i:int = 1; i <= 5; i++)
			{
				obj = configGift[i];
				info = AbstractGift.createGift(obj["ItemType"]);
				info.setInfo(obj);
				item = AbstractItemGift.createItemGift(info.ItemType, this.img, "EventNoel_ImgSlot", x, 317);
				item.hasNum = false;
				item.hasTooltipImg = false;
				item.hasTooltipText = true;
				item.initData(info);
				item.drawGift();
				_listItemCollection.push(item);
				x += 95;
			}
			/*dòng tip số lần còn lại*/
			tfCountCome = AddLabel("", 365, 410, 0xffffff, 1, 0x000000);
			fm = new TextFormat("Arial", 18, 0xffffff, true);
			tfCountCome.defaultTextFormat = fm;
			var strTimeRemain:String = Localization.getInstance().getString("EventNoel_TipNumRemain");
			var timeRemain:int = EventNoelMgr.getInstance().RemainNumPlay;
			strTimeRemain = strTimeRemain.replace("@Num@", timeRemain);
			tfCountCome.text = strTimeRemain;
			/*nút vào ngay*/
			var price:int = ConfigJSON.getInstance().getItemInfo("Noel_BoardConfig")["BoardGame"]["ZMoney"];
			btnCome = AddButton(CMD_COME_XU + "_" + price, "GuiHuntFish_BtnComeInXu", 450, 455);
			var tfPrice:TextField = AddLabel("", 530, 455, 0xffffff, 0, 0x000000);
			tfPrice.mouseEnabled = false;
			tfPrice.text = Ultility.StandardNumber(price);
			/*progressbar*/
			prgClock = AddProgress("", "GuiHuntFish_PrgClock", 270, 447, null, true);
			imgCLock = AddImage("", "GuiHuntFish_ImgClock", 250, 440, true, ALIGN_LEFT_TOP);
			tfTimeRemain = AddLabel("", 300, 452, 0xffffff, 0, 0x000000);
			fm = new TextFormat("Arial", 18, 0xffffff, true);
			tfTimeRemain.defaultTextFormat = fm;
			prgClock.img.visible = imgCLock.img.visible = tfTimeRemain.visible = false;
			var remainTime:int = EventNoelMgr.getInstance().getRemainTime();
			if (remainTime >= 0)
			{
				inUpdateTime = true;
				imgCLock.img.visible = prgClock.img.visible = tfTimeRemain.visible = true;
				tfTimeRemain.text = Ultility.convertToTime(remainTime);
			}
			else
			{//vừa vào thì hết giờ
				gotoSea();
			}
		}
			
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var cmd:String = data[0];
			var priceType:String;
			var price:int;
			switch(cmd)
			{
				case CMD_COME_XU:
					priceType = "ZMoney";
					price = ConfigJSON.getInstance().getItemInfo("Noel_BoardConfig")["BoardGame"]["ZMoney"];
					if (Ultility.payMoney(priceType, price))
					{
						GuiMgr.getInstance().guiHuntFish.setDataPacket( { "IsPlayNow":true } );
						gotoSea();
					}
					break;
			}
		}
		private function gotoSea():void 
		{
			Hide();
			EventNoelMgr.getInstance().NumPlay++;
			GuiMgr.getInstance().guiHuntFish.Show(Constant.GUI_MIN_LAYER, 5);
		}
		
		public function updateGui(curTime:Number):void
		{
			_timeGui = curTime;
			if (inUpdateTime)
			{
				var remainTime:Number = EventNoelMgr.getInstance().getRemainTime();
				if (remainTime >= 0)
				{
					tfTimeRemain.text = Ultility.convertToTime(remainTime);
					if (remainTime < 10)//không cho vào bằng xu lúc này vì chỉ còn 10s nữa
					{
						if (!btnCome.enable)
						{
							btnCome.SetDisable();
						}
					}
				}
				else
				{
					inUpdateTime = false;
					gotoSea();
				}
			}
			
			if (_timeShowUserInfo > 0)
			{
				if (curTime - _timeShowUserInfo > 0.5)
				{
					GuiMgr.getInstance().guiUserEventInfo.updateUserData();
					_timeShowUserInfo = -1;
				}
			}
		}
		override public function ClearComponent():void 
		{
			if (_listItemCollection != null && _listItemCollection.length > 0)
			{
				for (var i:int = 0; i < _listItemCollection.length; i++)
				{
					var item:AbstractItemGift = _listItemCollection[i];
					item.Destructor();
				}
				_listItemCollection.splice(0, _listItemCollection.length);
			}
			super.ClearComponent();
		}
		override public function OnHideGUI():void 
		{
			GuiMgr.getInstance().guiUserEventInfo.Hide();
			GuiMgr.getInstance().guiBtnControl.Hide();
		}
	}

}




















