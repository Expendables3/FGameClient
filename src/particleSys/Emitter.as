package particleSys
{
	import flash.filters.BlurFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author tuannm3
	 */
	public class Emitter
	{
		public var spawnCount:Number = 0;						//Số lượng hạt sẽ sinh ra trong 1s
		private var spawnedCount:Number = 0;					//Số lượng hạt đã sinh ra kể từ mốc thời gian bắt đầu đếm 1s
		
		private var elapseEachTime:Number = 0;					//Thời gian đã trôi qua kể từ điểm bắt đầu của 1s
		private var beginTime:Number = 0;						//Mốc thời gian bắt đầu sinh hạt
		private var curTime:Number = 0;							//Thời gian hiện tại
		public var spawnTime:Number = -1;						//Thời gian sinh ra hạt
		
		//Thời gian chờ để sinh ra hạt trong lần tiếp theo
		//nếu thời gian này lớn hơn thời gian sinh hạt spawnTime
		//thì emit sẽ sinh ra các hạt theo chu kỳ: cứ sinh hạt 
		//trong khoảng thời gian spawnTime rồi ngừng lại 
		//1 khoảng nextTime - spawnTime sau đó sinh hạt tiếp
		public var nextTime:Number = 0;						
		private var beginNextTime:Number = 0;					//Mốc thời gian bắt đầu đếm thời gian cho lần sinh hạt tiếp		
		
		public var timeBaseNum:Number = 1000;					//mỗi 1 khoảng thời gian timeBaseNum sẽ sinh ra spawnCount hạt, = 0 thì sinh hạt theo framebase
		
		public var lifeTime:Number = - 1;						//Thời gian tồn tại của hạt
		public var lifeTimeTolerance:Number = 0;				//Dung sai thời gian tồn tại
		
		public var pos:Point = new Point();						//Vị trí của cực phát
		public var posTolerance:Point = new Point();			//Dung sai vị trí
		
		public var existArea:Rectangle = null;					//Vùng tồn tại của các hạt
		
		public var vel:Point = new Point();						//Vận tốc của hạt(theo mỗi frame)
		public var velTolerance:Point = new Point()				//Dung sai vận tốc
			
		public var scaleOrg:Point = new Point(1, 1);			//Tỷ lệ gốc: = 1 là bình thường
		public var scaleOrgTolerance:Point = new Point(0, 0);	//Dung sai tỷ lệ gốc
		public var scale:Point = new Point();					//Tốc độ phóng to thu nhỏ: <0 là thu nhỏ, >0 là phóng to
		public var scaleTolerance:Point = new Point();			//Dung sai tỷ lệ phóng to thu nhỏ
		
		public var rotationOrg:Number = 0;						//Góc xoay gốc, mặc định là 0
		public var rotationOrgTolerance:Number = 0;				//Dung sai góc xoay gốc
		public var rotation:Number = 0;							//Tốc độ xoay, >0 là theo chiều kim đồng hồ, <0 là ngược lại
		public var rotationTolerance:Number = 0;				//Dung sai tốc độ xoay		
		
		public var alpha:Number = 1;							//Alpha gốc, mặc định là 1
		public var alphaTolerance:Number = 0;					//Dung sai alpha gốc
		public var fade:Number = 0;								//Tốc độ mờ dần của hạt, -1< fade <0
		public var fadeTolerance:Number = 0;					//Dung sai tốc độ mờ của hạt
		
		public var friction:Number = 0;							//Ma sát của hạt, 0<= friction <=1		
		public var frictionTolerance:Number = 0;					//Dung sai ma sát
		
		public var blur:Point = new Point();					//Độ nhòe của hạt theo hai chiều x và y
		public var blurTolerance:Point = new Point();			//Dung sai độ nhòe của hạt
		
		public var forceTotal:Point = new Point();				//Tổng lực tác động lên hạt			
		
		public var particleList:Array = new Array;				//Mảng các hạt particle được sinh ra
		public var imgList:Array = new Array;					//Mảng các content particle
		private var parent:Object;								//Content các hạt paritlce sẽ add trên đây
		public var emit:Emitter = null;							//Emitter đi theo các hạt particle		
		
		public var minChildIndex:int = 0;
		public var allowSpawn:Boolean = true;
		
		public function Emitter(Parent:Object) 
		{
			parent = Parent;			
			beginTime = curTime = getTimer();	
		}
		
		
		public function spawnParticle(number:int):void
		{
			for (var i:int = 0; i < number && imgList.length > 0; i++) 
			{
				var particle:Particle;
				var index:int = Math.round(Math.random() * (imgList.length - 1));
				particle = new Particle(imgList[index], parent, this);
				
				particle.pos.x = pos.x + (Math.random() * 2 - 1) * posTolerance.x;
				particle.pos.y = pos.y + (Math.random() * 2 - 1) * posTolerance.y;
				
				particle.vel.x = vel.x + (Math.random() * 2 - 1) * velTolerance.x;
				particle.vel.y = vel.y + (Math.random() * 2 - 1) * velTolerance.y;
				
				particle.acc.x = forceTotal.x;
				particle.acc.y = forceTotal.y;
				
				particle.image.scaleX = scaleOrg.x + (Math.random() * 2 - 1) * scaleOrgTolerance.x;
				particle.image.scaleY = scaleOrg.y + (Math.random() * 2 - 1) * scaleOrgTolerance.y;
				particle.scale.x = scale.x + (Math.random() * 2 - 1) * scaleTolerance.x;
				particle.scale.y = scale.y + (Math.random() * 2 - 1) * scaleTolerance.y;
				
				particle.image.alpha = alpha + (Math.random() * 2 - 1) * alphaTolerance;
				particle.fade = fade + Math.random() * fadeTolerance;
				particle.friction = friction + (Math.random() * 2 - 1) * frictionTolerance;
				
				particle.image.rotation = rotationOrg + (Math.random() * 2 - 1) * rotationOrgTolerance;
				particle.rotattion = rotation + (Math.random() * 2 - 1) * rotationTolerance;				
				
				particle.lifeTime = lifeTime + (Math.random() * 2 - 1) * lifeTimeTolerance;
				if (blur.x != 0 || blur.y != 0)
				{
					var blurfilter:BlurFilter = new BlurFilter(blur.x, blur.y, 1);
					var filterArray:Array = new Array(blurfilter);
					particle.image.filters = filterArray;
				}
				
				particle.existArea = existArea;
				
				if (emit != null)
				{
					var targetClass:Class = Object(emit).constructor;
					particle.emit = new targetClass(parent) as Emitter;					
				}
	
				particleList.push(particle);				
			}
		}
		
		
		public function spawnTimeBase():void
		{
			//Tính toán để sinh ra các hạt
			var newCurTime:Number = getTimer();
			if (newCurTime - beginTime < spawnTime || spawnTime == -1)
			{
				var interval:Number = newCurTime - curTime;
				elapseEachTime += interval;
				var n:Number = spawnCount * interval / timeBaseNum;
				//Nếu số hạt sinh ra trong khoảng time giữa 2 frame < 1 thì không làm gì,
				//để cộng dồn sang frame sau bằng cách không gán lại curTime
				if (n >= 1)
				{
					curTime = newCurTime;
					var n1:int = Math.round(n);			//Làm tròn					
					if (elapseEachTime >= timeBaseNum)			//Đã hết 1s
					{
						n1 = spawnCount - spawnedCount; //Hết 1s, số hạt sinh ra = số hạt phải sinh ra - số hạt đã sinh ra
						spawnedCount = 0;
						elapseEachTime = elapseEachTime % timeBaseNum;
					}
					spawnParticle(n1);
					spawnedCount += n1;					//Số hạt đã sinh ra thực tế
				}			
			}
			
			if (nextTime > 0 && newCurTime - beginNextTime > nextTime)
			{
				beginNextTime = beginTime = newCurTime;			
				onBeginNextSpawn();
			}			
		}
		
			
		public function spawnFrameBase():void
		{
			curTime = getTimer();
			if (curTime - beginTime < spawnTime || spawnTime == -1)
			{
				if (spawnCount >= 1)
				{
					spawnParticle(spawnCount);
				}
				else
				{				
					if (spawnedCount < 1)
					{
						spawnedCount += spawnCount;					
					}
					else
					{
						spawnParticle(spawnedCount);
						spawnedCount = 0;
					}
				}
			}
			if (nextTime > 0 && curTime - beginNextTime > nextTime)
			{	
				beginNextTime = beginTime = curTime;
				onBeginNextSpawn();
			}
		}
		
		/**
		 * Được gọi khi bắt đầu mỗi lần sinh hạt tiếp theo
		 */
		public virtual function onBeginNextSpawn():void
		{
			
		}
		
		
		public function modifyForce(force:Point):void
		{
			
		}
		
		public function setPos(x:int, y:int):void
		{
			if (allowSpawn)
			{
				pos.x = x;
				pos.y = y;
			}
		}
		
		public virtual function updateEmitter():void
		{	
			if (allowSpawn)
			{
				if (timeBaseNum > 0)
				{
					spawnTimeBase();
				}
				else
				{
					spawnFrameBase();
				}
			}
			
			//Update các hạt
			//var particle:Particle;						
			for (var i:int = 0; i < particleList.length; i++) 
			{
				particleList[i].updateParticle();				
			}			
		}		
				
		public function stopSpawn():void
		{
			allowSpawn = false;
		}
		
		public function startSpawn():void
		{
			allowSpawn = true;
		}
		
		public function removeParticle(index:int):void
		{
			particleList.splice(index, 1);
		}
		
		public virtual function destroy():void
		{			
			var particle:Particle;		
			while(particleList.length > 0)
			{
				particle = particleList[0];
				particle.destroy();				
			}
			
			if (emit != null)
			{
				emit.destroy();
				emit = null;
			}
		}
		
		
		public function clone(value:Object):Object
		{
			var buffer:ByteArray = new ByteArray();
			buffer.writeObject(value);
			buffer.position = 0;
			var result:Object = buffer.readObject();
			return result;
		}
	
	}

}