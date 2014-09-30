package GUI.ChampionLeague.GuiLeague 
{
	import GUI.ChampionLeague.GuiLeague.itemGui.ItemRock;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.component.BaseGUI;
	import GUI.GUINoneAbstract.GUINoneAbstract;
	
	/**
	 * GUI chứa các hộp quà show ra để cho người chơi biết khi đến top này sẽ nhận được cái đó
	 * @author HiepNM2
	 */
	public class GUIGiftLeague extends GUINoneAbstract 
	{
		// logic
		private var _rank:int;
		private var loaded:Boolean = false;
		// gui
		private var _listRock:Array = [];		//danh sách các tảng đá
		public function GUIGiftLeague(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIGiftLeague";
			ShiftFromInitGui = true;
			_xScr = _xDes = 0;
			_yScr = 170;
			_yDes = 0;
			_xGui = 170;
			_yGui = 475;
			_wMask = 550;
			_hMask = 150;
			_themeName = "GuiLeague_GUIGiftTheme";
			_bgName = "GuiLeague_GUIGiftTheme";
		}
		override protected function onInitGui():void 
		{
			_rank = LeagueMgr.getInstance().MyPlayer.Rank;
			drawRock();
		}
		
		/**
		 * vẽ ra các hòn đá
		 */
		private function drawRock():void 
		{
			var x:int = 0, y:int = 55;
			var k:int = 1;
			_listRock.splice(0, _listRock.length);
			var TopArrHere:Array = LeagueMgr.getInstance().getListTopGift(_rank);
			var handler:BaseGUI = this;
			var itemRock1:ItemRock = new ItemRock(ctnBg.img, "");
			itemRock1.typeRock = 1;
			itemRock1.setImgInfo = function():void {
				this.SetPos(0, 55);
				this.EventHandler = handler;
				this.Top = TopArrHere[3];
				//_listRock.push(this);
			}
			itemRock1.LoadRes("GuiLeague_ImgStone1");
			
			var itemRock2:ItemRock = new ItemRock(ctnBg.img, "");
			itemRock2.typeRock = 2;
			itemRock2.setImgInfo = function():void {
				this.SetPos(93, 69);
				this.EventHandler = handler;
				this.Top = TopArrHere[2];
			}
			itemRock2.LoadRes("GuiLeague_ImgStone2");
			
			var itemRock3:ItemRock = new ItemRock(ctnBg.img, "");
			itemRock3.typeRock = 3;
			itemRock3.setImgInfo = function():void {
				this.SetPos(196, 55);
				this.EventHandler = handler;
				this.Top = TopArrHere[1];
			}
			itemRock3.LoadRes("GuiLeague_ImgStone3");
			
			var itemRock4:ItemRock = new ItemRock(ctnBg.img, "");
			itemRock4.typeRock = 4;
			itemRock4.setImgInfo = function():void {
				this.SetPos(300, 69);
				this.EventHandler = handler;
				this.Top = TopArrHere[0];
				loaded = true;
			}
			itemRock4.LoadRes("GuiLeague_ImgStone4");
			_listRock.push(itemRock4);
			_listRock.push(itemRock3);
			_listRock.push(itemRock2);
			_listRock.push(itemRock1);
		}
		
		/**
		 * xoa cac component cua gui
		 */
		override public function ClearComponent():void 
		{
			for (var i:int = 0; i < _listRock.length; i++)
			{
				var itemGift:ItemRock = _listRock[i] as ItemRock;
				itemGift.Destructor();
			}
			_listRock.splice(0, _listRock.length);
			
			super.ClearComponent();
		}
		override public function OnHideGUI():void 
		{
			loaded = false;
		}
		public function updateGui():void
		{
			if (loaded)
			{
				for (var i:int = 0; i < _listRock.length; i++)
				{
					var itemRock:ItemRock = _listRock[i] as ItemRock;
					itemRock.updateRock();
				}
			}
			
		}
	}

}