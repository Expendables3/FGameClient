package GUI.component 
{
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.geom.Point;
	import GUI.GuiMgr;
	import Logic.Layer;
	import Logic.LayerMgr;
	/**
	 * ...
	 * @author ...
	 */
	public class GUIToolTip extends Container 
	{
		public var imgNameBg:String;
		public var iLayer:int;
		public var IsVisible:Boolean;
		public var isHaveArrow:Boolean = true;
		
		public var sizeToolTipX:int;
		public var sizeToolTipY:int;
		public var posToolTipX:int;
		public var posToolTipY:int;
		
		public var sizeParentX:int;
		public var sizeParentY:int;
		public var posParentX:int;			// vị trí điểm trên góc phải của cha
		public var posParentY:int;
		
		public var posCenterX:int;
		public var posCenterY:int;
		
		// vi tri tuong doi cua diem trai tren cua bg so voi dinh mui ten khi khong co arrow
		public var deltaArrowX:int;	// toa do diem trai tren gui - toa do diem arrow
		public var deltaArrowY:int;
		
		// Hai bien danh gia su thay doi vi tri cua cac bg voi bg4
		public var deltaX:int;
		public var deltaY:int;
		
		public function GUIToolTip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false, SetInfo:Function = null, ImageId:String = "") 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIToolTip";
		}
		
		/**
		 * hiển thị cái GUI ra màn hình
		 * @param ilayer layer mà cái GUI này đặt lên
		 * @param ShowModal mức độ hiển thị của cái GUI này (= 0 => các layer thấp hơn ko bị khóa, > 0 => các layer thấp hơn sẽ bị khóa )
		 */
		public virtual function Show(ilayer:int = Constant.GUI_MIN_LAYER, isInitGUI:Boolean = true):void
		{
			//trace("-----------Show");
			this.iLayer = ilayer;
			var layer:Layer = LayerMgr.getInstance().GetLayer(iLayer);
			IsVisible = true;
			
			if (layer)
			{
				if (iLayer != Constant.EmptyLayer)
				{
					Clear();
				}
				//this.iLayer = ilayer;
				Parent = layer as Sprite;
				if(isInitGUI) InitGUI();
			}
		}
		
		public virtual function InitGUI():void
		{
			
		}
		
		/**
		 * 
		 * @param	ctn				: Container ma muon hien tooltip
		 * @param	loadImg			: 1 anh background nao do trong 4 anh
		 * @param	globalParentX	: Vi tri goc tren ben trai cua container tren stage
		 * @param	globalParentY
		 * @param	deltaX			: toa do diem mui ten cua backgrond tro den goc IV
		 * @param	deltaY
		 * @param	isLinkAge
		 */
		public function InitPos(ctn:Container, loadImg:String, globalParentX:int, globalParentY:int, posXArrow:int, posYArrow:int, DeltaX:int = 0, DeltaY:int = 0, isLinkAge:Boolean = true, isHaveArrows:Boolean = true):void
		{
			isHaveArrow = isHaveArrows;
			Show(Constant.GUI_MIN_LAYER, false);
			if (loadImg.search("1") == loadImg.length - 1 || loadImg.search("2") == loadImg.length - 1 ||
				loadImg.search("3") == loadImg.length - 1 || loadImg.search("4") == loadImg.length - 1)
			{
				loadImg = loadImg.slice(0, loadImg.length - 1);
			}
			if(isHaveArrow)
			{
				LoadRes(loadImg + "1");
			}
			else 
			{
				LoadRes(loadImg);
			}
			
			//var globalParentX:int = ctn.img.localToGlobal(new Point(0, 0)).x;
			//var globalParentY:int = ctn.img.localToGlobal(new Point(0, 0)).y;
			
			sizeToolTipX = img.width;
			sizeToolTipY = img.height;
			
			sizeParentX = ctn.img.width;
			sizeParentY = ctn.img.height;
			posParentX = globalParentX;
			posParentY = globalParentY;
			
			var layer:Layer = LayerMgr.getInstance().GetLayer(this.iLayer);
			posCenterX = layer.stage.stageWidth / 2;
			posCenterY = layer.stage.stageHeight / 2;
			if (GuiMgr.IsFullScreen)
			{
				posCenterX = layer.stage.fullScreenWidth / 2;
				posCenterY = layer.stage.fullScreenHeight / 2;
			}
			
			deltaArrowX = posXArrow;
			deltaArrowY = posYArrow;
			
			this.deltaX = DeltaX;
			this.deltaY = DeltaY;
			
			Clear();
			var typeBg:int = getTypeBg();
			getPosGui(getTypeBg());
			if(isHaveArrow)
			{
				imgNameBg = loadImg + typeBg.toString();
			}
			else 
			{
				imgNameBg = loadImg;
			}
			LoadRes(imgNameBg);
			
			
			SetPos(posToolTipX, posToolTipY);
			
			getDeltaPos(typeBg);
			Hide();
		}
		
		
		/**
		 * ẩn cái GUI khỏi màn hình
		 * nếu GUI đang ở chế độ ShowModal > 0, thì khi ẩn chế độ này tự mất đi
		 */
		public function Hide():void
		{
			if (iLayer == Constant.EmptyLayer) 
			{
				return;
			}
			
			iLayer = Constant.EmptyLayer;
			IsVisible = false;		

			this.Clear();
			OnHideGUI();
		}
		
		public virtual function OnHideGUI():void
		{
		}
		
		private function getDeltaPos(type:int):void 
		{
			//trace("-----------getDeltaPos");
			if (type > 3 || type < 1)
			{
				deltaX = 0;
				deltaY = 0;
				return;
			}
			//deltaX = Math.max(deltaArrowX, 0) * (((type % 2) + int(type / 2)) % 2);
			//deltaY = 2 * Math.max(deltaArrowY, 0) * int(type / 2);
			deltaX = Math.max(deltaX, 0) * (((type % 2) + int(type / 2)) % 2);
			deltaY = 2 * Math.max(deltaY, 0) * int(type / 2);
		}
		public function getTypeBg():int
		{
			//trace("-----------getTypeBg");
			var curPosMouse:Point = GameInput.getInstance().MousePos;
			//if(isHaveArrow)
			{
				if (curPosMouse.x <= posCenterX) 
				{
					if (curPosMouse.y <= posCenterY)	// goc IV
					{
						return 4;
					}
					else 	// Góc III
					{
						return 3;
					}
				}
				else if (curPosMouse.y <= posCenterY) 	// Góc I
				{
					return 1;
				}
				else 	// Góc II
				{
					return 2;
				}
			}
			//else 
			//{
				//return -1;
			//}
		}
		public function getPosGui(typeBg:int):void
		{
			//trace("-----------getPosGui");
			var curPosMouse:Point = GameInput.getInstance().MousePos;
			
			//posToolTipX = curPosMouse.x;
			//posToolTipY = curPosMouse.y;
			if (posToolTipX + sizeToolTipX > 2 * posCenterX)	posToolTipX = curPosMouse.x - sizeToolTipX;
			if (posToolTipY + sizeToolTipY > 2 * posCenterY)	posToolTipY = curPosMouse.y - sizeToolTipY;
			
			//ThanhNT2 add check cho tip nang trong khung
			if (curPosMouse.x <= posCenterX) 
			{
				if (curPosMouse.y <= posCenterY) 
				{
					//trace(" x<, y<");
					posToolTipX = curPosMouse.x + 40;
					posToolTipY = curPosMouse.y - sizeToolTipY/2;
				}
				else 
				{
					//trace(" x<, y>");
					posToolTipX = curPosMouse.x+ 10;
					posToolTipY = curPosMouse.y - sizeToolTipY;
				}
			}
			else 
			{
				if (curPosMouse.y <= posCenterY)  
				{
					//trace(" x>, y<");
					posToolTipX = curPosMouse.x - sizeToolTipX - 40;
					posToolTipY = curPosMouse.y - sizeToolTipY/2;
				}
				else 
				{
					//trace(" x>, y>");
					posToolTipX = curPosMouse.x - sizeToolTipX - 10;
					posToolTipY = curPosMouse.y - sizeToolTipY;
				}
			}
			//End ThanhNT2
			
		}
	}

}