package Event.EventNoel.NoelGui.Team
{
	import Event.EventNoel.NoelGui.ItemGui.Bullet.BulletScenario;
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import Event.Factory.FactoryGui.ItemGui.FishAbstract;
	import Event.Factory.FactoryGui.ItemGui.ImgObject;
	import Event.Factory.FactoryLogic.ItemInfo.FishAbstractInfo;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.component.Image;
	import Logic.Ultility;
	
	/**
	 * Chỉ có con boss
	 * @author HiepNM2
	 */
	public class BossTeam extends RoundBossTeams
	{
		public function BossTeam(team:TeamAbstractInfo)
		{
			super(team);
		}
		
		override protected function drawTeam():void
		{
			drawDefault(_guiParent.img, 0, 0);
			var f:FishAbstract = _oFish[0];
			f.IsAppear = true;
			f.RealMaxSpeed = 4;
		}
		
		override public function update():void
		{
			if (_guiParent.ReachDes)
			{
				findDes();
			}
			else
			{
				var f:FishAbstract = _oFish[0];
				checkCollision(_oFish[0]);
				if (!BulletScenario.getInstance().RoundUpFlag)
				{
					if(!f.inIce)
						_guiParent.update();
				}
			}
			
		}
		override protected function findDes():void 
		{
			var des:Point = new Point();
			var curPos:Point = _guiParent.CurPos;
			des.x = curPos.x + Ultility.RandomNumber( -100, 100);
			if (des.x + MAX_RADIUS > 824)
			{
				des.x = 824 - MAX_RADIUS;
			}
			else if (des.x - MAX_RADIUS < 0)
			{
				des.x = MAX_RADIUS;
			}
			des.y = curPos.y + Ultility.RandomNumber( -100, 100);
			if (des.y + MAX_RADIUS > 450)
			{
				des.y = 450 - MAX_RADIUS;
			}
			else if (des.y - MAX_RADIUS < 0)
			{
				des.y = MAX_RADIUS;
			}
			_guiParent.prepareMoving(des);
		}
	}

}
















