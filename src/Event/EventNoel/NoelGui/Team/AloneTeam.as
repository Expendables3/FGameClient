package Event.EventNoel.NoelGui.Team 
{
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.component.Image;
	import Logic.Ultility;
	/**
	 * Với những team chỉ có 1 con cá ;))
	 * @author HiepNM2
	 */
	public class AloneTeam extends TeamAbstract 
	{
		
		public function AloneTeam(team:TeamAbstractInfo) 
		{
			super(team);
		}
		override public function draw(Parent:Sprite):void 
		{
			super.draw(Parent);//thực ra chỉ có 1 con cá :D
		}
		override protected function getKingDes(curPos:Point, dir:Point, minX:Number, minY:Number, isAppear:Boolean):Point 
		{
			return super.getKingDes(curPos, dir, minX, minY, isAppear);
		}
		
		override protected function getDes(curFishStartPos:Point, preFishStartPos:Point, preFishDesPos:Point):Point 
		{
			return super.getDes(curFishStartPos, preFishStartPos, preFishDesPos);
		}
	}

}






















