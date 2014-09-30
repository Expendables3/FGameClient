package GUI.ChampionLeague.GuiLeague.itemGui 
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.ChampionLeague.LogicLeague.Player;
	import GUI.component.Container;
	import GUI.component.Image;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class ItemPlayerTop extends Container 
	{
		private var _player:Player;
		
		private var imgRank:Image;
		private var imgCup:Image;
		private var imgAvatar:Image;
		private var tfName:TextField;
		//static private var index:int = 0;
		public function ItemPlayerTop(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "ItemPlayerTop";
		}
		
		public function drawItem():void
		{
			imgRank = AddImage("", "GuiTopLeague_ImgNum" + _player.Rank, 0, 0);
			imgRank.FitRect(40, 40, new Point(15, 15));
			var setAvatarInfo:Function = function loadAvatarComplete():void
			{
				this.SetSize(50, 50);
				this.SetPos(76, 7);
			}
			imgAvatar = AddImage("", _player.Avatar, 70, 3, false, ALIGN_LEFT_TOP, false, setAvatarInfo);
			if (_player.Rank == 1) 
			{
				imgCup = AddImage("", "GuiTopLeague_ImgCup", 250, 33);
			}
			//index++;
			var name:String = _player.Name;
			if (name.length > 15)
			{
				name = name.substr(0, 15) + "...";
			}
			tfName = AddLabel(name, 123, 24, 0xffffff, 1, 0x000000);
			//tfName = AddLabel(_player.Id.toString(), 123, 24, 0xffffff, 1, 0x000000);
			//tfName = AddLabel("Player " + index, 123, 24, 0xffffff, 1, 0x000000);
			var format:TextFormat = new TextFormat("arial", 12);
			tfName.setTextFormat(format);
		}

		
		public function set player(value:Player):void 
		{
			_player = value;
			IdObject = "ItemPlayerTop_" + _player.Rank;
			drawItem();
		}
	}

}













