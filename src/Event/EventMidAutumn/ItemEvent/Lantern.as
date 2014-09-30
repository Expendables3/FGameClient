package Event.EventMidAutumn.ItemEvent 
{
	import Data.ConfigJSON;
	import Data.Localization;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import Event.EventMidAutumn.EventPackage.SendFireLantern;
	import Event.EventMidAutumn.GuiFrontScreenEvent;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.GuiMgr;
	
	/**
	 * Cái lồng đèn
	 * @author HiepNM2
	 */
	public class Lantern extends Container 
	{
		//static public const ID_BTN_FIRE:String = "idBtnFire";
		private const NUM_USE:int = 3;
		static public const ID_BTN_REBORN:String = "idBtnReborn";
		private const ID_IMG_BLOOD:String = "idImgBlood";
		private const ID_ICON:String = "idIcon";
		static public const ID_IMG_BLOOD_NONE:String = "idImgBloodNone";
		
		private const PAPER:int = 1;
		private const GASCAN:int = 2;
		public static const SPACE:int = 3;
		
		private const Y_WATER_FACE:int = 500;
		private const Y_START:int = 372;
		private const DMOVE:Number = 1;
		private const DTIME:Number = 0.05;
		
		private const objBuff:Object = { "Protector":1, "Magnetic":1, "Speeduper":1 };
		private const objAgainst:Object = { "DropOfWater":1, "Cyclone":1 };
		
		private var posProtector:Point;
		private var posSpeeduper:Point;
		private var posMagnetic:Point;
		private var posIconMagnetic:Point;
		private var posIconProtector:Point;
		private var posTextMagnetic:Point;
		private var posTextProtector:Point;
		
		private var _high:int;				//độ cao hiện tại của lồng đèn
		private var _highMax:int;			//độ cao cực đại
		private var _numProtector:int;			//lần còn lại để sử dụng áo giáp
		private var _numSpeeduper:int;
		private var _numMagnetic:int;
		private var _blood:int;				//máu hiện tại
		private var _fuel:int;				//đang dùng loại nhiên liệu nào
		
		private var imgProtector:Image;
		private var imgMagnetic:Image;
		private var imgSpeeduper:Image;
		private var btnFire:Button;
		private var btnReborn:Button;
		
		public var isMoving:Boolean = false;
		public var inTransform:Boolean;
		public var isDrop:Boolean = false;
		private var inFall:Boolean;		//đang trong trạng thái rơi
		private var inEffBleeding:Boolean;
		private var effBleeding:SwfEffect;
		
		private var iconProtector:Container;
		private var iconMagnetic:Container;
		private var tfProtector:TextField;
		private var tfMagnetic:TextField;
		
		private var isSubProtector:Boolean = true;
		private var isSubMagnetic:Boolean = true;
		private var isSubSpeeduper:Boolean = true;
		
		public function Lantern(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "Lantern";
			posProtector = new Point(0, -15);
			posSpeeduper = new Point(22, 138);
			posMagnetic = new Point(0, 15);
			posIconMagnetic = new Point(75, 173);
			posIconProtector = new Point(-19, 170);
			posTextMagnetic = new Point(-28, 31);
			posTextProtector = new Point(-30, 33);
		}
		
		public function get High():int 
		{
			return _high;
		}
		
		public function set X(value:int):void 
		{
			_high = value;
		}
		
		public function get Blood():int 
		{
			return _blood;
		}
		public function set Blood(value:int):void
		{
			_blood = value;
		}
		
		private function setBlood(value:int):void 
		{
			if (value < 0)
			{
				value = 0;
			}
			else if (value > 5)
			{
				value = 5;
			}
			var isUpdate:Boolean = (_blood != value);//không có sự thay đổi gì cả
			_blood = value;
			if (isUpdate && !inFall)
			{
				updateBloodBar();
			}
		}
		
		public function get NumArmor():int 
		{
			return _numProtector;
		}
		
		public function set NumArmor(value:int):void 
		{
			_numProtector = value;
		}
		
		public function get NumSpeed():int 
		{
			return _numSpeeduper;
		}
		
		public function set NumSpeed(value:int):void 
		{
			_numSpeeduper = value;
		}
		
		public function get NumMagnet():int 
		{
			return _numMagnetic;
		}
		
		public function set NumMagnet(value:int):void 
		{
			_numMagnetic = value;
		}
		
		private function drawBuff(type:String):void
		{
			this["img" + type] = AddImage("", "EventMidAutumn_Buff" + type, this["pos" + type].x, this["pos" + type].y, true, ALIGN_LEFT_TOP);
			this["icon" + type] = AddContainer(ID_ICON + type, "EventMidAutumn_Icon" + type, this["posIcon" + type].x, this["posIcon" + type].y);
			this["icon" + type].setTooltipText(Localization.getInstance().getString("EventMidAutumn_Usage" + type));
			this["tf" + type] = this["icon" + type].AddLabel("x" + this["_num" + type], this["posText" + type].x, this["posText" + type].y, 0xffffff, 1, 0x000000);
		}
		
		/**
		 * ăn các item trên đường đi: hỗ trợ, cản trở, colection...
		 * @param	type : kiểu item
		 * @param	id : id của item
		 * @param	num : số lượng ăn vào
		 */
		public function eatItem(type:String, id:int, num:int = 1, pos:int = 0):void
		{
			switch(type)
			{
				case "Protector"://item hỗ trợ
				case "Magnetic":
				case "Speeduper":
					//trace("ăn item hỗ trợ: " + type);
					if (this["_num" + type] == 0 && _fuel != SPACE)
					{
						drawBuff(type);
					}
					var numUse:int = ConfigJSON.getInstance().getItemInfo("MidMoon_MoveItem")[type][id]["NumUse"];
					this["_num" + type] += num * numUse;
					if (_fuel != SPACE)
					{
						this["tf" + type].text = "x" + this["_num" + type];
					}
					
					break;
				case "Health"://máu
					var dBlood:int = ConfigJSON.getInstance().getItemInfo("MidMoon_MoveItem")[type][id]["ReduceHealth"];
					//trace("ăn được máu");
					setBlood(_blood + num * dBlood);
					break;
				case "DropOfWater"://mây đen
					//trace("dính phải mây đen id: " + id);
					if (_fuel != SPACE && _numProtector == 0)
					{
						crushBleeding(type, id, num, pos);
					}
					break;
				case "Disaster":
					if (_fuel != SPACE)
					{
						crushBleeding(type, id, num, pos);
					}
					break;
				case "Cyclone"://quả tạ
					//trace("dính phải quả tạ id: " + id);
					if (_fuel != SPACE && _numProtector == 0) 
					{
						_high = pos;
						var dHigh:int = ConfigJSON.getInstance().getItemInfo("MidMoon_MoveItem")["Cyclone"][id]["MoveStep"];
						dHigh *= num;
						fall( -dHigh);
					}
					break;
				case "Collection":
					GuiMgr.getInstance().guiFrontEvent.updateNumItemEvent(type, num, id);
					break;
				default:
					//trace("ăn phần thưởng");
			}
		}
		
		/**
		 * chảy máu
		 * @param	type : loại mây
		 * @param	id : id mây
		 * @param	num : số mây bị dính
		 */
		private function crushBleeding(type:String, id:int, num:int = 1, pos:int = 0):void 
		{
			var dBlood:int = ConfigJSON.getInstance().getItemInfo("MidMoon_MoveItem")[type][id]["ReduceHealth"];
			dBlood *= num;
			if (_blood + dBlood <= 0)
			{
				_high = pos;
			}
			setBlood(_blood + dBlood);
			if (!inEffBleeding)//nếu đang không trong effect chảy máu => thì chảy máu
			{
				inEffBleeding = true;
				effBleeding = transform("EventMidAutumn_LanternBleed", "EventMidAutumn_LanternFly", afterEffBleed, img.x, img.y);
				function afterEffBleed():void
				{
					img.visible = true;
					inEffBleeding = false;
				}
			}
		}
		
		public function checkFire():void
		{
			var id:int = 1;
			var num:int = 1;
			var xEff:int = 0, yEff:int = 0, effName:String = "KhungFriend";
			var resName:String = "EventMidAutumn_LanternFly";
			var xRes:int = 368, yRes:int = 350;
			
			isMoving = true;
			//trc
			//for (var itm:String in objBuff)//trừ 1 lần sử dụng các đồ buff
			//{
				//if (this["_num" + itm] > 0 && this["_num" + itm] % NUM_USE == 0)
				//{
					//this["_num" + itm]--;
				//}
			//}
			
			for (var itm:String in objBuff)//trừ 1 lần sử dụng các đồ buff
			{
				if (this["_num" + itm] > 1)
				{
					this["isSub" + itm] = true;//đã trừ ở phía trước
					this["_num" + itm]--;
				}
				else
				{
					if (this["_num" + itm] == 1)
					{
						this["isSub" + itm] = false;
					}
					else
					{
						this["isSub" + itm] = true;
					}
				}
			}
			
			
			var type:String = GuiMgr.getInstance().guiFrontEvent.TypeFire;
			GuiMgr.getInstance().guiFrontEvent.updateNumItemEvent(type, -1);//trừ 1 nhiên liệu
			setFuel(type);
			
			if (_fuel == SPACE)//biến hình nếu dùng tên lửa
			{
				effName = "EventMidAutumn_EffTransformSpace";
				resName = "EventMidAutumn_LanternSpace";
				xEff = 372;
				yEff = 397;
				xRes -= 22;
			}
			
			transform(effName, resName, onFinishTransform, xEff, yEff);
			function onFinishTransform():void
			{
				SetPos(xRes, yRes);
				startFire(type, id, num);
				if (_fuel != SPACE)
				{
					drawBloodBar();
					drawAllBuffItem();
				}
			}
		}
		/**
		 * gửi gói tin đốt đèn lên
		 * @param	type
		 * @param	id
		 * @param	num
		 */
		private function startFire(type:String, id:int, num:int):void
		{
			isDrop = true;
			var pk:SendFireLantern = new SendFireLantern(type, id, num);
			Exchange.GetInstance().Send(pk);
			//di chuyển
			var buffStep:int = GuiMgr.getInstance().guiFrontEvent.getNumStep(type);
			GuiMgr.getInstance().guiBackGround.flyByStep(buffStep, type == "SpaceCraft");
			_high += buffStep;
			if (_high > ConfigJSON.getInstance().getItemInfo("Param")["MidMoon"]["MissMoonHome"])
			{
				_high = 759;
			}
			
		}
		public function completeFire():void
		{
			for (var itm:String in objBuff)
			{
				if (this["_num" + itm] == 0)
				{
					if (this["img" + itm] != null)
					{
						RemoveImage(this["img" + itm]);
						RemoveContainer(ID_ICON + itm);
						this["img" + itm] = null;
					}
				}
				else
				{
					if (this["img" + itm] == null)
					{
						this["img" + itm] = AddImage("", "EventMidAutumn_Buff" + itm, this["pos" + itm].x, this["pos" + itm].y);
					}
				}
			}
		}
		
		override public function Destructor():void 
		{
			super.Destructor();
			posProtector = null;
			posMagnetic = null;
			posSpeeduper = null;
		}
		
		public function draw():void
		{
			//nút đốt
			if (_blood > 0)
			{
				//btnFire = AddButton(ID_BTN_FIRE, "EventMidAutumn_BtnFire", 22, 184);
			}
			else
			{
				btnReborn = AddButton(ID_BTN_REBORN, "EventMidAutumn_BtnReborn", 4, 184);
			}
			//thanh máu + giọt máu => thiết kế kiểu visible giọt máu=> nhanh
			drawBloodBar();
			//các item hỗ trợ
			drawAllBuffItem();
		}
		
		private function drawAllBuffItem():void 
		{
			for (var type:String in objBuff)
			{
				if (this["_num" + type] > 0)
				{
					drawBuff(type);
				}
			}
		}
		
		public function updateBloodBar():void
		{
			var imageBlood:Image;
			for (var i:int = 1; i <= 5; i++)
			{
				imageBlood = GetImage(ID_IMG_BLOOD + i);
				if(imageBlood != null)
				{
					imageBlood.img.visible = (i <= _blood);
				}
			}
		}
		public function clickToFire():void
		{
			if (_high == 0 && !isDrop)//bắt đầu chơi
			{
				//GuiMgr.getInstance().guiFrontEvent.inDropLantern = true;
				isMoving = true;
				drop();
			}
			else
			{
				checkFire();
			}
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			if (isMoving)
			{
				return;
			}
			switch(buttonID)
			{
				case ID_BTN_REBORN:
					GuiMgr.getInstance().guiRebornLantern.Show(Constant.GUI_MIN_LAYER, 5);
				break;
			}
		}
		
		private function drop():void 
		{
			
			transform("EventMidAutumn_GenieDropFish", "EventMidAutumn_LanternFly",
						onCompleteDrop, 278, 418);
			function onCompleteDrop():void
			{
				GuiMgr.getInstance().guiBackGround.addImageOnBackground("EventMidAutumn_Genie", 335, 533);
				checkFire();
				//GuiMgr.getInstance().guiFrontEvent.inDropLantern = false;
			}
		}
		
		public function setFuel(typeFire:String):void
		{
			switch(typeFire)
			{
				case "PaperBurn":
					_fuel = PAPER;
					break;
				case "GasCan":
					_fuel = GASCAN;
					break;
				case "SpaceCraft":
					_fuel = SPACE;
					break;
			}
		}
		
		public function get Fuel():int
		{
			return _fuel;
		}
		
		/**
		 * rơi xuống độ cao nào đó
		 * @param	dHigh
		 */
		public function fall(dHigh:int):void
		{
			if (dHigh > 0)
			{
				_high -= dHigh;
				if (_high < 0)
				{
					_high = 0;
				}
				inFall = true;
				transform("KhungFriend", "EventMidAutumn_LanternFall", onAfterTransToFall, img.x, img.y);
				if (inEffBleeding)
				{
					effBleeding.FinishEffect();
				}
				function onAfterTransToFall():void
				{
					//rơi tự do có gia tốc
					GuiMgr.getInstance().guiBackGround.flyByStep( -dHigh, true);
				}
			}
			
		}
		
		private function transform(effName:String, resName:String, 
									fAfterTransform:Function = null,
									xEff:int = 0, yEff:int = 0,
									layer:int = Constant.GUI_MIN_LAYER):SwfEffect
		{
			if (ImgName != resName)
			{
				ClearComponent();
				LoadRes(resName);//biến thành hình này
			}
			var mySprite:Sprite = img;	//reference
			img.visible = false;
			inTransform = true;
			return EffectMgr.getInstance().AddSwfEffect(layer, effName, null, xEff, yEff, 
												false, false, null, transformComp);
			function transformComp():void
			{
				if (!inEffBleeding)
				{
					mySprite.visible = true;//hiện lại hình biến thành
				}
				fAfterTransform();
				inTransform = false;
			}
		}
		
		private function drawBloodBar():void
		{
			if (_fuel == SPACE)
			{
				return;
			}
			var y:int = 125;
			var i:int;
			for (i = 1; i <= 5; i++)
			{
				AddImage(ID_IMG_BLOOD_NONE + i, "EventMidAutumn_ImgBlood0", -10, y - 1);
				AddImage(ID_IMG_BLOOD + i, "EventMidAutumn_ImgBlood1", -10, y);
				y -= 20;
			}
			updateBloodBar();
		}
		
		/**
		 * đèn lồng đến nơi
		 */
		public function reachDes():void
		{
			var effName:String = "KhungFriend", resName:String = "EventMidAutumn_LanternIdle";
			var xEff:int = 368, yEff:int = 350;
			var xRes:int = 368;
			var yRes:int = 350;
			if (_fuel == SPACE)
			{
				effName = "EventMidAutumn_EffTransformLantern";
			}
			setFuel("PaperBurn");
			
			if (_blood == 0)
			{
				resName = "EventMidAutumn_LanternIdle";//đèn lồng rách
			}
			//sau
			for (var itm:String in objBuff)//trừ 1 lần sử dụng các đồ buff
			{
				if (!this["isSub" + itm] && this["_num"+itm] > 0)
				{
					this["_num" + itm]--;
					this["isSub" + itm] = true;
				}
			}
			transform(effName, resName, onCompEff, 368, 350);
			function onCompEff():void
			{
				SetPos(xRes, yRes);
				if (_blood == 0)
				{
					GuiMgr.getInstance().guiRebornLantern.Show(Constant.GUI_MIN_LAYER, 5);
				}
				draw();
				inFall = false;
				isMoving = false;
				
				//Hiện quà khi đã xong hết eff chuyển đèn
				if(GuiMgr.getInstance().guiBackGround.isShowGift)
				{
					GuiMgr.getInstance().guiGiftStore.showGUI(GuiMgr.getInstance().guiBackGround.giftPosition, false);
					GuiMgr.getInstance().guiBackGround.isShowGift = false;
				}
			}
		}
	}

}























