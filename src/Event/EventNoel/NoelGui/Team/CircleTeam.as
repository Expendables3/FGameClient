package Event.EventNoel.NoelGui.Team 
{
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import Event.Factory.FactoryGui.ItemGui.FishAbstract;
	import Event.Factory.FactoryLogic.EventUtils;
	import Event.Factory.FactoryLogic.ItemInfo.FishAbstractInfo;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.component.Image;
	/**
	 * Đội mà bơi theo vòng tròn: 
		 * Xuất hiện ngay trên màn hình
		 * bơi vòng quanh 1 tâm cố định
	 * @author HiepNM2
	 */
	public class CircleTeam extends RoundBossTeams 
	{
		private const speed:int = 5;		//tốc độ từng con
		private static var _radius:Number = 120;	//bán kính vòng tròn, sẽ tăng khi thêm team
		private var _center:Point;			//tâm vòng tròn
		
		public function CircleTeam(team:TeamAbstractInfo) 
		{
			super(team);
		}
		/**
		 * vẽ team theo đội hình vòng tròn với parent là _guiParent
		 */
		override protected function drawTeam():void 
		{
			_center = new Point(0, 0);
			_startPoint.x = _center.x; _startPoint.y = _center.y - _radius;
			var info:FishAbstractInfo, f:FishAbstract;
			var p:Point = new Point(_startPoint.x, _startPoint.y);
			var dAlpha:Number = 2 * Math.PI / _team.NumFish;
			var oFish:Object = _team.getListFish();
			_oFish = [];
			var realMaxSpeedFish:Number = _team.getIdCircle() == 1 ? 5 : 8;
			var loadComp:Function = function():void
			{
				var alpha:Number = EventUtils.calculateAlpha(_center, _startPoint, this.CurPos);
				this.img.rotation = alpha * 180 / Math.PI;
			}
			for (var id:String in oFish)
			{
				info = oFish[id];
				f = FishAbstract.createFish(_guiParent.img, info, p.x, p.y/*, true, Image.ALIGN_LEFT_TOP, false, loadComp*/);
				f.IsAppear = true;
				f.RealMaxSpeed = realMaxSpeedFish;
				_oFish.push(f);
				p = EventUtils.rotateVector(_center, p, dAlpha);
			}
			_radius += 80; 
			_radius = _radius == 280 ? 120 : 200;
		}
		
		override public function update():void 
		{
			swimAllFish();
		}
		private function swimAllFish():void
		{
			if (_reachDes)//tất cả các con cá trong đàn đã đến đích
			{
				findDes();//->tìm điểm đến
				return;
			}
			var f:FishAbstract, i:int, reachDes:Boolean = true;
			for (i = 0; i < _oFish.length; i++)
			{
				f = _oFish[i];
				f.swim();
				if (checkCollision(f))
				{
					continue;
				}
				if (f.ReachDes)//con cá thứ i đến đích
				{
					findDes2(i);//->tìm điểm đến
				}
				reachDes &&= f.ReachDes;
			}
			_reachDes = reachDes;
		}
		override protected function findDes():void 
		{
			var f:FishAbstract, i:int, des:Point, alpha:Number;
			var dir:int = _team.getIdCircle() == 1 ? 1 : -1;
			const speedRadian:Number = dir * Math.PI / 6;//vận tốc góc
			for (i = 0; i < _oFish.length; i++)
			{
				f = _oFish[i];
				des = EventUtils.rotateVector(_center, f.CurPos, speedRadian);
				f.prepareMoving(des);
				alpha = EventUtils.calculateAlpha(_center, _startPoint, des);
				f.img.scaleX = dir;
				f.img.rotation = alpha * 180 / Math.PI;
			}
			_reachDes = false;
		}
		override protected function findDes2(index:int):void 
		{
			var dir:int = _team.getIdCircle() == 1 ? 1 : -1;
			const speedRadian:Number = dir * Math.PI / 6;//vận tốc góc
			var f:FishAbstract = _oFish[index];
			var des:Point = EventUtils.rotateVector(_center, f.CurPos, speedRadian);
			f.prepareMoving(des);
			var alpha:Number = EventUtils.calculateAlpha(_center, _startPoint, des);
			f.img.scaleX = dir;
			f.img.rotation = alpha * 180 / Math.PI;
		}
	}

}

































