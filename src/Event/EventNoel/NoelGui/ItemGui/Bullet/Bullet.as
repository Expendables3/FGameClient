package Event.EventNoel.NoelGui.ItemGui.Bullet 
{
	import Event.EventNoel.NoelGui.Team.RoundScene;
	import Event.EventNoel.NoelGui.Team.TeamAbstract;
	import Event.EventNoel.NoelLogic.ItemInfo.BulletInfo;
	import Event.Factory.FactoryGui.ItemGui.ImgObject;
	import flash.geom.Point;
	import GUI.component.Image;
	
	/**
	 * Viên đạn
	 * @author HiepNM2
	 */
	public class Bullet extends ImgObject 
	{
		private const THICKNESS:Number = 100;
		private var _bulletInfo:BulletInfo;
		private var _id:int;
		protected var _accelleration:Number = 0.5;			//gia tốc theo frame
		protected var _startSpeed:Number = 5;				//vận tốc ban đầu theo frame
		private var tail:Image;
		private var _listFish:Array;
		public function getListFish():Array { return _listFish; }
		public function pushFish(idFish:int, num:int):void//push con cá vào mảng _listFish
		{
			if (_listFish == null)
			{
				_listFish = [];
			}
			var expired:Boolean = false;
			var temp:Object;
			for (var i:int = 0; i < _listFish.length; i++)
			{
				temp = _listFish[i];
				if (temp["Id"] == idFish)
				{
					expired = true;
					temp["Num"] += num;
					break;
				}
			}
			if (!expired)
			{
				temp = new Object();
				temp["Id"] = idFish;
				temp["Num"] = num;
				_listFish.push(temp);
			}
		}
		
		public function Bullet(parent:Object, bulletInfo:BulletInfo, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false, SetInfo:Function=null, ImageId:String="") 
		{
			_bulletInfo = bulletInfo;
			super(parent, _bulletInfo.getBulletFireName(), x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
			ClassName = "Bullet";
		}
		
		public static function createBullet(parent:Object, bulletInfo:BulletInfo, 
									x:int = 0, y:int = 0, 
									isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, 
									toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = ""):Bullet
		{
			switch(bulletInfo.ItemType)
			{
				case "Bullet":
					switch(bulletInfo.ItemId)
					{
						case 1:
							return new SweetBullet(parent, bulletInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
						case 2:
							return new CoverBullet(parent, bulletInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
						case 3:
							return new ThroughBullet(parent, bulletInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
					}
					break;
				case "BulletGold":
					switch(bulletInfo.ItemId)
					{
						case 1:
							return new GoldBullet(parent, bulletInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
					}
					break;
			}
			return new Bullet(parent, bulletInfo, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, ImageId);
		}
		override public function OnLoadResComplete():void 
		{
			var loadTailComp:Function = function():void
			{
				this.img.hitArea = null;
			}
			tail = new Image(this.img, "GuiHuntFish_EffTail", -3, -8, true, ALIGN_LEFT_TOP, false, loadTailComp);
		}
		override public function update():Boolean 
		{
			if (_speedVec == null)_speedVec = new Point();
			_speedVec.normalize(_speedVec.length + 0.5);
			var reachDes:Boolean = !super.update();
			//checkCollection();
			if (reachDes)//nếu mà đã đến đích
			{
				var des:Point = findDes();
				prepareMoving(des);
				return false;
			}
			return true;
		}
		
		/**
		 * tìm điểm đến tiếp theo
		 * @return điểm đến tiếp theo
		 */
		public function findDes():Point 
		{
			var temp:Point = _desPos.subtract(CurPos);
			temp.normalize(THICKNESS);
			return _desPos.add(temp);
		}
		override protected function countDir(des:Point):Number 
		{
			var vectorDir:Point = des.subtract(CurPos);
			var alpha:Number = Math.atan2(vectorDir.y, vectorDir.x) * 180 / Math.PI + 90;
			return alpha;
		}
		override public function prepareMoving(des:Point, hasAccelleration:Boolean = false):void 
		{
			img.rotation = countDir(des);
			moveTo(des, _startSpeed);//tạm thời để tăng vận tốc
			//super.prepareMoving(des, hasAccelleration);//tạm thời comment để tăng vận tốc
		}
		override public function Destructor():void 
		{
			if (_listFish != null)
			{
				for (var i:int = 0; i < _listFish.length; i++)
				{
					delete(_listFish[i]["Id"]);
					delete(_listFish[i]["Num"]);
					_listFish[i] = null;
				}
				_listFish.splice(0, _listFish.length);
			}
			super.Destructor();
			_bulletInfo = null;
		}
		3
		public virtual function IsRemoveAfterCollision():Boolean { return true; }
		public function set Id(value:int):void { _id = value; }
		public function get Id():int { return _id; }
		public function get ItemId():int { return _bulletInfo.ItemId; }
		public function get ItemType():String { return _bulletInfo.ItemType; }
		public function get UseXu():Boolean { return _bulletInfo.UseXu; }
	}

}












