package Event.EventNoel.NoelGui.ItemGui 
{
	import Event.EventNoel.NoelLogic.ItemInfo.CandyInfo;
	import Event.Factory.FactoryGui.ItemGui.ItemCollectionEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Image;
	import Logic.LogicGift.AbstractGift;
	import Logic.Ultility;
	
	/**
	 * Item kẹo trong Noel. Dùng để đổi lấy đạn
	 * @author HiepNM2
	 */
	public class ItemCandy extends ItemCollectionEvent 
	{
		private var imgGift:Image;
		private var imgNumBg:Image;
		private var tfNum:TextField;
		public var maxNum:int;
		
		public var realSize:Object = {
										"1": { "w":67, "h":60 },
										"2": { "w":48, "h":64 },
										"3": { "w":46, "h":42 },
										"4": { "w":44, "h":66 },
										"5": { "w":52, "h":60 }
		};
		public function ItemCandy(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "ItemCandy";
		}
		override public function initData(gift:AbstractGift, slotName:String = "", widthSlot:int = 0, heightSlot:int = 0, hasSlot:Boolean = false):void
		{
			_gift = gift;
		}
		
		override public function drawGift():void
		{
			//var gift:CandyInfo = _gift as CandyInfo;
			var xGift:int = _gift.ItemId == 5 ? 15 : 7;
			var ptr:ItemCandy = this;
			var loadComp:Function = function():void
			{
				this.img.width = realSize[_gift.ItemId]["w"];
				this.img.height = realSize[_gift.ItemId]["h"];
				this.img.x = (ptr.img.width - this.img.width) / 2;
				this.img.y = ptr.img.height - 15 - this.img.height;
			}
			imgGift = AddImage("", _gift.getImageName(), 0, 0 , true, ALIGN_LEFT_TOP, false, loadComp);//ảnh kẹo
			tfNum = AddLabel("", -5, 75, 0xffffff, 1, 0x000000);
			var fm:TextFormat = new TextFormat("Arial", 14);
			if (_gift["Num"] < maxNum)
			{
				fm.color = 0xff0000;
			}
			else
			{
				fm.color = 0xffffff;
			}
			tfNum.defaultTextFormat = fm;
			tfNum.text = Ultility.StandardNumber(_gift["Num"]) + " / " + Ultility.StandardNumber(maxNum);
			
			/*tooltip*/
			this.setTooltipText(_gift.getTooltipText());
		}
		
		override public function refreshTextNumEvent():Boolean 
		{
			var fm:TextFormat = new TextFormat("Arial", 14);
			var isEnable:Boolean = false;
			if (_gift["Num"] < maxNum)
			{
				fm.color = 0xff0000;
			}
			else
			{
				isEnable = true;
				fm.color = 0xffffff;
			}
			tfNum.defaultTextFormat = fm;
			tfNum.text = Ultility.StandardNumber(_gift["Num"]) + " / " + Ultility.StandardNumber(maxNum);
			return isEnable;
		}
	}

}