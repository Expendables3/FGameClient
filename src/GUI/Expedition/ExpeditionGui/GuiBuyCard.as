package GUI.Expedition.ExpeditionGui 
{
	import Data.ConfigJSON;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import GUI.BlackMarket.GUIChooseNum;
	import GUI.component.Image;
	import GUI.GuiChooseNumAbstract;
	import Logic.Ultility;
	
	/**
	 * GUI mua ngư lệnh
	 * @author HiepNM2
	 */
	public class GuiBuyCard extends GuiChooseNumAbstract 
	{
		private var tfPrice:TextField;
		private var icZingXu:Image;
		private var costPerCard:int;
		public function GuiBuyCard(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GuiBuyCard";
		}
		
		override protected function onAddOther():void 
		{
			icZingXu = AddImage("", "IcZingXu", 300, 143);
			tfPrice = AddLabel("0", 225, 133, 0x000000, 0);
			var fm:TextFormat = new TextFormat("Arial", 18);
			tfPrice.defaultTextFormat = fm;
			//costPerCard = ConfigJSON.getInstance().getItemInfo("Param")["Expedition"]["PriceCard"];
			costPerCard = 1;
		}
		
		override protected function onSetNum():void 
		{
			var price:int = num * costPerCard;
			var textPrice:String = Ultility.StandardNumber(price);
			tfPrice.text = textPrice;
			icZingXu.img.x = tfPrice.x + tfPrice.width + 4;
		}
		
	}

}