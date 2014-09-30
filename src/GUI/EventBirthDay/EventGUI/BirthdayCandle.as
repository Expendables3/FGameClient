package GUI.EventBirthDay.EventGUI 
{
	import Data.ConfigJSON;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	//import GUI.component.Image;
	import GUI.EventBirthDay.EventLogic.BirthdayCandleInfo;
	import GUI.EventBirthDay.EventLogic.BirthDayItemMgr;
	import GUI.EventBirthDay.EventPackage.SendBurnCandle;
	import GUI.GuiMgr;
	import Logic.BaseObject;
	import Logic.GameLogic;
	import Logic.GameState;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class BirthdayCandle extends BaseObject 
	{
		public var birthdayCandleInfo:BirthdayCandleInfo;
		public var hasHelper:Boolean = false;
		public var hasFire:Boolean = false;
		// gui
		private var _guiTooltip:TooltipCandle;
		private var _guiBlowCandle:GUIBlowCandle;
		private var hasEffectBlow:Boolean = false;
		public function BirthdayCandle(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "BirthdayCandle";
		}
		
		public function get Id():int
		{
			return birthdayCandleInfo.ItemId;
		}
		
		public function initData(serverData:Object, id:int):void
		{
			birthdayCandleInfo = new BirthdayCandleInfo();
			birthdayCandleInfo.setInfo(serverData);
			var config:Object = ConfigJSON.getInstance().getItemInfo("BirthDayCandle", id);
			birthdayCandleInfo.setConfig(config, id);
			birthdayCandleInfo.initBlowed();
			drawCandle();
			var guiMgr:GuiMgr = GuiMgr.getInstance();
			
			_guiTooltip = guiMgr["guiTooltipCandle" + Id];
			_guiTooltip.initData(birthdayCandleInfo);
			_guiBlowCandle = guiMgr["guiBlowCandle" + Id];
			_guiBlowCandle.initData(birthdayCandleInfo);
		}
		
		public function drawCandle():void
		{
			ClearImage();
			LoadRes("");
			img.removeEventListener(MouseEvent.CLICK, OnMouseClick);
			img.removeEventListener(MouseEvent.ROLL_OVER, OnMouseOver);
			img.removeEventListener(MouseEvent.ROLL_OUT, OnMouseOut);
			var candleSp:Sprite = ResMgr.getInstance().GetRes("BirthdayCandle" + Id) as Sprite;
			candleSp.name = "BirthdayCandle" + Id;
			this.img.addChild(candleSp);
			candleSp.addEventListener(MouseEvent.CLICK, OnMouseClick);
			candleSp.addEventListener(MouseEvent.ROLL_OVER, OnMouseOver);
			candleSp.addEventListener(MouseEvent.ROLL_OUT, OnMouseOut);
			//candleSp.buttonMode = true;
			
			if (canBurn())//đang tắt
			{
				removeFire();
			}
			else//đang cháy => add them 1 cai child ngon lua
			{
				addFire();
			}
			
			SetPos(birthdayCandleInfo.Position.x, birthdayCandleInfo.Position.y);
		}
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			if (hasEffectBlow)
				return;
			var isMe:Boolean = !GameLogic.getInstance().user.IsViewer();
			if (isMe)
			{
				if (canBurn() && GameLogic.getInstance().gameState == GameState.GAMESTATE_IDLE)
				{
					var curTime:Number = GameLogic.getInstance().CurServerTime;
					birthdayCandleInfo.BurnLastTime = curTime;
					Mouse.cursor = "arrow";
					Mouse.cursor = "auto";
					burnCandle();
				}
				else
				{
					_guiBlowCandle.Show(Constant.GUI_MIN_LAYER, 2);
				}
			}
		}
		
		override public function OnMouseOver(event:MouseEvent):void 
		{
			SetHighLight();
			//if (_guiTooltip==null)
			//{
				//_guiTooltip = GuiMgr.getInstance()["guiTooltipCandle" + Id];
				//_guiTooltip.initData(birthdayCandleInfo);
			//}

			//_guiTooltip.Show();
			var isMe:Boolean = !GameLogic.getInstance().user.IsViewer();
			if (isMe)
			{
				if (canBurn() && GameLogic.getInstance().gameState == GameState.GAMESTATE_IDLE)
				{
					Mouse.cursor = "button";
				}
			}
		}
		
		override public function OnMouseOut(event:MouseEvent):void 
		{
			SetHighLight( -1);
			//if(_guiTooltip)
				_guiTooltip.Hide();
			if (canBurn() && GameLogic.getInstance().gameState == GameState.GAMESTATE_IDLE)
			{
				//Mouse.cursor = "arrow";
				Mouse.cursor = "auto";
			}
		}
		
		/**
		 * hành động châm nến
		 */
		public function burnCandle():void
		{
			birthdayCandleInfo.BurnNum++;
			hasHelper = false;
			var pk:SendBurnCandle = new SendBurnCandle(Id);
			Exchange.GetInstance().Send(pk);
			drawCandle();
		}
		
		/**
		 * check xem có thể châm nến hay không
		 * @return
		 */
		public function canBurn():Boolean
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			var can:Boolean = birthdayCandleInfo.canBurn(curTime);
			return can || birthdayCandleInfo.Blowed;
		}
		
		public function fallbonus(data:Object):void 
		{
			//rơi ra quà chắc chắn có data["Bonus"][1] là Money data["Bonus"][2] là Exp thực hiện + cho user
			trace("rơi ra exp + money + wishing point");
			var money:int = data["Gift"][2]["Num"];
			var exp:int = data["Gift"][1]["Num"];
			EffectMgr.getInstance().fallExpMoney(exp, money, birthdayCandleInfo.Position, 1000, 2000);
			
			//wishing point
			var id:int, num:int, type:String;
			var wp:int = data["Gift"][3]["Num"];
			id = data["Gift"][3]["ItemId"];
			type = data["Gift"][3]["ItemType"];
			num = data["Gift"][3]["Num"];
			//BirthDayItemMgr.getInstance().setNum(id, num);
			EffectMgr.getInstance().fallWishingPoint(num, id, birthdayCandleInfo.Position, 1);
			
			if (data["Gift"][4])
			{
				id = data["Gift"][4]["ItemId"];
				type = data["Gift"][4]["ItemType"];
				num = data["Gift"][4]["Num"];
				BirthDayItemMgr.getInstance().setNum(id, num);
				EffectMgr.getInstance().fallLollipop(num, id, birthdayCandleInfo.Position, 1);
			}
		}
		
		override public function Destructor():void 
		{
			/*hủy gui tooltip*/
			if (_guiTooltip)
			{
				if (_guiTooltip.img)
				{
					if (_guiTooltip.img.visible)
					{
						_guiTooltip.Hide();
					}
					//_guiTooltip.Destructor();
				}
				//_guiTooltip = null;
			}
			/*hủy gui thổi nến*/
			if (_guiBlowCandle)
			{
				if (_guiBlowCandle.img)
				{
					if (_guiBlowCandle.img.visible)
					{
						_guiBlowCandle.Hide();
					}
					//_guiBlowCandle.Destructor();
				}
				//_guiBlowCandle = null;
			}
			/*hủy cây nến*/
			if (img)
			{
				img.visible = false;
			}
			super.Destructor();
		}
		public function isShowBlowGui():Boolean {
			if (_guiBlowCandle.img == null)
			{
				return false;
			}
			else {
				return _guiBlowCandle.img.visible;
			}
		}
		public function hideBlowGui():void {
			_guiBlowCandle.Hide();
		}
		public function addHelper():void
		{
			var sp:Sprite = ResMgr.getInstance().GetRes("IcHelper") as Sprite;
			sp.mouseEnabled = false;
			sp.mouseChildren = false;
			sp.name = "HelperTree";
			this.img.addChild(sp);
			sp.y = -15;
			if (birthdayCandleInfo.ItemId == 3)
			{
				sp.x = birthdayCandleInfo.PosFire.x - 8;
			}
			else {
				sp.x = birthdayCandleInfo.PosFire.x;
			}
			
			
			hasHelper = true;
		}
		
		public function removeHelper():void 
		{
			var sp:Sprite = this.img.getChildByName("HelperTree") as Sprite;
			if(sp)
				this.img.removeChild(sp);
		}
		
		public function addFire():void
		{
			var str:String = "EventBirthday_Fire" + Id;
			//var image:Image = new Image(this.img, str,0,0,true,ALIGN_LEFT_TOP,true);
			
			var sp:Sprite = ResMgr.getInstance().GetRes(str) as Sprite;
			//var sp:Sprite = image.img;
			sp.mouseEnabled = false;
			sp.mouseChildren = false;
			sp.name = "Fire" + Id;
			this.img.addChild(sp);
			sp.x = birthdayCandleInfo.PosFire.x;
			sp.y = birthdayCandleInfo.PosFire.y;
			
			this.img.swapChildren(sp, this.img.getChildByName("BirthdayCandle" + Id));
			hasFire = true;
		}
		
		public function removeFire():void
		{
			var sp:Sprite = img.getChildByName("Fire" + Id) as Sprite;
			if (sp)
			{
				img.removeChild(sp);
				var x:int = birthdayCandleInfo.PosFireOff.x;
				var y:int = birthdayCandleInfo.PosFireOff.y;
				var pos:Point = img.localToGlobal(new Point(x, y));
				EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffNentat", null,
													pos.x, pos.y,
													false, false, null, null);
			}
			
		}
		
		public function effectBlow():void 
		{
			var x:int = birthdayCandleInfo.PosFireOff.x + 50;
			var y:int = birthdayCandleInfo.PosFireOff.y - 40;
			var pos:Point = img.localToGlobal(new Point(x, y));
			hasEffectBlow = true;
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER, "EffectFanBlow", null,
													pos.x, pos.y,
													false, false, null, onBlowComp);
			function onBlowComp():void
			{
				hasEffectBlow = false;
				removeFire();
			}
		}
	}
	
}
































