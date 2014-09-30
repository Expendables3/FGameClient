package Event.Factory.FactoryGui.ItemGui 
{
	import flash.geom.Point;
	import GUI.component.Image;
	
	/**
	 * Thể hiện đối tượng chuyển động cơ bản
		* Những đối tượng mang tính chuyển động nên kế thừa
	 * @author HiepNM2
	 */
	public class ImgObject extends Image 
	{
		protected const SPEED:Number = 2;
		protected var _desPos:Point;				//tọa độ đích
		protected var _speedVec:Point;				//vận tốc theo frame (hướng + độ lớn of vận tốc) độ lớn _speedVec.length = _spedd
		protected var _reachDes:Boolean = true;			//đến đích?
		
		protected var _guiStatus:GuiStatusAbstract;
		public function ImgObject(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "ImgObject";
		}
		protected function changeImage(imageName:String):void
		{
			Destructor();//hủy
			LoadRes(imageName);//load
		}
		/**
		 * chuẩn bị di chuyển
		 * @param	des : vị trí sẽ đi đến 
		 * @param	hasAccelleration : có gia tốc hem?
		 */
		public virtual function prepareMoving(des:Point, hasAccelleration:Boolean = false):void 
		{ 
			if (hasAccelleration)
			{
				moveTo(des, 1);
			}
			else
			{
				moveTo(des, SPEED);
			}
		}
		/**
		 * chuẩn bị tham số _speedVec cho việc di chuyển đến (x,y)
		 * @param	des : tọa độ đích
		 * @param	speed : độ lớn của _speedVec
		 */
		protected function moveTo(des:Point, speed:Number):void
		{
			_reachDes = false;
			_desPos = des;
			_speedVec = _desPos.subtract(CurPos);
			_speedVec.normalize(speed);
		}
		/**
		 * chuyển hướng vật thể
		 * @param	des vị trí đích đến
		 */
		protected virtual function countDir(des:Point):Number 
		{
			var temp:Point = des.subtract(CurPos);
			var dir:Number = Math.atan2(temp.y, temp.x) * 180 / Math.PI;
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
			return dir;
		}
		
		protected virtual function changeDir(rotation:Number):void
		{
			img.rotation = rotation;
			/*if (_guiStatus != null && _guiStatus.IsVisible)
			{
				_guiStatus.img.rotation = rotation;
			}*/
		}
		/**
		 * check vật thể vẫn ở trong màn hình?
		 */
		public function get InScreen():Boolean
		{
			const left:Number = 0;
			const top:Number = 0;
			const right:Number = 824;
			const bot:Number = 600;
			
			var leftFish:Number = img.x - img.width;
			var rightFish:Number = img.x + img.width;
			var topFish:Number = img.y - img.height;
			var botFish:Number = img.y + img.height;
			if (rightFish < left || leftFish > right || botFish < top || topFish > bot)
			{
				return false;
			}
			return true;
		}
		
		public function showGuiStatus():void
		{
			if(!_guiStatus.IsVisible)
				_guiStatus.Show();
		}
		public function hideGuiStatus():void
		{
			if(_guiStatus.IsVisible)
				_guiStatus.Hide();
		}
		public virtual function update():Boolean
		{
			if (_reachDes)
			{
				return false;
			}
			var temp:Point = _desPos.subtract(CurPos);
			if (temp.length < _speedVec.length)
			{
				_reachDes = true;
				return false;
			}
			CurPos = CurPos.add(_speedVec);
			img.x = CurPos.x; 
			img.y = CurPos.y;
			if (_guiStatus && _guiStatus.hasUpdate)
			{
				_guiStatus.CurPos = _guiStatus.CurPos.add(_speedVec);
				_guiStatus.img.x = _guiStatus.CurPos.x;
				_guiStatus.img.y = _guiStatus.CurPos.y;
			}
			return true;
		}
		
		/**
		 * hủy đối tượng
		 */
		override public function Destructor():void 
		{
			if (_guiStatus)
			{
				_guiStatus.Destructor();
				_guiStatus = null;
			}
			Parent.removeChild(img);
			super.Destructor();
			_desPos = null;
			_speedVec = null;
		}
		public function get ReachDes():Boolean { return _reachDes; }
		public function set DesPos(val:Point):void { _desPos = val; }
		public function get DesPos():Point { return _desPos; }
	}

}

















