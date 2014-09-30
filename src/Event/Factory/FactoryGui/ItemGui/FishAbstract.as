package Event.Factory.FactoryGui.ItemGui 
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import Data.ResMgr;
	import Event.EventNoel.NoelGui.FishNoel.FishBoss;
	import Event.EventNoel.NoelGui.FishNoel.FishCommon;
	import Event.EventNoel.NoelGui.FishNoel.FishFast;
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import Event.Factory.FactoryLogic.ItemInfo.FishAbstractInfo;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.ItemGift.AbstractItemGift;
	import Logic.LogicGift.AbstractGift;
	//import GUI.component.Image;
	import GUI.GuiMgr;
	
	/**
	 * Con cá trong event
	 * @author HiepNM2
	 */
	//public class FishAbstract extends Image 
	public class FishAbstract extends ImgObject 
	{
		private const CACHE_BITMAP:Boolean = false;
		private var _isAppear:Boolean = false;
		protected const ACCELERATION_INC:Number = 0.15;
		protected const ACCELERATION_DEC:Number = 0.12;
		protected const CHANGE_SPEED_DISTANCE:Number = 70;
		protected const SPEED_MIN:Number = 1;
		
		protected var _fishInfo:FishAbstractInfo;	//thông tin con cá
		protected var _speed:Number = 2;			//cho biết độ lớn của vận tốc
		protected var _realMaxSpeed:Number;			//vận tốc lớn nhất, tùy từng con (nhưng vẫn dao động trong 1 khoảng nhất định)
		protected var _changeSpeedDistance:Number = 0;	//khoảng mà nó sẽ chuyển từ nhanh dần đều đến chậm dần đều
		public var inIce:Boolean;
		private var _listBullet:Object;
		public var inFired:Boolean;
		public function FishAbstract(parent:Object, fishInfo:FishAbstractInfo, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			_fishInfo = fishInfo;
			super(parent, fishInfo.getImageName(), x, y, isLinkAge, imgAlign, CACHE_BITMAP, SetInfo, ImageId);
			_speedVec = x > 0? new Point( -2, 0) : new Point(2, 0);
			ClassName = "FishAbstract";
		}
		
		public static function createFish(parent:Object, fishInfo:FishAbstractInfo, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = ""):FishAbstract 
		{
			switch(fishInfo.FishType)
			{
				case "FishCommon":
					return new FishCommon(parent, fishInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
				case "FishFast":
					return new FishFast(parent, fishInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
				case "FishBoss":
					//return new FishBoss(parent, fishInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
					return new FishBoss(parent, fishInfo, x, y, isLinkAge, imgAlign, true, SetInfo, ImageId);
			}
			return new FishAbstract(parent, fishInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
		}
		public function drawProgress():void
		{
			if (_fishInfo.Blood < _fishInfo.getMaxBlood())
			{
				_guiStatus = GuiStatusAbstract.createGuiStatus(_fishInfo.FishType, this.img/* Parent*/, "");
				_guiStatus.hasUpdate = false;
				var data:Object = { "Blood":_fishInfo.Blood, "MaxBlood":_fishInfo.getMaxBlood(),
										"xFish":img.x, "yFish":img.y,
										"wFish":img.width, "hFish":img.height
								};
				_guiStatus.initData(data);
				_guiStatus.Show();
			}
			
		}
		
		
		public function checkAppear():Boolean
		{
			var objScreen:Sprite = GuiMgr.getInstance().guiHuntFish.img;
			_isAppear = img.hitTestObject(objScreen);
			return _isAppear;
		}
		public function swim():void 
		{ 
			if (inIce) return;
			if (update())
			{
				changeSpeedVecLength();
			}
		}
		/**
		 * thay đổi vận tốc khi có gia tốc
		 */
		private function changeSpeedVecLength():void 
		{
			var temp:Point = _desPos.subtract(CurPos);
			if (_changeSpeedDistance != 0)
			{
				if (temp.length <= _changeSpeedDistance)
				{
					_speed -= ACCELERATION_DEC;
					if (_speed < SPEED_MIN) 
					{
						_speed = SPEED_MIN;
					}
				}
				else
				{
					_speed += ACCELERATION_INC;
					if (_speed >= _realMaxSpeed) 
					{
						_speed = _realMaxSpeed;
					}
				}
			}
			_speedVec.normalize(_speed);
		}
		
		/**
		 * chuẩn bị di chuyển
		 * @param	des : vị trí sẽ đi đến 
		 * @param	hasAccelleration : có gia tốc hem?
		 */
		override public function prepareMoving(des:Point, hasAccelleration:Boolean = false):void 
		{
			var dir:Number = countDir(des);
			changeDir(dir);
			if (hasAccelleration)
			{
				moveTo(des, 1);
				_changeSpeedDistance = CHANGE_SPEED_DISTANCE;
				_speed = 0;//vì có gia tốc nên bắt đầu từ 0
			}
			else
			{
				moveTo(des, _realMaxSpeed);
				_changeSpeedDistance = 0;
				_speed = _realMaxSpeed;
			}
		}
		
		/**
		 * hủy đối tượng con cá
		 */
		override public function Destructor():void 
		{
			super.Destructor();
			_fishInfo = null;
		}
		
		/**
		 * cập nhật máu cho con cá
		 * @param	dBlood khoảng máu +-
		 * @return còn sống không
		 */
		public function updateBlood(dBlood:int):Boolean
		{
			var expriding:Boolean = _fishInfo.updateBlood(dBlood);
			if (_guiStatus == null)
			{
				drawProgress();
			}
			if (_guiStatus)
			{
				var data:Object = { "Blood":_fishInfo.Blood };
				_guiStatus.updateDataGui(data);
			}
			return expriding;//đang sống?
		}
		
		public function getListGiftInfo():Array { return _fishInfo.getListGift(); }
		public function set speed(val:Number):void { _speed = val; }
		public function get SpeedVec():Point { return _speedVec; }
		public function get Id():int { return _fishInfo.Id; }
		public function get Blood():int { return _fishInfo.Blood; }
		public function get FishType():String { return _fishInfo.FishType; }
		public function get IsAppear():Boolean { return _isAppear; }
		public function set IsAppear(val:Boolean):void { _isAppear = val; }
		public function set RealMaxSpeed(val:Number):void { _realMaxSpeed = val; }
		
		
		public function pushToListBullet(idBullet:int):void //con cá vừa dính viên đạn idBullet
		{
			if (_listBullet == null)
			{
				_listBullet = new Object();
			}
			_listBullet[idBullet] = 1;
		}
		
		public function checkBullet(idBullet:int):Boolean//kiểm tra xem con cá đã bị dính viên đạn idBullet chưa
		{
			if (_listBullet == null)
			{
				return false;
			}
			return (idBullet in _listBullet);
		}
		
		public virtual function updateFish():void { }
		public virtual function swimRandom():void { }
		public virtual function swimCurve():void { }
		public virtual function swimLine():void { }
		
		public function freeze():void 
		{
			var sp:Sprite = ResMgr.getInstance().GetRes("GuiHuntFish_ImgRainIce") as Sprite;
			sp.name = "ImgIce";
			img.addChild(sp);
		}
		public function unFreeze():void
		{
			if (inIce)
			{
				var sp:Sprite = img.getChildByName("ImgIce") as Sprite;
				if (sp)
				{
					img.removeChild(sp);
				}
			}
			inIce = false;
		}
		public function getInScreen():Boolean
		{
			const left:Number = 0;
			const top:Number = 0;
			const right:Number = 824;
			const bot:Number = 600;
			
			var leftFish:Number = img.x - img.width / 2;
			var rightFish:Number = img.x + img.width / 2;
			var topFish:Number = img.y - img.height / 2;
			var botFish:Number = img.y + img.height /2 ;
			if (rightFish < left || leftFish > right || botFish < top || topFish > bot)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * Effect mất máu
		 */
		public virtual function effBleed():void
		{
			/*var ptr:Sprite = img;
			var showAgain:Function = function():void
			{
				inFired = false;
				ptr = null;
			}
			var transparentComp:Function = function():void
			{
				TweenMax.to(ptr, 0.5, { autoAlpha:1, onComplete:showAgain } );
			}
			TweenMax.to(img, 0.5, { autoAlpha:0.2 , onComplete:transparentComp } );*/
			var ptr:Sprite = img;
			var showAgain:Function = function():void
			{
				inFired = false;
				ptr = null;
			}
			TweenMax.to(ptr, 0.2, { colorTransform: { tint:0x000000, tintAmount:0 }, onComplete:showAgain } );
			var compBlack3:Function = function():void
			{
				TweenMax.to(ptr, 0.2, { colorTransform: { tint:0xff0000, tintAmount:0 }, onComplete:showAgain } );
			}
			var compWhite2:Function = function():void
			{
				TweenMax.to(ptr, 0.1, {colorTransform:{tint:0x000000, tintAmount:0.7}, onComplete:compBlack3});
			}
			var compBlack2:Function = function():void
			{
				TweenMax.to(ptr, 0.1, {colorTransform:{tint:0xff0000, tintAmount:0.7}, onComplete:compWhite2});
			}
			var compWhite1:Function = function():void
			{
				TweenMax.to(ptr, 0.1, {colorTransform:{tint:0x000000, tintAmount:0.7}, onComplete:compBlack2});
			}
			var compBlack1:Function = function():void
			{
				TweenMax.to(ptr, 0.1, {colorTransform:{tint:0xff0000, tintAmount:0.7}, onComplete:compWhite1});
			}
			TweenMax.to(ptr, 0.1, {colorTransform:{tint:0x000000, tintAmount:0.7}, onComplete:compBlack1});
		}
	}
}


































