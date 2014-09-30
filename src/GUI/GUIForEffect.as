package GUI 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	import GUI.component.BaseGUI;
	import GUI.component.ProgressBar;
	import GUI.component.SpriteExt;
	import Logic.GameLogic;
	import Logic.GameState;
	import Logic.Layer;
	import Logic.LayerMgr;
	import NetworkPacket.PacketSend.SendLoadInventory;
	import NetworkPacket.PacketSend.SendOpenLixi;
	import particleSys.myFish.CometEmit;
	
	/**
	 * GUI phục vụ cho việc hiển thị effect
	 * @author HiepNM2
	 */
	public class GUIForEffect extends BaseGUI 
	{
		public var isReceiveData:Boolean = false;
		private var data:Object;
		public var emitStar:Array = [];
		
		public var beginPoint:Point;
		public var endPoint:Point;
		public var prg:ProgressBar;
		public var _timer:Timer;
		public var isReceiveData2:Boolean;
		private var dataLx:Object;
		
		public function GUIForEffect(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIForEffect";
		}
		override public function InitGUI():void 
		{
			LoadRes("");
		};
		public function SetForMagicBag(idGift:int, pos:Point):void
		{
			data = new  Object();
			data.idGift = idGift;
			data.pos = pos;
		};
		public function AddEffect():void
		{
			data.pos = new Point(data.pos.x + this.img.x, data.pos.y + this.img.y);
			StartParFromMagicBag(data.idGift, data.pos);
		}
		private function StartParFromMagicBag(idGift:int,pos:Point):void
		{
			//tính vị trí bắt đầu partical nhờ vào vị trí click chuột
			
			//vị trí kết thúc partical
			var med:Point;
			var time:Number = 1;
			var des:Point = new Point(Constant.STAGE_WIDTH / 2 - 26, Constant.STAGE_HEIGHT / 2 - 47);
			var emit:CometEmit = new CometEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));		
			var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;
			sao.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 204, 102, 0);			
			emit.imgList.push(sao);
			emitStar.push(emit);
			med = getThroughPoint(pos, des);
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.TopLayer);
			if (emit)
			{
				layer.stage.addChild(emit.sp);
				emit.sp.x = pos.x;
				emit.sp.y = pos.y;
				TweenMax.to(emit.sp , time, { bezierThrough:[ { x:med.x, y:med.y }, { x:des.x, y:des.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween } );					
			}
			
			function onCompleteTween():void
			{
				if (emit)
				{
					emit.stopSpawn();
				}
				layer.stage.removeChild(emit.sp);		
				ReceiveFromMagicBag(idGift);
			}
		}
		private function ReceiveFromMagicBag(IdGift:int):void
		{
			var curId:int = GuiMgr.getInstance().GuiStore.curId;
			//lấy đồ đó ra
			var Thing:Object = ConfigJSON.getInstance().getItemInfo("MagicBag", curId)["GiftContent"][IdGift];
			//effect Nhận thành công
			//EffectMgr.setEffBounceDown("Nhận thành công", 
										//Thing["ItemType"] + Thing["ItemId"], 
										//Constant.STAGE_WIDTH / 2 - 40, 
										//Constant.STAGE_HEIGHT - 100);
			//Effect mở túi càn khôn :D hehe		
			var sp:SpriteExt = new SpriteExt();
			sp.loadComp = function f():void
			{
				var arr:Array = [];
				sp.img.x = 100;
				sp.img.y = 100;
				arr.push(sp.img);
				EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffOpenMagicBag", arr,
														Constant.STAGE_WIDTH/2 + 260, 
														Constant.STAGE_HEIGHT / 2 + 90, 
														false, false, null, finishOpenMagicBag);					
			}
			sp.loadRes(Thing["ItemType"] + Thing["ItemId"]);
			if (Thing["ItemType"] == "EnergyItem" || Thing["ItemType"] == "RebornMedicine")
			{
				var x:Number = sp.img.x;
				var y:Number = sp.img.y;
				var w:Number = sp.img.width;
				var h:Number = sp.img.height;
				sp.img.x = x-w/2;
				sp.img.y = y-h/2;
			}
			function finishOpenMagicBag():void
			{
				//update vào kho
				//user.UpdateStockThing(Thing["ItemType"], Thing["ItemId"], 1);
				//GuiMgr.getInstance().GuiStore.isProcessedMagicBag = true;
				GuiMgr.getInstance().GuiStore.idGiftMagicBag = 0;
				//GameLogic.getInstance().SetState(GameState.GAMESTATE_IDLE);
				
				if (SuggestFeedOpenMagicBag(curId, IdGift))
				{
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_OPEN_MAGIC_BAG_LUCKY);
				}
				GuiMgr.getInstance().GuiStore.UpdateStore("MagicBag", curId, -1);
				GuiMgr.getInstance().GuiStore.UpdateStore(Thing["ItemType"], Thing["ItemId"], 1);
				GuiMgr.getInstance().GuiStore.isProgressFull = false;
				GuiMgr.getInstance().GuiStore.isHavePrg = false;
				GuiMgr.getInstance().GuiStore.curprgProcessing = null;
				GuiMgr.getInstance().GuiStore.btnID = "MagicBag";
				GuiMgr.getInstance().GuiStore.addAllEvent();
				//isReceiveData = false;
				Hide();
			}
		}
		
		
		private function getThroughPoint(psrc:Point, pdes:Point):Point
		{
			var p:Point = pdes.subtract(psrc);//Vector từ nguồn đến đích
			if (p.y == 0)
				return new Point(p.x/2, 0);
			var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2);//Trung điểm của nguồn và đích
			var v:Point = new Point( -p.y, p.x);//Vector vuông góc với vector(nguồn, đích)
	
			//Random hướng vuông góc
			var n:int = Math.round(Math.random()) * 2 - 1;
			v.x = n*v.x;
			v.y = n*v.y;
			var l:Number = Math.min(120, v.length / 3);
			v.normalize(l);//Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			var result:Point = med.add(v);//Tính ra điểm cần đi xuyên qua
			return result;			
		}
		private function SuggestFeedOpenMagicBag(idMagicBag:int, idGift:int):Boolean
		{
			switch(idGift)
			{
				case 3:
					if (idMagicBag == 1 || idMagicBag == 20 || idMagicBag == 40)
						return true;
				case 4:
					if (idMagicBag == 2 || idMagicBag == 21 || idMagicBag == 41)
						return true;
				case 5:
					if (idMagicBag == 3 || idMagicBag == 22 || idMagicBag == 42)
						return true;
					
				default:
					return false;
			}
			return false;
		}
		
		public function updateParticle():void
		{
			//Update particle
			for (var i:int; i < emitStar.length; i++)
			{
				emitStar[i].updateEmitter();
				if (!emitStar[i].allowSpawn && emitStar[i].particleList.length < 1)
				{
					emitStar[i].destroy();
					emitStar.splice(i, 1);
					i--;					
				};
			};
		};
		/*i come back*/
		public function useLixi(_itemType:String, _itemId:int, pscr:Point, pdes:Point):void
		{
			dataLx = new Object();
			dataLx["Lixi"] = new Object();
			dataLx["Lixi"]["Send"] = new Object();
			dataLx["Lixi"]["Send"]["ItemType"] = _itemType;
			dataLx["Lixi"]["Send"]["ItemId"] = _itemId;
			
			beginPoint = pscr;
			endPoint = pdes;
			sendOpenLixi(_itemType, _itemId);
			showHavePgr();
		};
		private function sendOpenLixi(_itemType:String, _itemId:int):void
		{
			isReceiveData2 = false;
			var cmd:SendOpenLixi = new SendOpenLixi(_itemType, _itemId);
			Exchange.GetInstance().Send(cmd);
		};
		public function showHavePgr():void
		{
			Show(Constant.GUI_MIN_LAYER, 2);
			prg = AddProgress("idprg", "PrgFood", beginPoint.x, beginPoint.y);
			prg.setStatus(0);
			_timer = new Timer(40);
			_timer.addEventListener(TimerEvent.TIMER, onWaitData);
			_timer.start();
		};
		public function receiveLixiHost(data1:Object):void
		{
			trace(data1);
			dataLx["Lixi"]["Receive"] = new Object();
			dataLx["Lixi"]["Receive"] = data1["Equipment"];
			isReceiveData2 = true;
		}
		private function onWaitData(event:Event):void
		{
			var curStatus:Number = prg.GetStatus();
			prg.setStatus(curStatus + 0.015);
			curStatus = prg.GetStatus();
			if (curStatus >= 1)
			{
				if (!isReceiveData2)
				{
					prg.setStatus(0);
				}
				else
				{
					_timer.stop();
					_timer.removeEventListener(TimerEvent.TIMER, onEndPrg);
					function onEndPrg():void { };
					RemoveProgressBar("idprg");
					/*bắt đầu bắn chưởng*/
					fireParticle(beginPoint, endPoint);
				}
			}
		}
		private function fireParticle(scr:Point, des:Point):void
		{
			var med:Point = getThroughPoint(scr, des);
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.TopLayer);
			var time:Number = 1;
			var emit:CometEmit = new CometEmit(layer);
			var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;
			sao.transform.colorTransform = new ColorTransform(0, 0, 0, 1, 255, 204, 102, 0);			
			emit.imgList.push(sao);
			emitStar.push(emit);
			if (emit)
			{
				layer.stage.addChild(emit.sp);
				emit.sp.x = scr.x;
				emit.sp.y = scr.y;
				TweenMax.to(emit.sp , time, { bezierThrough:[ { x:med.x, y:med.y }, { x:des.x, y:des.y } ], ease:Cubic.easeOut, onComplete:onCompleteTween } );					
			}
			/*hoàn thành việc bắn chưởng*/
			function onCompleteTween():void
			{
				if (emit)
				{
					emit.stopSpawn();
				}
				layer.stage.removeChild(emit.sp);		
				/*add function to control when complete bắn chưởng*/
				receiveSomething();
			};
		};
		private function receiveSomething():void
		{
			var idLixi:int = dataLx["Lixi"]["Send"]["ItemId"];
			var typeLixi:String = dataLx["Lixi"]["Send"]["ItemType"];
			var typeEquip:String = dataLx["Lixi"]["Receive"]["Type"];
			var rankEquip:int = dataLx["Lixi"]["Receive"]["Rank"];
			var sp:SpriteExt = new SpriteExt();
			
			sp.loadComp = function f():void
			{
				var arr:Array = [];
				sp.img.x = endPoint.x;
				sp.img.y = endPoint.y;
				arr.push(sp.img);
				EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffOpenMagicBag", arr,
														endPoint.x + 260, 
														endPoint.y + 90, 
														false, false, null, finishEff);					
			}
			sp.loadRes(typeEquip + rankEquip + "_Shop");
			function finishEff():void
			{
				/*hành động khi kết thúc effect pháo hoa*/
				/*ví dụ việc mở túi thì thêm các hành động khi nhận được quà*/
				
				finishOpenLixi(typeLixi,idLixi);
				Hide();
			};
		};
		
		private function finishOpenLixi(_typeLixi:String = "Lixi", _idLixi:int = 1):void
		{
			GuiMgr.getInstance().GuiStore.UpdateStore(_typeLixi, _idLixi, -1);
			var cmd:SendLoadInventory = new SendLoadInventory();
			Exchange.GetInstance().Send(cmd);
		};
	};

}