package GUI.Event8March 
{
	import Effect.EffectMgr;
	import flash.events.MouseEvent;
	import GUI.component.BaseGUI;
	import GUI.GuiMgr;
	import Logic.GameLogic;
	import NetworkPacket.PacketSend.SendChangePointGetGift;
	
	/**
	 * ...
	 * @author HiepNM2
	 */
	public class GUIChooseElementEvent extends BaseGUI 
	{
		// const
		private const ID_BTN_CLOSE:String = "idBtnClose";
		private const CMD_CHOOSE_ELEMENT:String = "cmdChooseElement";
		private const KIM:int = 1;
		private const MOC:int = 2;
		private const THO:int = 3;
		private const THUY:int = 4;
		private const HOA:int = 5;
		private var isClick:Boolean = false;
		// logic
		private var _chooseId:int;
		private var _parent:GUIAwardAfterEvent;
		public function set ParentObject(val:GUIAwardAfterEvent):void
		{
			_parent = val;
		}
		// getter and setter
		public function get ChooseId():int
		{
			return _chooseId;
		}
		public function set ChooseId(value:int):void
		{
			_chooseId = value;
		}
		public function GUIChooseElementEvent(parent:Object, imgName:String, x:int = 0, y:int = 0, isLinkAge:Boolean = true, imgAlign:String = ALIGN_LEFT_TOP) 
		{
			super(parent, imgName, x, y, isLinkAge, imgAlign);
			ClassName = "GUIChooseElementEvent";
		}
		override public function InitGUI():void 
		{
			isClick = false;
			LoadRes("Event8March_GUIChooseElement");
			SetPos(Constant.STAGE_WIDTH / 2 - img.width / 2, Constant.STAGE_HEIGHT / 2 - img.height / 2);
			addBgr();
		}
		private function addBgr():void
		{
			AddButton(ID_BTN_CLOSE, "BtnThoat", 618, -22);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + KIM, "Event8March_BtnChooseSteel", 10, 18);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + MOC, "Event8March_BtnChooseWood", 130, 18);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + THO, "Event8March_BtnChooseEarth", 490, 18);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + THUY, "Event8March_BtnChooseWater", 250, 18);
			AddButton(CMD_CHOOSE_ELEMENT + "_" + HOA, "Event8March_BtnChooseFire", 370, 18);
		}
		override public function OnButtonClick(event:MouseEvent, buttonID:String):void 
		{
			var data:Array = buttonID.split("_");
			var command:String = data[0];
			var element:int;
			switch(command)
			{
				case ID_BTN_CLOSE:
					Hide();
				break;
				case CMD_CHOOSE_ELEMENT:
					element = (int)(data[1]);
					if (!isClick)
					{
						receiveGift(element);
						isClick = !isClick;
					}
				break;
			}
		}
		
		private var TypeIdHoaMuaXuan:int;
		private var NameGuiUse:String = "";
		public function UseForChangeGiftHoaMuaXuan(id:int):void 
		{
			NameGuiUse = "GUIGameEventMidle8";
			TypeIdHoaMuaXuan = id;
		}
		
		private function receiveGift(element:int):void
		{
			if (NameGuiUse == "GUIGameEventMidle8")
			{
				GuiMgr.getInstance().GuiChangeGiftEvent.Update(TypeIdHoaMuaXuan, element);
				Hide();
			}
			else
			{
				/*gửi lên server*/
				var type:int = convertIdToType(_chooseId);
				
				var pk:SendChangePointGetGift = new SendChangePointGetGift(type, element);
				Exchange.GetInstance().Send(pk);
				/*Effect nhận thành công*/
				var index:int = _chooseId - 1;
				//var cfg:Object = ConfigJSON.getInstance().getItemInfo("ChangePointGetGift");
				var giftArr:Array = _parent.ParentObject.CfgGift;
				var gift:Object = giftArr[index];
				//var gift:Object = cfg[type.toString()];
				var typeSpecialGift:String = gift["1"]["ItemType"];
				var rankSpecialGift:String = _parent.ParentObject.CfgGift[index]["1"]["Rank"];
				var imgNameSpecialGift:String = typeSpecialGift + 10 * element + rankSpecialGift + "_Shop";
				var typeNormalGift:String = _parent.ParentObject.CfgGift[index]["2"]["ItemType"];
				var idNormalGift:String = _parent.ParentObject.CfgGift[index]["2"]["ItemId"];
				var imgNameNormalGift:String = typeNormalGift + idNormalGift;
				EffectMgr.setEffBounceDown("Nhận thành công", imgNameSpecialGift, 330, 280, onCompFallSpecialGift);
				function onCompFallSpecialGift():void
				{
					GameLogic.getInstance().user.GenerateNextID();
					EffectMgr.setEffBounceDown("Nhận thành công", imgNameNormalGift, 330, 280, onCompFallNormalGift);
					function onCompFallNormalGift():void
					{
						_parent.processReceiveGift(_chooseId);
						Hide();
					}
				}
			}
		}
		private function convertIdToType(id:int):int
		{
			if (id == 1) return 20;
			if (id == 2) return 50;
			if (id == 3) return 100;
			return -1;
		}
		
	}
}





















