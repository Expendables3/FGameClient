package Logic 
{
	import com.greensock.easing.Bounce;
	import com.greensock.TweenMax;
	import Event.EventNoel.NoelGui.ItemGui.EffectEvent.EffChest;
	import Event.EventNoel.NoelGui.ItemGui.EffectEvent.EffNoelItem;
	import Event.EventTeacher.EffCurveText;
	import fl.managers.FocusManager;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import GUI.GuiMgr;
	/**
	 * ...Các đối tượng tiền bay, exp bay lên thanh top bar
	 * @author tuannm3
	 */
	public class MotionObject extends BaseObject
	{
		public static const MOTION_FALL:int = 1;
		public static const MOTION_CURVE:int = 2;
		public static const MOTION_ROOM_OUT:int = 3;
		
		public static const MAX_SPEED_FALL:int = 25;
		public static const MAX_SPEED_CURVE:int = 50;	
		
		public var MotionState:int = 0;
		private const dx:Number = 0.1;
		private var existTime:int;
		
		private var SignScaleY:int;
		private var OrgScaleX:Number = 1;
		private var OrgScaleY:Number = 1;
		private var gravity:Number;
				
		//For curving
		public var CurDir:Number = 0;
		public var Speed:Number;
		public var TurnSpeed:Number;
		public var Acceleration:Number;
		public var ForceTimeOut:Number;
		public var friction:Number = 0.95;
		
		//Dùng để lưu đích đến theo hệ tọa độ toàn cục trên stage
		//Trong trường hợp đích đến nằm trong hệ tọa độ của hồ, khi pan hồ đi, đích đến sẽ bị thay đổi so với đích đến toàn cục
		//khi đó ta phải cập nhật lại đích đến trong tọa độ hồ để 2 đích này ko lệch nhau
		public var desPosOnStage:Point = null;
		
		//For room out
		public var roomSpeed:Number;
		public var maxRoom:Number;
		public var fadeSpeed:Number;
		
		public var finishMotion:Function;
		public var num:int;
		public var isFinishDeform:Boolean = false;
		
		public function MotionObject(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, Num:int = 0) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "MotionObject";
			num = Num;
		}
		
	
		
		public function updateMotionObj():void 
		{
			switch(MotionState)
			{
				case MOTION_FALL:					
					updateFall();
					break;
				case MOTION_CURVE:
					updateCurve();
					break;
				case MOTION_ROOM_OUT:
					updateRoomOut();
					break;
			}
		}		

		/**
		 * 
		 * @param	DesY  		Tọa độ Y của điểm rơi
		 * @param	Gravity		Trọng lượng của đối tượng
		 * @param	ExistTime	Thời gian tồn tại sau khi tới đích
		 */		
		public function fall(DesY:int, Gravity:Number = 4, ExistTime:Number = 5):void
		{
			DesPos.y = DesY;
			gravity = Gravity;
			existTime = ExistTime;
			MotionState = MOTION_FALL;
			SpeedVec.x = Ultility.RandomNumber(-10, 10);
			SpeedVec.y = - Ultility.RandomNumber(25, 35);
			SignScaleY = -1;
		}
		
		public function updateFall():void
		{
			if (ReachDes)
			{
				if (img != null)
				{
					if (!isFinishDeform)
					{
						if (img.scaleY < OrgScaleY)
						{
							img.scaleY += SignScaleY * dx;
							img.scaleX -= SignScaleY * dx;
							img.y = CurPos.y + (Height - img.height);
							img.x = CurPos.x + (Width - img.width)/2;
							if (img.scaleY <= 0.7*OrgScaleY)
							{
								SignScaleY *= -1;							
							}
						}
						else
						{
							isFinishDeform = true;
							img.scaleX = OrgScaleX;
							img.scaleY = OrgScaleY;
						}	
					}
					
					
					if (GameLogic.getInstance().CurServerTime > existTime)
					{
						if (finishMotion != null)
						{
							finishMotion();				
						}
					}					
				}				
				return;
			}
			
			if ( CurPos.y >=DesPos.y && SpeedVec.y > 0)
			{
				ReachDes = true;
				existTime = GameLogic.getInstance().CurServerTime + existTime;
				Height = img.height;
				Width = img.width;
				img.scaleY = OrgScaleY - dx;
				img.scaleX = OrgScaleX + dx;
				return;
			}
			SpeedVec.y += gravity;
			if (SpeedVec.y > MAX_SPEED_FALL) SpeedVec.y = MAX_SPEED_FALL;
			CurPos = CurPos.add(SpeedVec);
			this.img.x = CurPos.x;
			this.img.y = CurPos.y;
			if (CurPos.x < 0)
			{
				this.img.x = CurPos.x = 0;
			}
			if (CurPos.x > Constant.MAX_WIDTH - img.width)
			{
				this.img.x = CurPos.x = Constant.MAX_WIDTH - img.width;
			}
			
			img.scaleX = img.scaleY += 0.07;
			if(img.scaleY >=OrgScaleY) img.scaleY = OrgScaleY;
			if(img.scaleX >=OrgScaleX) img.scaleX = OrgScaleX;
		}
		
		
		/**
		 * 
		 * @param	x			tọa độ x của đích
		 * @param	y			tọa độ y của đích
		 * @param	force 		lực tác động (frame base)
		 * @param	dir 		hướng lượn cong: trái = -1, phải = 1;
		 * @param 	Friction 	ma sát
		 */
		public function curve(x:int, y:int, dir:int, forceTimeOut:Number = 0, force:Number = 3, turnSpeed:Number = 0, Friction:Number = 1.00):void
		{
			MotionState = MOTION_CURVE;
			ReachDes = false;
			Speed = 10;
			Acceleration = force;
			DesPos.x = x;
			DesPos.y = y;
			friction = Friction;
			var yDistance:Number = DesPos.y - CurPos.y;
			var xDistance:Number = DesPos.x - CurPos.x;
			var radian:Number = Math.atan2(yDistance, xDistance);
			CurDir = radian + dir * Math.PI / 2;
			
			//Tốc độ quay tỉ lệ nghịch với thời gian đi hết quãng đường
			//t là thời gian đi hết quãng đường (giả sử đi thẳng và gia tốc Acceleration trong 1s)
			var s:Number = Math.sqrt(yDistance * yDistance +  xDistance * xDistance); 
			//vì lực Acceleration ở đây tác động theo frame mà có 24frame/s nên nhân tỉ lệ với ~1/25
			var t:Number = Math.sqrt(s / Acceleration)/25;			
			if(turnSpeed == 0)
			{
				TurnSpeed = ( 4/t) * Math.PI / 180;
			}
			else
			{
				TurnSpeed = turnSpeed;
			}
			
			
			//Thời gian tác dộng của lực tỉ lệ thuận với thời gian đi hết quãng đường
			if (forceTimeOut == 0)
			{
				ForceTimeOut = getTimer() + 0.18*t*3600;			
			}
			else
			{
				ForceTimeOut = getTimer() + forceTimeOut;
			}
		}
		
		
		public function updateCurve():void 
		{
			if (ReachDes)
			{
				return;
			}	
			
			
			var yDistance:Number = DesPos.y - CurPos.y;
			var xDistance:Number = DesPos.x - CurPos.x;
			
			var DesDir:Number = Math.atan2(yDistance, xDistance);
			

			if ( Math.abs(DesDir - CurDir) <= TurnSpeed)
			{
				CurDir = DesDir;
			}
			else
			{				
				var sub:Number = CurDir - DesDir;
				if (sub <= Math.PI && sub >= 0 ) 
				{
					CurDir -= TurnSpeed;
				}
				else if (sub <0  && sub >= -Math.PI )
				{
					CurDir += TurnSpeed;					
				}
			}		

		
			if ( Math.sqrt(yDistance*yDistance +  xDistance*xDistance) <= Speed)
			{				
				CurPos.x = DesPos.x;
				CurPos.y = DesPos.y;
				img.x = CurPos.x;
				img.y = CurPos.y;
				ReachDes = true;
				if (finishMotion != null)
				{
					finishMotion();
				}
			}
			else
			{
				Speed *= friction;
				var vx:Number = Speed * Math.cos(CurDir);
				var vy:Number = Speed * Math.sin(CurDir);
				CurPos.x += vx;
				CurPos.y += vy;
				img.x = CurPos.x;
				img.y = CurPos.y;				
				if (ForceTimeOut > getTimer())
				{
					Speed += Acceleration;
				}
				else
				{					
					TurnSpeed +=  1 * Math.PI / 180;
					if (Speed <= 10)
					{
						Speed = 10;
						CurDir = DesDir;
					}
					if (TurnSpeed > MAX_SPEED_CURVE-10)
					{
						TurnSpeed = MAX_SPEED_CURVE-10;
					}
				}
				if (Speed >= MAX_SPEED_CURVE)
				{
					Speed = MAX_SPEED_CURVE;
				}		
				
				
			}		
		}		
		
		
		public function roomOut(RoomSpeed:Number, MaxRoom:Number ,FadeOutSpeed:Number):void
		{
			roomSpeed = RoomSpeed;
			maxRoom = OrgScaleX * MaxRoom;
			fadeSpeed = FadeOutSpeed;
			MotionState = MOTION_ROOM_OUT;
			Height = img.height;
			Width = img.width;
		}
		
		public function updateRoomOut():void
		{
			img.scaleX += roomSpeed;
			img.scaleY += roomSpeed;
			if (img.scaleX >= maxRoom)
			{
				img.scaleX = img.scaleY = maxRoom;
			}
			img.y = CurPos.y + (Height - img.height)/2;
			img.x = CurPos.x + (Width - img.width)/2;
			img.alpha += fadeSpeed;
			if (img.alpha <= 0)
			{
				if (finishMotion != null)
				{
					finishMotion();
				}
			}
		}		
				
		public function setSpeed(dx:int, dy:int):void 
		{
			SpeedVec.x = dx;
			SpeedVec.y = dy;
		}
		
		
		public function removeSelf():void
		{
			img.removeEventListener(Event.ENTER_FRAME, updateMotionObj);
			Destructor();			
		}		
		
		public override function OnMouseClick(event:MouseEvent):void
		{
			//if (finishMotion != null)
			//{
				//finishMotion();				
			//}
		}
		
		
		public override function OnMouseOver(event:MouseEvent):void
		{
			SetHighLight();
			if (finishMotion != null && isFinishDeform)
			{
				finishMotion();				
			}
		}
		
		
		public override function OnMouseOut(event:MouseEvent):void
		{
			SetHighLight(-1);
		}
		
		public function setScale(scaleX:Number, scaleY:Number):void
		{
			OrgScaleX = img.scaleX = scaleX;
			OrgScaleY = img.scaleY = scaleY;			
		}
		
		static public function createObject(type:String, iLayer:int, imageName:String, xsrc:int, ysrc:int, num:int,data:Object=null):MotionObject 
		{
			if (GuiMgr.getInstance().guiHuntFish.IsVisible)
			{
				switch(type)
				{
					case "Money":
					case "Exp":
					case "RankPointBottle":
					case "Material":
						return new EffNoelItem(LayerMgr.getInstance().GetLayer(iLayer), imageName, xsrc, ysrc, true, ALIGN_LEFT_TOP, num, data);
				}
			}
			switch(type)
			{
				case "EventTeacher":
				case "EventNoel":
					return new EffCurveText(LayerMgr.getInstance().GetLayer(iLayer), imageName, xsrc, ysrc, true, ALIGN_LEFT_TOP, num);
				case "AllChest":
				case "EquipmentChest":
				case "JewelChest":
					return new EffChest(LayerMgr.getInstance().GetLayer(iLayer), imageName, xsrc, ysrc, true, ALIGN_LEFT_TOP, num, data["Rank"]);
				default:
					return new MotionObject(LayerMgr.getInstance().GetLayer(iLayer), imageName, xsrc, ysrc, true, ALIGN_LEFT_TOP, num);
			}
		}
	}

}