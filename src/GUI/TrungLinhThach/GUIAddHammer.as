package GUI.TrungLinhThach 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.component.Image;
	import GUI.GuiChooseNumAbstract;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author ThanhNT2
	 */
	public class GUIAddHammer extends GuiChooseNumAbstract 
	{
		public var priceType:String;
		private var icMoney:Image;
		private var tfPrice:TextField;
		public var costPerPack:int;
		public function GUIAddHammer(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
		}
		override protected function onAddOther():void 
		{
			switch(priceType)
			{
				case "ZMoney":
					icMoney = AddImage("", "IcZingXu", 300, 143);
					break;
				case "Money":
					icMoney = AddImage("", "IcGold", 300, 143);
					break;
				case "Diamond":
					icMoney = AddImage("", "IcDiamond", 300, 143);
					break;
			}
			tfPrice = AddLabel("", 290, 160, 0x000000, 0);
			var fm:TextFormat = new TextFormat("Arial", 18);
			tfPrice.defaultTextFormat = fm;
		}
		override protected function onSetNum():void 
		{
			var price:int = num * costPerPack;
			var textPrice:String = Ultility.StandardNumber(price);
			tfPrice.text = textPrice;
			icMoney.img.x = tfPrice.x + tfPrice.width + 4;
			icMoney.img.y = tfPrice.y;
		}
	}

}

















