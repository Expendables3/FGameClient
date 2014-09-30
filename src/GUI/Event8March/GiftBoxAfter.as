package GUI.Event8March 
{
	import Data.ConfigJSON;
	import Data.ResMgr;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import Logic.BaseObject;
	import Logic.GameLogic;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GiftBoxAfter extends BaseObject 
	{
		// const
		private static const _x:int = 905;			//tọa độ đối với guimain
		private static const _y:int = 535;
		
		// logic variable
		private var _openBoxNum:int = -1;
		private var _isBest:Boolean = false;
		public var BtnLogicArr:Array = [0, 0, 0];
		private var _cfgGift:Array = [];
		
		// gui variable
		public var guiAward:GUIAwardAfterEvent = new GUIAwardAfterEvent(null, "");
		
		public function get CfgGift():Array
		{
			return _cfgGift;
		}

		public function get IsBest():Boolean
		{
			return _isBest;
		}
		public function get Type():int
		{
			if (_openBoxNum < 20)
			{
				return 0;
			}
			else if (_openBoxNum >= 20 && _openBoxNum < 50)
			{
				return 20;
			}
			else if (_openBoxNum >= 50 && _openBoxNum < 100)
			{
				return 50;
			}
			else
			{
				return 100;
			}
		}
		public function get Step():int
		{
			if (_openBoxNum < 20)
			{
				return 0;
			}
			else if (_openBoxNum >= 20 && _openBoxNum < 50)
			{
				return 1;
			}
			else if (_openBoxNum >= 50 && _openBoxNum < 100)
			{
				return 2;
			}
			else
			{
				return 3;
			}
		}
		public function convertToId(type:int):int
		{
			if (type == 20) return 0;
			if (type == 50) return 1;
			if (type == 100) return 2;
			return -1;
		}
		public function get OpenBoxNum():int
		{
			return _openBoxNum;
		}
		public function set OpenBoxNum(value:int):void
		{
			_openBoxNum = value;
		}
		
		
		public function GiftBoxAfter(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP, toBitmap:Boolean = false) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign, toBitmap);
			ClassName = "GiftBoxAfter";
		}
		
		
		override public function OnMouseClick(event:MouseEvent):void 
		{
			var isMe:Boolean = !GameLogic.getInstance().user.IsViewer();
			if (isMe)
			{
				guiAward.Show(Constant.GUI_MIN_LAYER, 5);
			}
		}
		override public function SetInfo(data:Object):void 
		{
			if(data["OpenBoxNum"])
				OpenBoxNum = data["OpenBoxNum"];
			else
				OpenBoxNum = 0;
			var uId:Number = GameLogic.getInstance().user.Id;
			if (data["TopUser"])
			{
				_isBest = (uId == (Number)(data["TopUser"]));
			}
			else
			{
				_isBest = false;
			}
			var config:Object = ConfigJSON.getInstance().getItemInfo("ChangePointGetGift");
			initCfgGift(config);
			//lấy cả giá trị để gán cho BtnLogicArr hoặc dựa vào server trả về tính bằng được BtnLogicArr
			initLogicArr(data);
			//BtnLogicArr = [1, 0, 2];
			drawGiftBox();
		}
		private function initCfgGift(cfg:Object):void
		{
			var obj:Object = new Object();
			obj = cfg["20"];
			_cfgGift.push(obj);
			obj = new Object();
			obj = cfg["50"];
			_cfgGift.push(obj);
			obj = new Object();
			obj = cfg["100"];
			_cfgGift.push(obj);
		}
		private function initLogicArr(data:Object):void
		{
			var i:int, str:String, j:int;
			if (data["Bonus"])
			{
				if (_isBest)
				{
					if (convertToId(Type) == 0)
					{
						BtnLogicArr = [2, 0, 0];
					}
					else if (convertToId(Type) == 1)
					{
						BtnLogicArr = [2, 2, 0];
					}
					else if (convertToId(Type) == 2)
					{
						BtnLogicArr = [2, 2, 2];
					}
					else
					{
						BtnLogicArr = [0, 0, 0];
					}
				}
				else
				{
					//BtnLogicArr = [1, 1, 1];
					for (i = 1; i <= 3; i++)
					{
						if (Step >= i)
						{
							BtnLogicArr[i - 1]++;
						}
					}
				}
				for (str in data["Bonus"])
				{
					j = (int)(str);
					i = convertToId(j);
					BtnLogicArr[i] -= data["Bonus"][str];					
				}
			}
			else
			{//khoi tao theo data["OpenBoxNum"]
				if (_isBest)
				{
					if (convertToId(Type) == 0)
					{
						BtnLogicArr = [2, 0, 0];
					}
					else if (convertToId(Type) == 1)
					{
						BtnLogicArr = [2, 2, 0];
					}
					else if (convertToId(Type) == 2)
					{
						BtnLogicArr = [2, 2, 2];
					}
					else
					{
						BtnLogicArr = [0, 0, 0];
					}
					
				}
				else
				{
					for (i = 1; i <= 3; i++)
					{
						if (Step >= i)
						{
							BtnLogicArr[i - 1]++;
						}
					}
				}
				
			}
			//BtnLogicArr = [1, 1, 1];
		}
		private function drawGiftBox():void
		{
			LoadRes("Event8March_GiftBoxAfter");
			SetPos(_x, _y);
			guiAward.ParentObject = this;
			var hasHelper:Boolean = checkHelper();
			if (hasHelper)
			{
				addHelper();
			}
		}
		private function addHelper():void
		{
			var isMe:Boolean = !GameLogic.getInstance().user.IsViewer();
			if (isMe)
			{
				var sp:Sprite = ResMgr.getInstance().GetRes("IcHelper") as Sprite;
				sp.name = "HelperGift";
				this.img.addChild(sp);
				sp.x = 30;
				sp.y = 5;
			}
			
		}
		private function checkHelper():Boolean
		{
			var hasHelper:Boolean = false;
			for (var i:int = 0; i < BtnLogicArr.length; i++)
			{
				hasHelper = hasHelper || BtnLogicArr[i];
			}
			return hasHelper;
		}
		/**
		 * lúc này đang có helper, xét xem có xóa helper đi ko
		 */
		public function updateHelper():void
		{
			var hasHelper:Boolean = checkHelper();
			if (!hasHelper)
			{
				this.img.removeChild(this.img.getChildByName("HelperGift"));
			}
		}
	}

}



























