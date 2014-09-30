package Logic 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import GUI.component.ActiveTooltip;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import NetworkPacket.PacketReceive.GetTreasure;
	import NetworkPacket.PacketSend.SendOpenTrunk;
	/**
	 * ...
	 * @author ...
	 */
	public class Treasure extends BaseObject
	{
		public static const TIME_TO_CLOSE:int = 3000;
		public static const MIN_LEVEL:int = 7;
		public static const KEY:String = "Key";
		public static const OPEN:String = "Open";
		public static const CLOSE:String = "Idle";
		private var effClickTreasure:SwfEffect;
		
		//control variable
		private var inEffClick:Boolean = false;				//kiểm tra xem có đang thực hiện flow ăn ngọc + nhả quà
		public var status:String = CLOSE;
		
		public var timer:Timer = null;
		public var type:int;
		public var tip:TooltipFormat = new TooltipFormat();
		private var effOpen:SwfEffect = null;
		public var resultData:GetTreasure = null;
		
		public function Treasure(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "Treasure";
			timer = new Timer(TIME_TO_CLOSE, 1);
			timer.addEventListener(TimerEvent.TIMER, CloseTreasure);
		}
		public function init(Type:int, x:int, y:int):void 
		{
			type = Type;
			status = CLOSE;
			SetPos(x, y);
			ClearImage();
			var str:String = "";
			switch (type) 
			{
				case 1:
					str = "Wood";
				break;
				
				case 2:
					str = "Silver";
				break;
				
				case 3:
					str = "Gold";
				break;
			}
			LoadRes("Treasure" + str + status);
		}		
		
		private function FinishEffOpen():void
		{
			effOpen = null;
			OpenTreasure();
		}
		
		public function SaveData(data:Object):void
		{
			resultData = new GetTreasure(data);
			//OpenTreasure();
		}		
		
		public function OpenTreasure():void 
		{
			
			if (GameLogic.getInstance().user.IsViewer())
			{
				return;
			}
			
			if (!resultData || effOpen)
			{
				return;
			}
			if (img.parent == null)
			{
				return;
			}
			ClearImage();
			status = OPEN;
			var str:String = ChangeType(type);
			//cho nó mở mồm
			LoadRes("EffOverTreasure" + str);
			if (resultData.Gift.length > 2)
			{
				var strTreasureName:String = "";
				var strTreasureType:String = "";
				var numTreasure:int = 0;
				var itemType:String = resultData.Gift[2]["ItemType"];
				if (itemType == "BabyFish")
				{
					itemType = "Fish";
				}
				var objTreasure:Object = ConfigJSON.getInstance().getItemInfo(itemType, resultData.Gift[2]["ItemId"]);
				var IconNameFeed:String = "";
				var feedType:String;
				switch(itemType)
				{
					case "Fish":
						GameLogic.getInstance().user.GenerateNextID();
						var idFish:int = resultData.Gift[2]["ItemId"];
						var domain:int = 0;
						var imgDomain:String = "";
						if (idFish >= Constant.FISH_TYPE_START_DOMAIN)
						{
							domain = (idFish - Constant.FISH_TYPE_START_DOMAIN) % Constant.FISH_TYPE_DISTANCE_DOMAIN;
							if (domain > 0)
							{
								imgDomain = Fish.DOMAIN + domain;
								resultData.Gift[2]["ItemId"] -= domain;
							}
						}
						
						strTreasureType = itemType + resultData.Gift[2]["ItemId"];
						strTreasureName = objTreasure["Name"];
						strTreasureType = strTreasureType + "_" + Fish.OLD + "_" + Fish.IDLE
						IconNameFeed = "fishOverLevel";
						switch (resultData.Gift[2]["FishType"]) 
						{
							case Fish.FISHTYPE_SPECIAL:
								strTreasureName = strTreasureName + " đặc biệt";
								IconNameFeed = "fishSpecial";
							break;
							
							case Fish.FISHTYPE_RARE:
								strTreasureName = strTreasureName + " quí";
								IconNameFeed = "fishRare";
							break;
						}
						numTreasure = resultData.Gift[2]["Num"];
						GuiMgr.getInstance().GuiTreasureGift.Show(Constant.GUI_MIN_LAYER, 4);
						GuiMgr.getInstance().GuiTreasureGift.InitInfomation(strTreasureType, strTreasureName, numTreasure, IconNameFeed, "RareFish", domain, imgDomain);
						break;
					case "Viagra":
					case "EnergyItem":
					case "Material":
						if (resultData.Gift[2]["ItemId"] == 106||resultData.Gift[2]["ItemId"] == 7||resultData.Gift[2]["ItemId"] == 6)//feed wall
						{
							if (resultData.Gift[2]["ItemId"] == 106 || resultData.Gift[2]["ItemId"] == 7)
								feedType = "Material";
							else
								feedType = "EnergyItem";
							strTreasureName = objTreasure["Name"];
							strTreasureType = itemType + resultData.Gift[2]["ItemId"];
							if (itemType == "Material")
								strTreasureType = Ultility.GetNameMatFromType(resultData.Gift[2]["ItemId"]);
							numTreasure = resultData.Gift[2]["Num"];
							IconNameFeed = "Ornament";
							GuiMgr.getInstance().GuiTreasureGift.Show(Constant.GUI_MIN_LAYER, 4);
							GuiMgr.getInstance().GuiTreasureGift.InitInfomation(strTreasureType, strTreasureName, numTreasure, IconNameFeed, feedType);
						}
						else
							GameLogic.getInstance().DropActionGift(resultData.Gift[2], CurPos.x, CurPos.y);
						break;
					default:
						strTreasureName = objTreasure["Name"];
						strTreasureType = itemType + resultData.Gift[2]["ItemId"];
						if (itemType == "Sparta" || itemType == "Swat" || itemType == "Spiderman" || itemType == "Batman")
						{
							GameLogic.getInstance().user.GenerateNextID();
							feedType = "XFish";
							strTreasureType = itemType;
							strTreasureName = GuiMgr.getInstance().GuiStore.GetNameFishSpecial(itemType);
						}
						else
						{
							feedType = "RebornMedicine";
						}
						numTreasure = resultData.Gift[2]["Num"];
						GuiMgr.getInstance().GuiTreasureGift.Show(Constant.GUI_MIN_LAYER, 4);
						IconNameFeed = "Ornament";
						GuiMgr.getInstance().GuiTreasureGift.InitInfomation(strTreasureType, strTreasureName, numTreasure, IconNameFeed, feedType);
						break;
				}				
				//GuiMgr.getInstance().GuiStore.UpdateStore(resultData.Gift[1]["ItemType"], resultData.Gift[1]["ItemId"], numTreasure);
			}
			GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + resultData.Gift[0]["Num"], GameLogic.getInstance().isEventDuplicateExp);			
			//EffectMgr.getInstance().fallFlyXP(CurPos.x, CurPos.y, resultData.Gift[0]["Num"]);
			//GameLogic.getInstance().user.SetUserMoney(GameLogic.getInstance().user.GetMoney() + resultData.Gift[1]["Num"]);			
			//EffectMgr.getInstance().fallFlyMoney(CurPos.x, CurPos.y, resultData.Gift[1]["Num"]);
			EffectMgr.getInstance().fallExpMoneyTreasureEvent(resultData.Gift[0]["Num"],
																resultData.Gift[1]["Num"],
																type,
																getExpPerIcon(),
																getMoneyPerIcon());
			
			resultData = null;
			inEffClick = false;
			//GameLogic.getInstance().user.UpdateStockThing(
			// timer để đóng nắp hòm
			timer.delay = TIME_TO_CLOSE;
			timer.start();
		}
		public function CloseTreasure(e:TimerEvent = null):void 
		{
			if (img && img.parent == null)
			{
				return;
			}
			ClearImage();
			SetDefault();
			//inEffClick = false;
		}
		
		private function SetDefault():void
		{
			status = CLOSE;
			var sType:String = ChangeType(type);
			LoadRes("Treasure" + sType + status);
			switch(type)
			{
				case 1:
					SetPos(590, 530);
					break;
				case 2:
					SetPos(720, 530);
					break;
				case 3:
					SetPos(850, 530);
					break;
			}
		}
		
		public override function OnMouseOver(event:MouseEvent):void 
		{
			/*//code truoc hiển thị dương trong lúc không có event hay chưa đủ level
			if (GameLogic.getInstance().user.GetLevel() < MIN_LEVEL)
			{
				tip.text = Localization.getInstance().getString("Message26").replace("@Level", MIN_LEVEL);				
				ActiveTooltip.getInstance().showNewToolTip(tip, this.img);
				ActiveTooltip.getInstance().setCountDownHide(50);
				ActiveTooltip.getInstance().setCountShow(1);
				return;
			}
			//*/
			switch(status)
			{
				case CLOSE:
				{
					var numKey:int = GameLogic.getInstance().user.GetStoreItemCount(KEY, type);
					if (!inEffClick)
					{
						ShowEffOpen();
						if (numKey > 0)
							GameLogic.getInstance().MouseTransform("MouseKey" + type);
						else
						{
							tip.text = Localization.getInstance().getString("Message27");
							ActiveTooltip.getInstance().showNewToolTip(tip, this.img);
							ActiveTooltip.getInstance().setCountDownHide(50);
							ActiveTooltip.getInstance().setCountShow(1);
						}
					}
					
					break;
				}
				case OPEN:
				{
					break;
				}
			}
		}
		
		public override function OnMouseOut(event:MouseEvent):void
		{
			GameLogic.getInstance().BackToOldMouse();//biến chuột về trạng thái cũ
			ActiveTooltip.getInstance().clearToolTip();
			switch(status)
			{
				case OPEN://đang mở miệng
					ClearImage();
					status = CLOSE;//đóng miệng
					LoadRes("Treasure" + ChangeType(type) + status);//cho về trạng thái ngậm miệng
					break;
				case CLOSE:
					break;
			}
		}
		
		public override function OnMouseClick(event:MouseEvent):void
		{
			//code trước đây hiển thị dương trong lúc không có event hay chưa đủ level
			if (!CheckEvent())//không trong event
			{
				GameLogic.getInstance().BackToIdleGameState();
				GameLogic.getInstance().SetState(GameState.GAMESTATE_ERROR);
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Sự kiện truy tìm báu vật đã kết thúc");
				return;
			}
			//if (GameLogic.getInstance().user.GetLevel() < MIN_LEVEL)
			//{
				//tip.text = Localization.getInstance().getString("Message26").replace("@Level", MIN_LEVEL);
				//ActiveTooltip.getInstance().showNewToolTip(tip, this.img);
				//ActiveTooltip.getInstance().setCountDownHide(50);
				//ActiveTooltip.getInstance().setCountShow(1);
				//return;
			//}
			//*/
			
			if (status == OPEN)
			{//trai đang mở mồm
				var numKey:int = GameLogic.getInstance().user.GetStoreItemCount(KEY, type);
				if (numKey > 0)
				{
					ShowEffClose();
					GameLogic.getInstance().MouseTransform("");
					//Update lại số lượng chìa khóa trong kho
					GuiMgr.getInstance().GuiStore.UpdateStore("Key", type, -1);
					if (GuiMgr.getInstance().GuiStore.IsVisible)
					{
						GuiMgr.getInstance().GuiStore.Hide();
					}
					Exchange.GetInstance().Send(new SendOpenTrunk(type));
				}
			}
		}
		
		private function ShowEffOpen():void
		{
			//bMoveOver = true;
			var sType:String = ChangeType(type);
			var effName:String = "EffOverTreasure" + sType;
			ClearImage();
			status = OPEN;
			LoadRes(effName);
			//thuc hien chay timer de dong lai giong voi opentrunk
			timer.delay = TIME_TO_CLOSE;
			timer.start();
		}
		
		private function ShowEffClose():void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.OBJECT_LAYER);
			inEffClick = true;
			var x:Number = this.img.x;// - layer.x;								//cần phải trừ đi đoạn drag
			var y:Number = this.img.y;// - layer.y;
			ClearImage();
			var sType:String = ChangeType(type);
			var effName:String = "EffCLickTreasure" + sType;
			status = CLOSE;
			effClickTreasure = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER,
																		effName,
																		null,
																		x/* - 273*/, y/* - 140*/,
																		false, false, null, finishEffClose);
			function finishEffClose():void
			{
				//show progess bar
				LoadRes("Treasure" + ChangeType(type) + CLOSE);
				effOpen = EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffProgessBar", null, x + 25, y - 20,
						false, false, null, FinishEffOpen);
			}
		}
		
		private function ChangeType(type:int):String
		{
			switch(type)
			{
				case 1:
					return "Wood";
				case 2:
					return "Silver";
				case 3:
					return "Gold";
			}
			return null;
		}
		
		public static function CheckEvent(nameEvent:String = "IconExchange2"):Boolean
		{
			var event:Object = ConfigJSON.getInstance().GetItemList("Event");
			if (!event[nameEvent])	return false;
			var beginTime:int = event[nameEvent].BeginTime;
			var endTime:int = event[nameEvent].ExpireTime;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			if (curTime >= beginTime && curTime <= endTime && GameLogic.getInstance().user.GetLevel()>=event[nameEvent].LevelRequire)
			{
				return true;
			}
			return false;
		}
		
		private function getMoneyPerIcon():int
		{
			switch(type)
			{
				case 1:
					return 50;
				case 2:
					return 50;
				case 3:
					return 50;
			}
			return 1;
		}
		private function getExpPerIcon():int
		{
			switch(type)
			{
				case 1:
					return 5;
				case 2:
					return 5;
				case 3:
					return 10;
			}
			return 1;
		}
	}

}























