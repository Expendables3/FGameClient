package GUI.GUIGemRefine.unused 
{
	import Data.ConfigJSON;
	import Logic.GameLogic;
	/**
	 * ...
	 * @author ...
	 */
	public class Pearl
	{
		public var isRefining:int = -1; // -1 chưa luyên, 0 đang luyện, 1 luyện xong rùi
		public var timeLife:int = 0;	// thời gian sống
		public var timeRefining:Number = 0; // thời gian luyện lên level tiếp theo 
		public var element:int = 0;	// loại hệ
		public var level:int = -1; // cấp
		public var timeStartRefine:Number = 0;		// thời gian bắt đầu luyện
		public var number:int = 0;	// số lượng ngọc, thạch cùng các thông tin
		public var moneyQuickUpgrade:int;
		public var moneyRecover:int = 0;
		public var zmoneyRecover:int = 0;
		public var numGem:int;
		public var zmoneyQuickUpgrade:int;
		public var agencyPoint:Number;		// tác dụng của ngọc 
		
		
		public function Pearl()
		{

		}
		
		/**
		 * load dữ liệu lúc load game
		 * @param	list	
		 */
		public function InitPearl(obj:Object):void 
		{
			if (obj)
			{
				if ("Element" in obj)
				{
					element = obj["Element"];
					level = obj["Level"];
					timeLife = obj["Day"];
				}
				// set các thuộc tính từ config Json
				SetInfoFromConfig();
			}	
		}
		
		public function asignPearl(p:Pearl):void 
		{
			level = p.level;
			element = p.element;
			timeLife = p.timeLife;
			number = 1;
			moneyQuickUpgrade=p.moneyQuickUpgrade;
			moneyRecover = p.moneyRecover;
			zmoneyRecover = p.zmoneyRecover;
			numGem = p.numGem;
			timeRefining = p.timeRefining;
			zmoneyQuickUpgrade = p.zmoneyQuickUpgrade;
			agencyPoint = p.agencyPoint;	
		}
		
		public function copy(p:Pearl):void 
		{
			level = p.level;
			element = p.element;
			timeLife = p.timeLife;
			moneyQuickUpgrade=p.moneyQuickUpgrade;
			moneyRecover = p.moneyRecover;
			zmoneyRecover = p.zmoneyRecover;
			numGem = p.numGem;
			timeRefining = p.timeRefining;
			zmoneyQuickUpgrade = p.zmoneyQuickUpgrade;
			agencyPoint = p.agencyPoint;	
			number = p.number;
			isRefining = p.isRefining;
			timeStartRefine = p.timeStartRefine;
		}
		
		/**
		 * các thuộc tính lấy từ Json
		 */
		public function SetInfoFromConfig():void 
		{
			
			var obj:Object = ConfigJSON.getInstance().GetItemList("Gem");
			var o:Object;
			if (obj)
			{
				if (level in obj)
				{
					o = obj[level];
					if (element in o )
					{
						agencyPoint = o[element];
						if ( "MoneyQuickUpgrade" in o ||"ZMoneyQuickUpgrade" in o)
						{
							moneyQuickUpgrade = o["MoneyQuickUpgrade"];
							zmoneyQuickUpgrade = o["ZMoneyQuickUpgrade"];	
						}

						if (level == 0)
						{
							if ("MoneyRecover" in o)
							{
								moneyRecover = o["MoneyRecover"];
							}
						}
						else
						{
							if ("ZMoneyRecover" in o)
							{
								zmoneyRecover=o["ZMoneyRecover"];
							}
							
						}
						
						numGem = o["NumGem"];
						timeRefining = o["TimeUpgrade"];
					}
				}
			}
		}
		/**
		 * Luyện ngọc
		 */
		public function RefinePearl():void 
		{
			isRefining = 0;
			timeStartRefine = GameLogic.getInstance().CurServerTime;
		}
		
		public function UpdateLevelPearl():Pearl
		{
			var p:Pearl = new Pearl();
			p.element = this.element;
			p.level = this.level + 1;
			return p;
		}
	}
}