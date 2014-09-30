package Event.EventNoel.NoelGui.ItemGui.Bullet 
{
	import Data.ConfigJSON;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	//import Event.EventNoel.NoelGui.ItemGui.EffectEvent.EffBomb;
	import Event.EventNoel.NoelGui.ItemGui.EffectEvent.EffIce;
	import Event.EventNoel.NoelGui.Team.RoundScene;
	import Event.EventNoel.NoelGui.Team.TeamAbstract;
	import Event.EventNoel.NoelLogic.ItemInfo.BulletInfo;
	import Event.EventNoel.NoelLogic.Round.RoundNoel;
	import Event.Factory.FactoryGui.ItemGui.FishAbstract;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Factory.FactoryLogic.EventUtils;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	/**
	 * Quản lý viên đạn content => bay dư lào
	 * @author HiepNM2
	 */
	public class BulletScenario 
	{
		private static var _instance:BulletScenario = null;
		private var _parent:Sprite;				//cha của toàn bộ đối tượng vẽ vào Round
		private var _activeBullets:Object;					//tập những viên đạn đang bay
		private var _autoId:int;							//Id tự động gen ra khi đạn ra
		private var _bulletId:int;							//id của đạn hiện tại
		private var _effectArea:Object;
		private var _fireInfo:Array;			//thông tin về đạn và con cá bị bắn
		private var _useGold:Boolean = false;
		public var InUpdate:Boolean = false;
		public var RoundUpFlag:Boolean = false;
		public var TimeOutFlag:Boolean = false;
		public var inEffIce:Boolean;
		
		private const cfgHeightBullet:Object = { 
													"Bullet": { "1":28.2, "2":29.85, "3":29.9 }, 
													"BulletGold": { "1":25.1 }
													/*"Bullet": { "1":38.2, "2":39.85, "3":39.9 }, 
													"BulletGold": { "1":35.1 }*/
													
												};
		public function BulletScenario() 
		{
			_autoId = 0;
			_bulletId = 1;//mặc định
			_activeBullets = new Object();
			_parent = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER);
			//tạo luôn 3 vùng sát thương
			_effectArea = new Object();
		}
		public static function getInstance():BulletScenario
		{
			if (_instance == null)
			{
				_instance = new BulletScenario();
			}
			return _instance;
		}
		
		/**
		 * Kiểm tra xem còn đạn hay không
		 * @return
		 */
		public function checkHasBullet():Boolean
		{
			var info:BulletInfo = EventSvc.getInstance().getItemInfo("Bullet", _bulletId) as BulletInfo;
			return (info != null && info.Num > 0);
		}
		public function checkHasBulletGold():Boolean
		{
			var info:BulletInfo = EventSvc.getInstance().getItemInfo("BulletGold", _bulletId) as BulletInfo;
			return (info != null && info.Num > 0);
		}
		/**
		 * sinh ra viên đạn
		 * @param	startPos : điểm bắt đầu
		 * @param	desPos : điểm đến (tạm thời)
		 * @param	useXu : viên đạn sinh là là nhờ dùng xu ???
		 * @return có sinh ra được đạn hay không? =true => có sinh đạn =false:không sinh.
		 */
		public function generateBullet(gunPos:Point, desPos:Point):Boolean
		{
			var info:BulletInfo;
			if (_useGold)
			{
				info = new BulletInfo("BulletGold");
				info.ItemId = 1;
				info.UseXu = false;
			}
			else
			{
				info = new BulletInfo("Bullet");
				info.ItemId = _bulletId;
				info.UseXu = GuiMgr.getInstance().guiBtnControl.getIsAuto();
			}
			
			var numCreate:int = 1;
			var listDesPos:Array = [desPos];
			if (info.ItemId == 2)//đạn trùm
			{
				listDesPos.push(EventUtils.rotateVector(gunPos, desPos, -Math.PI / 9));
				listDesPos.push(EventUtils.rotateVector(gunPos, desPos, Math.PI / 9));
				numCreate = 3;
			}
			/*tính điểm ra của viên đạn*/
			var vectorDir:Point = desPos.subtract(gunPos);
			vectorDir.normalize(110);
			var startPos:Point = gunPos.add(vectorDir);
			for (var i:int = 0; i < numCreate; i++)
			{
				var bullet:Bullet = Bullet.createBullet(_parent, info, startPos.x, startPos.y);
				var alpha:Number = Math.atan2(vectorDir.y, vectorDir.x) * 180 / Math.PI + 90;
				bullet.img.rotation = alpha;
				bullet.Id =++_autoId;
				bullet.DesPos = listDesPos[i];
				bullet.findDes();
				_activeBullets[bullet.Id] = bullet;
			}
			
			GuiMgr.getInstance().guiBtnControl.inFire = false;
			var price:int;
			/*xử lý trừ tiền, trừ vàng, trừ đạn của viên đạn sinh ra*/
			if (info.UseXu)//bắn đạn dùng xu
			{
				price = ConfigJSON.getInstance().getItemInfo("Noel_Bullet")["Bullet"][_bulletId]["ZMoney"];
				GameLogic.getInstance().user.UpdateUserZMoney( -price);
			}
			else
			{
				if (info.ItemType == "BulletGold" && info.ItemId == 1)//bắn đạn dùng vàng
				{
					EventSvc.getInstance().updateItem("BulletGold", 1, -1);
				}
				else
				{
					EventSvc.getInstance().updateItem("Bullet", _bulletId, -1);
				}
			}
			GuiMgr.getInstance().guiBtnControl.startTimeFire();
			return true;
		}
		
		public function mergeToBullet(bulletType:String, bulletId:int, useXu:Boolean, num:int):void 
		{
			if (_fireInfo == null)
			{
				_fireInfo = new Array();
			}
			var i:int, o:Object, existBullet:Boolean = false;
			for (i = 0; i < _fireInfo.length; i++)
			{
				o = _fireInfo[i];
				if (o["BulletType"] == bulletType && o["BulletId"] == bulletId && o["IsG"] == useXu)
				{
					existBullet = true;
					o["Num"] += num;
					break;
				}
			}
			if (!existBullet)
			{
				o = new Object();
				o["BulletType"] = bulletType;
				o["BulletId"] = bulletId;
				o["IsG"] = useXu;
				o["Num"] = num;
				_fireInfo.push(o);
			}
		}
		
		public function update(curTime:Number):void
		{
			var i:String, b:Bullet;
			var count:int = 0;
			for (i in _activeBullets)
			{
				count++;
				b = _activeBullets[i];
				if (RoundUpFlag || TimeOutFlag)
				{
					break;
				}
				else
				{
					b.update();
					checkOutOfScreen(b);
				}
			}
		}
		
		public function mergeToFishs(bulletType:String, bulletId:int, idFish:int, useXu:Boolean, num:int):void 
		{
			var i:int, o:Object, temp:Array, j:int, f:Object;
			var hasFish:Boolean = false;
			for (i = 0; i < _fireInfo.length; i++)
			{
				o = _fireInfo[i];
				if (o["BulletType"] == bulletType && o["BulletId"] == bulletId && o["IsG"] == useXu)
				{
					if (o["Fishs"] == null)
					{
						o["Fishs"] = new Array();
					}
					temp = o["Fishs"];
					for (j = 0; j < temp.length; j++)
					{
						f = temp[j];
						if (f["Id"] == idFish)
						{
							hasFish = true;
							f["Num"] += num;
							break;
						}
					}
					if (!hasFish)
					{
						f = new Object();
						f["Id"] = idFish;
						f["Num"] = num;
						temp.push(f);
					}
					break;
				}
			}
		}
		
		private function checkOutOfScreen(b:Bullet):Boolean 
		{
			if (!b.InScreen)
			{
				removeBullet(b.Id);
				return true;
			}
			return false;
		}
		
		public function removeBullet(idBullet:int):void 
		{
			var b:Bullet = _activeBullets[idBullet];
			//trace("merge:", _bulletId);
			mergeToBullet(b.ItemType, b.ItemId, b.UseXu, 1);
			var listFish:Array = b.getListFish();
			if (listFish != null)
			{
				var temp:Object;
				for (var i:int = 0; i < listFish.length; i++)//merge những con cá đã trúng bởi viên đạn này vào mảng đạn
				{
					temp = listFish[i];
					mergeToFishs(b.ItemType, b.ItemId, temp["Id"], b.UseXu, temp["Num"]);
				}
			}
			
			b.Destructor();
			delete(_activeBullets[idBullet]);
		}
		
		public function removeAllBullet():void
		{
			for (var idBullet:String in _activeBullets)
			{
				removeBullet(int(idBullet));
			}
		}
		
		public function set bulletId(value:int):void { _bulletId = value; }
		public function get bulletId():int { return _bulletId; }
		public function set UseGold(val:Boolean):void { _useGold = val; }
		public function get UseGold():Boolean { return _useGold; }
		public function get FireInfo():Array { return _fireInfo; }
		public function get ActiveBullets():Object { return _activeBullets; }
		
		
		private function removeEffectArea():void
		{
			for (var i:String in _effectArea)
			{
				var effArea:Image = _effectArea[i];
				_parent.removeChild(effArea.img);
				effArea.Destructor();
				delete(_effectArea[i]);
			}
		}
		
		public function Destructor():void
		{
			_autoId = 0;
			removeAllBullet();
			removeEffectArea();
			
		}
		public function flushAllFireInfo():void
		{
			if (_fireInfo == null) return;
			for (var i:int = 0; i < _fireInfo.length; i++)
			{
				var o:Object = _fireInfo[i];
				var ptr:Array = o["Fishs"];
				if (ptr != null)
				{
					for (var j:int = 0; j < ptr.length; j++)
					{
						ptr[j] = null;
					}
					ptr.splice(0, ptr.length);
				}
				_fireInfo[i] = null;
			}
			_fireInfo.splice(0, _fireInfo.length);
		}
		
		public function contructor():void 
		{
			for (var i:int = 1; i <= 3; i++)
			{
				_effectArea[i] = new Image(_parent, "GuiHuntFish_EffBum" + i, -1000, -1000);
			}
			RoundUpFlag = false;
		}
		
		public function useRainIce(type:String, id:int):void 
		{
			var activeTeams:Object = RoundScene.getInstance().ActiveTeams;
			var activeFishs:Array, team:TeamAbstract, fish:FishAbstract, idTeam:String, i:int, x:int, y:int;
			
			mergeToBullet(type, id, false, 1);
			inEffIce = true;
			var fJoin:Function = function():void
			{
				for (idTeam in activeTeams)
				{
					team = activeTeams[idTeam];
					activeFishs = team.ActiveFish;
					for (i = 0; i < activeFishs.length; i++)
					{
						fish = activeFishs[i];
						if (!fish.inIce)
						{
							fish.inIce = true;
							if (fish.getInScreen() || RoundScene.getInstance().Round.IdRound == RoundNoel.ROUND_BOSS)
							{
								fish.freeze();
							}
						}
					}
				}
			}
			var swfIce:EffIce = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER,
																		"GuiHuntFish_EffRainIce", null,
																		Constant.STAGE_WIDTH / 2,
																		Constant.STAGE_HEIGHT / 2,
																		false, false,null, fComp) as EffIce;
			swfIce.funcJoin = fJoin;
			function fComp():void
			{
				inEffIce = false;
				RoundScene.getInstance().useIce();
				GuiMgr.getInstance().guiBtnControl.startUseIce();
			}
		}
	}
}




















