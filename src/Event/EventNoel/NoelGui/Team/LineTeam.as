package Event.EventNoel.NoelGui.Team 
{
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * Đội hình 1 hàng
	 * @author HiepNM2
	 */
	public class LineTeam extends TeamAbstract 
	{
		
		public function LineTeam(team:TeamAbstractInfo) 
		{
			super(team);
		}
		
		override public function draw(Parent:Sprite):void 
		{
			super.draw(Parent);//vẽ hàng ngang
		}
		override protected function getKingDes(curPos:Point, dir:Point, minX:Number, minY:Number, isAppear:Boolean):Point 
		{
			var des:Point = super.getKingDes(curPos, dir, minX, minY,isAppear);
			//des.y = curPos.y;
			return des;
		}
		override protected function getDes(curFishStartPos:Point, preFishStartPos:Point, preFishDesPos:Point):Point 
		{
			return preFishStartPos;
			//return super.getDes(curFishStartPos, preFishStartPos, preFishDesPos);
		}
	}

}



























