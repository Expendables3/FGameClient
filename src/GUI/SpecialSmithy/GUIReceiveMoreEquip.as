package GUI.SpecialSmithy 
{
	import Data.Localization;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import GUI.component.Button;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.component.Image;
	import GUI.component.ListBox;
	import GUI.component.TooltipFormat;
	import GUI.FishWar.FishEquipment;
	import GUI.FishWar.GUIEquipmentInfo;
	import GUI.GUIFeedWall;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.Ultility;
	
	/**
	 * ...
	 * @author Linhdna
	 */
	public class GUIReceiveMoreEquip extends BaseGUI 
	{
		public const BTN_RECEIVE:String = "BtnReceive";
		public const BTN_NEXT:String = "BtnNext";
		public const BTN_BACK:String = "BtnBack";
		
		private var btnNext:Button;
		private var btnBack:Button;
		private var gBox:ListBox;
		private var giftList:Array;
		public function GUIReceiveMoreEquip(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIReceiveMoreEquip";
		}
		
		override public function InitGUI():void
		{
			SetPos(90, 80);
			LoadRes("GUIReceiveMoreEquip");
			AddButton(BTN_RECEIVE, "BtnReceive", 210, 385, this);
			btnNext = AddButton(BTN_NEXT, "BtnNextSmithy", 470, 255, this);
			btnBack = AddButton(BTN_BACK, "BtnBackSmithy", 85, 255, this);
			gBox = AddListBox(ListBox.LIST_X, 2, 4);
			gBox.setPos(120, 180);
			addGift(giftList);
			btnBack.SetVisible(false);
			btnNext.SetVisible(false);
			if (giftList.length > 8)
			{
				btnNext.SetVisible(true);
				btnBack.SetVisible(true);
				btnBack.SetDisable();
				btnNext.SetEnable();
			}
		}
		
		private function addGift(gList:Array):void 
		{
			gBox.removeAllItem();
			equipArr = new Object();
			var item:Image;
			for (var i:int = 0; i < gList.length; i++)
			{
				if (gList[i] as Array) return;
				var container:Container = new Container(img, "CtnEquipment", 0, 0);
				var e:FishEquipment = new FishEquipment();
				e.SetInfo(gList[i]);
				equipArr[i] = e;
				container.AddContainer("", FishEquipment.GetBackgroundName(gList[i].Color), 0, 0);
				
				var s:String = gList[i]["Type"] + gList[i]["Rank"];
				item = container.AddImage("", s + "_Shop", 43, 45);
				item.SetScaleXY(0.7);
				var idObj:String = "Special_" + i;
				gBox.addItem(idObj, container, this);
			}
		}
		
		public override function OnButtonOut(event:MouseEvent, buttonID:String):void
		{
			if (buttonID.split("_")[0] == "Special")
			{
				if (GuiMgr.getInstance().GuiEquipmentInfo.IsVisible)
				{
					GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				}
			}
		}
		
		private var equipArr:Object;
		public override function OnButtonMove(event:MouseEvent, buttonID:String):void
		{
			var arr:Array = buttonID.split("_");
			if (arr[0] == "Special")
			{
				GuiMgr.getInstance().GuiEquipmentInfo.Hide();
				GuiMgr.getInstance().GuiEquipmentInfo.InitAll(event.stageX, event.stageY, equipArr[arr[1]], GUIEquipmentInfo.INFO_TYPE_SPECIFIC, null, 0);
			}
		}
		public function showGift(gList:Array):void
		{
			giftList = gList;
			super.Show(Constant.GUI_MIN_LAYER, 3);	
		}
		
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_NEXT:
					gBox.showNextPage();
					checkEnabelBtnNextBack();
					break;
				case BTN_BACK:
					gBox.showPrePage();
					checkEnabelBtnNextBack();
					break;
				case BTN_RECEIVE:
					GuiMgr.getInstance().GuiFeedWall.ShowFeed(GUIFeedWall.FEED_TYPE_SPECIAL_SMITHY_GIFT);
					Hide();
					break;
			}
		}
		
		private function checkEnabelBtnNextBack():void
		{
			btnNext.SetEnable();
			btnBack.SetEnable();
			if(gBox.curPage >= gBox.getNumPage()-1)
			{
				btnNext.SetDisable();
			}
			else if(gBox.curPage <= 0)
			{				
				btnBack.SetDisable();
			}			
		}
	}

}