package Event.EventNoel.NoelGui.ItemGui 
{
	import Event.EventNoel.NoelLogic.EventNoelMgr;
	import flash.ui.Mouse;
	import GUI.GuiMgr;
	import GUI.GUIReceiveMultiGiftAbstract;
	import GUI.ItemGift.AbstractItemGift;
	import GUI.ItemGift.ItemNormalGift;
	import GUI.ItemGift.ItemSpecialGift;
	import Logic.GameLogic;
	import Logic.LogicGift.AbstractGift;
	import Logic.LogicGift.GiftNormal;
	import Logic.LogicGift.GiftSpecial;
	
	/**
	 * Gui nhan qua sau khi qua bai
	 * @author HiepNM2
	 */
	public class GuiFinishRound extends GUIReceiveMultiGiftAbstract 
	{
		public var roundId:int;
		public var inHide:Boolean;
		public function GuiFinishRound(parent:Object, imgName:String, x:int=0, y:int=0, isLinkAge:Boolean=true, imgAlign:String=ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ThemeName = "GuiFinishRound_Theme";
			xReceive = 220; 
			yReceive = 420;
			xNext = 520;
			xPrev = 30;
			yNextPrev = 310;
			xListBox = 87;
			yListBox = 235;
			dCol = 30;
			dRow = 5;
		}
		override public function addTip():void 
		{
			RemoveButton("idBtnClose");
			inHide = false;
			Mouse.show();
			GameLogic.getInstance().MouseTransform("");
			AddImage("", "GuiFinishRound_TipRound" + roundId, 290, 194);
		}
		override public function initListGift():void 
		{
			for (var i:int = 0; i < EventNoelMgr.getInstance().getNumGiftInStore(); i++)
			{
				var gift:AbstractGift = EventNoelMgr.getInstance().getGiftInStore(i);
				addGift(gift);
			}
		}
		override public function addGift(gift:AbstractGift):void 
		{
			var itemGift:AbstractItemGift = AbstractItemGift.createItemGift(gift.ItemType, this.img, "GuiFinishRound_ImgSlot");
			itemGift.initData(gift);
			itemGift.drawGift();
			ListGift.addItem("", itemGift, this);
		}
		override public function OnHideGUI():void 
		{
			GameLogic.getInstance().MouseTransform("EventNoel_ImgMouseTarget", 1, 0, 0, 0);
			Mouse.hide();
			inHide = true;
		}
		override public function processGetGift():void 
		{
			if (GuiMgr.getInstance().GuiStore.IsVisible)
			{
				GuiMgr.getInstance().GuiStore.Hide();
			}
			var length:int = ListGift.length;
			for (var i:int = 0; i < length; i++)
			{
				var itemGift:AbstractItemGift = ListGift.getItemByIndex(i) as AbstractItemGift;
				if (itemGift.ClassName == "ItemNormalGift")
				{
					var itemGiftNormal:ItemNormalGift = itemGift as ItemNormalGift;
					var gift:GiftNormal = itemGiftNormal.Gift;
					
					switch(gift.ItemType) 
					{
						case "Money":
							GameLogic.getInstance().user.UpdateUserMoney(gift.Num);
						break;
						case "ZMoney":
							GameLogic.getInstance().user.UpdateUserZMoney(gift.Num);
						break;
						case "Exp":
							GameLogic.getInstance().user.SetUserExp(GameLogic.getInstance().user.GetExp() + gift.Num);
						break;
						case "PowerTinh":
						case "Iron":
						case "Jade":
						case "SoulRock":
						case "SixColorTinh":
							GameLogic.getInstance().user.updateIngradient(gift.ItemType, gift.Num, gift.ItemId);
						break;
						case "Diamond":
							var curDiamond:int = GameLogic.getInstance().user.getDiamond();
							GameLogic.getInstance().user.setDiamond(curDiamond + gift.Num);
						break;
						case "Medal":
							GameLogic.getInstance().numMedalHalloween += gift.Num;
							break;
					}
				}
			}
		}
	}

}











































