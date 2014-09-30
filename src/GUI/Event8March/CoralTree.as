package GUI.Event8March 
{
	import Data.ConfigJSON;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import Event.EventMgr;
	import Event.Factory.FactoryLogic.EventSvc;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import GameControl.GameController;
	import GUI.GUIFeedWall;
	import GUI.GUIFrontScreen.GUIFrontScreen;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import Logic.BaseObject;
	import Logic.GameLogic;
	import Logic.GameState;
	import NetworkPacket.PacketSend.SendCareFlower;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class CoralTree extends BaseObject 
	{
		public var OpenBoxNum:int;
		public var MaxNumCare:int;
		public var MaxTimeCare:int;
		private var _priceToSeek:int;
		public var isUnLimitLevel:Boolean = false;
		//public var isSeeking:Boolean = false;//đang tua
		public function set PriceToSeek(value:int):void
		{
			_priceToSeek = value;
		}
		public function get PriceToSeek():int
		{
			return _priceToSeek;
		}
		public var Bonus:Object;
		public var FlowerBonus:Object;
		private var _level:int;
		public var guiTipTree:TooltipTree = new TooltipTree(null, "");//guiTooltip cho mỗi lần di qua cây
		public var guiSeekTime:GUISeekTime = new GUISeekTime(null, "");
		public var CareNum:int;
		public var _speedUpNum:int;
		public var hasHelper:Boolean = false;
		public var heightTree:Object = new Object();
		public var widthTree:Object = new Object();
		public function set SpeedUpLimit(value:int):void
		{
			_speedUpLimit = value;
		}
		public function get SpeedUpLimit():int
		{
			return _speedUpLimit;
		}
		
		private var _speedUpLimit:int;
		public function set SpeedUpNum(value:int):void
		{
			_speedUpNum = value;
		}
		public function get SpeedUpNum():int
		{
			return _speedUpNum;
		}
		
		private var _lastCareTime:Number;
		public var hasSeek:Boolean = false;//sẽ được tính sau khi load game dựa vào _lastCareTime
		public function set LastCareTime(value:Number):void
		{
			_lastCareTime = value;
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:Number = curTime-value;
			if(!isUnLimitLevel)
				hasSeek = (remainTime >= MaxTimeCare);
		}
		public function get LastCareTime():Number
		{
			return _lastCareTime;
		}
		
		public function get Level():int
		{
			return _level;
		}
		public function set Level(value:int):void
		{
			if (value > 7)
			{
				isUnLimitLevel = true;
				value = 7;
			}
			_level = value;
			var config:Object = ConfigJSON.getInstance().getItemInfo("Noel_Tree", value);
			MaxNumCare = config["CareNum"];
			MaxTimeCare = config["CareTime"];
			SpeedUpLimit = config["SpeedUpLimit"];
			PriceToSeek = config["ZMoney"];
			Bonus = config["Bonus"];
			FlowerBonus = config["Flower"];
			guiTipTree.init(this);
			guiSeekTime.init(this);
		}
		
		private static const _x:int = 810;			//tọa độ đối với guimain
		private static const _y:int = 580;
		public function CoralTree(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "MarchFlower";
			//heightTree[1] = 123;		widthTree[1] = 73;
			heightTree[1] = 161;		widthTree[1] = 109;
			heightTree[2] = 206;		widthTree[2] = 166;
			heightTree[3] = 272;		widthTree[3] = 268;
			heightTree[4] = 366;		widthTree[4] = 403;
		}
		/**
		 * move chuột qua "cây hoa": thực hiện hiển thị tooltip
		 * @param	event
		 */
		override public function OnMouseOver(event:MouseEvent):void 
		{
			//SetHighLight();
			guiTipTree.Show();
			var isMe:Boolean = !GameLogic.getInstance().user.IsViewer();
			if (isMe)
			{
				if (canCare() && GameLogic.getInstance().gameState == GameState.GAMESTATE_IDLE)
				{
					GameLogic.getInstance().MouseTransform("EventNoel_ImgBinhNuoc");
				}
			}
			
		}
		/**
		 * di chuột ra khỏi "cây hoa" ẩn tooltip đi
		 * @param	event
		 */
		override public function OnMouseOut(event:MouseEvent):void 
		{
			//SetHighLight( -1);
			guiTipTree.Hide();
			if (canCare() && GameLogic.getInstance().gameState == GameState.GAMESTATE_IDLE)
			{
				GameLogic.getInstance().MouseTransform("");
			}
		}

		override public function OnMouseClick(event:MouseEvent):void 
		{
			if (!GameLogic.getInstance().isEvent(EventMgr.NAME_EVENT))
			{
				GuiMgr.getInstance().GuiMessageBox.ShowOK("Đã hết thời gian diễn ra sự kiện.");	
				guiTipTree.Hide();
				GuiMgr.getInstance().guiFrontScreen.btnEvent.SetVisible(false);
				Destructor();
				return;
			}
			var isMe:Boolean = !GameLogic.getInstance().user.IsViewer();
			if (isMe)
			{
				if (canCare() && GameLogic.getInstance().gameState == GameState.GAMESTATE_IDLE)
				{
					LastCareTime = GameLogic.getInstance().CurServerTime;
					GameLogic.getInstance().MouseTransform("");
					EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER,
														"TuoiNuoc_8_3",
														null,
														event.stageX + 40, event.stageY - 60,
														false, false, null,
														tuoinuocComp);
					function tuoinuocComp():void
					{
						careTree();
					}
					
				}
				else
				{
					guiSeekTime.Show(Constant.GUI_MIN_LAYER, 2);
				}
			}
		}
		/**
		 * vẽ cái cây đó theo cấp của nó
		 */
		private function drawTree():void
		{
			ClearImage();
			var cap:int = _level / 2 + 1;
			LoadRes("CoralTree" + cap.toString());
			SetPos(_x, _y);
			SetAlign(ALIGN_LEFT_BOTTOM);
		}
		override public function SetInfo(data:Object):void 
		{
			this.Level = data["Level"];
			this.CareNum = data["CareNum"];
			this.SpeedUpNum = data["SpeedUpNum"];
			this.LastCareTime = data["LastCareTime"];
			if (data["OpenBoxNum"])
			{
				this.OpenBoxNum = data["OpenBoxNum"];
			}
			else
			{
				this.OpenBoxNum = 0;
			}
			drawTree();
		}
		/**
		 * checck xem cây có thể được chăm sóc hay không
		 * @return
		 */
		public function canCare():Boolean
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var remainTime:Number = curTime-LastCareTime;
			if (/*CareNum == 0 || */(remainTime >= MaxTimeCare || hasSeek) && (Level >=1 && Level <=7) && !isUnLimitLevel)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
		private function careTree():void
		{
			hasHelper = false;
			CareNum++;
			
			hasSeek = false;
			//gửi gói tin
			
			var pk:SendCareFlower = new SendCareFlower();
			Exchange.GetInstance().Send(pk);
			var cap:int = Level / 2 + 1;
			
			
			var xEffThuHoach:Number = img.x;
			var yEffThuHoach:Number = img.y;
			
			//kiểm tra xem cây có lên cấp
			if (CareNum >= MaxNumCare)
			{
				EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER,
													"EffThuHoach",
													null,
													xEffThuHoach, yEffThuHoach,
													false, false, null,
													onCareComp);
				function onCareComp():void
				{
					if (Level >=1 && Level < 4)
					{
						EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER,		//Effect cây lên cấp
														"EffCoralTreeLevelUp",
														null,
														xEffThuHoach, yEffThuHoach,
														false, false, null,
														onCompleteTransform);
					}
					else if(Level >=4&& Level <=7)
					{
						/*EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER,		//Effect cây lên cấp
														"EffCoralTreeLevelUp2",
														null,
														xEffThuHoach - 25, yEffThuHoach + heightTree[cap]/2);*/
						EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER,		//Effect cây lên cấp
														"EffCoralTreeLevelUp2",
														null,
														xEffThuHoach - 25,yEffThuHoach + heightTree[cap]/2,
														false, false, null,
														onCompleteTransform);
					}
					else
					{
						return;
					}
				}
				
				function onCompleteTransform():void
				{
					Level++;
					CareNum = 0;
					drawTree();
					//trace("feed cây lên cấp");
					if (!isUnLimitLevel)
						GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_EVENT_8_3_LEVELUP);
				}
			}
			else
			{
				EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffThuHoach", null, xEffThuHoach, yEffThuHoach);
			}
		}
		
		public function fallBonus(data:Object):void
		{
			//rơi ra quà chắc chắn có data["Bonus"][1] là Money data["Bonus"][2] là Exp thực hiện + cho user
			var money:int = data["Bonus"][1]["Num"];
			var exp:int = data["Bonus"][2]["Num"];
			EffectMgr.getInstance().fallExpMoney(exp, money, new Point(_x, _y), 50, 50);
			if (data["LuckyBonus"])
			{
				var id:int, num:int;
				for (var i:String in data["LuckyBonus"])
				{
					id = data["LuckyBonus"][i]["ItemId"];
					num = data["LuckyBonus"][i]["Num"];
					EventSvc.getInstance().updateItem(data["LuckyBonus"][i]["ItemType"], id, num);
					//GameLogic.getInstance().user.UpdateStockThing(data["LuckyBonus"][i]["ItemType"], id, num);
					//EffectMgr.getInstance().fallArrow(num, id,  new Point(_x, _y), 1);
					fallFlower(id, _x, _y, num);
				}
			}
		}
		private function fallFlower(id:int, xsrc:int, ysrc:int, num:int):void
		{
			var guiTop:GUIFrontScreen = GuiMgr.getInstance().guiFrontScreen;
			var pos:Point = new Point(guiTop.btnEvent.img.x, guiTop.btnEvent.img.y);
			pos = guiTop.img.localToGlobal(pos);
			//EffectMgr.getInstance().fallFly(Constant.OBJECT_LAYER, "EventNoel_ColPItem" + id, xsrc, ysrc, GameController.getInstance().GetLakeBottom() - (50 + Math.random()*30),  pos.x, pos.y, null, num, true);
			EffectMgr.getInstance().fallFlower(num,id, new Point(xsrc, ysrc), 1);
		}
		public function addHelper():void
		{
			var sp:Sprite = ResMgr.getInstance().GetRes("IcHelper") as Sprite;
			sp.name = "HelperTree";
			this.img.addChild(sp);
			//sp.y = 0;
			hasHelper = true;
		}
		public function removeHelper():void
		{
			var sp:Sprite = this.img.getChildByName("HelperTree") as Sprite;
			if(sp)
				this.img.removeChild(sp);
			//hasHelper = false;
		}
	}
}