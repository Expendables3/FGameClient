package Event.EventHalloween.HalloweenGui.ItemGui 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import GUI.component.Image;
	import GUI.GuiChooseNumAbstract;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GuiBuyMultiRock extends GuiChooseNumAbstract 
	{
		public var priceType:String;
		private var icMoney:Image;
		private var tfPrice:TextField;
		public var costPerPack:Number;
		public var inHide:Boolean;
		public function GuiBuyMultiRock(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiBuyMultiRock";
		}
		override protected function onAddOther():void 
		{
			inHide = false;
			Mouse.show();
			GameLogic.getInstance().MouseTransform("");
			
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
			tfPrice = AddLabel("", 225, 133, 0x000000, 0);
			var fm:TextFormat = new TextFormat("Arial", 18);
			tfPrice.defaultTextFormat = fm;
		}
		override protected function onSetNum():void 
		{
			var price:Number = num * costPerPack;
			var textPrice:String = Ultility.StandardNumber(price);
			tfPrice.text = textPrice;
			icMoney.img.x = tfPrice.x + tfPrice.width + 4;
		}
		override public function OnHideGUI():void 
		{
			if (GuiMgr.getInstance().guiHuntFish.IsVisible)
			{
				GameLogic.getInstance().MouseTransform("EventNoel_ImgMouseTarget", 1, 0, 0, 0);
				Mouse.hide();
				inHide = true;
			}
		}
		override protected function onAddNum():void 
		{
			if (maxNum > 0)
			{
				num = 1;
			}
		}
		
	}

}

















