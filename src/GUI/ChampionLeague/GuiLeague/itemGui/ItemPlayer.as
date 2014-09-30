package GUI.ChampionLeague.GuiLeague.itemGui 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.ChampionLeague.LogicLeague.LeagueMgr;
	import GUI.ChampionLeague.LogicLeague.Player;
	import GUI.component.Button;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ImageDigit;
	import Logic.Ultility;
	
	/**
	 * item chứa thông tin các người chơi
	 * @author HiepNM2
	 */
	public class ItemPlayer extends Container 
	{
		private const WAIT_MODE:int = 1;
		private const ATTACK_MODE:int = 0;
		public var Mode:int = 0;
		static public const CMD_FIGHT_CARD:String = "cmdFightCard";
		private var _player:Player;
		
		private var btnBackgound:Button;
		private var imgRank:ImageDigit;
		private var imgAvatar:Image;
		private var tfName:TextField;
		private var btnCard:Button;
		private var imgFlag:Image;
		private var tfCoolDown:TextField;
		//static private var index:int = 0;
		public function ItemPlayer(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "ItemPlayer";
		}
		public function initData(player:Player):void 
		{
			_player = player;
			IdObject = "ItemPlayer_"+ _player.Id;
		}
		
		public function drawItem():void 
		{
			//backround
			//imgBackgound = AddImage("abc", "GuiLeague_ItmPlayerSelect", 0, 0);
			btnBackgound = AddButton(CMD_FIGHT_CARD + "_" + _player.Rank, "GuiLeague_BtnPlayer1", 0, 0, EventHandler);
			//vẽ rank
			//tfRank = AddLabel(Ultility.StandardNumber(_player.Rank), -3, 41, 0xFFFF00, 1, 0x000000);
			//var format:TextFormat = new TextFormat("arial", 18);
			//tfRank.setTextFormat(format);
			//tfRank.mouseEnabled = false;
			imgRank = AddImageDigit("", _player.Rank, 47, 49, "GuiLeague", "Champion");
			imgRank.img.mouseEnabled = false;				
			imgRank.SetAlign(ALIGN_CENTER_CENTER);
			imgRank.img.mouseChildren = false;
			//vẽ avatar
			var setAvatarInfo:Function = function loadAvatarComplete():void
			{
				this.SetSize(50, 50);
				this.SetPos(78, 20);
				this.img.mouseEnabled = false;
			}
			imgAvatar = AddImage("", _player.Avatar, 55, 4, false, ALIGN_LEFT_TOP, false, setAvatarInfo);
			var name:String;
			name = _player.Name;
			if (name.length > 15)
			{
				name = name.substr(0, 15) + "...";
			}
			//index++;
			// vẽ tên
			//tfName = AddLabel(_player.Id.toString(), 131, 53, 0xffffff, 1, 0x000000);
			tfName = AddLabel(name, 131, 53, 0xffffff, 1, 0x000000);
			//tfName = AddLabel("Player " + index, 131, 53, 0xffffff, 1, 0x000000);
			tfName.mouseEnabled = false;
			// vẽ nút ngư lệnh
			if (_player.IsMe())
			{
				//imgBackgound.LoadRes("GuiLeague_CtnMe");
				imgFlag = AddImage("", "GuiLeague_ImgFlag", 250, 45);
				imgFlag.img.mouseEnabled = false;
			}
			else {
				btnCard = AddButton(CMD_FIGHT_CARD + "_" + _player.Rank, "GuiLeague_BtnFight1", 223, 28, EventHandler);
				tfCoolDown = AddLabel("-- : --", 187, 33, 0xffffff, 1, 0x000000);
				var isCoolDown:Boolean = LeagueMgr.getInstance().IsCoolDown;
				if (isCoolDown) {
					btnCard.SetVisible(false);
				}
				else {
					tfCoolDown.visible = false;
				}
			}
		}
		/**
		 * Thực hiện cập nhật nếu có cooldown
		 */
		public function UpdateItem(remainTime:int):void 
		{
			if (!_player.IsMe())
			{
				var mm:int = remainTime / 60;
				var sm:String = mm < 10 ? "0" + mm : mm.toString();
				var dm:int = remainTime % 60;
				var ss:String = dm < 10 ? "0" + dm : dm.toString();
				
				var strTime:String = sm + " : " +ss;
				tfCoolDown.text = strTime;
			}
			
		}
		
		public function changeToAttackMode():void 
		{
			if (!_player.IsMe())
			{
				btnCard.SetVisible(true);
				tfCoolDown.visible = false;
			}
		}
		
		public function changeToWaitMode():void
		{
			if (!_player.IsMe())
			{
				btnCard.SetVisible(false);
				tfCoolDown.visible = true;
			}
		}
		
		override public function Destructor():void 
		{
			super.Destructor();
			_player = null;
			tfName = null;
			imgRank = null;
			imgFlag = null;
			btnBackgound = null;
			btnCard = null;
			tfCoolDown = null;
			imgAvatar = null;
		}
		
	}
}













