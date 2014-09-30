package GUI 
{
	import Logic.Ultility;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import NetworkPacket.PacketSend.SendSellStockThing;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.stats.StatsView;
	//import PaperBase;
	import org.papervision3d.objects.parsers.MD2;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.materials.MovieMaterial;
	
	/**
	 * ...
	 * @author Le Ba Dung
	 */
	public class Model3D extends PaperBase
	{
		private var MeshFile:String;
		private var TextureFile:String;
		public var md2:MD2 = new MD2(true);
		public var model:DisplayObject3D = null;
		//public var mat:MaterialObject3D = new MaterialObject3D();
		public var material:BitmapFileMaterial;
		
		public const STATE_STAND:int = 0;
		public const STATE_RUN:int = 1;
		private var Pos:Point = new Point(0, 0);
		private var DesPos:Point = new Point(0, 0);
		private var SrcPos:Point = new Point(0, 0);
		private var Dir:Point = new Point(1, 0);
		private var State:int = STATE_STAND;
		private var Scale:Number = 1;
		private var OffsetPos:Point = new Point( -160, -100);
		private var OffsetRot:Number = 0;
		private var SpeedMove:Number = 10;
		private var Rotate:Number = 0;
		private var MatList:Array = new Array();
		
		public function Model3D(meshFile:String, textureFile:String = "") 
		{
			MeshFile = meshFile;
			TextureFile = textureFile;
			init();
		}
		
		override protected function onComplete(e:Event):void
		{
		}
		
		public function SetScale(scale:Number = 1):void
		{
			Scale = scale;
			scaleX = scaleY = scaleZ = scale;
		}
		
		public function SetPos(pos:Point):void
		{
			Pos = pos;
			SrcPos = pos;
			DesPos = pos;
			
			var realPos:Point = Ultility.PosLakeToScreen(pos.x, pos.y);
			x = realPos.x + OffsetPos.x;
			y = realPos.y + OffsetPos.y;
		}
		
		public function SetState(state:int):void
		{
			State = state;
			if (!md2.animation)
				return;
			
			var NumState:int = md2.animation.clipNames.length;
			if (state < 0 || state >= NumState)
			{
				return;
			}
			
			md2.play(md2.animation.clipNames[state]);
		}
		
		public function MoveTo(p:Point, speed:Number = 10):void
		{
			SpeedMove = speed;
			SrcPos = Pos;
			DesPos = p;
			SetState(STATE_RUN);

			var v1:Point = DesPos.subtract(SrcPos);
			if (!v1.equals(new Point(0, 0)))
			{
				var at:Number = Math.abs((Math.atan(Math.abs(v1.x) / Math.abs(v1.y)) / Math.PI) * 180);
				if (v1.x > 0)
				{
					if (v1.y > 0)
					{
						Rotate = at;
					}
					else
					{
						Rotate = -180 - at;
					}
				}
				else
				if (v1.x < 0)
				{
					if (v1.y > 0)
					{
						Rotate = - at;
					}
					else
					{
						Rotate = -90 - at;
					}
				}
				else
				{
					if (v1.y > 0)
					{
						Rotate = -90;
					}
					else
					{
						Rotate = 90;
					}
				}
				model.localRotationZ = Rotate + OffsetRot;			
			}			
		}
		
		override protected function init3d():void
		{			
			if (TextureFile != "")
			{
				material = new BitmapFileMaterial(TextureFile);
			}
			model = md2;
			md2.load(MeshFile, material, 25);
			default_scene.addChild(model);
			default_camera.position = new Number3D(0, 50, 180);//new Number3D( -150, 70, 50);
			default_camera.lookAt(md2, new Number3D(0, 1, 0));
			model.pitch( -90);
			model.localRotationZ = 90;
		}
		
		public function AddMaterial(fileName:String):void
		{
			var mat:BitmapFileMaterial = new BitmapFileMaterial(fileName);
			md2.material = mat;
			MatList.push(mat);
		}
		
		public function SetMaterial(index:int):void
		{
			if (index >= 0 && index < MatList.length)
			md2.material = MatList[index];
		}
		
		private function AtTarget():Boolean
		{
			return false;
		}
		
		override protected function processFrame():void 
		{
			if (State == STATE_STAND)
			{
				return;
			}
			
			// Di chuyen den dich
			if (State == STATE_RUN && Pos.equals(DesPos))
			{
				SetPos(DesPos);
				SetState(STATE_STAND);
				return;
			}
			
			var v1:Point = DesPos.subtract(SrcPos);
			if (v1.equals(new Point(0, 0)))
			{
				return;
			}
			
			//Rotate = (Math.atan(v1.y / v1.x) / Math.PI) * 180;
			//model.localRotationZ = Rotate + OffsetRot;

			v1.normalize(SpeedMove);
			Pos = Pos.add(v1);
			x = Pos.x + OffsetPos.x;
			y = Pos.y + OffsetPos.y;
			
			if ((DesPos.x > SrcPos.x && Pos.x > DesPos.x) || (DesPos.x < SrcPos.x && Pos.x < DesPos.x) ||
			(DesPos.y > SrcPos.y && Pos.y > DesPos.y) || (DesPos.y < SrcPos.y && Pos.y < DesPos.y))
			{
				Pos = DesPos;
			}
		}
	}

}