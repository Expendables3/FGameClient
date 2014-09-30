package Event.EventHalloween.HalloweenGui.ItemGui 
{
	import Effect.EffectMgr;
	import Event.EventHalloween.HalloweenLogic.HalloweenMgr;
	import Event.EventHalloween.HalloweenLogic.ItemHalloweenInfo;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import GUI.component.ButtonEx;
	import GUI.component.Image;
	import GUI.ItemGift.AbstractItemGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemHalloween extends AbstractItemGift 
	{
		private const ID_IMG_THEME:String = "idImgTheme";
		private const ID_IMG_ROCK:String = "idImgRock";
		private const ID_IMG_FREEZE:String = "idImgFreeze";
		
		public var fTransformComp:Function = null;
		private var imgTheme:Image;
		//private var imgRock:Image;
		private var imgRock:ButtonEx;
		private var imgFreeze:Image;
		public function ItemHalloween(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemHalloween";
		}
		
		public function get Node():ItemHalloweenInfo
		{
			return _gift as ItemHalloweenInfo;
		}
		public function set Node(value:ItemHalloweenInfo):void
		{
			_gift = value;
		}
		
		public function get State():int
		{
			return Node.Thick;
		}
		
		override public function drawGift():void 
		{
			if (Node.Thick > 0)
			{
				imgTheme = AddImage(ID_IMG_THEME, "GuiHalloween_HalItem0", 0, 0, true, ALIGN_LEFT_TOP);
			}
			else
			{
				imgTheme = AddImage(ID_IMG_THEME, "GuiHalloween_Road", 0, 0, true, ALIGN_LEFT_TOP);
			}
			if (Node.Thick == 1)
			{
				if (Node.ItemId == 1)
				{
				}
				imgRock = AddButtonEx(ID_IMG_ROCK, Node.getImageName(), 2, 2);
			}
			else if (Node.Thick == 2)
			{
				imgRock = AddButtonEx(ID_IMG_ROCK, Node.getImageName(), 3, 2);
				imgFreeze = AddImage(ID_IMG_FREEZE, "GuiHalloween_Freeze", 25, 24);
			}
			if (Node.isBound)
			{
				img.buttonMode = true;
			}
		}
		
		override public function transform(data:Object = null):void 
		{
			var pos:Point = new Point(27, 29);
			pos = img.localToGlobal(pos);
			var effName:String;
			var x:int = pos.x;
			var y:int = pos.y;
			if (Node.ItemType == "End" && Node.ItemId == 1)
			{
				if (Node.Thick == ItemHalloweenInfo.LAND)
				{
					effName = "GuiHalloween_EffUnlockEnd";
					x -= 30;
					y -= 50;
				}
				else if(Node.Thick == ItemHalloweenInfo.ROAD)
				{
					effName = "EffAnNgoc";
				}
			}
			else
			{
				effName = "EffAnNgoc";
			}
			EffectMgr.getInstance().AddSwfEffect(Constant.GUI_MIN_LAYER,
													effName,
													null,
													x, y,
													false, false, null,
													function ():void 
													{ 
														onCompleteTransform(); 
													} 
												);
		}
		private function onCompleteTransform():void
		{
			if (Node.Thick == ItemHalloweenInfo.LAND)
			{
				if (Node.ItemType == "End" && Node.ItemId == 1)
				{
					imgRock.LoadRes("GuiHalloween_ImgUnlockKey");
				}
				else
				{
					RemoveImage(imgFreeze);
				}
			}
			else if (Node.Thick == ItemHalloweenInfo.ROAD)
			{
				RemoveButtonEx(ID_IMG_ROCK);
			}
			
			if (fTransformComp != null)
			{
				fTransformComp();
			}
		}
		public function showAsBound():void
		{
			imgTheme.LoadRes("GuiHalloween_Bound");
			if (Node.Thick == 2)
			{
				img.swapChildrenAt(1, 3);
				img.swapChildrenAt(2, 3);
			}
			if (Node.Thick == 1)
			{
				img.swapChildrenAt(1, 2);
			}
			img.buttonMode = true;
		}
		public function showAsLand():void
		{
			imgTheme.LoadRes("GuiHalloween_Road");
			img.buttonMode = false;
		}
		public function freeze():void
		{
			Node.Thick = ItemHalloweenInfo.FREEZE;
			imgFreeze = AddImage(ID_IMG_FREEZE, "GuiHalloween_Freeze", 25, 24);
		}
		
		public function updateItem(curTime:Number):void 
		{
			if (guiTooltip == null) return;
			if (guiTooltip.IsVisible)
			{
				(guiTooltip as TooltipSquare).updateTooltip(curTime);
			}
		}
	}
}















