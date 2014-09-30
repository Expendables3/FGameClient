package Event.EventIceCream 
{
	import adobe.utils.CustomActions;
	import Data.ConfigJSON;
	import Event.EventIceCream.NetworkPacket.SendIceCreamUnlockSlot;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import GUI.component.BaseGUI;
	import GUI.component.Container;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import Logic.LayerMgr;
	import particleSys.myFish.IceCreamEmit;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GUIUnlockSlotIceCream extends BaseGUI 
	{
		public const BTN_THOAT:String = "BtnThoat";
		public const BTN_BUY:String = "BtnBuy";
		public var zMoneyNeed:int;
		public var slotId:int;
		public function GUIUnlockSlotIceCream(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			this.ClassName = "GUIUnlockSlotIceCream";
		}
		public function initGUI(ZMoneyNeed:int, SlotId:int):void 
		{
			zMoneyNeed = ZMoneyNeed;
			slotId = SlotId;
			Show(Constant.GUI_MIN_LAYER, 3);
			if (GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit)
			{
				GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit.destroy();
				GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit = null;
			}
		}
		override public function InitGUI():void 
		{
			this.setImgInfo = function():void
			{
				SetPos(180, 120);
				AddButton(BTN_THOAT, "BtnThoat", 417, 20, this);
				OpenRoomOut();
			}
			LoadRes("EventIceCream_ImgBgGuiUnlockSlotIceCream");
		}
		override public function EndingRoomOut():void 
		{
			super.EndingRoomOut();
			AddButton(BTN_BUY, "EventIceCream_BtnUnlockSlotIceCream", 203, 195, this);
			var txtFormat:TextFormat = new TextFormat("Arial", 15, 0x264904, true);
			AddLabel(zMoneyNeed.toString(), 231, 194).setTextFormat(txtFormat);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			switch (buttonID) 
			{
				case BTN_THOAT:
					Hide();
				break;
				case BTN_BUY:
					// Xử lý trừ G của user
					GameLogic.getInstance().user.UpdateUserZMoney( -zMoneyNeed);
					// Xử lý về mặt logic của hiển thị
					GuiMgr.getInstance().GuiMainEventIceCream.numSlotOpened ++;
					// Xử lý về mặt hiển thị
					var str:String = GuiMgr.getInstance().GuiMainEventIceCream.idCurProcess;
					var ctn1:Container = GuiMgr.getInstance().GuiMainEventIceCream.GetContainer(str);
					ctn1.GetImage(GuiMgr.getInstance().GuiMainEventIceCream.IMG_LOCK).img.visible = false;
					Hide();
					GuiMgr.getInstance().GuiMainEventIceCream.DataIceCream[slotId.toString()] = new Array();
					var cmd:SendIceCreamUnlockSlot = new SendIceCreamUnlockSlot(slotId);
					GuiMgr.getInstance().GuiMainEventIceCream.arrCtnSlotIcream.push(ctn1);
					ctn1.img.buttonMode = true;
					Exchange.GetInstance().Send(cmd);
				break;
			}
		}
		override public function OnHideGUI():void 
		{
			if (GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit == null)
			{
				GuiMgr.getInstance().GuiMainEventIceCream.iceCreamEmit = new IceCreamEmit(LayerMgr.getInstance().GetLayer(Constant.TopLayer));
			}
			GuiMgr.getInstance().GuiMainEventIceCream.idCurProcess = "";
		}
	}

}