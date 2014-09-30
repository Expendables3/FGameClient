package Logic 
{
	import Data.ConfigJSON;
	import flash.desktop.ClipboardFormats;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import GameControl.GameController;
	import GUI.component.Button;
	import GUI.component.ButtonEx;
	import GUI.component.Image;
	import GUI.ExtendDeco.GUIIconExtend;
	import GUI.GuiMgr;
	import Logic.BaseObject;
	import flash.geom.Transform;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author ducnh
	 */
	public class Decorate extends BaseObject
	{
		private const MAX_SCALE:Number = 1.4;
		private const MIN_SCALE:Number = 1.0;
		
		// thong tin lay tu database ve
		private var _Id:int;
		public var ItemId:int;
		public var ItemType:String;
		public var LastTimeGetMoney:int;
		public var Option:Object;
		public var X:int;
		public var Y:int;
		public var Z:Number;
		public var expiredTime:Number;
		public var extendTime:Number;
		
		// doi tuong moi tao ra
		public var IsNewObj:Boolean = true;
		
		// toa do cu
		private var UnmovePosX:Number;
		private var UnmovePosY:Number;
		private var UnmoveScale:Number;
		
		// thong tin do hoa
		public var Deep:Number = 0;
		public var Scale:Number = 1;
		
		// thong tin luu lai khi edit
		private var oldX:Number;
		private var oldY:Number;
		private var oldZ:Number;
		private var oldDeep:Number;
		
		public var official:Boolean = true;
		public var isExpired:Boolean = false;
		private var guiExtend:GUIIconExtend = new GUIIconExtend(null, "");
		
		public function Decorate(parent:Object, imgName:String, x:int, y:int, itemType:String, itemID:int)
		{
			ItemType = itemType;
			ItemId = itemID;
			super(parent, imgName, x, y, true, ALIGN_LEFT_TOP);
			this.ClassName = "Decorate";
			
			X = x;
			Y = y;
			
			if (ConfigJSON.getInstance())
			{
				var config:Object = ConfigJSON.getInstance().getItemInfo(itemType, itemID);
				if (config)
				{
					if(itemType == "PearFlower")
					{
						Option = config.Buff;
					}
					extendTime = config["TimeUse"];
				}
				else 
				{
					extendTime = int.MAX_VALUE;
				}
			}
		}

		public function HasChanged():Boolean
		{
			if (oldX != img.x) return true;
			if (oldY != img.y) return true;
			if (oldZ != Scale) return true;
			
			return false;
		}
		
		public function SaveInfo(isOffical:Boolean = true):void
		{
			UnmovePosX = img.x;
			UnmovePosY = img.y;
			oldX = img.x;
			oldY = img.y;
			oldZ = Scale;
			SetPos(oldX, oldY);
			official = isOffical;
		}
		
		public function UnMovePos():void
		{
			SetPos(UnmovePosX, UnmovePosY);
			UpdateDeep();		
			ShowDisable(false);
		}
		
		public function DoMovePos(px:int, py:int):void
		{
			UnmovePosX = img.x;
			UnmovePosY = img.y;
			SetPos(px, py);
		}
		
		public function UnSaveEdit():void
		{
			SetHighLight( -1);
			ChangeLayer(Constant.OBJECT_LAYER);
			SetPos(oldX, oldY);
			SetScale(oldZ);
			UpdateDeep();
			//SetDeep(oldDeep);
		}
		
		public virtual function UpdateDeep():void
		{
			var r:Rectangle = GameController.getInstance().GetDecorateArea();
			var tg:Number = 1 - (CurPos.y - r.top) / (r.height);
			if (tg > 1)
			{
				tg = 1;
			}
			if (tg < 0)
			{
				tg = 0;
			}
			SetDeep(tg);
		}
		
		public function ReloadInfo():void
		{
			X = oldX;
			Y = oldY;
			Z = oldZ;
		}
		
		public function ShowDisable(isShow:Boolean):void
		{
			var c:ColorTransform;
			if ((img == null) || (img.parent == null))
			{
				return;
			}
			
			if (!isShow)
			{
				SetHighLight(0x00FF00);
				//c = new ColorTransform();
				//img.transform.colorTransform = c;
			}
			else
			{
				SetHighLight(0xFF0000);
				//c = new ColorTransform(1.0, 0.4, 0.4, 1);
				//img.transform.colorTransform = c;
			}
		}
			
		public virtual function CheckPosition():Boolean
		{
			var kq:Boolean = true;
			var r:Rectangle = GameController.getInstance().GetDecorateArea();//vùng đáy biển dành cho decorate
			var r1:Rectangle = img.getBounds(img.parent);					//vùng bao ngoài decorate
			if (r1.left + r1.width > Constant.MAX_WIDTH - 20)				//vượt quá cạnh phải
			{
				kq = false;
			}
			if (r1.top < 20)												//vượt quá cạnh trên của GUIMain	ko cần thiết
			{
				kq = false;
			}
			if (r.top >  r1.bottom)											//deco vượt quá cạnh trên của đáy biển
			{
				kq = false;
			}
			else if(r.bottom < r1.bottom) 									//deco vượt quá cạnh dưới của đáy biển
			{
				kq = false;
			}
			if (kq)
			{
				ShowDisable(false);
				//UpdateDeep();
			}
			return kq;
		}
		
		public virtual function SetDeep(deep:Number):void
		{
			Deep = deep;
			img.scaleX = Scale*(0.6 + 0.4 * (1 - deep));
			img.scaleY = Scale*(0.6 + 0.4 * (1 - deep));
			var t:Transform = img.transform;
			var c:ColorTransform = new ColorTransform(0.6+0.4*(1-deep), 0.6+0.4*(1-deep), 0.8+0.2*(1-deep), 1);
			img.transform.colorTransform = c;
			oldDeep = Deep;
		}
		
		public function SetScale(scale:Number):void
		{
			Scale = scale;
			if (Scale > MAX_SCALE)
			{
				Scale = MAX_SCALE;
			}
			if (Scale < MIN_SCALE)
			{
				Scale = MIN_SCALE;
			}

			SetDeep(Deep);
			Z = Scale;
		}
		
		public override function OnLoadRes():void
		{
			addAllEvent();
			if (ItemType != "OceanAnimal")
			{
				var tg:MovieClip = img as MovieClip;
				if (tg != null)
				{
					if (tg.totalFrames > 1)
					{
						img.cacheAsBitmap = false;
					}
					else
					{
						img.cacheAsBitmap = true;
						//convert2Bmp();
					}
				}
			}
		}
		
		
		override public function OnLoadResComplete():void 
		{
			super.OnLoadResComplete();
			if (GameLogic.getInstance().CurServerTime > expiredTime)
			{
				img.visible = false;
			}
		}
		
		public override function OnBeforeReloadRes():void
		{
			removeAllEvent();
		}
		
		public override function OnReloadRes():void
		{
			addAllEvent();
			SetDeep(Deep);
			if (ItemType != "OceanAnimal")
			{
				var tg:MovieClip = img as MovieClip;
				if (tg != null)
				{
					if (tg.totalFrames > 1)
					{
						img.cacheAsBitmap = false;
					}
					else
					{
						img.cacheAsBitmap = true;
						//convert2Bmp();
					}
				}
			}
		}
		
		public function Zoom(scaleInterval:Number):Boolean
		{
			var scale:Number = Scale + scaleInterval;
			if (scale > MAX_SCALE)
			{
				scale = MAX_SCALE;
			}
			if (scale < MIN_SCALE)
			{
				scale = MIN_SCALE;
			}
			if (scale == Scale)
			{
				return false;
			}
			SetScale(scale);
			return true;
		}
		
		public override function OnStartDrag():Boolean
		{
			if (GameLogic.getInstance().gameState != GameState.GAMESTATE_EDIT_DECORATE)
			{
				return false;
			}
			
			this.SetHighLight();
			return true;
		}
		
		public override function OnFinishDrag():Boolean
		{
			this.SetHighLight(-1);
			return true;
		}
		
		public override function OnDragOver(obj:Object):void
		{
			if (!this.CheckPosition())
			{
				// hien thi ko the di chuyen
				if (!GuiMgr.getInstance().GuiStore.IsPointInGUI(this.img.x, this.img.y))
				{
					this.ShowDisable(true);
				}
				else
				{
					this.ShowDisable(false);
					
				}
			}
			else
			{
				this.UpdateDeep();
			}
		}
		
		public function canExtend():Boolean
		{
			var curTime:Number = GameLogic.getInstance().CurServerTime;
			//trace(expiredTime - curTime);
			if (expiredTime < curTime || expiredTime > (curTime + Constant.TIME_CAN_EXTEND))
			{
				return false;
			}
			return true;
		}
		
		public function showButtonExtend():void
		{
			if (guiExtend != null && !guiExtend.IsVisible)
			{
				guiExtend.showGUI();
			}
		}
		
		public function hideButtonExtend():void
		{
			if (guiExtend != null && guiExtend.IsVisible)
			{
				//trace("hide button extend");
				guiExtend.Hide();
			}
		}
		
		public function get Id():int 
		{
			return _Id;
		}
		
		public function set Id(value:int):void 
		{
			_Id = value;
			guiExtend.idDeco = value;
		}
		
		override public function SetPos(x:Number, y:Number):void 
		{
			super.SetPos(x, y);
			var pt:Point = new Point();
			var rec:Rectangle = img.getBounds(img.parent);
			var w:int = rec.width;
			var h:int = rec.height;
			pt.x = rec.left;
			pt.y = rec.top;
			
			guiExtend.SetPos(pt.x + w/2 - 15, pt.y - 30);
		}
	}

}