package GUI.component 
{
	import com.bit101.components.ComboBox;
	import Data.ResMgr;
	import Event.EventIceCream.GUIMainEventIceCream;
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import GameControl.HelperMgr;
	import GUI.component.Tree.TreeNode;
	import Event.*;
	import Logic.*;
	
	
	/**
	 * lớp này là lớp cơ bản, chứa các component (như textbox, label, button...) và có thể chứa cả các container
	 * @author ducnh
	 */
	public class Container extends Image 
	{
		/** là đối tượng bắt và xử lý các event do container sinh ra*/
		public var EventHandler:Container;
		/** dòng chữ xuất hiện khi di chuột qua*/
		public var TooltipText:String = null;
		public var tooltip:TooltipFormat = null;
		public var guiTooltip:GUIToolTip;
		/** ID duy nhất của container trong GUI*/
		public var IdObject:String;
		
		private var DesPos:Point = new Point();
		private var SpeedVec:Point = new Point();
		private var IsMoving:Boolean = false;
		protected var Dragable:Boolean = false;
		private var DragableArea:Rectangle = new Rectangle;
		private var OldColorHightLight:int = -1;
		
		public var LabelArr:Array = [];
		public var ButtonArr:Array = [];
		public var ProgressArr:Array = [];
		public var TextBoxArr:Array = [];
		public var ContainerArr:Array = [];
		public var ImageArr:Array = [];
		public var ButtonExArr:Array = [];
		public var ComboBoxArr:Array = [];
		public var ListboxArr:Array = [];
		public var ScrollBarArr:Array = [];
		public var ImageDigitArr:Array = [];
		public var isLook:Boolean; //ThanhNT2 check co khoa hay khong voi cac slot ngu thu
		public var isQuartz:Boolean; //ThanhNT2 check co linh thach hay khong voi cac slot ngu thu
		
		public var _enable:Boolean;
 
		public function Container(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "Container";
		}
		
		public function setGUITooltip(guiTip:GUIToolTip):void 
		{
			if (guiTooltip == null)	guiTooltip = guiTip;
		}
		
		public function setTooltip(tip:TooltipFormat):void
		{
			tooltip = tip;
		}
		public function getTooltipText():String 
		{
			return tooltip.text;
		}
		public function setTooltipText(str:String):void
		{
			if(tooltip == null)
			{
				tooltip = new TooltipFormat();
			}
			tooltip.htmlText = str;
		}
		
		public function ClearLabel():void
		{
			var i:int;
			// all label
			for (i = 0; i < LabelArr.length; i++)
			{
				img.removeChild(LabelArr[i]);
			}
			LabelArr.splice(0, LabelArr.length);
		}
		
		public function ClearListBox():void
		{
			var i:int;
			// all listbox
			for (i = 0; i < ListboxArr.length; i++)
			{
				var list:ListBox = ListboxArr[i] as ListBox;
				list.destructor();
			}
			ListboxArr.splice(0, ListboxArr.length);
		}
		
		public function ClearScroll():void
		{
			var i:int;
			// all scroll
			for (i = 0; i < ScrollBarArr.length; i++)
			{
				var scroll:ScrollBar = ScrollBarArr[i] as ScrollBar;
				scroll.destructor();
			}
			ScrollBarArr.splice(0, ScrollBarArr.length);
		}
		
		public function ClearImageDigit():void
		{
			var i:int;
			// all scroll
			for (i = 0; i < ImageDigitArr.length; i++)
			{
				var digit:ImageDigit = ImageDigitArr[i] as ImageDigit;
				digit.Destructor();
			}
			ImageDigitArr.splice(0, ImageDigitArr.length);
		}
		public function RemoveImageDigit(id:String):void
		{
			var i:int;
			for (i = 0; i < ImageDigitArr.length; i++)
			{
				var digit:ImageDigit = ImageDigitArr[i] as ImageDigit;
				if (digit.ImageId == id)
				{
					digit.Destructor();
					break;
				}
			}
			ImageDigitArr.splice(i, 1);
		}
		/**
		 * xóa toàn bộ component trong container
		 */
		public function ClearComponent():void
		{
			if (Parent == null) 
			{
				return;
			}
			
			var i:int;
			// all label
			if (LabelArr)
			{
				for (i = 0; i < LabelArr.length; i++)
				{
					var _txt:TextField = LabelArr[i];
					//_txt.parent.removeChild(_txt);
					if(_txt.parent == img)
					{
						img.removeChild(LabelArr[i]);
					}
				}
				LabelArr.splice(0, LabelArr.length);
			}
			// all button
			if (ButtonArr)
			{
				for (i = 0; i < ButtonArr.length; i++)
				{
					var btn:Button = ButtonArr[i] as Button;
					btn.RemoveAllEvent();
					HelperMgr.getInstance().ClearHelper(btn.HelperName);
					img.removeChild(btn.img);
					btn.img = null;
				}
				ButtonArr.splice(0, ButtonArr.length);
			}
			// all buttonEx
			if (ButtonExArr)
			{
				for (i = 0; i < ButtonExArr.length; i++)
				{
					var btn1:ButtonEx = ButtonExArr[i] as ButtonEx;
					HelperMgr.getInstance().ClearHelper(btn1.HelperName);
					img.removeChild(btn1.img);
					btn1.Destructor();
				}
				ButtonExArr.splice(0, ButtonExArr.length);
			}
			// all progressbar
			if (ProgressArr)
			{
				for (i = 0; i < ProgressArr.length; i++)
				{
					var prg:ProgressBar = ProgressArr[i] as ProgressBar;
					prg.RemoveAllEvent();
					prg.removeChild(prg.img);
					img.removeChild(prg);
					prg.img = null;
				}
				ProgressArr.splice(0, ProgressArr.length);
			}
			// all textbox
			if (TextBoxArr)
			{
				for (i = 0; i < TextBoxArr.length; i++)
				{
					var txt:TextBox = TextBoxArr[i] as TextBox;
					txt.RemoveAllEvent();
					img.removeChild(txt.textField);
					txt.textField = null;
				}
				TextBoxArr.splice(0, TextBoxArr.length);
			}
		
			// all image
			if (ImageArr)
			{
				for (i = 0; i < ImageArr.length; i++)
				{
					var img1:Image = ImageArr[i] as Image;
					if(img1.img != null && img1.img.parent == img)
						img.removeChild(img1.img);
					img1.Destructor();
				}
				ImageArr.splice(0, ImageArr.length);
			}
			
			//all ImageDigit
			if (ImageDigitArr != null)
			{
				for (i = 0; i < ImageDigitArr.length; i++)
				{
					var imgDigit:ImageDigit = ImageDigitArr[i] as ImageDigit;
					imgDigit.Destructor();
				}
				ImageDigitArr.splice(0, ImageDigitArr.length);
			}
			// all listbox
			if (ListboxArr)
			{
				for (i = 0; i < ListboxArr.length; i++)
				{
					var list:ListBox = ListboxArr[i] as ListBox;				
					list.destructor();
				}
				ListboxArr.splice(0, ListboxArr.length);
			}
			// all scroll
			if (ScrollBarArr)
			{
				for (i = 0; i < ScrollBarArr.length; i++)
				{
					var scroll:ScrollBar = ScrollBarArr[i] as ScrollBar;
					scroll.destructor();
					scroll = null;
				}
				ScrollBarArr.splice(0, ScrollBarArr.length);
			}
			// All Combos
			if (ComboBoxArr)
			{
				for (i = 0; i < ComboBoxArr.length; i++)
				{
					var Combo:ComboBox = ComboBoxArr[i] as ComboBox;
					img.removeChild(Combo);
				}
				ComboBoxArr.splice(0, ComboBoxArr.length);
			}
			// all container
			if (ContainerArr)
			{
				for (i = 0; i < ContainerArr.length; i++)
				{
					var container:Container = ContainerArr[i] as Container;
					
					container.Destructor();
				}
				ContainerArr.splice(0, ContainerArr.length);
			}
			//Guitooltip
			if (guiTooltip && guiTooltip.IsVisible)
			{
				guiTooltip.Hide();
			}
		}
		
		/**
		 * cho phép hoặc ko cho phép nhận sự kiện chuột
		 */
		public function set enable(value:Boolean):void
		{
			if (!value)
			{
				_enable = false;
				
				var elements:Array =
				[0.33, 0.33, 0.33, 0, 0,
				0.33, 0.33, 0.33, 0, 0,
				0.33, 0.33, 0.33, 0, 0,
				0, 0, 0, 1, 0];
				
				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
				img.filters = [colorFilter];
				img.mouseEnabled = false;
				img.mouseChildren = false;
			}
			else
			{
				_enable = true;
				img.mouseEnabled = true;
				img.mouseChildren = true;
				img.filters = null;
			}
		}
		
		public function get enable():Boolean
		{
			return _enable;
		}
		
		public function Clear():void
		{
			ClearComponent();
			
			// remove ban than container
			if (img != null && img.parent != null)
			{
				var i:int;
				for (i = 0; i < img.numChildren; i++)
				{
					if (img.removeChildAt(0) != null)
					{
						i--;
					}
					else
					{
						i++;
					}
				}
				removeAllEvent();
				if (img.parent != null)
				{
					img.parent.removeChild(img);
				}
				img = null;
			}			
		}
		
		
		public override function Destructor():void
		{
			Clear();
			
			// xoa cac con tro khac
			DesPos = null;
			CurPos = null;
			SpeedVec = null;
			DragableArea = null;
			
			// cac array
			LabelArr = null;
			ButtonArr = null;
			ProgressArr = null;
			TextBoxArr = null;
			ContainerArr = null;
			ImageArr = null;
			ButtonExArr = null;
			ImageDigitArr = null;
			
			removeAllEvent();
			img = null;
		}
		
		protected virtual function OnDestructor():void
		{
			
		}
		 
	 

		/**
		 * Cho phép đối tượng có thể kéo thả
		 * @param dragArea phạm vi con trỏ chuột có thể kéo thả trên đối tượng
		 */
		public function SetDragable(dragArea:Rectangle):void
		{
			Dragable = true;
			if (img == null)
			{
				DragableArea = dragArea;
			}
			else
			{
				var tempRect:Rectangle = img.getBounds(img);
				DragableArea.left = dragArea.left + tempRect.left;
				DragableArea.right = dragArea.right + tempRect.left;
				DragableArea.top = dragArea.top  + tempRect.top;
				DragableArea.bottom = dragArea.bottom  + tempRect.top;
			}
		}
		
		/**
		 * cho đối tượng tự động di chuyển đến 1 điểm nào đó
		 * @param x tọa độ theo phương x
		 * @param y tọa độ theo phương y
		 * @param speed tốc độ di chuyển
		 */
		public function MoveTo(x:int, y:int, speed:int):void
		{
			IsMoving = true;
			DesPos.x = x;
			DesPos.y = y;
			SpeedVec = DesPos.subtract(new Point(this.img.x, this.img.y));
			SpeedVec.normalize(speed);
		}
		
		public function ShowScale():void
		{
			img.scaleX = 0.1;
			img.scaleY = 0.1;
		}
		
		/**
		 * Cái này được gọi thường xuyên trong vòng loop của main, để update các di chuyển
		 */
		public function UpdateObject():void
		{
			if (img == null)
			{
				return;
			}
			if (img.scaleX < 1)
			{
				img.scaleX += 0.2;
				
				if (img.scaleX > 1)
				{
					img.scaleX = 1;
				}
			}
			
			if (img.scaleY < 1)
			{
				img.scaleY += 0.2;
				
				if (img.scaleY > 1)
				{
					img.scaleY = 1;
				}
			}
			
			if (IsMoving)
			{
				var CurPos:Point = new Point(this.img.x, this.img.y);
				var temp:Point = CurPos.subtract(DesPos);
				if ( temp.length < SpeedVec.length)
				{
					IsMoving = false;
					OnFinishMoving();
					CurPos = DesPos;
					if (img != null)
					{
						this.img.x = CurPos.x;
						this.img.y = CurPos.y;
					}
					return;
				}
					
				CurPos = CurPos.add(SpeedVec);
				this.img.x = CurPos.x;
				this.img.y = CurPos.y;
			}			
		}
		
		public virtual function OnFinishMoving():void
		{
			
		}
		
		
		public override function OnLoadRes():void
		{
			addAllEvent();
		}
		
		
		public override function OnBeforeReloadRes():void
		{
			removeAllEvent();
		}
		
		
		public override function OnReloadRes():void
		{
			addAllEvent();
			ReloadContainer();
		}
		
		public function ReloadContainer():void
		{
			var i:int;
			// all button
			for (i = 0; i < ButtonArr.length; i++)
			{
				var btn:Button = ButtonArr[i] as Button;
				//try{
					img.addChild(btn.img);
				//}catch (err:Error){
					//GameLogic.getInstance().CatchErr(err);
				//}
			}
			// all buttonEx
			for (i = 0; i < ButtonExArr.length; i++)
			{
				var btn1:ButtonEx = ButtonExArr[i] as ButtonEx;
				btn1.Parent = this.img;
				try {
					img.addChild(btn1.img);
				}catch (err:Error){
					GameLogic.getInstance().CatchErr(err);
				}
			}
			
			// all progressbar
			for (i = 0; i < ProgressArr.length; i++)
			{
				var prg:ProgressBar = ProgressArr[i] as ProgressBar;
				//try {
					//img.addChild(prg.img);
					img.addChild(prg);
				//}catch (err:Error){
					//GameLogic.getInstance().CatchErr(err);
				//}
			}
			
			// all textbox
			for (i = 0; i < TextBoxArr.length; i++)
			{
				var txt:TextBox = TextBoxArr[i] as TextBox;
				//try{				
					img.addChild(txt.textField);
				//}catch (err:Error){
					//GameLogic.getInstance().CatchErr(err);
				//}
			}
			
			// all image
			for (i = 0; i < ImageArr.length; i++)
			{
				var image:Image = ImageArr[i] as Image;
				image.Parent = this.img;
				//try {
					img.addChild(image.img);
				//}catch (err:Error){
					//GameLogic.getInstance().CatchErr(err);
				//}
			}
			
			// all label
			for (i = 0; i < LabelArr.length; i++)
			{
				var lbl:TextField = LabelArr[i] as TextField;
				try {
					img.addChild(lbl);
				}catch (err:Error){
					GameLogic.getInstance().CatchErr(err);
				}
			}

			// all container
			for (i = 0; i < ContainerArr.length; i++)
			{
				var container:Container = ContainerArr[i] as Container;
				container.Parent = this.img;
				container.ReloadContainer();
				//try {
					img.addChild(container.img);
				//}catch (err:Error){
					//GameLogic.getInstance().CatchErr(err);
				//}
			}
			// all ImageDigit
			for (i = 0; i < ImageDigitArr.length; i++)
			{
				var imgDigit:ImageDigit = ImageDigitArr[i] as ImageDigit;
				img.addChild(imgDigit.img);
			}
			// All combobox
			for (i = 0; i < ComboBoxArr.length; i++)
			{
				var Combo:ComboBox = ComboBoxArr[i] as ComboBox;
		
				img.addChild(Combo);
			}
		}
		
		
		public function addAllEvent():void
		{
			if (img == null)
				return;
				
			img.mouseChildren = true;
			img.mouseEnabled = true;

			//event cho img
			img.addEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			img.addEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			img.addEventListener(MouseEvent.CLICK, OnContainerClick);
			//img.addEventListener(MouseEvent.MOUSE_MOVE, OnButtonMouseOver);
			img.addEventListener(MouseEvent.ROLL_OVER, OnButtonMouseOver);
			img.addEventListener(MouseEvent.ROLL_OUT, OnButtonMouseOut);
			img.addEventListener(MouseEvent.MOUSE_WHEEL, OnButtonMouseWheel);
		}
		
		
		public function removeAllEvent():void
		{
			if (img == null)
				return;
			
			img.mouseChildren = false;
			img.mouseEnabled = false;

			//event cho img
			img.removeEventListener(MouseEvent.MOUSE_DOWN, OnMouseDown);
			img.removeEventListener(MouseEvent.MOUSE_UP, OnMouseUp);
			img.removeEventListener(MouseEvent.CLICK, OnContainerClick);
			img.removeEventListener(MouseEvent.ROLL_OVER, OnButtonMouseOver);
			img.removeEventListener(MouseEvent.ROLL_OUT, OnButtonMouseOut);
			img.removeEventListener(MouseEvent.MOUSE_WHEEL, OnButtonMouseWheel);
			ClearEvent();
		}
		 
		public virtual function OnButtonMouseWheel(e:MouseEvent):void 
		{
			if (EventHandler != null)
			{
				EventHandler.OnButtonWheel(e, IdObject);
			}
		}
		 
		 
		private function OnMouseDown(event:MouseEvent):void
		{
			if (Dragable)
			{
				if (event.target == img)
				{
					if (event.localX > DragableArea.left
						&& event.localX < DragableArea.right
						&& event.localY > DragableArea.top
						&& event.localY < DragableArea.bottom)
					{
						this.img.startDrag();
					}
				}
			}
			else
			{
				if (EventHandler != null)
				{
					EventHandler.OnButtonDown(event, IdObject);
				}
			}
		}
		 
		private function OnMouseUp(event:MouseEvent):void
		{
			if (Dragable)
			{
				this.img.stopDrag();
			}
			else
			{
				if (EventHandler != null)
				{
					EventHandler.OnButtonUp(event, IdObject);
				}
				else if ( this.ClassName == "GUIMainEventIceCream")
				{
					(this as GUIMainEventIceCream).ProcessChooseItemCreateCream();
				}
			}
		}	
		
	
		private function OnButtonMouseOver(event:MouseEvent):void
		{
			//if (TooltipText != null)
			//{
				//if (event.target == img)
				//{
					//Tooltip.getInstance().ShowNewToolTip(TooltipText, event.stageX, event.stageY);
				//}
			//}
			if (EventHandler != null)
			{
				EventHandler.OnButtonMove(event, IdObject);
			}
			
			if (tooltip != null)
			{
				ActiveTooltip.getInstance().showNewToolTip(tooltip, img);
			}
			
			if (guiTooltip != null)
			{
				guiTooltip.Show();
			}
		}
		
		private function OnButtonMouseOut(event:MouseEvent):void
		{
			//if (TooltipText != null)
			//{
				//Tooltip.getInstance().ClearTooltip();
			//}
			
			if (tooltip != null)
			{
				ActiveTooltip.getInstance().clearToolTip();
			}
			if (guiTooltip != null)
			{
				guiTooltip.Hide();
			}
			
			if (EventHandler != null)
			{
				EventHandler.OnButtonOut(event, IdObject);
			}
		}
		
		public function SetVisible(show:Boolean):void
		{
			img.visible = show;
		}
		
		//h:clear container
		public function VisibleContainer(ContainerID: String, visible:Boolean = false): void
		{			
			var i: int;
			for (i = 0; i < ContainerArr.length; i++ )
			{
				var container: Container = ContainerArr[i] as Container;
				if (container.IdObject == ContainerID)
				{
					//img.removeChild(container.img);
					container.img.visible = visible;
					//img.visible = false;
					//ContainerArr.splice(i, 1);
				}
				
			}			
		}
		/////////////////////////////////////////////////////////////	
		

		/**
		 * add 1 cái listbox
		 * @param	type kiểu listbox (LIST_X: list theo chiều ngang, LIST_Y:list theo chiều dọc)
		 * @param	nRow số hàng hiển thị trong 1 trang
		 * @param	nCol số cột hiển thị trong 1 trang
		 * @param	dx khoảng cách giữa x các item
		 * @param	dy khoảng cách giữa y các item
		 * @return
		 */
		public function AddListBox(type:int, numRow:int, numCol:int, dx:int = 10, dy:int = 10, wheeling:Boolean = false):ListBox
		{
			var lst:ListBox = new ListBox(type, numRow, numCol, dx, dy, wheeling);
			img.addChild(lst);
			ListboxArr.push(lst);
			return lst;
		}

		/**
		 * add 1 cái ScrollBar
		 * @param	type kiểu listbox (LIST_X: list theo chiều ngang, LIST_Y:list theo chiều dọc)
		 * @param	nRow số hàng hiển thị trong 1 trang
		 * @param	nCol số cột hiển thị trong 1 trang
		 * @param	dx khoảng cách giữa x các item
		 * @param	dy khoảng cách giữa y các item
		 * @return
		 */
		public function AddScroll(id:String, imgName:String, x:int, y:int, eventHandler:Container = null):ScrollBar
		{
			var scroll:ScrollBar = new ScrollBar(ResMgr.getInstance().GetRes(imgName) as Sprite);
			scroll.img.x = x;
			scroll.img.y = y;
			scroll.id = id;
			if (eventHandler == null)
			{
				scroll.EventHandler = this;
			}
			else
			{
				scroll.EventHandler = eventHandler;
			}
			ScrollBarArr.push(scroll);			
			img.addChild(scroll.img);
			return scroll;
		}

		
		/**
		 * thêm 1 cái label vào
		 * @param st chữ hiển thị trên label
		 * @param x tọa độ x tương đối trên container
		 * @param y tọa độ y tương đối trên container
		 * @return con trỏ đển label vừa tạo ra
		 */
		public function AddLabel(st:String, x:int, y:int, color:int = 0x000000, align:int = 1, IsOutline:int = -1):TextField
		{
			var txt:TextField = new TextField();
			txt.x = x;
			txt.y = y;			
			txt.text = st;
			switch(align)
			{
				case 0:
					txt.autoSize = TextFieldAutoSize.LEFT;
					break;
				case 1:
					txt.autoSize = TextFieldAutoSize.CENTER;
					break;
				case 2:
					txt.autoSize = TextFieldAutoSize.RIGHT;
					break;				
				default:
					txt.autoSize = TextFieldAutoSize.NONE;
					break;
			}
			txt.mouseEnabled = false;
			var txtFormat:TextFormat = new TextFormat();
			txtFormat.color = color;
			txtFormat.font = "Arial";
			txtFormat.bold = true;
			txt.setTextFormat(txtFormat);
			txt.defaultTextFormat = txtFormat;
			
			if (IsOutline >= 0)
			{
				var outline:GlowFilter = new GlowFilter();
				outline.blurX = outline.blurY = 3.5;
				outline.strength = 8;
				outline.color = IsOutline;
				var arr:Array = [];
				arr.push(outline);
				txt.antiAliasType = AntiAliasType.ADVANCED;
				txt.filters = arr;
			}
			LabelArr.push(txt);
			img.addChild(txt);
			
			return txt;
		}
		
		
		/**
		 * thêm 1 cái image vào
		 * @param objID id duy nhất của image trên GUI
		 * @param imgName ảnh đại diện
		 * @param x tọa độ x tương đối trên container
		 * @param y tọa độ y tương đối trên container
		 * @param SetInfo con trỏ hàm trỏ đến 1 hàm dùng để thay đổi thuộc tính của ảnh: màu sắc, kích thước...Được gọi khi loadRes và reloadRes
		 * @return con trỏ đển image vừa tạo ra
		 */
		public function AddImage(objID:String, imgName:String, x:int, y:int, isLinkAge:Boolean = true, imgAlign:String = ALIGN_CENTER_CENTER, toBitmap:Boolean = false, SetInfo:Function = null):Image
		{
			var image:Image = new Image(img, imgName, x, y, isLinkAge, imgAlign, toBitmap, SetInfo, objID);
			ImageArr.push(image);
			return image;
		}
		
		public function AddImageBySprite(spr:Sprite, x:int, y:int, objID:String = ""):Image
		{
			var image:Image = new Image(img, "", x, y);
			image.ImageId = objID;
			img.addChild(spr);
			image.img = spr;
			spr.x = x;
			spr.y = y;
			ImageArr.push(image);
			return image;
		}
	
		public function AddImageDigit(objID:String, num:int, x:int = 0, y:int = 0,
										guiName:String = "",
										family:String = "",
										isLinkAge:Boolean = true,
										imgAlign:String = ALIGN_CENTER_CENTER, 
										toBitmap:Boolean = false, 
										SetInfo:Function = null):ImageDigit
		{
			var imgDigit:ImageDigit = new ImageDigit(img, "KhungFriend", x, y, isLinkAge, imgAlign, toBitmap, SetInfo, objID);
			imgDigit.number = num;
			imgDigit.family = family;
			imgDigit.parentGui = guiName;
			imgDigit.changeNumberToImage();
			ImageDigitArr.push(imgDigit);
			return imgDigit;
		}
		public function AddBimap(bmp:Bitmap, x:int, y:int):void
		{
			img.addChild(bmp);
			bmp.x = x;
			bmp.y = y;
		}
		
		/**
		 * thêm 1 cái textbox vào
		 * @param textboxID ID duy nhất của đối tượng trên GUI
		 * @param text text mặc định xuất hiện trên textbox
		 * @param x tọa độ x tương đối trên container
		 * @param y tọa độ y tương đối trên container
		 * @param width chiều rộng của textbox
		 * @param height chiều cao của textbox
		 * @return con trỏ đển TextBox vừa tạo ra
		 */
		public function AddTextBox(textboxID:String, text:String, x:int, y:int, width:int, height:int, eventHandler:Container = null):TextBox
		{
			var txt:TextBox = new TextBox(textboxID, x, y, width, height);
			txt.SetText(text);
			txt.MyParent = eventHandler;
			TextBoxArr.push(txt);
			img.addChild(txt.textField);
			return txt;
		}
		
		/**
		 * 
		 * @param	prgID ID duy nhất của đối tượng trên GUI
		 * @param	imgName tên cái ảnh đại diện cho đối tượng
		 * @param 	x tọa độ x tương đối trên container
		 * @param 	y tọa độ y tương đối trên container
		 * @return	con trỏ đển ProgressBar vừa tạo ra
		 */
		public function AddProgress(prgID:String, imgName:String, x:int, y:int, eventHandler:Container = null, haveBg:Boolean = false, IsCircle:Boolean = false):ProgressBar
		{
			var prg:ProgressBar = new ProgressBar(prgID, imgName, x, y, haveBg, IsCircle);
			ProgressArr.push(prg);
			if (eventHandler != null)
			{
				prg.EventHandler = eventHandler;
			}
			
			//try {				
				//img.addChild(prg.img);
				img.addChild(prg);
			//}catch (err:Error){
				//GameLogic.getInstance().CatchErr(err);
			//}
			return prg;
		}
		
		
		/**
		 * thêm 1 cái Button vào
		 * @param btnID ID duy nhất của đối tượng trên GUI
		 * @param imgName tên cái ảnh đại diện cho đối tượng
		 * @param x tọa độ x tương đối trên container
		 * @param y tọa độ y tương đối trên container
		 * @param eventHandler đối tượng xử lý sự kiện do cái button này sinh ra (thường là GUI)
		 * @return con trỏ đển Button vừa tạo ra
		 */
		public function AddButton(btnID:String, imgName:String, x:int, y:int, eventHandler:Container = null, HelperName:String = ""):Button
		{
			var btn:Button = new Button(btnID, ResMgr.getInstance().GetRes(imgName) as SimpleButton , x, y);
			
			//btn = (ResMgr.getInstance().getRes(imgName) as  SimpleButton) as Button;
			ButtonArr.push(btn);
			if (eventHandler == null)
			{
				btn.EventHandler = this;
			}
			else
			{
				btn.EventHandler = eventHandler;
			}
			btn.HelperName = HelperName;
			if (HelperName != "")
			{
				HelperMgr.getInstance().SetHelperData(HelperName, btn.img);
			}
			img.addChild(btn.img);
			return btn;
		}
		
		// Add a combobox into this form
		public function AddCombobox():ComboBox
		{
			var Combo:ComboBox = new ComboBox();
			
			ComboBoxArr.push(Combo);
			img.addChild(Combo);
			
			return Combo;
		}
		
		/**
		 * thêm 1 cái Button vào
		 * @param btnID ID duy nhất của đối tượng trên GUI
		 * @param imgName tên cái ảnh đại diện cho đối tượng
		 * @param x tọa độ x tương đối trên container
		 * @param y tọa độ y tương đối trên container
		 * @param eventHandler đối tượng xử lý sự kiện do cái button này sinh ra (thường là GUI)
		 * @return con trỏ đển Button vừa tạo ra
		 */
		public function AddButtonEx(btnID:String, imgName:String, x:int, y:int, eventHandler:Container = null, HelperName:String = ""):ButtonEx
		{
			var btn:ButtonEx = new ButtonEx(img, imgName, x , y);
			btn.SetBtnInfo(btnID);
			
			//btn = (ResMgr.getInstance().getRes(imgName) as  SimpleButton) as Button;
			ButtonExArr.push(btn);
			if (eventHandler == null)
			{
				btn.EventHandler = this;
			}
			else
			{
				btn.EventHandler = eventHandler;
			}
			btn.HelperName = HelperName;
			if (HelperName != "")
			{
				HelperMgr.getInstance().SetHelperData(HelperName, btn.img);
			}
	
			return btn;
		}
		
		/**
		 * thêm 1 cái Container vào
		 * @param containerID ID duy nhất của đối tượng trên GUI
		 * @param imgName tên cái ảnh đại diện cho đối tượng
		 * @param x tọa độ x tương đối trên container
		 * @param y tọa độ y tương đối trên container
		 * @param eventHandler đối tượng xử lý sự kiện do cái button này sinh ra (thường là GUI)
		 * @return con trỏ đển Container vừa tạo ra
		 */
		public function AddContainer(containerID:String, imgName:String, x:int, y:int, isLinkAge:Boolean = true, eventHandler:Container = null, HelperName:String = ""):Container
		{
			var container:Container = new Container(img, imgName, x, y, isLinkAge);
			container.IdObject = containerID;
			
			ContainerArr.push(container);
			
			if (eventHandler == null)
			{
				//container.EventHandler = this;
			}
			else
			{
				container.EventHandler = eventHandler;
			}
			
			container.setHelper(HelperName);
			return container;
		}
		
		public function setHelper(HelperName:String):void
		{
			this.HelperName = HelperName;
			if (HelperName != "")
			{
				HelperMgr.getInstance().SetHelperData(HelperName, this.img);
			}
		}
		
		public function hideHelper():void 
		{
			if (this.HelperName != "")
			{
				HelperMgr.getInstance().HideHelper();
			}
		}
		
		public function GetContainer(id:String):Container
		{
			for (var i:int = 0; i < ContainerArr.length; i++)
			{
				var container:Container = ContainerArr[i] as Container;
				if (container.IdObject == id)
				{
					return ContainerArr[i] as Container;
				}
			}
			return null;
		}
		public function GetListBox(id:String):ListBox
		{
			for (var i:int = 0; i < ListboxArr.length; i++)
			{
				var listBox:ListBox = ListboxArr[i] as ListBox;
				if (listBox.IdObject == id)
				{
					return ListboxArr[i] as ListBox;
				}
			}
			return null;
		}
		public function GetTextBox(id:String):TextBox
		{
			for (var i:int = 0; i < TextBoxArr.length; i++)
			{
				var textBox:TextBox = TextBoxArr[i] as TextBox;
				if (textBox.TextBoxID == id)
				{
					return TextBoxArr[i] as TextBox;
				}
			}
			
			return null;
		}
		public function AddContainer2(container:Container, x:int, y:int, eventHandler:Container = null):Container
		{
			ContainerArr.push(container);
			container.SetPos(x, y);
			
			if (eventHandler == null)
			{
				//container.EventHandler = this;
			}
			else
			{
				container.EventHandler = eventHandler;
			}
			return container;
		}
		
		public function GetPosition():Point
		{
			return new Point(img.x, img.y);
		}
		
		public function GetImage(id:String):Image
		{
			for (var i:int = 0; ImageArr && i < ImageArr.length; i++)
			{
				var image:Image = ImageArr[i] as Image;
				if (image.ImageId == id)
				{
					return ImageArr[i] as Image;
				}
			}			
			return null;
		}
		
		public function GetProgress(id:String):ProgressBar
		{
			for (var i:int = 0;ProgressArr && i < ProgressArr.length; i++)
			{
				var prg:ProgressBar = ProgressArr[i] as ProgressBar;
				if (prg.PrgID == id)
				{
					return ProgressArr[i] as ProgressBar;
				}
			}
			
			return null;
		}
		
		public function GetButton(id:String):Button
		{
			for (var i:int = 0; ButtonArr && i < ButtonArr.length; i++)
			{
				var btn:Button = ButtonArr[i] as Button;
				if (btn.ButtonID == id)
				{
					return ButtonArr[i] as Button;
				}
			}
			
			return null;
		}
		
		public function GetButtonEx(id:String):ButtonEx
		{
			for (var i:int = 0; ButtonExArr && i < ButtonExArr.length; i++)
			{
				var btn:ButtonEx = ButtonExArr[i] as ButtonEx;
				if (btn.ButtonID == id)
				{
					return ButtonExArr[i] as ButtonEx;
				}
			}
			
			return null;
		}
		
		public function GetScrollBar(id:String):ScrollBar
		{
			for (var i:int = 0; ScrollBarArr && i < ScrollBarArr.length; i++)
			{
				var scroll:ScrollBar = ScrollBarArr[i] as ScrollBar;
				if (scroll.id == id)
				{
					return ScrollBarArr[i] as ScrollBar;
				}
			}
			
			return null;
		}		
		
		public function RemoveButton(id:String):void
		{
			for (var i:int = 0; i < ButtonArr.length; i++)
			{
				var btn:Button = ButtonArr[i] as Button;
				if (btn.ButtonID == id)
				{
					btn.RemoveAllEvent();
					HelperMgr.getInstance().ClearHelper(btn.HelperName);
					img.removeChild(btn.img);
					btn.img = null;
					ButtonArr.splice(i, 1);
					break;
				}
			}
		}
		
		public function RemoveProgressBar(id:String):void
		{
			for (var i:int = 0; i < ProgressArr.length; i++)
			{
				var prg:ProgressBar = ProgressArr[i] as ProgressBar;
				if (prg.PrgID == id)
				{
					prg.RemoveAllEvent();
					img.removeChild(prg);
					prg.img = null;
					ProgressArr.splice(i, 1);
					break;
				}
			}
		}
		
		public function RemoveAllProgressBar():void
		{
			for (var i:int = 0; i < ProgressArr.length; i++)
			{
				var prg:ProgressBar = ProgressArr[i] as ProgressBar;
				prg.RemoveAllEvent();
				img.removeChild(prg);
				prg.img = null;
				ProgressArr.splice(i, 1);
				i--;
			}
		}
		
		public function RemoveButtonEx(id:String):void
		{
			for (var i:int = 0; i < ButtonExArr.length; i++)
			{
				var btn:ButtonEx = ButtonExArr[i] as ButtonEx;
				if (btn.ButtonID == id && btn.img != null && btn.img.parent == img)
				{
					HelperMgr.getInstance().ClearHelper(btn.HelperName);
					img.removeChild(btn.img);
					ButtonExArr.splice(i, 1);
					break;
				}
			}
		}
		
		public function RemoveContainer(id:String):void
		{
			for (var i:int = 0; i < ContainerArr.length; i++)
			{
				var btn:Container = ContainerArr[i] as Container;
				if (btn.IdObject == id)
				{
					if(btn.img)
					{
						img.removeChild(btn.img);
					}
					ContainerArr.splice(i, 1);
					break;
				}
			}
		}
		
		public function RemoveAllContainer():void
		{
			for (var i:int = 0; i < ContainerArr.length; i++)
			{
				var btn:Container = ContainerArr[i] as Container;
				if (btn)
				{
					img.removeChild(btn.img);
				}
			}
			ContainerArr = [];
		}
		
		/**
		 * Ham set highlight cho container
		 * @param	color		mau se highlight
		 * @param	turnBack	tro ve mau highlight cu truoc khi set
		 * @param	enable		co enable cai container nay ko
		 * @param	strength	cuong do cua highlight
		 */
		public function SetHighLight(color:Number = 0x00FF00, turnBack:Boolean = false, enable:Boolean = true, strength:int = 8):void
		{
			if (img == null)
			{
				return;
			}
			
			//Làm cho contaier chuyển sang màu xám
			var filterArr:Array = [];	
			if (!enable)
			{
				_enable = false;
			
				var elements:Array =
				[0.33, 0.33, 0.33, 0, 0,
				0.33, 0.33, 0.33, 0, 0,
				0.33, 0.33, 0.33, 0, 0,
				0, 0, 0, 1, 0];
				
				var colorFilter:ColorMatrixFilter = new ColorMatrixFilter(elements);
				filterArr.push(colorFilter);
			}
			
			var glow:GlowFilter;
			if (color < 0)
			{
				if (turnBack && OldColorHightLight >0)
				{
					glow = new GlowFilter(OldColorHightLight, 1, 8, 8, strength);
					filterArr.push(glow);
				}
				else
				{
					img.filters = null;
				}
			}
			else	// color >= 0
			{
				//Nếu ko quay về màu cũ thì cứ lưu màu hiện tại lại để phục vụ cho lần gọi turnback sau
				if (!turnBack)
				{
					OldColorHightLight = color;				
				}
				
				glow = new GlowFilter(color, 1, 8, 8, 8);
				filterArr.push(glow);
			}
			
			img.filters = filterArr;
		}
		
		public function RemoveImage(image:Image):void
		{
			if (ImageArr)
			{
				var vt:int = ImageArr.indexOf(image);
				if (vt >= 0)
				{
					image.ClearEvent();
					if (image.img != null)
					{
						img.removeChild(image.img);
						image.ClearEvent();
						image.img = null;
					}
					ImageArr.splice(vt, 1);
				}
			}
		}
		
		public function RemoveAllImage():void
		{
			var i:int;
			// all image
			if (ImageArr)
			{
				for (i = 0; i < ImageArr.length; i++)
				{
					var MyImg:Image = ImageArr[i] as Image;				
					img.removeChild(MyImg.img);
					MyImg.ClearEvent();
					MyImg.img = null;
					
				}
				ImageArr.splice(0, ImageArr.length);
			}
		}
		
		public function RemoveAllButtonEx():void
		{
			var i:int;
			// all buttonEx
			if (ButtonExArr)
			{
				for (i = 0; i < ButtonExArr.length; i++)
				{
					var btn1:ButtonEx = ButtonExArr[i] as ButtonEx;
					HelperMgr.getInstance().ClearHelper(btn1.HelperName);
					btn1.removeAllEvent();
					img.removeChild(btn1.img);
					btn1.img = null;
					
				}
				ButtonExArr.splice(0, ButtonExArr.length);
			}
		}
		
		public virtual function OnButtonClick(event:MouseEvent, buttonID:String):void
		{
			if (ClassName == "Container")
			{
				//MyParent.o
			}
		}
		
		public virtual function OnButtonUp(event:MouseEvent, buttonID:String):void
		{
		}
		
		
		public virtual function OnButtonDown(event:MouseEvent, buttonID:String):void
		{
		}
		
		public virtual function OnButtonWheel(event:MouseEvent, buttonID:String):void
		{
		}
		
		
		public virtual function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (ClassName == "Container")
			{
				//MyParent.o
			}
		}
		
		
		public virtual function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
		}
		
		public virtual function OnTextboxKeyUp(event:KeyboardEvent, txtID:String):void
		{
			
		}
		
		public virtual function OnTextboxChange(event:Event, txtID:String):void
		{
			
		}
		
		public virtual function OnScrollBarChange(id:String, value:Number):void
		{
			
		}
		
		private function OnContainerClick(event:MouseEvent):void
		{
			if (EventHandler == null)
			{
				OnMouseClick(event);
				return;
			}
			if (event.currentTarget == img)
			{
				EventHandler.OnButtonClick(event, IdObject);
			}
		}
		
		public virtual function OnMouseClick(event:MouseEvent):void
		{
			
		}
		
		public virtual function onClickTreeNode(childNode:TreeNode):void
		{
			
		}
		public virtual function onComboboxChange(event:Event, comboboxId:String):void
		{
			
		}
		
	}

}