package Effect 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Circ;
	import com.greensock.easing.Cubic;
	import com.greensock.loading.core.DisplayObjectLoader;
	import com.greensock.plugins.AutoAlphaPlugin;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import Data.ResMgr;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventLuckyMachine.EventLuckyMachineMgr;
	import Event.Factory.FactoryLogic.EventSvc;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GameControl.GameController;
	import GUI.ChampionLeague.LogicLeague.LeagueController;
	import GUI.component.Image;
	import GUI.EventBirthDay.EventLogic.BirthDayItemMgr;
	import GUI.FishWorld.GUIMainFishWorld;
	import GUI.GUIFrontScreen.GUIFrontScreen;
	import GUI.GUIFrontScreen.GUIUserInfo;
	import GUI.GuiMgr;
	import GUI.GUITopInfo;
	import GUI.TrainingTower.TrainingGUI.GUITrainingTower;
	
	import Logic.BaseObject;
	import Logic.Layer;
	import Logic.LayerMgr;
	import Logic.MotionObject;
	import Logic.Ultility;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author ducnh
	 */
	public class EffectMgr
	{
		private static var instance:EffectMgr = new EffectMgr;
		
		public static const IMG_EFF_BLINK:int = 1;
		public static const IMG_EFF_BUBLE:int = 2;
		public static const IMG_EFF_FLY:int = 3;
		public static const EFF_MOVE_FISH:int = 4;
		public static const EFF_SCALE_DOWN:int = 5;
		public static const EFF_SUCCESS:int = 6;
		
		private var ImgEffArr:Array = [];
		private var SwfEffArr:Array = [];
		private var BmEffArr:Array = [];
		private var SwfEff1Arr:Array = [];
		public static var rippler:Rippler;
		
		public var motionArr:Array = [];
		
		//Mỗi phần tử mảng lưu thông tin về vị trí, thời gian, số lượng rơi ra của tiền, kinh nghiệm: time, pos, expNum, moneyNum;
		public var motionInfo:Array = [];
		public var lastPushTime:Number = 0;
		public var expIconNum:int = 0;
		public var moneyIconNum:int = 0;
		
		
		public static function getInstance():EffectMgr
		{
			if(instance == null)
			{
				instance = new EffectMgr();
			}
			
			return instance;
		}
		
		public function EffectMgr() 
		{
			
		}
		
		public function UpdateAllEffect():void
		{
			var i:int;
			var imgEff:ImageEffect;
			var swfEff:SwfEffect;
			var bmEff:BitmapEffect;
			var swfEff1:SwfEffect1;
			for (i = 0; i < ImgEffArr.length; i++)
			{
				imgEff = ImgEffArr[i] as ImageEffect;
				imgEff.UpdateEffect();
				if (imgEff.IsFinish)
				{
					if (imgEff.CallBack != null)
					{
						imgEff.CallBack();
						imgEff.CallBack = null;
					}
					ImgEffArr.splice(i, 1);
					i = i - 1;
				}
			}
			
			for (i = 0; i < SwfEffArr.length; i++)
			{
				swfEff = SwfEffArr[i] as SwfEffect;
				swfEff.UpdateEffect();
				if (swfEff.IsFinish)
				{
					SwfEffArr.splice(i, 1);
					i = i - 1;
				}
			}
			
			for (i = 0; i < BmEffArr.length; i++)
			{
				bmEff = BmEffArr[i] as BitmapEffect;
				bmEff.UpdateEffect();
				if (bmEff.IsFinish)
				{
					BmEffArr.splice(i, 1);
					i = i - 1;
				}
			}
			
			for (i = 0; i < SwfEff1Arr.length; i++)
			{
				swfEff1 = SwfEff1Arr[i] as SwfEffect1;
				swfEff1.UpdateEffect();
				if (swfEff1.IsFinish)
				{
					SwfEff1Arr.splice(i, 1);
					i = i - 1;
				}
			}
			
			//Update những đối tượng motion object như tiền, kinh nghiệm
			for (i = 0; i < motionInfo.length; i++ )
			{
				var data:Object = motionInfo[i];
				//Rơi kinh nghiệm
				if(data.expNum > 0)
				{
					if (GameLogic.getInstance().CurServerTime > data.time + 0.02)
					{
						if (data.expNum != 1)
						{
							fallFlyXP(data.pos.x, data.pos.y, data.e, true);
						}
						else
						{
							fallFlyXP(data.pos.x, data.pos.y, data.lastExp, true);
						}
						
						data.time += 0.02; 
						data.expNum--;						
					}
				}
				
				//Rơi tiền
				if(data.moneyNum > 0)
				{
					if (GameLogic.getInstance().CurServerTime > data.time + 0.02)
					{
						if (data.moneyNum != 1)
						{
							fallFlyMoney(data.pos.x, data.pos.y, data.g);	
						}
						else
						{
							fallFlyMoney(data.pos.x, data.pos.y, data.lastGold);
						}
						
						data.time += 0.02;
						data.moneyNum--;						
					}
				}			
				
				// Roi mui ten trong event hoa mua thu
				var guiTop:GUIFrontScreen;
				var pos1:Point;
				if (data.flowerNum > 0)
				{
					if (GameLogic.getInstance().CurServerTime > data.time + 0.02)
					{
						guiTop = GuiMgr.getInstance().guiFrontScreen;
						pos1 = new Point(25, 320);
						//fallFly(Constant.OBJECT_LAYER, "EventLuckyMachine_Ticket1", data.pos.x, data.pos.y,
						//fallFly(Constant.OBJECT_LAYER, "IslandItem15" + data.id, data.pos.x, data.pos.y,
						fallFly(Constant.OBJECT_LAYER, "GuiHalloween_HalItem" + data.id, data.pos.x, data.pos.y,
						//fallFly(Constant.OBJECT_LAYER, "EventNoel_Candy" + data.id, data.pos.x, data.pos.y,
						//fallFly(Constant.OBJECT_LAYER, "GUIGameEventMidle8_Arrow" + data.id, data.pos.x, data.pos.y,
								GameController.getInstance().GetLakeBottom() - (50 + Math.random() * 30), 
								25, 100, 
								null, data.lastFlower, true);
						data.time += 0.02;
						data.flowerNum--;
						//GuiMgr.getInstance().GuiStore.UpdateStore("Arrow", data.id, 1);	//StoneMaze
						//GuiMgr.getInstance().GuiStore.UpdateStore("Island_Item", 15, 1);	//TreasureIsland
						//EventLuckyMachineMgr.getInstance().updateTicket(1);					//EventLuckyMachine
						//EventSvc.getInstance().updateItem("Candy", data.id, 1);	//FishHunter
						HalloweenMgr.getInstance().updateRockStore(data.id, 1);	//Thạch bảo đồ
					}
				}
				
				//Tiền và kinh nghiệm rơi hết ra thì remove thông tin đi
				if (data.expNum + data.moneyNum <= 0)
					motionInfo.splice(motionInfo.indexOf(data), 1);
			}
			
			//Update quá trình bay lượn của tiền, exp
			for (i = 0; i < motionArr.length; i++)
			{
				var motion:MotionObject = motionArr[i];
				motion.updateMotionObj();	
				switch(motion.MotionState)
				{
					case MotionObject.MOTION_CURVE:
						if (!motion.DesPos.equals(motion.desPosOnStage))
						{
							motion.DesPos = Ultility.PosScreenToLake(motion.desPosOnStage.x, motion.desPosOnStage.y);
							var curPos:Point = Ultility.PosLakeToScreen(motion.CurPos.x, motion.CurPos.y);
							var temp:Point = new Point();
							temp.x = curPos.x - motion.desPosOnStage.x;
							temp.y = curPos.y - motion.desPosOnStage.y;
							if (temp.length < 200)
							{
								motion.friction = 0.83;
								
								//Đổi lên layer trên để image nằm trên thanh topinfo
								if (motion.Parent != LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER))
								{
									motion.ChangeLayer(Constant.GUI_MIN_LAYER);
									var pos:Point = Ultility.PosLakeToScreen(motion.CurPos.x, motion.CurPos.y);
									motion.SetPos(pos.x, pos.y);
									motion.DesPos.x = motion.desPosOnStage.x;
									motion.DesPos.y = motion.desPosOnStage.y;									
								}
							}
						}
					break;
				}
			}			
		}
		
		public function AddSwfEffect(iLayer:int, swfName:String, ChildList:Array = null, x:Number = 0, y:Number = 0, reUse:Boolean = false, IsLoop:Boolean = false, ObjUse:BaseObject = null, f:Function = null):SwfEffect
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(iLayer);
			var swfEff:SwfEffect = SwfEffect.createSwf(layer, swfName, ChildList, x, y, reUse, IsLoop, ObjUse, f);
			SwfEffArr.push(swfEff);
			return swfEff;
		}
		
		public function runSwfEff(parent:DisplayObject, swfName:String, x:Number, y:Number, completeFunction:Function = null):SwfEffect
		{
			var swfEff:SwfEffect = new SwfEffect(parent, swfName, null, x, y, false, false, null, completeFunction);
			SwfEffArr.push(swfEff);
			return swfEff;
		}
		
		public function AddBitmapEffect(iLayer:int, swfName:String, x:Number = 0, y:Number = 0, reUse:Boolean = false, IsLoop:Boolean = false, f:Function = null):BitmapEffect
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(iLayer);
			var bEff:BitmapEffect = new BitmapEffect(layer, swfName, x, y, reUse, IsLoop, f);
			BmEffArr.push(bEff);
			return bEff;
		}
		
		public function AddSwfEffect1(iLayer:int, swfName:String, NumMovieChild:int = 0, FrameChildStop:Array = null, x:Number = 0, y:Number = 0, reUse:Boolean = false, IsLoop:Boolean = false, ObjUse:BaseObject = null, f:Function = null):SwfEffect1
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(iLayer);
			var swfEff1:SwfEffect1 = new SwfEffect1(layer, swfName, NumMovieChild, FrameChildStop, x, y, reUse, IsLoop, ObjUse, f);
			SwfEff1Arr.push(swfEff1);
			return swfEff1;
		}
		
		public function AddImageEffect(EffName:int, img:DisplayObject, parent:DisplayObject = null, f:Function = null):ImageEffect
		{
			var vt:int = -1;
			var kq:ImageEffect = null;
			switch (EffName)
			{
				case IMG_EFF_BLINK:				
					vt = ImgEffArr.push(new ImgEffectBlink(img));
					vt = ImgEffArr.length - 1;
					break;
				case IMG_EFF_BUBLE:
					vt = ImgEffArr.push(new ImgEffectBuble(img));
					vt = ImgEffArr.length - 1;
					break;
				case IMG_EFF_FLY:
					vt = ImgEffArr.push(new ImgEffectFly(img, parent, f));
					vt = ImgEffArr.length - 1;
					break;
				case EFF_SCALE_DOWN:
					vt = ImgEffArr.push(new ImgEffectScaleDown(img));
					vt = ImgEffArr.length - 1;
					break;
				case EFF_SUCCESS:
					vt = ImgEffArr.push(new ImgEffectScaleDown(img));
					vt = ImgEffArr.length - 1;
					break;
			}
			
			if (vt >= 0)
			{
				kq = ImgEffArr[vt] as ImageEffect;
			}
			return kq;
		}		
		
		/**
		 * Tạo effect tiền rơi, kinh nghiệm rơi
		 * @param	imageName		tên ảnh
		 * @param	xsrc			tọa độ x của vị trí bắt đầu
		 * @param	ysrc			tọa độ y của vị trí bắt đầu
		 * @param	ydestFall		tọa độ y của điểm sẽ rơi xuống
		 * @param	xdestFly		tọa độ x của điểm sẽ bay tới
		 * @param	ydestFly		tọa độ y của điểm sẽ bay tới
		 * @param	img				ảnh sẽ bay lên khi đối tượng bắt đầu bay theo đường cong
		 */
		public function fallFly(iLayer:int, imageName:String, xsrc:int, ysrc:int, ydestFall:int, xdestFly:int, ydestFly:int, img:Sprite = null, num: int = 0, setExp: Boolean = false):void
		{
			var motion:MotionObject;
			if (setExp)
			{
				motion = new MotionObject(LayerMgr.getInstance().GetLayer(iLayer), imageName, xsrc, ysrc, true, Image.ALIGN_LEFT_TOP, num);			
			}
			else 
			{
				motion = new MotionObject(LayerMgr.getInstance().GetLayer(iLayer), imageName, xsrc, ysrc, true, Image.ALIGN_LEFT_TOP, 0);			
			}
			motionArr.push(motion);
			if (imageName == "IcGold")
			{
				motion.setScale(1.25, 1.25);
			}
					
			motion.fall(ydestFall, 3.5, 7 + Math.random() * 5);
			motion.finishMotion = function():void { complete(motion.MotionState) };
			function complete(motionState:int):void
			{
				if (motion.img == null) return;
				var curExp:int = GameLogic.getInstance().user.GetExp();
				
				switch(motionState)
				{
					case MotionObject.MOTION_FALL:
						//Effect										
						var pos:Point = Ultility.PosLakeToScreen(motion.CurPos.x, motion.CurPos.y);
						if (img != null)
						{
							var eff1:ImgEffectFly = AddImageEffect(EffectMgr.IMG_EFF_FLY, img) as ImgEffectFly;
							eff1.SetInfo(pos.x , pos.y , pos.x, pos.y - 35, 7, -0.035);
						}
					
						
						//Bay lượn						
						var dir:int = pos.x < 300 ? 1 : -1;
						if (GameController.getInstance().typeFishWorld > Constant.TYPE_MYFISH)
						{
							dir = 0;
						}
						pos = Ultility.PosScreenToLake(xdestFly, ydestFly);
						motion.curve(pos.x, pos.y, dir, 0, 8);
						motion.desPosOnStage = new Point(xdestFly, ydestFly);
						break;
						
					case MotionObject.MOTION_CURVE:
						motion.roomOut(0.2, 1.7, -0.04);
						if (imageName == "IcGold")
						{
							GameLogic.getInstance().user.UpdateUserMoney(motion.num);
							motion.num = 0;
						}
						else if (imageName == "IconEnergy")
						{
							GameLogic.getInstance().user.PlusEnergy(num);
						}
						else if (imageName == "ImgEXP" && setExp)
						{
							GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + motion.num, GameLogic.getInstance().isEventDuplicateExp, setExp);
							motion.num = 0;
						}
						break;
						
					case MotionObject.MOTION_ROOM_OUT:
						motion.removeSelf();
						motionArr.splice(motionArr.indexOf(motion), 1);					
						break;
				}				
			}			
		}	
		
		/**
		 * Hàm thực hiện effect rơi Gift rồi bay về topGUI
		 * @param	xsrc 	tọa độ x bắt đầu
		 * @param	ysrc	Tọa độ y bắt đầu
		 * @param	num		Số effect cần hiện
		 */
		public function fallFlyEnergy(xsrc:int, ysrc:int, num:int):void
		{
			if (num <= 0 ) return;
			var guiUserInfo:GUIUserInfo= GuiMgr.getInstance().guiUserInfo;
			var pos:Point = new Point(guiUserInfo.txtEnergy.x, guiUserInfo.txtEnergy.y);
			pos = guiUserInfo.img.localToGlobal(pos);
			fallFly(Constant.DIRTY_LAYER, "IconEnergy", xsrc, ysrc, GameController.getInstance().GetLakeBottom() - (50 + Math.random() * 30),  pos.x, pos.y, null, num);
		}
		
		/**
		 * Hàm thực hiện effect rơi Gift rồi bay về topGUI
		 * @param	xsrc 	tọa độ x bắt đầu
		 * @param	ysrc	Tọa độ y bắt đầu
		 * @param	num		Số effect cần hiện
		 */
		public function fallFlyScoreInFishWorld(xsrc:int, ysrc:int, num:int):void
		{
			if (num <= 0 ) return;
			
			var guiMainFishWorld:GUIMainFishWorld = GuiMgr.getInstance().GuiMainFishWorld;
			var pos:Point = new Point(guiMainFishWorld.iconLogoFishWorld.img.x, guiMainFishWorld.iconLogoFishWorld.img.y);
			pos = guiMainFishWorld.img.localToGlobal(pos);
			fallFly(Constant.DIRTY_LAYER, "IcFishWorld_0", xsrc, ysrc, GameController.getInstance().GetLakeBottom() - (80 + Math.random() * 40),  pos.x, pos.y, null, num);
		}
		
		/**
		 * Hàm thực hiện effect rơi EXP rồi bay về topGUI
		 * @param	xsrc 	tọa độ x bắt đầu
		 * @param	ysrc	Tọa độ y bắt đầu
		 * @param	num		Số effect cần hiện
		 */
		public function fallFlyXP(xsrc:int, ysrc:int, num:int, setExp: Boolean = false):void
		{
			if (num <= 0 ) return;
			if(setExp)	
			{
				GameLogic.getInstance().user.ExpWillBeAddLater();
			}
			var st:String = "+" + num;
			var txtFormat:TextFormat = new TextFormat("Arial", 18, 0xffffff, true);
			txtFormat.color = 0x00FFFF;
			txtFormat.font = "SansationBold";
			txtFormat.align = "left"
			var tmp:Sprite = Ultility.CreateSpriteText(st, txtFormat, 6, 0x293661, true);
			var icon:Sprite = ResMgr.getInstance().GetRes("ImgEXP") as Sprite;
			icon.scaleX = icon.scaleY = 0.55;
			
			var guiUserInfo:GUIUserInfo = GuiMgr.getInstance().guiUserInfo;
			var pos:Point = new Point(guiUserInfo.txtExp.x, guiUserInfo.txtExp.y);
			pos = guiUserInfo.img.localToGlobal(pos);
			if (LeagueController.getInstance().mode == LeagueController.IN_HOME)
			{
				fallFly(Constant.OBJECT_LAYER, "ImgEXP", xsrc, ysrc, GameController.getInstance().GetLakeBottom() - (80 + Math.random() * 40),  pos.x, pos.y, null, num, setExp);				
			}
			else 
			{
				GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + num);
			}
		}
		
		/**
		 * Hàm thực hiện effect rơi Money rồi bay về topGUI
		 * @param	xsrc 	tọa độ x bắt đầu
		 * @param	ysrc	Tọa độ y bắt đầu
		 * @param	num		Số effect cần hiện
		 */
		public function fallFlyMoney(xsrc:int, ysrc:int, num:int):void
		{
			if (num <= 0 ) return;
			var guiUserInfo:GUIUserInfo= GuiMgr.getInstance().guiUserInfo;
			var pos:Point = new Point(guiUserInfo.txtMoney.x - 24, guiUserInfo.txtMoney.y - 3);
			pos = guiUserInfo.img.localToGlobal(pos);
			fallFly(Constant.OBJECT_LAYER, "IcGold", xsrc, ysrc, GameController.getInstance().GetLakeBottom() - (50 + Math.random()*30),  pos.x, pos.y, null, num, true);
		}
		
		public static function setEffBounceDown(msg:String, imageName:String, xdes:int, ydes:int, func:Function = null, num:int = 0):void
		{
			//Hiện thông báo mua thành công
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
			var thongbao:MovieClip = new MovieClip();
			thongbao.x = xdes;
			thongbao.scaleX = thongbao.scaleY = 1.5;
			var image:Image = new Image(thongbao, imageName, 20, 0);
			image.FitRect(100, 100, new Point(0, 0));
			image.GoToAndStop(0);
			image.img.mouseEnabled = false;
			var txt:TextField = new TextField();
			txt.mouseEnabled = false;
			txt.text = msg;
			txt.x = 0;
			txt.y = -10;	
			txt.autoSize = TextFieldAutoSize.CENTER;
			var fmt:TextFormat = new TextFormat("Arial");
			fmt.size = 24;
			fmt.bold = true;
			fmt.color = 0xfff100;
			txt.setTextFormat(fmt);
			var glow:GlowFilter = new GlowFilter(0x97751e, 1, 6, 6, 10);
			txt.filters = [glow];
			thongbao.addChild(txt);
			if (num > 0)
			{
				txt = new TextField();
				txt.mouseEnabled = false;
				txt.text = "x" + Ultility.StandardNumber(num);
				txt.x = 80;
				txt.y = 60;
				txt.autoSize = TextFieldAutoSize.LEFT;
				fmt = new TextFormat("Arial");
				fmt.size = 19;
				fmt.bold = true;
				fmt.color = 0xffffff;
				txt.setTextFormat(fmt);
				glow = new GlowFilter(0x000000, 1, 6, 6, 10);
				txt.filters = [glow];
				thongbao.addChild(txt);
			}
			txt.mouseEnabled = false;
			thongbao.mouseEnabled = false;
			thongbao.mouseChildren = false;
			layer.addChild(thongbao);
			TweenLite.to(thongbao, 1, { x:xdes, y:ydes, ease:Bounce.easeOut, onComplete:autoAlpha } );			
			function autoAlpha():void
			{
				image.GoToAndPlay(0);
				var movieClip:MovieClip = image.img as MovieClip;
				if(movieClip != null)
				{
					var totalFrame:int = movieClip.totalFrames;
					var time:Number = totalFrame / 30;
					TweenLite.to(thongbao, time, { autoAlpha:1, onComplete:removeSelf } );
				}
				else
				{
					TweenLite.to(thongbao, 0.8, { autoAlpha:0, onComplete:removeSelf } );
				}
			}
			function removeSelf():void
			{
				layer.removeChild(thongbao);				
				if (func != null)
				{
					func();
				}
			}
		}
		/**
		 * Hàm thực hiện cho show ra numStar ngôi sao ứng với numExp
		 * @param	numExp
		 * @param	numStar
		 */
		public function fallFlyEXPToNumStar(numExp:int, numStar:int):void 
		{
			var numElement:int;
			if (numStar > numExp)
			{
				numStar = numExp;
			}
			numElement = Math.floor(numExp / numStar);
			for (var i:int = 0; i < numStar; i++) 
			{
				var numShow:int = numElement;
				if (i == numStar - 1)	numShow = numExp - (numStar - 1) * numElement;
				
				EffectMgr.getInstance().fallFlyXP(Constant.MAX_WIDTH / 2, GameController.getInstance().GetLakeTop(), numShow, true);
			}
		}
		//Event click tien ca
		public function fallExpMoneyClickEvent(Exp:int, Money:int):void
		{
			var data:Object = new Object();
			data.expNum = Exp / 5;
			data.moneyNum = Money / 50;
			data.time = GameLogic.getInstance().CurServerTime;
			data.pos = new Point(GuiMgr.getInstance().GuiTienCa.CurPos.x - 20, GuiMgr.getInstance().GuiTienCa.CurPos.y - 60);
			motionInfo.push(data);
			
			expIconNum = Exp / 5;
			moneyIconNum = Money / 50;
			lastPushTime = GameLogic.getInstance().CurServerTime;
		}
		
		//event Treasure2
		public function fallExpMoneyTreasureEvent(Exp:int, Money:int,type:int, e:int, g:int):void
		{
			var data:Object = new Object();
			data.expNum = Exp / e;
			data.moneyNum = Money / g;
			data.time = GameLogic.getInstance().CurServerTime;
			switch(type)
			{
				case 1:
					data.pos = new Point(670, 570);
					break;
				case 2:
					data.pos = new Point(770, 570);
					break;
				case 3:
					data.pos = new Point(870, 570);
					break;
			}
			motionInfo.push(data);
			
			expIconNum = Exp / e;
			moneyIconNum = Money / g;

			lastPushTime = GameLogic.getInstance().CurServerTime;
		}
		
		public function fallFlower(flower:int,id:int, pos:Point, f:int = 1):void
		{
			var data:Object = new Object();
			data.id = id;
			data.flowerNum = flower / f;
			data.time = GameLogic.getInstance().CurServerTime;
			data.pos = pos;
			motionInfo.push(data);
			data.lastFlower = f;
			lastPushTime = GameLogic.getInstance().CurServerTime;
		}
		
		public function fallArrow(arrow:int,id:int, pos:Point, f:int = 1):void
		{
			var data:Object = new Object();
			data.id = id;
			data.arrowNum = arrow / f;
			data.time = GameLogic.getInstance().CurServerTime;
			data.pos = pos;
			motionInfo.push(data);
			data.lastArrow = f;
			lastPushTime = GameLogic.getInstance().CurServerTime;
		}
		
		public function fallItemAutumn(type:String,id:int, numItem:int, pos:Point, i:int = 1):void
		{
			var data:Object = new Object();
			data.type = type;
			data.id = id;
			data.itemAutumnNum = numItem / i;
			data.time = GameLogic.getInstance().CurServerTime;
			data.pos = pos;
			motionInfo.push(data);
			data.lastItemAutumn = i;
			lastPushTime = data.time;
		}
		/**
		 * cho rơi ra điểm ngư mạch và chiến công cho gui luyện
		 * @author HiepNM2
		 * @param	Meridian : số điểm ngư mạch
		 * @param	pos : vị trí phọt ra
		 * @param	m : giá trị 1 điểm ngư mạch
		 */
		public function fallMeridian(Meridian:int, pos:Point, m:int):void 
		{
			var data:Object = new Object();
			data.meridianNum = Math.ceil(Meridian / m);
			data.time = GameLogic.getInstance().CurServerTime;
			data.lastMeridian = m;
			data.pos = pos;
			motionInfo.push(data);
			lastPushTime = GameLogic.getInstance().CurServerTime;
		}
		/**
		 * cho rơi ra điểm ngư mạch và chiến công cho gui luyện
		 * @author HiepNM2
		 * @param	RankPoint : số điểm ngư mạch
		 * @param	pos : vị trí phọt ra
		 * @param 	r : giá trị 1 điểm ngư mạch
		 */
		public function fallRankPoint(RankPoint:int, pos:Point, r:int):void 
		{
			var data:Object = new Object();
			data.RankPoint = Math.ceil(RankPoint / r);
			data.time = GameLogic.getInstance().CurServerTime;
			data.lastRankPoint = r;
			data.pos = pos;
			motionInfo.push(data);
			lastPushTime = GameLogic.getInstance().CurServerTime;
		}
		
		/**
		 * 
		 * @param	Exp		:	số kinh nghiệm ứng với số ngôi sao rơi ra
		 * @param	Money	: 	số tiền ứng với số đồng tiền rơi ra
		 * @param	pos		:	Vị trí phọt ra
		 * @param	e		: 	trị giá max của 1 ngôi sao
		 * @param	g		:	trị giá tiền max của 1 đồng tiền
		 */
		public function fallExpMoney(Exp:int, Money:int, pos:Point, e:int, g:int):void
		{
			var data:Object = new Object();
			data.expNum = Math.ceil(Exp / e);
			data.moneyNum = Math.ceil(Money / g);
			
			if (data.expNum > Constant.MAX_NUM_DROP)
			{
				e = Math.ceil(Exp / Constant.MAX_NUM_DROP);
				data.expNum = Math.ceil(Exp / e);
			}
			
			if (data.moneyNum > Constant.MAX_NUM_DROP)
			{
				g = Math.ceil(Money / Constant.MAX_NUM_DROP);
				data.moneyNum = Math.ceil(Money / g);
			}
			
			data.time = GameLogic.getInstance().CurServerTime;
			data.lastExp = Exp % e;
			data.lastGold = Money % g;
			if (data.lastExp == 0) data.lastExp = e;
			if (data.lastGold == 0) data.lastGold = g;
			data.e = e;
			data.g = g;
			data.pos = pos;

			motionInfo.push(data);
			
			expIconNum = Math.ceil(Exp / e);
			moneyIconNum = Math.ceil(Money / g);

			lastPushTime = GameLogic.getInstance().CurServerTime;
		}
		
		/**
		 * 
		 * @param	Exp		:	số kinh nghiệm ứng với số ngôi sao rơi ra
		 * @param	Money	: 	số tiền ứng với số đồng tiền rơi ra
		 * @param	pos		:	Vị trí phọt ra
		 * @param	e		: 	trị giá max của 1 ngôi sao
		 * @param	g		:	trị giá tiền max của 1 đồng tiền
		 */
		public function fallExpMoneyToNumStar(Exp:int, Money:int, pos:Point, numStar:int = 5, numIconMoney:int = 5):void
		{
			var e:int = Math.ceil(Exp / numStar);
			var g:int = Math.ceil(Money / numIconMoney);
			var data:Object = new Object();
			data.expNum = numStar;
			data.moneyNum = numIconMoney;
			
			data.time = GameLogic.getInstance().CurServerTime;
			data.lastExp = Exp % e;
			data.lastGold = Money % g;
			if (data.lastExp == 0) data.lastExp = e;
			if (data.lastGold == 0) data.lastGold = g;
			data.e = e;
			data.g = g;
			data.pos = pos;

			motionInfo.push(data);
			
			expIconNum = numStar;
			moneyIconNum = numIconMoney;

			lastPushTime = GameLogic.getInstance().CurServerTime;
		}
		
		public function reset():void
		{
			//Xoa nguyen lieu
			for (var i:int = 0; i < motionArr.length; i++)
			{
				var mo:MotionObject = motionArr[i] as MotionObject;
				if (mo.num > 0)
				{
					if(mo.ImgName == "ImgEXP")
					{
						GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + mo.num);
					}
					if (mo.ImgName == "IcGold")
					{
						GameLogic.getInstance().user.UpdateUserMoney(mo.num);
					}
				}
				mo.removeSelf();
			}
			motionArr.splice(0, motionArr.length);
		}
		
		/**
		 * Lấy exp trong motionArr(exp được đặt trong queue, khi nào bay tới thanh top bar mới được cộng)
		 */
		public function getExpFromQueue():Number
		{
			var exp:Number = 0;
			for (var i:int = 0; i < motionArr.length; i++)
			{
				var mo:MotionObject = motionArr[i] as MotionObject;
				if (mo.num > 0 && mo.ImgName == "ImgEXP")
				{
					exp += mo.num;
				}
			}
			return exp;
		}		
		
		public function textFly(text:String, p:Point, txtFormat:TextFormat = null, parent:DisplayObject = null, dx:int = 0, dy:int = -50, speed:int = 1):void
		{
			if (txtFormat == null)
			{
				txtFormat = new TextFormat("Arial", 24, 0xffff00, true);
				txtFormat.align = "center";
			}
			
			var tmp1:Sprite = Ultility.CreateSpriteText(text, txtFormat, 6, 0x293661);
			
			// Kiểm tra chữ có bị ăn ra ngoài màn hình ko, nếu có ăn ra nòoài thì align lại txtFormat
			if (!GuiMgr.IsFullScreen && Constant.STAGE_WIDTH < GameInput.getInstance().MousePos.x + tmp1.width + 10)
			{
				txtFormat.align = "right";
				tmp1 = Ultility.CreateSpriteText(text, txtFormat, 6, 0x293661);
			}
			
			var eff1:ImgEffectFly = EffectMgr.getInstance().AddImageEffect(EffectMgr.IMG_EFF_FLY, tmp1, parent) as ImgEffectFly;
			eff1.SetInfo(p.x, p.y, p.x + dx, p.y + dy, speed);
		}
		
		/**
		 * Effect tạo effect chữ bay đi bay về
		 * @param	text		: nội dung
		 * @param	parent		: chữ này dc add vào đâu
		 * @param	p0			: tọa độ ban đầu trên parent
		 * @param	pmax		: tọa độ điểm giữa (cực đại)
		 * @param	pdes		: tọa độ điểm cuối (kết thúc)
		 * @param	timemax		: thời gian đến cực đại
		 * @param	timeDes		: thời gian đến đích
		 * @param	txtFormat	: format text
		 */
		public function textBack(text:String, parent:Sprite, p0:Point, pmax:Point, pdes:Point, timemax:Number, timeDes:Number, txtFormat:TextFormat = null):void
		{
			if (txtFormat == null)
			{
				txtFormat = new TextFormat("Arial", 24, 0x00ff00, true);
				txtFormat.align = "center";
			}
			
			var tmpl:Sprite = Ultility.CreateSpriteText(text, txtFormat, 6, 0x293661);
			tmpl.x = p0.x;
			tmpl.y = p0.y;
			parent.addChild(tmpl);
			TweenLite.to(tmpl, timemax, { x:pmax.x, y:pmax.y, ease:Cubic.easeOut, onComplete:onFinishTween1, onCompleteParams:[parent, tmpl, pdes, timeDes] } );
		}
		
		/**
		 * Tương tự hàm textBack, tạo effect với 1 sprite
		 * @param	s
		 * @param	parent
		 * @param	p0
		 * @param	pmax
		 * @param	pdes
		 * @param	timemax
		 * @param	timeDes
		 */
		public function flyBack(s:Sprite, parent:Sprite, p0:Point, pmax:Point, pdes:Point, timemax:Number, timeDes:Number):void
		{
			s.x = p0.x;
			s.y = p0.y;
			parent.addChild(s);
			TweenLite.to(s, timemax, { x:pmax.x, y:pmax.y, ease:Cubic.easeOut, onComplete:onFinishTween1, onCompleteParams:[parent, s, pdes, timeDes] } );
		}
		
		public function fallWishingPoint(wishingPoint:int, id:int, pos:Point, w:int):void 
		{
			var data:Object = new Object();
			data.id = id;
			data.wishingPoint = wishingPoint / w;
			data.time = GameLogic.getInstance().CurServerTime;
			data.pos = pos;
			motionInfo.push(data);
			data.lastWishingPoint = w;
			lastPushTime = GameLogic.getInstance().CurServerTime;
		}
		
		
		public function fallLollipop(lollipop:int, id:int, pos:Point, l:int):void 
		{
			var data:Object = new Object();
			data.id = id;
			data.lollipop = lollipop / l;
			data.time = GameLogic.getInstance().CurServerTime;
			data.pos = pos;
			motionInfo.push(data);
			data.lastLollipop = l;
			lastPushTime = GameLogic.getInstance().CurServerTime;
		}
		
		private function onFinishTween1(parent:Sprite, tmpl:Sprite, pdes:Point, timeDes:Number):void
		{
			TweenLite.to(tmpl, timeDes, { x:pdes.x, y:pdes.y, ease:Cubic.easeOut, alpha:0.2, onComplete:onFinishTween, onCompleteParams:[parent, tmpl] } );
		}
		
		private function onFinishTween(parent:Sprite, tmpl:Sprite):void
		{
			parent.removeChild(tmpl);
		}
		
		/**
		 * cho 1 text bay theo đường cong đến điểm (xDes, yDes)
		 * @param	str	: Dòng text
		 * @param	format : Format của text trên
		 * @param	iLayer : layer chứa sprite text
		 * @param	xScr : hoành độ nguồn
		 * @param	yScr : tung độ nguồn
		 * @param	xDes : hoành độ đích
		 * @param	yDes : tung độ đích
		 * @param	finishCurveText : hàm sẽ được thực hiện khi hoàn thành motion
		 */
		public function curveText(str:String, format:TextFormat,
									iLayer:int = Constant.OBJECT_LAYER,
									xScr:int = 0,
									yScr:int = 0,
									xDes:int = 0, 
									yDes:int = 0,
									dir:int=1,
									finishCurveText:Function = null):void 
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(iLayer);
			var motion:MotionObject = new MotionObject(layer, "", xScr, yScr);
			var sp:Sprite = Ultility.CreateSpriteText(str, format, 6, 0x000000, true);
			sp.name = "CurveText";
			layer.addChild(sp);
			motion.img = sp;
			sp.x = xScr;
			sp.y = yScr;
			motionArr.push(motion);
			motion.curve(xDes, yDes, 1, 0, 8);
			motion.desPosOnStage = new Point(xDes, yDes);
			motion.finishMotion = function():void 
			{
				if (motion.img == null)	return;
				layer.removeChild(layer.getChildByName("CurveText") as DisplayObject);
				if (finishCurveText != null)
				{
					finishCurveText();
				}
			}
		}
		
		/**
		 * 
		 * @param	iLayer : 
		 * @param	imgName : 
		 * @param	xScr : 
		 * @param	yScr : 
		 * @param	xCurveDes : 
		 * @param	yCurveDes : 
		 */
		public function curveIcon(iLayer:int, imageName:String, xScr:int, yScr:int, 
									xCurveDes:int, yCurveDes:int,
									dir:int,
									finishCurveIcon:Function = null):void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(iLayer);
			var motion:MotionObject = new MotionObject(layer, imageName, xScr, yScr, true, Image.ALIGN_LEFT_TOP, 0);
			motion.img.name = "CurveIcon";
			motionArr.push(motion);
			motion.curve(xCurveDes, yCurveDes, dir, 0, 5);
			motion.desPosOnStage = new Point(xCurveDes, yCurveDes);
			motion.finishMotion = function():void 
			{
				if (motion)
				{
					if (motion.img.alpha > 0)
					{
						motion.roomOut(0.5, 1.5, -0.2);
					}
					else {
						layer.removeChild(motion.img as DisplayObject);
						motion = null;
						if (finishCurveIcon != null)
						{
							finishCurveIcon();
						}
					}
				}
			}
		}
		
		private var fromP:Point;
		private var toP:Point;
		public function effectPartSmithy(fP:Point, tP:Point):void
		{
			fromP = fP;
			toP = tP;
			var t:Timer = new Timer(10, 30);
			t.addEventListener(TimerEvent.TIMER, timerEvent);
			t.start();
		}
		
		public function timerEvent(event:TimerEvent): void
		{
			var s:Number = 1 + Math.random();
			var fromPoint:Point;
			fromPoint = new Point(fromP.x + s * 20, fromP.y + s * 20);
			effectPart(fromPoint, toP, 1000, 200, 2);
		}
		
		private function effectPart(from:Point, target:Point, velocity:Number, angle:Number, delay:Number):void
		{
			var layer:Layer = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
			var eff:MovieClip = ResMgr.getInstance().GetRes("Star") as MovieClip;
			layer.addChild(eff);
			eff.x = from.x;
			eff.y = from.y;
			var s:Number = 1 + Math.random();
			eff.scaleX = s;
			eff.scaleY = s;
			eff.alpha = 1;
			
			var x1:int;
			var y1:int;
			var y2:int;
			if(Math.random() < 0.5)		x1 = from.x + 100 * Math.random() ;
			else 		x1 = from.x - (100 * Math.random());
			y1 = from.y + 80;
			
			TweenMax.to(eff, 2, { physics2D: { velocity:velocity, angle:angle, acceleration:100 }, delay:0, bezier:[ { x:x1, y:y1 }, { x:target.x, y:target.y } ], 
								alpha:0.5, ease:Back.easeOut, onUpdate:onUpdate, onUpdateParams:[from,target,eff], onComplete:removeEff } );
			
			function removeEff():void
			{
				if (eff != null && layer.contains(eff)) 		layer.removeChild(eff);
			}
		}
		
		/**
		 * Set scale cho ngoi sao khi di chuyen
		 * @param	from
		 * @param	target
		 * @param	self
		 */
		private function onUpdate(from:Point, target:Point, self:MovieClip):void
		{
			var dX:Number = (target.x - from.x);
			var dY:Number = (target.y - from.y);
			dX = Math.abs(dX);
			dY = Math.abs(dY);
			var dis:Number = Math.round(Math.sqrt(dX * dX + dY * dY))/5*3;
			var _dX:Number = self.x - from.x;
			var _dY:Number = self.y - from.y;
			_dX = Math.abs(_dX);
			_dY = Math.abs(_dY);
			var _dis:Number = Math.round(Math.sqrt(_dX * _dX + _dY * _dY));
			var curScaleX:Number = self.scaleX;
			var curScaleY:Number = self.scaleY;
			
			if (_dis < dis) {
				self.scaleX = curScaleX + 0.01;
				self.scaleY = curScaleY + 0.01;
			}
			else {
				self.scaleX = curScaleX - 0.05;
				self.scaleY = curScaleY - 0.05;
			}
		}
		
	}
}

















