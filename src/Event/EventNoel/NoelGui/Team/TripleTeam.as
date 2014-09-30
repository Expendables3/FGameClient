package Event.EventNoel.NoelGui.Team 
{
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import Event.Factory.FactoryGui.ItemGui.FishAbstract;
	import Event.Factory.FactoryLogic.ItemInfo.FishAbstractInfo;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.component.Image;
	import Logic.Ultility;
	/**
	 * Đội hình tam giác ;))
	 * @author HiepNM2
	 */
	public class TripleTeam extends TeamAbstract 
	{
		
		public function TripleTeam(team:TeamAbstractInfo) 
		{
			super(team);
		}
		/**
		 * vẽ đội hình tam giác
		 * @param	Parent
		 */
		override public function draw(Parent:Sprite):void 
		{
			var info:FishAbstractInfo, f:FishAbstract, p:Point;
			var oFish:Object = _team.getListFish();
			var index:int = 1;
			var assign:int = _startPoint.x > 0 ? 1 : -1;
			_oFish = [];
			var loadComp:Function = function():void
			{
				this.img.scaleX = assign > 0 ? -1 : 1;
				this.drawProgress();
			}
			for (var id:String in oFish)
			{
				p = getInitPos(index);
				info = oFish[id];
				f = FishAbstract.createFish(Parent, info, p.x, p.y, true, Image.ALIGN_LEFT_TOP, true, loadComp);//cache bitmap cho con cá trong đội hình tam giác => vì nó chỉ bơi thẳng và không xoay
				_oFish.push(f);
				index++;
			}
		}
		/**
		 * nhập vào con cá số mấy (cho biết vị trí khởi tạo của nó)
		 * @param	index số thứ tự của con cá
		 * @return vị trí của nó trong đội hình tam giác
		 */
		private function getInitPos(index:int):Point
		{
			const deltaY:int = 60;		//khoảng cách Y giữa 2 con cá cùng hàng
			const deltaX:int = 100;		//khoảng cách X giữa 2 con cá ở 2 hàng liên tiếp
			var xStart:int = _startPoint.x;
			var yStart:int = _startPoint.y;
			var assign:int = xStart > 0 ? 1 : -1;
			var row:int = 0;//với index này thì nó ở hàng nào
			var col:int = 0;//với index này thì nó ở cột nào
			while (index > 0)
			{
				row++;
				for (col = 0; col < row; col++)
				{
					if (--index == 0) break;
				}
			}
			row--;
			var x:int = xStart + row * deltaX * assign;
			var y:int = yStart + col * deltaY - (deltaY * row) / 2;
			return new Point(x, y);
		}
		
		override protected function getKingDes(curPos:Point, dir:Point, minX:Number, minY:Number, isAppear:Boolean):Point 
		{
			var des:Point = new Point();
			var dirx:int = dir.x > 0 ? 1 : -1;
			des.x = curPos.x + dirx * (minX + Ultility.RandomNumber(100, 200));
			des.y = curPos.y;
			return des;
		}
		
		override protected function getDes(curFishStartPos:Point, preFishStartPos:Point, preFishDesPos:Point):Point 
		{
			var temp:Point = preFishDesPos.subtract(preFishStartPos);	//vector tịnh tiến
			var des:Point = curFishStartPos.add(temp);					//tịnh tiến đến điểm đó
			return des;
		}
	}

}





































