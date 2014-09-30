package Logic 
{
	import adobe.utils.CustomActions;
	import com.bit101.charts.PieChart;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import Effect.EffectMgr;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import GameControl.GameController;
	import GUI.component.ActiveTooltip;
	import GUI.component.Tooltip;
	import GUI.component.TooltipFormat;
	import GUI.GuiMgr;
	import GUI.GUIStore;
	/**
	 * ...
	 * @author tuannm
	 * Những object roi và bay vào kho
	 */
	public class FallingObject extends BaseObject 
	{
		public static const FALL:int = 1;
		public static const FLY:int = 2;
		public static const DISAPPEAR:int = 3;
		public var ItemType:String;
		public var ItemId:int;
		
		private const dx:Number = 0.1;
		private var DisappearTime:int;
		public var getDesToFly:Function = null;
		
		private var SignScaleY:int;
		private var OrgHeight:int;
		private var OrgWidth:int;
		private var Ywater:int
		public var isFinishDeform:Boolean = false;
		public var movingState:int = FALL;
		public var waitingTime:Number = 5;
		private var isRandomDirToFly:Boolean = false;
		
		//Biến cho biết đồ vật rơi nằm lại trong hồ
		public var stayInLake:Boolean = false;
		
		public var completeFly:Function;
		
		public function FallingObject(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "FallingObject";
			getDesToFly = null;
			isRandomDirToFly = false;
			var t:int = GameController.getInstance().GetLakeBottom() - 75;
			var AreaHeight:int = 40;
			DesPos.y = Ultility.RandomNumber(t - AreaHeight, t);
			SpeedVec.x = Ultility.RandomNumber(-7, 7);
			SpeedVec.y = - Ultility.RandomNumber(25, 35);
			SignScaleY = -1;
			img.scaleX = img.scaleY = 0.2;
			Ywater = y + 10;
			if (y > t - AreaHeight)
			{
				SetPosY(y - 30);
				img.scaleX = img.scaleY = 1;
				if(DesPos.y <= CurPos.y) DesPos.y = CurPos.y + 1;
			}
			EffectMgr.getInstance().AddSwfEffect(Constant.OBJECT_LAYER, "EffNhapNhay", null, x - 25, y + 25);		
			// Xử lý 1 số case đặc biệt
			if (imgName.search("EventIceCream_Item") >= 0)
			{
				(img as MovieClip).gotoAndStop(0);
			}
		}
		
		public function setWaitingTime(waitTime:Number):void
		{
			waitingTime = waitTime;
		}
		
		/**
		 * Cho phép hướng bay tới đích ngẫu nhiên
		 * @param	isRandom
		 */
		public function setRandomDir(isRandom:Boolean):void
		{
			isRandomDirToFly = isRandom;
		}
		
		
		public function UpdateMixMaterial():void
		{
			switch(movingState)
			{
				case FALL:
					Fall();
					break;
				case FLY:
					break;
				case DISAPPEAR:
					fadeOut();
					break;
			}			
		}
		
		public function Fall():void
		{
			if (ReachDes)
			{
				if (!isFinishDeform)
				{
					if (img.scaleY < 1)
					{
						img.scaleY += SignScaleY * dx;
						img.scaleX -= SignScaleY * dx;
						img.y = CurPos.y + (OrgHeight - img.height);
						img.x = CurPos.x + (OrgWidth - img.width)/2;
						if (img.scaleY <= 0.7)
						{
							SignScaleY *= -1;							
						}
					}
					else
					{
						img.scaleY = 1;
						isFinishDeform = true;
					}			
					
							
				}	
				if (GameLogic.getInstance().CurServerTime > DisappearTime)
				{
					startFly();							
				}		
				return;
			}
			
			if ( CurPos.y >=DesPos.y)
			{
				ReachDes = true;				
				DisappearTime = GameLogic.getInstance().CurServerTime + waitingTime;
				OrgHeight = img.height;
				OrgWidth = img.width;
				img.scaleY = 1 - dx;
				img.scaleX = 1 + dx;									
				return;
			}
			SpeedVec.y += 4;
			if (CurPos.y > Ywater)
			{
				SpeedVec.y -= 0.2* SpeedVec.y;
			}
			
			CurPos = CurPos.add(SpeedVec);
			this.img.x = CurPos.x;
			this.img.y = CurPos.y;
			if (CurPos.x < 0)
			{
				this.img.x = CurPos.x = 0;
			}
			if (CurPos.x > Constant.MAX_WIDTH - img.width)
			{
				this.img.x = CurPos.x = Constant.MAX_WIDTH - img.width;
			}
			
			img.scaleX = img.scaleY += 0.07;
			if(img.scaleY >=1) img.scaleX = img.scaleY = 1;
		}
		
		public function onFinishTween():void
		{			
			movingState = DISAPPEAR;
			if (ItemType != "ItemCollection")
			{
				if (GameLogic.getInstance().user.IsViewer())
				{
					GuiMgr.getInstance().GuiMain.btnHome.setStateMouseOver();
				}
				else
				{
					if (GuiMgr.getInstance().GuiMain)
					{
						GuiMgr.getInstance().GuiMain.btnInventory.setStateMouseOver();
					}
				}
			}
			else
			{
				//GameLogic.getInstance().dropItemCollection = false;
				if(GuiMgr.getInstance().guiAnoucementCollection.IsVisible)
				{
					GuiMgr.getInstance().guiAnoucementCollection.addNum(ItemId, 1);
				}
			}
			
			if (completeFly != null)
			{
				completeFly();
			}
		}
		
		public function fadeOut():void
		{
			if (img != null)
			{
				img.alpha -= 0.08;
				if (img.alpha <= 0)
				{			
					var i:int = GameLogic.getInstance().user.fallingObjArr.indexOf(this);
					GameLogic.getInstance().user.fallingObjArr.splice(i, 1);
					if (GameLogic.getInstance().user.IsViewer())
					{
						GuiMgr.getInstance().GuiMain.btnHome.setStateMouseOut();
					}
					else
					{
						if (GuiMgr.getInstance().GuiMain)
						{
							GuiMgr.getInstance().GuiMain.btnInventory.setStateMouseOut();
						}
						
					}					
					Destructor();
				}		
			}
		}
		
		public function getThroughPoint(psrc:Point, pdes:Point):Point
		{
			var p:Point = pdes.subtract(psrc);//Vector từ nguồn đến đích
			if (p.y == 0)
				return new Point(p.x/2, 0);
			var med:Point = new Point((psrc.x + pdes.x) / 2, (psrc.y + pdes.y) / 2);//Trung điểm của nguồn và đích
			var v:Point = new Point( -p.y, p.x);//Vector vuông góc với vector(nguồn, đích)
			if (isRandomDirToFly)
			{
				var n:int = Math.round(Math.random()) * 2 - 1;
				v.x = n*v.x;
				v.y = n*v.y;
			}
			else
			{
				if (v.y > 0) //chỉ lấy vector vuông góc có y hướng lên trên, tức là y <0
				{
					v.x = -v.x;
					v.y = -v.y;
				}
			}
			
			var l:Number = Math.min(150, v.length / 2);
			v.normalize(l);//Tính vector có độ dài bằng 1/2 độ dài vector vuông góc			
			var result:Point = med.add(v);//Tính ra điểm cần đi xuyên qua
			return result;
			
		}
		
		private function getDesPosToStore():Point
		{
			var des:Point = new Point;
			var dx:int = 0;
			var dy:int = 0;
			
			switch(ItemType)
			{
				case "EnergyItem":
					dy = - 14;			
					break;
				case "Material":
					dx = 15;
					break;
				case "Icon":
					dy = -15;
					break;
			}
			if (GameLogic.getInstance().user.IsViewer())
			{
				des.x = GuiMgr.getInstance().GuiMain.btnHome.img.x + dx;
				des.y = GuiMgr.getInstance().GuiMain.btnHome.img.y + GuiMgr.getInstance().GuiMain.img.y + dy;
			}
			else
			{
				if (GuiMgr.getInstance().GuiStore.IsVisible)
				{
					var p:Point = GuiMgr.getInstance().GuiStore.getTabPosByType(ItemType);
					des.x = GuiMgr.getInstance().GuiStore.img.x + p.x - 5 + dx;
					des.y = GuiMgr.getInstance().GuiStore.img.y - 10 + dy;				
				}
				else
				{
					if (GuiMgr.getInstance().GuiMain && GuiMgr.getInstance().GuiMain.IsVisible) 
					{
						des.x = GuiMgr.getInstance().GuiMain.btnInventory.img.x + dx;
						des.y = GuiMgr.getInstance().GuiMain.img.y + GuiMgr.getInstance().GuiMain.btnInventory.img.y  + dy;
					}
					else
					{
						des.x = GuiMgr.getInstance().guiUserInfo.txtExp.x;
						des.y = GuiMgr.getInstance().guiUserInfo.txtExp.y;
					}
				}
			}
			return des;
		}
		
		public function startFly():void
		{
			if (movingState == FLY || movingState == DISAPPEAR || stayInLake) return;
			//bay vao kho
			ChangeLayer(Constant.GUI_MIN_LAYER);
			//var p:Point = Ultility.PosLakeToScreen(img.x, img.y);
			var p:Point = Sprite(Parent).localToGlobal( new Point(img.x, img.y));
			p = LayerMgr.getInstance().GetLayer(Constant.GUI_MIN_LAYER).globalToLocal(p);
			img.x = p.x;
			img.y = p.y;			
			var des:Point;
			if (getDesToFly == null)
			{
				des = getDesPosToStore();					
			}
			else
			{
				des = getDesToFly();
			}
			var med:Point = getThroughPoint(p, des);
			TweenMax.to(img, 1, { bezierThrough:[ { x:med.x, y:med.y }, { x:des.x, y:des.y } ], ease:Cubic.easeOut, onComplete:onFinishTween } );	
			movingState = FLY;		
		}
	}

}