package GUI.Collection 
{
	import com.greensock.easing.Cubic;
	import com.greensock.TweenMax;
	import Data.ConfigJSON;
	import flash.geom.Point;
	import GUI.component.BaseGUI;
	import GUI.component.ListBox;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author dongtq
	 */
	public class GUIAnoucementCollection extends BaseGUI 
	{
		private var listIcon:Object;
		private var check:Boolean;
		
		public function GUIAnoucementCollection(parent:Object, imgName:String) 
		{
			super(parent, imgName);
		}
		
		override public function InitGUI():void 
		{
			LoadRes("GUI_Anoucement_Collection_Bg");
			SetPos(811, 25);
			SetScaleXY(0.7);
		}
		
		public function showTab(tabName:String, itemId:int):void
		{
			Show();
			
			var itemCollection:Object = GameLogic.getInstance().user.StockThingsArr["ItemCollection"];
			var data:Object = new Object();
			for each(var obj:Object in itemCollection)
			{
				data[obj["Id"]] = obj["Num"];
			}
			
			var config:Object = ConfigJSON.getInstance().getItemInfo("ItemCollectionExchange", -1);
			
			if((tabName == "Sea" && itemId < 22) || (tabName == "MetalSea" && itemId < 32) || (tabName == "IceSea"))
			{
				config = config[tabName][1]["NecessaryItem"];
			}
			else if (tabName == "MetalSea" && itemId >= 32)
			{
				config = config[tabName][2]["NecessaryItem"];
			}
			else 
			{
				config  = config[tabName][2]["NecessaryItem"];
			}
			
			var i:int = 0;
			listIcon = new Object();
			for (var s:String in config)
			{
				var iconCollection:ItemCollection = new ItemCollection(img);
				iconCollection.forAnoucement = true;
				iconCollection.initItemCollection(config[s]["ItemType"], config[s]["ItemId"], 0);
				iconCollection.num = data[config[s]["ItemId"]];
				iconCollection.SetPos(i * 90, 15 - 20);
				i++;
				this.img.addChild(iconCollection.img);
				listIcon[config[s]["ItemId"]] = iconCollection;
			}
			
			TweenMax.to(img , 2, { bezierThrough:[ { x:300, y:25 } ], ease:Cubic.easeOut, onComplete:onCompleteOut, onCompleteParams:[itemId] } );	
			check = true;
		}
		
		private function onCompleteOut(itemId:int):void 
		{
			//TweenMax.to(img , 3, { bezierThrough:[ { x:300, y:50 }, { x:300, y:50 }, { x:300, y:50 }, {x:811, y:50} ], ease:Cubic.easeInOut, onComplete:onCompleteIn, onCompleteParams:[itemId]} );
		}
		
		public function addNum(itemId:int, num:int):void
		{
			if(listIcon[itemId.toString()] != null)
			{
				ItemCollection(listIcon[itemId.toString()]).num += num;
				//if (!GameLogic.getInstance().dropItemCollection)
				{
					TweenMax.to(img , 2, { bezierThrough:[ { x:300, y:25 }, { x:300, y:25 }, { x:300, y:25 }, { x:811, y:25 } ], ease:Cubic.easeInOut, onComplete:onCompleteIn, onCompleteParams:[itemId] } );
					check = false;
				}
			}
		}
		
		private function onCompleteIn(itemId:int):void 
		{
			//trace("complete");
			//if (!GameLogic.getInstance().dropItemCollection)
			{
				//GameLogic.getInstance().dropItemCollection = false;
				if (!check)
				{
					Hide();
					//GameLogic.getInstance().checkCompleteCollection(itemId);
				}
			}
			/*else if(img != null)
			{
				
				TweenMax.to(img , 3, { bezierThrough:[ { x:300, y:50 }], ease:Cubic.easeOut, onComplete:onCompleteOut, onCompleteParams:[itemId]} );					
			}*/
		}
		
		public function getPosById(itemId:int):Point
		{
			var p:Point;
			if (listIcon != null && img != null && listIcon[itemId.toString()] != null)
			{
				p = ItemCollection(listIcon[itemId.toString()]).GetPosition();
				p = img.localToGlobal(p);
				//p.x += 60;
				//p.y += 75;
				p.x += 43;
				p.y += 58;
				return p;
			}
			p = new Point(680, 500);
			return p;
		
		}
		
	}

}