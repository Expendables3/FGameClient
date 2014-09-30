package Event.EventNoel.NoelGui.Team 
{
	import Data.ConfigJSON;
	import Effect.BitmapEffect;
	import Effect.EffectMgr;
	import Effect.SwfEffect;
	import Event.EventNoel.NoelGui.ItemGui.Bullet.Bullet;
	import Event.EventNoel.NoelGui.ItemGui.Bullet.BulletScenario;
	import Event.EventNoel.NoelLogic.Round.RoundNoel;
	import Event.EventNoel.NoelLogic.TeamInfo.TeamAbstractInfo;
	import Event.Factory.FactoryGui.ItemGui.FishAbstract;
	import Event.Factory.FactoryLogic.EventSvc;
	import Event.Factory.FactoryLogic.EventUtils;
	import Event.Factory.FactoryLogic.ItemInfo.FishAbstractInfo;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.component.Image;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	/**
	 * Đội hình cá
	 * @author HiepNM2
	 */
	public class TeamAbstract 
	{
		protected var _team:TeamAbstractInfo;//thông tin đàn cá
		protected var _oFish:Array;			//mảng cá hiển thị lên màn hình
		protected var _startPoint:Point;		//điểm bắt đầu của con đầu đàn
		protected var _parent:Sprite;		//parent để vẽ con cá lên đó
		protected var _isAppearAll:Boolean;	//các con cá đã xuất hiện hết trên màn hình chưa=> dựa vào từng con cá
		protected var _reachDes:Boolean = true;	//cả đàn đã đến đích
		protected var _idKing:int;			//id của con cá đầu đàn
		
		private const cfgHeightBullet:Object = { 
													"Bullet": { "1":28.2, "2":29.85, "3":29.9 }, 
													"BulletGold": { "1":25.1 }
												};
		private const cfgWidthBullet:Object = { 
													"Bullet": { "1":19.65, "2":20.65, "3":23.1 }, 
													"BulletGold": { "1":16.65 }
												};
		private const cfgHeightBodyBullet:Object = {
													"Bullet": { "1":23.75, "2":25.8, "3":26.75 }, 
													"BulletGold": { "1":18.95 }
												};
		
		public function TeamAbstract(team:TeamAbstractInfo) 
		{
			_team = team;
			_isAppearAll = false;
		}
		
		public static function createTeam(team:TeamAbstractInfo):TeamAbstract
		{
			switch(team.TypeTeam)
			{
				case TeamAbstractInfo.ALONE:
					return new AloneTeam(team);
				case TeamAbstractInfo.LINE:
					return new LineTeam(team);
				case TeamAbstractInfo.TRIPLE:
					return new TripleTeam(team);
				case TeamAbstractInfo.CIRCLE:
				case TeamAbstractInfo.BOSS:
					return RoundBossTeams.createTeam(team);
			}
			return new TeamAbstract(team);
		}
		/**
		 * vẽ đội hình theo hàng ngang
		 * @param	Parent
		 */
		protected function drawDefault(Parent:Sprite, x:int, y:int):void
		{
			var info:FishAbstractInfo, f:FishAbstract;
			var oFish:Object = _team.getListFish();
			var assign:int = x > 0 ? 1 : -1;
			_oFish = [];
			var loadComp:Function = function():void
			{
				this.img.scaleX = assign > 0 ? -1 : 1;
				this.drawProgress();
			}
			for (var id:String in oFish)
			{
				info = oFish[id];
				f = FishAbstract.createFish(Parent, info, x, y, true, Image.ALIGN_LEFT_TOP, false, loadComp);
				_oFish.push(f);
				x += assign * 100;
			}
		}
		/**
		 * cập nhật cả đàn
		 */
		public virtual function update():void 
		{ 
			var f:FishAbstract;
			if (!_isAppearAll)//nếu cả đàn chưa xuất hiện hết
			{
				var isAppearAll:Boolean = true;
				for (var i:int = 0; i < _oFish.length; i++)
				{
					f = _oFish[i];
					isAppearAll &&= f.checkAppear();
				}
				_isAppearAll = isAppearAll;
			}
			swimAll();
		}
		
		protected function swimAll():void 
		{
			if (_reachDes)
			{
				findDes();//tìm điểm đến cho tất cả các con cá trong đàn
				return;
			}
			var f:FishAbstract, i:int, reachDes:Boolean = true;
			for (i = 0; i < _oFish.length; i++)
			{
				f = _oFish[i];
				f.swim();
				if (checkCollision(f))//có roundUp
				{
					continue;
				}
				if (f.ReachDes)
				{
					findDes2(i);
				}
				if (f.IsAppear)
				{
					checkOutOfScreen(f);
				}
				reachDes &&= f.ReachDes;
			}
			_reachDes = reachDes;
		}
		/**
		 * Kiểm tra va chạm của con cá trong team với các viên đạn đang active trên hồ
		 * @param	f con cá đem đi check hàng
		 * @return con cá có bị chết hay không
		 */
		protected function checkCollision(f:FishAbstract):Boolean 
		{
			var activeBullets:Object = BulletScenario.getInstance().ActiveBullets;//tập đạn trên hồ
			var bullet:Bullet, hasDeath:Boolean;
			var swfBum:SwfEffect;
			//var swfBum:BitmapEffect;
			var bulletType:String, bulletId:int, idFish:int, useXu:Boolean;
			for (var idBullet:String in activeBullets)
			{
				bullet = activeBullets[idBullet];
				if (f.checkBullet(int(idBullet)))//nếu đã dính viên đạn này -> xét tiếp các viên khác
				{
					continue;
				}
				//tính toán 3 điểm va chạm của viên đạn này
				var alpha:Number = bullet.img.rotation * Math.PI / 180;
				var heightBullet:Number = cfgHeightBullet[bullet.ItemType][bullet.ItemId];
				var heightBodyBullet:Number = cfgHeightBodyBullet[bullet.ItemType][bullet.ItemId];
				var widthBullet:Number = cfgWidthBullet[bullet.ItemType][bullet.ItemId];
				var o:Point = new Point(bullet.img.x, bullet.img.y);
				var p1:Point = new Point(o.x, o.y - heightBullet);
				p1 = EventUtils.rotateVector(o, p1, alpha);
				var p2:Point = new Point(o.x - widthBullet / 2, o.y - heightBodyBullet);
				p2 = EventUtils.rotateVector(o, p2, alpha);
				var p3:Point = new Point(o.x + widthBullet / 2, o.y - heightBodyBullet);
				p3 = EventUtils.rotateVector(o, p3, alpha);
				
				if ((f.img.hitTestPoint(p1.x, p1.y) || f.img.hitTestPoint(p2.x, p2.y) || f.img.hitTestPoint(p3.x, p3.y))&& f.IsAppear)
				{//chạm cá (cá đã xuất hiện)
					var round:RoundNoel = RoundScene.getInstance().Round;
					var posBum:Point = getPosBum(f.img.x, f.img.y);
					f.pushToListBullet(int(idBullet));
					swfBum = EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER,
																"GuiHuntFish_EffBullet" + bullet.ItemId,
																null, posBum.x, posBum.y, false, false, null, null);
					
					bulletType = bullet.ItemType;
					bulletId = bullet.ItemId;
					useXu = bullet.UseXu;
					idFish = f.Id;
					bullet.pushFish(idFish, 1);//đẩy con cá bị trúng đạn vào mảng cá của viên đạn
					if (bullet.IsRemoveAfterCollision())
					{
						if (activeBullets[idBullet] != null)
						{
							BulletScenario.getInstance().removeBullet(int(idBullet));
						}
					}
					var gifts:Array = [];
					var isRemoveFish:Boolean = !fired(bulletType, bulletId, idFish, gifts);//nếu remove con cá
					if (isRemoveFish)
					{
						hasDeath = true;//có chết chóc
						round.updateNum(1);
						GuiMgr.getInstance().guiBtnControl.updateFishDie();
						BulletScenario.getInstance().RoundUpFlag = round.isFinish();
						if (BulletScenario.getInstance().RoundUpFlag)
						{
							GuiMgr.getInstance().guiHuntFish.preparingRoundUp();
							break;
						}
					}
					else
					{
						if (!f.inFired)
						{
							f.effBleed();
						}
						f.inFired = true;
					}
					var str:String = "-" + ConfigJSON.getInstance().getItemInfo("Noel_Bullet")[bulletType][bulletId]["Blood"];
					var dxRand:int = Ultility.RandomNumber( -2, 2);
					var dyRand:int = Ultility.RandomNumber( -2, 0);
					if (f.img != null&&f.FishType == "FishBoss")
					{
						dxRand = Ultility.RandomNumber( -10, 10);
						dyRand = Ultility.RandomNumber( -7, 0);
					}
					EventUtils.effText(LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER) as Sprite, /*f.img */swfBum.img, dxRand, dyRand, dxRand, -30, 0xff0000, str, 1, 0x000000, 8);
					
					if (_team.NumFish <= 0)
					{
						RoundScene.getInstance().forceRemoveTeam(_team.IdTeam);
						break;
					}
					
					if (hasDeath) break;
				}
			}
			/*thực hiện vung ra quà*/
			if (hasDeath)
			{
				fallGiftFromFish(gifts, posBum.x, posBum.y);
			}
			return hasDeath;
		}
		/**
		 * rơi quà ra
		 * @param	gifts tập quà rơi ra
		 * @param	xSrcGift vị trí bắt đầu
		 * @param	ySrcGift
		 */
		private function fallGiftFromFish(gifts:Array, xSrcGift:Number, ySrcGift:Number):void 
		{
			var gift:AbstractGift;
			var flyComp:Function = function fallFlyComp(num:int, index:int):void
			{
				if (RoundScene.getInstance().Round.IdRound == 5)
				{
					gift = gifts[index];
					EventSvc.getInstance().processGetGift(gift, num);
				}
			}
			for (var i:int = 0; i < gifts.length; i++)
			{
				gift = gifts[i];
				var desFly:Point = getDesFly(gift.ItemType);
				
				/*var data:Object;
				if (gift["Rank"] != null)
				{
					data = new Object();
					data["Rank"] = gift["Rank"];
				}*/
				EventUtils.effFallFly(gift.ItemType, Constant.GUI_MIN_LAYER,
										gift.getImageName(), xSrcGift, ySrcGift,
										500, desFly.x, desFly.y,
										flyComp, gift["Num"], i, gift);
			}
		}
		private function getDesFly(itemType:String):Point
		{
			switch(itemType)
			{
				/*case "Exp":
					return new Point(10, 20);
				case "Money":
					return new Point(100, 20);*/
				default:
					return new Point(700, 20);
			}
			return new Point(700, 20);
		}
		public virtual function getPosBum(x:Number, y:Number):Point 
		{
			return new Point(x, y);
		}
		
		/**
		 * tìm điểm đến cho con cá thứ i
		 * @param	index : index của con cá ( = 0 => cá đầu đàn)
		 */
		protected virtual function findDes2(index:int):void 
		{
			var f:FishAbstract = _oFish[index];
			var des:Point;
			if (index == 0)
			{
				des = getKingDes(f.CurPos, f.SpeedVec, f.img.width, f.img.height, f.IsAppear);//lấy vị trí cho con cá đầu đàn
			}
			else
			{
				var preFish:FishAbstract = _oFish[index - 1];
				var preFishDesPos:Point = preFish.DesPos;
				var prePos:Point = preFish.CurPos;
				des = getDes(f.CurPos, prePos, preFishDesPos);
			}
			f.prepareMoving(des);
		}
		
		/**
		 * xem con cá còn nằm trong màn hình chơi ko?
		 * @param	f
		 */
		private function checkOutOfScreen(f:FishAbstract):void 
		{
			var inScreen:Boolean = f.InScreen;
			if (!inScreen)
			{
				removeFish(f.Id);
			}
		}
		
		public function get InScreen():Boolean
		{
			var f:FishAbstract, inScreen:Boolean = false;
			if (_oFish == null) return false;
			for (var i:int = 0; i < _oFish.length; i++)
			{
				f = _oFish[i];
				inScreen ||= f.InScreen;//chỉ cần 1 con cá đang nằm trong màn hình
			}
			return inScreen;
		}
		/**
		 * tìm vị trí đích cho cả đàn
		 */
		protected virtual function findDes():void
		{
			var f:FishAbstract, i:int, des:Point, prePos:Point;
			f = _oFish[0];
			prePos = f.CurPos;
			des = getKingDes(f.CurPos, f.SpeedVec, f.img.width, f.img.height, f.IsAppear);//lấy vị trí cho con cá đầu đàn
			f.prepareMoving(des);
			for (i = 1; i < _oFish.length; i++)
			{
				f = _oFish[i];
				des = getDes(f.CurPos, prePos, des);
				f.prepareMoving(des);
				prePos = f.CurPos;
			}
			_reachDes = false;
		}
		/**
		 * tìm điểm đến tiếp theo của con đầu đàn
		 * @param	curPos 	vị trí hiện tại
		 * @param	dir 	hướng di chuyển của con cá (dấu của dir.x cho biết đang di chuyển sang trái, phải; dấu của dir.y cho biết di chuyển lên ,xuống)
		 * @param	minX 	giá trị nhỏ nhất cần để cộng thêm vào CurPos.x
		 * @param	minY 	giá trị nhỏ nhất cần để cộng thêm vào CurPos.y
		 * @return 			tọa độ điểm đến
		 */
		protected virtual function getKingDes(curPos:Point, dir:Point, minX:Number, minY:Number, isAppear:Boolean):Point 
		{ 
			var des:Point = new Point();
			var dirx:int = dir.x > 0 ? 1 : -1;
			var diry:int = Ultility.RandomNumber( -1, 1);
			des.x = curPos.x + dirx * (minX + Ultility.RandomNumber(100, 200));
			if (isAppear)
			{
				des.y = curPos.y + diry * (minY + Ultility.RandomNumber(0, 50));//cho dao động theo phương thẳng đứng ít thoai
			}
			else//nếu chưa xuất hiện thì cứ cho bơi thẳng
			{
				des.y = curPos.y;
			}
			return des;
		}
		/**
		 * tìm điểm đến cho các con kế tiếp (DEFAULT là kiểu tịnh tiến)
		 * @param	curFishStartPos		vị trí hiện tại của con cá cần tính điểm đến
		 * @param	preFishStartPos		vị trí hiện tại của con đi trước
		 * @param	preFishDesPos		vị trí đến của con cá đi trước
		 * @return 						tọa độ điểm đến của con cá nè
		 */
		protected virtual function getDes(curFishStartPos:Point, preFishStartPos:Point, preFishDesPos:Point):Point 
		{ 
			var temp:Point = preFishDesPos.subtract(preFishStartPos);	//vector tịnh tiến
			var des:Point = curFishStartPos.add(temp);					//tịnh tiến đến điểm đó
			return des;
			//return preFishStartPos;
		}
		/**
		 * vẽ các con trong _team ra rồi push vào _oFish
		 * @param	Parent
		 */
		public virtual function draw(Parent:Sprite):void 
		{ 
			var x:int = int(_startPoint.x);
			var y:int = int(_startPoint.y);
			drawDefault(Parent, x, y);
		}
		/**
		 * hủy team
		 */
		public virtual function destructor():void //hủy team
		{
			_startPoint = null;
			_isAppearAll = false;
			removeAllFish();
			_team.IsActive = false;
			_team = null;
		};
		
		/**
		 * xóa 1 con cá bất kỳ khỏi mảng cá hiển thị
		 * @param	id id của con cá được remove
		 */
		public virtual function removeFish(id:int):void
		{
			if (_oFish == null || _oFish.length == 0) return;
			var f:FishAbstract, i:int, isRemove:Boolean = false;
			for (i = 0; i < _oFish.length; i++)
			{
				f = _oFish[i];
				if (f.Id == id)
				{
					isRemove = true;
					f.Destructor();//xóa con cá content
					break;
				}
			}
			if (isRemove)
			{
				_oFish.splice(i, 1);
				RoundScene.getInstance().Round.NumFishActive--;
			}
		}
		public function forceRemoveFish(id:int):void
		{
			removeFish(id);
			_team.removeFish(id);
		}
		public function forceRemoveAllFish():void
		{
			removeAllFish();
			_team.removeAllFish();
		}
		public function forceDestructor():void
		{
			_startPoint = null;
			_isAppearAll = false;
			forceRemoveAllFish();
		}
		/**
		 * xóa tất cả mảng cá hiển thị
		 */
		public virtual function removeAllFish():void
		{
			if (_oFish == null || _oFish.length == 0) return;
			var f:FishAbstract, i:int;
			for (i = 0; i < _oFish.length; i++)
			{
				f = _oFish[i];
				f.Destructor();
				RoundScene.getInstance().Round.NumFishActive--;
			}
			_oFish.splice(0, _oFish.length);
		}
		
		/**
		 * hàm xử lý con cá bị dính 1 viên đạn
		 * @param	bulletType : loại đạn
		 * @param	bulletId : id của đạn
		 * @param	idFsh : id của con cá bị dính đạn
		 * @param	gift [out] : tập quà nhận về
		 * @return con cá có id trên còn sống không
		 */
		private function fired(bulletType:String, bulletId:int, idFish:int, gifts:Array):Boolean 
		{
			var dBlood:int = ConfigJSON.getInstance().getItemInfo("Noel_Bullet")[bulletType][bulletId]["Blood"];
			var f:FishAbstract, i:int, gift:Array;
			for (i = 0; i < _oFish.length; i++)
			{
				f = _oFish[i];
				if (f.Id == idFish)//tìm thấy con cá bị dính chưởng
				{
					var isDie:Boolean = !f.updateBlood( -dBlood);//cập nhật máu cho con cá và xem nó có chết ko?
					if (isDie)//nếu chết
					{
						gift = f.getListGiftInfo();
						var info:AbstractGift;
						for (var j:int = 0; j < gift.length; j++)
						{
							info = gift[j];
							if (Ultility.categoriesGift(info.ItemType) == 1)//nếu mà rơi ra đồ=> genId luon
							{
								for (var k:int = 0; k < info["Num"]; k++)
								{
									GameLogic.getInstance().user.GenerateNextID();
								}
							}
							gifts.push(gift[j]);
						}
						f.Destructor();
						_oFish.splice(i, 1);
						RoundScene.getInstance().Round.NumFishActive--;
						_team.removeFish(idFish);
						return false;
					}
					break;
				}
			}
			return true;
		}
		
		public function set StartPoint(val:Point):void {_startPoint = val; };
		public function get IsAppearAll():Boolean { return _isAppearAll; };
		public function get IdTeam():int { return _team.IdTeam; }
		public function get ActiveFish():Array { return _oFish; }
		public function get NumFish():int { return _team.NumFish; }//số lượng cá trong team
	}

}





















