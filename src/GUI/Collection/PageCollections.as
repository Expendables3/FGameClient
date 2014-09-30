package GUI.Collection 
{
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import GUI.component.Container;
	import GUI.component.ListBox;
	import GUI.component.ScrollBar;
	import Logic.GameLogic;
	
	/**
	 * 1 trang collections: weapon, amour, helmet
	 * @author dongtq
	 */
	public class PageCollections extends Container 
	{
		private var listSetCollection:ListBox;
		private var scrollBar:ScrollBar;
		
		public function PageCollections(parent:Object, imgName:String = "", x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, "", x, y, isLinkAge, imgAlign);
		}
		
		public function initPageCollection(data:Object, _pageId:String):void
		{
			LoadRes("");
			listSetCollection = new ListBox(ListBox.LIST_Y, 3, 1);
			listSetCollection.setPos(40, 140);
			img.addChild(listSetCollection);
			var min:int = 1000;
			var max:int = 0;
			for (var s:String in data)
			{
				if (s != "Id" && s != "Name" && s != "type")
				{
					if (int(s) < min)
					{
						min = int(s);
					}
					if (int(s) > max)
					{
						max = int(s);
					}
				}
			}
			
			for (var i:int = min; i <= max; i++)
			{
				if (data[i] != null)
				{
					var setCollection:SetCollection = new SetCollection(listSetCollection);
					//setCollection.initSetCollection(data[i], data["Id"]);
					setCollection.initSetCollection(data[i], _pageId);
					listSetCollection.addItem(setCollection.rewardId.toString(), setCollection);
				}
			}
		/*	for (var s:String in data)
			{
				if (s != "Id" && s != "Name" && s != "type")
				{
					var setCollection:SetCollection = new SetCollection(listSetCollection);
					setCollection.initSetCollection(data[s], data["Id"]);
					listSetCollection.addItem(setCollection.rewardId.toString(), setCollection);
				}
			}*/
			
			scrollBar = AddScroll("", "GuiCollection_ScrollBarExtendDeco", 675, 100);
			scrollBar.setScrollImage(listSetCollection.img, 0, 415);
			
			if (listSetCollection.length < 4)
			{
				scrollBar.visible = false;
			}
			else
			{
				scrollBar.visible = true;
			}
		}
		
		public function initData(data:Object):void
		{
			for each(var setCollection:SetCollection in listSetCollection.itemList)
			{
				setCollection.initData(data);
			}
		}
		
		public function focusTo(rewardType:String, rewardId:int):void
		{
			var arr:Array = listSetCollection.itemList;
			var index:int;
			for each(var setCollection:SetCollection in arr)
			{
				if (setCollection.rewardId == rewardId && setCollection.rewardType == rewardType)
				{
					index = listSetCollection.getIndexById(setCollection.rewardId.toString());
					//setCollection.SetHighLight(0xff0000);
					TweenMax.to(setCollection.img, 1, { glowFilter: { color:0xff0000, alpha:1, blurX:20, blurY:20, strength:1.5 }} );
					//setCollection.ChangeColor(new ColorTransform(1, 1, 1, 1, 255, 0, 0, 0), "1");
				}
			}
			
			var dy:Number = (scrollBar.bar.height -scrollBar.getBtnBarHeight())  * ((index -1) / (listSetCollection.numItem));
			scrollBar.setScrollPos(65 + dy);
			listSetCollection.showItem(index - 1);
		}
		
		public function updateInfo():void
		{
			var itemCollection:Object = GameLogic.getInstance().user.StockThingsArr["ItemCollection"];
			initData(itemCollection);
			for each(var setCollection:SetCollection in listSetCollection)
			{
				setCollection.updateBtnClaim();
			}
		}
	}

}