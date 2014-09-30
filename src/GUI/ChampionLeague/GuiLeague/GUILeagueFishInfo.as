package GUI.ChampionLeague.GuiLeague 
{
	import flash.text.TextField;
	import GUI.component.BaseGUI;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUILeagueFishInfo extends BaseGUI 
	{
		private var _damage:int;
		private var _defence:int;
		private var _critical:int;
		private var _vitality:int;
		private var _isMe:Boolean;
		
		private var tfDamage:TextField;
		private var tfDefence:TextField;
		private var tfCritical:TextField;
		private var tfVitality:TextField;
		
		public function GUILeagueFishInfo(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUILeagueFishInfo";
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				var x:int, y:int;
				if (_isMe)
				{
					x = 50;
					y = 275;
				}
				else {
					x = 680;
					y = 240;
				}
				SetPos(x, y);
				addInfo();
			}
			LoadRes("GuiLeague_FishInfoTheme");
		}
		
		private function addInfo():void 
		{
			tfDamage = AddLabel("Công: " + _damage, 10, 05, 0xffffff, 0, 0x000000);
			tfDefence = AddLabel("Thủ: " + _defence, 10, 21, 0xffffff, 0, 0x000000);
			tfCritical = AddLabel("Chí: " + _critical, 10, 37, 0xffffff, 0, 0x000000);
			tfVitality = AddLabel("Máu: " + _vitality, 10, 53, 0xffffff, 0, 0x000000);
		}
		
		public function set damage(value:int):void 
		{
			_damage = value;
		}
		
		public function set defence(value:int):void 
		{
			_defence = value;
		}
		
		public function set critical(value:int):void 
		{
			_critical = value;
		}
		
		public function set vitality(value:int):void 
		{
			_vitality = value;
		}
		
		public function set isMe(value:Boolean):void 
		{
			_isMe = value;
		}
	}

}
















