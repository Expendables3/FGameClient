package Event.EventNoel.NoelGui.Team 
{
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import Event.Factory.FactoryGui.ItemGui.ImgObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class RoundBossTeams extends TeamAbstract 
	{
		protected const MAX_RADIUS:Number = 200;
		protected var _guiParent:ImgObject;
		public function RoundBossTeams(team:TeamAbstractInfo) 
		{
			super(team);
		}
		override public function draw(Parent:Sprite):void 
		{
			initGuiParent(Parent);
			drawTeam();
		}
		
		private function initGuiParent(Parent:Sprite):void 
		{
			_guiParent = RoundScene.getInstance().guiBossTeam;
			_guiParent.SetPos(Constant.STAGE_WIDTH / 2, Constant.STAGE_HEIGHT / 2);
		}
		
		protected virtual function drawTeam():void { }
		
		static public function createTeam(team:TeamAbstractInfo):RoundBossTeams 
		{
			switch(team.TypeTeam)
			{
				case TeamAbstractInfo.BOSS:
					return new BossTeam(team);
				case TeamAbstractInfo.CIRCLE:
					return new CircleTeam(team);
				default:
					return new CircleTeam(team);
			}
		}
		override public function getPosBum(x:Number, y:Number):Point 
		{
			if (_guiParent == null)
			{
				return new Point(x, y);
			}
			else
			{
				return new Point(_guiParent.img.x + x, _guiParent.img.y + y);
			}
			
		}
	}

}











