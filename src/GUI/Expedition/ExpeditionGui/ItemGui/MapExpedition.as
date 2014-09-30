package GUI.Expedition.ExpeditionGui.ItemGui 
{
	import com.greensock.easing.Expo;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import GUI.component.ButtonEx;
	import GUI.component.Container;
	import GUI.Expedition.ExpeditionLogic.ExpeditionMgr;
	import GUI.Expedition.ExpeditionLogic.ExpeditionXML;
	import GUI.GuiMgr;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class MapExpedition extends Container 
	{
		//const
		private const ID_NODE:String = "idNode";
		public static const LENGTH_MAP:int = 3381;
		public static const LENGTH_SCREEN:int = 676;
		private const DELTA_X:int = 20;
		private const friction:Number = 1.35;
		private const POSNODE:Array = 
			[ 
				{"x": 35, "y": 130 }, 
				{"x": 44, "y": 56}, {"x": 111, "y": 84}, {"x": 159, "y": 96}, {"x": 229, "y": 78}, {"x": 269, "y": 139}, 
				{"x": 335, "y": 88}, {"x": 426, "y": 67}, {"x": 495, "y": 69}, {"x": 529, "y": 98}, {"x": 585, "y": 70}, 
				{"x": 629, "y": 22}, {"x": 695, "y": 12}, {"x": 740, "y": 58}, {"x": 750, "y": 105}, {"x": 797, "y": 162}, 
				{"x": 861, "y": 129}, {"x": 928, "y": 112}, {"x": 995, "y": 56}, {"x": 1102, "y": 43}, {"x": 1190, "y": 94}, 
				{"x": 1217, "y": 153}, {"x": 1289, "y": 112}, {"x": 1317, "y": 43}, {"x": 1369, "y": 43}, {"x": 1410, "y": 75}, 
				{"x": 1438, "y": 100}, {"x": 1505, "y": 151}, {"x": 1554, "y": 82}, {"x": 1578, "y": 51}, {"x": 1667, "y": 32}, 
				{"x": 1736, "y": 18}, {"x": 1850, "y": 22}, {"x": 1885, "y": 42}, {"x": 1934, "y": 84}, {"x": 1990, "y": 155}, 
				{"x": 2047, "y": 129}, {"x": 2103, "y": 103}, {"x": 2153, "y": 118}, {"x": 2202, "y": 98}, {"x": 2254, "y": 58}, 
				{"x": 2310, "y": 48}, {"x": 2362, "y": 48}, {"x": 2422, "y": 96}, {"x": 2474, "y": 115}, {"x": 2540, "y": 43}, 
				{"x": 2586, "y": 33}, {"x": 2662, "y": 54}, {"x": 2722, "y": 94}, {"x": 2758, "y": 137}, {"x": 2807, "y": 134}, 
				{"x": 2857, "y": 96}, {"x": 2930, "y": 127}, {"x": 2971, "y": 134}, {"x": 3033, "y": 80}, {"x": 3098, "y": 49}, 
				{"x": 3139, "y": 72}, {"x": 3228, "y": 145}, {"x": 3297, "y": 110}, {"x": 3340, "y": 48}, {"x": 0, "y": 0}, 
			];
		private const POSITEMMAP:Array = 
			[
				{"x": 39, "y": 152 }, { "x": 140, "y": 10 }, { "x": 332, "y": 18 }, { "x": 366, "y": 118 },
				{"x": 613, "y": 56 }, { "x": 683, "y": 127 }, { "x": 889, "y": 18 }, { "x": 950, "y": 143 },
				{"x": 1253, "y": 10 }, { "x": 1426, "y": 22 }, { "x": 1556, "y": 142 }, { "x": 1684, "y": 79 },
				{"x": 1836, "y": 48 }, { "x": 1898, "y": 111 }, { "x": 2015, "y": 48 }, { "x": 2174, "y": 18 },
				{"x": 2226, "y": 76 }, { "x": 2455, "y": 22 }, { "x": 2630, "y": 129 }, { "x": 2726, "y": 20 },
				{"x": 2830, "y": 134 }, { "x": 2949, "y": 44 }, { "x": 3125, "y": 107 }, { "x": 3222, "y": 3 },
			];
		private const NAMEITEMMAP:Array = 
			[
				"Home", "LightHouse", "CoconutLand", "Vocalnic",
				"OceanTrunk", "DeamonLand", "BuildingLand", "Dragon",
				"HeadLand", "CoconutTree", "IceLand", "Whale",
				"FishEnd", "TrunkLand", "Octopus", "Shark",
				"WarShip", "WaterFall", "Genie", "BornLand2",
				"BornLand","SkullLand","TreasureLand","SeaGenie"
			];
		//var - gui
		private var _map:Container;
		private var _actor:ActorFish;
		//var - logic
		private var _listPos:Array = [];//tập vị trí của từng node
		private var xOffset:Number;
		private var xPrev:Number = 0;
		private var xCur:Number = 0;
		private var xTraj:Number = 0;
		private var inDrag:Boolean = false;
		private var _timer:Timer;
		public function MapExpedition(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP, toBitmap:Boolean=false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "MapExpedition";
		}
		
		public function create():void
		{
			//b1: add vào cái background
			_map = AddContainer("", "GuiExpedition_ImgMap", 0, 0);
			for (var i:int = 0; i < 24; i++)
			{
				_map.AddImage("", "GuiExpedition_Img" + NAMEITEMMAP[i], POSITEMMAP[i]["x"], POSITEMMAP[i]["y"], true, ALIGN_LEFT_TOP, true);
			}
			//b2: tạo mặt nạ
			var mask:Sprite = new Sprite();
			mask.graphics.beginFill(0xff0000);
			mask.graphics.drawRect(0, 0, 677, 403);
			mask.graphics.endFill();
			img.addChild(mask);
			img.mask = mask;
			
			//b3: gen Map dựa vào SilkRoad => tạo ra tập nút trên map
			generateMap();
			initActor();
			_map.img.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownMap);
		}
		
		private function generateMap():void
		{
			var x:int, y:int, i:int, type:int;
			var silkRoad:Array = ExpeditionMgr.getInstance().getSilkRoad();
			_listPos.splice(0, _listPos.length);
			var node:Container;
			for (i = 0; i < silkRoad.length; i++)
			{
				x = POSNODE[i]["x"];
				y = POSNODE[i]["y"];
				type = silkRoad[i];
				type = ((type % 100 != 0) && (type % 10 == 0))? 10 : type;
				node = _map.AddContainer(ID_NODE + "_" + type, "GuiExpedition_Node" + type, x, y);
				node.setTooltipText(ExpeditionXML.getInstance().getString("TipExpedition" + type));
				_listPos.push(new Point(x, y));
			}
		}
		
		private function initActor():void 
		{
			_actor = new ActorFish(_map.img, "GuiExpedition_ActorFish1", 0, 0);
			_actor.img.rotationY = 180;
			var index:int = ExpeditionMgr.getInstance().Index;
			var pos:Point = _listPos[index];
			_actor.SetPos(pos.x, pos.y);
			/*chỉnh lại vị trí cho map*/
			var firstNode:int = index - 2 < 0 ? 0 : index - 2;
			var xPosFirstNode:int = (_listPos[firstNode] as Point).x;
			_map.img.x = 20 - xPosFirstNode;
			if (_map.img.x <= LENGTH_SCREEN - LENGTH_MAP)
			{
				_map.img.x = LENGTH_SCREEN - LENGTH_MAP;
			}
		}
		private function onMouseDownMap(e:MouseEvent):void 
		{
			if (!GuiMgr.getInstance().guiExpedition.IsVisible)
			{
				return;
			}
			_map.img.startDrag();
			inDrag = true;
			_map.img.addEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
			_map.img.addEventListener(MouseEvent.MOUSE_OUT, onMouseOutStage);
		}
		
		private function onMouseOutStage(e:MouseEvent):void 
		{
			_map.img.stopDrag();
			inDrag = false;
			_map.img.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
			_map.img.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutStage);
		}
		
		private function onMouseUpStage(e:MouseEvent):void 
		{
			_map.img.stopDrag();
			inDrag = false;
			_map.img.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpStage);
			_map.img.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOutStage);
		}
		
		public function hopFish(numDice:int, fComplete:Function):void
		{
			var index:int = ExpeditionMgr.getInstance().Index;
			var subList:Array;
			if (numDice < 0)
			{
				subList = _listPos.slice(index + numDice, index);
				subList.reverse();
			}
			else
			{
				subList = _listPos.slice(index + 1, index + numDice + 1);
			}
			_actor.hop(subList, fComplete);
		}
		public function shiftLeft():Boolean
		{
			_map.img.x -= DELTA_X;
			if (_map.img.x <= LENGTH_SCREEN - LENGTH_MAP)
			{
				_map.img.x = LENGTH_SCREEN - LENGTH_MAP;
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public function shiftRight():Boolean
		{
			_map.img.x += DELTA_X;
			if (_map.img.x >= 0)
			{
				_map.img.x = 0;
				return false;
			}
			else
			{
				return true;
			}
		}
		
		override public function Destructor():void 
		{
			_actor.Destructor();
			super.Destructor();
		}
		
		public function AutoShiftMap(distance:int, fCompleteAutoShift:Function):void 
		{
			if (distance == 0)
			{
				onCompTweenShift();
				return;
			}
			var xMap:int = _map.img.x + distance;
			if (xMap < LENGTH_SCREEN - LENGTH_MAP)
			{
				xMap = LENGTH_SCREEN - LENGTH_MAP;
			}
			var yMap:int = _map.img.y;
			TweenMax.to(_map.img, 2, { 
										bezierThrough:[ { x:xMap, y:yMap } ], 
										ease:Expo.easeInOut,
										onComplete:onCompTweenShift
									}
						);
			function onCompTweenShift():void
			{
				if (fCompleteAutoShift != null)
				{
					fCompleteAutoShift();
				}
			}
		}
		
		public function onUpdateMap():void
		{
			if (inDrag)
			{
				xPrev = xCur;
				xCur = GameInput.getInstance().MousePos.x;
				xTraj = xPrev - xCur;
			}
			else
			{
				xTraj /= friction;
				_map.img.x -= xTraj;
			}
			if (_map.img.x < LENGTH_SCREEN - LENGTH_MAP)
			{
				_map.img.x = LENGTH_SCREEN - LENGTH_MAP;
			}
			if (_map.img.x > 0)
			{
				_map.img.x = 0;
			}
			if (_map.img.y != 0)
			{
				_map.img.y = 0;
			}
		}
		
		public function getXactor():int//trả về tọa độ của con cá so với chỗ add Map vào ở GUIExpedition
		{
			var xMap:int = int(Math.abs(_map.img.x));
			return int(_actor.img.x) - xMap;
		}
		
		public function getXIndex(index:int):int//tọa độ của cái node so với cái chỗ add map vào guiExpedition
		{
			var xMap:int = int(Math.abs(_map.img.x));
			return int((_listPos[index] as Point).x) - xMap;
		}
		
	}
}



















