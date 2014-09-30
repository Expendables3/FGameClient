package Logic 
{
	import flash.geom.Point;
	import GameControl.GameController;
	import GUI.GuiMgr;
	/**
	 * ...
	 * @author tuan
	 */
	public class Food extends BaseObject
	{
		public static const F_IDLE:int = 0;
		public static const F_FALL:int = 1;
		
		public var CurDir:Number = 90;
		public var TurnSpeed:Number = 4;
		public var Speed:Number = 3;
		public var MovingSate:int = F_FALL;
		public var FishId:int;
		public var Amount:Number = 0;
		
		public function Food(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			FishId = -2;
		}
		
		public function UpdateFood():void
		{
			switch(MovingSate)
			{
				case F_IDLE:
					break;
				case F_FALL:
					Fall();
					break;
			}			
		}
		
		public function Fall():void
		{
			if (CurPos.equals(DesPos))
			{
				nextDes();
			}
			else
			{
				var s:Point = DesPos.subtract(CurPos);
				var DesDirDegree:Number = Math.atan2(s.y, s.x) * 180 / Math.PI;
				DesDirDegree = DesDirDegree % 360;
				CurDir = CurDir % 360;
				
				if (DesDirDegree == CurDir)
				{

				}
				else if (Math.abs(DesDirDegree - CurDir) <= TurnSpeed)
				{
					CurDir = DesDirDegree;
				}
				else
				{
					
					var sub:Number = CurDir - DesDirDegree;
					if(sub < 0)
						sub += 360;
					if ( (sub <= 180 ) && (sub >= 0 ))
					{
						CurDir -= TurnSpeed;
					}
					else if ((sub > 180 ) && (sub < 360 ))
					{
						CurDir += TurnSpeed;
						if(CurDir >= 360)
						{
							CurDir = CurDir%360;
						}
					}
				}

				if (s.length <= Speed)
				{
					SetPos(DesPos.x, DesPos.y);
				}
				else
				{
					var v:Point = new Point;
					v.x = Speed * Math.cos(CurDir*Math.PI/180);
					v.y = Speed * Math.sin(CurDir*Math.PI/180);
					
					CurPos = CurPos.add(v);
					SetPos(CurPos.x, CurPos.y);
				}
			}
		}
		
		
		public function nextDes():void
		{
			var p:Point = CurPos.clone();
			DesPos.x = p.x + Ultility.RandomNumber(-50, 50);
			DesPos.y = p.y + 50;
			CurDir = 90;
			if (DesPos.y > GameController.getInstance().GetLakeBottom() + Ultility.RandomNumber( -30, 0))
			{
				MovingSate = F_IDLE;
				FishId = -1;
			}
		}
		
		public function Eated(id:int, amount:Number):void
		{
			this.FishId = id;
			this.Amount = amount;
		}
	}

}