package GUI.TrungLinhThach 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import Data.ResMgr;
	import Event.EventMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import Logic.LayerMgr;
	import Logic.Ultility;
	import particleSys.myFish.CometEmit;
	
	import Sound.SoundMgr;
	import com.adobe.serialization.json.JSON;
	
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	
	import GUI.component.BaseGUI;
	import GUI.component.Button;
	import GUI.component.ComboBoxEx;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TextBox;
	import GUI.GuiMgr;
	import GUI.Event8March.CoralTree;
	
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class GUITrungLinhThach extends BaseGUI 
	{
		static public const FASTTIME:Number = 0.05;
		static public const NORMALTIME:Number = 1.001;
		static public const SALE_OFF:String = "buttonSaleOff";
		static public const ITEM_NEW_QUARTZ:String = "itemNewQuartz";
		
		[Embed(source='../../../content/dataloading.swf', symbol='DataLoading')]	
		private var DataLoading:Class;
		private var WaitData:MovieClip = new DataLoading();
		private var isDataReady:Boolean;
		private var ListItemTrung:Array = [];
		
		public var IsInitFinish:Boolean = false;
		private var _timeGui:Number;
		private var hammerObjData:Object = new Object();
		private var eggObjData:Object = new Object();
		private var bonusObjData:Object = new Object();
		public var slotObjData:Object = new Object();
		private var typeEggs:Array = ['WhiteEgg', 'GreenEgg', 'YellowEgg', 'PurpleEgg'];
		private var typeHammer:Array = ['HammerWhite','HammerGreen', 'HammerYellow', 'HammerPurple'];
		private var arrImageEggX:Array = [65, 242, 455, 655];
		private var arrImageEggY:Array = [256, 242, 235, 238];
		private var timeItemArr:Array = [];
		private var emitStar:Array = [];
		private var numQuartzSix:int = 0;
		
		private var btnSaleOff:Button;
		private var imgBgSaleOff:Image;
		private var imgQuartz2013:Button;
		private var txtNumQota:TextField;
		
		public function GUITrungLinhThach(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GuiTrungLinhThach";
		}
		
		override public function InitGUI():void 
		{
			//trace("InitGUI()");
			this.setImgInfo = function():void
			{
				IsInitFinish = false;
				SetPos(0, 0);
				
				var sound:Sound = SoundMgr.getInstance().getSound("DongMoBang") as Sound;
				if (sound != null)
				{
					sound.play();
				}
				
				//Add ảnh chờ load dữ liệu
				img.addChild(WaitData);
				WaitData.x = img.width / 2 - 5;
				WaitData.y = img.height / 2 - 5;
				//trace("Load data() SendGetSmashEgg ");
				var cmdLinhThach:SendGetSmashEgg = new SendGetSmashEgg();
				cmdLinhThach.FriendId = 0;
				Exchange.GetInstance().Send(cmdLinhThach);
				
				OpenRoomOut();
				
				_timeGui = GameLogic.getInstance().CurServerTime;
			}
			LoadRes("GuiTrungLinhThach_Bg");
		}
		
		public function showGUI():void
		{
			isDataReady = false;
			//trace("showGUI()== " + isDataReady);
			this.Show(Constant.GUI_MIN_LAYER, 3);
		}
		
		override public function EndingRoomOut():void 
		{
			IsInitFinish = true;
			//trace("EndingRoomOut()== " + isDataReady);
			super.EndingRoomOut();
			if (isDataReady)
			{
				ClearComponent();
				refreshComponent();
			}
		}
		
		public function refreshComponent(dataAvailable:Boolean = true):void 
		{
			isDataReady = dataAvailable;
			//trace("refreshComponent()== " + isDataReady);
			if (!isDataReady || !IsFinishRoomOut)
			{
				return;
			}
			
			if (img == null) return;
			
			if (img.contains(WaitData))
			{
				img.removeChild(WaitData);
			}
			addContent();
		}
		
		public function addDataRespont(data:Object):void
		{
			hammerObjData = data["SmashEgg"]["Hammer"];
			eggObjData = data["SmashEgg"]["Egg"];
			bonusObjData = data["SmashEgg"]["Bonus"];
			slotObjData = data["SmashEgg"]["Slot"];
			numQuartzSix = data["NumView6Star"];
			
			ClearComponent();
			refreshComponent();
		}
		
		public function loadDataBonusSmash(OldData:Object, Data:Object):void
		{
			numQuartzSix = Data["NumView6Star"];
			
			for (var i:int = 0; i < ListItemTrung.length; i++)
			{
				var itemTrung:ItemTrung = ListItemTrung[i] as ItemTrung;
				//trace("loadDataBonusSmash() itemTrung.nameItem== " + itemTrung.nameItem);
				//trace("loadDataBonusSmash() OldData.EggType== " + OldData.EggType);
				if (itemTrung.nameItem == OldData.EggType)
				{
					//trace("update cho Item nay-------");
					itemTrung.updateGuiItem(Data["Bonus"], OldData);
				}
			}
			
			updateNum6Star();
		}
		
		public function loadReceiveBonus(OldData:Object, Data:Object):void
		{
			//trace("loadReceiveBonus() Data[Time]== " + Data["Time"]);
			//bonusObjData[OldData.EggType] = Data["Bonus"];
			for (var i:int = 0; i < ListItemTrung.length; i++)
			{
				var itemTrung:ItemTrung = ListItemTrung[i] as ItemTrung;
				if (itemTrung.nameItem == OldData.EggType)
				{
					itemTrung.updateEggSmash(Data["Bonus"], Data["Time"]);
				}
			}
		}
		
		/*Add thong tin content cho Gui*/
		private function addContent():void
		{
			GuiMgr.getInstance().guiUserTrungLinhThachInfo.Show();
			GuiMgr.getInstance().guiHammerInfo.Show();
			
			GuiMgr.getInstance().guiUserTrungLinhThachInfo.updateUserData();
			
			GuiMgr.getInstance().guiHammerInfo.updateUserData(hammerObjData);
			
			var data:Array = new Array();
			data.push(eggObjData.WhiteEgg);
			data.push(eggObjData.GreenEgg);
			data.push(eggObjData.YellowEgg);
			data.push(eggObjData.PurpleEgg);
			
			addAllItemTrung(data);
			
			GuiMgr.getInstance().guiToolBar.Show();
			if (EventMgr.CheckEvent(EventMgr.NAME_EVENT) == EventMgr.CURRENT_IN_EVENT)
			{
				//imgBgSaleOff = AddImage("", "GuiTrungLinhThach_bgSaleOff2013", 440, 156) //bg dải vải đỏ
				
				btnSaleOff = AddButton(SALE_OFF, "GuiTrungLinhThach_SaleOff", 367, 125); //buttom giảm giá
				btnSaleOff.setTooltipText("Mua búa giảm giá");
				
				imgQuartz2013 = AddButton(ITEM_NEW_QUARTZ, "GuiTrungLinhThach_itemQuartzNew", 630, 510); //buttom giảm giá
				
				txtNumQota = AddLabel('', 683, 550, 0xFFFF01, 1);
				updateNum6Star();
			}
			
		}
		
		private function updateNum6Star():void
		{
			if (txtNumQota)
			{
				var fm:TextFormat = new TextFormat("Arial", 22, 0xFFFF01, true);
				txtNumQota.text = Ultility.StandardNumber(numQuartzSix);
				txtNumQota.setTextFormat(fm);
				txtNumQota.defaultTextFormat = fm;
			}
		}
		
		private function addAllItemTrung(data:Array):void 
		{
			/*trace("data.length== " + data.length)
			trace("data[0].Time== " + data[0].Time)
			trace("data[0].Status== " + data[0].Status)
			trace("data[0].SmashNum== " + data[0].SmashNum)*/
			ListItemTrung.splice(0, ListItemTrung.length);
			
			var i:int;
			var leng:int = 4;
			for (i = 0; i < data.length; i++)
			{
				var trung:Object = data[i];
				trung.id = i + 1;
				trung.name = typeEggs[i];
				trung.hammer = typeHammer[i];
				addItemTrung(trung, i);
			}
			
			var imgGia:Image = AddImage("", "beDoEggSmash", 25, 330, true, ALIGN_LEFT_TOP);
			imgGia.img.mouseChildren = false;
			imgGia.img.mouseEnabled = false;
			imgGia.img.parent.mouseEnabled = false;
		}
		
		private function addItemTrung(trung:Object, index:int):void 
		{
			//trace("----------addItemTrung");
			var itemTrung:ItemTrung = new ItemTrung(this.img, "KhungFriend");
			itemTrung.initData(trung, bonusObjData);
			itemTrung.IdObject = "TabRoom_" + trung.id;
			itemTrung.EventHandler = this;
			itemTrung.VirtualTime = _timeGui;
			itemTrung.drawItem();
			itemTrung.img.x = arrImageEggX[index];
			itemTrung.img.y = arrImageEggY[index];
			ListItemTrung.push(itemTrung);
			timeItemArr.push(false);
		}
		
		public function updateGUI():void 
		{
			if (IsInitFinish)
			{
				//trace("updateGUI()");
				var curTime:Number = GameLogic.getInstance().CurServerTime;
				updateAllPage(curTime);
			}
			
			var i:int;
			for (i = 0; i < emitStar.length; i++)
			{
				emitStar[i].updateEmitter();
				if (!emitStar[i].allowSpawn && emitStar[i].particleList.length < 1)
				{
					emitStar[i].destroy();
					emitStar.splice(i, 1);
					i--;
				}
			}
		}
		
		private function updateAllPage(curTime:Number):void 
		{
			var isSetTimeGui:Boolean = false;
			for (var i:int = 0; i < ListItemTrung.length; i++)
			{
				var itemTrung:ItemTrung = ListItemTrung[i] as ItemTrung;
				var isUpdated:Boolean = true;// (itemTrung.room.State == Room.STATE_TRAIN);
				
				if (isUpdated)
				{
					var tickcount:Number = curTime - _timeGui;
					if (tickcount >= NORMALTIME)
					{
						updateTime(itemTrung, curTime);
						isSetTimeGui = true;
						checkDinkInUpdate();
					}
				}
				itemTrung.updateItemRock();
			}
			if (isSetTimeGui)
			{
				_timeGui = curTime;
			}
		}
		
		private function updateTime(itemTrung:ItemTrung, time:Number):void 
		{
			itemTrung.UpdateStaus(time);
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch(buttonID)
			{
				case SALE_OFF:
					GuiMgr.getInstance().guiBuyHammerSaleOff.showGUI();
					break;
				case ITEM_NEW_QUARTZ:
					GuiMgr.getInstance().guiNewItemQuartz.showGUI(numQuartzSix);
					break;
			}
		}
		
		override public function OnHideGUI():void 
		{
			TrungLinhThachMgr.getInstance().getQuartzInfo();
			GuiMgr.getInstance().guiUserTrungLinhThachInfo.Hide();
			GuiMgr.getInstance().guiHammerInfo.Hide();
		}
		
		/**
		 * Hàm tạo effect 1 chùm sao bay theo đường cong từ điểm này tới điểm kia
		 * @param	fromPoint : điểm bắt đầu
		 * @param	toPoint : điểm kết thúc
		 * @param	colorTransform : transform màu cho sao
		 * @param	isReverse : có bay ngược từ toPoint đến fromPoint hay không, mặc định là không
		 * @param	completeFunction : hàm thưc hiện khi xong effect
		 * @param	params : tham số cho hàm completeFunction
		 * @param	mid : chọn điểm giữa, 0 là random, 1 là hướng vòng lên, -1 là hướng vòng xuống, 2 là bay thẳng
		 * @param	spawnCount : số sao bay
		 */
		private function particalStar(fromPoint:Point, toPoint:Point, colorTransform:ColorTransform, completeFunction:Function = null, params:Object = null, time:Number = 0.5, isReverse:Boolean = false, mid:int = 0, spawnCount:int = 7):void
		{
			var emit:CometEmit = new CometEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));
			emit.spawnCount = spawnCount;
			var sao:Sprite = ResMgr.getInstance().GetRes("ImgSao") as Sprite;
			sao.transform.colorTransform = colorTransform;
			emit.imgList.push(sao);
			emitStar.push(emit);
			if (isReverse)
			{
				var temp:Point = toPoint.clone();
				toPoint = fromPoint.clone();
				fromPoint = temp;
			}
			
			var midPoint:Point = midPoint = getThroughPoint(fromPoint, toPoint, mid);
			
			if (emit)
			{
				img.addChild(emit.sp);
				emit.sp.x = fromPoint.x;
				emit.sp.y = fromPoint.y;
				if (mid != 2)
				{
					emit.velTolerance = new Point(1.5, 1.5);
					TweenMax.to(emit.sp, time, {bezierThrough: [{x: midPoint.x, y: midPoint.y}, {x: toPoint.x, y: toPoint.y}], ease: Cubic.easeOut, onComplete: onCompleteTween, onCompleteParams: [completeFunction, params]});
				}
				else
				{
					emit.velTolerance = new Point(1.2, 1.2);
					TweenMax.to(emit.sp, time, {bezierThrough: [{x: toPoint.x, y: toPoint.y}], ease: Cubic.easeOut, onComplete: onCompleteTween, onCompleteParams: [completeFunction, params]});
				}
			}
			
			function onCompleteTween():void
			{
				if (IsVisible)
				{
					if (emit)
					{
						emit.stopSpawn();
					}
					if (emit && emit.sp && emit.sp.parent == img)
					{
						img.removeChild(emit.sp);
					}
				}
				if (completeFunction != null)
				{
					completeFunction(params);
				}
			}
		}
		
		/**
		 * Tìm điểm trung gian giữa 2 điểm nguồn và đích để bay vòng qua đó cho đẹp
		 * @param	psrc	điểm nguồn
		 * @param	pdes	điểm đích
		 * @return
		 */
		private function getThroughPoint(psrc:Point, pdes:Point, mid:int = 0):Point
		{
			var p:Point = pdes.subtract(psrc); //Vector từ nguồn đến đích
			if (p.y == 0)
				return new Point(p.x / 2, 0);
			var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2); //Trung điểm của nguồn và đích
			var v:Point = new Point(-p.y, p.x); //Vector vuông góc với vector(nguồn, đích)
			
			//Random hướng vuông góc
			var n:int;
			if (mid == 0)
			{
				n = Math.round(Math.random()) * 2 - 1;
			}
			else
			{
				n = mid;
			}
			v.x = n * v.x;
			v.y = n * v.y;
			var l:Number = Math.min(120, v.length / 3);
			v.normalize(l); //Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			var result:Point = med.add(v); //Tính ra điểm cần đi xuyên qua
			return result;
		}
		
		public function ClearItemBonus():void
		{
			for (var i:int = 0; i < ListItemTrung.length; i++)
			{
				var itemTrung:ItemTrung = ListItemTrung[i] as ItemTrung;
				itemTrung.ClearItemBonus();
			}
		}
		
		public function updateButtomFront(isRung:Boolean):void
		{
			GuiMgr.getInstance().guiFrontScreen.BtnTrungLinhThach.SetBlink(isRung);
			//trace("updateButtomFront isRung== " + isRung);
		}
		
		public function pushStatusInItem(isRung:Boolean, index:int):void
		{
			timeItemArr[index] = isRung;
		}
		
		private function checkDinkInUpdate():void
		{
			var dinkOk:Boolean = false;
			for (var i:int = 0; i < timeItemArr.length; i++ )
			{
				if (timeItemArr[i] == true)
				{
					dinkOk = true;
				}
			}
			
			updateButtomFront(dinkOk);
		}
	}
}