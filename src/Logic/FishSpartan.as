package Logic 
{
	import adobe.utils.CustomActions;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import com.greensock.TweenMax;
	import Data.Config;
	import Data.ConfigJSON;
	import Data.INI;
	import Data.Localization;
	import Data.ResMgr;
	import Effect.EffectMgr;
	import flash.display.ColorCorrection;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	import flash.events.*;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import GameControl.GameController;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.GUIFishStatus;
	import GUI.GuiMgr;
	import NetworkPacket.PacketReceive.GetInitRun;
	import NetworkPacket.PacketSend.SendFishUpLevel;
	import particleSys.sample.StarEmit;
	
	import particleSys.sample.MusicEmit;
	import particleSys.sample.MusicStarEmit;
	import Sound.SoundMgr;
	import NetworkPacket.PacketSend.SendFishChangeLake;
	import NetworkPacket.PacketSend.SendGetGiftOfFish;
	/**
	 * ...
	 * @author ...
	 */
	public class FishSpartan extends Decorate
	{
		//Define các hằng số begin
		//public static const GROWTH_UP:int = 5;
		//public static const RADIUS: int = 150;
		public static const FS_IDLE:int = 0;
		public static const FS_SWIM:int = 1;
		public static const FS_FALL:int = 2;
		public static const FS_RETURN:int = 3;
		
		public static const EGG:String = "Egg";
		public static const BABY:String = "Baby";
		public static const OLD:String = "Old";
		
		public static const IDLE:String = "Idle";
				
		public static const AURA_COLOR_OTHER:int = 0xff0000;	// số option = 3
		public static const AURA_COLOR_OTHER2:int = 0xff6600;	// số option = 2
		public static const AURA_COLOR_OTHER1:int = 0xffffff;	// số option = 1
		
		public static const ItemType:String = "Sparta";			
		public static const SCALE_BABY:Number = 0.7;// 0.55;
		public static const SCALE_OLD:Number = 1;// 0.85;
		public static const SHADOW_SCOPE:int = 80;
		
		private const MUSIC_EMIT:String = "musicSparta";
		
		//Define các hằng số end
		
		public var SwimingArea:Rectangle = new Rectangle(0, 0, 0, 0);
		public var State:int = FS_IDLE;
		public var AgeState:String = BABY;
		public var Emotion:String = IDLE;
		public var CenterPos:Point = new Point();
		public var OrientX:int = 1;
		//public var Scale:Number = SCALE_OLD;
		
		//Các content đi kèm cá
		public var underContent:Sprite = new Sprite();					//Layer add những conent đi kèm cá mà nằm dưới content cá
		public var aboveContent:Sprite = new Sprite();					//Layer add những conent đi kèm cá mà nằm dưới content cá
		public var effSpecialFish:Sprite = null;
		public var effRareFish:Sprite = null;
		public var musicEmit:MusicEmit;
		//public var starEmit:StarEmit;
		
		public var MinSpeed:Number = 1;
		public var MaxSpeed:Number = 5;
		public var realMaxSpeed:Number = 0;
		public var curSpeed:Number = 0;
		public var SetcurSpeed:Number = 0;
		public var changeSpeedDistance:Number = 0;
		
		public var GuiFishStatus:GUIFishStatus = new GUIFishStatus(null, "");
		public var IsHide:Boolean = false;
		public static var dragingFish:FishSpartan = null;
		
		//Data lay tu server ve
		//public var Id:int;								//Id của cá đó trong data base
		public var Name:String;
		public var NameItem:String;		
		public var OriginalStartTime:Number;
		public var StartTime:Number;
		public var RateOption:Object;
		public var LakeId:Number;		
		public var ExpiredTime:Number;
		public var fallPos:Point = new Point();
		//public var isExpired:Boolean;		//  true là còn hạn sử dụng,  false là hết hạn sử dụng
		public var numOption:int;
		public var Material:Array = [];
		public var numMatUse:int = 0;
		
		public var isInRightSide:Boolean = false;
		
		private var shadow:Sprite = null;
		
		// kiem tra ca dau dan
		public var curDeep:Number = Math.random();
		private var rateDeep:Number = 0;
		public var numReborn:int;
		public var maxNumReborm:int = ConfigJSON.getInstance().GetItemList("Param")["MaxReborn"];
		
		//
		public var bCollisionBottom:Boolean = false;
		
		public function FishSpartan(parent:Object, imgName:String, x:int = 0, y:int = 0, itemType:String = "", itemId:int = 0) 
		{
			super(parent, imgName, x, y, itemType, itemId);
			aboveContent.cacheAsBitmap = true;
			underContent.cacheAsBitmap = true;			
			this.ClassName = "FishSpartan";
		}
		
		public function Init(x:int, y:int):void
		{
			//trace("Init ------")
			Dragable = true;			
			//Eated = 0;
			SetDeep(curDeep);			
			SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
			SetPos(x, y);
			if (y < SwimingArea.top)
			{
				SetMovingState(FS_FALL);
			}
			else
			{	
				SetMovingState(FS_SWIM);
				FindDes(false);
			}	
			RefreshImg();
		}
		
		public function FallPos():Point 
		{
			var pos:Point = new Point();
			pos.x = CurPos.x;
			pos.y = Ultility.RandomNumber(GameController.getInstance().GetLakeBottom() - 130, GameController.getInstance().GetLakeBottom() - 70);
			return pos;
		}
		
		public static function initStaticFish():void
		{
		}
		
		/**
		 * 
		 */
		
		public override function OnReloadRes():void
		{
			super.OnReloadRes();
			Init(CurPos.x, CurPos.y);
			img.mouseChildren = false;
			//UpdateColor();
		}
		/**
		 * Set độ sâu cho cá
		 * @param	deep
		 */
		public override function SetDeep(deep:Number):void
		{
			if (curDeep == deep)
			{
				return;
			}
			curDeep = deep;			
			//img.scaleX = OrientX*Scale*(0.6 + 0.4 * (1 - deep));
			//img.scaleY = Scale*(0.6 + 0.4 * (1 - deep));
			var t:Transform = img.transform;
			var c:ColorTransform = new ColorTransform(0.4+0.6*(1-deep), 0.4+0.6*(1-deep), 0.8+0.2*(1-deep), 1);
			img.transform.colorTransform = c;
			if (!isExpired)//hoa thach
			{
				super.SetDeep(deep);
			}
		}
		
		// Hàm set tốc độ cá
		public function SetSpeed(Min:Number, Max:Number):void
		{
			MinSpeed = Min;
			MaxSpeed = Max;
		}
		// Hàm xét trạng thái phát triển của cá, để set hình dáng của cá
		public function SetAgeState(ageState:String):void
		{
			if (AgeState == ageState)
			{
				return;
			}
			
			// Gán lại hình dáng
			AgeState = ageState;			
			Scale = SCALE_OLD;
			
			RefreshImg();
		}
		
		public function RefreshImg():void
		{
			var imageNameFish:String = ImgName;
			ClearImage();
			LoadRes(imageNameFish);
			
			img.scaleX = OrientX*Scale;
			img.scaleY = Scale;
			
			sortContentLayer();			
			
			var cur:int = GameLogic.getInstance().CurServerTime;
			if (isExpired)
			{
				addRareContent();
				
				// hard code với con cá batman
				if (imageNameFish == "Batman" || imageNameFish == "Spiderman")
				{
					effRareFish.x = OrientX * 5;
					effRareFish.y = 15;
					effRareFish.scaleX = effRareFish.scaleY = 1.7;
				}
				//Vẽ aura bằng glowFilter
				var cl:int = getAuraColor();
				TweenMax.to(img, 1, { glowFilter: { color:cl, alpha:1, blurX:25, blurY:25, strength:1.5 }} );	
			}			
	
			//Đổi màu aura tỏa tỏa
			var str:String = cl.toString(16).split("").reverse().join("");
			var color:Array = new Array(0, 0, 0);
			for (var i:int = 0; i < str.length; i += 2) 
			{
				color[i/2] = parseInt(str.slice(i, i + 2), 16);				
			}	
			if (effRareFish != null)
			{
				effRareFish.transform.colorTransform = new ColorTransform(0, 0, 0, 1, color[2], color[1], color[0]);
			}		
			
			//Khởi tạo emitter huýt sáo
			if (musicEmit == null)
			{
				musicEmit = new MusicEmit(img.parent, MUSIC_EMIT + "1", MUSIC_EMIT + "2", MUSIC_EMIT + "3");		
				//musicEmit.emit = new MusicStarEmit(img.parent);
			}
			
			//Add bóng
			if(shadow == null)
			{
				shadow = ResMgr.getInstance().GetRes("FishShadow") as Sprite;				
				Parent.addChild(shadow);
				shadow.x = img.x;
				shadow.y = GameController.getInstance().GetLakeBottom() - curDeep*SHADOW_SCOPE;
				shadow.scaleY = 0.7;
			}
		}
		/**
		 * Sắp xếp lại các layer conntent của cá gồm: layer nằm dưới cá, layer cá và layer nằm trên cá
		 */
		private function sortContentLayer():void
		{
			//Add content đi kèm theo cá			
			if (!Parent.contains(underContent)) Parent.addChild(underContent);
			if (!Parent.contains(aboveContent)) Parent.addChild(aboveContent);
			
			if (Parent.getChildIndex(underContent) > Parent.getChildIndex(aboveContent))
			{
				Parent.swapChildren(underContent, aboveContent);
			}
			
			if (Parent.getChildIndex(img) > Parent.getChildIndex(aboveContent))
			{
				Parent.swapChildren(img, aboveContent);
			}
			
			if (Parent.getChildIndex(img) < Parent.getChildIndex(underContent))
			{
				Parent.swapChildren(img, underContent);
			}			
		}
		
		public function GetMoveArea():Sprite
		{
			var area:Sprite = new Sprite();
			var Pos:Point = new Point();
			Pos.x = CurPos.x < DesPos.x ? CurPos.x: DesPos.x;
			Pos.y = CurPos.y < DesPos.y ? CurPos.y: DesPos.y;
			area.graphics.drawRect(Pos.x - img.width/2, Pos.y - img.height/2, Math.abs(DesPos.x - CurPos.x) + img.width, Math.abs(DesPos.y - CurPos.y) + img.height);
			return area;
		}
		
		public function SetSwimingArea(area:Rectangle):void
		{
			SwimingArea = area;
		}
		
		public function SetMovingState(movState:int):void
		{
			if (movState == State)
			{
				return;
			}
			State = movState;
			switch(movState)
			{
				case FS_IDLE:
					break;
				case FS_SWIM:				
					break;
				case FS_FALL:
					var t:int = SwimingArea.top;
					DesPos.y = Ultility.RandomNumber(t + SwimingArea.height / 2, t + 3*SwimingArea.height / 4);
					SpeedVec.x = Ultility.RandomNumber(-10, 10);
					SpeedVec.y = - 20;
					if (SpeedVec.x < 0)
					{
						flipX(-1);
					}
					State = FS_FALL;
				break;
			}
		}
		
		public function SetDirFall(dir:int):void
		{
			if (dir == 1)
			{
				SpeedVec.x = Ultility.RandomNumber(1, 10);
				flipX(1);
			}
			else
			{
				SpeedVec.x = Ultility.RandomNumber(-10, -1);
				flipX(-1);
			}
			updateAttachContent();
		}
			
		public function UpdateFish():void
		{			
			if (IsHide)
			{
				return;
			}
			
			//Update trạng thái di chuyển của cá
			switch(State)
			{
				case FS_IDLE:
					break;
				case FS_SWIM:
					Swim();
					break;
				case FS_FALL:
					Fall();
					break;
				case FS_RETURN:
					Return();
					break;
			}	
			
			//Update các content khác đi kèm theo cá
			aboveContent.x = underContent.x = img.x;
			aboveContent.y = underContent.y = img.y;
			
			//di chuyển chatbox
			if (chatbox)
			{
				chatbox.x = this.img.x;
				chatbox.y = this.img.y - 20;
			}
			
			if (musicEmit)
			{
				musicEmit.pos.x = img.x + OrientX * img.width / 2
				musicEmit.pos.y = img.y;
				musicEmit.updateEmitter();
				musicEmit.vel = new Point(OrientX*(curSpeed+6), 0);
			}
			
			//update gui status đi kèm theo cá
			if (GuiFishStatus.IsVisible)
			{				
				GuiFishStatus.SetPos(CurPos.x, CurPos.y);
			}			
		}
		
		public function SwimTo(x:int, y:int, speed:Number = -1):void
		{
			var Des:Point = new Point();
			Des.x = x;
			Des.y = y;
			State = FS_SWIM;
			PrepareMoving(Des, speed, false);
		}
		
		public function FindDes(hasAcceleration:Boolean = true):void
		{
			var Des:Point = new Point();
			
			var x:Number = Ultility.PosScreenToLake(0, 0).x;
			if(img.stage)
				Des.x = Ultility.RandomNumber(x, x + img.stage.stageWidth);
			do
			{
				Des.y = CurPos.y + Ultility.RandomNumber( -150, 150);
			}				
			while (	Des.y < SwimingArea.top	|| Des.y > SwimingArea.bottom);
			rateDeep = -(Math.random() - curDeep) / Math.abs(Des.x - CurPos.x);							
			PrepareMoving(Des, -1, hasAcceleration);			
		}
		
		public function GoBack():void
		{
			var Des:Point = new Point();
			Des.x = CurPos.x - sign(SpeedVec.x) * Ultility.RandomNumber(10, 100);
			do
			{
				Des.y = CurPos.y + Ultility.RandomNumber( -150, 150);
			}
			while (	Des.y < SwimingArea.top	|| Des.y > SwimingArea.bottom);
			PrepareMoving(Des);
		}
		
		private function PrepareMoving(Des:Point, speed:Number = -1, hasAcceleration:Boolean = true):void
		{
			if (speed > 0)
			{
				realMaxSpeed = speed;	
			}
			else
			{
				realMaxSpeed = Ultility.RandomNumber(MinSpeed, MaxSpeed);
			}
			ChangeDir(CurPos, Des);
			var temp:Number = Des.x - CurPos.x;
			if (temp > 0){
				flipX(1);
			}
			else{
				flipX( -1);
			}
			updateAttachContent();
			if (hasAcceleration)
			{
				MoveTo(Des.x, Des.y, MinSpeed);
				changeSpeedDistance = 70;//CurPos.subtract(DesPos).length/4;
				curSpeed = 0;
			}
			else
			{
				MoveTo(Des.x, Des.y, realMaxSpeed);
				changeSpeedDistance = 0;
				curSpeed = realMaxSpeed;
			}
		}		
		
		private function Swim(speedFish:int = -1):void
		{
			if (SwimingArea.width == 0 && SwimingArea.height == 0)
			{
				return;
			}
			
			UpdateObject();			
			updateShadow();
			var temp:Point = CurPos.subtract(DesPos);
			if(speedFish == -1)
				if (temp.length <= changeSpeedDistance)
				{
					curSpeed -= 0.12;
					if (curSpeed <= 1) {curSpeed = 1;}
				}
				else
				{
					curSpeed += 0.15;
					if (curSpeed >= realMaxSpeed) {curSpeed = realMaxSpeed;}
				}
			//else 	curSpeed = 2 - ChangCurSpeed;
			SpeedVec.normalize(curSpeed);
			
			CheckSwimingArea();
			
			if (ReachDes) 
			{
				if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR)
				{
					var posX:int = Ultility.RandomNumber(Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2 + img.width + 50, Constant.MAX_WIDTH);
					var posY:int = GameController.getInstance().GetLakeTop() + Constant.HEIGHT_LAKE / 2;
					SwimTo(posX, posY, 10);
				}
				else
				{
					FindDes();
				}
			}
			
			if (chatbox)
			{
				chatbox.x = this.img.x;
				chatbox.y = this.img.y - 20;
			}
			
			if (GameLogic.getInstance().gameMode == GameMode.GAMEMODE_WAR && (CurPos.x - img.width) >= (Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2))
			{
				if (!isInRightSide)
				{
					isInRightSide = true;
					SetSwimingArea(new Rectangle(Constant.MAX_WIDTH / 2 + Main.imgRoot.stage.width / 2 + 2 * img.width, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH / 2 - Main.imgRoot.stage.width / 2, Constant.HEIGHT_LAKE - 80));
					img.visible = false;
					aboveContent.visible = false;
				}
			}
			else if (GameLogic.getInstance().gameMode != GameMode.GAMEMODE_WAR)
			{
				if (isInRightSide)
				{
					isInRightSide = false;
					SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, Constant.MAX_WIDTH, Constant.HEIGHT_LAKE - 80));
					img.visible = true;
					aboveContent.visible = true;
				}
			}
		}
		
		// Thả cá
		private function Fall():void
		{
			SpeedVec.y += 4;
			{
				if (CurPos.y > SwimingArea.top)
				{
					var pos1:Point = Ultility.PosScreenToLake(img.width , CurPos.y);
					var pos2:Point = Ultility.PosScreenToLake(img.stage.stageWidth - img.width, CurPos.y);
					if ( CurPos.y >=DesPos.y)
					{
						ReachDes = true;
						DesPos.y = DesPos.y + Ultility.RandomNumber( -100, -50);
						SwimTo((pos2.x + pos1.x) / 2, DesPos.y);
						return;
					}
					
					if (CurPos.x <= pos1.x|| CurPos.x >= pos2.x)
					{						
						SwimTo((pos2.x + pos1.x) / 2, CurPos.y);
						return;
					}
					
				 	SpeedVec.y -= 4;
					if (SpeedVec.y < 2.5)
						SpeedVec.y = 2.5;
				}
				var temp:Number = CurPos.y;
				CurPos = CurPos.add(SpeedVec);
				this.img.x = CurPos.x;
				this.img.y = CurPos.y;
				
				//Cá chạm mặt nước
				//Tác động lực làm cá rơi chậm đi
				//Effect nước bắn
				if (temp <= SwimingArea.top && CurPos.y >= SwimingArea.top)
				{
					SpeedVec.y = 0.2 * SpeedVec.y;
					EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffNuocBan", null, CurPos.x + Ultility.RandomNumber(-10, 10), SwimingArea.top);
				}
			}
		}
		
		private function Return():void
		{
			img.scaleX += OrientX * 0.6;
			
			if (Math.abs(img.scaleX) >= Scale)
			{
				img.scaleX = OrientX * Scale;
				SetMovingState(FS_SWIM);
				return;				
			}		
		}
		
		private function flipX(orient:int, rightnow:Boolean = true):void
		{
			if (!img)
				return;
				
			if (orient == 0)
				return;
		
			if (CurPos.x < SwimingArea.left + img.width/2 || CurPos.x > SwimingArea.right - img.width/2)
				return;
			
			if (rightnow)
			{
				if (orient > 0)
				{
					img.scaleX = Scale;
				}
				else
				{
					img.scaleX = -Scale;
				}
			}
			else
			{
				SetMovingState(FS_RETURN);
			}
			OrientX = orient;
		}
		
		public function sign(x:Number):int
		{
			return (x > 0) ? 1 : ((x < 0) ? -1 : 0);
		}
		
		private function CheckSwimingArea():void
		{
			var flagX:Boolean = false;
			var flagY:Boolean = false;
			
			if(CurPos.x <= SwimingArea.left + img.width/2)
			{
				SetPos(SwimingArea.left + img.width/2, CurPos.y);
				if (OrientX < 0)
				{
					flagX = true;
				}
			}
			if (CurPos.x >= SwimingArea.right - img.width/2)
			{
				SetPos(SwimingArea.right - img.width / 2, CurPos.y);
				if (OrientX > 0)
				{
					flagX = true;
				}
			}					
			
			if (CurPos.y < SwimingArea.top +  img.height/2 && SpeedVec.y < 0)
			{
				SetPos(CurPos.x , SwimingArea.top + img.height/2);
				flagY = true;
			}
			if ( CurPos.y > SwimingArea.bottom - img.height/2 && SpeedVec.y > 0)
			{
				SetPos(CurPos.x , SwimingArea.bottom - img.height/2);
				flagY = true;
			}

			if (flagX == true)
			{
				GoBack();
			}
			if (flagY == true)
			{
				FindDes();
			}
		}
		
		private function ChangeDir(curPos:Point, desPos:Point, turnSpeed:Number = 0):void
		{
			var s:Point = desPos.subtract(curPos);
			var dir:Number = Math.atan2(s.y, s.x) * 180 / Math.PI;
			if (dir < 0)
			{
				dir += 360;
			}
			
			if (dir > 90 && dir < 270)
			{
				dir = (dir + 180) % 360;
			}
			
			
			var delta:int = 20;
			if (dir < 360 - delta && dir >= 270)
			{
				dir = 360 - delta;
			}
			
			if (dir > delta && dir <= 90)
			{
				dir = delta;
			}
			img.rotation = dir;			
		}		
		public function Growth():Number
		{
			return 1;
		}
		public function GetValue():Number
		{	
			//var obj:Object = ConfigJSON.getInstance().GetItemList("Param");
			var obj:Object = ConfigJSON.getInstance().getSuperFishInfo(NameItem);
			//var objFishSpecial:Object = obj[NameItem + "Info"];			
			if (ExpiredTime * 24 * 3600 >= GameLogic.getInstance().CurServerTime - StartTime)
			{
				//return objFishSpecial["Active"]["Money"];
				return obj["Active"]["Money"];
			}
			else 
			{
				//return objFishSpecial["Disable"]["Money"];
				return obj["Disable"]["Money"];
			}
		}
		
		public function getExp(isGift:Boolean = false):int
		{
			//var obj:Object = ConfigJSON.getInstance().GetItemList("Param");
			var obj:Object = ConfigJSON.getInstance().GetItemList("SuperFish");
			//var objFishSpecial:Object = obj[NameItem + "Info"];	
			var objFishSpecial:Object = obj[NameItem];	
			var exp:int;
			if (ExpiredTime * 24 * 3600 >= GameLogic.getInstance().CurServerTime - StartTime)			
			{
				exp = objFishSpecial["Active"]["Exp"];
			}
			else 
			{
				exp = objFishSpecial["Disable"]["Exp"];
			}
			
			//Nếu có sự kiện nhân đôi
			if (GameLogic.getInstance().isEventDuplicateExp)
			{
				exp *= 2;
			}
			return exp;
		}
		/**
		 * Add những content đi kèm với cá quý
		 */
		private function addRareContent():void
		{
			if (effRareFish == null)
			{
				//aura =  ResMgr.getInstance().GetRes("aura") as Sprite;
				//aura =  ResMgr.getInstance().GetRes("EffCaDacBiet") as Sprite;
				effRareFish =  ResMgr.getInstance().GetRes("EffCaQuy") as Sprite;
				effRareFish.scaleX = effRareFish.scaleY = 1.3;
				effRareFish.y = 5;
				effRareFish.mouseEnabled = false;
				effRareFish.mouseChildren = false;
				aboveContent.addChild(effRareFish);
				updateAttachContent();
			}			
		}
		/**
		 * Update lại vị trí các content đi kèm khi cá quay đầu
		 */
		private function updateAttachContent():void
		{
			if (effRareFish != null)
			{
				if (ImgName != "Batman" && ImgName != "Spiderman" && ImgName != "Superman" && ImgName != "Ironman")
				{
					effRareFish.x = -OrientX * (img.width / 5);
				}
				else 
				{
					effRareFish.x = OrientX * 5;
					effRareFish.y = 15;
				}
			}
		}
		
		public function ChangeLayerAttachConent(newILayer:int):void
		{
			var layer:Object = LayerMgr.getInstance().GetLayer(newILayer);				
			if ((layer != null) && img.parent != null)
			{
				aboveContent.parent.removeChild(aboveContent);
				underContent.parent.removeChild(underContent);				
				layer.addChild(aboveContent);
				layer.addChild(underContent);
			}			
		}
		
		
		
		public function Clear():void
		{
			if (Sprite(Parent).contains(underContent))
			{
				Sprite(Parent).removeChild(underContent);
			}
			if (Sprite(Parent).contains(aboveContent))
			{
				Sprite(Parent).removeChild(aboveContent);
			}
			
			if (shadow != null && Sprite(Parent).contains(shadow))
			{
				Parent.removeChild(shadow);
				shadow = null;
			}
			if (musicEmit != null)
			{
				musicEmit.destroy();
				musicEmit = null;
			}
			ClearImage();
			
			if (GuiFishStatus.IsVisible)
			{
				GuiFishStatus.Hide();
			}
		}
		
		public function Hide():void
		{
			if (chatbox)
			{
				chatbox.Hide();
			}
			Clear();
			IsHide = true;			
		}
		
		public function Show():void
		{
			RefreshImg();			
			IsHide = false;
		}
		
		public override function OnDestructor():void
		{
			Hide();
			if (musicEmit != null)
			{
				musicEmit.destroy();
				musicEmit = null;
			}
			if (GuiFishStatus != null)
			{
				GuiFishStatus.Hide();
			}			
		}

		override public function SetHighLight(color:Number = 0x00FF00):void 
		{
			if (isExpired)
			{
				var cl:int = getAuraColor();
				TweenMax.to(img, 1, { glowFilter: { color:cl, alpha:1, blurX:25, blurY:25, strength:1.5 }} );		
			}
			else
			{
				if (img == null)
				{
					return;
				}
				
				if (color < 0)
				{
					img.filters = null;
					return;
				}
				
				var glow:GlowFilter = new GlowFilter(color, 1, 5, 5, 100);
				img.filters = [glow];
			}
		}
		
		public function getAuraColor():int
		{
			switch (numOption) 
			{
				case 1:
					return AURA_COLOR_OTHER1;
				break;
				
				case 2:
					return AURA_COLOR_OTHER2;
				break;
			}
			return AURA_COLOR_OTHER;
		}
		
		/**
		 * @param	event: Sự kiện cá sẽ nói
		 * @param	time: thời gian chatbox tồn tại, đơn vị milisecond, mặc định 5 giây
		 * @param	rate: tỉ lệ xuất hiện câu nói cho mỗi con cá, càng nhỏ càng cao, mặc định 1/20
		 */
		public function Chatting(event:String = "", time:int = 5000, rate:int = 20):void
		{
		//	return;
			// Lải nhải
			if (img == null || IsHide)
			{
				return;
			}
			if (event == "")
			{
				chatbox.Hide();
				return;
			}
			var i:int = Ultility.RandomNumber(1, 15);
			var st:String = Localization.getInstance().getString("Chat" + event + i);
			
			if (Math.round(Ultility.RandomNumber(0, rate)) == 1)		
			{
				var format: TextFormat = new TextFormat;
				format.font = "Arial";
				format.size = 12;
				if (chatbox.ContentImg == "imgThinkContent2")
				{
					format.color = "0xD71717";
					format.italic = true;
				}
				format.bold = true;
				format.align = "center";
				chatbox.Show(st, time, format);
			}
		}
		
		public override function OnStartDrag():Boolean
		{			
			if (img.x > SwimingArea.right || img.x < SwimingArea.left || 
				img.y < SwimingArea.top || img.y > SwimingArea.bottom + 80)
			{
				finisDrag();
				return false;
			}
				
			GameLogic.getInstance().CountHerd = 13;
			switch(GameLogic.getInstance().gameState)
			{
				case GameState.GAMESTATE_IDLE:
				{
					if (GameLogic.getInstance().user.IsViewer())
					{
						return false;
					}
					SetHighLight();
					SetMovingState(FS_IDLE);
					ChangeLayerAttachConent(Constant.ACTIVE_LAYER);
					if (GuiMgr.getInstance().GuiFishInfo.IsVisible)
						GuiMgr.getInstance().GuiFishInfo.Hide();
					dragingFish = this;
					return true;
				}
				default:
					return false;
			}
		}

		public override function OnFinishDrag():Boolean
		{
			//SetSwimingArea(new Rectangle(0, GameController.getInstance().GetLakeTop() + 30, LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenWidth, LayerMgr.getInstance().GetLayer(Constant.BACKGROUND_LAYER).stage.fullScreenHeight - 80));
			GameLogic.getInstance().CountHerd = 0;
			ChangeLayerAttachConent(Constant.OBJECT_LAYER);
			this.SetMovingState(Fish.FS_SWIM);
			this.SetHighLight( -1);
			dragingFish = null;
			
			if (GuiMgr.getInstance().GuiMain.MovedFishLake >= 0)
			{
				return GuiMgr.getInstance().GuiMain.ChangeLakeSparta(GuiMgr.getInstance().GuiMain.MovedFishLake, this);
			}
			
			if (img.x > SwimingArea.right || img.x < SwimingArea.left || 
				img.y < SwimingArea.top || img.y > SwimingArea.bottom + 80)
				return false;

			return true;
		}
		
		public override function Destructor():void
		{
			ClearImage();
			DesPos = null;
			SpeedVec = null;
			CurPos = null;
			OnDestructor();
		}
		
		public override function OnDragOver(obj:Object):void
		{
			var i:int = 0;
			var button:Button = null;
			var point: Point;
			var container: Container;
			var arr: Array;
			if (GameLogic.getInstance().user.IsViewer())
			{
				return;
			}
			
			for (i = 0; i < GuiMgr.getInstance().GuiMain.btnLakeArr.length; i++ )
			{
				container = GuiMgr.getInstance().GuiMain.btnLakeArr[i];
				button = container.ButtonArr[0] as Button;
				if (button.img.hitTestPoint(GameInput.getInstance().MousePos.x, GameInput.getInstance().MousePos.y))
				{
					point = new Point(55 + i * 45, -11);
					container.img.scaleX = 1.2;
					container.img.scaleY = 1.2;
					container.SetPos(point.x, point.y);
					arr = container.IdObject.split("_");
					GuiMgr.getInstance().GuiMain.MovedFishLake = arr[1];
				}
				else
				{
					if (container.img.scaleX != 1.0)
					{
						point = new Point(55 + i * 45, -11);
						container.img.scaleX = 1.0;
						container.img.scaleY = 1.0;
						container.SetPos(point.x, point.y);
						GuiMgr.getInstance().GuiMain.MovedFishLake = -1;
					}
				}
			}
		}
		/**
		 * Update vị trí bóng của cá theo thông tin 
		 * @param	speed
		 */
		public function updateShadow():void
		{
			if (shadow == null) return;
			var lakeBottom:Number = GameController.getInstance().GetLakeBottom();
			curDeep += -(rateDeep * Math.abs(SpeedVec.x));
			if (shadow.y <= img.y + img.height)
			{
				shadow.y = img.y + img.height;
				curDeep = (lakeBottom - shadow.y) / SHADOW_SCOPE;
			}
			if (curDeep >= 1)
			{
				curDeep = 1;
			}
			if (curDeep <= 0)
			{
				curDeep = 0;
			}
			shadow.scaleX = shadow.scaleY = 1.4 - 0.7*curDeep;
			shadow.x = img.x;
			shadow.y = lakeBottom - curDeep*SHADOW_SCOPE;			
		}
		/*
		 * 
		 */
		override public function UpdateDeep():void 
		{
			if (!isExpired)
			{
				var r:Rectangle = GameController.getInstance().GetDecorateArea();
				var tg:Number = 1 - (CurPos.y - r.top) / (r.height);
				if (tg > 1)
				{
					tg = 1;
				}
				if (tg < 0)
				{
					tg = 0;
				}
				SetDeep(tg);
			}
		}
		override public function CheckPosition():Boolean 
		{
			var kq:Boolean = true;
			var r:Rectangle = GameController.getInstance().GetDecorateArea();//vùng đáy biển dành cho decorate
			//trace("r.top = " + r.top + "\nr.bottom = " + r.bottom);
			//r.bottom -= 131;
			var r1:Rectangle = img.getBounds(img.parent);					//vùng bao ngoài decorate
			if (r1.left + r1.width > Constant.MAX_WIDTH - 20)				//vượt quá cạnh phải
			{
				kq = false;
			}
			if (r1.top < 20)												//vượt quá cạnh trên của GUIMain	ko cần thiết
			{
				kq = false;
			}
			if (r.top >  r1.bottom)											//deco vượt quá cạnh trên của đáy biển
			{
				kq = false;
			}
			else if(r.bottom + 32 < r1.bottom) 									//deco vượt quá cạnh dưới của đáy biển
			{
				kq = false;
			}
			if (kq)
			{
				ShowDisable(false);
				//UpdateDeep();
			}
			return kq;
		}
	}

}