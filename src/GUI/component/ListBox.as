package GUI.component 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ... lớp này dùng làm cái listbox
	 * @author ducnh
	 */
	public class ListBox extends Sprite
	{
		public static const LIST_X:int = 1;
		public static const LIST_Y:int = 2;
		
		public var IdObject:String;
		private var dx0:int = 10;
		private var dy0:int = 10;
		private var wItem:int = 0;
		private var hItem:int = 0;
		private var listType:int = 1;
		public var itemList:Array = [];
		private var itemListBackup:Array = [];
		private var maskImg:Sprite;
		private var numRowShow:int = 3;
		private var numColShow:int = 3;
		public var curPage:int = 0;
		public var img:Sprite;
		// dieu khien chuyen dong
		public var wheeling:Boolean = false;
		private var desPos:Point = new Point();
		private var isMoving:Boolean = false;
		private var dir:Point = new Point();
		private var curSpeed:Number;
		private var a:Number;
		public var speed:Number = 60;
		public var friction:Number = 0.99999;
		// hien thi theo type
		private var typeIndex:int = 0;
		private var typeCount:int = -1;
		// thứ tự item đang hiển thị ở đầu
		private var nowStartItem:int = 0;
		private var oldStartItem:int = 0;
		
		// rong, dai, background
		private var listW:int;
		private var listH:int
		private var listBorder:Sprite = null;
		private var _border:Boolean = false;
		
		private var smartList:Array = [];
		public var isSmartList:Boolean = false;
		public var sizeSmartList:int = 9;
  
		/**
		 * khởi tạo listbox
		 * @param	type kiểu listbox (LIST_X: list theo chiều ngang, LIST_Y:list theo chiều dọc)
		 * @param	nRow số hàng hiển thị trong 1 trang
		 * @param	nCol số cột hiển thị trong 1 trang
		 * @param	dx khoảng cách giữa x các item
		 * @param	dy khoảng cách giữa y các item
		 * @param	wheeling cho phép dùng cuộn chuột hay ko
		 */
		public function ListBox(type:int, nRow:int, nCol:int, dx:int = 10, dy:int = 10, wheeling:Boolean = false) 
		{
			listType = type;
			numRowShow = nRow;
			numColShow = nCol;
			dx0 = dx;
			dy0 = dy;
			this.wheeling = wheeling;
			img = new Sprite();
			img.x = dx0 / 2;
			img.y = dy0 / 2;
			this.addChild(img);
			createMask(1, 1);
			
			this.addEventListener(Event.ENTER_FRAME, update);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, OnMouseWheel);
			smartList = [];
		}	
		
		public function get ColShow():int
		{
			return numColShow;
		}
		
		public function get RowShow():int
		{
			return numRowShow;
		}
		
		public function get numItem():int
		{
			return itemList.length;
		}
		
		public function OnMouseWheel(e:MouseEvent):void 
		{
			if (!wheeling) return;
			
			if (e.delta > 0)
			{
				showPrePage();
			}
			else
			{
				showNextPage();
			}
		}		
		
		/**
		 * chieu dai listbox
		 */
		public function get length():int
		{
			return itemList.length;
		}
		
		/**
		 * tham chiếu đến 1 item
		 * @param	index
		 * @return
		 */
		public function getItemByIndex(index:int):Container
		{
			return itemList[index] as Container;
		}		
		
		/**
		 * chỉ hiện ra những item thỏa mãn 1 cái function nào đó (function(item) == true)
		 * @param	f
		 */
		public function showItemByFunction(f:Function):void
		{
			typeIndex = 0;
			typeCount = -1;

			// load lai mang backup
			itemList.splice(0, itemList.length);
			itemList = itemList.concat(itemListBackup);
			
			// an di nhung cai type khac
			var i:int = 0;
			//for (i = 0; i < itemList.length; i++)
			//{
				//if (f(itemList[i]))
				//{
					//itemList[i].visible = true;
				//}
				//else
				//{
					//itemList[i].visible = false;
				//}
			//}
			while (i < itemList.length)
			{
				if (f(itemList[i]))
				{
					itemList[i].img.visible = true;
					i++;
				}
				else
				{
					itemList[i].img.visible = false;
					itemList.splice(i, 1);
				}
			}
			
			updateAllItemPos();
			var oldSpeed:int = speed;
			speed = 0;
			showPage(0);
			speed = oldSpeed;
		}
		
		public function updateInvisibleItem():void
		{
			// load lai mang backup
			itemList.splice(0, itemList.length);
			itemList = itemList.concat(itemListBackup);
			
			var i:int = 0;
			while (i < itemList.length)
			{
				if (itemList[i].img.visible)
				{
					i++;
				}
				else
				{
					itemList.splice(i, 1);
				}
			}
			updateAllItemPos();
			var oldSpeed:int = speed;
			speed = 0;
			showPage(curPage);
			speed = oldSpeed;
		}
		
		private function update(event:Event):void
		{
			if (!isMoving)
			{
				return;
			}
			// update pos
			if (curSpeed > 2)
			{
				curSpeed *= friction;
			}

			var curPos:Point = new Point(img.x, img.y);
			var temp:Point = curPos.subtract(desPos);
			var speedVec:Point = new Point(dir.x * curSpeed, dir.y * curSpeed);
			if ( temp.length <= speedVec.length)
			{
				isMoving = false;
				img.x = desPos.x;
				img.y = desPos.y;
				return;
			}
				
			curPos = curPos.add(speedVec);
			img.x = curPos.x;
			img.y = curPos.y;
		}
		
		private function moveTo(px:int, py:int):void
		{
			if (speed > 0)
			{
				isMoving = true;
				desPos.x = px;
				desPos.y = py;
				dir = desPos.subtract(new Point(img.x, img.y));
				
				var s:Number = dir.length;
				speed = s * (1 - friction) / (1 - Math.pow(friction, 11));
				
				dir.normalize(1);
				if (dir.length < 0.5) 
				{
					isMoving = false;
				}
				curSpeed = speed;
				//trace(curSpeed);
			}
			else
			{
				img.x = px;
				img.y = py;
			}
		}
		
		/**
		 * thêm thông tin cho listbox
		 * @param	dx là khoảng cách giữa 2 item gần nhau theo x
		 * @param	dy là khoảng cách giữa 2 item gần nhau theo y
		 * @param	itemWidth là chiều rộng của 1 item
		 * @param	itemHeight là chiều cao của 1 item
		 */
		public function setInfo(dx:int = 10, dy:int = 10, itemWidth:int = 0, itemHeight:int = 0):void
		{
			wItem = itemWidth;
			hItem = itemHeight;
			dx0 = dx;
			dy0 = dy;
			img.x = dx0 / 2;
			img.y = dy0 / 2;
			updateAllItemPos();
		}
		
		/**
		 * thay đổi vị trí đặt
		 * @param	posX
		 * @param	posY
		 */
		public function setPos(posX:int, posY:int):void
		{
			this.x = posX;
			this.y = posY;
		}
		
		/**
		 * thêm 1 item vao listbox
		 * @param	item
		 */
		public function addItem(id:String, item:Container, eventHandler:Container = null):void
		{
			// thay doi kich thuoc item
			if (wItem == 0 || hItem == 0)
			{
				wItem = item.img.width;
				hItem = item.img.height;
				createMask(numColShow * (wItem + dx0), numRowShow * (hItem + dy0));
			}
			
			// add item vao list
			item.IdObject = id;
			item.EventHandler = eventHandler;
			img.addChild(item.img);
			itemList.push(item);
			itemListBackup.push(item);
			updateItemPos(itemList.length - 1);
		}
		
		/**
		 * thêm 1 item tại 1 vị trí nào đó
		 * @param	id
		 * @param	item
		 * @param	index
		 * @param	eventHandler
		 */
		public function addItemAt(id:String, item:Container, index:int, eventHandler:Container = null):void
		{
			// thay doi kich thuoc item
			if (wItem == 0 || hItem == 0)
			{
				wItem = item.img.width;
				hItem = item.img.height;
				createMask(numColShow * (wItem + dx0 + 1), numRowShow * (hItem + dy0 + 1));
			}
			
			// add item vao list
			item.IdObject = id;
			item.EventHandler = eventHandler;
			img.addChild(item.img);
			
			// them vao mang
			if (index >= itemList.length)
			{
				itemList.push(item);
			}
			else
			{
				var tg:Array = itemList.slice(index);
				itemList.splice(index + 1);
				itemList[index] = item;
				itemList = itemList.concat(tg);
			}
			
			// tao backup
			itemListBackup.splice(0, itemListBackup.length);
			itemListBackup = itemListBackup.concat(itemList);
			
			// update lai toa do
			updateAllItemPos();
			if (itemList.length == 1)
			{
				showPage(0);
				speed = 60;
			}
		}

		/**
		 * xóa 1 item khoi list
		 * @param	id
		 */
		public function removeItem(id:String):void
		{
			var item:Container;
			var i:int;
			var vt:int;
			for (i = 0; i < itemList.length; i++)
			{
				item = itemList[i] as Container;
				if (item.IdObject == id)
				{
					itemListBackup.splice(i, 1);
					itemList.splice(i, 1);
					item.Clear();
					vt = i;
					break;
				}
			}
			
			updateAllItemPos();
		}
		
		/**
		 * xóa 1 item khoi list, return item do ra
		 * @param	id
		 */
		public function removeAndReturnItem(id:String):Container
		{
			var item:Container = null;
			var i:int;
			var vt:int;
			for (i = 0; i < itemList.length; i++)
			{
				item = itemList[i] as Container;
				if (item.IdObject == id)
				{
					itemListBackup.splice(i, 1);
					itemList.splice(i, 1);
					vt = i;
					break;
				}
			}
			
			updateAllItemPos();
			return item;
		}
		
		/**
		 * tìm con trỏ đến item theo id
		 * @param	id
		 */
		public function getItemById(id:String):Container
		{
			var item:Container;
			var i:int;
			for (i = 0; i < itemList.length; i++)
			{
				item = itemList[i] as Container;
				if (item.IdObject == id)
				{
					return item;
				}
			}
			
			return null;
		}
		
		public function getIndexById(id:String):int
		{
			var item:Container;
			var i:int;
			for (i = 0; i < itemList.length; i++)
			{
				item = itemList[i] as Container;
				if (item.IdObject == id)
				{
					return i;
				}
			}
			return i;
		}
		
		public function getIdByIndex(index:int):String
		{
			var item:Container = itemList[index] as Container;
			var s:String = item.IdObject;
			return s;
		}
		/**
		 * xóa tất cả các item trong list
		 */
		public function removeAllItem():void
		{
			var item:Container;
			var i:int;
			for (i = 0; i < itemList.length; i++)
			{
				item = itemList[i] as Container;
				item.Clear();
			}
			itemList.splice(0, itemList.length);
			itemListBackup.splice(0, itemListBackup.length);
			curPage = 0;
			
			// chinh lai vi tri
			img.x = dx0 / 2;
			img.y = dy0 / 2;
		}
		
		/**
		 * update lại vị trí 1 item
		 * @param	index
		 */
		private function updateItemPos(index:int):void
		{
			var item:Container;
			item = itemList[index] as Container;
			if (!item.img.visible)
			{
				return;
			}
			
			// tim vi tri xuat hien
			var vt:int = index - typeIndex;
			if (vt < 0) 
			{
				vt = 0;
			}
			
			var tg:int = vt % (numRowShow * numColShow);
			var r:int = tg / numColShow;
			var c:int = tg % numColShow;
			var page:int = vt / (numRowShow * numColShow);
			var x:int;
			var y:int;
			
			switch (listType)
			{
				case LIST_X:
					x = numColShow * page * (wItem + dx0) + c * (wItem + dx0);
					y = r * (hItem + dy0);
					item.SetPos(x, y);
					break;
				case LIST_Y:
					x = c *(wItem + dx0);
					y = numRowShow * page * (hItem + dy0) + r * (hItem + dy0);
					item.SetPos(x, y);
					break;
			}
		}
		
		public function updateAllItemPos():void
		{
			var i:int;
			// xap sep lại vị trí các item
			for (i = i; i < itemList.length; i++)
			{
				updateItemPos(i);
			}
		}
		
		/**
		 * chuyển tới vị trí 1 item nào đó
		 * @param	index item cần hiển thị
		 */
		public function showItem(index:int):void
		{
			var itemIndex:int = index;
			
			if (itemIndex > itemList.length - 1)
			{
				itemIndex = itemList.length - 1;
			}
			if (itemIndex < 0)
			{
				return;
			}

			var item:Container = itemList[itemIndex] as Container;
			//img.x = -(item.img.x - dx0) - 5;
			//img.y = -(item.img.y - dy0) + 5;
			oldStartItem = nowStartItem;
			nowStartItem = itemIndex;
			moveTo( -(item.img.x - dx0) - dx0 / 2 , -(item.img.y - dy0) - dy0 / 2);
			curPage = Math.ceil(itemIndex / (numRowShow * numColShow));
		}
		
		/**
		 * hiện trang cuối
		 */
		public function showLastPage():void
		{
			showPage(getNumPage() - 1);
		}
		
		/**
		 * hiện trang đầu
		 */
		public function showFirstPage():void
		{
			showPage(0);
		}
		
		/**
		 * hiển thị 1 trang nào đó (kích thước trang nrow, ncol)
		 * @param	index trang cần hiển thị
		 */
		public function showPage(index:int):void
		{
			if (isMoving) return;
			var page:int = index;
			if (page > getNumPage() - 1)
			{
				page = getNumPage() - 1;
			}
			var i:int = 0;
			if (typeCount < 0)
			{
				i = page * numRowShow * numColShow;
			}
			else
			{
				i = page * numRowShow * numColShow + typeIndex;
			}
			if (i > itemList.length - 1)
			{
				i = itemList.length - 1;
			}
			if (i > itemList.length - 1)
			{
				i --;
			}
			var item:Container = itemList[i] as Container;
			//var n:int = itemList.length - i;
			//var nShow:int = numRowShow * numColShow;
			//if ((n < nShow) && (nShow < itemList.length))
			//{
				//i -= nShow - n;
			//}
			
			if (numRowShow == 1 || numColShow == 1)
			{
				var itemPerPage:int = numRowShow * numColShow;
				
				if (i > itemList.length - itemPerPage)
				{
					i = itemList.length - itemPerPage;
				}
			}
			curPage = page;
			showItem(i);
		}
		
		/**
		 * lấy số trang tối đa
		 * @return
		 */
		public function getNumPage():int
		{
			if (typeCount == -1)
			{
				return Math.ceil(itemList.length / (numRowShow * numColShow));
			}
			else
			{
				return Math.ceil(typeCount / (numRowShow * numColShow)); 
			}
		}
		
		/**
		 * lấy index của trang hiện tại
		 * @return
		 */
		public function getCurPage():int
		{
			return curPage;
		}
		
		/**
		 * hiển thị trang kế tiêp
		 */
		public function showNextPage():void
		{
			if (curPage < getNumPage() - 1)
			{
				showPage(curPage + 1);
			}
		}
		
		/**
		 * hiển thị trang trước đó
		 */
		public function showPrePage():void
		{
			if (curPage > 0)
			{
				showPage(curPage - 1);
			}
		}
		
		public function getCurPos():Point
		{
			var rt:Point = new Point();
			var item:Container = itemList[0] as Container;
			//if (curPage == 0)	return rt;
			if (listType == LIST_X)
			{
				rt.y = 0;
				rt.x = (item.img.width + dx0) * (oldStartItem - nowStartItem);
			}
			else 
			{
				rt.x = 0;
				rt.y = (item.img.height + dy0) * (oldStartItem - nowStartItem);
			}
			return rt;
		}
		
		public function updateAllGuiToolTip():void 
		{
			for (var i:int = 0; i < itemList.length; i++) 
			{
				var item:Container = itemList[i] as Container;
				if (item.guiTooltip != null)
				{
					item.guiTooltip.InitPos(item, item.guiTooltip.imgNameBg, item.img.localToGlobal(getCurPos()).x, 
							item.img.localToGlobal(getCurPos()).y, item.guiTooltip.deltaArrowX, item.guiTooltip.deltaArrowY)
				}
			}
		}
		
		public function createMask(w:int, h:int):void
		{
			if (maskImg != null)
			{
				this.removeChild(maskImg);
			}
			maskImg = new Sprite();
			maskImg.graphics.beginFill(0x00ff00, 0.4);
			maskImg.graphics.drawRect(0, -7, w, h + 7);
			maskImg.graphics.endFill();
			this.mask = maskImg;
			this.addChild(maskImg);
			listW = w;
			listH = h;
			
			if (border)
			{
				border = true;
			}
		}

		public function set border(data:Boolean):void
		{
			_border = data;
			if (data)
			{
				if (listBorder != null)
				{
					this.removeChild(listBorder);
				}
				listBorder = new Sprite();
				listBorder.graphics.beginFill(0xff00ff);
				listBorder.graphics.drawRect(0, 0, listW, listH);
				listBorder.graphics.endFill();
				//this.addChild(listBorder);
				this.addChildAt(listBorder, 0);
			}
			else
			{
				if (listBorder != null)
				{
					this.removeChild(listBorder);
					listBorder = null;
				}
			}
		}

		public function get border():Boolean
		{
			return _border;
		}
		
		public function hideItem(id:String):void
		{
			var item:Container;
			var i:int;
			for (i = 0; i < itemList.length; i++)
			{
				item = itemList[i] as Container;
				if (item.IdObject == id)
				{
					item.SetVisible(false);
					break;
				}
			}
			
			updateInvisibleItem();
		}
		
		public function restore():void
		{
			var i:int;
			var item:Container;
			itemList.splice(0, itemList.length);
			itemList = itemList.concat(itemListBackup);
			for (i = 0; i < itemList.length; i++)
			{
				item = itemList[i] as Container;
				if (!item.img.visible)
				{
					item.SetVisible(true);
					break;
				}
			}
			updateAllItemPos();
		}
		
		public function sortById(descending:Boolean = false):void
		{
			if (descending)
			{
				itemList.sortOn(["IdObject"], Array.DESCENDING);
			}
			else
			{
				itemList.sortOn(["IdObject"]);
			}
			updateAllItemPos();
		}
		
		public function destructor():void
		{
			this.removeEventListener(Event.ENTER_FRAME, update);
			this.removeEventListener(MouseEvent.MOUSE_WHEEL, OnMouseWheel);
			removeAllItem();
			
			img.parent.removeChild(img);
			img = null;
		}
		
		public function addSmartList():void 
		{
			var i:int = 0;
			var num:int = Math.min(smartList.length, sizeSmartList);
			for (i = 0; i < num; i++)
			{
				var item:Container = smartList[i] as Container;
				img.addChild(item.img);
				itemList.push(item);
				itemListBackup.push(item);
				updateItemPos(itemList.length - 1);
			}
			smartList.splice(0, num);
			updateAllItemPos();
			//trace("smartlist length", smartList.length, "itemlist lenght", itemList.length);
		}
	}

}